import { PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { randomUUID } from 'crypto';
import { PrismaService } from '../../prisma/prisma.service';
import { PresignUploadDto } from './dto/presign-upload.dto';

@Injectable()
export class UploadsService {
  private readonly client: S3Client;

  constructor(
    private readonly config: ConfigService,
    private readonly prisma: PrismaService,
  ) {
    this.client = new S3Client({
      region: this.config.get<string>('s3.region'),
      endpoint: this.config.get<string>('s3.endpoint'),
      forcePathStyle: true,
      credentials: {
        accessKeyId: this.config.get<string>('s3.accessKeyId', ''),
        secretAccessKey: this.config.get<string>('s3.secretAccessKey', ''),
      },
    });
  }

  async presign(uploaderId: string, dto: PresignUploadDto) {
    const bucket = this.config.get<string>('s3.bucket', '');
    const key = `uploads/${uploaderId}/${randomUUID()}-${dto.filename}`;
    const command = new PutObjectCommand({
      Bucket: bucket,
      Key: key,
      ContentType: dto.mimeType,
      ContentLength: dto.sizeBytes,
    });
    const uploadUrl = await getSignedUrl(this.client, command, { expiresIn: 900 });
    const asset = await this.prisma.asset.create({
      data: { uploaderId, key, bucket, mimeType: dto.mimeType, sizeBytes: dto.sizeBytes },
    });
    return { uploadUrl, assetId: asset.id, key, expiresIn: 900 };
  }
}
