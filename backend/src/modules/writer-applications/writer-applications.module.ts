import { Module } from '@nestjs/common';
import { WriterApplicationsController } from './writer-applications.controller';
import { WriterApplicationsService } from './writer-applications.service';

@Module({
  controllers: [WriterApplicationsController],
  providers: [WriterApplicationsService],
})
export class WriterApplicationsModule {}
