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

## 2. Install — works for any agent, not just Claude

From the client repo root:

```bash
git clone <overlay-remote> .ai && bash .ai/setup.sh
```

That is the whole install, whichever tool you use. One script wires every surface; there
is no per-tool variant to pick and nothing to configure.

Re-run `bash .ai/setup.sh` any time — it is idempotent. It pulls the overlay, creates or
repairs every symlink, mirrors the surfaces, drops the location-triggered context files,
prunes links whose source was deleted, appends any missing exclude entries, and reports
what it changed. Real files it would otherwise overwrite are backed up, never destroyed.

**Re-run it after `pnpm install`** — husky resets the git hooks path, and the script says
so when it finishes.

### What you get, per tool

| Your tool | Reads | Wired by |
| --- | --- | --- |
| **Claude Code** | root `CLAUDE.md`, and a nested `CLAUDE.md` in each surface directory that loads automatically as you work there | root + nested symlinks |
| **Codex** | root `AGENTS.md`, and a nested `AGENTS.md` in each surface directory | root + nested symlinks |
| **Cursor** | `.cursor/skills/`, `.cursor/agents/`, `.cursor/contexts/`, `.cursor/rules/` | `mirror_dir` |
| **Antigravity** | `.agent/skills/`, `.agent/agents/`, `.agent/contexts/` | `mirror_dir` |
| **Anything else** | `.ai/claude/CLAUDE.md` as the entry point; `.ai/claude/contexts/<surface>.md` for depth | nothing needed — point it at the path |

Root `AGENTS.md` and root `CLAUDE.md` resolve to **the same file**. They cannot drift,
because there is only one.

### If your tool is not in that table

Nothing special is required. Every surface directory carries **both** a `CLAUDE.md` and an
`AGENTS.md` pointing at the same context file, so a tool that auto-loads either convention
is already served. A tool that auto-loads neither still works: give it
[`claude/CLAUDE.md`](claude/CLAUDE.md) as its project instructions, and it names the
context paths to open by hand.

If you wire a new surface, add it to `mirror_dir` in [`setup.sh`](setup.sh) rather than
copying files — copies drift, links cannot.

### Verifying it worked

```bash
cat CLAUDE.md | head -3          # resolves into the overlay
cat apps/api/CLAUDE.md | head -3 # the API surface context
git status --short               # must show nothing from the AI layer
```

The third is the one that matters. Everything wired in is appended to the client repo's
`.git/info/exclude`, so if AI-layer paths appear in `git status`, the exclude step did not
complete and the layer is at risk of being committed to the client repo.

Full behavior: [`setup.sh`](setup.sh).

## 3. Surfaces

Several tools consume this layer, and they do **not** consume it the same way.

| Surface | Entry point | How it consumes the layer |
| --- | --- | --- |
| **Claude Code** | root `CLAUDE.md` → [`claude/CLAUDE.md`](claude/CLAUDE.md), plus `.claude/` → [`claude/`](claude/) | Root context always on; a nested `CLAUDE.md` in each surface directory loads as work happens there. Settings from `.claude/`. |
| **Codex** | root `AGENTS.md`, plus `.codex/agents/`, `.codex/contexts/` | `AGENTS.md` is a symlink to the same root context file. A nested `AGENTS.md` sits in each surface directory. **Whether it auto-loads nested files is unverified** — see the plan's cross-surface section. |
| **Cursor** | `.cursor/agents/`, `.cursor/contexts/` | Mirrored from the overlay. **Status: provisional** — whether Cursor reads mirrored `.md` with this frontmatter is unverified; the plan marks it CONVERT and it is not yet done. |
| **Antigravity** | `.agent/agents/`, `.agent/contexts/` | Mirrored as above. |

Skills were removed pending redefinition, so no surface mirrors them today.

Mirroring is done by `mirror_dir` in [`setup.sh`](setup.sh) and the nested context files by
`link_context`. Definitions are canonical under `.ai/` and linked outward, never copied.

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

**Skills** are removed pending redefinition. They will be re-introduced as task-triggered
tools that are phase-independent — the kind of thing anyone needs at any point — rather
than as an alternative way to run a feature end to end.

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
| — | [`tcg-scrum`](aidlc/agents/tcg-scrum.md) | Unblocks from written sources or escalates. Never guesses. Runs alongside every phase |

All six ask for the stronger model tier available, because every one of them is judgement
work — see the tier note in the agents README.

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
