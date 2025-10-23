import { Body, Controller, Delete, Get, HttpException, NotFoundException, Param, ParseIntPipe, Patch, Post, Query } from '@nestjs/common';
import { SitesService } from './sites.service';
import { CreateSiteDto } from './dtos/create-site.dto';
import { UpdateSiteDto } from './dtos/update-site.dto';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';

@Controller('sites')
export class SitesController {
  constructor(private readonly sitesService: SitesService) {}

  @Post()
  async createSite(@Body() body: CreateSiteDto) {
    const createdSite = await this.sitesService.createSite(body);
    if (!createdSite)
      throw new HttpException('Something went wrong while creating the site', 500);

    return createdSite;
  }

  @Get() 
  async getSites(
    @Query('page') page?: string, 
    @Query('siteDomain') siteDomain?: string, 
  ) {
    if (siteDomain) {
      const site = await this.sitesService.findSite({ siteDomain });
      if (!site)
        throw new NotFoundException('The site was not found');

      const { createdAt, ...reamingData } = site;
      return {
        ...reamingData,
        createdAt: createdAt.toLocaleString('es-MX'), 
      };
    }
    
    if (page !== undefined && typeof parseInt(page) !== 'number')
      throw new HttpException('Missing page number', 400);

    const data = await this.sitesService.getSites(parseInt(page as string));
    if (!data.sites.length)
      throw new HttpException('There are no sites', 400);

    return data;
  }

  @Get(':siteId')
  async getSiteById(@Param('siteId', new ParseIntPipe) siteId: number) {
    const site = await this.sitesService.findSite({ id: siteId });
    if (!site)
      throw new NotFoundException('The site was not found');

    const {createdAt, ...remainingSiteData} = site;

    return { 
      ...remainingSiteData, 
      createdAt: createdAt.toLocaleString('es-MX'), 
    };
  }

  @Patch(':siteId')
  async updateSite(
    @Param('siteId', new ParseIntPipe) siteId: number, 
    @Body() body: UpdateSiteDto
  ) {
    const updatedSite = await this.sitesService.updateSiteById(siteId, body);
    if (!updatedSite)
      throw new NotFoundException('The site was not found');

    return updatedSite;
  }

  @Delete(':siteId')
  async deleteSite(@Param('siteId', new ParseIntPipe) siteId: number) {
    const deletedSite = await this.sitesService.deleteSiteById(siteId);
    if (deletedSite)
      throw new NotFoundException('The site was not found');

    return deletedSite;
  }  

  @Get(':siteId/reputation')
  async getSiteReputationById(@Param('siteId', new ParseIntPipe) siteId: number) {
    const site = await this.sitesService.findSite({ id: siteId });
    if (!site)
      throw new NotFoundException('The site was not found');

    const { reports } = site;
    const accumulatedSeverity = reports.reduce((accum, report) => {
      return accum + report.severity;
    }, 0);
    const reputation = accumulatedSeverity / reports.length;

    if (!Number.isNaN(reputation) && site.siteReputation !== reputation)
      return this.sitesService.updateSiteById(site.id, { siteReputation: reputation });
  
    return site.siteReputation;
  }
}
