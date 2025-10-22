import { ApiProperty } from '@nestjs/swagger';
import { IsInt, IsNotEmpty, IsString } from 'class-validator';

export class CreateVoteAdminDto {
  @ApiProperty({
    example: 'approve',
    description: 'Tipo de voto emitido por el administrador (por ejemplo: approve, reject)'
  })
  @IsNotEmpty()
  @IsString()
  voteType: string;

  @ApiProperty({
    example: 42,
    description: 'ID del usuario administrador que emite el voto'
  })
  @IsNotEmpty()
  @IsInt()
  userId: number;

  @ApiProperty({
    example: 101,
    description: 'ID del reporte sobre el cual se emite el voto'
  })
  @IsNotEmpty()
  @IsInt()
  reportId: number;
}