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
    private readonly prisma: PrismaService, 
    private readonly authService: AuthService, 
  ) {}
  
  async hashPassword(password: string) {
    const salt = randomBytes(8).toString('hex');
    const hashedPassword = await scrypt(password, salt, 32) as Buffer;
    const hashToStore = salt + '.' + hashedPassword.toString('hex');
    return hashToStore;
  }

  async findUserById(userId: number) {
    return await this.prisma.user.findUnique({ 
      where: { id: userId }, 
      include: { votes: true, reports: true }
    });
  } 
  
  async getUsers(filter: object | null) {
    if (!filter)
      return await this.prisma.user.findMany();
    
    return await this.prisma.user.findMany({ where: filter });
  }

  async createUser(data: Prisma.UserCreateInput) {
    data.hashedPassword = await this.hashPassword(data.hashedPassword);

    const newUser = await this.prisma.user.create({ data });   
    
    const { id, username, email, userRole, userStatus } = newUser;
    const payload = { id, username, email, userRole, userStatus };
    const { accessToken, refreshToken } = await this.authService.generateTokens(id, payload);
    const hashedRefreshToken = await argon2.hash(refreshToken);

    await this.prisma.user.update({ 
      where: { id }, 
      data: { hashedRefreshToken } 
    });

    return { newUser, accessToken, refreshToken };
  }

  async updateUserById(userId: number, data: Prisma.UserUpdateInput) {
    const user = await this.findUserById(userId);
    if (!user || !data)
      return null;

    if ('hashedPassword' in data)
      data.hashedPassword = await this.hashPassword(data.hashedPassword as string);

    const updatedAt = new Date().toISOString();
    return await this.prisma.user.update({ 
      where: { id: user.id }, 
      data: {
        ...data,
        updatedAt, 
      } 
    });
  }

  async deleteUserById(userId: number) {
    const user = await this.findUserById(userId);
    if (!user)
      return null;

    return await this.prisma.user.delete({ where: { id: user.id } });
  }
}
