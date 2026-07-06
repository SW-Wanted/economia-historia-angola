# Web

Frontend web da plataforma **Economia com História — Angola**.

Aplicação **SPA (Single Page Application)** que consome a API REST do backend (NestJS) e espelha, em ambiente web, a experiência da app mobile em Flutter.

---

## Stack de Desenvolvimento

| Tecnologia | Versão | Uso |
|---|---|---|
| React | 18 | Biblioteca de UI |
| React Router | 6 | Roteamento client-side (SPA) |
| Vite | 5 | Dev server, bundler e build |
| TypeScript | 5.x | Tipagem estática |
| TailwindCSS | 3.x | Estilização (com PostCSS + Autoprefixer) |

> **Sem framework SSR, sem bibliotecas externas de estado ou de dados.** A gestão de estado é feita com **React Context** (`AuthContext`, `AuthGateContext`, `RegistrationContext`) e o acesso à API com um **cliente `fetch` próprio** (`src/services/api/client.ts`), sem Axios, Zustand, shadcn/ui ou Supabase.

---

## Arquitetura

```
Browser → Vite dev server (:5173) → proxy /api → Backend NestJS (:3001) → PostgreSQL
```

- **Autenticação:** JWT (access + refresh) emitidos pelo backend. Tokens guardados em `localStorage`
  (`eca_access_token`, `eca_refresh_token`). Ver `src/services/api/client.ts` e `src/contexts/AuthContext.tsx`.
- **Refresh automático:** em respostas `401`, o cliente tenta renovar o token uma vez (single-flight) e repete
  o pedido; se falhar, limpa a sessão e redireciona para `/login`.
- **Proxy de desenvolvimento:** o `vite.config.ts` reencaminha `/api` para `http://localhost:3001`,
  evitando problemas de CORS em dev.
- **Visitante (guest):** rotas públicas acessíveis sem sessão; ações protegidas abrem um diálogo de
  autenticação (`AuthGateContext`).

---

## Estrutura de Pastas

```
web/
├── index.html                  ← ponto de entrada HTML (Vite)
├── vite.config.ts              ← config Vite + proxy /api → :3001
├── tailwind.config.ts
├── postcss.config.js
├── tsconfig.json
├── .env.local                  ← variáveis de ambiente (dev)
└── src/
    ├── main.tsx                ← bootstrap React + BrowserRouter
    ├── App.tsx                 ← composição dos Context providers
    ├── routes/
    │   └── AppRoutes.tsx       ← definição das rotas
    ├── pages/                  ← páginas (Login, Explorar, Forum, QuizHub, Perfil, ...)
    ├── components/
    │   ├── ui/                 ← primitivos de UI (EhButton, EhCard, EmptyState, ...)
    │   ├── AppShell.tsx        ← layout global (sidebar + bottom nav)
    │   ├── Sidebar.tsx
    │   ├── MobileBottomNav.tsx
    │   ├── ProtectedRoute.tsx  ← guarda de rota autenticada
    │   ├── PermissionRoute.tsx ← guarda de rota por permissão
    │   └── AuthRequired.tsx
    ├── contexts/
    │   ├── AuthContext.tsx         ← sessão, login/registo/logout, permissões
    │   ├── AuthGateContext.tsx     ← diálogo de autenticação para visitantes
    │   └── RegistrationContext.tsx ← estado do cadastro em 2 passos
    ├── services/
    │   ├── api/                ← cliente fetch + serviços por domínio
    │   │   ├── client.ts       ← wrapper fetch, tokens, refresh automático
    │   │   ├── auth.service.ts
    │   │   ├── user.service.ts
    │   │   ├── content.service.ts
    │   │   ├── comments.service.ts
    │   │   ├── forum.service.ts
    │   │   ├── quiz.service.ts
    │   │   ├── notification.service.ts
    │   │   ├── reports.service.ts
    │   │   └── writer-application.service.ts
    │   └── types/
    │       └── api.types.ts    ← tipos partilhados da API
    ├── styles/
    │   └── index.css           ← Tailwind + estilos base
    └── utils/
        └── errors.ts
```

---

## Variáveis de Ambiente

As variáveis são expostas ao cliente pelo Vite através do prefixo **`VITE_`** (não `NEXT_PUBLIC_`).
O ficheiro de desenvolvimento é `.env.local`:

```env
# Usa o proxy do Vite (ver vite.config.ts) — sem problemas de CORS em desenvolvimento.
# Para builds de produção, aponta para o URL do backend implantado.
VITE_API_URL=/api/v1
```

| Variável | Descrição | Default (se omitida) |
|---|---|---|
| `VITE_API_URL` | Base URL da API. Em dev usa-se `/api/v1` (via proxy). Em produção, o URL absoluto do backend, ex.: `https://api.exemplo.com/api/v1`. | `http://localhost:3001/api/v1` |

> O ficheiro `.env.example` do diretório contém variáveis legadas de uma stack anterior (Next.js + Supabase)
> que **não são usadas** por esta aplicação. Usa `.env.local` com `VITE_API_URL`.

---

## Instalação e Execução

Pré-requisito: **backend a correr em `http://localhost:3001`** (ver [`backend/README.md`](../backend/README.md)).

```bash
# Instalar dependências
npm install

# Rodar em modo de desenvolvimento
npm run dev
```

A aplicação fica disponível em **`http://localhost:5173`** (porta default do Vite).

### Comandos disponíveis

```bash
npm run dev        # Servidor de desenvolvimento (Vite) com HMR
npm run build      # Build de produção para dist/
npm run preview    # Servir localmente o build de produção
```

> Não existem scripts `lint` nem `start` neste `package.json`.

---

## Deploy

Build estático gerado por `npm run build` (pasta `dist/`), servível por qualquer host de estáticos
(Vercel, Netlify, Nginx, etc.). Em produção, define `VITE_API_URL` com o URL absoluto do backend
e garante que essa origem está em `CORS_ORIGINS` no backend.

---

## Convenções de Código

- Componentes em `PascalCase` — `QuizCard.tsx`
- Funções e variáveis em `camelCase` — `fetchConteudos()`
- Todos os componentes são funcionais com TypeScript
- Sem `any` — tipagem explícita sempre
