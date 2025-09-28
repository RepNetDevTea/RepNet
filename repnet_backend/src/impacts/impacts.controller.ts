import { Body, Controller, Delete, Get, Param, ParseIntPipe, Patch, Post } from '@nestjs/common';
import { CreateImpactDto } from './dtos/create-impact.dto';
import { ImpactsService } from './impacts.service';
import { UpdateImpactDto } from './dtos/update-impact.dto';


@Controller('impacts')
export class ImpactsController {
  constructor(private impactsService: ImpactsService) {}
  
  @Post('')
  async createImpact(@Body() body: CreateImpactDto) {
    return await this.impactsService.createImpact(body);
  }

  @Get('')
  async getAllImpacts() {
    return await this.impactsService.getAllImpacts();
  }

  @Patch(':id')
  async updateImpact(
    @Param('id', new ParseIntPipe) id: number, 
    @Body() body: UpdateImpactDto
  ) {
    return await this.impactsService.updateImpact(id, body);
  }

  @Delete(':id')
  async deleteImpact(@Param('id', new ParseIntPipe) id: number) {
    return await this.impactsService.deleteImpact(id);
  } 
}
