# Screen AUTH: Login

## 1. Related Spec

[AUTH-user-auth.spec.md](../specs/AUTH-user-auth.spec.md)

## 2. Prototype

[AUTH-user-auth.html](./AUTH-user-auth.html)

## 3. Summary

Single screen where an existing, email-verified user authenticates with email + password, with an optional "remember me" toggle. Surfaces account-lockout and unverified-email states without leaking account existence.

## 4. Layout

- Card (centered, single column, max-width ~380px)
  - Logo
  - Heading ("Log in")
  - Error banner (hidden by default; appears above the form fields when a login attempt fails)
  - Form
    - Email field (label + input)
    - Password field (label + input + show/hide toggle)
    - Remember me (checkbox + label)
    - Submit button ("Log in")
  - Forgot password link (below the form)

See [AUTH-user-auth.html](./AUTH-user-auth.html) for the visual reference — the prototype is the source of truth for exact spacing/styling.

## 5. Elements

| Element | Type | Notes |
|---|---|---|
| Email | text input | required, standard email format validation client-side |
| Password | password input (show/hide toggle) | required |
| Remember me | checkbox | maps to `remember_me` flag on `POST /auth/login` |
| Log in | primary button | disabled while request in flight; shows loading state |
| Forgot password? | link | routes to password-reset flow (out of scope, separate spec) |
| Inline error banner | text/alert region | renders the error states below; announced to screen readers via `aria-live="polite"` |

## 6. States

### Default
Empty form, Log in button enabled once both fields are non-empty and email is well-formed.

### Loading
On submit: button shows spinner and is disabled; inputs are disabled to prevent duplicate submits.

### Success
`POST /auth/login` returns `access_token`; refresh token cookie is set by the server. Redirect to the app's authenticated landing page. No confirmation screen — this state is transient.

### Error — invalid credentials
Message: "Email or password is incorrect." Generic wording per spec — never indicates whether the email exists. Password field is cleared; email is retained. Focus moves to the error banner.

### Error — account locked
Message: "Your account is temporarily locked. Try again in N minutes." `N` derived from server-provided unlock time. Log in button stays enabled (user can retry once the lock naturally expires; server will re-reject until then).

### Error — unverified email
Message: "Please verify your email before logging in." Includes a link/action to resend verification (handled by the separate email-verification spec).

### Error — rate limited
Message: generic "Too many attempts, please try again shortly." Triggered by the API-layer rate limiter, distinct from per-account lockout.

### Error — network/unknown
Message: generic "Something went wrong. Please try again." Fallback for unexpected failures (timeout, 5xx).

## 7. Validation Rules (client-side)

- Email: required, must match basic email pattern.
- Password: required, no client-side strength check on login (only enforced at registration).
- Submit disabled until both fields pass required checks; server is the source of truth for all business rules (lockout, verification, credential match).

## 8. Accessibility

- Form labels explicitly associated with inputs (`<label for>`).
- Error banner uses `role="alert"` / `aria-live="polite"` so screen readers announce failures without moving focus unexpectedly.
- Password visibility toggle has an accessible name ("Show password" / "Hide password") and does not trap keyboard focus.
- All interactive elements reachable and operable via keyboard; visible focus states on inputs, checkbox, and button.

## 9. Responsive Behavior

- Single-column form centered on the viewport at all breakpoints (320–1920).
- Touch target minimum 44x44px for checkbox and buttons on mobile widths.

## 10. Open Questions

- Exact copy/timing display for account-lockout countdown (e.g., live countdown vs. static minute estimate) — to be confirmed during implementation.
- Whether "Forgot password" and "resend verification" links need dedicated screens documented separately (tracked in their respective specs).
