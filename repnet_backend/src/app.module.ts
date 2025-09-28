import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { TagsModule } from './tags/tags.module';
import { ImpactsModule } from './impacts/impacts.module';
import { ReportsModule } from './reports/reports.module';
import { SitesModule } from './sites/sites.module';
import { EvidencesModule } from './evidences/evidences.module';
import { AwsModule } from './aws/aws.module';

@Module({
  imports: [PrismaModule, AuthModule, UsersModule, TagsModule, ImpactsModule, ReportsModule, SitesModule, EvidencesModule, AwsModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
