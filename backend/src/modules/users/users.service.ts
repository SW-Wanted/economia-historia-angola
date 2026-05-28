import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { UpdateProfileDto } from './dto/update-profile.dto';

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  findMe(id: string) {
    return this.prisma.user.findUniqueOrThrow({
      where: { id },
      select: {
        id: true,
        email: true,
        name: true,
        username: true,
        avatarUrl: true,
        bio: true,
        region: true,
        province: true,
        municipality: true,
        school: true,
        emailVerifiedAt: true,
        createdAt: true,
        updatedAt: true,
        roles: { include: { role: true } },
        memberships: { include: { community: true } },
        subscriptions: true,
      },
    });
  }

  updateMe(id: string, dto: UpdateProfileDto) {
    return this.prisma.user.update({
      where: { id },
      data: dto,
      select: { id: true, email: true, name: true, username: true, avatarUrl: true, bio: true },
    });
  }

  progress(userId: string) {
    return this.prisma.progress.findMany({
      where: { userId },
      include: { content: { select: { id: true, title: true, type: true, thumbnailUrl: true } } },
      orderBy: { updatedAt: 'desc' },
    });
  }

  permissions(userId: string) {
    return this.prisma.user.findUniqueOrThrow({
      where: { id: userId },
      select: {
        roles: {
          select: {
            role: {
              select: {
                code: true,
                permissions: { select: { permission: { select: { code: true, description: true } } } },
              },
            },
          },
        },
      },
    });
  }
}
