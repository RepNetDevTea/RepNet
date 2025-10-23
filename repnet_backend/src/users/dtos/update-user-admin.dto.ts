import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsEmail,
  IsOptional,
  IsString,
  IsStrongPassword
} from 'class-validator';

export class UpdateUserAdminDto {
  @ApiPropertyOptional({
    example: 'felipe',
    description: 'Nombre actualizado del usuario'
  })
  @IsOptional()
  @IsString()
  name: string;

  @ApiPropertyOptional({
    example: 'Pérez',
    description: 'Apellido paterno actualizado del usuario'
  })
  @IsOptional()
  @IsString()
  fathersLastName: string;

  @ApiPropertyOptional({
    example: 'Gómez',
    description: 'Apellido materno actualizado del usuario'
  })
  @IsOptional()
  @IsString()
  mothersLastName: string;

  @ApiPropertyOptional({
    example: 'juanperez123',
    description: 'Nuevo nombre de usuario'
  })
  @IsOptional()
  @IsString()
  username: string;

  @ApiPropertyOptional({
    example: 'juan.perez@nuevoemail.com',
    description: 'Correo electrónico actualizado'
  })
  @IsOptional()
  @IsEmail()
  email: string;

  @ApiPropertyOptional({
    example: 'N3wP@ssw0rd!',
    description: 'Nueva contraseña segura del usuario'
  })
  @IsOptional()
  @IsStrongPassword()
  hashedPassword: string;

  @ApiPropertyOptional({
    example: 'editor',
    description: 'Nuevo rol asignado al usuario'
  })
  @IsOptional()
  @IsString()
  userRole: string;

  @ApiPropertyOptional({
    example: 'inactive',
    description: 'Nuevo estado del usuario'
  })
  @IsOptional()
  @IsString()
  userStatus: string;
}