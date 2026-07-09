import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { ContentStatus, MembershipStatus, NotificationType, PermissionCode, Prisma, Visibility } from '@prisma/client';
import { paginate } from '../../common/dto/pagination.dto';
import { NotificationsService } from '../notifications/notifications.service';
import { PrismaService } from '../../prisma/prisma.service';
import { ContentQueryDto } from './dto/content-query.dto';
import { CreateContentDto } from './dto/create-content.dto';

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
    // Resolve a categoria para um id escalar antes do create. O runtime do
    // Prisma Client 7 não aceita a escrita aninhada da relação `category`
    // (connect/connectOrCreate) neste modelo — apenas o campo escalar
    // `categoryId` —, pelo que fazemos o upsert da categoria em separado.
    const resolvedCategoryId = await this.resolveCategoryId(categoryId, categoryName);
    const contentData: Prisma.ContentUncheckedCreateInput = {
      ...data,
      authorId,
      categoryId: resolvedCategoryId,
      status: ContentStatus.PUBLISHED,
      publishedAt: new Date(),
    };

    return this.prisma.content.create({
      data: contentData,
      include: { author: { select: { id: true, name: true, avatarUrl: true } }, category: true },
    });
  }

  /// Devolve o id da categoria a associar: usa o id explícito quando fornecido,
  /// senão cria/reaproveita a categoria pelo nome (via slug). `undefined` quando
  /// não há categoria.
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

  async favorite(userId: string, contentId: string) {
    // Deteta se já existia para notificar o autor apenas no primeiro gosto
    // (o endpoint é idempotente — repetir não deve gerar notificações duplicadas).
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
