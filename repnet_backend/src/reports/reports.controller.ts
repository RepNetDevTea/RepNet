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

    const base64images = await Promise.all(
      evidences.map(async ({ evidenceKey }) => {
        const bytes = await this.s3Service.retrieve(evidenceKey as string)
        return Buffer.from(bytes).toString('base64');
      })
    );

    const evidenceFiles: object[] = [];

    for (let i = 0; i < evidences.length; ++i) {
      const { evidenceType } = evidences[i];
      evidenceFiles.push({
        type: 'image',
        source: {
          type: 'base64', 
          media_type: `image/${evidenceType}`,
          data: base64images[i], 
        } 
      })
    }

    const context = {
      reportUrl, 
      tags,
      reportDescription, 
      impacts, 
      tagScoreData: { tagWeight, tagsScore, realTagScore, },
      impactScoreData: { impactWeight, impactsScore, realImpactScore, }, 
      evidenceFiles, 
    }

    const prompt = promptBuilder(context);
    const bedrockOutput = this.bedrockService.scoreEvidence(prompt); 

    return bedrockOutput;
  }

  @Post(':reportId/evidences')
  @UseInterceptors(FileInterceptor('file'))
  async createEvidence(
    @Param('reportId', new ParseIntPipe) reportId: number, 
    @UploadedFile(
      new ParseFilePipe({ 
        validators: [
          new MaxFileSizeValidator({ maxSize: 25 * 1024 * 1024 }), 
          new FileTypeValidator({ fileType: /^(image\/(png|jpeg|jpg))$/ })
        ] 
      })
    ) file: Express.Multer.File
  ) {
    const { buffer, mimetype } = file;
    const fileExtension = mimetype.split('/')[1];

    const data = { evidenceType: fileExtension };

    const evidence = await this.evidencesService.createEvidence(reportId, data);
    if (!evidence)
      throw new HttpException('Something went wrong while creating the evidence', 500);

    const evidenceKey = `${reportId}-${evidence.id}-${new Date().toISOString()}.${fileExtension}`;

    await this.s3Service.upload(evidenceKey, buffer);

    const evidenceFileUrl = this.s3Service.createFileUrl(evidenceKey);
    const evidenceFileUri = this.s3Service.createFileUri(evidenceKey); 
    
    return await this.evidencesService.updateEvidenceById(evidence.id, { 
      evidenceFileUrl, 
      evidenceKey, 
      evidenceFileUri, 
    });
  }

  @Get(':reportId/evidences')
  async getEvidencesByReportId(@Param('reportId', new ParseIntPipe) reportId: number) {
    const evidences = await this.reportsService.findEvidencesById(reportId);
    if (evidences === null)
      throw new NotFoundException('The report was not found');
    else if (!evidences.length)
      throw new HttpException('The report has no evidences attached to it', 400);

    return evidences;
  }

  @Patch(':reportId/evidences/:evidenceId')
  @UseInterceptors(FileInterceptor('file'))
  async updateReportEvicenceByEvidenceId(
    @Param('reportId', new ParseIntPipe) reportId: number, 
    @Param('evidenceId', new ParseIntPipe) evidenceId: number, 
    @UploadedFile(
      new ParseFilePipe({ 
        validators: [
          new MaxFileSizeValidator({ maxSize: 25 * 1024 *1024 }), 
          new FileTypeValidator({ fileType: /^(image\/(png|jpeg|jpg))$/ })
        ] 
      })
    ) 
    file: Express.Multer.File
  ) {
    const report = await this.reportsService.findReportById(reportId);
    if (!report)
      throw new NotFoundException('The report was not found');
    
    const evidence = report.evidences.filter(({ id }) => id === evidenceId);
    if (!evidence.length)
      throw new NotFoundException('The evidence was not found');

    const { buffer } = file;
    const { id, evidenceKey } = evidence[0];

    await this.s3Service.upload(evidenceKey!, buffer);
    
    return await this.evidencesService.updateEvidenceById(id, null);
  }

  @Delete(':reportId/evidences/:evidenceId')
  async deleteReportEvidenceByEvidenceId(
    @Param('reportId', new ParseIntPipe) reportId: number, 
    @Param('evidenceId', new ParseIntPipe) evidenceId: number, 
  ) {
    const report = await this.reportsService.findReportById(reportId);
    if (!report)
      throw new NotFoundException('The report was not found');

    const deletedEvidence = await this.evidencesService.deleteEvidenceById(evidenceId);
    if (!deletedEvidence)
      throw new NotFoundException('The evidence was not found');
    
    return deletedEvidence;
  }
}
