import { Module } from '@nestjs/common';
import { ReportsService } from './reports.service';
import { ReportsController } from './reports.controller';
import { PrismaModule } from 'src/prisma/prisma.module';
import { AuthModule } from 'src/auth/auth.module';
import { SitesModule } from 'src/sites/sites.module';

@Module({
  providers: [ReportsService],
  controllers: [ReportsController],
  imports: [
    PrismaModule, 
    AuthModule, 
    SitesModule
  ], 
  exports: [ReportsService], 
})
export class ReportsModule {}
