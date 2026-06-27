import { ApiPropertyOptional } from '@nestjs/swagger';
import { AccountStatus } from '@prisma/client';
import { IsBoolean, IsEnum, IsOptional } from 'class-validator';

export class UpdateUserStatusDto {
  @ApiPropertyOptional({ description: 'Set to false to suspend the account' })
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;

  @ApiPropertyOptional({ enum: AccountStatus, description: 'Change account approval status' })
  @IsOptional()
  @IsEnum(AccountStatus)
  approvalStatus?: AccountStatus;
}
