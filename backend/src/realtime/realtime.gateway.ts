import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import {
  ConnectedSocket,
  MessageBody,
  OnGatewayConnection,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { MembershipStatus } from '@prisma/client';
import { Server, Socket } from 'socket.io';
import { PrismaService } from '../prisma/prisma.service';

const allowedOrigins = process.env.CORS_ORIGINS?.split(',').filter(Boolean) ?? [];

@WebSocketGateway({
  namespace: 'realtime',
  cors: { origin: allowedOrigins.length > 0 ? allowedOrigins : false, credentials: true },
})
export class RealtimeGateway implements OnGatewayConnection {
  @WebSocketServer()
  server!: Server;

  constructor(
    private readonly jwtService: JwtService,
    private readonly config: ConfigService,
    private readonly prisma: PrismaService,
  ) {}

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
}
