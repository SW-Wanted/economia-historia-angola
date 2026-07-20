import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { CommunityType, MembershipStatus, NotificationType, Visibility } from '@prisma/client';
import { randomBytes } from 'crypto';
import { NotificationsService } from '../notifications/notifications.service';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateCommunityDto } from './dto/create-community.dto';
import { InviteDto } from './dto/invite.dto';

@Injectable()
export class CommunitiesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly notifications: NotificationsService,
  ) {}

  async listPublic(currentUserId?: string) {
    const communities = await this.prisma.community.findMany({
      where: { type: CommunityType.PUBLIC, deletedAt: null },
      include: { _count: { select: { memberships: true, forums: true } } },
      orderBy: { createdAt: 'desc' },
    });
    return this.attachViewerStatus(communities, currentUserId);
  }

  /// Detalhe de uma comunidade, incluindo os seus fóruns públicos (usados como
  /// "tópicos" da comunidade no mobile) e o estado de adesão do utilizador atual.
  async detail(communityId: string, currentUserId?: string) {
    const community = await this.prisma.community.findFirst({
      where: { id: communityId, deletedAt: null },
      include: {
        _count: { select: { memberships: true, forums: true } },
        forums: {
          where: { visibility: Visibility.PUBLIC, deletedAt: null },
          orderBy: { createdAt: 'desc' },
          include: { _count: { select: { topics: true } } },
        },
      },
    });
    if (!community) throw new NotFoundException('Community not found');
    const [withStatus] = await this.attachViewerStatus([community], currentUserId);
    return withStatus;
  }

  private async attachViewerStatus<T extends { id: string }>(communities: T[], currentUserId?: string) {
    if (!currentUserId || communities.length === 0) {
      return communities.map((c) => ({ ...c, viewerStatus: 'NONE' as const }));
    }
    const memberships = await this.prisma.communityMembership.findMany({
      where: { userId: currentUserId, communityId: { in: communities.map((c) => c.id) } },
      select: { communityId: true, status: true },
    });
    const byCommunity = new Map(memberships.map((m) => [m.communityId, m.status]));
    return communities.map((c) => ({ ...c, viewerStatus: byCommunity.get(c.id) ?? ('NONE' as const) }));
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

  async join(userId: string, communityId: string) {
    const community = await this.prisma.community.findFirst({
      where: { id: communityId, deletedAt: null },
      select: { name: true, type: true, ownerId: true },
    });
    if (!community) throw new NotFoundException('Community not found');

    // Comunidades públicas: adesão imediata (ACTIVE). Privadas: pedido pendente
    // que aguarda aprovação do dono/moderador.
    const immediate = community.type === CommunityType.PUBLIC;
    const membership = await this.prisma.communityMembership.upsert({
      where: { communityId_userId: { communityId, userId } },
      update: immediate
        ? { status: MembershipStatus.ACTIVE, joinedAt: new Date() }
        : { status: MembershipStatus.PENDING },
      create: {
        communityId,
        userId,
        status: immediate ? MembershipStatus.ACTIVE : MembershipStatus.PENDING,
        joinedAt: immediate ? new Date() : null,
      },
    });

    // Numa comunidade privada, avisa o dono de que há um pedido para aprovar.
    if (!immediate && community.ownerId !== userId) {
      const applicant = await this.prisma.user.findUnique({ where: { id: userId }, select: { name: true } });
      void this.notifications
        .create(
          community.ownerId,
          NotificationType.COMMUNITY,
          'Novo pedido de adesão',
          `${applicant?.name ?? 'Um utilizador'} pediu para entrar na comunidade "${community.name}"`,
          { communityId },
        )
        .catch(() => void 0);
    }
    return membership;
  }

  async leave(userId: string, communityId: string) {
    const community = await this.prisma.community.findFirst({
      where: { id: communityId, deletedAt: null },
      select: { ownerId: true },
    });
    if (!community) throw new NotFoundException('Community not found');
    if (community.ownerId === userId) {
      throw new ForbiddenException('O dono da comunidade não pode sair. Transfira a posse ou elimine a comunidade.');
    }
    await this.prisma.communityMembership.deleteMany({ where: { communityId, userId } });
    return { left: true };
  }

  async invite(invitedById: string, communityId: string, dto: InviteDto) {
    const expiresAt = dto.expiresAt ? new Date(dto.expiresAt) : new Date(Date.now() + 7 * 86400_000);
    const invitation = await this.prisma.invitation.create({
      data: { communityId, invitedById, email: dto.email, code: randomBytes(8).toString('hex'), expiresAt },
    });
    void this.notifyInvitedUser(communityId, dto.email).catch(() => void 0);
    return invitation;
  }

  private async notifyInvitedUser(communityId: string, email?: string) {
    if (!email) return;
    const [user, community] = await Promise.all([
      this.prisma.user.findUnique({ where: { email }, select: { id: true } }),
      this.prisma.community.findUnique({ where: { id: communityId }, select: { name: true } }),
    ]);
    if (!user || !community) return;
    await this.notifications.create(
      user.id,
      NotificationType.COMMUNITY,
      'Convite para uma comunidade',
      `Foi convidado para a comunidade "${community.name}"`,
      { communityId },
    );
  }

  async approve(currentUserId: string, communityId: string, membershipId: string) {
    const membership = await this.prisma.communityMembership.findUnique({
      where: { id: membershipId },
      include: { community: { select: { ownerId: true, name: true } } },
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

    const updated = await this.prisma.communityMembership.update({
      where: { id: membershipId },
      data: { status: MembershipStatus.ACTIVE, joinedAt: new Date() },
    });

    // Avisa o candidato de que a sua adesão foi aprovada.
    void this.notifications
      .create(
        membership.userId,
        NotificationType.COMMUNITY,
        'Adesão aprovada',
        `A sua adesão à comunidade "${membership.community.name}" foi aprovada.`,
        { communityId },
      )
      .catch(() => void 0);
    return updated;
  }
}
