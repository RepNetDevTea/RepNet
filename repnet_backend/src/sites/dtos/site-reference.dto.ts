import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsInt,
  IsOptional,
  IsString
} from 'class-validator';

export class CreateSiteDto {
  @ApiPropertyOptional({
    example: 17,
    description: 'ID único del sitio (opcional, generalmente generado automáticamente)'
  })
  @IsOptional()
  @IsInt()
  id: number;

  @ApiPropertyOptional({
    example: 'example.org',
    description: 'Dominio del sitio web que será registrado (opcional)'
  })
  @IsOptional()
  @IsString()
  siteDomain: string;
}