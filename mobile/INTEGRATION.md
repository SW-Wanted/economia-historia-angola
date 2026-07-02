# Integração Mobile ↔ Backend

Documento que descreve como o app Flutter (`mobile/flutter`) se liga ao backend
NestJS (`backend/`), as alterações feitas para tornar a integração **estável**, e
o que é preciso para a executar de ponta a ponta.

---

## 1. Visão geral

| Camada | Tecnologia | Endpoint base |
|--------|-----------|---------------|
| Mobile | Flutter (Dart) | — |
| Backend | NestJS + Prisma + Postgres | `http://<host>:3001/api/v1` |

O backend expõe um **prefixo global** `api/v1` e usa **versionamento por URI**
(`app.setGlobalPrefix('api/v1')` + `enableVersioning(URI)` em `backend/src/main.ts`).
Todos os pedidos do mobile passam pelo `ApiClient`, que concatena esse prefixo.

Fluxo de autenticação (JWT + refresh com **rotação**):

```
login/register ──► { accessToken (15 min), refreshToken (30 dias), user }
       │
       ├─ tokens persistidos (SharedPreferences)
       │
   pedido 401 (access expirado)
       │
       └─► POST /auth/refresh ──► novo par de tokens ──► repete o pedido original
```

---

## 2. Arquitetura da integração no Flutter

```
lib/core/config/api_config.dart   → resolve a URL base por plataforma
lib/services/token_store.dart     → persiste tokens (SharedPreferences)   [NOVO]
lib/services/api_client.dart      → HTTP + refresh automático em 401
lib/services/backend_service.dart → mapeia respostas para os modelos do app
lib/services/mock_data_service.dart → fallback offline-first
```

- **Offline-first:** se o backend estiver inacessível, o `BackendService`
  recorre ao `MockDataService`, e as telas de login/registo permitem continuar
  em modo offline. A app nunca fica bloqueada por falha de rede.
- **Fonte única de sessão:** o `BackendService.instance` é um singleton que
  detém o `ApiClient` e o utilizador em cache (`cachedUser`).

---

## 3. Alterações necessárias para estabilidade

Estas são as alterações aplicadas nesta integração. Sem elas, a sessão quebrava
ao fim de 15 minutos ou ao reiniciar a app, e o Android emulador não conseguia
sequer alcançar o backend.

### 3.1 Persistência de sessão — `token_store.dart` (novo)
Antes os tokens viviam apenas em memória → **sessão perdida a cada reinício** e
refresh token nunca reutilizado.

- Novo `TokenStore` guarda/lê/limpa `accessToken` e `refreshToken` em
  `SharedPreferences`.
- Dependência adicionada em `pubspec.yaml`: `shared_preferences: ^2.3.2`.

### 3.2 Renovação automática de token — `api_client.dart`
O access token expira em **15 min** (`JWT_ACCESS_TTL`). Antes, qualquer pedido
após esse prazo falhava com 401 e a sessão morria.

- `ApiClient` ganhou o callback `onUnauthorized`.
- Ao receber **401**, o client chama `onUnauthorized` (uma única vez, com guarda
  anti-recursão e sem tentar renovar o próprio `/auth/refresh`) e **repete** o
  pedido original com o novo access token.
- Refatorado para separar `_dispatch` (envio) de `_decode` (tratamento de
  resposta), permitindo a repetição limpa.

### 3.3 Wiring de sessão — `backend_service.dart`
- `_storeTokens` passou a ser assíncrono e **persiste** via `TokenStore`.
- Novo `restoreSession()`: recarrega tokens guardados no arranque e valida com
  `GET /users/me`; se inválidos, limpa a sessão.
- Novo `_refreshSession()`: liga-se a `POST /auth/refresh` (rotação) e é
  registado como `_api.onUnauthorized` no construtor.
- `logout()` agora limpa também o `TokenStore`.

### 3.4 Restauro no arranque — `main.dart`
- `main` passou a ser `async` com `WidgetsFlutterBinding.ensureInitialized()`.
- Chama `BackendService.instance.restoreSession()` antes de `runApp`, dentro de
  try/catch (nunca bloqueia o arranque). Assim, uma sessão válida sobrevive ao
  reinício da app.

### 3.5 URL base por plataforma — `api_config.dart`
O Android emulador **não alcança `localhost`** (isso é o próprio dispositivo).

- `ApiConfig.baseUrl` resolve o host automaticamente:
  - **Android emulador** → `10.0.2.2` (alias do host da máquina)
  - **iOS simulador / desktop / web** → `localhost`
- Continua a respeitar o override de build:
  `--dart-define=API_BASE_URL=https://api.exemplo.ao/api/v1`.

---

## 4. Mapa de endpoints usados pelo mobile

Todos relativos a `…/api/v1`. Correspondem 1:1 aos controllers em
`backend/src/modules/*`.

| Funcionalidade | Método + rota | Ficheiro mobile |
|---|---|---|
| Registo | `POST /auth/register` | `backend_service.register` |
| Login | `POST /auth/login` | `backend_service.login` |
| Refresh (rotação) | `POST /auth/refresh` | `backend_service._refreshSession` |
| Logout | `POST /auth/logout` | `backend_service.logout` |
| Recuperar senha | `POST /auth/forgot-password` | `backend_service.forgotPassword` |
| Perfil | `GET /users/me` | `backend_service.currentUser` |
| Estatísticas do perfil | `GET /users/me/stats` | `backend_service.profileStats` |
| Interesses + comunidades | `GET /users/me` (interests, memberships) | `backend_service.myProfileExtras` |
| Números da landing | `GET /stats/landing` | `backend_service.landingStats` |
| Conteúdos | `GET /contents?search=` | `backend_service.contents` |
| Fóruns / tópicos | `GET /forums`, `GET /forums/:id/topics` | `backend_service.forumTopics` |
| Ranking | `GET /quizzes/rankings` | `backend_service.ranking` |
| Notificações | `GET /notifications` | `backend_service.notifications` |
| Denúncias | `GET /reports`, `PATCH /reports/:id/review` | `backend_service.reports` |
| Candidatura escritor | `POST /writer-applications`, `GET /writer-applications/me` | `backend_service.submitWriterApplication` |

**Contratos importantes**
- `register` exige `password` com **mínimo de 8 caracteres** (validado também no
  cliente em `register_screen.dart`) e `email` válido. `409` → email já existe.
- `login`/`register`/`refresh` devolvem `{ accessToken, refreshToken, user }`,
  onde `user = { id, email, roles, permissions }`.
- Mapeamento de papéis (backend → app): `SUPER_ADMIN`→superAdmin, `ADMIN`→admin,
  `PROFESSOR`/`WRITER`→escritor, restante→utilizador.

---

## 4.1 Endpoints novos (perfil e landing)

Adicionados para eliminar dados fictícios das telas de perfil e landing.

### `GET /stats/landing` — público
Contagens reais para a secção "A comunidade em números" da landing.
```json
{ "members": 7, "contents": 0, "quizzes": 0 }
```
Backend: `modules/stats`. Só conta registos ativos/públicos (mesmo critério dos
endpoints públicos de listagem). No mobile, `landingStats()` devolve `null` se o
backend estiver inacessível → a landing mantém os valores de apresentação.

### `GET /users/me/stats` — autenticado
Estatísticas agregadas do perfil ("O Meu Progresso").
```json
{ "points": 0, "rank": null, "contentsCompleted": 0, "quizzesTaken": 0 }
```
- `points`: pontuação global acumulada (`RankingEntry` global, período `all`).
- `rank`: posição global (nº de utilizadores com pontuação superior + 1); `null`
  se ainda não pontuou.
- `contentsCompleted`: `Progress` com `completedAt` preenchido.
- `quizzesTaken`: `QuizAttempt` com `status = SUBMITTED`.

## 4.2 Papéis e remoção de mocks (segurança + fidelidade)

- **Fallback de papel seguro:** `cachedUser` deixou de devolver o mock
  `Manuel Kiala (Super Admin)` quando não há sessão. Passa a devolver um
  utilizador **anónimo de menor privilégio** (`Convidado`, role `utilizador`).
  Isto evita expor UI de Escritor/Admin/Super Admin a quem não tem o papel real
  enquanto o perfil ainda não carregou. O mesmo se aplica a `currentUser()`.
- **Perfil sem dados fictícios:** a tela de perfil carrega `currentUser()` +
  `profileStats()` + `myProfileExtras()` do backend e mostra um loading durante o
  carregamento. Secções sem fonte real (ex.: interesses/comunidades vazios) são
  **escondidas** em vez de mostrarem exemplos. As estatísticas fixas antigas
  (3h20 de leitura, `20`/`8`/`#14`) foram substituídas pelos valores reais.
- **Loading no login:** entre o login e o dashboard é apresentado um overlay de
  ecrã inteiro (`AppLoadingOverlay`) enquanto a sessão é autenticada e o perfil
  real (incl. papel) é carregado.

---

## 5. Como executar de ponta a ponta

### 5.1 Backend (Docker — recomendado)
A partir de `backend/` (ver também `mobile/DOCKER_BACKEND.md`):

```powershell
# 1. Infra local
docker compose --profile local-infra up -d postgres redis

# 2. API (com DB local, sem tocar no .env remoto)
docker compose run -d --service-ports --name backend-api-local `
  -e DATABASE_URL="postgresql://postgres:postgres@postgres:5432/economia_historia?schema=public" `
  -e REDIS_URL="redis://redis:6379" `
  api
```

Verificar saúde:

```powershell
Invoke-WebRequest -Uri http://localhost:3001/api/v1/health -UseBasicParsing   # {"status":"ok"}
```

Swagger: `http://localhost:3001/docs`.

> Se `POST` devolver 500, confirme que `backend-postgres-1` e `backend-redis-1`
> estão `Up` (`docker ps -a`) — os POSTs precisam gravar no banco.

### 5.2 Mobile

```powershell
cd mobile/flutter
flutter pub get

# Android emulador (usa 10.0.2.2 automaticamente)
flutter run

# iOS simulador / desktop / web (usa localhost automaticamente)
flutter run -d chrome

# Dispositivo físico / servidor remoto — fixar o endpoint:
flutter run --dart-define=API_BASE_URL=http://192.168.1.100:3001/api/v1
```

---

## 6. Variáveis de ambiente relevantes (backend)

| Variável | Default | Efeito na integração |
|---|---|---|
| `PORT` | `3001` | Porta da API (mobile assume 3001) |
| `API_PREFIX` | `/api/v1` | Prefixo global — mobile assume `api/v1` |
| `JWT_ACCESS_TTL` | `15m` | Validade do access token → dita o refresh |
| `JWT_REFRESH_TTL_DAYS` | `30` | Validade da sessão persistida no mobile |
| `CORS_ORIGINS` | (vazio → `true` fora de produção) | Em produção **defina** as origens |
| `DATABASE_URL` | — | **Obrigatória** |
| `JWT_ACCESS_SECRET` | — | **Obrigatória** |

---

## 7. Checklist de estabilidade

- [x] Tokens persistem entre reinícios da app (`SharedPreferences`).
- [x] Access token expirado (15 min) é renovado automaticamente e o pedido é repetido.
- [x] Refresh com rotação; sessão inválida faz logout limpo (sem loop de 401).
- [x] Sessão restaurada no arranque sem bloquear a UI.
- [x] URL base correta por plataforma (Android `10.0.2.2` vs `localhost`).
- [x] Override de endpoint via `--dart-define` para físico/produção.
- [x] Offline-first: falha de rede recorre a dados mock em vez de crashar.
- [x] `flutter analyze` sem erros.

## 8. Pendências / próximos passos sugeridos

- Migrar tokens para `flutter_secure_storage` (armazenamento cifrado) em produção.
- Definir `CORS_ORIGINS` explícito antes de deploy em produção.
- Cobrir `restoreSession` e o retry de 401 com testes de widget/unitários.
- Expor o estado de sessão no `AppState` para reagir a logout global na UI.
