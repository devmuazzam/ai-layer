# Reflection — SCRUM-877 Labor & Unit Details

## 0. Context

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-877` |
| Spec | `.ai/aidlc/SCRUM-877/spec.md` |
| Units | U1, U2, U3, U4, U5, U6 — *all shipped* |
| Reflected on | `2026-08-24` |
| Reviewer(s) | devmohsinakram |
| Open questions at build time | 0 |
| `[UNVERIFIED]` requirements built | 0 |
| Unverified × irreversible | 0 |

## 1. Spec defects — what the spec missed

### SD-1 — Stale Labor Hours when Ticket Work Timestamps update post-labor entry

- **Where:** REQ-01 / REQ-07 (Labor Hours calculation)
- **What the executor needed to know:** How to resolve labor total hours when a crew member's ticket `startedWorkAt` or `endedWorkAt` is updated after an initial labor entry is created.
- **What the spec said:** `nothing` (implied calculation was one-off at entry creation).
- **What was decided instead, and by whom:** In `TicketLaborEntriesService`, prioritize `m.startedWorkAt` / `m.endedWorkAt` from `jobTickets` over `existingEntry.boomStartedAt` / `existingEntry.boomEndedAt` so crew labor hour totals dynamically recalculate on step reads (`getCrewForTicket`) and single ticket reads (`getEntryForTicket`).
- **Was the decision right:** Yes — verified by mobile crew view rendering updated 1.0 hr labor instead of stale 0.5 hr entry.
- **Cost:** A post-ship bug fix commit (`62ba22a8`).
- **Class:** missing-requirement
- **Fix:** Update API service calculation rules to state that ticket milestone timestamps override persisted labor entry boom timestamps when ticket milestones are newer.

### SD-2 — Dynamic Crane Main Boom Length Bracket Suggestion

- **Where:** REQ-05 / REQ-08 (Craft Modifier bracket selection)
- **What the executor needed to know:** How to dynamically match the suggested bracket when no crane asset or main boom length is specified.
- **What the spec said:** Hardcoded suggestions on mobile.
- **What was decided instead, and by whom:** Query the set's assigned crane asset `mainBoomLength` server-side, map to the 16-row rate table bracket, and fallback to `OI-BP-00` / `OP-BP-00` ("No Pay") if no main boom length is set on the crane asset.
- **Was the decision right:** Yes — matches dynamic business rule requirements.
- **Cost:** Minor patch commit (`54646026`).
- **Class:** missing-requirement
- **Fix:** Update bracket matching documentation to detail the asset lookup and "No Pay" fallback behavior.

## 2. Executor defects — what was built against the spec

### ED-1 — Prisma Scoping Allowlist Conflict on Rebase

- **Where:** `apps/api/src/orm/prisma.service.ts`
- **Spec said:** N/A (repository architecture rail)
- **Built:** A merge conflict occurred during rebase where `ticketlaborentry` was removed from the allowlist.
- **Caught by:** Integration testing / rebase review.
- **Class:** tenancy-gap
- **Fix:** Resolved allowlist in `prisma.service.ts` keeping `ticketlaborentry`, `ticketlunchbreak`, and `vendorcontact`.

## 3. Source and vault findings

- **Sources that turned out to be wrong or stale:** Mobile `LaborBody.tsx` initially used mock `RAW_CREW` and hardcoded `SUGGESTED_BOOM`.
- **Conflicts that surfaced only during build:** None.
- **Questions answered by a named human during the build:** None.
- **`gaps.md` entries this ticket should close:** None.
- **`gaps.md` entries this ticket opened:** None.
- **Undefined terms hit:** None.

## 4. Rule changes proposed

| # | File | Section | Exact change | Prevents | Accepted |
| --- | --- | --- | --- | --- | --- |
| R1 | `.ai/claude/contexts/api.md` | `TicketLaborEntries` | Prioritize `jobTickets` timestamps over stale persisted entry boom times | SD-1 | applied |

## 5. Recurrence check

| Defect | Class | Prior rows | Occurrence | Why the previous fix did not hold |
| --- | --- | --- | --- | --- |
| SD-1 | missing-requirement | none | 1st | N/A |
| SD-2 | missing-requirement | none | 1st | N/A |
| ED-1 | tenancy-gap | none | 1st | N/A |

- **Escalate:** None.
- **New class added to the index?** No.
- **Rows appended to `reflections/INDEX.md`:** Yes.

## 6. Kept as-is

- `lunchesTakenCount` and `wtlCount` persistence — persisted on `TicketLaborEntry` and used in `computeLaborHours`.
