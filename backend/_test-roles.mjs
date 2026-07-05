import 'dotenv/config'
import { PrismaPg } from '@prisma/adapter-pg'
import { PrismaClient } from '@prisma/client'

const API = 'http://127.0.0.1:3001/api/v1'
const prisma = new PrismaClient({ adapter: new PrismaPg({ connectionString: process.env.DATABASE_URL }) })

const created = []
async function reg(name) {
  const email = `roletest-${name}-${Date.now()}-${Math.random().toString(36).slice(2, 6)}@test.local`
  const r = await fetch(`${API}/auth/register`, {
    method: 'POST', headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ name, email, password: 'Test1234!' }),
  })
  const d = await r.json()
  created.push(d.user.id)
  return { id: d.user.id, email, token: d.accessToken }
}
async function login(email) {
  const r = await fetch(`${API}/auth/login`, {
    method: 'POST', headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password: 'Test1234!' }),
  })
  const d = await r.json()
  return d.accessToken
}
async function assignRole(userId, code) {
  const role = await prisma.role.findUnique({ where: { code } })
  await prisma.userRole.deleteMany({ where: { userId } })
  await prisma.userRole.create({ data: { userId, roleId: role.id } })
}
async function setRole(token, targetId, role) {
  const r = await fetch(`${API}/users/${targetId}/role`, {
    method: 'PATCH', headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
    body: JSON.stringify({ role }),
  })
  return r.status
}
async function removeUser(token, targetId) {
  const r = await fetch(`${API}/users/${targetId}`, {
    method: 'DELETE', headers: { Authorization: `Bearer ${token}` },
  })
  return r.status
}
const results = []
function check(label, actual, expected) {
  const ok = actual === expected
  results.push(`${ok ? '✅' : '❌'} ${label} → ${actual} (esperado ${expected})`)
}

try {
  // Setup
  const superA = await reg('SuperA')
  const adminA = await reg('AdminA')
  const uUser = await reg('TargetUser')
  const uUser2 = await reg('TargetUser2')
  const uAdmin = await reg('TargetAdmin')
  const uSuper = await reg('TargetSuper')
  await assignRole(superA.id, 'SUPER_ADMIN')
  await assignRole(adminA.id, 'ADMIN')
  await assignRole(uAdmin.id, 'ADMIN')
  await assignRole(uSuper.id, 'SUPER_ADMIN')
  // Fresh tokens (reflect DB roles/permissions)
  const superTok = await login(superA.email)
  const adminTok = await login(adminA.email)

  // Super Admin actor
  check('Super promove USER→WRITER', await setRole(superTok, uUser.id, 'WRITER'), 200)
  check('Super promove USER→ADMIN', await setRole(superTok, uUser2.id, 'ADMIN'), 200)
  check('Super tenta alterar papel de Super Admin', await setRole(superTok, uSuper.id, 'USER'), 403)
  check('Super tenta remover Super Admin', await removeUser(superTok, uSuper.id), 403)
  check('Super não altera o próprio papel', await setRole(superTok, superA.id, 'USER'), 403)

  // Admin actor
  check('Admin promove USER→PROFESSOR', await setRole(adminTok, uUser.id, 'PROFESSOR'), 200)
  check('Admin tenta promover →ADMIN (proibido)', await setRole(adminTok, uUser.id, 'ADMIN'), 403)
  check('Admin tenta alterar papel de outro Admin', await setRole(adminTok, uAdmin.id, 'USER'), 403)
  check('Admin tenta remover Admin', await removeUser(adminTok, uAdmin.id), 403)
  check('Admin tenta alterar Super Admin', await setRole(adminTok, uSuper.id, 'USER'), 403)
  check('Admin remove USER comum', await removeUser(adminTok, uUser.id), 200)

  // Super remove a normal user (uUser2 is now ADMIN, so use a fresh one)
  check('Super remove utilizador comum (uUser2 agora ADMIN)', await removeUser(superTok, uUser2.id), 200)

  console.log('\n' + results.join('\n'))
  const fails = results.filter((r) => r.startsWith('❌')).length
  console.log(`\n${fails === 0 ? '✅ TODOS OS TESTES PASSARAM' : `❌ ${fails} FALHAS`}`)
} catch (e) {
  console.error('ERRO', e)
} finally {
  // Cleanup: hard-delete test users
  if (created.length) {
    await prisma.userRole.deleteMany({ where: { userId: { in: created } } })
    await prisma.refreshToken.deleteMany({ where: { userId: { in: created } } })
    await prisma.user.deleteMany({ where: { id: { in: created } } })
  }
  await prisma.$disconnect()
}
