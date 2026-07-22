# AUTH-user-auth Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship email/password login with JWT access tokens, rotating refresh tokens (reuse detection), account lockout, and "remember me", per [AUTH-user-auth.spec.md](../specs/AUTH-user-auth.spec.md).

**Architecture:** Next.js App Router feature module (`src/web/features/auth/`) following [NEXT_ARCHITECTURE.md](../architecture/NEXT_ARCHITECTURE.md): Zod schemas validate input, Prisma `queries/` handle reads, Server Actions (`actions/`) handle writes/mutations, a Client Component form calls the Server Action. `/auth/refresh` and `/auth/logout` are Route Handlers (`app/api/auth/...`) since they are called by the browser's cookie-bearing fetch, not through a page form submission.

**Tech Stack:** Next.js (App Router), Prisma + PostgreSQL, Zod, bcrypt (password hashing), `jsonwebtoken` (JWT access tokens), Vitest + `vitest-mock-extended` (unit tests), React Testing Library (component tests).

## Global Constraints

- Password hashing: bcrypt or argon2, never plaintext/reversible (spec: Security Notes).
- Access token: JWT, 15 min TTL, returned in response body (spec: Token Refresh / API convention).
- Refresh token: opaque random token, 7 day TTL (30 days if `rememberMe`), stored `httpOnly` + `secure` + `SameSite=Strict` cookie, never exposed to client JS (spec: Login Flow, Security Notes).
- Account lockout: 5 consecutive failed attempts → 15 minute lockout, auto-expires, counter resets on success (spec: Account Lockout).
- Refresh token reuse (already-revoked token presented again) revokes **all** outstanding refresh tokens for that user (spec: Token Refresh).
- Error responses never reveal whether an email/account exists (spec: Error Handling).
- API envelope: `{ "success": bool, "data": {} | null, "error": { "code": string, "message": string } | null }` (docs/api/api.md).
- Never log or return `password_hash` or raw token values in any response (docs/api/api.md Rules).

---

## File Structure

```text
prisma/
├── schema.prisma                       # User, RefreshToken models (Task 1)
└── seed.ts                              # Seed one verified test user (Task 1)

src/web/
├── lib/
│   ├── db/prisma.ts                     # Prisma client singleton (Task 1)
│   ├── config/env.ts                    # Zod-validated env (JWT secret, DB url) (Task 1)
│   └── auth/
│       ├── jwt.ts                       # signAccessToken/verifyAccessToken (Task 2)
│       ├── password.ts                  # hashPassword/verifyPassword (Task 2)
│       └── refresh-token.ts             # generate/hash opaque refresh token (Task 2)
├── features/auth/
│   ├── schemas/
│   │   └── login-schema.ts              # loginSchema (email, password, rememberMe) (Task 3)
│   ├── queries/
│   │   ├── get-user-by-email.ts         # (Task 3)
│   │   └── get-refresh-token.ts         # (Task 5)
│   ├── actions/
│   │   └── login.ts                     # loginAction Server Action (Task 4)
│   ├── lib/
│   │   ├── lockout.ts                   # isLocked/registerFailedAttempt/resetAttempts (Task 3)
│   │   └── refresh-rotation.ts          # rotateRefreshToken/revokeAllForUser (Task 5)
│   ├── components/
│   │   └── login-form.tsx               # Client Component form (Task 6)
│   └── types.ts                         # LoginResult, AuthErrorCode (Task 3)
└── app/
    ├── (marketing)/login/page.tsx       # Login page, renders LoginForm (Task 6)
    └── api/auth/
        ├── refresh/route.ts             # POST /api/v1/auth/refresh (Task 5)
        └── logout/route.ts              # POST /api/v1/auth/logout (Task 7)

tests/features/auth/
├── lib/lockout.test.ts                  # (Task 3)
├── queries/get-user-by-email.test.ts    # (Task 3)
├── actions/login.test.ts                # (Task 4)
├── lib/refresh-rotation.test.ts         # (Task 5)
├── api/refresh.test.ts                  # (Task 5)
├── api/logout.test.ts                   # (Task 7)
└── components/login-form.test.tsx       # (Task 6)
```

---

### Task 1: Project bootstrap — Prisma schema, client, env config

**Files:**
- Create: `prisma/schema.prisma`
- Create: `prisma/seed.ts`
- Create: `src/web/lib/db/prisma.ts`
- Create: `src/web/lib/config/env.ts`
- Create: `.env.example`

**Interfaces:**
- Produces: `prisma.user`, `prisma.refreshToken` (Prisma Client models), `env.JWT_SECRET: string`, `env.DATABASE_URL: string`

- [ ] **Step 1: Write `prisma/schema.prisma`**

```prisma
// prisma/schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id                  String    @id @default(uuid())
  email               String    @unique
  passwordHash        String    @map("password_hash")
  emailVerifiedAt     DateTime? @map("email_verified_at")
  failedLoginAttempts Int       @default(0) @map("failed_login_attempts")
  lockedUntil         DateTime? @map("locked_until")
  createdAt           DateTime  @default(now()) @map("created_at")
  updatedAt           DateTime  @updatedAt @map("updated_at")

  refreshTokens RefreshToken[]

  @@map("users")
}

model RefreshToken {
  id          String    @id @default(uuid())
  userId      String    @map("user_id")
  tokenHash   String    @unique @map("token_hash")
  expiresAt   DateTime  @map("expires_at")
  revokedAt   DateTime? @map("revoked_at")
  rememberMe  Boolean   @default(false) @map("remember_me")
  createdAt   DateTime  @default(now()) @map("created_at")

  user User @relation(fields: [userId], references: [id])

  @@index([userId])
  @@index([tokenHash])
  @@map("refresh_tokens")
}
```

This matches `docs/database/db.md` field-for-field (snake_case columns via `@map`, camelCase in the Prisma Client).

- [ ] **Step 2: Write `src/web/lib/config/env.ts`**

```ts
// src/web/lib/config/env.ts
import { z } from 'zod'

const envSchema = z.object({
  DATABASE_URL: z.string().url(),
  JWT_SECRET: z.string().min(32),
})

export const env = envSchema.parse({
  DATABASE_URL: process.env.DATABASE_URL,
  JWT_SECRET: process.env.JWT_SECRET,
})
```

- [ ] **Step 3: Write `.env.example`**

```bash
DATABASE_URL="postgresql://user:password@localhost:5432/app_dev"
JWT_SECRET="replace-with-a-random-32-plus-character-secret"
```

- [ ] **Step 4: Write `src/web/lib/db/prisma.ts`**

```ts
// src/web/lib/db/prisma.ts
import { PrismaClient } from '@prisma/client'

const globalForPrisma = globalThis as unknown as { prisma?: PrismaClient }

export const prisma = globalForPrisma.prisma ?? new PrismaClient()

if (process.env.NODE_ENV !== 'production') {
  globalForPrisma.prisma = prisma
}
```

- [ ] **Step 5: Write `prisma/seed.ts` (one verified test user, password `Password1`)**

```ts
// prisma/seed.ts
import { PrismaClient } from '@prisma/client'
import bcrypt from 'bcrypt'

const prisma = new PrismaClient()

async function main() {
  const passwordHash = await bcrypt.hash('Password1', 12)
  await prisma.user.upsert({
    where: { email: 'test@example.com' },
    update: {},
    create: {
      email: 'test@example.com',
      passwordHash,
      emailVerifiedAt: new Date(),
    },
  })
}

main().finally(() => prisma.$disconnect())
```

- [ ] **Step 6: Generate the Prisma client and run migration**

Run: `npx prisma migrate dev --name init_auth`
Expected: migration applied, `User` and `RefreshToken` types available from `@prisma/client`

- [ ] **Step 7: Commit**

```bash
git add prisma/ src/web/lib/db/prisma.ts src/web/lib/config/env.ts .env.example
git commit -m "feat(auth): add Prisma schema, client, and env config for auth"
```

---

### Task 2: Auth primitives — password hashing, JWT, opaque refresh tokens

**Files:**
- Create: `src/web/lib/auth/password.ts`
- Create: `src/web/lib/auth/jwt.ts`
- Create: `src/web/lib/auth/refresh-token.ts`
- Test: `tests/lib/auth/password.test.ts`
- Test: `tests/lib/auth/jwt.test.ts`
- Test: `tests/lib/auth/refresh-token.test.ts`

**Interfaces:**
- Consumes: `env.JWT_SECRET` from `src/web/lib/config/env.ts` (Task 1)
- Produces:
  - `hashPassword(plain: string): Promise<string>`
  - `verifyPassword(plain: string, hash: string): Promise<boolean>`
  - `signAccessToken(payload: { userId: string }): string`
  - `verifyAccessToken(token: string): { userId: string } | null`
  - `generateRefreshToken(): { token: string; tokenHash: string }`
  - `hashRefreshToken(token: string): string`

- [ ] **Step 1: Write failing tests for password hashing**

```ts
// tests/lib/auth/password.test.ts
import { describe, it, expect } from 'vitest'
import { hashPassword, verifyPassword } from '@/lib/auth/password'

describe('password hashing', () => {
  it('verifies a correct password against its hash', async () => {
    const hash = await hashPassword('Password1')
    expect(await verifyPassword('Password1', hash)).toBe(true)
  })

  it('rejects an incorrect password', async () => {
    const hash = await hashPassword('Password1')
    expect(await verifyPassword('WrongPass1', hash)).toBe(false)
  })
})
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/lib/auth/password.test.ts`
Expected: FAIL — `Cannot find module '@/lib/auth/password'`

- [ ] **Step 3: Implement `src/web/lib/auth/password.ts`**

```ts
// src/web/lib/auth/password.ts
import bcrypt from 'bcrypt'

const SALT_ROUNDS = 12

export async function hashPassword(plain: string): Promise<string> {
  return bcrypt.hash(plain, SALT_ROUNDS)
}

export async function verifyPassword(plain: string, hash: string): Promise<boolean> {
  return bcrypt.compare(plain, hash)
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `npx vitest run tests/lib/auth/password.test.ts`
Expected: PASS (2 tests)

- [ ] **Step 5: Write failing tests for JWT access tokens**

```ts
// tests/lib/auth/jwt.test.ts
import { describe, it, expect } from 'vitest'
import { signAccessToken, verifyAccessToken } from '@/lib/auth/jwt'

describe('access token', () => {
  it('round-trips a valid token', () => {
    const token = signAccessToken({ userId: 'user-1' })
    expect(verifyAccessToken(token)).toEqual({ userId: 'user-1' })
  })

  it('rejects a tampered token', () => {
    const token = signAccessToken({ userId: 'user-1' })
    expect(verifyAccessToken(token + 'x')).toBeNull()
  })
})
```

- [ ] **Step 6: Run test to verify it fails**

Run: `npx vitest run tests/lib/auth/jwt.test.ts`
Expected: FAIL — `Cannot find module '@/lib/auth/jwt'`

- [ ] **Step 7: Implement `src/web/lib/auth/jwt.ts`**

```ts
// src/web/lib/auth/jwt.ts
import jwt from 'jsonwebtoken'
import { env } from '@/lib/config/env'

const ACCESS_TOKEN_TTL = '15m'

export function signAccessToken(payload: { userId: string }): string {
  return jwt.sign(payload, env.JWT_SECRET, { expiresIn: ACCESS_TOKEN_TTL })
}

export function verifyAccessToken(token: string): { userId: string } | null {
  try {
    const decoded = jwt.verify(token, env.JWT_SECRET) as { userId: string }
    return { userId: decoded.userId }
  } catch {
    return null
  }
}
```

- [ ] **Step 8: Run test to verify it passes**

Run: `npx vitest run tests/lib/auth/jwt.test.ts`
Expected: PASS (2 tests)

- [ ] **Step 9: Write failing tests for opaque refresh tokens**

```ts
// tests/lib/auth/refresh-token.test.ts
import { describe, it, expect } from 'vitest'
import { generateRefreshToken, hashRefreshToken } from '@/lib/auth/refresh-token'

describe('refresh token', () => {
  it('generates a token whose hash matches hashRefreshToken(token)', () => {
    const { token, tokenHash } = generateRefreshToken()
    expect(hashRefreshToken(token)).toBe(tokenHash)
  })

  it('generates a token at least 32 characters long', () => {
    const { token } = generateRefreshToken()
    expect(token.length).toBeGreaterThanOrEqual(32)
  })
})
```

- [ ] **Step 10: Run test to verify it fails**

Run: `npx vitest run tests/lib/auth/refresh-token.test.ts`
Expected: FAIL — `Cannot find module '@/lib/auth/refresh-token'`

- [ ] **Step 11: Implement `src/web/lib/auth/refresh-token.ts`**

```ts
// src/web/lib/auth/refresh-token.ts
import { randomBytes, createHash } from 'crypto'

export function hashRefreshToken(token: string): string {
  return createHash('sha256').update(token).digest('hex')
}

export function generateRefreshToken(): { token: string; tokenHash: string } {
  const token = randomBytes(32).toString('hex')
  return { token, tokenHash: hashRefreshToken(token) }
}
```

- [ ] **Step 12: Run test to verify it passes**

Run: `npx vitest run tests/lib/auth/refresh-token.test.ts`
Expected: PASS (2 tests)

- [ ] **Step 13: Commit**

```bash
git add src/web/lib/auth/ tests/lib/auth/
git commit -m "feat(auth): add password hashing, JWT, and refresh token primitives"
```

---

### Task 3: Login schema, lockout logic, user query

**Files:**
- Create: `src/web/features/auth/schemas/login-schema.ts`
- Create: `src/web/features/auth/queries/get-user-by-email.ts`
- Create: `src/web/features/auth/lib/lockout.ts`
- Create: `src/web/features/auth/types.ts`
- Test: `tests/features/auth/lib/lockout.test.ts`
- Test: `tests/features/auth/queries/get-user-by-email.test.ts`

**Interfaces:**
- Consumes: `prisma` from `src/web/lib/db/prisma.ts` (Task 1)
- Produces:
  - `loginSchema: z.ZodSchema<{ email: string; password: string; rememberMe: boolean }>`
  - `type LoginInput = z.infer<typeof loginSchema>`
  - `getUserByEmail(email: string): Promise<User | null>` (Prisma `User`)
  - `isLocked(user: User): boolean`
  - `lockoutRemainingMinutes(user: User): number`
  - `registerFailedAttempt(userId: string): Promise<void>` — increments `failedLoginAttempts`; sets `lockedUntil = now + 15min` when it reaches 5
  - `resetFailedAttempts(userId: string): Promise<void>`
  - `type AuthErrorCode = 'invalid_credentials' | 'account_locked' | 'email_not_verified'`

- [ ] **Step 1: Write `src/web/features/auth/schemas/login-schema.ts`**

```ts
// src/web/features/auth/schemas/login-schema.ts
import { z } from 'zod'

export const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1),
  rememberMe: z.boolean().default(false),
})

export type LoginInput = z.infer<typeof loginSchema>
```

- [ ] **Step 2: Write `src/web/features/auth/types.ts`**

```ts
// src/web/features/auth/types.ts
export type AuthErrorCode = 'invalid_credentials' | 'account_locked' | 'email_not_verified'

export type LoginResult =
  | { success: true; data: { accessToken: string } }
  | { success: false; error: { code: AuthErrorCode; message: string } }
```

- [ ] **Step 3: Write failing test for lockout logic**

```ts
// tests/features/auth/lib/lockout.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mockDeep, mockReset } from 'vitest-mock-extended'
import type { PrismaClient } from '@prisma/client'
import { isLocked, lockoutRemainingMinutes, registerFailedAttempt, resetFailedAttempts } from '@/features/auth/lib/lockout'

vi.mock('@/lib/db/prisma', () => ({ prisma: mockDeep<PrismaClient>() }))
import { prisma } from '@/lib/db/prisma'
const prismaMock = prisma as unknown as ReturnType<typeof mockDeep<PrismaClient>>

beforeEach(() => mockReset(prismaMock))

describe('isLocked', () => {
  it('is false when lockedUntil is null', () => {
    expect(isLocked({ lockedUntil: null } as any)).toBe(false)
  })

  it('is true when lockedUntil is in the future', () => {
    expect(isLocked({ lockedUntil: new Date(Date.now() + 60_000) } as any)).toBe(true)
  })

  it('is false when lockedUntil is in the past', () => {
    expect(isLocked({ lockedUntil: new Date(Date.now() - 60_000) } as any)).toBe(false)
  })
})

describe('lockoutRemainingMinutes', () => {
  it('rounds up remaining time to the nearest minute', () => {
    const minutes = lockoutRemainingMinutes({ lockedUntil: new Date(Date.now() + 90_000) } as any)
    expect(minutes).toBe(2)
  })
})

describe('registerFailedAttempt', () => {
  it('locks the account once failedLoginAttempts reaches 5', async () => {
    prismaMock.user.update.mockResolvedValue({ failedLoginAttempts: 5 } as any)
    await registerFailedAttempt('user-1')
    const call = prismaMock.user.update.mock.calls[0][0]
    expect(call.data.failedLoginAttempts).toEqual({ increment: 1 })
  })
})

describe('resetFailedAttempts', () => {
  it('resets the counter and clears lockedUntil', async () => {
    await resetFailedAttempts('user-1')
    expect(prismaMock.user.update).toHaveBeenCalledWith({
      where: { id: 'user-1' },
      data: { failedLoginAttempts: 0, lockedUntil: null },
    })
  })
})
```

- [ ] **Step 4: Run test to verify it fails**

Run: `npx vitest run tests/features/auth/lib/lockout.test.ts`
Expected: FAIL — `Cannot find module '@/features/auth/lib/lockout'`

- [ ] **Step 5: Implement `src/web/features/auth/lib/lockout.ts`**

```ts
// src/web/features/auth/lib/lockout.ts
import type { User } from '@prisma/client'
import { prisma } from '@/lib/db/prisma'

const LOCKOUT_THRESHOLD = 5
const LOCKOUT_DURATION_MS = 15 * 60 * 1000

export function isLocked(user: Pick<User, 'lockedUntil'>): boolean {
  return !!user.lockedUntil && user.lockedUntil.getTime() > Date.now()
}

export function lockoutRemainingMinutes(user: Pick<User, 'lockedUntil'>): number {
  if (!user.lockedUntil) return 0
  return Math.ceil((user.lockedUntil.getTime() - Date.now()) / 60_000)
}

export async function registerFailedAttempt(userId: string): Promise<void> {
  const updated = await prisma.user.update({
    where: { id: userId },
    data: { failedLoginAttempts: { increment: 1 } },
  })

  if (updated.failedLoginAttempts >= LOCKOUT_THRESHOLD) {
    await prisma.user.update({
      where: { id: userId },
      data: { lockedUntil: new Date(Date.now() + LOCKOUT_DURATION_MS) },
    })
  }
}

export async function resetFailedAttempts(userId: string): Promise<void> {
  await prisma.user.update({
    where: { id: userId },
    data: { failedLoginAttempts: 0, lockedUntil: null },
  })
}
```

- [ ] **Step 6: Run test to verify it passes**

Run: `npx vitest run tests/features/auth/lib/lockout.test.ts`
Expected: PASS (5 tests)

- [ ] **Step 7: Write failing test for `getUserByEmail`**

```ts
// tests/features/auth/queries/get-user-by-email.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mockDeep, mockReset } from 'vitest-mock-extended'
import type { PrismaClient } from '@prisma/client'

vi.mock('@/lib/db/prisma', () => ({ prisma: mockDeep<PrismaClient>() }))
import { prisma } from '@/lib/db/prisma'
import { getUserByEmail } from '@/features/auth/queries/get-user-by-email'
const prismaMock = prisma as unknown as ReturnType<typeof mockDeep<PrismaClient>>

beforeEach(() => mockReset(prismaMock))

describe('getUserByEmail', () => {
  it('returns null when no user matches', async () => {
    prismaMock.user.findUnique.mockResolvedValue(null)
    expect(await getUserByEmail('missing@example.com')).toBeNull()
  })

  it('returns the user when found', async () => {
    prismaMock.user.findUnique.mockResolvedValue({ id: 'user-1', email: 'a@b.com' } as any)
    expect(await getUserByEmail('a@b.com')).toEqual({ id: 'user-1', email: 'a@b.com' })
  })
})
```

- [ ] **Step 8: Run test to verify it fails**

Run: `npx vitest run tests/features/auth/queries/get-user-by-email.test.ts`
Expected: FAIL — `Cannot find module '@/features/auth/queries/get-user-by-email'`

- [ ] **Step 9: Implement `src/web/features/auth/queries/get-user-by-email.ts`**

```ts
// src/web/features/auth/queries/get-user-by-email.ts
import 'server-only'
import type { User } from '@prisma/client'
import { prisma } from '@/lib/db/prisma'

export function getUserByEmail(email: string): Promise<User | null> {
  return prisma.user.findUnique({ where: { email } })
}
```

- [ ] **Step 10: Run test to verify it passes**

Run: `npx vitest run tests/features/auth/queries/get-user-by-email.test.ts`
Expected: PASS (2 tests)

- [ ] **Step 11: Commit**

```bash
git add src/web/features/auth/schemas/ src/web/features/auth/queries/ src/web/features/auth/lib/lockout.ts src/web/features/auth/types.ts tests/features/auth/
git commit -m "feat(auth): add login schema, user query, and account lockout logic"
```

---

### Task 4: `loginAction` Server Action

**Files:**
- Create: `src/web/features/auth/actions/login.ts`
- Test: `tests/features/auth/actions/login.test.ts`

**Interfaces:**
- Consumes: `loginSchema`, `LoginInput`, `LoginResult` (Task 3), `getUserByEmail` (Task 3), `isLocked`, `lockoutRemainingMinutes`, `registerFailedAttempt`, `resetFailedAttempts` (Task 3), `verifyPassword` (Task 2), `signAccessToken` (Task 2), `generateRefreshToken` (Task 2)
- Produces: `loginAction(input: unknown): Promise<LoginResult>` — on success, also sets the `refresh_token` cookie via `next/headers` `cookies()` and persists a `RefreshToken` row (does not return the raw refresh token in `data`)

- [ ] **Step 1: Write failing tests covering every branch in the spec's Login Flow**

```ts
// tests/features/auth/actions/login.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mockDeep, mockReset } from 'vitest-mock-extended'
import type { PrismaClient } from '@prisma/client'

vi.mock('@/lib/db/prisma', () => ({ prisma: mockDeep<PrismaClient>() }))
vi.mock('next/headers', () => ({ cookies: () => ({ set: vi.fn() }) }))
import { prisma } from '@/lib/db/prisma'
import { loginAction } from '@/features/auth/actions/login'
const prismaMock = prisma as unknown as ReturnType<typeof mockDeep<PrismaClient>>

const baseUser = {
  id: 'user-1',
  email: 'a@b.com',
  passwordHash: '$2b$12$abcdefghijklmnopqrstuv', // bcrypt-shaped, verified via mocked bcrypt below
  emailVerifiedAt: new Date(),
  failedLoginAttempts: 0,
  lockedUntil: null,
}

vi.mock('bcrypt', () => ({ default: { compare: vi.fn(), hash: vi.fn() } }))
import bcrypt from 'bcrypt'

beforeEach(() => {
  mockReset(prismaMock)
  vi.mocked(bcrypt.compare).mockReset()
})

describe('loginAction', () => {
  it('returns invalid_credentials for an unknown email', async () => {
    prismaMock.user.findUnique.mockResolvedValue(null)
    const result = await loginAction({ email: 'missing@example.com', password: 'Password1', rememberMe: false })
    expect(result).toEqual({ success: false, error: { code: 'invalid_credentials', message: 'Email or password is incorrect' } })
  })

  it('returns account_locked when the account is currently locked', async () => {
    prismaMock.user.findUnique.mockResolvedValue({ ...baseUser, lockedUntil: new Date(Date.now() + 60_000) } as any)
    const result = await loginAction({ email: baseUser.email, password: 'Password1', rememberMe: false })
    expect(result.success).toBe(false)
    if (!result.success) expect(result.error.code).toBe('account_locked')
  })

  it('returns email_not_verified when emailVerifiedAt is null', async () => {
    prismaMock.user.findUnique.mockResolvedValue({ ...baseUser, emailVerifiedAt: null } as any)
    const result = await loginAction({ email: baseUser.email, password: 'Password1', rememberMe: false })
    expect(result).toEqual({ success: false, error: { code: 'email_not_verified', message: 'Please verify your email before logging in' } })
  })

  it('returns invalid_credentials and increments the failure counter on wrong password', async () => {
    prismaMock.user.findUnique.mockResolvedValue({ ...baseUser } as any)
    vi.mocked(bcrypt.compare).mockResolvedValue(false as never)
    const result = await loginAction({ email: baseUser.email, password: 'WrongPass1', rememberMe: false })
    expect(result).toEqual({ success: false, error: { code: 'invalid_credentials', message: 'Email or password is incorrect' } })
    expect(prismaMock.user.update).toHaveBeenCalledWith(
      expect.objectContaining({ where: { id: 'user-1' }, data: { failedLoginAttempts: { increment: 1 } } }),
    )
  })

  it('returns an access token and resets the failure counter on success', async () => {
    prismaMock.user.findUnique.mockResolvedValue({ ...baseUser } as any)
    vi.mocked(bcrypt.compare).mockResolvedValue(true as never)
    prismaMock.refreshToken.create.mockResolvedValue({} as any)
    const result = await loginAction({ email: baseUser.email, password: 'Password1', rememberMe: false })
    expect(result.success).toBe(true)
    if (result.success) expect(typeof result.data.accessToken).toBe('string')
    expect(prismaMock.user.update).toHaveBeenCalledWith({
      where: { id: 'user-1' },
      data: { failedLoginAttempts: 0, lockedUntil: null },
    })
    expect(prismaMock.refreshToken.create).toHaveBeenCalled()
  })
})
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/features/auth/actions/login.test.ts`
Expected: FAIL — `Cannot find module '@/features/auth/actions/login'`

- [ ] **Step 3: Implement `src/web/features/auth/actions/login.ts`**

```ts
// src/web/features/auth/actions/login.ts
'use server'

import { cookies } from 'next/headers'
import { prisma } from '@/lib/db/prisma'
import { loginSchema } from '../schemas/login-schema'
import { getUserByEmail } from '../queries/get-user-by-email'
import { isLocked, lockoutRemainingMinutes, registerFailedAttempt, resetFailedAttempts } from '../lib/lockout'
import { verifyPassword } from '@/lib/auth/password'
import { signAccessToken } from '@/lib/auth/jwt'
import { generateRefreshToken } from '@/lib/auth/refresh-token'
import type { LoginResult } from '../types'

const GENERIC_INVALID_CREDENTIALS = { code: 'invalid_credentials' as const, message: 'Email or password is incorrect' }
const REFRESH_TOKEN_TTL_MS = 7 * 24 * 60 * 60 * 1000
const REFRESH_TOKEN_TTL_REMEMBER_ME_MS = 30 * 24 * 60 * 60 * 1000

export async function loginAction(input: unknown): Promise<LoginResult> {
  const parsed = loginSchema.safeParse(input)
  if (!parsed.success) {
    return { success: false, error: GENERIC_INVALID_CREDENTIALS }
  }

  const { email, password, rememberMe } = parsed.data
  const user = await getUserByEmail(email)
  if (!user) {
    return { success: false, error: GENERIC_INVALID_CREDENTIALS }
  }

  if (isLocked(user)) {
    return {
      success: false,
      error: {
        code: 'account_locked',
        message: `Account temporarily locked, try again in ${lockoutRemainingMinutes(user)} minutes`,
      },
    }
  }

  if (!user.emailVerifiedAt) {
    return { success: false, error: { code: 'email_not_verified', message: 'Please verify your email before logging in' } }
  }

  const passwordMatches = await verifyPassword(password, user.passwordHash)
  if (!passwordMatches) {
    await registerFailedAttempt(user.id)
    return { success: false, error: GENERIC_INVALID_CREDENTIALS }
  }

  await resetFailedAttempts(user.id)

  const accessToken = signAccessToken({ userId: user.id })
  const { token: refreshToken, tokenHash } = generateRefreshToken()
  const ttlMs = rememberMe ? REFRESH_TOKEN_TTL_REMEMBER_ME_MS : REFRESH_TOKEN_TTL_MS

  await prisma.refreshToken.create({
    data: {
      userId: user.id,
      tokenHash,
      expiresAt: new Date(Date.now() + ttlMs),
      rememberMe,
    },
  })

  cookies().set('refresh_token', refreshToken, {
    httpOnly: true,
    secure: true,
    sameSite: 'strict',
    maxAge: ttlMs / 1000,
    path: '/',
  })

  return { success: true, data: { accessToken } }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `npx vitest run tests/features/auth/actions/login.test.ts`
Expected: PASS (5 tests)

- [ ] **Step 5: Commit**

```bash
git add src/web/features/auth/actions/ tests/features/auth/actions/
git commit -m "feat(auth): add loginAction Server Action"
```

---

### Task 5: Refresh token rotation + `/api/v1/auth/refresh` Route Handler

**Files:**
- Create: `src/web/features/auth/queries/get-refresh-token.ts`
- Create: `src/web/features/auth/lib/refresh-rotation.ts`
- Create: `src/web/app/api/auth/refresh/route.ts`
- Test: `tests/features/auth/lib/refresh-rotation.test.ts`
- Test: `tests/features/auth/api/refresh.test.ts`

**Interfaces:**
- Consumes: `hashRefreshToken`, `generateRefreshToken` (Task 2), `signAccessToken` (Task 2), `prisma` (Task 1)
- Produces:
  - `getRefreshTokenByHash(tokenHash: string): Promise<RefreshToken | null>`
  - `type RotationResult = { status: 'rotated'; accessToken: string; refreshToken: string; ttlMs: number } | { status: 'invalid' } | { status: 'reuse_detected' }`
  - `rotateRefreshToken(presentedToken: string): Promise<RotationResult>` — validates, revokes the presented token, issues new access+refresh token pair; on reuse of an already-revoked token, revokes all tokens for that user and returns `{ status: 'reuse_detected' }`
  - `POST` handler at `src/web/app/api/auth/refresh/route.ts` returning the API envelope, setting the new `refresh_token` cookie on `rotated`, clearing it on `invalid`/`reuse_detected`

- [ ] **Step 1: Write `src/web/features/auth/queries/get-refresh-token.ts`**

```ts
// src/web/features/auth/queries/get-refresh-token.ts
import 'server-only'
import type { RefreshToken } from '@prisma/client'
import { prisma } from '@/lib/db/prisma'

export function getRefreshTokenByHash(tokenHash: string): Promise<RefreshToken | null> {
  return prisma.refreshToken.findUnique({ where: { tokenHash } })
}
```

- [ ] **Step 2: Write failing tests for `rotateRefreshToken`**

```ts
// tests/features/auth/lib/refresh-rotation.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mockDeep, mockReset } from 'vitest-mock-extended'
import type { PrismaClient } from '@prisma/client'

vi.mock('@/lib/db/prisma', () => ({ prisma: mockDeep<PrismaClient>() }))
import { prisma } from '@/lib/db/prisma'
import { rotateRefreshToken } from '@/features/auth/lib/refresh-rotation'
import { hashRefreshToken } from '@/lib/auth/refresh-token'
const prismaMock = prisma as unknown as ReturnType<typeof mockDeep<PrismaClient>>

beforeEach(() => mockReset(prismaMock))

describe('rotateRefreshToken', () => {
  it('returns invalid for an unknown token', async () => {
    prismaMock.refreshToken.findUnique.mockResolvedValue(null)
    expect(await rotateRefreshToken('unknown-token')).toEqual({ status: 'invalid' })
  })

  it('returns invalid for an expired, never-revoked token', async () => {
    prismaMock.refreshToken.findUnique.mockResolvedValue({
      id: 'rt-1', userId: 'user-1', tokenHash: hashRefreshToken('t'), expiresAt: new Date(Date.now() - 1000), revokedAt: null, rememberMe: false,
    } as any)
    expect(await rotateRefreshToken('t')).toEqual({ status: 'invalid' })
  })

  it('detects reuse of an already-revoked token and revokes all tokens for the user', async () => {
    prismaMock.refreshToken.findUnique.mockResolvedValue({
      id: 'rt-1', userId: 'user-1', tokenHash: hashRefreshToken('t'), expiresAt: new Date(Date.now() + 100_000), revokedAt: new Date(), rememberMe: false,
    } as any)
    const result = await rotateRefreshToken('t')
    expect(result).toEqual({ status: 'reuse_detected' })
    expect(prismaMock.refreshToken.updateMany).toHaveBeenCalledWith({
      where: { userId: 'user-1', revokedAt: null },
      data: { revokedAt: expect.any(Date) },
    })
  })

  it('rotates a valid token: revokes the old one, creates a new one, returns a new access token', async () => {
    prismaMock.refreshToken.findUnique.mockResolvedValue({
      id: 'rt-1', userId: 'user-1', tokenHash: hashRefreshToken('t'), expiresAt: new Date(Date.now() + 100_000), revokedAt: null, rememberMe: true,
    } as any)
    prismaMock.refreshToken.create.mockResolvedValue({} as any)
    const result = await rotateRefreshToken('t')
    expect(result.status).toBe('rotated')
    expect(prismaMock.refreshToken.update).toHaveBeenCalledWith({ where: { id: 'rt-1' }, data: { revokedAt: expect.any(Date) } })
    expect(prismaMock.refreshToken.create).toHaveBeenCalled()
    if (result.status === 'rotated') {
      expect(typeof result.accessToken).toBe('string')
      expect(typeof result.refreshToken).toBe('string')
      expect(result.ttlMs).toBe(30 * 24 * 60 * 60 * 1000) // rememberMe preserved across rotation
    }
  })
})
```

- [ ] **Step 3: Run test to verify it fails**

Run: `npx vitest run tests/features/auth/lib/refresh-rotation.test.ts`
Expected: FAIL — `Cannot find module '@/features/auth/lib/refresh-rotation'`

- [ ] **Step 4: Implement `src/web/features/auth/lib/refresh-rotation.ts`**

```ts
// src/web/features/auth/lib/refresh-rotation.ts
import { prisma } from '@/lib/db/prisma'
import { hashRefreshToken, generateRefreshToken } from '@/lib/auth/refresh-token'
import { signAccessToken } from '@/lib/auth/jwt'

const REFRESH_TOKEN_TTL_MS = 7 * 24 * 60 * 60 * 1000
const REFRESH_TOKEN_TTL_REMEMBER_ME_MS = 30 * 24 * 60 * 60 * 1000

export type RotationResult =
  | { status: 'rotated'; accessToken: string; refreshToken: string; ttlMs: number }
  | { status: 'invalid' }
  | { status: 'reuse_detected' }

export async function rotateRefreshToken(presentedToken: string): Promise<RotationResult> {
  const tokenHash = hashRefreshToken(presentedToken)
  const existing = await prisma.refreshToken.findUnique({ where: { tokenHash } })

  if (!existing) {
    return { status: 'invalid' }
  }

  if (existing.revokedAt) {
    await prisma.refreshToken.updateMany({
      where: { userId: existing.userId, revokedAt: null },
      data: { revokedAt: new Date() },
    })
    return { status: 'reuse_detected' }
  }

  if (existing.expiresAt.getTime() <= Date.now()) {
    return { status: 'invalid' }
  }

  await prisma.refreshToken.update({ where: { id: existing.id }, data: { revokedAt: new Date() } })

  const ttlMs = existing.rememberMe ? REFRESH_TOKEN_TTL_REMEMBER_ME_MS : REFRESH_TOKEN_TTL_MS
  const { token: refreshToken, tokenHash: newTokenHash } = generateRefreshToken()

  await prisma.refreshToken.create({
    data: {
      userId: existing.userId,
      tokenHash: newTokenHash,
      expiresAt: new Date(Date.now() + ttlMs),
      rememberMe: existing.rememberMe,
    },
  })

  return { status: 'rotated', accessToken: signAccessToken({ userId: existing.userId }), refreshToken, ttlMs }
}
```

- [ ] **Step 5: Run test to verify it passes**

Run: `npx vitest run tests/features/auth/lib/refresh-rotation.test.ts`
Expected: PASS (4 tests)

- [ ] **Step 6: Write failing test for the `/api/auth/refresh` route**

```ts
// tests/features/auth/api/refresh.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest'

vi.mock('@/features/auth/lib/refresh-rotation', () => ({ rotateRefreshToken: vi.fn() }))
vi.mock('next/headers', () => ({ cookies: () => ({ get: vi.fn(), set: vi.fn(), delete: vi.fn() }) }))
import { rotateRefreshToken } from '@/features/auth/lib/refresh-rotation'
import { cookies } from 'next/headers'
import { POST } from '@/app/api/auth/refresh/route'

beforeEach(() => vi.mocked(rotateRefreshToken).mockReset())

describe('POST /api/auth/refresh', () => {
  it('returns 401 invalid_token when no refresh_token cookie is present', async () => {
    vi.mocked(cookies().get).mockReturnValue(undefined)
    const res = await POST()
    const body = await res.json()
    expect(res.status).toBe(401)
    expect(body).toEqual({ success: false, data: null, error: { code: 'invalid_token', message: 'Invalid or expired refresh token' } })
  })

  it('returns 401 token_reuse_detected on reuse', async () => {
    vi.mocked(cookies().get).mockReturnValue({ value: 'stale-token' } as any)
    vi.mocked(rotateRefreshToken).mockResolvedValue({ status: 'reuse_detected' })
    const res = await POST()
    const body = await res.json()
    expect(res.status).toBe(401)
    expect(body.error.code).toBe('token_reuse_detected')
  })

  it('returns a new access token and sets the refresh cookie on success', async () => {
    vi.mocked(cookies().get).mockReturnValue({ value: 'valid-token' } as any)
    vi.mocked(rotateRefreshToken).mockResolvedValue({ status: 'rotated', accessToken: 'new.jwt', refreshToken: 'new-refresh', ttlMs: 604_800_000 })
    const res = await POST()
    const body = await res.json()
    expect(res.status).toBe(200)
    expect(body).toEqual({ success: true, data: { accessToken: 'new.jwt' }, error: null })
  })
})
```

- [ ] **Step 7: Run test to verify it fails**

Run: `npx vitest run tests/features/auth/api/refresh.test.ts`
Expected: FAIL — `Cannot find module '@/app/api/auth/refresh/route'`

- [ ] **Step 8: Implement `src/web/app/api/auth/refresh/route.ts`**

```ts
// src/web/app/api/auth/refresh/route.ts
import { NextResponse } from 'next/server'
import { cookies } from 'next/headers'
import { rotateRefreshToken } from '@/features/auth/lib/refresh-rotation'

export async function POST() {
  const presented = cookies().get('refresh_token')?.value

  if (!presented) {
    return NextResponse.json(
      { success: false, data: null, error: { code: 'invalid_token', message: 'Invalid or expired refresh token' } },
      { status: 401 },
    )
  }

  const result = await rotateRefreshToken(presented)

  if (result.status === 'invalid') {
    cookies().delete('refresh_token')
    return NextResponse.json(
      { success: false, data: null, error: { code: 'invalid_token', message: 'Invalid or expired refresh token' } },
      { status: 401 },
    )
  }

  if (result.status === 'reuse_detected') {
    cookies().delete('refresh_token')
    return NextResponse.json(
      { success: false, data: null, error: { code: 'token_reuse_detected', message: 'Session invalidated, please log in again' } },
      { status: 401 },
    )
  }

  cookies().set('refresh_token', result.refreshToken, {
    httpOnly: true,
    secure: true,
    sameSite: 'strict',
    maxAge: result.ttlMs / 1000,
    path: '/',
  })

  return NextResponse.json({ success: true, data: { accessToken: result.accessToken }, error: null })
}
```

- [ ] **Step 9: Run test to verify it passes**

Run: `npx vitest run tests/features/auth/api/refresh.test.ts`
Expected: PASS (3 tests)

- [ ] **Step 10: Commit**

```bash
git add src/web/features/auth/queries/get-refresh-token.ts src/web/features/auth/lib/refresh-rotation.ts src/web/app/api/auth/refresh/ tests/features/auth/lib/refresh-rotation.test.ts tests/features/auth/api/refresh.test.ts
git commit -m "feat(auth): add refresh token rotation with reuse detection"
```

---

### Task 6: Login page + `LoginForm` Client Component

**Files:**
- Create: `src/web/features/auth/components/login-form.tsx`
- Create: `src/web/app/(marketing)/login/page.tsx`
- Test: `tests/features/auth/components/login-form.test.tsx`

**Interfaces:**
- Consumes: `loginAction` (Task 4), `LoginResult` (Task 3)
- Produces: `LoginForm` React component (default export not used — named export `export function LoginForm()`), rendered by `app/(marketing)/login/page.tsx`

Per [AUTH-user-auth.screen.md](../screens/AUTH-user-auth.screen.md): email + password + "remember me" + submit; disabled/loading state while pending; generic invalid-credentials message (password cleared, email kept); account-locked message with minutes; unverified-email message; `role="alert"`/`aria-live="polite"` error banner.

- [ ] **Step 1: Write failing component tests for the key states from the screen spec**

```tsx
// tests/features/auth/components/login-form.test.tsx
import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { LoginForm } from '@/features/auth/components/login-form'

vi.mock('@/features/auth/actions/login', () => ({ loginAction: vi.fn() }))
import { loginAction } from '@/features/auth/actions/login'

beforeEach(() => vi.mocked(loginAction).mockReset())

describe('LoginForm', () => {
  it('shows the generic invalid-credentials message and clears the password field', async () => {
    vi.mocked(loginAction).mockResolvedValue({ success: false, error: { code: 'invalid_credentials', message: 'Email or password is incorrect' } })
    render(<LoginForm />)
    fireEvent.change(screen.getByLabelText(/email/i), { target: { value: 'a@b.com' } })
    fireEvent.change(screen.getByLabelText(/password/i), { target: { value: 'WrongPass1' } })
    fireEvent.click(screen.getByRole('button', { name: /log in/i }))

    await waitFor(() => expect(screen.getByRole('alert')).toHaveTextContent('Email or password is incorrect'))
    expect(screen.getByLabelText(/email/i)).toHaveValue('a@b.com')
    expect(screen.getByLabelText(/password/i)).toHaveValue('')
  })

  it('shows the account-locked message', async () => {
    vi.mocked(loginAction).mockResolvedValue({ success: false, error: { code: 'account_locked', message: 'Account temporarily locked, try again in 15 minutes' } })
    render(<LoginForm />)
    fireEvent.change(screen.getByLabelText(/email/i), { target: { value: 'a@b.com' } })
    fireEvent.change(screen.getByLabelText(/password/i), { target: { value: 'Password1' } })
    fireEvent.click(screen.getByRole('button', { name: /log in/i }))

    await waitFor(() => expect(screen.getByRole('alert')).toHaveTextContent(/temporarily locked/i))
  })

  it('disables the submit button while the request is pending', async () => {
    let resolvePromise: (v: any) => void
    vi.mocked(loginAction).mockReturnValue(new Promise((resolve) => { resolvePromise = resolve }))
    render(<LoginForm />)
    fireEvent.change(screen.getByLabelText(/email/i), { target: { value: 'a@b.com' } })
    fireEvent.change(screen.getByLabelText(/password/i), { target: { value: 'Password1' } })
    fireEvent.click(screen.getByRole('button', { name: /log in/i }))

    expect(screen.getByRole('button', { name: /log in/i })).toBeDisabled()
    resolvePromise!({ success: true, data: { accessToken: 'jwt' } })
  })
})
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/features/auth/components/login-form.test.tsx`
Expected: FAIL — `Cannot find module '@/features/auth/components/login-form'`

- [ ] **Step 3: Implement `src/web/features/auth/components/login-form.tsx`**

```tsx
// src/web/features/auth/components/login-form.tsx
'use client'

import { useState, useTransition } from 'react'
import { loginAction } from '../actions/login'

export function LoginForm() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [rememberMe, setRememberMe] = useState(false)
  const [errorMessage, setErrorMessage] = useState<string | null>(null)
  const [isPending, startTransition] = useTransition()

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setErrorMessage(null)
    startTransition(async () => {
      const result = await loginAction({ email, password, rememberMe })
      if (!result.success) {
        setErrorMessage(result.error.message)
        setPassword('')
        return
      }
      window.location.assign('/dashboard')
    })
  }

  return (
    <form onSubmit={handleSubmit} aria-busy={isPending}>
      {errorMessage && (
        <div role="alert" aria-live="polite">
          {errorMessage}
        </div>
      )}

      <label htmlFor="login-email">Email</label>
      <input
        id="login-email"
        type="email"
        required
        value={email}
        disabled={isPending}
        onChange={(e) => setEmail(e.target.value)}
      />

      <label htmlFor="login-password">Password</label>
      <input
        id="login-password"
        type="password"
        required
        value={password}
        disabled={isPending}
        onChange={(e) => setPassword(e.target.value)}
      />

      <label htmlFor="login-remember">
        <input
          id="login-remember"
          type="checkbox"
          checked={rememberMe}
          disabled={isPending}
          onChange={(e) => setRememberMe(e.target.checked)}
        />
        Remember me
      </label>

      <button type="submit" disabled={isPending}>
        Log in
      </button>
    </form>
  )
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `npx vitest run tests/features/auth/components/login-form.test.tsx`
Expected: PASS (3 tests)

- [ ] **Step 5: Write `src/web/app/(marketing)/login/page.tsx`**

```tsx
// src/web/app/(marketing)/login/page.tsx
import { LoginForm } from '@/features/auth/components/login-form'

export default function LoginPage() {
  return (
    <main>
      <h1>Log in</h1>
      <LoginForm />
    </main>
  )
}
```

- [ ] **Step 6: Commit**

```bash
git add src/web/features/auth/components/login-form.tsx src/web/app/\(marketing\)/login/ tests/features/auth/components/
git commit -m "feat(auth): add login page and LoginForm component"
```

---

### Task 7: Logout Route Handler

**Files:**
- Create: `src/web/app/api/auth/logout/route.ts`
- Test: `tests/features/auth/api/logout.test.ts`

**Interfaces:**
- Consumes: `hashRefreshToken` (Task 2), `prisma` (Task 1)
- Produces: `POST` handler at `src/web/app/api/auth/logout/route.ts` — revokes the refresh token matching the cookie (if any) and clears the cookie; always returns `200` with `data: null` (idempotent even with no cookie, per spec's logout behavior)

- [ ] **Step 1: Write failing tests**

```ts
// tests/features/auth/api/logout.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mockDeep, mockReset } from 'vitest-mock-extended'
import type { PrismaClient } from '@prisma/client'

vi.mock('@/lib/db/prisma', () => ({ prisma: mockDeep<PrismaClient>() }))
vi.mock('next/headers', () => ({ cookies: () => ({ get: vi.fn(), delete: vi.fn() }) }))
import { prisma } from '@/lib/db/prisma'
import { cookies } from 'next/headers'
import { POST } from '@/app/api/auth/logout/route'
const prismaMock = prisma as unknown as ReturnType<typeof mockDeep<PrismaClient>>

beforeEach(() => mockReset(prismaMock))

describe('POST /api/auth/logout', () => {
  it('revokes the matching refresh token and clears the cookie', async () => {
    vi.mocked(cookies().get).mockReturnValue({ value: 'valid-token' } as any)
    prismaMock.refreshToken.updateMany.mockResolvedValue({ count: 1 } as any)
    const res = await POST()
    const body = await res.json()
    expect(res.status).toBe(200)
    expect(body).toEqual({ success: true, data: null, error: null })
    expect(prismaMock.refreshToken.updateMany).toHaveBeenCalled()
    expect(cookies().delete).toHaveBeenCalledWith('refresh_token')
  })

  it('is idempotent when no refresh_token cookie is present', async () => {
    vi.mocked(cookies().get).mockReturnValue(undefined)
    const res = await POST()
    const body = await res.json()
    expect(res.status).toBe(200)
    expect(body).toEqual({ success: true, data: null, error: null })
    expect(prismaMock.refreshToken.updateMany).not.toHaveBeenCalled()
  })
})
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/features/auth/api/logout.test.ts`
Expected: FAIL — `Cannot find module '@/app/api/auth/logout/route'`

- [ ] **Step 3: Implement `src/web/app/api/auth/logout/route.ts`**

```ts
// src/web/app/api/auth/logout/route.ts
import { NextResponse } from 'next/server'
import { cookies } from 'next/headers'
import { prisma } from '@/lib/db/prisma'
import { hashRefreshToken } from '@/lib/auth/refresh-token'

export async function POST() {
  const presented = cookies().get('refresh_token')?.value

  if (presented) {
    await prisma.refreshToken.updateMany({
      where: { tokenHash: hashRefreshToken(presented), revokedAt: null },
      data: { revokedAt: new Date() },
    })
  }

  cookies().delete('refresh_token')
  return NextResponse.json({ success: true, data: null, error: null })
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `npx vitest run tests/features/auth/api/logout.test.ts`
Expected: PASS (2 tests)

- [ ] **Step 5: Commit**

```bash
git add src/web/app/api/auth/logout/ tests/features/auth/api/logout.test.ts
git commit -m "feat(auth): add logout route handler"
```

---

### Task 8: Full test run + coverage check

**Files:** none created — verification only.

- [ ] **Step 1: Run the full test suite**

Run: `npx vitest run --coverage`
Expected: all `tests/features/auth/**` and `tests/lib/auth/**` suites PASS

- [ ] **Step 2: Confirm coverage meets the 80% minimum for `src/web/features/auth/` and `src/web/lib/auth/`**

Run: inspect the coverage report's per-file lines for those two directories
Expected: ≥80% statements/branches; if below, add the missing test case rather than lowering the bar

- [ ] **Step 3: Type-check**

Run: `npx tsc --noEmit`
Expected: no errors

- [ ] **Step 4: Update tracking**

Check the box for step 7 ("Implement Plan") in `docs/plans/plan.md` under the `AUTH-user-auth` entry once all tasks above are committed, then move to step 8 ("Run Tests") for final sign-off.

---

## Notes / Deferred (per spec's Open Questions)

- API-layer rate limiting (distinct from per-account lockout) is called out in the spec as still needing exact thresholds — not implemented in this plan; add a follow-up task once thresholds are defined.
- Multi-device/session management (viewing/revoking individual sessions) is explicitly out of scope.
- `bcrypt`, `jsonwebtoken`, `vitest-mock-extended`, and their `@types/*` packages must be added to `package.json` before Task 1 (`npm install bcrypt jsonwebtoken && npm install -D @types/bcrypt @types/jsonwebtoken vitest-mock-extended`) if not already present.
