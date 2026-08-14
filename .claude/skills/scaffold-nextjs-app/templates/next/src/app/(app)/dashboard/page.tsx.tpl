import { requireUser } from '@/lib/auth/session'
import { signOut } from '@/features/sign-in/actions/sign-out'
import { Button } from '@/components/ui/button'

export default async function DashboardPage() {
  const session = await requireUser()

  return (
    <main className="mx-auto max-w-2xl space-y-6 p-6">
      <h1 className="text-2xl font-semibold">Dashboard</h1>
      <p className="text-sm text-muted-foreground">Signed in as user {session.userId}</p>
      <form action={signOut}>
        <Button type="submit" variant="outline">
          Sign out
        </Button>
      </form>
    </main>
  )
}
