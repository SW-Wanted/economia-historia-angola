# Economia com História — Angola

> Plataforma educativa sobre história económica de Angola, disponível em Web e Mobile.

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)
[![React](https://img.shields.io/badge/Web-React%2018%20%2B%20Vite-61dafb)](./web)
[![Flutter](https://img.shields.io/badge/Mobile-Flutter%203-blue)](./mobile)
[![NestJS](https://img.shields.io/badge/Backend-NestJS%2011%20%2B%20Prisma-e0234e)](./backend)

---

## Sobre o Projecto

**Economia com História — Angola** é uma aplicação educativa que integra conteúdos históricos e económicos de forma interactiva e acessível. A plataforma permite aos utilizadores explorar conteúdos multimédia, participar em quizzes, debater no fórum e acompanhar o seu progresso de aprendizagem.

---

## Módulos

| Módulo | Descrição |
|---|---|
| Explorar Conteúdos | Vídeos, textos e podcasts sobre economia e história angolana |
| Quiz Interactivo | Perguntas contextualizadas com pontuação e ranking |
| Fórum de Discussão | Debates e troca de experiências entre utilizadores |
| Comentários | Espaço aberto para reflexões sobre os conteúdos |
| Perfil e Subscrição | Área do utilizador com histórico e notificações |

---

## Arquitectura

```mermaid
flowchart TB
    BROWSER["Browser<br/>Utilizador Web"] --> WEB["React 18 + Vite<br/>SPA + React Router"]
    PHONE["Telemóvel<br/>Android + iOS"] --> MOBILE["Flutter 3<br/>Android + iOS"]

    WEB --> API["REST API<br/>NestJS 11 + Prisma"]
    MOBILE --> API

    API --> POSTGRES["PostgreSQL 16<br/>Base de Dados"]
    API --> REALTIME["Socket.IO<br/>Realtime + Notificações"]
    API --> STORAGE["S3 / MinIO<br/>Uploads via signed URL"]

    classDef top fill:#3a3a3a,stroke:#8a8a8a,color:#f5f5f5;
    classDef web fill:#4b3fb8,stroke:#6f66d6,color:#ffffff;
    classDef mobile fill:#12539f,stroke:#2a74c4,color:#ffffff;
    classDef api fill:#0b6f5f,stroke:#25a08c,color:#dffaf4;
    classDef data fill:#8a5409,stroke:#c8892f,color:#ffe7bf;

    class BROWSER,PHONE top;
    class WEB web;
    class MOBILE mobile;
    class API api;
    class POSTGRES,REALTIME,STORAGE data;
```

---

## Estrutura do Repositório

```text
economia-historia-angola/
├── web/          → Frontend Web (React 18 + Vite + React Router + TailwindCSS)
├── mobile/       → App Mobile (Flutter 3 — Android e iOS)
├── backend/      → API REST (NestJS 11 + Prisma + PostgreSQL + Socket.IO)
└── docs/         → Artefactos académicos (requisitos, diagramas, protótipos)
```

---

## Stack de Desenvolvimento

| Camada | Tecnologia |
|---|---|
| Web | React 18, Vite 5, React Router 6, TypeScript, TailwindCSS 3 (estado via React Context; cliente `fetch` próprio) |
| Mobile | Flutter 3, Dart, Material 3, Riverpod, Go Router |
| Backend | NestJS 11, Prisma 7 ORM, TypeScript, Socket.IO |
| Base de dados | PostgreSQL 16 (extensão `citext`) |
| Auth | JWT (access + refresh) + Argon2 (no próprio backend) |
| Storage | S3 / Cloudflare R2 / MinIO (upload por signed URL) |
| Deploy Web | Estáticos (build Vite → `dist/`) |
| Deploy Backend | Docker (multi-stage) |

---

Consulta os READMEs individuais de cada pasta para instruções detalhadas:

- [`docs/README.md`](./docs/README.md)
- [`web/README.md`](./web/README.md)
- [`mobile/README.md`](./mobile/README.md)
- [`backend/README.md`](./backend/README.md)