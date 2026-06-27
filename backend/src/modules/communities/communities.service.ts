import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { CommunityType, MembershipStatus } from '@prisma/client';
import { randomBytes } from 'crypto';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateCommunityDto } from './dto/create-community.dto';
import { InviteDto } from './dto/invite.dto';

@Injectable()
export class CommunitiesService {
  constructor(private readonly prisma: PrismaService) {}

  listPublic() {
    return this.prisma.community.findMany({
      where: { type: CommunityType.PUBLIC, deletedAt: null },
      include: { _count: { select: { memberships: true, forums: true } } },
    });
  }

  create(ownerId: string, dto: CreateCommunityDto) {
    return this.prisma.community.create({
      data: {
        ...dto,
        ownerId,
        memberships: { create: { userId: ownerId, status: MembershipStatus.ACTIVE, isModerator: true } },
      },
    });
  }

  join(userId: string, communityId: string) {
    return this.prisma.communityMembership.upsert({
      where: { communityId_userId: { communityId, userId } },
      update: { status: MembershipStatus.PENDING },
      create: { communityId, userId, status: MembershipStatus.PENDING },
    });
  }

  invite(invitedById: string, communityId: string, dto: InviteDto) {
    const expiresAt = dto.expiresAt ? new Date(dto.expiresAt) : new Date(Date.now() + 7 * 86400_000);
    return this.prisma.invitation.create({
      data: { communityId, invitedById, email: dto.email, code: randomBytes(8).toString('hex'), expiresAt },
    });
  }

  async approve(currentUserId: string, communityId: string, membershipId: string) {
    const membership = await this.prisma.communityMembership.findUnique({
      where: { id: membershipId },
      include: { community: { select: { ownerId: true } } },
    });
    if (!membership) throw new NotFoundException('Membership not found');
    if (membership.communityId !== communityId) {
      throw new NotFoundException('Membership does not belong to this community');
    }

    const isOwner = membership.community.ownerId === currentUserId;
    if (!isOwner) {
      const moderator = await this.prisma.communityMembership.findFirst({
        where: { communityId, userId: currentUserId, isModerator: true, status: MembershipStatus.ACTIVE },
      });
      if (!moderator) {
        throw new ForbiddenException('Only moderators or the community owner can approve memberships');
      }
    }

    return this.prisma.communityMembership.update({
      where: { id: membershipId },
      data: { status: MembershipStatus.ACTIVE, joinedAt: new Date() },
    });
  }
}
