import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Visibility } from '@prisma/client';
import { IsEnum, IsOptional, IsString, IsUUID } from 'class-validator';

export class CreateForumDto {
  @ApiProperty()
  @IsString()
  name!: string;

  @ApiProperty()
  @IsString()
  slug!: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional({ enum: Visibility })
  @IsOptional()
  @IsEnum(Visibility)
  visibility?: Visibility;

  @ApiPropertyOptional({ description: 'Comunidade a que o fórum pertence.' })
  @IsOptional()
  @IsUUID()
  communityId?: string;
}
