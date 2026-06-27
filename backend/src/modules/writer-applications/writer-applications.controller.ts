import { Body, Controller, Get, Param, Patch, Post, Query, Request } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { PermissionCode } from '@prisma/client';
import { Permissions } from '../../common/decorators/permissions.decorator';
import { CreateWriterApplicationDto } from './dto/create-writer-application.dto';
import { ListWriterApplicationsDto } from './dto/list-writer-applications.dto';
import { ReviewWriterApplicationDto } from './dto/review-writer-application.dto';
import { WriterApplicationsService } from './writer-applications.service';

@ApiTags('Writer Applications')
@ApiBearerAuth()
@Controller('writer-applications')
export class WriterApplicationsController {
  constructor(private readonly service: WriterApplicationsService) {}

  @Post()
  @ApiOperation({ summary: 'Submit a writer candidacy application' })
  apply(@Request() req: { user: { id: string } }, @Body() dto: CreateWriterApplicationDto) {
    return this.service.apply(req.user.id, dto);
  }

  @Get('me')
  @ApiOperation({ summary: "Get the authenticated user's writer application" })
  findMine(@Request() req: { user: { id: string } }) {
    return this.service.findMine(req.user.id);
  }

  @Patch('me/resubmit')
  @ApiOperation({ summary: 'Resubmit application after REQUEST_CHANGES decision' })
  resubmit(@Request() req: { user: { id: string } }, @Body() dto: CreateWriterApplicationDto) {
    return this.service.resubmit(req.user.id, dto);
  }

  @Get()
  @Permissions(PermissionCode.USER_MANAGE)
  @ApiOperation({ summary: '[Admin] List all writer applications, optionally filtered by status' })
  listAll(@Query() query: ListWriterApplicationsDto) {
    return this.service.listAll(query);
  }

  @Get(':id')
  @Permissions(PermissionCode.USER_MANAGE)
  @ApiOperation({ summary: '[Admin] Get full details of a writer application' })
  findOne(@Param('id') id: string) {
    return this.service.findOne(id);
  }

  @Patch(':id/review')
  @Permissions(PermissionCode.USER_MANAGE)
  @ApiOperation({ summary: '[Admin] Approve, reject, or request changes on an application' })
  review(
    @Request() req: { user: { id: string } },
    @Param('id') id: string,
    @Body() dto: ReviewWriterApplicationDto,
  ) {
    return this.service.review(req.user.id, id, dto);
  }
}
