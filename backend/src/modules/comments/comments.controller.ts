import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AuthUser, CurrentUser } from '../../common/decorators/current-user.decorator';
import { Public } from '../../common/decorators/public.decorator';
import { CommentsService } from './comments.service';
import { CreateCommentDto } from './dto/create-comment.dto';
import { CreateRoomDto } from './dto/create-room.dto';

@ApiTags('comments')
@Controller('comments')
export class CommentsController {
  constructor(private readonly comments: CommentsService) {}

  @Public()
  @Get('content/:contentId')
  publicForContent(@Param('contentId') contentId: string) {
    return this.comments.publicForContent(contentId);
  }

  @ApiBearerAuth()
  @Post()
  create(@CurrentUser() user: AuthUser, @Body() dto: CreateCommentDto) {
    return this.comments.create(user.id, dto);
  }

  @ApiBearerAuth()
  @Post('rooms')
  createRoom(@CurrentUser() user: AuthUser, @Body() dto: CreateRoomDto) {
    return this.comments.createRoom(user.id, dto);
  }

  @ApiBearerAuth()
  @Post('rooms/:roomId/participants/:userId')
  addParticipant(@Param('roomId') roomId: string, @Param('userId') userId: string) {
    return this.comments.addParticipant(roomId, userId);
  }
}
