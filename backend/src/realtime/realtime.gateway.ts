import { Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import {
  ConnectedSocket,
  MessageBody,
  OnGatewayConnection,
  OnGatewayInit,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { createAdapter } from '@socket.io/redis-adapter';
import { MembershipStatus } from '@prisma/client';
import { Redis } from 'ioredis';
import { Server, Socket } from 'socket.io';
import { PrismaService } from '../prisma/prisma.service';

const allowedOrigins = process.env.CORS_ORIGINS?.split(',').filter(Boolean) ?? [];

@WebSocketGateway({
  namespace: 'realtime',
  cors: { origin: allowedOrigins.length > 0 ? allowedOrigins : true, credentials: true },
})
export class RealtimeGateway implements OnGatewayInit, OnGatewayConnection {
  private readonly logger = new Logger(RealtimeGateway.name);

  @WebSocketServer()
  server!: Server;

  constructor(
    private readonly jwtService: JwtService,
    private readonly config: ConfigService,
    private readonly prisma: PrismaService,
  ) {}

  /// Liga o adaptador Redis quando REDIS_URL está configurado, permitindo que a
  /// emissão de eventos chegue a clientes ligados a *qualquer* instância do
  /// backend (escala horizontal). Sem Redis (ou se a ligação falhar), o
  /// Socket.IO mantém o adaptador em memória — funcional numa única instância.
  async afterInit(server: Server) {
    const url = this.config.get<string>('redisUrl');
    if (!url || url.includes('localhost')) {
      this.logger.log('Realtime a usar adaptador em memória (REDIS_URL não configurado).');
      return;
    }
    // Desiste ao fim de poucas tentativas em vez de reconectar para sempre — se
    // o Redis não estiver acessível, o realtime degrada para o adaptador em
    // memória (funcional numa única instância) sem inundar os logs.
    const options = {
      lazyConnect: true,
      maxRetriesPerRequest: 2,
      retryStrategy: (times: number) => (times > 3 ? null : Math.min(times * 200, 1000)),
    } as const;

    const pubClient = new Redis(url, options);
    const subClient = pubClient.duplicate();

    // Anexa os handlers de erro ANTES de conectar: caso contrário, uma falha de
    // ligação (ex.: DNS) emite um "unhandled error event" que derruba o processo.
    let warned = false;
    const onError = (err: Error) => {
      if (!warned) {
        warned = true;
        this.logger.warn(`Realtime sem Redis (a usar adaptador em memória): ${err.message}`);
      }
    };
    pubClient.on('error', onError);
    subClient.on('error', onError);

    try {
      await Promise.all([pubClient.connect(), subClient.connect()]);
      server.adapter(createAdapter(pubClient, subClient));
      this.logger.log('Realtime ligado ao adaptador Redis (escala multi-instância).');
    } catch (error) {
      onError(error as Error);
      pubClient.disconnect();
      subClient.disconnect();
    }
  }

  handleConnection(client: Socket) {
    const token = client.handshake.auth?.token as string | undefined;
    if (!token) {
      client.disconnect(true);
      return;
    }
    try {
      const payload = this.jwtService.verify<{ id: string }>(token, {
        secret: this.config.get<string>('jwt.accessSecret'),
      });
      client.data.userId = payload.id;
      void client.join(`user:${payload.id}`);
    } catch {
      client.disconnect(true);
    }
  }

  @SubscribeMessage('community.join')
  async joinCommunity(
    @ConnectedSocket() client: Socket,
    @MessageBody() body: { communityId: string },
  ) {
    const userId = client.data.userId as string | undefined;
    if (!userId) return { error: 'Unauthorized' };

    const membership = await this.prisma.communityMembership.findFirst({
      where: { communityId: body.communityId, userId, status: MembershipStatus.ACTIVE },
    });
    if (!membership) return { error: 'Not a member of this community' };

    void client.join(`community:${body.communityId}`);
    return { joined: true };
  }

  emitNotification(userId: string, payload: unknown) {
    this.server.to(`user:${userId}`).emit('notification.created', payload);
  }

  emitComment(scope: string, payload: unknown) {
    this.server.to(scope).emit('comment.created', payload);
  }

  /// Emite um evento arbitrário para a "sala" de um utilizador (ex.: mudança de
  /// estado de um conteúdo submetido para revisão).
  emitToUser(userId: string, event: string, payload: unknown) {
    this.server.to(`user:${userId}`).emit(event, payload);
  }
}
