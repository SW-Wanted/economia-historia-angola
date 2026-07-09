import { Injectable } from '@nestjs/common';
import { NotificationType, Visibility } from '@prisma/client';
import { PaginationDto, paginate } from '../../common/dto/pagination.dto';
import { NotificationsService } from '../notifications/notifications.service';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateForumDto } from './dto/create-forum.dto';
import { CreateReplyDto } from './dto/create-reply.dto';
import { CreateTopicDto } from './dto/create-topic.dto';

@Injectable()
export class ForumsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly notifications: NotificationsService,
  ) {}

  listPublicForums() {
    return this.prisma.forum.findMany({ where: { visibility: Visibility.PUBLIC, deletedAt: null } });
  }

  listPublicTopics(forumId: string) {
    return this.prisma.topic.findMany({
      where: { forumId, visibility: Visibility.PUBLIC, deletedAt: null },
      include: { author: { select: { id: true, name: true, avatarUrl: true } }, _count: { select: { replies: true } } },
      orderBy: { createdAt: 'desc' },
    });
  }

  createForum(dto: CreateForumDto) {
    return this.prisma.forum.create({ data: dto });
  }

  createTopic(authorId: string, forumId: string, dto: CreateTopicDto) {
    return this.prisma.topic.create({ data: { ...dto, authorId, forumId } });
  }

  async reply(authorId: string, topicId: string, dto: CreateReplyDto) {
    const created = await this.prisma.topicReply.create({ data: { ...dto, authorId, topicId } });
    void this.notifyTopicAuthor(topicId, authorId).catch(() => void 0);
    return created;
  }

  async listReplies(topicId: string, query: PaginationDto) {
    const [items, total] = await this.prisma.$transaction([
      this.prisma.topicReply.findMany({
        where: { topicId, deletedAt: null },
        ...paginate(query),
        orderBy: { createdAt: 'asc' },
        include: { author: { select: { id: true, name: true, avatarUrl: true } } },
      }),
      this.prisma.topicReply.count({ where: { topicId, deletedAt: null } }),
    ]);
    return { items, total, page: query.page, limit: query.limit };
  }

  private async notifyTopicAuthor(topicId: string, replyAuthorId: string) {
    const topic = await this.prisma.topic.findUnique({
      where: { id: topicId },
      select: { authorId: true, title: true },
    });
    if (topic && topic.authorId !== replyAuthorId) {
      await this.notifications.create(
        topic.authorId,
        NotificationType.FORUM,
        'Nova resposta no seu tópico',
        `Recebeu uma nova resposta no tópico "${topic.title}"`,
      );
    }
  }
}
