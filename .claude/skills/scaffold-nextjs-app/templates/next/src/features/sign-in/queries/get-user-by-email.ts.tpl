import 'server-only'
import { prisma } from '@/lib/db/prisma'

export function getUserByEmail(email: string) {
  return prisma.user.findUnique({
    where: { email },
    select: { id: true, email: true, name: true, passwordHash: true },
  })
}
