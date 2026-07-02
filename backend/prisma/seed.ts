import 'dotenv/config';
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient, PermissionCode, RoleCode } from '@prisma/client';
import * as argon2 from 'argon2';

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
    PermissionCode.QUIZ_MANAGE,
    PermissionCode.COMMUNITY_CREATE,
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

const seededUsers: Array<{
  role: RoleCode;
  email: string;
  username: string;
  name: string;
  bio: string;
  region?: string;
  province?: string;
  municipality?: string;
  school?: string;
  course?: string;
  interests?: string;
  motivation?: string;
}> = [
  {
    role: RoleCode.USER,
    email: 'usuario@gmail.com',
    username: 'usuario',
    name: 'Utilizador Base',
    bio: 'Conta padrão para explorar a plataforma como membro comum.',
    region: 'Luanda',
    municipality: 'Talatona',
    interests: 'Economia, historia e cidadania',
  },
  {
    role: RoleCode.WRITER,
    email: 'writer@gmail.com',
    username: 'writer',
    name: 'Autor Conteudista',
    bio: 'Produz artigos e conteúdos editoriais para a plataforma.',
    region: 'Benguela',
    school: 'Escola de Comunicação',
    course: 'Jornalismo',
    interests: 'Escrita, reportagem e análise económica',
    motivation: 'Partilhar conteúdo didático e atualizado.',
  },
  {
    role: RoleCode.PROFESSOR,
    email: 'professor@gmail.com',
    username: 'professor',
    name: 'Professor da Rede',
    bio: 'Acompanha turmas, fóruns privados e quizzes de aprendizagem.',
    region: 'Huíla',
    province: 'Huíla',
    school: 'Instituto Médio',
    course: 'História e Geografia',
    interests: 'Ensino, avaliação e tutoria',
    motivation: 'Apoiar estudantes com conteúdos e atividades.',
  },
  {
    role: RoleCode.MODERATOR,
    email: 'moderador@gmail.com',
    username: 'moderador',
    name: 'Moderador Comunitário',
    bio: 'Garante a ordem nos fóruns e modera comentários e denúncias.',
    region: 'Huambo',
    interests: 'Moderação, comunidade e mediação',
    motivation: 'Manter o espaço seguro e produtivo.',
  },
  {
    role: RoleCode.ADMIN,
    email: 'admin@gmail.com',
    username: 'admin',
    name: 'Administrador do Sistema',
    bio: 'Administra conteúdos, utilizadores e permissões da plataforma.',
    region: 'Luanda',
    interests: 'Operações, segurança e suporte',
    motivation: 'Gerir a plataforma com consistência.',
  },
  {
    role: RoleCode.SUPER_ADMIN,
    email: 'superadmin@gmail.com',
    username: 'superadmin',
    name: 'Super Administrador',
    bio: 'Tem acesso total para gerir toda a aplicação.',
    region: 'Luanda',
    interests: 'Governança, auditoria e infraestrutura',
    motivation: 'Supervisionar todos os módulos do sistema.',
  },
];

async function main() {
  const passwordHash = await argon2.hash('Senha123!');

  for (const code of Object.values(PermissionCode)) {
    await prisma.permission.upsert({
      where: { code },
      update: {},
      create: { code, description: code.toLowerCase().replaceAll('_', ' ') },
    });
  }

  for (const [code, permissions] of Object.entries(rolePermissions) as [
    RoleCode,
    PermissionCode[],
  ][]) {
    const role = await prisma.role.upsert({
      where: { code },
      update: { name: code.replaceAll('_', ' ') },
      create: { code, name: code.replaceAll('_', ' ') },
    });
    for (const permissionCode of permissions) {
      const permission = await prisma.permission.findUniqueOrThrow({
        where: { code: permissionCode },
      });
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

  for (const userData of seededUsers) {
    const user = await prisma.user.upsert({
      where: { email: userData.email },
      update: {
        name: userData.name,
        username: userData.username,
        passwordHash,
        bio: userData.bio,
        region: userData.region,
        province: userData.province,
        municipality: userData.municipality,
        school: userData.school,
        course: userData.course,
        interests: userData.interests,
        motivation: userData.motivation,
        isActive: true,
      },
      create: {
        email: userData.email,
        username: userData.username,
        name: userData.name,
        passwordHash,
        bio: userData.bio,
        region: userData.region,
        province: userData.province,
        municipality: userData.municipality,
        school: userData.school,
        course: userData.course,
        interests: userData.interests,
        motivation: userData.motivation,
      },
    });

    const role = await prisma.role.findUniqueOrThrow({ where: { code: userData.role } });
    await prisma.userRole.upsert({
      where: { userId_roleId: { userId: user.id, roleId: role.id } },
      update: {},
      create: { userId: user.id, roleId: role.id },
    });
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
