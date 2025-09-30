import { Module } from '@nestjs/common';
import { VotesService } from './votes.service';
import { VotesController } from './votes.controller';
import { PrismaModule } from 'src/prisma/prisma.module';
import { AuthModule } from 'src/auth/auth.module';

@Module({
  controllers: [VotesController],
  providers: [VotesService],
  imports: [PrismaModule, AuthModule], 
  exports: [VotesService], 
})
export class VotesModule {}
