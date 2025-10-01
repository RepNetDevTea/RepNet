import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class VotesService {
  constructor(private prisma: PrismaService) {}

  async createVote(data: Prisma.VoteCreateInput) {
    return await this.prisma.vote.create({ data });
  }

  async findVoteById(voteId: number) {
    return await this.prisma.vote.findUnique({ where: { id: voteId } });
  }

  async findVote(filter: Prisma.VoteWhereUniqueInput) {
    return await this.prisma.vote.findUnique({ where: filter });
  }

  async findVotes() {
    return await this.prisma.vote.findMany();
  }

  async updateVoteById(reportId: number, data: Prisma.VoteUpdateInput) {
    const report = await this.findVoteById(reportId);
    if (!report)
      return null;

    const updatedAt = new Date().toISOString();
    return await this.prisma.vote.update({ 
      where: { id: report.id }, 
      data: { ...data, updatedAt } 
    });
  }

  async deleteVote(userId: number, reportId: number) {
    const vote = await this.findVote({ userId_reportId: { userId, reportId } });
    if (!vote)
      return null;

    return await this.prisma.vote.delete({ where: { id: vote.id } });
  }

  async deleteVoteById(voteId: number) {
    const vote = await this.findVoteById(voteId);
    if (!vote)
      return null;

    return await this.prisma.vote.delete({ where: { id: vote.id } });
  }
}
