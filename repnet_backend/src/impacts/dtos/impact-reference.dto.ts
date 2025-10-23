import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsInt,
  IsOptional,
  IsString
} from 'class-validator';

export class ImpactReferenceDto {
  @ApiPropertyOptional({
    example: 7,
    description: 'ID único del impacto referenciado'
  })
  @IsOptional()
  @IsInt()
  id: number;

  @ApiPropertyOptional({
    example: 'Reducción de emisiones',
    description: 'Nombre del impacto referenciado'
  })
  @IsOptional()
  @IsString()
  impactName: string;
}