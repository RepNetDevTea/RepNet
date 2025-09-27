import { Module } from '@nestjs/common';
import { ImpactsService } from './impacts.service';
import { ImpactsController } from './impacts.controller';
import { AuthModule } from 'src/auth/auth.module';
import { PrismaModule } from 'src/prisma/prisma.module';

@Module({
  providers: [ImpactsService],
  controllers: [ImpactsController],
  imports: [PrismaModule, AuthModule], 
  exports: [ImpactsService], 
})
export class ImpactsModule {}
