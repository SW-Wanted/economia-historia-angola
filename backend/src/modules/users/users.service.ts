import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { paginate } from '../../common/dto/pagination.dto';
import { PrismaService } from '../../prisma/prisma.service';
import { AdminListUsersDto } from './dto/admin-list-users.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { UpdateUserStatusDto } from './dto/update-user-status.dto';

const USER_PUBLIC_SELECT = {
  id: true,
  email: true,
  name: true,
  username: true,
  avatarUrl: true,
  coverUrl: true,
  bio: true,
  region: true,
  province: true,
  municipality: true,
  school: true,
  course: true,
  interests: true,
  motivation: true,
  emailVerifiedAt: true,
  createdAt: true,
  updatedAt: true,
  roles: { include: { role: true } },
  memberships: { include: { community: true } },
  subscriptions: true,
} as const;

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  findMe(id: string) {
    return this.prisma.user.findUniqueOrThrow({
      where: { id },
      select: USER_PUBLIC_SELECT,
    });
  }

  updateMe(id: string, dto: UpdateProfileDto) {
    return this.prisma.user.update({
      where: { id },
      data: dto,
      select: { id: true, email: true, name: true, username: true, avatarUrl: true, coverUrl: true, bio: true },
    });
  }

  progress(userId: string) {
    return this.prisma.progress.findMany({
      where: { userId },
      include: { content: { select: { id: true, title: true, type: true, thumbnailUrl: true } } },
      orderBy: { updatedAt: 'desc' },
    });
  }

  permissions(userId: string) {
    return this.prisma.user.findUniqueOrThrow({
      where: { id: userId },
      select: {
        roles: {
          select: {
            role: {
              select: {
                code: true,
                permissions: { select: { permission: { select: { code: true, description: true } } } },
              },
            },
          },
        },
      },
    });
  }

  favorites(userId: string) {
    return this.prisma.favorite.findMany({
      where: { userId },
      include: { content: { select: { id: true, title: true, type: true, thumbnailUrl: true, slug: true } } },
      orderBy: { createdAt: 'desc' },
    });
  }

  /**
   * Estatísticas agregadas do perfil (secção "O Meu Progresso").
   * - points: pontuação global acumulada (ranking global 'all').
   * - rank: posição global (nº de utilizadores com pontuação superior + 1);
   *   `null` se o utilizador ainda não tem entrada no ranking.
   * - contentsCompleted: conteúdos com progresso concluído.
   * - quizzesTaken: tentativas de quiz submetidas.
   */
  async stats(userId: string) {
    const [globalEntry, contentsCompleted, quizzesTaken] = await Promise.all([
      this.prisma.rankingEntry.findFirst({
        where: { userId, scope: 'global', scopeId: null, period: 'all' },
      }),
      this.prisma.progress.count({ where: { userId, completedAt: { not: null } } }),
      this.prisma.quizAttempt.count({ where: { userId, status: 'SUBMITTED' } }),
    ]);

    const points = globalEntry?.score ?? 0;
    const rank =
      globalEntry === null
        ? null
        : (await this.prisma.rankingEntry.count({
            where: { scope: 'global', scopeId: null, period: 'all', score: { gt: points } },
          })) + 1;

    return { points, rank, contentsCompleted, quizzesTaken };
  }

  async listAll(dto: AdminListUsersDto) {
    const where = {
      deletedAt: null,
      isActive: dto.isActive,
      name: dto.search ? { contains: dto.search, mode: 'insensitive' as const } : undefined,
    };
    const [items, total] = await this.prisma.$transaction([
      this.prisma.user.findMany({
        where,
        ...paginate(dto),
        orderBy: { createdAt: 'desc' },
        select: {
          id: true,
          email: true,
          name: true,
          username: true,
          isActive: true,
          createdAt: true,
          roles: { include: { role: { select: { code: true } } } },
        },
      }),
      this.prisma.user.count({ where }),
    ]);
    return { items, total, page: dto.page, limit: dto.limit };
  }

  async updateStatus(actorId: string, targetId: string, dto: UpdateUserStatusDto) {
    if (actorId === targetId) {
      throw new ForbiddenException('Cannot change your own account status');
    }
    const target = await this.prisma.user.findUnique({ where: { id: targetId } });
    if (!target) throw new NotFoundException('User not found');

    return this.prisma.user.update({
      where: { id: targetId },
      data: { isActive: dto.isActive },
      select: { id: true, email: true, name: true, isActive: true },
    });
  }
}
