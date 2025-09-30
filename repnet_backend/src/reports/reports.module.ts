import { Module } from '@nestjs/common';
import { ReportsService } from './reports.service';
import { ReportsController } from './reports.controller';
import { PrismaModule } from 'src/prisma/prisma.module';
import { AuthModule } from 'src/auth/auth.module';
import { SitesModule } from 'src/sites/sites.module';
import { EvidencesModule } from 'src/evidences/evidences.module';
import { AwsModule } from 'src/aws/aws.module';
import { VotesModule } from 'src/votes/votes.module';

@Module({
  providers: [ReportsService],
  controllers: [ReportsController],
  imports: [
    PrismaModule,  
    AuthModule, 
    AwsModule, 
    EvidencesModule, 
    SitesModule, 
    VotesModule, 
  ], 
  exports: [ReportsService], 
})
export class ReportsModule {}
