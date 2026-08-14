# Database (Prisma)
DATABASE_URL="postgresql://user:password@localhost:5432/{{project_name}}"

# Session signing secret (used by lib/auth/session.ts) — generate with:
# openssl rand -base64 32
SESSION_SECRET="replace-with-a-32-byte-random-secret"

# Public app URL, exposed to the browser bundle
NEXT_PUBLIC_APP_URL="http://localhost:3000"
