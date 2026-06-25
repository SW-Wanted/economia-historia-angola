# Backend com Docker

## Estado atual

O backend foi iniciado com Docker e está disponível em:

```text
http://localhost:3001/api/v1
```

A documentação Swagger respondeu com status `200` em:

```text
http://localhost:3001/docs
```

## Containers em execução

```text
backend-api-local   API NestJS na porta 3001
backend-postgres-1  Postgres local na porta 5432
backend-redis-1     Redis local na porta 6379
```

## Observação sobre o banco

O container padrão `backend-api-1` tentou usar o banco remoto configurado no `.env`
e falhou com:

```text
P1001: Can't reach database server at aws-1-eu-central-1.pooler.supabase.com:5432
```

Por isso, a API foi iniciada usando Postgres e Redis locais dentro do Docker,
sem alterar o arquivo `.env`.

Variáveis usadas para a API local:

```text
DATABASE_URL=postgresql://postgres:postgres@postgres:5432/economia_historia?schema=public
REDIS_URL=redis://redis:6379
```

Durante a inicialização, o Prisma executou:

```text
npx prisma generate
npx prisma db push
npm run prisma:seed
```

Depois o Nest iniciou em modo watch com:

```text
npm run start:dev
```

## Ver logs

```powershell
docker logs -f backend-api-local
```

## Ver containers

```powershell
docker ps
```

Ou, a partir da pasta `backend`:

```powershell
docker compose --profile local-infra ps
```

## Erro 500 em requisições POST

Se uma requisição como `POST /api/v1/auth/register` responder:

```json
{
  "statusCode": 500,
  "path": "/api/v1/auth/register",
  "error": "Internal server error"
}
```

verifique se o Postgres local ainda está rodando. Neste ambiente, a API ficou
ativa, mas `backend-postgres-1` e `backend-redis-1` tinham parado. Como os POSTs
precisam gravar no banco, a API devolvia erro 500.

Confirme o estado:

```powershell
docker ps -a
```

Se aparecer algo como:

```text
backend-api-local   Up
backend-postgres-1  Exited
backend-redis-1     Exited
```

religue a infraestrutura local a partir da pasta `backend`:

```powershell
docker compose --profile local-infra start postgres redis
```

Depois teste a saúde da API:

```powershell
Invoke-WebRequest -Uri http://localhost:3001/api/v1/health -UseBasicParsing
```

Resposta esperada:

```json
{"status":"ok"}
```

Após religar o banco, o registro voltou a funcionar com status `201`.

## Parar somente a API

```powershell
docker stop backend-api-local
```

## Parar Postgres e Redis

A partir da pasta `backend`:

```powershell
docker compose --profile local-infra stop postgres redis
```

## Subir novamente

A partir da pasta `backend`, primeiro suba a infraestrutura local:

```powershell
docker compose --profile local-infra up -d postgres redis
```

Depois inicie a API usando as variáveis locais:

```powershell
docker compose run -d --service-ports --name backend-api-local `
  -e DATABASE_URL="postgresql://postgres:postgres@postgres:5432/economia_historia?schema=public" `
  -e REDIS_URL="redis://redis:6379" `
  api
```

Se o container `backend-api-local` já existir, remova-o antes de recriar:

```powershell
docker rm backend-api-local
```
