---
title: "__NEW_PAYROLL_v1.1__MASTER-TEMPLATE.xlsx"
source_file: "PAYROLL_CURRENT/__NEW_PAYROLL_v1.1__MASTER-TEMPLATE.xlsx"
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

# `__NEW_PAYROLL_v1.1__MASTER-TEMPLATE.xlsx`

**Path in the drop:** `PAYROLL_CURRENT/__NEW_PAYROLL_v1.1__MASTER-TEMPLATE.xlsx`
**Size:** 2.5 MB
**Status:** not migrated — live payroll data
**Where the content lives:** —

A separate, newer workbook lineage (`NEW_PAYROLL v1.1`) — not the `PAYROLL for ADP` line.

## What is in the file

- **84 sheets.**
- **5 configuration / system sheets:** `PAYROLL_START`, `Holidays`, `CraftRates`, `CraftModRates`, `TEMPLATE`
- **79 further sheets**, one per employee, named `LASTNAME-F`. **Not listed here** — the sheet names are the payroll roster.

> **Redaction.** This file carries real employee payroll rows. Per the knowledge pack's
> `SECURITY_REDACTION_CHECKLIST.md` the data is **not** copied into the vault — only the
> structure above. For the column-level rules this workbook implements, see
> [../adp-workbook-column-rules.md](../adp-workbook-column-rules.md).

---

*This page exists so that any filename in the 2026-08-11 OneDrive drop resolves to something in
the vault. It records what the file is and where its content went — it is not a copy of the file.
Full drop-level provenance: [../source-manifest.md](../source-manifest.md).*
