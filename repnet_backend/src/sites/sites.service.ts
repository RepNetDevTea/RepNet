import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { report } from 'process';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class SitesService {
  constructor(private readonly prisma: PrismaService) {}

  async findSite(filter: Prisma.SiteWhereUniqueInput) {
    return await this.prisma.site.findUnique({ 
      where: filter, 
      include: { 
        reports: { 
          include: { 
            impacts: { 
              select: { impact: { select: { impactName: true } } } 
            }, 
            tags: { 
              select: { tag: { select: { tagName: true } } } 
            }
          }, 
        }, 
      }
    });
  }

  async createSite(data: Prisma.SiteCreateInput) {
    return await this.prisma.site.create({ data });
  }
  
  async getSites(page: number) {
    const sitesPerRequest = 10;
    const skip = (page - 1) * sitesPerRequest;

    const [sites, totalNumberOfSites ] =  await Promise.all([
      await this.prisma.site.findMany({
        include: { reports: true }, 
        skip, 
        take: sitesPerRequest, 
      }), 
      await this.prisma.site.count(), 
    ]);     

    const totalNumberOfPages = Math.ceil(totalNumberOfSites / sitesPerRequest);

    return {
      sites, 
      metaData: {
        currentPage: page, 
        totalNumberOfPages,
        totalNumberOfSites, 
      }
    };
  }
  
  async updateSiteById(siteId: number, data: Prisma.SiteUpdateInput) {
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
  
  async deleteSiteById(siteId: number) {
    const site = await this.findSite({ id: siteId });
    if (!site)
      return null;

    return await this.prisma.site.delete({ where: { id: site.id } });
  }  
}
