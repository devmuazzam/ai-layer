---
title: Agency creation form — final field set (Ehtesham Anwar, 2026-09-15) — decision
source: decision/Ehtesham Anwar via Syed Haris; cross-checked against Ben's "City List turn around" sheet
decided: 2026-09-15
decided_by: >-
  Ehtesham Anwar (CodingCops PM) — the "final agency creation form" relayed by
  Syed Haris on 2026-09-15, alongside Ben's `City List turn around - Ben.xlsx`
  (500 CA/NV cities with permit lead time, county, jurisdiction type, coverage
  note). Not a TCG client-side sign-off. Recorded `status: reference` — binding on
  the CodingCops build, open to being overruled by TCG.
status: reference
conflicts_with: []
resolves: []
jira: []
tags: [module/vendors-agencies, module/projects-jobs, kind/decision, permits, agencies]
entities: [Agency, Permit, Attachment]
---

# Agency creation form — the final field set

Replaces the form described on the 2026-03-26 sync
([transcripts/2026-03-26](../meetings/transcripts/2026-03-26-tcg-cc-product-sync-demo.md)
@ ~line 183: name, city, website, portal, address, turnaround time, TCP, no-parking,
city hall hours, permit cost, notes, process, attachments). Consistent with
[agencies.md](../vendors-agencies/agencies.md) — one directory whose rows feed the
permit form — and with the 2026-06-18 recording where Brian Petros says the FCC
"cities" become **agencies** and *Quality Permits* is the one third-party permit
vendor ([2026-06-18 transcript](../meetings/transcripts/2026-06-18-dispatch-permits.md)
@ 22:44, 1:05:36).

## Decision — the form

| # | Field | Required | Control / values |
| --- | --- | --- | --- |
| 1 | Agency Name | yes | text |
| 2 | Agency Type | yes | City / Municipality · County · State · Federal · Special District · Utility · Other |
| 3 | Jurisdiction Type | yes | City · **Town** · **Unincorporated / CDP** (both added by Syed Haris 2026-09-15 from Ben's sheet — 3 and 243 rows) · County · Township · Borough · Village · State · Federal · Special District · Other |
| 4 | Permit Lead Time | yes | counter, whole days (Ben's sheet: 1–20 dropdown, values 0–14 in use) |
| 5 | State | yes | dropdown, 50 states + DC — **built as Country / State / City picklists** (Syed Haris, 2026-09-15: the app-wide address pattern; city picked from the list so job-site ↔ agency matching is exact) |
| 6 | County / Area | yes | text |
| 7 | City / Community | yes | dropdown, cities of the chosen state (see 5) |
| 8 | Coverage Area | yes | text area |
| 9 | Website | no | URL |
| 10 | TCP Requirements | no | Required · Not Required · Depends on Project · Agency Review |
| 11 | No Parking Requirement | no | Required · Not Required · Depends on Project |
| 12 | City Hall Hours | no | text area |
| 13 | Coverage Note | yes | text area |
| 14 | Time Restrictions | yes | multi-line rows (≥ 1) |
| 15 | Attachments | yes | ≥ 1 file |
| 16 | Submission Type | — (not marked) | Manual · Email (+ address — amended 2026-10-09, see below) · 3rd Party Vendor (+ name) · Portal (+ URL + credentials) |
| 17 | Avg Permit Cost | — (not marked) | currency |

Fields 16–17 arrived without a required/not-required marker; the build treats both
as **optional**, with the vendor name required once *3rd Party Vendor* is chosen and
the portal URL required once *Portal* is chosen (and, since 2026-10-09, the email address
once *Email* is chosen). See gaps.

## How it maps onto Ben's sheet

`City List turn around - Ben.xlsx` → form: City/Community → 7 · Permit Lead Time → 4 ·
County/Area → 6 · State → 5 · Jurisdiction Type → 3 · Coverage Note → 13 · Notes →
Additional Notes (kept, optional). Two sheet columns have no home on the form and two
sheet values have no dropdown entry — recorded in
[`../vendors-agencies/gaps.md`](../vendors-agencies/gaps.md).

## Effect on the build (PR `feat/agency-form-rework`)

- `agencies` gains `agency_type`, `jurisdiction_type`, `permit_lead_time_days`, `state`,
  `county_area`, `coverage_area`, `coverage_note`, `tcp_requirement`, `submission_type`,
  `submission_vendor_name`, `portal_username`, `portal_password`; `turnaround_time`,
  `top_requirement`, `process` and the never-written `address` are dropped (Process
  text is folded into Notes; a bare-number turnaround becomes the lead time).
- The address block is gone from the form; the permit form's city/state autofill reads
  `Agency.city` / `Agency.state`, falling back to the old primary address for rows that
  predate this.
- Picklist codes live in `packages/shared/src/constants/agencies.ts`; the API
  validates with `@IsIn` against the same lists.
- Additional Notes is kept (optional) — it is in `agencies.md`'s user flow and on Ben's
  sheet, even though Ehtesham's list omits it.
- The agencies list table carries Ben's sheet columns after Agency Code and Name: City /
  Community · Permit Lead Time · County / Area · State · Jurisdiction Type · Notes ·
  Coverage Note (Syed Haris, 2026-09-15).

## What this does not settle

Everything under *Agency form 2026-09-15* in
[`../vendors-agencies/gaps.md`](../vendors-agencies/gaps.md).

## Amendment — 2026-10-09

Row 16 originally gave *Email* no companion field. Syed Haris approved adding one (TCG-144):
one Submission Email, required once Email is picked, reference only. See
[2026-10-09-agency-email-submission-address.md](2026-10-09-agency-email-submission-address.md).
