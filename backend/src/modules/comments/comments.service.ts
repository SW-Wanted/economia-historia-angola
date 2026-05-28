import { BadRequestException, Injectable } from '@nestjs/common';
import { CommentStatus, Visibility } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateCommentDto } from './dto/create-comment.dto';
import { CreateRoomDto } from './dto/create-room.dto';

@Injectable()
export class CommentsService {
  constructor(private readonly prisma: PrismaService) {}

  publicForContent(contentId: string) {
    return this.prisma.comment.findMany({
      where: { contentId, visibility: Visibility.PUBLIC, status: CommentStatus.VISIBLE, deletedAt: null },
      include: { author: { select: { id: true, name: true, avatarUrl: true } } },
      orderBy: { createdAt: 'asc' },
    });
  }

  create(authorId: string, dto: CreateCommentDto) {
    if (!dto.contentId && !dto.roomId) throw new BadRequestException('contentId or roomId is required');
    return this.prisma.comment.create({ data: { ...dto, authorId } });
  }

  createRoom(professorId: string, dto: CreateRoomDto) {
    return this.prisma.discussionRoom.create({
      data: {
        ...dto,
        professorId,
        participants: { create: { userId: professorId, canComment: true, canView: true } },
      },
    });
  }

  addParticipant(roomId: string, userId: string) {
    return this.prisma.discussionRoomParticipant.upsert({
      where: { roomId_userId: { roomId, userId } },
      update: { canComment: true, canView: true },
      create: { roomId, userId },
    });
  }
}
