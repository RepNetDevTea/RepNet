import { IsInt, IsNotEmpty, IsString } from "class-validator";

export class CreateVoteAdminDto {
  @IsNotEmpty()
  @IsString()
  voteType: string;

  @IsNotEmpty()
  @IsInt()  
  userId: number;

  @IsNotEmpty()
  @IsInt()  
  reportId: number;
}