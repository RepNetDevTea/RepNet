import { 
  IsInt, 
  IsNotEmpty, 
  IsOptional, 
  IsString, 
  Max, 
  Min, 
} from "class-validator";

export class CreateSiteDto {
  @IsNotEmpty()
  @IsString()
  siteDomain: string;

  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(100)
  siteReputation: number;
}