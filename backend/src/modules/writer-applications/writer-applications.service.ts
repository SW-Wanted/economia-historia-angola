import {
  BadRequestException,
  ConflictException,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { RoleCode, WriterApplicationStatus } from '@prisma/client';
import { paginate } from '../../common/dto/pagination.dto';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateWriterApplicationDto } from './dto/create-writer-application.dto';
import { ListWriterApplicationsDto } from './dto/list-writer-applications.dto';
import { ReviewWriterApplicationDto } from './dto/review-writer-application.dto';

const APPLICATION_INCLUDE = {
  user: { select: { id: true, name: true, email: true } },
  reviewer: { select: { id: true, name: true } },
} as const;

@Injectable()
export class WriterApplicationsService {
  constructor(private readonly prisma: PrismaService) {}

  async apply(userId: string, dto: CreateWriterApplicationDto) {
    const existing = await this.prisma.writerApplication.findUnique({ where: { userId } });
    if (existing) {
      if (existing.status === WriterApplicationStatus.APPROVED) {
        throw new ConflictException('Your writer application has already been approved');
      }
      if (existing.status === WriterApplicationStatus.PENDING || existing.status === WriterApplicationStatus.REQUEST_CHANGES) {
        throw new ConflictException('You already have an active application. Use /writer-applications/me/resubmit if changes were requested');
      }
      // REJECTED: replace with a fresh application
      await this.prisma.writerApplication.delete({ where: { userId } });
    }
    return this.prisma.writerApplication.create({ data: { ...dto, userId } });
  }

  async findMine(userId: string) {
    const app = await this.prisma.writerApplication.findUnique({
      where: { userId },
      include: APPLICATION_INCLUDE,
    });
    if (!app) throw new NotFoundException('No writer application found for this account');
    return app;
  }

  async resubmit(userId: string, dto: CreateWriterApplicationDto) {
    const app = await this.prisma.writerApplication.findUnique({ where: { userId } });
    if (!app) throw new NotFoundException('No writer application found');
    if (app.status !== WriterApplicationStatus.REQUEST_CHANGES) {
      throw new BadRequestException('Application can only be resubmitted when status is REQUEST_CHANGES');
    }
    return this.prisma.writerApplication.update({
      where: { userId },
      data: {
        ...dto,
        status: WriterApplicationStatus.PENDING,
        reviewNotes: null,
        rejectionReason: null,
        reviewedBy: null,
        reviewedAt: null,
      },
    });
  }

  async listAll(query: ListWriterApplicationsDto) {
    const where = query.status ? { status: query.status } : {};
    const [items, total] = await this.prisma.$transaction([
      this.prisma.writerApplication.findMany({
        where,
        ...paginate(query),
        orderBy: { submittedAt: 'desc' },
        include: APPLICATION_INCLUDE,
      }),
      this.prisma.writerApplication.count({ where }),
    ]);
    return { items, total, page: query.page, limit: query.limit };
  }

  async findOne(id: string) {
    const app = await this.prisma.writerApplication.findUnique({
      where: { id },
      include: APPLICATION_INCLUDE,
    });
    if (!app) throw new NotFoundException('Writer application not found');
    return app;
  }

  async review(adminId: string, id: string, dto: ReviewWriterApplicationDto) {
    const app = await this.prisma.writerApplication.findUnique({ where: { id } });
    if (!app) throw new NotFoundException('Writer application not found');
    if (app.status !== WriterApplicationStatus.PENDING) {
      throw new BadRequestException('Only PENDING applications can be reviewed');
    }

    const updated = await this.prisma.writerApplication.update({
      where: { id },
      data: {
        status: dto.decision,
        reviewedBy: adminId,
        reviewedAt: new Date(),
        reviewNotes: dto.notes ?? null,
        rejectionReason: dto.rejectionReason ?? null,
      },
      include: APPLICATION_INCLUDE,
    });

    if (dto.decision === WriterApplicationStatus.APPROVED) {
      await this.assignWriterRole(app.userId, adminId);
    }

    return updated;
  }

  private async assignWriterRole(userId: string, grantedBy: string) {
    const writerRole = await this.prisma.role.findUnique({ where: { code: RoleCode.WRITER } });
    if (!writerRole) {
      throw new InternalServerErrorException('WRITER role not found in database. Run seed first.');
    }
    await this.prisma.userRole.upsert({
      where: { userId_roleId: { userId, roleId: writerRole.id } },
      create: { userId, roleId: writerRole.id, grantedBy },
      update: {},
    });
  }
}
