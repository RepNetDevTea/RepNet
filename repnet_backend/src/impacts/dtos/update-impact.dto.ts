import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsInt,
  IsOptional,
  IsString
} from 'class-validator';

export class UpdateImpactDto {
  @ApiPropertyOptional({
    example: 'Reducción de emisiones avanzadas',
    description: 'Nuevo nombre del impacto (opcional)'
  })
  @IsOptional()
  @IsString()
  impactName: string;

  @ApiPropertyOptional({
    example: 9,
    description: 'Nuevo puntaje asociado al impacto (opcional)'
  })
  @IsOptional()
  @IsInt()
  impactScore: number;

  @ApiPropertyOptional({
    example: 'Actualización que refleja una mayor reducción en las emisiones de gases contaminantes.',
    description: 'Nueva descripción del impacto (opcional)'
  })
  @IsOptional()
  @IsString()
  impactDescription: string;
}