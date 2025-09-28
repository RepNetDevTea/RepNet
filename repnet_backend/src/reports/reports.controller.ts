import { 
  Body, Controller, Delete, FileTypeValidator, Get, Inject, MaxFileSizeValidator, NotFoundException, Param, 
  ParseFilePipe, ParseIntPipe, Post, Req, UploadedFile, UseGuards, 
  UseInterceptors 
} from '@nestjs/common';
import { ReportsService } from './reports.service';
import { AccessJwtAuthGuard } from 'src/auth/guards/access-jwt-auth.guard';
import type { Request } from 'express';
import { CreateReportDto } from './dtos/create-report.dto';
import { classToPlain } from 'class-transformer';
import { parse } from 'tldts';
import { SitesService } from 'src/sites/sites.service';
import { EvidencesService } from 'src/evidences/evidences.service';
import s3Config from 'src/aws/config/s3.config';
import type { ConfigType } from '@nestjs/config';
import { FileInterceptor } from '@nestjs/platform-express';
import { S3Service } from 'src/aws/s3.service';
import { UsersService } from 'src/users/users.service';

@Controller('reports')
export class ReportsController {
  constructor(
    private reportsService: ReportsService, 
    private evidencesService: EvidencesService, 
    private sitesService: SitesService,
    private usersService: UsersService, 
    @Inject(s3Config.KEY) private s3Configuration: ConfigType<typeof s3Config>,
    private s3Service: S3Service,  
  ) {}
  
  @Post('')
  @UseGuards(AccessJwtAuthGuard)
  async createReport(@Req() req: Request, @Body() body: CreateReportDto) {
    const { tags, impacts, ...data} = body;
    const userId = classToPlain(req.user).id;

    const parsedUrl = parse(body.reportUrl.toLowerCase());
    const domain = parsedUrl.domain!;

    const existingSite = await this.sitesService.findSite({ siteDomain: domain });
    const site = existingSite ?? await this.sitesService.createSite({ siteDomain: domain });

    const report = {
      ...data,
      user: { connect: { id: userId } },
      site: { connect: { id: site.id } }, 
    }
  
    return await this.reportsService.createReport(report);
    // Tenemos dos arreglos de referencias de tags e impactos para consultar los impactos    
    // y tags para calcular la severidad base del reporte (tal vez se haga aquí o en alguna función de repors service).
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
            fileType: /^(image\/(png|jpeg|jpg)|application\/(pdf|msword|vnd\.openxmlformats-officedocument\.wordprocessingml\.document))$/
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

    const evidence = {
      evidenceType: mimetype, 
      evidenceFileUrl, 
      evidenceKey: key, 
    };

    const report = await this.evidencesService.createEvidence(reportId, evidence);
    return report;
  }

  @Get('')
  async getAllReports() {
    const reports = await this.reportsService.getAllReports();
    if (!reports)
      throw new NotFoundException('Theres no reports to display');

    return reports;
  }

  @Get('/:id')
  async getUserReports(@Param('id', new ParseIntPipe) id: number) {
    const user = await this.usersService.findUserById(id);
    if (!user)
      throw new NotFoundException('No user was found');

    const userReports = await this.reportsService.getUserReports(user.id);
    if (!userReports)
      throw new NotFoundException('User has not created a single report');

    return userReports;
  }

  @Delete('/:id')
  @UseGuards(AccessJwtAuthGuard)
  async deleteUserReports(@Param('id', new ParseIntPipe) id: number) {
    
  }

  
}
