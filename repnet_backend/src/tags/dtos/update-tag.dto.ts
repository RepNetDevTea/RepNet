import { 
  IsInt, 
  IsOptional, 
  IsString 
} from "class-validator";

export class UpdateTagDto {
  @IsOptional()
  @IsString()
  tagName: string;

  @IsOptional()
  @IsInt()
  tagScore: number;

  @IsOptional()
  @IsString()
  tagDescription: string;
}