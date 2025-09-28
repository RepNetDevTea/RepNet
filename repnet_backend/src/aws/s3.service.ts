import { PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { Inject, Injectable } from '@nestjs/common';
import s3Config from './config/s3.config';
import type { ConfigType } from '@nestjs/config';

@Injectable()
export class S3Service {
  // Tenemos que instanciar a la clase S3Client para poder interactuar con nuestro 
  // S3 Bucket de AWS, pero antes de poder usarlo, tenemos que pasar un objeto 
  // configure a nuestro S3Client
  private s3Client: S3Client;

  constructor(
    @Inject(s3Config.KEY) private s3Configuration: ConfigType<typeof s3Config>,
  ) {
    this.s3Client = new S3Client({ region: this.s3Configuration.region });
  }

  async upload(fileName: string, file: Buffer) {
    return await this.s3Client.send(
      new PutObjectCommand({
        Bucket: 'repnet-evidences-bucket', 
        Key: fileName,
        Body: file,
      })
    );
  }
}
