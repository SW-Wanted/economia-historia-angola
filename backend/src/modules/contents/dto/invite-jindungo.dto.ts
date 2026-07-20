import { ApiProperty } from '@nestjs/swagger';
import { ArrayMaxSize, ArrayNotEmpty, IsArray, IsEmail } from 'class-validator';

export class InviteJindungoDto {
  @ApiProperty({
    description: 'Emails das pessoas a convidar (utilizadores já registados). Acesso concedido de imediato.',
    type: [String],
    example: ['leitor@exemplo.ao'],
  })
  @IsArray()
  @ArrayNotEmpty()
  @ArrayMaxSize(50)
  @IsEmail({}, { each: true })
  emails!: string[];
}
