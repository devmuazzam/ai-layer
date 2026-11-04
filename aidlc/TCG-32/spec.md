# Spec — TCG-32 Pre-Checklist row test IDs (colours blocked)

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `TCG-32` — "DAS Pre-Checklist: permit and plan row colours should follow status" |
| Elaborated on | `2026-10-16`, in a working session with devmohsinakram |
| Product source | `.ai/vault/uat/register-2026-09-18.md:206` — UAT 2 (NOT DONE) |
| Code read at | `fixes/TCG-15-OCT` @ `bab2ec11b` (local working branch, not pushed) |
| Built in | `craneguys-platform` `61bb545ac` (1 web file, +2) |

## 1. Requirements

| Req | Requirement | Source |
| --- | --- | --- |
| REQ-01 | Each DAS Pre-Checklist row carries `data-testid="das-pre-checklist-row-<item id>"` (ids: `permits`, `plan`, `po`, `assets`, `resources`, …), in `checklist-badge.tsx` — used by the job and vendor-slot pre-checklists | ticket developer note |
| REQ-02 | No colour, DAS Legend or shared status badge change | ticket; §12 Q1 |

## 2. Verification

- `apps/web` ESLint and typecheck clean. No E2E test referenced these rows before.

## 12. Open questions

- **Q1 — Row colours by status.** Lisette Anzaldo (with Liz Lopez): bring per-status colours back, or
  distinguish Open / Application Submitted / Cancelled inside the amber? **Status:** open.
  Findings for whoever builds it:
  - Row colours are local to `checklist-badge.tsx` (green when done, orange otherwise); the DAS Legend
    has its own row-state list (`legend-artifact-status-sections.tsx`). Both must change together —
    the 2026-09-12 attempt was reverted for mismatching the Legend.
  - The same component renders the vendor-slot checklist and PO / document rows — scope any change
    to permit and plan rows.
  - The job-card Pre-Checklist trigger goes green from the same done state (`b3213e95e`, `750facb08`)
    — keep it consistent.
  - A Cancelled colour implies a rule (does a cancelled permit still count as required-and-missing?).
  - `ArtifactStatusPill` (5 files) and `StatusBadge` (20 files) are shared — do not change them.
  - A Draft colour cannot be built: these rows never carry Draft.

## 13. Deliberately out of scope

- All colour changes; the DAS Legend; shared badges.
