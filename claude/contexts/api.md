# API context — `apps/api/`

NestJS 11 + Prisma 7. Loads when working in `apps/api/`; open by path on tools that do
not auto-load.

## Layers

```
src/presentation/<feature>/   controllers + dto/
src/usecase/<feature>/        services + modules (business logic)
src/service/<feature>/        repositories (data access)
src/orm/                      PrismaService, BaseRepository
```

**Never import upward.** A repository must not import a controller.

One sanctioned exception: a usecase **module** imports its controller, because that is how
NestJS registers it (`controllers: [XController]`). That applies to `*.module.ts` only —
a `*.service.ts` importing from `@presentation/` is a real violation.

Nothing enforces this. There is no `import/no-restricted-paths` or `boundaries/*` rule in
`eslint.config.mjs`, so the layering is convention, and it is currently violated in places.
Do not take existing code as licence.

## File patterns

| Type | Pattern |
| --- | --- |
| Controller | `<feature>.controller.ts` |
| Service | `<feature>.service.ts` |
| Repository | `<feature>.repository.ts` |
| DTO | `<action>.dto.ts` in `dto/` |
| Guard | `<name>.guard.ts` |
| Strategy | `<name>.strategy.ts` |

Barrel `index.ts` in every feature folder.

## Auth and access control

Four guards are registered globally in `app.module.ts`, in order:

1. `AccessTokenGuard` — every route is protected by default
2. `RolesGuard` — enforces `@Roles(Role.ADMIN)`
3. `PermissionsGuard` — DB-driven module permissions for `@RequirePermission` routes; runs
   after `RolesGuard`, and `@Roles` endpoints are unaffected by it
4. `ThrottlerGuard` — rate limiting

`RefreshTokenGuard` is **not** global — apply it explicitly with `@UseGuards()`.

Decorators in `src/decorator/`: `@Public()` (opt out of auth), `@Roles()`,
`@RequirePermission()`, `@GetCurrentUser()`.

JWT is dual-token, access + refresh, with the refresh token hashed in the database.
**Expiries are environment configuration** (`JWT_ACCESS_EXPIRATION`,
`JWT_REFRESH_EXPIRATION`, `JWT_REFRESH_EXPIRATION_REMEMBER`) with no fallback in code — do
not state a lifetime as a fact without reading the deployment's env. There is a
remember-me branch that uses the third value.

## Adding a feature

Presentation, usecase and service folders; Prisma model plus a committed migration if the
schema changes; register the module in `app.module.ts`; barrel exports throughout.

Verify with `pnpm lint && pnpm build`. Note that `pnpm lint` fails on pre-existing errors
in `apps/web` — check whether a failure is yours.

## Tenancy

Multi-tenant. Scoping is applied by a Prisma client extension and **is not
unconditional** — see `contexts/prisma.md` before assuming a query is scoped.
