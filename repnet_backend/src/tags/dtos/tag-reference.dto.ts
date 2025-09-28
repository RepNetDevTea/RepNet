import { 
  IsInt, 
  IsOptional, 
  IsString, 
} from "class-validator";

export class TagReferenceDto {
  @IsOptional()
  @IsInt()
  id: number;

  @IsOptional()
  @IsString()
  tagName: string;
}