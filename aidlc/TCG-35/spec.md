# Spec — TCG-35 Row amount tooltip: one "After adjustments" total, no "Final Amount"

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `TCG-35` — "Quotation Resources: "Final Amount" shows different numbers in different places" |
| Elaborated on | `2026-10-16`, in a working session with devmohsinakram |
| Product source | `.ai/vault/uat/register-2026-09-18.md:211` — UAT 1 (NOT DONE) |
| Decisions relied on | `decisions/2026-09-02-one-surcharge-per-quote.md` (verified, Melissa McNutt); `decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md` (reference, Fouzan Shakil) |
| Code read at | `fixes/TCG-15-OCT` @ `61bb545ac` |
| Built in | `craneguys-platform` `2ebc1cc40` (1 web file, +6 / −7) |

## 1. Requirements

| Req | Requirement | Source |
| --- | --- | --- |
| REQ-01 | The row amount tooltip (`resource-row.amount-cell.tsx`, shown only when a row has a discount or price hike) lists Base Amount, the Discount / Price Hike lines, and one **"After adjustments"** total. No number repeats | ticket "Done when"; §12 Q1 |
| REQ-02 | No screen labels anything "Final Amount" (the tooltip was the only place) | ticket "Done when"; §12 Q1 |
| REQ-03 | No row shows surcharge money; the surcharge stays a footer row | §12 Q2 |
| REQ-04 | Amount column, footer rows, totals, saved `finalAmount`, print and PDF unchanged | ticket "Done when" |

## 2. Verification

- "Final Amount" was searched across the web app, the API, the print view and the PDF: the tooltip was
  its only label. The saved `finalAmount` (`@tcg/shared` `quotation-pricing.ts:68`) includes surcharge
  and is used only behind the scenes.
- `apps/web` ESLint and typecheck clean. No E2E test reads either label. No visual check yet.
- **"Final Amount shows the same number on every screen" is met by removal** — no conflicting label
  remains — not by displaying one number everywhere. Showing the saved, surcharge-inclusive amount on a
  row was rejected because it contradicts both decisions above.

## 12. Open questions

- **Q1 — Rename the tooltip row, or match the saved Final Amount?** (ticket: Fouzan Shakil). Decided
  2026-10-16 by devmohsinakram (developer): rename to "After adjustments" and drop the duplicate row —
  consistent with Fouzan's 2026-09-11 footer-rows decision (row amounts are before every adjustment).
  **Status:** resolved for build; open to Fouzan overruling.
- **Q2 — Should a row show surcharge money at all?** (ticket: Melissa McNutt). Decided by devmohsinakram:
  no — consistent with Melissa's verified 2026-09-02 decision (one surcharge, one named row).
  **Status:** resolved for build; open to Melissa overruling.
- **Q3 — QA test-case docs out of date.** `qa-automation/docs/testinyCases/quotations.md` (the
  amount-cell tooltip row, ~line 178: still lists a Surcharge line and "Final Amount $969.00") and its
  `csv/quotations.csv` copy. The ticket asks to fix them in the same change; the developer chose not to
  touch `qa-automation` for now. **Status:** open.
- **Note:** an older entry in `vault/quotations/gaps.md` (~line 866) says the per-row surcharge "stays"
  in the Amount tooltip; the 2026-09-11 footer-rows decision superseded it and the code no longer shows
  it. That historical text was not edited.

## 13. Deliberately out of scope

- Amount column, footer rows, totals, saved values, print, PDF, shared pricing code, QA docs.
