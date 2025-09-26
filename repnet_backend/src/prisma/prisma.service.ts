import { Injectable } from '@nestjs/common';
import { OnModuleInit } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit {
  onModuleInit() {
    this.$connect()
    .then(() => console.log('Connected to DB'))
    .catch((error) => console.log('Could not connect to DB', error));
  }
}
