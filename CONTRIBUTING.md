# 🛠 Guia de Contribuição

## 📋 Regras Fundamentais

| # | Regra | Descrição | ❌ Não fazer | ✅ Fazer |
|---|-------|-----------|-------------|---------|
| 1 | **Não fazer push direto na `main`** | Todo o trabalho deve vir de uma branch secundária e passar por um PR | `git push origin main` direto | Criar branch + abrir PR |
| 2 | **Comunicação é essencial** | Dúvidas sobre tarefas devem ser comentadas na Issue | WhatsApp/Discord para perguntas da tarefa | Comentar na Issue do GitHub |
| 3 | **Cumprir prazos** | PR aberto **24h antes** do prazo da Issue | Abrir PR em cima da hora | Abrir PR com pelo menos 1 dia de antecedência |
| 4 | **Respeitar o CI/CD** | Corrigir erros do Workflow antes da revisão | Pedir review com ❌ no CI | Rodar testes localmente antes do push |
| 5 | **Code Review obrigatório** | Pelo menos 1 aprovação antes do merge | Fazer merge sem revisão | Aguardar aprovação de um colega |

---

## 🔄 Fluxo de Trabalho

### 1. Escolher uma Tarefa
Vá ao separador **[Projects](https://github.com/users/SW-Wanted/projects/6)** ou **[Issues](https://github.com/SW-Wanted/economia-historia-angola/issues)**. Escolha uma tarefa atribuída a si e mova para a coluna **"In Progress"**.

<img width="1039" height="671" alt="image" src="https://github.com/user-attachments/assets/96c2b494-fd36-4ddd-9c07-1b000e7ee0d3"/>

<img width="1039" height="671" alt="image" src="https://github.com/user-attachments/assets/e4f19be5-7bae-498e-9a3b-8c916ddeeb02" />


### 2. Criar uma Branch

Crie uma branch localmente seguindo o padrão de nomenclatura:

<img width="1039" height="671" alt="image" src="https://github.com/user-attachments/assets/255f00cc-03ce-4895-bcb5-93dd43c32520" />

<img width="1039" height="671" alt="image" src="https://github.com/user-attachments/assets/7e1954e8-5896-4eaf-ae14-535da6c46fa1" />

<img width="1039" height="671" alt="image" src="https://github.com/user-attachments/assets/4fab6155-f011-4231-a537-409e82e82f5b" />

<img width="1325" height="295" alt="image" src="https://github.com/user-attachments/assets/2fb059b4-2da5-4ee9-84a4-cf2d7fe08926" />

**Formato:** `tipo/componente/primeiro-nome/descricao-curta`

**Tipos disponíveis:**
- `docs/` → Documentação
- `feat/` → Nova funcionalidade
- `fix/` → Correção de bug
- `design/` → Alterações de UI/UX
- `refactor/` → Refatoração de código
- `test/` → Adição ou correção de testes
- `chore/` → Configurações, dependências
- `perf/` → Melhorias de performance
- `security/` → Correções de segurança

**Componentes disponíveis:**
- `web/` → Aplicação Next.js
- `mobile/` → Aplicação Flutter
- `backend/` → API Node.js + Fastify
- `requisitos/` → Requisitos Funcionais, Não Funcionais e Regras de Negócio
- `diagramas/` → Diagrama de caso de uso e de classes
- `prototipo/` → Protótipos do figma
- `ci/` → CI/CD, workflows, configs gerais

**Exemplos:**
```bash
feat/web/emanuel/autenticacao-google
```
```bash
docs/requisitos/carlos-jose/requisitos-funcionais
```
```bash
fix/mobile/liria/correcao-navegacao-perfil
```
```bash
refactor/backend/jose/reorganizar-controllers
```
```bash
design/web/lucio/telas-quiz-figma
```
```bash
test/backend/abel/validacao-api-quiz
```
```bash
chore/ci/jofre/configurar-eslint
```

**Nota:** Para mudanças que afetam múltiplos componentes, use o componente principal ou `shared/`.

### 3. Commits (Conventional Commits)

Use mensagens de commit claras, descritivas e em **português**.

**Formato:** `tipo(escopo): descrição`

**Tipos principais:**
- `feat:` Nova funcionalidade
- `fix:` Correção de bug
- `docs:` Documentação
- `style:` Formatação, espaços (sem mudança de lógica)
- `refactor:` Refatoração sem alterar funcionalidade
- `test:` Adição/correção de testes
- `chore:` Tarefas de build, dependências
- `perf:` Melhorias de performance
- `security:` Correções de segurança

**Exemplos:**
```bash
feat(auth): implementada autenticação via Google OAuth
```
```bash
fix(mobile): corrigido crash ao abrir perfil do utilizador
```
```bash
docs(readme): actualizada secção de instalação
```
```bash
test(quiz): adicionados testes unitários para validação de respostas
```
```bash
refactor(api): reorganizada estrutura de controllers
```

**Boas práticas:**
- Use verbos no **particípio passado** (implementado, corrigido, adicionado)
- Seja específico mas conciso (máx. 72 caracteres)
- Se necessário, adicione corpo do commit com mais detalhes

📖 Referência completa: [Convenção de Commits](https://github.com/SW-Wanted/git-references/blob/main/docs/convention_commit.md)

## 📝 Documentação do Projeto

Toda a documentação técnica e de requisitos está centralizada na pasta **[`/docs`](./docs/)**.

### Estrutura de Documentação

A organização segue a seguinte hierarquia:

#### 📋 Requisitos
Documentação de requisitos e regras de negócio do sistema:

- **[Requisitos Funcionais](./docs/requisitos/funcionais.md)** — Funcionalidades e casos de uso do sistema
- **[Requisitos Não Funcionais](./docs/requisitos/nao-funcionais.md)** — Performance, segurança, usabilidade, etc.
- **[Regras de Negócio](./docs/requisitos/regras-de-negocio.md)** — Lógica e políticas do domínio

#### 🎨 Diagramas
Modelos visuais da arquitetura e design do sistema:

- **[Diagrama de Classes](./docs/diagramas/classe.md)** — Estrutura de classes e relacionamentos
- **[Diagrama de Caso de Uso](./docs/diagramas/caso-de-uso.md.md)** — Actores e Casos de Uso

#### 🖼️ Protótipo
Design e interfaces do usuário:

- **[Projeto Figma](./docs/prototipo/figma.md)** — Link e documentação do design no Figma

### Como Contribuir com Documentação

1. **Escolha o ficheiro apropriado** conforme a categoria acima
2. **Edite o ficheiro `.md`** diretamente no GitHub ou localmente
3. **Siga o formato existente** no documento para manter consistência
4. **Abra um Pull Request** com branch `docs/componente/seu-nome/descricao`
5. **Aguarde revisão** antes do merge

### Boas Práticas

- ✅ Use **Markdown** para formatação consistente
- ✅ Adicione **imagens** em `/docs/assets/` e referencie no `.md`
- ✅ Mantenha **linguagem clara** e objetiva
- ✅ Atualize a **documentação junto com o código** (não deixe para depois)
- ✅ Use **diagramas** quando necessário para facilitar compreensão

---

## 🚀 Pull Request

Ao terminar uma tarefa:

1. **Faça self-review:** Revise o seu próprio código antes de abrir o PR
2. **Push da branch:**
   ```bash
   git push origin nome-da-sua-branch
   ```
3. **Abra um Pull Request** contra a branch `main`
4. **Preencha o template** completamente (não deixe secções vazias)
5. **Assignees:** Coloque-se a si próprio
6. **Reviewers:** Marque **[SW Wanted](https://github.com/SW-Wanted)** ou membro da equipa
7. **Labels:** Adicione labels apropriadas (bug, enhancement, documentation, etc.)
8. **Linked Issues:** Referencie a issue com `Fixes #123` ou `Closes #123`
9. **CI/CD:** Aguarde os checks passarem ✅
10. **Revisão:** Aguarde aprovação. Se houver comentários, corrija prontamente
11. **Merge:** Após aprovação, o merge será feito por quem tem permissões

### ⚠️ Antes de Abrir o PR

- [ ] Código está formatado (lint passou)
- [ ] Testes passam localmente
- [ ] Documentação actualizada (se aplicável)
- [ ] Screenshots adicionados (para mudanças visuais)
- [ ] Breaking changes documentadas (se houver)

---

## 🎨 Padrões de Código e Design

### Stack Tecnológica
- **Web:** Next.js 14 + TypeScript + TailwindCSS
- **Mobile:** Flutter 3 + Dart (Material Design 3)
- **Backend:** Node.js + Fastify + TypeScript
- **Banco de Dados:** PostgreSQL
- **Autenticação:** JWT

### Padrões de Código

#### Web (Next.js)
- Use **TypeScript** para type safety
- Componentes funcionais com hooks
- CSS Modules ou TailwindCSS (evite CSS inline)
- Nomes de ficheiros: `kebab-case.tsx`
- Componentes: `PascalCase`

#### Mobile (Flutter)
- Siga **Material Design 3**
- Use providers para gestão de estado
- Nomes de ficheiros: `snake_case.dart`
- Classes: `PascalCase`

#### Backend (Node.js)
- Use **TypeScript**
- Estrutura MVC ou Clean Architecture
- Validação de inputs com Zod/Joi
- Tratamento de erros centralizado

### Design (Figma)
- Link oficial do Figma está no `README.md`
- **Não altere** cores globais, tipografia ou espaçamentos sem aprovação do Design
- Respeite os tokens de design system
- Em caso de dúvida, pergunte à equipa de Design

---

## 🔒 Segurança

Se encontrar uma **vulnerabilidade de segurança**, **NÃO** abra uma issue pública.

👉 Siga o processo descrito em [SECURITY.md](./SECURITY.md)

---

## 🧪 Testes

- **Web:** Jest + React Testing Library
- **Mobile:** Widget tests + Integration tests
- **Backend:** Jest + Supertest

**Cobertura mínima desejada:** 70%

---

## 🆘 Precisa de Ajuda?

Se estiver bloqueado em alguma tarefa:

1. **Verifique a documentação** no `/docs`
2. **Comente na Issue** explicando o bloqueio
3. **Marque no GitHub:**
   - [@SW-Wanted](https://github.com/SW-Wanted)
   - Colegas da mesma área
4. **Participe nas reuniões** de equipa para discutir obstáculos
5. **Seja proativo** e comunicativo!

---

## 📚 Recursos

- [Conventional Commits](https://github.com/SW-Wanted/git-references)
- [Next.js Docs](https://nextjs.org/docs)
- [Flutter Docs](https://docs.flutter.dev/)
- [Material Design 3](https://m3.material.io/)

---

**Obrigado por contribuir!**
