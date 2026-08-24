---
title: Invoicing-adjustment taxonomy — Tia & Micaela, ~late July 2026
source: client message (Tia + Micaela Dipane via Brian Petros), Teams ~2026-07-28; captured 2026-08-24 with five ticket screenshots
status: unverified
kind: source
updated: 2026-08-24
tags: [module/accounting, module/field-ops, module/payroll, kind/source, invoicing, ticket-workflow, downtime-delays, tools-rigging]
---

# Invoicing-adjustment taxonomy — what deducts, what doesn't, what bills extra

The ops/AR answer to "how do job-ticket events change the invoice." The list is explicitly
open ("if we think of any other we will send them"). **This is the billing-side half of the
payable ≠ billable seam** — payroll still pays these hours
([../payroll/rules/PAY-004-labor-entry-import.md](../payroll/rules/PAY-004-labor-entry-import.md)).

## 1. Company-caused delays → time DEDUCTED from the invoice

| Cause | Exhibit in the attached tickets |
| --- | --- |
| Flat tire | 46126: *"230 to 430pm crane down for flat tire"* |
| Mechanical issue onsite — work stops for mechanic (plus crew wait time) | OM60120: *"2:30pm–4pm crane was down while mechanic fix a hydraulic leak"* |
| Crew arrived late due to **incorrect leave time** | — (judgment call: who decides "incorrect"?) |
| Mechanical issues on the drive to/from site | — |
| Accident/safety incident → employee leaves for **drug testing** | the drug-test ticket ([PAY-056](../payroll/rules/PAY-056-injury-day-pay.md) exhibit) — paid by payroll, deducted from invoice |

## 2. Customer-caused delays → NO billing adjustment (documented on ticket only)

- Customer's contractors late (trucks late, no traffic control)
- **Damaged rigging** — time NOT deducted, **but an additional fee is charged** to replace the
  damaged item. Exhibit: ticket comment *"Damage 1 1/4 x 20 wire rope slings need 4 new ones."*
  (Open: where does the replacement price come from — assets/tools pricing?)

## 3. Extra billable

- Customer/project-required **onsite or specific training** → billed as additional time under
  **"crew time"**. Exhibit: job OM58898 (SCE, "THUMS Training" — note: recorded in the
  *Equipment Required* field, a capture-quality signal for why the ERP needs a real category).

## What the ticket screenshots incidentally prove (payroll side)

- The FCC e-ticket **already asks for lunch times** — items 9–12: "Lunch Time (If lunch is
  taken enter time here, example: Lunch 12 pm to 12:30 pm)" + 2nd/3rd/4th lunch. Brian's
  "even better if we knew what time" wish is served on paper *today* — but it lands in a
  checklist, not structured payroll data → the token failure persists
  ([PAY-047](../payroll/rules/PAY-047-worked-through-lunch-adjustment.md)).
- **Subsistence capture today** = item 8: "If Subsistence is applicable please click
  deficiency and note long or short sub in the comments" — the upstream origin of the
  `SUB_SHORT`/`SUB_LONG` tokens ([PAY-048](../payroll/rules/PAY-048-standard-subsistence.md)).
- Item 14 is a signed **meal/rest attestation** (first meal by end of 5th hour, 10-minute
  rest per 4 hours) — the compliance text the Atom app's US-17 attestation must reproduce.

## ERP design implication

Field-ops already requires downtime/delay capture (FR-FOP-024/-030 family). This taxonomy is
the **disposition layer** on top: cause-coded downtime → automatic invoice treatment
(deduct / document-only / fee / crew-time). The accounting wishlist's "invoice generated
automatically from actual hours" is only possible if this mapping is encoded, not tribal.
