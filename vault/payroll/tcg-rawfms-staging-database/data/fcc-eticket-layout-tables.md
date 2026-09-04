---
title: FCC e-ticket layout tables — the section and sub-section rows behind the ETS template
source: shared-folder/Project-Repository-2026-09-04/3.7.1_MODULE-HR-LABOR-PAYROLL/PAYROLL_APP_build/PayrollAPP_0.5/TCG_SQL_backup_2026-06-23.7z → TCG_RawFMS_20260623.bak, restored 2026-09-04 and read from stg.FMS_TICKET_SECTIONS_SUBLIST_Raw
migrated: 2026-09-04
updated: 2026-09-04
status: reference
conflicts_with: []
jira: []
tags: [module/field-ops, module/dispatch, kind/reference, ticket-workflow, reference-data]
part_of: payroll/tcg-rawfms-staging-database/INDEX.md
---

> Rows exactly as FCC NexGen held them when the nightly copy ran at 08:00 UTC on 2026-06-23.
> Audit columns (`CreatedBy`, `CreatedDate`, `ModifiedBy`, `ModifiedDate`, `trg*`, the two
> `_…AtUTC` load stamps) are dropped from the tables below; the full column set is in
> [../ddl/stg.FMS_TICKET_SECTIONS_SUBLIST_Raw.sql](../ddl/stg.FMS_TICKET_SECTIONS_SUBLIST_Raw.sql). This is what the system **held**, not
> what TCG has decided it should hold — treat every row as a fact about FCC, not a requirement.

# FCC e-ticket layout tables — sections and sub-sections

Two tables drive what an e-ticket (ETS) template shows. `FMS_TICKET_SECTIONS_SUBLIST` names the
fields available inside each section (`TicketSectionListID` 3 = job-site block, 8 = time and
crew block, 12 and 13 = checklist grids with *Description / Comments / Completed / Deficiency /
N/A*). `FMS_ETS_TICKET_SUB_SECTION` then says, per template, which of those fields are
visible, printed, and in what order. Only `TemplateID = 1` exists. The three-state checklist
answer the field example describes
([../../../field-ops/e-ticket-worked-example.md](../../../field-ops/e-ticket-worked-example.md) §3)
is sub-sections 25–27 / 33–35 here.

## `FMS_TICKET_SECTIONS_SUBLIST` — 21 rows

| TicketSectionSubListID | TicketSectionListID | SubSectionName | LineNumb |
|---|---|---|---|
| `1` | 3 | Job Site Information | 1 |
| `2` | 3 | Report To | 2 |
| `3` | 3 | Customer Information | 3 |
| `5` | 8 | Est Start Time | 2 |
| `6` | 8 | Est End Time | 3 |
| `7` | 8 | Comments | 4 |
| `9` | 8 | Employee Name | 6 |
| `10` | 8 | Employee Type | 7 |
| `25` | 12 | Completed | 3 |
| `26` | 12 | Deficiency | 4 |
| `27` | 12 | N/A | 5 |
| `28` | 12 | Description | 1 |
| `29` | 12 | Comments | 2 |
| `30` | 3 | Directions | 4 |
| `31` | 13 | Description | 1 |
| `32` | 13 | Comments | 2 |
| `33` | 13 | Completed | 3 |
| `34` | 13 | Deficiency | 4 |
| `35` | 13 | N/A | 5 |
| `36` | 8 | Worked Through Lunch | 9 |
| `37` | 8 | Hook Ready Time | 10 |

## `FMS_ETS_TICKET_SUB_SECTION` — 42 rows

| TemplateID | TicketSectionListID | TicketSectionSubListID | Visibility | Printed | DisplaySectionName | LineNumb |
|---|---|---|---|---|---|---|
| `1` | 3 | 1 | 0 | 0 |  | 1 |
| `1` | 3 | 2 | 0 | 0 |  | 2 |
| `1` | 3 | 3 | 0 | 0 |  | 3 |
| `1` | 3 | 30 | 0 | 0 |  | 4 |
| `1` | 8 | 5 | 0 | 0 |  | 9 |
| `1` | 8 | 6 | 0 | 0 |  | 2 |
| `1` | 8 | 7 | 0 | 0 |  | 3 |
| `1` | 8 | 9 | 0 | 0 |  | 4 |
| `1` | 8 | 10 | 0 | 0 |  | 6 |
| `1` | 8 | 36 | 0 | 0 |  | 7 |
| `1` | 8 | 37 | 0 | 0 |  | 10 |
| `1` | 12 | 25 | 1 | 0 |  | 3 |
| `1` | 12 | 26 | 0 | 0 |  | 4 |
| `1` | 12 | 27 | 0 | 0 |  | 5 |
| `1` | 12 | 28 | 1 | 0 |  | 1 |
| `1` | 12 | 29 | 1 | 0 |  | 2 |
| `1` | 13 | 31 | 1 | 0 |  | 1 |
| `1` | 13 | 32 | 1 | 0 |  | 2 |
| `1` | 13 | 33 | 1 | 0 |  | 3 |
| `1` | 13 | 34 | 0 | 0 |  | 4 |
| `1` | 13 | 35 | 0 | 0 |  | 5 |
| `2` | 3 | 1 | 0 | 0 |  | 1 |
| `2` | 3 | 2 | 0 | 0 |  | 2 |
| `2` | 3 | 3 | 0 | 0 |  | 3 |
| `2` | 3 | 30 | 0 | 0 |  | 4 |
| `2` | 8 | 5 | 0 | 0 |  | 2 |
| `2` | 8 | 6 | 0 | 0 |  | 3 |
| `2` | 8 | 7 | 0 | 0 |  | 4 |
| `2` | 8 | 9 | 0 | 0 |  | 6 |
| `2` | 8 | 10 | 0 | 0 |  | 7 |
| `2` | 8 | 36 | 0 | 0 |  | 9 |
| `2` | 8 | 37 | 0 | 0 |  | 10 |
| `2` | 12 | 25 | 1 | 0 |  | 3 |
| `2` | 12 | 26 | 1 | 0 |  | 4 |
| `2` | 12 | 27 | 1 | 0 |  | 5 |
| `2` | 12 | 28 | 1 | 0 |  | 1 |
| `2` | 12 | 29 | 1 | 0 |  | 2 |
| `2` | 13 | 31 | 1 | 0 |  | 1 |
| `2` | 13 | 32 | 1 | 0 |  | 2 |
| `2` | 13 | 33 | 1 | 0 |  | 3 |
| `2` | 13 | 34 | 1 | 0 |  | 4 |
| `2` | 13 | 35 | 1 | 0 |  | 5 |
