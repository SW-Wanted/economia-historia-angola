import { ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { Reflector } from '@nestjs/core';
import { JwtAuthGuard } from './jwt-auth.guard';

const makeContext = (
  reflector: jest.Mocked<Reflector>,
  headers: Record<string, string>,
  isPublic: boolean,
): ExecutionContext => {
  reflector.getAllAndOverride.mockReturnValue(isPublic);
  const request = { headers, user: undefined as unknown };
  return {
    getHandler: jest.fn(),
    getClass: jest.fn(),
    switchToHttp: jest.fn().mockReturnValue({ getRequest: jest.fn().mockReturnValue(request) }),
  } as unknown as ExecutionContext;
};

describe('JwtAuthGuard', () => {
  let guard: JwtAuthGuard;
  let reflector: jest.Mocked<Reflector>;
  let jwtService: jest.Mocked<JwtService>;
  let configService: jest.Mocked<ConfigService>;

  beforeEach(() => {
    reflector = { getAllAndOverride: jest.fn() } as unknown as jest.Mocked<Reflector>;
    jwtService = { verify: jest.fn() } as unknown as jest.Mocked<JwtService>;
    configService = { get: jest.fn().mockReturnValue('test-secret') } as unknown as jest.Mocked<ConfigService>;
    guard = new JwtAuthGuard(reflector, jwtService, configService);
  });

  it('allows public routes without a token', () => {
    const ctx = makeContext(reflector, {}, true);
    expect(guard.canActivate(ctx)).toBe(true);
    expect(jwtService.verify).not.toHaveBeenCalled();
  });

  it('throws when Authorization header is absent', () => {
    const ctx = makeContext(reflector, {}, false);
    expect(() => guard.canActivate(ctx)).toThrow(UnauthorizedException);
  });

  it('throws when Authorization scheme is not Bearer', () => {
    const ctx = makeContext(reflector, { authorization: 'Basic dXNlcjpwYXNz' }, false);
    expect(() => guard.canActivate(ctx)).toThrow(UnauthorizedException);
  });

  it('throws when JWT verification fails', () => {
    jwtService.verify.mockImplementation(() => {
      throw new Error('jwt expired');
    });
    const ctx = makeContext(reflector, { authorization: 'Bearer bad.token.here' }, false);
    expect(() => guard.canActivate(ctx)).toThrow(UnauthorizedException);
  });

  it('attaches payload to request and returns true for a valid token', () => {
    const payload = { id: 'user-1', email: 'a@b.com', roles: [], permissions: [] };
    jwtService.verify.mockReturnValue(payload as never);
    reflector.getAllAndOverride.mockReturnValue(false);
    const request: Record<string, unknown> = { headers: { authorization: 'Bearer valid.jwt.token' } };
    const ctx = {
      getHandler: jest.fn(),
      getClass: jest.fn(),
      switchToHttp: jest.fn().mockReturnValue({ getRequest: jest.fn().mockReturnValue(request) }),
    } as unknown as ExecutionContext;

    expect(guard.canActivate(ctx)).toBe(true);
    expect(request.user).toEqual(payload);
  });
});
