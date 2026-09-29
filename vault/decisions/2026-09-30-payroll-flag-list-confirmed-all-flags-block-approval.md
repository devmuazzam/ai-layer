---
title: "The nine payroll flags confirmed; every flag blocks approval until fixed; Send Back to the worker with a 3-hour reminder — decision"
source: decision/Corrina Bustos (TCG Payroll Manager) — Teams reply, 2026-09-30
decided: 2026-09-30
decided_by: >-
  Corrina Bustos (TCG, Payroll Manager — the payroll owner), in writing, in a Microsoft Teams reply to
  Syed Haris (CodingCops) on 2026-09-30. She confirmed a nine-item flag list and routing summary that
  he sent her, and answered its first question, on blocking. She did **not** answer its second
  question, on the boom basis. Her confirmation is a blanket *"yes all of those are correct"* to a list
  that CodingCops drafted. Items she had never stated herself are therefore confirmed by assent, not
  by her own words. Each item below says which.
status: verified
conflicts_with: []
provenance_note: >-
  FOLLOWED UP THE SAME DAY — decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md. Not-decided item 2 is answered: payroll can mark a flag
  "reviewed, no change" and the week can then be approved. Incomplete tickets also block
  processing/approval. The boom basis (item 1) was asked a second time and was again not answered.
  Body unchanged.
supersedes_partial:
  - "decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md (clause 6: 'A boom-range flag on its own only warns' — overruled; every flag now blocks)"
resolves:
  - "payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives (Q3, Q5(f); Q7/Q8 extended; Q10 (a)(b) ratified)"
  - "payroll/gaps.md#which-payroll-issues-block-approval-pay-065--a-provisional-list-is-live-in-every-tenant (for the nine flags only; partial)"
jira: []
tags: [module/payroll, module/assets, module/dispatch, kind/decision, payroll-review, send-back, samsara, payroll-approval]
entities: []
---

# The nine payroll flags confirmed; every flag blocks approval until fixed

## The exchange

Syed Haris, verbatim:

> "Hi Corrina, here's the full list of payroll flags we're building. Could you confirm it's right?
> 1. Boom length outside the crane's boom range
> 2. Overlapping jobs
> 3. Under 8 hours' rest
> 4. Missing notes
> 5. Invalid times: wrong AM/PM, same start and end, times out of order, duplicate entries, missing
> start or end, shifts over 24 hours, labor not matching the ticket
> 6. Invalid long boom time
> 7. Ticket time more than 30 minutes off Samsara, at the start or end of the day
> 8. Crew times not matching: Left Yard or Arrived at Yard different for anyone on the job
> 9. Asset not back at the yard it left from (Dispatch is notified too)
> All flags go to you and Micaela. You can fix any time for one person, or send the entry back to the
> worker with a reminder after 3 hours.
> Two questions:
> 1. Should any of these stop you from approving the week until they're fixed, or should they all
> just warn?
> 2. For the boom length check, should we compare to the boom the salesperson set on the job, or the
> crane's maximum boom?"

Corrina Bustos, Teams, 2026-09-30, verbatim:

> "Hello, yes all of those are correct.
> yes all of these will need to be adjusted and fixed before the payroll can be approved."

## Decision

**A. The flag list.** All nine are confirmed as listed.

| # | Flag | Her own earlier words, or assent only |
| --- | --- | --- |
| 1 | Boom length outside the **crane's boom range** | Assent. The either/or basis question was **not answered** — see *Not decided* |
| 2 | Overlapping jobs | Her words, 2026-09-29 |
| 3 | Under 8 hours' rest | Her words, 2026-09-29 |
| 4 | Missing notes | Her words, 2026-09-29 |
| 5 | Invalid times, covering eight checks: | Mixed — see the sub-list below |
| 6 | Invalid long boom time | Her words, 2026-09-29 (definition partly given) |
| 7 | More than 30 min off Samsara, **at the start or end of the day** | Her words: 30 minutes (2026-09-29); the start of the ticket (2026-09-30) |
| 8 | Crew times not matching, **Left Yard or Arrived at Yard**, anyone on the job | **Ratifies** the developer reading [2026-09-30-crew-flag-compares-left-and-arrived-yard-asset-must-return-to-departure-yard.md](2026-09-30-crew-flag-compares-left-and-arrived-yard-asset-must-return-to-departure-yard.md) clause 1 |
| 9 | Asset not back at **the yard it left from**; dispatch notified | **Ratifies** that note's departure-yard rule (clause 2). *"Last engine shut-off of the day"* was **not** in the message, so that reading remains ours |

Item 5's eight checks:

- **Her own words (2026-09-29):**
  - wrong AM/PM;
  - the same start and end;
  - times out of order.
- **New, confirmed by assent (2026-09-30):**
  - duplicate entries;
  - a missing start or end;
  - shifts over 24 hours;
  - labor not matching the ticket.

**B. Routing and correction, confirmed again.**

- **All flags go to** the Payroll Admin (Micaela) and the Payroll Manager (Corrina).
- **Payroll may fix any time, for one person.**
- **Send Back survives, and its target is the worker.** A reminder goes out after **3 hours**. That
  matches her own 2026-08-04 ask (15:50, *"Is there a way we can set up like an auto reminder if they
  haven't replied?"* —
  [../meetings/transcripts/2026-08-04-payroll-process.md](../meetings/transcripts/2026-08-04-payroll-process.md)
  l. 78) and the unverified Confluence US-03 AC 9 (3 hours).

**C. Blocking.** *"All of these will need to be adjusted and fixed before the payroll can be
approved."*

- **Every one of the nine flags blocks approval until it is resolved.**
- This **overrules** 2026-09-28 clause 6: *"A boom-range flag on its own only warns. It does not
  block."*
- It answers PAY-065 for these nine flags.

## Where the new item-5 checks come from

- **Duplicate entries:** the legacy engine's `Warn_DuplicateWindow` (same employee, identical rounded
  start and end) —
  [../payroll/legacy-payroll-app-db-extract/calculations.md](../payroll/legacy-payroll-app-db-extract/calculations.md)
  l. 206–207.
- **Overlap** (item 2) is legacy `Warn_Overlap`, same place. **In legacy both are warnings; now they
  block.**
- **Labor not matching the ticket:** Joe Schacatano, 2026-06-23 33:15 (employee time 9½ h vs ticket
  8, *"flags it for her"*).
- **Missing start or end, and over 24 hours:** these were CodingCops's list items. The nearest written
  rules are PAY-018 (an entry missing times cannot be priced) and PAY-004's **23.5-hour** cap on
  imported rows. See *Not decided*.

## Not decided — recorded, not resolved

1. **The boom basis (her question 2) was not answered.** Should the check use the job's crane
   configuration set by sales, or the crane's range? Her *"all of those are correct"* covers item 1
   as it was worded (*"the crane's boom range"*), but she did not address the either/or asked beneath
   it. Recorded as **unanswered, not as a choice.** payroll/gaps.md Q6 stays open.
2. **"Fixed" for a legitimate difference.**
   - Item 8 flags **any** difference, including legitimate ones such as the oiler staying behind
     (Corrina, earlier on 2026-09-30).
   - If every flag blocks until *"adjusted and fixed"*, how does payroll clear a flag where nothing is
     wrong? Options: a "reviewed — no change" action, or a required note.
   - The same applies to rest and overlap flags that are real, and are paid correctly under PAY-045
     and PAY-029.
   - Not asked, not answered.
3. **Item 9 blocking payroll.** The asset flag is about an asset, not a labor entry. Whose week does
   it block: the crew on that asset's ticket, or the whole period? She said *"all"*, so it is recorded
   as blocking, and the mechanics are open.
4. **24 hours vs 23.5 hours.** Item 5 says *"shifts over 24 hours"*. The 09-28 correction refuses
   more than **23.5 h**, following PAY-004's cap on imported FCC rows. Which threshold applies is
   not settled.
5. **Send Back mechanics:**
   - the worker's mobile screen and edit rights;
   - whether the worker can edit or only reply;
   - who receives the 3-hour reminder (the worker, payroll, or both), and whether it repeats.
6. **"Last engine shut-off of the day"** (item 9), and the yard radius, remain developer readings or
   open.

## Build impact

PR #690 / #691 on `main` built the following, and each now contradicts or falls short of this:

- **Send Back goes to a Crane Supervisor.** It should go to the **worker**.
- **There is no reminder.** One is required after 3 hours.
- **The boom-range flag only warns.** It must **block**.
- **Only the boom-range flag exists.** Flags 2–9 are not built.

The PAY-065 approval gate (`payroll_approval_blocking_issues`, seeded with the provisional
`NO_ADP_FILE` and `RATE_*` codes) must gain the nine flags as **blocking**. That is a data and seed
change, and a pay-process change.

## Effect on the vault

Done in the same pass:

- **2026-09-28 note:** `provenance_note:` extended. Clause 6's warn-only is overruled, and Send Back
  now goes to the worker. **Done.**
- **Developer-reading note (2026-09-30):** `provenance_note:` records Corrina's ratification of
  clause 1 and the departure-yard rule. `status:` is **left at `reference`**, because *"last engine
  shut-off of the day"* is still unratified and part of the same clause. Flipping the whole note to
  `verified` would claim more than she confirmed. **Done.**
- **First 2026-09-29 note:** `provenance_note:` extended. Its open item 3 (Send Back) and the reminder
  are answered here. **Done.**
- **payroll/gaps.md → [*Flagged entries go to payroll…*](../payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives):**
  Q3, Q5(f), Q7 and Q10 updated; Q6 kept open. **Done.**
- **payroll/gaps.md → [*Which payroll issues block approval (PAY-065)*](../payroll/gaps.md#which-payroll-issues-block-approval-pay-065--a-provisional-list-is-live-in-every-tenant):**
  an update line is added. The nine flags block. The provisional list and sub-questions 1–3 stay
  open for every other code. **Done.**
- **PAY-045:** not changed. Flag 3 is a review flag. It does not change how the rest premium is
  priced.

Not done, because file bodies are outside the recording agent's write scope: `payroll/INDEX.md`. The
exact text was handed to the main session.
