import { Controller, Post, Req, UseGuards } from '@nestjs/common';
import { LocalAuthGuard } from './guards/local-auth.guard';
import type { Request } from 'express';
import { classToPlain } from 'class-transformer';
import { AuthService } from './auth.service';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('login') 
  @UseGuards(LocalAuthGuard)
  async logInUser(@Req() req: Request) {
    const user = classToPlain(req.user);
    const { id, email, role } = user;
    const payload = { id, email, role };
    const { accessToken, refreshToken } = await this.authService.generateTokens(id, payload);
    return { user, accessToken, refreshToken };
  }

  
}
