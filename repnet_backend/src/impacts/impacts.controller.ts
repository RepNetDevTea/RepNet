import { Body, Controller, Delete, Get, HttpException, NotFoundException, Param, ParseIntPipe, Patch, Post } from '@nestjs/common';
import { CreateImpactDto } from './dtos/create-impact.dto';
import { ImpactsService } from './impacts.service';
import { UpdateImpactDto } from './dtos/update-impact.dto';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';

@Controller('impacts')
export class ImpactsController {
  constructor(private readonly impactsService: ImpactsService) {}
  
  @Post()
  async createImpact(@Body() body: CreateImpactDto) {
    const createdImpact = await this.impactsService.createImpact(body);
    if (!createdImpact)
      throw new HttpException('Something went wrong', 500);

    return createdImpact;
  }

  @Get()
  async getAllImpacts() {
    const impacts = await this.impactsService.getAllImpacts();
    if (!impacts)
      throw new HttpException('There are no impacts', 400);

    return impacts;
  }

  @Get(':impactId')
  async getImpactById(@Param('impactId', new ParseIntPipe) impactId: number) {
    const impact = await this.impactsService.findImpact({ id: impactId });
    if (!impact)
      throw new NotFoundException('Impact was not found');

    return impact;
  }

  @Patch(':impactId')
  async updateImpact(
    @Param('impactId', new ParseIntPipe) impactId: number, 
    @Body() body: UpdateImpactDto
  ) {
    const updatedImpact = await this.impactsService.updateImpact(impactId, body);
    if (!updatedImpact)
      throw new NotFoundException('The impact was not found');

    return updatedImpact;
  }

  @Delete(':impactId')
  async deleteImpact(@Param('impactId', new ParseIntPipe) impactId: number) {
    const deletedImpact = await this.impactsService.deleteImpact(impactId);
    if(!deletedImpact)
      throw new NotFoundException('The impact was not found');

    return deletedImpact;
  } 
}
