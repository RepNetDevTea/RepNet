import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class ImpactsService {
  constructor(private readonly prisma: PrismaService) {}

  async findImpact(filter: Prisma.ImpactWhereUniqueInput) {
    return await this.prisma.impact.findUnique({ 
      where: filter,
      include: { reports: true }, 
    });
  }

  async createImpact(data: Prisma.ImpactCreateInput) {
    return await this.prisma.impact.create({ data });
  }
  
  async getAllImpacts() {
    return await this.prisma.impact.findMany({ include: { reports: true }});
  }
  
  async updateImpact(impactId: number, data: Prisma.ImpactUpdateInput) {
    const impact = await this.findImpact({ id: impactId });
    if (!impact)
      return null;

    const updatedAt = new Date().toISOString()
    return await this.prisma.impact.update({ 
      where: { id: impact.id }, 
      data: {
        ...data, 
        updatedAt, 
      }
    });
  }
  
  async deleteImpact(impactId: number) {
    const impact = await this.findImpact({ id: impactId });
    if (!impact)
      return null;

    return await this.prisma.impact.delete({ where: { id: impact.id } });
  }
}
