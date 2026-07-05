import { Body, Controller, Get, Param, Patch, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { PermissionCode } from '@prisma/client';
import { AuthUser, CurrentUser } from '../../common/decorators/current-user.decorator';
import { Permissions } from '../../common/decorators/permissions.decorator';
import { AdminListUsersDto } from './dto/admin-list-users.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { UpdateUserStatusDto } from './dto/update-user-status.dto';
import { UsersService } from './users.service';

@ApiBearerAuth()
@ApiTags('users')
@Controller('users')
export class UsersController {
  constructor(private readonly users: UsersService) {}

  @ApiOperation({ summary: 'Get own full profile', description: 'Returns roles, memberships, subscriptions, course, interests and motivation.' })
  @Get('me')
  me(@CurrentUser() user: AuthUser) {
    return this.users.findMe(user.id);
  }

  @ApiOperation({ summary: 'Update own profile', description: 'Updatable fields: name, bio, avatarUrl, region, school, course, interests (CSV), motivation.' })
  @Patch('me')
  updateMe(@CurrentUser() user: AuthUser, @Body() dto: UpdateProfileDto) {
    return this.users.updateMe(user.id, dto);
  }

  @ApiOperation({ summary: 'Get learning progress across all contents' })
  @Get('me/progress')
  progress(@CurrentUser() user: AuthUser) {
    return this.users.progress(user.id);
  }

  @ApiOperation({ summary: 'Get own roles and granular permissions' })
  @Get('me/permissions')
  permissions(@CurrentUser() user: AuthUser) {
    return this.users.permissions(user.id);
  }

  @ApiOperation({ summary: 'Get contents marked as favourite' })
  @Get('me/favorites')
  favorites(@CurrentUser() user: AuthUser) {
    return this.users.favorites(user.id);
  }

  @ApiOperation({ summary: 'Get own profile stats', description: 'Aggregated counters: points, rank, contentsCompleted, quizzesTaken.' })
  @Get('me/stats')
  stats(@CurrentUser() user: AuthUser) {
    return this.users.stats(user.id);
  }

  @ApiOperation({ summary: '[Admin] List all users (paginated)', description: 'Query params: ?search= (name), ?isActive= (boolean), ?page=, ?limit=' })
  @Permissions(PermissionCode.USER_MANAGE)
  @Get()
  listAll(@Query() dto: AdminListUsersDto) {
    return this.users.listAll(dto);
  }

  @ApiOperation({ summary: '[Admin] Suspend or reactivate a user account', description: 'Cannot change own account. Set isActive: false to suspend.' })
  @Permissions(PermissionCode.USER_MANAGE)
  @Patch(':id/status')
  updateStatus(
    @CurrentUser() user: AuthUser,
    @Param('id') targetId: string,
    @Body() dto: UpdateUserStatusDto,
  ) {
    return this.users.updateStatus(user.id, targetId, dto);
  }
}
