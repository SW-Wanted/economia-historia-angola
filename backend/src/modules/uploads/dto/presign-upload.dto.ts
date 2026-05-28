import { ApiProperty } from '@nestjs/swagger';
import { IsInt, IsMimeType, IsString, Max, Min } from 'class-validator';

export class PresignUploadDto {
  @ApiProperty()
  @IsString()
  filename!: string;

  @ApiProperty()
  @IsMimeType()
  mimeType!: string;

  @ApiProperty()
  @IsInt()
  @Min(1)
  @Max(1024 * 1024 * 500)
  sizeBytes!: number;
}
