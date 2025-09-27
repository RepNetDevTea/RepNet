import { Module } from '@nestjs/common';
import { TagsService } from './tags.service';
import { TagsController } from './tags.controller';
import { AuthModule } from 'src/auth/auth.module';
import { PrismaModule } from 'src/prisma/prisma.module';

@Module({
  providers: [TagsService], 
  controllers: [TagsController], 
  imports: [PrismaModule, AuthModule], 
  exports: [TagsService], 
})
export class TagsModule {}
