import { Body, Controller, Delete, Get, NotFoundException, Param, ParseIntPipe, Patch, Post } from '@nestjs/common';
import { CreateTagDto } from './dtos/create-tag.dto';
import { TagsService } from './tags.service';
import { UpdateTagDto } from './dtos/update-tag.dto';

@Controller('tags')
export class TagsController {
  constructor(private tagsService: TagsService) {}
  
  @Post()
  async createTag(@Body() body: CreateTagDto) {
    const user = await this.tagsService.createTag(body);
    if (!user)
      throw new NotFoundException('The tag was not found');

    return user;
  }

  @Get()
  async getAllTags() {
    const tags = await this.tagsService.getAllTags();
    if (!tags)
      throw new NotFoundException('There are no tags');

    return tags;
  }

  @Get(':tagId')
  async getTagById(@Param('tagId', new ParseIntPipe) tagId: number) {
    const tag = await this.tagsService.findTagByFilter({ id: tagId });
    if (!tag)
      throw new NotFoundException('The tag was not found');

    return tag;
  }

  @Patch(':tagId')
  async updateTag(
    @Param('tagId', new ParseIntPipe) tagId: number, 
    @Body() body: UpdateTagDto
  ) {
    const updatedTag = await this.tagsService.updateTagById(tagId, body);
    if (!updatedTag)
      throw new NotFoundException('The tag was not found');

    return updatedTag;
  }

  @Delete(':tagId')
  async deleteTag(@Param('tagId', new ParseIntPipe) tagId: number) {
    const deletedTag = await this.tagsService.deleteTagById(tagId);
    if (!deletedTag)
      throw new NotFoundException('The tag was not found');

    return deletedTag;
  }  
}
