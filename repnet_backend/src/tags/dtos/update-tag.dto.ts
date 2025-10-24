import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsInt,
  IsOptional,
  IsString
} from 'class-validator';

export class UpdateTagDto {
  @ApiPropertyOptional({
    example: 'monetario',
    description: 'Nuevo nombre de la etiqueta (opcional)'
  })
  @IsOptional()
  @IsString()
  tagName: string;

  @ApiPropertyOptional({
    example: 7,
    description: 'Nuevo puntaje asociado a la etiqueta (opcional)'
  })
  @IsOptional()
  @IsInt()
  tagScore: number;

  @ApiPropertyOptional({
    example: 'el usuario perdio dinero',
    description: 'Nueva descripción de la etiqueta (opcional)'
  })
  @IsOptional()
  @IsString()
  tagDescription: string;
}