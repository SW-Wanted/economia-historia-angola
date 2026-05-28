import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AuthUser, CurrentUser } from '../../common/decorators/current-user.decorator';
import { Public } from '../../common/decorators/public.decorator';
import { CommunitiesService } from './communities.service';
import { CreateCommunityDto } from './dto/create-community.dto';
import { InviteDto } from './dto/invite.dto';

@ApiTags('communities')
@Controller('communities')
export class CommunitiesController {
  constructor(private readonly communities: CommunitiesService) {}

  @Public()
  @Get()
  listPublic() {
    return this.communities.listPublic();
  }

  @ApiBearerAuth()
  @Post()
  create(@CurrentUser() user: AuthUser, @Body() dto: CreateCommunityDto) {
    return this.communities.create(user.id, dto);
  }

  @ApiBearerAuth()
  @Post(':id/join')
  join(@CurrentUser() user: AuthUser, @Param('id') id: string) {
    return this.communities.join(user.id, id);
  }

  @ApiBearerAuth()
  @Post(':id/invitations')
  invite(@CurrentUser() user: AuthUser, @Param('id') id: string, @Body() dto: InviteDto) {
    return this.communities.invite(user.id, id, dto);
  }

  @ApiBearerAuth()
  @Post(':id/members/:memberId/approve')
  approve(@Param('memberId') memberId: string) {
    return this.communities.approve(memberId);
  }
}
