import { Body, Controller, Post, Req } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Public } from '../../common/decorators/public.decorator';
import { CurrentUser, AuthUser } from '../../common/decorators/current-user.decorator';
import { AuthService } from './auth.service';
import { ChangePasswordDto } from './dto/change-password.dto';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { LoginDto } from './dto/login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { RegisterDto } from './dto/register.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly auth: AuthService) {}

  @Public()
  @ApiOperation({ summary: 'Create account and receive tokens immediately', description: 'Optional fields: username, course, interests (CSV), motivation. Returns accessToken + refreshToken.' })
  @Post('register')
  register(@Body() dto: RegisterDto, @Req() req: { headers: Record<string, string | undefined> }) {
    return this.auth.register(dto, req.headers['user-agent']);
  }

  @Public()
  @ApiOperation({ summary: 'Login with email and password', description: 'Returns 401 if credentials are wrong or account is suspended (isActive: false).' })
  @Post('login')
  login(@Body() dto: LoginDto, @Req() req: { headers: Record<string, string | undefined> }) {
    return this.auth.login(dto, req.headers['user-agent']);
  }

  @Public()
  @ApiOperation({ summary: 'Renew access token using a refresh token', description: 'The previous refresh token is revoked immediately (rotation). A new pair is issued.' })
  @Post('refresh')
  refresh(@Body() dto: RefreshTokenDto) {
    return this.auth.refresh(dto.refreshToken);
  }

  @ApiBearerAuth()
  @ApiOperation({ summary: 'Revoke the current refresh token (logout)' })
  @Post('logout')
  logout(@CurrentUser() user: AuthUser, @Body() dto: RefreshTokenDto) {
    return this.auth.logout(user.id, dto.refreshToken);
  }

  @Public()
  @ApiOperation({ summary: 'Request a password reset link', description: 'Response is always identical regardless of whether the email exists (anti-enumeration).' })
  @Post('forgot-password')
  forgotPassword(@Body() dto: ForgotPasswordDto) {
    return this.auth.forgotPassword(dto.email);
  }

  @Public()
  @ApiOperation({ summary: 'Apply a new password using the reset token', description: 'Token expires after 1 hour. On success, all active refresh tokens for the account are revoked.' })
  @Post('reset-password')
  resetPassword(@Body() dto: ResetPasswordDto) {
    return this.auth.resetPassword(dto);
  }

  @ApiBearerAuth()
  @ApiOperation({ summary: 'Change the current authenticated user password' })
  @Post('change-password')
  changePassword(@CurrentUser() user: AuthUser, @Body() dto: ChangePasswordDto) {
    return this.auth.changePassword(user.id, dto);
  }

  @Public()
  @ApiOperation({ summary: 'Email verification placeholder (provider integration pending)' })
  @Post('verify-email')
  verifyEmail() {
    return { queued: true, message: 'Email verification flow is ready for provider integration.' };
  }
}
