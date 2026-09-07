---
title: Payable hours vs billable hours — same clock span, different numbers
source: synthesis of decision notes, recordings and client-supplied billing documents, 2026-09-07
migrated: 2026-09-07
updated: 2026-09-07
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, module/accounting, module/field-ops, kind/reference, time-tracking, wtl, payroll-rules, compliance]
part_of: payroll/INDEX.md
---

# Payable hours vs billable hours

**One sentence.** Payroll and billing measure the **same clock span** — dispatch start time at the
yard to return to the yard, rounded start-down / end-up to the half hour — and then each applies
its own layer on top: **payroll adds union rule hours; billing applies contract minimums and
deducts company-caused downtime.** They coincide only on an uneventful day.

Sources are recordings and client documents; the Jira thread is deliberately not cited (see the
open question at the end).

## 1. The shared span — settled

| Boundary | Rule | Who said it |
| --- | --- | --- |
| Start | The **dispatch start time**, at the yard. Pre-trip inspection is inside paid time; the crane rolls 15–30 min later | Kyle Harlow 2026-09-03 47:27 / 47:57; Joe Schacatano 48:00; Corrina Bustos concurring — [decision](../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md) |
| End | Back at the yard, crane fuelled and parked, paperwork done | Kyle 50:33, 53:54; Melissa McNutt 2026-06-04 45:56 *"this is still part of the customer's time"* |
| Billing span | *"All charges are portal to portal… begin and end with Pre & Post trip inspections at equipment(s) dispatched location(s)"* | LEM ticket T&C §13 ([field-paper-forms.md](../field-ops/field-paper-forms.md)); Melissa 2026-05-21 49:37 *"we bill from our portal to our portal for every job"*; Lisette Anzaldo 10:46 |
| Rounding | **Start rounds down, end rounds up**, to 30 minutes, all employees. 12:47 start → 12:30; 12:31 end → 1:00. Not nearest-half-hour, not total-duration | Brian Petros in writing 2026-08-24 — [decision](../decisions/2026-08-24-payroll-time-rounding-method.md); Kyle and Corrina 2026-09-03 54:13–54:22 |

Melissa, 2026-06-04: *"their labor hours should always match the billing hours to the customer."*
That is the span. It is not the amount.

## 2. Where the numbers diverge

| | Payable | Billable |
| --- | --- | --- |
| **Rule hours** (WTL +0.5 h at DT, rest-forced hours to DT, guarantees, holiday 8-h minimum) | Added or repriced by the union rules — `rules/PAY-045`, `PAY-047`, `PAY-040`, `PAY-033` | Never billed as hours. **Exception:** the WTL penalty is charged to the customer **only with a customer signature** — Melissa 2026-05-21 37:15 *"we end up paying the employee, but we're not being able to charge the customer"* |
| **Company-caused downtime** (flat tire, mechanical, drug-test departure) | Paid in full — Kyle 2026-07-28 16:53 *"I had to pay the operator and the oiler no matter what"* | Deducted from the invoice, amount at the salesperson's discretion — Kaitlin, Tia, Micaela 2026-07-28; [invoicing-adjustment taxonomy](../accounting/2026-07-invoicing-adjustment-taxonomy.md). `rules/PAY-004`: *payable ≠ billable* |
| **Customer-caused delay** | Paid | Not deducted; documented on the ticket. Damaged rigging is a separate fee |
| **Minimums** | Union guarantees on their own triggers (4-h, 8-h, holiday, Special Saturday, long-boom) | Contract minimums by equipment class and time of day, Operator Load 5 min / 8 max — Melissa 2026-05-21 47:22 *"the employee would show 2 hours, for the invoice we would show 4"*; [quotations gap](../quotations/gaps.md#billable-hour-minimums-and-maximums-are-contractual-but-have-nowhere-to-live) |
| **Overlapping jobs** | One paid span | Second customer billed from the office as if the crane left for them — Melissa 2026-05-21 49:18 |
| **Standby** | Paid | Contradictory: avoided (Melissa 2026-07-01 25:08) vs billed as *Permit Stand By* on the LADWP ticket |

## 3. Boom time is a payroll concept

Build-up through breakdown including hook work, travel excluded (Kyle 2026-09-03 45:34; Corrina
2026-06-09 37:33). Every TCG statement attaches it to **boom pay** (`PAY-043`, `PAY-044`), not to
the customer's bill. *"Net billable hours = boom + WTL"* appears only in Jira comments from an
unnamed account and in no recording; the June demo computed "net billable" as yard-to-yard minus
lunch, the opposite.

## 4. The customer signature

Evidence, not a boundary. It locks the ticket's times (Brian 2026-05-21 17:59), makes the WTL
charge defensible, and travels with the invoice (LADWP wet signature — Micaela 2026-07-30). The
invoiced times are still deliberately different from the signed times (§2, minimums and
overlapping jobs).

## 5. What is still open

- **Which billing model applies per quote** — hourly portal to portal, or bundled
  mob / crane time / demob (Brian and Joe 2026-05-05; Ryan 2026-06-16 says both exist) — and whether
  the Jira "boom + WTL" was ever a billing rule:
  [accounting/gaps.md → Billable hours](../accounting/gaps.md#billable-hours--the-recordings-say-portal-to-portal-the-jira-decision-says-boom-time-plus-wtl).
- **Contract minimums** have no model: [quotations gap](../quotations/gaps.md#billable-hour-minimums-and-maximums-are-contractual-but-have-nowhere-to-live).
- **Post-trip** — the contract bills to it; Melissa says TCG does not perform it ([field-ops gap](../field-ops/gaps.md)).
- **Missed-meal billing** — three documents, three charges ([payroll gap](gaps.md#missed-meal-period--three-documents-three-different-charges)).
