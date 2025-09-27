import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class ImpactsService {
  constructor(private prisma: PrismaService) {}

  async findImpactById(impactId: number) {
    return await this.prisma.impact.findUnique({ where: { id: impactId } });
  }

  async createImpact(data: Prisma.ImpactCreateInput) {
    return await this.prisma.impact.create({ data });
  }
  
  async getAllImpacts() {
    return await this.prisma.impact.findMany();
  }
  
  async updateImpact(impactId: number, data: Prisma.ImpactUpdateInput) {
    const impact = await this.findImpactById(impactId);
    if (!impact)
      return null;

    return await this.prisma.impact.update({ where: { id: impact.id }, data });
  }
  
  async deleteImpact(impactId: number) {
    const impact = await this.findImpactById(impactId);
    if (!impact)
      return null;

    return await this.prisma.impact.delete({ where: { id: impact.id } });
  }
}
