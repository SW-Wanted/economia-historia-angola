import 'dotenv/config';
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient, PermissionCode, RoleCode } from '@prisma/client';

const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  throw new Error('DATABASE_URL is required to run the Prisma seed');
}

const prisma = new PrismaClient({
  adapter: new PrismaPg({ connectionString }),
});

const rolePermissions: Record<RoleCode, PermissionCode[]> = {
  USER: [PermissionCode.COMMENT_CREATE, PermissionCode.FORUM_TOPIC_CREATE],
  WRITER: [
    PermissionCode.COMMENT_CREATE,
    PermissionCode.FORUM_TOPIC_CREATE,
    PermissionCode.CONTENT_CREATE,
    PermissionCode.CONTENT_UPDATE_OWN,
    PermissionCode.JINDUNGO_WRITE,
  ],
  PROFESSOR: [
    PermissionCode.COMMENT_CREATE,
    PermissionCode.FORUM_TOPIC_CREATE,
    PermissionCode.CONTENT_CREATE,
    PermissionCode.CONTENT_UPDATE_OWN,
    PermissionCode.PRIVATE_ROOM_VIEW,
    PermissionCode.PRIVATE_ROOM_MANAGE,
    PermissionCode.QUIZ_MANAGE,
  ],
  MODERATOR: [
    PermissionCode.COMMENT_CREATE,
    PermissionCode.FORUM_TOPIC_CREATE,
    PermissionCode.COMMENT_MODERATE,
    PermissionCode.COMMUNITY_MODERATE,
    PermissionCode.COMMUNITY_APPROVE_MEMBER,
    PermissionCode.FORUM_MODERATE,
    PermissionCode.REPORT_REVIEW,
  ],
  ADMIN: Object.values(PermissionCode).filter((code) => code !== PermissionCode.ROLE_MANAGE),
  SUPER_ADMIN: Object.values(PermissionCode),
};

async function main() {
  for (const code of Object.values(PermissionCode)) {
    await prisma.permission.upsert({
      where: { code },
      update: {},
      create: { code, description: code.toLowerCase().replaceAll('_', ' ') },
    });
  }

  for (const [code, permissions] of Object.entries(rolePermissions) as [RoleCode, PermissionCode[]][]) {
    const role = await prisma.role.upsert({
      where: { code },
      update: { name: code.replaceAll('_', ' ') },
      create: { code, name: code.replaceAll('_', ' ') },
    });
    for (const permissionCode of permissions) {
      const permission = await prisma.permission.findUniqueOrThrow({ where: { code: permissionCode } });
      await prisma.rolePermission.upsert({
        where: { roleId_permissionId: { roleId: role.id, permissionId: permission.id } },
        update: {},
        create: { roleId: role.id, permissionId: permission.id },
      });
    }
  }

  const categories = [
    ['economia', 'Economia'],
    ['historia', 'Historia'],
    ['inflacao', 'Inflacao'],
    ['urbanizacao', 'Urbanizacao'],
    ['migracao', 'Migracao'],
    ['moeda', 'Moeda'],
    ['politicas-publicas', 'Politicas Publicas'],
    ['empreendedorismo', 'Empreendedorismo'],
  ];
  for (const [slug, name] of categories) {
    await prisma.category.upsert({ where: { slug }, update: {}, create: { slug, name } });
  }
}

main()
  .finally(async () => {
    await prisma.$disconnect();
  })
  .catch(async (error) => {
    console.error(error);
    await prisma.$disconnect();
    process.exit(1);
  });
