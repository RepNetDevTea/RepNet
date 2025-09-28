import { Body, Controller, Delete, Get, Param, ParseIntPipe, Patch, Post } from '@nestjs/common';
import { CreateTagDto } from './dtos/create-tag.dto';
import { TagsService } from './tags.service';
import { UpdateTagDto } from './dtos/update-tag.dto';

@Controller('tags')
export class TagsController {
  constructor(private tagsService: TagsService) {}
  
  @Post('')
  async createTag(@Body() body: CreateTagDto) {
    return await this.tagsService.createTag(body);
  }

  @Get('')
  async getAllTags() {
    return await this.tagsService.getAllTags();
  }

  @Patch(':id')
  async updateTag(
    @Param('id', new ParseIntPipe) id: number, 
    @Body() body: UpdateTagDto
  ) {
    return await this.tagsService.updateTag(id, body);
  }

  @Delete(':id')
  async deleteTag(@Param('id', new ParseIntPipe) id: number) {
    return await this.tagsService.deleteTag(id);
  }  
}
