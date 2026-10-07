---
title: "Every ticket must be completed before the week's payroll is processed or approved; a flag can be cleared as \"reviewed, no change\" — decision"
source: decision/Corrina Bustos (TCG Payroll Manager) — Teams reply, 2026-09-30
decided: 2026-09-30
decided_by: >-
  Corrina Bustos (TCG, Payroll Manager — the payroll owner), in writing, in a Microsoft Teams reply to
  Syed Haris (CodingCops) on 2026-09-30. She answered questions 1 and 2 of three. **Question 3, the
  boom basis, went unanswered for the second time that day.**
status: verified
conflicts_with: []
provenance_note: >-
  2026-10-07: PROVISIONAL ANSWERS bearing on "Not decided" items 2 and 4, not adopted. Melissa McNutt
  (TCG President), in written Teams answers posted on or before 2026-10-06: every field employee may
  complete or edit their own ticket for 24 hours. After that, approval from a "manager or payroll" is
  needed, requested in the app, followed by 4 hours to complete. Supervisors and dispatchers may
  complete on a worker's behalf ("Yes"). Payroll can edit at all times. TCG then asked CodingCops to
  hold those answers until an updated version is sent. They do not change this note's ruling: every
  ticket must be complete before the week is processed or approved. A ticket waiting on that
  approval would hold the week. Recorded in
  decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md
  (status: reference, T2, T13). Open in payroll/gaps.md under "Who may complete or correct a ticket
  on a worker's behalf". Body unchanged.
supersedes_partial:
  - "decisions/2026-09-10-pending-tickets-are-a-display-only-payroll-overlay.md (clause 6: 'warn' is no longer the strongest word — an incomplete ticket blocks processing/approval)"
resolves:
  - "payroll/gaps.md#which-payroll-issues-block-approval-pay-065--a-provisional-list-is-live-in-every-tenant (sub-question 5, clearing a flag; and incomplete tickets as a blocker)"
  - "payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives (clearing a flag where nothing is wrong)"
jira: []
tags: [module/payroll, module/field-ops, kind/decision, payroll-review, payroll-approval]
entities: []
---

# Incomplete tickets block the week; "reviewed, no change" clears a flag

## The exchange

Syed Haris, verbatim:

> "Hi Corrina, a few more to confirm. Sorry for sending these in batches, they come to me as I plan
> things out:
> 1. If a ticket is completed after that week's payroll is approved (for example a job that started
> 8/28 but was only completed after the 8/22 to 8/28 payroll was approved), should its hours go into
> the next week's payroll?
> 2. Sometimes a flag is correct but nothing needs changing (for example the oiler really did stay
> later). Should you be able to mark it "reviewed, no change" so the week can still be approved?
> 3. For the boom length check, should we compare to the boom the salesperson set on the job, or the
> crane's maximum boom?"

Corrina Bustos, Teams, 2026-09-30, verbatim:

> "no, all tickets must be completed before the payroll can be processed/approved.
> 2. yes that would be a good option."

## Decision

1. **All tickets for the week must be completed before that week's payroll can be processed or
   approved.**
   - An incomplete ticket **blocks** the week.
   - So the case asked about cannot arise by design: a ticket completed *after* the week is approved,
     with its hours rolled into next week. Her answer to "next week?" is **no**.
2. **A flag can be cleared as "reviewed, no change".** Payroll marks a correct-but-legitimate flag as
   reviewed, and the week can then be approved. Her example was the oiler really staying later. This
   is the escape path for the rule that all flags block until *"adjusted and fixed"*
   ([2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md)).

## What it changes

- **[2026-09-10-pending-tickets-are-a-display-only-payroll-overlay.md](2026-09-10-pending-tickets-are-a-display-only-payroll-overlay.md)**
  (`reference`, Syed Haris):
  - The overlay still shows unfinished tickets without pricing them. That part is untouched.
  - Its clause 6 said a week with an open entry should *warn* before approval, and left blocking
    *"explicitly not settled"*. **It now blocks.**
- **PAY-065** ([payroll/gaps.md → *Which payroll issues block approval*](../payroll/gaps.md#which-payroll-issues-block-approval-pay-065--a-provisional-list-is-live-in-every-tenant)):
  - An incomplete ticket joins the nine flags as a blocker.
  - Sub-question 5 (clearing a flag) is answered.
- **Not changed:** corrections to an **already approved** week. That case is different, and remains
  governed by the proposed closed-payroll policy in
  [../payroll/payroll-rule-dependency-matrix.md](../payroll/payroll-rule-dependency-matrix.md)
  (l. 122–126: the posted payroll stays immutable; the difference is a retroactive adjustment for
  Payroll to review). That text is an unverified recommendation, not a decision.
- **Prior record:** no earlier vault entry was found for "a ticket completed after the week is
  approved". It was raised only in this exchange.

## Not decided — recorded, not resolved

1. **"Processed/approved".** Does an incomplete ticket also block **Calculate** (processing), or only
   approval? The overlay decision lets the week be calculated with pending tickets shown alongside.
   If "processed" means Calculate, that changes too.
2. **An escape path for a ticket that never completes.** A cancelled or abandoned ticket, or a crew
   that never taps Review & Complete, would block the week forever. Who may complete or void it on
   the crew's behalf (payroll? dispatch?), and does that go through the flag or Send Back flow?
3. **Cross-week shifts.** A shift starting 8/28 and ending 8/29 belongs to its start week. Presumably
   it must be completed before the 8/22–8/28 week is approved. Confirm which week a ticket belongs to
   for this rule: the work date, or the start.
4. **"Reviewed, no change" mechanics:**
   - whether a note or reason is required;
   - who may do it (Payroll Admin and Payroll Manager, as for flags?);
   - the audit trail;
   - whether it is available for every flag type, or not for some, for example asset-not-home.
5. **Boom basis** (job configuration set by sales, or the crane's range/maximum). **Asked twice on
   2026-09-30 and not answered either time.** Suggest routing it to **Brian Petros**, or raising it at
   the demo. [payroll/gaps.md Q6](../payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives)
   stays open.

## Build impact

- The approval gate needs a "tickets for this week not completed" blocker. The overlay already
  computes this at read time.
- Every flag needs a **"reviewed, no change"** clear action. PR #690/#691 have neither.
- Whether Calculate is also blocked waits on open point 1.

## Effect on the vault

Done in the same pass:

- **2026-09-10 note:** `provenance_note:` added. Clause 6 is superseded: an incomplete ticket blocks.
  **Done.**
- **2026-09-30 flag-list note:** `provenance_note:` added. The clearing path is answered here. **Done.**
- **payroll/gaps.md:** the PAY-065 entry and the flagged-entries entry are updated. **Done.**

Not done, because file bodies are outside the recording agent's write scope: `payroll/INDEX.md`. The
exact text was handed to the main session.
