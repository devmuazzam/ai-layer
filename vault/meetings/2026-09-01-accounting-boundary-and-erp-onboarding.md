---
title: Accounting boundary and ERP onboarding plan (1 September 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-09-01_Accounting and Payroll - transcript.docx"
migrated: 2026-09-04
updated: 2026-09-01
status: unverified
conflicts_with: []
jira: []
tags: [module/accounting, module/admin, module/payroll, module/assets, kind/meeting-notes, integrations, reporting, permissions-roles, sprint-planning, data-migration]
entities: [quickbooks, tenant, employee-type, craft-code, department, role]
meeting_date: 2026-09-01
---

# Accounting boundary and ERP onboarding plan — 1 September 2026

Curated from [transcripts/2026-09-01-accounting-and-payroll.md](transcripts/2026-09-01-accounting-and-payroll.md)
(55 min). Present: Brian Petros, ehtesham.anwar, Brent Wagstaff (controller), Abdul Rehman,
Patrick (`IT Support`), Melissa McNutt, Micaela Dipane, Sammy Garrett, Tia Brenneise.

> **Forward-looking.** Statements here are positions taken in a live call, not adjudicated
> requirements. Where something is decision-shaped it says so, and names what is still owed.

## 1. The accounting boundary — the answer Brent had been waiting for

Brent's standing question, in his words: *"are we maintaining the books in this new ERP or are
we not?"* Ehtesham answered it directly, and this is the clearest statement of accounting scope
in the record:

- **QuickBooks keeps the books.** *"All of the workflows that are in QuickBooks should remain in
  QuickBooks because we are not creating again an invoicing software… that would be foolish to
  build within the ERP."*
- **The ERP takes the reporting.** What TCG does today in spreadsheets — AR, AP, and the rest —
  is automated in the ERP, fed **from** QuickBooks by webhook, and joined to customers, projects,
  jobs and quotations (the customer revenue percentage already on the customer module is the
  shape of it).
- **Journal entries, trial balance, P&L and balance-sheet accounts stay out** — Brent named them
  and neither party put them in scope.
- **Integration is by API, not QODBC.** Patrick asked directly; Ehtesham: *"We are going to
  utilize APIs"*, the same path as ADP and Samsara. Abdul asked for a QuickBooks account to
  explore the API.
- **Self-service reports are wanted, and deferred.** Brent asked whether users could build their
  own reports or whether developers build each one; Ehtesham's answer was essentials first, a
  report builder later once the ERP holds the data.

**Decision-shaped, and a decision note is owed** — this pins the accounting module's outer edge,
which [accounting/gaps.md → *Wishlist vs committed scope*](../accounting/gaps.md) says nobody had
tiered. Recorded there as the client-side answer; it is not a signed decision until `tcg-scrum`
writes one.

## 2. The 15 September onboarding, and what the shared tenant is for

- Two tenants exist: the original `portal-admin` login, and an **`FCC data` tenant** holding the
  first-pass FCC import. Brian could not see the imported data because he was in the wrong one.
  Ehtesham confirmed multi-tenancy is deliberate — *"imagine a new company comes in… all we have
  to do is create a separate tenant."*
- **Until 15 September the shared tenant is for data review only** — *"just to look at the data
  we have ported over from FCC, nothing else. I don't want you to go in and figure out the user
  flows right now."* Modules to look at: customers, employees, assets (categories,
  sub-categories, individual assets and their forms), yards, projects, departments, billing codes.
- **15 September (and 17 if needed) is the walkthrough**: a clean ERP, loaded live, module by
  module, plus written user journeys — quotation → approval/loss → DocuSign → job conversion →
  permits and plans → POs. Purpose stated plainly: so testers know *"what are the functionalities
  that we have intentionally built and what are the functionalities that we have not covered."*
- **Internal scope to the 15th:** quotation → project → job → mobile ticket → payroll →
  **CSV export for manual ADP import**. ADP API automation starts *after* the 15th.
- **Feedback channel:** Brian will open a dedicated Teams channel; Ehtesham floated in-app
  feedback capture with a dashboard, if it fits before the 15th.
- Mobile: Android build is usable now; **iOS is blocked on the Apple developer account**, which
  Patrick says is in flight. Private distribution first, public only if the product goes SaaS.

## 3. Roles and departments — an unbuilt layer, and TCG owes the list

Abdul, unambiguously: *"right now we haven't implemented any authorization layer based on these
department and roles"*, and asked for TCG's departments, roles, and each role's capabilities;
a session with Corrina was proposed. Employee **type** in the ERP currently comes from the FCC
roles import, unmapped to departments.

## 4. Payroll-group classification — the outlier problem, restated by Brian

Brian re-raised the classification problem that decides *how payroll selects people*, with a live
case: an employee who is **union by classification but must not be paid on union rules** — hourly,
and admin/management. Neither "all union employees", nor "exclude admin", nor "hourly only"
selects the right set. Corrina recalls Kyle being told there would be a **special classification**
for this; Brian would rather it fall out of the **primary employee class at setup** than need a
special type. Registered on [payroll/gaps.md](../payroll/gaps.md) against `PAY-009`.

## 5. Also raised

- **Win number vs serial number** must be separate fields on the asset — feedback already sent,
  CodingCops to fix before the 15th.
- **Lunches**: Brian flagged a new payroll process TCG is designing that needs the **actual lunch
  time captured**, hard to do in the mobile flow; deferred to the 9 September call with Corrina.
  This is the thread that the 2026-09-04 message on rule lookback windows continues.
- **ADP API write access** appears not to be granted (read tested, write not); Ehtesham to send
  Patrick the exact permissions needed.
- A **detailed development plan past 15 September** is being written; accounting UX design starts
  in parallel over the following weeks.
