import { Body, Controller, Get, Param, Patch, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { PermissionCode } from '@prisma/client';
import { AuthUser, CurrentUser } from '../../common/decorators/current-user.decorator';
import { Permissions } from '../../common/decorators/permissions.decorator';
import { Public } from '../../common/decorators/public.decorator';
import { AnswerDto } from './dto/answer.dto';
import { CreateQuizDto } from './dto/create-quiz.dto';
import { GenerateQuizDto } from './dto/generate-quiz.dto';
import { UpdateQuizDto } from './dto/update-quiz.dto';
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
  @Permissions(PermissionCode.QUIZ_MANAGE)
  @Post('generate')
  @ApiOperation({ summary: 'Gera perguntas de quiz com IA (Gemini) a partir de um tema/conteúdo' })
  generate(@Body() dto: GenerateQuizDto) {
    return this.quizzes.generate(dto);
  }

  @ApiBearerAuth()
  @Permissions(PermissionCode.QUIZ_MANAGE)
  @Get(':id/edit')
  @ApiOperation({ summary: 'Carrega um quiz para edição (inclui a opção correta)' })
  findForEdit(@Param('id') id: string) {
    return this.quizzes.findForEdit(id);
  }

  @ApiBearerAuth()
  @Permissions(PermissionCode.QUIZ_MANAGE)
  @Patch(':id')
  update(@CurrentUser() user: AuthUser, @Param('id') id: string, @Body() dto: UpdateQuizDto) {
    const isAdmin = user.roles.includes('ADMIN') || user.roles.includes('SUPER_ADMIN');
    return this.quizzes.update(user.id, isAdmin, id, dto);
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

  @Public()
  @Get('weekly')
  @ApiOperation({ summary: 'Get the featured "Quiz of the Week" (or null if none is set)' })
  weekly() {
    return this.quizzes.weekly();
  }

  @Public()
  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.quizzes.findById(id);
  }
}
