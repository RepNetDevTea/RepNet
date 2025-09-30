import { IsNotEmpty, IsString } from "class-validator";

export class CreateVoteDto {
  @IsNotEmpty()
  @IsString()
  voteType: string;
}