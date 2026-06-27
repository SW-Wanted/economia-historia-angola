import { Body, Controller, Get, Param, Patch, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { PermissionCode } from '@prisma/client';
import { AuthUser, CurrentUser } from '../../common/decorators/current-user.decorator';
import { Permissions } from '../../common/decorators/permissions.decorator';
import { Public } from '../../common/decorators/public.decorator';
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
