import {
  ForbiddenException,
  Injectable,
  NotFoundException,
  ServiceUnavailableException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { QuizAttemptStatus, Visibility } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { AnswerDto } from './dto/answer.dto';
import { CreateQuizDto } from './dto/create-quiz.dto';
import { GenerateQuizDto } from './dto/generate-quiz.dto';
import { UpdateQuizDto } from './dto/update-quiz.dto';

@Injectable()
export class QuizzesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly config: ConfigService,
  ) {}

  listPublic() {
    return this.prisma.quiz.findMany({
      where: { visibility: Visibility.PUBLIC, deletedAt: null },
      include: { category: true, _count: { select: { questions: true, attempts: true } } },
    });
  }

  /// O "Quiz da Semana" em destaque: o quiz público mais recente marcado como
  /// semanal, já com as perguntas e opções. Devolve `null` quando nenhum admin
  /// marcou um quiz como semanal — a app não mostra o cartão de destaque nesse
  /// caso.
  weekly() {
    return this.prisma.quiz.findFirst({
      where: { visibility: Visibility.PUBLIC, deletedAt: null, isWeekly: true },
      orderBy: [{ publishedAt: 'desc' }, { createdAt: 'desc' }],
      include: {
        category: true,
        questions: {
          orderBy: { position: 'asc' },
          select: {
            id: true,
            statement: true,
            explanation: true,
            points: true,
            position: true,
            options: {
              orderBy: { position: 'asc' },
              select: { id: true, text: true, isCorrect: true, position: true },
            },
          },
        },
      },
    });
  }

  async findById(id: string) {
    const quiz = await this.prisma.quiz.findFirst({
      where: { id, visibility: Visibility.PUBLIC, deletedAt: null },
      include: {
        category: true,
        questions: {
          orderBy: { position: 'asc' },
          select: {
            id: true,
            statement: true,
            explanation: true,
            points: true,
            position: true,
            options: {
              orderBy: { position: 'asc' },
              select: { id: true, text: true, position: true },
            },
          },
        },
      },
    });
    if (!quiz) throw new NotFoundException('Quiz not found');
    return quiz;
  }

  /// Versão para edição: inclui `isCorrect` nas opções (o `findById` público
  /// esconde-o). Só acessível a quem tem QUIZ_MANAGE (gate no controller).
  async findForEdit(id: string) {
    const quiz = await this.prisma.quiz.findFirst({
      where: { id, deletedAt: null },
      include: {
        category: true,
        questions: {
          orderBy: { position: 'asc' },
          include: { options: { orderBy: { position: 'asc' } } },
        },
      },
    });
    if (!quiz) throw new NotFoundException('Quiz not found');
    return quiz;
  }

  create(createdById: string, dto: CreateQuizDto) {
    const { questions, ...quiz } = dto;
    return this.prisma.quiz.create({
      data: {
        ...quiz,
        createdById,
        publishedAt: new Date(),
        questions: questions?.length
          ? {
              create: questions.map((question, questionIndex) => ({
                statement: question.statement,
                explanation: question.explanation,
                points: question.points ?? 1,
                position: questionIndex,
                options: {
                  create: question.options.map((option, optionIndex) => ({
                    text: option.text,
                    isCorrect: option.isCorrect ?? false,
                    position: optionIndex,
                  })),
                },
              })),
            }
          : undefined,
      },
      include: {
        category: true,
        questions: {
          orderBy: { position: 'asc' },
          include: { options: { orderBy: { position: 'asc' } } },
        },
      },
    });
  }

  /// Gera perguntas de escolha múltipla com a Gemini API a partir de um
  /// tema/conteúdo. Devolve o mesmo formato de `CreateQuizQuestionDto[]`, pronto
  /// a alimentar `create`. Não persiste nada — a persistência acontece quando o
  /// utilizador publica o quiz. Lança 503 se a chave não estiver configurada ou
  /// se a IA falhar/retornar formato inválido.
  async generate(dto: GenerateQuizDto) {
    const apiKey = this.config.get<string>('gemini.apiKey');
    if (!apiKey) {
      throw new ServiceUnavailableException(
        'Geração por IA indisponível: GEMINI_API_KEY não está configurada no servidor.',
      );
    }
    const model = this.config.get<string>('gemini.model') ?? 'gemini-2.0-flash';
    const count = Math.min(Math.max(dto.count ?? 5, 1), 10);
    const difficulty = dto.difficulty ?? 'Médio';

    const prompt = [
      `Gera exatamente ${count} perguntas de escolha múltipla, em português de Angola,`,
      `sobre o tema: "${dto.title}"${dto.category ? ` (área: ${dto.category})` : ''}.`,
      dto.context ? `Contexto de apoio: ${dto.context}` : '',
      `Dificuldade: ${difficulty}.`,
      'Cada pergunta deve ter 4 opções, apenas UMA correta, e uma explicação curta.',
      'Responde SÓ com JSON válido (sem markdown), no formato:',
      '{"questions":[{"statement":"...","explanation":"...","options":[{"text":"...","isCorrect":true},{"text":"...","isCorrect":false},{"text":"...","isCorrect":false},{"text":"...","isCorrect":false}]}]}',
    ]
      .filter(Boolean)
      .join(' ');

    let payload: unknown;
    try {
      const response = await fetch(
        `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            contents: [{ parts: [{ text: prompt }] }],
            generationConfig: { temperature: 0.7, responseMimeType: 'application/json' },
          }),
          signal: AbortSignal.timeout(30_000),
        },
      );
      if (!response.ok) {
        throw new Error(`Gemini respondeu ${response.status}`);
      }
      payload = await response.json();
    } catch (error) {
      throw new ServiceUnavailableException(
        `Falha ao gerar o quiz com IA: ${error instanceof Error ? error.message : 'erro desconhecido'}`,
      );
    }

    const questions = this.parseGeminiQuestions(payload, count);
    if (questions.length === 0) {
      throw new ServiceUnavailableException('A IA não devolveu perguntas num formato válido. Tente novamente.');
    }
    return { questions };
  }

  private parseGeminiQuestions(payload: unknown, count: number) {
    // Extrai o texto da 1ª candidatura e faz parse do JSON (tolerante a cercas ```).
    const text = (payload as any)?.candidates?.[0]?.content?.parts?.[0]?.text;
    if (typeof text !== 'string') return [];
    const cleaned = text.trim().replace(/^```(?:json)?/i, '').replace(/```$/i, '').trim();
    let parsed: any;
    try {
      parsed = JSON.parse(cleaned);
    } catch {
      return [];
    }
    const rawQuestions = Array.isArray(parsed) ? parsed : parsed?.questions;
    if (!Array.isArray(rawQuestions)) return [];
    return rawQuestions
      .slice(0, count)
      .map((q: any) => {
        const options = Array.isArray(q?.options)
          ? q.options
              .filter((o: any) => typeof o?.text === 'string' && o.text.trim())
              .map((o: any) => ({ text: String(o.text).trim(), isCorrect: o?.isCorrect === true }))
          : [];
        return {
          statement: typeof q?.statement === 'string' ? q.statement.trim() : '',
          explanation: typeof q?.explanation === 'string' ? q.explanation.trim() : '',
          points: 1,
          options,
        };
      })
      // Válida: enunciado, >=2 opções e exatamente uma correta.
      .filter(
        (q) => q.statement && q.options.length >= 2 && q.options.filter((o: { isCorrect: boolean }) => o.isCorrect).length === 1,
      );
  }

  /// Edita um quiz. Só o criador (ou um admin, via permissão no controller)
  /// pode editar. Quando `questions` é fornecido, substitui integralmente as
  /// perguntas e opções — a cascata de `onDelete: Cascade` remove as antigas.
  async update(currentUserId: string, isAdmin: boolean, id: string, dto: UpdateQuizDto) {
    const existing = await this.prisma.quiz.findFirst({
      where: { id, deletedAt: null },
      select: { createdById: true },
    });
    if (!existing) throw new NotFoundException('Quiz not found');
    if (existing.createdById !== currentUserId && !isAdmin) {
      throw new ForbiddenException('Só o criador ou um administrador pode editar este quiz.');
    }

    const { questions, ...quiz } = dto;
    return this.prisma.$transaction(async (tx) => {
      if (questions) {
        // Substituição integral: apaga as perguntas atuais (cascata remove opções).
        await tx.quizQuestion.deleteMany({ where: { quizId: id } });
      }
      return tx.quiz.update({
        where: { id },
        data: {
          ...quiz,
          questions: questions?.length
            ? {
                create: questions.map((question, questionIndex) => ({
                  statement: question.statement,
                  explanation: question.explanation,
                  points: question.points ?? 1,
                  position: questionIndex,
                  options: {
                    create: question.options.map((option, optionIndex) => ({
                      text: option.text,
                      isCorrect: option.isCorrect ?? false,
                      position: optionIndex,
                    })),
                  },
                })),
              }
            : undefined,
        },
        include: {
          category: true,
          questions: {
            orderBy: { position: 'asc' },
            include: { options: { orderBy: { position: 'asc' } } },
          },
        },
      });
    });
  }

  async start(userId: string, quizId: string) {
    const quiz = await this.prisma.quiz.findUniqueOrThrow({ where: { id: quizId }, include: { questions: true } });
    return this.prisma.quizAttempt.create({
      data: { userId, quizId, totalQuestions: quiz.questions.length },
    });
  }

  async answer(userId: string, attemptId: string, dto: AnswerDto) {
    const attempt = await this.prisma.quizAttempt.findUniqueOrThrow({ where: { id: attemptId } });
    if (attempt.userId !== userId || attempt.status !== QuizAttemptStatus.STARTED) {
      throw new ForbiddenException('Attempt is not active for this user');
    }
    const option = await this.prisma.quizOption.findUniqueOrThrow({ where: { id: dto.optionId } });
    const question = await this.prisma.quizQuestion.findUniqueOrThrow({ where: { id: dto.questionId } });
    const isCorrect = option.questionId === question.id && option.isCorrect;
    return this.prisma.userAnswer.upsert({
      where: { attemptId_questionId: { attemptId, questionId: dto.questionId } },
      update: { optionId: dto.optionId, isCorrect, pointsEarned: isCorrect ? question.points : 0 },
      create: {
        attemptId,
        userId,
        questionId: dto.questionId,
        optionId: dto.optionId,
        isCorrect,
        pointsEarned: isCorrect ? question.points : 0,
      },
    });
  }

  async submit(userId: string, attemptId: string) {
    const attempt = await this.prisma.quizAttempt.findUniqueOrThrow({ where: { id: attemptId } });
    if (attempt.userId !== userId || attempt.status !== QuizAttemptStatus.STARTED) {
      throw new ForbiddenException('Attempt is not active for this user');
    }
    const answers = await this.prisma.userAnswer.findMany({ where: { attemptId, userId } });
    const score = answers.reduce((sum, answer) => sum + answer.pointsEarned, 0);
    const submitted = await this.prisma.quizAttempt.update({
      where: { id: attemptId },
      data: { score, status: QuizAttemptStatus.SUBMITTED, submittedAt: new Date() },
    });
    void this.updateRanking(userId, attempt.quizId, score).catch(() => void 0);
    return submitted;
  }

  private async updateRanking(userId: string, quizId: string, score: number) {
    for (const [scope, scopeId] of [
      ['quiz', quizId],
      ['global', null],
    ] as [string, string | null][]) {
      const existing = await this.prisma.rankingEntry.findFirst({
        where: { userId, scope, scopeId, period: 'all' },
      });
      if (existing) {
        await this.prisma.rankingEntry.update({
          where: { id: existing.id },
          data: { score: existing.score + score, attempts: existing.attempts + 1, computedAt: new Date() },
        });
      } else {
        await this.prisma.rankingEntry.create({
          data: { userId, scope, scopeId, period: 'all', score, attempts: 1 },
        });
      }
    }
  }

  ranking(scope: string, period: string) {
    return this.prisma.rankingEntry.findMany({
      where: { scope, period },
      include: { user: { select: { id: true, name: true, avatarUrl: true, region: true, school: true } } },
      orderBy: [{ score: 'desc' }, { attempts: 'asc' }],
      take: 100,
    });
  }
}
