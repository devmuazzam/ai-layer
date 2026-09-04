---
title: "screenshot of ADP labor entry screen.png"
source_file: "PAYROLL_APP_build/ADP-specific_files/screenshot of ADP labor entry screen.png"
source: onedrive/OneDrive_1_8-11-2026/
size: 504 KB
migrated: 2026-08-19
status: reference
migration_status: described
vault_target: ""
conflicts_with: []
jira: []
tags: [module/payroll, kind/source, provenance]
entities: []
part_of: payroll/sources/INDEX.md
---

# `screenshot of ADP labor entry screen.png`

**Path in the drop:** `PAYROLL_APP_build/ADP-specific_files/screenshot of ADP labor entry screen.png`
**Size:** 504 KB
**Status:** read from the image 2026-09-04; described below
**Where the content lives:** —

Screenshot of the ADP labor entry screen.

## What is in the file

Read visually on 2026-09-04. It is the **ADP Workforce Now "Worksheet" screen** for a pay-data
batch — the grid the workbook's ROLL sheet is keyed into:

- Batch **`ROLL`**, sub-label **`Field Roll`**; Company **`631 - The Crane Gu…`**; Status
  **☑ In balance**; *"Total Employees (by File#) in this batch: 87"*.
- Columns, left to right: `File # · Name · Pay # · Tax Freq… · Temporary Rate · Reg Hours · O/T
  Hours · Double Time · LB REG… · LB OVE… · LB DBL · SUB PAY · Holiday Double · Holiday Triple ·
  Sick · Other Earnings - Holiday · Other Earnings - OTH · Reg Ea… · O/T Earnings`. Rows are one
  per employee **per line** — one employee shows eleven rows, so a row is an earnings line, not an
  employee.
- Footer: `Batch Totals · Your Totals · Difference` per column; buttons *Cancel · Save · Auto
  Balance · Done*; a *Show Employee Details and Rates* expander; *Change Saving Options*.
- Employee names and file numbers are visible in the image and are **not copied here**.

**Two things worth knowing.** The column set is exactly the bucket vocabulary in
[../adp-bucket-crosswalk.md](../adp-bucket-crosswalk.md) (`LB REG / LB OVE / LB DBL` = long-boom
regular/overtime/double; `SUB PAY` = subsistence; `Holiday Double / Triple`). And the **company
shown is `631`**, whereas the vault's other ADP artefacts (the `EPI4RZ32.csv` export, the
pay-schedule API response) carry company code **`4RZ`**. Whether `631` is a different ADP company
code, a client ID, or a batch identifier is not established by this image.

---

*This page exists so that any filename in the 2026-08-11 OneDrive drop resolves to something in
the vault. It records what the file is and where its content went — it is not a copy of the file.
Full drop-level provenance: [../source-manifest.md](../source-manifest.md).*
