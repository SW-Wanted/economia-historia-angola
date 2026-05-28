import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { SyncQueryDto } from './dto/sync-query.dto';

@Injectable()
export class SyncService {
  constructor(private readonly prisma: PrismaService) {}

  async changes(userId: string, query: SyncQueryDto) {
    const since = query.since ? new Date(query.since) : new Date(0);
    const [contents, notifications] = await this.prisma.$transaction([
      this.prisma.content.findMany({
        where: { updatedAt: { gt: since }, deletedAt: null },
        orderBy: { updatedAt: 'asc' },
        take: 200,
      }),
      this.prisma.notification.findMany({
        where: { userId, createdAt: { gt: since } },
        orderBy: { createdAt: 'asc' },
        take: 200,
      }),
    ]);
    return {
      serverTime: new Date().toISOString(),
      changes: { contents, notifications },
      strategy: 'incremental-pull; clients keep per-scope cursors and retry idempotently',
    };
  }
}
