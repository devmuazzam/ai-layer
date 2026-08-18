---
title: Who owns which employee field — ADP vs the ERP vs QuickBooks, and where onboarding starts
source: decision/email thread "TCG – Meeting Notes (June 25)", craneguys.com + codingcops.com, 2026-06-26 → 2026-06-30
decided: 2026-06-30
decided_by: Brian Petros (TCG, Data Analyst) proposed the ownership model on 2026-06-27; Ehtesham Anwar (Codingcops, Product Manager) refined where the lifecycle starts on 2026-06-28; Brian agreed on 2026-06-30 ("I agree with everything you said there 100%"). Wes Staley, Melissa McNutt, Corrina Bustos, Ryan Adams and the wider TCG/CC teams were on the thread; nobody dissented on record.
status: verified
resolves: []
topics: [payroll, adp-integration, architecture, employee-data]
entities: [employee, adp-code, payroll-group, craft, adp-company-code]
---

# Decision

**There is no single source of truth for "the employee". There is one owning system per data
domain, and every other system receives that field by integration.**

| Data domain | Owner | Notes |
| --- | --- | --- |
| Legal employee record, SSN, tax setup, W-4 / state withholding, direct deposit, payroll status | **ADP** | payroll/compliance system; stays authoritative |
| ADP file number / ADP employee ID | **ADP**, copied into the ERP | ERP stores it as a cross-reference, **never generates it** |
| Employee name, address, phone, email | usually **ADP**, synced to the ERP | ERP may display; avoid editing in both |
| Operational classification — union/non-union, field vs mechanic vs admin, craft & craft modifier, dispatch eligibility, certifications, crane/operator qualifications, job-costing categories, payroll-rule classification, ERP security/role | **ERP** | these are operational business rules, not HR facts |
| Time, labor, job, ticket, equipment assignment | **ERP / operations** | where the work happens |
| Payroll calculation output / labor costing detail | **ERP (payroll app)**, then sent to ADP as **payroll input** | "ADP should receive finalized payroll inputs, not necessarily calculate all your union rules" |
| Final payroll check, taxes, deductions, payroll register | **ADP** | ADP processes payroll and produces official results |
| Accounting journal entries, payroll liabilities, job-cost posting | **QuickBooks** | GL only — *not* the employee master |

Pay rate is split deliberately: **ADP for the official payroll rate**; the ERP may store an
operational/rule rate if its own calculations need one.

## Where the lifecycle starts

The ERP **initiates**, ADP **performs**, the ERP **records the result**:

1. The ERP creates the operational employee record (a pending / pre-hire).
2. The ERP initiates employee creation in ADP through the integration.
3. ADP completes the HR and payroll onboarding it is already good at — tax forms, direct
   deposit, payroll profile, withholding, pay schedule, deductions.
4. The ERP automatically captures the **ADP Employee ID / file number** that comes back.
5. Until ADP reports onboarding **complete**, the ERP treats the employee as pending and
   **blocks scheduling, equipment assignment and job allocation**.
6. From then on the ERP drives operational workflows and uses the ADP identifier for payroll
   exports, reporting and reconciliation.

Explicitly rejected: rebuilding ADP's onboarding inside the ERP ("I don't think it's a good
idea or makes much sense to rebuild what ADP already has working well for us" — Brian), and
making the ERP the full legal/payroll source of truth on day one.

Also agreed as a build order: **write the ownership matrix before the ERP vendor designs the
employee screens**, so no field ends up editable in two systems.

## Why this matters to the build

- It settles that our onboarding integration is a **push from the ERP**, not a manual ADP
  entry that the ERP watches — see [../payroll/adp-read-write-boundary-2026-08-18.md](../payroll/adp-read-write-boundary-2026-08-18.md)
  and the artifact *ADP Employee Onboarding via API Central*.
- It settles the **file number**: prefer WFN auto-assign, ERP stores what ADP returns. The
  ERP must not mint file numbers. (Whether TCG's WFN is configured to auto-assign is still
  unconfirmed.)
- It makes craft, craft modifier and TCG payroll group **ERP-owned** and only *optionally*
  mirrored into ADP (payroll `CustomArea1–4`). Nothing in ADP needs them for a payroll run —
  the ERP sends finished pay lines.
- It requires an **onboarding-status signal** back from ADP, because step 5 gates dispatch.

## Open questions the thread raised, and where they stand (2026-08-18)

| Question (Ehtesham, 2026-06-28) | Status |
| --- | --- |
| Can employee records be created through the APIs, or must ADP remain the only entry point? | **Answered.** `POST /hcm/v2/applicant.onboard` (V2, in-progress or complete) and the classic `worker.hire` event both create employees; both are API Central use cases, no Marketplace listing needed. |
| Which employee fields are owned by ADP vs synchronised from the ERP? | **Answered by this decision** for the domains above; field-level detail in the onboarding artifact and `adp-read-write-boundary-2026-08-18.md` §3. |
| What onboarding statuses / events are exposed to drive operational workflows? | **Partly.** `applicant.onboard` carries `onboardingStatus` = `inprogress` / `complete`; the practitioner finishes an in-progress hire in WFN (*Process › Hire › In-Progress Hires*). Whether completion is *pushed* to us is still open — see next row. |
| What synchronisation model is available (events, webhooks, polling)? | **Partly.** `GET /core/v1/event-notification-messages` is entitled and reachable but returned `204` (empty) on 2026-08-13 — the queue exists, nothing has been observed arriving. Polling `GET /hr/v2/workers` works today. Which events TCG's tenant actually emits is unconfirmed. |
| How do we handle failed syncs, duplicate employees, rehires, status changes, edge cases? | **Open.** `worker.rehire` and `worker.terminate` exist for the lifecycle; ADP exposes no idempotency key on these events, so the ERP must store the AOID/file number and check before re-posting. Duplicate resolution in WFN is manual. No retry/replay semantics documented for us yet. |

Two facts from the same thread that are now stale: "API access is not yet enabled under the
existing ADP subscription" and "additional ADP API access requires an upgraded account"
(2026-06-25). Access was obtained — live calls ran against TCG's tenant on 2026-08-13. What
is still missing is the **New Hire Onboarding use case** on the API Central project and
security access to the *HR + Payroll TCG* hire template.
