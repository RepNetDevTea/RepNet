import { 
  IsInt, 
  IsOptional, 
  IsString, 
  Max, 
  Min, 
} from "class-validator";

export class UpdateSiteDto {
  @IsOptional()
  @IsString()
  siteDomain: string;

  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(100)
  siteReputation: number;

  @IsOptional()
  @IsInt()
  accumulatedSeverity: number;
}