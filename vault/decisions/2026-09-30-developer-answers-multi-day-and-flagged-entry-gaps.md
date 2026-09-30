---
title: "Developer answers, 2026-09-30: multi-day pay questions, the correction page, and the mechanics of flags, Send Back and incomplete tickets — decision (developer direction, pending client ratification)"
source: decision/devmohsinakram (CodingCops developer) — chat answers in a Claude Code session, 2026-09-30
decided: 2026-09-30
decided_by: >-
  The CodingCops developer building payroll review and the correction page (git user
  devmohsinakram; PR #699, branch fix/payroll-correction-page-ui of the platform repo). They answered
  in chat with the coordinating Claude Code session on 2026-09-30, over seven rounds of questions,
  then four more the same day: round 8, the build plan (section *Later the same day*); round 9,
  the flag definitions and designs for PAYROLL-FLAGS units U14–U21 (section *Round 9*); and rounds
  10 and 11, the remaining flag details and the answers to the ticket specs' open questions
  (section *Rounds 10 and 11*). Round 9 separates client-owned rules, which are pending
  ratification (F1–F15), from CodingCops design calls, which the developer settled (G1–G2).
  Rounds 10 and 11 add flag readings pending ratification (H1–H6), two pay rules pending
  Corrina Bustos and Brian Petros (J1–J2), and workflow and display directions (K1–K5).
  This is a **developer's direction**, not a client-side product decision. It is `status: reference`
  for that reason, on the same basis as
  decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md. It binds
  implementation only where an item below says so, and TCG can overrule any of it. Four answers are
  the developer's own words, quoted, and round 9 adds two more (F5, F13). The rest are the option the developer picked, in the
  coordinating session's wording. Ratifiers: **Brian Petros** and **Corrina Bustos** for every pay
  rule; **Corrina Bustos** for every extension of her verified 2026-09-30 decisions; **TCG's
  field-ops owner** (not named in the vault), with Lisette Anzaldo and Brian Petros, for the
  one-ticket-per-day conflict and for what End Work means.
status: reference
conflicts_with:
  - decisions/2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md
  - decisions/2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md
  - payroll/payroll-rules-provenance.md
  - decisions/2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md
provenance_note: >-
  Recorded 2026-09-30 by tcg-scrum from the coordinating session's list of the developer's answers.
  conflicts_with names three written sources this note's answers disagree with or sit in tension
  with: the verified one-ticket-per-day note (A6); the verified "individual" correction rule (C6);
  and two provenance rows, the minimums "per calendar day" (A2) and the Confirmed long-tier
  subsistence "every day of the holdover" (A4). None of those files is changed by this note.
  ROUND 9 (2026-09-30) adds a fourth: Corrina's verified asset-flag trigger ("I dont think it would go
  off a time. it would trigger if the asset shut off at address other than ...") sits in tension
  with F13, which judges the asset's position once the ticket's end date has passed. Recorded, not
  resolved; Corrina ratifies.
  ROUNDS 10–11 (2026-09-30) add no conflicts_with entry. H5 moves F13's check to the job's last
  ticket date for a multi-day non-holdover job. It is still date-based, so the F13 tension stands
  unchanged. J1–J2 sit on the provenance row "8-hour rest — gap start", which already records
  both as built and pending; that file is not changed.
supersedes_partial:
  - "decisions/2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md (clause 4's bullet 'Adding or removing a lunch is not supported' — the later bullet, add / remove / switch, governs; C11)"
resolves:
  - "payroll/gaps.md#which-payroll-issues-block-approval-pay-065--a-provisional-list-is-live-in-every-tenant (sub-question 5 mechanics — settled; incomplete tickets and Calculate, the never-completed ticket, flag 9's scope — developer answers, see each item)"
  - "payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives (Q3 remainder and Q5(f) — settled mechanics; whose week an asset flag blocks — settled mechanics; 24 vs 23.5 h — developer answer)"
  - "payroll/gaps.md#send-back-of-a-multi-crew-ticket--does-sending-a-ticket-back-also-return-it-for-the-other-crew-members-on-that-ticket (developer answer (c) plus a hold; pending Corrina Bustos)"
  - "payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives (round 9: C4 — settled, CodingCops design, G1; Q6, Q7, Q8, Q9, Q10(c)(d), Q11 — developer readings F1–F10, still open pending Corrina Bustos)"
  - "assets/gaps.md#asset-not-returned-to-its-home-yard-at-end-of-shift--a-requested-flag-with-no-owner-no-yard-geometry-and-no-shift-end (round 9: Q1 remainder, Q2, Q3 derivation, Q5, Q8 — developer readings F11–F15, still open pending ratification; Q7 not answered)"
  - "decisions/2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md open item 5 (round 9: the worker's edit rights on a returned ticket — settled, CodingCops design, G2)"
  - "payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives (rounds 10–11: Q5(d) what counts as a note, H1; Q7 AM/PM replaces out-of-order and the 30 minutes is on the total difference, H3–H4; Q10(c)(d) only the mismatching workers are held, H2 — developer readings, still open pending Corrina Bustos. C1 rest-start mechanics, per rest chain and across chains, J1–J2 — pay rules, still open pending Corrina Bustos / Brian Petros)"
  - "assets/gaps.md#asset-not-returned-to-its-home-yard-at-end-of-shift--a-requested-flag-with-no-owner-no-yard-geometry-and-no-shift-end (rounds 10–11: Q2 a multi-day non-holdover job is judged after the job's last ticket date, H5, still in tension with Corrina's trigger; Q7 no Samsara data, no asset flag, H6 — developer direction; entry still open)"
  - "aidlc/PAYROLL-FLAGS/spec.md §12 Q9–Q11, spec-u6-u13.md §12 Q20–Q25, spec-u14-u21.md §12 Q40–Q41 (rounds 10–11: recorded here as J1–J2 and K1 for Q9–Q11; K2–K5, plus C6 restated, for Q20–Q25; H4 and H6 for Q40–Q41. The ticket files already mark them resolved)"
  - "payroll/gaps.md multi-day entries (b) ladder, (c) minimums, (d) subsistence, (e) meals after 27 h, (f) non-union workday, (g) DAILY premiums, (h) craft rate change — developer answers only, every one still open pending Brian Petros / Corrina Bustos"
jira: []
tags: [module/payroll, module/field-ops, module/assets, module/dispatch, kind/decision, payroll-rules, overtime, subsistence, wtl, guaranteed-hours, ticket-workflow, time-tracking, notifications, payroll-review, send-back, samsara, yards]
entities: []
---

# Developer answers, 2026-09-30: multi-day pay, the correction page, and the mechanics of flags and Send Back

**Nothing in this note is a client ruling.** Each item carries one of three standings:

- **Settled.** A verified client decision states the rule. The developer's answer fills in only
  mechanics that decision left open, and goes no further than her words. **Build it.**
- **Developer reading, pending ratification.** The item says who ratifies, and whether it may be
  built before they do.
- **Superseded.** Recorded so it is not asked again. **Nothing is built from it.**

Two rules apply to every pay item in sections A and B:

- **"Keeps today's behaviour"** (section A): the engine already does this. There is no code change,
  and the gap stays **open** until Brian Petros and Corrina Bustos ratify.
- **"Would change pay"** (section B): **not to be built until ratified.** The build then needs its
  source row in [../payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md) in
  the same commit (`CLAUDE.md`, the `packages/payroll-engine/` row).

## Where the answers come from

- **Who:** git user `devmohsinakram`, the developer of PR #699, in chat on 2026-09-30.
- **How:** seven rounds of questions from the coordinating session, which kept the list of answers.
- **Wording:** four answers are verbatim and are quoted (D1, C1, C6, C9). The rest are the option the
  developer picked, in the session's wording, not the developer's.
- **Context:** the same day, Corrina Bustos gave two verified answers:
  [2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md)
  and
  [2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md](2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md).
  In round 6 the session put the two places where the developer's earlier answers disagreed with
  them back to the developer. The developer chose Corrina's rule on the week (D1) and restated the
  crew rule (C6).

## Summary

| # | Answer | Answers | Standing |
| --- | --- | --- | --- |
| A1 | The 8/12 ladder never resets inside one entry | gaps (b) | Pay rule, keeps today's; pending Brian / Corrina |
| A2 | Daily and long-boom 4 h minimums group on the start (anchor) date | gaps (c), **conflict** | Pay rule, keeps today's; pending Corrina / Brian |
| A3 | DAILY catalog premiums once per ticket | gaps (g) | Pay rule, keeps today's; pending Brian / Corrina |
| A4 | Subsistence on the start date only | gaps (d) | Pay rule, keeps today's; pending; **long tier sits against a Confirmed row** |
| A5 | A craft rate change keeps the start rate for the whole ticket | gaps (h) | Pay rule, keeps today's; pending Brian / Corrina |
| A6 | One ticket of 24 h or more is allowed | 09-28 2nd addendum D, **conflict** | Pending TCG field-ops owner, Lisette Anzaldo, Brian Petros |
| A7 | The over-24 h flag fires at 24 h or more | 09-28 2nd addendum G | 24 is Corrina's (by assent); the `>=` boundary is pending her |
| B1 | Meals after 27 h continue every 5.5 h, WTL checked at each | gaps (e) | **Changes pay. Do not build until ratified** |
| B2 | Non-union: an entry over 24 h splits into a workday per calendar date | gaps (f) | **Changes pay. Do not build until ratified** |
| C1 | Every flag blocks weekly approval | 09-28 2nd addendum G; PAY-065 | **Settled** (Corrina) |
| C2 | "Reviewed, no change": note required, audited, Payroll Admin/Manager only, every flag | Incomplete-tickets note, open item 4 | **Settled** (Corrina + mechanics) |
| C3 | The worker edits the ticket times on mobile and resubmits | Flag-list note, open item 5 | **Settled** (Corrina + mechanics) |
| C4 | The reminder goes to the worker every 3 h until they respond | Flag-list note, open item 5 | **Settled** (Corrina + mechanics) |
| C5 | Flag 9 blocks that ticket's crew's weeks | Flag-list note, open item 3 | **Settled** (Corrina + mechanics) |
| C6 | A shared ticket is sent back to every worker on it, and blocks all their weeks | Multi-crew Send Back gap | Pending Corrina |
| C7 | An incomplete ticket blocks Approve only, not Calculate | Incomplete-tickets note, open item 1 | Pending Corrina |
| C8 | Payroll Admin/Manager may complete or void a never-completed ticket | Incomplete-tickets note, open item 2 | Pending Corrina; voiding reaches beyond payroll |
| C9 | A week move into a settled week is processed in the current open week | 09-28 2nd addendum F | Pending Brian / Corrina |
| C10 | End Work = the crew leaving the job site | 09-28 3rd addendum, **conflict** | Pending TCG field-ops owner; **billing effect not asked** |
| C11 | Lunches can be added, removed and switched on the correction page | 09-28 first addendum, *Stale lines* | Developer direction on the developer's own note |
| D1 | Roll an incomplete ticket into next week ("Week 1, until approved") | gaps (a) | **Superseded** by Corrina. Not built |

## A. Answers that keep today's behaviour (pay rules, pending ratification)

**Standing for A1–A5:** developer direction, pending ratification by **Brian Petros** and
**Corrina Bustos**. The engine is unchanged, and each gap stays **open**. A6 and A7 have their own
ratifiers, given in each item.

### A1. The 8/12 ladder never resets inside one entry

- **Answers:** [payroll/gaps.md → *Multi-day entry — does the 8-hour OT and 12-hour DT ladder ever reset inside one entry*](../payroll/gaps.md#multi-day-entry--does-the-8-hour-ot-and-12-hour-dt-ladder-ever-reset-inside-one-entry)
  (the 2026-09-28 note's second addendum, item E(b)).
- **Answer:** never restarts. One entry is one shift. After the 12th hour, every hour is DT or
  higher, however long the entry runs.
- **Today:** the engine does exactly this. `cumulative` carries through every slice of the entry,
  and the ladder resets only between entries, after a gap of 8 hours or more (as the gap records).

### A2. The daily and long-boom 4-hour minimums group on the start (anchor) date — a conflict answer

- **Answers:** [payroll/gaps.md → *Daily and long-boom 4-hour minimums — grouped on the shift anchor date or on each calendar date*](../payroll/gaps.md#daily-and-long-boom-4-hour-minimums--grouped-on-the-shift-anchor-date-or-on-each-calendar-date)
  (second addendum, item E(c)).
- **Answer:** per start (anchor) date, as today.
- **This takes a side in a conflict between written sources.** It sides with the verified
  [2026-09-04-cross-midnight-day-type-and-holiday-minimum.md](2026-09-04-cross-midnight-day-type-and-holiday-minimum.md)
  (:92-102: the daily and long-boom minimums are grouped on `ShiftAnchorDate`). It goes against
  [../payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md) :89-90
  (`reference`: *"per calendar day"*, citing Brian Petros on 2026-09-10 at 35:46–36:28, with Corrina
  agreeing).
- **Today:** the engine groups on `entry.day.workDate`, the anchor date. Only its doc comment says
  *"per calendar work day"*.
- **Why it stays open.** A developer cannot settle a disagreement between two client-sourced
  records. The verified note is Corrina's. The provenance rows cite Brian, with Corrina agreeing.
  The gap already notes that the two may differ only in wording: the 2026-09-10 point was per day
  versus per labor entry. A one-line "yes, the anchor date" from Corrina or Brian would close it.
  The provenance rows are not changed by this note.

### A3. DAILY catalog premiums are paid once per ticket

- **Answers:** [payroll/gaps.md → *Multi-day entry — DAILY catalog premiums once per ticket or once per calendar date*](../payroll/gaps.md#multi-day-entry--daily-catalog-premiums-once-per-ticket-or-once-per-calendar-date)
  (item E(g)).
- **Answer:** once per ticket, as today (`calculate.ts:372-373`).
- **Known consequence, accepted by the answer:** one 30-hour ticket pays it once. The same work as
  one ticket per day pays it two or three times.

### A4. Subsistence is paid on the start date only

- **Answers:** [payroll/gaps.md → *Multi-day entry — subsistence on a date reached only by a spill past midnight*](../payroll/gaps.md#multi-day-entry--subsistence-on-a-date-reached-only-by-a-spill-past-midnight)
  (item E(d)).
- **Answer:** the start date only, as today (`applySubsistence` keys on the job plus the entry's
  start date).
- **The long ($200) tier sits against a Confirmed rule.** Two sources state it:
  - [../payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md) :130,
    **Confirmed**: *"$200/day beyond 77.5 mi, every day of the holdover"*;
  - the answered gap *Subsistence — the recording and the engine disagree*: *"every calendar day of
    the holdover, worked or not"*.

  The Tuesday and Wednesday of one Monday-to-Wednesday entry on a holdover job are calendar days of
  that holdover. Start-date-only pays Monday alone. A developer answer cannot override a Confirmed
  rule, so **for the long tier this answer is not to be relied on.** Brian Petros and Corrina Bustos
  must say whether one entry across several dates is one holdover day or several.
- **The short ($85) tier**, *"days worked"*, is the real open question: is a date reached only by a
  spill past midnight a day worked? The developer says no. That is pending ratification.

### A5. A craft rate change inside one entry keeps the start rate for the whole ticket

- **Answers:** [payroll/gaps.md → *Multi-day entry — a craft rate change that takes effect inside one entry*](../payroll/gaps.md#multi-day-entry--a-craft-rate-change-that-takes-effect-inside-one-entry)
  (item E(h)).
- **Answer:** the start rate for the whole ticket, as today. Pricing resolves one rate per entry at
  `shiftStartedAt`.
- **Not answered by it:** the resolver cuts `shiftStartedAt` to its **UTC** date, noticed in the gap
  and not a pay-rule question. An evening entry can pick up the next date's rate.

### A6. One ticket of 24 hours or more is allowed — a conflict answer

- **Answers:** the 2026-09-28 note, [second addendum, item D](2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md#d-tension-with-a-verified-decision-one-ticket-per-day-flagged-not-resolved).
- **Answer:** a 24 h+ ticket is allowed, as the system handles it today.
- **This contradicts a verified decision.**
  [2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md](2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md)
  clause 1 says a job ticket is per asset group **per day**, where the day can run past midnight.
  A developer's direction cannot overrule it.
- **What it binds now:** payroll and the correction page accept and price a 24 h+ ticket that
  exists. That is what the second addendum's items A and G already do. It does **not** tell
  field-ops to produce such tickets.
- **Ratifiers:** TCG's field-ops owner, with that decision's named deciders, Lisette Anzaldo
  (dispatch) and Brian Petros. The conflict stays open.

### A7. The over-24-hour review flag fires at 24 hours or more

- **Answers:** the 2026-09-28 note, [second addendum, item G](2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md#g-a-single-ticket-over-24-h-price-it-flag-it-for-review-amends-clause-6-added-later-on-2026-09-29),
  *Not recorded: the exact threshold*.
- **Answer:** 24 h or more (`>=`). A ticket of exactly 24.0 h is flagged.
- **Against Corrina's flag list:** item 5 of her verified list says *"shifts over 24 hours"*. That
  wording was CodingCops's, confirmed by her assent. The number, 24, is hers. The `>=` boundary is
  the developer's, and differs only for a ticket of exactly 24.0 h. **Pending her OK on that one
  boundary.**
- **24 vs 23.5 h** (the flag-list note's open item 4): the developer's threshold is 24.
  - The correction's 23.5 h refusal was lifted on 2026-09-29 (second addendum, item A).
  - PAY-004's 23.5 h cap applies only to imported FCC rows.
  - So 24 is the only threshold left for ERP-born entries.
- **Not asked:** whether item G's review flag and flag 5's over-24-hours check are one flag or two.
  They fire on the same condition, and both block (C1).

## B. Answers that would change pay (not to be built until ratified)

**Standing:** developer direction, pending ratification by **Brian Petros** and **Corrina
Bustos**. **Do not build either until they ratify.** When built, each needs its row in
[../payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md), in the same
commit. Each gap stays **open**.

### B1. Meal and WTL opportunities continue every 5.5 hours after 27 hours

- **Answers:** [payroll/gaps.md → *Multi-day entry — meal and WTL opportunities after 27 hours*](../payroll/gaps.md#multi-day-entry--meal-and-wtl-opportunities-after-27-hours)
  (item E(e)).
- **Answer:** continue the cadence, one every 5.5 hours: the fifth at 27 h, the sixth at 32.5 h, and
  so on. WTL is checked at each.
- **Today:** the engine caps at four. After 21.5 h no meal is due and no WTL is raised.
  - `MEAL_OPPORTUNITY_HOURS = [5, 10.5, 16, 21.5]` (`packages/payroll-engine/src/meal-periods.ts:35`)
  - `WTL_TRIGGERS = [5.01, 10.51, 16.01, 21.51]` (`calculate.ts:43`)
- **What building it takes:**
  - an engine change;
  - more lunch slots in capture, because `VISIBLE_LUNCH_BREAKS === WTL_TRIGGERS.length`
    (`calculate.ts:105`).
- **Support, and a dependency:**
  - The MLA *Meal Periods* §1 (quoted in the gap) sets no upper limit, which supports the answer.
    The legacy `cfg.WTL_MaxMealThreshold` stops at four.
  - **The first four positions are themselves contested:** 16.0 vs 16.5 h and 21.5 vs 22 h (the
    provenance *Meal opportunities — count* row, *Pending — Corrina*). If the later positions win,
    the fifth falls at 27.5 h, not 27. The continued cadence follows whatever the first four settle
    on.

### B2. Non-union: an entry over 24 hours splits into a workday per calendar date

- **Answers:** [payroll/gaps.md → *Multi-day entry — the non-union workday for an entry longer than 24 hours*](../payroll/gaps.md#multi-day-entry--the-non-union-workday-for-an-entry-longer-than-24-hours)
  (item E(f)).
- **Answer:** split at each midnight. Each calendar date is its own workday:
  - the daily 8/12 ladder restarts on each date;
  - each date counts as a worked day for the seventh-day rule.
- **Today:** the start workday owns every hour (`packages/payroll-engine/src/non-union.ts:12-13`,
  :44-45).
- **Ratifiers:** **Brian Petros**, who wrote the non-union rules, and Corrina Bustos.
- **Not asked, and needed before it is built:** where the split starts.
  - The answer covers entries **over 24 h**. An entry under 24 h stays in its start workday
    ([../payroll/non-union-hourly-rules-2026-09-07.md](../payroll/non-union-hourly-rules-2026-09-07.md)
    §10).
  - If the split falls at every midnight, including the first, a 25 h entry is cut at a midnight
    where a 23 h entry is not.
  - The other reading is that the split applies only after the first 24 h.
- **Union and non-union now differ on purpose.** A1 keeps the union ladder running through one
  entry. B2 restarts the non-union ladder at each midnight of a 24 h+ entry.

## C. Behaviour and workflow

### C1. Every flag blocks weekly approval until it is resolved — settled

- **Answers:** the 2026-09-28 note's [second addendum, item G](2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md#g-a-single-ticket-over-24-h-price-it-flag-it-for-review-amends-clause-6-added-later-on-2026-09-29),
  *whether the flag blocks approval or only warns*; and, for the flags,
  [payroll/gaps.md → *Which payroll issues block approval (PAY-065)*](../payroll/gaps.md#which-payroll-issues-block-approval-pay-065--a-provisional-list-is-live-in-every-tenant).
- **The developer, verbatim (round 4):** *"we consider these tickets as flagged if there is any
  flagged tickt in weekly payroll paaroved button should be disable for that week before mark as
  approved we need to resove it firest"*.
- **Round 5:** every flag blocks. A flag is resolved by a Send Back or by clearing it (C2).
- **Standing: settled.** Corrina's verified flag-list decision says the same thing: *"all of these
  will need to be adjusted and fixed before the payroll can be approved"*. The developer's answer
  agrees with it and adds nothing to it. G's over-24-hour flag blocks like every other flag.

### C2. "Reviewed, no change" — settled

- **Answers:** the incomplete-tickets note, [*Not decided*, item 4](2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md#not-decided--recorded-not-resolved),
  and the flag-list note's open item 2.
- **Answer:**
  - a **note is required**;
  - the action is **audited**;
  - only the **Payroll Admin / Payroll Manager** may do it;
  - it is available for **every flag type**, the asset flag (flag 9) included.
- **Standing: settled.** Corrina said yes to the action (*"yes that would be a good option"*,
  verified). The developer set its mechanics. Limiting it to the two payroll roles matches her
  routing: all flags go to those two, and either may adjust. **Build it.**

### C3. The worker on a Send Back edits the ticket times on mobile and resubmits — settled

- **Answers:** the flag-list note, [*Not decided*, item 5](2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md#not-decided--recorded-not-resolved)
  (the worker's mobile screen and edit rights; edit or only reply), and the open remainder of
  [payroll/gaps.md → *Flagged entries go to payroll…*](../payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives)
  Q3.
- **Answer:** the worker **edits the ticket times** on mobile, then resubmits. Payroll then
  recalculates.
- **Standing: settled, as mechanics.** Corrina decided that Send Back goes to the worker (verified).
  Whether the worker edits or only replies is how that works, and the developer chose edit. The
  unverified Confluence US-03 AC 4 also lets the worker edit *"the specified ticket"*.
- **Not stated:** whether the resubmitted times re-run the flags, or whether Payroll must still
  clear the flag after recalculating.
- **See C6** for what happens on a ticket more than one worker shares.

### C4. The reminder goes to the worker, every 3 hours, until they respond — settled

- **Answers:** the flag-list note's open item 5 (who receives the 3-hour reminder, and whether it
  repeats), and gaps Q3 and Q5(f).
- **Answer:** to the **worker**, every **3 hours**, until they respond.
- **Standing: settled, as mechanics.** The 3 hours and the worker as target are Corrina's (verified).
  The recipient and the repetition are the developer's. It matches her own 2026-08-04 ask, *"Is
  there a way we can set up like an auto reminder if they haven't replied?"*
  ([../meetings/transcripts/2026-08-04-payroll-process.md](../meetings/transcripts/2026-08-04-payroll-process.md)
  l. 78).
- "Respond" is not defined further. Under C3, the worker's response is resubmitting the ticket.

### C5. Flag 9 blocks that ticket's crew's weeks — settled

- **Answers:** the flag-list note's open item 3 (*"Whose week does it block: the crew on that
  asset's ticket, or the whole period?"*) and the gaps entry's open point *whose week an asset flag
  blocks*.
- **Answer:** flag 9 (asset not back at its departure yard) blocks the weeks of **that ticket's
  crew** until it is resolved or cleared as reviewed (C2).
- **Standing: settled, as mechanics.** Corrina said every flag blocks. Which weeks carry the block
  is how that works.

### C6. A shared ticket is sent back to every worker on it, and blocks all their weeks — pending Corrina

- **Answers:** [payroll/gaps.md → *Send Back of a multi-crew ticket*](../payroll/gaps.md#send-back-of-a-multi-crew-ticket--does-sending-a-ticket-back-also-return-it-for-the-other-crew-members-on-that-ticket),
  raised by the 2026-09-28 note's [fifth addendum, item D](2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md#d-send-back-from-any-date-row-returns-the-whole-ticket).
- **Round 3:** *return it for everyone*. The send-back covers every crew member's entry on that
  ticket. That is option (c) of the gap.
- **Round 6, verbatim, after the session put Corrina's worker-target rule to the developer:** *"we
  have rule if any job have oiler and oprator both then oiler and oprator have one tickt so if we
  send oiler or oprator ticket back it should send other employee as well and block both employees
  payroll"*.
- **Answer:** sending back one worker's entry on a shared ticket sends the ticket back to **every
  worker on it**, and **blocks every one of their weeks** until it is resolved. That is option (c),
  with option (b)'s hold as well.
- **The shared ticket is a verified shape.**
  [2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md](2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md)
  clause 2: when the crane set has an Oiler, the Oiler is the ticket's primary employee and fills it
  in. The Operator is a second employee on the same ticket, with a separate labor record that the
  Oiler enters.
- **Standing: developer reading, pending Corrina Bustos.** It extends her verified rule, *"send the
  entry back to the worker"*, from one worker to every worker on the ticket. **It needs her OK.**
- **In tension with a verified rule.**
  [2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md](2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md)
  clause 3 (Corrina: *"individual"*): a correction to a shared time changes that one employee's
  hours, not the whole crew's.
  - She said that about payroll's own correction.
  - C6 is about Send Back, where a worker edits the shared ticket on mobile (C3).
  - Not stated: if the Oiler edits the shared ticket times, does the Operator's pay move too
    (shared), or only the Oiler's (individual)?
- **Build:** an API change, not built. `sendBack` would create a send-back for each worker on the
  ticket, and `countBlockingByEmployee` would hold each of their weeks. Today a send-back is per
  (period, ticket, employee), and only that employee's week is held.

### C7. An incomplete ticket blocks Approve only, not Calculate — pending Corrina

- **Answers:** the incomplete-tickets note, [*Not decided*, item 1](2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md#not-decided--recorded-not-resolved)
  (*"processed/approved"*: does it also block Calculate?).
- **Answer:** it blocks **Approve** only. **Calculate** stays allowed. The overlay shows the pending
  tickets beside the calculated week, as
  [2026-09-10-pending-tickets-are-a-display-only-payroll-overlay.md](2026-09-10-pending-tickets-are-a-display-only-payroll-overlay.md)
  already does.
- **Standing: developer reading of Corrina's word "processed", pending her.** The approval gate
  gains the "tickets not completed" blocker either way. Only the Calculate half waits on her.

### C8. A never-completed ticket: Payroll Admin/Manager may complete it or void it — pending Corrina

- **Answers:** the incomplete-tickets note's open item 2 (an escape path for a ticket that never
  completes).
- **Answer:** the Payroll Admin or Payroll Manager may:
  - **complete** it, entering the missing times; or
  - **void** it.

  Either way a note is required, and the action is audited.
- **Standing: developer reading, pending Corrina.**
  - **Completing** sits inside what she already decided: payroll may fix any time (verified). The
    2026-09-28 clause 4 also lets missing captures be added.
  - **Voiding a ticket is new**, and reaches beyond payroll. A voided ticket may matter to dispatch
    and to billing. Nobody has asked either of them.

### C9. A correction that moves an entry into a settled week is processed in the current open week — pending Brian / Corrina

- **Answers:** the 2026-09-28 note, [second addendum, item F](2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md#f-a-correction-may-move-an-entry-into-another-pay-week-amends-clause-4-added-later-on-2026-09-29),
  *Not recorded: what happens when the week the entry moves into is already approved or exported*.
- **Answer:** *"process that in current open week"*.
- **Standing: developer reading, pending Brian Petros and Corrina Bustos.** Which week pays an hour
  is a pay-process rule.
- **Tension with item F:**
  - F says the entry's anchor follows the corrected Start Ticket.
  - This answer pays the hours in a week that does not contain that Start Ticket. It is an
    exception to the anchor rule.
- **The nearest written source:** the closed-payroll proposal in
  [../payroll/payroll-rule-dependency-matrix.md](../payroll/payroll-rule-dependency-matrix.md)
  (l. 122–126). It is an unverified recommendation: the posted payroll stays immutable, and the
  difference is a retroactive adjustment for Payroll to review (PAY-068, *Pending*).
  - This answer agrees that a settled week is not reopened.
  - It differs on the method: it moves the entry's hours, instead of posting a difference.
  - The verified incomplete-tickets note leaves corrections to an approved week to that policy.
- **Not stated:** whether the moved entry is priced in the open week's context (its weekly-OT and
  seventh-day counts), and at which week's rates.

### C10. End Work is the crew leaving the job site — a conflict answer, pending the field-ops owner

- **Answers:** the conflict noticed in the 2026-09-28 note's third addendum,
  [*What the names mean*](2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md#what-the-names-mean).
  It was noticed there and not registered.
  - [../../aidlc/SCRUM-PROGRESS/spec.md](../../aidlc/SCRUM-PROGRESS/spec.md):201 (REQ-05,
    `[UNVERIFIED]`) says End Work *"closes `WORK_AT_JOB_SITE_TIME` when the crew leaves the job
    site"*.
  - The mobile code closes it when the break-down timer ends
    (`apps/mobile/features/field-ticket/steps/start-work/StartWorkBody.tsx:261-274`, as cited on
    2026-09-29).
- **Answer:** End Work closes when the crew **leaves the job site**, siding with the SCRUM-PROGRESS
  spec.
  - **Mobile must change:** it must close `WORK_AT_JOB_SITE_TIME` later than the break-down end.
  - **The correction page changes too.** Its *End Work Time* hint is *"break-down end"* (third
    addendum, item C). The session's record says the page's End Work lock changes as well. What
    that lock is, is not recorded here.
- **Pay is not affected.** Payroll prices `WORK_TIME` (Start Ticket → End Ticket). See the resolved
  [payroll/gaps.md → *Payable time*](../payroll/gaps.md#payable-time--start-work-to-end-work-or-yard-to-yard).
- **Billing may be affected, and nobody has asked about it.**
  - The API treats `WORK_AT_JOB_SITE_TIME` as the **billed** window: Net Billable Hours are
    arrived-at-job-site → End Work (`apps/api/src/usecase/ticket-labor-entries/compute-labor-hours.ts:15-17`;
    `apps/api/src/usecase/job-tickets/ticket-step.constants.ts:44`, checked 2026-09-30).
  - Moving End Work to leaving the site lengthens that window by the time between break-down end
    and leaving. The window then ends where `JOB_SITE_TIME` ends.
  - The verified SCRUM-877 REQ-02 defines Net Billable from boom time
    ([../../aidlc/SCRUM-877/spec.md](../../aidlc/SCRUM-877/spec.md):113, :183), not from this
    window.
  - This note does not decide what a customer is billed. Check the billing consumers before mobile
    ships the change.
- **Standing:** developer direction on a disagreement between two CodingCops artifacts, an
  unverified spec and the code. What End Work means on a ticket is for **TCG's field-ops owner** to
  ratify.

### C11. Lunches can be added, removed and switched on the correction page — resolves clause 4's self-contradiction

- **Answers:** the contradiction recorded in the 2026-09-28 note's first addendum,
  [*Stale lines in the original note*](2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md#stale-lines-in-the-original-note).
  Clause 4 says both *"Adding or removing a lunch is not supported"* and *"Lunches can be added,
  removed, and switched between taken and worked through"*.
- **Answer:** add, remove and switch are all allowed. The second bullet governs, and the first is
  superseded (`supersedes_partial` above).
- **Standing:** developer direction on the developer's own `reference` note, within that note's
  ratification: the TCG field-ops owner, for clause 4's edit rights.
  - Corrina's *"all times"* (2026-09-29, verified) says which times payroll may edit.
  - It does not mention adding or removing a lunch.
- **Pay effect:** switching taken ↔ worked-through changes pay, because WTL adds a paid half-hour
  (PAY-047). Each such edit is a pay-changing correction, audited like any other (clause 4, *Audit
  trail*).
- **Scope:** this is the correction form. Whether payroll's own fix, and the worker's mobile edit
  (C3), allow the same lunch edits was not stated.

## D. Superseded

### D1. The developer's first-round week rule — superseded by Corrina; nothing is built from it

- **It answered:** [payroll/gaps.md → *Multi-day entry — which pay period owns the hours after Saturday 00:00*](../payroll/gaps.md#multi-day-entry--which-pay-period-owns-the-hours-after-saturday-0000)
  (item E(a)).
- **The developer, verbatim (round 1):** *"if its done on time of payroll calculation all of it will
  process with previous week otherwise if ticket is not complete then move that ticket to next week
  payroll"*.
- **Clarified in round 2 as "Week 1, until approved":**
  - any calculation of week 1 that finds the ticket complete takes the whole ticket;
  - it moves to next week only once week 1 is approved or exported without it;
  - it is never split.

  Building it would have needed a change to the engine and the API's loader.
- **Superseded by** Corrina Bustos, verified, the same day:
  [2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md](2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md):
  *"no, all tickets must be completed before the payroll can be processed/approved"*.
  - An incomplete ticket blocks its week (C7).
  - It never rolls forward.
  - **The developer chose her rule in round 6.**
- **Recorded only as superseded.** Nothing is built from it, and the loader change it needed is
  not to be made.
- **What stays open in that gap:** anchor or split for a completed ticket that crosses Saturday
  00:00.
  - Corrina's note asks the same thing as its open item 3 (*"Confirm which week a ticket belongs to
    for this rule: the work date, or the start"*).
  - The engine anchors today.
  - The superseded answer is not a source for the anchor.

## What this note does not decide

- Anchor or split across the week line (D1).
- The boom basis (flag-list note, open item 1), asked twice and unanswered.
- Whether item G's review flag and flag 5's over-24-hours check are one flag (A7).
- What a customer is billed once End Work moves (C10).
- Whether the non-union split starts at the first midnight (B2).
- For a worker's mobile edit of a shared ticket, whether the other worker's pay moves (C6).
- Whether voiding a ticket needs dispatch or billing sign-off (C8).
- How a moved entry is priced in the open week (C9).

## Effect on the vault

Done in the same pass:

- **This note.**
- **[payroll/gaps.md](../payroll/gaps.md):** a dated *Developer answer 2026-09-30* bullet was added
  to each entry below. Every entry's `Status` stays **open**. Sub-questions settled by a verified
  client decision plus the developer's mechanics are marked answered inside their entries.
  - *Which payroll issues block approval (PAY-065)*
  - *Flagged entries go to payroll, not the crane superintendent*
  - multi-day entries (a) to (h)
  - *Send Back of a multi-crew ticket*
- **[2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md](2026-09-28-flagged-entries-boom-range-and-send-back-to-crane-supervisor.md):**
  a short note in its fifth addendum only. It covers what "sent back as a whole" now means, and
  says the Crane Supervisor correction page is superseded as the corrector.

Not changed:

- **No other file's frontmatter.** A developer's `reference` direction verifies and supersedes
  nothing.
  - The 2026-09-14 one-ticket note and the 2026-09-04 cross-midnight note stay `verified`, as
    written.
  - The provenance rows are untouched.
- **Outside this pass's write scope, and handed to the main session as exact text:**
  - [../payroll/INDEX.md](../payroll/INDEX.md): a line for this note;
  - [../payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md): Pending rows
    for B1 and B2, and a *Still open* note on the minimums rows (A2);
  - [../field-ops/gaps.md](../field-ops/gaps.md): the 24 h+ ticket question (A6) and End Work (C10).

## Follow-up answers, same day (2026-09-30)

Asked after the answers above were recorded, on points the recording raised. Same standing: the
developer's direction, `reference`, pending client ratification wherever a pay rule is involved.

- **A4 refined — subsistence, long tier:** the $200/day long (holdover) tier keeps the Confirmed rule,
  *every calendar day of the holdover, worked or not* (`payroll-rules-provenance.md:130`). *Start date
  only* applies to the $85/day "days worked" tier. This removes A4's conflict with the Confirmed row
  for the long tier.
- **C10 refined — End Work and billing:** yes, customers are billed until the crew leaves the job site.
  Moving End Work later is meant to lengthen the billed Work-at-Job-Site window. Pay is unaffected.
  Still needs the field-ops owner's confirmation ([../field-ops/gaps.md → *End Work*](../field-ops/gaps.md#end-work--break-down-end-or-the-crew-leaving-the-job-site)).
- **C6 refined — a shared ticket's edit:** on a shared operator + oiler ticket, shared ticket times
  (yard, site and work) move for both workers when either edits them; each worker fixes only their
  own personal times. This is the developer's reading **against** Corrina's verified *"a fix changes
  only that one person"* (2026-09-29) — recorded as a conflict for her to settle, not as settled.
- **B2 refined — non-union midnight split:** the split applies at **every** midnight, always, not
  only once an entry passes 24 h. A 22:00 → 03:00 non-union shift is two workdays. This widens B2
  beyond entries over 24 h, so it still changes pay and is **not to be built until ratified**.

## Later the same day — the build plan (2026-09-30)

Given while planning the flagged-entries rework (ticket `PAYROLL-FLAGS`, `.ai/aidlc/PAYROLL-FLAGS/`).
Developer direction, `reference`.

- **E1 — Approve and Export narrow to Payroll Admin and Payroll Manager.** Today any `payroll:edit`
  holder (every seeded manager/admin role) may approve and export. From this rework, only holders of
  the Payroll Admin / Payroll Manager access may. Other managers keep view and Calculate.
- **E2 — Who is "Payroll Admin" is a Department Roles setting.** No fixed permission bundle is seeded
  for the role: whoever a tenant's department roles grant the payroll-admin permission to acts as
  Payroll Admin/Manager, and what else they can do is whatever their role grants.
- **E3 — the under-8-hours rest flag fires on any gap under 8 h**, not only when the PAY-045 OT/DT
  trigger holds (so it also flags a short gap that earns no rest premium).
- **E4 — PR #699 is closed** (2026-09-30T09:22:51Z). Its Crane Supervisor correction flow is
  superseded; its reusable parts are salvaged into the new units off `main`.

## Round 9 — the flag definitions and designs (2026-09-30)

The coordinating session asked these later on 2026-09-30 to unblock units U14–U21 of ticket
`PAYROLL-FLAGS`. The developer is the same (`devmohsinakram`), in the same chat. Two answers are
verbatim and quoted (F5, F13). The rest are the option the developer picked, in the session's
wording.

**This round has two standings. Neither is a client ruling.**

- **Client-owned rule: developer reading, pending ratification (F1–F15).** TCG makes the rule. The
  developer answered so that U14–U21 can be built, and they are being built against these readings
  now. Each stays **open** in its register until the named ratifier confirms or overrules it.
  None is a pay rule. A flag blocks approval and changes no amount, so no
  `payroll-rules-provenance.md` row is involved.
- **CodingCops design: settled by the developer (G1–G2).** How the platform stores and edits a
  correction is CodingCops's call, not TCG's. These are closed.

| # | Answer | Answers | Standing | Ratifier |
| --- | --- | --- | --- | --- |
| F1 | Boom basis = the crane's min–max boom range | payroll Q6 | Client-owned, pending | Corrina Bustos (the gap suggests Brian Petros or the demo) |
| F2 | Wrong AM/PM = an out-of-order time that a 12-hour shift would put in order | payroll Q7 | Client-owned, pending | Corrina Bustos |
| F3 | Labor vs ticket = the worker's own work window vs Start/End Ticket, more than 30 min apart | payroll Q7 | Client-owned, pending | Corrina Bustos |
| F4 | A boom session outside Start Work → End Job is invalid | payroll Q8 | Client-owned, pending | Corrina Bustos |
| F5 | When a note is required (flag 4) | no register entry | Client-owned, pending | Corrina Bustos |
| F6 | Crew grouping = same job + same date | payroll Q10(c) | Client-owned, pending | Corrina Bustos |
| F7 | The crew flag is one ticket-level flag | payroll Q10(d) | Client-owned, pending; blocking scope **to confirm** | Corrina Bustos |
| F8 | Samsara signal = the asset leaving / re-entering the yard's location | payroll Q9, Q11(b) | Client-owned, pending | Corrina Bustos |
| F9 | Samsara points = start and end of day only | payroll Q9, Q11(a) | Client-owned, pending | Corrina Bustos |
| F10 | No Samsara data → no flag | payroll Q9, Q11(c) | Client-owned, pending | Corrina Bustos |
| F11 | Yard radius = 500 m | assets Q5 | Client-owned, pending | TCG assets owner, with Corrina Bustos |
| F12 | Departure yard taken from the Samsara location | assets Q3 | Client-owned, pending | TCG assets owner |
| F13 | The asset is judged once the ticket's end date has passed | assets Q2, **tension** | Client-owned, pending | Corrina Bustos, Lisette Anzaldo |
| F14 | Cranes only; holdover jobs skipped | assets Q6, Q8 | Client-owned, pending | Corrina Bustos (scope), Lisette Anzaldo (holdover) |
| F15 | Dispatch-permission holders notified, in-app and by email | assets Q1 remainder | Client-owned, pending | Lisette Anzaldo |
| G1 | Per-person corrections live in a per-employee override table | payroll C4 | **Settled** (CodingCops design) | — |
| G2 | On a returned ticket the worker may edit every time, segment and lunch, each with a reason | flag-list note, open item 5 | **Settled** (CodingCops design) | — |

"payroll" is [../payroll/gaps.md → *Flagged entries go to payroll…*](../payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives).
"assets" is [../assets/gaps.md → *Asset not returned to its home yard at end of shift*](../assets/gaps.md#asset-not-returned-to-its-home-yard-at-end-of-shift--a-requested-flag-with-no-owner-no-yard-geometry-and-no-shift-end).

### F. Client-owned rules — developer readings, pending ratification

**F1. Boom basis (payroll Q6): the crane's min–max boom range.**

- This is what is built. It is also what clause 1 of the 2026-09-28 note said.
- It matches the wording Corrina assented to, *"the crane's boom range"*. Her assent did not choose
  between the two bases, and she was asked twice. The job's crane configuration set by sales
  (Melissa McNutt, 2026-05-28) is **not** used.
- A crane with no range recorded gives `RANGE_MISSING`. That result is a flag like any other, and it
  **blocks** (C1). This was already answered.

**F2. Wrong AM/PM (payroll Q7).** Flag an out-of-order time that adding or removing 12 hours would
put in order.

**F3. Labor vs ticket (payroll Q7).**

- The check compares the worker's **own** work window with the ticket's Start Ticket → End Ticket.
- It flags when they differ by **more than 30 minutes**.
- *Start Ticket → End Ticket* is defined in
  [../payroll/gaps.md → *Payable time*](../payroll/gaps.md#payable-time--start-work-to-end-work-or-yard-to-yard).
- The 30 minutes is new here. Corrina's 30 minutes (2026-09-29) is the **Samsara** tolerance, and
  this answer reuses the figure.
- Joe Schacatano's 2026-06-23 example (employee 9½ h vs ticket 8 h) would flag.

**F4. Invalid long boom (payroll Q8): yes.** A boom session that starts before Start Work, or ends
after End Job, is invalid. This is in addition to Corrina's three checks: the same start and end,
out of order, and wrong AM/PM.

**F5. When a note is required (flag 4, *Missing notes*).** The developer, verbatim: *"for all and
also include if he mark any issue on checklist"*. The session had offered four cases, and *"for
all"* takes all four. The developer added a fifth. A note is required when:

- (a) a captured time was adjusted;
- (b) a lunch was worked through (WTL);
- (c) any flag is on the entry;
- (d) the ticket is over 12 hours;
- (e) the worker marks any issue on a checklist.

No register entry asks this. The flag's only other written source is the unverified Confluence KPI
*"Entries with Notes Missing"* (cited in
[2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md](2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md)).

**F6. Crew grouping (payroll Q10(c)): same job + same date.** The DAS allocation is not the
grouping.

**F7. Crew flag owner (payroll Q10(d)): the ticket only.** It is one ticket-level flag, not a
per-employee payroll flag.

- **Session reading, to confirm:** it blocks the weeks of **everyone on that ticket**, as flag 9
  does (C5).
- **Not stated:** which ticket carries it. Left Yard and Arrived at Yard are per ticket, so a
  difference is always between two tickets of the group.

**F8. Samsara signal (payroll Q9, Q11(b)): the yard's location.**

- **Left Yard** is compared with the moment the asset **leaves the yard's location**.
- **Arrived at Yard** is compared with the moment it **re-enters** it.
- The tolerance is 30 minutes: Corrina's own words, 2026-09-29, and item 7 of the verified flag
  list.
- This needs yard geofences, and none exist today. The integration has engine-state events, trips
  and GPS, and no geofence events (the 2026-09-30 crew-time-mismatch note, *What the code has*).
  F11 sets the radius.
- **Her example named a different signal.** Her 2026-09-30 example used engine-on (*"samsara does
  not show engine on until 730am"*), and the developer chose the yard exit. Her 2026-09-29 phrase
  *"geotag time"* fits a location signal. She has not chosen either.

**F9. Samsara points (payroll Q9): the start and end of the day only.** The check compares Left Yard
and Arrived at Yard. Arriving at and leaving the job site are not compared. This is the same scope as
item 7 of the verified flag list (*"at the start or end of the day"*, confirmed by assent).

**F10. No Samsara data (payroll Q11(c)): no flag.**

- This was answered for the **Samsara time flag** (U20) only.
- For the asset flag (F13), the handling of untracked or silent assets was not stated. assets Q7
  stays open.
- **Consequence:** an untracked crane, or a linked crane that has gone silent, never raises the
  Samsara time flag. See
  [../assets/gaps.md → *Which dispatchable cranes are untracked…*](../assets/gaps.md#which-dispatchable-cranes-are-untracked-and-what-stands-in-for-them--asked-twice-unanswered-twice)
  and [*A Samsara link that has gone silent*](../assets/gaps.md#a-samsara-link-that-has-gone-silent--three-200-ton-plus-cranes-have-not-reported-in-813-months).

**F11. Yard radius (assets Q5; used by F8, F12 and F13): 500 m** from a yard's address coordinates.
`Address` carries latitude and longitude since migration `20260917000000_address_county_and_coordinates`.

**F12. Departure yard (assets Q3): from the Samsara location.**

- The departure yard is the yard whose geofence the asset was **inside when it first left that
  day**.
- This replaces the example derivation in
  [2026-09-30-crew-flag-compares-left-and-arrived-yard-asset-must-return-to-departure-yard.md](2026-09-30-crew-flag-compares-left-and-arrived-yard-asset-must-return-to-departure-yard.md)
  (*"the Samsara location at the first engine-on or trip start"*). `Asset.yardId` is still not the
  rule.
- Corrina ratified the departure-yard rule itself. What is listed for ratification here is how the
  departure yard is derived, alongside the rest of flag 9. That note had called this derivation
  CodingCops design.

**F13. When the asset is judged (assets Q2): after the ticket's end date.** The developer,
verbatim: *"after ticket end date pass"*. Once the ticket's end date has passed, the check asks
whether the asset is inside its departure yard's geofence. If it is not, the asset is flagged.

- **Tension with a verified note, recorded and not resolved.** Corrina, 2026-09-30:
  [2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md](2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md)
  clause 3, verbatim: *"I dont think it would go off a time. it would trigger if the asset shut off
  at address other than the los alamitos or Ventura yard addresses."*
  - Her trigger is an event: a shut-off away from the yard.
  - This one is a position check, made once a date has passed.
  - The two can give different answers. For example, an asset shut off away from the yard, and
    back inside it by the time the check runs, flags under hers and not under this one.
  - Corrina ratifies which one applies.
- **It replaces the developer's own earlier reading, "the last engine shut-off of the day"** (the
  crew-flag note, clause 2). That reading was never ratified.

**F14. Scope (assets Q8, Q6): cranes only, and holdover jobs are skipped.**

- *"Cranes only"* narrows Corrina's *"an asset"*.
- The holdover exclusion is her own. What makes a job a holdover is still open in
  [../dispatch/gaps.md → *Does copying allocations make a job a holdover?*](../dispatch/gaps.md#does-copying-allocations-make-a-job-a-holdover).

**F15. Dispatch notification (assets Q1 remainder).** Holders of the dispatch permission are
notified, in-app and by email. Corrina's words were only *"dispatch notified"*. Who is notified, and
how, belongs to dispatch.

### G. CodingCops design — settled by the developer

**G1. Per-person corrections: an override table (payroll C4).**

- Payroll's correction for one person is stored as a **per-employee override**: ticket, employee,
  step, corrected time, reason, and who made it and when.
- The shared ticket times stay as captured. Pricing and payroll read an employee's override where
  one exists.
- This is the per-employee home for corrected times that clause 7 of the verified
  [2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md](2026-09-14-crew-ticket-shape-primary-allocation-and-ticket-employees.md)
  left undecided. It is how Corrina's *"individual"* (2026-09-29) is stored.
- **It does not settle** what a **worker's** mobile edit of a shared time does. That is C6's refined
  answer, and the conflict with Corrina is still pending.

**G2. Worker edits on a returned ticket (U14): all of it, each with a reason.**

- The worker may edit the ticket times, the segment timers (build-up, boom, break-down), and
  lunches / WTL. Every edit carries a reason.
- This extends C3, and answers the edit-rights half of the flag-list note's open item 5.
- On a shared ticket, what an edit of a shared time does is still C6's pending conflict.

### Not settled by round 9

- **Q6:** the developer's answer is not Corrina's choice. The gap's suggestion stands: route it to
  Brian Petros, or raise it at the demo.
- **Q7:** the rest of *"etc"*. For F3, whether "more than 30 minutes" is measured at each end or on
  the total.
- **Q8:** boom hours with no long-boom bracket.
- **F7:** which ticket carries the crew flag, and its blocking scope.
- **Flag 9 (F10):** untracked or silent assets (assets Q7).
- **F12 and F13:**
  - which day's departure yard a multi-day ticket is judged against;
  - assets legitimately parked at a site on a non-holdover multi-day job.
- **Unchanged from before:**
  - Q4, Q5(d)'s manual half, and C1's confirmation trail;
  - C3, C5 and C6 of the gaps entry;
  - C6's refined conflict on shared-ticket edits.

### Effect on the vault (round 9)

Done in the same pass:

- **This section**, and this note's frontmatter: `decided_by`, `conflicts_with`, `resolves` and
  `tags`.
- **[../payroll/gaps.md → *Flagged entries go to payroll…*](../payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives):**
  - a dated *Developer answer 2026-09-30 (round 9)* bullet under each of Q6, Q7, Q8, Q9, Q10 and
    Q11, and under C4;
  - **C4 marked answered**;
  - the status line updated. **The entry stays open.**
- **[../assets/gaps.md](../assets/gaps.md):**
  - *Asset not returned to its home yard…*: a round-9 bullet under Q1, Q2, Q3, Q5, Q6, Q7 and Q8,
    and the status line updated. It stays open.
  - *Which dispatchable cranes are untracked…* and *A Samsara link that has gone silent*: one dated
    bullet each, on F10's consequence. Neither question is answered.
- **[../dispatch/gaps.md → *Pointer — asset-not-home flag…*](../dispatch/gaps.md#pointer--asset-not-home-flag-depends-on-the-holdover-definition):**
  a dated bullet on F13–F15.
- **[2026-09-30-crew-flag-compares-left-and-arrived-yard-asset-must-return-to-departure-yard.md](2026-09-30-crew-flag-compares-left-and-arrived-yard-asset-must-return-to-departure-yard.md):**
  `provenance_note:` extended. Its "last engine shut-off" trigger and its example derivation of the
  departure yard are replaced by F12–F13. Its `status:` stays `reference`.

Not changed:

- **No `status:` anywhere.** A developer's `reference` direction verifies nothing.
- **The verified Corrina notes** are not changed. The F13 tension is recorded in this note's
  `conflicts_with`.
- **No provenance row.** None of these is a pay rule.
- **Outside this pass's write scope:** a
  [../payroll/INDEX.md](../payroll/INDEX.md) mention of round 9. The exact text was handed to the
  main session.

## Rounds 10 and 11 — flag details for PAYROLL-FLAGS U14–U21 (2026-09-30)

The coordinating session asked these later on 2026-09-30, after round 9. Round 10 filled the gaps
left in the draft spec for units U14–U21, and answered the open questions of the ticket's two
earlier spec files. Round 11 answered the last two questions of the U14–U21 spec (Q40, Q41). The
developer is the same (`devmohsinakram`), in the same chat. **No answer in these two rounds is
verbatim.** Each is the option the developer picked, in the session's wording.

The questions, with the options offered, are in §12 of the ticket's spec files:
[spec.md](../../aidlc/PAYROLL-FLAGS/spec.md) Q9–Q11,
[spec-u6-u13.md](../../aidlc/PAYROLL-FLAGS/spec-u6-u13.md) Q20–Q25 and
[spec-u14-u21.md](../../aidlc/PAYROLL-FLAGS/spec-u14-u21.md) Q40–Q41. Those files already mark
them resolved. This section is the vault's record of the answers.

**These rounds have three standings. None is a client ruling.**

- **Client-owned flag rule: developer reading, pending ratification (H1–H6).** The same standing
  as round 9's F items, each of which H1–H6 refines. Each stays **open** in its register until the
  named ratifier confirms or overrules it. A flag blocks approval and changes no amount, so no
  `payroll-rules-provenance.md` row is involved.
- **Pay rule: developer direction, pending ratification (J1–J2).** The same footing as section A:
  both keep what unit U2 built, and the other reading would change pay. Both stay **open** until
  Corrina Bustos and Brian Petros ratify.
- **Workflow and display: developer direction (K1–K5).** Each item says who, if anyone, still has
  to confirm it.

| # | Answer | Answers | Standing | Ratifier |
| --- | --- | --- | --- | --- |
| H1 | Any note on the ticket satisfies "a note is required" | payroll Q5(d); refines F5 | Client-owned, pending | Corrina Bustos |
| H2 | The crew yard-time flag holds only the mismatching workers | payroll Q10(c)(d); **narrows F7** | Client-owned, pending | Corrina Bustos |
| H3 | Where a 12-hour shift fixes a pair, only the AM/PM flag fires | payroll Q7; refines F2 | Client-owned, pending | Corrina Bustos |
| H4 | The labor-vs-ticket 30 minutes is on the total difference | payroll Q7; refines F3 (round 11) | Client-owned, pending | Corrina Bustos |
| H5 | A multi-day non-holdover job is judged after its last ticket date | assets Q2; refines F13, **tension stands** | Client-owned, pending | Corrina Bustos, Lisette Anzaldo |
| H6 | No Samsara data → no asset flag | assets Q7 (round 11) | Developer direction; owner recorded two ways | see H6 |
| J1 | The 2nd missed meal is counted per rest chain | payroll C1; spec Q9 | **Pay rule**, as built; pending | Corrina Bustos, Brian Petros |
| J2 | The rest gap is measured across `chainJobDays` boundaries | payroll C1; spec Q10 | **Pay rule**, as built; pending | Corrina Bustos, Brian Petros |
| K1 | The rest-audit panel shows the rule text, not the WTL minutes | spec Q11 | **Settled** (CodingCops display choice) | — |
| K2 | A payroll fix writes to the person's own window, with no billing effect | spec-u6-u13 Q20 | Own window **settled** (design); billing pending | TCG's billing owner (not named in the vault) |
| K3 | `/me/labor` shows the corrected hours | spec-u6-u13 Q21 | Developer direction | No TCG owner named for the screen |
| K4 | Completing a never-completed ticket is payroll-only, as voiding is | C8; spec-u6-u13 Q22 | Developer direction; pending | Corrina Bustos, with dispatch and billing |
| K5 | A worker's resubmit waits for the next Calculate | C3; spec-u6-u13 Q25 | Developer direction | Corrina Bustos or CodingCops (the spec named both) |

"payroll" is [../payroll/gaps.md → *Flagged entries go to payroll…*](../payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives).
"assets" is [../assets/gaps.md → *Asset not returned to its home yard at end of shift*](../assets/gaps.md#asset-not-returned-to-its-home-yard-at-end-of-shift--a-requested-flag-with-no-owner-no-yard-geometry-and-no-shift-end).

### H. Flag details — developer readings, pending ratification

**H1. What counts as a note (U17; refines F5).** Any note on the ticket satisfies "a note is
required":

- the labor comment;
- the left-yard comment;
- a ticket comment;
- the signature comment;
- a time-adjustment reason.

A note in any one of them is enough, whichever of F5's five triggers applies. It need not say
which trigger it answers.

- **Bears on:** payroll Q5(d), where *missing notes* is one of the six auto-flag sources Corrina
  named on 2026-09-29
  ([2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md](2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md)).
  Round 9 found no register entry asking *when* a note is required. Q5(d) is where the flag itself
  is recorded, so the dated line goes there.
- **Ratifier:** Corrina Bustos, together with F5.

**H2. The crew yard-time flag holds only the mismatching workers (U18; narrows F7).**

- Only workers whose **Left Yard** or **Arrived at Yard** differs from the rest of the crew are
  held. A worker whose times match the rest is not held.
- **This narrows round 9.** F7's session reading, marked *to confirm*, was that the flag blocks the
  weeks of **everyone on that ticket**, as flag 9 does (C5). The developer did not confirm it.
  This answer replaces it.
- Left Yard and Arrived at Yard are per ticket (F7). So in practice the held workers are the crew
  of the ticket whose times differ from the rest of the group. That also answers F7's *which ticket
  carries it*.
- **Bears on:** payroll Q10(c)(d); item 8 of the verified
  [2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md)
  (*"Left Yard or Arrived at Yard different for anyone on the job"*). Her words say when the flag
  fires. They do not say whose week it holds.
- **Ratifier:** Corrina Bustos.

**H3. Wrong AM/PM replaces out-of-order for that pair (U16; refines F2).**

- Where adding or removing 12 hours would put an out-of-order pair in order, **only the AM/PM
  flag** fires. It replaces the generic out-of-order flag (U7) for that pair. The two never fire
  together on one pair.
- Other out-of-order pairs keep the generic flag.
- Either way the pair is flagged, and every flag blocks (C1). This decides which flag payroll sees,
  not whether the week is held.
- **Bears on:** payroll Q7. Corrina's verified list names the two separately: *"incorrect use of
  AM/PM … times out of order, etc"*
  ([2026-09-29-invalid-entry-flags-samsara-30-minutes-and-wtl-penalty-moves-rest-start.md](2026-09-29-invalid-entry-flags-samsara-30-minutes-and-wtl-penalty-moves-rest-start.md)
  clause 1).
- **Ratifier:** Corrina Bustos, together with F2.

**H4. Labor vs ticket: the 30 minutes is on the total difference (U16; round 11, spec-u14-u21 Q40;
refines F3).**

- Flag when |own start − Start Ticket| + |own end − End Ticket| is **more than 30 minutes**. It is
  not measured at each end.
- Example: 20 minutes at the start and 20 at the end make 40 in total. That flags, though neither
  end alone passes 30.
- This answers what round 9 left open for F3 (*Not settled by round 9*, Q7).
- The ticket spec had proposed per edge as its default. The developer chose the total instead.
- **Bears on:** payroll Q7; *"labor not matching the ticket"*, under item 5 of the verified
  [2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md)
  (confirmed by assent).
- **Ratifier:** Corrina Bustos, together with F3.

**H5. The asset flag on a multi-day non-holdover job is judged after the job's last ticket date
(U21; refines F13).**

- On a multi-day job that is **not** a holdover, the asset is checked only once the **job's last
  ticket date** has passed. There is no nightly check in the middle of the job.
- This answers round 9's open case: an asset legitimately parked at a site between the days of such
  a job no longer flags each night.
- **It is still date-based, so the F13 tension stands.** Corrina's verified trigger is an event:
  *"it would trigger if the asset shut off at address other than the los alamitos or Ventura yard
  addresses"*
  ([2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md](2026-09-30-crew-time-flag-job-start-to-yard-return-across-tickets-and-asset-flag-on-engine-off.md)
  clause 3). Taken literally, hers fires on any shut-off away from a yard, mid-job included. This
  one checks nothing until the job has ended. On a multi-day job, the two can now differ on every
  night before the last.
- **Consequence:** a crane taken home overnight in the middle of a multi-day job is caught only if
  it is still away from its departure yard after the job's last ticket date. That is the case
  Corrina gave when she asked for the flag (*"This has happened when an EE has taken the asset
  home"*,
  [2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md](2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md)
  clause 4).
- **Not stated:** which day's departure yard the check uses. The ticket spec reads it as the day the
  asset first left, normally the job's first day (spec-u14-u21 REQ-52). That is the spec's reading,
  not the developer's answer.
- **Bears on:** assets Q2; this note's `conflicts_with`.
- **Ratifier:** Corrina Bustos, with Lisette Anzaldo, as F13.

**H6. An untracked or Samsara-silent crane raises no asset flag (U21; round 11, spec-u14-u21
Q41).**

- No Samsara data → **no asset flag**. This is fail-open, the same as F10 for the Samsara time flag
  (U20).
- **This answers assets Q7 for this flag, as developer direction.** Round 9 had left it open.
- **Consequence:** an untracked crane, or a linked crane that has gone silent, can raise neither
  Samsara-based flag, even when it is taken home. Three 200-ton-plus cranes have not reported in
  8–13 months:
  [../assets/gaps.md → *A Samsara link that has gone silent*](../assets/gaps.md#a-samsara-link-that-has-gone-silent--three-200-ton-plus-cranes-have-not-reported-in-813-months).
- **Owner, recorded two ways.** The assets entry's *Owner* line gives Q7's handling to CodingCops.
  The ticket spec's Q41 named Corrina Bustos, with the TCG assets owner. This note does not choose
  between them.
- **Not answered:** which cranes are untracked. That stays open in
  [../assets/gaps.md → *Which dispatchable cranes are untracked…*](../assets/gaps.md#which-dispatchable-cranes-are-untracked-and-what-stands-in-for-them--asked-twice-unanswered-twice).

### J. Pay rules — the rest gap start (U2), pending Corrina Bustos and Brian Petros

Both answers are *"as built"*. They keep what unit U2 built (`restGapStartMs`,
`packages/payroll-engine/src/rest-period.ts`), and both change pay against the other reading. The
provenance row *8-hour rest — gap start*
([../payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md), line 103)
already records both as built and pending. This pass does not change it.

**J1. The 2nd missed meal is counted per rest chain (spec Q9).**

- The meal that moves the rest-gap start is counted across the whole **rest chain**, as stitched by
  `REST_STITCH_MINUTES`. It is not counted per gapless meal group.
- Example: two tickets 1–30 minutes apart, each with one meal worked through. The second ticket's
  meal is the chain's 2nd, and moves the gap start 30 minutes.
- The two readings differ only for tickets 1–30 minutes apart. The provenance row *Rest chain
  stitching* (line 102) is Confirmed at back-to-back or overlapping only, with the ERP still at 30.
  Once that change lands, the readings differ only for tickets that touch once rounded (spec Q9).
- **Bears on:** payroll C1 (the WTL penalty moves the rest start) and C2 (only the 2nd missed meal
  onward moves it, Corrina, 2026-09-30,
  [2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md](2026-09-30-crew-time-mismatch-flag-first-wtl-does-not-move-rest-and-two-new-flag-ideas.md)
  clause 2). She was asked "the first, or the 2nd onward", not how the 2nd is counted across
  tickets.

**J2. The rest gap is measured across `chainJobDays` boundaries (spec Q10).**

- Every gap is measured from the rounded paid end plus the WTL extension. That includes a gap
  across a `chainJobDays` (OT/DT reset) boundary.
- Before U2, the engine never checked rest across that boundary. Now a raw gap of 8 hours or more
  that is under 8 hours once measured from the rounded end plus WTL is caught. This decides which
  runs get the rest premium at all.
- **Bears on:** payroll C1. None of Corrina's statements was asked whether the rule reaches across
  that boundary.

### K. Workflow and display — developer direction

**K1. The rest-audit panel shows the rule text only (spec Q11).**

- The panel names the rule (*plus any WTL penalty from the 2nd missed meal on*). It does not show
  the WTL minutes applied to this gap. No new column is added.
- **Standing: settled.** The ticket spec assigned this display choice to the developer.
- **Bears on:** no register entry. The panel displays the rest rule of
  [2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md](2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md)
  clause 5.

**K2. A payroll fix goes to the person's own window, with no billing effect (spec-u6-u13 Q20,
U8).**

- Payroll's fix always writes to that person's **own window**, even on a ticket with only one
  worker. The ticket's shared times stay as captured.
- So customer billing, which reads the ticket's shared times, is untouched.
- **Standing:**
  - The own window is how Corrina's verified *"individual"* is stored. That is CodingCops design,
    settled, as G1 is.
  - *"No billing effect"* is developer direction. TCG's billing owner, not named in the vault, has
    never been asked.
- **Bears on:**
  [2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md](2026-09-29-flagged-entries-payroll-corrects-per-employee-and-rest-from-rounded-paid-time.md)
  clause 3; G1.

**K3. `/me/labor` shows the corrected hours (spec-u6-u13 Q21).**

- The worker's own hours view reads the person's own window or override. So a worker sees payroll's
  corrected hours, and their own resubmitted edit.
- The ticket spec adds a requirement for it (REQ-33).
- **Standing:** developer direction. No TCG owner is named for this screen.
- **Bears on:** no register entry. It was raised only in the ticket spec (spec-u6-u13 Q21).

**K4. Completing a never-completed ticket is payroll-only, as voiding is (spec-u6-u13 Q22, U10).**

- Completing the ticket makes it priceable **for payroll only**. Billing, invoicing and dispatch
  are untouched, the same as for a void.
- **Bears on:** C8 above, which said voiding reaches beyond payroll and that nobody had asked
  dispatch or billing. Also the incomplete-tickets note,
  [*Not decided*, item 2](2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md#not-decided--recorded-not-resolved).
- **Standing:** developer direction. It answers C8's open half as a design, not as TCG's ruling.
  Dispatch (Lisette Anzaldo) and TCG's billing owner have still not been asked. C8 stays pending
  Corrina.

**K5. A worker's resubmit waits for the next Calculate (spec-u6-u13 Q25, U13).**

- A resubmit holds the week until payroll recalculates. Flags and pay update then. The resubmit
  does not re-run the flags by itself.
- This is how a payroll fix already holds until the next completed Calculate (the ticket spec's
  REQ-18).
- **Answers:** C3's *Not stated* (whether the resubmitted times re-run the flags).
- **Standing:** developer direction. It sets when flags are re-checked, not whether they block.
  Every flag still blocks until cleared (C1).
- **Bears on:** C3; the flag-list note,
  [*Not decided*, item 5](2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md#not-decided--recorded-not-resolved).

**Restated, not new (spec-u6-u13 Q23, Q24).** Round 10 answered these by pointing back to C6 and
to C6 refined (*Follow-up answers*). Nothing changes. A shared ticket sent back to every worker on
it is still pending Corrina. Shared times that move for both workers are still a conflict with her
verified *"individual"* rule.

### Not settled by rounds 10 and 11

- **H1:** whether another worker's labor comment on a shared ticket counts for this worker. The
  labor comment is per worker. The other four notes are per ticket.
- **H2:** a group that splits evenly, where no ticket differs from "the rest" (for example two
  tickets with two different times). The ticket spec proposes flagging every ticket
  (spec-u14-u21 REQ-46). That is its own proposal, not the developer's answer.
- **H5:** which day's departure yard a multi-day job is judged against.
- **H5:** the F13 tension with Corrina's verified trigger.
- **H6:** which cranes are untracked (assets, *Which dispatchable cranes are untracked…*).
- **Unchanged from round 9:** Q6's ratification, the rest of Q7's *"etc"*, Q8's boom hours with
  no long-boom bracket, and the other items under *Not settled by round 9*.

### Effect on the vault (rounds 10 and 11)

Done in the same pass:

- **This section**, and this note's frontmatter: `decided_by`, `provenance_note` and `resolves`.
- **[../payroll/gaps.md → *Flagged entries go to payroll…*](../payroll/gaps.md#flagged-entries-go-to-payroll-not-the-crane-superintendent--who-corrects-them-who-the-payroll-admin-is-and-whether-send-back-survives):**
  - a dated *Developer answer 2026-09-30 (rounds 10–11)* bullet under Q5(d) (missing notes), Q7,
    Q10 and C1 (the rest-start mechanics, J1–J2);
  - the status line, and the closing *Developer answer* list, updated. **The entry stays open.**
- **[../assets/gaps.md → *Asset not returned to its home yard…*](../assets/gaps.md#asset-not-returned-to-its-home-yard-at-end-of-shift--a-requested-flag-with-no-owner-no-yard-geometry-and-no-shift-end):**
  a dated bullet under Q2 (the multi-day judging) and Q7, and the status line updated. It stays
  open.

Not changed:

- **No `status:` anywhere.** A developer's `reference` direction verifies nothing.
- **The verified Corrina notes.** The F13 tension is already in this note's `conflicts_with`.
- **No provenance row.** J1 and J2 are pay rules, but the row *8-hour rest — gap start* already
  records both as built and pending.
- **`aidlc/PAYROLL-FLAGS/`.** Its spec files already mark these questions resolved.
- **Not in this pass's brief, and possibly worth a dated line:**
  - [../assets/gaps.md](../assets/gaps.md): *Which dispatchable cranes are untracked…* and *A
    Samsara link that has gone silent*. H6 extends F10's consequence to the asset flag.
  - [../dispatch/gaps.md → *Pointer — asset-not-home flag…*](../dispatch/gaps.md#pointer--asset-not-home-flag-depends-on-the-holdover-definition):
    H5.
  - [../payroll/INDEX.md](../payroll/INDEX.md): a mention of rounds 10 and 11.

## Round 12 — two follow-ups to H1 and H2 (2026-09-30)

Developer direction, `reference`, pending client ratification like H1 and H2 themselves.

- **H2 refined — an evenly split crew.** When a job + date group splits evenly on Left Yard or
  Arrived at Yard, so no worker differs "from the rest", the **oiler** is held. The developer's one-word
  answer was *"oiler"*; read with H2, the operator's (primary's) times are the reference and the
  oiler(s) who differ from them are held.
- **H1 refined — notes on a shared ticket.** Any note anywhere on the ticket satisfies "a note is
  required" for **everyone** on it, another worker's labor comment included.
- **F14 refined — which assets are cranes.** Any asset whose category name contains "Crane"
  (case-insensitive): Mobile Crane, Rough Terrain Crane, Crawler Crane, and any future "… Crane"
  category. Self Loader is not a crane for this flag. Assets have no typed category; the match is on
  `Category.name`.
- **F11 refined — which yard address is "the yard".** Any of the yard's addresses that has
  coordinates: within 500 m of any of them counts as at the yard.
