import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsInt,
  IsOptional,
  IsString,
  Max,
  Min
} from 'class-validator';

export class UpdateSiteDto {
  @ApiPropertyOptional({
    example: 'updated-example.org',
    description: 'Nuevo dominio del sitio web (opcional)'
  })
  @IsOptional()
  @IsString()
  siteDomain: string;

  @ApiPropertyOptional({
    example: 72,
    description: 'Nueva reputación del sitio en una escala de 0 a 100 (opcional)',
    minimum: 0,
    maximum: 100
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(100)
  siteReputation: number;

  @ApiPropertyOptional({
    example: 15,
    description: 'Severidad acumulada del sitio (opcional)'
  })
  @IsOptional()
  @IsInt()
  accumulatedSeverity: number;
}