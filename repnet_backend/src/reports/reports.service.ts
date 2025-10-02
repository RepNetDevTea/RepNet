import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { S3Service } from 'src/aws/s3.service';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class ReportsService {
  constructor(
    private prisma: PrismaService, 
  ) {}

  async createReport(data: Prisma.ReportCreateInput) {
    return await this.prisma.report.create({ data });
  }

  async getAllReports() {
    return await this.prisma.report.findMany({
      include: {
        votes: true,
        evidences: true,
        tags: true,
        impacts: true
      }
    });
  }

  async findReportById(reportId: number) {
    return await this.prisma.report.findUnique({ 
      where: { id: reportId },
      include: {
        votes: true, 
        evidences: { select: { id: true, evidenceType: true,  evidenceKey: true , evidenceFileUrl: true, evidenceFileUri: true } }, 
        tags: { select: { tag: { select: { tagName: true, tagScore: true, tagDescription: true } } } }, 
        impacts: { select: { impact: { select: { impactName: true, impactScore: true, impactDescription: true } } } }, 
      } 
    });
  }

  async deleteReportById(reportId: number) {
    const report = await this.findReportById(reportId);
    if (!report)
      return null;

    return await this.prisma.report.delete({ where: { id: report.id } });  
  }

  async updateReportById(reportId: number, data: Prisma.ReportUpdateInput) {
    const report = await this.findReportById(reportId);
    if (!report)
      return null;

    const updatedAt = new Date().toISOString();
    return await this.prisma.report.update({ 
      where: { id: report.id }, 
      data: { ...data, updatedAt }, 
    });  
  }

  async findEvidencesById(reportId: number) {
    const report = await this.findReportById(reportId)
    if (!report)
      return null;

    return report.evidences;
  }
}
