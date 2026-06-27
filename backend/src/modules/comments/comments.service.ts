import { BadRequestException, ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { CommentStatus, NotificationType, Visibility } from '@prisma/client';
import { NotificationsService } from '../notifications/notifications.service';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateCommentDto } from './dto/create-comment.dto';
import { CreateRoomDto } from './dto/create-room.dto';

@Injectable()
export class CommentsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly notifications: NotificationsService,
  ) {}

  publicForContent(contentId: string) {
    return this.prisma.comment.findMany({
      where: { contentId, visibility: Visibility.PUBLIC, status: CommentStatus.VISIBLE, deletedAt: null },
      include: { author: { select: { id: true, name: true, avatarUrl: true } } },
      orderBy: { createdAt: 'asc' },
    });
  }

  async roomComments(userId: string, roomId: string) {
    const participant = await this.prisma.discussionRoomParticipant.findUnique({
      where: { roomId_userId: { roomId, userId } },
    });
    if (!participant?.canView) {
      throw new ForbiddenException('You do not have access to this room');
    }
    return this.prisma.comment.findMany({
      where: { roomId, status: CommentStatus.VISIBLE, deletedAt: null },
      include: { author: { select: { id: true, name: true, avatarUrl: true } } },
      orderBy: { createdAt: 'asc' },
    });
  }

  async create(authorId: string, dto: CreateCommentDto) {
    if (!dto.contentId && !dto.roomId) throw new BadRequestException('contentId or roomId is required');
    if (dto.roomId) {
      const participant = await this.prisma.discussionRoomParticipant.findUnique({
        where: { roomId_userId: { roomId: dto.roomId, userId: authorId } },
      });
      if (!participant?.canComment) {
        throw new ForbiddenException('You do not have permission to comment in this room');
      }
    }
    const created = await this.prisma.comment.create({ data: { ...dto, authorId } });
    if (dto.parentId) {
      void this.notifyParentAuthor(dto.parentId, authorId).catch(() => void 0);
    }
    return created;
  }

  createRoom(professorId: string, dto: CreateRoomDto) {
    return this.prisma.discussionRoom.create({
      data: {
        ...dto,
        professorId,
        visibility: Visibility.PRIVATE,
        participants: { create: { userId: professorId, canComment: true, canView: true } },
      },
    });
  }

  async addParticipant(currentUserId: string, roomId: string, targetUserId: string) {
    const room = await this.prisma.discussionRoom.findUnique({ where: { id: roomId } });
    if (!room) throw new NotFoundException('Room not found');
    if (room.professorId !== currentUserId) {
      throw new ForbiddenException('Only the room professor can manage participants');
    }
    return this.prisma.discussionRoomParticipant.upsert({
      where: { roomId_userId: { roomId, userId: targetUserId } },
      update: { canComment: true, canView: true },
      create: { roomId, userId: targetUserId },
    });
  }

  private async notifyParentAuthor(parentId: string, replyAuthorId: string) {
    const parent = await this.prisma.comment.findUnique({ where: { id: parentId }, select: { authorId: true } });
    if (parent && parent.authorId !== replyAuthorId) {
      await this.notifications.create(
        parent.authorId,
        NotificationType.COMMENT,
        'Nova resposta ao seu comentário',
      );
    }
  }
}
