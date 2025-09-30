import { IsInt, IsOptional, IsString } from "class-validator";

export class UpdateVoteAdminDto {
  @IsOptional()
  @IsString()
  voteType: string;

  @IsOptional()
  @IsInt()  
  userId: number;

  @IsOptional()
  @IsInt()  
  reportId: number;
}