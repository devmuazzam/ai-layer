---
title: TCG Payroll App (legacy) - AI Knowledge Pack
source: onedrive/OneDrive_1_8-11-2026/PAYROLL_APP_build/PayrollAPP_0.5/TCG_PayrollAPP_AI_Knowledge_Pack_2026-06-23.zip
migrated: 2026-08-13
updated: 2026-06-23
status: reference
conflicts_with: []
jira: []
topics: [payroll, payroll-app, current-state, architecture, sql-first]
entities: [payroll-group, pricing-engine, pay-component, payroll-exception]
---

# TCG Payroll App — current state (the system being replaced)

A knowledge pack TCG assembled on **2026-06-23** for exactly this purpose: handing a vendor
enough context to work on the payroll system. It documents the **legacy Payroll App**, not the
ERP module we are building.

> **Different stack from this repo.** The legacy Payroll App is **SQL Server + C# API +
> Next.js**, SQL-first, with the calculation living in stored procedures. The TCG platform is
> **NestJS + Prisma + PostgreSQL**. Read this pack for *what the rules do and which cases exist*,
> never for *how to build it here* — the architecture does not transfer, and `.ai/claude/contexts/api.md`
> governs how we build.

> **`status: reference`, not `unverified`.** These files describe a system that demonstrably
> ran; they are a faithful record of implemented behaviour as of 2026-06-23. That still does not
> make them a statement of what the ERP module *should* do — for target behaviour see
> [../erp-payroll-module-frd/INDEX.md](../erp-payroll-module-frd/INDEX.md).

## Files

| File | Answers |
| --- | --- |
| [01-current-state-walkthrough.md](01-current-state-walkthrough.md) | What exists today, end to end, and what the largest unfinished area is |
| [02-architecture-and-data-flow.md](02-architecture-and-data-flow.md) | How data moves: `TCG_RawFMS` → synonyms → base views → pricing → finalization → ledger → api/rpt → C# → Next.js |
| [03-payroll-rule-catalog.md](03-payroll-rule-catalog.md) | **Every payroll rule family, with its current implementation status.** The single most useful file here |
| [04-payroll-group-and-rule-applicability.md](04-payroll-group-and-rule-applicability.md) | Which rules apply to which of the five Payroll Groups — including the many still marked "Confirm" |
| [05-api-and-ui-contract.md](05-api-and-ui-contract.md) | The web routes, the SQL surfaces behind each UI card, and known UI wording defects |
| [06-sql-object-catalog.md](06-sql-object-catalog.md) | The high-value SQL objects by role: sources, base views, procedures, tables, config, api/rpt |
| [07-testing-and-validation.md](07-testing-and-validation.md) | Smoke checks, the existing `test.*` regression objects, and what tests are still missing |
| [08-known-issues-and-next-decisions.md](08-known-issues-and-next-decisions.md) | **What is not finished and what decisions are still needed.** Read before trusting anything else here |
| [09-glossary.md](09-glossary.md) | Project terminology — the only glossary for payroll domain terms |

## The source-of-truth order the pack itself declares

When sources conflict, the pack ranks them:

1. Current production SQL source code and database object definitions.
2. Current C# API and Next.js Web source code.
3. This knowledge pack's dated Markdown files.
4. The 2026-05-29 current-state walkthrough `.docx`.
5. Most recent handoff notes and validated screenshots/results.
6. The older March walkthrough and early design notes.

**Note what that ordering means for us:** items 1 and 2 are the legacy codebase, which is not in
this repo. Nobody here can reach the top two ranks of the pack's own hierarchy. So a claim
sourced only from these files is, at best, rank 3.

## Baseline Local 12 values as implemented

Quick reference — full detail and caveats in [03-payroll-rule-catalog.md](03-payroll-rule-catalog.md):

| Setting | Value |
| --- | --- |
| Standard day window | 06:00–17:00 |
| Straight-time daily threshold | 8.0 hours |
| Double-time daily threshold | after 12.0 hours |
| OT / DT multiplier | 1.50 / 2.00 |
| Saturday / Sunday multiplier | 1.50 / 2.00 |
| Holiday multiplier | generally 3.00 |
| Shift 2 | 7.0 worked / 8.0 paid, +$3.00/hour |
| Shift 3 | 6.5 worked / 8.0 paid, +$4.00/hour |
| Pricing granularity | 30-minute slices, one controlling multiplier per slice (no pyramiding) |
| Special Saturday | first Saturday in June and December, double-time behaviour |

## Not migrated from the pack

`01_AI_INSTRUCTIONS_FOR_VENDOR.md`, `03_LOCAL_SETUP_README.md`,
`for_vendor_ai/PROJECT_INSTRUCTIONS_PASTE_INTO_AI_SYSTEM.md`, `SECURITY_REDACTION_CHECKLIST.md`,
`manifest.json`, the three `sql_templates/*.sql`, and the config examples. These are vendor-
onboarding and Windows/SQL-Server local-restore instructions for the legacy stack — no bearing on
what the ERP module must do. See [../source-manifest.md](../source-manifest.md).
