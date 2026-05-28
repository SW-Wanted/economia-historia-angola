import { Injectable } from '@nestjs/common';
import { Visibility } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateReplyDto } from './dto/create-reply.dto';
import { CreateTopicDto } from './dto/create-topic.dto';

@Injectable()
export class ForumsService {
  constructor(private readonly prisma: PrismaService) {}

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

  createTopic(authorId: string, forumId: string, dto: CreateTopicDto) {
    return this.prisma.topic.create({ data: { ...dto, authorId, forumId } });
  }

  reply(authorId: string, topicId: string, dto: CreateReplyDto) {
    return this.prisma.topicReply.create({ data: { ...dto, authorId, topicId } });
  }
}
