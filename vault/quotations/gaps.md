---
title: Quotations — open questions
status: reference
kind: gaps
updated: 2026-08-24
tags: [module/quotations, kind/gaps, open-questions]
---

# Quotations — open questions

Live register per [STRUCTURE.md](../STRUCTURE.md) → *Where a question goes*. Ticket-raised
questions do **not** go here — they belong in that ticket's `spec.md` §12.

Entry format (unchanged from the retired registers, so the global sweep still works):

```markdown
## <question title>
- **Status:** open
- **Asked:** YYYY-MM-DD — by whom / which work raised it
- **Question:** one paragraph
- **Sources checked:** what was read before declaring this open
```

## Sell-side scheduling artefacts — no vault coverage

- Question: what are the Job Schedule Master, the Ready-to-Schedule Checklist, the One-Page
  Customer Intake, the Geographic Heat Map, and "Red Path"?
- Candidates: [meetings/2026-08-12-sell-side-workflow-and-scheduling.md](meetings/2026-08-12-sell-side-workflow-and-scheduling.md)
  only. Brian Petros shared source files in the meeting; **those files are not in the vault**.
- Note: **"Red Path" is undefined.** It is used as though established. Add it to the undefined-terms
  list. Two scheduling rules stated in the meeting — cranes under maintenance must not be
  selectable, and double booking must be *supported* where short jobs allow — belong to the Daily
  Allocation System, and neither of that area's two conflicting sources covers either rule.
- Note also: **permits** (annual vs job-specific, city eligibility, crane-travel permits) have no
  vault coverage. The field-ops FRD lists permits only as a *Pending* BRS topic.
- Blocked: the Customer Intake action item on CC, which depends on TCG confirming the intake
  questions, fields and business rules.
- Owner: TCG team for intake questions/fields/rules; Brian Petros for the workflow source files.
- Status: open
- **From (frozen original):** [gaps.md#sell-side-scheduling-artefacts-no-vault-coverage](../gaps.md#sell-side-scheduling-artefacts-no-vault-coverage)

## "Customer PO" on the quotation — which of three things does it mean?

- Question: does `quotations/quotation.md:26` *"Customer PO"* mean (a) a PO-number field on the
  quotation form, (b) the Customer PO workflow that `SCRUM-575` shipped between Sent-to-Customer and
  Won, or (c) associating customer POs with the customer record — and is a PO number on the
  quotation wanted at all?
- Candidates:
  - Recording **2026-03-06**, `ehtesham.anwar` (**CodingCops**) at 9:13, transcript line 170: *"the
    PO number is going to be available. This functionality is going to be available right there. You
    can create within the quotation as well."* Again the vendor describing his own mockup; the
    2026-03-06 action-items file contains **no** PO item at all.
  - `SCRUM-149` *PO number field — remove it* — **Done**, reporter Aiman Farooq, created 2026-04-22.
    **`description: null`** — no description, no AC, no rationale, no requester. Its only comment
    (Abdul Muazzam) is what establishes the field was on the quotation at all.
  - `SCRUM-575` *Pre-Quote Data Form & Customer PO Form* — **Done**, reporter Umair Khan, created
    2026-06-25, label `Feedback.Sprint.4`. Description in full: *"Add Pre-Quote Data Form and
    Customer PO workflow between Sent to Customer and Won stages."* Its closing comment says it
    shipped under two different names — *"1. new customer packet 2. job and labor compliance
    information request form"*.
  - `quotations/quotation.md:26` (JZ punch list, 2026-06-23) — the bare bullet *"Customer PO"*, one of
    ~20 unelaborated bullets, **post-dating `SCRUM-149`** by two months.
  - `customers/customer-and-job-sites.md:28` — *"Need to associate customer POs with customer -- need
    to ask TCG team to provide customer PO form / data"*. **Phrased as an open question to TCG**,
    never answered.
  - `vendors-agencies/purchase-order.md` — `conflicts_with: []`, and entirely about **vendor and permit** POs
    owned by Liz Lopez and Jeff Stricker. Says nothing about a customer PO on a quotation.
- Note: the built state is unambiguous and is the reason this is answerable in one line —
  `model Quotation` has **no** `poNumber`; `model Project` and `model Job` both do. A vestigial
  `poNumber?: string | null` survives in `apps/web/src/features/quotations/types/quotation-api.ts`
  with no form field and no consumer. So the field was removed and the workflow was built elsewhere
  under other names. What is genuinely unresolved is only what the punch-list bullet is asking for,
  and it was written **after** the removal — which is why it cannot be dismissed as stale.
- Blocked: any spec work citing `quotations/quotation.md`; whether the vestigial web type should be
  deleted; the pre-quote package scope.
- Owner: Ryan Adams / Joe Schacatano (sales & quotation).
- Status: open
- **From (frozen original):** [gaps.md#customer-po-on-the-quotation-which-of-three-things-does-it-mean](../gaps.md#customer-po-on-the-quotation-which-of-three-things-does-it-mean)

## Billing-rate effective dating for pricing sheets — raised by the client, no design yet

- **Status:** open
- **Asked:** 2026-08-24 — client-message batch (Brian Petros, rate-rollover message; payroll-side counterpart on `payroll/rules/PAY-008`)
- **Question:** union *wage* rates change every fiscal year and the ERP will effective-date them
  (PAY-008). The client is "not sure yet about the FCC billing rates for invoicing (pricing
  sheets)" and expects the ERP to do better. Where do billing rates live in the ERP
  (price-listings / billing codes), and how are they versioned over time so an old job invoices
  at the rate in force on its work date?
- **Sources checked:** FCC `UNION_CRAFT.BillingRate` exists but is **0.000 on every sampled row**
  — a dead path; billing actually comes from pricing sheets. Vault: [billing-code-and-price-list.md](billing-code-and-price-list.md)
  (status draft/in-progress/active discussed 2026-03-12, no effective-dating design anywhere).

