---
title: Yard loadout — an unassigned asset/employee slot is not loadable; the card warns; Mark Available is disabled only when nothing at all is loadable — decision
source: decision/Syed Haris
decided: 2026-09-14
decided_by: >-
  Syed Haris (CodingCops developer; the ticket's reporter; git identity `hariscops`) —
  in-session during the SCRUM-LOADOUT-UNASSIGNED build (PRs #571, #573). A developer's
  defaults, not a product-owner decision: Dylan Masterson (yard) and Lisette Anzaldo (DAS)
  were not consulted. Recorded `status: reference` — binding on the build now, every item
  reversible in one file, and pending product confirmation (see *Who should confirm*).
status: reference
conflicts_with: []
provenance_note: >
  2026-09-15: Ehtesham Anwar approved branch `fix/15-sep`, which supersedes
  Q3 (employees as something to load), Q7(a) copy (drop "employees"), and
  REQ-04 assigned-row pre-tick. See
  decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md. Unassigned
  *assets* still not loadable; chip, REQ-10 Partial Loadout, and Q1/Q2/Q4–Q6/Q8
  stand.
resolves: aidlc/SCRUM-LOADOUT-UNASSIGNED/spec.md#12-open-questions--the-stop-and-ask-list (Q1–Q8) and #req-10 (the two reporter decisions)
jira: []
tags: [module/dispatch, module/assets, kind/decision, yards, loadout]
---

# Yard loadout: unassigned slots are not loadable, and the card says so

## Decision

**A DAS resource slot with no asset or employee allocated to it cannot be loaded out.** The
Yard Operations (Dylen) card warns before *Mark Available for Loadout*; the Start Loadout
(Phase-1) modal never lets such a row be ticked; the API rejects it regardless of the UI.
**Mark Available is disabled only when nothing at all on the shift is loadable** — and a
tool/rigging row with quantity > 0 counts as something to load, so a rigging-only or
trucking-only job stays markable.

The eight sub-answers, as built (`.ai/aidlc/SCRUM-LOADOUT-UNASSIGNED/spec.md` §12):

| # | Question | Answer |
| --- | --- | --- |
| Q1 | Unassigned row in the Phase-1 modal | **Shown, greyed, unselectable** — not hidden |
| Q2 | Override for an unassigned row | **Never selectable, no override.** The API hard-rejects (`400 Unassigned asset item: …` / `Unassigned employee item: …`, `apps/api/src/usecase/das-loadout/das-loadout.service.ts:298,330`); no override flag exists |
| Q3 | Do tool/rigging rows count as "assigned"? | **Excluded from the unassigned check** (chip, Phase-1 pre-selection, API guard apply to asset/employee slots only — a tool row has nothing to allocate; its failure mode is stock, already covered by the "exceeds available stock" warning). **But tools count as something to load**: the disable rule is *no assigned asset/employee slot **and** no tool row with quantity > 0* |
| Q4 | "Nothing assigned to load out." placement | **Modal footer, left of the Loadout button**; shown only when at least one asset/employee row is listed, every listed asset/employee row is unassigned, and no tool row is listed. The pre-existing "No assets or tools are available for loadout." body message still covers the no-rows case |
| Q5 | Camera button on an unassigned Phase-1 row | **Hidden** — nothing exists to photograph for a slot with no allocation |
| Q6 | `completeLoadout` toast fallback copy | **"Failed to complete loadout"** (sibling of "Failed to save photos"); the two API 400 messages above and `Nothing to load out for this shift.` (`:345`) are shown verbatim |
| Q7 | Chip and copy | (a) Disabled Mark Available tooltip: *"Nothing assigned to load out — assign assets, employees or tools first"*. (b) Confirm-modal needs-review row: *"<slot label>: Unassigned — no asset or employee is allocated to this slot."*, in the same bulleted list as the quantity warnings. (c) Chip tooltip groups slot labels with a count (*"Operator ×2, Load Trailer"*), first-seen order, no length cap; an employee slot with no DAS label reads "Employee". (d) Chip sits in the card header's badge row and, expanded, on the shift row's "Assets & Employees" heading; hidden while allocations load, at zero, and once the shift is DAS-stage-locked or workflow-complete. (e) The header chip is **shift-scoped to the card's `shiftNumber`** (shift 1 under "All"), the scope the "Shift ended" / "Riggings locked" badges already use |
| Q8 | Scope of the disable rule | Applies **only while the legacy CTA reads "Mark Available for Loadout"**; later states (Start Loadout / Off-load / Completed) keep their existing rules. While the job-resources / allocations queries are loading the rule does not fire; if the `/jobs/:jobCode` read fails the card sees zero slots and the rule *does* fire for a shift with no tool quantity |

**REQ-10 — "Partial Loadout"** (added by the reporter during U2 UAT): when a shift's loadout has
started but is not fully loaded, and the day is not completed or force-completed, the card's
status pill reads **Partial Loadout** instead of *Pending Offload* (multi-shift: any partial
shift → Partial). Two sub-decisions: **(a)** an unassigned asset/employee slot counts as *not
loaded*, so the pill stays Partial until offload completes and the Q7 chip explains why;
**(b)** it is a **label only — not a new filter bucket or chip**. The Yard Ops bucket set stays
with the open [`../dispatch/gaps.md`](../dispatch/gaps.md) → *DAS map job status buckets —
nine SubJob stages collapsed to four, and LOADOUT counted as pending*; this decision does not
touch it.

## Why

**The only client statement is a July punch-list line, and it says "not able".**
[`../dispatch/yard-operations-jz.md`](../dispatch/yard-operations-jz.md):16 (`status:
unverified`, updated 2026-07-15, 952 bytes — a bug list, not a specification): *"if assets /
people are not assigned – we should not be able to loadout that particular item"*, and :19:
*"Employee - unasisgned – weird ghost employees"*. That is the whole written record. It supports
the core rule and Q2 (never selectable) directly; it says nothing about row visibility, tools,
copy, placement, the camera, or when Mark Available is disabled.

**Tools are excluded because the system has no "assigned tool".** `subJob.job.tools` is
quantity-based inventory, not a `JobResource` slot with a `resourceAllocations` row — there
is nothing an unassigned check could test. Counting tools as *loadable*, on the other hand,
is what keeps trucking-only and rigging-only jobs markable, which Dylan asked to keep seeing
([`../meetings/transcripts/2026-05-12-loading-figma-demo.md`](../meetings/transcripts/2026-05-12-loading-figma-demo.md):161-172
— *"I would still need to look at some… if we're going to send a certain trailer out"*;
labelled `Brian Petros` in the auto-transcript, addressed as Dylan at :142 and :162).

**The API mirrors the modal, not the card.** `intent.md` §3 point 4 makes the guard a mirror
of the Phase-1 modal only; nobody asked for a `mark-available` API guard, so none was added
(spec §0, §13). Q8 keeps the disable rule to the literal Mark Available state for the same
reason — REQ-03 names that state and no other.

**Everything else is the developer's smallest consistent default**, chosen to be reversible
in one file each (the spec's §12 names the file per item), not sourced from anyone's stated
preference. Q5 leans on the same punch list's :18 *"Hide camera when not applicable"*, which
is unadjudicated and does not name the unassigned case.

## Who should confirm

- **Dylan Masterson** (yard manager — the card, the modal, the chip copy, Q1–Q8 in full).
- **Lisette Anzaldo** (DAS owner) for REQ-10 (b): whether *Partial Loadout* should also be a
  filter bucket, which is the open bucket-set question above and not settled here.

Until one of them does, a one-line reply per item resolves it; the spec's §12 entries name
the file each reversal touches.

## What this does not settle

- **Whether a job with nothing to load should appear on the yard board at all** — open,
  [`../dispatch/gaps.md`](../dispatch/gaps.md) → *Should the yard board show jobs that have
  nothing to load*. Q3/Q8 keep such jobs *markable*; they do not decide whether they are shown.
- **The Yard Ops bucket set** — open, as above.
- **Items assigned but never loaded out at offload** — open,
  [`../dispatch/gaps.md`](../dispatch/gaps.md) → *Items assigned but never loaded out vanish
  silently at offload*. This decision stops an unassigned slot from being loaded; it does not
  say what happens to an *assigned* slot that was skipped.

## Effect on the vault

- **No winner, no loser.** No vault content file is verified or superseded by this note: the
  only source ([`../dispatch/yard-operations-jz.md`](../dispatch/yard-operations-jz.md)) stays
  `status: unverified` — a developer's default is not an adjudication of a client punch list,
  and the note's scope is narrower than the file's.
- **Done:** `.ai/aidlc/SCRUM-LOADOUT-UNASSIGNED/spec.md` §12 Q1–Q8 `Status:` →
  `resolved — see decisions/2026-09-14-yard-unassigned-slots-not-loadable.md`, answer text kept.
- **Done:** the first and third open questions above appended to
  [`../dispatch/gaps.md`](../dispatch/gaps.md) (2026-09-14) — the bucket-set entry was already
  open — alongside three more from the same close-out (manual vs automatic offload; six meeting
  asks never ticketed; the attachment-delete ordering follow-up).
