# API

## List of APIs

| Group | Doc                                    |
| ----- | -------------------------------------- |
| Auth  | [endpoints/auth.md](endpoints/auth.md) |

## Convention

- Base path: `/api/v1`
- Format: JSON request/response bodies, `Content-Type: application/json`
- Naming: resource paths are plural, kebab-case (`/auth/refresh-tokens`)
- HTTP methods: `GET` read, `POST` create/action, `PATCH` partial update, `DELETE` remove
- Response envelope:
  ```json
  {
    "success": true,
    "data": {},
    "error": null
  }
  ```
- Errors use the same envelope with `success: false`, `data: null`, and `error: { "code": "...", "message": "..." }`

## Authentication

- Access token: JWT, sent as `Authorization: Bearer <token>`, 15 min TTL
- Refresh token: opaque, stored in an `httpOnly`, `secure`, `SameSite=Strict` cookie, never exposed to client JS
- Unauthenticated requests to protected endpoints return `401`

## Rules

- Never return sensitive fields (password hash, raw tokens) in any response
- Validate all input server-side, even if already validated client-side
- Rate limit sensitive endpoints (login, refresh) at the API layer
- Error messages must not leak whether a resource (e.g. an email/account) exists
- Every new endpoint must be documented in `docs/api/endpoints/*.md` before merge
