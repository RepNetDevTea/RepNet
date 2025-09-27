import { Test, TestingModule } from '@nestjs/testing';
import { ImpactsController } from './impacts.controller';

describe('ImpactController', () => {
  let controller: ImpactsController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [ImpactsController],
    }).compile();

    controller = module.get<ImpactsController>(ImpactsController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
