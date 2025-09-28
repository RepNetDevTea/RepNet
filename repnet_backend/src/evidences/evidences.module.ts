import { Module } from '@nestjs/common';
import { EvidencesService } from './evidences.service';
import { EvidencesController } from './evidences.controller';
import { PrismaModule } from 'src/prisma/prisma.module';
import { AuthModule } from 'src/auth/auth.module';

@Module({
  providers: [EvidencesService],
  controllers: [EvidencesController], 
  imports: [
    PrismaModule, 
    AuthModule, 
  ], 
  exports: [EvidencesService], 
})
export class EvidencesModule {}
