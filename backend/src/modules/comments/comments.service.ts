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
    } else if (dto.contentId) {
      // Comentário de topo num conteúdo: avisa o autor do conteúdo.
      void this.notifyContentAuthor(dto.contentId, authorId).catch(() => void 0);
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

  /// Salas privadas do utilizador: onde é professor OU participante. Inclui a
  /// contagem de participantes e se o utilizador é o dono (professor).
  async listRooms(userId: string) {
    const rooms = await this.prisma.discussionRoom.findMany({
      where: {
        deletedAt: null,
        OR: [{ professorId: userId }, { participants: { some: { userId } } }],
      },
      include: { _count: { select: { participants: true, comments: true } } },
      orderBy: { updatedAt: 'desc' },
    });
    return rooms.map((room) => ({ ...room, isOwner: room.professorId === userId }));
  }

  /// Detalhe de uma sala (com participantes). Só acessível a quem participa.
  async roomDetail(userId: string, roomId: string) {
    const participant = await this.prisma.discussionRoomParticipant.findUnique({
      where: { roomId_userId: { roomId, userId } },
    });
    if (!participant?.canView) {
      throw new ForbiddenException('You do not have access to this room');
    }
    const room = await this.prisma.discussionRoom.findFirst({
      where: { id: roomId, deletedAt: null },
      include: {
        participants: {
          include: { user: { select: { id: true, name: true, avatarUrl: true } } },
        },
      },
    });
    if (!room) throw new NotFoundException('Room not found');
    return { ...room, isOwner: room.professorId === userId };
  }

  /// Adiciona um participante pelo email (o frontend não conhece userIds).
  /// Só o professor da sala. 404 se o email não corresponder a um utilizador.
  async inviteParticipantByEmail(currentUserId: string, roomId: string, email: string) {
    const room = await this.prisma.discussionRoom.findUnique({ where: { id: roomId } });
    if (!room) throw new NotFoundException('Room not found');
    if (room.professorId !== currentUserId) {
      throw new ForbiddenException('Only the room professor can manage participants');
    }
    const user = await this.prisma.user.findUnique({ where: { email }, select: { id: true } });
    if (!user) throw new NotFoundException('Não existe um utilizador com esse email.');
    const created = await this.prisma.discussionRoomParticipant.upsert({
      where: { roomId_userId: { roomId, userId: user.id } },
      update: { canComment: true, canView: true },
      create: { roomId, userId: user.id },
    });
    void this.notifications
      .create(user.id, NotificationType.COMMENT, 'Adicionado a uma sala privada', `Foi adicionado à sala "${room.name}"`, {
        roomId,
      })
      .catch(() => void 0);
    return created;
  }

  /// Remove um participante (só o professor). O próprio professor não é removível.
  async removeParticipant(currentUserId: string, roomId: string, targetUserId: string) {
    const room = await this.prisma.discussionRoom.findUnique({ where: { id: roomId } });
    if (!room) throw new NotFoundException('Room not found');
    if (room.professorId !== currentUserId) {
      throw new ForbiddenException('Only the room professor can manage participants');
    }
    if (targetUserId === room.professorId) {
      throw new ForbiddenException('O professor da sala não pode ser removido.');
    }
    await this.prisma.discussionRoomParticipant.deleteMany({ where: { roomId, userId: targetUserId } });
    return { removed: true };
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

  private async notifyContentAuthor(contentId: string, commentAuthorId: string) {
    const content = await this.prisma.content.findUnique({
      where: { id: contentId },
      select: { authorId: true, title: true },
    });
    if (content && content.authorId !== commentAuthorId) {
      await this.notifications.create(
        content.authorId,
        NotificationType.COMMENT,
        'Novo comentário no seu conteúdo',
        `Recebeu um comentário em "${content.title}"`,
        { contentId },
      );
    }
  }
}
