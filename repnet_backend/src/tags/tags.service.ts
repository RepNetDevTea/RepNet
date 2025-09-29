import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class TagsService {
  constructor(private prisma: PrismaService) {}

  async findTagByFilter(filter: Prisma.TagWhereUniqueInput) {
    return await this.prisma.tag.findUnique({ 
      where: filter, 
      include: { reports: true } 
    });
  }

  async createTag(data: Prisma.TagCreateInput) {
    return await this.prisma.tag.create({ data });
  }
  
  async getAllTags() {
    return await this.prisma.tag.findMany();
  }
  
  async updateTagById(tagId: number, data: Prisma.TagUpdateInput) {
    const tag = await this.findTagByFilter({ id: tagId });
    if (!tag)
      return null;

    const updatedAt = new Date().toISOString()
    return await this.prisma.tag.update({ 
      where: { id: tag.id }, 
      data: {
        ...data, 
        updatedAt, 
      }
    });
  }
  
  async deleteTagById(tagId: number) {
    const tag = await this.findTagByFilter({ id: tagId });
    if (!tag)
      return null;

    return await this.prisma.tag.delete({ where: { id: tag.id } });
  }
}
