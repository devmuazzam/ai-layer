---
title: Permit lead times by city — three datasets that disagree
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/City Permit Turn Around Time.xlsx · .../__Job Schedule Master (from Ryan 2026-08-11)/City List turn around - Ben.xlsx · .../Permit_Turnaround_by_City.docx
migrated: 2026-09-04
updated: 2026-08-11
status: unverified
conflicts_with: []
jira: []
tags: [module/projects-jobs, module/dispatch, kind/reference, permits, scheduling, reference-data]
entities: []
---

# Permit lead times by city — three datasets that disagree

**What this is.** Three separate lead-time datasets arrived in the 2026-09-04 drop. The
Green/Yellow/Red scheduling decision in
[../scheduling/dispatch-scheduling-path.md](../scheduling/dispatch-scheduling-path.md) turns
entirely on "the approved Permit Lead-Time Chart", and the Job Schedule Master workbook computes
a permit path from one of these lists automatically. **Which of the three is the approved chart is
not stated anywhere in the drop, and they contradict each other on roughly 44% of the cities they
share.** That is the single most consequential finding on this page.

## The three datasets

### 1. `City Permit Turn Around Time.xlsx` — the hand-kept list

One sheet, `Sheet1`, dimensions A1:B124, two columns: `CITY` and `Turn around`. 98 distinct
jurisdictions after de-duplication. Values are **free text**, not numbers — "48 hours", "3 days",
"3-5 days (some annuals)", "10days", "48 Hours depending on address)", "5- 10 days". The
parenthetical "(annuals)" / "(some annuals)" marker appears on 27 rows and is the only annual-permit
signal in this file. "(Lic)" / "(LIC)" appears after nine city names — Anaheim, Costa Mesa,
Cypress, Fountain Valley, Hawthorne, Huntington Beach, Irvine, Ontario, Rancho Cucamonga,
San Bernardino County, Tustin — with no legend explaining it.

**The file contains internal duplicates that disagree with themselves:** `Arcadia` appears twice
as "48 hours" and "3 days"; `Corona` appears twice as "3-5 days (some annuals)" and "3 days".
Spellings are inconsistent ("Daimond Bar", "Bell Gardena", "Los Alamitios", "Turale", "Westminiter",
"La Vern"). No dates, no owner, no provenance.

### 2. `City List turn around - Ben.xlsx` — the structured list

Three sheets.

| Sheet | Dimensions | Content |
| --- | --- | --- |
| `Local 12 City List` | A1:H501 | **500 jurisdictions**, one per row |
| `Dropdown` | A1:A21 | The integers 1–20, headed `Permit Lead Time` — a validation list |
| `Estimate Notes` | A1:A3 | Two lines of text (quoted in full below) |

`Local 12 City List` columns: `City / Community`, `Permit Lead Time`, `County / Area`, `State`,
`Jurisdiction Type`, `Notes`, `Coverage Note`, `Estimated TCG Planning Lead Time (Days)`.

**Row data was not copied** — it is a 500-row reference table, and the Job Schedule Master
workbook carries the same 500 rows as its `PERMIT RULES MASTER` sheet. Its shape:

- **States:** 472 CA, 28 NV.
- **Jurisdiction types:** 243 `Unincorporated / CDP`, 239 `City`, 12 `Unincorporated Community`,
  3 `Town`, 3 `Community / Jurupa Valley Area`.
- **Counties:** Los Angeles 130, Riverside 65, San Bernardino 53, San Diego 43, Orange 42,
  Kern 35, Clark (NV) 23, Ventura 22, Santa Barbara 22, San Luis Obispo 20, Imperial 15, Mono 13,
  Inyo 12, Nye (NV) 5.
- **Permit lead time (days) distribution:** 0 → 1 jurisdiction · 1 → 19 · 2 → 45 · 3 → 73 ·
  4 → 20 · 5 → 50 · 7 → 2 · **10 → 288** · 14 → 2.
- **Estimated TCG Planning Lead Time distribution:** 1 → 1 · 3 → 42 · 4 → 25 · **5 → 431** · 10 → 1.
- The `Notes` column is empty on every row. `Coverage Note` is populated only for the Nevada rows,
  where it reads "Southern Nevada / verify Local 12 dispatch coverage".

**288 of 500 rows carry a 10-day lead time and 431 of 500 carry a 5-day planning estimate** —
those are clearly defaults for jurisdictions nobody has actually checked, not measured values.
The `Estimate Notes` sheet says so in as many words:

> Estimated TCG Planning Lead Times
> These values are planning estimates for internal scheduling, not official agency commitments.

The "Local 12" in the sheet name is the operating-engineers union local whose dispatch territory
TCG works in; the sheet is a coverage map as much as a permit list.

### 3. `Permit_Turnaround_by_City.docx` — a rendered view of dataset 2

581 lines. A `Turnaround Summary` table (the same 0/1/2/3/4/5/7/10/14-day counts, total 500), then
one section per lead-time band listing every jurisdiction in it with county, state and jurisdiction
type. **It is a presentation of dataset 2, not an independent source** — every count matches. Its
only added content is the word "Meaning" against each band: "Same-day estimate" for 0 days,
"Estimated permit processing time" for every other band.

## Where the two independent datasets disagree

78 jurisdictions appear in both dataset 1 and dataset 2 under an exactly matching name. **34 of
those 78 disagree** — treating "48 hours" as 2 days and "24 hours" as 1 day, and accepting any
overlap with a stated range.

| City | Hand-kept list says | Structured list says (lead / TCG planning) |
| --- | --- | --- |
| Cathedral City | 48 hours | 10 / 5 |
| Downey | 3–5 days | 4 / 5 |
| Fontana | 4 days (some annuals) | 3 / 4 |
| Highland | 48 hours | 4 / 5 |
| Inglewood | 48 hours (some annuals) | 4 / 5 |
| La Cañada Flintridge | 48 hours | 3 / 5 |
| **Laguna Beach** | 48 hours | **0 / 3** |
| Montebello | 5 days | 7 / 5 |
| Monterey Park | 5 days | 10 / 5 |
| Norco | 48 hours | 3 / 5 |
| Orange | 5 days (some annuals) | 4 / 3 |
| Oxnard | 48 hours | 3 / 4 |
| Palm Desert | 48 hours | 3 / 5 |
| Palm Springs | 2 days | 3 / 5 |
| **Palos Verdes Estates** | **10 days** | **2 / 5** |
| Pasadena | 48 hours | 4 / 5 |
| Placentia | 3 days (some annuals) | 4 / 3 |
| **Rancho Santa Margarita** | **3 days** | **10 / 3** |
| Redlands | 24 hours (some annuals) | 3 / 5 |
| Redondo Beach | 3 days | 2 / 5 |
| **Rolling Hills Estates** | **3 days** | **7 / 5** |
| San Bernardino | 5 days | 4 / 5 |
| San Diego | 5 days | 2 / 5 |
| Santa Ana | 3 days (annuals) | 2 / 3 |
| Santa Barbara | 5 days (some annuals) | 3 / 5 |
| Santa Clarita | 2 days | 3 / 5 |
| Santa Paula | 7–10 days | 5 / 4 |
| Seal Beach | 3 days | 4 / 3 |
| Stanton | 2 days (some annuals) | 3 / 3 |
| Upland | 3 days | 5 / 5 |
| Vernon | 48 hours | 3 / 3 |
| Victorville | 3 days | 4 / 5 |
| Villa Park | 5 days | 3 / 3 |
| Whittier | 48 hours | 4 / 5 |

The direction of disagreement runs both ways — sometimes the structured list is more conservative
(Cathedral City 2 → 10 days), sometimes far less (Palos Verdes Estates 10 → 2 days, Santa Paula
7–10 → 5 days). Neither dataset is uniformly the safe one.

## And the per-city notes are a *third* opinion

The dispatch notes in [city-permit-reference-a-l.md](city-permit-reference-a-l.md) and
[city-permit-reference-m-z.md](city-permit-reference-m-z.md) carry their own stated turnarounds,
which are not always either of the above. Examples:

- **Laguna Beach** — dataset 2 says 0 days. The note says the city **does not issue permits at all**
  and honours Caltrans. A 0-day lead time and "no permit exists" are not the same fact.
- **Palos Verdes Estates** — dataset 1 says 10 days, dataset 2 says 2. The note says the *route*
  usually needs Torrance and Rolling Hills Estates as well, and Rolling Hills Estates asks for
  **2–7 days' notice**.
- **Rancho Palos Verdes** — the note says "can take up to 10 days".
- **Bellflower** — the note says **2 weeks**; neither lead-time file lists Bellflower above 3 days.
- **Glendale** — the note says **14 business days (Mon–Thu)**; dataset 1 says 10 days.
- **Culver City** — dataset 1 says 10 days; the note says 3–5 days.
- **Claremont** — the note contradicts itself in four lines: "72hr notice" and then "permits have a
  3–5 days turnaround".

## What is unresolved

The drop does not say which list is "the approved Permit Lead-Time Chart" the scheduling playbooks
require, who owns any of the three, when each was last checked against the cities, or what a
Sales Coordinator is meant to do when two of them disagree on the city in front of them. The
Job Schedule Master workbook silently uses dataset 2 (as its `PERMIT RULES MASTER` sheet) to
compute Green / Yellow / Red — see
[job-schedule-master-workbook.md](../scheduling/job-schedule-master-workbook.md).

## Source

- `3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/City Permit Turn Around Time.xlsx`
  — 1 sheet, A1:B124, ~2.6 KB of text. `.xlsx` → per-sheet row dump.
- `3.1.1_MODULE-CRM-SALES-QUOTES/__Job Schedule Master (from Ryan 2026-08-11)/City List turn around - Ben.xlsx`
  — 3 sheets (`Local 12 City List` A1:H501, `Dropdown` A1:A21, `Estimate Notes` A1:A3), ~31 KB.
  **500 data rows not copied**; structure, distributions and both quoted note lines are above.
- `3.1.1_MODULE-CRM-SALES-QUOTES/__Job Schedule Master (from Ryan 2026-08-11)/Permit_Turnaround_by_City.docx`
  — 581 lines, `.docx` → pandoc GFM. A rendered grouping of the file above; **no independent content**.
