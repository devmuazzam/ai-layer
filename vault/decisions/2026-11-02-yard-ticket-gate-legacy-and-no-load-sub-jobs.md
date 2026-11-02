---
title: "Yard-Operations ticket gate scope: legacy multi-shift loadouts are accepted with no backfill, and a no-load / employee-only sub-job is gated like any other (no special-casing) — decision"
source: decision/Syed Haris (CodingCops) — owner answers in the Claude Code session of YARD-TICKET-GATE, 2026-11-02 (spec §12 Q5, Q6)
decided: 2026-11-02
decided_by: >-
  Syed Haris (CodingCops), product owner and requester of the YARD-TICKET-GATE build
  (Owner on the spec: syedharis14@gmail.com / dev for Q5, syedharis14@gmail.com / dispatch
  for Q6), answering §12 Q5 and Q6 on 2026-11-02. tcg-scrum did not see the session; it
  records from the spec's §12 answers and §13. These are owner/developer directions for this
  build, recorded as `status: reference` the same way haris directions are recorded elsewhere
  in this folder: binding on the YARD-TICKET-GATE build, open to being overruled by the TCG
  product team.
status: reference
resolves:
  - YARD-TICKET-GATE/spec.md#q5
  - YARD-TICKET-GATE/spec.md#q6
conflicts_with: []
related_tickets:
  - YARD-TICKET-GATE
related_decisions:
  - 2026-11-02-yard-ticket-gate-stage-scope-and-card-lock.md
  - 2026-11-02-yard-ticket-gate-client-only-online-enforcement.md
tags: [module/field-ops, module/dispatch, kind/decision, ticket-workflow, das, loadout]
---

# Yard-Operations ticket gate: legacy data and no-load sub-jobs

Two scope edges of the per-shift gate were put to the owner on 2026-11-02.

## Decision

### Q5 — Legacy multi-shift loadouts completed before the per-shift column

**Accept, no backfill.** A sub-job whose shift 2 completed loadout before this deploy has no
per-shift `loadout_completed_shifts_at` marker, so after deploy `isShiftLoadedOut(…, 2)` reads
false and gate 2 would block that shift-2 ticket's Left Yard. We accept that rather than
backfilling the column from `SubJobLoadoutItem.loadoutAt`. Live tickets at deploy are almost
all COMPLETE, so gate 2 never fires on legacy shift-2 rows; historical rows fall back to the
shift-1-only legacy branch.

### Q6 — No-load / employee-only sub-jobs

> **SUPERSEDED 2026-11-02 by Q7 = B (owner).** Q6 = C below was found unreachable: a no-load
> sub-job can never Mark Available or complete Loadout, so "waits for a yard action" meant
> "blocked forever". The owner reversed it to **B — do not gate a no-load sub-job**: the mapper
> sends `yardGate: null` when the job has nothing loadable
> (`buildLoadoutAssetCatalogEntries(job.resources)` empty **and** no `job.tools`), the same catalog
> the yard builds. Built on branch `fix/yard-ticket-gate-no-load`. The original Q6 = C reasoning is
> kept below for the record.

**(Superseded) The gate stays; no special-casing, no mapper change.** A non-holdover ticket whose sub-job
has nothing loadable (the yard UI disables Mark Available and `completeLoadout` rejects an empty
loadout) is **not** exempted and is **not** given a `yardGate: null` from the mapper. No
loadable-item signal is introduced. Such a ticket waits for a yard action to mark it available,
like any other ticket. Rejected: option A (never gate a no-load sub-job) and option B (a yard
"release without loadout" action).

## Why

- **No backfill (Q5)** because the case it would fix — a legacy shift-2 row that is not yet
  COMPLETE at deploy — is vanishingly rare, and a backfill adds data and needs a staging-copy
  dry run for no live benefit. The shift-1 legacy fallback covers historical reads.
- **Gate stays (Q6)** because inventing a "no-load" signal (counting loadable asset/tool items)
  or a new yard release action is more machinery than the gate warrants, and either would be a
  guessed product behaviour. The accepted trade-off is that a no-load / employee-only sub-job
  cannot start until the yard marks it available — the same wait every other ticket has.

## Effect on the vault

- No vault file changes status. These are scope decisions internal to the YARD-TICKET-GATE
  build; no vault conflict is resolved and no loadable-item mapper change is made.
- `.ai/aidlc/YARD-TICKET-GATE/spec.md` §12 Q5 and Q6 `Status:` lines now point at this note —
  done in the same pass. Note: §12 holds two Q6 blocks (the resolved "C" answer and an older
  "open" duplicate); both are pointed at this note so no stale `Status: open` is left behind.
