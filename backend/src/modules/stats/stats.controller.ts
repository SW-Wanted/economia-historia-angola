import { Controller, Get, Param } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { Public } from '../../common/decorators/public.decorator';
import { StatsService } from './stats.service';

@ApiTags('stats')
@Controller('stats')
export class StatsController {
  constructor(private readonly stats: StatsService) {}

  @Public()
  @Get('landing')
  @ApiOperation({ summary: 'Public counts for the landing page (members, contents, quizzes)' })
  landing() {
    return this.stats.landing();
  }

  @Public()
  @Get('province/:name')
  @ApiOperation({ summary: 'Real content/author counts for a province (0 when none)' })
  province(@Param('name') name: string) {
    return this.stats.province(name);
  }
}
