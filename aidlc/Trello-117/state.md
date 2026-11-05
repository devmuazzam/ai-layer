# State — Trello-117 Job Walk Web Tab

**Path:** A · **Branch(es):** `feat/trello-117-u1-job-walk-permissions` (local, uncommitted) · **Last updated:** 2026-11-03 by the AI

## Phases

- [S] Intent — no separate `intent.md`; product decisions finalized in conversation and recorded in `spec.md` §0 and §11b
- [x] Spec — `spec.md`: `job-walks` permission module, API guards (create on `mobile-quotations`), signature protection, audit logging on the quotation Activity Log, read-only tab, edit through Edit Quotation
- [ ] Sign-off — `spec.md` §14 not yet checked by a named developer
- [x] Units — `units.md` (U1 permissions + API guards, U2 audit logging + signature protection, U3 web Job Walk tab)
- [~] Build — U1, U2, U3 built in one working tree on `feat/trello-117-u1-job-walk-permissions`, uncommitted (2026-11-03). Gates run: API + web typecheck pass, changed-file lint 0 errors, web tests 967 pass / 1 pre-existing Windows-path failure, job-walk + quotation API specs 58/58, API build pass, API boot and real requests confirm Job Walk changes on the quotation Activity Log. Web UI not yet checked in a browser; developer testing.
- [ ] Analyse
- [ ] Merged
- [ ] Reflect
- [ ] Closed

## Product decisions (finalized 2026-11-02)

| # | Decision | Decided by |
| --- | --- | --- |
| D1 | Job Walk creation only via mobile by Salesperson — no web create | Developer |
| D2 | New `job-walks` permission module, independent from `quotations` | Developer |
| D3 | Salesperson eligible for edit access through the `job-walks` permission | Developer |
| D4 | Operator & Foreman signatures always read-only on web | Developer |
| D5 | Backend enforces all permissions at API level, not frontend-only | Developer |
| D6 | Audit trail tracks who changed what and when via `ActivityLog` | Developer |
| D7 | Existing tenants: `job-walks: view` for all roles; `edit` only for roles with `mobile-quotations`; admins adjust the rest from Settings | Developer |
| D8 | Superseded by D18: WON/LOST disables Edit Quotation, which is the only way in | Developer |
| D9 | `POST /job-walks` guarded by `mobile-quotations: edit` | Developer |
| D10 | Superseded by D17 | Developer |
| D11 | Superseded: the design is copied exactly, so "% of net capacity" is shown (Q1 closed) | Developer |
| D12 | U2 and U3 merged — 3 stacked PRs | Developer |
| D13 | Design HTML approved by Umar | Developer |
| D14 | Sales Manager seeded at `job-walks: view`; Field roles `none` (DS8) | Developer |
| D15 | Header scope: PATCH strips signature fields, signature PUT/DELETE 403 without mobile header; header from Trello-115 (DS9) | Developer |
| D16 | No Job Walk on the quote → the Job Walk tab is hidden, no empty-state message | Developer |
| D17 | Job Walk changes go to the quotation Activity Log; no separate Change history | Developer |
| D18 | Job Walk is edited only from Edit Quotation; step shown with `job-walks: edit`; no separate Edit button | Developer |
| D19 | Web tab copies the approved design exactly | Developer |

## Resume

U1, U2 and U3 are being built in one working tree on `feat/trello-117-u1-job-walk-permissions`, uncommitted; the developer commits, splits into stacked branches and opens the PRs. Before merge: sign off `spec.md` §14 and run the DS3 permission migration on a copy of staging data (G2).

**Merge order for U2 (DS9, decided 2026-11-02):** the signature header comes from Trello-115 — Trello-115 U1 + U2a must merge and its mobile build must be live before U2 reaches production, or mobile signature name/date edits are stripped.

**Not part of this ticket:** the untracked `apps/api/prisma/migrations/20261102143552_temp_employee/` is a local schema-drift migration (index renames, `updated_at DROP DEFAULT` on ~30 tables). Never commit it on a Trello-117 branch; raise the drift separately.
