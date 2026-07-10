import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { RoleCode } from '@prisma/client';
import { AuthUser } from '../../common/decorators/current-user.decorator';
import { paginate } from '../../common/dto/pagination.dto';
import { PrismaService } from '../../prisma/prisma.service';
import { AdminListUsersDto } from './dto/admin-list-users.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { UpdateUserStatusDto } from './dto/update-user-status.dto';

const ADMIN_USER_SELECT = {
  id: true,
  email: true,
  name: true,
  username: true,
  isActive: true,
  createdAt: true,
  roles: { include: { role: { select: { code: true } } } },
} as const;

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
  superAdminGrade: true,
  createdAt: true,
  updatedAt: true,
  roles: { include: { role: true } },
  memberships: { include: { community: true } },
  subscriptions: true,
} as const;

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  /// Ordena a antiguidade de um Super Admin pela sua "grade": 0 = fundador (mais
  /// sénior), valores maiores = menos sénior. Um Super Admin sem grade definida
  /// é tratado como o menos sénior de todos. Devolve `null` para quem não é
  /// Super Admin (não participa nesta hierarquia).
  private superAdminSeniority(roles: readonly string[], grade: number | null | undefined): number | null {
    if (!roles.includes(RoleCode.SUPER_ADMIN)) return null;
    return grade ?? Number.MAX_SAFE_INTEGER;
  }

  /// Verifica se `actor` pode gerir (alterar/remover/suspender) o `target`,
  /// aplicando a hierarquia de papéis e de grades entre Super Admins:
  /// - Um Super Admin só pode agir sobre outro Super Admin se for estritamente
  ///   mais sénior (grade menor). Isto impede que pares ou subordinados se
  ///   modifiquem entre si, e protege o fundador (grade 0).
  /// - Só um Super Admin pode gerir um Admin.
  /// - Ninguém que não seja Super Admin pode gerir um Super Admin.
  private assertCanManage(
    actor: AuthUser,
    targetRoles: readonly string[],
    targetGrade: number | null,
    action: string,
  ) {
    const actorIsSuperAdmin = actor.roles.includes(RoleCode.SUPER_ADMIN);
    const targetSeniority = this.superAdminSeniority(targetRoles, targetGrade);

    if (targetSeniority !== null) {
      // Alvo é Super Admin: exige um ator Super Admin estritamente mais sénior.
      const actorSeniority = this.superAdminSeniority(actor.roles, actor.superAdminGrade);
      if (actorSeniority === null || actorSeniority >= targetSeniority) {
        throw new ForbiddenException(
          `Não tem antiguidade suficiente para ${action} este Super Administrador.`,
        );
      }
      return;
    }

    if (targetRoles.includes(RoleCode.ADMIN) && !actorIsSuperAdmin) {
      throw new ForbiddenException(`Apenas um Super Administrador pode ${action} um Administrador.`);
    }
  }

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
          superAdminGrade: true,
          region: true,
          school: true,
          createdAt: true,
          roles: { include: { role: { select: { code: true } } } },
        },
      }),
      this.prisma.user.count({ where }),
    ]);
    return { items, total, page: dto.page, limit: dto.limit };
  }

  async updateStatus(actor: AuthUser, targetId: string, dto: UpdateUserStatusDto) {
    if (actor.id === targetId) {
      throw new ForbiddenException('Cannot change your own account status');
    }
    const target = await this.prisma.user.findFirst({
      where: { id: targetId, deletedAt: null },
      include: { roles: { include: { role: true } } },
    });
    if (!target) throw new NotFoundException('User not found');

    const targetRoles = target.roles.map((r) => r.role.code);
    this.assertCanManage(actor, targetRoles, target.superAdminGrade, 'suspender ou reativar');

    return this.prisma.user.update({
      where: { id: targetId },
      data: { isActive: dto.isActive },
      select: { id: true, email: true, name: true, isActive: true },
    });
  }

  /**
   * Promove ou despromove um utilizador, substituindo o seu papel pelo indicado.
   * Regras: nunca é possível modificar um SUPER_ADMIN; apenas um SUPER_ADMIN pode
   * conceder ou retirar papéis de nível administrativo (ADMIN/SUPER_ADMIN).
   */
  async setRole(actor: AuthUser, targetId: string, role: RoleCode) {
    if (actor.id === targetId) {
      throw new ForbiddenException('Não pode alterar o seu próprio papel.');
    }
    const target = await this.prisma.user.findFirst({
      where: { id: targetId, deletedAt: null },
      include: { roles: { include: { role: true } } },
    });
    if (!target) throw new NotFoundException('Utilizador não encontrado.');

    const targetRoles = target.roles.map((r) => r.role.code);
    const actorIsSuperAdmin = actor.roles.includes(RoleCode.SUPER_ADMIN);

    // Hierarquia de papéis/grades sobre o alvo (protege Super Admins mais séniores).
    this.assertCanManage(actor, targetRoles, target.superAdminGrade, 'gerir o papel de');

    // Conceder um papel administrativo exige que o ator seja Super Admin.
    const grantsAdminLevel = role === RoleCode.ADMIN || role === RoleCode.SUPER_ADMIN;
    if (grantsAdminLevel && !actorIsSuperAdmin) {
      throw new ForbiddenException('Apenas um Super Administrador pode gerir papéis de administrador.');
    }

    const roleRecord = await this.prisma.role.findUnique({ where: { code: role } });
    if (!roleRecord) throw new NotFoundException('Papel não encontrado.');

    await this.prisma.$transaction([
      this.prisma.userRole.deleteMany({ where: { userId: targetId } }),
      this.prisma.userRole.create({
        data: { userId: targetId, roleId: roleRecord.id, grantedBy: actor.id },
      }),
    ]);

    return this.prisma.user.findUniqueOrThrow({ where: { id: targetId }, select: ADMIN_USER_SELECT });
  }

  /**
   * Remove (soft-delete) a conta de um utilizador.
   * Regras: nunca remover um SUPER_ADMIN; apenas um SUPER_ADMIN pode remover um ADMIN.
   */
  async removeUser(actor: AuthUser, targetId: string) {
    if (actor.id === targetId) {
      throw new ForbiddenException('Não pode remover a sua própria conta.');
    }
    const target = await this.prisma.user.findFirst({
      where: { id: targetId, deletedAt: null },
      include: { roles: { include: { role: true } } },
    });
    if (!target) throw new NotFoundException('Utilizador não encontrado.');

    const targetRoles = target.roles.map((r) => r.role.code);
    this.assertCanManage(actor, targetRoles, target.superAdminGrade, 'remover');

    return this.prisma.user.update({
      where: { id: targetId },
      data: { deletedAt: new Date(), isActive: false },
      select: { id: true, email: true, name: true, isActive: true },
    });
  }
}
