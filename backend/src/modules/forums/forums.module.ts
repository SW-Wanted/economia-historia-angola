import { Module } from '@nestjs/common';
import { NotificationsModule } from '../notifications/notifications.module';
import { ForumsController } from './forums.controller';
import { ForumsService } from './forums.service';

@Module({ imports: [NotificationsModule], controllers: [ForumsController], providers: [ForumsService] })
export class ForumsModule {}
