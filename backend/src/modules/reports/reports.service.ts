import { BadRequestException, Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateReportDto } from './dto/create-report.dto';
import { ReviewReportDto } from './dto/review-report.dto';

@Injectable()
export class ReportsService {
  constructor(private readonly prisma: PrismaService) {}

  create(reporterId: string, dto: CreateReportDto) {
    if (!dto.communityId && !dto.topicId && !dto.replyId && !dto.commentId) {
      throw new BadRequestException('At least one report target is required');
    }
    return this.prisma.report.create({ data: { ...dto, reporterId } });
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
