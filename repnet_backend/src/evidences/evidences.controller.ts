import { Controller } from '@nestjs/common';
import { EvidencesService } from './evidences.service';

@Controller('evidences')
export class EvidencesController {
  constructor(private evidencesService: EvidencesService) {} 
}