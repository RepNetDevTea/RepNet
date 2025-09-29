import { Body, Controller, Delete, Get, NotFoundException, Param, ParseIntPipe, Patch, Post } from '@nestjs/common';
import { CreateTagDto } from './dtos/create-tag.dto';
import { TagsService } from './tags.service';
import { UpdateTagDto } from './dtos/update-tag.dto';
import { PutBucketNotificationConfigurationCommand } from '@aws-sdk/client-s3';

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
    return await this.tagsService.updateTagById(tagId, body);
  }

  @Delete(':tagId')
  async deleteTag(@Param('tagId', new ParseIntPipe) tagId: number) {
    return await this.tagsService.deleteTagById(tagId);
  }  
}
