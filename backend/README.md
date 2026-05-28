# Economia com Historia - Angola Backend

Backend enterprise em **NestJS + TypeScript + PostgreSQL + Prisma + Redis + Socket.IO**, preparado para Flutter, Next.js, comunidades educativas, conteúdos multimédia, quiz, permissões granulares e sincronização offline futura.

## Decisões Técnicas

- **NestJS**: modular, opinativo, excelente para equipas, Swagger nativo, guards/interceptors e boa evolução para microserviços.
- **TypeScript**: contratos fortes para Flutter/Next.js consumirem APIs previsíveis.
- **PostgreSQL**: melhor escolha relacional para RBAC/ACL, fóruns, quizzes, auditoria, rankings e queries analíticas.
- **Prisma ORM**: produtividade, migrations versionadas e schema como contrato central do domínio.
- **Redis + BullMQ**: cache, rate limiting, filas de notificações, processamento de media, rankings e sync events.
- **Socket.IO**: realtime pragmático para notificações, comentários, presença e chats futuros.
- **S3/R2 compatível**: uploads com URLs assinadas, barato, CDN-ready e portável entre AWS, Cloudflare R2 e MinIO local.
- **JWT + refresh tokens**: mobile-friendly, stateless no access token e revogação via refresh token persistido.
- **Docker**: ambiente reprodutível para dev/staging/prod.

Tradeoff principal: este backend começa como **monólito modular**. É mais simples e barato no início, mas os limites já estão definidos por módulos e filas para extrair microserviços depois: media, notificações, rankings, search e sync.

## Estrutura

```text
src/
├── common/            # decorators, guards, filtros, DTOs partilhados
├── config/            # env e configuração tipada
├── events/            # contrato base para domain events
├── health/            # health check
├── modules/
│   ├── auth/          # register, login, refresh, logout
│   ├── users/         # perfil, progresso, permissões
│   ├── contents/      # conteúdos públicos/protegidos, favoritos, progresso
│   ├── comments/      # comentários e salas privadas
│   ├── communities/   # comunidades, membros, convites
│   ├── forums/        # fóruns, tópicos, respostas
│   ├── quizzes/       # quiz, tentativas, respostas, rankings
│   ├── notifications/ # notificações persistidas e realtime-ready
│   ├── uploads/       # signed URLs S3/R2
│   └── sync/          # incremental sync para offline-first
├── prisma/            # PrismaService global
├── queues/            # nomes de filas
└── realtime/          # Socket.IO gateway
```

## Domínio e Banco de Dados

O [schema.prisma](./prisma/schema.prisma) modela:

- utilizadores, roles, permissões e ACL granular;
- conteúdos, categorias, tags, assets, favoritos, visualizações e progresso;
- comentários públicos/privados e salas privadas de discussão;
- comunidades públicas/privadas, memberships e convites por email/código;
- fóruns, tópicos, respostas e denúncias;
- quizzes, perguntas, opções, tentativas, respostas e rankings;
- notificações, subscrições, auditoria e eventos de sincronização.

Há índices para consultas críticas: publicação/visibilidade, soft delete, rankings, memberships, fórum/tópicos, notificações, progresso e sync por data.

## Permissões

Roles base:

- `USER`
- `WRITER`
- `PROFESSOR`
- `MODERATOR`
- `ADMIN`
- `SUPER_ADMIN`

Permissões granulares incluem `JINDUNGO_ACCESS`, `JINDUNGO_WRITE`, `CONTENT_APPROVE`, `COMMENT_MODERATE`, `PRIVATE_ROOM_MANAGE`, `COMMUNITY_APPROVE_MEMBER`, `FORUM_MODERATE`, `QUIZ_MANAGE`, `REPORT_REVIEW` e outras.

O RBAC cobre permissões globais. A tabela `AccessControlEntry` cobre ACL por recurso, por exemplo acesso a um conteúdo "Textos com Jindungo", sala privada, comunidade ou quiz específico.

## Endpoints Principais

Base URL local: `http://localhost:3001/api/v1`

Swagger: `http://localhost:3001/docs`

### Auth

- `POST /auth/register`
- `POST /auth/login`
- `POST /auth/refresh`
- `POST /auth/logout`
- `POST /auth/forgot-password`
- `POST /auth/verify-email`

### Users

- `GET /users/me`
- `PATCH /users/me`
- `GET /users/me/progress`
- `GET /users/me/permissions`

### Contents

- `GET /contents` público, apenas conteúdos publicados e públicos
- `GET /contents/:id` público
- `POST /contents` requer `CONTENT_CREATE`
- `POST /contents/:id/favorite`
- `PATCH /contents/:id/progress`
- `POST /contents/:id/request-access`

### Communities

- `GET /communities`
- `POST /communities`
- `POST /communities/:id/join`
- `POST /communities/:id/invitations`
- `POST /communities/:id/members/:memberId/approve`

### Forums

- `GET /forums`
- `GET /forums/:forumId/topics`
- `POST /forums/:forumId/topics`
- `POST /forums/topics/:topicId/replies`

### Comments

- `GET /comments/content/:contentId`
- `POST /comments`
- `POST /comments/rooms`
- `POST /comments/rooms/:roomId/participants/:userId`

### Quizzes

- `GET /quizzes`
- `POST /quizzes` requer `QUIZ_MANAGE`
- `POST /quizzes/:id/start`
- `POST /quizzes/attempts/:attemptId/answers`
- `POST /quizzes/attempts/:attemptId/submit`
- `GET /quizzes/rankings`

### Uploads, Notifications e Sync

- `POST /reports`
- `GET /reports` requer `REPORT_REVIEW`
- `PATCH /reports/:id/review` requer `REPORT_REVIEW`
- `POST /uploads/presign`
- `GET /notifications`
- `PATCH /notifications/:id/read`
- `GET /sync/changes?since=2026-01-01T00:00:00.000Z`

## Segurança

Implementado na fundação:

- JWT access token curto + refresh token revogável;
- hash Argon2 para passwords;
- hash SHA-256 para lookup seguro de refresh token;
- RBAC por guards globais;
- permissões por decorator `@Permissions(...)`;
- Helmet, CORS, validation pipe e rate limiting;
- logs estruturados com `nestjs-pino`;
- auditoria via `AuditLog`;
- soft delete em entidades críticas.

Próximos hardenings recomendados: CAPTCHA/anti-spam para criação pública, device fingerprint leve, verificação de email real, política de password reset com token dedicado, e Content Security Policy ajustada ao frontend.

## Offline-First

O backend já prepara:

- `updatedAt` e `version` para entidades sincronizáveis;
- `SyncEvent` para event log incremental;
- `SyncCursor` por utilizador/dispositivo/escopo;
- endpoint `/sync/changes` para pull incremental;
- operações idempotentes recomendadas para clientes mobile.

Estratégia futura: Flutter guarda cache local, envia mutations com client operation id, backend resolve conflitos por versão (`server-wins` para conteúdo editorial, `merge` para progresso/comentários quando possível).

## Escalabilidade

Fase inicial:

- monólito modular NestJS;
- PostgreSQL gerido;
- Redis gerido;
- object storage S3/R2;
- CDN para assets;
- deploy em container.

Fase de crescimento:

- separar workers BullMQ de media/rankings/notificações;
- adicionar OpenSearch/Meilisearch para pesquisa;
- read replicas PostgreSQL para feed/conteúdo;
- cache Redis para listagens públicas;
- Socket.IO com Redis adapter;
- extrair serviços: media, notifications, ranking, search, sync.

## Cloud Recomendada

Para custo-benefício inicial:

- **API**: Railway/Fly.io/Render ou ECS/Fargate quando houver orçamento enterprise.
- **DB**: Supabase Postgres/Neon/RDS.
- **Redis**: Upstash/Redis Cloud/ElastiCache.
- **Storage**: Cloudflare R2, por custo baixo de egress, ou AWS S3 se a infra for AWS.
- **CDN**: Cloudflare.
- **Observabilidade**: Grafana Cloud/Sentry/OpenTelemetry.

Para escala enterprise em AWS: API em ECS/Fargate ou EKS, RDS PostgreSQL Multi-AZ, ElastiCache Redis, S3 + CloudFront, SQS/EventBridge, CloudWatch + OpenTelemetry.

## Execução

Este ambiente de trabalho tinha `node`, mas não tinha `npm`. Numa máquina com Node.js 20 LTS e npm:

```bash
cd backend
cp .env.example .env
npm install
npx prisma generate
npx prisma migrate dev
npm run prisma:seed
npm run start:dev
```

Com Docker:

```bash
cd backend
cp .env.example .env
docker compose up --build
```

## Flutter e Next.js

Flutter:

- paginação `page/limit`;
- tokens JWT + refresh;
- uploads por signed URL;
- endpoint de sync incremental;
- payloads pequenos e cacheáveis.

Next.js:

- REST simples para SSR/ISR;
- conteúdos públicos sem login para SEO;
- bearer token em rotas autenticadas;
- assets via CDN;
- Swagger/OpenAPI pode gerar SDK TypeScript.
