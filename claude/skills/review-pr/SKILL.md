---
name: review-pr
description: Review a PR, branch or diff against both the code conventions and the product record in the vault. Use when reviewing a pull request, a branch, uncommitted changes, or before merging.
---

Review a change on two axes: **does it do what the product record says**, and **is it built
the way this codebase requires**. The second half is well covered elsewhere; the first is
the one nobody does, and it is where the expensive defects live.

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
verdict in the output (see §5) rather than re-deciding it yourself. Three outcomes:
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
- **Reuse** — a new component that already exists somewhere in the nine `components/`
  directories. Search `ui/`, `base/`, `atoms/`, `molecules/`, `patterns/` — not just the
  atomic tiers.

## 5. Tag every finding

- **VERIFIED** — you ran something. Name the command and its result.
- **INFERRED** — you read and concluded. Say what you read.

Never both in one sentence. `file:line` precision does not upgrade an inference into a
fact — a finding that looks tool-produced but was reasoned is the one that gets acted on
wrongly.

**Know what green means here.** `pnpm lint` enforces no module boundaries, no duplication,
no hardcoded colour, and treats `any` as a warning. It also fails on ~14 pre-existing errors
in `apps/web`, so establish which failures belong to this diff before reporting any.

## 6. Output

```
PR review: <branch> → main   (<n> files, ticket <SCRUM-###|none>)

LOOP TRAIL — .ai/aidlc/processed.log
  <entry found: path taken | no entry, no folder — untracked | no entry, folder exists — inconsistent>

PRODUCT — against the vault
  Sourced:      <behaviour> — <path> — status: <verified|unverified>
  Conflicted:   <behaviour> — candidates: <paths> — conflict stub, or gaps.md#<anchor> if a pre-retirement entry already covers it — NOT adjudicated
  Unsourced:    <behaviour> — searched: <what> — tcg-scrum verdict: <sourced it | confirmed unsourced, escalated | recorded a decision at <path>>
  Contradicted: <behaviour> — vault says <x>, diff does <y> — <path>

CODE — most consequential first
  [VERIFIED] <file:line> — <finding> — established by: <command>
  [INFERRED] <file:line> — <finding> — reasoned from: <what>

Gates: <command> → <result>   (pre-existing failures excluded: <n>)
Delegated: <contract-tracer / prisma-guardian / tcg-scrum verdicts, or "none needed">

Verdict: <ship | ship with follow-ups | do not ship — one reason>
Follow-ups, out of scope for this PR: <list>
```

Anything **Contradicted**, or any isolation finding, goes first.

## 7. Rules

- **Report, never fix.** A reviewer who edits is no longer reviewing.
- **Refute your own findings once** before writing them. Is that "upward import" the
  sanctioned `*.module.ts` → controller exception? Is that "missing migration" a diff that
  touched no schema? Findings that do not survive are dropped, and worth saying you dropped.
- Improvements beyond the PR's scope are follow-ups, listed separately. A reviewer who grows
  the PR has made it harder to merge and no safer.
