# Economia com Historia — Angola · Backend

Backend enterprise em **NestJS + TypeScript + PostgreSQL + Prisma + Socket.IO**, preparado para Flutter, Next.js, comunidades educativas, conteúdos multimédia, quiz, permissões granulares e sincronização offline.

---

## Decisões Técnicas

| Tecnologia | Motivo |
|---|---|
| **NestJS 11** | Modular, opinativo, guards/interceptors nativos, Swagger integrado, boa evolução para microserviços |
| **TypeScript** | Contratos fortes para os clientes Flutter e Next.js consumirem APIs previsíveis |
| **PostgreSQL 16** | Melhor opção relacional para RBAC/ACL, fóruns, quizzes, auditoria, rankings e queries analíticas |
| **Prisma 7** | Migrations versionadas, schema como contrato central do domínio, type-safety total |
| **Socket.IO** | Realtime pragmático para notificações, comentários, presença e chats futuros |
| **S3/R2 compatível** | Uploads com URLs assinadas, barato, CDN-ready e portável entre AWS, Cloudflare R2 e MinIO local |
| **JWT + refresh tokens opacos** | Mobile-friendly; access token de curta duração, refresh token revogável armazenado com hash no DB |
| **Argon2** | Hash de passwords resistente a GPU; SHA-256 para lookup seguro de tokens |
| **Docker** | Ambiente reprodutível para dev/staging/prod |

> **Tradeoff principal:** o backend é um **monólito modular**. Mais simples e barato no início, mas os limites de domínio já estão definidos por módulos para permitir extração futura de microserviços: media, notificações, rankings, search e sync.

> **Nota sobre Redis:** o Docker Compose inclui Redis para infraestrutura local. O código não usa BullMQ ativamente — os processors foram removidos por serem scaffolding sem implementação. Redis fica preparado para integração futura de filas de notificações, rankings e Socket.IO Redis Adapter em ambiente multi-instância.

---

## Estrutura

```text
backend/
├── prisma/
│   ├── schema.prisma       # contrato central do domínio
│   ├── migrations/         # migrations versionadas (geradas com prisma migrate dev)
│   └── seed.ts
└── src/
    ├── app.module.ts        # raiz: guards globais, throttling, JWT, módulos
    ├── main.ts              # bootstrap, CORS, global prefix, validação de env
    ├── common/
    │   ├── decorators/      # @Public(), @Permissions(), @CurrentUser()
    │   ├── dto/             # PaginationDto + paginate()
    │   ├── filters/         # AllExceptionsFilter
    │   └── guards/          # JwtAuthGuard, PermissionsGuard
    ├── config/
    │   ├── configuration.ts # factory tipada das env vars
    │   └── env.validation.ts# validação no arranque (falha rápido se env incompleto)
    ├── health/              # GET /health
    ├── modules/
    │   ├── auth/            # register, login, refresh, logout, forgot/reset-password
    │   ├── users/           # perfil, progresso, favoritos, permissões, gestão admin
    │   ├── contents/        # conteúdos públicos/protegidos, Jindungo, favoritos, progresso
    │   ├── comments/        # comentários públicos e salas privadas de discussão
    │   ├── communities/     # comunidades, membros, convites, aprovação
    │   ├── forums/          # fóruns, tópicos, respostas paginadas
    │   ├── quizzes/         # quiz, tentativas, respostas, rankings automáticos
    │   ├── notifications/   # notificações persistidas e realtime-ready
    │   ├── reports/         # denúncias com auto-ocultação aos 3 reports
    │   ├── uploads/         # signed URLs S3/R2
    │   └── sync/            # incremental sync para offline-first
    ├── prisma/              # PrismaService global (@Global)
    └── realtime/            # Socket.IO gateway com autenticação JWT obrigatória
```

---

## Domínio e Base de Dados

O [schema.prisma](./prisma/schema.prisma) modela:

- utilizadores com roles, permissões, ACL granular e fluxo de aprovação (`AccountStatus`);
- conteúdos, categorias, tags, assets, favoritos, visualizações e progresso;
- Jindungo — conteúdos de acesso restrito com pedido de acesso explícito;
- comentários públicos e salas privadas de discussão controladas pelo professor;
- comunidades públicas/privadas, memberships e convites por email/código;
- fóruns, tópicos, respostas, denúncias com auto-ocultação;
- quizzes, perguntas (com `isCorrect` oculto ao cliente), opções, tentativas e rankings cumulativos;
- notificações persistidas por evento de domínio (resposta a tópico, resposta a comentário);
- refresh tokens opacos e password reset tokens com expiração e uso único;
- auditoria, subscriptions, sync events e cursores de sincronização.

### Enums principais

| Enum | Valores |
|---|---|
| `AccountStatus` | `PENDING` · `APPROVED` · `REJECTED` |
| `RoleCode` | `USER` · `WRITER` · `PROFESSOR` · `MODERATOR` · `ADMIN` · `SUPER_ADMIN` |
| `Visibility` | `PUBLIC` · `AUTHENTICATED` · `PRIVATE` · `COMMUNITY` · `PERMISSIONED` |
| `MembershipStatus` | `PENDING` · `ACTIVE` · `REJECTED` · `BANNED` · `LEFT` |
| `CommentStatus` | `VISIBLE` · `HIDDEN` · `DELETED` |
| `ReportStatus` | `PENDING` · `REVIEWING` · `RESOLVED` · `DISMISSED` |
| `NotificationType` | `SYSTEM` · `CONTENT` · `COMMENT` · `COMMUNITY` · `FORUM` · `QUIZ` · `MODERATION` |

---

## Permissões

### Roles base

`USER` · `WRITER` · `PROFESSOR` · `MODERATOR` · `ADMIN` · `SUPER_ADMIN`

### Permissões granulares

| Código | Descrição |
|---|---|
| `CONTENT_CREATE` | Criar conteúdos |
| `CONTENT_APPROVE` / `CONTENT_PUBLISH` | Aprovar e publicar conteúdos |
| `JINDUNGO_ACCESS` | Aceder a conteúdos de acesso restrito |
| `JINDUNGO_WRITE` | Criar conteúdos Jindungo |
| `COMMENT_MODERATE` | Moderar comentários |
| `PRIVATE_ROOM_MANAGE` | Gerir salas privadas de discussão |
| `COMMUNITY_APPROVE_MEMBER` | Aprovar membros em comunidades |
| `FORUM_MODERATE` | Moderar fóruns e tópicos |
| `QUIZ_MANAGE` | Criar e gerir quizzes |
| `USER_MANAGE` | Listar e alterar estado de utilizadores (admin) |
| `ROLE_MANAGE` | Gerir roles |
| `REPORT_REVIEW` | Rever e resolver denúncias |

O RBAC cobre permissões globais. A tabela `AccessControlEntry` permite ACL por recurso — por exemplo, acesso a um conteúdo Jindungo específico, sala privada ou comunidade.

---

## Cadeia de Guards (global)

```
ThrottlerGuard → JwtAuthGuard → PermissionsGuard
```

- **ThrottlerGuard** — rate limiting (TTL e limite configuráveis por env).
- **JwtAuthGuard** — valida Bearer token em todos os endpoints; rotas marcadas com `@Public()` ficam isentas.
- **PermissionsGuard** — verifica `PermissionCode[]` no payload do JWT; actua apenas quando `@Permissions(...)` está presente.

---

## Fluxo de Autenticação

### Registo

1. `POST /auth/register` com `email`, `name`, `username`, `password`, `course`, `motivation`.
2. Conta criada com `approvalStatus: PENDING` — **nenhum token é emitido**.
3. Resposta: `{ pending: true, message: "Registration submitted. Await approval from the administrator." }`.
4. Admin aprova via `PATCH /users/:id/status` com `{ "approvalStatus": "APPROVED" }`.

### Login

- Rejeita `401` se `approvalStatus === PENDING` (aguarda aprovação).
- Rejeita `401` se `approvalStatus === REJECTED` (registo não aprovado).
- Rejeita `401` se `isActive === false` (conta suspensa).
- Em caso de sucesso, devolve `{ accessToken, refreshToken, user }`.

### Tokens

- **Access token** JWT de curta duração (padrão 15 min), assinado com `JWT_ACCESS_SECRET`.
- **Refresh token** opaco (48 bytes aleatórios), armazenado como hash SHA-256 no DB com TTL configurável (padrão 30 dias). Ao usar, o token anterior é revogado imediatamente (rotation).

### Password Reset

1. `POST /auth/forgot-password` — gera token seguro (`randomBytes(32)`), armazena hash SHA-256 com expiração de 1 hora. Resposta sempre idêntica (proteção contra enumeração de emails).
2. `POST /auth/reset-password` — valida token, atualiza password com Argon2, marca token como usado, revoga todos os refresh tokens do utilizador.

---

## Endpoints

Base URL local: `http://localhost:3001/api/v1`
Swagger: `http://localhost:3001/docs`

### Auth — público

| Método | Endpoint | Descrição |
|---|---|---|
| `POST` | `/auth/register` | Registo (devolve `pending: true`, sem tokens) |
| `POST` | `/auth/login` | Login (requer conta aprovada e activa) |
| `POST` | `/auth/refresh` | Renovar access token com refresh token |
| `POST` | `/auth/logout` | Revogar refresh token |
| `POST` | `/auth/forgot-password` | Solicitar reset de password |
| `POST` | `/auth/reset-password` | Aplicar nova password com token |
| `POST` | `/auth/verify-email` | Placeholder para verificação de email |

### Users — autenticado

| Método | Endpoint | Permissão | Descrição |
|---|---|---|---|
| `GET` | `/users/me` | — | Perfil do utilizador autenticado |
| `PATCH` | `/users/me` | — | Atualizar perfil |
| `GET` | `/users/me/progress` | — | Progresso em conteúdos |
| `GET` | `/users/me/permissions` | — | Roles e permissões actuais |
| `GET` | `/users/me/favorites` | — | Conteúdos marcados como favorito |
| `GET` | `/users` | `USER_MANAGE` | Listar todos os utilizadores (paginado, filtrável) |
| `PATCH` | `/users/:id/status` | `USER_MANAGE` | Aprovar / rejeitar / suspender utilizador |

### Contents

| Método | Endpoint | Autenticação | Descrição |
|---|---|---|---|
| `GET` | `/contents` | Opcional | Listagem de conteúdos `PUBLIC` publicados |
| `GET` | `/contents/:id` | Opcional | Detalhe de conteúdo `PUBLIC` |
| `GET` | `/contents/:id/full` | Obrigatória | Conteúdo com verificação de acesso Jindungo |
| `POST` | `/contents` | `CONTENT_CREATE` | Criar conteúdo |
| `POST` | `/contents/:id/favorite` | Autenticado | Adicionar / remover favorito |
| `PATCH` | `/contents/:id/progress` | Autenticado | Atualizar percentagem de progresso |
| `POST` | `/contents/:id/request-access` | Autenticado | Pedir acesso a conteúdo Jindungo |

**Lógica de acesso Jindungo (`GET /contents/:id/full`):** permite acesso se a visibilidade é `PUBLIC` ou `AUTHENTICATED`, ou se o utilizador tem permissão `JINDUNGO_ACCESS`, ou se tem um `AccessRequest` activo para o conteúdo. Caso contrário devolve `403 Forbidden`.

### Comments

| Método | Endpoint | Autenticação | Descrição |
|---|---|---|---|
| `GET` | `/comments/content/:contentId` | Opcional | Comentários `VISIBLE` de um conteúdo |
| `GET` | `/comments/rooms/:roomId` | Obrigatória | Mensagens de sala privada (`canView` verificado) |
| `POST` | `/comments` | Autenticado | Criar comentário (`canComment` verificado em salas; notifica autor do comentário pai se `parentId`) |
| `POST` | `/comments/rooms` | Autenticado | Criar sala privada (visibilidade sempre `PRIVATE`) |
| `POST` | `/comments/rooms/:roomId/participants/:userId` | Autenticado | Adicionar participante (apenas o professor da sala) |

### Communities

| Método | Endpoint | Autenticação | Descrição |
|---|---|---|---|
| `GET` | `/communities` | Opcional | Listar comunidades públicas |
| `POST` | `/communities` | Autenticado | Criar comunidade |
| `POST` | `/communities/:id/join` | Autenticado | Pedir entrada |
| `POST` | `/communities/:id/invitations` | Autenticado | Convidar por email / código |
| `POST` | `/communities/:id/members/:memberId/approve` | Autenticado | Aprovar membro (owner ou moderador activo) |

### Forums

| Método | Endpoint | Autenticação | Descrição |
|---|---|---|---|
| `GET` | `/forums` | Opcional | Listar fóruns públicos |
| `GET` | `/forums/:forumId/topics` | Opcional | Tópicos públicos de um fórum |
| `POST` | `/forums/:forumId/topics` | Autenticado | Criar tópico |
| `GET` | `/forums/topics/:topicId/replies` | Opcional | Respostas paginadas de um tópico |
| `POST` | `/forums/topics/:topicId/replies` | Autenticado | Responder a tópico (notifica autor do tópico) |

### Quizzes

| Método | Endpoint | Autenticação | Descrição |
|---|---|---|---|
| `GET` | `/quizzes` | Opcional | Listar quizzes públicos |
| `GET` | `/quizzes/:id` | Opcional | Quiz com perguntas e opções (**`isCorrect` omitido**) |
| `POST` | `/quizzes` | `QUIZ_MANAGE` | Criar quiz |
| `POST` | `/quizzes/:id/start` | Autenticado | Iniciar tentativa |
| `POST` | `/quizzes/attempts/:attemptId/answers` | Autenticado | Registar resposta a uma pergunta |
| `POST` | `/quizzes/attempts/:attemptId/submit` | Autenticado | Submeter tentativa (actualiza `RankingEntry`) |
| `GET` | `/quizzes/rankings` | Opcional | Ranking por `?scope=` e `?period=` |

### Reports

| Método | Endpoint | Permissão | Descrição |
|---|---|---|---|
| `POST` | `/reports` | Autenticado | Criar denúncia (auto-ocultação ao atingir 3 reports) |
| `GET` | `/reports` | `REPORT_REVIEW` | Listar denúncias pendentes |
| `PATCH` | `/reports/:id/review` | `REPORT_REVIEW` | Resolver denúncia |

### Outros

| Método | Endpoint | Autenticação | Descrição |
|---|---|---|---|
| `POST` | `/uploads/presign` | Autenticado | Gerar signed URL para upload S3/R2 |
| `GET` | `/notifications` | Autenticado | Listar notificações do utilizador |
| `PATCH` | `/notifications/:id/read` | Autenticado | Marcar notificação como lida |
| `GET` | `/sync/changes?since=` | Autenticado | Pull incremental (apenas `PUBLIC`/`AUTHENTICATED`, sem Jindungo) |
| `GET` | `/health` | Público | Health check |

---

## WebSocket (Socket.IO)

**Namespace:** `/realtime`

**Autenticação obrigatória na ligação:**

```js
const socket = io('/realtime', {
  auth: { token: '<access_token>' }
});
// Ligações sem token ou com token inválido são desconectadas imediatamente.
```

### Eventos cliente → servidor

| Evento | Payload | Descrição |
|---|---|---|
| `community.join` | `{ communityId: string }` | Entrar na sala da comunidade (verifica membership `ACTIVE`) |

### Eventos servidor → cliente

| Evento | Sala | Descrição |
|---|---|---|
| `notification.created` | `user:<id>` | Nova notificação para o utilizador |
| `comment.created` | scope arbitrário | Novo comentário numa sala |

---

## Automações de Domínio

| Trigger | Comportamento automático |
|---|---|
| 3 reports num comentário | `CommentStatus` muda para `HIDDEN` (oculto, preservado para moderação) |
| 3 reports numa resposta de fórum | `deletedAt` preenchido (soft delete) |
| 3 reports num tópico | `deletedAt` preenchido (soft delete) |
| Submissão de quiz | `RankingEntry` actualizado para `scope=quiz` e `scope=global`, período `all` (cumulativo) |
| Resposta a tópico de fórum | Notificação persistida para o autor do tópico (se diferente do autor da resposta) |
| Resposta a comentário com `parentId` | Notificação persistida para o autor do comentário pai (se diferente) |

---

## Segurança

| Camada | Implementação |
|---|---|
| Passwords | Argon2 (resistente a GPU) |
| Refresh tokens | Opaco + hash SHA-256 + revogação por rotation |
| Password reset | `randomBytes(32)`, hash SHA-256, expiração 1h, uso único, resposta constante (anti-enumeração) |
| Aprovação de conta | `approvalStatus: PENDING` bloqueia login até admin aprovar; `REJECTED` bloqueia permanentemente |
| IDOR — salas | Apenas o professor da sala pode adicionar participantes; `canView` e `canComment` verificados |
| IDOR — comunidades | Aprovação de membro verifica se o actor é owner **ou** moderador activo da comunidade |
| CORS | Origens lidas de `CORS_ORIGINS` (CSV); em `NODE_ENV=production` sem origens → processo falha no arranque |
| WebSocket | JWT obrigatório na ligação; `community.join` verifica membership `ACTIVE` no DB |
| Sync | Apenas `PUBLIC`/`AUTHENTICATED` e não-Jindungo são incluídos no pull incremental |
| Transport | Helmet, CORS, cookie-parser, rate limiting (`@nestjs/throttler`) |
| Auditoria | `AuditLog` para operações sensíveis (ex: forgot-password) |
| Soft delete | Entidades críticas têm `deletedAt` em vez de eliminação física |

---

## Testes

```bash
cd backend
npm test
```

Ficheiros de teste:

| Ficheiro | Casos |
|---|---|
| `src/common/guards/jwt-auth.guard.spec.ts` | Rota pública · sem token · esquema errado · token inválido · token válido |
| `src/modules/auth/auth.service.spec.ts` | Email duplicado · registo pendente · utilizador inexistente · password errada · conta PENDING · conta REJECTED · conta suspensa · login com sucesso |

---

## Variáveis de Ambiente

Copia `.env.example` para `.env` e preenche:

```env
NODE_ENV=development
PORT=3001
API_PREFIX=/api/v1

# PostgreSQL
DATABASE_URL=postgresql://user:password@host:5432/dbname?schema=public

# Redis (preparado para uso futuro)
REDIS_URL=redis://localhost:6379

# JWT — gera com: openssl rand -hex 64
JWT_ACCESS_SECRET=<64-hex-chars>
JWT_ACCESS_TTL=15m
JWT_REFRESH_TTL_DAYS=30

# CORS — CSV de origens permitidas; obrigatório em produção
CORS_ORIGINS=http://localhost:3000,http://localhost:5173

# S3 / Cloudflare R2 / MinIO
S3_REGION=auto
S3_ENDPOINT=https://PROJECT_REF.storage.supabase.co/storage/v1/s3
S3_BUCKET=economia-historia
S3_ACCESS_KEY_ID=...
S3_SECRET_ACCESS_KEY=...
S3_PUBLIC_BASE_URL=...

# Rate limiting
RATE_LIMIT_TTL=60
RATE_LIMIT_MAX=120
```

---

## Execução

### Pré-requisito: gerar a migration inicial

Antes do primeiro deploy ou CI, gera o diretório `prisma/migrations/` **uma única vez** em ambiente de desenvolvimento:

```bash
cd backend
npx prisma migrate dev --name init
```

A partir daí todos os ambientes usam `prisma migrate deploy` — aplicação idempotente e segura.

### Desenvolvimento com Supabase

```bash
cd backend
npm ci
npx prisma generate
npx prisma migrate deploy
npm run prisma:seed
npm run start:dev
```

### Docker (serviços cloud)

```bash
cd backend
docker compose up api --build
# O container executa migrate deploy antes de arrancar.
```

### Docker (infraestrutura local completa)

```bash
cd backend
docker compose --profile local-infra up --build
```

Configura `.env` com os valores locais:

```env
DATABASE_URL=postgresql://postgres:postgres@postgres:5432/economia_historia?schema=public
REDIS_URL=redis://redis:6379
S3_REGION=auto
S3_ENDPOINT=http://minio:9000
S3_BUCKET=economia-historia
S3_ACCESS_KEY_ID=minioadmin
S3_SECRET_ACCESS_KEY=minioadmin
S3_PUBLIC_BASE_URL=http://localhost:9000/economia-historia
```

---

## CI/CD

O workflow `.github/workflows/backend-ci.yml` executa em cada PR e push para `main` em `backend/**`:

1. `npm ci` — install determinístico a partir do lockfile
2. `npx prisma generate` + `npx prisma validate`
3. `npx prisma migrate deploy` — aplica migrations na DB de CI
4. `npm run build` — compilação TypeScript
5. `npm test` — testes unitários

Variáveis de CI necessárias: `DATABASE_URL`, `JWT_ACCESS_SECRET`, `REDIS_URL`.

---

## Dockerfile (produção)

Build multi-stage com três etapas:

| Etapa | O que faz |
|---|---|
| `deps` | `npm ci` no lockfile — instala dependências de forma determinística |
| `builder` | `prisma generate` + `nest build` — compila para `dist/` |
| `runner` | Imagem mínima; copia `dist/`, `prisma/` e `node_modules` com `--chown=node:node`; executa como `USER node` (sem root) |

**As migrations não são executadas no arranque do container.** Devem ser aplicadas via job separado (`prisma migrate deploy`) antes do rollout do serviço.

---

## Offline-First

O backend prepara sincronização incremental:

- `updatedAt` e `version` em entidades sincronizáveis;
- `SyncEvent` para event log incremental;
- `SyncCursor` por utilizador/dispositivo/âmbito;
- `GET /sync/changes?since=<ISO8601>` — devolve apenas conteúdos `PUBLIC`/`AUTHENTICATED` não-Jindungo alterados após a data indicada.

Estratégia futura: Flutter guarda cache local, envia mutations com `clientOperationId`, servidor resolve conflitos por versão (`server-wins` para conteúdo editorial, `merge` para progresso e comentários quando possível).

---

## Escalabilidade

**Fase inicial — monólito modular:**
- PostgreSQL gerido (Supabase / Neon / RDS)
- Redis gerido (Upstash / Redis Cloud / ElastiCache)
- Object storage S3/R2 com CDN
- Deploy em container único

**Fase de crescimento:**
- Workers BullMQ separados para media, notificações e rankings
- OpenSearch / Meilisearch para pesquisa full-text
- Read replicas PostgreSQL para feed e conteúdo
- Socket.IO com Redis Adapter para múltiplas instâncias
- Extração de serviços: media · notifications · ranking · search · sync

**Cloud recomendada:**

| Componente | Opções |
|---|---|
| API | Railway · Fly.io · Render · ECS/Fargate |
| DB | Supabase · Neon · RDS PostgreSQL |
| Redis | Upstash · Redis Cloud · ElastiCache |
| Storage | Cloudflare R2 (egress barato) · AWS S3 |
| CDN | Cloudflare |
| Observabilidade | Grafana Cloud · Sentry · OpenTelemetry |

---

## Clientes

**Flutter:**
- Paginação `page` / `limit` em todas as listagens
- JWT access + refresh token com rotation automática
- Uploads por signed URL (sem proxy pelo backend)
- `GET /sync/changes?since=` para sincronização offline-first
- Payloads pequenos e cacheáveis

**Next.js:**
- REST simples para SSR / ISR
- Conteúdos públicos sem autenticação para SEO
- Bearer token em rotas autenticadas
- Assets servidos via CDN
- Swagger/OpenAPI em `/docs` para geração de SDK TypeScript
