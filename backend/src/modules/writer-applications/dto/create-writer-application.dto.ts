import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsUrl } from 'class-validator';

export class CreateWriterApplicationDto {
  @ApiProperty()
  @IsString()
  fullName!: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsUrl()
  photoUrl?: string;

  @ApiProperty()
  @IsString()
  biography!: string;

  @ApiProperty()
  @IsString()
  academicBackground!: string;

  @ApiProperty()
  @IsString()
  institution!: string;

  @ApiProperty()
  @IsString()
  specialization!: string;

  @ApiProperty()
  @IsString()
  researchExperience!: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  previousPublications?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  portfolio?: string;

  @ApiProperty({ description: 'Comma-separated areas, e.g. "História Colonial,Economia Moderna"' })
  @IsString()
  economicHistoryAreas!: string;

  @ApiProperty({ description: 'Comma-separated language codes, e.g. "PT,EN"' })
  @IsString()
  languages!: string;

  @ApiProperty({ description: 'Comma-separated interest topics' })
  @IsString()
  interestTopics!: string;

  @ApiPropertyOptional({ description: 'URL of uploaded identification document' })
  @IsOptional()
  @IsUrl()
  documentUrl?: string;
}
