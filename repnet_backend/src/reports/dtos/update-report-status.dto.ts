import { 
  IsNotEmpty, 
  IsOptional, 
  IsString, 
} from "class-validator";

export class UpdateReportStatustDto {
  @IsNotEmpty()
  @IsString()
  reportStatus: string;

  @IsOptional()
  @IsString()
  adminFeedback: string;
}