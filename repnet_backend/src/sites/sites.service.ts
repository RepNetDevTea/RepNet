import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class SitesService {
  constructor(private prisma: PrismaService) {}

  async findSite(filter: Prisma.SiteWhereUniqueInput) {
    return await this.prisma.site.findUnique({ where: filter });
  }

  async createSite(data: Prisma.SiteCreateInput) {
    return await this.prisma.site.create({ data });
  }
  
  async getAllSites() {
    return await this.prisma.site.findMany();
  }
  
  async updateSite(siteId: number, data: Prisma.SiteUpdateInput) {
    const site = await this.findSite({ id: siteId });
    if (!site)
      return null;

    const updatedAt = new Date().toISOString()
    return await this.prisma.site.update({ 
      where: { id: site.id }, 
      data: {
        ...data, 
        updatedAt, 
      }
    });
  }
  
  async deleteSite(siteId: number) {
    const site = await this.findSite({ id: siteId });
    if (!site)
      return null;

    return await this.prisma.site.delete({ where: { id: site.id } });
  }  
}
