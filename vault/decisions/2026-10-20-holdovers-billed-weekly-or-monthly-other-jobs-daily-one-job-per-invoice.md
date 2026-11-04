---
title: "Billing cadence: holdovers are billed weekly, some customers want only monthly billing, all other jobs are billed daily, and TCG typically does one job per invoice / PO (Melissa McNutt, 2026-10-20) — decision"
source: decision/client written reply (Melissa McNutt, TCG President, Slack/Teams thread with CodingCops, 2026-10-20)
decided: 2026-10-20
decided_by: >-
  Melissa McNutt (TCG, President; per the unverified admin/engagement-directory-and-org-charts.md),
  in a written reply in the client thread on Tue 2026-10-20, 1:30 am (timezone as relayed), answering
  three questions Umer (CodingCops) put on Mon 2026-10-19, 11:09 pm to Brent Wagstaff (TCG, CFO), cc
  Brian Petros and Melissa McNutt. Brent did not reply in the relayed thread. Melissa is the
  business owner of the company, so her answer stands as the client's word on these points. The
  thread was relayed to tcg-scrum verbatim by the Claude Code session of syed.haris (CodingCops) on
  2026-10-20. tcg-scrum did not see the thread itself, and the channel (Slack or Microsoft Teams) was
  not stated in the relay. Recorded by tcg-scrum on 2026-10-20.
status: verified
conflicts_with: []
resolves: []
related_decisions:
  - 2026-10-13-invoice-by-whole-job-day-never-per-ticket-payroll-flag-holds-the-day.md
  - 2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md
  - 2026-09-05-po-types-and-quote-to-invoice-workflow.md
jira: []
tags: [module/accounting, module/dispatch, kind/decision, invoicing, holdover, purchase-orders]
---

# Billing cadence: holdovers weekly (sometimes monthly), other jobs daily, one job per invoice / PO

## Decision

Melissa McNutt, 2026-10-20, in writing. Her whole reply, verbatim:

> *"Hey Umer, We like to bill holdovers weekly, there are times when customers only want monthly
> billing. All other jobs are billed daily. We typically do 1 job per invoice / PO."*

What it states, sentence by sentence, and nothing more:

1. **Holdovers are billed weekly.** *"We like to bill holdovers weekly"*.
2. **Some customers want only monthly billing.** *"there are times when customers only want
   monthly billing"*. She put this right after the holdover sentence, so it reads as an exception
   to weekly holdover billing. She did not say so in as many words, and she did not say whether it
   can apply to non-holdover jobs too.
3. **Every other job is billed daily.** *"All other jobs are billed daily."*
4. **Normally one job per invoice and per PO.** *"We typically do 1 job per invoice / PO."*
   *"typically"* means exceptions exist. She did not name them.

## Mapped to Umer's three questions (2026-10-19)

| # | Umer asked | Melissa's answer | Settled? |
| --- | --- | --- | --- |
| 1 | If a job runs several weeks or a month, invoice once at the end, or progress-bill (weekly / monthly / milestones)? If progress-bill, what decides the cut: calendar, amount, or customer agreement? | Holdovers: **weekly**, and **monthly** when the customer wants only that. Other jobs: **daily**. | **Mostly.** A long holdover is **not** invoiced once at the end. The cut is by time (week or month). The customer's wish is what moves it to monthly. Amount and milestone cuts were not mentioned. What a billing week or month is (which day it closes on) was not said. |
| 2 | Is that interim-billing rule the same for all customers, or per contract (e.g. Edison vs a one-off customer)? | *"there are times when customers only want monthly billing"* | **Partly.** It is **not** the same for every customer: some customers want monthly. Where that is set (on the customer, per contract, or per job) was not said. Edison was not mentioned. |
| 3 | Can a customer require split invoices for one job (per PO line / per location), or strictly one job, one invoice? | *"We typically do 1 job per invoice / PO."* | **Partly.** The norm is one job per invoice and per PO. It is not *"strictly"*: *"typically"* allows exceptions, which she did not name. Splitting by PO line or by location was not addressed. |

## Why

Melissa gave no reasons. The record around it supplies context, not reasons:

- **Weekly holdover billing fits the verified invoice unit.** Invoices are built from whole days of
  a job, days are independent, and several days of one job can go on one invoice
  ([2026-10-13-invoice-by-whole-job-day-never-per-ticket-payroll-flag-holds-the-day.md](2026-10-13-invoice-by-whole-job-day-never-per-ticket-payroll-flag-holds-the-day.md),
  `verified`, points 1–4). A weekly holdover invoice is a week's days of one job on one invoice.
- **"One job per invoice" cannot mean one invoice for a job's whole life**, because a holdover that
  runs several weeks is billed every week. The reading her four sentences support together is that
  an invoice normally covers **one** job, and a long job can produce several invoices. She did not
  say this in so many words. It is filed for confirmation (see *What is still open*).

## What this settles in the existing record

- **The holdover item in the 2026-10-13 decision's *What was not decided*.** That note left open
  *"Whether a holdover job is invoiced only at the end, or whether a long holdover can be invoiced in
  parts"*. The answer: **in parts, weekly by default, monthly when the customer wants that.** The
  same question is item 1 of
  [../meetings/2026-10-13-accounting-and-safety-day-invoicing-vendor-bills-collections-and-field-audits.md](../meetings/2026-10-13-accounting-and-safety-day-invoicing-vendor-bills-collections-and-field-audits.md)
  §10. It was never filed in a register, so there was no register entry to close.
- **CodingCops' stated holdover design does not match.** On 2026-10-13 (17:47–17:54), ehtesham.anwar
  said a holdover job is invoiced **once, as a whole job**. Nobody at TCG confirmed that then, and
  Melissa's answer contradicts it. It was a design statement, not a decision, so nothing in the vault
  changes status. Any build that invoices a holdover only at the end must change.
- **Tia's 2026-10-13 remark.** At 17:34 Tia Brenneise said *"I went bill each day individually on a
  holdover"*, with *"I went bill"* left unresolved in the transcript. Weekly billing fits the
  *"I won't bill"* reading. This note does not settle what Tia said.
- **The 2026-10-16 accounting demo** (Ehtesham: Collections, Cash Forecast with a *"promise / Edison
  interval / Net 30"* basis, and so on) is CodingCops' proposal, not a client decision. Nothing in
  Melissa's reply confirms or rejects any of it.

## Conflicts and interactions

- **No conflict with any decision note.** No earlier note says how often TCG invoices.
- **[2026-10-07 two cranes](2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md)**
  (`verified`, point 3): Joe Schacatano said a job with two cranes gets one invoice (40:06), and
  that separate invoices happen only *"if one machine ends up staying longer than the other"* or
  *"if the customer just asked for it"* (40:32). That is consistent with *"typically"* and gives
  two known exceptions. Joe said it about two cranes on one job, not as a general list.
- **[2026-09-05 PO types](2026-09-05-po-types-and-quote-to-invoice-workflow.md)** (Brian Petros):
  the customer PO lives on the job / schedule tab and is printed on the *"final invoice"*. Melissa's
  *"1 job per invoice / PO"* fits one customer PO per job. Two things are not settled: whether every
  weekly holdover invoice carries the job's PO, and what happens when a job has more than one PO.
- **The 2026-10-13 decision, point 4** (several days can share one invoice, read as *permitted*):
  *"All other jobs are billed daily"* can be read two ways. Either each working day of a
  non-holdover multi-day job is its own invoice, or days are billed as they complete and may still
  be grouped. Melissa's own 2026-10-13 question (*"could she group multiple days in on one
  invoice?"*, 17:47) does not settle which. Filed as open.
- **The payroll hold on a weekly invoice.** A day with a payroll-flagged ticket waits, and days
  are independent (2026-10-13, points 2–3). It was not said whether a weekly holdover invoice waits
  for the flagged day, or goes out without it and the day is billed later. Filed as open.
- **Which "holdover".** Melissa did not define the word. TCG's working definition is Joe
  Schacatano's (2026-10-07 sprint review §6, `unverified` curated notes): *"any time the machine
  stays on site, it's a holdover… regardless of how many days it is."* The platform has two flags
  called holdover: dispatch's per-line *Make Holdover* and payroll's job-level subsistence holdover.
  Which one marks a job for weekly billing is part of the open dispatch question. See
  *What is still open*.

## What is still open

Filed in [../accounting/gaps.md](../accounting/gaps.md), the accounting module's register. No
ticket owns invoicing: TCG-218 excludes invoices from its scope.

- [*Billing cadence — what sets monthly instead of weekly, what a billing week is, and what "billed daily" means*](../accounting/gaps.md#billing-cadence--what-sets-monthly-instead-of-weekly-what-a-billing-week-is-and-what-billed-daily-means)
- [*One job per invoice / PO — what are the exceptions to "typically"?*](../accounting/gaps.md#one-job-per-invoice--po--what-are-the-exceptions-to-typically)
- A pointer was added to
  [../dispatch/gaps.md → *Is the DAS holdover the same thing as payroll's subsistence holdover?*](../dispatch/gaps.md#is-the-das-holdover-the-same-thing-as-payrolls-subsistence-holdover):
  billing cadence is now a third consumer of the holdover definition.

## Effect on the vault

- **No status flips.** This note adjudicates no conflict set: no file wins, no file is superseded,
  and no `conflicts_with` changes.
- **No register entry closed.** The holdover-invoicing question (2026-10-13 meeting §10, item 1)
  was never filed in a register.
- **Done in this pass:** two new open entries appended to `accounting/gaps.md`, and an
  *Update 2026-10-20* pointer added to the dispatch entry above. Both link back to this note.
- **Not done (outside tcg-scrum's write access, file bodies):** add this note to
  `accounting/INDEX.md` → *Decisions that bind this module* and to the decisions table in
  `INDEX.md`, and link the 2026-10-13 decision's *Holdover jobs* item to this note.
