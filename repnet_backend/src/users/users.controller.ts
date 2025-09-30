import { Body, Controller, Delete, ForbiddenException, Get, HttpException, NotFoundException, Param, ParseIntPipe, Patch, Post, Req, UseGuards } from '@nestjs/common';
import { CreateUserDto } from './dtos/create-user.dto';
import { UsersService } from './users.service';
import { AccessJwtAuthGuard } from 'src/auth/guards/access-jwt-auth.guard';
import type { Request } from 'express';
import { classToPlain } from 'class-transformer';
import { UpdateUserDto } from './dtos/update-user.dto';
import { UpdateUserAdminDto } from './dtos/update-user-admin.dto';

@Controller('users')
export class UsersController {
  constructor(
    private userService: UsersService, 
  ) {}

  @Post()
  async createUser(@Body() body: CreateUserDto) {
    const { newUser, accessToken, refreshToken } = await this.userService.createUser(body);
    if (!newUser)
      throw new HttpException('Something went wrong while creating the user', 500);

    return { newUser, accessToken, refreshToken };
  }

  @Get()
  async getUsers() {
    const users = await this.userService.getUsers(null);
    if (!users)
      throw new HttpException('There are no users', 400);

    return users;
  }

  @Get(':userId')
  async getUserById(@Param('userId', new ParseIntPipe) userId: number) {
    const user = await this.userService.findUserById(userId);
    if (!user)
      throw new NotFoundException('The user was not found');
    
    return user;
  }

  @Get('me')
  @UseGuards(AccessJwtAuthGuard)
  async getUser(@Req() req: Request) {
    const { id, userStatus } = classToPlain(req.user);
    const user = await this.userService.findUserById(id);
    if (!user)
      throw new NotFoundException('The user was not found');
    else if (userStatus === "suspended" || userStatus === "banned")
      throw new ForbiddenException('You have been either suspended or banned');

    return user;
  }
  
  @Patch('me')
  @UseGuards(AccessJwtAuthGuard)
  async updateUser(@Req() req: Request, @Body() body: UpdateUserDto) {
    const { id } = classToPlain(req.user);
    const updatedUser = await this.userService.updateUserById(id, body);
    if (!updatedUser)
      throw new NotFoundException('The user was not found');

    return updatedUser;
  }

  @Patch(':userId')
  async updateUserById(@Param('userId', new ParseIntPipe) userId: number, @Body() body: UpdateUserAdminDto) {
    const updatedUser = await this.userService.updateUserById(userId, body);
    if(!updatedUser)
      throw new NotFoundException('The user was not found');

    return updatedUser;
  }

  @Delete('me')
  @UseGuards(AccessJwtAuthGuard)
  async deleteUser(@Req() req: Request) {
    const { id } = classToPlain(req.user);
    const deletedUser = await this.userService.deleteUserById(id);
    if (!deletedUser)
      throw new NotFoundException('The user was not found');

    return deletedUser;
  }
}
