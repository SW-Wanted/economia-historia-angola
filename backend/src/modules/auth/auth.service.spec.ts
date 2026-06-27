import { ConflictException, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { AccountStatus } from '@prisma/client';
import * as argon2 from 'argon2';
import { AuthService } from './auth.service';

jest.mock('argon2');
const mockArgon2 = argon2 as jest.Mocked<typeof argon2>;

const makePrisma = () => ({
  user: {
    findUnique: jest.fn(),
    findUniqueOrThrow: jest.fn(),
    create: jest.fn(),
    update: jest.fn(),
  },
  refreshToken: {
    create: jest.fn(),
    findUnique: jest.fn(),
    update: jest.fn(),
    updateMany: jest.fn(),
  },
  passwordResetToken: {
    deleteMany: jest.fn(),
    create: jest.fn(),
    findUnique: jest.fn(),
    update: jest.fn(),
  },
  auditLog: { create: jest.fn() },
});

describe('AuthService', () => {
  let service: AuthService;
  let prisma: ReturnType<typeof makePrisma>;
  let jwtService: jest.Mocked<JwtService>;
  let configService: jest.Mocked<ConfigService>;

  beforeEach(() => {
    prisma = makePrisma();
    jwtService = { signAsync: jest.fn().mockResolvedValue('access-token') } as unknown as jest.Mocked<JwtService>;
    configService = {
      get: jest.fn().mockImplementation((key: string, def?: unknown) => def ?? '15m'),
    } as unknown as jest.Mocked<ConfigService>;
    service = new AuthService(prisma as never, jwtService, configService);
  });

  describe('register', () => {
    const dto = { email: 'new@example.com', name: 'New User', username: 'newuser', password: 'secret123', course: 'CS', motivation: 'Learn' };

    it('throws ConflictException when email is already registered', async () => {
      prisma.user.findUnique.mockResolvedValue({ id: 'existing' } as never);
      await expect(service.register(dto)).rejects.toThrow(ConflictException);
    });

    it('returns pending status on successful registration', async () => {
      prisma.user.findUnique.mockResolvedValue(null);
      mockArgon2.hash.mockResolvedValue('hashed' as never);
      prisma.user.create.mockResolvedValue({ id: 'new-id' } as never);

      const result = await service.register(dto);

      expect(prisma.user.create).toHaveBeenCalled();
      expect(result).toEqual({
        pending: true,
        message: 'Registration submitted. Await approval from the administrator.',
      });
    });
  });

  describe('login', () => {
    const dto = { email: 'user@example.com', password: 'correct-password' };

    const approvedActiveUser = {
      id: 'u1',
      email: dto.email,
      passwordHash: 'hash',
      approvalStatus: AccountStatus.APPROVED,
      isActive: true,
    };

    it('throws when user does not exist', async () => {
      prisma.user.findUnique.mockResolvedValue(null);
      await expect(service.login(dto)).rejects.toThrow(UnauthorizedException);
    });

    it('throws when password is incorrect', async () => {
      prisma.user.findUnique.mockResolvedValue(approvedActiveUser as never);
      mockArgon2.verify.mockResolvedValue(false as never);
      await expect(service.login(dto)).rejects.toThrow(UnauthorizedException);
    });

    it('updates lastLoginAt and issues tokens for valid approved active credentials', async () => {
      prisma.user.findUnique.mockResolvedValue(approvedActiveUser as never);
      mockArgon2.verify.mockResolvedValue(true as never);
      prisma.user.update.mockResolvedValue(approvedActiveUser as never);
      const issueTokensSpy = jest
        .spyOn(service as never, 'issueTokens')
        .mockResolvedValue({ accessToken: 'at', refreshToken: 'rt', user: {} } as never);

      const result = await service.login(dto);

      expect(prisma.user.update).toHaveBeenCalledWith(
        expect.objectContaining({ where: { id: 'u1' }, data: { lastLoginAt: expect.any(Date) } }),
      );
      expect(issueTokensSpy).toHaveBeenCalledWith('u1', undefined);
      expect(result).toHaveProperty('accessToken');
    });
  });
});
