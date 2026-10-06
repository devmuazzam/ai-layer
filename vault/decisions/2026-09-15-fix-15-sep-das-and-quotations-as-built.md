---
title: Branch fix/15-sep as built — DAS loadout, allocation steal, letterhead — decision
source: decision/Ehtesham Anwar
decided: 2026-09-15
decided_by: >-
  Ehtesham Anwar (CodingCops product manager), stated 2026-09-15 in a Cursor
  review session of branch `fix/15-sep` (Fouzan Shakil). He approved the
  branch as built, including the three review merge-blockers and the other
  unsourced behaviours listed below. Not a TCG client-side sign-off (Dylan
  Masterson / Lisette Anzaldo / Brian Petros were not on the call). Recorded
  `status: reference` — binding on the CodingCops build, open to being
  overruled by TCG.
status: reference
conflicts_with: []
provenance_note: >-
  Item 4 OVERRIDDEN FOR A HELD ASSET ONLY, 2026-10-06, by
  decisions/2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md (Fouzan
  Shakil, `reference`). A held asset (Make Holdover) is refused to other jobs for the whole planned
  hold, before it is loaded out too; its allocation is not taken over with "Reassign anyway?".
  Item 4 stands for every asset that is not held. The rest of this note is unchanged.
supersedes_partial:
  - 2026-09-14-yard-unassigned-slots-not-loadable.md (Q3 employees-as-loadable; Q7(a) copy; REQ-04 assigned-row pre-tick)
resolves:
  - aidlc/SCRUM-LOADOUT-UNASSIGNED/spec.md#q3 (employee half)
  - aidlc/SCRUM-LOADOUT-UNASSIGNED/spec.md#q7 (copy (a) only)
  - dispatch/gaps.md#das-substituted-asset-pre-checklist--required-should-open-create-and-link-travel-permit (part (a) only)
jira: []
tags: [module/dispatch, module/quotations, module/assets, module/projects-jobs, kind/decision, yards, loadout, daily-allocation, permits]
entities: [das, job, quotation, employee, asset, permit, purchase-order]
---

# Branch `fix/15-sep` ships as built

PR-review of `fix/15-sep` (71 files, no ticket, no `.ai/aidlc/` folder) held
merge on three contradictions of
[2026-09-14-yard-unassigned-slots-not-loadable.md](2026-09-14-yard-unassigned-slots-not-loadable.md)
and of `SCRUM-LOADOUT-UNASSIGNED` REQ-04, plus a ticket-lock bypass on DAS
reassignment. **Ehtesham Anwar approved all of it as the intended product**,
2026-09-15.

## Decision

Ehtesham Anwar, 2026-09-15 — **the branch as built is the rule.** In particular:

### Yard loadout (supersedes parts of 2026-09-14 / REQ-04)

1. **Employees are not loaded out or offloaded.** Phase-1 never lets an employee
   row be ticked; `completeLoadout` / `completeOffload` reject any `employees`
   payload (`400 Employees cannot be loaded out.` / `Employees cannot be offloaded.`).
   Unassigned **asset** slots stay not-loadable (that half of 2026-09-14 stands).
   Tools still count as something to load. Mark Available empty-state copy is
   *"Nothing assigned to load out — assign assets or tools first"* (the word
   *employees* is dropped from Q7(a)).
2. **Start Loadout and Off-load open fully unchecked.** Assigned asset rows are
   **not** pre-ticked. Unassigned asset rows stay shown, greyed, unselectable
   (Q1/Q2 stand). This overrules REQ-04's "assigned rows are pre-ticked as today."

### DAS allocation (new)

3. **Yard lock is a hard save-block.** An employee or asset that is marked
   available for loadout, or already loaded out, on an overlapping job cannot
   be reassigned. Drop stages the chip with inline warning; Save Allocations
   refuses. Copy Allocations keeps a hard conflict for **assets**; **employees**
   on a `COPY` write are not run through this check (as built).
4. **Plain overlapping allocations are cleared on confirmed reassignment.**
   Reason `ALLOCATED` (not yet marked available / not loaded out) is stolen:
   the prior row is deleted, including when the **source** sub-job is
   `TICKET_SENT` or `ticketsLocked`. Payroll-locked tickets still refuse.
   The dispatcher confirms "Reassign anyway?" on the target; there is no
   second confirm on the source job.
   - **Overridden for a held asset, 2026-10-06** (Fouzan Shakil, CodingCops,
     `reference`, not confirmed by TCG):
     [2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md](2026-10-06-held-asset-refused-by-other-jobs-for-the-whole-planned-hold.md).
     A held asset (Make Holdover) is refused to other jobs for the whole planned
     hold, even before it is loaded out (`HELD_ON_SITE`, 409). It is never
     offered as "Reassign anyway?". To move it, release it in Make Holdover
     first. Item 4 is unchanged for every asset that is not held.
5. **Same non-vendor resource cannot fill two slots in one shift** on the same
   sub-job. Drop and upsert both block. Shift 1→2 copies ("Same assets / Same
   resources of Shift 1") still allowed. Cross-job non-overlapping double-book
   (`dispatch/daily-allocation-system.md` drag-and-drop AC, `unverified`) is
   unchanged. Vendors are out of this rule.
6. **Cancel Allocations** discards that expanded job's unsaved drafts locally
   (no API). Sits beside Copy Allocations.

### Yard tools

7. **Tool quantity has no upper cap** on the job-card stepper or in the
   handover modal. **Add Tool stays enabled when loadout is locked.** Quantity
   actions remain visible after `workflowPhase >= 2`.

### Permits / POs / checklist chrome

8. **Conversion travel is linked onto allocated assets** rather than minting a
   second Travel Permit from Required. All Permits prefers those asset-scoped
   `TRAVEL_*` rows so the slot and View all show the same code. When conversion
   travel is cancelled or missing, Required opens Permits/Plans (same as View
   all) instead of toasting. The `AssetPermitModal` create-and-link flow is
   gone — this is Ehtesham's answer to part (a) of
   [`../dispatch/gaps.md`](../dispatch/gaps.md) → *DAS substituted-asset
   Pre-checklist — Required should open create-and-link Travel Permit*. Parts
   (b)–(d) of that entry stay open.
9. **Vendor PO Pre-checklist greens only when status is `CLOSED`.** Linked
   `OPEN` stays pending. Uses
   [2026-09-11-po-closed-means-closed-out-not-cancelled.md](2026-09-11-po-closed-means-closed-out-not-cancelled.md)
   (`CLOSED` = closed-out / done). The job-card **PO#** aggregate row is **not**
   reopened here — that stays
   [`../dispatch/gaps.md`](../dispatch/gaps.md) → *Branch fix/permits-pos — the
   DAS pre-checklist "PO#" row…*.
10. **Pre-checklist trigger chrome follows the progress dots:** green border
    and fill when every item is complete, otherwise red border / orange fill.
    Idle 10s plan/permit/PO assignment refetches skip the global top loader.
11. **Craft-mismatch copy names the employee** ("The Oiler slot for {name}
    must have an Oiler craft code").

### Quotations / email

12. **Print and PDF quotation headers follow the Lovable Print Quote
    letterhead** (CA Lic, crane seal, red/blue rules, Portal Dr / Los Alamitos
    address, Office / Fax / web). Fallback identity when `COMPANY_*` is unset:

    | Field | Fallback |
    | --- | --- |
    | Legal name | The Crane Guys, LLC |
    | Address | 10850 Portal Dr., Los Alamitos, CA 90720 |
    | Email | quotes@thecraneguys.com |
    | Phone | 562.777.0600 |
    | Fax | 562.777.2424 |
    | Website | www.CraneGuys.com |
    | License | 967520 |

    Production env that already sets `COMPANY_*` is unchanged. The four
    quotations conflict candidates
    ([`../quotations/quotations-INDEX.md`](../quotations/quotations-INDEX.md))
    still do not define a letterhead — this note is the letterhead source, not
    an adjudication of that stub.
13. **View Ticket buttons in assignment / reschedule / reminder / completion
    emails** are Outlook-safe table+anchor CTAs and omit the button when
    `ticketLink` is empty.

## Why

UAT on 2026-09-15. The review treated (1)(2) as contradictions of a two-day-old
yard decision and (4) as a contradiction of the unverified DAS ticket-lock
story. Ehtesham, as product manager for this build, overrode those and the
other unsourced items rather than reverting the branch.

## What this does not settle

- **Dylan Masterson / Lisette Anzaldo ratification** of (1)(2)(7). The 2026-09-14
  note still names them. This note is a CodingCops PM sign-off, same class as
  the 15 Sep permit freeze.
- **Yard board visibility for jobs with nothing to load**, **bucket set**,
  **assigned-but-never-loaded at offload**, **manual vs automatic offload** —
  still open in [`../dispatch/gaps.md`](../dispatch/gaps.md).
- **COPY-path employees skipping the yard lock** (item 3). Approved as built;
  whether Copy Allocations should later hard-block employees the way it does
  assets is not a new question here — do not invent one.
- **Quotations conflict stub** — four candidates, none verified. Letterhead
  does not pick a winner among them.
- **Customer PO as a quotation field** — still contradicts
  [2026-09-05-po-types-and-quote-to-invoice-workflow.md](2026-09-05-po-types-and-quote-to-invoice-workflow.md);
  this note does not reopen or close that.

## Effect on the vault

- **No winner, no loser among migrated files.** `dispatch/daily-allocation-system.md`
  and the quotations four stay `status: unverified`. A PM sign-off of a UAT
  branch is not an adjudication of Confluence.
- **Done:** [2026-09-14-yard-unassigned-slots-not-loadable.md](2026-09-14-yard-unassigned-slots-not-loadable.md)
  `provenance_note` records that Q3 (employees as loadable), Q7(a) copy, and
  REQ-04 pre-tick are superseded here. The rest of that note stands
  (unassigned **assets** not loadable, chip, REQ-10 Partial Loadout, Q1/Q2/Q4–Q6/Q8).
- **Done:** `SCRUM-LOADOUT-UNASSIGNED/spec.md` §12 Q3 and Q7 status lines point
  here for the superseded halves.
- **Done:** `dispatch/gaps.md` *DAS substituted-asset Pre-checklist…* part (a)
  marked resolved to this note; (b)–(d) stay open.
- **INDEX / module routers** updated to point here.
