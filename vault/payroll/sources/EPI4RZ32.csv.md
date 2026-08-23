---
title: "EPI4RZ32.csv"
source_file: "PAYROLL for ADP v3.0 - current/EPI4RZ32.csv"
source: onedrive/OneDrive_1_8-11-2026/
size: 6 KB
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

# `EPI4RZ32.csv`

**Path in the drop:** `PAYROLL for ADP v3.0 - current/EPI4RZ32.csv`
**Size:** 6 KB
**Status:** not migrated — live payroll data
**Where the content lives:** —

The **output** of the July 25–31 workbook — the ADP paydata import, company `4RZ`.

## What is in the file

- **176 data rows**, 16 columns.
- Columns: `Co Code`, `Batch ID`, `File #`, `Reg Hours`, `O/T Hours`, `Hours 3 Code`, `Hours 3 Amount`, `Temp Rate`, `Hours 4 Code`, `Hours 4 Amount`, `Hours 4 Code`, `Hours 4 Amount`, `Hours 4 Code`, `Hours 4 Amount`, `Earnings 3 Code`, `Earnings 3 Amount`

> **Redaction.** This file carries real employee payroll rows. Per the knowledge pack's
> `SECURITY_REDACTION_CHECKLIST.md` the data is **not** copied into the vault — only the
> structure above. For the column-level rules this workbook implements, see
> [../adp-workbook-column-rules.md](../adp-workbook-column-rules.md).

---

*This page exists so that any filename in the 2026-08-11 OneDrive drop resolves to something in
the vault. It records what the file is and where its content went — it is not a copy of the file.
Full drop-level provenance: [../source-manifest.md](../source-manifest.md).*
