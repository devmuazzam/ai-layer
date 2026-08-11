---
name: debug-api
description: Diagnose a failing NestJS API endpoint — 401, 403, 404, 500, empty results, or a Prisma error. Use when an endpoint misbehaves, a guard blocks access, or a query returns nothing it should return.
---

Triage a failing endpoint. Start from the status code, but check the tenancy case early —
in this codebase an empty result or a 404 is more often an isolation miss than a missing
row, and it looks identical from the client.

## Trace the request

```
Controller (presentation) → Service (usecase) → Repository (service) → Prisma (orm)
```

Find the handler first, then work down. `grep -rn "@Controller\|@Get\|@Post" apps/api/src/presentation/<feature>/`

## By status code

**401 — unauthenticated.** `AccessTokenGuard` runs globally, so every route is protected by
default. Is the route meant to be `@Public()`? Is the token expired — expiries are
env-driven (`JWT_ACCESS_EXPIRATION`), not fixed in code. The web client silently refreshes
and retries once (`apps/web/src/lib/base-api.ts`), so a 401 in the console can be the
designed cycle rather than a fault. Establish which before "fixing" it — the fix for a
designed 401 is usually weakening the auth flow to clean up a log.

**403 — authenticated, not allowed.** Four guards run globally, in order:

1. `AccessTokenGuard`
2. `RolesGuard` — `@Roles(Role.ADMIN)`
3. `PermissionsGuard` — **DB-driven**, for `@RequirePermission` routes. Runs after
   `RolesGuard`, and `@Roles` endpoints are unaffected by it
4. `ThrottlerGuard` — rate limiting; a burst reads as 403/429, not as a permissions bug

If the route uses `@RequirePermission`, the answer is in the database, not the decorator.
Check the permission rows for that user's role before reading any more code.

**404 — check tenancy before existence.** The row may exist in another tenant. See below.

**500 — usually Prisma or a null.** Read the actual stack rather than the response body;
a unique-constraint violation, a missing relation and a null deref look the same to the
caller.

## The tenancy case — check this early

Scoping is a Prisma **client extension** (`$extends` in `orm/prisma.service.ts`), not
middleware, and it is **not unconditional**. It skips scoping entirely when:

1. **there is no request context** — cron jobs, workers, seeds run unscoped;
2. **the user is `SUPER_ADMIN`** — bypassed by design, so a bug that only reproduces for
   normal users is a strong tenancy signal;
3. **the model is not in the allowlist** — anything absent is untouched.

Two symptoms this explains, and neither looks like a tenancy problem from the client:

- **Correct-looking query returns nothing.** The row belongs to another tenant, or the
  caller passed an id from one. `findFirst({ where: { customerCode } })` is scoped only if
  the model is in the allowlist.
- **It works for you and not for them**, or the reverse — you are `SUPER_ADMIN`.

Confirm by reading the allowlist in `prisma.service.ts` rather than assuming. For depth,
hand it to `tcg-prisma-guardian`.

## Codes and identity

A lookup by business code fails when the prefix is wrong, and the prefix rarely matches the
model name — price listings mint `PRCL`, not `PRLT`. Derive it:

```bash
grep -rn "getNextValue" apps/api/src/usecase/<feature>/
```

Some are string literals, some come through a constant, so a grep for quoted literals alone
misses several. And a business code is unique **per tenant** — never globally — so it is
never a safe standalone `where`.

## Tools

```bash
pnpm db:studio                      # inspect rows, including tenantCompanyId
pnpm --filter @tcg/api exec jest <pattern>
```

Swagger is at `/api/docs`. Logging: prefer the Nest `Logger` over `console.log` — the API has
no `no-console` rule, so a stray log will pass lint and ship.

## Before you call it fixed

Say which layer the fault was in and what confirmed it — a fix at the controller for a
repository bug will pass review and reappear. If the cause was tenancy or a guard, say
whether the behaviour was **wrong** or **designed**; those need opposite responses, and
"designed" is the answer more often than it looks.
