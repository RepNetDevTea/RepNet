import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { AuthModule } from 'src/auth/auth.module';
import { PrismaModule } from 'src/prisma/prisma.module';
import { AwsModule } from 'src/aws/aws.module';

@Module({
  providers: [UsersService],
  controllers: [UsersController], 
  imports: [PrismaModule, AuthModule, AwsModule], 
  exports: [UsersService], 
})
export class UsersModule {}
