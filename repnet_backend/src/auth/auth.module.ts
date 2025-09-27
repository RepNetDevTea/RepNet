import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { PrismaModule } from 'src/prisma/prisma.module';
import { LocalStrategy } from './strategies/local-strategy';
import { JwtModule } from '@nestjs/jwt';
import accessJwtConfig from './config/access-jwt.config';
import { ConfigModule } from '@nestjs/config';
import { PassportModule } from '@nestjs/passport';
import refreshJwtConfig from './config/refresh-jwt.config';
import { AccessJwtAuthStrategy } from './strategies/access-jwt.strategy';
import { RefreshJwtAuthStrategy } from './strategies/refresh-jwt.strategy';

@Module({
  providers: [
    AuthService, 
    LocalStrategy, 
    AccessJwtAuthStrategy, 
    RefreshJwtAuthStrategy, 
  ], 
  controllers: [AuthController], 
  imports: [
    PrismaModule, 
    ConfigModule.forFeature(refreshJwtConfig), 
    ConfigModule.forFeature(accessJwtConfig), 
    JwtModule.registerAsync(accessJwtConfig.asProvider()), 
    PassportModule, 
  ], 
  exports: [
    JwtModule, 
    AuthService, 
  ]
})
export class AuthModule {}
