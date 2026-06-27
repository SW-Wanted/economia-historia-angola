import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { WriterApplicationStatus } from '@prisma/client';
import { IsEnum, IsNotIn, IsOptional, IsString } from 'class-validator';

const REVIEWABLE = [
  WriterApplicationStatus.APPROVED,
  WriterApplicationStatus.REJECTED,
  WriterApplicationStatus.REQUEST_CHANGES,
] as const;

export class ReviewWriterApplicationDto {
  @ApiProperty({ enum: REVIEWABLE, description: 'Decision: APPROVED, REJECTED, or REQUEST_CHANGES' })
  @IsEnum(WriterApplicationStatus)
  @IsNotIn([WriterApplicationStatus.PENDING], { message: 'Decision cannot be PENDING' })
  decision!: (typeof REVIEWABLE)[number];

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  notes?: string;

  @ApiPropertyOptional({ description: 'Required when decision is REJECTED' })
  @IsOptional()
  @IsString()
  rejectionReason?: string;
}
