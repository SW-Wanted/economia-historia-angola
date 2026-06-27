export function validateEnv(config: Record<string, unknown>) {
  const required = ['DATABASE_URL', 'JWT_ACCESS_SECRET'];
  const missing = required.filter((key) => !config[key]);
  if (missing.length > 0) {
    throw new Error(`Missing required environment variables: ${missing.join(', ')}`);
  }

  const placeholders = Object.entries(config)
    .filter(([key]) => required.includes(key) || key.startsWith('S3_') || key === 'REDIS_URL')
    .filter(([, value]) => typeof value === 'string')
    .filter(([, value]) => /(change-me|PROJECT_REF|DB_PASSWORD|SUPABASE_|REDIS_|SUPABASE_DB_HOST)/.test(value as string))
    .map(([key]) => key);

  if (placeholders.length > 0) {
    throw new Error(`Replace placeholder environment variables before starting: ${placeholders.join(', ')}`);
  }

  return config;
}
