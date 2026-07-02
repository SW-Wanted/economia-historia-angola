import { ApiProperty } from '@nestjs/swagger';
import { RoleCode } from '@prisma/client';
import { IsEnum } from 'class-validator';

export class SetUserRoleDto {
  @ApiProperty({ enum: RoleCode, description: 'Papel a atribuir ao utilizador (substitui o papel atual).' })
  @IsEnum(RoleCode)
  role!: RoleCode;
}
