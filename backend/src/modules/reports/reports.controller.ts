import { Body, Controller, Get, Param, Patch, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { PermissionCode } from '@prisma/client';
import { AuthUser, CurrentUser } from '../../common/decorators/current-user.decorator';
import { Permissions } from '../../common/decorators/permissions.decorator';
import { CreateReportDto } from './dto/create-report.dto';
import { ReviewReportDto } from './dto/review-report.dto';
import { ReportsService } from './reports.service';

@ApiBearerAuth()
@ApiTags('reports')
@Controller('reports')
export class ReportsController {
  constructor(private readonly reports: ReportsService) {}

  @Post()
  create(@CurrentUser() user: AuthUser, @Body() dto: CreateReportDto) {
    return this.reports.create(user.id, dto);
  }

  @Permissions(PermissionCode.REPORT_REVIEW)
  @Get()
  list() {
    return this.reports.list();
  }

  @Permissions(PermissionCode.REPORT_REVIEW)
  @Patch(':id/review')
  review(@CurrentUser() user: AuthUser, @Param('id') id: string, @Body() dto: ReviewReportDto) {
    return this.reports.review(user.id, id, dto);
  }
}
