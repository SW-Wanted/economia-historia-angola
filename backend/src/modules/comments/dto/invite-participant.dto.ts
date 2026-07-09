import { ApiProperty } from '@nestjs/swagger';
import { IsEmail } from 'class-validator';

export class InviteParticipantDto {
  @ApiProperty({ description: 'Email do utilizador a adicionar à sala.' })
  @IsEmail()
  email!: string;
}
