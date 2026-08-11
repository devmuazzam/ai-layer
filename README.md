# TCG AI layer

The private AI layer for the TCG crane-rental platform.

This README explains **how the layer works** — how it wires into a repo it is not part of,
how instructions actually reach an agent, and how to prove any of it. Content lives in the
files that own it; this one links rather than restates, because a fact in two places
diverges.

**New here?** Install (§3), confirm it worked (§4), then read
[`aidlc/GUIDE.md`](aidlc/GUIDE.md) before running a ticket through.

---

## 1. What this is, and why it is built this way

A **separate git repository** that clones into the client monorepo at `.ai/` and is wired in
by symlink. The client repo never contains it, never sees it, and never learns it exists.

That constraint drives every design decision below. The layer has to be **present enough for
tools to read** and **invisible enough that nothing leaks into a client commit** — and those
pull in opposite directions.

Three moves, all performed by [`setup.sh`](setup.sh):

1. **Clone** — the overlay lives at `.ai/`, with its own git history, its own branches, its
   own remote.
2. **Symlink in** — every path a tool looks at becomes a symlink pointing back into `.ai/`.
   Tools see ordinary files at ordinary paths.
3. **Hide** — every wired path is appended to the client repo's `.git/info/exclude`, so
   `git status` in the client repo shows nothing.

**Everything real lives under `.ai/`.** Anything outside it is a pointer back in. Never write
AI-layer content into the client tree.

---

## 2. How the wiring works

### 2.1 Why symlinks and not copies

A copy has to be kept in sync, and anything kept in sync eventually is not. Symlinks give
**one file with several names**: edit `.ai/claude/contexts/api.md` and every path that points
at it changes at once, with no sync step to forget.

It also means a stale pointer is *visible* — a dangling symlink is detectable, where a stale
copy looks exactly like a fresh one. `verify.sh` uses that property.

### 2.2 The map

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

### 2.3 Four things that surprise people

**`AGENTS.md` is a three-hop chain.** `readlink AGENTS.md` prints `.claude/AGENTS.md`, which
is *itself* a symlink to `CLAUDE.md` in the same directory — and `.claude` is a symlink too.
That looks like a broken link and is not. Use `cat`, not `readlink`. It is also why the two
root entry points **cannot drift**: there is only one file.

**Every surface directory carries both filenames.** `apps/api/CLAUDE.md` and
`apps/api/AGENTS.md` are two links to one context file. Claude Code reads `CLAUDE.md`;
Cursor reads `AGENTS.md`. Guessing wrong would mean a surface silently gets no rules, so
both are always present.

**Link prefixes are computed from depth, not hardcoded.** `prefix_for` in `setup.sh` counts
path segments — `../../` at `apps/web`, `../../../` at `apps/api/prisma`. Moving a surface
deeper does not silently break its link.

**A dangling link means a source was deleted from the overlay.** `verify.sh` reports them;
`setup.sh` prunes them. This is not theoretical: removing `claude/rules/` and
`claude/skills/` once left 14 dead links behind on a machine that had already run setup.

### 2.4 Why `.git/info/exclude` and never `.gitignore`

This is the single easiest thing to "helpfully" break.

`.gitignore` is **tracked and committed**. Adding `.ai/`, `CLAUDE.md` or `.cursor/` to it
would announce the layer's existence to the client — in the very act of hiding it from git.
The commit that hides the layer is the commit that reveals it.

`.git/info/exclude` does the identical job and is **local-only**: never committed, never
pushed, never travels to anyone else's clone. That is why `setup.sh` writes there.

Consequence worth knowing: because it is local, **every machine must run `setup.sh`**.
Cloning the client repo alone gets you none of this.

The exclude list is also **derived, not hand-maintained**. `setup.sh` builds the nested
context paths from the same `CONTEXT_MAP` it links them with, so a path can never be linked
but left unhidden — which would put AI-layer files in a client `git status`.

---

## 3. Install

From the client repo root, using **your own** remote URL:

```bash
git clone <your-overlay-remote> .ai && bash .ai/setup.sh
```

One script wires every surface. There is no per-tool variant to choose.

> **The `AI_REMOTE` default will not work on your machine.** `setup.sh` falls back to
> `git@dev_codingcops_github.com:devCodingcops/tcg-ai-layer.git`, where
> `dev_codingcops_github.com` is an **SSH host alias**, not a hostname — it resolves only
> with that entry in `~/.ssh/config`. Either clone manually as above, or override it:
>
> ```bash
> AI_REMOTE=git@github.com:<org>/tcg-ai-layer.git bash .ai/setup.sh
> ```
>
> First run only. Once `.ai/` is a clone, `setup.sh` pulls from whatever `origin` it has.

`setup.sh` is **idempotent** — re-run it any time. It pulls the overlay, creates or repairs
every symlink, drops the nested context files, mirrors the surfaces, prunes links whose
source was deleted, appends missing exclude entries, and reports what it changed. A real
file it would otherwise overwrite is **backed up, never destroyed**.

**Re-run it after `pnpm install`** — husky resets the git hooks path. The script says so when
it finishes.

---

## 4. How instructions actually reach an agent

The part most worth understanding, because "the agent ignored the rule" and "the agent never
saw the rule" look identical and have opposite fixes.

### 4.1 Two loading behaviours

| | When it loads |
| --- | --- |
| **Root** `CLAUDE.md` / `AGENTS.md` | At session start, always, in full |
| **Nested** `apps/*/CLAUDE.md` | **Only when the agent reads a file in that directory** |

Nested contexts are *not* loaded at launch. Per Claude Code's documentation, subdirectory
`CLAUDE.md` files are *"included when Claude reads files in those directories"*.

**What counts as the trigger:**

| | Loads it? |
| --- | --- |
| Claude using its **Read tool** on a file in that directory | **yes** |
| A `cd` inside a bash command | no |
| **You** running `cat` in your own terminal | no — the agent is not involved |
| The agent running `cat` via bash | probably not — ask it to *read* |

This matters more than it sounds. Two sessions were asked *"how is this app organised?"*,
explored `apps/web` with `find` and `ls` only, and answered without ever loading
`contexts/web.md` — correctly, because nothing triggered it.

**After `/compact`, nested contexts are not re-injected.** They reload the next time the
agent reads a file in that directory. The root does get re-injected.

### 4.2 Prove it, do not ask

Asking a model what is in its own context is the one method that cannot be trusted. Use
`/context`, typed **in the Claude Code chat**:

```
read apps/api/src/main.ts
/context
```

Look under **Memory files** for `apps/api/CLAUDE.md`. That is an observation, not a
self-report.

For a permanent record, the `InstructionsLoaded` hook logs which instruction files load,
when, and why — the Claude Code docs name lazy-loaded subdirectory files as its use case.

### 4.3 Per surface

| Tool | Reads | Status |
| --- | --- | --- |
| **Claude Code** | root `CLAUDE.md` + nearest `apps/*/CLAUDE.md` | **verified** |
| **Cursor** | root `AGENTS.md` + nearest `apps/*/AGENTS.md`, nearest wins | **verified** against Cursor's rules docs, 2026-08-11 |
| **Antigravity** | everything above is present, plus `.agent/` mirrors | **unverified** — reachable, but what it auto-loads is unestablished |

**Cursor does not use `.cursor/rules/`.** Its rules system reads `.mdc` only and ignores
`.md`, so an earlier version of this layer that mirrored `.md` rules there was never read at
all. `.cursor/agents/` and `.cursor/contexts/` are findable reference copies, not a loading
mechanism — nothing depends on them.

Codex is **not supported**; `setup.sh` removes `.codex/` unless you have put real files there.

### 4.4 Confirming the whole thing

```bash
bash .ai/verify.sh
```

Checks the overlay is a clone, both root entry points resolve to one file, every surface
carries both filenames pointing at the right context, no dangling links anywhere, all skills
present, and **nothing from the layer visible to the client repo's `git status`**. Exits
non-zero and names the fix.

That last check is the important one: if AI-layer paths show up in `git status`, the exclude
step did not complete and the layer is at risk of being committed into the client repo.

`verify.sh` also prints an **essence test** — questions whose answers exist only in a
specific context file, split into a tier answerable from the root and a tier answerable only
from a nested context. Wiring is not comprehension, and the two tiers keep those apart.

---

## 5. What is in the layer

| Path | What it holds |
| --- | --- |
| [`claude/CLAUDE.md`](claude/CLAUDE.md) | The always-on root context. Also served as `AGENTS.md` |
| [`claude/contexts/`](claude/contexts/) | Per-surface rules — [api](claude/contexts/api.md), [prisma](claude/contexts/prisma.md), [web](claude/contexts/web.md), [mobile](claude/contexts/mobile.md) |
| [`claude/skills/`](claude/skills/) | Task-triggered procedures |
| [`aidlc/`](aidlc/) | The delivery loop — agents, templates, guide |
| [`vault/`](vault/) | Product knowledge migrated from Confluence |
| [`setup.sh`](setup.sh) · [`verify.sh`](verify.sh) | Wire it · prove it |

### Skills — task-triggered, deliberately narrow

Narrow so they never compete with a phase agent. An earlier set was removed because two of
its four were alternative ways to run a feature end to end.

| Skill | Fires on |
| --- | --- |
| [`commit`](claude/skills/commit/SKILL.md) | Starting a unit, rebasing, writing a commit |
| [`review-pr`](claude/skills/review-pr/SKILL.md) | Reviewing a PR — against the **vault** as well as the code |
| [`lint-triage`](claude/skills/lint-triage/SKILL.md) | A failing gate — which errors are yours |
| [`find-component`](claude/skills/find-component/SKILL.md) | Adding UI — searches all nine `components/` directories |
| [`debug-api`](claude/skills/debug-api/SKILL.md) | A failing endpoint |

Two exist because of measured failures rather than general good practice: `pnpm lint` fails
before you touch anything, and `components/ui` has more importers than any atomic tier — so
the search the old docs prescribed missed the largest source in the app.

### Vault — product knowledge

**Retrieval is index-first, always.** Start at [`vault/INDEX.md`](vault/INDEX.md). Where a
topic has competing sources it routes you to a conflict stub rather than one side of an
unresolved disagreement. Opening a content file directly is how an agent ends up quoting a
candidate as settled fact.

| File | What it is |
| --- | --- |
| [`vault/INDEX.md`](vault/INDEX.md) | **The entry point.** Read before any content file |
| [`vault/README.md`](vault/README.md) | Migration conventions, frontmatter, deliberate exclusions |
| [`vault/gaps.md`](vault/gaps.md) | Open questions — unresolved conflicts and unsourced decisions |
| [`vault/sync/confluence-sync.md`](vault/sync/confluence-sync.md) | How the vault tracks a source that keeps moving |

Most of it is `status: unverified`. Statuses and counts live in the index and gap register,
not here.

---

## 6. AI-DLC — the delivery loop

> **Start here: [`aidlc/GUIDE.md`](aidlc/GUIDE.md)** — the loop end to end, what each agent
> does and refuses to do, why the tools exist, a full worked pass, and what to expect on a
> first real run.

A ticket becomes an **intent**; the elaborator turns it into a sourced **spec** and stops to
ask what it could not source; the spec is decomposed into shippable **units**; units are
built and checked; a **reflection** feeds what was missed back into the rules.

**Not every ticket runs the full loop.** That is the *feature* path. A bug whose correct
behaviour is already specified goes straight to construction; a one-line UI change needs no
phase at all. The valve that keeps the short paths honest: **any path becomes the full loop
the moment someone has to decide something nobody specified.** See the GUIDE's *Not every
ticket runs the full loop*.

| Phase | Agent | What it does |
| --- | --- | --- |
| [inception](aidlc/agents/inception/) | [`tcg-elaborator`](aidlc/agents/inception/tcg-elaborator.md) | Intent → sourced spec, then stops and asks. Never implements |
| | [`tcg-decomposer`](aidlc/agents/inception/tcg-decomposer.md) | Spec → vertical units that ship alone. Never builds |
| [construction](aidlc/agents/construction/) | [`tcg-executor`](aidlc/agents/construction/tcg-executor.md) | One unit → code. Stops where the spec stops |
| | [`tcg-analyst`](aidlc/agents/construction/tcg-analyst.md) | Reviews it, tagging every finding VERIFIED or INFERRED |
| [reflection](aidlc/agents/reflection/) | [`tcg-reflector`](aidlc/agents/reflection/tcg-reflector.md) | What the loop missed → proposed rule changes. Never applies them |
| [tools](aidlc/agents/tools/) | [`tcg-contract-tracer`](aidlc/agents/tools/tcg-contract-tracer.md) | An API shape changed — what breaks in web and mobile |
| | [`tcg-prisma-guardian`](aidlc/agents/tools/tcg-prisma-guardian.md) | Schema change — safe, isolated, efficient? Isolation first |
| — | [`tcg-scrum`](aidlc/agents/tcg-scrum.md) | Unblocks from written sources or escalates. Never guesses |

Model tier follows **how much judgement the task needs**, not seniority. Strong: elaborator,
decomposer, analyst, reflector, scrum. Mid: executor, contract-tracer, prisma-guardian.
Layout and tier reasoning in [`aidlc/agents/README.md`](aidlc/agents/README.md).

**Branching and commits.** One unit, one branch, one PR —
`<type>/SCRUM-###-u<n>-<slug>`, branched from `origin/main` and rebased onto it before
pushing. The executor enforces it; mechanics live in the `commit` skill.

**Templates** fix the field set for each artifact. A field is never deleted — an unfillable
one is marked, so a gap is visible rather than silent.
[`intent`](aidlc/templates/intent.md) · [`spec`](aidlc/templates/spec.md) ·
[`units`](aidlc/templates/units.md) · [`reflection`](aidlc/templates/reflection.md)

---

## 7. Conventions

- **Everything under `.ai/`.** Paths outside are symlinks created by `setup.sh`.
- **Never write to the client repo.** Not source, not config, not docs, not whitespace. If a
  change seems to require it, stop and raise it.
- **One branch per change**, merged by PR — matching this repo's history.
- **One fact, one home.** A fact in two files diverges. Link to the owner rather than
  restating it. This README goes first: it explains mechanism and links for content.
- **Verified and inferred are never blended.** Say which a claim is, and name the command
  that established it. This applies to the agents, the reviews, and these documents.

---

## 8. Known open items

Honest state, so nobody rediscovers them.

- **Nested-context loading is not yet confirmed by observation.** The root is. `/context`
  settles it in seconds (§4.2); it has not been run.
- **Antigravity's loading behaviour is unestablished** — reachable, but unproven (§4.3).
- **The loop has never run a real ticket end to end.** Written is not working.
- **`apps/web` does not glob its tests** — `package.json` passes 14 filenames explicitly, so
  a web test not hand-added never runs and nothing says so. Fix before trusting web coverage.
- [`aidlc/context-restructure-plan.md`](aidlc/context-restructure-plan.md) is **partly
  superseded** — its per-block disposition was written against a `CLAUDE.md` that has since
  been rewritten. Its PRE-FLIGHT 0 gate is answerable with `/context`.
- [`aidlc/skills-and-rails-analysis.md`](aidlc/skills-and-rails-analysis.md) is a **dated
  record**, deliberately not updated. It references files that no longer exist; that is what
  makes it evidence.
