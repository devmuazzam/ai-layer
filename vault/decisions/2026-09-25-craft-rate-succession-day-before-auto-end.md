---
title: "Craft code rate succession — an open-ended previous rate is auto-ended the day before the new rate starts; open pay weeks warn, not block — decision"
source: decision/Syed Haris (CodingCops) — TCG-138 / PAY-008, 2026-09-25 Claude Code session
decided: 2026-09-25
decided_by: >-
  Syed Haris (syedharis14@gmail.com) — CodingCops developer/owner, answering five questions
  put to him directly in a Claude Code session on 2026-09-25 while TCG-138 was being closed.
  He is **not** the client-side product owner. Clauses 1 and 2 restate what TCG already heard
  and accepted on recorded calls (Corrina Bustos 2026-09-02 23:55 *"Perfect."*; Brian Petros
  2026-09-03 58:37) — see *Client record*. Clauses 3–5 are his own calls and nobody at TCG has
  spoken to them. Rate succession is a payroll-configuration question, and PAY-008's blocking
  item (*"Confirm configuration ownership"*) names the owners this register assigns it to:
  **Corrina Bustos** (Payroll Manager) and **Brian Petros** (Data Analyst, ERP Project
  Coordinator) — they roll the rates over each fiscal year, and they should ratify clauses 4
  and 5 in particular. `status: reference` rather than `verified` for that reason — the same
  basis as `2026-09-10-pending-tickets-are-a-display-only-payroll-overlay.md` and the other
  Syed Haris notes that name a client-side ratifier: binding on implementation now, open to
  being overruled by TCG.
status: reference
supersedes: []
conflicts_with: []
resolves:
  - payroll/gaps.md#adding-a-rate-when-the-previous-one-has-no-effective-to-date--back-fill-it-or-error
  - "PAY-008 (partial — craft code rates only; the configuration-ownership / approver item stays open)"
jira: [TCG-138]
tags: [module/payroll, kind/decision, craft-code, effective-dating, payroll-rules, reference-data]
entities: []
---

# Craft code rate succession — day-before auto-end

Settles how one craft code rate **succeeds** another: what happens to the previous rate's end
date, which date it gets, what it covers, what an already-calculated pay week does about it, and
who may do it. Answers the payroll register's
[*Adding a rate when the previous one has no effective-to date — back-fill it, or error*](../payroll/gaps.md#adding-a-rate-when-the-previous-one-has-no-effective-to-date--back-fill-it-or-error)
for craft code rates, and the *"rate closed under an open period"* question raised in that entry's
2026-09-24 update.

## Decision

1. **Back-fill, not error.** When a new craft code rate is added and the previous rate for that
   craft has **no effective-to date**, the system ends the previous rate automatically. No error.
   An effective-to date that is **already set is never rewritten**.

2. **The previous rate ends the day before.** The previous rate's effective-to is **the day
   before** the new rate's effective-from. New rate from July 1 → old rate effective-to June 30.
   This applies to **single Add Rate and Bulk Rate Update alike**.
   - **Affirms** the day-before clause of
     [2026-09-03-l12-bulk-rate-update-uniform-delta.md](2026-09-03-l12-bulk-rate-update-uniform-delta.md)
     (Ehtesham Anwar 58:07, *"effectively added from 10th. Automatically, the previous rates get the
     date 9th."*).
   - **Supersedes** the same-day rule (previous rate ends **on** the new rate's start date, new rate
     wins the shared day) in the TCG-138 ticket text, in commit `f1e1d0a27` (2026-09-12, *"close
     previous bulk rate on the new rate's start date"*, Bulk Rate Update) and in app PR #659
     (`fix/craft-rate-backfill-open-ended`, merged 2026-09-24, Add Rate).
   - **Existing rows that share a boundary day** (`previous.effectiveTo == next.effectiveFrom`) are to
     be **corrected to the day before** (`previous.effectiveTo = next.effectiveFrom − 1 day`).

3. **Scope: craft code rates only, for now.** Employee hourly/salary rates, price-list/billing rates
   and craft-modifier (boom adder) rates have **no rate history today**. Dating them — and whether
   this succession rule then applies to them — stays with TCG-168,
   [payroll/gaps.md → *Effective-dating the rest of payroll's rates (PAY-008, TCG-168)*](../payroll/gaps.md#effective-dating-the-rest-of-payrolls-rates-pay-008-tcg-168).
   Not decided here.

4. **Open pay weeks warn; they do not block.** When a craft code rate is added, ended or changed
   such that its effective window **overlaps a pay week that is `CALCULATED` or `REVIEW`**, and the
   change happened **after that week's latest completed calculation**, the payroll week shows a
   warning that rates changed since it was calculated and it should be recalculated. **Approve and
   export are not blocked** by this warning.

5. **Configuration ownership: keep current access.** Any user with craft-code write permission may
   create or end rates. **No second-person approval step.** PAY-008's *"approver"* requirement stays
   **open** for the client to raise later.

## Why

- **The client already heard and accepted clauses 1–2.** Ehtesham demoed the back-fill as the
  intended behaviour on 2026-09-02 and Corrina answered *"Perfect."*; he specified the day-before
  end date for the bulk path on 2026-09-03 and Brian accepted it. The same-day rule was introduced
  later, on the ticket and in code, without going back to the client.
- **The reason given for same-day was wrong.** TCG-138 argued that ending on *start − 1* would leave a
  $0 gap day. It does not: `CraftCodeRate.effectiveFrom/effectiveTo` are `@db.Date`, and
  `findRateInForce` (`apps/api/src/service/craft-codes/craft-codes.repository.ts:160`) treats
  `effectiveTo` as **inclusive** (`effectiveTo: { gte: date }`). With day-before, June 30 is priced
  by the old rate and July 1 by the new one — **pay is identical to same-day**. The choice is about
  what the stored record says, and *"last date valid"* is the reading every written source uses
  (see *Client record*). Same-day also leaves two rows both claiming the boundary day, which is why
  the repository needed a tie-break comment (`craft-codes.repository.ts:236`); day-before does not.
- **Open-ended previous rates are the normal case.** FCC overwrites rates in place and never uses its
  `StartDate`/`EndDate` columns
  ([payroll/rules/PAY-008-effective-dated-configuration.md](../payroll/rules/PAY-008-effective-dated-configuration.md)
  → *Open*), so every migrated rate arrives with no end date and the first ERP rate change on any of
  them hits this path. An error there would block every rollover.
- **Warn rather than block (clause 4).** NexGen's only answer to rate timing is an operating rule —
  process payroll **before** updating rates
  ([payroll/fcc-union-code-configuration.md](../payroll/fcc-union-code-configuration.md) ~200–204).
  The ERP prices per work date, so a late rate change is safe to recalculate; the risk is only that a
  stored `CALCULATED`/`REVIEW` result silently goes stale, which a warning addresses. Blocking
  approval would stop a payroll week over a rate change that may not touch it materially.
- **Keep access as it is (clause 5).** Nobody at TCG has asked for a second approver; adding one is a
  workflow the client should specify, not one CodingCops should invent.

## Client record (verified by reading, 2026-09-25)

All sources below are `status: unverified` migrated records; they are cited as what was said, not
adjudicated by this note.

- [meetings/transcripts/2026-09-02-erp-job-tickets-and-payroll.md](../meetings/transcripts/2026-09-02-erp-job-tickets-and-payroll.md)
  line 99, **Ehtesham Anwar 22:55**, demoing craft code rates: *"the new functionality is I add a new
  rate and I say it's going to be effective from today. Then automatically, instead of giving us this
  error, It's going to...add the previous day's date into the old rate and automatically make the new
  one effective from today."* Line 100, **Corrina Bustos 23:55**: *"Perfect."*
- [meetings/transcripts/2026-09-03-payroll-lunch-rules-and-dispatch-times.md](../meetings/transcripts/2026-09-03-payroll-lunch-rules-and-dispatch-times.md)
  lines 1136–1145: Brian Petros 57:44 asks to set rates in advance with start and end effective dates;
  **Ehtesham Anwar 58:07**: *"we say they are going to get effectively added from 10th. Automatically,
  the previous rates get the date 9th."*; **Brian Petros 58:37**: *"Oh, okay, so it would have the
  start date on there."*
- [meetings/transcripts/2026-08-13-payroll-process.md](../meetings/transcripts/2026-08-13-payroll-process.md)
  line 446, **Brian Petros 1:05:46**: *"they would still need a start and end date, effective dates."*
- [uat/sessions/17sep-internal-uat.md](../uat/sessions/17sep-internal-uat.md) line 39 (Fouzan Shakil,
  internal UAT, 2026-09-17), under *Craft Code*: *"When adding rate, if the previous date shouldn't
  have an effective date so it should add the new rate effective to date to that previous rate and
  shouldn't throw an error"* — the ask behind clause 1. Its wording of the date is ambiguous; clause 2
  settles it.
- [payroll/adp-bucket-crosswalk.md](../payroll/adp-bucket-crosswalk.md) line 151:
  `EffectiveEndDate | Last date valid; null means current` — the client's own crosswalk schema treats
  an end date as the **last valid day**, not the first invalid one. (It is the ADP bucket-mapping
  table, not the rate table — cited for the convention, not as a rate rule.)
- [payroll/fcc-union-code-configuration.md](../payroll/fcc-union-code-configuration.md) ~200–204 — the
  NexGen guide: *"Make sure all payroll is processed for the period when rates and benefits apply
  BEFORE updating to new rates and rules"* — the incumbent's manual workaround that clause 4 replaces
  with a warning.

## Correction to the 2026-09-03 note

[2026-09-03-l12-bulk-rate-update-uniform-delta.md](2026-09-03-l12-bulk-rate-update-uniform-delta.md)
says the day-before behaviour was *"the same auto-end-the-day-before behaviour **already built and
demoed** for single-rate effective dating"*. **That is wrong.** On 2026-09-02 Ehtesham demoed it as
*"the new functionality"* it was *"going to"* get (transcript line 99); single-rate back-fill did not
exist in the product until app PR #659, merged **2026-09-24** — and #659 ends the previous rate
**on** the new start date, not the day before. The 2026-09-03 note's **rule** (day-before) stands and
is affirmed by clause 2; only its claim about what was already built is corrected. Its body is not
edited; the correction is carried in its `provenance_note:` and here.

## What this does NOT decide

- **Any rate type other than craft code rates** — employee hourly/salary, price-list/billing, craft
  modifier (boom adder). TCG-168 owns them.
- **PAY-008's approver / configuration-ownership requirement** — deferred to the client (clause 5
  keeps today's access; it does not answer the matrix's blocking item).
- **Recalculation of `APPROVED` / `EXPORTED` weeks** after a rate change — out of scope; clause 4
  covers only `CALCULATED` and `REVIEW`.
- **The warning's wording, placement and dismissal** — a build detail for TCG-138's follow-up.
- **The apprentice steps in a bulk update** — still open per the 2026-09-03 note.
- **Employee craft-assignment history** — [payroll/gaps.md → *Craft assignment has no history*](../payroll/gaps.md#craft-assignment-has-no-history).
- **What Fouzan Shakil's UAT row meant** beyond the back-fill itself — still owed on the gaps entry.

## Who ratifies on the client side

**Corrina Bustos** and **Brian Petros**. Clauses 1–2 they have effectively already accepted on the
record above. Clauses 3–5 are CodingCops calls they have not heard; the one most worth putting to them
is clause 4 (warn, do not block) together with clause 5 (no approver step), since both sit on PAY-008's
open *configuration ownership* item.

## Effect on the vault

Done in the same pass as this note:

- [payroll/gaps.md → *Adding a rate when the previous one has no effective-to date*](../payroll/gaps.md#adding-a-rate-when-the-previous-one-has-no-effective-to-date--back-fill-it-or-error)
  — **done**: `Status` set to resolved for craft code rates, pointing here; history kept.
- [payroll/gaps.md → *Effective-dating the rest of payroll's rates (PAY-008, TCG-168)*](../payroll/gaps.md#effective-dating-the-rest-of-payrolls-rates-pay-008-tcg-168)
  — **done**: stays **open**; update bullet cross-links this note and narrows its *Also blocked by*.
- [2026-09-03-l12-bulk-rate-update-uniform-delta.md](2026-09-03-l12-bulk-rate-update-uniform-delta.md)
  — **done**: `provenance_note:` added pointing at the correction above. Not superseded (its rule is
  affirmed); `status: verified` unchanged; body not edited.

Not done by this pass — rule and index **bodies** are outside the recording agent's write scope, same
as the 2026-09-24 PAY-064 note; left for the calling agent:

- [payroll/rules/PAY-008-effective-dated-configuration.md](../payroll/rules/PAY-008-effective-dated-configuration.md)
  — needs a pointer under **Open**. Its `status: open` stays open (approver / ownership; other rate
  types).
- [payroll/INDEX.md](../payroll/INDEX.md) → the `module/payroll` decisions list — needs this note.

No file is verified or superseded by this decision.
