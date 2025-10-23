import { ApiProperty } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  IsArray,
  IsNotEmpty,
  IsString,
  IsUrl
} from 'class-validator';
import { ImpactReferenceDto } from 'src/impacts/dtos/impact-reference.dto';
import { TagReferenceDto } from 'src/tags/dtos/tag-reference.dto';

export class CreateReportDto {
  @ApiProperty({
    example: 'Informe de sostenibilidad 2025',
    description: 'Título del reporte que será registrado'
  })
  @IsNotEmpty()
  @IsString()
  reportTitle: string;

  @ApiProperty({
    example: 'https://example.com/report.pdf',
    description: 'URL pública del reporte. Debe ser válida y accesible.'
  })
  @IsNotEmpty()
  @Transform(({ value }) => value.trim())
  @IsUrl()
  reportUrl: string;

  @ApiProperty({
    example: 'Este informe detalla las acciones de sostenibilidad realizadas durante el año 2025.',
    description: 'Descripción breve del contenido del reporte'
  })
  @IsNotEmpty()
  @IsString()
  reportDescription: string;

  @ApiProperty({
    type: [TagReferenceDto],
    description: 'Lista de etiquetas asociadas al reporte'
  })
  @IsNotEmpty()
  @IsArray()
  @Type(() => TagReferenceDto)
  tags: TagReferenceDto[];

  @ApiProperty({
    type: [ImpactReferenceDto],
    description: 'Lista de impactos relacionados con el reporte'
  })
  @IsNotEmpty()
  @IsArray()
  @Type(() => ImpactReferenceDto)
  impacts: ImpactReferenceDto[];
}