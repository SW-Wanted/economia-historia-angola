import { Controller, Get, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AuthUser, CurrentUser } from '../../common/decorators/current-user.decorator';
import { SyncQueryDto } from './dto/sync-query.dto';
import { SyncService } from './sync.service';

@ApiBearerAuth()
@ApiTags('sync')
@Controller('sync')
export class SyncController {
  constructor(private readonly sync: SyncService) {}

  @Get('changes')
  changes(@CurrentUser() user: AuthUser, @Query() query: SyncQueryDto) {
    return this.sync.changes(user.id, query);
  }
}
