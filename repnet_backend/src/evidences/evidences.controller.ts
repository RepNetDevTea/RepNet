import { Controller, FileTypeValidator, Inject, MaxFileSizeValidator, Param, ParseFilePipe, ParseIntPipe, Post, UploadedFile, UseInterceptors } from '@nestjs/common';
import { EvidencesService } from './evidences.service';
import { FileInterceptor } from '@nestjs/platform-express';

@Controller('evidences')
export class EvidencesController {
  constructor(private evidencesService: EvidencesService) {} 
}