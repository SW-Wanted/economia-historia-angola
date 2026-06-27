import { ValidationPipe, VersioningType } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import * as compression from 'compression';
import * as cookieParser from 'cookie-parser';
import helmet from 'helmet';
import { Logger } from 'nestjs-pino';
import { AppModule } from './app.module';
import { AllExceptionsFilter } from './common/filters/all-exceptions.filter';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { bufferLogs: true });
  const config = app.get(ConfigService);

  app.useLogger(app.get(Logger));
  app.use(helmet());
  app.use(compression());
  app.use(cookieParser());

  const origins = config.get<string>('CORS_ORIGINS', '').split(',').filter(Boolean);
  if (process.env.NODE_ENV === 'production' && origins.length === 0) {
    throw new Error('CORS_ORIGINS must be configured in production');
  }
  app.enableCors({
    origin: origins.length > 0 ? origins : true,
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  });

  app.setGlobalPrefix((config.get<string>('apiPrefix') ?? 'api/v1').replace(/^\//, ''));
  app.enableVersioning({ type: VersioningType.URI });
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );
  app.useGlobalFilters(new AllExceptionsFilter());

  const swaggerConfig = new DocumentBuilder()
    .setTitle('Economia com Historia - Angola API')
    .setDescription('API REST para Flutter, Next.js, comunidades, conteudos, quiz e offline sync.')
    .setVersion('1.0')
    .addBearerAuth()
    .build();
  SwaggerModule.setup('docs', app, SwaggerModule.createDocument(app, swaggerConfig));

  await app.listen(config.get<number>('PORT', 3001), '0.0.0.0');
}

bootstrap();
