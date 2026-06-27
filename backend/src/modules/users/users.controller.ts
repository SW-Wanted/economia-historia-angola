import { Body, Controller, Get, Param, Patch, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
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

  @Get('me')
  me(@CurrentUser() user: AuthUser) {
    return this.users.findMe(user.id);
  }

  @Patch('me')
  updateMe(@CurrentUser() user: AuthUser, @Body() dto: UpdateProfileDto) {
    return this.users.updateMe(user.id, dto);
  }

  @Get('me/progress')
  progress(@CurrentUser() user: AuthUser) {
    return this.users.progress(user.id);
  }

  @Get('me/permissions')
  permissions(@CurrentUser() user: AuthUser) {
    return this.users.permissions(user.id);
  }

  @Get('me/favorites')
  favorites(@CurrentUser() user: AuthUser) {
    return this.users.favorites(user.id);
  }

  @Permissions(PermissionCode.USER_MANAGE)
  @Get()
  listAll(@Query() dto: AdminListUsersDto) {
    return this.users.listAll(dto);
  }

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
