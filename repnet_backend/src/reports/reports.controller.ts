import { Body, Controller, Post, Req, UseGuards } from '@nestjs/common';
import { ReportsService } from './reports.service';
import { AccessJwtAuthGuard } from 'src/auth/guards/access-jwt-auth.guard';
import type { Request } from 'express';
import { CreateReportDto } from './dtos/create-report.dto';
import { classToPlain } from 'class-transformer';
import { parse } from 'tldts';
import { SitesService } from 'src/sites/sites.service';

@Controller('reports')
export class ReportsController {
  constructor(
    private reportsService: ReportsService, 
    private sitesService: SitesService, 
  ) {}
  
  @Post('create')
  @UseGuards(AccessJwtAuthGuard)
  async createReport(@Req() req: Request, @Body() body: CreateReportDto) {
    const { tags, impacts, ...data} = body;
    const { id } = classToPlain(req.user);

    const parsedUrl = parse(body.reportUrl.toLowerCase());
    const domain = parsedUrl.domain!;

    const existingSite = await this.sitesService.findSite({ siteDomain: domain });
    const site = existingSite ?? await this.sitesService.createSite({ siteDomain: domain });

    const report = {
      ...data,
      userId: id,
      siteId: site.id, 
    }
  
    return report;

    // Tenemos que crear otro modulo? para poder subir las evidencias a S3 y poder relacionar las evidencias con su reporte correspondiente.

    // Tenemos dos arreglos de referencias de tags e impactos para consultar los impactos    
    // y tags para calcular la severidad base del reporte (tal vez se haga aquí o en alguna función de repors service).
  }
}
