import { 
  IsInt, 
  IsOptional, 
  IsString 
} from "class-validator";

export class UpdateImpactDto {
  @IsOptional()
  @IsString()
  impactName: string;

  @IsOptional()
  @IsInt()
  impactScore: number;

  @IsOptional()
  @IsString()
  impactDescription: string;
}