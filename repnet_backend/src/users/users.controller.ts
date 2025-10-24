import { Body, Controller, Delete, ForbiddenException, Get, HttpException, NotFoundException, Param, ParseIntPipe, Patch, Post, Req, UseGuards } from '@nestjs/common';
import { CreateUserDto } from './dtos/create-user.dto';
import { UsersService } from './users.service';
import { AccessJwtAuthGuard } from 'src/auth/guards/access-jwt-auth.guard';
import type { Request } from 'express';
import { instanceToPlain } from 'class-transformer';
import { UpdateUserDto } from './dtos/update-user.dto';
import { UpdateUserAdminDto } from './dtos/update-user-admin.dto';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';


@ApiTags('usuarios')
@Controller('users')
export class UsersController { 
  constructor(
    private readonly userService: UsersService, 
  ) {}

  @Post()
  @ApiOperation({ summary: 'Crea un nuevo usuario' })
  async createUser(@Body() body: CreateUserDto) {
    const { newUser, accessToken, refreshToken } = await this.userService.createUser(body);
    if (!newUser)
      throw new HttpException('Something went wrong while creating the user', 500);

    return { newUser, accessToken, refreshToken };
  }

  @Get()
  @ApiOperation({ summary: 'llama todos los usuarios' })
  async getUsers() {
    const users = await this.userService.getUsers(null);
    if (!users)
      throw new HttpException('There are no users', 400);

    return users;
  }

  @Get('me')
  @UseGuards(AccessJwtAuthGuard)
  @ApiOperation({ summary: 'regresa la informacion del usuario' })
  async getUser(@Req() req: Request) {
    const { id, userStatus } = instanceToPlain(req.user);
    const user = await this.userService.findUserById(id);
    if (!user)
      throw new NotFoundException('The user was not found');
    else if (userStatus === "suspended" || userStatus === "banned")
      throw new ForbiddenException('You have been either suspended or banned');

    return user;
  }  

  @Patch('me')
  @UseGuards(AccessJwtAuthGuard)
  @ApiOperation({ summary: 'Actualiza la informacion del usuario' })
  async updateUser(@Req() req: Request, @Body() body: UpdateUserDto) {
    const { id } = instanceToPlain(req.user);
    const updatedUser = await this.userService.updateUserById(id, body);
    if (!updatedUser)
      throw new HttpException('The user was not found or no data was provided', 400);

    return updatedUser;
  }

  @Delete('me')
  @UseGuards(AccessJwtAuthGuard)
  @ApiOperation({ summary: 'El usuario se borra a si mismo' })
  async deleteUser(@Req() req: Request) {
    const { id } = instanceToPlain(req.user);
    const deletedUser = await this.userService.deleteUserById(id);
    if (!deletedUser)
      throw new NotFoundException('The user was not found');

    return deletedUser;
  }

  @Get(':userId')
  @ApiOperation({ summary: 'Se busca un usuario por ID' })
  async getUserById(@Param('userId', new ParseIntPipe) userId: number) {
    const user = await this.userService.findUserById(userId);
    if (!user)
      throw new NotFoundException('The user was not found');
    
    return user;
  }

  @Patch(':userId')
  @ApiOperation({ summary: 'Se modifica usuario por ID' })
  async updateUserById(@Param('userId', new ParseIntPipe) userId: number, @Body() body: UpdateUserAdminDto) {
    const updatedUser = await this.userService.updateUserById(userId, body);
    if(!updatedUser)
      throw new NotFoundException('The user was not found');

    return updatedUser;
  }
}
