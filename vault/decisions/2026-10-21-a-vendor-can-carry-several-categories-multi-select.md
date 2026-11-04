---
title: "A vendor can carry several categories: the vendor category becomes a multi-select (Sammy Garrett, 2026-10-21) — decision"
source: decision/client recorded call (Sammy Garrett, Controller, ERP Demo Walkthrough Part 1, 2026-10-21)
decided: 2026-10-21
decided_by: >-
  Sammy Garrett (TCG, Controller; per the unverified admin/engagement-directory-and-org-charts.md,
  Accounts Payable reports through him), on the recorded 2026-10-21 ERP Demo Walkthrough Part 1
  (meetings/2026-10-21-erp-demo-walkthrough-part-1-roles-craft-codes-agencies-billing-codes-price-lists-and-vendors.md §9;
  transcript meetings/transcripts/2026-10-21-erp-demo-walkthrough-part-1.md, 50:41–51:46).
  Sammy asked whether a vendor booked under one category is "only that one", given that one vendor
  supplies parts, rents a crane and works as a subcontractor, and put the alternative himself: "do
  we just like kind of comment on it?" ehtesham.anwar (CodingCops) answered that the field would be
  converted "into a multi-select" (51:21). Sammy: "Right. Sweet, thank you." (51:46). It answers his
  own ask, and he accepted the option over the comment he had named. On authority: Melissa McNutt
  (President) named "Sam and Sammy" as the people who will create vendors (11:18). Sammy also
  addressed "Brent" (Brent Wagstaff, CFO) in his question. Brent is not a labelled speaker on the
  call and no reply from him was recorded. Not confirmed in writing. Recorded by tcg-scrum on
  2026-10-22 at the request of syed.haris (CodingCops).
status: verified
conflicts_with: []
resolves: []
related_decisions:
  - 2026-09-05-po-types-and-quote-to-invoice-workflow.md
jira: []
tags: [module/vendors-agencies, module/accounting, kind/decision, reference-data]
---

# A vendor can carry several categories

## Decision

Sammy Garrett, 2026-10-21: **one vendor can be given more than one category.** The vendor's
category is a multi-select, not a single choice. His example is Western, which TCG buys parts from,
rents a crane from, and uses as a subcontractor.

That is all this note decides. The list of categories is not decided (see *What was not decided*).

## The exchange — verbatim

Source: [../meetings/transcripts/2026-10-21-erp-demo-walkthrough-part-1.md](../meetings/transcripts/2026-10-21-erp-demo-walkthrough-part-1.md).

The built field, as shown just before:

> **ehtesham.anwar (48:24):** *"… General information, their phone number, e-mail, type of the vendor,
> individual or this vendor is a business, category, service, parts, subcontractor, renter, comments,
> address, on the map."*

> **Sammy Garrett (50:41):** *"Hi, in the general info, when you were doing like what kind of categories
> they are, so part, service, subcontractor, is there a way? So if you book them as one, then is it
> only that one? Because there is like, for example, drawing a blank, but like Western, if we get a
> part from there or if we rent a crane for rent. to crane from there, or if we still got a job. So if
> we use one vendor for multiple different things, does, I guess the multitude of them, Brent, does it
> matter? Or do we just like kind of comment on it? Because if we just have one category and there
> are three different things."*
>
> **ehtesham.anwar (51:05):** *"Mhm. Makes sense."*
>
> **Sammy Garrett (51:18):** *"What do we want it to be under?"*
>
> **ehtesham.anwar (51:21):** *"All right, so right now we have this as one selection option. From your
> comment, seems like 1 vendor can be used to source parts or rent something from them, have them
> work as a subcontractor, or get some kind of a service from them, right? So we will create this,
> convert this into a multi-select page, we will be able to select multiple categories. And on top
> of this, if you have more categories, if you see in the system or you think about them, send us
> those, we'll add those as an option here."* ("multi-select page" is left as transcribed, probably
> *multi-select field*.)
>
> **Sammy Garrett (51:46):** *"Right. Sweet, thank you."*

("if we still got a job" is left unresolved in the transcript. ehtesham.anwar's restatement reads
it as having the vendor *"work as a subcontractor"*.)

## Why

Sammy's reason is in his question: TCG uses one vendor for several kinds of work. With a single
category, the other kinds could only go in a comment.

## What was not decided

- **The category list.** The build shows service, parts, subcontractor and renter (48:24). Sammy
  named part, service and subcontractor. ehtesham.anwar asked TCG to send any categories that are
  missing (51:21, curated notes §11). Whether *renter* is the right word for renting from a vendor
  was not discussed.
- **Whether a category is required**, or whether one category is the vendor's main one. Not
  discussed.
- **What a category drives.** Nobody said whether the category affects POs, bills, 1099 reporting,
  the default GL expense account or the DAS vendor allocation, or whether it is only a label for
  finding vendors.
- **Existing vendor records.** The build stores one category per vendor today (see below). How
  existing values carry over was not discussed.

## Conflicts and interactions

- **No decision-note conflict.** No earlier decision note covers vendor categories.
- **The build is single-select today.** ehtesham.anwar said so at 51:21. The schema agrees: one
  nullable `Vendor.vendorCategory` string (`apps/api/prisma/schema.prisma`, model `Vendor`). This
  decision changes the field, not the list of values.
- **The earlier asks were for a category, not several.** The punch list
  [../vendors-agencies/agency-and-vendor.md](../vendors-agencies/agency-and-vendor.md) (`unverified`)
  has *"Add category inside vendor to make them sub contractor"*. Melissa McNutt asked on 2026-06-17
  for a *"vendor type … service or parts or subcontractor"* (cited in the gaps entry below). Neither
  says one vendor has only one. This note adds that a vendor can have several.
- **Partly answers an open register entry, which is not edited here.**
  [../vendors-agencies/gaps.md → *PO and vendor/agency rules the E2E suite asserts with no written
  source — PR #488*](../vendors-agencies/gaps.md#po-and-vendoragency-rules-the-e2e-suite-asserts-with-no-written-source--pr-488),
  item (f), asks for the vendor billing enums, category included. This note settles that a vendor's
  category is multi-valued. It does not settle the values, or any other part of (f).

## Effect on the vault

- No status flips. No file wins or is superseded, and no `conflicts_with` changes.
- No register entry closed. The PR #488 entry stays open, and (f) is only partly answered. That
  entry was not edited in this pass.
- Done in this pass: a row for this note in the decisions table of [../INDEX.md](../INDEX.md), and
  the *Candidates for a decision note* section of the 2026-10-21 curated notes updated to point here.
