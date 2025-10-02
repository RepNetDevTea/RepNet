import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { S3Service } from 'src/aws/s3.service';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class EvidencesService {
  constructor(
    private prisma: PrismaService, 
    private s3Service: S3Service, 
  ) {}

  async createEvidence(reportId: number, data: Prisma.EvidenceCreateWithoutReportInput) {
    return await this.prisma.evidence.create({ data: { ...data, reportId } });
  }

  async getEvidences() {
    return await this.prisma.evidence.findMany();
  }

  async findEvidenceById(evidenceId: number) {
    return await this.prisma.evidence.findUnique({ where: { id: evidenceId } });
  }

  async updateEvidenceById(evidenceId: number, data: Prisma.EvidenceUpdateInput | null ) {
    const evidence = await this.findEvidenceById(evidenceId);
    if (!evidence)
      return null;
    
    const updatedAt = new Date().toISOString();
    return this.prisma.evidence.update({
      where: { id: evidenceId },
      data: { 
        ...data,
        updatedAt, 
      }
    });
  }

  async deleteEvidenceById(evidenceId: number) {
    const evidence = await this.findEvidenceById(evidenceId);
    if (!evidence)
      return null;

    await this.s3Service.delete(evidence.evidenceKey!);

    return await this.prisma.evidence.delete({ where: { id: evidenceId } });
  }
}
