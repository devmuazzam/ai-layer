# TCG platform — always-on context

Crane rental platform. NestJS API + Next.js web + Expo mobile + a shared TS package.

This file is **surface knowledge**: what is true about this codebase, in every phase of
work. It does not describe how work moves — that is AI-DLC's job, below.

## Where answers come from

Three different questions, three different sources. Getting this wrong is the most
expensive mistake available here.

| Question | Source |
| --- | --- |
| **How do we build it?** | This file, plus the surface context for what you are touching |
| **What should it do?** | `.ai/vault/` — read `INDEX.md` **first** |
| **What is in flight on this ticket?** | `.ai/aidlc/SCRUM-###/` — intent, spec, units |

**Rules govern how we build, never what to build. A rule can never make a requirement
true.** If a behaviour is not written in the vault or on a ticket, it is unspecified —
say so and ask. Do not infer product intent from neighbouring code.

Two things about the vault that change how you read it: most of it is `status:
unverified` (migrated from Confluence, never adjudicated), and it has open conflicts
where several documents disagree. If a file's `conflicts_with` is non-empty, do not pick
one and answer from it — read the conflict stub. Open questions live in
`.ai/vault/gaps.md`.

## Surface contexts

Deeper rules live per surface. On Claude Code these load automatically when you work in
the directory; **on other tools they do not — open them by path.**

| Working in | Read |
| --- | --- |
| `apps/api/` | `.ai/claude/contexts/api.md` |
| `apps/api/prisma/` | `.ai/claude/contexts/prisma.md` |
| `apps/web/` | `.ai/claude/contexts/web.md` |
| `apps/mobile/` | `.ai/claude/contexts/mobile.md` |

## Stack

| App | Path | Stack | Port |
| --- | --- | --- | --- |
| API | `apps/api/` | NestJS 11 + Prisma 7 + PostgreSQL | 3000 |
| Web | `apps/web/` | Next.js 16 + Tailwind v4 + shadcn/ui | 3001 |
| Mobile | `apps/mobile/` | Expo SDK 54 + Expo Router | 8081 |
| Shared | `packages/shared/` | Pure TypeScript | — |

Node 22.22.0 (`.nvmrc`), pnpm workspaces.

## Commands

```bash
pnpm install                    # install
pnpm api:dev / web:dev          # dev servers
pnpm mobile:start               # Expo
pnpm db:migrate                 # create + run a migration
pnpm db:studio                  # Prisma Studio
pnpm lint && pnpm build         # quality gate (runs every workspace)
```

`pnpm lint` currently fails on pre-existing errors in `apps/web`. Check whether a failure
is yours before chasing it.

## Architecture invariants

- **API:** `presentation → usecase → service → orm`. Never import upward. NestJS module
  registration is the sanctioned exception — a usecase module imports its controller.
- **Web:** atoms → molecules → organisms → templates → pages. Never import upward.
- Barrel `index.ts` at every layer boundary.

## Naming

| Thing | Convention | Example |
| --- | --- | --- |
| Files | `kebab-case` | `access-token.guard.ts` |
| Classes | `PascalCase` | `AuthService` |
| Functions | `camelCase` | `signUp` |
| Constants | `UPPER_SNAKE` | `JWT_SECRET` |
| DB columns / tables | `snake_case` via `@map()` / `@@map()` | `password_hash` / `users` |

## Import aliases

- **API:** `@orm/* @presentation/* @usecase/* @service/* @config/* @guard/* @decorator/*
  @strategy/* @utility/* @filter/* @interceptor/* @context/*`
- **Web:** `@/*` → `./src/*`
- **Mobile:** `@/*` → `./*`, `@tcg/shared` → `packages/shared/src`

## Identity — UUID primary keys, per-tenant business codes

Every business entity carries two identifiers: a UUID primary key, and a prefixed
business code that is unique **only within a tenant**. The code is never the primary key.

- PK: `id String @id @default(uuid()) @db.Uuid`
- Code: `@@unique([tenantCompanyId, <codeField>])` — never globally unique
- Child tables reference the parent by UUID, never by code
- Routes and DTOs use the code for UX; the service resolves `(tenant, code) → id` once
- New codes are minted from `entity_sequences`

**Do not work from a memorised list of entity codes — derive it.** The field and prefix
differ per model and the set grows. For any entity: `grep '@@unique(\[tenantCompanyId'
apps/api/prisma/schema.prisma` for its code field, and `grep getNextValue`
in its service for the prefix. Full detail in `contexts/prisma.md`.

Tenant scoping is applied by a Prisma **client extension** (`$extends`), not middleware,
and it is **not unconditional** — see `contexts/prisma.md` for when it does not apply.
Never assume a query is tenant-scoped without checking.

## Code quality

Strict TypeScript, no `any`. Named exports only, except Next.js pages. ESLint + Prettier,
Husky pre-commit. JSDoc on public APIs.

**Lint does not enforce most of the conventions in this file.** There is no rule for
module boundaries, duplication, or hardcoded colours. Passing lint is not evidence a
convention was followed.

## Elsewhere

- `.ai/vault/INDEX.md` — product knowledge, read first
- `.ai/vault/gaps.md` — open product questions
- `.ai/aidlc/agents/` — the AI-DLC phase agents
- `.ai/vault/sync/confluence-sync.md` — how the vault tracks Confluence
