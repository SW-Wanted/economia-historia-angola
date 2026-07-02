import { Module } from '@nestjs/common';
import { NotificationsModule } from '../notifications/notifications.module';
import { ContentsController } from './contents.controller';
import { ContentsService } from './contents.service';

@Module({ imports: [NotificationsModule], controllers: [ContentsController], providers: [ContentsService] })
export class ContentsModule {}
