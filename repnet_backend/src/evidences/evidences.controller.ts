import { Body, Controller, Delete, Get, NotFoundException, Param, ParseIntPipe, Patch } from '@nestjs/common';
import { EvidencesService } from './evidences.service';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';

@Controller('evidences')
export class EvidencesController {
  constructor(private readonly evidencesService: EvidencesService) {}

  @Get()
  async getEvidences() {
    const evidences = await this.evidencesService.getEvidences();
    if (!evidences)
      throw new NotFoundException('There are no evidences');

    return evidences;
  }

  @Patch(':evidenceId')
  async updateEvidenceById(@Param('evidenceId', new ParseIntPipe) evidenceId, @Body() body: any) {
    const updatedEvidence = await this.evidencesService.updateEvidenceById(evidenceId, body);
    if (!updatedEvidence)
      throw new NotFoundException('The evidence was not found');

    return updatedEvidence;
  }

  @Delete(':evidenceId')
  async deleteEvidenceById(@Param('evidenceId', new ParseIntPipe) evidenceId) {
    const deletedEvidence = await this.evidencesService.deleteEvidenceById(evidenceId);
    if (!deletedEvidence)
      throw new NotFoundException('The evidence was not found');

    return deletedEvidence;
  }
}
