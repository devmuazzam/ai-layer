# TCG platform — always-on context

Crane rental platform. NestJS API + Next.js web + Expo mobile + a shared TS package. This file
is what is true on every prompt; process detail lives in `.ai/aidlc/GUIDE.md`, per-surface
rules in `.ai/claude/contexts/`.

## Where answers come from

| Question | Source |
| --- | --- |
| **How do we build it?** | This file + the surface context for what you touch |
| **What should it do?** | `.ai/vault/` — `INDEX.md` first, then the module's `INDEX.md` |
| **What is in flight?** | `.ai/aidlc/<TICKET>/` — `state.md` first, then intent, spec, units |

**A rule never makes a requirement true.** Behaviour not written in the vault or on a ticket
is unspecified. Most of the vault is `status: unverified`; a file with non-empty
`conflicts_with` is answered from its conflict stub, never on its own.

**Read `.ai/vault/` and `.ai/aidlc/` by section.** Check size first (`wc -c`); over ~40 KB,
`grep -n` the heading and read that range. Never read a meeting transcript or a `gaps.md`
whole. Research across several large files goes to a subagent (`tcg-scrum`, `Explore`).

Open questions: a ticket's live in its `spec.md` §12; a question belonging to no ticket in
`vault/<module>/gaps.md`. Where each kind of fact is written: `GUIDE.md` §10.

## Build requests enter AI-DLC — through triage

Before writing code, name the ticket (or say there is none) and the path (`GUIDE.md` §2):

| Path | When | What runs |
| --- | --- | --- |
| **A** | New behaviour, or client-facing behaviour nobody specified | intent → spec → units → execute → analyse → reflect |
| **B** | Bug against specified behaviour | repro → `tcg-executor` → `tcg-analyst` |
| **C** | Small, stated change | build, self-review (`find-component` first if UI) |

A path becomes A only for guardrail G1 or one side of a vault conflict. Questions, debugging,
reviews and exploration do not enter the loop.

## The AI decides how; it stops only at the guardrails

The vault says _what_. _How_ — tables, columns, reuse versus new, endpoints, shapes,
defaults, sort orders, siblings — the AI decides (`contexts/patterns.md`, then the nearest
existing code, then the simplest option) and **records** in `spec.md` §11b or the PR's _AI
decisions_ table. A developer reviews it in the PR. Stop only at:

- **G1** client-facing behaviour nobody specified → §12 question to the owner, batched
- **G2** destroying or rewriting existing data → developer approval + guard run on a copy of staging data
- **G3** tenant data → `tcg-prisma-guardian`; a new tenant model goes in `TENANT_SCOPED_MODELS` (`prisma.service.spec.ts` fails otherwise)
- **G4** pay rules → source in `vault/payroll/payroll-rules-provenance.md`, same commit
- **G5** new dependency → ask; changed response shape → `tcg-contract-tracer`, callers fixed in the same unit
- **G6** push to `main`, secrets → blocked by hooks and permissions

**No new tests unless the developer asks** (Haris, 2026-10-21). Run the existing ones; do not
write new spec files or test cases — in a unit, a fix or a sweep — unless the prompt or the
ticket asks for them. Where a template has a tests row, it reads `not requested` by default.

## Siblings get the same change

A change to one instance of a `contexts/patterns.md` shape goes to its siblings too —
applied in the same PR or listed as a follow-up, and recorded either way.

## One unit, or one independent task, per PR

No size budget. Dependent units stack (U2's PR targets U1's branch). Sweeps — lint/format
autofix, import order, dependency upgrades, unrelated fixes — are their own PR.

## Tooling is Haris-only

`.ai/claude/**`, `.ai/aidlc/agents/**`, `.ai/aidlc/templates/**`, `.ai/aidlc/GUIDE.md`,
`.ai/setup.sh`, `.ai/verify.sh`, `.ai/README.md` are changed only when
`git -C .ai config user.email` is `syed.haris@codingcops.com`; otherwise write the proposed
change out for Haris. `.claude/hooks/guard-edits.mjs` enforces it for Edit/Write, and blocks
client-repo edits on `main`.

## One memory, every tool

The memory is the files under `.ai/` — never a tool's own memory, rules or saved prompts. A
fact reaches the team only when the overlay is committed and pushed (in a worktree:
`pnpm worktree:done`). Where each kind of fact goes and who writes it: `GUIDE.md` §10.

## Surface contexts

On Claude Code these load when you work in the directory; on other tools open them by path.

| Working in | Read |
| --- | --- |
| `apps/api/` | `contexts/api.md` |
| `apps/api/prisma/` | `contexts/prisma.md` |
| `apps/web/` | `contexts/web.md` (test IDs, browser autofill, components) |
| `apps/mobile/` | `contexts/mobile.md` |
| `packages/payroll-engine/` | `contexts/payroll-engine.md` |
| A CRUD, reference list or other recurring shape | `contexts/patterns.md` |

## Stack

| App | Path | Stack | Port |
| --- | --- | --- | --- |
| API | `apps/api/` | NestJS 11 + Prisma 7 + PostgreSQL | 3000 |
| Web | `apps/web/` | Next.js 16 + Tailwind v4 + shadcn/ui | 3001 |
| Mobile | `apps/mobile/` | Expo SDK 54 + Expo Router | 8081 |
| Shared | `packages/shared/` | Pure TypeScript | — |
| E2E | `qa-automation/` | Playwright + Prisma 7 — live API + Postgres | — |

Node 22.22.0, pnpm 10, **Nx** (package-based; every `package.json` script is a target).
`@tcg/shared` is consumed as its **built `dist/`** — never alias it to `src`. Always
`pnpm nx …`, never `npx nx` (the root script sets `NX_LOAD_DOT_ENV_FILES=false`; without it
the API's `.env` breaks `next build`).

## Commands

```bash
pnpm install                    # also wires the tracked git hooks
pnpm api:dev / web:dev          # dev servers (build @tcg/shared first)
pnpm mobile:start               # Expo
pnpm db:migrate / db:studio     # migration / Prisma Studio
pnpm lint && pnpm build         # every project, cached by Nx
pnpm test / pnpm typecheck      # api jest · web node --test · mobile jest / web + mobile tsc
pnpm affected                   # lint + build + test for projects changed vs main
```

**Nothing runs these automatically** — pre-push keeps only the `main` guard and CI only
deploys (the PR size check goes with #897). Run them yourself. On an 8 GB machine the API's lint and build
need `NODE_OPTIONS=--max-old-space-size=4096`. As of 2026-10-21 lint has 0 errors on every
project; a lint error is yours.

## Architecture invariants

- **API:** `presentation → usecase → service → orm`, never upward (module registration is
  the one exception).
- **Web:** feature-first — `src/features/<feature>/`; `components/` is a shared library over
  nine directories (not an atomic hierarchy). `components/` never imports from `features/`.
- **Mobile:** Expo Router groups are personas, not pages.
- Barrel `index.ts` at every layer boundary.

## Naming and aliases

Files `kebab-case` · classes `PascalCase` · functions `camelCase` · constants `UPPER_SNAKE` ·
DB tables/columns `snake_case` via `@@map()` / `@map()`.
API aliases: `@orm/* @presentation/* @usecase/* @service/* @config/* @guard/* @decorator/*
@strategy/* @utility/* @filter/* @interceptor/* @context/*`. Web `@/*` → `./src/*`; mobile
`@/*` → `./*`.

## Identity — UUID primary keys, per-tenant business codes

- PK `id String @id @default(uuid()) @db.Uuid`; business code unique **per tenant**
  (`@@unique([tenantCompanyId, <codeField>])`), never the PK.
- Children reference the parent by UUID. Routes and DTOs use the code; the service resolves
  `(tenant, code) → id` once. New codes come from `entity_sequences`.
- Derive an entity's code field and prefix — `grep '@@unique(\[tenantCompanyId'
  apps/api/prisma/schema.prisma`, `grep getNextValue` in its service. Never from memory.
- Tenant scoping is a Prisma `$extends` extension and **not unconditional** —
  `contexts/prisma.md`. Never assume a query is scoped.

## Code quality

- Strict TypeScript, no `any`. Named exports only (except Next.js pages). One root Prettier
  config. JSDoc on public APIs.
- Git hooks in `.husky/` run in every worktree (`pnpm install` there first). `pre-commit`
  runs lint-staged, which can rewrite what you staged — re-read `git diff --staged`.
- `data-testid` in `apps/web` is a contract with `qa-automation/` — `grep -rn '<id>'
  qa-automation/e2e` before renaming one (`contexts/web.md` → _Test IDs_).
- Lint does not check module boundaries, duplication or hardcoded colours.
- **No AI committer identity:** commits and PRs carry the human developer's name and email
  only — never `Co-Authored-By`, `Committer: Claude` or an AI attribution line.

## Say how you know

Before saying something works, is fixed or is done, check the thing the claim is about, and say
what you checked. A fix is checked by repeating the original symptom, not by changing the code.
A screen is checked on the screen, in the right tenant and date. Data is checked by querying it. A
subagent's report is a lead, not a result. If you did not check it, say "not run" or "not checked":
that is always acceptable, and it never needs a new test.

**Debugging:** reproduce it and find the cause before changing code. Rule out the local state first:
branch, pending migrations, stale Prisma client or `@tcg/shared` build, tenant, date. Change one
thing at a time. After two failed fixes, stop and report what you know. API failures: `debug-api`.

<!-- nx configuration start-->
<!-- Leave the start & end comments to automatically receive updates. -->

## General Guidelines for working with Nx

- For navigating/exploring the workspace, invoke the `nx-workspace` skill first - it has patterns for querying projects, targets, and dependencies
- When running tasks (for example build, lint, test, e2e, etc.), always prefer running the task through `nx` (i.e. `nx run`, `nx run-many`, `nx affected`) instead of using the underlying tooling directly
- Prefix nx commands with the workspace's package manager (e.g., `pnpm nx build`, `npm exec nx test`) - avoids using globally installed CLI
- You have access to the Nx MCP server and its tools, use them to help the user
- For Nx plugin best practices, check `node_modules/@nx/<plugin>/PLUGIN.md`. Not all plugins have this file - proceed without it if unavailable.
- NEVER guess CLI flags - always check nx_docs or `--help` first when unsure

## Scaffolding & Generators

- For scaffolding tasks (creating apps, libs, project structure, setup), ALWAYS invoke the `nx-generate` skill FIRST before exploring or calling MCP tools

## When to use nx_docs

- USE for: advanced config options, unfamiliar flags, migration guides, plugin configuration, edge cases
- DON'T USE for: basic generator syntax (`nx g @nx/react:app`), standard commands, things you already know
- The `nx-generate` skill handles generator discovery internally - don't call nx_docs just to look up generator syntax

<!-- nx configuration end-->
