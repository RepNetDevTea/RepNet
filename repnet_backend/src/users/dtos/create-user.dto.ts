import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsEmail,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsStrongPassword
} from 'class-validator';

export class CreateUserDto {
  @ApiProperty({
    example: 'Juan',
    description: 'Nombre del usuario'
  })
  @IsNotEmpty()
  @IsString()
  name: string;

  @ApiProperty({
    example: 'Pérez',
    description: 'Apellido paterno del usuario'
  })
  @IsNotEmpty()
  @IsString()
  fathersLastName: string;

  @ApiProperty({
    example: 'Gómez',
    description: 'Apellido materno del usuario'
  })
  @IsNotEmpty()
  @IsString()
  mothersLastName: string;

  @ApiProperty({
    example: 'juanperez',
    description: 'Nombre de usuario único'
  })
  @IsNotEmpty()
  @IsString()
  username: string;

  @ApiProperty({
    example: 'juan.perez@example.com',
    description: 'Correo electrónico del usuario'
  })
  @IsNotEmpty()
  @IsEmail()
  email: string;

  @ApiProperty({
    example: 'Str0ngP@ssw0rd!',
    description: 'Contraseña segura del usuario (mínimo 8 caracteres, mayúsculas, minúsculas, números y símbolos)'
  })
  @IsNotEmpty()
  @IsStrongPassword()
  hashedPassword: string;

  @ApiPropertyOptional({
    example: 'admin',
    description: 'Rol asignado al usuario (opcional)'
  })
  @IsOptional()
  @IsString()
  userRole: string;

  @ApiPropertyOptional({
    example: 'active',
    description: 'Estado del usuario (opcional)'
  })
  @IsOptional()
  @IsString()
  userStatus: string;
}