'use server'

import { redirect } from 'next/navigation'
import { createSession } from '@/lib/auth/session'
import { verifyPassword } from '@/lib/auth/password'
import { signInSchema } from '../schemas/sign-in-schema'
import { getUserByEmail } from '../queries/get-user-by-email'

type ActionResult = { success: true } | { success: false; error: string }

export async function signIn(input: unknown): Promise<ActionResult> {
  const parsed = signInSchema.safeParse(input)
  if (!parsed.success) {
    return { success: false, error: parsed.error.issues[0].message }
  }

  const user = await getUserByEmail(parsed.data.email)
  if (!user) {
    return { success: false, error: 'Invalid email or password' }
  }

  const isValid = await verifyPassword(parsed.data.password, user.passwordHash)
  if (!isValid) {
    return { success: false, error: 'Invalid email or password' }
  }

  await createSession({ userId: user.id })
  redirect('/dashboard')
}
