import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { ContentStatus, MembershipStatus, NotificationType, PermissionCode, Prisma, Visibility } from '@prisma/client';
import { AuthUser } from '../../common/decorators/current-user.decorator';
import { paginate } from '../../common/dto/pagination.dto';
import { NotificationsService } from '../notifications/notifications.service';
import { PrismaService } from '../../prisma/prisma.service';
import { ContentQueryDto } from './dto/content-query.dto';
import { CreateContentDto } from './dto/create-content.dto';

const MANAGE_INCLUDE = {
  category: true,
  author: { select: { id: true, name: true } },
  _count: { select: { views: true } },
} satisfies Prisma.ContentInclude;

@Injectable()
export class ContentsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly notifications: NotificationsService,
  ) {}

  async listPublic(query: ContentQueryDto) {
    const where = {
      status: ContentStatus.PUBLISHED,
      visibility: { in: [Visibility.PUBLIC, Visibility.AUTHENTICATED] },
      deletedAt: null,
      type: query.type,
      categoryId: query.categoryId,
      title: query.search ? { contains: query.search, mode: 'insensitive' as const } : undefined,
    };
    const [items, total] = await this.prisma.$transaction([
      this.prisma.content.findMany({
        where,
        ...paginate(query),
        orderBy: { publishedAt: 'desc' },
        include: { author: { select: { id: true, name: true, avatarUrl: true } }, category: true, tags: { include: { tag: true } } },
      }),
      this.prisma.content.count({ where }),
    ]);
    return { items, total, page: query.page, limit: query.limit };
  }

  async findPublic(id: string) {
    const content = await this.prisma.content.findFirst({
      where: { id, status: ContentStatus.PUBLISHED, visibility: Visibility.PUBLIC, deletedAt: null },
      include: {
        author: { select: { id: true, name: true, avatarUrl: true } },
        category: true,
        tags: { include: { tag: true } },
        comments: { where: { deletedAt: null } },
      },
    });
    if (!content) throw new NotFoundException('Content not found or not public');
    return content;
  }

  async findAuthorized(userId: string, contentId: string, userPermissions: PermissionCode[]) {
    const content = await this.prisma.content.findFirst({
      where: { id: contentId, status: ContentStatus.PUBLISHED, deletedAt: null },
      include: { author: { select: { id: true, name: true, avatarUrl: true } }, category: true, tags: { include: { tag: true } } },
    });
    if (!content) throw new NotFoundException('Content not found');

    const openVisibilities: Visibility[] = [Visibility.PUBLIC, Visibility.AUTHENTICATED];
    if (openVisibilities.includes(content.visibility) && !content.isJindungo) {
      return content;
    }

    if (userPermissions.includes(PermissionCode.JINDUNGO_ACCESS)) {
      return content;
    }

    const approved = await this.prisma.accessRequest.findFirst({
      where: {
        userId,
        contentId,
        permission: PermissionCode.JINDUNGO_ACCESS,
        status: MembershipStatus.ACTIVE,
      },
    });
    if (!approved) {
      throw new ForbiddenException('Access to this content requires explicit authorization');
    }
    return content;
  }

  async create(authorId: string, dto: CreateContentDto) {
    if (dto.isJindungo && dto.visibility === Visibility.PUBLIC) {
      throw new ForbiddenException('Textos com Jindungo require controlled access');
    }
    const { categoryName, categoryId, ...data } = dto;
    const resolvedCategoryId = await this.resolveCategoryId(categoryId, categoryName);
    const contentData: Prisma.ContentUncheckedCreateInput = {
      ...data,
      authorId,
      categoryId: resolvedCategoryId,
      status: ContentStatus.DRAFT,
    };

    return this.prisma.content.create({
      data: contentData,
      include: { author: { select: { id: true, name: true, avatarUrl: true } }, category: true },
    });
  }

  private async resolveCategoryId(categoryId?: string, categoryName?: string) {
    if (categoryId) return categoryId;

    const normalized = categoryName?.trim();
    if (!normalized) return undefined;

    const slug = this.slugFor(normalized);
    const category = await this.prisma.category.upsert({
      where: { slug },
      update: {},
      create: { name: normalized, slug },
    });
    return category.id;
  }

  private slugFor(value: string) {
    const slug = value
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '');
    return slug || 'conteudo';
  }

  async listForManagement(user: AuthUser, query: ContentQueryDto) {
    const perms = user.permissions as PermissionCode[];
    const canSeeAll =
      perms.includes(PermissionCode.CONTENT_APPROVE) || perms.includes(PermissionCode.CONTENT_PUBLISH);

    const where: Prisma.ContentWhereInput = {
      deletedAt: null,
      status: query.status,
      type: query.type,
      categoryId: query.categoryId,
      title: query.search ? { contains: query.search, mode: 'insensitive' } : undefined,
      ...(canSeeAll ? {} : { authorId: user.id }),
    };

    const [items, total] = await this.prisma.$transaction([
      this.prisma.content.findMany({
        where,
        ...paginate(query),
        orderBy: { updatedAt: 'desc' },
        include: MANAGE_INCLUDE,
      }),
      this.prisma.content.count({ where }),
    ]);
    return { items, total, page: query.page, limit: query.limit };
  }

  async changeStatus(user: AuthUser, id: string, status: ContentStatus) {
    const content = await this.prisma.content.findFirst({ where: { id, deletedAt: null } });
    if (!content) throw new NotFoundException('Conteúdo não encontrado.');

    const perms = user.permissions as PermissionCode[];
    const isOwner = content.authorId === user.id;
    const canApprove = perms.includes(PermissionCode.CONTENT_APPROVE);
    const canPublish = perms.includes(PermissionCode.CONTENT_PUBLISH);
    const deny = () => {
      throw new ForbiddenException('Não tem permissão para esta transição de estado.');
    };

    switch (status) {
      case ContentStatus.PENDING_REVIEW:
        if (!(isOwner || canApprove || canPublish)) deny();
        break;
      case ContentStatus.PUBLISHED:
      case ContentStatus.REJECTED:
        if (!(canApprove || canPublish)) deny();
        break;
      case ContentStatus.ARCHIVED:
        if (!(canPublish || isOwner)) deny();
        break;
      case ContentStatus.DRAFT:
        if (!(isOwner || canPublish)) deny();
        break;
      default:
        deny();
    }

    const data: Prisma.ContentUpdateInput = { status };
    if (status === ContentStatus.PUBLISHED && !content.publishedAt) {
      data.publishedAt = new Date();
    }
    if (status !== ContentStatus.PUBLISHED) {
      data.publishedAt = null;
    }

    return this.prisma.content.update({ where: { id }, data, include: MANAGE_INCLUDE });
  }

  async remove(user: AuthUser, id: string) {
    const content = await this.prisma.content.findFirst({ where: { id, deletedAt: null } });
    if (!content) throw new NotFoundException('Conteúdo não encontrado.');

    const perms = user.permissions as PermissionCode[];
    const isOwner = content.authorId === user.id;
    if (!isOwner && !perms.includes(PermissionCode.CONTENT_DELETE)) {
      throw new ForbiddenException('Não tem permissão para remover este conteúdo.');
    }

    await this.prisma.content.update({ where: { id }, data: { deletedAt: new Date() } });
    return { id, deleted: true };
  }

  async favorite(userId: string, contentId: string) {
    const existing = await this.prisma.favorite.findUnique({
      where: { userId_contentId: { userId, contentId } },
      select: { createdAt: true },
    });
    const favorite = await this.prisma.favorite.upsert({
      where: { userId_contentId: { userId, contentId } },
      update: {},
      create: { userId, contentId },
    });
    if (!existing) {
      void this.notifyContentAuthorOfLike(contentId, userId).catch(() => void 0);
    }
    return favorite;
  }

  private async notifyContentAuthorOfLike(contentId: string, likerId: string) {
    const content = await this.prisma.content.findUnique({
      where: { id: contentId },
      select: { authorId: true, title: true },
    });
    if (content && content.authorId !== likerId) {
      await this.notifications.create(
        content.authorId,
        NotificationType.CONTENT,
        'Novo gosto no seu conteúdo',
        `Alguém gostou de "${content.title}"`,
        { contentId },
      );
    }
  }

  progress(userId: string, contentId: string, percentage: number) {
    return this.prisma.progress.upsert({
      where: { userId_contentId: { userId, contentId } },
      update: { percentage },
      create: { userId, contentId, percentage },
    });
  }

  requestJindungoAccess(userId: string, contentId: string) {
    return this.prisma.accessRequest.create({
      data: { userId, contentId, permission: PermissionCode.JINDUNGO_ACCESS },
    });
  }
}
