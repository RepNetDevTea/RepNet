import { Module } from '@nestjs/common';
import { S3Service } from './s3.service';
import { ConfigModule } from '@nestjs/config';
import s3Config from './config/s3.config';
import { AuthModule } from 'src/auth/auth.module';
import { PrismaModule } from 'src/prisma/prisma.module';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { APP_GUARD } from '@nestjs/core';
import { BedrockService } from './bedrock.service';
import bedrockConfig from './config/bedrock.config';

@Module({
  providers: [
    S3Service,
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard, 
    },
    BedrockService, 
  ], 
  controllers: [], 
  imports: [
    PrismaModule, 
    AuthModule,
    ConfigModule.forFeature(s3Config), 
    ConfigModule.forFeature(bedrockConfig),
    // El ThrottlerModule toma un objeto que configura al ThrottlerModule 
    // donde especificamos el número máximo de solicitudes que queremos permitir
    // (usando limit), dentro de un periodo de tiempo (usando la propiedad ttl)
    ThrottlerModule.forRoot([{
      ttl: 60,
      limit: 2, 
    }]), 
  ],
  exports: [
    S3Service,
    BedrockService,
    ConfigModule.forFeature(bedrockConfig), 
    ConfigModule.forFeature(s3Config), 
  ], 
})
export class AwsModule {}