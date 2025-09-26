import { HttpException, Inject, Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { scrypt as _scrypt } from 'crypto';
import { promisify } from 'util';
import { JwtService } from '@nestjs/jwt';
import refreshJwtConfig from './config/refresh-jwt.config';
import type { ConfigType } from '@nestjs/config';

const scrypt = promisify(_scrypt);

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService, 
    private jwtService: JwtService, 
    @Inject(refreshJwtConfig.KEY) private refreshJwtConfiguration: ConfigType<typeof refreshJwtConfig>, 
  ) {}
  
  async generateTokens(userId: number, payload: object) {
    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(payload), 
      this.jwtService.signAsync(payload, this.refreshJwtConfiguration), 
    ]);

    return { userId, accessToken, refreshToken };
  }

  async findByCredentials(email: string, password: string) {
    const user = await this.prisma.user.findUnique({ where: { email } });
    if (!user)
      throw new NotFoundException('Invalid credentials');

    const [salt, storedHash] = user.hashedPassword;
    const hashedPassword = await scrypt(salt, password, 32) as Buffer;

    if (storedHash !== hashedPassword.toString('hex'))
      throw new HttpException('Invalid credentials', 400);

    return user;
  }
}
