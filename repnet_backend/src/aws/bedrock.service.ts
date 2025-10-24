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

  async scoreEvidence(prompt) {

    const payload = {
        modelId: 'arn:aws:bedrock:us-east-2:509399593375:inference-profile/us.anthropic.claude-3-5-sonnet-20241022-v2:0', 
        contentType: 'application/json', 
        accept: 'application/json', 
        body: JSON.stringify({ 
          anthropic_version: 'bedrock-2023-05-31', 
          max_tokens: 1000, 
          temperature: 0.3, 
          ...prompt, 
        }),
    };

    const response = await this.bedrockClient.send(
      new InvokeModelCommand(payload) 
    )

    return JSON.parse(new TextDecoder().decode(response.body));
  }
}
