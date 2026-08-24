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

.claude/agents/tcg-*.md              -> ../../aidlc/agents/<phase>/...  (flat index)
.cursor/{skills,agents}/*            -> ../../.ai/...    (LOADED, not a mirror)
.agents/{skills,agents}/*            -> ../../.ai/...    (LOADED — Antigravity default)
.agent/{skills,agents}/*             -> ../../.ai/...    (LOADED — Antigravity legacy)
{.cursor,.agents,.agent}/contexts/*  -> ../../.ai/...    (reference mirror)
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

It no longer touches git hooks. Since the client repo's Nx merge (PR #363, 2026-08-19) the
hooks are tracked in `.husky/` and `pnpm install` wires them (`core.hooksPath=.husky`); the
overlay used to install a competing pre-push in `.git/hooks`, which is why re-running after
`pnpm install` was once required. `setup.sh` now only repairs a machine that still points at
the old location, and prunes its own stale hook files.

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
| **Claude Code** | root `CLAUDE.md` + nearest `apps/*/CLAUDE.md`; `.claude/skills/`, `.claude/agents/` | **verified** |
| **Cursor** | root `AGENTS.md` + nearest `apps/*/AGENTS.md`, nearest wins; `.cursor/skills/`, `.cursor/agents/` | contexts **verified** 2026-08-11; skills/subagents **verified on a real install** 2026-08-19 |
| **Antigravity** | root `AGENTS.md`/`GEMINI.md` + nested `AGENTS.md`; `.agents/skills/`, `.agents/agents/` | **wired, unconfirmed** — nobody has run it |

**Skills and subagents are no longer a Claude Code exclusive.** Cursor shipped Agent Skills
and Subagents, and Antigravity shipped Skills (IDE 1.14.2) and Subagents (2.0, I/O 2026).
All three now discover the same two shapes:

- a skill is `skills/<name>/SKILL.md`, frontmatter `name` (**must** match the folder) and
  `description`. Auto-invoked: the tool preloads every description and pulls in the body
  when it judges one relevant. This is why descriptions here are written as trigger
  phrasing ("Use when…") rather than summaries.
- a subagent is `agents/<name>.md`, **flat**, with YAML frontmatter. The overlay stores
  agents nested by phase, so `setup.sh` flat-links them per surface — mirroring the phase
  tree publishes directories, and every tool finds nothing. See `link_agents`.

**Surface directories are not one per tool.** `.agents/` (plural) is Antigravity's current
default *and* a second path Cursor scans for skills — it is becoming the cross-tool
standard. `.agent/` (singular) is Antigravity's legacy path: still supported, no longer the
default, still written so a machine on an older build loses nothing. `setup.sh` writes all
of `.cursor/`, `.agents/`, `.agent/`, and derives the `.git/info/exclude` entries from the
same list — gitignore patterns are exact, `/.agent/` does **not** cover `/.agents/`, and
hand-maintaining the two lists was one typo away from publishing the layer.

**This was broken here until 2026-08-19**, and all 22 checks in `verify.sh` passed
throughout: `.cursor/agents/` held four phase directories, a README and one stray agent, so
Cursor could discover one agent of eight and would have read `examples/` as real ones.
`verify.sh` now asserts the flat shape and the skill `name`/folder match on every surface —
the check that would have caught it.

**Cursor still does not use `.cursor/rules/`.** Its rules system reads `.mdc` only and
ignores `.md`, so an earlier version of this layer that mirrored `.md` rules there was never
read at all. That is Cursor's **rules** system and it says nothing about skills or
subagents — which load from the paths above, in `.md`. Conflating the two is what kept this
layer manual on Cursor for months longer than it needed to be.

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
| [`close-ticket`](claude/skills/close-ticket/SKILL.md) | A PR merged — the writeback: reflection, gap disposition, decision notes, push the overlay. **The loop's tail; currently its least-run step** |

Two exist because of measured failures rather than general good practice: `pnpm lint` fails
before you touch anything, and `components/ui` has more importers than any atomic tier — so
the search the old docs prescribed missed the largest source in the app.

### Vault — product knowledge

**Retrieval is index-first, always — and two hops since the 2026-08-24 reorg.** Name the
module, read `vault/<module>/INDEX.md`, follow where it points; for cross-cutting material
search tags, not prose (`grep -rl 'module/dispatch' vault/meetings/`). Where a topic has
competing sources the index routes you to a conflict stub rather than one side of an
unresolved disagreement. Opening a content file directly is how an agent ends up quoting a
candidate as settled fact.

| File | What it is |
| --- | --- |
| [`vault/INDEX.md`](vault/INDEX.md) | **The entry point** — a router to the module indexes. Read before any content file |
| [`vault/STRUCTURE.md`](vault/STRUCTURE.md) | **How the vault is organized** — one folder per product module (mirroring the backend), the Obsidian tag facets (`module/x`, `kind/y`), where a question goes, and the old→new migration map |
| `vault/<module>/` | Ten module folders (`payroll/`, `dispatch/`, `field-ops/`, `quotations/`, …), each with its own `INDEX.md`, sources, and a **live `gaps.md`** |
| [`vault/payroll/rules/`](vault/payroll/rules/INDEX.md) | **The payroll rule register** — 73 canonical `PAY-###` rules, each joining matrix + FRD + legacy engine + contract + conflicts. The build's entry point for payroll |
| [`vault/decisions/`](vault/decisions/) | Dated, named-human decisions — the only thing that makes an answer durable. Written by `tcg-scrum` |
| [`vault/README.md`](vault/README.md) | Migration conventions, frontmatter, deliberate exclusions |
| `vault/gaps.md` · `vault/payroll/gaps-2026-08-20-retired.md` | **Retired, frozen** registers — open entries were dispositioned into the module `gaps.md` files (2026-08-24); citable by anchor, never appended |
| [`vault/sync/confluence-sync.md`](vault/sync/confluence-sync.md) | How the vault tracks a source that keeps moving — **bootstrap run executed 2026-08-24** (`sync/manifest.json`, 40 pages tracked) |
| [`vault/meetings/`](vault/meetings/) | Sprint plans and curated client minutes, plus three raw-material subfolders: `transcripts/`, `summaries/`, `assets/` — see `vault/README.md` § Folders |

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

Model tier: **Sonnet by default for every agent, Opus by explicit per-run escalation.** Only
`tcg-scrum` stays on Opus. Each agent's *Model tier* section names when one Opus run is worth
it. Reasoning in [`aidlc/agents/README.md`](aidlc/agents/README.md); the budget rules in §10
below and [`aidlc/GUIDE.md`](aidlc/GUIDE.md) §14.

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

## 8. Is it working?

[`SUCCESS.md`](SUCCESS.md) — the baseline numbers with the exact commands that produce them,
the leading signals to read off real artifacts, how this dies quietly, the five missing rails
that would make the numbers hold, and the one falsifiable question that decides whether the
discipline is worth its cost.

Short version: the layer's core claim is that stopping instead of guessing is cheaper.
That is testable — *does an `[OPEN]` marker ever get answered and turn out to have
mattered?* — and you will know inside two or three tickets.

## 9. Known open items

Honest state, so nobody rediscovers them.

- **Nested-context loading is not yet confirmed by observation.** The root is. `/context`
  settles it in seconds (§4.2); it has not been run.
- **Antigravity's loading behaviour is unestablished** — reachable, but unproven (§4.3).
- **The loop is half-running (audited 2026-08-24).** Entry side works: five tickets in
  `aidlc/processed.log` (paths B/C — fouzan, areeba), specs with §12, five decision notes
  written back, SCRUM-903 shipped through spec → review → decision → merge. **The tail has
  never run**: `reflections/INDEX.md` has zero rows — no merged ticket has had its
  `close-ticket` writeback, so the third-occurrence rule protects nothing yet. Also missed:
  `scrum-873` and `sync-fcc-data-with-tcg` merged with **no ledger row and no folder**
  (the latter also breaks branch naming), and the ledger's `pr` column is never backfilled
  after merge. Path A (full spec → decompose → units) is still unexercised.
- **`apps/web` does not glob its tests** — `package.json` passes 14 filenames explicitly, so
  a web test not hand-added never runs and nothing says so. Fix before trusting web coverage.
- [`aidlc/context-restructure-plan.md`](aidlc/context-restructure-plan.md) is **partly
  superseded** — its per-block disposition was written against a `CLAUDE.md` that has since
  been rewritten. Its PRE-FLIGHT 0 gate is answerable with `/context`.
- [`aidlc/skills-and-rails-analysis.md`](aidlc/skills-and-rails-analysis.md) is a **dated
  record**, deliberately not updated. It references files that no longer exist; that is what
  makes it evidence.

---

## 10. Token budget — running the loop on a $20 plan

Every seat on the team is on a Pro-tier plan. The loop as first written assumed the top model
tier on five of eight agents and treated context as free; people were hitting their window
mid-unit. This section is the guide for staying inside it, on every tool. The owner of these
rules is [`aidlc/GUIDE.md`](aidlc/GUIDE.md) §14 — this is the same content, kept here so a new
person meets it before their first ticket.

### 10.1 What actually costs

- **The fixed context is cheap.** `CLAUDE.md`, the surface context, an agent's own prompt —
  sent once, cached. Trimming those helps a little; it is not where the budget goes.
- **What you read into the conversation is expensive**, because it is re-sent on every turn
  after that: an 88 KB gaps register read whole, a 40 KB spec, a full `git diff` of a long
  branch, a pasted log.
- **The model is a multiplier on all of it.** An Opus turn draws roughly five times what a
  Sonnet turn does from the same window.

So the two levers, in order: **which model**, then **what you read**.

### 10.2 The seven rules

1. **Sonnet is the default — every agent, every session.** `tcg-elaborator`,
   `tcg-decomposer`, `tcg-analyst`, `tcg-reflector`, `tcg-contract-tracer` and
   `tcg-prisma-guardian` declare `model: sonnet`. `tcg-executor` inherits the session, so
   **set the session to Sonnet before invoking it**. Only `tcg-scrum` stays on Opus — it runs
   rarely and briefly. Escalate to Opus **for one run, explicitly** ("run tcg-elaborator on
   opus") when the agent's own *Model tier* section says so: the ticket touches an open
   conflict, is payroll or ADP, the unit touches `prisma`/tenancy/auth, or the reflector sees a
   third occurrence. Never by changing the default back.
2. **Read by section, never whole.** The module `gaps.md` registers, the retired snapshots, any spec over
   ~15 KB, any vault file over ~20 KB: `grep -n '^#'` first, then `sed -n` the section you
   need. The only vault file meant to be read whole is `vault/INDEX.md`, and it is a routing
   table — follow its pointer, do not also read the neighbours.
3. **One unit per session.** A fresh session (Claude Code) or chat (Cursor, Antigravity) per
   unit and per phase boundary. `units.md` is written to be read cold; if it is not, that is a
   decomposer defect for the reflector, not a reason to keep one long session.
4. **Pick the path before the agent.** Path B (bug) and C (small change) in the GUIDE's *Not
   every ticket runs the full loop* exist because running inception on a bug is the most
   expensive way to learn the answer was already on the ticket.
5. **Tail, do not paste.** The last 40 lines of a log, the failing test, `git diff --stat`
   then one file. The agent can ask for more.
6. **Worked examples are on demand.** Each loop agent's three examples live in
   [`aidlc/agents/examples/`](aidlc/agents/examples/) and are read only when a case is
   ambiguous. Do not paste them back into a prompt.
7. **Search with a cheap reader.** Claude Code: broad "where is X used" questions go to the
   built-in read-only Explore agent, not the main session. Cursor: codebase search or `@` a
   specific file — never `@` a whole folder such as `.ai/vault` or `.ai/aidlc`.

### 10.3 Per tool

| | Model | Session hygiene | Check |
| --- | --- | --- | --- |
| **Claude Code** | `/model sonnet` at start. Agents carry their own `model:`; override per run by asking for it. | `/clear` between units. `/compact` if `/context` shows >60% before a long phase. Disable MCP servers and plugins this repo does not need — every attached server adds tool schemas to every session (`claude mcp list`, `/plugins`). | `/context` at start, `/usage` at end. |
| **Cursor** | Model picker per chat: a Sonnet-class model or *Auto* for executor and analyst. **MAX mode off** for loop work. | New chat per unit. Skills and subagents are auto-invoked — ask for the task, not the file; `/tcg-elaborator` or `/commit` to force one. `@` specific files, never folders. Root `AGENTS.md` is always attached, which is why nothing is added to it casually. | Cursor's usage page in settings. |
| **Antigravity** | Model picker per conversation, same rule as Cursor. | New conversation per unit. Skills and subagents are wired (§4.3) but unconfirmed on a real install — its planner delegates via `invoke_subagent` on the description rather than routing automatically, so expect to name an agent out loud more often. If a task that should reach for one does not, open `.agents/agents/tcg-*.md` by path and say so in `#ai-dlc`. | Its own usage view. |
| **GitHub Copilot** (if used) | Its model picker; Sonnet-class. | Reads root `AGENTS.md` and nested `apps/*/AGENTS.md` like Cursor does; the same read-by-section and one-unit rules apply. | — |

### 10.4 What changed on 2026-08-17, with numbers

| Lever | Before | After |
| --- | --- | --- |
| Agent model defaults | 5 of 8 on Opus, executor inherits | 1 of 8 on Opus (`tcg-scrum`); four loop agents on Sonnet; executor documented as "set the session to Sonnet" |
| `vault/gaps.md` | 88 KB, one register | 24 KB product + [`vault/payroll/gaps.md`](vault/payroll/gaps.md) 64 KB; both open with a read-by-section rule; all 57 entries kept |
| `vault/INDEX.md` | 24 KB | 19 KB — FR-FOP numbering → [`field-ops/fr-fop-numbering.md`](vault/field-ops/fr-fop-numbering.md), tags → [`tags.md`](vault/tags.md), payroll narrative and sprint-plan rows collapsed to pointers |
| Agent prompts | examples inline | examples in `aidlc/agents/examples/` — elaborator 25→21 KB, scrum 21→15, executor 14→12, reflector 13→10, decomposer 12→10, analyst 11→10 |

### 10.5 Measure it

Ask each developer to run `/context` at session start and `/usage` at session end (or the
tool's usage page) for one week and post the numbers. Without a baseline nobody can tell which
lever moved the needle. **If the window is still the constraint after this, the next lever is
not more trimming** — it is moving the one or two people who run inception most onto a higher
plan, which is cheaper than the whole team stalling mid-unit.
