import { ApiProperty } from '@nestjs/swagger';
import { IsInt, IsNotEmpty, IsString } from 'class-validator';

export class CreateImpactDto {
  @ApiProperty({
    example: 'Reducción de emisiones',
    description: 'Nombre del impacto que será registrado'
  })
  @IsNotEmpty()
  @IsString()
  impactName: string;

  @ApiProperty({
    example: 8,
    description: 'Puntaje asociado al impacto (entero positivo)'
  })
  @IsNotEmpty()
  @IsInt()
  impactScore: number;

  @ApiProperty({
    example: 'Este impacto representa una reducción significativa en las emisiones de CO₂.',
    description: 'Descripción detallada del impacto'
  })
  @IsNotEmpty()
  @IsString()
  impactDescription: string;
}
