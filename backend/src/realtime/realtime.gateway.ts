import {
  ConnectedSocket,
  MessageBody,
  OnGatewayConnection,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';

@WebSocketGateway({ namespace: 'realtime', cors: { origin: '*' } })
export class RealtimeGateway implements OnGatewayConnection {
  @WebSocketServer()
  server!: Server;

  handleConnection(client: Socket) {
    const userId = client.handshake.auth?.userId;
    if (userId) void client.join(`user:${userId}`);
  }

  @SubscribeMessage('community.join')
  joinCommunity(@ConnectedSocket() client: Socket, @MessageBody() body: { communityId: string }) {
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
