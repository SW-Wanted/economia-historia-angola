import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { QuizAttemptStatus, Visibility } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { AnswerDto } from './dto/answer.dto';
import { CreateQuizDto } from './dto/create-quiz.dto';

@Injectable()
export class QuizzesService {
  constructor(private readonly prisma: PrismaService) {}

  listPublic() {
    return this.prisma.quiz.findMany({
      where: { visibility: Visibility.PUBLIC, deletedAt: null },
      include: { category: true, _count: { select: { questions: true, attempts: true } } },
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

  create(createdById: string, dto: CreateQuizDto) {
    return this.prisma.quiz.create({ data: { ...dto, createdById } });
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
