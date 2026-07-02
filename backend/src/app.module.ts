import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { APP_GUARD } from '@nestjs/core';
import { JwtModule } from '@nestjs/jwt';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { LoggerModule } from 'nestjs-pino';
import { join } from 'path';
import { JwtAuthGuard } from './common/guards/jwt-auth.guard';
import { PermissionsGuard } from './common/guards/permissions.guard';
import { configuration } from './config/configuration';
import { validateEnv } from './config/env.validation';
import { HealthModule } from './health/health.module';
import { PrismaModule } from './prisma/prisma.module';
import { MailModule } from './modules/mail/mail.module';
import { RealtimeModule } from './realtime/realtime.module';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { ContentsModule } from './modules/contents/contents.module';
import { CommentsModule } from './modules/comments/comments.module';
import { CommunitiesModule } from './modules/communities/communities.module';
import { ForumsModule } from './modules/forums/forums.module';
import { QuizzesModule } from './modules/quizzes/quizzes.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { UploadsModule } from './modules/uploads/uploads.module';
import { SyncModule } from './modules/sync/sync.module';
import { ReportsModule } from './modules/reports/reports.module';
import { WriterApplicationsModule } from './modules/writer-applications/writer-applications.module';
import { StatsModule } from './modules/stats/stats.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      // Procura o `.env` na raiz do backend. Em `nest start` (ts-node) __dirname é
      // `src/`, mas no build compilado é `dist/src/`, onde `../.env` apontaria
      // erradamente para `dist/.env`. Incluir `process.cwd()/.env` garante que o
      // `.env` da raiz é carregado nos dois modos (ex.: credenciais SMTP).
      envFilePath: [join(process.cwd(), '.env'), join(__dirname, '..', '.env')],
      load: [configuration],
      validate: validateEnv,
    }),
    LoggerModule.forRoot({
      pinoHttp: {
        transport: process.env.NODE_ENV === 'production' ? undefined : { target: 'pino-pretty' },
        redact: ['req.headers.authorization', 'req.headers.cookie'],
      },
    }),
    ThrottlerModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => [
        {
          ttl: config.get<number>('rateLimit.ttl', 60) * 1000,
          limit: config.get<number>('rateLimit.max', 120),
        },
      ],
    }),
    JwtModule.register({}),
    PrismaModule,
    MailModule,
    HealthModule,
    AuthModule,
    UsersModule,
    ContentsModule,
    CommentsModule,
    CommunitiesModule,
    ForumsModule,
    QuizzesModule,
    NotificationsModule,
    UploadsModule,
    SyncModule,
    ReportsModule,
    WriterApplicationsModule,
    StatsModule,
    RealtimeModule,
  ],
  providers: [
    { provide: APP_GUARD, useClass: ThrottlerGuard },
    { provide: APP_GUARD, useClass: JwtAuthGuard },
    { provide: APP_GUARD, useClass: PermissionsGuard },
  ],
})
export class AppModule {}
