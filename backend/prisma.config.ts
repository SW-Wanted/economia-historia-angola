import 'dotenv/config';
import { defineConfig, env } from 'prisma/config';

export default defineConfig({
  schema: 'prisma/schema.prisma',
  datasource: {
    url: env('DATABASE_URL'),
  },
  // Runner explícito do seed com `tsx` (o default do Prisma 7 tentava `bun`, que
  // não está instalado). Garante que `prisma db seed` aplica dados como o
  // superAdminGrade do fundador.
  migrations: {
    seed: 'tsx prisma/seed.ts',
  },
});
