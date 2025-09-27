import { Body, Controller, Post } from '@nestjs/common';
import { CreateUserDto } from './dtos/create-user.dto';
import { UsersService } from './users.service';

@Controller('users')
export class UsersController {
  constructor(
    private userService: UsersService, 
  ) {}

  @Post('signup')
  async createUser(@Body() body: CreateUserDto) {
    const { newUser, accessToken, refreshToken } = await this.userService.createUser(body);
    return { newUser, accessToken, refreshToken };
  }
  
}
