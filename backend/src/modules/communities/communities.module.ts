import { Module } from '@nestjs/common';
import { NotificationsModule } from '../notifications/notifications.module';
import { CommunitiesController } from './communities.controller';
import { CommunitiesService } from './communities.service';

@Module({ imports: [NotificationsModule], controllers: [CommunitiesController], providers: [CommunitiesService] })
export class CommunitiesModule {}
