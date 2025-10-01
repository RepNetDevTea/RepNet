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

  async scoreEvidence(context) {
    const bedrockResponse = await this.bedrockClient.send(
      new InvokeModelCommand({
        modelId: 'mistral.pixtral-large-25.02', 
        contentType: 'application/json', 
        accept: 'application/json', 
        body: JSON.stringify(context), 
      }) 
    )

    return JSON.parse(new TextDecoder().decode(bedrockResponse.body));
  }
}
