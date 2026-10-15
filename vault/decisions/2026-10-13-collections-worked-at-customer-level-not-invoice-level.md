---
title: "Collections are worked per customer, not per invoice: the collections list has one row per customer with that customer's overdue invoices behind it (Brent Wagstaff, 2026-10-13) — decision"
source: decision/client recorded call (Brent Wagstaff, CFO, Accounting and Safety discussion, 2026-10-13)
decided: 2026-10-13
decided_by: >-
  Brent Wagstaff (TCG, CFO; per the unverified admin/engagement-directory-and-org-charts.md), on the
  recorded 2026-10-13 Accounting and Safety discussion
  (meetings/2026-10-13-accounting-and-safety-day-invoicing-vendor-bills-collections-and-field-audits.md §5;
  transcript meetings/transcripts/2026-10-13-accounting-and-safety-discussion.md, 26:46–30:23).
  ehtesham.anwar (CodingCops) showed a collections tab design and named the choice: built "on the
  customer level", "instead of" the invoice level (27:46). Brent: "We definitely want it at the
  customer level. This is, that's what we're looking for." (28:01). This answers Brent's own ask of
  2026-10-08 (transcript 32:29–35:33), which was already framed per customer. Not confirmed in
  writing. It is the approval of a design on screen, so only the point Brent chose between named
  alternatives is recorded as decided. The rest of the tab is design. Recorded by tcg-scrum on
  2026-10-15 at the request of syed.haris (CodingCops).
status: verified
conflicts_with: []
resolves: []
related_decisions: []
jira: []
tags: [module/accounting, kind/decision, invoicing, reporting]
---

# Collections are worked per customer, not per invoice

## Decision

Brent Wagstaff, 2026-10-13: **the collections worklist is per customer.** Each row is a customer,
and the customer's overdue invoices sit behind it. A follow-up (a call or e-mail) is logged against
the customer, not against each invoice.

That is all this note decides. The rest of the tab shown on the call is design (see *What was not
decided*).

## The exchange — verbatim

Source: [../meetings/transcripts/2026-10-13-accounting-and-safety-discussion.md](../meetings/transcripts/2026-10-13-accounting-and-safety-discussion.md).

> **ehtesham.anwar (26:46):** *"You mentioned that we need a collections structure where every Monday
> somebody needs to call. and then log the communication on top of it, right? For that, we have
> created the collections tab. Here you have all of the overdue bills, 30, 31, 30 days above. … and we
> have created this instead of on the."*
>
> **ehtesham.anwar (27:46):** *"Invoices level, we have created this on the customer level. Then they
> can click on log call or even like click on the customer to see, okay, these are their pending
> invoices."*
>
> **Brent Wagstaff (27:51):** *"Yes. Yup. Yeah."*
>
> **ehtesham.anwar (27:57):** *"They can log the week's contact."*
>
> **Brent Wagstaff (28:01):** *"Yeah, that's great. We want, we definitely want it at the customer
> level. This is, that's what we're looking for."*

**The ask it answers, 2026-10-08.** Source:
[../meetings/transcripts/2026-10-08-accounting-demo-invoicing-ar-ap-and-quickbooks-sync.md](../meetings/transcripts/2026-10-08-accounting-demo-invoicing-ar-ap-and-quickbooks-sync.md).

> **Brent Wagstaff (32:29):** *"… something we do weekly, which is we have a… what I would call a task,
> where we touch base with all the customers over, you know, a certain day is … you have like the
> customer list, let's say there's whatever, 15, 15 customers. Can you like just check off that you
> did that one that week and then check off another one?"*
>
> **Brent Wagstaff (35:13):** *"So then it's like, okay, let's say there were 15, right? Well, I've
> touched base with 13 of them. How many do I have left? Who is left, right?"*

## Why

Brent's weekly task is to contact each customer with overdue invoices, not each invoice (10-08,
32:29–35:13). One row per customer matches the job he does. His 10-08 example counts customers
(*"15 customers … touched base with 13 of them"*).

## What was not decided

These were shown on 10-13. Brent responded positively, but each is design, not a decision:

- **Promise to pay** (date, amount, a quick-select for the full amount), notes, next follow-up, and
  the outcomes (left voicemail, no answer, e-mail, disputed) (28:18–28:47). Brent: *"Yep, exactly."*
- **Done for the week / still to contact** (28:47). This is what Brent asked for on 10-08 (*"once you
  update them, it falls off until next week"*, 35:02), but the 10-13 mechanics were not confirmed.
- **The KPI strip** (28:06). Brent: *"Oh, yeah, that's fantastic."*
- **Looking back at an earlier week** (29:05–29:37). ehtesham.anwar offered a week date-range
  selector. Brent, after seeing past contacts on the customer view: *"Okay. Maybe that would be
  enough then."* That is undecided.
- **When an invoice enters collections.** ehtesham.anwar: at 30+ days (30:09). Brent: *"Yeah, yeah,
  sounds good."* (30:23). His 10-08 practice is a list of invoices over 30 days, fixed *"as of
  Monday"* (33:11). Whether the list is frozen as of a weekday was not discussed on 10-13. The 10-08
  design's 90-day tag, and the whiteboard's 90-day lien escalation
  ([../accounting/ap-ar-value-engine-and-whiteboard-flow.md](../accounting/ap-ar-value-engine-and-whiteboard-flow.md),
  `unverified`), were not mentioned.
- **Who works the list.** Brent on 10-08 says *"I"*. Tia was on the call (Melissa 28:44, *"Tia, there
  goes your sheep"*, probably *sheet*). Roles and permissions were not discussed.

## Conflicts and interactions

- **No decision-note conflict.**
- **Replaces the 2026-10-08 design's per-invoice tags.** [../meetings/2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md](../meetings/2026-10-08-accounting-demo-invoicing-approval-ar-ap-and-quickbooks.md)
  §4 showed a Collections tab tagging **invoices** at 30 and 90 days. That was a design, not a
  decision.
- **Not the AI collections assistant.** The July wishlist's *"AI collections assistant"*
  ([../accounting/2026-07-accounting-team-erp-wishlist.md](../accounting/2026-07-accounting-team-erp-wishlist.md),
  `unverified`) is automated reminders and escalation. This note does not tier it.

## Effect on the vault

- No status flips. No register entry closed.
- Pointer added (no entry closed):
  [../accounting/gaps.md → *Wishlist vs committed scope*](../accounting/gaps.md#wishlist-vs-committed-scope--nobody-has-tiered-the-accounting-list).
