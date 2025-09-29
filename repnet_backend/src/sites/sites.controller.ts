import { Body, Controller, Delete, Get, HttpException, NotFoundException, Param, ParseIntPipe, Patch, Post } from '@nestjs/common';
import { SitesService } from './sites.service';
import { CreateSiteDto } from './dtos/create-site.dto';
import { UpdateSiteDto } from './dtos/update-site.dto';

@Controller('sites')
export class SitesController {
  constructor(private sitesService: SitesService) {}

  @Post('')
  async createSite(@Body() body: CreateSiteDto) {
    const createdSite = await this.sitesService.createSite(body);
    if (!createdSite)
      throw new HttpException('Something went wrong while creating the site', 500);

    return createdSite;
  }

  @Get('')
  async getAllSites() {
    const sites = await this.sitesService.getAllSites();
    if(sites)
      throw new HttpException('There are no sites', 400);

    return sites;
  }

  @Get(':siteId')
  async getSiteById(@Param('sitId', new ParseIntPipe) siteId: number) {
    const site = await this.sitesService.findSite({ id: siteId });
    if (!site)
      throw new NotFoundException('The site was not found');

    return site;
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
    return reputation;
  }
}
