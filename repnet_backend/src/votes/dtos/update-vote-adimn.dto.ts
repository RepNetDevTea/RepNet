import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsInt, IsOptional, IsString } from 'class-validator';

export class UpdateVoteAdminDto {
  @ApiPropertyOptional({
    example: 'reject',
    description: 'Nuevo tipo de voto emitido por el administrador (opcional)'
  })
  @IsOptional()
  @IsString()
  voteType: string;

  @ApiPropertyOptional({
    example: 42,
    description: 'Nuevo ID del usuario administrador que emite el voto (opcional)'
  })
  @IsOptional()
  @IsInt()
  userId: number;

  @ApiPropertyOptional({
    example: 101,
    description: 'Nuevo ID del reporte sobre el cual se emite el voto (opcional)'
  })
  @IsOptional()
  @IsInt()
  reportId: number;
}