---
title: FCC job status, job type and department codes as held on 2026-06-23
source: shared-folder/Project-Repository-2026-09-04/3.7.1_MODULE-HR-LABOR-PAYROLL/PAYROLL_APP_build/PayrollAPP_0.5/TCG_SQL_backup_2026-06-23.7z → TCG_RawFMS_20260623.bak, restored 2026-09-04 and read from stg.FMS_JOB_STATUS_Raw
migrated: 2026-09-04
updated: 2026-09-04
status: reference
conflicts_with: []
jira: []
tags: [module/projects-jobs, module/dispatch, kind/reference, reference-data]
part_of: payroll/tcg-rawfms-staging-database/INDEX.md
---

> Rows exactly as FCC NexGen held them when the nightly copy ran at 08:00 UTC on 2026-06-23.
> Audit columns (`CreatedBy`, `CreatedDate`, `ModifiedBy`, `ModifiedDate`, `trg*`, the two
> `_…AtUTC` load stamps) are dropped from the tables below; the full column set is in
> [../ddl/stg.FMS_JOB_STATUS_Raw.sql](../ddl/stg.FMS_JOB_STATUS_Raw.sql). This is what the system **held**, not
> what TCG has decided it should hold — treat every row as a fact about FCC, not a requirement.

# FCC job status, job type and department codes

Three small lookups that every FCC job row references. All three are printed in full.

## Job status — 7 codes

Note the create stamp: all seven rows were (re)written by `sa` on **2026-02-18**, the same
day FCC added the *Job Foreman* employee type — a vendor maintenance release, not a TCG edit.

| JobStatusCode | Description |
|---|---|
| `C` | Confirmed |
| `F` | Finished |
| `O` | On Job |
| `R` | Transfer |
| `T` | Tentative |
| `X` | Cancelled |
| `Z` | Complete |

## Job type — 11 codes, 4 active

`Status = 1` marks the four still selectable (`B`, `H`, `S`, `Z`). *Contract*, *Monthly*, *Weekly* were retired in
2020; *OCIP/CCIP*, *Prevailing Wage*, *PSA/PLA* and *Vacation* were switched off on
2025-10-30 and *Storage* switched on the next day — the same week the `ST` Storage department
below was created. The quote screen's own job-type list is the same 11 codes
([../../../quotations/fcc-nexgen-quote-entry.md](../../../quotations/fcc-nexgen-quote-entry.md)).

| JobTypeCode | Description | Status |
|---|---|---|
| `B` | Bare | 1 |
| `C` | Contract | 0 |
| `H` | Hourly | 1 |
| `M` | Monthly | 0 |
| `O` | OCCIP/ CCIP | 0 |
| `P` | Prevailing Wage | 0 |
| `S` | Storage | 1 |
| `U` | PSA / PLA | 0 |
| `V` | Vacation | 0 |
| `W` | Weekly | 0 |
| `Z` | Hourly w/ Mob | 1 |

## Department — 10 codes

`ExpAcct` is FCC's "expense account required" flag. The two youngest departments are
*Customer Repair* (2025-08-13) and *Storage* (2025-10-31). Purchase-order numbers are prefixed
with these codes
([../../../vendors-agencies/purchase-orders-fcc/fcc-po-entry-walkthrough.md](../../../vendors-agencies/purchase-orders-fcc/fcc-po-entry-walkthrough.md)).

| DeptCode | Name | Status | ExpAcct |
|---|---|---|---|
| `CR` | Customer Repair | 1 | 0 |
| `FL` | FLEET | 1 | 1 |
| `ID` | INTERNAL DAMAGE | 1 | 1 |
| `MC` | MECHANICS | 1 | 1 |
| `OM` | OPERATED & MAINTAINED | 1 | 1 |
| `RG` | RIGGING | 1 | 1 |
| `SH` | SHOP | 1 | 1 |
| `ST` | STORAGE | 1 | 0 |
| `TR` | TRUCKING | 1 | 1 |
| `YD` | YARD | 1 | 1 |
