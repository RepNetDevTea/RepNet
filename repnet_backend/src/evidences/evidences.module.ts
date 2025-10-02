import { Module } from '@nestjs/common';
import { EvidencesService } from './evidences.service';
import { PrismaModule } from 'src/prisma/prisma.module';
import { AuthModule } from 'src/auth/auth.module';
import { EvidencesController } from './evidences.controller';
import { AwsModule } from 'src/aws/aws.module';

@Module({
  providers: [EvidencesService],
  controllers: [EvidencesController], 
  imports: [
    PrismaModule, 
    AuthModule, 
    AwsModule, 
  ], 
  exports: [EvidencesService], 
})
export class EvidencesModule {}
