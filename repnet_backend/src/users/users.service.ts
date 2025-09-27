import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';
import { randomBytes, scrypt as _scrypt } from 'crypto';
import { promisify } from 'util';
import { AuthService } from 'src/auth/auth.service';
import * as argon2 from 'argon2';

const scrypt = promisify(_scrypt);

@Injectable()
export class UsersService {
  constructor(
    private prisma: PrismaService, 
    private authService: AuthService, 
  ) {}
  
  async createUser(data: Prisma.UserCreateInput) {
    const password = data.hashedPassword;
    const salt = randomBytes(8).toString('hex');
    const hashedPassword = await scrypt(password, salt, 32) as Buffer;
    data.hashedPassword = salt + '.' + hashedPassword.toString('hex');

    const newUser = await this.prisma.user.create({ data });   
    
    const { id, username, email, userRole } = newUser;
    const payload = { id, username, email, userRole };
    const { accessToken, refreshToken } = await this.authService.generateTokens(id, payload);
    const hashedRefreshToken = await argon2.hash(refreshToken);

    await this.prisma.user.update({ 
      where: { id }, 
      data: { hashedRefreshToken } 
    });

    return { newUser, accessToken, refreshToken };
  }
}
