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

**Enforced by lint** (`@typescript-eslint/no-restricted-imports`, error — PRs #899/#900):
no runtime import from a higher layer, by alias or relative path. Allowed: `import type`
(no runtime dependency), `*.module.ts` (Nest module registration), `*.spec.ts`, and a usecase
service injecting a presentation `*.gateway` — keep that a value import: with
`emitDecoratorMetadata`, `import type` of an injected class breaks DI silently. A helper a
repository needs lives in `service/` or `utility/`, never `usecase/`.

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

## Picker list routes — page without counting

`utility/picker-list.helpers.ts` `findPickerList` is the shared dual-mode helper for
searchable dropdowns. On a paged call it answers `hasMore` by taking `limit + 1` rows and
trimming — **not** a second `count()`. `PickerPage.total` is optional and usually absent;
nothing in the picker UI renders it, and counting on every keystroke doubled the work.

Hand-rolled picker queries (jobs list picker path, eligible approvers, resource-catalog
tree) must use the same overshoot pattern. Resource-catalog **search** still needs
per-kind counts for window placement across kinds — that is the standing exception, not a
licence to count elsewhere.

`QueryPickerDto` (and the jobs / resource-catalog search DTOs that mirror it) cap
`limit` at `@Max(100)`. Do not raise that for a "just in case" page size — the web
constant is `PICKER_PAGE_SIZE` and stays well below it.

Pagination `orderBy` must end on a unique key — see `contexts/prisma.md` (*Picker
pagination sorts on a unique last key*).

## Reading frozen or copied data

A reader of a frozen copy (snapshot, history, revision) imports the **same exported
`orderBy` constant** as the live read of the same data and adds no tie-break of its own. If
the live order needs a unique last key, add it to the shared constant, so both reads change
together (TCG-218).

## Notifications

Every key in the notification catalog is a member of `NOTIFICATION_TYPES` in `@tcg/shared`
(`packages/shared/src/types/notification.types.ts`). The catalog is keyed by plain string, so
tsc does not catch a miss (`payroll.entry_corrected`, PAYROLL-FLAGS, fixed in #735). Add a
type to both in the same commit.

## Testing

No new tests unless the developer asks (root `CLAUDE.md`). A unit that changes a provider
constructor, or a module's `providers` or `imports`, boots the API once (`pnpm api:dev`) so a
DI break shows before the PR, not after (TICKET-FLOW-SLOTS-HOLDOVER).
