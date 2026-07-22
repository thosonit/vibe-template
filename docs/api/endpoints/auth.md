# Auth Endpoints

Related spec: [AUTH-user-auth](../../specs/AUTH-user-auth.spec.md)

## POST /auth/login

Log in with email and password.

**Request**
```json
{
  "email": "user@example.com",
  "password": "string",
  "rememberMe": false
}
```

**Response 200**
```json
{
  "success": true,
  "data": {
    "accessToken": "jwt"
  },
  "error": null
}
```
Sets `refresh_token` as an httpOnly cookie.

**Errors**
- `401 invalid_credentials` — wrong email or password (generic message)
- `403 account_locked` — too many failed attempts, includes retry time
- `403 email_not_verified` — email not yet verified

---

## POST /auth/refresh

Exchange the refresh token cookie for a new access token (rotation).

**Request**: no body, reads `refresh_token` cookie.

**Response 200**
```json
{
  "success": true,
  "data": {
    "accessToken": "jwt"
  },
  "error": null
}
```
Sets a new `refresh_token` cookie, revokes the old one.

**Errors**
- `401 invalid_token` — expired or unknown token
- `401 token_reuse_detected` — revoked token reused; all sessions for the user are revoked, user must log in again

---

## POST /auth/logout

Revoke the current refresh token and clear the cookie.

**Request**: no body, reads `refresh_token` cookie.

**Response 200**
```json
{
  "success": true,
  "data": null,
  "error": null
}
```
