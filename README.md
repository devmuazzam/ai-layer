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
2. **Symlink in** — every path a tool looks at is a symlink pointing back into `.ai/`. The
   tools see ordinary files at ordinary paths; nothing is copied. Full map below.
3. **Hide** — every wired-in path is appended to the client repo's `.git/info/exclude`, so
   `git status` in the client repo shows nothing. `.git/info/exclude` is local-only and is
   never committed, so the exclusion does not travel to the client either.

> **Never add these paths to the client repo's `.gitignore`.** It is a tracked, committed
> file, so listing `.ai/`, `CLAUDE.md` or `.cursor/` there would announce the layer's
> existence to the client in the very act of hiding it from git. `.git/info/exclude` does
> the identical job and is never committed. This is the whole reason `setup.sh` writes
> there, and it is the one part of the stealth model that a well-meaning cleanup breaks.

### The symlink map

Every one of these is created and repaired by `setup.sh`. Nothing here is a copy.

```
.claude              -> .ai/claude                       (the whole directory)
CLAUDE.md            -> .claude/CLAUDE.md                -> .ai/claude/CLAUDE.md
AGENTS.md            -> .claude/AGENTS.md -> CLAUDE.md   -> .ai/claude/CLAUDE.md

apps/api/CLAUDE.md         ┐
apps/api/AGENTS.md         ┘ -> ../../.ai/claude/contexts/api.md
apps/api/prisma/CLAUDE.md  ┐
apps/api/prisma/AGENTS.md  ┘ -> ../../../.ai/claude/contexts/prisma.md
apps/web/CLAUDE.md         ┐
apps/web/AGENTS.md         ┘ -> ../../.ai/claude/contexts/web.md
apps/mobile/CLAUDE.md      ┐
apps/mobile/AGENTS.md      ┘ -> ../../.ai/claude/contexts/mobile.md

.cursor/{skills,agents,contexts}/*   -> ../../.ai/...    (reference mirrors)
.agent/{skills,agents,contexts}/*    -> ../../.ai/...
```

Three things worth knowing when one of these looks wrong:

- **`AGENTS.md` is a three-hop chain.** `readlink AGENTS.md` prints `.claude/AGENTS.md`,
  which is *itself* a symlink to `CLAUDE.md` in the same directory. So both root entry
  points end at one file and cannot drift. Use `cat`, not `readlink`, to see content.
- **Link prefixes are computed from depth**, not hardcoded — `../../` at `apps/web`,
  `../../../` at `apps/api/prisma`. `prefix_for` in `setup.sh` does this, so moving a
  surface deeper does not silently break its link.
- **A dangling link means a source was deleted from the overlay.** `bash .ai/verify.sh`
  reports them per surface; `bash .ai/setup.sh` prunes them.

Consequence worth internalising: **all real content lives under `.ai/`.** Anything outside
it is a symlink pointing back in. Never write AI-layer content into the client tree.

See also [`.gitignore`](.gitignore) for what the overlay itself does not track.

## 2. Install — works for any agent, not just Claude

From the client repo root, using **your own** remote URL for this overlay:

```bash
git clone <your-overlay-remote> .ai && bash .ai/setup.sh
```

That is the whole install, whichever tool you use. One script wires every surface; there
is no per-tool variant to pick and nothing to configure.

> **The `AI_REMOTE` default will not work on your machine.** `setup.sh` falls back to
> `git@dev_codingcops_github.com:devCodingcops/tcg-ai-layer.git`, and
> `dev_codingcops_github.com` is an **SSH host alias**, not a real hostname — it resolves
> only on a machine with that entry in `~/.ssh/config`. Everyone else must either clone
> manually as above, or override it:
>
> ```bash
> AI_REMOTE=git@github.com:<org>/tcg-ai-layer.git bash .ai/setup.sh
> ```
>
> This matters on the **first run only**. Once `.ai/` is a git clone, `setup.sh` pulls from
> whatever `origin` that clone already has and never consults `AI_REMOTE` again.

Re-run `bash .ai/setup.sh` any time — it is idempotent. It pulls the overlay, creates or
repairs every symlink, mirrors the surfaces, drops the location-triggered context files,
prunes links whose source was deleted, appends any missing exclude entries, and reports
what it changed. Real files it would otherwise overwrite are backed up, never destroyed.

**Re-run it after `pnpm install`** — husky resets the git hooks path, and the script says
so when it finishes.

### What you get

**Two supported tools: Claude Code and Cursor.** Both receive the identical content
through the identical mechanism — a root entry file plus one nested file per surface
directory, where **the file nearest your edit wins**. They differ only in the filename each
one looks for, and both filenames are always present.

| Your tool | Reads | Status |
| --- | --- | --- |
| **Claude Code** | root `CLAUDE.md`, plus the nearest `apps/*/CLAUDE.md` as you work | **verified** — nested `CLAUDE.md` confirmed by probe, 2026-08-11 |
| **Cursor** | root `AGENTS.md`, plus the nearest `apps/*/AGENTS.md` | **verified** against Cursor's rules documentation, 2026-08-11 |
| **Antigravity** | all of the above are present, plus `.agent/agents/` and `.agent/contexts/` | **unverified** — see below |

Root `AGENTS.md` and root `CLAUDE.md` resolve to **the same file**. They cannot drift,
because there is only one.

**Cursor does not use `.cursor/rules/`.** Its rules system reads `.mdc` only and ignores
`.md`, so an earlier version of this layer that mirrored `.md` rules there was never read
at all. `.cursor/agents/` and `.cursor/contexts/` exist as findable reference copies; they
are not auto-loaded and nothing depends on them.

**Antigravity is wired but unconfirmed.** Both root entry filenames and both nested
filenames are present, and `.agent/` mirrors the content, so it is *reachable*. Which of
those it loads by itself has not been established, and its published docs do not say. Check
it in a minute: open a file under `apps/api/` and ask something only `contexts/api.md`
answers — *"how many global guards does this API register, and which?"* The answer is four:
AccessToken, Roles, Permissions, Throttler. If it cannot say, point it at
[`claude/CLAUDE.md`](claude/CLAUDE.md) explicitly; that file names every context path.

Codex is **not supported**. `setup.sh` removes `.codex/` if an earlier run created it,
unless you have put real files there.

### Confirming it worked

```bash
bash .ai/verify.sh
```

It checks that the overlay is a clone, that both root entry points resolve to one file,
that every surface directory carries both filenames pointing at the right context, that
nothing from the layer is visible to the client repo's `git status`, and that no mirror
holds a dangling link. It prints what your agent will read, exits non-zero on any failure,
and names the fix.

Run it after install, and any time an agent seems to be ignoring the rules — "is it wired
or is the model ignoring it?" is otherwise a very expensive question to answer by hand.

The `git status` check is the one that matters most. Everything wired in is appended to the
client repo's `.git/info/exclude`; if AI-layer paths show up there, the exclude step did
not complete and the layer is at risk of being committed into the client repo.

Full behavior: [`setup.sh`](setup.sh), [`verify.sh`](verify.sh).

## 3. Surfaces

**Two surfaces: Claude Code and Cursor.** They consume the layer the same way — a root
entry file plus one nested file per surface directory, nearest file winning — and differ
only in the filename each looks for.

| Surface | Entry point | How it consumes the layer |
| --- | --- | --- |
| **Claude Code** | root `CLAUDE.md` → [`claude/CLAUDE.md`](claude/CLAUDE.md), plus `.claude/` → [`claude/`](claude/) | Root context always on; the nested `CLAUDE.md` in a surface directory loads as work happens there. Settings from `.claude/`. |
| **Cursor** | root `AGENTS.md` + the nested `AGENTS.md` per surface directory | **Verified 2026-08-11** against Cursor's rules documentation: it reads `AGENTS.md` at the root *and* nested in subdirectories, more specific taking precedence — exactly the shape `link_context` produces. It ignores `.md` in `.cursor/rules/`, reading only `.mdc`, so this layer does not use that path. `.cursor/agents/` and `.cursor/contexts/` are findable reference copies, not auto-loaded. |

| **Antigravity** | root + nested entry files, plus `.agent/agents/`, `.agent/contexts/` | **Unverified.** Everything is present and reachable; which of it Antigravity loads unprompted has not been established and its docs do not say. The install section gives a one-minute check. |

Codex was dropped. `setup.sh` removes `.codex/` when it holds nothing but its own symlinks,
and leaves it with a warning if it holds anything else. Skills were removed pending
redefinition, so nothing mirrors them today.

Nested context files are created by `link_context` in [`setup.sh`](setup.sh), the Cursor
reference mirror by `mirror_dir`. Definitions are canonical under `.ai/` and linked
outward, never copied.

**Every surface directory gets both filenames.** `apps/api/CLAUDE.md` and
`apps/api/AGENTS.md` are two links to one context file, because the tools disagree about
which name they look for and guessing wrong means a surface silently gets no rules. The
directory-to-context mapping is declared once in `setup.sh` as `CONTEXT_MAP`, and the
exclude entries are derived from it — so a path can never be linked but left unhidden.

## 4. Context layer

The layer holds **surface knowledge only** — what is true about this codebase, in every
phase of work. How work *moves* belongs to AI-DLC (section 6). That split is the rule:
if something only makes sense inside one phase, it does not belong here.

**Root context** — always on, and the same file on every surface.

| File | Read it when |
| --- | --- |
| [`claude/CLAUDE.md`](claude/CLAUDE.md) | Always. Where answers come from, stack, commands, architecture invariants, naming, aliases, the identity rule, code quality |
| `claude/AGENTS.md` | Never separately — it is a symlink to `CLAUDE.md` |
| [`claude/settings.json`](claude/settings.json) | Claude Code permissions and tool allow/deny lists |

**Surface contexts** — dropped into the directory they govern by `link_context`.

| File | Governs |
| --- | --- |
| [`claude/contexts/api.md`](claude/contexts/api.md) | `apps/api/` — layering, file patterns, the four global guards, feature checklist |
| [`claude/contexts/prisma.md`](claude/contexts/prisma.md) | `apps/api/prisma/` — identity codes and how to derive them, when tenant scoping does **not** apply, migrations |
| [`claude/contexts/web.md`](claude/contexts/web.md) | `apps/web/` — component layers, workspace patterns, theming, forms |
| [`claude/contexts/mobile.md`](claude/contexts/mobile.md) | `apps/mobile/` — Expo Router, tokens, `StyleSheet`, secure storage |

**Removed, and why.** The previous layer documented a second delivery flow — drop design
images in a folder, say "implement the feature", five parallel agents deliver a full
stack — which contradicts AI-DLC's inception → construction → reflection loop. Both were
loading at once and telling an agent opposite things. The flow docs, the skills built for
that flow, and the PNG-drop design intake are gone; recover any of them from git history if
needed.

`claude/rules/` was superseded by `claude/contexts/`, which was written by reading the
codebase rather than by editing the old rules. That distinction matters: the old files
described atomic design, `PRLT`, NestJS 10, Prisma 5 and unconditional tenant scoping, none
of which are true.

**Skills** — task-triggered, phase-independent, and deliberately narrow so they never
compete with a phase agent. The previous set was removed because two of the four were
alternative ways to run a feature end to end; these are not.

| Skill | Fires on |
| --- | --- |
| [`commit`](claude/skills/commit/SKILL.md) | Starting a unit, rebasing, or writing a commit. Branch naming, rebase-from-`origin/main`, conventional commit format |
| [`review-pr`](claude/skills/review-pr/SKILL.md) | Reviewing a PR, branch or diff — against the **vault** as well as the code. Cites product sources with their status, surfaces conflicts without adjudicating them |
| [`lint-triage`](claude/skills/lint-triage/SKILL.md) | A failing gate. Separates your errors from the ~14 pre-existing ones by diffing against a baseline |
| [`find-component`](claude/skills/find-component/SKILL.md) | Adding any UI component. Searches all nine `components/` directories, not just the atomic tiers |
| [`debug-api`](claude/skills/debug-api/SKILL.md) | A failing endpoint. Status-code triage through four global guards, with the tenancy case checked early |

Two of these exist because of measured failures rather than general good practice.
`lint-triage` exists because `pnpm lint` fails before you touch anything. `find-component`
exists because `components/ui` has more importers than any atomic tier, so the search the
old docs prescribed missed the largest source in the app.

`review-pr` is the one that reads the vault. Its discipline there is the vault's own: index
first, name every candidate when sources conflict, never pick a winner, and never present
`unverified` content as settled — most of the vault is unverified.

**Design intake** is being redesigned around the UI team's HTML/CSS handoff rather than
images. Not yet specified.

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

**Agents are organised by phase**, and each phase folder carries a README explaining why
its agents belong together and what leaves that phase. Roles stay in the filename; only
folders carry phase, so moving an agent between phases never breaks a reference.

See [`aidlc/agents/README.md`](aidlc/agents/README.md) for the layout rule, the handoff
contract, and what every agent in the loop shares.

| Phase | Agent | What it does |
| --- | --- | --- |
| [inception](aidlc/agents/inception/) | [`tcg-elaborator`](aidlc/agents/inception/tcg-elaborator.md) | Intent → sourced spec, then stops and asks. Never implements |
| | [`tcg-decomposer`](aidlc/agents/inception/tcg-decomposer.md) | Approved spec → vertical units that ship alone. Never builds |
| [construction](aidlc/agents/construction/) | [`tcg-executor`](aidlc/agents/construction/tcg-executor.md) | One unit → working code. Stops where the spec stops |
| | [`tcg-analyst`](aidlc/agents/construction/tcg-analyst.md) | Reviews the built unit, tagging every finding VERIFIED or INFERRED |
| [reflection](aidlc/agents/reflection/) | [`tcg-reflector`](aidlc/agents/reflection/tcg-reflector.md) | What the loop missed → proposed rule changes. Proposes, never applies |
| [tools](aidlc/agents/tools/) | [`tcg-contract-tracer`](aidlc/agents/tools/tcg-contract-tracer.md) | An API shape changed — what breaks across web and mobile. Reports, never fixes |
| | [`tcg-prisma-guardian`](aidlc/agents/tools/tcg-prisma-guardian.md) | Is this schema change safe, isolated and efficient. Isolation first, because scoping here is conditional |
| — | [`tcg-scrum`](aidlc/agents/tcg-scrum.md) | Unblocks from written sources or escalates. Never guesses. Runs alongside every phase |

Model tier is assigned by how much judgement the task needs, not by seniority: elaborator,
decomposer, analyst, reflector and scrum ask for the strong tier; executor, contract-tracer
and prisma-guardian sit at mid tier. See the tier table in
[`aidlc/agents/README.md`](aidlc/agents/README.md).

**Branching and commits.** One unit, one branch, one PR —
`<type>/SCRUM-###-u<n>-<slug>`, branched from `origin/main` and rebased onto it before
pushing. Conventional commits with a body that says why, and what was deliberately left
out. The executor enforces it; the mechanics live in the `branch-commit` skill.

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
