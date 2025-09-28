import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class ReportsService {
  constructor(private prisma: PrismaService) {}

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

  async getUserReports(userId: number) {
    return await this.prisma.report.findMany({ 
      where: { userId }, 
      include: { 
        votes: true, 
        evidences: true,
        tags: true,
        impacts: true
      } 
    });
  }

}
