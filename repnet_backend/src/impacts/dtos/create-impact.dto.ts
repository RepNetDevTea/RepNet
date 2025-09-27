import { 
  IsInt, 
  IsNotEmpty, 
  IsString 
} from "class-validator";

export class CreateImpactDto {
  @IsNotEmpty()
  @IsString()
  impactName: string;

  @IsNotEmpty()
  @IsInt()
  impactScore: number;

  @IsNotEmpty()
  @IsString()
  impactDescription: string;
}