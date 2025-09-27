import { Controller, HttpCode, HttpStatus, Post, Req, UseGuards } from '@nestjs/common';
import { LocalAuthGuard } from './guards/local-auth.guard';
import type { Request } from 'express';
import { classToPlain } from 'class-transformer';
import { AuthService } from './auth.service';
import { AccessJwtAuthGuard } from './guards/access-jwt-auth.guard';
import { RefreshJwtAuthGuard } from './guards/refresh-jwt-auth.guard';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @HttpCode(HttpStatus.OK)
  @Post('login') 
  @UseGuards(LocalAuthGuard)
  async logInUser(@Req() req: Request) {
    const user = classToPlain(req.user);
    const { id, email, username, role } = user;
    const payload = { id, username, email, role };
    const { accessToken, refreshToken } = await this.authService.generateTokens(id, payload);
    await this.authService.updateHashedRefreshToken(id, refreshToken);
    
    return { user, accessToken, refreshToken };
  }

  @Post('refresh')
  @UseGuards(RefreshJwtAuthGuard)
  async refreshToken(@Req() req: Request) {
    const user = classToPlain(req.user);
    const { id, email, username, role } = user;
    const payload = { id, email, username, role };
    return await this.authService.refreshTokens(id, payload);
  }

  @Post('logout')
  @UseGuards(AccessJwtAuthGuard)
  async logOutUser(@Req() req: Request) {
    const user = classToPlain(req.user);
    const { id } = user;
    return await this.authService.logOut(id);
  }
}
