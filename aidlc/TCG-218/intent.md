# Intent — TCG-218

> Ticket capture from Linear (`the-crane-guys` workspace, project *TCG Platform*). Not a spec,
> not a design. Nothing here is sourced from the vault yet — that happens in `spec.md`.
>
> **Fresh start.** Two earlier attempts at this ticket were discarded unmerged on 2026-10-14
> at the ticket owner's request (branch `feat/association-document-visibility`; the
> 2026-10-09 unit branches with PRs #753 and #754). No code, spec or unit from either is
> carried into this run. Product decisions recorded in the vault stay valid and are the
> elaborator's to source, not this file's.

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `TCG-218` (Linear), with `TCG-202` folded in — see §4 |
| Title | Quotation: per-association quote visibility and Quotation Type (Hourly / Hourly w/ Mob) |
| Type | Feature (Linear label) |
| Status | In Progress |
| Epic | `NOT ON TICKET` (project *TCG Platform*, no parent issue) |
| Sprint | Cycle 2 (2026-10-04 → 2026-10-18) |
| Reporter | syed haris |
| Assignee | syed haris |
| Captured on | `2026-10-14` |
| Captured by | Claude Code session for Syed Haris (ticket owner) |

Ticket state moves. Everything below is a snapshot of the tickets on 2026-10-14; the TCG-218
description was last edited the same day (Status section and the Price Adjustment line).

## 2. Business intent

- Intent, quoted from TCG-218 *Why*: "Today a quotation lists every associated field asset
  of a crane. Joe Schacatano (2026-10-01 meeting) said that is wrong. Only what TCG bills
  belongs on the quote: Operator Load is one billing code, and its tractor and operator stay
  on the job, not the quote. On an "Hourly w/ Mob" job, the customer sees only the
  Mobilization and Demobilization totals, plus the main items."
- Who benefits (role): sales / estimating (builds the quote); the customer (receives it);
  dispatch (works the job the quote becomes) — the dispatch part comes from the ticket
  owner's scope addition in §4, not from the TCG-218 text.
- What is worse today without it: quotations list dispatch-only resources as priced lines;
  there is no Hourly vs Hourly w/ Mob choice; the browser print shows the lines inside
  Mobilization/Demobilization to the customer (TCG-202).

## 3. Definition of done, as the ticket states it

TCG-218 has no section titled acceptance criteria. Its *Scope* section, verbatim:

```
Sub-category → Associated Field Assets

* Per association: Field Setting (unchanged), Hourly · Quote/Invoice: Show,
  Mob/Demob · Quote/Invoice: Show, then Main item / Sub item while shown.
* An employee type starts hidden on both quote types.
* "Also brings along" rows (an association's own associations): the same Hourly and
  Mob/Demob settings, stored per parent, hidden by default, and disabled while the parent
  is hidden on that quote type.

Quotation → Resources

* Quotation Type chip beside Price List: Hourly / Hourly w/ Mob, saved on the quotation.
* Hourly: each item with its hourly-shown associations, plus any sub-items its parent ticked.
* Hourly w/ Mob: the item alone, its Main items as their own lines, then Mobilization and
  Demobilization (its Sub items) at the bottom.
  * The group quantity is the number of visits: rate = sum of its ticked lines,
    amount = qty × rate.
  * Demob lines start at 0.
  * Lines inside a group take 0 and two-decimal quantities.
  * A line added to Mob is mirrored into Demob at 0.
  * Only the Price Adjustment custom type (FCC custom type PA) inside a group is priced
    by hand. Any other custom line in a group needs a billing code (Syed Haris, ticket
    owner, 2026-10-09).

Customer documents: the server PDF and the browser print show only the Mobilization and
Demobilization lines, never the lines inside them (see TCG-202).
```

TCG-202 *Expected*, verbatim:

```
* A group parent prints as one line (its rolled-up amount); its children are not printed.
* The discount / price-hike / surcharge foot lines still include group children's amounts
  (the server PDF's getAdjustmentResources does this already).
```

TCG-218 *Status*, verbatim: "The fresh run also covers TCG-202 (customer documents) and the
quote-to-job dispatch rule for lines inside Mobilization/Demobilization. Product decisions to
build from: `.ai/vault/quotations/mob-demob-current-rules.md`."

- Acceptance criteria present on the ticket: no (a *Scope* list, not acceptance criteria)
- `OPEN — TCG-218 has no acceptance criteria; per domain/jira-sop.md it does not meet Definition of Ready. The elaborator should derive testable criteria from the Scope list and the vault, and mark each one's source.`

## 4. In scope

From TCG-218 *Scope*:

- [ ] Per association on a sub-category: Hourly · Quote/Invoice: Show; Mob/Demob · Quote/Invoice: Show; Main item / Sub item while shown. Field Setting unchanged.
- [ ] An employee-type association starts hidden on both quote types.
- [ ] "Also brings along" rows: the same Hourly and Mob/Demob settings, stored per parent, hidden by default, disabled while the parent is hidden on that quote type.
- [ ] Quotation Type chip beside Price List (Hourly / Hourly w/ Mob), saved on the quotation.
- [ ] Hourly layout: each item with its hourly-shown associations, plus any sub-items its parent ticked.
- [ ] Hourly w/ Mob layout: the item alone, its Main items as their own lines, then Mobilization and Demobilization (its Sub items) at the bottom.
- [ ] Group quantity is the number of visits: rate = sum of ticked lines, amount = qty × rate.
- [ ] Demob lines start at 0; lines in a group take 0 and two-decimal quantities.
- [ ] A line added to Mob is mirrored into Demob at 0.
- [ ] Only the Price Adjustment custom type inside a group is priced by hand.

From TCG-202 (folded in):

- [ ] Customer documents (server PDF and browser print) show the Mobilization and Demobilization lines only, never the lines inside them; foot lines still include the children's amounts.

Ticket owner's scope addition (TCG-218 *Status*; Syed Haris, 2026-10-09: *"not in the
backlog, fix in this ticket"*):

- [ ] Quote → job conversion: lines inside Mobilization/Demobilization do not become duplicate dispatch slots on the job; equipment quoted only inside the groups is dispatched on its visit days. Rule recorded in `vault/decisions/2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md`.

## 5. Out of scope

From TCG-218 *Out of scope*, verbatim:

- [ ] "Main item → field-app "stays on the job" behaviour."
- [ ] "A per-machine mob/demob template with minimum quantities."
- [ ] "An alert when the schedule passes the quoted hours."

Adjacent work held in other tickets (not on the TCG-218 text; listed so a reader does not
assume them):

- [ ] One Mob/Demob pair per main crane, crane-named; Field Assets Configuration rename and activity log — `TCG-220`.
- [ ] Mobile quote builder parity — `TCG-219`.
- [ ] Who may edit the settings / switch Quotation Type — `TCG-227` (open).
- [ ] Job timeline strip — `TCG-226`; multi-crane invoicing — `TCG-225`; holdover on the quote — `TCG-221`; one-day job becoming a holdover — `TCG-222`; change orders — `TCG-224`.
- [ ] Invoices. `NOT ON TICKET` whether TCG-218's "Quote/Invoice" settings drive invoices now or later.

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS — presentation / usecase / service) | yes | association settings, quotation type, group maths, PDF, quote → job conversion |
| `apps/api/prisma` (schema + migration) | ? | new per-association settings and quotation type imply schema; the elaborator decides with the developer |
| `apps/web` (Next.js) | yes | sub-category association settings, Resources tab layouts, browser print |
| `apps/mobile` (Expo Router) | ? | `NOT ON TICKET`; mobile quote builder parity is TCG-219, but shared changes may reach it |
| `packages/shared` (types shared across apps) | ? | `NOT ON TICKET` |

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `Quotation` | `quoteNo` / `QUOT` sequence | reads; gains the Quotation Type |
| `QuotationResource` | none (UUID only) | reads/writes lines, groups, quantities |
| `SubCategory` | `NOT ON TICKET` — no `@@unique([tenantCompanyId, …])` code found | reads |
| `SubCategoryAssociatedResource` | none (UUID only) | gains the per-association settings |
| `Job` | `jobId` / `JOB` sequence | created by conversion (reads) |
| `JobResource` | none (UUID only) | written by conversion (dispatch rule) |

- New entity introduced by this ticket: `NOT ON TICKET`
- New code prefix introduced: no
- Existing rows affected (backfill / migration of data, not just schema): ? — `OPEN — what do existing associations and existing quotations default to?`

## 8. Roles and permissions

- Roles that can perform this: `NOT ON TICKET` — moved to TCG-227 (open); existing sub-category and quotation edit permissions apply until then.
- Roles explicitly excluded: `NOT ON TICKET`
- Tenant scope: standard per-tenant isolation.

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | `NOT ON TICKET` |
| Jira attachments | `N/A — Linear ticket, no attachments` |
| Related tickets | `TCG-202` (folded in); `TCG-220`, `TCG-219`, `TCG-227`, `TCG-221`–`TCG-226` (see §5) |
| Existing repo docs | `NOT ON TICKET` |
| Vault area the reader thinks is relevant | `vault/quotations/mob-demob-current-rules.md`; `vault/quotations/mobilization-and-demobilization.md` (FR-1, FR-2, FR-6, FR-7); `vault/meetings/2026-10-01-quotes-and-billing-codes-associated-assets-mob-demob-and-holdover.md`; `vault/meetings/2026-10-07-sprint-review-offline-tickets-holdover-and-mob-demob-sign-off.md`; the 2026-10-01 → 2026-10-08 Mob/Demob notes in `vault/decisions/` |

## 10. Terms used that may not be defined

- `mob-demob` (known-undefined) — used as: "then Mobilization and Demobilization (its Sub items) at the bottom".
- Main item / Sub item — used as: "then Main item / Sub item while shown".
- "Also brings along" — used as: "an association's own associations".
- Visits — used as: "The group quantity is the number of visits".
- Field Setting — used as: "Field Setting (unchanged)".
- Operator Load — used as: "Operator Load is one billing code".
- Price Adjustment — used as: "Only the Price Adjustment custom type (FCC custom type PA)".
- Dispatch slot / visit days — used in the TCG-218 *Status* scope addition (not defined there).

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| Quotation Type values: `Hourly`, `Hourly w/ Mob` | Joe Schacatano, 2026-10-01 meeting (TCG-218 *Why*) |
| Demob lines start at `0` | `NOT ON TICKET — no origin cited` (vault has a 2026-10-01 decision) |
| Two-decimal quantities in a group | `NOT ON TICKET — no origin cited` |
| Mirrored line added to Demob at `0` | `NOT ON TICKET — no origin cited` |
| `amount = qty × rate`, rate = sum of ticked lines | `NOT ON TICKET — no origin cited` (vault: Joe, Teams 2026-10-08) |
| Price Adjustment = FCC custom type `PA` | Syed Haris, ticket owner, 2026-10-09 |

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: 11 — epic; acceptance criteria (as such); mobile; shared; SubCategory code; new entity; roles; excluded roles; design handoff; repo docs; invoice scope.
- Fields left as `OPEN`: 2 — acceptance criteria (Definition of Ready); defaults for existing associations and quotations.
- Is this ticket, as written, buildable without a product answer? no
- The blocking questions are:
  - What do existing sub-category associations and existing quotations default to when the new settings and Quotation Type arrive?
  - Which testable acceptance criteria does each Scope line become, and which are sourced?

---

**Next step:** run the elaborator (`.ai/aidlc/agents/inception/tcg-elaborator.md`) against this file.
It produces `spec.md` beside it and then stops to ask its questions. It will not implement.
