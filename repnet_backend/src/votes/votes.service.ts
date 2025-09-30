import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class VotesService {
  constructor(private prisma: PrismaService) {}

  async findVote(filter: Prisma.VoteFindUniqueArgs) {
    return await this.prisma.vote.findUnique(filter);
  }

  async createVote() {

  }

  async deleteVote() {

  }


}
