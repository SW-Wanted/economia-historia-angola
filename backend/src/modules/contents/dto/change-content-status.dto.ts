import { ApiProperty } from '@nestjs/swagger';
import { ContentStatus } from '@prisma/client';
import { IsEnum } from 'class-validator';

export class ChangeContentStatusDto {
  @ApiProperty({ enum: ContentStatus, description: 'Novo estado do conteúdo.' })
  @IsEnum(ContentStatus)
  status!: ContentStatus;
}
