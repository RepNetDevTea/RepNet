import { Module } from '@nestjs/common';
import { SitesService } from './sites.service';
import { SitesController } from './sites.controller';
import { PrismaModule } from 'src/prisma/prisma.module';
import { AuthModule } from 'src/auth/auth.module';

@Module({
  providers: [SitesService],
  controllers: [SitesController],
  imports: [PrismaModule, AuthModule], 
  exports: [SitesService], 
})
export class SitesModule {}
