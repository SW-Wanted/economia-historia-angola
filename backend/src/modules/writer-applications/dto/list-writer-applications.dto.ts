import { ApiPropertyOptional } from '@nestjs/swagger';
import { WriterApplicationStatus } from '@prisma/client';
import { IsEnum, IsOptional } from 'class-validator';
import { PaginationDto } from '../../../common/dto/pagination.dto';

export class ListWriterApplicationsDto extends PaginationDto {
  @ApiPropertyOptional({ enum: WriterApplicationStatus })
  @IsOptional()
  @IsEnum(WriterApplicationStatus)
  status?: WriterApplicationStatus;
}
