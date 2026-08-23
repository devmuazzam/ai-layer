---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [field-ops/frd-new-format-draft/INDEX.md, field-ops/atom-mobile-app-user-stories/INDEX.md]
jira: []
tags: [module/field-ops, module/payroll, kind/frd, requirements]
entities: [labor-record, union-code]
part_of: field-ops/field-ops-frd/INDEX.md
restored: 2026-08-13
---
## 10. BRS References

The following topics require detailed specification within the Field Operations BRS:

> **Restored 2026-08-13.** This table was omitted by the 2026-08-10 migration because four of
> its rows linked to payroll, ADP and labor-union documents on SharePoint, which were then out
> of scope for this vault. **Those four documents are now in the vault** — they arrived in the
> OneDrive drop migrated on 2026-08-13, with filenames matching these links exactly. The
> exclusion reason no longer holds, so the table is restored with the vault location added.
>
> SharePoint URLs are reproduced as bare paths; the folder is
> `TCGCodingCopsERPTeam / Shared Documents / Project Repository /
> CC_FRD-Field-Ops-Mobile-App_2026-06-11 / BRS References/`.

| Topic | Status | Client document | Now in the vault |
| --- | --- | --- | --- |
| Lunch threshold values | Saved in Project Repository → `CC_FRD-Field-Ops-Mobile-App_2026-06-11` | `Worked Through Lunch Charts- Payroll_Billing.pdf` | ✅ [payroll/wtl-charts.md](../../payroll/wtl-charts.md) |
| Work Through Lunch decision matrix | **Pending** | — | ✗ still pending upstream |
| Union-specific lunch requirements | **Pending** | — | Partially — [payroll/mcog-l12-mla-2025-2028/01](../../payroll/mcog-l12-mla-2025-2028/01-article-iii-working-rules.md) *Meal Periods* is the contract text, but it is not the same thing as a stated requirement |
| Payroll processing rules & Labor calculation logic | Saved in Project Repository → `CC_FRD-Field-Ops-Mobile-App_2026-06-11` | `PayrollAPP_LABOR-LOGIC-EXAMPLES.xlsx` | ✅ [payroll/rule-examples-catalog.md](../../payroll/rule-examples-catalog.md) (Examples_Catalog sheet) |
| ADP mappings | Saved in Project Repository → `CC_FRD-Field-Ops-Mobile-App_2026-06-11` | `wfn_importing_paydata.pdf` | ⚠ In the OneDrive drop but **not migrated** — ADP vendor documentation. See [payroll/source-manifest.md](../../payroll/source-manifest.md). The TCG-side mapping is [payroll/adp-bucket-crosswalk.md](../../payroll/adp-bucket-crosswalk.md) |
| L12 Labor Union Master Agreement | Saved in Project Repository → `CC_FRD-Field-Ops-Mobile-App_2026-06-11` | `OE-Local-12-MLA-25-28-Comp.pdf` | ⚠ In the OneDrive drop but **unreadable** — a scan with no text layer. The readable extract is [payroll/mcog-l12-mla-2025-2028/](../../payroll/mcog-l12-mla-2025-2028/INDEX.md) |
| Downtime implications | **Pending** | — | ✗ |
| Escalation routing matrices | **Pending** | — | ✗ |
| Notification timing rules | **Pending** | — | ✗ |
| Certification notification thresholds | **Pending** | — | ✗ |
| Inspection retention requirements | **Pending** | — | ✗ |

**What this table establishes.** The field-ops FRD did not omit payroll by accident — it
explicitly deferred four topics to documents held outside Confluence. Those documents are the
payroll set. This is the formal link between the two areas, and it means
[payroll/](../../payroll/INDEX.md) is a **dependency of this FRD**, not a neighbouring module.

Six of the eleven rows are still **Pending** upstream and nothing in the vault answers them.

---

