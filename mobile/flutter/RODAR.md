# Como rodar a aplicação (backend + mobile)

Guia completo para executar a **Economia com História – Angola** ponta a ponta:
o backend NestJS e a aplicação Flutter já integrada com ele.

A integração é **offline-first**: se o backend não estiver acessível, a app
continua a funcionar com dados locais (mock) e o login/registo entram em
"modo offline".

---

## 1. Pré-requisitos

- **Flutter SDK** 3.12+ (`flutter --version`)
- **Node.js** 20+ e **npm** (para o backend)
- Um destes alvos para a app: **emulador Android**, dispositivo físico, ou
  Chrome/desktop (estes dois últimos exigem ativar suporte — ver secção 5).

> O ficheiro `backend/env` já vem com credenciais hospedadas (Postgres no
> Supabase + Redis no Upstash), por isso **não é preciso Docker** para
> desenvolver. (Alternativa local com Docker na secção 6.)

---

## 2. Arrancar o backend

```bash
cd backend

# 1. O NestJS lê o ficheiro ".env" — copie o "env" fornecido:
cp env .env                 # Git Bash / macOS / Linux
# PowerShell:  Copy-Item env .env

# 2. Instalar dependências
npm install

# 3. Gerar o cliente Prisma (local — sempre necessário)
npx prisma generate

# 4. Sincronizar o schema com a BD (apenas na 1ª vez ou após mudar o schema)
#    A BD do Supabase já tem o schema aplicado; este comando é idempotente.
npx prisma db push

# 5. Popular papéis, permissões e categorias (idempotente)
npm run prisma:seed

# 6. Iniciar a API (modo watch — a 1ª compilação demora ~1 min)
npm run start:dev
```

A API fica em **http://localhost:3001/api/v1** e a documentação Swagger em
**http://localhost:3001/docs** (útil para confirmar os endpoints).

> Espere pela linha `Nest application successfully started` no terminal.

> O seed **não cria utilizadores** — a primeira conta cria-se pelo ecrã de
> registo da app (secção 4).

---

## 3. Arrancar a aplicação Flutter

```bash
cd mobile/flutter
flutter pub get
```

A URL da API é configurada em tempo de compilação via `--dart-define`
(`API_BASE_URL`). **Escolha conforme o alvo:**

| Alvo                         | API_BASE_URL                          |
|------------------------------|---------------------------------------|
| Emulador Android             | `http://10.0.2.2:3001/api/v1`         |
| iOS simulator / desktop / web| `http://localhost:3001/api/v1`        |
| Dispositivo físico (Wi‑Fi)   | `http://SEU_IP_LOCAL:3001/api/v1`     |

> No emulador Android, `10.0.2.2` é o atalho para o `localhost` da máquina.
> Para dispositivo físico, use o IP da máquina (`ipconfig`) e garanta que
> ambos estão na mesma rede.

Exemplo (emulador Android):

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3001/api/v1
```

Sem `--dart-define`, usa-se o valor por omissão `http://localhost:3001/api/v1`.

> **Web (Chrome):** o backend só autoriza CORS para as origens listadas em
> `CORS_ORIGINS` no `.env` (`http://localhost:3000`, `:5173`, `:8080`). O
> Flutter web escolhe uma porta aleatória a cada arranque, que não está na
> lista — o browser bloqueia as chamadas e a app entra em "modo offline".
> **Corra sempre numa porta autorizada** (ex.: 8080):
>
> ```bash
> flutter run -d chrome --web-port=8080
> ```
>
> (Em alternativa, acrescente a porta usada a `CORS_ORIGINS` e reinicie o
> backend — mas fixar a porta é mais simples.)

---

## 4. Primeira utilização

1. No ecrã inicial, escolha **Criar conta** e complete os 3 passos do registo.
   - A **senha deve ter no mínimo 8 caracteres** (exigência do backend).
2. Ao finalizar, a conta é criada no backend e a sessão fica ativa.
3. Pode também **Entrar** com o email/senha registados.
4. O perfil e a saudação da página inicial passam a mostrar a identidade real
   (nome obtido de `/users/me`); o **Terminar sessão** (no Perfil) encerra a
   sessão no backend.

> Nota: o ecrã de denúncias só mostra dados reais para perfis com permissão
> `REPORT_REVIEW` (admin/moderador). Um utilizador normal vê os dados de
> exemplo (fallback) — comportamento esperado.

---

## 5. O que já está integrado

| Funcionalidade            | Estado                                                        |
|---------------------------|---------------------------------------------------------------|
| Login                     | `POST /auth/login` — guarda tokens, trata erros e offline     |
| Registo                   | `POST /auth/register` — dados acumulados nos 3 passos         |
| Recuperar senha           | `POST /auth/forgot-password`                                  |
| Terminar sessão           | `POST /auth/logout` + limpeza de tokens locais                |
| Identidade (perfil/home)  | utilizador autenticado em cache, com fallback offline         |
| Denúncias (moderação)     | `GET /reports` + `PATCH /reports/:id/review` (manter/remover) |

Telas de listas ligadas ao backend (todas com **fallback offline** e
indicador de carregamento via `DataLoader`):

| Tela                     | Origem dos dados                         |
|--------------------------|------------------------------------------|
| Fórum / Gerir fóruns     | `GET /forums` → tópicos                  |
| Ranking / Ranking local  | `GET /quizzes/rankings`                  |
| Notificações             | `GET /notifications`                     |
| Biblioteca / Modo offline| `GET /contents`                          |
| Conteúdos da província   | `GET /contents` + `GET /quizzes/rankings`|
| Pesquisa                 | `GET /contents` + `GET /forums`          |
| Identidade (perfil/home/admin) | utilizador autenticado em cache    |

Conteúdo puramente local (offline-first), mantido em dados de exemplo por não
ter um endpoint 1:1: FAQ/Ajuda, perguntas de quiz, threads de comentários,
categorias da comunidade e a cadeia de Super Admins (demonstração da
hierarquia).

A camada de rede vive em:
- `lib/core/config/api_config.dart` — URL base
- `lib/services/api_client.dart` — cliente HTTP + tokens
- `lib/services/backend_service.dart` — chamadas + fallback offline

### Verificar a integração (testes)

Com o backend **ligado**, corra o teste de integração real (faz
registo → logout → login → perfil contra a API):

```bash
cd mobile/flutter
flutter test --run-skipped test/backend_integration_test.dart
```

O `flutter test` normal (sem backend) continua verde — o teste de integração
é saltado automaticamente.

---

## 6. Alternativa: infraestrutura local com Docker

Se preferir Postgres/Redis locais em vez dos serviços hospedados:

```bash
cd backend
docker compose --profile local-infra up -d postgres redis
# Ajuste no .env:
#   DATABASE_URL=postgresql://postgres:postgres@localhost:5432/economia_historia?schema=public
#   REDIS_URL=redis://localhost:6379
npx prisma db push && npm run prisma:seed && npm run start:dev
```

---

## 7. Notas

- **Android cleartext:** a app já inclui permissão de INTERNET e uma
  `network_security_config` que autoriza HTTP apenas para `10.0.2.2`,
  `localhost` e `127.0.0.1` (produção permanece HTTPS).
- **Web/Desktop:** o projeto está configurado para Android. Para correr em
  Chrome/Windows, execute uma vez `flutter create .` na pasta `mobile/flutter`
  para adicionar as plataformas. No Chrome, arranque numa porta autorizada
  pelo CORS do backend (ver nota na secção 3): `flutter run -d chrome
  --web-port=8080`.
- **Segurança:** o `backend/env` contém segredos reais commitados no
  repositório. Recomenda-se rotacioná-los e mantê-los fora do controlo de
  versões.
