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

Verify with `pnpm api:lint && pnpm api:build && pnpm api:test` (or `pnpm affected`). The
whole-workspace `pnpm lint` still fails on pre-existing errors in `apps/web` — check whether a
failure is yours (`lint-triage`). `apps/api`'s `lint` no longer mutates the tree; `lint:fix`
does, and is uncached on purpose.

## Docker production build

Three non-obvious hazards in `apps/api/Dockerfile`'s prod stage (fixed 2026-08-20,
`9f812c7e`):

- **`catalog:` specifiers only exist in devDependencies** (`grep 'catalog:'
  apps/api/package.json`). `npm install --omit=dev` still parses the field and rejects
  `catalog:` with `EUNSUPPORTEDPROTOCOL` — the prod-stage rewrite must delete
  `devDependencies` outright, not just rely on `--omit=dev`.
- **`prisma` (the CLI) is a devDependency** in `apps/api/package.json`, but the ECS migrate
  task needs it at runtime. It must be promoted into `dependencies` before the prod-stage
  `npm install`, and copied from that npm-installed tree — not from pnpm's
  `.pnpm/prisma@*/node_modules/prisma`, which is missing `.bin` and CLI deps and fails with
  `prisma: not found`.
- **`dotenv` is undeclared** — no entry in `apps/api/package.json`, present only via
  transitive hoisting in local pnpm trees. `prisma.config.ts` must not hard-`import
  'dotenv/config'`; load it defensively (try/catch) since the prod image and CI won't have
  it and inject `DATABASE_URL` directly.

`apps/api/prisma/scripts/migrate-deploy.sh` calls the installed binary directly
(`./node_modules/.bin/prisma`, falling back to `node
./node_modules/prisma/build/index.js`) rather than `npx prisma` — `npx` consults
`package.json` and skips a devDependency under `NODE_ENV=production`.

## Tenancy

Multi-tenant. Scoping is applied by a Prisma client extension and **is not
unconditional** — see `contexts/prisma.md` before assuming a query is scoped.
