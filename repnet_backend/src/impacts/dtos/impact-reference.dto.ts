import { 
  IsInt, 
  IsOptional, 
  IsString
} from "class-validator";

export class ImpactReferenceDto {
  @IsOptional()
  @IsInt()
  id: number;

  @IsOptional()
  @IsString()
  impactName: string;
}