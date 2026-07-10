import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean } from 'class-validator';

export class ReviewAccessRequestDto {
  @ApiProperty({ description: 'true = aprovar (conceder acesso); false = rejeitar.' })
  @IsBoolean()
  approve!: boolean;
}
