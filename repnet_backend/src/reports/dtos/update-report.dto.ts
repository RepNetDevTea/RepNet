import { Transform, Type } from "class-transformer";
import { 
  IsArray, 
  IsOptional, 
  IsString, 
  IsUrl 
} from "class-validator";
import { ImpactReferenceDto } from "src/impacts/dtos/impact-reference.dto";
import { TagReferenceDto } from "src/tags/dtos/tag-reference.dto";

export class UpdateReportDto {
  @IsOptional()
  @IsString()
  reportTitle: string; 

  @IsOptional()
  @Transform(({ value }) => typeof value === 'string' ? value.trim(): value)
  @IsUrl()
  reportUrl: string;

  @IsOptional()
  @IsString()
  reportDescription: string;

  @IsOptional()
  @IsArray()
  @Type(() => TagReferenceDto)
  addedTags: TagReferenceDto[];

  @IsOptional()
  @IsArray()
  @Type(() => TagReferenceDto)
  deletedTags: TagReferenceDto[];

  @IsOptional()
  @IsArray()
  @Type(() => ImpactReferenceDto)
  addedImpacts: ImpactReferenceDto[];

  @IsOptional()
  @IsArray()
  @Type(() => ImpactReferenceDto)
  deletedImpacts: ImpactReferenceDto[];
}