import { 
  IsInt, 
  IsOptional, 
  IsString, 
} from "class-validator";

export class CreateSiteDto {
  @IsOptional()
  @IsInt()
  id: number;

  @IsOptional()
  @IsString()
  siteDomain: string;
}