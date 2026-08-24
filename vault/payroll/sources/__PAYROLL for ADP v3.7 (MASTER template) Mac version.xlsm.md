---
title: "__PAYROLL for ADP v3.7 (MASTER template) Mac version.xlsm"
source_file: "PAYROLL for ADP v3.0 - current/__PAYROLL for ADP v3.7 (MASTER template) Mac version.xlsm"
source: onedrive/OneDrive_1_8-11-2026/
size: 2.5 MB
migrated: 2026-08-19
status: reference
migration_status: data
vault_target: ""
conflicts_with: []
jira: []
tags: [module/payroll, kind/source, provenance]
entities: []
part_of: payroll/sources/INDEX.md
---

# `__PAYROLL for ADP v3.7 (MASTER template) Mac version.xlsm`

**Path in the drop:** `PAYROLL for ADP v3.0 - current/__PAYROLL for ADP v3.7 (MASTER template) Mac version.xlsm`
**Size:** 2.5 MB
**Status:** not migrated — live payroll data
**Where the content lives:** —

Previous master, Mac build.

## What is in the file

- **11 sheets.**
- **11 configuration / system sheets:** `__hiddenParams`, `__PayrollWeeks`, `Holidays`, `CraftRates`, `CraftModRates`, `ADP TempRates`, `PAYROLL_START`, `Emp_ADP#s and SheetNames`, `TEMPLATE`, `ADP_IMPORT_REVIEW`, `ADP_IMPORT_VALIDATION`

> **Redaction.** This file carries real employee payroll rows. Per the knowledge pack's
> `SECURITY_REDACTION_CHECKLIST.md` the data is **not** copied into the vault — only the
> structure above. For the column-level rules this workbook implements, see
> [../adp-workbook-column-rules.md](../adp-workbook-column-rules.md).

---

*This page exists so that any filename in the 2026-08-11 OneDrive drop resolves to something in
the vault. It records what the file is and where its content went — it is not a copy of the file.
Full drop-level provenance: [../source-manifest.md](../source-manifest.md).*

---

> **Drift note (2026-08-24):** a newer copy exists in `3.7.1_MODULE-HR-LABOR-PAYROLL.zip`
> (Downloads, zipped 2026-08-19): 2,619,102 B (drop, 2026-08-11) → 2,562,970 B (zip, 2026-08-19 03:02). Live-file churn; the vault summary
> describes the migrated 2026-08-11 state. Everything else in that zip is byte-identical to
> the migrated drop — including both `__NEW_PAYROLL_v1.1` workbooks.
> **Drift explained (client message, 2026-08-24 batch):** the 2026-08-19 version is the
> **ADP-code accommodation update** — "we recently updated our payroll Excel file to
> accommodate the new payroll codes in ADP. This Excel file also automatically generates the
> file to import payroll data into ADP." The 8-19 copy is the current-process workbook.
