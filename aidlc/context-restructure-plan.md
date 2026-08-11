# Context-layer restructure — executable plan

Status: **for review, not applied.** Nothing in here has been executed.

Mechanism is settled and not relitigated here: Claude Code follows a symlinked nested
`CLAUDE.md` (ALPHA/BRAVO probe, 2026-08-11), and `setup.sh` already does every mechanical
step this plan needs — `safe_link` (`setup.sh:34`), `prefix_for` (`setup.sh:49`),
`mirror_dir` (`setup.sh:56`), exclude management (`setup.sh:117-123`). Every move below
cites the function that already performs it. Exactly one genuinely new script capability is
required, and it is flagged as such in §5.

---

## PRE-FLIGHT 0 — the number everything else rests on

**Question:** does Claude Code expand `@`-imports in `CLAUDE.md` at session start, through
the `/CLAUDE.md → .claude/CLAUDE.md → .ai/claude/CLAUDE.md` symlink chain?

`CLAUDE.md:176-186` references nine files with `@`-prefixed paths. If those expand, the
always-on layer is **2,893 lines**. If they silently fail to resolve, it is **186**.

| | Lines |
| --- | --- |
| `claude/CLAUDE.md` | 186 |
| `claude/rules/api.md` | 96 |
| `claude/rules/web.md` | 49 |
| `claude/rules/prisma.md` | 120 |
| `claude/rules/design-system.md` | 522 |
| `claude/DESIGN.md` | 447 |
| `claude/AGENTS.md` | 335 |
| `claude/AUTOMATED-FEATURES.md` | 528 |
| `claude/QUICK-REFERENCE.md` | 194 |
| `claude/design/README.md` | 416 |
| **Total if imports expand** | **2,893** |

**Observation, not proof:** in the session that produced this plan, the initial context
contained the root `CLAUDE.md` body verbatim — including the literal `@.claude/rules/api.md`
lines — and did **not** contain any rules content. Every rules file had to be read
explicitly. That is consistent with imports not expanding, but the harness may present
imports differently, so it is not conclusive.

**Check — observe the injected context, do not ask the model.** Start a fresh session in
the repo and inspect what is actually injected before any file is read, the same way the
ALPHA/BRAVO probes were confirmed: the injected bodies are visible as context blocks, so
read them. Look for `standardizeDesktopColumns` (unique to `rules/web.md:48`) and
`FormErrorSummary` (unique to `rules/design-system.md:104`).

**Do not ask Claude whether those strings are in its context.** Self-report on the contents
of one's own context is exactly the class of question a model answers confidently and
wrongly, and this is the single fact the plan's entire framing hangs on. ALPHA/BRAVO were
trustworthy because the probes were *observed as injected reminders*, not because anything
introspected. Use the same standard here.

**Branch A — imports expand.** Baseline 2,893. This plan's savings are as stated below.

**Branch B — imports do not expand.** Baseline 186. State the consequence precisely,
because the loose version is wrong and will be pushed back on:

- **Agents are unaffected.** `tcg-scrum` and `tcg-elaborator` read their rules by path
  (`tcg-elaborator.md` §2 step 3, §6's surface-to-rules table). They never relied on ambient
  load, so they have been getting the rules all along. Anyone objecting that "the elaborator
  clearly used them" is right, and it is not evidence against Branch B.
- **What breaks is the ad-hoc human session.** A developer opening the repo gets no rules
  unless they happen to know which file to open. That is a real latent bug affecting eight
  people, and it has been invisible precisely because the agent path masked it.
- So Branch B is simultaneously a live defect *and* an argument for the agent-driven path:
  the agents were structurally insulated from a failure the humans were exposed to.

Under either branch the restructure goes ahead — nested-by-symlink makes loading
deterministic rather than accidental. But the two branches are not two descriptions of one
piece of work. **They are two different pieces of work.**

- **Branch A: a token-and-attention optimization.** Real, inherited by every future agent
  and dev session, and not urgent. A 98% cut to ambient context sharpens attention. That is
  the whole story.
- **Branch B: the fix for the problem this methodology exists to solve.** The stated goal is
  consistency across eight developers on four surfaces. If the rules are not ambiently
  loading, then consistency today is whatever each developer remembers to open — the
  pre-AI-DLC world with extra files in it. This stops being an optimization and becomes the
  moment the rules start reaching the people the methodology is for. The agents never felt
  it because they read by path, which is exactly why nobody noticed.

**This is the real reason to run PRE-FLIGHT 0 first — ahead of the commit message, ahead of
everything.** Until it comes back you do not know which of these two plans you are holding,
and they carry different urgencies.

### Circumstantial findings — NON-DISCRIMINATING. Do not read these as evidence for B.

A session spent reading this layer surfaced five divergences without looking for them. They
are real, and they are recorded below because they matter. **They are not evidence about
whether the rules load**, and an earlier draft of this plan wrongly presented them as
"leaning B." That inference does not survive contact:

| # | Divergence | What it actually discriminates |
| --- | --- | --- |
| 1 | `CLAUDE.md` Identity table documents `PRLT-00001`; code **and** seed uniformly use `PRCL` | **Leans against B.** Non-loading produces *inconsistent code*. This is uniform code with one stale doc above it — a rule that was set, followed consistently, and then documented wrong. That is doc drift, the opposite direction from B. |
| 2 | Seed writes `VEN-0001`; `vendors.service.ts:73-74` mints `VEND-#####` | Over-determined |
| 3 | Seed writes 4-digit codes (`CUST-0001`, `EMP-1001`); services mint 5 via `padStart(5)` | Over-determined |
| 4 | `formatInternalId` re-declared privately in ~7 use-case files | Over-determined |
| 5 | `FormErrorSummary` required by one always-loaded file, banned by the other (D3) | **Orthogonal.** Two rules contradicting each other exist whether or not either loads. |

**Why "over-determined" kills the inference.** The known rails gap — non-mechanical rules,
the decorative `codeStyle` key in `claude/settings.json`, the hardcoded hex values across
the web app — predicts a world where a rule *loads and nothing enforces it*. That produces
violations exactly where the rule applies, which is the same signature as a rule that never
loaded. Both causes were already suspected and they share a fingerprint, so the fingerprint
cannot tell them apart. Rows 2-4 are consistent with either.

**And the sample selects for the conclusion.** These five surfaced during an audit *of the
rules layer* and a reconstruction *of the identity area*. "Concentrated where the rule
applies" is partly a map of where someone was looking.

Net: of five findings, **zero support B, one leans against it, three are non-discriminating,
one is orthogonal.** Branch B is a live hypothesis, not a prior.

### Enter PRE-FLIGHT 0 blind

This matters for one practical reason. If the check is run *expecting* B, an ambiguous
context dump is easy to read as confirmation, and ambiguity is the likely outcome rather
than the unlikely one.

The discipline is already written down elsewhere in this repo and applies to its authors as
much as to its agents: assume unverified until observed, and keep VERIFIED apart from
UNVERIFIED. Read the injected context and let it hand over the answer. Do not go in with a
result to confirm.

**One edit is owed to whichever answer comes back:** `setup.sh:113` currently asserts
*"(audit: rules currently reach Claude only)"* in a comment. That claim is exactly what this
check tests. Leave it alone until the check runs — rewriting it now would be writing the
answer before the observation — then correct it to whatever was actually observed.

If it returns B, **then** the five findings become the first measurement of the cost, and
*"how long has this been running, and what else is out there we did not happen to look at"*
becomes the right next question. That is a conclusion for the check to produce — not a prior
to bring to it.

The five findings stay on the record regardless: they are the strongest available evidence
for the **rails** gap, which is a separate layer and a separate piece of work.

Everything below is written to be correct under both branches. Only the savings column
changes.

---

## 1. PER-RULE DISPOSITION

### 1a. Root `CLAUDE.md` — block by block

Source: `.ai/claude/CLAUDE.md` (186 lines).

| Lines | Block | n | Disposition | Destination / trigger |
| --- | --- | --- | --- | --- |
| 1-4 | Title + intro | 4 | **always-loaded** | — |
| 5-13 | Stack | 9 | **always-loaded** | orients every other decision; cheapest high-value block in the file |
| 14-25 | Commands | 12 | **always-loaded** | used in most sessions regardless of surface |
| 26-42 | Automated Feature Implementation | 17 | **pointer-only** → 2 lines | body already lives in `claude/design/README.md`; see §2 row D5 |
| 43-60 | Architecture | 18 | **split** — keep 6 | API layer list → `contexts/api.md`; atomic list → `contexts/web.md`; root keeps the two one-line invariants ("never import upward") |
| 61-71 | Naming Conventions | 11 | **always-loaded, trimmed to 8** | drop the 2 DB rows (duplicated in `prisma.md:24-33`); see §2 row D6 |
| 72-101 | Identity Convention | 30 | **location-triggered**, root keeps 3 | `contexts/prisma.md` ← trigger `apps/api/prisma/CLAUDE.md`; see §2 row D1 |
| 102-107 | Import Aliases | 6 | **always-loaded** | cross-surface, tiny |
| 108-114 | Auth System | 7 | **location-triggered** | `contexts/api.md` ← trigger `apps/api/CLAUDE.md` |
| 115-122 | Frontend Patterns | 8 | **location-triggered** | `contexts/web.md` ← trigger `apps/web/CLAUDE.md` |
| 123-132 | Form Validation UX Standard | 10 | **location-triggered** | `contexts/web.md`; **resolve the contradiction in §2 row D3 first** |
| 133-156 | Web UI Rules | 24 | **location-triggered** | `contexts/web.md`; see §2 rows D2/D4 |
| 157-167 | Feature Checklist | 11 | **location-triggered** | `contexts/api.md` |
| 168-175 | Code Quality | 8 | **always-loaded** | cross-cutting, applies to every file in the repo |
| 176-186 | Links | 11 | **replaced** — keep 4 | becomes a pointer index with no `@` prefixes; see §5 |

**Root after: 62 lines** (4 + 9 + 12 + 2 + 6 + 8 + 3 + 6 + 8 + 4).
**Removed from always-on: 124 lines.**

### 1b. The `@`-imported files

| Source | n | Disposition | Destination | Trigger path (symlink) |
| --- | --- | --- | --- | --- |
| `claude/rules/api.md` | 96 | location-triggered | `claude/contexts/api.md` | `apps/api/CLAUDE.md` |
| `claude/rules/prisma.md` | 120 | location-triggered | `claude/contexts/prisma.md` | `apps/api/prisma/CLAUDE.md` |
| `claude/rules/web.md` | 49 | location-triggered (merged) | `claude/contexts/web.md` | `apps/web/CLAUDE.md` |
| `claude/rules/design-system.md` | 522 | **split** — see below | `claude/contexts/design-tokens.md` (166) | `apps/web/CLAUDE.md` (merged into `contexts/web.md`) |
| ” | ” | location-triggered, **deeper** | `claude/contexts/design-patterns.md` (356) | `apps/web/src/components/CLAUDE.md` |
| `claude/rules/mobile.md` | 102 | location-triggered | `claude/contexts/mobile.md` | `apps/mobile/CLAUDE.md` |
| `claude/DESIGN.md` | 447 | pointer-only | stays put | — |
| `claude/AGENTS.md` | 335 | pointer-only | stays put | — |
| `claude/AUTOMATED-FEATURES.md` | 528 | pointer-only | stays put | — |
| `claude/QUICK-REFERENCE.md` | 194 | pointer-only | stays put | — |
| `claude/design/README.md` | 416 | location-triggered | stays put | `.ai/claude/design/CLAUDE.md` → `README.md` |

Two notes on this table.

**`rules/mobile.md` is currently orphaned.** It is referenced from no `@`-import and from
no `Links` row — `grep -rn "@\.claude/" claude/` returns api, web, prisma and design-system
only. Under Branch A it has never loaded; under Branch B nothing has. Either way this is a
**correctness fix worth 0 tokens**: mobile rules start reaching mobile work for the first
time.

**`design-system.md` splits in two, and the split is decided rather than inherited.**
Triggering all 522 lines at `apps/web/` would load CVA variants and workspace-component
rules for route and config work that cannot use them. But triggering *all* of it at
`apps/web/src/components/` starves page-level work of the token rules it genuinely needs.
Measured on the tree as it stands: `apps/web/src/app/` holds **148** `layout.tsx`/`page.tsx`
files, of which **24** use responsive breakpoints and **12** reference CSS theme variables
directly — and `globals.css` lives there too. Page-level work needs tokens.

So:

| Fragment | Sections | Lines | Trigger |
| --- | --- | --- | --- |
| `contexts/design-tokens.md` | Centralized Theming (10-59), Responsive Design (163-234), Spacing (389-400), Typography (401-415), Gradients (416-432) | ~166 | `apps/web/` — merged into `contexts/web.md` |
| `contexts/design-patterns.md` | Component Reusability (60-162), Workspace Page Patterns (235-346), Design from Images (347-388), Status/Badge (433-445), Component Docs (446-460), Accessibility (461-481), CSS Best Practices (482-497), Performance (498-504), List tables (505-512), Tokens Export (513-522) | ~356 | `apps/web/src/components/` |

The trade is deliberate: page-level sessions now pay ~166 lines they did not pay under the
single-deep-trigger version, to prevent the failure that costs most — hardcoded colors,
which `CLAUDE.md` marks MANDATORY-not-to-do and which review catches late and expensively.
Component sessions load both fragments and are within ~20 lines of the unsplit figure. The
always-on total is unaffected either way.

This is also the one place the plan buys real progressive disclosure rather than relocation.

Related: its frontmatter claims `paths: ['apps/mobile/**/*.tsx']` (`design-system.md:5`),
but its body is Tailwind, CVA, `theme.css` and shadcn — none of which mobile uses, since
`rules/mobile.md:97-101` mandates `StyleSheet.create` and `theme/tokens.ts`. **That path
entry is wrong and should be dropped**, not carried into the new trigger set.

### 1c. Savings

| | Branch A | Branch B |
| --- | --- | --- |
| Always-on before | 2,893 | 186 |
| Always-on after | 62 | 62 |
| **Removed** | **2,831 (97.9%)** | **124 (66.7%)** |

Triggered loads after, by surface — none of which is paid unless the work touches that path:

| Trigger | Loads | ~lines |
| --- | --- | --- |
| `apps/api/**` | `contexts/api.md` | 115 |
| `apps/api/prisma/**` | `contexts/prisma.md` | 145 |
| `apps/web/**` | `contexts/web.md` (incl. design-tokens) | 251 |
| `apps/web/src/components/**` | `contexts/design-patterns.md` | 356 |
| `apps/mobile/**` | `contexts/mobile.md` | 102 |
| `.ai/claude/design/**` | `design/README.md` | 416 |

Worst realistic single session (a full-stack web feature touching components) loads
62 + 115 + 145 + 251 + 356 = **929**, against 2,893 today under Branch A. A pure API session
loads **177**. A web page-level session that never opens `components/` loads **313**.

---

## 2. DUPLICATION MAP

Every row carries both verdicts. A row that names a canonical copy without sentencing the
loser is not a finished row.

| # | Pair | Canonical | **Loser becomes** |
| --- | --- | --- | --- |
| D1 | `CLAUDE.md:72-101` Identity Convention **vs** `prisma.md:34-83` Business ID Convention | **`prisma.md`** — fuller (adds the service-layer `code → id` resolution example at 71-82), and correctly path-scoped to where the rule binds | **Pointer stub, 3 lines**, in root. Not deleted: the invariant must be visible to someone who never opens `prisma/`. Exact replacement text: *"Every business entity has a UUID PK plus a per-tenant prefixed business code. The code is never the PK; child FKs use the UUID. Full rules load with the schema."* |
| D2 | `CLAUDE.md:133-156` Web UI Rules **vs** `rules/web.md` **vs** `design-system.md:235-346` Workspace Page Patterns | **`design-system.md`** for component/pattern rules; **`web.md`** for `CommonTable` specifics | `CLAUDE.md` copy → **deleted**. Fully covered by the other two; it is a summary that has already drifted (see D3). |
| D3 | `CLAUDE.md:123-132` Form Validation UX **vs** `design-system.md:102-115` Form Validation Reusability | **Neither, yet — see D3-ESCALATION below** | **Both replaced by a pointer to a conflict stub.** These two do not overlap, they **conflict**: `CLAUDE.md:125` says *"Do not render top-of-form validation summary boxes"*, while `design-system.md:104-108` mandates reusing `FormErrorSummary` and requires *"Top summary messages are single-line and readable."* One forbids the widget the other requires. |

### D3-ESCALATION — do not block the relocation on it

The instinct is to hold the form-validation move until a human adjudicates. **Don't.**
Canonical-doc questions have stalled before, and this one would hold the entire web
relocation hostage to an answer nobody has committed to giving.

This is a conflict, and conflicts already have a mechanism in this repo. Use it:

1. **File a conflict stub** naming both candidates, their line ranges, and what each
   uniquely requires — same shape as `vault/product/<topic>-INDEX.md`, no winner picked.
2. **Append the question to the gap register**, phrased for a one-line reply: *"Do web forms
   render a top-of-form error summary via `FormErrorSummary`, or is the summary box banned
   in favour of focus-only validation? `CLAUDE.md` and `design-system.md` currently require
   opposite behavior."*
3. **The restructure replaces both copies with a pointer to that stub** and moves on.

This is strictly better than today on the day it lands, independent of adjudication: right
now both contradictory rules load every session and something silently obeys one of them
without anyone knowing which. After the move, the contradiction is out of ambient context
and visible as an open question. Adjudication then happens on its own clock.

**One decision needed before filing** — `vault/gaps.md` is scoped to Confluence-migration
conflicts and every entry reads `Owner: product team`. D3 is an internal engineering
standards conflict with a different owner. Two options: file it in `gaps.md` with an
explicit `Owner: engineering`, or open a second register. **Recommendation: `gaps.md`, with
the owner field carrying the distinction.** A second register is how one fact acquires two
homes, which is the exact failure this whole pass exists to remove.
| D4 | Migration rule, **three copies**: `CLAUDE.md:154` (Web UI Rule 12), `web.md:38-45`, `prisma.md:100-111` | **`prisma.md:100-111`** — the fullest, and the only one that mentions `MIGRATION_BASELINE.md` | `CLAUDE.md:154` → **deleted**. `web.md:38-45` → **pointer stub, 1 line** (`Schema changes need a committed migration — see the prisma context`), since a web dev editing a list table does need the reminder even though the rule is not theirs. |
| D5 | `CLAUDE.md:26-42` Automated Feature Implementation **vs** `claude/design/README.md` (416) **vs** `claude/AUTOMATED-FEATURES.md` (528) | **`design/README.md`** — the folder-usage doc, closest to where the work happens | `CLAUDE.md:26-42` → **pointer stub, 2 lines**. `AUTOMATED-FEATURES.md` → **pointer-only** (kept, unloaded); it and `design/README.md` overlap heavily and a later pass should merge them, but that is a content merge, not a wiring change — out of scope here and recorded as follow-up F3. |
| D6 | `CLAUDE.md:61-71` Naming Conventions (DB rows) **vs** `prisma.md:24-33` | **Split, both canonical for their half.** `CLAUDE.md` owns Files/Classes/Functions/Constants; `prisma.md` owns Model/Field/DB column/DB table/Index | The 2 DB rows in `CLAUDE.md`'s table → **deleted** (they are the duplicated ones). `prisma.md` keeps the index convention `idx_<table>_<column>`, which `CLAUDE.md` never had. |
| D7 | `design-system.md:505-512` List tables **vs** `web.md:9-48` | **`web.md`** | Already a pointer (`design-system.md:507` says *"follow @.claude/rules/web.md"*). **Verify and keep as pointer**; strip the `@` prefix so it reads as a reference rather than an import. No line change. |
| D8 | Touch targets: `CLAUDE.md:122` (44/48px) **vs** `mobile.md:100` (48px) **vs** `design-system.md:163-234` Responsive | **`design-system.md`** (web) and **`mobile.md`** (mobile) | `CLAUDE.md:122` → **deleted**, absorbed into the two surface contexts. |

---

## 3. INVARIANT PASS — `tcg-scrum.md` + `tcg-elaborator.md` together

Sorting rule, applied to every embedded snapshot: *does this fact change agent behavior,
and does it survive the thing it describes moving?* Two dispositions only.

| Snapshot | Where | Behavior? | Survives? | Verdict |
| --- | --- | --- | --- | --- |
| "The vault is 154 files" | `tcg-scrum.md:60` | no | no | **DROP** |
| "145 of the 151 content files are `status: unverified`" | `tcg-scrum.md:60-61` | no | no | **DROP** → replaced by the disposition sentence below |
| "145 of the vault's 151 content files" | `tcg-elaborator.md` §2 | no | no | **DROP** |
| "153 files, migrated from Confluence" | `vault/INDEX.md:3` | no | no | **DROP** |
| "Seven gaps are open" | `tcg-scrum.md:61` | yes | no | **DERIVE** — count `^## ` headings in `gaps.md`. **Already wrong: 8 today.** |
| "Eight entries in `gaps.md` are open" | `tcg-elaborator.md` §2 | yes | no | **DERIVE** — same source |
| "Only the six `domain/` SOP files are verified" | both agents, repeatedly | **yes** | no | **DERIVE** — rows in the `domain/` table of `INDEX.md`. Behavior-changing (it *is* the verified set), so it cannot be dropped; but the count must come from the table, not from prose. |
| "Five conflict stubs exist" + the five names | `tcg-scrum.md:45-47`, elaborator §2 | yes | no | **DERIVE** — rows in the *Open conflicts* table in `INDEX.md` |
| FR-FOP id collision across the two FRDs | both | **yes** | **yes** | **KEEP** — passes both tests; this is what prose is for |
| The four recency counter-examples | `tcg-scrum.md:110-120`, elaborator §5 | **yes** | **yes** | **KEEP** |
| `meetings/` is retrospective | both | **yes** | **yes** | **KEEP** |
| `user-story-and-tasks.md` personal-space provenance | both | **yes** | **yes** | **KEEP** |

### The three-way disagreement, killed

`INDEX.md:3` says **153 files**. `tcg-scrum.md:60` says **154 files** and **151 content
files**; `tcg-elaborator.md` repeats the 151. Three artifacts, three numbers, no way to tell
which counting rule each used.

**Resolution: no number replaces them.** All three are DROPped, in the same pass, in all
three files, and nothing is written in their place except the disposition that actually
drives behavior:

> Assume any vault file is unverified until the index says otherwise. Only the `domain/`
> SOP set is adjudicated.

That sentence is true at 151 files, at 153, at 300, and after every gap closes. Applying it
to both agents **in the same commit** is what stops them re-diverging — fixing one and not
the other is how the third number appeared in the first place.

### One reconciliation that is not a bug

`INDEX.md:8` says *"Seven open conflicts"* while `gaps.md` has **eight** `##` entries. These
are consistent: the eighth entry (*Lunch thresholds*) is an unsourced decision in flight,
not a documentation conflict. Two different facts, similarly labelled. **Do not "fix" this
by changing either number** — instead label them distinctly when the derive rule is written:
*conflicts* = rows in the INDEX conflicts table; *gaps* = `##` headings in `gaps.md`.

---

## 4. CROSS-SURFACE

### 4a. Cursor — CONVERT (confirmed by format, falsifiable in 60 seconds)

Cursor's project rules are `.cursor/rules/*.mdc` with frontmatter keys `description`,
`globs`, `alwaysApply`. The mirrored files are **`.md`** (`setup.sh:114` →
`mirror_dir "$AI_DIR/claude/rules" ".cursor/rules"`, producing `api.md`,
`design-system.md`, `mobile.md`, `prisma.md`, `web.md`) and their frontmatter key is
**`paths:`**, which is not a Cursor key at all.

Two independent failures — wrong extension, wrong key — so `setup.sh:114`'s parenthetical
*"(audit: rules currently reach Claude only)"* is almost certainly right, and the Cursor
mirror has been inert since it was created.

**Branch taken: convert.** And convert *once*, in a way that serves both surfaces from one
body:

1. Rewrite each context file's frontmatter to Cursor's schema — `description:`, `globs:`
   (carrying over the current `paths:` values), `alwaysApply: false`. YAML frontmatter in a
   nested `CLAUDE.md` is inert for Claude Code, so one body satisfies both readers.
2. `mirror_dir` links name-for-name (`setup.sh:56-70`), so it must gain extension mapping to
   emit `api.mdc` from `api.md`. **This is the one genuinely new script capability in the
   plan** — see §5.
3. Falsification test, if anyone wants it before committing: open Cursor, ask whether
   `standardizeDesktopColumns` is in context while editing a file under `apps/web`. If it
   is, `paths:` in `.md` is honored after all and step 1 reduces to adding `globs:`.

### 4b. Codex — PROVISIONAL

Codex reads `AGENTS.md`; the root one is already symlinked (`AGENTS.md → .claude/AGENTS.md`)
and excluded (`setup.sh:119`). Nested `AGENTS.md` is its location-triggered equivalent, so
the pattern transfers **in shape**. What is unproven is whether Codex follows a *symlinked*
nested `AGENTS.md` — that is exactly the ALPHA probe's question, answered for Claude Code
and for nothing else.

**Required probe, same method:** create `apps/api/AGENTS.md` as a symlink into
`.ai/claude/contexts/` containing a sentinel line, open a file under `apps/api/` from
Codex, check whether the sentinel is in context. Two minutes.

**Plan assuming it passes:** one `safe_link` per trigger path, mirroring §1b exactly —
`apps/api/AGENTS.md`, `apps/api/prisma/AGENTS.md`, `apps/web/AGENTS.md`,
`apps/web/src/components/AGENTS.md`, `apps/mobile/AGENTS.md` — each pointing at the same
`claude/contexts/*.md` bodies the Claude Code links use. One body, three readers.

**The one move that changes if it fails:** the nested `AGENTS.md` symlinks are dropped, and
Codex keeps a single root `AGENTS.md` carrying the pointer index only. Codex then loses
location-triggering and reads contexts on demand by path. Nothing else in the plan moves —
the context bodies, the Claude Code links, and the Cursor `.mdc` mirror are all unaffected.

### 4c. `.agent/` — do NOT drop; the premise is wrong

`setup.sh:107-108` says *"kept for now — flagged as a possible drop in the audit; delete the
entry below once confirmed nobody's tool reads it."*

**A reader is documented.** `claude/AGENTS.md:326` states skills are linked for *"Cursor
(`.cursor/skills/`), Claude Code (`.claude/skills/`), Codex (`.codex/skills/`), and
Antigravity (`.agent/skills/`)"*. All four directories exist on disk with the same four
skills. So `.agent/` is Antigravity's surface, not a dead drop.

**Disposition:** keep the entry; **rewrite the comment** at `setup.sh:107-108` to name
Antigravity and state the real condition. The drop is a question for the team ("is anyone
using Antigravity?"), not something the codebase can answer, and the current comment hides
that by implying it is discoverable.

**Bonus defect, same line region:** `AGENTS.md:326` tells the reader to run
`pnpm setup:agents`. That script does not exist in the root `package.json` — it is the
zip-era command `setup.sh` replaced (`setup.sh:11`). Fix to `bash .ai/setup.sh`.

---

## 5. `setup.sh` CHANGES

| # | Change | Existing mechanism | New work? |
| --- | --- | --- | --- |
| S1 | Six nested `CLAUDE.md` symlinks (§1b trigger column) | `safe_link` (`setup.sh:34`) + `prefix_for` (`setup.sh:49`), which computes `../` depth per destination | **none** — new entries only |
| S2 | Six exclude lines for those paths | the `for p in …` loop (`setup.sh:119-123`), idempotent via `grep -qxF` | **none** — extend the list |
| S3 | Five nested `AGENTS.md` symlinks (Codex, provisional) | same as S1 | **none** |
| S4 | Cursor `.mdc` emission | `mirror_dir` (`setup.sh:56`) links name-for-name and cannot change extensions | **YES — the only new capability in this plan.** Add an optional extension-map argument to `mirror_dir`, or a sibling `mirror_dir_as`. Keep the prune loop (`setup.sh:64-70`) so renamed sources still clean up. |
| S5 | Comment fix at `setup.sh:107-108` (`.agent/` → Antigravity) | — | **none** — comment only |

Nothing here requires a new loader. S4 is a ~10-line change to one helper.

---

## 6. ACCEPTANCE TEST — per trigger, not extrapolated

ALPHA proved the mechanism **once, at one depth, for one path**. Deterministic loading is
the entire value proposition of this restructure, so it gets verified per trigger rather
than assumed to generalise. Run this after S1 + S2, before the Cursor and Codex work.

For each row: start a fresh session, read the named file, and **observe the injected
context** (not a self-report — same standard as PRE-FLIGHT 0).

| # | Trigger | Read this file | Must be present | Must be ABSENT |
| --- | --- | --- | --- | --- |
| T1 | `apps/api/` | `apps/api/src/service/sequences/sequence.module.ts` | `contexts/api.md` | prisma, web, design-*, mobile |
| T2 | `apps/api/prisma/` | `apps/api/prisma/schema.prisma` | `contexts/prisma.md` **+** `contexts/api.md` (parent) | web, design-*, mobile |
| T3 | `apps/web/` (page level) | `apps/web/next.config.ts` | `contexts/web.md` incl. design-tokens | `design-patterns.md`, api, prisma, mobile |
| T4 | `apps/web/src/components/` | any component `.tsx` | `design-patterns.md` **+** `contexts/web.md` (parent) | api, prisma, mobile |
| T5 | `apps/mobile/` | any `apps/mobile/**/*.tsx` | `contexts/mobile.md` | web, design-*, api, prisma |
| T6 | `.ai/claude/design/` | `.ai/claude/design/README.md` sibling | `design/README.md` | everything else |
| T7 | repo root only | `package.json` | root `CLAUDE.md` (62 lines) | **all six contexts** |

**The ABSENT column is the half that actually matters.** A context that loads everywhere is
the flat layer with extra steps, and it would pass a presence-only check silently. T7 is the
single most important row: if any context body appears in a root-only session, the
restructure has not achieved anything and the savings figure is fiction.

Also re-run the stealth check from ALPHA at each step: `git status --porcelain` in the client
repo must show nothing but pre-existing changes, with all six nested files in place.

## 7. ORDER OF EXECUTION

Three of these are external-latency items. **Fire them now and do not serialise behind
them.**

**Start immediately, in parallel:**

- **PRE-FLIGHT 0** — settle the `@`-import question. Decides how the plan is *described*,
  not what it does, so nothing downstream waits on it except the commit message.
- **D3-ESCALATION** — file the conflict stub and the gap entry (§2). This is a *filing*
  action, not a waiting one; adjudication runs on its own clock and blocks nothing.
- **§3 invariant pass** — both agents plus `INDEX.md`, **one commit**. Depends on neither of
  the above, is cheap, and every day it waits the counts spread further.

**Then, in order:**

1. **§2 duplication map** — collapse to one home each, in the current file layout. Do this
   *before* moving files: deduplicating and relocating in one step makes the diff unreadable.
2. **§1 relocation** — create `claude/contexts/`, move bodies, split `design-system.md` per
   §1b, shrink root to 62 lines.
3. **S1 + S2** — nested links and exclude lines; re-run `setup.sh`.
4. **§6 acceptance test** — all seven rows, presence *and* absence.
5. **4a Cursor** — S4 plus frontmatter conversion.
6. **4b Codex probe** — then S3, or the fallback if it fails.
7. **4c** — comment fix and the `pnpm setup:agents` correction.

**PRE-FLIGHT 0 is the only hard gate, and it gates more than the commit message.** Its
answer decides whether this plan is a token optimization worth doing eventually (A) or the
correctness fix the whole methodology rests on (B) — two different pieces of work with two
different urgencies. Run it first for that reason, not for the wording. Everything else in
the parallel block can proceed while it is outstanding.

## 8. FOLLOW-UPS RECORDED, NOT IN SCOPE

- **F1** — `rules/mobile.md` was never wired to anything. Worth asking how long mobile work
  has proceeded without it, and whether its content is still accurate.
- **F2** — `design-system.md:5` claims `apps/mobile/**/*.tsx`; the body is web-only. Dropped
  by this plan; the underlying question is whether mobile ever needed a design-system doc.
- **F3** — `AUTOMATED-FEATURES.md` (528) and `design/README.md` (416) overlap substantially.
  A content merge, not a wiring change.
- **F4** — `claude/SETUP-SUMMARY.md` (338) and `claude/DESIGN-FOLDER-UPDATE.md` (128) are
  referenced by nothing at all. Candidates for deletion; not touched here.
- **F5** — `claude/AGENTS.md:145-148` documents a shared-state mechanism at
  `/.agents/task-context.json`, `/.agents/design-specs.json`, `/.agents/api-contracts.json`
  and `/.agents/implementation-log.json`. **No `.agents/` directory exists anywhere in the
  tree.** Note the plural: it is distinct from `.agent/`, which is Antigravity's surface and
  does exist. That distinction is what separates the two possible explanations — either this
  is a documented mechanism that was never built, or it is a path that got renamed and the
  doc was not followed. **A question, not a fix.** Answering it decides whether the section
  is deleted or the mechanism is implemented; guessing either way writes fiction into a doc
  the multi-agent workflow depends on.

  *(Not on this list: the `setup.sh:6` bootstrap clone URL, which names a different host and
  org than this repo's actual remote. It is ungated, owned by nothing in this plan, and
  wants its own small correction commit rather than folding in here.)*
