import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsInt, IsOptional, IsString, Max, Min } from 'class-validator';

/// Pedido de geração de perguntas por IA a partir de um tema/conteúdo.
export class GenerateQuizDto {
  @ApiProperty({ description: 'Título ou tema do conteúdo base.' })
  @IsString()
  title!: string;

  @ApiPropertyOptional({ description: 'Categoria/área (ex.: "Economia Colonial").' })
  @IsOptional()
  @IsString()
  category?: string;

  @ApiPropertyOptional({ description: 'Contexto adicional (resumo/corpo do conteúdo).' })
  @IsOptional()
  @IsString()
  context?: string;

  @ApiPropertyOptional({ description: 'Número de perguntas (1–10).', default: 5 })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(10)
  count?: number;

  @ApiPropertyOptional({ description: 'Dificuldade (Fácil/Médio/Difícil).', default: 'Médio' })
  @IsOptional()
  @IsString()
  difficulty?: string;
}
