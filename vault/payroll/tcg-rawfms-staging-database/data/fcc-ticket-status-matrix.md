---
title: FCC ticket status matrix — the 53 rows that decode a ticket status per ticket type
source: shared-folder/Project-Repository-2026-09-04/3.7.1_MODULE-HR-LABOR-PAYROLL/PAYROLL_APP_build/PayrollAPP_0.5/TCG_SQL_backup_2026-06-23.7z → TCG_RawFMS_20260623.bak, restored 2026-09-04 and read from stg.FMS_TICKET_STATUS_Raw
migrated: 2026-09-04
updated: 2026-09-04
status: reference
conflicts_with: []
jira: []
tags: [module/dispatch, module/field-ops, kind/reference, ticket-workflow, reference-data]
part_of: payroll/tcg-rawfms-staging-database/INDEX.md
---

> Rows exactly as FCC NexGen held them when the nightly copy ran at 08:00 UTC on 2026-06-23.
> Audit columns (`CreatedBy`, `CreatedDate`, `ModifiedBy`, `ModifiedDate`, `trg*`, the two
> `_…AtUTC` load stamps) are dropped from the tables below; the full column set is in
> [../ddl/stg.FMS_TICKET_STATUS_Raw.sql](../ddl/stg.FMS_TICKET_STATUS_Raw.sql). This is what the system **held**, not
> what TCG has decided it should hold — treat every row as a fact about FCC, not a requirement.

# FCC ticket status matrix — 53 rows, four ticket types

FCC does not store one status per ticket. `FMS_TICKET_STATUS` is a **decoding matrix**: the
displayed status is derived from the ticket's `TicketType`, its one-letter `JobTicketStatus`
code, and four flags (`Viewed`, `Download`, `EnableWT`, `TimeStart`/`TimeEnd` non-null). The
`Comments` column is FCC's own note on which combination wins. Four ticket types share the
same letter codes but display different words — `C` is *Left Yard* on an Operator ticket,
*Arrived at Shipper* on a Trucking ticket and *Picked Up* on a Load ticket.

The letter progression every type follows: `T` (sent → viewed → downloaded → started) →
`C` → `O` → `S` → `R` → `F` → `Y` (arrived / ended) → `Z` completed, with `X` cancelled at any
point. The e-ticket lifecycle the vault describes elsewhere
([../../../dispatch/fcc-nexgen-dispatch-guide.md](../../../dispatch/fcc-nexgen-dispatch-guide.md),
[../../../field-ops/fcc-nexgen-service-guide.md](../../../field-ops/fcc-nexgen-service-guide.md))
is this table rendered as prose. The legacy payroll app re-derives the same thing in
`app.v_JobTicket_Status_Enriched`
([../../legacy-payroll-app-db-extract/sql/app/v_JobTicket_Status_Enriched.VIEW.sql](../../legacy-payroll-app-db-extract/sql/app/v_JobTicket_Status_Enriched.VIEW.sql)).

| TicketStatusCode | TicketType | Viewed | Download | EnableWT | TimeStart | TimeEnd | Description | Comments |
|---|---|---|---|---|---|---|---|---|
| `T` | Operator | 0 | 0 | 0 | 0 | 0 | Sent | Viewed=0, Download=0 |
| `T` | Operator | 1 | 0 | 0 | 0 | 0 | Viewed | Viewed=1, Download=0 |
| `T` | Operator | 1 | 1 | 0 | 0 | 0 | Downloaded | Viewed=1 Download =1 |
| `T` | Operator | 1 | 1 | 1 | 1 | 0 | Started | EnableWorkTimes =1 and TimeStart=1 (means TimeStart is not null) |
| `C` | Operator | 1 | 1 | 0 | 0 | 0 | Left Yard | Just go with Status and Type |
| `O` | Operator | 1 | 1 | 0 | 0 | 0 | Arrived Job | Just go with Status and Type |
| `S` | Operator | 1 | 1 | 0 | 0 | 0 | 1st Signature | Just go with Status and Type |
| `R` | Operator | 1 | 1 | 0 | 0 | 0 | 2nd Signature | Just go with Status and Type |
| `F` | Operator | 1 | 1 | 0 | 0 | 0 | Left Job | Just go with Status and Type |
| `Y` | Operator | 1 | 1 | 0 | 0 | 0 | Arrived Yard | Just go with Status and Type |
| `Y` | Operator | 1 | 1 | 0 | 0 | 1 | Ended | EnableWorkTimes =1 and TimeEnd=1 |
| `Z` | Operator | 1 | 1 | 0 | 0 | 0 | Completed | Just go with Status and Type |
| `X` | Operator | 1 | 1 | 0 | 0 | 0 | Cancelled | Just go with Status and Type |
| `T` | LEM | 0 | 0 | 0 | 0 | 0 | Sent | Viewed=0, Download=0 |
| `T` | LEM | 1 | 0 | 0 | 0 | 0 | Viewed | Viewed=1, Download=0 |
| `T` | LEM | 1 | 1 | 0 | 0 | 0 | Downloaded | Viewed=1 Download =1 |
| `T` | LEM | 1 | 1 | 0 | 0 | 0 | Not Started | Just go with Status and Type |
| `T` | LEM | 1 | 1 | 1 | 1 | 0 | Started | EnableWorkTimes =1 and TimeStart=1 |
| `C` | LEM | 1 | 1 | 0 | 0 | 0 | Left Yard | Just go with Status and Type |
| `O` | LEM | 1 | 1 | 0 | 0 | 0 | Arrived Job | Just go with Status and Type |
| `S` | LEM | 1 | 1 | 0 | 0 | 0 | 1st Signature | Just go with Status and Type |
| `R` | LEM | 1 | 1 | 0 | 0 | 0 | 2nd Signature | Just go with Status and Type |
| `F` | LEM | 1 | 1 | 0 | 0 | 0 | Left Job | Just go with Status and Type |
| `Y` | LEM | 1 | 1 | 0 | 0 | 0 | Arrived Yard | Just go with Status and Type |
| `Y` | LEM | 1 | 1 | 1 | 0 | 1 | Ended | EnableWorkTimes =1 and TimeEnd=1 |
| `Z` | LEM | 1 | 1 | 0 | 0 | 0 | Completed | Just go with Status and Type |
| `X` | LEM | 1 | 1 | 0 | 0 | 0 | Cancelled | Just go with Status and Type |
| `T` | TRUCKING | 0 | 0 | 0 | 0 | 0 | Sent | Viewed=0, Download=0 |
| `T` | TRUCKING | 1 | 0 | 0 | 0 | 0 | Viewed | Viewed=1, Download=0 |
| `T` | TRUCKING | 1 | 1 | 0 | 0 | 0 | Downloaded | Viewed=1 Download =1 |
| `T` | TRUCKING | 1 | 1 | 0 | 0 | 0 | Not Started | Just go with Status and Type |
| `T` | TRUCKING | 1 | 1 | 1 | 1 | 0 | Started | EnableWorkTimes =1 and TimeStart=1 |
| `C` | TRUCKING | 1 | 1 | 0 | 0 | 0 | Arrived at Shipper | Just go with Status and Type |
| `O` | TRUCKING | 1 | 1 | 0 | 0 | 0 | Started | Just go with Status and Type |
| `S` | TRUCKING | 1 | 1 | 0 | 0 | 0 | Shipper's Signature | Just go with Status and Type |
| `R` | TRUCKING | 1 | 1 | 0 | 0 | 0 | Receiver's Signaturee | Just go with Status and Type |
| `F` | TRUCKING | 1 | 1 | 0 | 0 | 0 | Received | Just go with Status and Type |
| `Y` | TRUCKING | 1 | 1 | 0 | 0 | 0 | Departed Receiver | Just go with Status and Type |
| `Y` | TRUCKING | 1 | 1 | 1 | 0 | 1 | Ended | EnableWorkTimes =1 and TimeEnd=1 |
| `Z` | TRUCKING | 1 | 1 | 0 | 0 | 0 | Completed | Just go with Status and Type |
| `X` | TRUCKING | 1 | 1 | 0 | 0 | 0 | Cancelled | Just go with Status and Type |
| `T` | LOAD | 0 | 0 | 0 | 0 | 0 | Sent | Viewed=0, Download=0 |
| `T` | LOAD | 1 | 0 | 0 | 0 | 0 | Viewed | Viewed=1, Download=0 |
| `T` | LOAD | 1 | 1 | 0 | 0 | 0 | Downloaded | Viewed=1 Download =1 |
| `T` | LOAD | 1 | 1 | 0 | 0 | 0 | Not Started | Just go with Status and Type |
| `T` | LOAD | 1 | 1 | 1 | 1 | 0 | Started | EnableWorkTimes =1 and TimeStart=1 |
| `C` | LOAD | 1 | 1 | 0 | 0 | 0 | Picked Up | Just go with Status and Type |
| `O` | LOAD | 1 | 1 | 0 | 0 | 0 | 1st Signature | Just go with Status and Type |
| `F` | LOAD | 1 | 1 | 0 | 0 | 0 | 2nd Signature | Just go with Status and Type |
| `Y` | LOAD | 1 | 1 | 0 | 0 | 0 | Dropped | Just go with Status and Type |
| `Y` | LOAD | 1 | 1 | 1 | 0 | 1 | Ended | EnableWorkTimes =1 and TimeEnd=1 |
| `Z` | LOAD | 1 | 1 | 0 | 0 | 0 | Completed | Just go with Status and Type |
| `X` | LOAD | 1 | 1 | 0 | 0 | 0 | Cancelled | Just go with Status and Type |
