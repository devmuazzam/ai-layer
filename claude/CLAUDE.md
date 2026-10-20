# TCG platform — always-on context

Crane rental platform. NestJS API + Next.js web + Expo mobile + a shared TS package.

This file is **surface knowledge**: what is true about this codebase, in every phase of
work. It does not describe how work moves — that is AI-DLC's job, below.

## Where answers come from

Three different questions, three different sources. Getting this wrong is the most
expensive mistake available here.

| Question                              | Source                                                                 |
| ------------------------------------- | ---------------------------------------------------------------------- |
| **How do we build it?**               | This file, plus the surface context for what you are touching          |
| **What should it do?**                | `.ai/vault/` — read `INDEX.md` **first**, then the module's `INDEX.md` |
| **What is in flight on this ticket?** | `.ai/aidlc/SCRUM-###/` — intent, spec, units                           |

**Rules govern how we build, never what to build. A rule can never make a requirement
true.** If a behaviour is not written in the vault or on a ticket, it is unspecified —
say so and ask. Do not infer product intent from neighbouring code.

Two things about the vault that change how you read it: most of it is `status:
unverified` (migrated from Confluence, never adjudicated), and it has open conflicts
where several documents disagree. If a file's `conflicts_with` is non-empty, do not pick
one and answer from it — read the conflict stub.

**Read the vault and ticket folders by section, never whole.** Several files there are
80–220 KB (`SCRUM-926/spec.md`, `payroll/legacy-payroll-app-db-extract/`,
`meetings/transcripts/`), and the module `gaps.md` registers run 45–600 KB (`payroll/gaps.md`
is the largest). One whole-file read of those is 20–55k tokens and is why sessions
hit _prompt too long_. Before opening anything under `.ai/vault/` or `.ai/aidlc/`, check its
size (`wc -c`); over ~40 KB, `grep -n` for the heading or anchor and read only that range
(`sed -n`, or `Read` with offset/limit). Never read a meeting transcript or a retired
`gaps` file in full. Research that spans several large files belongs in a subagent
(`tcg-scrum`, `Explore`) that returns the conclusion, not the pages.

**A question a ticket raised belongs to that ticket** — §12 of `.ai/aidlc/SCRUM-###/spec.md`,
the section that also blocks its sign-off. A ticket folder has no `gaps.md`. To see what is
open across every ticket: `grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/[A-Z]*/spec.md` —
`[A-Z]*`, not `SCRUM-*`: ticket folders are also `TCG-###` and named (`PAYROLL-FLAGS`), and a
`SCRUM-*` sweep misses most open questions. Where a ticket is in the loop: its `state.md`.

That redesign landed 2026-08-24: the vault is organized as one folder per product module
(`vault/STRUCTURE.md` — module set, tag facets, routing protocol, migration map), and **a
product-wide question belonging to no ticket goes in that module's `vault/<module>/gaps.md`**
(payroll included — its live register is `payroll/gaps.md` since the 2026-08-24 disposition).
`.ai/vault/gaps.md` and `.ai/vault/payroll/gaps-2026-08-20-retired.md` stay **retired and frozen** — historical snapshot, citable by anchor, never appended. The
all-modules sweep: `grep -rn '^- \*\*Status:\*\* open' .ai/vault/*/gaps.md`.

## Build requests enter AI-DLC — through triage

**Any prompt that asks to build, change or fix code enters AI-DLC. The entry is triage,
not the full loop.** Before writing code, name the ticket (or say there is none), classify
it per `.ai/aidlc/GUIDE.md` §2, and state the path:

| Path  | When                                                              | What runs                                          |
| ----- | ----------------------------------------------------------------- | -------------------------------------------------- |
| **A** | New behaviour, or anything needing product intent                 | intent → spec → units → execute → analyse → reflect |
| **B** | Bug — the behaviour is specified, or the bug _is_ the deviation   | repro → `tcg-executor` → `tcg-analyst`             |
| **C** | Small, stated change — copy, spacing, a column, a variant         | `find-component` if UI, build, self-review         |

**Any path becomes A the moment you must decide something nobody specified** — a sort
order, a default, a threshold, one side of a vault conflict. Schema, tenancy or an API
shape calls `tcg-prisma-guardian` / `tcg-contract-tracer` on every path.

Questions, debugging, reviews and exploration do not enter the loop. On Claude Code a
`UserPromptSubmit` hook repeats this on every prompt; on other tools this section is the
only trigger. Decision: `vault/decisions/2026-10-09-build-prompts-enter-aidlc-through-triage.md`.

## Developers decide structure — the AI proposes, on every path

**AI is a tool here, not the builder of record.** The vault answers _what_ to build; a
**developer** answers _how it is structured_. On a structural choice the AI lays out the
options and stops — it does not pick one and carry on. A developer who asks "what would you
do?" gets a recommendation with its trade-offs, and still has to state the choice; an AI
suggestion becomes a decision only when the developer says so.

**Structural — stop and ask:**

- a new **table**, **column**, **enum member** or **relation** — and what it holds, its type,
  nullability and default
- a new **exported** function, service, repository method, hook or component **versus reusing
  or extending** an existing one (name the existing candidates you found, with paths)
- a new **endpoint** or a changed **request/response shape**
- a new **dependency**
- following a different shape than the reference in `.ai/claude/contexts/patterns.md`, or
  building something whose pattern entry is `UNDECIDED`

**Not structural — just build:** private helpers inside one file, local variables, test
fixtures, anything the spec or the pattern reference already fixes.

**Record every answer** — Path A: `spec.md` → _Developer decisions_; Paths B and C: the
PR description's _Developer decisions_ table (`commit` skill §6). Each row names the
developer who decided. **An AI never fills the _Decided by_ column**, and never records its
own suggestion as decided. A structural change with no recorded decider is a `review-pr`
finding.

## Siblings get the same change — with the developer's say-so

**Same job, same build.** Recurring shapes (a CRUD, a reference-code list, an archive flow)
have a reference implementation in `.ai/claude/contexts/patterns.md` — follow it. When you
change one instance of a pattern, the others are its **siblings**:

1. **Name them** — every sibling, with paths and what the same change would be in each
   (`patterns.md` lists the instances; confirm with `git grep`).
2. **Ask the developer** whether they get the change too. Never apply it silently, never
   skip mentioning it.
3. **On a yes, apply it in the same PR.** On a no, record why in _Developer decisions_
   ("intentionally different because…" or "follow-up ticket <id>").

The goal is that no developer is surprised by drift: four CRUDs either change together or
someone decided, in writing, that they should not.

## One unit, or one independent task, per PR

**A PR is one AI-DLC unit (Path A) or one independent task (Paths B/C) — and at most ~400
changed source lines in 25 source files.** Tests, migrations, lockfiles and snapshots do
not count. Measure before you push:

```bash
git diff --numstat origin/main...HEAD | grep -Ev '(\.spec\.|\.test\.|/e2e/|__tests__/|^qa-automation/|/migrations/|pnpm-lock\.yaml$|\.snap$)' \
  | awk '{l+=$1+$2; f++} END{print l+0" lines, "f+0" files"}'
```

- **Dependent units ship as stacked PRs**, not one PR: U2 branches from U1's branch and its
  PR targets U1's branch; when U1 merges, GitHub retargets U2 to `main`. Nobody waits.
- **Sweeps are their own PR**: lint/format autofixes, import reordering, dependency or SDK
  upgrades, unrelated fixes. Never inside a feature PR. `lint-staged` reformats whole files
  you touch — if that balloons the diff, commit the reformat separately as its own PR first.
- **"Same branch, one PR for all units" is not a developer choice any more.** It overrode
  the rule on PAYROLL-FLAGS (#709: 21 units, 35,108 source lines, 784 files). The only way
  over the budget is per PR: a developer adds the `size-exception` label and writes why in
  the description.
- **Enforced by** `.github/workflows/pr-size.yml` (red check + a comment listing the commits
  to split along — the free plan cannot block the merge) and by the executor, `commit` and
  `review-pr`, which measure and stop.

## Tooling is Haris-only

The AI layer is changed by **Haris (Syed Haris — git `syed.haris@codingcops.com`) only**:
`.ai/claude/**` (this file, `contexts/`, `skills/`, `settings.json`), `.ai/aidlc/agents/**`,
`.ai/aidlc/templates/**`, `.ai/aidlc/GUIDE.md`, `.ai/setup.sh`, `.ai/verify.sh`,
`.ai/README.md`. Before editing any of them, an AI checks
`git -C .ai config user.email`; if it is not Haris's, it **refuses the edit** and writes the
proposed change out for the developer to send to Haris instead. Everything else in `.ai/` —
`vault/`, ticket folders, `reflections/INDEX.md`, `processed.log` — stays open to every
developer under its owner in the table below. On Claude Code a `PreToolUse` hook
(`.claude/hooks/guard-edits.mjs`) refuses an Edit/Write to a tooling path when the overlay
email is not Haris's, and refuses any client-repo edit while it is on `main`. Shell edits,
other tools and hand edits bypass it, and nothing on GitHub blocks them, so `review-pr` still
flags any tooling change authored by someone else. Decision for this section
and the two above: `vault/decisions/2026-10-09-developers-decide-structure-siblings-and-haris-only-tooling.md`.

## One memory, every tool

Eight developers on four or more AI tools. **The memory is the files under `.ai/`, and
nothing else counts.** Same content, same paths, whichever tool you are in — the overlay is
one repo, symlinked into place, so two tools cannot hold different versions of a fact.

**Never store a project fact in your tool's own memory.** Not Claude Code's memory, not
Cursor Rules or memories, not Antigravity's, not a `.md` in your home directory, not a
saved prompt. A fact kept there is invisible to the other seven people and to every other
tool, it survives no machine but yours, and **nothing anywhere reports the divergence** —
you find out when two developers confidently give different answers.

Anything worth keeping goes to exactly one of these, and each has an owner:

| What you learned                        | Where it goes                                                                                                 | Who writes it                        |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| A named human decided something         | `.ai/vault/decisions/`                                                                                        | `tcg-scrum`                          |
| An open question raised by a ticket     | `.ai/aidlc/SCRUM-###/spec.md` §12                                                                             | any agent, append                    |
| An open question belonging to no ticket | `.ai/vault/<module>/gaps.md` — the module's live register. See `vault/STRUCTURE.md` → _Where a question goes_ | any agent, append                    |
| How we build — a convention, a rail     | `.ai/claude/contexts/` (recurring shapes: `contexts/patterns.md`)                                             | Haris only — see _Tooling is Haris-only_ |
| A defect the loop made                  | `.ai/aidlc/reflections/INDEX.md`                                                                              | `tcg-reflector`                      |

**The test: if deleting your tool's local state would lose it, it is not memory yet.**

Two consequences worth stating, because both are load-bearing. The overlay is a separate
repo — a written fact reaches nobody until it is committed and pushed there, which is why
`close-ticket` ends with that step. In **linked worktrees** (`pnpm worktree:add`) the overlay
rides a per-ticket branch: a fact there reaches the team only when that branch is merged into
overlay **main** — `pnpm worktree:done` does exactly that after `close-ticket`. And **skills and subagents are Claude Code features**:
on other tools the same procedures are still readable at their paths
(`.ai/claude/skills/<name>/SKILL.md`, `.ai/aidlc/agents/`), they just are not invoked for
you. The knowledge is portable; the automation is not. Open the file by path.

## Surface contexts

Deeper rules live per surface. On Claude Code these load automatically when you work in
the directory; **on other tools they do not — open them by path.**

| Working in                 | Read                                                                                                                                            |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| `apps/api/`                | `.ai/claude/contexts/api.md`                                                                                                                    |
| `apps/api/prisma/`         | `.ai/claude/contexts/prisma.md`                                                                                                                 |
| `apps/web/`                | `.ai/claude/contexts/web.md`                                                                                                                    |
| `apps/mobile/`             | `.ai/claude/contexts/mobile.md`                                                                                                                 |
| `packages/payroll-engine/` | `.ai/claude/contexts/payroll-engine.md` — **no pay-rule change without its source in `vault/payroll/payroll-rules-provenance.md`, same commit** |
| Any CRUD, reference list or other recurring shape | `.ai/claude/contexts/patterns.md` — the reference to follow, and the siblings a change must be offered to |

## Stack

| App    | Path               | Stack                                       | Port |
| ------ | ------------------ | ------------------------------------------- | ---- |
| API    | `apps/api/`        | NestJS 11 + Prisma 7 + PostgreSQL           | 3000 |
| Web    | `apps/web/`        | Next.js 16 + Tailwind v4 + shadcn/ui        | 3001 |
| Mobile | `apps/mobile/`     | Expo SDK 54 + Expo Router                   | 8081 |
| Shared | `packages/shared/` | Pure TypeScript                             | —    |
| E2E    | `qa-automation/`   | Playwright + Prisma 7 — live API + Postgres | —    |

Node 22.22.0 (`.nvmrc`), pnpm 10 workspaces, orchestrated by **Nx** (package-based — every
`package.json` script is a target; Nx owns ordering, caching and affected-only runs; the apps
still run `nest`/`next`/`expo` exactly as before). `@tcg/shared` is consumed by every app as
its **built `dist/`** — never alias it to `src` in a tsconfig. Always invoke Nx as `pnpm nx …`,
never `npx nx` (the root script sets `NX_LOAD_DOT_ENV_FILES=false`; without it the API's `.env`
leaks into every task and breaks `next build`).

## Commands

```bash
pnpm install                    # install; also wires the tracked git hooks (core.hooksPath=.husky)
pnpm api:dev / web:dev          # dev servers (build @tcg/shared first, or restore it from cache)
pnpm mobile:start               # Expo
pnpm db:migrate                 # create + run a migration
pnpm db:studio                  # Prisma Studio
pnpm lint && pnpm build         # quality gate — every project, cached by Nx
pnpm test / pnpm typecheck      # api jest · web node --test · mobile jest / web + mobile tsc
pnpm affected                   # lint + build + test only for projects changed vs main
pnpm nx run @tcg/api:build --skip-nx-cache   # force a real run when a cached result looks wrong
```

`pnpm lint` still fails on pre-existing errors in `apps/web` (37 as of 2026-08-19). Check
whether a failure is yours before chasing it — `lint-triage` skill. **Nothing runs lint, test
or build automatically right now** — `.husky/pre-push` keeps only the branch guard (the
`nx affected` gates are commented out in the file, not deleted), and `.github/workflows/`
holds `deploy.yml`, which deploys and checks nothing, and `pr-size.yml`, which checks only
PR size (see _One unit, or one independent task, per PR_). Every lint/test/build gate in
this file is a command you run by hand until those are restored. Verified 2026-10-09.

## Architecture invariants

- **API:** `presentation → usecase → service → orm`. Never import upward. NestJS module
  registration is the sanctioned exception — a usecase module imports its controller.
- **Web:** **feature-first.** `src/features/<feature>/` holds most of the app; `components/`
  is a shared library spread over nine directories, of which `ui/` (shadcn) has the most
  consumers. **It is not an atomic-design hierarchy** — `atoms/`, `molecules/` and
  `organisms/` exist but are three of the nine. Features may import from `components/`;
  `components/` must not import from `features/`. Detail in `contexts/web.md`.
- **Mobile:** persona-driven — Expo Router groups are personas, not pages.
- Barrel `index.ts` at every layer boundary.

## Naming

| Thing               | Convention                            | Example                   |
| ------------------- | ------------------------------------- | ------------------------- |
| Files               | `kebab-case`                          | `access-token.guard.ts`   |
| Classes             | `PascalCase`                          | `AuthService`             |
| Functions           | `camelCase`                           | `signUp`                  |
| Constants           | `UPPER_SNAKE`                         | `JWT_SECRET`              |
| DB columns / tables | `snake_case` via `@map()` / `@@map()` | `password_hash` / `users` |

## Import aliases

- **API:** `@orm/* @presentation/* @usecase/* @service/* @config/* @guard/* @decorator/*
  @strategy/* @utility/* @filter/* @interceptor/* @context/*`
- **Web:** `@/*` → `./src/*`
- **Mobile:** `@/*` → `./*`. `@tcg/shared` is a workspace dependency resolved to its built `dist/`, on every surface — no `src` alias anywhere

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

Strict TypeScript, no `any`. Named exports only, except Next.js pages. ESLint + one root
Prettier config (never per-app copies); an import-order rule (`import-x/order`) on all four
projects. JSDoc on public APIs.

**Git hooks are tracked files in `.husky/` and run in every worktree** (a worktree without
`node_modules` refuses to commit — `pnpm install` there first). `pre-commit`: `lint-staged`
(ESLint `--fix` + Prettier on staged files — it can rewrite what you staged; re-read
`git diff --staged`) only — no build, so commits stay cheap and Nx cache restore cannot
stomp a live `web:dev` / `api:dev`. `pre-push`: **refuses a direct push of `main`, and
nothing else** — the `nx affected` lint/typecheck/build block is commented out in the hook.
`SKIP_GATES=1` is therefore a no-op today; the branch guard was never skippable.

**`data-testid` in `apps/web` is a contract.** `qa-automation/` addresses the UI through
it, and that suite is **outside the pnpm workspace and not yet an Nx project** — so no hook
and no CI job lints, typechecks or runs it, and renaming an ID breaks a test nothing will
report. (Registering it as an Nx project is an accepted PR #386 follow-up; until that lands,
the grep below is the only signal there is.)
New screens ship with IDs; before renaming one, `grep -rn '<the-id>' qa-automation/e2e`.
Scheme and the shared-component rule: `contexts/web.md` → _Test IDs_.

**Browser autofill is suppressed on every `apps/web` form control except login.** Chrome
runs two systems: profile Autofill, beaten by an `autocomplete` token it has never seen, and
the typed-history dropdown, keyed on the DOM `name` and beaten only by a decoy one. So a raw
control takes `useBrowserAutofillDomAttrs()` spread whole; a `<select>`, `<textarea>` or
`type="number"` that must keep its real `name` takes `useBrowserAutofillToken()` instead.
**Never a string literal** — Chrome ignores `"off"`, and any fixed token is identical on every
page load, so it just becomes the new key history accumulates under. Never rewrite DOM `id`,
`placeholder` or label text: `qa-automation` selects on all three, and the ZWNJ label disguise
was removed because a screen reader announces it. `browser-autofill-coverage.test.mjs` fails
the build on a control that breaks any of this. Scope, exemptions and the two things it does
_not_ cover: `vault/decisions/2026-09-22-browser-autofill-suppression-scope-and-mechanism.md`.

**Lint does not enforce most of the conventions in this file.** There is no rule for
module boundaries, duplication, or hardcoded colours. Passing lint is not evidence a
convention was followed.

**No AI committer identity**: Commits must strictly be authored and committed under the human developer's name and email. Never include `Co-Authored-By`, `Committer: Claude`, or AI attribution trailers on commits or PRs.

## Elsewhere

- `.ai/vault/INDEX.md` — product knowledge, read first
- `.ai/aidlc/SCRUM-###/spec.md` §12 — open questions raised by a ticket
- `.ai/vault/STRUCTURE.md` — vault organization: modules, tags, where a question goes
- `.ai/vault/<module>/gaps.md` — live module questions · root/payroll `gaps.md` retired, historical only
- `.ai/aidlc/agents/` — the AI-DLC phase agents
- `.ai/vault/sync/confluence-sync.md` — how the vault tracks Confluence
- `.ai/claude/contexts/web.md` → _Test IDs_ — the `data-testid` contract `qa-automation/` depends on
- `.ai/claude/skills/demo-walkthrough/WALKTHROUGH.md` — fresh tenant → calculated payroll, every URL and pre-req. **Describes shipped code, never a source for a spec**; kept current by `close-ticket` step 5

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
