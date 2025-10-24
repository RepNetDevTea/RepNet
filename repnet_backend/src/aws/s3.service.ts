import { 
  PutObjectCommand, 
  DeleteObjectCommand, 
  GetObjectCommand, 
  S3Client 
} from '@aws-sdk/client-s3';
import { HttpException, Inject, Injectable } from '@nestjs/common';
import s3Config from './config/s3.config';
import type { ConfigType } from '@nestjs/config';

@Injectable()
export class S3Service {
  private s3Client: S3Client;

  constructor(
    @Inject(s3Config.KEY) private s3Configuration: ConfigType<typeof s3Config>,
  ) {
    this.s3Client = new S3Client({ region: this.s3Configuration.region });
  }

  createFileUrl(key: string) {
    const bucketName = 'repnet-evidences-bucket';
    const region = this.s3Configuration.region;
    const evidenceFileUrl = `https://${bucketName}.s3.${region}.amazonaws.com/${encodeURIComponent(key)}`;
    return evidenceFileUrl;
  }

  createFileUri(key: string) {
    const bucketName = 'repnet-evidences-bucket';
    return `s3://${bucketName}/${key}`;
  }

  async upload(fileKey: string, file: Buffer) {
    return await this.s3Client.send(
      new PutObjectCommand({
        Bucket: 'repnet-evidences-bucket', 
        Key: fileKey,
        Body: file,
      })
    );
  }

  async retrieve(fileKey: string) {
    const response = await this.s3Client.send(
      new GetObjectCommand({
        Bucket : 'repnet-evidences-bucket',
        Key: fileKey, 
      })
    );

    const byteArray = await response.Body?.transformToByteArray();
    if (!byteArray)
      throw new HttpException('The evidence has no file', 500);

    return byteArray;
  }

  async delete(fileKey: string) {
    await this.s3Client.send(
      new DeleteObjectCommand({
        Bucket: 'repnet-evidences-bucket',
        Key: fileKey, 
      })
    );
  }
}
