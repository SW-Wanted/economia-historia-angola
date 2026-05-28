import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsISO8601, IsOptional, IsString } from 'class-validator';

export class SyncQueryDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsISO8601()
  since?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  scope?: string;
}
