import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class EvidencesService {
  constructor(private prisma: PrismaService) {}

  async createEvidence(reportId: number, data: Prisma.EvidenceCreateWithoutReportInput) {
    return await this.prisma.evidence.create({ data: { ...data, reportId } });
  }
}
