import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { ContentStatus, MembershipStatus, PermissionCode, Visibility } from '@prisma/client';
import { paginate } from '../../common/dto/pagination.dto';
import { PrismaService } from '../../prisma/prisma.service';
import { ContentQueryDto } from './dto/content-query.dto';
import { CreateContentDto } from './dto/create-content.dto';

@Injectable()
export class ContentsService {
  constructor(private readonly prisma: PrismaService) {}

  async listPublic(query: ContentQueryDto) {
    const where = {
      status: ContentStatus.PUBLISHED,
      visibility: Visibility.PUBLIC,
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
        include: { category: true, tags: { include: { tag: true } } },
      }),
      this.prisma.content.count({ where }),
    ]);
    return { items, total, page: query.page, limit: query.limit };
  }

  async findPublic(id: string) {
    const content = await this.prisma.content.findFirst({
      where: { id, status: ContentStatus.PUBLISHED, visibility: Visibility.PUBLIC, deletedAt: null },
      include: { category: true, tags: { include: { tag: true } }, comments: { where: { deletedAt: null } } },
    });
    if (!content) throw new NotFoundException('Content not found or not public');
    return content;
  }

  async findAuthorized(userId: string, contentId: string, userPermissions: PermissionCode[]) {
    const content = await this.prisma.content.findFirst({
      where: { id: contentId, status: ContentStatus.PUBLISHED, deletedAt: null },
      include: { category: true, tags: { include: { tag: true } } },
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

  create(authorId: string, dto: CreateContentDto) {
    if (dto.isJindungo && dto.visibility === Visibility.PUBLIC) {
      throw new ForbiddenException('Textos com Jindungo require controlled access');
    }
    return this.prisma.content.create({ data: { ...dto, authorId } });
  }

  favorite(userId: string, contentId: string) {
    return this.prisma.favorite.upsert({
      where: { userId_contentId: { userId, contentId } },
      update: {},
      create: { userId, contentId },
    });
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
