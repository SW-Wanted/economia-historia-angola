import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Visibility } from '@prisma/client';
import { IsBoolean, IsEnum, IsOptional, IsString } from 'class-validator';

export class CreateQuizDto {
  @ApiProperty()
  @IsString()
  title!: string;

  @ApiProperty()
  @IsString()
  slug!: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  categoryId?: string;

  @ApiPropertyOptional({ enum: Visibility })
  @IsOptional()
  @IsEnum(Visibility)
  visibility?: Visibility;

  @ApiPropertyOptional({ description: 'Marca este quiz como o "Quiz da Semana" em destaque.' })
  @IsOptional()
  @IsBoolean()
  isWeekly?: boolean;
}
