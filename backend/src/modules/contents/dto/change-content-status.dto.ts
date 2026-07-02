import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ContentStatus } from '@prisma/client';
import { IsEnum, IsOptional, IsString, MaxLength } from 'class-validator';

export class ChangeContentStatusDto {
  @ApiProperty({ enum: ContentStatus, description: 'Novo estado do conteúdo.' })
  @IsEnum(ContentStatus)
  status!: ContentStatus;

  @ApiPropertyOptional({
    description: 'Notas da revisão ou motivo da rejeição/devolução (visível ao autor na notificação).',
    maxLength: 1000,
  })
  @IsOptional()
  @IsString()
  @MaxLength(1000)
  notes?: string;
}
