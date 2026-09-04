---
title: Payroll source manifest - OneDrive drop 2026-08-11
source: onedrive/OneDrive_1_8-11-2026/
migrated: 2026-08-13
updated: 2026-09-04
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, data-migration, provenance]
entities: []
---

# Payroll source manifest — OneDrive drop, 2026-08-11

Every file in `OneDrive_1_8-11-2026/`, and what happened to it on 2026-08-13. **33 files.**
This exists so nobody has to re-derive whether something was missed, and so the ones that could
*not* be converted are a written fact rather than a silent gap.

> **Per-file pages added 2026-08-19: [sources/](sources/INDEX.md).** Every one of the 33 files now
> has its own page *named after the file*, carrying what the file is, its internal structure, and
> where its content went. Name any file from this drop and it resolves — including the ones
> deliberately not migrated, so "we don't have that" is a written answer rather than a guess.
> This page stays the drop-level narrative; that folder is the per-file index.

> **Re-shared 2026-09-04, verified file by file.** The same folder came back as
> `3.7.1_MODULE-HR-LABOR-PAYROLL/` inside the client's SharePoint "Project Repository" drop. All 34
> files were compared against this manifest by name. **33 are accounted for below. One was not:
> `Payroll-rule dependency matrix.docx`** — a ~9,000-word TCG-side position paper on calculation
> scope, immutable closed periods and retro adjustments, now
> [payroll-rule-dependency-matrix.md](payroll-rule-dependency-matrix.md). Its worked example
> (8/22–8/28) postdates the 2026-08-11 snapshot, so the likelier reading is that it was added to
> SharePoint after this drop was taken rather than missed by the migration. Two further changes:
> `TCG - backup - 2026-06-10_L12andNU.7z`, listed under *Binaries* below, was **opened** and turns
> out to be full application source — see
> [legacy-payroll-app-source-tree-2026-06-10.md](legacy-payroll-app-source-tree-2026-06-10.md);
> and the drop-level record for every file, including these, is
> [sync/project-repository-2026-09-04.md](../sync/project-repository-2026-09-04.md).

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

**2026-09-04 — `TCG_SQL_backup_2026-06-23.7z` restored.** The SQL backup that was listed but never opened is now processed: `TCG_PayrollAPP_20260623.bak` → [legacy-payroll-app-db-backup-2026-06-23.md](legacy-payroll-app-db-backup-2026-06-23.md) (code identical to the 2026-08-18 extract; data and run history recorded), `TCG_RawFMS_20260623.bak` → [tcg-rawfms-staging-database/INDEX.md](tcg-rawfms-staging-database/INDEX.md) (schema, ETL, reference rows). Archive and a table export are kept off-SharePoint; see those pages for the confidentiality note.

## Not migrated, and why

### Scanned images — no text layer

`pdftotext` returned **zero characters** for all three. **OCR'd on 2026-09-04** (tesseract, 200 dpi):
they are *not* three copies of one document — the 40-page file is the Truck Crane MLA, the
108-page file is the **SCCA Southern California MLA** (a different agreement), and the 4-page file
is Local 12's **2025-08-15 wage notice**. All three are now in
[mcog-l12-mla-2025-2028/](mcog-l12-mla-2025-2028/INDEX.md) → *The scanned PDFs — OCR'd 2026-09-04*.

| File | Size |
| --- | ---: |
| `MCOG LABOR UNION L12/MCOG-O. E. Local 12 Truck Crane Master Labor Agreement 2025-2028.pdf` | 3.4 MB |
| `MCOG LABOR UNION L12/07.01.2025 truck crane MLA (1).pdf` | 2.6 MB |
| `PAYROLL_APP_build/L12_Union-Labor-Agreements/OE-Local-12-MLA-25-28-Comp.pdf` | 2.4 MB |

~~If the full agreement text is ever needed, these need OCR~~ — done 2026-09-04; searchable text now in the vault.

### Full agreement text, superseded by the payroll extract

| File | Size | Note |
| --- | ---: | --- |
| `MCOG LABOR UNION L12/MCOG Union 12 Master Labor Agreement 2022-2025 and 2025-2028.pdf` | 15.9 MB | Text-extractable (1,753 lines). Contains **both** the expiring 2022–2025 and current 2025–2028 agreements — a live trap for citing a superseded rate. Not migrated because the payroll-relevant sections are already in `mcog-l12-mla-2025-2028/` |
| `PAYROLL_APP_build/L12_Union-Labor-Agreements/MCOG … 2025-2028 EXTRACTED.docx` | 1.1 MB | ~~Near-identical to the migrated payroll summary~~ **Wrong — corrected 2026-09-04.** It is the *whole* agreement as clean text (17 articles, Appendix A, camera MOU), not the payroll extract. Now [mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md](mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md). The same text is embedded as an OLE object in `PayrollAPP_LABOR-LOGIC-EXAMPLES.xlsx` |
| `MCOG LABOR UNION L12/2026 MCOG_updated_corrected_2026-06-22.pdf` | 248 KB | Rate sheet, 212 lines — **migrated 2026-09-04** to [mcog-l12-mla-2025-2028/wage-rate-sheet-2026-07-01.md](mcog-l12-mla-2025-2028/wage-rate-sheet-2026-07-01.md) |
| `MCOG LABOR UNION L12/2026 MCOG_incorrectOldVersion.pdf` | 366 KB | **Filename says it is wrong.** Do not cite — diffed 2026-09-04: differs from the corrected sheet only in the supplemental-dues column ($3.45 vs $1.75) |

### Legacy walkthrough documents, superseded by the knowledge pack

The knowledge pack's own source-of-truth order ranks these below its dated Markdown, and the
2026-03-08 copy is explicitly flagged as historical-only.

| File | Size |
| --- | ---: |
| `PAYROLL_APP_build/2026-05-29_TCG_PayrollAPP_Technical_Walkthrough.docx` | 72 KB |
| `PAYROLL_APP_build/2026-05-29_TCG_PayrollAPP_Management_Walkthrough.docx` | 28 KB |
| `PAYROLL_APP_build/2026-03-08_TCG_PayrollAPP_Technical_Walkthrough.docx` | 57 KB |

### Live payroll data and workbook machinery

Real employee payroll data and the macro-enabled workbooks that produce it. Not migrated as data. **The VBA in the three `.xlsm` files was read on 2026-09-04** → [adp-workbook-vba-macros.md](adp-workbook-vba-macros.md). They remain data and tooling, not specification, and copying employee payroll rows into a second system
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
