# Intent — Trello-254

> Snapshot of the ticket on 2026-11-16. Owner answers of the same date (Syed Haris, in chat) are marked **[owner]**.

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `Trello-254` (Scrum board #254, https://trello.com/c/4gh3HypZ) |
| Title | Mobile tweaks [quotation module] |
| Type | Task |
| Status | In Progress |
| Epic | `NOT ON TICKET` |
| Sprint | `NOT ON TICKET` |
| Reporter | Abdul Muazzam (card creator) |
| Assignee | Abdul Muazzam (card member) |
| Captured on | `2026-11-16` |
| Captured by | Claude Code session for Syed Haris |

## 2. Business intent

- Intent: `NOT ON TICKET` — the card lists five mobile tweaks and gives no reason. Reading: bring the mobile quote builder closer to web (yard search, price list, zip validation) and make required fields and errors easier to find.
- Who benefits (role): sales users building quotes on the mobile app (inferred, `NOT ON TICKET`).
- What is worse today without it: `NOT ON TICKET`.

## 3. Definition of done, as the ticket states it

```
- Add searching for yard lookup.
- Mark all asterisk as red in quotation module and other modules.
- Add price list lookup in quotation resources.
- Auto scroll to the erroneous fields.
- There is no validation for zip code for addresses in mobile just like we have in web
```

- Acceptance criteria present on the ticket: no (no checklist, no comments, no attachments).
- `OPEN — ticket has no acceptance criteria; per domain/jira-sop.md it does not meet Definition of Ready.` The five lines above are taken as the scope; behaviour beyond them is decided and recorded, or asked where client-facing (G1).

## 4. In scope

- [ ] Yard dropdown on the mobile quote builder (Main Info) is searchable.
- [ ] Every required-field asterisk on mobile sales screens renders red **[owner: whole sales surface — quotes, customers, projects, email compose, billing-code and custom-type sheets]**.
- [ ] Price List picker on the mobile quote builder's Resources step **[owner: mirror web's Price List dropdown above the resources: quote's list / customer's current list / Master, re-pricing lines]**.
- [ ] On a failed step (Next / Save), the quote builder scrolls to the first invalid field.
- [ ] Zip-code validation on mobile address forms with the web rule **[owner: all mobile address forms — quote add-job-site sheet, customer create (billing zip and job-site zip), any other mobile address form found]**.

## 5. Out of scope

- [ ] Web changes (web already has all five behaviours; web is the reference).
- [ ] API changes unless the price-list switch needs an endpoint web does not already use (to be decided in spec §11b).
- [ ] Field-worker (ticket) screens — they already use the red `required` mark and field-error scroll.
- [ ] Non-US zip formats (web rule is US 5 or 5+4).
- [ ] The TCG-219 Mob/Demob parity work (separate unmerged branch; overlap is a rebase risk, not scope).

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` | ? | Only if the price-list switch needs data web does not already fetch |
| `apps/api/prisma` | no | |
| `apps/web` | no | Reference only |
| `apps/mobile` | yes | Yard Select, `Field required`, scroll-to-error wiring, zip helper + inputs, Price List picker |
| `packages/shared` | ? | Zip helper could move to shared so web and mobile use one; decided in spec §11b |

## 7. Entities and business codes

| Entity | Code field / prefix | This ticket… |
| --- | --- | --- |
| `Yard` | — | reads |
| `Customer` / customer job site | — | creates (zip validated) |
| `Quotation` | quotation code | edits (`priceList`, `priceListSource`) |

- New entity introduced by this ticket: no
- New code prefix introduced: no
- Existing rows affected: no

## 8. Roles and permissions

- Roles that can perform this: whoever can already create or edit a quotation on mobile (`NOT ON TICKET` for any change).
- Roles explicitly excluded: `NOT ON TICKET`
- Tenant scope: standard per-tenant isolation

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | `NOT ON TICKET` |
| Jira attachments | none (Trello card, no attachments) |
| Related tickets | `TCG-219` — same mobile quote-builder files, branch unmerged |
| Existing repo docs | `apps/web/src/lib/zipcode.ts`, `apps/web/src/features/quotations/components/organisms/resources-pricing-chips.tsx`, `apps/mobile/design-system/primitives/{field,field-error-scroll,select}.tsx` |
| Vault area the reader thinks is relevant | `quotations/INDEX.md`, `quotations/billing-code-and-price-list.md` |

## 10. Terms used that may not be defined

- "yard lookup" — used on the ticket as: "Add searching for yard lookup."
- "price list lookup in quotation resources" — used on the ticket as: "Add price list lookup in quotation resources." Resolved by owner to web's Price List dropdown on Resources.

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| none stated | `NOT ON TICKET — no origin cited` (zip rule is "like we have in web") |

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: epic, sprint, business intent, designs, roles, numbers.
- Fields left as `OPEN`: acceptance criteria.
- Buildable without a product answer? Partly. Yard search, red asterisks, scroll-to-error and zip are web-parity or UI-only. The price-list switch decides what happens to existing line rates (client-facing, G1) and needs the spec's §12 batch.
