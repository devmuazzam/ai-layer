# Skills, agents, and the rails beneath them — analysis

Status: **analysis only.** Nothing outside this file was changed. No skill, agent, eslint
config, rule file or application code was edited, and no diffs are proposed below.

Every claim carries a `file:line`. Every finding is tagged **VERIFIED** (a command was run,
or a config was read and the quoted text is in it) or **INFERRED** (reasoned from reading).
The two are never mixed inside one sentence.

Commands run for this analysis, for reproduction:

| # | Command | Where |
| --- | --- | --- |
| C1 | `npx eslint --no-fix <the 7 formatInternalId services>` | `apps/api` |
| C2 | `npx eslint src/ -f json -o …` | `apps/web` |
| C3 | `grep -rn "formatInternalId" apps packages` | repo root |
| C4 | `grep -rni "abortifnoformchanges\|abort_if_no_form\|abort if no form" .` (all files, excl. `node_modules`/`.git`/`dist`) | repo root |
| C5 | `grep -rn "from '@presentation" apps/api/src/usecase apps/api/src/service` | repo root |
| C6 | `grep -rhoE "(text\|bg\|border\|from\|to\|via)-\[#[0-9a-fA-F]{3,8}\]" apps/web/src --include="*.tsx"` | repo root |
| C7 | `git log -1 --format=… -- <path>` in the nested `.ai` repo | `.ai` |
| C8 | `ls -laR .cursor .codex .agent` | repo root |

---

## 1. Inventory

### 1a. Ours — `.ai/aidlc/agents/`

| Name | Location | Mirrored to | Purpose (from the file) | Last meaningful change |
| --- | --- | --- | --- | --- |
| **tcg-elaborator** | `.ai/aidlc/agents/tcg-elaborator.md` (443 lines) | **nothing** — see F1 | Turns a Jira intent into `spec.md` and **stops**; two write paths only (`spec.md`, `gaps.md`), never implements, never resolves a conflict (`tcg-elaborator.md:1-16`, `:32-42`) | `816806e` 2026-08-11 `feat(aidlc): add the elaborator and its four templates` |
| **tcg-scrum** | `.ai/aidlc/agents/tcg-scrum.md` (395 lines) | **nothing** — see F1 | Unblocks a developer on "how is this supposed to work" from written sources or escalates; writes only `gaps.md` and `decisions/` (`tcg-scrum.md:1-13`, `:26-33`) | `0f85a45` 2026-08-11 `feat(agents): add TCG Scrum unblocker agent` |

**F1 — the agents are mirrored nowhere. VERIFIED (C8).** `.ai/setup.sh:110-113` loops
`for surface in .cursor .agent .codex` and calls
`mirror_dir "$AI_DIR/aidlc/agents" "$surface/agents"`. On disk,
`.cursor/agents`, `.codex/agents` and `.agent/agents` all return
`No such file or directory`. Only `skills` (all three surfaces) and `rules`
(`.cursor` only, from `setup.sh:115`) exist.

**INFERRED** as to cause: the three `skills` symlink sets are dated `Aug 10 20:44` and
`.ai/aidlc/agents/` was created `Aug 11 03:01` (C8 timestamps), so the most economical
reading is that `setup.sh` has not been re-run since the agents were authored. The
alternative — `mirror_dir` failing silently — is not ruled out by this evidence.

**F2 — there is no `.claude/agents/` directory. VERIFIED.** `ls .ai/claude/agents` →
`No such file or directory`. `.claude` is a symlink to `.ai/claude` (`ls -l .claude`).
So the two agents above are the complete set of agent definition files in the repo.

### 1b. Pre-existing — `.ai/claude/skills/` (Relay-side)

All four are surfaced to Claude Code at `.claude/skills/<name>/SKILL.md` through the
`.claude → .ai/claude` symlink, and mirrored by symlink to `.cursor/skills/`,
`.codex/skills/`, `.agent/skills/` (**VERIFIED**, C8 — each mirror entry is a symlink back
to `../../.ai/claude/skills/<name>`).

| Name | Location | Mirrored to | Purpose (from the file) | Last meaningful change |
| --- | --- | --- | --- | --- |
| **commit** | `.ai/claude/skills/commit/SKILL.md` (37 lines) | `.cursor`, `.codex`, `.agent` | Conventional-commit authoring: read `git status`/`git diff --staged`, classify the change, write `<type>(<scope>): <desc>`; imperative lowercase, "Only commit when the user explicitly asks" (`:30-37`) | `219ea64` 2026-08-10 `Initial workspace configuration` |
| **debug-api** | `.ai/claude/skills/debug-api/SKILL.md` (45 lines) | same | NestJS failure triage: trace `Controller → Service → Repository → Prisma`, then a status-code decision table (401→`AccessTokenGuard`/`@Public()`, 403→`@Roles()`, 404→route, 500→Prisma/null) and `pnpm db:studio` (`:15-45`) | `219ea64` 2026-08-10 |
| **new-feature** | `.ai/claude/skills/new-feature/SKILL.md` (30 lines) | same | Three-layer scaffold checklist — `presentation/` + `usecase/` + `service/`, Prisma model + `pnpm db:migrate`, register in `app.module.ts`; then web `features/<feature>/`, then `packages/shared`; verify with `pnpm lint && pnpm build` (`:10-30`) | `219ea64` 2026-08-10 |
| **review-pr** | `.ai/claude/skills/review-pr/SKILL.md` (48 lines) | same | Six-heading review checklist — architecture/layering, naming, TypeScript, identity convention, web UI, quality — output is summary + issues with `file:line` + suggestions (`:8-48`) | `219ea64` 2026-08-10 |

**F3 — the skills have never been edited since import. VERIFIED (C7).** All four resolve to
the nested `.ai` repo's root commit `219ea64` (2026-08-10). `git log -- .claude/skills` in
the *platform* repo returns nothing, so they carry no history there either. The two agents
are the only artefacts in this layer authored after that root commit.

### 1c. Adjacent — not an agent definition, but describes agents

`.ai/claude/AGENTS.md` (335 lines) declares five prose "agents" under
*Phase 2: Parallel Agent Execution* (`AGENTS.md:59-131`) — Database, API, Web UI, Mobile,
Test. **VERIFIED** they exist only as prose: `AGENTS.md:62` reads
`**Agent 1: Database Agent** (reads @prisma.md)` followed by a fenced pseudo-spec. There is
no corresponding definition file anywhere (F2). **INFERRED:** an executor reading AGENTS.md
would have to synthesise these five roles itself; nothing in the repo constrains what they
actually do.

---

## 2. The eslint / reusability mechanism

### 2a. What exists

**VERIFIED.** Three configs, no root config, no `.eslintrc*` anywhere
(`find . -maxdepth 4 -name "eslint.config.*" -o -name ".eslintrc*"` → exactly
`apps/web/eslint.config.mjs`, `apps/api/eslint.config.mjs`, `apps/mobile/eslint.config.mjs`).

Every rule in those three files that touches imports or module boundaries:

| Config | Import/boundary rules present |
| --- | --- |
| `apps/web/eslint.config.mjs:107-110` | `import-x/no-absolute-path`, `import-x/no-self-import`, `import-x/export`, `import-x/no-mutable-exports` |
| `apps/web/eslint.config.mjs:73` | `no-duplicate-imports` (two `import` statements from the *same specifier in the same file*) |
| `apps/api/eslint.config.mjs:16-21` | **none** — the whole rules block is four `@typescript-eslint/*` entries |
| `apps/mobile/eslint.config.mjs:48` | `no-duplicate-imports` only |

**VERIFIED absent everywhere:** `import/no-restricted-paths`, any `boundaries/*` rule,
`no-restricted-imports`, and any custom rule or local plugin. Neither
`eslint-plugin-boundaries` nor `eslint-plugin-import` (only `import-x`) appears in any
config. There is no duplication detector (no `jscpd`, no `sonarjs`) in any
`package.json` (`grep -n '"lint\|jscpd' package.json apps/*/package.json`).

### 2b. The mechanism is (b) — UNENFORCED, not (a) blocked

**VERIFIED (C1).** ESLint run over all seven files that privately re-declare
`formatInternalId`:

```
✖ 8 problems (0 errors, 8 warnings)
```

All eight are `@typescript-eslint/no-explicit-any` (6× in `yards.service.ts`, 1× in
`agencies.service.ts`) and `@typescript-eslint/no-unused-vars` (1× in `assets.service.ts`).
Zero relate to duplication, reuse, or imports. Exit code 0.

**VERIFIED (C2).** ESLint over the whole of `apps/web/src`: **14 errors, 290 warnings.** The
complete error breakdown by rule is `no-magic-numbers` ×10, `complexity` ×2,
`max-lines-per-function` ×1, `max-lines` ×1. **No import, boundary, or restricted-path rule
fired once**, because none is configured.

**VERIFIED — (a) is ruled out affirmatively, not merely by absence.** Consolidating
`formatInternalId` into `apps/api/src/utility/` and importing it would be lint-clean, because
33 files under `apps/api/src/usecase/` already import from `@utility/*` today
(`grep -rln "from '@utility" apps/api/src/usecase | wc -l` → 33), e.g.
`apps/api/src/usecase/customers/customers.service.ts:11`,
`apps/api/src/usecase/vendors/vendors.service.ts:24`,
`apps/api/src/usecase/employee-certificates/employee-certificates.service.ts:5`. No rule
blocks the shared import; nothing rewards taking it.

**Conclusion: mechanism (b).** The reuse convention is unenforced. Devs are not copying code
to dodge a lint error — no lint error exists in either direction. The consolidated form and
the duplicated form are equally green.

### 2c. Instance 1 — `formatInternalId`

**VERIFIED (C3).** Seven private declarations, one per use-case service:

| File:line | Body |
| --- | --- |
| `apps/api/src/usecase/asset-management/assets/assets.service.ts:49` | `` `${prefix}-${String(nextValue).padStart(5, '0')}` `` |
| `apps/api/src/usecase/yards/yards.service.ts:38` | `` `${prefix}-${nextValue.toString().padStart(5, '0')}` `` |
| `apps/api/src/usecase/billing-codes/billing-codes.service.ts:27` | same as yards |
| `apps/api/src/usecase/billing-code-custom-types/billing-code-custom-types.service.ts:10` | same, but padded with `ID_PAD_LENGTH` (`:8`) |
| `apps/api/src/usecase/employee/employee.service.ts:48` | same as yards |
| `apps/api/src/usecase/agencies/agencies.service.ts:30` | same as yards |
| `apps/api/src/usecase/price-listings/price-listings.service.ts:45` | same as yards |

Call sites confirm all seven are live, not dead: `assets.service.ts:505,692`,
`yards.service.ts:155`, `billing-codes.service.ts:123`,
`billing-code-custom-types.service.ts:25`, `employee.service.ts:223,708`,
`agencies.service.ts:70,82`, `price-listings.service.ts:379`.

An eighth reference is documentary — `apps/api/src/utility/employee-code.util.ts:13` cites
`formatInternalId` in a JSDoc comment *from inside the shared utility directory*, without
importing it.

- **Would an eslint rule have caught it and didn't?** **VERIFIED: yes.** No configured rule
  targets cross-file duplication (§2a), and C1 confirms all seven files pass. A
  `no-restricted-syntax` guard on the literal, or a duplication detector, would have. Neither
  is present.
- **Did a rule prevent consolidating it?** **VERIFIED: no.** §2b — 33 sibling use-case files
  already import `@utility/*`.
- **INFERRED, worth recording:** the seven bodies are *textually* three variants
  (`String(x)` vs `x.toString()` vs a named pad constant) while being semantically identical.
  A naive token-level duplication check tuned tightly would likely miss at least the
  `assets` and `billing-code-custom-types` copies. This is a design constraint on any future
  rule, not a claim about the current one — there is no current one.

### 2d. Instance 2 — the `abortIfNoFormChanges` must-remember pattern

**VERIFIED (C4).** The identifier `abortIfNoFormChanges` **does not exist anywhere in the
repository** — case-insensitive grep across every file (excluding `node_modules`, `.git`,
`dist`), including all `.md`, returned zero hits. It is not defined, not imported, not
referenced in any rule doc, skill, or agent.

What exists instead is the *behaviour*, hand-rolled and inconsistent, with no shared name:

| Form | Site |
| --- | --- |
| `if (!isDirty) return;` | `apps/web/src/features/settings/views/profile-tab.tsx:232` |
| `if (!dirty) return;` | `apps/web/src/features/permits/components/permit-inline-rich-text-card.tsx:41` |
| `toast('No changes to save')` | `apps/web/src/features/price-listings/views/save-price-list-items.ts:119` |
| `disabled={!isDirty \|\| isSubmitting}` | `apps/web/src/features/customers/workspace/detail/customer-pre-quote-data-tab.tsx:246` |

Dirty-state computation itself is duplicated across ~18 page files, in at least four
distinct idioms — a shared hook (`usePermitFormDirty` at
`apps/web/src/app/(protected)/permits/create/page.tsx:50`), a composed helper
(`combineFormDirty(...)` at
`apps/web/src/app/(protected)/permits/[permitId]/edit/page.tsx:65`), a raw
`JSON.stringify` comparison
(`apps/web/src/app/(protected)/asset-management/parts/[partNumber]/edit/page.tsx:71` and
`.../parts/manufacturers/[manufacturerCode]/edit/page.tsx:70`), and a hardcoded
`isDirty: true` (`apps/web/src/app/(protected)/projects/[id]/plans/create/page.tsx:238`).

- **Would an eslint rule have caught it and didn't?** **INFERRED: no, and this is the harder
  case.** Unlike `formatInternalId` there is no shared symbol to point a rule at — the
  pattern has no canonical implementation, so a rule would have to assert a *positive*
  ("every submit handler must call X") rather than forbid a duplicate. No such rule exists,
  and the target it would name does not exist either.
- **Did a rule prevent consolidating it?** **VERIFIED: no.** No import or boundary rule is
  configured for `apps/web` beyond the four `import-x` hygiene rules (§2a), and C2 shows zero
  such errors across `src/`.
- **VERIFIED consequence for the tag "must-remember":** a pattern that lives only in memory,
  with no symbol, no rule and no mention in any `.md`, has exactly one enforcement mechanism
  — someone remembering. C4 establishes there is no second one.

### 2e. Adjacent rails findings (all VERIFIED)

- `packages/shared/package.json:20` — `"lint": "echo \"no lint configured yet\""`. Since
  root `package.json:32` defines `lint:local` as
  `pnpm --filter @tcg/shared lint && pnpm --filter @tcg/api lint`, **`lint:local` effectively
  lints `apps/api` only** — web and mobile are outside it.
- `apps/web` lint is currently **red**: 14 errors (C2), in
  `src/features/permits/components/print/permit-print-model.ts` (8),
  `.../print/permit-print-document.tsx` (4),
  `src/features/permits/components/permits-listing.tsx:73` (1) and
  `.../print/permit-print-document.tsx:301` (1). So `pnpm lint` at the root fails today.
- `.husky/pre-commit` is `npx lint-staged` + `pnpm build` (2 lines). `lint-staged`
  (`package.json:51-60`) runs `eslint --fix` per app on staged files only — so the 14 web
  errors above are not blocking unless those exact files are staged.
- `.ai/claude/settings.json:44-51` carries a `"codeStyle"` block declaring
  `"linter": "eslint"`, `"strict": true`, `"noAny": true`. **VERIFIED it enforces nothing
  in eslint**: `@typescript-eslint/no-explicit-any` is `'warn'` in all three configs
  (`apps/web/…:38`, `apps/api/…:19`, `apps/mobile/…:27`), and C1/C2 show `any` producing
  warnings, never errors. **INFERRED:** `codeStyle` is not a key the harness acts on; it
  reads as a declaration of intent parked next to the permissions block.

---

## 3. The `.md` drift

### 3a. Which `.md` is the source of truth

**There are three, and they overlap and disagree.** Naming them precisely matters because
the drift is partly *between them*, not only between doc and code.

| Candidate | Claim to authority | Loaded how |
| --- | --- | --- |
| `.ai/claude/rules/design-system.md` (522 lines) | Owns the convention: `## Component Reusability (MANDATORY)` at `:60`, checklist at `:92-100`, `## Workspace Page Patterns (MANDATORY)` at `:235`. `.ai/claude/CLAUDE.md:181` names it *"Centralized theming, component reusability"* | Referenced by `@`-path from `CLAUDE.md:181`; mirrored to `.cursor/rules/design-system.md` (symlink) |
| `.ai/claude/CLAUDE.md` (186 lines) | Restates it as *Web UI Rules* `:135-155`, rule 1 `**Component Reusability (CRITICAL)**` at `:135` | Root `CLAUDE.md` symlink → `.claude/CLAUDE.md` → `.ai/claude/CLAUDE.md` |
| `.ai/claude/AGENTS.md` (335 lines) | Restates the same conventions "for other AI coding agents" (`AGENTS.md:3`), incl. `## Critical: Web List Tables (CommonTable)` at `:292` | Root `AGENTS.md` symlink |

**Verdict: `design-system.md` governs.** It is the only one of the three that states the
convention with a decision procedure (`:92-100` checklist; `:100` *"If 70%+ similar component
exists, extend it. Don't create duplicate."*; `:341-345` the same threshold for shared
variants). `CLAUDE.md:135` and `AGENTS.md` are summaries that point back at it
(`CLAUDE.md:155` ends *"See @.claude/rules/design-system.md → 'Workspace Page Patterns'"`).

**F4 — the summaries have drifted from the governing file, and from themselves.
VERIFIED.** `CLAUDE.md` rule 9 (`:151`) mandates `CommonTable`; `CLAUDE.md` rule 13 (`:155`)
mandates `WorkspaceTable`. Both are marked `(MANDATORY)`, four lines apart, for the same
concern. `web.md:9-49` is entirely `CommonTable`. `design-system.md:235-340` is
`WorkspaceTable`, while `design-system.md:505-511` reverts to a `## List tables
(`CommonTable`)` section. **VERIFIED they are two distinct components**, not an alias:
`apps/web/src/components/templates/common-table.tsx` and
`apps/web/src/components/templates/workspace-table.tsx` are separate files, and
`workspace-table.tsx` imports only `./common-table-empty-message` (`:17`) and
`./common-table-controls` (via `workspace-table.footer.tsx:5`,
`workspace-table.toolbar.tsx:7`) — shared leaf helpers, not the `CommonTable` component.

### 3b. The three-way table

| What the `.md` MANDATES | What eslint ENFORCES | What the code ACTUALLY does |
| --- | --- | --- |
| `design-system.md:60,92-100` — *"Component Reusability (MANDATORY) … Before creating a new component, check: Does similar component exist…"*, `:100` *"If 70%+ similar component exists, extend it. Don't create duplicate."* | **Nothing.** No duplication rule, no boundary rule in any of the three configs (§2a). **VERIFIED** | 7 private `formatInternalId` copies (§2c) pass lint clean — **VERIFIED (C1, 0 errors)** |
| `design-system.md:104-105` — *"Do not create per-form validation summary widgets. Reuse `FormErrorSummary` from `apps/web/src/components/organisms/form-error-summary.tsx` for all forms."* | **Nothing.** **VERIFIED** | `apps/web/src/components/organisms/form-error-summary.tsx` exists (4,928 bytes) and has **zero consumers** — `grep -rln "FormErrorSummary" apps/web/src` returns only the file that defines it. **VERIFIED**. Directly contradicted by `CLAUDE.md:127` *"Do not render top-of-form validation summary boxes"* and `AGENTS.md:285` *"Do not use top-of-form validation summary boxes."* The code follows `CLAUDE.md`, not the governing file |
| `design-system.md:84-90` — *"Import Rule: NEVER import from higher levels: … Molecules: Import atoms only; Organisms: Import atoms + molecules only"* | **Nothing.** **VERIFIED (C2 — zero import/boundary errors across all of `apps/web/src`)** | 11 files in `components/organisms/` and 2 in `components/molecules/` import `@/features/*` — e.g. `apps/web/src/components/molecules/categorized-attachment-card.tsx:9-14` (six imports from `@/features/attachments/`), `apps/web/src/components/molecules/address-fields.tsx:20-22`. **VERIFIED**. Atoms are clean (0 upward imports) |
| `rules/api.md:17` — *"Dependency Rule: Never import upward. Repository cannot import Controller."* (restated `CLAUDE.md:57`) | **Nothing.** `apps/api/eslint.config.mjs:16-21` configures four `@typescript-eslint` rules and no import rule at all. **VERIFIED** | 142 upward import lines from `@presentation` into `usecase`/`service` (C5) — 38 `*.service.ts` and 56 `*.module.ts` files under `usecase/`, plus repositories: `apps/api/src/service/job-site/job-site.repository.interface.ts:2`, `apps/api/src/service/industries/industries.repository.ts:6`, `apps/api/src/service/billing-code-types/billing-code-types.repository.ts:4`. Also 5 files under `src/service/` importing `@usecase`. **VERIFIED**, all lint-clean |
| `design-system.md:14` — *"CRITICAL: All colors MUST use CSS variables from `apps/web/src/styles/theme.css`"* (restated `CLAUDE.md:136` *"NO hardcoded colors"*) | **Nothing.** **VERIFIED (C2)** | **593** hardcoded hex utility classes across **113** `.tsx` files under `apps/web/src` (C6) |
| `CLAUDE.md:151` (rule 9) — desktop tables use **`CommonTable`** | **Nothing** | 13 files reference `CommonTable`. **VERIFIED** |
| `CLAUDE.md:155` (rule 13) + `design-system.md:235-340` — pages use **`WorkspaceTable`**, `PageHero`, and *"Do not hand-roll … `FormLayout`/`PageHeader` headers"* | **Nothing** | 73 files reference `WorkspaceTable`, 70 reference `PageHero`, 1 `PageHeader`, 2 `FormLayout`. **VERIFIED.** This is the one convention the code overwhelmingly follows — and it is the one where the docs contradict each other most sharply |

**F5 — the rule that is followed is followed despite the docs, not because of them.
INFERRED.** `WorkspaceTable`/`PageHero` adoption (73/70 files) far exceeds every other
convention audited here, while `CommonTable` — mandated with equal force by `CLAUDE.md:151`,
all of `web.md:9-49`, `design-system.md:505` and `AGENTS.md:292` — sits at 13. The
distinguishing feature is that `WorkspaceTable` was, per `design-system.md:237-241`,
*"rolled out across the app"* as a migration. That is a code-side event, not a doc-side one.
The docs record both states simultaneously and cannot discriminate between them.

**F6 — the layering rule is self-contradicting as written. VERIFIED.** `api.md:17` forbids
upward imports; `api.md:86-95` then prints the canonical NestJS module with
`controllers: [UsersController]`, which requires the `usecase` module to import from
`presentation`. 56 of the 142 upward imports are exactly this sanctioned form. A rule that
forbids what its own example requires cannot be mechanised without first being split — worth
recording before anyone tries to write the eslint rule.

---

## 4. Intactness verdicts

Cross-checked against: **Branch B** (rules may not load ambiently — the reliance is unproven
until PRE-FLIGHT 0 runs, per `context-restructure-plan.md:14-52`), the **rails gap** (§2),
and the **`.md` drift** (§3).

**Branch B, stated once so it is not restated per-row. VERIFIED:**
`grep -rn "rules/\|CLAUDE\.md\|\.ai/" .ai/claude/skills/*/SKILL.md` returns **zero hits
across all four skills.** Not one of them reads, cites, or names any rule file by path. Every
convention they invoke is inherited from ambient context or from the model's own priors.
**INFERRED:** if Branch B holds, all four skills degrade to the model's priors about NestJS
and React, with no signal that anything was lost.

**A note on what I did not do.** I did not test whether the `@`-imports in `CLAUDE.md:176-186`
expanded in this session, and I make no claim either way.
`context-restructure-plan.md:48-52` explicitly forbids resolving this by model self-report —
*"Self-report on the contents of one's own context is exactly the class of question a model
answers confidently and wrongly"* — and that instruction binds this analysis as much as any
other. What I can offer is one adjacent **VERIFIED** fact that narrows the question:
`ls -lL .claude/rules/api.md` resolves to a real 2,259-byte file, so the symlink chain is not
broken at the filesystem level. Whether the harness expands the reference is untouched by
that, and remains PRE-FLIGHT 0's to settle.

### commit — **intact**

Purely mechanical: `git status`, `git diff --staged`, a type taxonomy (`:20-28`), formatting
rules (`:32-35`). Asserts no codebase convention, so the rails gap cannot touch it, and it
needs no rule file, so Branch B cannot touch it either.

One **VERIFIED** omission, not drift: `.husky/pre-commit` runs `pnpm build` on every commit
(line 2), and the skill's closing instruction — *"Run `git add` for unstaged files if needed,
then commit"* (`:37`) — does not mention it. **INFERRED:** a commit through this skill will
run a full monorepo build, and a failure surfaces as an opaque commit failure rather than as
something the skill anticipated.

### debug-api — **intact**

The status-code table (`:22-26`) and the guard/decorator names (`AccessTokenGuard`,
`@Public()`, `@Roles()`, `RolesGuard`) match `CLAUDE.md:115-118` and `api.md:66-70`.
**VERIFIED** that its `console.log('Debug:', { variable })` advice (`:39-41`) is lint-safe on
its target surface: `grep -n "no-console" apps/api/eslint.config.mjs` returns nothing, so the
API has no `no-console` rule. (`apps/web/eslint.config.mjs:66` sets `no-console: ['error', …]`
— but this skill is scoped to the API and never touches web.)

Rails: it prescribes diagnostics, not conventions, so §2/§3 do not apply. Branch B: it
reproduces enough of `api.md` inline to function without it.

### new-feature — **drifted**

The scaffold steps (`:10-24`) match `CLAUDE.md:158-166` and `api.md:10-15` accurately. Two
problems, both about its verification step and its closing line:

1. **VERIFIED.** `:27` instructs *"Run `pnpm lint` and `pnpm build`"*. Root `pnpm lint` is
   `pnpm -r lint` (`package.json:33`), which currently **fails** — 14 errors in `apps/web`
   (C2), all pre-existing and all in `src/features/permits/components/print/*` plus
   `permits-listing.tsx:73`. The gate is red before any new feature is written, so a
   developer following the skill sees failures they did not cause. The narrower
   `lint:local` (`package.json:32`) does not help either: `packages/shared/package.json:20`
   is `echo "no lint configured yet"`, so `lint:local` covers `apps/api` alone.
2. **INFERRED.** `:30` — *"Always follow existing patterns in the codebase"* — is the rails
   gap stated as an instruction. Per §2c, the existing pattern for minting a business code is
   seven private copies of `formatInternalId`; per §3b, the existing pattern for a list table
   is two mutually-exclusive components both marked MANDATORY. Told to follow existing
   patterns and given nothing that discriminates between them, the skill propagates whichever
   the model happens to read first.

### review-pr — **assumes-a-thing-that-isn't-true**

This is the sharpest case, and it fails on the exact axis the brief names.

**VERIFIED — the skill has no gate/inference separation, structurally.** The full text is 48
lines. It contains **no instruction to run any command** — no `pnpm lint`, no `tsc`, no
`git diff`, nothing. Its Output section (`:41-48`) asks for three things: *"Summary of
changes"*, *"Issues found (with file:line references)"*, *"Suggestions for improvement"*.
There is no field for what was executed, no field for confidence, and no vocabulary
separating a checked claim from a read one. Every finding it produces necessarily arrives in
the same voice.

**VERIFIED — four of its six checklist headings ask questions nothing in the repo can
answer.** Each is a convention established in §2/§3 to be unenforced:

| Checklist item | Status |
| --- | --- |
| `:13` *"No upward imports?"* | 142 violations exist and lint is silent (§3b row 4) |
| `:33` *"Existing components reused"* | 7 `formatInternalId` copies, lint silent (§2c) |
| `:38` *"No hardcoded values"* | 593 hex literals, lint silent (§3b row 5) |
| `:34` *"CommonTable search/filter conventions"* | Names `CommonTable` (13 files) as the convention, where `CLAUDE.md:155`/`design-system.md:235` mandate `WorkspaceTable` (73 files). **The skill encodes one side of an unresolved doc conflict as settled** (§3a F4) |

**INFERRED — the failure mode this produces.** The `file:line` format required at `:46` is
the same format a real gate emits. A reviewer receiving *"upward import at
`foo.service.ts:17`"* cannot tell whether a tool found it or the model read it off the diff,
because the skill provides no way to mark the difference and no tool that would have found
it. The one checklist item that *is* mechanically checkable — `:23` *"No `any` types"* — is
**VERIFIED** to be a warning, not an error, in all three configs
(`apps/api/eslint.config.mjs:19`, `apps/web/eslint.config.mjs:38`,
`apps/mobile/eslint.config.mjs:27`), so even that one would pass a lint gate the skill never
runs.

**On the SCRUM-855-857 review specifically — NOT VERIFIED, and I could not make it so.**
`grep -rln "SCRUM-855\|SCRUM-857"` across the repo (excluding `node_modules`/`.git`) returns
only `.ai/aidlc/agents/tcg-scrum.md` and `.ai/aidlc/agents/tcg-elaborator.md`, where they
appear as citation-format examples (`tcg-scrum.md:77`, `tcg-elaborator.md:170`). The review
transcript is not in the repository, and `git log --all` shows no related branch. So I can
confirm the *mechanism* by which real gate output and an unreachable-state assertion would
appear side by side in one undifferentiated list — that is the structural finding above — but
I cannot confirm the specific observation. It is reported to me and consistent with the
skill's structure; it is not independently established here.

### tcg-elaborator — **intact, with one inherited defect**

**Branch B: intact, and immune by construction. VERIFIED.** Unlike all four skills, it reads
rules by path: `tcg-elaborator.md:124` makes *"The rules that bind the touched surfaces"*
step 3 of a mandatory retrieval order, and `:254-260` is an explicit surface→file table
naming `.ai/claude/rules/api.md`, `prisma.md`, `web.md`, `design-system.md`, `mobile.md`. It
never relies on ambient load. This matches `context-restructure-plan.md:59-62` exactly.

**Rails gap: intact, and it anticipates it.** `:262-264` — *"A rule can make a requirement
unnecessary … A rule can never make a requirement true"* — is the correct discipline, and
`:148-155` (*"The repo is not a source of intent … Half the patterns in a codebase are the
first implementation that worked"*) describes §2c's seven copies precisely without having
been written about them.

**The inherited defect. INFERRED.** `:258` instructs the spec to respect, for `apps/web`,
both *"`.ai/claude/rules/web.md`, `.ai/claude/rules/design-system.md`"* **and**
*"`CLAUDE.md` → Web UI Rules"* — the three documents shown in §3b to contradict each other on
tables and on `FormErrorSummary`. The agent's own §5 (`:221-247`) would require it to mark a
*vault* conflict `[CONFLICT]`, name every candidate and refuse to merge. **Its conflict
machinery is scoped to product sources and does not extend to the rules layer**: §5 keys off
`conflicts_with:` frontmatter and the five `product/*-INDEX.md` stubs (`:224`), and the rules
files have neither — their frontmatter is a `paths:` glob list only
(**VERIFIED**: `api.md:1-4`, `web.md:1-5`, `design-system.md:1-6`, `prisma.md:1-5`,
`mobile.md:1-4`). So a rules-layer contradiction reaches the spec as an unflagged binding
constraint, through the one part of the agent that has no conflict handling.

**Staleness. VERIFIED.** `:145` states *"Eight entries in `gaps.md` are open."*
`.ai/vault/gaps.md` currently has **12** `##` entries, all `Status: open`
(`grep -c "^## " .ai/vault/gaps.md` → 12; every `Status:` line reads `open`). Also
**VERIFIED (F1)**: this agent is mirrored to no surface, so it is reachable from Claude Code
only, not from Cursor or Codex.

### tcg-scrum — **intact**

**Branch B: not applicable, and correctly so.** It answers product questions from
`.ai/vault/`; its retrieval order (`:41-50`) is INDEX → conflict stub → file, all by explicit
path. It never invokes a code convention, so §2 and §3 cannot reach it.

**Rails gap: intact, and it is the only artefact in this layer that gets the VERIFIED/
INFERRED discipline right.** `:84-96` requires a status tag on every answer, `:97-123`
forbids picking a conflict winner, `:160-197` requires *"There is no written answer to
this"* as a first line rather than a plausible fallback. §7 of the brief's own method is this
agent's §3 and §4.

**Staleness. VERIFIED.** `:61` states *"Seven gaps are open"* and `:132` refers to *"the
seventh `gaps.md` entry"*; the actual count is 12 (above). `:60` states *"The vault is 154
files"* and `:60-61` *"145 of the 151 content files are `status: unverified`"* — I did not
re-count these two and make no claim about them. **VERIFIED (F1):** mirrored to no surface.

---

## 5. Noticed, deliberately not chased

Recorded so they are on the record, not fixed and not investigated further.

1. **PRE-FLIGHT 0 itself.** Whether `@`-imports in `CLAUDE.md:176-186` expand at session
   start. `context-restructure-plan.md:42-52` requires an externally-observed answer and
   explicitly forbids model self-report; this analysis honoured that and left the question
   open. Everything in §4 tagged Branch B stays provisional until it runs.
2. **The five prose agents in `AGENTS.md:59-131`.** Not compared against the two real agent
   definitions, and not assessed for whether their described division of labour matches
   anything executable.
3. **`.cursor/rules/*.md` file extension.** The five rules are symlinked as `.md`
   (`setup.sh:115`). Whether Cursor reads `.md` in `.cursor/rules/`, and whether the
   `paths:` frontmatter (`api.md:1-4`) is a key Cursor honours, was not tested — the mirror
   may be inert. `setup.sh:114`'s comment *"(audit: rules currently reach Claude only)"* is
   flagged in `context-restructure-plan.md:127-130` as owed an edit after PRE-FLIGHT 0;
   untouched here.
4. **Whether the 142 upward API imports are type-only.** Several use `import type`
   (`plan-requests.service.ts:6`, `permit-requests.service.ts:6`,
   `employee-certificates.service.ts:4`), which erases at compile time and is arguably not a
   runtime dependency. I did not split the 142 into type-only vs value imports; the count is
   reported whole and the distinction would matter to anyone writing the rule.
5. **`no-magic-numbers` as the dominant error rule.** 10 of the 14 web errors (C2). Whether
   the ignore list at `apps/web/eslint.config.mjs:83` is calibrated, or whether this rule is
   generating friction disproportionate to its value, was not assessed.
6. **The mobile surface.** `apps/mobile/eslint.config.mjs` has no import rules and no
   `max-lines`, and `rules/mobile.md` (102 lines) was read only for its frontmatter. No
   mobile-side reuse audit was performed; §2 and §3 findings are API- and web-only.
7. **`apps/api/dist/` is checked into the working tree** — `formatInternalId` appears in
   `apps/api/dist/utility/employee-code.util.d.ts:10` (C3). Whether build output should be
   present at all was not pursued; it was excluded from every count above.
8. **The `PRLT` / `PRCL` identity discrepancy** noted at
   `context-restructure-plan.md:96` (row 1). It sits in the same doc-drift family as §3 and
   I did not re-verify or extend it.
9. **`.ai/claude/SETUP-SUMMARY.md`, `DESIGN.md`, `AUTOMATED-FEATURES.md`,
   `QUICK-REFERENCE.md`, `DESIGN-FOLDER-UPDATE.md`** — five further always-referenced `.md`
   files (`CLAUDE.md:176-186`) not audited for drift. §3 covers only the three that carry the
   reusability convention.
