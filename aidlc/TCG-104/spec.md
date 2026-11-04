# Spec — TCG-104 Warn before sending an empty quote

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `TCG-104` — "Send Quotation: warn when the quote has no items (source unknown)" |
| Elaborated on | `2026-10-16`, in a working session with devmohsinakram |
| Product source | None — the ticket says no UAT session contains the request |
| Code read at | `fixes/TCG-15-OCT` @ `2ebc1cc40` |
| Built in | `craneguys-platform` `101de0ce9` (3 web files, +44 / −1) |

## 1. Requirements

| Req | Requirement | Source |
| --- | --- | --- |
| REQ-01 | On the quotation detail page, clicking **Send Quote to Customer** (the same handler serves Send Updated) on a quote with **no resources and no tools** opens "Send an empty quote?" — "This quote has no equipment, services or tools. Send anyway?" — with **Cancel** and **Send anyway** | ticket |
| REQ-02 | **Send anyway** continues exactly as before (approval check, then the DocuSign / email send modal); **Cancel** closes and does nothing | ticket ("warn only") |
| REQ-03 | A quote with tools only is not empty; any resource or tool skips the warning | ticket |
| REQ-04 | Reuses `ConfirmDeleteModal` (primary button; existing `confirm-modal*` test IDs). State lives in `use-empty-quote-send-warning.ts`; the empty flag is passed from `detail-left-panel.tsx` | — |

## 2. Verification

- `apps/web` ESLint and typecheck clean. Send-modal helper tests pass.
- `browser-autofill-coverage.test.mjs` fails 2 subtests in files this branch never touched
  (`payroll-corrections/.../correction-dialog-sidebar.tsx`, the login page) — pre-existing.
- No API, database or test change. No visual check yet.

## 12. Open questions

- **Q1 — Is the warning wanted at all?** The ticket's source is unknown and it is worded "if
  confirmed". Decided 2026-10-16 by devmohsinakram (developer): build it — it warns only and never
  blocks. **Status:** resolved for build; open to TCG removing it.
- **Q2 — Resend.** The separate **Resend** action (`handleResend`, re-sending an existing envelope) does
  not show the warning; only opening the send flow does. **Status:** open, if anyone wants it there too.

## 13. Deliberately out of scope

- The send modal, approval flow, PDF wording, API.
