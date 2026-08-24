---
id: PAY-067
title: PAY-067 — ADP export
section: G-audit-review-export
status: conflicted
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-067 — ADP export

**Rule:** Validate mappings and generate export-ready records.

**Applies to:** Approved employees/pay period. **Trigger:** Export is requested.
**Requires:** ADP ID; earning codes; hours; amounts.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-067` — baseline: *New ERP requirement*
- **FRD** (target design): [10-approval-close-export-and-adjustments.md](../erp-payroll-module-frd/10-approval-close-export-and-adjustments.md) `PR-055` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: no direct counterpart (new in the ERP target)

## Open

- **Blocking (matrix):** Confirm ADP file specification
- **Conflict:** Assumes API submission; `../adp-read-write-boundary-2026-08-18.md` says payroll-output write is **Marketplace-partner-gated** (`pay-data-input.modify` path). Confluence “Payroll management” page (US/PAY-WP ids) staged in `../../sync/.conflict/2026-08-24-bootstrap/payroll-management.md`.
- **Product identity (team exchange, via Patrick):** *"We are with workforce but upgrading to next level soon."* First half ✅ agrees with the gap resolved 2026-08-13 (classic WFN, confirmed from a live practitioner session). Second half is **new and material**: every ADP reference doc (capabilities, read-write boundary, live api-responses, event notifications) was validated against **classic WFN** — a WFN **Next Generation** migration can change the API Central surface, entitlements and endpoints. Get the upgrade date and scope in writing; re-validate the ADP research on upgrade.
- **Interim submission path (same exchange):** manual **CSV upload in the ADP browser UI** while the API path is decided — a refinement of today's spreadsheet family, not the API. The Excel-or-API gap remains open; this is the bridge.
- **Bridge-workbook status (client message + 2026-08-19 zip inspection):** the `__NEW_PAYROLL_v1.1` workbooks (master + Corrina's partial-sample test week) are **unchanged since migration** — `adp-workbook-column-rules.md` remains current. Client states the **Power Query backend is not fully built** (new status fact) and that an **ADP-rep meeting** is planned because "we will need to create a few more fields in ADP to allow importing" — i.e. the earning-code-setup gap, now with an emerging owner (Brian + ADP rep). Checkpoint for reconciliation: ADP held **52 live Hours & Earnings codes** at 2026-08-18 (`adp-api-responses/pay-data-input-meta.md`); diff the crosswalk's required codes against those 52 to know exactly which "few more fields" are still missing.
- **Import scope confirmed (client big summary), matching the crosswalk exactly:** hours per bucket (RT/OT/DT/TT + the special-holiday double bucket), separate temporary-rate rows (hours + rate), subsistence dollars (no hours), non-union sick hours — "and that is currently it." **Access status:** Brian has production-account access ("actual"), the **dev/sandbox account is not created yet** (matches the open test-company request, 2026-08-17); Wes is arranging CodingCops access via Melissa + Corrina; **Corrina is scheduling the ADP-rep meeting for next week** — ask to join or get the recording.
- **Company code changed: `631` → `4RZ`** (client, ~2026-07-28; dashboard shows "4RZ - THE CRANE GUYS LLC"). Export generation must target 4RZ; **audit every artifact for stale 631 references** (v3.7/v3.8 workbook Power Query, crosswalk rows, the EPI export naming). The old sample `EPI63100.CSV` vs new `EPI4RZ32.csv` shows the code is baked into filenames.
- **The "few more fields" were created:** Hours & Earnings codes updated/added on the Validation Table in July — and our **52-code pull (2026-08-18) post-dates the update**, so the crosswalk-vs-52 reconciliation runs against current state. ADP-rep meetings with Corrina happened several times mid-July; a recurring Thursday slot existed (July 30, 3 PM PST) with an open invitation for CodingCops — ask for the recording/notes and the exact added-code list.
- **The July code additions, enumerated and vault-corroborated:** Brian's list (shift-diff 2nd, shift-diff 3rd, long-boom holiday triple, lattice oiler, lattice operator) = exactly the code families the vault flagged as **absent from the June 4 CSV and present in the 2026-08-18 pull** (`S2*/S3*`, `LBT`, `LP*`, `LO*` — pay-data-input-meta.md documents the delta). Residual unknowns: which unused code was *removed*, and which holiday code was *changed* "to add to total hours".
- **Backend-calculation opacity (ADP rep, on record):** the calculations behind several codes are **not accessible in any interface** — "hidden in the backend; check with ADP to verify if/when needed." Design consequence: the ERP computes every amount itself and treats ADP codes as **labeled buckets only**; any behavior verification is an ADP-support engagement, never a UI check. (Also: two nav paths reach Hours & Earnings Codes; "Show more" hides rows; the Download is incomplete — the live API pull is the better artifact and ours post-dates the changes.)
- **Live trap documented in the pull:** `LPR` = "LATT OP REG" as an *earning* but "Life Post" as a *deduction* — sending it in `deductionInputs` deducts life insurance instead of paying lattice premium. Export code must be array-aware, not code-aware.
- **The interim path has its generator (message 21):** the v3.x "PAYROLL for ADP" workbook family was updated for the new codes and **auto-generates the ADP import file** — the bridge for the manual-CSV-upload interim (message 5) is this workbook. Live sample `EPI4RZ32.csv` verified: `4RZ` throughout, Temp-Rate/Hours-4 row architecture in production, new codes correctly absent (event-driven). Stale-631 residual narrows to the v3.7-Mac internals and any crosswalk rows.
