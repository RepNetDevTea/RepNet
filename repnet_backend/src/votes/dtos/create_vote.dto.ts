import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class CreateVoteDto {
  @ApiProperty({
    example: 'approve',
    description: 'Tipo de voto emitido por el usuario (por ejemplo: approve, reject)'
  })
  @IsNotEmpty()
  @IsString()
  voteType: string;
}