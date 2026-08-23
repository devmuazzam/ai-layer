---
title: Foreman & Military Base premiums — Brian Petros, 2026-08-09
source: user-supplied/chat-google-chat/TCG CodingCops ERP Team · General
migrated: 2026-08-13
updated: 2026-08-09
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, adp, certified-payroll, union-agreement]
entities: [payroll-rule, pay-component, adp-code, foreman-premium, military-premium, davis-bacon, job-site]
---

# Foreman & Military Base premiums

**Two payroll premiums that exist in no other vault document.** Posted by **Brian Petros** to the
`TCG CodingCops ERP Team · General` chat on **Sunday 9 August 2026, 11:14 AM**, addressed to
Ehtesham. His own framing:

> "We have a couple more payroll rules (**not previously provided to you in the
> specs/requirement documents**)… although we spoke about these in the meeting last week."

The meeting he means is [2026-08-05](../meetings/2026-08-05-payroll-module-design-review.md),
where the Second/Third Shift differentials were discussed and TCG undertook to share updated ADP
codes. **This chat is a partial delivery of that action item** — four of the roughly sixteen
codes promised. It is not the comprehensive rules documentation also promised there.

---

## 1. Foreman premium

| | |
| --- | --- |
| **Amount** | **$3.00 per hour**, added to the base rate |
| **Rule origin** | **Company rule — not a Labor Union rule.** But it **only applies to Labor Union employees** |
| **Eligibility** | All Labor Union employees potentially eligible. All group rates potentially eligible |
| **Who decides** | The job foreman is chosen by the **crane superintendent** (currently **Jeff Kelley**) **per job** |

### How it is captured today

- **There is no field in FCC for the foreman.** None.
- Payroll learns who the foreman is **when the employee tells Payroll**.
- Payroll then types the literal token **`(PAY:FOREMAN)`** into the **payroll comments on the
  labor entry** in FCC.
- The **Payroll App** applies the premium by **finding the `(PAY:FOREMAN)` token** in those
  payroll comments.
- The **Payroll for ADP Excel file** carries **a special column** indicating when to apply it.

### Granularity — stated as an assumption, not a rule

> "Note: it is assumed that this will be for all hours for that day/row in that employee's Excel
> sheet. **If it only applies to some of the hours for that day, then a separate row for that day
> must be created.**"

This is Brian's assumption, written as one. It is the sentence that decides whether the premium
attaches to an **employee-day** or to a **labor entry**, and it has not been confirmed by anyone.

### ADP codes

| Code | Description | Type |
| --- | --- | --- |
| `FRR` | Foreman REG | Hours/Earnings |
| `FRO` | Foreman OT | Hours/Earnings |
| `FRD` | Foreman DT | Hours/Earnings |
| `FRT` | **Foreman TRI** | Hours/Earnings |

---

## 2. Military Base Job Site premium

| | |
| --- | --- |
| **Amount** | **$10.00 per hour**, added to the base rate |
| **Scope** | Added to **ALL hours** for **ALL employees on the job** |
| **Rule origin** | **This is a Labor Union rule** |
| **Eligibility** | All Labor Union employees potentially eligible. All group rates potentially eligible |

### How the premium is determined

- **Davis-Bacon provides a listing of job site locations that qualify** for this premium.
- **But:** some of the "official" job site locations are **adjacent (very close) to** military
  bases — "so this may exclude some jobs if they are 'technically' not exactly at/on the military
  base location."
- **The Local 12 Business Agent is called to verify if necessary.**

**No ADP codes were given for this premium.** The chat lists codes for Foreman and stops.

> **They existed all along — found 2026-08-13.** A live call to ADP's Payroll Data Input `/meta`
> endpoint returned four Military codes already configured under company `4RZ`:
>
> | Code | Description | Type |
> | --- | --- | --- |
> | `MLR` | Military REG | Hours/Earnings |
> | `MLO` | Military OT | Hours/Earnings |
> | `MLD` | Military DT | Hours/Earnings |
> | `MLT` | **Military TRI** | Hours/Earnings |
>
> Same REG/OT/DT/TRI shape as Foreman. See
> [adp-api-responses/pay-data-input-meta.md](adp-api-responses/pay-data-input-meta.md).
>
> **`MLT` matters.** A TRI code on this premium raises the same question `FRT` raises for Foreman:
> if the $10/hr were a flat adder there would be nothing to multiply. Its existence implies the
> premium is $10 **times the applicable multiplier** — $30/hr at triple time, for every employee
> on the job. Nobody has stated this. It remains the largest unpriced assumption in either rule.
>
> Worth noting *how* this was found: nobody sent it. The request was framed as "TCG owes us an
> export", and the answer was sitting in an API TCG already paid for.

---

## Why this matters more than two line items

### It introduces a fifth multiplier tier

`FRT` — **Foreman TRI** — means **triple time**. Every rate table in the vault so far runs
straight / OT 1.5x / DT 2x, with holiday 2x and 3x
([payroll-rules configuration](../../vault/payroll/erp-payroll-module-frd/05-weekend-holiday-and-shift-rules.md)).
A TRI code on a *premium* implies the premium is multiplied along with the base — i.e. the
foreman premium is not a flat $3 adder, it is $3 **times the applicable multiplier**. That
reading is not stated anywhere and changes the arithmetic materially.

### It confirms the comment-token pattern is the real integration surface

`(PAY:FOREMAN)` behaves exactly like the `LATT_OPER` / `LATT_OILER` tokens already documented in
[adp-bucket-crosswalk.md](adp-bucket-crosswalk.md): a human types a magic string into a free-text
comment field, and a downstream job greps for it. The ERP requirements document nowhere describes
this mechanism, yet it is how at least three premiums are actually driven today. **If the ERP
replaces FCC, these tokens have to become real fields** — and someone has to decide what happens
to historical entries that carry them.

### The Military premium is a job-level attribute, not an employee-level one

"ALL hours for ALL employees on the job" makes this the first premium in the vault that attaches
to the **job site**, not the worker. Nothing in the current payroll data model carries it. It has
to be set once on the job and fan out to every labor entry against that job — including entries
from workers who were never told about it.

### It joins payroll to Labor Compliance

Davis-Bacon appears in exactly one other place in the vault: the
[7 August Labor Compliance minutes](../meetings/2026-08-07-labor-compliance-certified-payroll.md),
where Corrina owes Ryan the Davis-Bacon business rules and identification criteria. **That action
item is now also a payroll blocker**, not just a compliance one — the same Davis-Bacon
determination that decides whether a job appears in Certified Payroll also decides whether every
worker on it gets $10/hr more.

And the adjacency problem is unresolvable in software as described: the authority of last resort
is **a phone call to the Local 12 Business Agent**. Any ERP design has to model "verified by
business agent" as a state, with a person and a date, or it will silently guess.

---

## What is missing before either rule can be built

- **No ADP codes for the Military premium.** Foreman got four; Military got none.
- **No effective date** for either premium. Retroactive to when?
- **No answer on whether `$3` and `$10` are multiplied.** `FRT` implies yes for Foreman; nothing
  is said for Military.
- **No stacking rule.** Can a foreman on a military base job draw both? Presumably yes — $13/hr
  over base — but no one has said so, and the L12 agreement's *no pyramiding* clause
  ([mcog-l12-mla .../01](mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)) is exactly the
  kind of clause that would restrict it.
- **No source of truth for the Davis-Bacon qualifying-location list.** "Davis-Bacon provides a
  listing" — where does TCG hold it, and who updates it?
- **Nothing about which Payroll Groups these apply to.** Both say "all Labor Union employees",
  which spans `L12 Labor Union Field` **and** `L12 Labor Union Mechanic`. Whether a union mechanic
  in the shop can be a job foreman is precisely the
  [rule-applicability-by-Payroll-Group](INDEX.md) question the vault already flags as the largest
  open design area.

All recorded in [payroll/gaps.md](gaps.md).
