import { 
  Body, Controller, Delete, FileTypeValidator, Get, HttpException, Inject, MaxFileSizeValidator, NotFoundException, Param, 
  ParseFilePipe, ParseIntPipe, Patch, Post, Req, UploadedFile, UseGuards, 
  UseInterceptors 
} from '@nestjs/common';
import { ReportsService } from './reports.service';
import { AccessJwtAuthGuard } from 'src/auth/guards/access-jwt-auth.guard';
import type { Request } from 'express';
import { CreateReportDto } from './dtos/create-report.dto';
import { instanceToPlain } from 'class-transformer';
import { parse } from 'tldts';
import { SitesService } from 'src/sites/sites.service';
import { EvidencesService } from 'src/evidences/evidences.service';
import s3Config from 'src/aws/config/s3.config';
import type { ConfigType } from '@nestjs/config';
import { FileInterceptor } from '@nestjs/platform-express';
import { S3Service } from 'src/aws/s3.service';
import { UpdateReportDto } from './dtos/update-report.dto';
import { VotesService } from 'src/votes/votes.service';
import computeSeverityMetric from './utils/compute-severity-metric';
import promptBuilder from './utils/promptBuilder';
import bedrockConfig from 'src/aws/config/bedrock.config';
import { BedrockService } from 'src/aws/bedrock.service';

@Controller('reports')
export class ReportsController {
  constructor(
    private reportsService: ReportsService, 
    private evidencesService: EvidencesService, 
    private sitesService: SitesService,
    private votesService: VotesService, 
    @Inject(s3Config.KEY) private s3Configuration: ConfigType<typeof s3Config>,
    private s3Service: S3Service, 
    private bedrockService: BedrockService, 
  ) {}
  
  @Post()
  @UseGuards(AccessJwtAuthGuard)
  async createReport(@Req() req: Request, @Body() body: CreateReportDto) {
    const { tags, impacts, ...reportData} = body;
    const userId = instanceToPlain(req.user).id;

    const parsedUrl = parse(body.reportUrl.toLowerCase());
    const domain = parsedUrl.domain!;

    const existingSite = await this.sitesService.findSite({ siteDomain: domain });
    const site = existingSite ?? await this.sitesService.createSite({ siteDomain: domain });

    const data = {
      ...reportData,
      user: { connect: { id: userId } },
      site: { connect: { id: site.id } }, 
    }
  
    const report = await this.reportsService.createReport(data);
    if (!report)
      throw new HttpException('Something went wrong while creating the report', 500);

    return report;
  }

  @Post(':reportId/evidences')
  @UseInterceptors(FileInterceptor('file'))
  async createEvidence(
    @Param('reportId', new ParseIntPipe) reportId: number, 
    @UploadedFile(
      new ParseFilePipe({ 
        validators: [
          new MaxFileSizeValidator({ maxSize: 25 * 1024 * 1024 }), 
          new FileTypeValidator({ 
            fileType: /^(image\/(png|jpeg|jpg))$/
          })
        ] 
      })
    ) file: Express.Multer.File
  ) {
    const { buffer, mimetype, originalname } = file;
    await this.s3Service.upload(originalname, buffer);

    const bucketName = 'repnet-evidences-bucket';
    const region = this.s3Configuration.region;
    const key = originalname;
    const evidenceFileUrl = `https://${bucketName}.s3.${region}.amazonaws.com/${encodeURIComponent(key)}`;

    const data = {
      evidenceType: mimetype, 
      evidenceFileUrl, 
      evidenceKey: key, 
    };

    const evidence = await this.evidencesService.createEvidence(reportId, data);
    if (!evidence)
      throw new HttpException('Something went wrong while creating the evidence', 500);

    return evidence;
  }

  @Patch(':reportId/severityScore')
  async computeSeverityScore(@Param('reportId', new ParseIntPipe) reportId: number) {
    const report = await this.reportsService.findReportById(reportId);
    if (!report)
      throw new NotFoundException('The report was not found');

    const {reportUrl, reportDescription, tags, impacts, evidences } = report;

    const tagWeight = 0.2;
    const tagsScore = computeSeverityMetric('tag', tags);
    const realTagScore = tagWeight * tagsScore;

    const impactWeight = 0.35;
    const impactsScore = computeSeverityMetric('impact', impacts);
    const realImpactScore = impactWeight * impactsScore;

    const context = {
      reportUrl, 
      tags,
      reportDescription, 
      impacts, 
      tagScoreData: { tagWeight, tagsScore, realTagScore, },
      impactScoreData: { impactWeight, impactsScore, realImpactScore, }, 
      evidenceUrls: evidences.map(( evidence ) => evidence.evidenceFileUrl), 
    }

    const prompt = promptBuilder(context);
    const bedrockOutput = this.bedrockService.scoreEvidence(prompt); 

    return bedrockOutput;
  }

  @Get()
  async getAllReports() {
    const reports = await this.reportsService.getAllReports();
    if (!reports)
      throw new NotFoundException('There are no reports');

    return reports;
  }

  @Get(':reportId')
  async getReport(@Param('reportId', new ParseIntPipe) reportId: number) {
    const report = await this.reportsService.findReportById(reportId);
    if (!report)
      throw new NotFoundException('The report was not found');

    return report;
  }

  @Patch(':reportId')
  async updateReport(@Param('reportId', new ParseIntPipe) reportId: number, @Body() body: UpdateReportDto) {
    const { tags, impacts, ...attrsToUpdate } = body;
    const updatedReport = await this.reportsService.updateReportById(reportId, attrsToUpdate);
    if (!updatedReport)
      throw new NotFoundException('The report was not found');

    return updatedReport;
  }

  @Delete(':reportId')
  async deleteReport(@Param('reportId', new ParseIntPipe) reportId: number) {
    const deletedReport = await this.reportsService.deleteReportById(reportId);
    if (!deletedReport)
      throw new NotFoundException('The report was not found');

    return deletedReport;
  }
  
  @Post(':reportId/toggleVote')
  @UseGuards(AccessJwtAuthGuard)
  async toggleDownvote(
    @Req() req: Request, 
    @Param('reportId', new ParseIntPipe) reportId: number, 
    @Body() { voteType }: any
  ) {
    const userId = instanceToPlain(req.user).id;

    if (voteType !== 'downvote' && voteType !== 'upvote') {
      const deletedDownvote = await this.votesService.deleteVote(userId, reportId);
      if (!deletedDownvote)
        throw new NotFoundException('The vote was not found');

      return deletedDownvote;
    }

    const data = {
      voteType, 
      user: { connect: { id: userId } }, 
      report: { connect: { id: reportId } }, 
    }

    const vote = await this.votesService.createVote(data);
    if (!vote)
      throw new HttpException('Something went wrong while storing upvote', 500);

    return vote;
  }
}
