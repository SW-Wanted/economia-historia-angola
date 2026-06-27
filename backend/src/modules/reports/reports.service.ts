import { BadRequestException, Injectable } from '@nestjs/common';
import { CommentStatus } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateReportDto } from './dto/create-report.dto';
import { ReviewReportDto } from './dto/review-report.dto';

const AUTO_HIDE_THRESHOLD = 3;

@Injectable()
export class ReportsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(reporterId: string, dto: CreateReportDto) {
    if (!dto.communityId && !dto.topicId && !dto.replyId && !dto.commentId) {
      throw new BadRequestException('At least one report target is required');
    }
    const report = await this.prisma.report.create({ data: { ...dto, reporterId } });
    void this.autoHide(dto).catch(() => void 0);
    return report;
  }

  private async autoHide(dto: CreateReportDto) {
    const now = new Date();
    if (dto.commentId) {
      const count = await this.prisma.report.count({ where: { commentId: dto.commentId } });
      if (count >= AUTO_HIDE_THRESHOLD) {
        await this.prisma.comment.updateMany({
          where: { id: dto.commentId },
          data: { status: CommentStatus.HIDDEN },
        });
      }
    } else if (dto.replyId) {
      const count = await this.prisma.report.count({ where: { replyId: dto.replyId } });
      if (count >= AUTO_HIDE_THRESHOLD) {
        await this.prisma.topicReply.updateMany({ where: { id: dto.replyId, deletedAt: null }, data: { deletedAt: now } });
      }
    } else if (dto.topicId) {
      const count = await this.prisma.report.count({ where: { topicId: dto.topicId } });
      if (count >= AUTO_HIDE_THRESHOLD) {
        await this.prisma.topic.updateMany({ where: { id: dto.topicId, deletedAt: null }, data: { deletedAt: now } });
      }
    }
  }

  list() {
    return this.prisma.report.findMany({
      include: { reporter: { select: { id: true, name: true } } },
      orderBy: { createdAt: 'desc' },
      take: 100,
    });
  }

  review(moderatorId: string, id: string, dto: ReviewReportDto) {
    return this.prisma.report.update({ where: { id }, data: { ...dto, moderatorId } });
  }
}
