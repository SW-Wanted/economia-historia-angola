import { ConflictException, Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService, JwtSignOptions } from '@nestjs/jwt';
import { PermissionCode, RoleCode } from '@prisma/client';
import * as argon2 from 'argon2';
import { createHash, randomBytes } from 'crypto';
import { PrismaService } from '../../prisma/prisma.service';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';

type Principal = {
  id: string;
  email: string;
  roles: RoleCode[];
  permissions: PermissionCode[];
};

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwt: JwtService,
    private readonly config: ConfigService,
  ) {}

  async register(dto: RegisterDto, userAgent?: string) {
    const exists = await this.prisma.user.findUnique({ where: { email: dto.email } });
    if (exists) throw new ConflictException('Email already registered');

    const passwordHash = await argon2.hash(dto.password);
    const user = await this.prisma.user.create({
      data: {
        email: dto.email,
        name: dto.name,
        username: dto.username,
        passwordHash,
        roles: {
          create: {
            role: {
              connectOrCreate: {
                where: { code: RoleCode.USER },
                create: { code: RoleCode.USER, name: 'User' },
              },
            },
          },
        },
      },
    });
    return this.issueTokens(user.id, userAgent);
  }

  async login(dto: LoginDto, userAgent?: string) {
    const user = await this.prisma.user.findUnique({ where: { email: dto.email } });
    if (!user?.passwordHash || !(await argon2.verify(user.passwordHash, dto.password))) {
      throw new UnauthorizedException('Invalid credentials');
    }
    await this.prisma.user.update({ where: { id: user.id }, data: { lastLoginAt: new Date() } });
    return this.issueTokens(user.id, userAgent);
  }

  async refresh(refreshToken: string) {
    const tokenHash = await this.hashToken(refreshToken);
    const stored = await this.prisma.refreshToken.findUnique({ where: { tokenHash } });
    if (!stored || stored.revokedAt || stored.expiresAt < new Date()) {
      throw new UnauthorizedException('Invalid refresh token');
    }
    await this.prisma.refreshToken.update({
      where: { id: stored.id },
      data: { revokedAt: new Date() },
    });
    return this.issueTokens(stored.userId);
  }

  async logout(userId: string, refreshToken: string) {
    const tokenHash = await this.hashToken(refreshToken);
    await this.prisma.refreshToken.updateMany({
      where: { userId, tokenHash, revokedAt: null },
      data: { revokedAt: new Date() },
    });
    return { success: true };
  }

  async forgotPassword(email: string) {
    await this.prisma.auditLog.create({
      data: { action: 'AUTH_FORGOT_PASSWORD', entityType: 'User', metadata: { email } },
    });
    return { queued: true };
  }

  private async issueTokens(userId: string, userAgent?: string) {
    const principal = await this.getPrincipal(userId);
    const accessTtl = this.config.get<string>('jwt.accessTtl', '15m') as JwtSignOptions['expiresIn'];
    const accessToken = await this.jwt.signAsync(principal, {
      secret: this.config.get<string>('jwt.accessSecret'),
      expiresIn: accessTtl,
    });
    const refreshToken = randomBytes(48).toString('base64url');
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + this.config.get<number>('jwt.refreshTtlDays', 30));
    await this.prisma.refreshToken.create({
      data: {
        userId,
        tokenHash: await this.hashToken(refreshToken),
        userAgent,
        expiresAt,
      },
    });
    return { accessToken, refreshToken, user: principal };
  }

  private async getPrincipal(userId: string): Promise<Principal> {
    const user = await this.prisma.user.findUniqueOrThrow({
      where: { id: userId },
      include: { roles: { include: { role: { include: { permissions: { include: { permission: true } } } } } } },
    });
    const roles = user.roles.map((item) => item.role.code);
    const permissions = new Set<PermissionCode>();
    user.roles.forEach((item) =>
      item.role.permissions.forEach((rolePermission) => permissions.add(rolePermission.permission.code)),
    );
    return { id: user.id, email: user.email, roles, permissions: [...permissions] };
  }

  private hashToken(token: string) {
    return Promise.resolve(createHash('sha256').update(token).digest('hex'));
  }
}
