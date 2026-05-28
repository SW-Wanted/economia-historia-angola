# Arquitectura Enterprise

## Estilo Arquitectural

O sistema começa como monólito modular com Clean Architecture pragmática:

- controllers: transporte HTTP e Swagger;
- DTOs: validação de entrada;
- services: casos de uso e regras de negócio;
- Prisma: persistência;
- guards: autenticação/autorização transversal;
- gateway: realtime;
- queues/events: trabalhos assíncronos e integração futura.

DDD aplica-se nos limites: `auth`, `users`, `contents`, `communities`, `forums`, `comments`, `quizzes`, `notifications`, `uploads`, `sync`.

CQRS completo ainda não é necessário. A recomendação é introduzir CQRS quando feeds, rankings e pesquisa começarem a exigir modelos de leitura separados.

## Event-Driven

Eventos recomendados:

- `content.published`
- `comment.created`
- `community.member_requested`
- `community.member_approved`
- `quiz.attempt_submitted`
- `ranking.recomputed`
- `notification.created`
- `sync.event_recorded`

No início podem ser publicados para BullMQ. No crescimento, migrar para Kafka, NATS, RabbitMQ, SQS ou EventBridge.

## Módulos Extraíveis Futuramente

- Media Service: compressão, thumbnails, transcrição.
- Notification Service: email, push, websocket.
- Ranking Service: cálculo periódico e materialização.
- Search Service: indexação e autocomplete.
- Sync Service: conflict resolution avançado.

## Observabilidade

Mínimo production-ready:

- logs JSON estruturados;
- request id/correlation id;
- métricas RED: rate, errors, duration;
- tracing OpenTelemetry;
- alertas de erro 5xx, latência p95, saturação DB/Redis;
- Sentry para exceptions.
