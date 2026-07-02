import { ApiPropertyOptional } from '@nestjs/swagger';
import { ContentStatus, ContentType } from '@prisma/client';
import { IsEnum, IsOptional, IsString } from 'class-validator';
import { PaginationDto } from '../../../common/dto/pagination.dto';

export class ContentQueryDto extends PaginationDto {
  @ApiPropertyOptional({ enum: ContentType })
  @IsOptional()
  @IsEnum(ContentType)
  type?: ContentType;

  @ApiPropertyOptional({ enum: ContentStatus, description: 'Filtro de estado (apenas no painel de gestão).' })
  @IsOptional()
  @IsEnum(ContentStatus)
  status?: ContentStatus;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  categoryId?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  tag?: string;
}
