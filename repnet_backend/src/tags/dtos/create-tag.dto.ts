import { 
  IsInt, 
  IsNotEmpty, 
  IsString 
} from "class-validator";

export class CreateTagDto {
  @IsNotEmpty()
  @IsString()
  tagName: string;

  @IsNotEmpty()
  @IsInt()
  tagScore: number;

  @IsNotEmpty()
  @IsInt()
  tagDescription: string;
}