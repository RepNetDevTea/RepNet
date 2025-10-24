import { ApiProperty } from '@nestjs/swagger';
import {
  IsInt,
  IsNotEmpty,
  IsString
} from 'class-validator';

export class CreateTagDto {
  @ApiProperty({
    example: 'Robo de identidad',
    description: 'Nombre de la etiqueta que será registrada'
  })
  @IsNotEmpty()
  @IsString()
  tagName: string;

  @ApiProperty({
    example: 5,
    description: 'Puntaje asociado a la etiqueta (entero positivo)'
  })
  @IsNotEmpty()
  @IsInt()
  tagScore: number;

  @ApiProperty({
    example: 'El usuario perdio alguna credencial por el sitio web',
    description: 'Descripción breve de la etiqueta'
  })
  @IsNotEmpty()
  @IsString()
  tagDescription: string;
}