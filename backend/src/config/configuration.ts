export const configuration = () => ({
  port: Number(process.env.PORT ?? 3001),
  apiPrefix: process.env.API_PREFIX ?? '/api/v1',
  redisUrl: process.env.REDIS_URL ?? 'redis://localhost:6379',
  jwt: {
    accessSecret: process.env.JWT_ACCESS_SECRET,
    accessTtl: process.env.JWT_ACCESS_TTL ?? '15m',
    refreshTtlDays: Number(process.env.JWT_REFRESH_TTL_DAYS ?? 30),
  },
  s3: {
    region: process.env.S3_REGION ?? 'auto',
    endpoint: process.env.S3_ENDPOINT,
    bucket: process.env.S3_BUCKET,
    accessKeyId: process.env.S3_ACCESS_KEY_ID,
    secretAccessKey: process.env.S3_SECRET_ACCESS_KEY,
    publicBaseUrl: process.env.S3_PUBLIC_BASE_URL,
  },
  rateLimit: {
    ttl: Number(process.env.RATE_LIMIT_TTL ?? 60),
    max: Number(process.env.RATE_LIMIT_MAX ?? 120),
  },
  gemini: {
    apiKey: process.env.GEMINI_API_KEY,
    model: process.env.GEMINI_MODEL ?? 'gemini-2.5-flash',
  },
  mail: {
    host: process.env.SMTP_HOST,
    port: Number(process.env.SMTP_PORT ?? 587),
    secure: process.env.SMTP_SECURE === 'true',
    user: process.env.SMTP_USER,
    // Aceita SMTP_PASSWORD ou o alias SMTP_PASS (nome comum em snippets Brevo).
    password: process.env.SMTP_PASSWORD ?? process.env.SMTP_PASS,
    from: process.env.MAIL_FROM ?? 'Economia com História <no-reply@economiahistoria.ao>',
  },
});
