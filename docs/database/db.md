# Database Schema

The schema below is written in [DBML](https://dbml.dbdiagram.io/docs/) (Database Markup Language). To view it as a visual ERD:

1. Copy the entire contents of the code block below.
2. Open https://dbdiagram.io/d
3. Paste it into the editor to render the entity-relationship diagram.

## Schema

```dbml
Table users {
  id uuid [pk, default: `gen_random_uuid()`]
  email varchar [not null, unique]
  password_hash varchar [not null]
  email_verified_at timestamp [null]
  failed_login_attempts int [not null, default: 0]
  locked_until timestamp [null]
  created_at timestamp [not null, default: `now()`]
  updated_at timestamp [not null, default: `now()`]

  Note: 'User accounts. Registration/email verification are covered in a separate spec.'
}

Table refresh_tokens {
  id uuid [pk, default: `gen_random_uuid()`]
  user_id uuid [not null, ref: > users.id]
  token_hash varchar [not null, unique]
  expires_at timestamp [not null]
  revoked_at timestamp [null]
  remember_me boolean [not null, default: false]
  created_at timestamp [not null, default: `now()`]

  Note: 'Rotating refresh tokens. expires_at = now()+7d, or +30d if remember_me is set.'

  indexes {
    user_id
    token_hash
  }
}
```

## Notes

- `users.locked_until`: timestamp when the account lockout expires (15-minute lockout after 5 consecutive failed login attempts); `null` means the account is not locked.
- `refresh_tokens.revoked_at`: when set, the token has been revoked (due to logout, rotation, or detected reuse/theft).
- If a revoked refresh token is reused, treat it as a compromise signal and revoke all `refresh_tokens` for that `user_id` (set `revoked_at`).
- This schema will grow as more specs are added (registration, password reset, etc.).
