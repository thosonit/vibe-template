# Spec AUTH: User Login

## Summary

Email/password login for the web app, using JWT access tokens with rotating refresh tokens. Includes account lockout on repeated failed attempts and a "remember me" option for extended sessions.

## Scope

**In scope:**
- Login with email + password
- Access/refresh token issuance (JWT access token, rotating refresh token)
- Refresh token rotation with reuse detection
- Logout (refresh token revocation)
- Account lockout after repeated failed login attempts
- "Remember me" (extended refresh token lifetime)

**Out of scope (separate specs):**
- Account registration
- Password reset / forgot password
- Email verification flow (this spec assumes an account's email is already verified as a precondition for login; the verification flow itself is defined elsewhere)
- OAuth / social login

## Actors

- **End user** — has an existing, email-verified account and wants to authenticate to access the app.

## Requirements

### Password Policy

- Minimum 8 characters, must include at least one letter and one number.
- Enforced at registration (out of scope here) and re-validated on login only for format, not strength (login just compares hashes).

### Login Flow

1. User submits email, password, and optional "remember me" flag to `POST /auth/login`.
2. Server validates, in order:
   - Account exists for the given email.
   - Account is not currently locked out.
   - Account's email is verified.
   - Password matches the stored hash (bcrypt/argon2).
3. On success:
   - Reset the account's failed-login-attempt counter.
   - Issue an `access_token` (JWT, 15 min TTL).
   - Issue a `refresh_token` (7 day TTL by default, 30 days if "remember me" is set).
   - Return `access_token` in the response body; set `refresh_token` as an `httpOnly`, `secure`, `SameSite=Strict` cookie.
4. On failure (bad password):
   - Increment the account's failed-login-attempt counter.
   - If the counter reaches 5, lock the account for 15 minutes.
   - Return a generic error that does not reveal whether the email exists.

### Account Lockout

- Threshold: 5 consecutive failed attempts.
- Lockout duration: 15 minutes, auto-expires (no manual/admin unlock required).
- Failed-attempt counter resets on a successful login.
- Locked-out login attempts return an error indicating the account is temporarily locked and roughly when it will unlock, without additional account detail.

### Token Refresh

- `POST /auth/refresh` reads the `refresh_token` from the cookie.
- Server validates the token is unexpired and not already revoked.
- On success: revoke the presented refresh token, issue a new `access_token` + new `refresh_token` (rotation), set the new refresh token cookie.
- On reuse of an already-revoked refresh token: treat as a suspected token theft — revoke all outstanding refresh tokens for that user, and require the user to log in again.

### Logout

- `POST /auth/logout` revokes the current refresh token and clears the cookie.

### Error Handling

- Invalid credentials (unknown email or wrong password): generic "Email or password is incorrect" — no enumeration of which part was wrong or whether the account exists.
- Locked account: explicit "account temporarily locked, try again in N minutes" message.
- Unverified email: explicit message directing the user to verify their email before logging in.
- Rate limiting is applied at the API layer (independent of per-account lockout) to slow down distributed brute-force attempts across many accounts.

## Security Notes

- Passwords stored as salted hashes (bcrypt or argon2), never in plaintext or reversible form.
- Refresh tokens are rotated on every use; reuse of a revoked token is treated as a compromise signal.
- Refresh tokens are never exposed to client-side JS (httpOnly cookie only); access tokens are short-lived and held client-side.

## Open Questions / Follow-ups

- Exact rate-limit thresholds/windows for the API-layer limiter (to be defined during implementation planning or ops review).
- Multi-device/session management (viewing/revoking individual active sessions) is not covered here — candidate for a future spec if needed.
