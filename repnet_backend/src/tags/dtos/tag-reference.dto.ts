import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsInt,
  IsOptional,
  IsString
} from 'class-validator';

export class TagReferenceDto {
  @ApiPropertyOptional({
    example: 12,
    description: 'ID único de la etiqueta referenciada'
  })
  @IsOptional()
  @IsInt()
  id: number;

  @ApiPropertyOptional({
    example: 'Sostenibilidad',
    description: 'Nombre de la etiqueta referenciada'
  })
  @IsOptional()
  @IsString()
  tagName: string;
}