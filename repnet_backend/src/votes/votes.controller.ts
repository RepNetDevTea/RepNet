import { Body, Controller, Delete, Get, HttpException, NotFoundException, Param, ParseIntPipe, Patch, Post } from '@nestjs/common';
import { VotesService } from './votes.service';
import { CreateVoteAdminDto } from './dtos/create_vote_admin.dto';
import { UpdateVoteAdminDto } from './dtos/update-vote-adimn.dto';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';

@Controller('votes')
export class VotesController {
  constructor(private readonly votesService: VotesService) {}

  @Get()
  async getAllVotes() {
    const votes = await this.votesService.findVotes();
    if (!votes)
      throw new NotFoundException('There are no votes');

    return votes;
  }

  @Post()
  async createVote(@Body() body: CreateVoteAdminDto) {
    const { voteType, userId, reportId } = body;
    const data = {
      voteType, 
      user: { connect: { id: userId } }, 
      report: { connect: { id: reportId } }, 
    }

    const newVote = await this.votesService.createVote(data);
    if (!newVote)
      throw new HttpException('Somtihng went wrong while creating the vote', 500);

    return newVote;
  }

  @Get(':voteId')
  async getVoteById(@Param('voteId', new ParseIntPipe) voteId: number) {
    const vote = await this.votesService.findVoteById(voteId);
    if (!vote)
      throw new NotFoundException('The vote does not exist');

    return vote;
  } 

  @Patch(':voteId') 
  async updateVoteById(
    @Param('voteId', new ParseIntPipe) voteId: number, 
    @Body() body: UpdateVoteAdminDto
  ) {
    const updatedVote = await this.votesService.updateVoteById(voteId, body);
    if (!updatedVote)
      throw new NotFoundException('The vote was not found');

    return updatedVote;
  }

  @Delete(':voteId')
  async deleteVoteById(@Param('voteId', new ParseIntPipe) voteId: number) {
    const deletedVote = await this.votesService.deleteVoteById(voteId);
    if (!deletedVote)
      throw new NotFoundException('The vote was not found');

    return deletedVote;
  }
}
