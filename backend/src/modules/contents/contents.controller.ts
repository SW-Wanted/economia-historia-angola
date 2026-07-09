import { Body, Controller, Delete, Get, Param, Patch, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { PermissionCode } from '@prisma/client';
import { AuthUser, CurrentUser } from '../../common/decorators/current-user.decorator';
import { Permissions } from '../../common/decorators/permissions.decorator';
import { Public } from '../../common/decorators/public.decorator';
import { ChangeContentStatusDto } from './dto/change-content-status.dto';
import { ContentQueryDto } from './dto/content-query.dto';
import { CreateContentDto } from './dto/create-content.dto';
import { UpdateProgressDto } from './dto/update-progress.dto';
import { ContentsService } from './contents.service';

@ApiTags('contents')
@Controller('contents')
export class ContentsController {
  constructor(private readonly contents: ContentsService) {}

  @Public()
  @Get()
  list(@Query() query: ContentQueryDto) {
    return this.contents.listPublic(query);
  }

  @ApiBearerAuth()
  @ApiOperation({
    summary: 'List contents for the management panel (drafts, pending, published)',
    description: 'Approvers/publishers see all contents; other authors see only their own.',
  })
  @Permissions(PermissionCode.CONTENT_CREATE)
  @Get('manage')
  listForManagement(@CurrentUser() user: AuthUser, @Query() query: ContentQueryDto) {
    return this.contents.listForManagement(user, query);
  }

  @Public()
  @Get(':id')
  findPublic(@Param('id') id: string) {
    return this.contents.findPublic(id);
  }

  @ApiBearerAuth()
  @Get(':id/full')
  findAuthorized(@CurrentUser() user: AuthUser, @Param('id') id: string) {
    return this.contents.findAuthorized(user.id, id, user.permissions as PermissionCode[]);
  }

  @ApiBearerAuth()
  @Permissions(PermissionCode.CONTENT_CREATE)
  @Post()
  create(@CurrentUser() user: AuthUser, @Body() dto: CreateContentDto) {
    return this.contents.create(user.id, dto);
  }

  @ApiBearerAuth()
  @ApiOperation({ summary: 'Change content status (submit, publish, reject, archive)' })
  @Permissions(PermissionCode.CONTENT_CREATE)
  @Patch(':id/status')
  changeStatus(
    @CurrentUser() user: AuthUser,
    @Param('id') id: string,
    @Body() dto: ChangeContentStatusDto,
  ) {
    return this.contents.changeStatus(user, id, dto.status);
  }

  @ApiBearerAuth()
  @ApiOperation({ summary: 'Remove (soft-delete) a content item' })
  @Permissions(PermissionCode.CONTENT_CREATE)
  @Delete(':id')
  remove(@CurrentUser() user: AuthUser, @Param('id') id: string) {
    return this.contents.remove(user, id);
  }

  @ApiBearerAuth()
  @Post(':id/favorite')
  favorite(@CurrentUser() user: AuthUser, @Param('id') id: string) {
    return this.contents.favorite(user.id, id);
  }

  @ApiBearerAuth()
  @Patch(':id/progress')
  progress(@CurrentUser() user: AuthUser, @Param('id') id: string, @Body() dto: UpdateProgressDto) {
    return this.contents.progress(user.id, id, dto.percentage);
  }

  @ApiBearerAuth()
  @Post(':id/request-access')
  requestAccess(@CurrentUser() user: AuthUser, @Param('id') id: string) {
    return this.contents.requestJindungoAccess(user.id, id);
  }
}
