# Reflection — SCRUM-### <feature name>

> Written to `.ai/aidlc/SCRUM-###/reflection.md` after the units ship, before the ticket
> closes. Consumed by the reflector.
>
> **Skeleton only in this run** — the reflector agent that fills it does not exist yet.
> The field list is the contract; treat it as fixed.

## What this is for

Three questions, in this order:

1. **What did the spec miss?** — the executor had to decide something the spec did not
   settle. Every such decision is a spec defect, whether or not the guess was right.
2. **What did the executor get wrong?** — it had the answer in front of it and did
   something else.
3. **Which rule needs updating?** — the thing that would have prevented it, written where
   the next person will actually read it.

A reflection that finds nothing is a valid outcome roughly as often as a spec with no open
questions — which is to say, rarely. If every field says "none", check whether the ticket
was small or the reflection was.

**A guess that turned out right is still a spec defect.** Record it. The next guess in the
same hole will be wrong and nobody will know why it was allowed.

## Fill rules

Every field is required. **Never delete a field.** Unfilled fields take `NONE FOUND`,
`N/A — <reason>`, or `OPEN — <question>`.

Findings are attributed to artifacts, not people. "The spec did not state X" — not "the
dev forgot X".

---

## 0. Context

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-###` |
| Spec | `.ai/aidlc/SCRUM-###/spec.md`, elaborated `YYYY-MM-DD` |
| Units | U1…Un — *shipped / partially shipped / abandoned* |
| Reflected on | `YYYY-MM-DD` |
| Reviewer(s) | |
| Open questions at build time | *count; how many were answered before the executor started* |

## 1. Spec defects — what the spec missed

One block per defect.

### SD-1 — <short name>

- **Where:** REQ-nn, or *"nowhere — the spec has no section for this"*
- **What the executor needed to know:**
- **What the spec said:** *quote it, or `nothing`*
- **What was decided instead, and by whom:** *the executor / a dev in review / a product
  reply that never made it back into the spec*
- **Was the decision right:** yes / no / still unknown — *and how we know*
- **Cost:** *rework, a wrong migration, a review round, or nothing yet*
- **Class:** missing / ambiguous / contradicted a source / sourced from the wrong file /
  laundered an unverified source as settled
- **Fix:** *which template or agent field would have caught it — see §4*

## 2. Executor defects — what was built against the spec

### ED-1 — <short name>

- **Where:** *file path(s)*
- **Spec said:** *quote REQ-nn*
- **Built:**
- **Caught by:** review / tests / production / not yet caught
- **Class:** ignored a stated requirement / invented behavior the spec marked `[OPEN]` /
  broke a layering rule / duplicated an existing component / skipped the migration /
  wrong identity convention / other
- **Fix:** *rule change, guard, lint, or test — see §4*

## 3. Source and vault findings

What the build learned about the documentation itself. This is the feedback path into the
vault, and it is the one most often skipped.

- **Sources that turned out to be wrong or stale:** *path — what it says — what is true*
- **Conflicts that surfaced only during build:** *path(s) — new `gaps.md` entry?*
- **Questions answered by a named human during the build:** *these must land in
  `.ai/vault/decisions/YYYY-MM-DD-topic.md` or they are lost. Written? yes / no*
- **`gaps.md` entries this ticket should close:** *anchor — and the exact frontmatter edits
  still needed on the winning/losing files*
- **`gaps.md` entries this ticket opened:**
- **Undefined terms hit:** *from the known nine, or new*

## 4. Rule changes proposed

The output that matters. Each row must be specific enough to apply without rewriting.

| # | File | Section | Exact change | Prevents | Accepted |
| --- | --- | --- | --- | --- | --- |
| R1 | `.ai/claude/rules/prisma.md` | *heading* | *add/change this line* | SD-1 | pending |
| R2 | `.ai/aidlc/templates/spec.md` | *§n* | *add this required field* | SD-2 | pending |
| R3 | `.ai/aidlc/agents/tcg-elaborator.md` | *§n* | | ED-1 | pending |

- **Rejected proposals, and why:** *keeping these stops the same idea being re-proposed
  every sprint*

## 5. Recurrence check

- **Has this appeared in an earlier reflection?** *list the ticket ids*
- **If yes, why did the previous fix not hold:** *the rule was not written / was written in
  a file nobody reads / was written and ignored*
- **Escalate:** *when the same defect class recurs a third time, it is not a reminder
  problem — say what structural change is needed (a lint rule, a guard, a template field,
  a check in the executor's own instructions)*

## 6. Kept as-is

Things that looked wrong and are not. Recording them stops the next reflection re-opening
a settled question.

- *thing* — *why it is correct*
