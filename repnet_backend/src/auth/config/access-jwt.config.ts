import { JwtModuleOptions } from '@nestjs/jwt';
import { registerAs } from '@nestjs/config';

export default registerAs(
  'access-jwt',
  (): JwtModuleOptions => ({
    secret: process.env.ACCESS_JWT_SECRET,
    signOptions: {
      expiresIn: process.env.ACCESS_JWT_EXPIRES_IN, 
    }
  })
); 