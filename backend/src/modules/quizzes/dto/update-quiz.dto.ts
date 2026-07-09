import { PartialType } from '@nestjs/swagger';
import { CreateQuizDto } from './create-quiz.dto';

/// Edição de um quiz. Todos os campos são opcionais; quando `questions` é
/// fornecido, substitui integralmente as perguntas/opções existentes.
export class UpdateQuizDto extends PartialType(CreateQuizDto) {}
