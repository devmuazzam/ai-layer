# Spec — TCG-85 Quotation print: empty Other hidden, Terms on the print view

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `TCG-85` — "Quotation print: remove "Other" section and add Terms & Conditions" |
| Elaborated on | `2026-10-15`, in a working session with devmohsinakram |
| Product source | `.ai/vault/uat/register-2026-09-18.md:260` — UAT 4 #14 (NOT DONE) |
| Code read at | `fixes/TCG-15-OCT` @ `6752e3c27` |
| Built in | `craneguys-platform`, four commits (each under 400 lines): `48ee153e1` (a — empty Other fields and section left off), `d39b77cd8` (b — Terms text added to `@tcg/shared`), `5eb6edd72` (c — API file re-exports it), `8e0637b79` (d — Terms on the print view) |

## 1. Requirements

| Req | Requirement | Source |
| --- | --- | --- |
| REQ-01 | When a quotation has no Other Information to show, the browser print view omits the section entirely — no heading, no "No additional information." | ticket "Fix now" |
| REQ-02 | When it has data, Other Information prints as before (real crane/equipment data, not removed) | ticket; §12 Q3 |
| REQ-02a | A field with no value is left off; a section whose fields are all empty is dropped; with nothing left, REQ-01 applies. A yes/no field answered No still prints. Section headings (the sub-category's section name, e.g. "Additional Information") are unchanged | §12 Q5 |
| REQ-03 | The browser print view shows Terms and Conditions in the PDF's order: Payment Terms / Validity (only when set), rate card, long-boom table, standard terms 1–26, Exhibit TCG | §12 Q4 |
| REQ-04 | The Terms text has one source: `packages/shared/src/constants/quotation-terms.ts`, exported from `@tcg/shared`. `apps/api/.../quotation-pdf-terms.ts` re-exports it. Not copied | ticket developer note |
| REQ-05 | The Quotation PDF is unchanged — the service file is not edited, output identical | §12 Q3 |
| REQ-06 | The print Terms block carries `data-testid="quotations-print-terms"` | `contexts/web.md` → Test IDs |

## 2. Verification

- ESLint and typecheck clean on web, API and shared.
- `quotation-pdf.service.spec.ts`: 7 / 7 pass (with `--testTimeout=180000`; at the default 60 s the
  25-render "wrapped row" test times out with or without this change).
- No E2E test references the Other Information heading, its empty-state line, or the new Terms block.
- **Not done:** no visual check of the rendered print view.

## 12. Open questions

- **Q1 — Remove "Other" from the PDF too, or only the print view?** Ticket: Joe Schacatano / Ryan
  Adams (Umair Khan comparing with FCC). Not answered. The PDF was deliberately not touched.
  **Status:** open.
- **Q2 — Who owns and approves the Terms and Conditions text?** Ticket: Joe Schacatano / Ryan Adams.
  Not answered. The text (OM-35140, one customer's quote) is unapproved and its rates do not match
  what TCG charges. Moving it into `@tcg/shared` changed no word of it. **Status:** open.
- **Q3 — What to do with "Other" now?** Decided 2026-10-15 by devmohsinakram (developer): hide it
  when empty, keep showing it when it has data; print view only, PDF left as is. **Status:**
  resolved for build.
- **Q4 — Add Terms to the print view before Q2 is answered?** The ticket says the decisions should
  be written down "before any Terms change". Decided 2026-10-15 by devmohsinakram (developer):
  add them now, from the PDF's own source, so the print view matches what the customer receives.
  A developer call, not a TCG sign-off — the print view now repeats the unapproved text the PDF
  already carries. **Status:** resolved for build; open to TCG overruling.

- **Q5 — Configured but unfilled Additional Info fields?** They printed as dashes. Decided
  2026-10-15 by devmohsinakram (developer): leave empty fields off, drop all-empty sections, and
  keep section headings as they are (not replaced by the resource name). **Status:** resolved
  for build.

## 13. Deliberately out of scope

- **The Quotation PDF** — its Other Information and Terms are unchanged.
- **The Terms wording and rates** — waits on Q2.
- **TCG-28, TCG-37, TCG-81** — the ticket suggests doing them together; not done here.
