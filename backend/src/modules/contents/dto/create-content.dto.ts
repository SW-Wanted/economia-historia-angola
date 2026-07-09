import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ContentType, Visibility } from '@prisma/client';
import { IsBoolean, IsEnum, IsInt, IsOptional, IsString, Min } from 'class-validator';

export class CreateContentDto {
  @ApiProperty()
  @IsString()
  title!: string;

  @ApiProperty()
  @IsString()
  slug!: string;

  @ApiProperty({ enum: ContentType })
  @IsEnum(ContentType)
  type!: ContentType;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  summary?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  body?: string;

  @ApiPropertyOptional({ enum: Visibility })
  @IsOptional()
  @IsEnum(Visibility)
  visibility?: Visibility;

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  isJindungo?: boolean;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  categoryId?: string;

  @ApiPropertyOptional({ description: 'URL pública do ficheiro principal (vídeo, áudio, PDF ou documento).' })
  @IsOptional()
  @IsString()
  mediaUrl?: string;

  @ApiPropertyOptional({ description: 'URL pública da imagem de capa/miniatura.' })
  @IsOptional()
  @IsString()
  thumbnailUrl?: string;

  @ApiPropertyOptional({ description: 'URL de origem/referência externa do conteúdo.' })
  @IsOptional()
  @IsString()
  sourceUrl?: string;

  @ApiPropertyOptional({ description: 'Duração em segundos (vídeo/áudio).' })
  @IsOptional()
  @IsInt()
  @Min(0)
  durationSeconds?: number;
}
