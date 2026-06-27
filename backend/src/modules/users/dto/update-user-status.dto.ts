import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsBoolean, IsOptional } from 'class-validator';

export class UpdateUserStatusDto {
  @ApiPropertyOptional({ description: 'Set to false to suspend the account' })
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}
