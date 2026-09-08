---
title: "EPI4RZ36.csv"
source_file: "PAYROLL for ADP v5.1 - current/EPI4RZ36.csv"
source: shared-folder/Project-Repository-2026-09-08/3.7.1_MODULE-HR-LABOR-PAYROLL/
size: 7 KB
migrated: 2026-09-08
status: reference
migration_status: data
vault_target: ""
conflicts_with: []
jira: []
tags: [module/payroll, kind/source, provenance]
entities: []
part_of: payroll/sources/INDEX.md
---

# `EPI4RZ36.csv`

**Path in the drop:** `PAYROLL for ADP v5.1 - current/EPI4RZ36.csv`
**Size:** 7 KB
**Status:** not migrated — live payroll data; structure verified
**Where the content lives:** —

The **output** of the week-36 v5.1 workbook — the ADP paydata import for **2026-08-22 → 08-28**,
company `4RZ`, batch `260936`. The client: *"this one contains the data for this payroll week #36."*
Compare [`EPI4RZ32.csv`](EPI4RZ32.csv.md), the v3.x export of week 32.

## What is in the file — structure only

- **184 data rows, 24 columns, 61 distinct File #s.** One Co Code (`4RZ`), one Batch ID.
- Header, in order: `Co Code · Batch ID · File # · Reg Hours · O/T Hours · Hours 3 Code · Hours 3
  Amount · Temp Rate · (Hours 4 Code · Hours 4 Amount) × 6 · Earnings 3 Code · Earnings 3 Amount ·
  Hours 3 Code · Hours 3 Amount`. The v3.x file had 16 columns with three Hours-4 pairs; the
  exporter still writes only the pairs some row uses, so the width is week-dependent.
- **Row shapes:** a primary row per employee (Reg / OT, `DT` in the first Hours-3 pair, `SUB` as
  Earnings 3 on four rows, `SIC` in the trailing Hours-3 pair on two rows), then temp-rate rows
  with exactly one Hours-4 pair each. Employees carry 1–7 rows; 25 of 61 have a single row.
- **Codes present:** `DT` (52 rows) · `LBH` 46 · `LBO` 43 · `LBD` 27 · **`MLR` / `MLO` / `MLD` 2
  each** · `SUB` 4 · `SIC` 2. No `HDD`, `HOL`, `LBT`, lattice, shift or foreman codes this week.
- **Temp rates seen:** the boom ladder values (0.50 … 20.00 at ×1, ×1.5, ×2 — including operator
  brackets up to $6.75 and beyond), **10 / 15 / 20 on the Military rows**, and **one temp-rate row
  at `72.16`** — a full L12 Group-9 FY26-27 base rate, not an adder. What that row is, the engine
  page explains: [adp-workbook-v5.1-engine.md](../adp-workbook-v5.1-engine.md).

> **First production evidence that the Military Base premium reaches ADP** — as `MLR`/`MLO`/`MLD`
> temp-rate rows at $10 × 1 / 1.5 / 2, exactly the multiplied reading
> [foreman-and-military-premiums.md](../foreman-and-military-premiums.md) inferred from the
> existence of `MLT`.

> **Redaction.** Real employee payroll rows keyed by ADP File #. The data is **not** copied into
> the vault — counts, codes and rate values only.
