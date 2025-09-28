import { Module } from '@nestjs/common';
import { EvidencesService } from './evidences.service';
import { PrismaModule } from 'src/prisma/prisma.module';
import { AuthModule } from 'src/auth/auth.module';

@Module({
  providers: [EvidencesService],
  controllers: [], 
  imports: [
    PrismaModule, 
    AuthModule, 
  ], 
  exports: [EvidencesService], 
})
export class EvidencesModule {}
