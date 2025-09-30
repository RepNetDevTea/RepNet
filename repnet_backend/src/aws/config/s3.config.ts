import { registerAs } from "@nestjs/config";
import { S3ClientConfig } from "@aws-sdk/client-s3";

export default registerAs(
  "s3",
  (): S3ClientConfig => ({
    region: process.env.AWS_REGION, 
  })
);