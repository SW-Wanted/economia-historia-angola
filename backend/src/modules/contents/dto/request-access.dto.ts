import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, MaxLength } from 'class-validator';

export class RequestAccessDto {
  @ApiPropertyOptional({ description: 'Motivo/justificação do pedido de acesso (opcional).', maxLength: 500 })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  reason?: string;
}
