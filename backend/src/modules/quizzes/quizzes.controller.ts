import { Body, Controller, Get, Param, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { PermissionCode } from '@prisma/client';
import { AuthUser, CurrentUser } from '../../common/decorators/current-user.decorator';
import { Permissions } from '../../common/decorators/permissions.decorator';
import { Public } from '../../common/decorators/public.decorator';
import { AnswerDto } from './dto/answer.dto';
import { CreateQuizDto } from './dto/create-quiz.dto';
import { QuizzesService } from './quizzes.service';

@ApiTags('quizzes')
@Controller('quizzes')
export class QuizzesController {
  constructor(private readonly quizzes: QuizzesService) {}

  @Public()
  @Get()
  list() {
    return this.quizzes.listPublic();
  }

  @ApiBearerAuth()
  @Permissions(PermissionCode.QUIZ_MANAGE)
  @Post()
  create(@CurrentUser() user: AuthUser, @Body() dto: CreateQuizDto) {
    return this.quizzes.create(user.id, dto);
  }

  @ApiBearerAuth()
  @Post(':id/start')
  start(@CurrentUser() user: AuthUser, @Param('id') id: string) {
    return this.quizzes.start(user.id, id);
  }

  @ApiBearerAuth()
  @Post('attempts/:attemptId/answers')
  answer(@CurrentUser() user: AuthUser, @Param('attemptId') attemptId: string, @Body() dto: AnswerDto) {
    return this.quizzes.answer(user.id, attemptId, dto);
  }

  @ApiBearerAuth()
  @Post('attempts/:attemptId/submit')
  submit(@CurrentUser() user: AuthUser, @Param('attemptId') attemptId: string) {
    return this.quizzes.submit(user.id, attemptId);
  }

  @Public()
  @Get('rankings')
  ranking(@Query('scope') scope = 'global', @Query('period') period = 'all') {
    return this.quizzes.ranking(scope, period);
  }
}
