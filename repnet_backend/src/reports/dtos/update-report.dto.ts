import { ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  IsArray,
  IsOptional,
  IsString,
  IsUrl
} from 'class-validator';
import { ImpactReferenceDto } from 'src/impacts/dtos/impact-reference.dto';
import { TagReferenceDto } from 'src/tags/dtos/tag-reference.dto';

export class UpdateReportDto {
  @ApiPropertyOptional({
    example: 'Informe de sostenibilidad actualizado',
    description: 'Nuevo título del reporte (opcional)'
  })
  @IsOptional()
  @IsString()
  reportTitle: string;

  @ApiPropertyOptional({
    example: 'https://example.com/updated-report.pdf',
    description: 'Nueva URL del reporte (opcional)'
  })
  @IsOptional()
  @Transform(({ value }) => typeof value === 'string' ? value.trim() : value)
  @IsUrl()
  reportUrl: string;

  @ApiPropertyOptional({
    example: 'Descripción actualizada del informe de sostenibilidad.',
    description: 'Nueva descripción del reporte (opcional)'
  })
  @IsOptional()
  @IsString()
  reportDescription: string;

  @ApiPropertyOptional({
    type: [TagReferenceDto],
    description: 'Etiquetas que se agregarán al reporte'
  })
  @IsOptional()
  @IsArray()
  @Type(() => TagReferenceDto)
  addedTags: TagReferenceDto[];

  @ApiPropertyOptional({
    type: [TagReferenceDto],
    description: 'Etiquetas que se eliminarán del reporte'
  })
  @IsOptional()
  @IsArray()
  @Type(() => TagReferenceDto)
  deletedTags: TagReferenceDto[];

  @ApiPropertyOptional({
    type: [ImpactReferenceDto],
    description: 'Impactos que se agregarán al reporte'
  })
  @IsOptional()
  @IsArray()
  @Type(() => ImpactReferenceDto)
  addedImpacts: ImpactReferenceDto[];

  @ApiPropertyOptional({
    type: [ImpactReferenceDto],
    description: 'Impactos que se eliminarán del reporte'
  })
  @IsOptional()
  @IsArray()
  @Type(() => ImpactReferenceDto)
  deletedImpacts: ImpactReferenceDto[];
}