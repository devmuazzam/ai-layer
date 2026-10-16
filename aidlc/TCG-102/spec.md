# Spec — TCG-102 Quotation print: Billing Type hidden when blank

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `TCG-102` — "Quotation print: review Billing Type on the customer quote" |
| Elaborated on | `2026-10-15`, in a working session with devmohsinakram |
| Product source | `.ai/vault/uat/register-2026-09-18.md:289` — UAT 3, "Review the Billing Type field on the print view" (NOT DONE, no decision recorded) |
| Code read at | `fixes/TCG-15-OCT` @ `3dd85135b` |
| Built in | `craneguys-platform` `6752e3c27` — `fix(quotations): hide blank Billing Type on quote print and PDF (TCG-102)` |

No vault decision covered this. `decisions/2026-09-11-billing-code-type-master-dropped.md`
concerns the billing-code-type master table, not the quotation's `billingType` field.

## 1. Requirements

| Req | Requirement | Source |
| --- | --- | --- |
| REQ-01 | When the quotation's Billing Type is empty or whitespace, the **Billing Type** row is omitted from Project Details in the web print view (`print-quotation.model.ts` → `buildProjectDetails`) | §12 Q1; ticket "Done when" |
| REQ-02 | The same rule applies to the Quotation PDF (`quotation-pdf.service.ts` → `drawProjectDetails`) | ticket |
| REQ-03 | When Billing Type has a value, it prints exactly as before (trimmed), in the same first position | §12 Q1 |
| REQ-04 | The quotation form, the stored value, and every non-print consumer (project/job/field-ticket copy, list filter) are unchanged | §12 Q1 |

## 2. Verification

- ESLint clean on both files; `apps/web` typecheck clean; `apps/api` service file has no type errors.
- `quotation-pdf.service.spec.ts`: 6 / 7 pass. The 7th ("a wrapped row stays on one page") times
  out at 60 s with and without the change — pre-existing, not caused by TCG-102.
- No consumer depends on the row count or Billing Type's position; no unit or E2E test asserts
  the printed row (`qa-automation` checks only the persisted value).
- **Not done:** no visual check of a rendered print view or PDF.

## 12. Open questions

- **Q1 — Remove from the customer quote, or keep it?** **Keep, hidden when blank** — decided
  2026-10-15 by devmohsinakram (developer on the ticket), in session, from three options offered
  (remove / hide when blank / keep + required + fixed values). A developer call, not a TCG
  product-owner sign-off; TCG may overrule it. **Status:** resolved for build.
- **Q2 — Required, and limited to fixed values (Rental / Parts)?** Not done. The ticket's
  "keep" option included both; they were deliberately left out, so the field can still be blank
  and can still hold values the dropdown does not offer. Doing it needs a plan for existing rows.
  **Status:** open.
- **Q3 — Start and End date no longer share a row when Billing Type is blank.** Both outputs lay
  Project Details out two per row, so omitting the first field shifts the rest by one slot.
  Cosmetic; raised to the developer, not yet decided. **Status:** open.

## 13. Deliberately out of scope

- **The quotation form** — Billing Type stays optional with its current dropdown.
- **Mobile** — no quotation print view there.
- **Other places Billing Type is shown** (DAS job overview, send-ticket modal, job detail header)
  — internal screens, not the customer quote.
