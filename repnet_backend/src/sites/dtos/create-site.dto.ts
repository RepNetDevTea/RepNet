import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  Max,
  Min
} from 'class-validator';

export class CreateSiteDto {
  @ApiProperty({
    example: 'example.com',
    description: 'Dominio del sitio web que será registrado'
  })
  @IsNotEmpty()
  @IsString()
  siteDomain: string;

  @ApiPropertyOptional({
    example: 85,
    description: 'Reputación del sitio en una escala de 0 a 100',
    minimum: 0,
    maximum: 100
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(100)
  siteReputation: number;
}