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
      messages: [
        {
          role: 'user',
          content: prompt, 
        }
      ],
      temperature: 0.3, 
    };

    const bedrockResponse = await this.bedrockClient.send(
      new InvokeModelCommand({
        modelId: 'arn:aws:bedrock:us-east-2:509399593375:inference-profile/us.mistral.pixtral-large-2502-v1:0', 
        contentType: 'application/json', 
        accept: 'application/json', 
        body: JSON.stringify(payload), 
      }) 
    )

    return JSON.parse(new TextDecoder().decode(bedrockResponse.body));
  }
}
