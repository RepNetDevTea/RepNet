import { Body, Controller, Delete, Get, Param, ParseIntPipe, Patch, Post } from '@nestjs/common';
import { SitesService } from './sites.service';
import { CreateSiteDto } from './dtos/create-site.dto';
import { UpdateSiteDto } from './dtos/update-site.dto';

@Controller('sites')
export class SitesController {
  constructor(private sitesService: SitesService) {}

  @Post('')
  async createSite(@Body() body: CreateSiteDto) {
    return await this.sitesService.createSite(body);
  }

  @Get('')
  async getAllSites() {
    return await this.sitesService.getAllSites();
  }

  @Patch(':siteId')
  async updateSite(
    @Param('siteId', new ParseIntPipe) siteId: number, 
    @Body() body: UpdateSiteDto
  ) {
    return await this.sitesService.updateSiteById(siteId, body);
  }

  @Delete(':siteId')
  async deleteSite(@Param('siteId', new ParseIntPipe) siteId: number) {
    return await this.sitesService.deleteSiteById(siteId);
  }  
}
