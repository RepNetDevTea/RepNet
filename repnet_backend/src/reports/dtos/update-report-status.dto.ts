import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsNotEmpty,
  IsOptional,
  IsString
} from 'class-validator';

export class UpdateReportStatustDto {
  @ApiProperty({
    example: 'approved',
    description: 'Estado actual del reporte (por ejemplo: approved, rejected, pending)'
  })
  @IsNotEmpty()
  @IsString()
  reportStatus: string;

  @ApiPropertyOptional({
    example: 'El reporte fue aprobado tras revisión del comité.',
    description: 'Comentario opcional del administrador sobre el estado del reporte'
  })
  @IsOptional()
  @IsString()
  adminFeedback: string;
}