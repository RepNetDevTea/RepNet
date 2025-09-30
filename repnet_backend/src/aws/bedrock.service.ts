import { Inject, Injectable } from '@nestjs/common';
import { BedrockRuntimeClient, InvokeModelCommand } from '@aws-sdk/client-bedrock-runtime';
import type { ConfigType } from '@nestjs/config';
import bedrockConfig from './config/bedrock.config';

@Injectable()
export class BedrockService {
  private bedrockClient: BedrockRuntimeClient;

  constructor(
    @Inject(bedrockConfig.KEY) private bedrockConfiguration: ConfigType<typeof bedrockConfig>
  ) {
    this.bedrockClient = new BedrockRuntimeClient({
      region: this.bedrockConfiguration.region!, 
    });
  }

  // async scoreEvidence() {
  //   return await this.bedrockClient.send(
  //     new InvokeModelCommand({
        
  //     }) 
  //   )
  // }
}
