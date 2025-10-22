import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsInt,
  IsOptional,
  IsString
} from 'class-validator';

export class UpdateTagDto {
  @ApiPropertyOptional({
    example: 'Sostenibilidad avanzada',
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
    example: 'Etiqueta actualizada con enfoque en prácticas ecológicas avanzadas.',
    description: 'Nueva descripción de la etiqueta (opcional)'
  })
  @IsOptional()
  @IsString()
  tagDescription: string;
}