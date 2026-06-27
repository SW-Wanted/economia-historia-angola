# Economia com Historia — Angola · Backend

Backend em **NestJS + TypeScript + PostgreSQL + Prisma + Socket.IO** para uma plataforma educativa sobre a história económica de Angola. Serve clientes Flutter (mobile), Next.js (web) e qualquer cliente HTTP — incluindo uso direto via Swagger ou curl sem necessidade de frontend.

---

## Decisões Técnicas

| Tecnologia                      | Motivo                                                                                                       |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **NestJS 11**                   | Modular, opinativo, guards/interceptors nativos, Swagger integrado                                           |
| **TypeScript**                  | Contratos fortes para os clientes consumirem APIs previsíveis                                                |
| **PostgreSQL 16 + citext**      | RBAC/ACL, fóruns, quizzes, auditoria e queries analíticas; `citext` para emails e usernames case-insensitive |
| **Prisma 7**                    | Migrations versionadas, schema como contrato central do domínio, type-safety total                           |
| **Socket.IO**                   | Realtime para notificações, comentários e presença                                                           |
| **JWT + refresh tokens opacos** | Access token de curta duração; refresh token revogável armazenado com hash SHA-256 no DB                     |
| **Argon2**                      | Hash de passwords resistente a GPU; SHA-256 para lookup seguro de tokens opacos                              |
| **Docker multi-stage**          | Build determinístico; runner executa como utilizador não-root                                                |

> **Arquitectura:** monólito modular. Limites de domínio definidos por módulo para extracção futura de microserviços (media, notificações, rankings, search, sync).

---

## Estrutura

```text
backend/
├── prisma/
│   ├── schema.prisma          # contrato central do domínio
│   ├── migrations/            # migrations versionadas
│   └── seed.ts
└── src/
    ├── app.module.ts           # guards globais, throttling, JWT, módulos
    ├── main.ts                 # bootstrap, CORS, validação, Swagger
    ├── common/
    │   ├── decorators/         # @Public(), @Permissions(), @CurrentUser()
    │   ├── dto/                # PaginationDto + paginate()
    │   ├── filters/            # AllExceptionsFilter
    │   └── guards/             # JwtAuthGuard, PermissionsGuard
    ├── config/
    │   ├── configuration.ts    # factory tipada das env vars
    │   └── env.validation.ts   # validação no arranque
    ├── health/                 # GET /health
    ├── modules/
    │   ├── auth/               # register, login, refresh, logout, forgot/reset-password
    │   ├── users/              # perfil, progresso, favoritos, permissões, gestão admin
    │   ├── contents/           # conteúdos, Jindungo, favoritos, progresso
    │   ├── comments/           # comentários públicos e salas privadas
    │   ├── communities/        # comunidades, membros, convites
    │   ├── forums/             # fóruns, tópicos, respostas
    │   ├── quizzes/            # quiz, tentativas, respostas, rankings
    │   ├── notifications/      # notificações persistidas
    │   ├── reports/            # denúncias com auto-ocultação
    │   ├── uploads/            # signed URLs S3/R2
    │   ├── sync/               # sincronização offline-first
    │   └── writer-applications/ # candidaturas a escritor + revisão admin
    ├── prisma/                 # PrismaService global (@Global)
    └── realtime/               # Socket.IO gateway com JWT
```

---

## Domínio e Modelos

### User

Entidade central. Todos os perfis funcionais (leitor, escritor, professor, moderador, admin, super-admin) são **roles aplicados sobre um único modelo `User`** — sem entidades de conta separadas.

| Campo                                   | Tipo                      | Propósito                                                     |
| --------------------------------------- | ------------------------- | ------------------------------------------------------------- |
| `id`                                    | UUID                      | Identificador único                                           |
| `email`                                 | Citext (case-insensitive) | Login e contacto                                              |
| `passwordHash`                          | String?                   | Hash Argon2; `null` se OAuth futuro                           |
| `name`                                  | String                    | Nome de apresentação                                          |
| `username`                              | Citext?                   | Handle público opcional (ex: `@joao_silva`)                   |
| `avatarUrl`                             | String?                   | URL da foto de perfil                                         |
| `bio`                                   | String?                   | Texto breve de apresentação pública                           |
| `region` / `province` / `municipality`  | String?                   | Localização para estatísticas e filtragem geográfica          |
| `school`                                | String?                   | Instituição de ensino (recolhida no cadastro como "Instituição") |
| `course`                                | String?                   | Curso ou área de estudo; usado para personalizar sugestões de conteúdo |
| `interests`                             | String?                   | Temas selecionados no onboarding (CSV: `"Agricultura,Finanças"`); base de recomendações |
| `motivation`                            | String?                   | Texto livre sobre o porquê de aderir; recolhido no passo 2 do cadastro, opcional |
| `emailVerifiedAt`                       | DateTime?                 | Data de verificação de email; `null` se ainda não verificado  |
| `lastLoginAt`                           | DateTime?                 | Auditoria de actividade; actualizado a cada login com sucesso |
| `isActive`                              | Boolean                   | `false` → conta suspensa por admin; rejeita login com 401     |
| `createdAt` / `updatedAt` / `deletedAt` | DateTime                  | `deletedAt` para soft-delete (conta nunca apagada do DB)      |

**Relações relevantes:**

- `roles` — roles atribuídas via `UserRole` (muitos para muitos)
- `writerApplication` — candidatura a escritor (1:1 opcional); existe apenas se o utilizador se candidatou
- `reviewedApplications` — candidaturas que este utilizador reviu como admin

---

### WriterApplication

Entidade separada do `User` para gerir o processo de candidatura a escritor. Desacopla o estado de aprovação de escritor do estado da conta do utilizador.

| Campo                  | Tipo                    | Propósito                                                                            |
| ---------------------- | ----------------------- | ------------------------------------------------------------------------------------ |
| `id`                   | UUID                    | Identificador da candidatura                                                         |
| `userId`               | UUID (único)            | Utilizador que se candidatou; cada utilizador tem no máximo uma candidatura activa   |
| `status`               | WriterApplicationStatus | Estado actual da candidatura (ver enum abaixo)                                       |
| `fullName`             | String                  | Nome completo para publicação de artigos                                             |
| `photoUrl`             | String?                 | Foto do autor para o perfil público de escritor                                      |
| `biography`            | String                  | Apresentação do autor visível nos artigos                                            |
| `academicBackground`   | String                  | Formação académica (ex: "Licenciatura em Economia, UAN 2018")                        |
| `institution`          | String                  | Instituição actual (universidade, empresa, organização)                              |
| `specialization`       | String                  | Área principal de especialização                                                     |
| `researchExperience`   | String                  | Experiência em investigação (anos, projectos, publicações)                           |
| `previousPublications` | String?                 | Links ou referências de publicações anteriores                                       |
| `portfolio`            | String?                 | URL de website, CV ou portefólio                                                     |
| `economicHistoryAreas` | String                  | Áreas de história económica que domina (CSV: `"História Colonial,Economia Moderna"`) |
| `languages`            | String                  | Idiomas de escrita (CSV: `"PT,EN,FR"`)                                               |
| `interestTopics`       | String                  | Temas de interesse para publicar (CSV)                                               |
| `documentUrl`          | String?                 | URL do documento de identificação carregado via `/uploads/presign`                   |
| `reviewedBy`           | UUID?                   | Admin que reviu a candidatura                                                        |
| `reviewNotes`          | String?                 | Notas internas do admin para o candidato                                             |
| `rejectionReason`      | String?                 | Razão específica em caso de `REJECTED`                                               |
| `submittedAt`          | DateTime                | Data de submissão (preenchida automaticamente)                                       |
| `reviewedAt`           | DateTime?               | Data de decisão do admin                                                             |
| `updatedAt`            | DateTime                | Última actualização (inclui resubmissões)                                            |

---

### Role e Permission

Estrutura RBAC com dois níveis:

**`Role`** — papel funcional do utilizador:

- `USER` — utilizador autenticado base; acesso a conteúdos, quizzes, fóruns, comentários
- `WRITER` — cria e edita os próprios artigos, quizzes e fóruns
- `PROFESSOR` — gere salas privadas, turmas e conteúdos exclusivos
- `MODERATOR` — modera comentários, fóruns e resolve denúncias
- `ADMIN` — gere utilizadores, candidaturas, conteúdos e toda a plataforma
- `SUPER_ADMIN` — permissões totais, incluindo gestão de admins

**`Permission`** — permissão granular atribuída a roles:

| Código                     | Descrição                                                         |
| -------------------------- | ----------------------------------------------------------------- |
| `CONTENT_CREATE`           | Criar conteúdos novos                                             |
| `CONTENT_UPDATE_OWN`       | Editar os próprios conteúdos                                      |
| `CONTENT_APPROVE`          | Aprovar conteúdos de outros para publicação                       |
| `CONTENT_PUBLISH`          | Publicar conteúdos aprovados                                      |
| `CONTENT_DELETE`           | Apagar qualquer conteúdo                                          |
| `JINDUNGO_ACCESS`          | Aceder a conteúdos de acesso restrito (Jindungo)                  |
| `JINDUNGO_WRITE`           | Criar conteúdos Jindungo                                          |
| `COMMENT_CREATE`           | Criar comentários (verificado em salas privadas)                  |
| `COMMENT_MODERATE`         | Ocultar / apagar comentários de qualquer utilizador               |
| `PRIVATE_ROOM_VIEW`        | Ver salas privadas de discussão sem ser participante              |
| `PRIVATE_ROOM_MANAGE`      | Criar salas e gerir participantes                                 |
| `COMMUNITY_CREATE`         | Criar comunidades                                                 |
| `COMMUNITY_MODERATE`       | Moderar conteúdos de uma comunidade                               |
| `COMMUNITY_APPROVE_MEMBER` | Aprovar membros em comunidades privadas                           |
| `FORUM_TOPIC_CREATE`       | Criar tópicos em fóruns                                           |
| `FORUM_MODERATE`           | Bloquear tópicos, remover respostas                               |
| `QUIZ_MANAGE`              | Criar, editar e publicar quizzes                                  |
| `USER_MANAGE`              | Listar utilizadores, suspender/activar contas, gerir candidaturas |
| `ROLE_MANAGE`              | Atribuir e remover roles a utilizadores                           |
| `REPORT_REVIEW`            | Rever e resolver denúncias                                        |

A tabela `AccessControlEntry` permite ACL por recurso — ex: acesso a um conteúdo Jindungo específico, sala privada ou comunidade — para além das permissões globais de role.

---

### Enumeradores

| Enum                      | Valores e significado                                                                                                                                                                                  |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `RoleCode`                | `USER` · `WRITER` · `PROFESSOR` · `MODERATOR` · `ADMIN` · `SUPER_ADMIN`                                                                                                                                |
| `WriterApplicationStatus` | `PENDING` (aguarda revisão) · `APPROVED` (aprovado, role WRITER atribuída) · `REJECTED` (rejeitado; utilizador mantém role USER) · `REQUEST_CHANGES` (admin pediu correcções; candidato pode reenviar) |
| `Visibility`              | `PUBLIC` (qualquer visitante) · `AUTHENTICATED` (utilizador com login) · `PRIVATE` (sala ou comunidade fechada) · `COMMUNITY` (membros activos da comunidade) · `PERMISSIONED` (ACL explícita)         |
| `ContentType`             | `VIDEO` · `PODCAST` · `TEXT` · `MICROTEXT` · `PDF` · `ARTICLE` · `AUDIO`                                                                                                                               |
| `ContentStatus`           | `DRAFT` · `PENDING_REVIEW` · `PUBLISHED` · `ARCHIVED` · `REJECTED`                                                                                                                                     |
| `MembershipStatus`        | `PENDING` (pedido de entrada) · `ACTIVE` · `REJECTED` · `BANNED` · `LEFT`                                                                                                                              |
| `InvitationStatus`        | `PENDING` · `ACCEPTED` · `EXPIRED` · `REVOKED`                                                                                                                                                         |
| `TopicStatus`             | `OPEN` · `LOCKED` (sem novas respostas) · `HIDDEN` · `ARCHIVED`                                                                                                                                        |
| `ReportStatus`            | `PENDING` · `REVIEWING` · `RESOLVED` · `DISMISSED`                                                                                                                                                     |
| `CommentStatus`           | `VISIBLE` · `HIDDEN` (auto-ocultado aos 3 reports) · `DELETED`                                                                                                                                         |
| `QuizAttemptStatus`       | `STARTED` · `SUBMITTED` · `ABANDONED`                                                                                                                                                                  |
| `NotificationType`        | `SYSTEM` · `CONTENT` · `COMMENT` · `COMMUNITY` · `FORUM` · `QUIZ` · `MODERATION`                                                                                                                       |
| `SubscriptionStatus`      | `ACTIVE` · `CANCELED` · `EXPIRED` · `TRIALING`                                                                                                                                                         |
| `SyncOperation`           | `CREATE` · `UPDATE` · `DELETE` — operações registadas no `SyncEvent` para sync incremental                                                                                                             |

---

## Cadeia de Guards

```
ThrottlerGuard → JwtAuthGuard → PermissionsGuard
```

- **ThrottlerGuard** — rate limiting configurável por env (`RATE_LIMIT_TTL`, `RATE_LIMIT_MAX`). Aplica-se a todos os endpoints antes de qualquer autenticação.
- **JwtAuthGuard** — verifica o Bearer token em cada pedido. Rotas com `@Public()` ficam isentas (ex: listagem de conteúdos, login, registo).
- **PermissionsGuard** — verifica `PermissionCode[]` no payload do JWT; actua apenas quando `@Permissions(...)` está declarado no controller.

---

## Fluxo de Autenticação

### Registo (acesso imediato)

```
POST /auth/register
{
  "name": "...",
  "email": "...",
  "password": "...",

  // Opcionais — campos de personalização recolhidos no cadastro Flutter
  "username": "...",
  "course": "Gestão de Empresas",
  "interests": "Agricultura,Finanças,História de Angola",
  "motivation": "Quero perceber como a economia moldou Angola..."
}

→ Conta criada com role USER
→ Tokens emitidos imediatamente
→ { accessToken, refreshToken, user }
```

Não existe estado de "aprovação pendente" para registo de utilizador comum. A conta fica activa no momento do registo. Os campos `course`, `interests` e `motivation` são opcionais e servem exclusivamente para personalizar a experiência — não têm qualquer efeito na autenticação ou autorização.

### Registo como escritor

```
POST /auth/register
{ "email": "...", "name": "...", "password": "..." }
→ { accessToken, refreshToken, user }   ← utilizador já consegue fazer login

POST /writer-applications          (com Bearer token)
{ "fullName": "...", "biography": "...", ... }
→ { id, status: "PENDING", ... }        ← candidatura criada

(admin revê)

PATCH /writer-applications/:id/review
{ "decision": "APPROVED", "notes": "Excelente perfil." }
→ role WRITER atribuída automaticamente
```

Alternativamente, um utilizador já registado pode submeter a candidatura posteriormente — não é obrigatório fazê-lo no momento do registo.

### Login

```
POST /auth/login
{ "email": "...", "password": "..." }

→ 401 se password errada
→ 401 se isActive === false (conta suspensa pelo admin)
→ { accessToken, refreshToken, user }
```

### Renovação de token

```
POST /auth/refresh
{ "refreshToken": "<token opaco>" }
→ { accessToken, refreshToken, user }   ← token anterior revogado (rotation)
```

### Recuperação de password

```
POST /auth/forgot-password
{ "email": "..." }
→ { message: "If that email is registered, a reset link has been sent." }
   (resposta constante — protege contra enumeração de emails)

POST /auth/reset-password
{ "token": "<token do email>", "newPassword": "..." }
→ password actualizada + todos os refresh tokens revogados
```

---

## Swagger — Usar a API sem Frontend

O Swagger está disponível em:

```
http://localhost:3001/docs
```

### Autenticar no Swagger

1. Fazer login via `POST /auth/login` no Swagger (corpo: `{ "email": "...", "password": "..." }`)
2. Copiar o `accessToken` da resposta
3. Clicar no botão **Authorize** (canto superior direito)
4. Inserir o token no campo `BearerAuth` como: `<token>` (sem prefixo "Bearer")
5. Clicar **Authorize** — todos os pedidos seguintes usam este token

### Fluxo completo de teste no Swagger

#### 1. Criar conta e obter tokens

```
POST /auth/register
{
  "name": "Emanuel Santos",
  "email": "emanuel@example.com",
  "password": "senhasegura123",
  "course": "Gestão de Empresas",
  "interests": "Agricultura,Finanças,História de Angola",
  "motivation": "Quero perceber como a economia moldou Angola."
}
```

Guardar `accessToken` e `refreshToken` da resposta. Os campos de personalização são opcionais — o registo funciona apenas com `name`, `email` e `password`.

#### 2. Autenticar (botão Authorize) e explorar o perfil

```
GET /users/me
```

#### 3. Submeter candidatura a escritor

```
POST /writer-applications
{
  "fullName": "Emanuel dos Santos",
  "biography": "Investigador de história económica angolana com 5 anos de experiência.",
  "academicBackground": "Mestrado em Economia, ISPTEC 2022",
  "institution": "ISPTEC",
  "specialization": "Economia Colonial e Pós-Colonial",
  "researchExperience": "3 artigos publicados em revistas académicas nacionais",
  "economicHistoryAreas": "História Colonial,Economia do Petróleo,Industrialização",
  "languages": "PT,EN",
  "interestTopics": "Colonialismo,MPLA,Guerra Civil,Reconstrução Nacional"
}
```

#### 4. Aprovar candidatura (como admin)

```
PATCH /writer-applications/{id}/review
{
  "decision": "APPROVED",
  "notes": "Perfil académico sólido e experiência comprovada."
}
```

O utilizador recebe automaticamente a role `WRITER`.

#### 5. Criar um artigo (como escritor aprovado)

```
POST /contents
{
  "title": "A Economia de Angola no Século XX",
  "slug": "economia-angola-seculo-xx",
  "type": "ARTICLE",
  "body": "...",
  "visibility": "PUBLIC"
}
```

---

## Usar via curl / Postman

### Registo e login

```bash
# Registar
curl -X POST http://localhost:3001/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Emanuel","email":"e@example.com","password":"senha123"}'

# Extrair token (requer jq)
TOKEN=$(curl -s -X POST http://localhost:3001/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"e@example.com","password":"senha123"}' | jq -r '.accessToken')

echo "Token: $TOKEN"
```

### Usar token nas chamadas seguintes

```bash
# Perfil próprio
curl http://localhost:3001/api/v1/users/me \
  -H "Authorization: Bearer $TOKEN"

# Listar conteúdos públicos (sem autenticação)
curl http://localhost:3001/api/v1/contents

# Submeter candidatura a escritor
curl -X POST http://localhost:3001/api/v1/writer-applications \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "Emanuel dos Santos",
    "biography": "Investigador ...",
    "academicBackground": "Mestrado em Economia",
    "institution": "ISPTEC",
    "specialization": "Economia Colonial",
    "researchExperience": "5 anos de investigação",
    "economicHistoryAreas": "História Colonial,Economia do Petróleo",
    "languages": "PT,EN",
    "interestTopics": "Colonialismo,Reconstrução"
  }'

# Ver própria candidatura
curl http://localhost:3001/api/v1/writer-applications/me \
  -H "Authorization: Bearer $TOKEN"

# Listar candidaturas pendentes (requer USER_MANAGE)
curl "http://localhost:3001/api/v1/writer-applications?status=PENDING" \
  -H "Authorization: Bearer $ADMIN_TOKEN"
```

---

## Endpoints

Base URL local: `http://localhost:3001/api/v1`
Swagger interactivo: `http://localhost:3001/docs`

### Auth — público

| Método | Endpoint                | Descrição                                         |
| ------ | ----------------------- | ------------------------------------------------- |
| `POST` | `/auth/register`        | Cria conta e emite tokens imediatamente           |
| `POST` | `/auth/login`           | Login com email e password                        |
| `POST` | `/auth/refresh`         | Renovar access token com refresh token (rotation) |
| `POST` | `/auth/logout`          | Revogar refresh token                             |
| `POST` | `/auth/forgot-password` | Iniciar reset de password (envia token por email) |
| `POST` | `/auth/reset-password`  | Aplicar nova password com token recebido          |

### Users

| Método  | Endpoint                | Permissão     | Descrição                                                       |
| ------- | ----------------------- | ------------- | --------------------------------------------------------------- |
| `GET`   | `/users/me`             | Autenticado   | Perfil completo com roles, memberships e subscriptions          |
| `PATCH` | `/users/me`             | Autenticado   | Actualizar nome, bio, avatar, localização, curso, interesses e motivação |
| `GET`   | `/users/me/progress`    | Autenticado   | Progresso em todos os conteúdos                                 |
| `GET`   | `/users/me/permissions` | Autenticado   | Roles e permissões granulares actuais                           |
| `GET`   | `/users/me/favorites`   | Autenticado   | Conteúdos marcados como favorito                                |
| `GET`   | `/users`                | `USER_MANAGE` | Listar utilizadores (paginado, filtro `?search=`, `?isActive=`) |
| `PATCH` | `/users/:id/status`     | `USER_MANAGE` | Suspender (`isActive: false`) ou reactivar conta                |

### Writer Applications

| Método  | Endpoint                           | Permissão     | Descrição                                                                  |
| ------- | ---------------------------------- | ------------- | -------------------------------------------------------------------------- |
| `POST`  | `/writer-applications`             | Autenticado   | Submeter candidatura a escritor                                            |
| `GET`   | `/writer-applications/me`          | Autenticado   | Ver estado da própria candidatura                                          |
| `PATCH` | `/writer-applications/me/resubmit` | Autenticado   | Reenviar candidatura (apenas quando `status === REQUEST_CHANGES`)          |
| `GET`   | `/writer-applications`             | `USER_MANAGE` | Listar todas as candidaturas (filtro `?status=PENDING`)                    |
| `GET`   | `/writer-applications/:id`         | `USER_MANAGE` | Ver detalhe completo de uma candidatura                                    |
| `PATCH` | `/writer-applications/:id/review`  | `USER_MANAGE` | Decisão: `APPROVED` (atribui role WRITER) · `REJECTED` · `REQUEST_CHANGES` |

**Comportamento de `PATCH /writer-applications/:id/review`:**

- `APPROVED` → `WriterApplication.status = APPROVED` + role `WRITER` atribuída ao utilizador
- `REJECTED` → `WriterApplication.status = REJECTED`; utilizador mantém role `USER`; pode submeter nova candidatura no futuro
- `REQUEST_CHANGES` → candidato recebe `reviewNotes` explicando o que corrigir; pode reenviar via `PATCH /writer-applications/me/resubmit`

### Contents

| Método  | Endpoint                       | Auth             | Descrição                                      |
| ------- | ------------------------------ | ---------------- | ---------------------------------------------- |
| `GET`   | `/contents`                    | Opcional         | Listagem `PUBLIC` publicados (paginada)        |
| `GET`   | `/contents/:id`                | Opcional         | Detalhe de conteúdo `PUBLIC`                   |
| `GET`   | `/contents/:id/full`           | Obrigatória      | Conteúdo com verificação de acesso Jindungo    |
| `POST`  | `/contents`                    | `CONTENT_CREATE` | Criar conteúdo (fica em `DRAFT`)               |
| `POST`  | `/contents/:id/favorite`       | Autenticado      | Adicionar / remover favorito (toggle)          |
| `PATCH` | `/contents/:id/progress`       | Autenticado      | Atualizar percentagem de progresso (`0`–`100`) |
| `POST`  | `/contents/:id/request-access` | Autenticado      | Pedir acesso a conteúdo Jindungo               |

**Acesso Jindungo (`GET /contents/:id/full`):** permite se `PUBLIC` ou `AUTHENTICATED`, ou se o utilizador tem permissão `JINDUNGO_ACCESS`, ou se tem `AccessRequest` activo. Caso contrário devolve `403`.

### Comments

| Método | Endpoint                                       | Auth        | Descrição                                                         |
| ------ | ---------------------------------------------- | ----------- | ----------------------------------------------------------------- |
| `GET`  | `/comments/content/:contentId`                 | Opcional    | Comentários `VISIBLE` de um conteúdo                              |
| `GET`  | `/comments/rooms/:roomId`                      | Obrigatória | Mensagens de sala privada (`canView` verificado)                  |
| `POST` | `/comments`                                    | Autenticado | Criar comentário; se `parentId`, notifica autor do comentário pai |
| `POST` | `/comments/rooms`                              | Autenticado | Criar sala privada (visibilidade `PRIVATE`)                       |
| `POST` | `/comments/rooms/:roomId/participants/:userId` | Autenticado | Adicionar participante (só o professor da sala)                   |

### Communities

| Método | Endpoint                                     | Auth        | Descrição                                  |
| ------ | -------------------------------------------- | ----------- | ------------------------------------------ |
| `GET`  | `/communities`                               | Opcional    | Listar comunidades públicas                |
| `POST` | `/communities`                               | Autenticado | Criar comunidade                           |
| `POST` | `/communities/:id/join`                      | Autenticado | Pedir entrada (cria membership `PENDING`)  |
| `POST` | `/communities/:id/invitations`               | Autenticado | Convidar por email / código                |
| `POST` | `/communities/:id/members/:memberId/approve` | Autenticado | Aprovar membro (owner ou moderador activo) |

### Forums

| Método | Endpoint                          | Auth        | Descrição                                     |
| ------ | --------------------------------- | ----------- | --------------------------------------------- |
| `GET`  | `/forums`                         | Opcional    | Listar fóruns públicos                        |
| `GET`  | `/forums/:forumId/topics`         | Opcional    | Tópicos de um fórum (paginado)                |
| `POST` | `/forums/:forumId/topics`         | Autenticado | Criar tópico                                  |
| `GET`  | `/forums/topics/:topicId/replies` | Opcional    | Respostas paginadas de um tópico              |
| `POST` | `/forums/topics/:topicId/replies` | Autenticado | Responder a tópico (notifica autor do tópico) |

### Quizzes

| Método | Endpoint                               | Auth          | Descrição                                                          |
| ------ | -------------------------------------- | ------------- | ------------------------------------------------------------------ |
| `GET`  | `/quizzes`                             | Opcional      | Listar quizzes públicos                                            |
| `GET`  | `/quizzes/:id`                         | Opcional      | Quiz com perguntas e opções (`isCorrect` **omitido** — anti-cheat) |
| `POST` | `/quizzes`                             | `QUIZ_MANAGE` | Criar quiz                                                         |
| `POST` | `/quizzes/:id/start`                   | Autenticado   | Iniciar tentativa → devolve `attemptId`                            |
| `POST` | `/quizzes/attempts/:attemptId/answers` | Autenticado   | Registar resposta a uma pergunta                                   |
| `POST` | `/quizzes/attempts/:attemptId/submit`  | Autenticado   | Submeter tentativa → actualiza `RankingEntry`                      |
| `GET`  | `/quizzes/rankings`                    | Opcional      | Ranking (`?scope=quiz&scopeId=...&period=all`)                     |

### Reports

| Método  | Endpoint              | Permissão       | Descrição                                            |
| ------- | --------------------- | --------------- | ---------------------------------------------------- |
| `POST`  | `/reports`            | Autenticado     | Criar denúncia (auto-ocultação ao atingir 3 reports) |
| `GET`   | `/reports`            | `REPORT_REVIEW` | Listar denúncias pendentes                           |
| `PATCH` | `/reports/:id/review` | `REPORT_REVIEW` | Resolver ou dispensar denúncia                       |

### Outros

| Método  | Endpoint                  | Auth        | Descrição                                                        |
| ------- | ------------------------- | ----------- | ---------------------------------------------------------------- |
| `POST`  | `/uploads/presign`        | Autenticado | Gerar signed URL para upload directo S3/R2                       |
| `GET`   | `/notifications`          | Autenticado | Listar notificações do utilizador                                |
| `PATCH` | `/notifications/:id/read` | Autenticado | Marcar notificação como lida                                     |
| `GET`   | `/sync/changes?since=`    | Autenticado | Pull incremental (apenas `PUBLIC`/`AUTHENTICATED`, sem Jindungo) |
| `GET`   | `/health`                 | Público     | Health check do servidor                                         |

---

## Automações de Domínio

| Trigger                             | Comportamento automático                                                                                       |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| 3 reports num comentário            | `Comment.status` → `HIDDEN` (preservado para moderação, invisível para leitores)                               |
| 3 reports numa resposta de fórum    | `TopicReply.deletedAt` preenchido (soft delete)                                                                |
| 3 reports num tópico                | `Topic.deletedAt` preenchido (soft delete)                                                                     |
| Submissão de quiz                   | `RankingEntry` actualizado para `scope=quiz` (específico) e `scope=global` (geral), período `all` — cumulativo |
| Resposta a tópico de fórum          | Notificação persistida para o autor do tópico (se diferente do autor da resposta)                              |
| Resposta a comentário (`parentId`)  | Notificação persistida para o autor do comentário pai (se diferente)                                           |
| Aprovação de candidatura a escritor | Role `WRITER` atribuída automaticamente ao utilizador                                                          |

Todas as automações usam o padrão **fire-and-forget** — não bloqueiam a resposta HTTP principal.

---

## WebSocket (Socket.IO)

**Namespace:** `/realtime`

```js
const socket = io('http://localhost:3001/realtime', {
  auth: { token: '<access_token>' },
});
// Ligações sem token ou com token inválido são desconectadas imediatamente.
```

### Eventos cliente → servidor

| Evento           | Payload                   | Descrição                                                           |
| ---------------- | ------------------------- | ------------------------------------------------------------------- |
| `community.join` | `{ communityId: string }` | Entrar na sala da comunidade (membership `ACTIVE` verificada no DB) |

### Eventos servidor → cliente

| Evento                 | Sala             | Descrição                                      |
| ---------------------- | ---------------- | ---------------------------------------------- |
| `notification.created` | `user:<id>`      | Nova notificação para o utilizador autenticado |
| `comment.created`      | scope arbitrário | Novo comentário numa sala                      |

---

## Segurança

| Camada             | Implementação                                                                                                         |
| ------------------ | --------------------------------------------------------------------------------------------------------------------- |
| Passwords          | Argon2 (resistente a GPU) — nunca armazenadas em claro                                                                |
| Refresh tokens     | Opaco (48 bytes) + hash SHA-256 no DB + revogação por rotation (uso único)                                            |
| Password reset     | `randomBytes(32)`, hash SHA-256, expiração 1h, uso único, resposta constante (anti-enumeração de emails)              |
| Suspensão de conta | `isActive: false` → 401 no login; definido pelo admin via `PATCH /users/:id/status`                                   |
| IDOR — salas       | Só o professor (criador) da sala pode adicionar participantes; `canView` e `canComment` verificados                   |
| IDOR — comunidades | Aprovação de membro verifica se o actor é owner **ou** moderador activo                                               |
| CORS               | Origens lidas de `CORS_ORIGINS` (CSV); em `NODE_ENV=production` sem origens configuradas → processo falha no arranque |
| WebSocket          | JWT obrigatório na ligação; `community.join` verifica membership `ACTIVE` no DB                                       |
| Sync               | Apenas `PUBLIC`/`AUTHENTICATED` não-Jindungo incluídos no pull incremental                                            |
| Transport          | Helmet, CORS, cookie-parser, rate limiting via `@nestjs/throttler`                                                    |
| Auditoria          | `AuditLog` para operações sensíveis (ex: forgot-password, alterações de role)                                         |
| Soft delete        | `deletedAt` em vez de eliminação física em entidades críticas                                                         |

---

## Testes

```bash
cd backend
npm test
```

| Ficheiro                                   | Casos                                                                                                                                    |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `src/common/guards/jwt-auth.guard.spec.ts` | Rota pública · sem header · esquema não-Bearer · token inválido · token válido (payload anexado)                                         |
| `src/modules/auth/auth.service.spec.ts`    | Email duplicado · registo cria utilizador e emite tokens · utilizador inexistente · password errada · conta suspensa · login com sucesso |

---

## Variáveis de Ambiente

Copiar `.env.example` para `.env`:

```env
NODE_ENV=development
PORT=3001
API_PREFIX=/api/v1

# PostgreSQL
DATABASE_URL=postgresql://user:password@host:5432/dbname?schema=public

# JWT — gerar com: openssl rand -hex 64
JWT_ACCESS_SECRET=<64-hex-chars>
JWT_ACCESS_TTL=15m
JWT_REFRESH_TTL_DAYS=30

# CORS — CSV de origens; obrigatório em produção
CORS_ORIGINS=http://localhost:3000,http://localhost:5173

# S3 / Cloudflare R2 / MinIO
S3_REGION=auto
S3_ENDPOINT=https://...
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

Esta secção cobre os fluxos de arranque mais comuns e como parar cada um deles sem deixar processos soltos.

### O que sobe em cada modo

| Modo                                              | Serviços activos              | Quando usar                                                        |
| ------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------ |
| `npm run start:dev`                               | Apenas a API                  | Quando já tens PostgreSQL, Redis e S3/MinIO externos configurados  |
| `docker compose up api --build`                   | API                           | Quando queres a API em container, mas usas bases/serviços externos |
| `docker compose --profile local-infra up --build` | API, PostgreSQL, Redis, MinIO | Quando queres o ambiente local completo, sem dependências externas |

### Como parar cada modo

- Execução local com Node: pressiona `Ctrl+C` no terminal onde o comando está a correr.
- `docker compose up api --build`: pressiona `Ctrl+C` para parar o container da API.
- `docker compose --profile local-infra up --build`: pressiona `Ctrl+C` para parar a stack; se quiseres remover também os volumes locais, usa `docker compose --profile local-infra down -v`.

### Como usar os serviços arrancados

- API: `http://localhost:3001`
- Swagger: `http://localhost:3001/docs`
- PostgreSQL: `localhost:5432`
- Redis: `localhost:6379`
- MinIO API: `http://localhost:9000`
- MinIO Console: `http://localhost:9001`

Se estiveres no modo `local-infra`, a API usa estes serviços internos automaticamente através do `.env` local:

- `DATABASE_URL=postgresql://postgres:postgres@postgres:5432/economia_historia?schema=public`
- `S3_ENDPOINT=http://minio:9000`
- `S3_PUBLIC_BASE_URL=http://localhost:9000/economia-historia`

No navegador, a forma mais directa de confirmar que tudo está a funcionar é abrir o Swagger e o endpoint de health:

- `http://localhost:3001/docs`
- `http://localhost:3001/health`

### Primeira execução (criar migration inicial)

```bash
cd backend
npm ci
npx prisma generate
npx prisma migrate dev --name init
npm run prisma:seed
npm run start:dev
```

> `prisma migrate dev --name init` cria o directório `prisma/migrations/` com a migration inicial. Executar **uma única vez** em desenvolvimento. A partir daí todos os ambientes usam `prisma migrate deploy`.

### Desenvolvimento com Supabase / Neon

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

`.env` para infraestrutura local:

```env
DATABASE_URL=postgresql://postgres:postgres@postgres:5432/economia_historia?schema=public
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

Variáveis de CI necessárias: `DATABASE_URL`, `JWT_ACCESS_SECRET`.

---

## Dockerfile (produção)

Build multi-stage:

| Etapa     | O que faz                                                                                                             |
| --------- | --------------------------------------------------------------------------------------------------------------------- |
| `deps`    | `npm ci` — instala dependências de forma determinística a partir do lockfile                                          |
| `builder` | `prisma generate` + `nest build` — compila para `dist/`                                                               |
| `runner`  | Imagem mínima; copia `dist/`, `prisma/` e `node_modules` com `--chown=node:node`; executa como `USER node` (sem root) |

As migrations **não são executadas no container de produção**. Devem ser aplicadas via job separado (`prisma migrate deploy`) antes do rollout.

---

## Offline-First

- `updatedAt` e `version` em entidades sincronizáveis
- `SyncEvent` — log incremental de operações (`CREATE`, `UPDATE`, `DELETE`)
- `SyncCursor` — posição de sincronização por utilizador / dispositivo / âmbito
- `GET /sync/changes?since=<ISO8601>` — devolve conteúdos `PUBLIC`/`AUTHENTICATED` não-Jindungo alterados após a data indicada

---

## Clientes

**Flutter:**

- Paginação `page` / `limit` em todas as listagens
- JWT access + refresh token com rotation automática
- Uploads por signed URL (sem proxy pelo backend)
- `GET /sync/changes?since=` para cache offline-first

**Next.js:**

- Conteúdos públicos sem autenticação (SSR/ISR)
- Bearer token em rotas autenticadas
- Assets via CDN
- Swagger em `/docs` para geração de SDK TypeScript
