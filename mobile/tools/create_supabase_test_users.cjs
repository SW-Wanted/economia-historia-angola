const path = require('node:path');

const backendDir = path.resolve(__dirname, '..', '..', 'backend');
require(path.join(backendDir, 'node_modules', 'dotenv')).config({
  path: path.join(backendDir, '.env'),
});

const argon2 = require(path.join(backendDir, 'node_modules', 'argon2'));
const { PrismaClient } = require(path.join(backendDir, 'node_modules', '@prisma', 'client'));
const { PrismaPg } = require(path.join(backendDir, 'node_modules', '@prisma', 'adapter-pg'));

const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  throw new Error('DATABASE_URL is required.');
}

const prisma = new PrismaClient({
  adapter: new PrismaPg({ connectionString }),
});

const password = 'Teste12345!';
const users = [
  {
    email: 'admin@economiahistoria.ao',
    name: 'Admin Teste',
    username: 'admin_teste',
    role: 'ADMIN',
  },
  {
    email: 'escritor@economiahistoria.ao',
    name: 'Escritor Teste',
    username: 'escritor_teste',
    role: 'WRITER',
  },
  {
    email: 'superadmin@economiahistoria.ao',
    name: 'Super Admin Teste',
    username: 'superadmin_teste',
    role: 'SUPER_ADMIN',
  },
];

async function ensureUser(user, passwordHash) {
  const role = await prisma.role.findUniqueOrThrow({
    where: { code: user.role },
  });

  const saved = await prisma.user.upsert({
    where: { email: user.email },
    update: {
      name: user.name,
      username: user.username,
      passwordHash,
      isActive: true,
      deletedAt: null,
    },
    create: {
      email: user.email,
      name: user.name,
      username: user.username,
      passwordHash,
      isActive: true,
    },
  });

  await prisma.userRole.upsert({
    where: {
      userId_roleId: {
        userId: saved.id,
        roleId: role.id,
      },
    },
    update: {},
    create: {
      userId: saved.id,
      roleId: role.id,
    },
  });

  return {
    email: saved.email,
    role: user.role,
    isActive: saved.isActive,
  };
}

async function main() {
  const passwordHash = await argon2.hash(password);
  const results = [];

  for (const user of users) {
    results.push(await ensureUser(user, passwordHash));
  }

  console.log(JSON.stringify({ password, users: results }, null, 2));
}

main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
