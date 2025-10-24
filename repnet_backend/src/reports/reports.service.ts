import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class ReportsService {
  constructor(
    private readonly prisma: PrismaService, 
  ) {}

  async createReportImpacts(
    reportId: number, 
    impactIds: Prisma.ImpactWhereUniqueInput[]
  ) {
    const reportImpactsRecords = impactIds
    .filter(({ id }) => typeof id === 'number')
    .map(({ id }) => ({
      impactId: id as number, 
      reportId
    }));

    return await this.prisma.reportImpacts.createMany({ 
      data: reportImpactsRecords 
    });
  }

  async deleteReportImpacts(
    reportId: number, 
    impactIds: Prisma.ImpactWhereUniqueInput[]
  ) {
    const reportImpactsRecords = impactIds
    .filter(({ id }) => typeof id === 'number')
    .map(({ id }) => ({
      impactId: id as number, 
      reportId 
    }));

    return await this.prisma.reportImpacts.deleteMany({ 
      where: { 
        OR: reportImpactsRecords 
      } 
    });
  }

  async createReportTags(
    reportId: number, 
    tagIds: Prisma.TagWhereUniqueInput[]
  ) {
    const reportTagsRecords = tagIds
    .filter(({ id }) => typeof id === 'number')
    .map(({ id }) => ({ 
      tagId: id as number, 
      reportId 
    }));

    return await this.prisma.reportTags.createMany({ 
      data: reportTagsRecords
    });
  }

  async deleteReportTags(
    reportId: number, 
    tagIds: Prisma.TagWhereUniqueInput[]
  ) {
    const reportTagsRecords = tagIds
    .filter(({ id }) => typeof id === 'number')
    .map(({ id }) => ({ 
      tagId: id as number,
      reportId
    }));

    return await this.prisma.reportTags.deleteMany({ 
      where: { 
        OR: reportTagsRecords 
      } 
    });
  }  

  async createReport(
    data: Prisma.ReportCreateInput, 
    tags: Prisma.TagWhereUniqueInput[] | undefined, 
    impacts: Prisma.ImpactWhereUniqueInput[] | undefined,  
  ) {
    const report = await this.prisma.report.create({ data });
    const reportId = report.id;

    if (tags !== undefined && tags.length)
      await this.createReportTags(reportId, tags);

    if (impacts !== undefined && impacts.length)
      await this.createReportImpacts(reportId, impacts);

    return report;
  }

  async getReports(page: number) {
    const reportsPerRequest = 10;
    const skip = (page - 1) * reportsPerRequest;

    const [reports, totalNumberOfReports ] =  await Promise.all([
      await this.prisma.report.findMany({
        include: {
          votes: true,
          evidences: true,
          tags: true,
          impacts: true
        }, 
        skip, 
        take: reportsPerRequest, 
      }), 
      await this.prisma.report.count(), 
    ]);     

    const totalNumberOfPages = Math.ceil(totalNumberOfReports / reportsPerRequest);

    return {
      reports, 
      metaData: {
        currentPage: page, 
        totalNumberOfPages,
        totalNumberOfReports, 
      }
    };
  }

  async findReportById(reportId: number) {
    return await this.prisma.report.findUnique({ 
      where: { id: reportId },
      include: {
        votes: true, 
        site: { select: { id: true, siteDomain: true, } }, 
        user: { select: { username: true } }, 
        evidences: { select: { id: true, evidenceType: true,  evidenceKey: true , evidenceFileUrl: true, evidenceFileUri: true } }, 
        tags: { select: { tag: { select: { id: true, tagName: true, tagScore: true, tagDescription: true } } } }, 
        impacts: { select: { impact: { select: { id: true, impactName: true, impactScore: true, impactDescription: true } } } }, 
      } 
    });
  }

  async deleteReportById(reportId: number) {
    const report = await this.findReportById(reportId);
    if (!report)
      return null;

    return await this.prisma.report.delete({ where: { id: report.id } });  
  }

  async updateReportById(
    reportId: number, 
    data: Prisma.ReportUpdateInput, 
    addedTags: Prisma.TagWhereUniqueInput[] | undefined,
    deletedTags: Prisma.TagWhereUniqueInput[] | undefined,
    addedImpacts: Prisma.ImpactWhereUniqueInput[] | undefined,
    deletedImpacts: Prisma.ImpactWhereUniqueInput[] | undefined,
  ) {
    const report = await this.findReportById(reportId);
    if (!report)
      return null;

    if (addedTags !== undefined && addedTags.length)
      await this.createReportTags(report.id, addedTags);

    if (deletedTags !== undefined && deletedTags.length)
      await this.deleteReportTags(report.id, deletedTags);

    if (addedImpacts !== undefined && addedImpacts.length)
      await this.createReportImpacts(report.id, addedImpacts);

    if (deletedImpacts !== undefined && deletedImpacts.length)
      await this.deleteReportImpacts(report.id, deletedImpacts);

    const updatedAt = new Date().toISOString();
    return await this.prisma.report.update({ 
      where: { id: report.id }, 
      data: { ...data, reportStatus: 'pending', updatedAt }, 
    });  
  }

  async updateReportStatusById(reportId: number, data: Prisma.ReportUpdateInput) {
    const report = await this.findReportById(reportId);
    if (!report)
      return null;

    const validStatuses = ['approved', 'rejected'];

    const newReportStatus = data.reportStatus as string;
    if (!validStatuses.includes(newReportStatus))
      return null;

    const storedReportStatus = report.reportStatus;
    if (validStatuses.includes(storedReportStatus))
      return null;

    const updatedAt = new Date().toISOString();
    return await this.prisma.report.update({ 
      where: { id: report.id }, 
      data: { ...data, updatedAt },  
    })
  }

  async findEvidencesById(reportId: number) {
    const report = await this.findReportById(reportId)
    if (!report)
      return null;

    return report.evidences;
  }
}
