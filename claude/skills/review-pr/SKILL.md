---
name: review-pr
description: Review a PR, branch or diff against both the code conventions and the product record in the vault. Use when reviewing a pull request, a branch, uncommitted changes, or before merging.
---

Review a change on three axes: **does it do what the product record says**, **is it built
the way this codebase requires**, and **what already-working behaviour does it reach**. The
middle one is well covered elsewhere. The first is the one nobody does, and it is where the
expensive defects live; the third is where the last two weeks' defects actually landed —
changes that were correct about their own feature and broke something adjacent.

For a unit built through AI-DLC, `tcg-analyst` owns the verdict — use this when reviewing
ad-hoc work, someone else's PR, or a branch with no unit behind it.

## 1. Establish the diff, and what it claims to do

```bash
git fetch origin && git diff origin/main...HEAD --stat
git log --oneline origin/main..HEAD
```

Find the ticket. If the branch names one (`feat/SCRUM-757-u1-…`), read it. If there is a
spec at `.ai/aidlc/SCRUM-###/spec.md`, that is the contract and it outranks your judgement
about what the feature should do.

## 2. The vault pass — what the product record says

**Retrieval order, always:** `.ai/vault/INDEX.md` → the conflict stub for the topic if one
exists → the specific file. Never grep straight to a content file; that is how you end up
quoting one side of an unresolved disagreement as settled fact.

For each behaviour the diff introduces or changes, ask what the vault says about it, and
report one of four outcomes:

| Outcome | What to write |
| --- | --- |
| **Sourced** | Cite the vault-root-relative path and its `status:`. Almost everything is `unverified` — say so; do not present it as settled |
| **Conflicted** | The topic has a conflict stub or the file's `conflicts_with` is non-empty. **Name every candidate. Do not pick one.** The diff may have implemented one side without knowing the other existed |
| **Unsourced** | The vault says nothing. This is common and it is a finding, not a gap in your search — record what you looked at |
| **Contradicted** | The diff does something the vault says otherwise about. The highest-value finding available here |

**Never treat the vault as approval.** A file being `unverified` means nobody adjudicated
it — so "the vault agrees" is weaker evidence than it sounds, and "the vault disagrees" may
mean the vault is stale. Report the disagreement; do not adjudicate it.

If the change turns on something nobody has written down, name it in the review as
Unsourced rather than assuming the author knew. `.ai/vault/gaps.md` is retired — do not
append the question there; there is no register for it until the per-module gaps redesign
lands.

**Every Unsourced finding gets handed to `tcg-scrum` before the review is finalized, not
just named and left.** The reviewer is the backstop when a dev pushes an unsourced rule
without ever routing through AI-DLC — if this review doesn't escalate it, nothing will.
Spawn `tcg-scrum` with the specific behaviour and where you already looked; report its
verdict in the output (see §7) rather than re-deciding it yourself. Three outcomes:
- It sources the rule from something you missed → fold that into **Sourced**, not Unsourced.
- It confirms nobody decided it and escalates → keep it **Unsourced**, note that `tcg-scrum`
  also couldn't source it, and that it needs a human decision before or shortly after merge.
- A human decision surfaces during escalation → `tcg-scrum` writes it to
  `.ai/vault/decisions/`; cite that path instead of Unsourced.

Two standing traps:

- **`FR-FOP-NNN` ids are ambiguous.** Both field-ops FRDs number from `001`. A PR citing a
  bare `FR-FOP-013` has cited nothing — ask which document.
- **`meetings/` is retrospective**, never a commitment. Do not review against it.

## 3. The loop trail — did this ticket go through AI-DLC at all

`.ai/aidlc/processed.log` gets one line per ticket at branch creation, on every path
(A/B/C) — it is the only artifact that distinguishes "correctly skipped the full loop" from
"never touched the loop." Check it for this ticket:

```bash
grep -i '<SCRUM-###>' .ai/aidlc/processed.log
```

- **No entry, and no `.ai/aidlc/SCRUM-###/` folder** — the ticket left no trail at all. Say
  so in the output as its own line; do not silently treat it as "must have been Path C."
  This is exactly the situation the reviewer exists to catch when a dev doesn't push through
  the setup themselves.
- **No entry, but the diff decides something nobody specified** — a value, threshold,
  default, or rule with no ticket and no vault source — that is the escalation trigger from
  `.ai/aidlc/GUIDE.md` ("you catch yourself writing a value nobody stated"). Treat every such
  behaviour as Unsourced (§2) and route it to `tcg-scrum` per that section, regardless of
  which path the PR actually took.
- **Entry exists** — note the path taken; if it's Path A, the `spec.md`/`units.md` for that
  ticket outrank your own judgement per §1.

## 4. The code pass

Check against `.ai/claude/contexts/<surface>.md` for whatever the diff touches, not against
memory. Then the standing hazards, each silent and each unenforced:

- **Isolation** — a new model holding tenant data must be in the scoping allowlist in
  `prisma.service.ts`. Scoping is conditional. Delegate depth to `tcg-prisma-guardian`.
- **API contract** — a changed DTO or response shape is not compile-checked outside
  `@tcg/shared`. Delegate to `tcg-contract-tracer` rather than eyeballing the callers.
- **Migration** — schema moved without a committed migration is incomplete, not pending.
- **Timestamptz** — new timestamp columns; ~285 existing columns use it.
- **Enum exhaustiveness** — a new enum member needs every `switch` updated.
- **Test IDs** — web UI in the diff: new controls and state regions carry a
  `data-testid`, and no *existing* one was renamed or dropped without its spec.
  `qa-automation/` binds to them and no gate runs it, so the grep is the only signal.
- **Reuse** — a new component that already exists somewhere in the nine `components/`
  directories. Search `ui/`, `base/`, `atoms/`, `molecules/`, `patterns/` — not just the
  atomic tiers.

Each of these is a question about the diff. *Who else consumes what it changed* is §5, and
the two are not the same check: a DTO can be correct, conventional and still break three
screens that are not in the diff.

## 5. The ripple pass — what else this change reaches

Everything above asks whether the diff is right about **its own** feature. This asks the
question the last two weeks kept answering the expensive way: **what already worked that
this change reaches?** A ripple defect is invisible in a diff review, because the file that
broke is not in the diff.

The pass is mechanical, and it is not optional. For every symbol, shape, column, component,
filter or config the diff **changes, retypes or removes**, enumerate the consumers with a
command. Added-only is a smaller radius, not a zero one — a new enum member, a new required
field, a new allowlist row and a new required prop all ripple.

| The diff touches | Ripples to | Enumerate with |
| --- | --- | --- |
| `packages/shared` — any export | web **and** mobile, both, always. Both consume the built `dist/`, so a stale local build hides the break | `git grep -rn '<symbol>' apps/web/src apps/mobile packages` |
| A DTO or response shape | Every web and mobile caller. Only files importing `@tcg/shared` are compile-checked; the rest fail at runtime | delegate `tcg-contract-tracer` — do not eyeball callers |
| A Prisma field renamed, retyped or dropped | Every `select`/`include`/`where` naming it — seeders, fixtures and reports included | `git grep -rn '<field>' apps packages` |
| A new enum member | Every `switch`, mapping table, badge and label map, on both front-ends | `git grep -rn '<EnumName>' apps packages` |
| A unit, format or id representation — feet-inches, currency, `generateId()` | Every producer **and** consumer of that value on all four projects. Longest reach, weakest compile-time signal | `git grep -rn '<field>' apps packages` |
| A shared component in one of the nine `components/` dirs | Every render site. The diff shows one; the grep shows the rest | `git grep -rln '<ComponentName>' apps/web/src` |
| A `data-testid`, or the element carrying one | Every spec addressing it. Renaming an ID is a silent break — the suite is not an Nx project, so no hook and no CI job runs it | `grep -rn '<the-id>' qa-automation/e2e` |
| A query filter, guard, role or visibility rule | Every route and list built on that method. A filter loosened for one screen is loosened for all of them | `git grep -rn '<serviceMethod>' apps/api/src` |
| An extracted, renamed or "cleaned up" helper | Its **pre-existing** callers — the ones that gained no test in this diff | `git grep -rn '<fn>' apps packages` |
| Env, seed, docker or build config | Whatever reads it at **build** time. Mobile inlines `EXPO_PUBLIC_*` at build, so a dev-correct read can ship broken | name the build that would have caught it |
| Sidebar, nav, route or permission config | Every module entry under it, not just the one being fixed | `git grep -rn '<config file>' apps/web/src` |

Two judgements per ripple target, and both belong in the output:

- **Covered, or not.** Is there a test that fails if this consumer broke? A test written for
  the **new** call site does not cover the **old** one. "Existing consumer, no regression
  coverage" is a finding by itself, and it is the one that has been shipping.
- **Intended, or not.** A behaviour change reaching an existing consumer is either in the
  ticket or it is not. If no spec line, ticket or vault file mentions that consumer, the
  change to it is **Unsourced** — route it through §2 like any other, including the
  `tcg-scrum` hand-off.

**Green is not evidence of no ripple.** The pre-push and CI gates run `nx affected` with
**web excluded from lint and mobile excluded from typecheck** (`CLAUDE.md` → Commands) — the
two surfaces most often on the receiving end. Nothing lints a module boundary, and no gate
notices that a filter now returns rows it used to hide. The grep is the evidence; a ripple
target you did not enumerate with a command is **INFERRED**, and must say so.

## 6. Tag every finding

- **VERIFIED** — you ran something. Name the command and its result.
- **INFERRED** — you read and concluded. Say what you read.

Never both in one sentence. `file:line` precision does not upgrade an inference into a
fact — a finding that looks tool-produced but was reasoned is the one that gets acted on
wrongly.

**Know what green means here.** `pnpm lint` enforces no module boundaries, no duplication,
no hardcoded colour, and treats `any` as a warning. It also fails on ~14 pre-existing errors
in `apps/web`, so establish which failures belong to this diff before reporting any.

## 7. Output

```
PR review: <branch> → main   (<n> files, ticket <SCRUM-###|none>)

LOOP TRAIL — .ai/aidlc/processed.log
  <entry found: path taken | no entry, no folder — untracked | no entry, folder exists — inconsistent>

PRODUCT — against the vault
  Sourced:      <behaviour> — <path> — status: <verified|unverified>
  Conflicted:   <behaviour> — candidates: <paths> — conflict stub, or gaps.md#<anchor> if a pre-retirement entry already covers it — NOT adjudicated
  Unsourced:    <behaviour> — searched: <what> — tcg-scrum verdict: <sourced it | confirmed unsourced, escalated | recorded a decision at <path>>
  Contradicted: <behaviour> — vault says <x>, diff does <y> — <path>

RIPPLE — what already shipped that this reaches
  <target> — reached via <shared export | DTO | schema field | component | filter | config>
      enumerated by: <command>   consumers: <n>   regression coverage: <test path | none>
      intended: <spec/ticket line | not mentioned anywhere — treated as Unsourced above>
  <or "none — the diff adds only new surfaces, established by: <command>">

CODE — most consequential first
  [VERIFIED] <file:line> — <finding> — established by: <command>
  [INFERRED] <file:line> — <finding> — reasoned from: <what>

Gates: <command> → <result>   (pre-existing failures excluded: <n>)
Delegated: <contract-tracer / prisma-guardian / tcg-scrum verdicts, or "none needed">

Verdict: <ship | ship with follow-ups | do not ship — one reason>
Follow-ups, out of scope for this PR: <list>
```

Anything **Contradicted**, or any isolation finding, goes first. A ripple target with no
regression coverage caps the verdict at **ship with follow-ups**; an unintended one — an
existing consumer whose behaviour changes and which no source mentions — is **do not ship**
until someone says it was meant to.

## 8. Rules

- **Report, never fix.** A reviewer who edits is no longer reviewing.
- **Refute your own findings once** before writing them. Is that "upward import" the
  sanctioned `*.module.ts` → controller exception? Is that "missing migration" a diff that
  touched no schema? Findings that do not survive are dropped, and worth saying you dropped.
- Improvements beyond the PR's scope are follow-ups, listed separately. A reviewer who grows
  the PR has made it harder to merge and no safer.
- **A ripple target is not scope growth.** Code the diff breaks is the diff's problem, however
  far from the ticket it sits. Report it in RIPPLE, not in follow-ups — follow-ups are for
  things that would be *better*, never for things that are now *broken*.
