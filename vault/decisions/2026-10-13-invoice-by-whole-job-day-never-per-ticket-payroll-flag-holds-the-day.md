---
title: "Invoices are built from whole days of a job, never from individual tickets: every ticket of that job on that day is included, a day with a payroll-flagged ticket waits until payroll clears it, days are independent, and several days can share one invoice (Brent Wagstaff, 2026-10-13) — decision"
source: decision/client recorded call (Brent Wagstaff, CFO, Accounting and Safety discussion, 2026-10-13)
decided: 2026-10-13
decided_by: >-
  Brent Wagstaff (TCG, CFO; per the unverified admin/engagement-directory-and-org-charts.md, Accounts
  Receivable reports to him), on the recorded 2026-10-13 Accounting and Safety discussion
  (meetings/2026-10-13-accounting-and-safety-day-invoicing-vendor-bills-collections-and-field-audits.md §2;
  transcript meetings/transcripts/2026-10-13-accounting-and-safety-discussion.md, 13:42–19:17).
  ehtesham.anwar (CodingCops) proposed day selection at 13:42. Brent put the deciding question to
  Tia Brenneise (TCG, Accounts Receivable) at 18:38. She answered "No." (18:54), and Brent concluded
  "So I think we can do it by day." (18:55). Melissa McNutt (TCG, President) supported holding a
  flagged day (15:06) and stated that days are independent (17:19). Tia saw no problem with the
  design (17:16). Nobody at TCG objected. Not confirmed in writing. Same basis as
  decisions/2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md:
  the business owner of the area, on tape, answering a direct question. Recorded by tcg-scrum on
  2026-10-15 at the request of syed.haris (CodingCops).
status: verified
conflicts_with: []
resolves: []
related_decisions:
  - 2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md
  - 2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md
  - 2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md
  - 2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md
jira: []
tags: [module/accounting, module/payroll, kind/decision, invoicing, ticket-workflow]
---

# Invoices are built from whole days of a job, never from individual tickets

## Decision

Brent Wagstaff, 2026-10-13, with Tia Brenneise and Melissa McNutt:

1. **The unit accounting selects to invoice is a day of a job, not a ticket.** Selecting a day
   selects **every ticket of that job on that day** automatically. Accounting cannot pick some of
   a day's tickets and leave the others out.
2. **A day with any payroll-flagged ticket cannot be invoiced until payroll clears that ticket.**
   The whole day waits, not only the flagged ticket.
3. **Days are independent.** A clean day can be invoiced while another day of the same job waits
   on payroll.
4. **Several days can go on one invoice.**

Points 1 and 2 are decided by Brent with Tia's and Melissa's support. Point 3 is Melissa's
statement, which ehtesham.anwar confirmed was the design. Point 4 is a capability Melissa asked
about and CodingCops confirmed. Brent acknowledged it ("Mhm", 19:17) and nobody at TCG required
it. Read point 4 as **permitted**, not as "always group the days".

## The exchange — verbatim

Source: [../meetings/transcripts/2026-10-13-accounting-and-safety-discussion.md](../meetings/transcripts/2026-10-13-accounting-and-safety-discussion.md).
The transcript is Teams ASR, normalized. "bill" at 14:47, 15:13 and 17:47 was "build" in the raw
capture (the transcript header lists every substitution).

**The proposal.**

> **ehtesham.anwar (13:42):** *"what if we only allow Accounting team to select the day they are
> creating an invoice for instead of selecting individual tickets? … we have 3 tickets on Tuesday.
> For this particular job, third ticket, even though it is payroll flagged and it needs to be
> finalized from payroll … maybe for any, for example, day we have 3 tickets and Accounting forgets
> to select the third one for that day, then the invoicing. can get messed up. So I was thinking of
> just allowing the day to be selected and all of the tickets are auto selected."*
>
> **Brent Wagstaff (14:40):** *"Even if it's… Like for that example, even if it's flagged, it still
> gets picked up when you pick the whole day."*
>
> **ehtesham.anwar (14:47):** *"… if this is black and we cannot create an invoice, then the day is
> black as well then. That one ticket. needs to be processed by the payroll, then you can bill this
> date for this particular job."* ("black" is left unresolved in the transcript; it probably means
> *flagged*.)

**The payroll hold.**

> **Melissa McNutt (15:06):** *"… we'd want to hold the invoice until the payroll is figured out
> because we charge based off the hours. So if that one's flagged and it's an hour issue, we don't
> want to bill the customer and have to rebill if the guy charged more hours."*
>
> **Brent Wagstaff (15:56):** *"Okay, so when you pick the whole day, it will basically, like you
> said, it'll then, when you lock it out so you can only pick the whole day, it will flag the one
> that's not available to bill. So then you can't bill is what you're saying."*
>
> **Melissa McNutt (15:57):** *"Right."*

**Asking for outliers.**

> **Brent Wagstaff (16:27):** *"Melissa or Joe is, do you see any issues with that being grouped
> together as a whole day? I can't think of anything, but I also know that there's outliers in every
> situation."*
>
> **Tia Brenneise (17:00, 17:16):** *"… setting it up to where it chooses all the tickets, or actually
> it flags the whole job as I can't bill because like on the third day we're waiting for payroll. …
> I don't see where that would be a problem."*
>
> **Melissa McNutt (17:19):** *"Well, the days are individual, right? It's just the ticket. So if you,
> if you have, so you can bill, you can bill Wednesday because if all the tickets were good, but you
> can't bill Tuesday because you're waiting on payroll."*
>
> **ehtesham.anwar (17:34):** *"… that's the idea."*

**Several days on one invoice.**

> **Melissa McNutt (17:47):** *"So, if she had, if she had, could she group multiple days in on one
> invoice?"*
>
> **ehtesham.anwar (17:54):** *"Yeah, she can select multiple days."*

**The decision.**

> **Brent Wagstaff (18:38):** *"So I guess my question, Tia, is, is there ever a situation where,
> let's assume all five of these line items could be billed. Is there a situation when you don't
> pull all five?"*
>
> **Tia Brenneise (18:54):** *"No."*
>
> **Brent Wagstaff (18:55):** *"I think that's the answer. So I think we can do it by day."*
>
> **ehtesham.anwar (18:58):** *"Yeah, that's going to remove human errors as well. … Let's also log the
> days if there is a problem based on our rules on the tickets. And whenever a day becomes available,
> it is the day that is getting billed and multiple days can be grouped together."*
>
> **Brent Wagstaff (19:17):** *"Mhm."*

**Brent's earlier view, which this replaces.** At 10:53–11:26 he had said *"more options is better"*
and *"I like the ability to choose the tickets from day-to-day"*. That was before he understood how
tickets are cut (one per allocation, 9:57–13:28). His 18:55 conclusion is the later word.

## Why

- **No ticket is left out by mistake.** With per-ticket selection, accounting can bill two of a
  day's three tickets and forget the third (ehtesham.anwar 13:42, 15:13). Tia confirmed there is no
  case where accounting would want only some of a day's billable tickets (18:54).
- **No rebilling.** TCG charges the customer from the hours on the tickets. A flagged ticket may
  change its hours, so billing before payroll settles it risks a rebill (Melissa 15:06).
- **Days stay independent**, so one flagged ticket does not hold up the rest of a long job
  (Melissa 17:19).

## What was not decided

- **Holdover jobs.** Tia (17:34): *"Well, I mean, that would be a holdover. So that would, that would
  be like, I would. I went bill. each day individually on a holdover."* ("I went bill" is unresolved
  in the transcript, possibly *"I won't bill"*.) ehtesham.anwar (17:47, 17:54) said a holdover job is
  invoiced **once, as a whole job**, and that the holdover designs are being finalised that week.
  **Nobody at TCG confirmed that.** Melissa's next turn asked about grouping days, not about
  holdover. Whether a holdover job is invoiced only at the end, or whether a long holdover can be
  invoiced in parts, is **open**. It is question 1 of the curated notes' §10, which is not yet filed
  in [../accounting/gaps.md](../accounting/gaps.md).
- **What "cleared by payroll" means.** The call said the flag must be fixed (*"until the payroll is
  figured out"*, 15:06). It did not say whether the flag must be resolved, the employee's payroll
  week approved, or payroll processed. For what a flag is and that every flag blocks payroll
  approval, see
  [2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md](2026-09-30-payroll-flag-list-confirmed-all-flags-block-approval.md).
- **Other blockers on a day.** Only the payroll flag was discussed. ehtesham.anwar's *"based on our
  rules on the tickets"* (18:58) is design. Whether an incomplete or unsigned ticket also holds its
  day was not said. The bills-received blocker in §4 of the curated notes was **proposed by
  ehtesham.anwar (26:21) and not agreed** (Brent: *"Cost. Yeah."*, as transcribed, 26:41).
- **Logging blocked days** (ehtesham.anwar 18:58) is design, not decided.
- **Days from different jobs on one invoice.** Only days of the same job were discussed.
- **Invoice lines.** Which lines a day's tickets produce, and how ticket hours map onto them, is
  not touched. See [../accounting/gaps.md → *Does the invoice carry exactly the quotation's lines*](../accounting/gaps.md#does-the-invoice-carry-exactly-the-quotations-lines--including-the-lines-hidden-inside-mobilizationdemobilization)
  and [*Billable hours*](../accounting/gaps.md#billable-hours--the-recordings-say-portal-to-portal-the-jira-decision-says-boom-time-plus-wtl).

## Conflicts and interactions

- **No decision-note conflict.** No earlier note says how tickets are selected for an invoice.
- **Replaces the 2026-10-08 design.** [../meetings/2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md](../meetings/2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md)
  §2 recorded accounting selecting *"a whole day or one ticket"*. That was a design shown by
  CodingCops, not a decision. Its notes stay as the record of what was shown. No frontmatter change.
- **Fits [2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md](2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md)**
  (`verified`): one invoice for a job with two cranes. Several days on one invoice is consistent
  with that.
- **Ticket shape.** A day's tickets are the allocation tickets of
  [2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md](2026-09-14-one-job-ticket-per-asset-group-oiler-fills-it.md)
  (`reference`). ehtesham.anwar said an allocation can run up to 48 hours (11:53–12:06). **Which
  day a ticket that crosses midnight belongs to was not discussed.**

## Effect on the vault

- No status flips. No register entry closed.
- Pointers added (no entry closed):
  [../accounting/gaps.md → *Billable hours*](../accounting/gaps.md#billable-hours--the-recordings-say-portal-to-portal-the-jira-decision-says-boom-time-plus-wtl)
  and [*Invoicing a travel permit that is not tied to a job*](../accounting/gaps.md#invoicing-a-travel-permit-that-is-not-tied-to-a-job--brian-named-the-case-nothing-covers-it).
