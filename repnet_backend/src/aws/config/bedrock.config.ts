import { registerAs } from "@nestjs/config"; 
import { BedrockRuntimeClientConfig } from "@aws-sdk/client-bedrock-runtime";

export default registerAs(
  'bedrock',
  ():BedrockRuntimeClientConfig => ({
    region: process.env.AWS_REGION, 
  })
);