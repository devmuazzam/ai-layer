# TCG AI layer

Navigation hub for this overlay. **Pointers only** — every entry links to the file that
owns the subject. Nothing here restates another document's content, and nothing here
carries a count. If you want a number, follow the link; the file that owns the fact is the
only place it should live.

---

## 1. What this is

The private AI layer for the TCG crane-rental platform. It is a **separate repo** that
clones into the client monorepo at `.ai/` and is wired in by symlink. The client repo never
contains it and never sees it.

The stealth model, in three moves, all performed by [`setup.sh`](setup.sh):

1. **Clone** — the overlay lives at `.ai/`, its own git repo with its own history.
2. **Symlink in** — `.claude` → `.ai/claude`, root `CLAUDE.md` → `.claude/CLAUDE.md`, and
   the same for the other surfaces' entry points. The tools see ordinary files at ordinary
   paths.
3. **Hide** — every wired-in path is appended to the client repo's `.git/info/exclude`, so
   `git status` in the client repo shows nothing. `.git/info/exclude` is local-only and is
   never committed, so the exclusion does not travel to the client either.

Consequence worth internalising: **all real content lives under `.ai/`.** Anything outside
it is a symlink pointing back in. Never write AI-layer content into the client tree.

See also [`.gitignore`](.gitignore) for what the overlay itself does not track.

## 2. Install

From the client repo root:

```bash
git clone <overlay-remote> .ai && bash .ai/setup.sh
```

After that, `bash .ai/setup.sh` again any time — it is idempotent and safe to re-run. It
pulls the overlay, creates or repairs every symlink, mirrors the surfaces, prunes links
whose source was deleted, appends any missing exclude entries, and reports what it actually
changed. Real files it would otherwise overwrite are backed up, never destroyed.

Full behavior: [`setup.sh`](setup.sh).

## 3. Surfaces

Several tools consume this layer, and they do **not** consume it the same way.

| Surface | Entry point | How it consumes the layer |
| --- | --- | --- |
| **Claude Code** | root `CLAUDE.md` → [`claude/CLAUDE.md`](claude/CLAUDE.md), plus `.claude/` → [`claude/`](claude/) | Reads the root context file, plus skills and settings from `.claude/`. Location-triggered nested context files are what the restructure moves to — see [the plan](aidlc/context-restructure-plan.md). |
| **Cursor** | `.cursor/rules/`, `.cursor/skills/`, `.cursor/agents/` | Mirrored from [`claude/rules/`](claude/rules/), [`claude/skills/`](claude/skills/) and [`aidlc/agents/`](aidlc/agents/). **Status: provisional** — whether the mirrored rules are actually read is unresolved; see the plan's cross-surface section. |
| **Codex** | root `AGENTS.md` → [`claude/AGENTS.md`](claude/AGENTS.md), plus `.codex/skills/`, `.codex/agents/` | Reads `AGENTS.md`; skills and agents mirrored as above. **Status: nested-context support unverified** — see the plan. |
| **Antigravity** | `.agent/skills/`, `.agent/agents/` | Skills and agents mirrored as above. See the *Project Skills* section of [`claude/AGENTS.md`](claude/AGENTS.md) for the provider skill map. |

Mirroring for all four is done by `mirror_dir` in [`setup.sh`](setup.sh); the skill
definitions are canonical in [`claude/skills/`](claude/skills/) and linked outward, never
copied.

## 4. Context layer

**This layer is mid-restructure.** It is being reorganised from always-loaded to
location-triggered, and the design, sequencing and open checks live in
[`aidlc/context-restructure-plan.md`](aidlc/context-restructure-plan.md). That plan is
**gated on an unrun check (PRE-FLIGHT 0)** and nothing in it has been applied. Read it
before changing anything below, and prefer adding to the plan over editing these files
piecemeal.

**Root context**

| File | Read it when |
| --- | --- |
| [`claude/CLAUDE.md`](claude/CLAUDE.md) | The always-loaded project context — stack, architecture, naming, identity convention, code quality |
| [`claude/AGENTS.md`](claude/AGENTS.md) | Multi-agent workflow, and the provider skill map |
| [`claude/DESIGN.md`](claude/DESIGN.md) | Implementing a feature from design images |
| [`claude/AUTOMATED-FEATURES.md`](claude/AUTOMATED-FEATURES.md) | The automated feature-implementation flow end to end |
| [`claude/QUICK-REFERENCE.md`](claude/QUICK-REFERENCE.md) | Fast lookup for common tasks |
| [`claude/SETUP-SUMMARY.md`](claude/SETUP-SUMMARY.md) | How the layer was originally assembled |
| [`claude/DESIGN-FOLDER-UPDATE.md`](claude/DESIGN-FOLDER-UPDATE.md) | History of the design-folder convention |
| [`claude/settings.json`](claude/settings.json) | Claude Code permissions and tool allow/deny lists |

**Surface rules** — each scoped to the paths it governs.

| File | Governs |
| --- | --- |
| [`claude/rules/api.md`](claude/rules/api.md) | NestJS clean-architecture layering, controllers, repositories, DTOs, guards |
| [`claude/rules/prisma.md`](claude/rules/prisma.md) | Schema conventions, the business-ID/UUID identity rules, migrations |
| [`claude/rules/web.md`](claude/rules/web.md) | Next.js list tables — search placeholders, filter empty states, column layout |
| [`claude/rules/design-system.md`](claude/rules/design-system.md) | Theming, component reuse, CVA variants, workspace page patterns, accessibility |
| [`claude/rules/mobile.md`](claude/rules/mobile.md) | Expo structure, components, forms, secure storage, navigation |

**Skills** — task-triggered instructions, provider-neutral.

[`commit`](claude/skills/commit/SKILL.md) ·
[`debug-api`](claude/skills/debug-api/SKILL.md) ·
[`new-feature`](claude/skills/new-feature/SKILL.md) ·
[`review-pr`](claude/skills/review-pr/SKILL.md)

**Design intake** — drop images in a folder under [`claude/design/`](claude/design/) and
describe the feature. [`claude/design/README.md`](claude/design/README.md) explains the
convention; [`claude/design/example-feature/specs.md`](claude/design/example-feature/specs.md)
is the worked example.

## 5. Vault

Product and process documentation migrated from Confluence.

**Retrieval is index-first, always.** Start at [`vault/INDEX.md`](vault/INDEX.md) — it
states what exists, what each file answers, and the caveats that change how everything
downstream reads. Where a topic has competing sources, the index routes you to a conflict
stub rather than to one side of an unresolved disagreement. Opening a content file directly
is how an agent ends up quoting one candidate as settled fact.

| File | What it is |
| --- | --- |
| [`vault/INDEX.md`](vault/INDEX.md) | **The entry point.** Read before opening any content file |
| [`vault/README.md`](vault/README.md) | Migration conventions, frontmatter schema, what was deliberately excluded and why |
| [`vault/gaps.md`](vault/gaps.md) | The open-question register — unresolved conflicts and unsourced decisions |

Statuses, verification state, conflict sets and their counts all live in the index and the
gap register. They are deliberately not repeated here.

## 6. AI-DLC

The delivery loop this layer is built around: a Jira ticket is captured as an **intent**;
the **elaborator** turns that intent into a sourced **spec** and then stops to ask what it
could not source; the spec is decomposed into vertically shippable **units**; units are
built; and a **reflection** feeds what the spec missed and what the executor got wrong back
into the rules. The **scrum** agent runs alongside the whole loop, unblocking developers
from written sources or escalating honestly when nothing is written.

**The loop is partial today.** The elaborator and scrum agents exist. The downstream
agents — decomposer, executors, analyst, reflector — do **not** exist yet; their templates
are written and their field contracts are fixed, but nothing consumes them. By the project's
own sequencing they are authored after the context restructure, so they are written once
against the trimmed layer instead of reworked after it moves.

**Agents**

| File | What it does |
| --- | --- |
| [`aidlc/agents/tcg-elaborator.md`](aidlc/agents/tcg-elaborator.md) | Intent → sourced spec, then stops and asks. Never implements |
| [`aidlc/agents/tcg-scrum.md`](aidlc/agents/tcg-scrum.md) | Answers "how is this supposed to work" from written sources, or escalates. Never guesses |

**Templates** — required-field checklists. A field is never deleted; an unfillable field
stays and is marked, so a gap is visible rather than silent.

| File | Filled when |
| --- | --- |
| [`aidlc/templates/intent.md`](aidlc/templates/intent.md) | Capturing a Jira ticket, before elaboration |
| [`aidlc/templates/spec.md`](aidlc/templates/spec.md) | Produced by the elaborator; the document an executor builds from |
| [`aidlc/templates/units.md`](aidlc/templates/units.md) | Decomposing an approved spec into vertical slices |
| [`aidlc/templates/reflection.md`](aidlc/templates/reflection.md) | After units ship, before the ticket closes |

**Plan**

[`aidlc/context-restructure-plan.md`](aidlc/context-restructure-plan.md) — the context-layer
restructure. Unapplied, and gated on PRE-FLIGHT 0.

## 7. Conventions

- **Everything under `.ai/`.** All real content lives here. Paths outside are symlinks
  pointing back in, created by [`setup.sh`](setup.sh).
- **Never write to the client repo.** Not source, not config, not docs, not whitespace. If
  a change appears to require it, stop and raise it instead.
- **One branch per change.** Branch from `main`, one logical change per branch, merged by
  PR — matching the history this repo already has.
- **One fact, one home.** If a fact lives in two files it will diverge. Link to the owner
  rather than restating it; that rule applies to this README first.
