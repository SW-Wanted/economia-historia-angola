# Web

Frontend web da plataforma **Economia com História — Angola**.

---

## Stack de Desenvolvimento

| Tecnologia | Versão | Uso |
|---|---|---|
| Next.js | 14 (App Router) | Framework principal |
| TypeScript | 5.x | Tipagem estática |
| TailwindCSS | 3.x | Estilização |
| shadcn/ui | latest | Componentes de UI |
| Zustand | 4.x | Gestão de estado global |
| Supabase JS | 2.x | Auth e Storage client |

---

## Estrutura de Pastas

```
web/
├── app/
│   ├── (auth)/
│   │   ├── login/
│   │   │   └── page.tsx
│   │   └── register/
│   │       └── page.tsx
│   ├── explorar/
│   │   └── page.tsx
│   ├── quiz/
│   │   └── page.tsx
│   ├── forum/
│   │   └── page.tsx
│   ├── perfil/
│   │   └── page.tsx
│   ├── layout.tsx
│   └── page.tsx          ← Página inicial
├── components/
│   ├── ui/               ← Componentes shadcn/ui (auto-gerados)
│   └── shared/           ← Componentes reutilizáveis do projecto
├── lib/
│   ├── api.ts            ← Funções de chamada ao backend
│   ├── supabase.ts       ← Cliente Supabase
│   └── utils.ts
├── public/
│   └── images/
├── .env                  ← Variáveis de ambiente
├── .env.example          ← Template
├── tailwind.config.ts
├── next.config.ts
└── package.json
```

---

## Variáveis de Ambiente

Copia `.env.example` para `.env` e preenche os valores:

```env
NEXT_PUBLIC_API_URL=http://localhost:3001
NEXT_PUBLIC_SUPABASE_URL=https://xxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

---

## Instalação e Execução

```bash
# Instalar dependências
npm install

# Copiar variáveis de ambiente
cp .env.example .env

# Rodar em modo de desenvolvimento
npm run dev
```

A aplicação fica disponível em `http://localhost:3000`.

### Outros comandos

```bash
npm run build      # Build de produção
npm run start      # Correr build de produção
npm run lint       # Verificar erros de código
```

---

## Deploy

O deploy é feito automaticamente no **Vercel** a cada push para a branch `main`.

O pipeline CI (`.github/workflows/ci-web.yml`) valida o build antes de qualquer merge.

---

## Convenções de Código

- Componentes em `PascalCase` — `QuizCard.tsx`
- Funções e variáveis em `camelCase` — `fetchConteudos()`
- Pastas em `kebab-case` — `quiz-card/`
- Todos os componentes são funcionais com TypeScript
- Sem `any` — tipagem explícita sempre