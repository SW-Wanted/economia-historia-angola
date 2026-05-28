import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AuthUser, CurrentUser } from '../../common/decorators/current-user.decorator';
import { Public } from '../../common/decorators/public.decorator';
import { CreateReplyDto } from './dto/create-reply.dto';
import { CreateTopicDto } from './dto/create-topic.dto';
import { ForumsService } from './forums.service';

@ApiTags('forums')
@Controller('forums')
export class ForumsController {
  constructor(private readonly forums: ForumsService) {}

  @Public()
  @Get()
  list() {
    return this.forums.listPublicForums();
  }

  @Public()
  @Get(':forumId/topics')
  topics(@Param('forumId') forumId: string) {
    return this.forums.listPublicTopics(forumId);
  }

  @ApiBearerAuth()
  @Post(':forumId/topics')
  createTopic(@CurrentUser() user: AuthUser, @Param('forumId') forumId: string, @Body() dto: CreateTopicDto) {
    return this.forums.createTopic(user.id, forumId, dto);
  }

  @ApiBearerAuth()
  @Post('topics/:topicId/replies')
  reply(@CurrentUser() user: AuthUser, @Param('topicId') topicId: string, @Body() dto: CreateReplyDto) {
    return this.forums.reply(user.id, topicId, dto);
  }
}
