---
title: Payroll source manifest - OneDrive drop 2026-08-11
source: onedrive/OneDrive_1_8-11-2026/
migrated: 2026-08-13
updated: 2026-08-18
status: reference
conflicts_with: []
jira: []
topics: [payroll, migration, source-manifest, provenance]
entities: []
---

# Payroll source manifest — OneDrive drop, 2026-08-11

Every file in `OneDrive_1_8-11-2026/`, and what happened to it on 2026-08-13. **33 files.**
This exists so nobody has to re-derive whether something was missed, and so the ones that could
*not* be converted are a written fact rather than a silent gap.

## Migrated

| Source file | Size | Became |
| --- | ---: | --- |
| `The Crane Guys ERP Payroll Module.pdf` | 542 KB | [erp-payroll-module-frd/](erp-payroll-module-frd/INDEX.md) — 11 parts |
| `CodingCops_Payroll_Rule_Matrix.xlsx` | 38 KB | [codingcops-rule-matrix.md](codingcops-rule-matrix.md) — 68 rules |
| `Payroll_ADP_Bucket_Crosswalk.xlsx` | 32 KB | [adp-bucket-crosswalk.md](adp-bucket-crosswalk.md) |
| `MCOG Union 12 Master Labor Agreement 2025-2028 (payroll-specific summary).docx` | 60 KB | [mcog-l12-mla-2025-2028/](mcog-l12-mla-2025-2028/INDEX.md) — 5 parts |
| `PAYROLL_APP_build/PayrollAPP_0.5/TCG_PayrollAPP_AI_Knowledge_Pack_2026-06-23.zip` | 251 KB | [payroll-app-current-state/](payroll-app-current-state/INDEX.md) — 9 of 27 pack files |
| `PAYROLL_CURRENT/Worked Through Lunch Charts- Payroll_Billing.pdf` | 109 KB | [wtl-charts.md](wtl-charts.md) — 3 charts |
| `PAYROLL_CURRENT/Payroll Concepts Reference (Shift - Job - Labor Entry).html` | 14 KB | [payroll-concepts-shift-job-labor-entry.md](payroll-concepts-shift-job-labor-entry.md) |
| `PAYROLL for ADP v3.0 - current/PAYROLL for ADP - SOP v3.8.docx` | 1027 KB | [adp-sop-v3.8.md](adp-sop-v3.8.md) |
| `PAYROLL_APP_build/ADP-specific_files/HOUR_EARNING_CODES_…csv` | 1 KB | [adp-hour-earning-codes.md](adp-hour-earning-codes.md) |
| `PAYROLL_APP_build/PayrollAPP_LABOR-LOGIC-EXAMPLES.xlsx` | 20 MB | [rule-examples-catalog.md](rule-examples-catalog.md) — `Examples_Catalog` sheet only |

## Later drops (not part of the OneDrive folder)

| Source | Received | Became |
| --- | --- | --- |
| `projects.rar` — `tcg-payroll-api` (Program.cs) + `tcg-payroll-ui` (Next.js), files to Jul 2026 | 2026-08-13 / re-sent 2026-08-17 | [legacy-payroll-app-code-extract.md](legacy-payroll-app-code-extract.md) |
| `DATABASE_STORED_PROCEDURES.md` — object/parameter/table reference generated on the client machine | 2026-08-17 | folded into [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md) (superseded by the full extract) |
| `PAYROLL_CALC_EXTRACT.zip` (464 KB) — read-only extract of `TCG_PayrollAPP`: 141 SQL definitions, DDL, config rows, distinct codes, source feed, tests, worked examples | 2026-08-18 | [legacy-payroll-app-db-extract/](legacy-payroll-app-db-extract/INDEX.md) — everything except the extract's `parts/` provenance copies |
| 4 ADP Workforce Now screenshots (Manage Regular Payroll #31, ROLL / SALARY / PTO001 worksheets, company 4RZ) | 2026-08-18 | the ADP hand-off section of [legacy-payroll-app-db-extract/INDEX.md](legacy-payroll-app-db-extract/INDEX.md) |

## Not migrated, and why

### Scanned images — no text layer

`pdftotext` returned **zero characters** for all three. They are photographed/scanned copies of
the union agreement. Nothing was extracted; nothing was inferred. The readable route to the same
content is [mcog-l12-mla-2025-2028/](mcog-l12-mla-2025-2028/INDEX.md).

| File | Size |
| --- | ---: |
| `MCOG LABOR UNION L12/MCOG-O. E. Local 12 Truck Crane Master Labor Agreement 2025-2028.pdf` | 3.4 MB |
| `MCOG LABOR UNION L12/07.01.2025 truck crane MLA (1).pdf` | 2.6 MB |
| `PAYROLL_APP_build/L12_Union-Labor-Agreements/OE-Local-12-MLA-25-28-Comp.pdf` | 2.4 MB |

**If the full agreement text is ever needed, these need OCR** — they are not currently searchable
by any tool, including this vault.

### Full agreement text, superseded by the payroll extract

| File | Size | Note |
| --- | ---: | --- |
| `MCOG LABOR UNION L12/MCOG Union 12 Master Labor Agreement 2022-2025 and 2025-2028.pdf` | 15.9 MB | Text-extractable (1,753 lines). Contains **both** the expiring 2022–2025 and current 2025–2028 agreements — a live trap for citing a superseded rate. Not migrated because the payroll-relevant sections are already in `mcog-l12-mla-2025-2028/` |
| `PAYROLL_APP_build/L12_Union-Labor-Agreements/MCOG … 2025-2028 EXTRACTED.docx` | 1.1 MB | Near-identical to the migrated payroll summary |
| `MCOG LABOR UNION L12/2026 MCOG_updated_corrected_2026-06-22.pdf` | 248 KB | Rate sheet, 212 lines |
| `MCOG LABOR UNION L12/2026 MCOG_incorrectOldVersion.pdf` | 366 KB | **Filename says it is wrong.** Do not cite |

### Legacy walkthrough documents, superseded by the knowledge pack

The knowledge pack's own source-of-truth order ranks these below its dated Markdown, and the
2026-03-08 copy is explicitly flagged as historical-only.

| File | Size |
| --- | ---: |
| `PAYROLL_APP_build/2026-05-29_TCG_PayrollAPP_Technical_Walkthrough.docx` | 72 KB |
| `PAYROLL_APP_build/2026-05-29_TCG_PayrollAPP_Management_Walkthrough.docx` | 28 KB |
| `PAYROLL_APP_build/2026-03-08_TCG_PayrollAPP_Technical_Walkthrough.docx` | 57 KB |

### Live payroll data and workbook machinery

Real employee payroll data and the macro-enabled workbooks that produce it. Not migrated: they
are data and tooling, not specification, and copying employee payroll rows into a second system
is what the knowledge pack's `SECURITY_REDACTION_CHECKLIST.md` warns against. The **process**
they implement is captured in [adp-sop-v3.8.md](adp-sop-v3.8.md) and
[adp-bucket-crosswalk.md](adp-bucket-crosswalk.md).

| File | Size | What it is |
| --- | ---: | --- |
| `PAYROLL for ADP v3.0 - current/__PAYROLL for ADP v3.8 (MASTER template).xlsm` | 2.6 MB | 11 sheets, current master template |
| `PAYROLL for ADP v3.0 - current/__PAYROLL for ADP v3.7 (MASTER template) Mac version.xlsm` | 2.6 MB | 11 sheets |
| `PAYROLL for ADP v3.0 - current/July 25-31 2026.xlsm` | 3.6 MB | 83 sheets, one live week |
| `PAYROLL_CURRENT/__NEW_PAYROLL_v1.1__MASTER-TEMPLATE.xlsx` | 2.5 MB | 84 sheets |
| `PAYROLL_CURRENT/__NEW_PAYROLL_v1.1_June 20- 26, 2026 (partial sample).xlsx` | 2.5 MB | 82 sheets |
| `PAYROLL_APP_build/COPY_of_Official_Payroll_June 6- 12, 2026.xlsx` | 292 KB | 80 sheets |
| `PAYROLL for ADP v3.0 - current/EPI4RZ32.csv` | 7 KB | ADP paydata export, **Co Code 4RZ** |
| `PAYROLL_APP_build/ADP-specific_files/Sample ADP Export - EPI63100.CSV` | 28 KB | ADP paydata export sample |

### Binaries and environment setup

| File | Size | Note |
| --- | ---: | --- |
| `PAYROLL_APP_build/PayrollAPP_0.5/TCG_SQL_backup_2026-06-23.7z` | 172 MB | SQL Server database backup |
| `PAYROLL_APP_build/PayrollAPP_0.5/TCG - backup - 2026-06-10_L12andNU.7z` | 99 MB | Application backup |
| `PAYROLL_APP_build/PayrollAPP_0.5/README_SETUP_TCG_PayrollApp_2026-06-23.md` | 18 KB | Windows / SQL Server Express local-restore guide for the legacy stack |
| `PAYROLL_APP_build/ADP-specific_files/wfn_importing_paydata.pdf` | 533 KB | ADP Workforce Now vendor documentation — importing paydata |
| `PAYROLL_APP_build/ADP-specific_files/screenshot of ADP labor entry screen.png` | 505 KB | Screenshot of the ADP labor entry screen |

### Knowledge-pack files left behind

Of the 27 files in the AI Knowledge Pack zip, 9 were migrated. The rest are vendor-onboarding
instructions, Windows/SQL-Server restore steps, `.sql` templates, config examples, the redaction
checklist, the manifest, and duplicate copies of the source `.docx`/`.md` documents already
covered above.
