import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

const SESSION_COOKIE = 'session'
const PROTECTED_PREFIXES = ['/dashboard']

export function middleware(request: NextRequest) {
  const isProtected = PROTECTED_PREFIXES.some((prefix) =>
    request.nextUrl.pathname.startsWith(prefix),
  )
  if (!isProtected) return NextResponse.next()

  const hasSession = request.cookies.has(SESSION_COOKIE)
  if (!hasSession) {
    const signInUrl = new URL('/sign-in', request.url)
    signInUrl.searchParams.set('from', request.nextUrl.pathname)
    return NextResponse.redirect(signInUrl)
  }

  return NextResponse.next()
}

export const config = {
  matcher: ['/dashboard/:path*'],
}
