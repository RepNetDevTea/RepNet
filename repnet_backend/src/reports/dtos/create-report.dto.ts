import { Transform, Type } from "class-transformer";
import { 
  IsArray, 
  IsNotEmpty, 
  IsString, 
  IsUrl 
} from "class-validator";
import { ImpactReferenceDto } from "src/impacts/dtos/impact-reference.dto";
import { TagReferenceDto } from "src/tags/dtos/tag-reference.dto";

export class CreateReportDto {
  @IsNotEmpty()
  @IsString()
  reportTitle: string; 

  @IsNotEmpty()
  @Transform(({ value }) => value.trim())
  @IsUrl()
  reportUrl: string;

  @IsNotEmpty()
  @IsString()
  reportDescription: string;

  @IsNotEmpty()
  @IsArray()
  @Type(() => TagReferenceDto)
  tags: TagReferenceDto[]

  @IsNotEmpty()
  @IsArray()
  @Type(() => ImpactReferenceDto)
  impacts: ImpactReferenceDto[]
}