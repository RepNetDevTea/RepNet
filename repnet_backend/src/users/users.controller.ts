import { Body, Controller, Delete, Patch, Post, Req, UseGuards } from '@nestjs/common';
import { CreateUserDto } from './dtos/create-user.dto';
import { UsersService } from './users.service';
import { AccessJwtAuthGuard } from 'src/auth/guards/access-jwt-auth.guard';
import type { Request } from 'express';
import { classToPlain } from 'class-transformer';
import { UpdateUserDto } from './dtos/update-user.dto';

@Controller('users')
export class UsersController {
  constructor(
    private userService: UsersService, 
  ) {}

  @Post('')
  async createUser(@Body() body: CreateUserDto) {
    const { newUser, accessToken, refreshToken } = await this.userService.createUser(body);
    return { newUser, accessToken, refreshToken };
  }
  
  @Patch('me')
  @UseGuards(AccessJwtAuthGuard)
  async updateUser(@Req() req: Request, @Body() body: UpdateUserDto) {
    const { id } = classToPlain(req.user);
    return await this.userService.updateUserById(id, body);
  }

  @Delete('me')
  @UseGuards(AccessJwtAuthGuard)
  async deleteUser(@Req() req: Request) {
    const { id } = classToPlain(req.user);
    const deletedUser = await this.userService.deleteUserById(id);
    return deletedUser;
  }
}
