# Spec — TCG-41 Asset Bar Code hidden on Create, Edit and detail

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `TCG-41` — "Assets: decide what to do with the Bar Code field" |
| Elaborated on | `2026-10-16`, in a working session with devmohsinakram |
| Product source | `.ai/vault/uat/register-2026-09-18.md:218` (UAT 1, remove from Create) and `:327` (UAT 6, review) — both NOT DONE |
| Code read at | `fixes/TCG-15-OCT` @ `1324896e0` |
| Built in | `craneguys-platform` `2fed5e65b` (2 web files, +4 / −9) |

## 1. Requirements

| Req | Requirement | Source |
| --- | --- | --- |
| REQ-01 | The asset Bar Code input is not shown on Create or Edit (one shared form, `registration-section.tsx`) | §12 Q5 |
| REQ-02 | The Bar Code row is not shown on the asset detail page (`asset-detail-tabs.tsx`) — no barcode shown that cannot be set | ticket "Done when"; §12 Q5 |
| REQ-03 | Saved values are kept: the edit form still loads and re-sends `barCode` unchanged; API, DTO, database and FCC seeder untouched | §12 Q5 |
| REQ-04 | The Tools barcode and its QR code page are not touched | ticket note |

## 2. Verification

- `apps/web` ESLint and typecheck clean.
- **Known failure:** `qa-automation/e2e/specs/asset-management/assets/1-lifecycle.spec.ts` still fills
  "Bar Code" by label on Create and Edit and asserts the stored value; it will fail at that step until
  updated. Left as is by the developer's call (§12 Q6). The suite is not run by any gate.
- No visual check yet.

## 12. Open questions

- **Q1 — What is an asset barcode used for?** TCG to answer (named person). **Status:** open.
- **Q2 — Remove from Create only, or also from Edit and detail?** TCG. **Status:** open.
- **Q3 — Hide the field, or delete the saved values too?** TCG. **Status:** open.
- **Q4 — What happens to barcodes from the old system?** TCG. **Status:** open.
- **Q5 — Build before Q1–Q4 are answered?** The ticket says "do not build until this is decided".
  Decided 2026-10-16 by devmohsinakram (developer): build the reversible option — hide on Create, Edit
  and detail, keep every saved value, no API or database change. Restoring the field is a few lines in
  the two web files. **Status:** resolved for build; open to TCG overruling.
- **Q6 — Update the automated tests in the same change, as the ticket asks?** Decided by
  devmohsinakram: not now — tests are not to be touched without approval; to be reviewed at the end of
  the branch. **Status:** open.

## 13. Deliberately out of scope

- API, DTO, database column, FCC seeder — `barCode` still accepted and stored.
- The Tools barcode and QR code page.
