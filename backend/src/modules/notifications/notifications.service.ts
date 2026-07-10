import { Injectable } from '@nestjs/common';
import { NotificationType } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { RealtimeGateway } from '../../realtime/realtime.gateway';

@Injectable()
export class NotificationsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly realtime: RealtimeGateway,
  ) {}

  list(userId: string) {
    return this.prisma.notification.findMany({ where: { userId }, orderBy: { createdAt: 'desc' }, take: 50 });
  }

  /// Persiste a notificação e faz *push* em tempo real ao destinatário se este
  /// tiver uma sessão realtime aberta. O push é best-effort: uma falha na
  /// emissão nunca impede a persistência (a notificação continua a aparecer no
  /// próximo carregamento da lista).
  async create(userId: string, type: NotificationType, title: string, body?: string, data?: object) {
    const notification = await this.prisma.notification.create({
      data: { userId, type, title, body, data },
    });
    try {
      this.realtime.emitNotification(userId, notification);
    } catch {
      // Emissão realtime é opcional; a notificação já ficou persistida.
    }
    return notification;
  }

  markRead(userId: string, id: string) {
    return this.prisma.notification.updateMany({ where: { id, userId }, data: { readAt: new Date() } });
  }

  markAllRead(userId: string) {
    return this.prisma.notification.updateMany({
      where: { userId, readAt: null },
      data: { readAt: new Date() },
    });
  }
}
