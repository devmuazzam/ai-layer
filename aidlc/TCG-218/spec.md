# Spec — TCG-218 Quotation: per-association quote visibility and Quotation Type (Hourly / Hourly w/ Mob)

> Written to `.ai/aidlc/TCG-218/spec.md` by the elaborator from `intent.md` beside it.
> **Fresh run.** Nothing from the two discarded attempts (branch `feat/association-document-visibility`,
> PRs #753/#754) is used. Every claim about code below was read from this checkout (origin/main, 857caf850).
>
> **Scope change 2026-10-14:** the per-crane Mob/Demob pair (from TCG-220) is now in this run (Q5); mobile stays out (Q9).
>
> Folded in: **TCG-202** (customer documents show Mob/Demob lines only) and the ticket owner's
> **quote → job conversion** addition. Out of scope (intent §5): TCG-220, TCG-219, TCG-227, TCG-221–226, invoices.

## How to read the source tags in this spec

`decisions/` notes are the product record, but **their status differs by rule** and the template's
blanket "decision = VERIFIED" would launder that. Tags here:

- `[VERIFIED]` — a decision note whose own frontmatter says `status: verified` **and** the specific rule is
  client-authored in that note. Used per source line, with the authority named.
- `[UNVERIFIED]` — a decision note with `status: reference` (the ticket owner's or CodingCops' ruling, "TCG can overrule
  it"), any rule the note labels *ticket owner*, any meeting note, any Linear ticket, the repo.
- A requirement takes the worst tag among its sources. Several `status: verified` notes mix client rules
  with ticket-owner rules in one file; the line says which is which.
- **Labelled interpretations are not requirements.** Where a note says "interpretation — not confirmed" the
  requirement is `[OPEN]` and the question is in §12.

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `TCG-218` (Linear, project TCG Platform, Cycle 2); `TCG-202` folded in |
| Intent | `.ai/aidlc/TCG-218/intent.md`, captured 2026-10-14 |
| Linear re-check | **Not done.** No Linear/Jira read was made in this run; the ticket text is quoted from `intent.md` (description last edited 2026-10-14). §8 of the agent rules says re-diff against the live ticket before sign-off — **the developer must do it** (§14). |
| Elaborated on | 2026-10-14 |
| Vault state at elaboration | Six `domain/` files verified (none relevant). Mob/Demob decisions read: 10-01 lines/quantities, 10-01 Operator Load, 10-06 ×3, 10-06 quotation type, 10-07 visits, 10-07 ticket-owner log, 10-07 two cranes, 10-08 Price Adjustment, 10-08 visit days, 09-11 footer (provenance note only). Conflict stub `quotations/mob-demob-INDEX.md` exists — see below. |
| Open questions raised by this spec | **18** (Q1–Q18), all answered by the ticket owner (2026-10-14/15); Q12–Q16 and Q18 as assumptions pending Lisette's demo review; Q11 answered by Q18; decision notes pending, decision notes pending, all in §12 |
| Already-shipped behaviour reached | **9 consumer groups in §11a**; **5** (R1, R2, R5, R7, R8) are partly or wholly without a source for what happens to them |
| Rules consulted | `.ai/claude/contexts/api.md`-class layering (via CLAUDE.md), `prisma.md` (tenant allowlist, migrations), `web.md` (feature-first), `patterns.md` (no entry for sub-categories/quotations), `mobile.md` (not built here) |

**Conflicts that bind this spec**

1. `quotations/mob-demob-INDEX.md` (stub): two Mob/Demob Confluence pages, only `quotations/mobilization-and-demobilization.md`
   (12 KB on disk; 2026-09-04 extension) is in the vault; the FR-01…FR-12 page is not migrated and **no ids FR-01…FR-12 are cited here**.
   Not adjudicated by any decision note. This spec cites the migrated page's FR-1/2/6/7 only as *agreeing with* the
   2026-10-01 client statements, never alone.
2. `decisions/2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md` Q6/U8 **vs**
   `decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md` — both are developer (`reference`) rulings, neither is the client's. This is REQ-15 `[CONFLICT]`.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Per-association quote settings (Hourly Show; Mob/Demob Show; Main/Sub item) | schema / api / web | `[UNVERIFIED]` | settings note; TCG-218 | no |
| REQ-02 | Employee-type associations start hidden (new picks and existing rows) | schema / api / web | `[UNVERIFIED]` | employee-types note | no |
| REQ-03 | Existing non-employee associations start hidden | schema / api | `[UNVERIFIED]` | ticket-owner answer Q1 (decision note pending) | no |
| REQ-04 | "Also brings along" rows: same settings, per parent, hidden by default, disabled while parent hidden | schema / api / web | `[UNVERIFIED]` | nested note; Operator Load note | no |
| REQ-05 | Quotation Type (Hourly / Hourly w/ Mob), chip beside Price List, saved on the quote | schema / api / web | `[UNVERIFIED]` | type note | no |
| REQ-06 | Hourly layout: a row appears exactly when its Hourly Show is ticked | web / api | `[UNVERIFIED]` | type note; ticket-owner answer Q6 | no |
| REQ-07 | Hourly w/ Mob layout: item alone, Main items, Mob/Demob groups at the bottom (the item itself first in its groups — Q42) | web / api | `[UNVERIFIED]` | type note; 10-01 note pt 9 | no |
| REQ-08 | Sub-item associations fill Mobilization automatically, mirrored into Demobilization at 0 | web / api | `[UNVERIFIED]` | ticket-owner answer Q3; 10-01 note pts 4, 8 | no |
| REQ-09 | One crane-named Mobilization/Demobilization pair per main crane, on the Resources tab, PDF and print | web / api | `[UNVERIFIED]` | two-cranes note (Joe); ticket-owner answer Q5 | no |
| REQ-10 | Group quantity = visits; amount = visits × sum of ticked lines; one total everywhere | shared / api / web | `[UNVERIFIED]` | visits note (Joe 2026-10-08 for rules 1–3) | no (Q2, Q9 answered) |
| REQ-11 | Lines in a group: 0 and 2-dp quantities, Demob starts at 0, a 0 line stays out, adding to Mob adds to Demob at 0 | web / api | `[UNVERIFIED]` | 10-01 note pts 4,5,8 (client) | no |
| REQ-12 | Rename/delete of a group line follows to its twin (basic rule only) | web / api | `[UNVERIFIED]` | 10-01 note update; ticket-owner answer Q8 | no |
| REQ-13 | Only the Price Adjustment line is hand-priced inside a group; others need a billing code | web / api | `[UNVERIFIED]` | PA note | no |
| REQ-14 | Customer documents show Mob/Demob lines only, with visits × rate = amount; foot lines include children | api / web | `[UNVERIFIED]` | 10-01 note pt 3; TCG-202; ticket-owner answer Q7 | no |
| REQ-15 | A hidden Always Included association still reaches the job; an Optional one left off the quote does not | api | `[UNVERIFIED]` | Operator Load note; 09-12 note; ticket-owner assumption Q12 | no |
| REQ-16 | Lines inside Mob/Demob add no dispatch slots; dispatch comes from the asset configuration | api | `[UNVERIFIED]` | visit-days note; ticket-owner answers Q10, Q18 | no |
| REQ-17 | Mob-only equipment: allocatable any day, optional slot, never blocks completion | api / web (DAS) | `[UNVERIFIED]` | ticket-owner assumptions Q13, Q16 | no |
| REQ-18 | Visits do not create required dispatch days; one-day job is one trip | api / web (DAS) | `[UNVERIFIED]` | ticket-owner assumptions Q13, Q14 | no |
| REQ-19 | Operator Load and Sub items: no first/last-day restriction | api / web (DAS) | `[UNVERIFIED]` | ticket-owner assumption Q15 | no |
| REQ-20 | Holdover items go to all days, as today | api / web (DAS) | `[UNVERIFIED]` | ticket-owner assumption Q16(1) | no |

| REQ-21 | Hourly w/ Mob Resources-tab layout: groups last, header row with editable visits and total, lines nested and collapsed | web | `[UNVERIFIED]` | 10-01 note pt 9 (Joe 1:01:56–1:02:14); ticket-owner choice | no |
| REQ-22 | New Mobilization lines start at 0 | web / api | `[UNVERIFIED]` | ticket-owner answer Q4; 10-01 note (Demob) | no |

Counts: **22** total — **0** verified, **22** unverified, **0** conflicted, **0** open. REQ-15 and REQ-17–20 rest on ticket-owner **assumptions** (Lisette not asked), so they are the least settled `[UNVERIFIED]` ones.


Self-check (§1 of the agent rules): of the `Sources:` lines behind requirements, `apps/…` is cited **only** as `kind: code` in
Ripple/Notes fields, not as a source of intent. Every requirement's `Sources:` cites vault/decision/Linear only.

## 2. Requirements

### REQ-01 — Per-association quote settings `[UNVERIFIED]`

- **Statement:** On a sub-category's Associated Field Assets, each association keeps its Field Setting unchanged and gains "Hourly · Quote/Invoice: Show" and "Mob/Demob · Quote/Invoice: Show", and while Mob/Demob Show is on, a Main item / Sub item choice; the two Show settings are independent, and the quote lists associations in the sub-category page's order.
- **Surface:** schema / api / web
- **Sources:**
  - `decisions/2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md` — `[VERIFIED]` (status: verified) for points 1–2, **Joe Schacatano approved 2026-10-07 sprint review** (36:23, 49:55, 50:10); `[UNVERIFIED]` for point 3 (independent settings) and Q16 (order) — **ticket owner Syed Haris only, Joe did not discuss**.
  - `decisions/2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md` — `[UNVERIFIED]` — kind: decision (`status: reference`) — Q16 order, Q18 independent.
  - `meetings/2026-10-07-sprint-review-offline-tickets-holdover-and-mob-demob-sign-off.md` §7 — `[UNVERIFIED]` — kind: vault (meeting; corroborates only, never the sole source).
  - `TCG-218` — `[UNVERIFIED]` — kind: jira(Linear) — *Scope* first bullet.
- **Conflict:** none for this requirement. (The stub `quotations/mob-demob-INDEX.md` concerns the un-migrated Confluence page, not these settings.)
- **Open question:** none for the settings themselves; defaults for existing rows → REQ-03 / Q1.
- **Ripple:** see §11a rows R4–R6 (sub-category endpoints and DTO, web sub-category forms, mobile contract, seeds, DAS `isRequired` reads). Tab rename to "Field Assets Configuration" and its activity log are **TCG-220**, not here.
- **Acceptance:** (derived from the Scope line; each clause traceable to the notes above) — an admin can set, per association, Hourly Show on/off, Mob/Demob Show on/off and, while Mob/Demob Show is on, Main item or Sub item; Field Setting is unchanged by the change; turning Hourly Show off does not alter Mob/Demob Show and vice-versa; settings persist and reload.
- **Notes for the executor:** The existing row is `SubCategoryAssociatedResource` (`apps/api/prisma/schema.prisma:719`; fields `associatedSubCategoryId | associatedEmployeeTypeId | associatedCustomTypeId`, `isRequired`). Whether settings are columns here or elsewhere is §11b D1. Who may edit: existing sub-category permissions until TCG-227 (intent §8).

### REQ-02 — Employee-type associations start hidden `[UNVERIFIED]`

- **Statement:** An association to an employee type starts hidden on both quote types (Hourly Show off, Mob/Demob Show off), for new picks and for existing rows; a user with permission may tick Show and it then appears; already-saved quotes keep their lines when reopened.
- **Surface:** schema / api / web
- **Sources:**
  - `decisions/2026-10-06-employee-type-associations-start-hidden-on-the-quote.md` — `[VERIFIED]` (status: verified) for default and configurability (client-approved, Joe 2026-10-07, 49:55–50:30); `[UNVERIFIED]` for the backfill and "saved quotes unchanged" (ticket owner only, Q7).
  - `TCG-218` — `[UNVERIFIED]` — kind: jira — "An employee type starts hidden on both quote types."
- **Conflict:** none.
- **Open question:** none. (Not blocking: whether a *charged* operator is reached by ticking Show or only by a Certified Operator billing code is TCG-218 Q19 — unanswered; see §13.)
- **Ripple:** existing employee-type association rows (backfill) — §11a R5; saved quotes — unchanged (source: the same note, point 2).
- **Acceptance:** a new employee-type association has both Show settings off; every existing employee-type association is off after the change; a quote saved before the change shows the same lines when reopened.
- **Notes for the executor:** the backfill is a data migration — a migration is mandatory (`prisma.md`).

### REQ-03 — Existing non-employee associations start hidden `[UNVERIFIED]`

- **Statement:** When the settings arrive, existing non-employee sub-category associations (custom-type included) start hidden on both quote types.
- **Surface:** schema / api
- **Sources:**
  - Ticket owner, Q1, 2026-10-14, Claude Code session: "hidden" — `[UNVERIFIED]` — kind: decision (answer in §12; **decision note pending**, not client-confirmed; Joe was not asked).
  - `decisions/2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md` — `[UNVERIFIED]` for this point — its default for a *newly picked* direct association is shown/Main item; the owner's answer covers **existing** rows only. Whether new picks stay shown is not changed by the answer.
- **Conflict:** none.
- **Open question:** none. (Joe has not seen this default for existing rows.)
- **Ripple:** §11a R5 — existing rows hidden: quotes built after release list fewer associations; saved quotes unchanged (employee note pt 2 states this for employee rows; for non-employee rows it is the same mechanism but not stated — treated as unchanged, confirm at sign-off). Seeds/fixtures: `NOT SPECIFIED`.
- **Acceptance:** after migration every existing non-employee association has both Show settings off.
- **Notes for the executor:** data migration, committed. Default for new picks is per the settings note, not this requirement.

### REQ-04 — "Also brings along" rows `[UNVERIFIED]`

- **Statement:** An association's own associations (e.g. Operator Load → Tractor-Semi, Operator) carry the same Hourly Show and Mob/Demob Show + Main/Sub settings, stored per parent association, hidden by default, and disabled (and cleared) while the parent is hidden on that quote type; a shown such row goes on the quote with its parent.
- **Surface:** schema / api / web
- **Sources:**
  - `decisions/2026-10-06-nested-association-quote-visibility-stored-per-parent.md` — `[VERIFIED]` (status: verified) for points 1 and 3 (configurable, hidden by default — **Joe approved 2026-10-07**); `[UNVERIFIED]` for point 2 (per-parent storage — CodingCops design, Joe did not discuss) and point 4 (disabled/cleared while parent hidden — ticket owner).
  - `decisions/2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md` — `[VERIFIED]` — Joe 2026-10-01: Operator Load is one billing code; tractor/operator keep codes for one-offs; refined by Joe 2026-10-07 into "hidden by default, configurable".
  - `TCG-218` — `[UNVERIFIED]` — kind: jira.
- **Conflict:** none open (the 10-01 conflict was closed by Joe on 2026-10-07 per the nested note). A **build question** the note leaves to review: `decisions/2026-08-31-quotation-associated-child-merge-semantics.md` merges grandchildren by normalised name — whether the per-parent lists survive that merge is not settled.
- **Open question:** none for product. Structure → §11b D2.
- **Ripple:** today a quote persists only the first association level; deeper levels are created at conversion by `materialize-job-resources.ts` — §11a R5, R8.
- **Acceptance:** the same child (e.g. Operator) can be shown under one parent and hidden under another; with the parent hidden on Hourly, its nested rows' Hourly controls are disabled and read as hidden; defaults for a new nested row are hidden on both types.
- **Notes for the executor:** per-parent storage rules out a flag on the child's own association row (nested note, point 2). Shape of storage is D2.

### REQ-05 — Quotation Type `[UNVERIFIED]`

- **Statement:** A quotation carries one Quotation Type, Hourly or Hourly w/ Mob, default Hourly, chosen once for the whole quote via a chip beside Price List, saved on the quotation and carried on duplicate; switching asks for confirmation when it will change rows; every quote saved before this exists opens as Hourly (no inference, no backfill).
- **Surface:** schema / api / web
- **Sources:**
  - `decisions/2026-10-06-quotation-type-hourly-or-hourly-with-mob.md` — `[UNVERIFIED]` (status: reference — ticket owner's ruling; "TCG can overrule it"); Joe saw the switch on 2026-10-07 and raised no objection but was **not asked** per-quote vs per-crane.
  - `TCG-218` — `[UNVERIFIED]` — kind: jira — "Quotation Type chip beside Price List: Hourly / Hourly w/ Mob, saved on the quotation."
  - `meetings/2026-10-01-quotes-and-billing-codes-associated-assets-mob-demob-and-holdover.md` §8 — `[UNVERIFIED]` — quotes are hourly or mob/demob (corroboration only).
- **Conflict:** none among notes. Open register entries `quotations/gaps.md` → *Estimate defaults per resource type / job type / yard* (a) full job-type list, (f) whole quote vs per row — **answered by the ticket owner only; still open for Joe Schacatano / Ryan Adams** (`quotations/gaps.md:1086`). This spec does not close them.
- **Open question:** none blocking. Not specified: what counts as a switch that "will change rows", and whether manual edits are discarded or kept — the note says "manual edits may be discarded only after confirmation" (Q15 refinement). The exact discard rule is `NOT SPECIFIED`.
- **Ripple:** §11a R1 (every reader of quotation DTO/shape), R7 (duplicate, revision snapshot — **not specified** whether `QuotationRevision.snapshot` carries the type, §13).
- **Acceptance:** a new quote is Hourly; the chip switches the type; a switch that changes rows prompts first; reopening a pre-existing quote shows Hourly and its lines unchanged; a duplicated quote has the source's type.
- **Notes for the executor:** the note records "a short string `'hourly'|'hourly_w_mob'`, not an enum" as the ticket owner's earlier build choice — it is **D3**, not decided here. `Quotation` model at `schema.prisma:1826` already has `priceList` / `priceListSource` (the chip's neighbour).

### REQ-06 — Hourly layout `[UNVERIFIED]`

- **Statement:** On an Hourly quote each item is listed with the associations that are Hourly-shown, plus any further rows its parent ticked.
- **Surface:** web / api
- **Sources:**
  - `decisions/2026-10-06-quotation-type-hourly-or-hourly-with-mob.md` — `[UNVERIFIED]` — point 3: "each item, with the associations it shows on Hourly (and any 'also brings along' rows its parent shows)".
  - `TCG-218` — `[UNVERIFIED]` — kind: jira — "plus any sub-items its parent ticked".
- **Conflict:** none; a **wording gap**: the ticket says "sub-items its parent ticked", the note says "also brings along rows its parent shows". Not assumed equal — Q6.
- **Open question:** none. Q6 answered 2026-10-15: "whatever is hidden it's hidden, what's shown is shown" — a row appears exactly when its Hourly Show is ticked.
- **Ripple:** §11a R3 (web resources tab, create/edit/detail views).
- **Acceptance:** with the Hourly 100 Ton example shown to Joe on 2026-10-07 (crane, Operator Load, travel permit shown; tractor-semi and operator hidden), an Hourly quote lists exactly the Hourly-shown associations.
- **Notes for the executor:** web builds quote rows from the catalog in `apps/web/src/lib/resource-catalog.ts` (association expansion near line 299) — a code observation only.

### REQ-07 — Hourly w/ Mob layout `[UNVERIFIED]`

- **Statement:** On an Hourly w/ Mob quote the item appears alone, its Main-item associations as their own lines, then the Mobilization and Demobilization groups (the item itself first, then its Sub items) at the bottom. *(Amended 2026-10-16, §12 Q42 — `decisions/2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md`.)*
- **Surface:** web / api
- **Sources:**
  - `decisions/2026-10-06-quotation-type-hourly-or-hourly-with-mob.md` — `[UNVERIFIED]` — point 3.
  - `decisions/2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md` — `[VERIFIED]` (status: verified) — point 9: groups at the bottom is **Joe's stated preference, "not a hard requirement"** ("I have no preference… on the bottom is better").
  - `TCG-218` — `[UNVERIFIED]` — kind: jira.
- **Conflict:** none.
- **Open question:** what *populates* the groups → REQ-08.
- **Ripple:** §11a R3. The meeting record (2026-10-07 §7) says mob/demob-at-bottom was "still to do" at the demo.
- **Acceptance:** with a crane whose association A is Main and B is Sub, the quote lists crane, A, then Mobilization and Demobilization last; B appears only inside the groups.
- **Notes for the executor:** `isGroup` / `isIncluded` already exist on `QuotationResource` (`schema.prisma:1972`); a group today is a top-level row whose label matches Mobilization/Demobilization (`isGroupResourceLabel` in `@tcg/shared`, used by web `resources-tab.state.helpers.ts` and mobile `quote-create.store.ts`).

### REQ-08 — Sub-item associations fill the groups automatically `[UNVERIFIED]`

- **Statement:** On an Hourly w/ Mob quote, Sub-item associations are added into Mobilization automatically and mirrored into Demobilization at quantity 0.
- **Surface:** web / api
- **Sources:**
  - Ticket owner, Q3, 2026-10-14: "automatically" — `[UNVERIFIED]` — kind: decision (pending note).
  - `decisions/2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md` — `[VERIFIED]` (Joe) — pts 4 and 8: Demob starts at 0; adding to Mob adds to Demob.
- **Conflict:** none.
- **Open question:** initial qty/hours/rate of the Mobilization line → REQ-22 / Q4.
- **Ripple:** §11a R3.
- **Acceptance:** picking a crane with a Sub-item association yields that line inside Mobilization and a twin inside Demobilization at 0.
- **Notes for the executor:** the Mobilization line's initial values are NOT specified here.

### REQ-09 — One crane-named pair per main crane `[UNVERIFIED]`

- **Statement:** Each main crane on an Hourly w/ Mob quote gets its own Mobilization/Demobilization pair labelled with the crane (e.g. "90 Ton Crane – Mobilization"), on the Resources tab and on the customer PDF and print.
- **Surface:** web / api
- **Sources:**
  - `decisions/2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md` — `[VERIFIED]` (status: verified) for pts 1–3 (Joe 2026-10-07: separate pair per crane on one quote, labelled; one invoice); label wording is ticket owner.
  - Ticket owner, Q5, 2026-10-14: "two pair of mob/demob 90 ton crane mob/demob 250 ton crane mob/demob and reflect on print as well" — `[UNVERIFIED]` — kind: decision (pending note).
- **Conflict:** none. **Scope change from `intent.md` §5:** this per-crane-pair part of TCG-220 is now in this run; tab rename and activity log remain TCG-220.
- **Open question:** none. Group order: Q17 answered — each crane's Mob and Demob together, in crane order.
- **Ripple:** §11a R2, R3 (PDF and print group handling now per crane).
- **Acceptance:** a quote with a 90 Ton and a 250 Ton crane shows two labelled pairs; the PDF and print show the four group lines only; each pair rolls up its own lines.
- **Notes for the executor:** how a group is tied to its crane is a structural choice (D13).

### REQ-10 — Group quantity is visits `[UNVERIFIED]`

- **Statement:** The Mobilization (and Demobilization) group's own quantity is the number of visits (default 1, editable); lines inside are entered as for one visit; group rate = sum of the ticked lines; group amount = quantity × rate; only Mobilization and Demobilization multiply (any other group parent rolls up ×1); discount, surcharge and price hike on the lines scale × visits; one total on every server surface; approval margin multiplies the group's ticked lines (revenue and cost) by visits.
- **Surface:** shared / api / web (mobile out of scope per Q9; but `@tcg/shared` is consumed by mobile — executor must not break mobile's build)
- **Sources:**
  - `decisions/2026-10-07-mob-demob-group-quantity-is-visits-times-the-summed-lines.md` — `[VERIFIED]` (status: verified) for rules 1–3 (**Joe Schacatano, Teams, 2026-10-08**, quoted verbatim in the note); `[UNVERIFIED]` for rules 4–9 (Demob the same, Mob/Demob only, adjustment scaling, one total, margin, one-off outside the group — **ticket owner, Joe not asked**).
  - `decisions/2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md` — `[VERIFIED]` — point 7 (Joe 29:02–29:35, the quantity must be editable).
  - `decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md` — `[UNVERIFIED]` (`reference`) — point 2 "group parent shows the sum of its children"; its `provenance_note` says this holds **at quantity 1 only**.
  - `TCG-218` — `[UNVERIFIED]` — kind: jira.
- **Conflict:** none (the 09-11 point is settled for Mob/Demob by Joe's reply; for other group parents the 09-11 figure stands).
- **Open question:** none. Answered 2026-10-14 by the ticket owner: Q2 "reset to 1" (saved quotes whose group qty is not 1 are reset to 1 visit, so totals do not change — a data migration); Q9 "don't do mobile changes for now" (mobile out of scope, may show 1-visit totals until TCG-219). Both `[UNVERIFIED]`, decision notes pending.
- **Ripple:** the widest in this ticket — §11a R2 (about 18 non-test files compute group totals).
- **Acceptance:** at visits = 3 with lines Crane 3 hr and Support load 3 hr, per-visit rate is the sum of the ticked lines and the group amount is 3 × that sum; line quantities are unchanged by editing visits; an unticked line is excluded; a Crane Time group stays ×1; quote subtotal, total, customer metrics, project revenue and the approval/signature emails agree.
- **Notes for the executor:** the arithmetic exists twice today: `packages/shared/src/utils/quotation-pricing.ts` (`getGroupTotal`, web+mobile) and `apps/api/src/usecase/quotations/quotation-resource-totals.ts` (`applyGroupRollups`, `computeQuotationTotals`). Neither reads the group row's `qty`. Choosing one home is D5. Expect this requirement alone to exceed one ~400-line PR.

### REQ-11 — Lines inside a group `[UNVERIFIED]`

- **Statement:** A line inside Mobilization/Demobilization accepts 0 and two-decimal quantities; Demobilization lines start at 0; a line at 0 stays out of the total; adding a line to Mobilization adds it to Demobilization at 0.
- **Surface:** web / api
- **Sources:**
  - `decisions/2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md` — `[VERIFIED]` (status: verified) — points 4, 5, 8 are **Joe's** (30:19–30:21, 51:01–51:35, 1:02:57–1:03:07); the **two-decimal precision is the ticket owner's** (Q11) — no TCG person stated a precision.
  - `TCG-218` — `[UNVERIFIED]` — kind: jira.
- **Conflict:** `decisions/2026-08-31-quotation-qty-not-das-sets.md` is "not a conflict" per the 10-01 note (children default quantity 1; Mob/Demob group rules explicitly unchanged).
- **Open question:** none.
- **Ripple:** §11a R2 (zero-line exclusion applies wherever group totals are computed).
- **Acceptance:** a Demob line mirrored from a Mob line has qty 0.00; entering 0.5 and 1.25 is accepted; a third decimal is not; a 0 line contributes 0 to the group and the quote.
- **Notes for the executor:** `QuotationResource.qty` is already `Decimal(10,2)`.

### REQ-12 — Rename and delete follow the twin `[UNVERIFIED]`

- **Statement:** Renaming or deleting a line in Mobilization renames or deletes its Demobilization twin, and the reverse.
- **Surface:** web / api
- **Sources:**
  - `decisions/2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md` — update 2026-10-08, point 8: **ticket owner** ("q14: twin follow"); Joe **not asked**.
  - `decisions/2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md` — `[UNVERIFIED]` — Q14.
- **Conflict:** none.
- **Open question:** none. Q8 answered 2026-10-15: "Only the basic rule" — twin follows rename/delete, no special duplicate-name handling, no quantity rule. (The note's "build reading" — a twin is left alone while another line in the source group still has its name; a rename keeps the twin's quantity and re-prices it. is therefore not adopted: no duplicate-name or quantity rule beyond "the twin follows".)
- **Ripple:** §11a R3.
- **Acceptance:** deleting the only Mob line named X deletes Demob X; renaming Mob X to Y renames Demob X to Y. Edge cases per Q8.
- **Notes for the executor:** how a twin is identified (name match vs stored link) is a structural choice, §11b D5b.

### REQ-13 — Price Adjustment is the only hand-priced line in a group `[UNVERIFIED]`

- **Statement:** Price Adjustment is a **line item** inside the group (not a change to a rate). Inside a Mob/Demob group only the "Price Adjustment" item (FCC billing code `PA`, custom type) is priced by hand without a billing code; its rate may carry cents; any other code-less custom line, inside or outside a group, needs a billing code.
- **Surface:** web / api
- **Sources:**
  - `decisions/2026-10-08-only-the-price-adjustment-custom-type-is-hand-priced-in-a-mob-demob-group.md` — `[UNVERIFIED]` (status: reference; ticket owner, "q13: yes" 2026-10-09). Basis: Joe 2026-10-01 37:16 named one line; the note supersedes `2026-10-07-unbilled-custom-type-…` (superseded — not used).
  - `TCG-218` — `[UNVERIFIED]` — kind: jira (cites the 2026-10-09 ticket-owner confirmation).
  - Joe Schacatano, 2026-10-01 transcript 37:16 (via the coordinator's `tcg-scrum` finding): "there was a line item price adjustment … a hotel, food, just random stuff that we don't really generate billing codes for, or if we want to just add extra money in there"; FCC data has Price Adjustment as a billing code (unit EA, default rate 0, GL account PA). Ticket owner 2026-10-14: "okay then it's a line item".
- **Conflict:** none. `2026-08-31-quotation-resource-rate-whole-dollars.md` (whole-dollar rate) is expressly disapplied for PA by the note.
- **Open question:** none for product. The note says how the item is identified (dedicated custom type vs the `PA` code) "a build matter" → D9.
- **Ripple:** §11a R9 ("Billing Code missing." logic in web `resource-row.rate-column.tsx` and mobile `quote-create-resources.tsx`).
- **Acceptance:** a Price Adjustment line in Mobilization saves with a hand-entered 25.50 rate and no "Billing Code missing."; a different code-less custom line in the group is flagged; whole-dollar rule still applies to ordinary rates.
- **Notes for the executor:** the seed files `apps/api/fcc-seeder/seed-files/billing-code-types.json` and `billing-codes.json` mention "price adjustment"; no application source references it (`git grep -i "price adjustment" -- apps` → seed files, mobile/web comments only) — a code observation.

### REQ-14 — Customer documents show Mob/Demob lines only `[UNVERIFIED]`

- **Statement:** The server PDF and the browser print show Mobilization, Demobilization and the main items only — never the lines inside the groups; the discount / price-hike / surcharge foot lines still include the group children's amounts.
- **Surface:** api / web
- **Sources:**
  - `decisions/2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md` — `[VERIFIED]` (status: verified) — point 3, **Joe 26:50–27:11 "Yes. Exactly"**; "covers both customer documents… the browser print breaking it is a bug, tracked as TCG-202".
  - `quotations/mobilization-and-demobilization.md` — `[UNVERIFIED]` — FR-6 / FR-7 (customer sees totals only; staff view keeps sub-items) — consistent, unadjudicated (conflict stub).
  - `TCG-202` (via `intent.md` §3) — `[UNVERIFIED]` — *Expected*: group parent prints as one line (its rolled-up amount); foot lines still include children's amounts.
- **Conflict:** the mob/demob stub (see §0) does not touch FR-6; no candidate disagrees on this point.
- **Open question:** none. Q7 answered 2026-10-15: "Visits × rate = amount" — on both PDF and print the group line shows visits as Qty, the per-visit rate and the amount (e.g. Mobilization 3 visit $1,995 $5,985). The PDF and print currently differ (PDF prints qty; print prints "—"), so both change.
- **Ripple:** §11a R2/R3. As read today (code, descriptive): the server PDF already hides group children (`getVisibleResources` in `quotation-pdf.service.ts`) and keeps included children in the foot lines (`getAdjustmentResources`); the browser print (`print-quotation.helpers.ts` `buildPrintLineItems`) walks every child and indents it, so the leak is **web print only**. The PDF's group row prints `fmtNumber(r.qty)` while print prints "—" for qty/unit/rate — they already differ.
- **Acceptance:** print and PDF of a quote with Mob (3 lines) and Demob (3 lines) show exactly Mobilization and Demobilization and the main items; foot lines equal the sum over all included children (× visits per REQ-10); the in-app detail view still shows the lines (FR-7).
- **Notes for the executor:** reuse the server's rule shape; do not duplicate a third copy (D6). `data-testid` contract: check `qa-automation/e2e` before renaming IDs (CLAUDE.md).

### REQ-15 — A hidden association still reaches the job `[UNVERIFIED]`

- **Statement:** Show/hide is for the quote only: an Always Included billable association hidden on the quote (e.g. Operator Load's tractor and operator) still becomes a dispatch row on the job; an Optional association left off the quote does not.
- **Surface:** api
- **Sources:**
  - `decisions/2026-10-01-operator-load-is-one-billing-code-its-associations-stay-off-the-quote.md` — `[VERIFIED]` — Joe 13:37 "always included on the job end when it's dispatched".
  - `decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md` — `[UNVERIFIED]` (reference) — Optional not carried by the quote is not materialised.
  - Ticket owner, Q12, 2026-10-15: "no" — `[UNVERIFIED]`, **assumption pending Lisette's review at the demo**.
- **Conflict:** the earlier `[CONFLICT]` (09-12 vs Q6/U8 in `decisions/2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md`) is **resolved for this build by the ticket owner's assumption on the 09-12 side**. Both vault notes still list each other in `conflicts_with` until `tcg-scrum` records a note; the owner reverses his own Q6/U8 ruling. Not client-confirmed.
- **Open question:** none (Q12 answered as an assumption).
- **Ripple:** §11a R8 — current `materialize-job-resources.ts` skips Optional (`isRequired: false`), which matches this answer.
- **Acceptance:** Operator Load's hidden tractor and operator appear as job rows; an Optional association absent from the quote does not.
- **Notes for the executor:** the Optional branch needs no change.

### REQ-16 — Lines inside Mob/Demob are not duplicate dispatch slots `[UNVERIFIED]`

- **Statement:** On quote → job conversion, lines inside Mobilization/Demobilization do not add dispatch slots of their own; dispatch comes from the crane's asset configuration, and each machine is one slot.
- **Surface:** api
- **Sources:**
  - `decisions/2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md` — `[UNVERIFIED]` (reference) — "Defect this fixes" paragraph; rule 6 price lines are not dispatched.
  - Ticket owner, Q10, 2026-10-14: "dispatch comes from asset configuration, but let's say he added a support load which was not initially required then what? or added a new single asset" — reading confirmed (rows inside the groups add no slots); follow-up answered by Q18.
  - Ticket owner, Q18, 2026-10-15: "yes" — equipment added outside the configuration (inside Mobilization or as its own line) shows on the dispatch board to assign (assumption pending Lisette).
  - `TCG-218` *Status* — `[UNVERIFIED]` — kind: jira.
- **Conflict:** none.
- **Open question:** none. Not stated: whether group rows/children are kept on the job as non-dispatch rows (shape on the job is D7).
- **Ripple:** §11a R8 (`createJobFromQuotationInTx`, three callers; ~50 files read `JobResource`).
- **Acceptance:** converting an Hourly w/ Mob quote yields one dispatch row per configured machine and none for price lines; an unconfigured machine added by the salesperson is assignable on the board.
- **Notes for the executor:** how an added machine becomes a row while group lines add none is D7.

### REQ-17 — Equipment quoted only inside Mob/Demob: allocatable any day, never blocks completion `[UNVERIFIED]`

- **Statement (restated 2026-10-15):** A dispatch slot for equipment quoted only inside Mobilization/Demobilization has **no day restriction**: dispatch sends it on whichever days they allocate it, and — when it is not marked holdover — it is optional on the board, so an empty slot never blocks "allocation completed" / Send Tickets.
- **Surface:** api / web (DAS)
- **Sources:**
  - Ticket owner, Q13 "we don't restrict day, where dispatch add it can be sent"; Q16(2) "go with a" — 2026-10-15, `[UNVERIFIED]`, **assumptions pending Lisette's review**.
  - Background (no longer the rule as written): `decisions/2026-10-08-equipment-quoted-only-inside-mob-demob-goes-out-on-visit-days.md` rules 1–3 — Joe 2026-10-01 52:08–52:54 said a build-only support load goes to build and to break down (first and last day), "Correct."; the owner's assumption does not enforce days.
- **Conflict:** none recorded, but the answer is **looser than Joe's stated practice** and than the note's rules 3–5; the vault note stays unchanged until `tcg-scrum` writes one. Flag for Lisette's demo review.
- **Open question:** none.
- **Ripple:** §11a R8; the earlier "required on first and last day" meaning is removed — no new required-day concept is needed (D8 may reduce to "optional slot" representation, developer's call).
- **Acceptance:** a Mob-only support load is assignable on any day; leaving its slot empty does not stop completion or Send Tickets.
- **Notes for the executor:** the optional-slot flag representation is a structural choice (D8).

### REQ-18 — Extra visits `[UNVERIFIED]`

- **Statement (restated):** Visits do not map to dispatch days: dispatch decides on which days Mob-only equipment goes out (Q13). One-day job: one trip (Q14).
- **Surface:** api / web (DAS)
- **Sources:**
  - Ticket owner, Q13 "we don't restrict day, where dispatch add it can be sent"; Q14 "then yes" (one trip on a one-day job) — 2026-10-15, `[UNVERIFIED]`, assumptions pending Lisette.
  - Context: Lisette 2026-05-21 59:00 "If it's for a single day, yeah, they'll go do the job and then come back to the yard with the crane." (via tcg-scrum research).
- **Conflict:** the owner's earlier "3 visits → 3 trips" (visit-days note rule 4) is no longer enforced by the system.
- **Open question:** none.
- **Ripple:** §11a R8.
- **Acceptance:** raising visits changes price only; it creates no required dispatch days.
- **Notes for the executor:** none.

### REQ-19 — Operator Load and Sub items `[UNVERIFIED]`

- **Statement (restated):** No first/last-day restriction for Operator Load or Sub-item associations.
- **Surface:** api / web (DAS)
- **Sources:** ticket owner, Q15, 2026-10-15: "we don't restrict for now" — `[UNVERIFIED]`, assumption pending Lisette. Context: Joe 2026-10-01 39:09 concerns charges; the visit-days note's rule 5 interpretation is not used.
- **Conflict:** none.
- **Open question:** none ("for now").
- **Ripple:** §11a R8.
- **Acceptance:** Operator Load follows the same optional, any-day rule as REQ-17 where applicable; no first/last-day enforcement.
- **Notes for the executor:** none.

### REQ-20 — Holdover items `[UNVERIFIED]`

- **Statement (restated):** Items marked holdover go to all days, as holdover works today; Mob-only equipment not marked holdover is the optional slot of REQ-17.
- **Surface:** api / web (DAS)
- **Sources:** ticket owner, Q16(1) "whoever is holdover can go to all days", 2026-10-15 — `[UNVERIFIED]`, assumption pending Lisette. Context: Lisette 57:33 crane crews work every day on a holdover.
- **Conflict:** none.
- **Open question:** none for the product. Build-only item crews and Copy Allocations remain unwritten in the vault (`dispatch/gaps.md:1038`, `:1059`) and are not changed by this answer.
- **Ripple:** §11a R8 (`JobResource.isHoldover`, DAS holdover).
- **Acceptance:** an item marked holdover is occupied on all days as today.
- **Notes for the executor:** existing holdover behaviour unchanged.

### REQ-21 — Hourly w/ Mob Resources-tab layout `[UNVERIFIED]`

- **Statement:** On an Hourly w/ Mob quote the Resources tab shows quoted items and Main items first and the Mobilization/Demobilization groups last; each group is a header row carrying its visits (editable) and its total, with its lines nested underneath, collapsed by default (expand to see and edit the lines). With two cranes, all crane-named groups sit at the bottom.
- **Surface:** web
- **Sources:**
  - `decisions/2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md` — `[VERIFIED]` (status: verified) pt 9 — Joe 1:01:56–1:02:14: "it's like looking at a balance sheet. You're looking at the total on the bottom … if we want to change the quantity of the mobilizations, taking it from one to three, we're seeing that at the bottom … So I think on the bottom is better." The note records it as his stated preference, not a hard requirement.
  - Ticket owner, 2026-10-14, "go with A": chose this presentation over a spreadsheet-style subtotal-below-its-lines layout — `[UNVERIFIED]` — kind: decision (pending note). "Collapsed by default" is the owner's, not Joe's.
- **Conflict:** none.
- **Open question:** none (Q17 answered).
- **Ripple:** §11a R3; supersedes REQ-07's placement wording for the group presentation (REQ-07 stays for item/Main-item order).
- **Acceptance:** with Mobilization at 3 visits the header shows 3 and the total; expanding shows the lines; collapsed by default on open.
- **Notes for the executor:** web only; existing `resource-row*` components render group children today.

### REQ-22 — Initial qty/hours/rate of a new Mobilization line `[UNVERIFIED]`

- **Statement:** New lines inside Mobilization start at quantity 0, like Demobilization lines; the rate comes from the customer's price list, else the billing code, like any other quote line.
- **Surface:** web / api
- **Sources:**
  - Ticket owner, Q4, 2026-10-14: "start at 0 we can present and if they want to change we can" — `[UNVERIFIED]` — kind: decision (pending note); to be shown to Joe at the sprint review, not client-confirmed.
  - Ticket owner, 2026-10-15: "Billing code / price list" — only the quantity starts at 0; the rate is priced as any other line — `[UNVERIFIED]` (pending note).
  - `decisions/2026-10-01-mob-demob-lines-quantities-and-placement-on-the-quote.md` — `[VERIFIED]` (Joe 30:21) — Demob half only.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** §11a R3.
- **Acceptance:** a line added to or auto-filled into Mobilization has qty 0 and a price-list/billing-code rate.
- **Notes for the executor:** initial hours: `NOT SPECIFIED`.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** **yes** (per-association settings; Quotation Type; likely visit-days and nested-settings storage). *The exact columns/tables are a developer decision (§11b); this section lists what the requirements force, not what to add.*
- **Migration required:** yes — committed under `apps/api/prisma/migrations/` (`prisma.md`).
- **Data backfill required:** yes for REQ-02 (employee-type rows hidden — sourced); REQ-03 `OPEN — Q1`; existing quotes → Hourly (REQ-05: "no backfill" — default only).
- **Existing models considered** (found by `grep -n '^model ' apps/api/prisma/schema.prisma`):
  - `SubCategoryAssociatedResource` (:719) — the row the settings attach to; one row per (parent, associated); `isRequired` already there.
  - `Quotation` (:1826) — holds `priceList`, `priceListSource`; candidate for the type.
  - `QuotationResource` (:1972) — has `isGroup`, `isIncluded`, `parentId`, `qty Decimal(10,2)`, `sortOrder`; group row `qty` exists but no rollup reads it. **No `tenantCompanyId` column.**
  - `JobResource` (:3632) — has `quotationResourceId`, `parentId`, `isHoldover`, `qty`; no field for visit days.
  - `JobSchedule` (:3769), `JobScheduleInterval` (:3790), `JobResourceAllocation` (:3953) — where days live.
  - `QuotationRevision` (:2952) — `snapshot Json?` (whether it should carry the type: not specified).
- **Tenancy fact for the guardian:** `TENANT_SCOPED_MODELS` in `apps/api/src/orm/prisma.service.ts` lists `jobresource` (:68); `grep -n -i` finds **no** `subcategoryassociatedresource` or `quotationresource` entry. A new per-association or per-parent table inherits that gap unless a developer decides otherwise (D1b).

```prisma
// NOT SPECIFIED — no models or columns are proposed in this spec.
// Options are laid out in §11b D1–D4, D8. The spec does not write schema.
```

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| none | none | none | none | no source asks for a business code; join/child rows are UUID-only like `SubCategoryAssociatedResource` |

- **New prefix introduced:** no.
- **Child relations:** by UUID `id`.
- **Fields whose type/precision no source states:** the Show flags' nullability/default (beyond the stated defaults in REQ-02/REQ-03), the type column's width, any visit-days field — all `NOT SPECIFIED`. Quantity precision is stated: 2 dp (ticket owner); money precision: `Decimal(15,2)` exists.

## 4. API surface — `apps/api`

- **Pattern:** none — `patterns.md` has no entry for sub-categories or quotations (P1 coded CRUD, P2 reference-code list only; checked by `grep -n -i -E 'sub-?categor|quotation' .ai/claude/contexts/patterns.md` — only an unrelated hook-location mention). Follow the existing modules.
- **Existing functions/services to reuse:**
  - `apps/api/src/usecase/asset-management/sub-categories/sub-categories.service.ts` and `service/asset-management/sub-categories/sub-categories.repository.ts` — create/update of associations; DTO `presentation/asset-management/sub-categories/dto/sub-category-associated-resource.dto.ts` (`SubCategoryAssociatedResourceDto`, nested in `create-sub-category.dto.ts:66–74`).
  - `apps/api/src/usecase/quotations/quotations.service.ts` (resource sync ~1553 `applyGroupRollups` then `syncResources`), `quotation-resource-totals.ts`, `quotation-resource-margins.ts`; DTO `presentation/quotations/dto/create-quotation.dto.ts` (`isGroup` ~:180).
  - `usecase/docusign/quotation-pdf.service.ts` — `getVisibleResources`, `getAdjustmentResources`.
  - `usecase/projects/projects.service.ts` `createJobFromQuotationInTx`, and `usecase/projects/materialize-job-resources.ts`.
  - `usecase/das/` (`das.service.ts`, `missing-required-components.util.ts`, `sub-job.mapper.ts`).
- **New exported functions/services proposed:** none by this spec. Needs forced by the requirements (each a §11b row, none chosen): storing/serving per-association settings; per-parent nested settings; quotation type persistence; visits-aware rollup; excluding group children on conversion; representing visit days.

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| *NOT SPECIFIED — whether any endpoint is new or an existing DTO/response is extended is D10.* | | | | | REQ-01, 04, 05 |

- **Request / response DTO:** `SubCategoryAssociatedResourceDto` and the quotation create/update DTO would gain fields; response shapes returned by `GET` sub-category (raw `parentAssociatedResources`, renamed to `associatedResources` by web `mapSubCategoryRaw`, consumed by mobile `sub-category.contract.ts`) and quotation reads. `NOT SPECIFIED`.
- **Guards / roles:** existing `AccessTokenGuard` + existing sub-category/quotation edit permissions; role changes are TCG-227.
- **Route param identity:** unchanged.
- **Errors:** `NOT SPECIFIED` (e.g. rejecting a Sub item on an association with Mob/Demob Show off).
- **Module registration:** no new module required by any requirement.

## 5. Web surface — `apps/web`

Feature-first; settings tab lives in `src/features/assets/sub-category/` (`associated-assets-tab.tsx`, `associated-assets-tab-content.tsx`, `associated-resource-select.tsx`, `use-sub-category-inline-edit.ts`, `use-create-sub-category-actions.ts`, `associated-asset-tree-preview.tsx`); quote builder in `src/features/quotations/` (`resources-tab*.ts(x)`, `resource-row*`, `views/create-quotation.helpers.ts`, `views/edit-quotation.mapper.ts`, `workspace/detail/detail-format.ts`, `detail-resources-tab.tsx`, `components/organisms/print-quotation*`).

- **Routes:** no new route required by any requirement.
- **Existing components to reuse:** search all nine `components/` directories first (`find-component` skill); nothing is proposed here. `SectionCard`, `Field`, `InfoRow` etc. per `web.md`.
- **New components proposed:** none by this spec (Quotation Type chip beside Price List: reuse `resource-row.amount-cell.tsx`-adjacent price-list UI? **not verified** — developer picks; D11).
- **Table:** `NOT SPECIFIED`.
- **Forms:** react-hook-form + Zod v4 per `web.md`; sub-category forms are hand-built hooks (see siblings).
- **Server state:** TanStack Query v5 — invalidation keys `NOT SPECIFIED`.
- **Colors / spacing:** theme variables only.
- **Copy:** exact strings given by sources only: "Hourly · Quote/Invoice: Show", "Mob/Demob · Quote/Invoice: Show", "Main item", "Sub item", "Hourly", "Hourly w/ Mob", "Mobilization", "Demobilization", "Price Adjustment", "Billing Code missing." (existing). Confirmation popup wording and the chip label text beyond the two values: `NOT SPECIFIED`.

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** none built here. Mobile quote builder parity is **TCG-219 (out of scope)**.
- **Components:** n/a.
- **Offline / sync behavior:** `NOT SPECIFIED`.
- **Touch targets / push:** `N/A`.
- **But reached:** shared pricing and the quotation/sub-category contracts are used by mobile — §11a R2, R4; Q9 asks what the interim must be. Interim rule on record: "until [TCG-219] ships, the mobile builder computes group totals at ×1" (ticket-owner log Q1, `reference`).

## 7. Shared package — `packages/shared`

- **Types added / changed:** `PricedResource` / `getGroupTotal` / `getResourceFinalAmount` / `sumResourceAmounts` in `src/utils/quotation-pricing.ts` currently ignore the group's `qty` — if they change, **web and mobile both change** (REQ-10, Q9). Any new constants (quote-type values) would be consumed by both. `NOT SPECIFIED`; D5.

## 8. Permissions and tenancy

- **Roles permitted:** existing sub-category and quotation edit permissions apply; changing who may edit the settings or switch Quotation Type is **TCG-227** (open). `NOT SPECIFIED` here.
- **Roles denied:** `NOT SPECIFIED`.
- **Tenant isolation:** standard; see §3 tenancy fact — two child models are not in the allowlist.
- **Cross-tenant reads:** none.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| Quantity of a line inside a group | 0 allowed; two decimal places | `decisions/2026-10-01-…` (Joe: fractional; 2 dp ticket owner Q11) | `[UNVERIFIED]` |
| Demob line quantity on mirror/creation | 0 | same (Joe) | `[UNVERIFIED]` |
| Price Adjustment rate | may carry cents; ordinary rates stay whole-dollar | PA note (ticket owner) | `[UNVERIFIED]` |
| Other code-less custom line (in or out of a group) | requires a billing code | PA note | `[UNVERIFIED]` |
| Group quantity (visits) | default 1; editable; **min/max/integer-only: `NOT SPECIFIED`** | visits note ("number of visits") | — |
| Quotation Type | `Hourly` / `Hourly w/ Mob`; default Hourly | type note | `[UNVERIFIED]` |
| Sub-item with Mob/Demob Show off | `NOT SPECIFIED` | — | — |

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit | group amount = visits × sum of ticked lines; unticked and 0 lines excluded; Crane Time ×1; foot-line scaling | REQ-10, 11 |
| Unit | print builder omits group children; foot lines include them | REQ-14 |
| Unit | conversion yields one row per machine; price lines produce none | REQ-16 |
| Integration (API) | settings persist/reload; type persists, duplicate carries it, pre-existing quote reads Hourly; employee backfill | REQ-01, 02, 05 |
| E2E / manual script | build an Hourly and an Hourly w/ Mob quote on the 100 Ton crane; print/PDF; convert; open DAS | REQ-06, 07, 14, 16, 17 |

- Requirements with no testable acceptance criterion: none (no `[OPEN]` requirement remains). TCG-218 has no acceptance criteria and does not meet Definition of Ready (`domain/jira-sop.md`, per `intent.md`); the criteria above are derived from the Scope list and cited notes.
- Existing specs that encode the old behaviour and will need review: `quotation-resource-totals.spec.ts`, `quotation-pdf.service.spec.ts`, `materialize-job-resources.spec.ts`, `packages/shared/src/utils/quotation-pricing.test.mjs`, `apps/web/.../detail-format.test.mjs`, mobile `quotation-pricing.test.ts` and `quotations.mock.test.ts`.

## 11. Non-functional

- **Performance:** `NOT SPECIFIED`.
- **Concurrency:** conversion is guarded by `claimQuotationForConversion` (`convertedToJob` flag) — existing; unchanged.
- **Audit / activity log:** activity log for the settings tab belongs to TCG-220. Existing quotation activity entries: `NOT SPECIFIED`.
- **Migration/rollout order:** schema → API (totals, conversion) → shared → web → (mobile is TCG-219). Because visits-multiplication changes totals everywhere at once, API and web must not ship apart (Q9 covers the mobile gap).
- **PR size:** `.claude/CLAUDE.md` caps a PR at ~400 changed source lines / 25 files, one unit each. **This ticket will not fit one PR.** Forced large units (before decomposition): (a) visits math — ~18 non-test files in four projects (§11a R2), and it must be API-and-web together; (b) conversion + DAS visit days — a new dispatch concept; (c) print + PDF + settings UI + chip. Stacked PRs per the repo rule; the decomposer decides the slices.

## 11a. Ripple — already-shipped behaviour these requirements reach

| # | Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- | --- |
| R1 | Every reader of the quotation DTO / row (web create-edit-detail, mobile contract `quotation.contract.ts`, emails, repository reads) | new Quotation Type field | REQ-05 | additive; older quotes read as Hourly | type note pt 5 | `git grep -l 'priceListSource' -- apps packages` (14 non-test files: API DTO, `quotations.service.ts`, `demo-flows.service.ts`, mobile `quotations.service.ts` and `quote-create.helpers.ts`, web `types/*`, `views/create-quotation*` and `edit-quotation.mapper.ts`) — a proxy for quotation-shape consumers; the contract tracer must run the full pass |
| R2 | Group-total computation: `projects.repository.ts`, `customers/customer-quotation-metrics.ts`, `docusign/quotation-pdf.service.ts`, `notifications/templates/quotation-email-context.util.ts`, `projects/project-quotation-revenue.ts`, `quotations/quotation-resource-totals.ts`, `quotations/quotation-resource-margins.ts`, `quotations.service.ts`, `quotation-approvals.service.ts`, `quotation-signatures.service.ts`, `projects.service.ts` (~1810), web `resource-row.tsx`, `print-quotation.helpers.ts`, `resources-tab.helpers.ts`, `resources-table-money.ts`, `detail-format.ts`, `create-quotation.helpers.ts`, mobile `quotation-pricing.ts`, `quote-create.store.ts`, `quote-create-resources.tsx`, `quotation-financials.ts`, `quotations.mock.ts`, `packages/shared/src/utils/quotation-pricing.ts` | group rollup that ignores group `qty` today | REQ-10 | changes deliberately: one visits-multiplied total on every server surface and web; margins × visits; **mobile**: interim ×1 per ticket-owner log (`reference`) — contradicts "one total" for mobile-saved quotes → **OPEN Q9**; **existing saved quotes** → **OPEN Q2** | visits note rules 6–8 (`reference`); ticket-owner log Q1; | `git grep -l -e applyGroupRollups -e computeQuotationTotals -e getGroupTotal -e getResourceFinalAmount -e sumResourceAmounts -e baseLineAmount -- apps packages` then `git grep -l -e isGroup -e isIncluded -- apps packages` |
| R3 | Web quote builder and views: `resources-tab*.ts(x)`, `resource-row*`, `resources-rows-list.tsx`, `create-quotation.helpers.ts`, `edit-quotation.mapper.ts`, `detail-resources-tab.tsx`; print (`print-quotation*.ts(x)`) | layout by type; mirroring; print filter | REQ-06,07,11,12,14 | changes deliberately; print leaks group children today (code observation) | 10-01 note pt 3 (Joe) | `git grep -l -i mobilization -- apps/web/src`; `git grep -l 'print-quotation' -- apps/web/src` |
| R4 | Sub-category API + DTO + repository + service; web `lib/api/asset-management*`; mobile `sub-category.contract.ts` (`parentAssociatedResources`), `resource-catalog.helpers.ts`, `resource-catalog.mock.ts` | new fields on association rows | REQ-01,02,04 | web: changes; **mobile: unchanged until TCG-219** (code reading, unverified: the mobile builder expands associations from the same list, so it would not apply the new visibility) — source: ticket-owner log Q1 (`reference`) (the quote-visibility rule is then not applied on mobile quotes) | ticket-owner log Q1 | `git grep -l -e parentAssociatedResources -e subCategoryAssociatedResource -- apps/api/src apps/mobile apps/web/src` |
| R5 | Existing association rows and their writers: seeds/demo (`usecase/seed/catalogue-seed.service.ts`, `usecase/staircase-seed/staircase-billing.ts`, `usecase/demo-data/demo-flows.service.ts`, `apps/api/fcc-seeder/…`, `prisma/scripts/remove-optional-materialized-job-resources.ts`) and DAS readers (`das.repository.ts`, `missing-required-components.util.ts`) | defaults/backfill | REQ-02,03 | employee rows → hidden (sourced); all others → **OPEN Q1**; seeds/fixtures: `NOT SPECIFIED` → part of Q1 | employee note pt 2 | same grep as R4 plus `git grep -l SubCategoryAssociatedResource -- apps` |
| R6 | Sub-category create/edit forms: `create-sub-category-layout*.tsx`, `use-create-sub-category-actions.ts`, `use-sub-category-inline-edit.ts`, `associated-assets-tab*.tsx`, `associated-asset-tree-preview.tsx`, activity-log label map `activity-log-format.ts` | new per-row controls | REQ-01,04 | changes deliberately | settings note | `git grep -l associatedResources -- apps/web/src` |
| R7 | Quotation duplicate; `QuotationRevision.snapshot` | type carried on duplicate | REQ-05 | duplicate carries type (sourced); revision snapshot **not specified** | type note pt 1 | `git grep -n -i duplicate -- apps/api/src/usecase/quotations` |
| R8 | Conversion and everything reading `JobResource`: `projects.service.ts` (`createJobFromQuotationInTx`, 3 callers), `materialize-job-resources.ts`, `usecase/das/*`, `service/das*`, `job-holdover*`, `job-progress`, `job-tickets`, payroll, `ticket-*`, `das-loadout` (~50 non-test files) | not copying/duplicating group lines | REQ-15,16,17–20 | changes deliberately for dispatch rows; **what happens to group rows and children as job financial/payroll data → OPEN Q10**; visit days → **OPEN Q13–Q16** | visit-days note (`reference`) | `git grep -l -i jobResource -- apps/api/src \| grep -v -E 'spec\|test'` (50 files) |
| R9 | "Billing Code missing." handling: web `resource-row.rate-column.tsx`, `resources-tab.callbacks.ts`, `use-billing-code-fanout.ts`; mobile `quote-create-resources.tsx` | PA exception inside a group | REQ-13 | changes deliberately on web; mobile → TCG-219 | PA note | `git grep -n -i "billing code missing" -- apps` |

- **Surfaces with no existing behaviour in this area:** *Quotation Type* — `git grep -n -i -E 'hourly_w_mob|quotationType|quotation_type|mobDemob' -- apps packages` returned nothing; no per-association Show settings — none on `SubCategoryAssociatedResource` (read at `schema.prisma:719`); no invoice model — `grep -n -i '^model .*invoice' apps/api/prisma/schema.prisma` returned nothing (so "Quote/Invoice" settings affect no invoice today).
- **Consumers with no source for what happens to them:** R2-existing saved quotes (Q2), R2-mobile (Q9), R5 existing rows and seeds (Q1), R8 group rows/children on the job (Q10), R8 visit days (Q13–Q16), R1 DTO consumers not fully enumerated (ask the contract tracer — `tcg-contract-tracer` is required on this ticket: schema, API shape and `@tcg/shared` all move), R7 revision snapshot (§13).

## 11b. Developer decisions — structure is the developer's call

Options only. *Chosen* and *Decided by* are blank by design.

| ID | Decision | Options (with existing code found) | AI note | Chosen | Decided by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | Where the per-association settings (Hourly Show, Mob/Demob Show, Main/Sub) live | (a) new columns on `SubCategoryAssociatedResource` (`schema.prisma:719`) — types (Boolean, Boolean, String/enum) and defaults per REQ-02/03; (b) a new child table keyed to the association row | One row per (parent, associated) already exists with one-to-one data → (b) is a one-to-one table with no history/lifecycle (the template's test says that is a column). Enum vs string is yours. | (a) three columns on `SubCategoryAssociatedResource`: Hourly Show (bool), Mob/Demob Show (bool), Main/Sub (bool sub-item, false = Main); defaults per REQ-02/03 (hidden). Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D1b | Tenant scoping for the models that carry the settings | `subcategoryassociatedresource` and `quotationresource` are absent from `TENANT_SCOPED_MODELS` (`prisma.service.ts`); options: add `tenantCompanyId` to the new row/table and allowlist it; keep scoping via the parent id in the service; allowlist only | Run `tcg-prisma-guardian` on any schema change. | `tenantCompanyId` on the new nested-settings table (D2) and add it to `TENANT_SCOPED_MODELS`. The missing scoping on the existing association and quotation-line models stays a separate follow-up, not this ticket. Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D2 | Storage for the nested ("also brings along") settings, per parent | (a) a new table keyed (parent association, child association); (b) JSON on the parent association row; (c) columns on the parent association row for ids lists. (vault: per-parent, not on the child row) | (a) is queryable and keeps FKs by UUID; (b)/(c) avoid a table but bury ids in data with no FK. | (a) a new table, one row per (crane's association, nested item) holding Hourly Show, Mob/Demob Show, Main/Sub, with foreign keys. Per parent: a crane's setting for Operator Load's sub-items does not carry over to Operator Load's own configuration or to another crane (ticket owner, session 2026-10-15: "if i set a setting for operator load which is an associated field asset of 100 ton crane so the configuration it has will not carry over for operator load sub-category and it associated fields asset"). | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D2a | D2 detail (U2): how a nested-settings row references the brought-along item, and the table name | (a) FK to the crane's association row + the item's own identity (sub-category / employee type / custom type, exactly one set, mirroring `SubCategoryAssociatedResource`); (b) FKs to both association rows (crane's and Operator Load's); (c) (b) plus changing the whole-list save to update rows in place | `replaceAssociatedResources` (`sub-categories.repository.ts:321`) deletes and recreates a list's rows with new ids on every save, so under (b) re-saving Operator Load's own list would cascade-delete every crane's nested settings for it; (c) rewrites existing save logic. Same shape as `CraftModifierRate` (child keyed by a pair, `tenantCompanyId`, no business code, cascade from parent). Depth: one nested level — Lisette-approved configurations are crane → load trailers → tractor + crew (`vault/dispatch/crane-configuration-rules.md` §1), and local data has nothing below level 2. | (a). Table `sub_category_nested_association_settings`, model `SubCategoryNestedAssociationSetting`: `parent_association_id` → `sub_category_associated_resources.id` ON DELETE CASCADE; `nested_sub_category_id` / `nested_employee_type_id` / `nested_custom_type_id` (exactly one set); the three settings as `BOOLEAN NOT NULL DEFAULT false` (REQ-04 hidden by default); `tenant_company_id` (D1b); timestamps; unique on (parent association, nested item). A row exists only once someone sets it; no row reads hidden. One nested level only. Also a DB CHECK that exactly one nested-item id is set (`ck_sc_nested_assoc_exactly_one_item` (repo `ck_` convention), kept — ticket owner 2026-10-16). Stated by the ticket owner in session 2026-10-16. | Syed Haris (signed on his instruction "Sign D2a, OK all", 2026-10-16) | 2026-10-16 |
| D3 | Quotation Type column | `Quotation` (:1826): String(`VarChar`) vs a Prisma `enum`; nullable vs `NOT NULL DEFAULT 'hourly'`; vault 10-06 note recorded a short string "because the job-type list is not closed" as the ticket owner's earlier choice — confirm or change | The list is not closed (quotations/gaps.md:1086 (a)); a string avoids an enum migration per new type but loses DB validation. | Short string, `NOT NULL DEFAULT 'hourly'`, values validated by the API (`hourly` \| `hourly_w_mob`). Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D3a | D3 detail (U3): column name, where the type values live, what the chip is built from | Column: `quotation_type` vs `type`. Values: `@tcg/shared` constant vs local copies in API and web. Chip: the Price List chip pattern in `resources-pricing-chips.tsx` (private `Chip`/`ChipLabel` + `NativeSelect`) vs two `ToggleChip` pills (`components/molecules/toggle-chip.tsx`) | `@tcg/shared` already holds cross-app constants (`constants/permit-types.ts`); `priceListSource` is a local string today. | `Quotation.quotationType` → `quotation_type VARCHAR(30) NOT NULL DEFAULT 'hourly'`. Values, type and labels in a new `packages/shared/src/constants/quotation-types.ts`, used by the API DTO validation and the web chip (mobile later, TCG-219). The chip is a "Quotation Type" chip beside Price List in `resources-pricing-chips.tsx`, same `Chip`/`ChipLabel` + `NativeSelect` as the Price List chip — `ResourcesPricingChips` props extended, no new component. Stated by the ticket owner in session 2026-10-16. | Syed Haris (signed on his instruction "Sign D3a, OK all", 2026-10-16) | 2026-10-16 |
| D4 | Where the visits number lives | (a) the existing group row `qty` (`QuotationResource.qty Decimal(10,2)`, ignored by rollups today); (b) a new `visits` column | (a) needs no schema change but makes `qty` on group rows carry two meanings across history (Q2). | (a) the existing group row `qty`; saved groups reset to 1 (Q2). Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D5 | Where the visits-aware group maths lives | (a) edit both `packages/shared/src/utils/quotation-pricing.ts` and `apps/api/src/usecase/quotations/quotation-resource-totals.ts` in place; (b) make the API import the shared function (API does not import `@tcg/shared` for this today — verify); (c) new util in `apps/api/src/utility/` | (b) removes a duplicated rollup, but widens a shared export that mobile also consumes (Q9). | Change the existing shared `getGroupTotal` (`packages/shared/src/utils/quotation-pricing.ts`) to visits x sum of included lines, and change the API's own flat-row copy (`quotation-resource-totals.ts`) to the same rule. Ticket owner, session 2026-10-15: "we need this on mobile at one place so would'nt it be good to change existing?" Mobile code is not touched (Q9); mobile has no visits field on a group row and saved groups are reset to 1 (Q2), so mobile totals stay x1 today. Merging the two copies is a possible follow-up. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D5b | How a Mob line is paired with its Demob twin | name match (as `isGroupResourceLabel` matches labels by name today) vs a stored twin link column | Rename detection (REQ-12) is fragile by name. | Match by name in the paired group; on rename the previous name is used. No schema change. Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D6 | Browser-print filtering | (a) filter in `buildPrintLineItems` (`print-quotation.helpers.ts`) mirroring the server's `getVisibleResources`; (b) filter in `print-quotation.model.ts`; (c) share one helper | Server and print should not drift; a shared helper would live in `packages/shared`. | One shared 'customer line items' helper in `@tcg/shared`, used by the server PDF (API) and the browser print (web): lines inside Mobilization/Demobilization hidden, the group line shows visits x rate = amount (Q7). Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D7 | How group lines are kept off the dispatch board | (a) skip group children in `createJobFromQuotationInTx` (`projects.service.ts:373` loop); (b) copy them but flag/exclude at read in `das.repository.ts`/`sub-job.mapper.ts`; (c) copy and mark with a new `JobResource` column | (a) is smallest but changes what job financial/payroll readers (~50 files) see — Q10. | Copy every quote line to the job as today (job financials unchanged) and add one column on `JobResource`, `dispatch`: `REQUIRED` (default, today's behaviour) / `OPTIONAL` / `NONE`, set at conversion: lines inside Mob/Demob `NONE`; equipment in a group that is not in the crane's configuration `OPTIONAL` (Q18, Q16a); everything else `REQUIRED`. DAS completion and the board read it. Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D8 | Representation of "required on first and last day, extra visits allocatable" | derive at read time from `JobSchedule*` + group qty; new `JobResource` columns; a new table of required days | Needs Q13/Q14 first. New concept in DAS: allocate/complete logic changes. | Same column as D7: an `OPTIONAL` slot is allocatable on any day and never blocks allocation completed / Send Tickets (Q13, Q15, Q16a); held items go to all days as holdover does today (Q16). No required-days storage. Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D9 | Identifying the Price Adjustment line | custom type title match (like `isGroupResourceLabel`); billing code `PA` match; a flag on `BillingCodeCustomType` (`schema.prisma:1483`) | Title matching is already how groups are detected; a flag is explicit but needs a column and seed. | Match the custom type's per-tenant code `PA` (`BillingCodeCustomType.billingCodeCustomTypeId`), not its title. No schema change. Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D9a | D9 revised (before U6): how the Price Adjustment line is recognised | (a) by custom-type title "Price Adjustment" (trimmed, case-insensitive), like Mob/Demob groups by name; (b) a flag column on `billing_code_custom_types`; (c) a built-in fixed-name line with no item | D9 as signed cannot work: custom-type codes and billing codes are minted by a sequence (`BCCT-00021`, `BLCD-00052`), so no tenant can have a code `PA` (checked 2026-10-16: none exists, no seed creates one). | (a) By title: a line whose custom type is titled "Price Adjustment" (trimmed, case-insensitive; a shared constant next to `GROUP_RESOURCE_LABELS` in `@tcg/shared`) may have no billing code and a rate with cents; every other code-less custom line is still flagged. No schema change; renaming the type breaks the match (accepted). Admins create the type per tenant (release note); the **demo seed** gets one so it can be demoed. Supersedes D9's "code PA". Stated by the ticket owner in session 2026-10-16. | Syed Haris (signed on his instruction "OK all, sign D9a", 2026-10-16) | 2026-10-16 |
| D10 | API shape | extend `SubCategoryAssociatedResourceDto` and the quotation DTO in place (changes response shape for web+mobile); or a new endpoint for per-parent nested settings | `tcg-contract-tracer` required. | Extend the existing sub-category association and quotation DTOs in place (fields added, none changed); the nested per-crane settings and the crane link travel with the existing sub-category / quotation save. `tcg-contract-tracer` to check every consumer. Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D11 | Quotation Type chip and layout rebuild | web builds rows (catalog in `lib/resource-catalog.ts`) and API stores; or API computes the layout | | Web builds the rows (as today, from the catalog in the Resources tab); the API stores them and computes totals. Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D12 | Pattern | `patterns.md` has no sub-category/quotation entry — follow existing modules, or add a pattern entry (Haris only) | | Follow the existing modules (sub-category association editor, quotation Resources tab); a `patterns.md` entry, if any, comes from the reflection (Haris only). Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D13 | How a crane-named group is tied to its crane (REQ-09) | name/label match (as `isGroupResourceLabel` matches by name); a stored link to the crane's quotation resource (`parentId` is already used for group children) | | A stored link on the group row to the crane line it belongs to (one nullable column on the quotation line); label, ordering (Q17) and dispatch read it. Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D13a | D13 detail (U4): the link column's name and delete behaviour | name `craneResourceId` vs `groupOwnerId`; on delete of the crane line: set null vs cascade | Quote lines keep their ids across saves (`quotations.repository.ts` `syncResources` upserts client-sent ids, the way `parentId` works), so a stored link stays valid. | `QuotationResource.craneResourceId` → `crane_resource_id UUID NULL`, self-relation to `quotation_resources.id`, **ON DELETE SET NULL** (groups fall back to plain "Mobilization"/"Demobilization"); set only on Mob/Demob group rows; null on every existing line. Stated by the ticket owner in session 2026-10-16. | Syed Haris (signed on his instruction "OK all, sign D13a", 2026-10-16) | 2026-10-16 |
| D14 | Stored name of a crane-named group (REQ-09, D13) | (a) stored item name stays "Mobilization"/"Demobilization" and the crane name is prefixed for display from the D13 link; (b) store "90 Ton Crane – Mobilization" as the name and teach every group detector the new form | (a) keeps `isGroupResourceLabel`, totals and Crane Time detection unchanged (resolves the decomposer's U4/U7/U8 stop-and-ask). | (a): stored name stays "Mobilization"/"Demobilization"; display label "<crane> – Mobilization" from the D13 link on the Resources tab, PDF, print, email and signing. Answered "yes" by the ticket owner, 2026-10-15. | Syed Haris (answered in session, 2026-10-15) | 2026-10-15 |

## 11c. Siblings — same pattern, same change?

| Sibling | Pattern | Same change? | Decided by | Enumerated by |
| --- | --- | --- | --- | --- |
| Sub-category **create** vs **detail inline edit** forms (two writers of associations) | none | Yes — both forms get the settings (ticket owner, session 2026-10-15). | Syed Haris (signed on his instruction "sign them", 2026-10-15) | `git grep -l associatedResources -- apps/web/src/features/assets/sub-category` |
| Quotation **create** vs **edit** vs **detail** views (and the print/PDF pair) | none | Yes — all show the same layout and visits; print/PDF via the D6 helper (ticket owner, session 2026-10-15). | Syed Haris (signed on his instruction "sign them", 2026-10-15) | `git grep -l -i mobilization -- apps/web/src/features/quotations` |
| Three quote → job entry points (`createFromQuotation`, `convertQuotationToJob`, `attachQuotationToProject`) all call `createJobFromQuotationInTx` | none | Yes — all three get the dispatch rule (D7); they share `createJobFromQuotationInTx` (ticket owner, session 2026-10-15). | Syed Haris (signed on his instruction "sign them", 2026-10-15) | `git grep -n createJobFromQuotationInTx -- apps/api/src` (3 call sites) |
| Mobile quote builder (TCG-219) | none | No — follow-up TCG-219, per Q9 (ticket owner, session 2026-10-15). | Syed Haris (signed on his instruction "sign them", 2026-10-15) | `git grep -l isGroup -- apps/mobile` |
| Seeds / demo flows creating associations | none | Yes — update the demo seed so Operator Load is shown as a Sub item on the demo tenant, for the demo to Joe/Lisette (ticket owner, session 2026-10-15). | Syed Haris (signed on his instruction "sign them", 2026-10-15) | see R5 |
| Server-side customer documents other than the quotation PDF (emails, signature flow: `quotation-signatures.service.ts`, `quotation-email-context.util.ts`) | none | Yes — quotation email and signing flow use the D6 shared customer-line-items helper (ticket owner, session 2026-10-15). | Syed Haris (signed on his instruction "sign them", 2026-10-15) | R2 grep |

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** Owners are named where a vault note names one; "ticket owner" = Syed Haris.

### Q1 — Existing non-employee associations: shown or hidden?
- **Question:** When the settings arrive, do existing non-employee sub-category associations (asset sub-category and custom-type ones) start shown on both quote types as Main item, or hidden?
- **Why it cannot be answered from what is written:** the settings note gives a default for a *newly picked* direct association and says whether existing ones "should start shown was not asked"; the employee note covers only employee rows.
- **Blocked:** REQ-03 (and the seed/demo behaviour, R5).
- **Candidates:** `decisions/2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md` (7.8 KB, 2026-10-06); `…employee-type-associations-start-hidden…` (3.9 KB, 2026-10-06); `quotations/mob-demob-current-rules.md` (6.1 KB, 2026-10-09).
- **Owner:** ticket owner (Syed Haris); Joe Schacatano for the client view.
- **Workaround, if any:** none that avoids choosing a default.
- **Answer (Syed Haris, ticket owner, 2026-10-14, Claude Code session):** "hidden" — existing non-employee associations (custom-type included) start hidden on both quote types when the settings arrive.

- **Status:** answered by ticket owner 2026-10-14 — decision note pending (`tcg-scrum` writes it); not client-confirmed

### Q2 — Existing saved quotes whose Mobilization group has a stored quantity other than 1
- **Question:** Do saved quotes that already have a Mobilization/Demobilization group start being multiplied by that group's stored quantity (even though they open as Hourly), or does the visits rule apply only to quotes created after release?
- **Why it cannot be answered from what is written:** the notes say saved quotes keep their lines (employee note) and existing quotes are Hourly, but none addresses a total *changing* on an existing quote. Code: group `qty` is stored (`QuotationResource.qty`) and ignored by rollups today, so a stored value other than 1 would change money. I did not inspect data.
- **Blocked:** REQ-10; R2.
- **Candidates:** visits note (7.4 KB, 2026-10-07); type note (5.4 KB, 2026-10-06).
- **Owner:** ticket owner; confirm with Joe if totals of sent quotes would move.
- **Workaround, if any:** apply the multiplier only when the group's quantity was set by the new UI — **labelled workaround, not a decision**.
- **Answer (Syed Haris, ticket owner, 2026-10-14, Claude Code session):** "reset to 1" — saved quotes whose Mobilization/Demobilization group has a stored qty other than 1 are reset to 1 visit, so their totals do not change unexpectedly.

- **Status:** answered by ticket owner 2026-10-14 — decision note pending (`tcg-scrum` writes it); not client-confirmed

### Q3 — Do Sub-item associations fill the groups automatically?
- **Question:** On an Hourly w/ Mob quote, are Sub-item associations added as lines inside Mobilization (and mirrored to Demobilization at 0) automatically when the crane is picked, or does the salesperson add them?
- **Why:** the type and settings notes say Sub items are "a line inside the Mobilization and Demobilization groups"; none says who adds them.
- **Blocked:** REQ-08.
- **Candidates:** type note; settings note; meeting 10-07 §7 (18.3 KB).
- **Owner:** ticket owner.
- **Workaround:** none.
- **Answer (Syed Haris, ticket owner, 2026-10-14, Claude Code session):** "automatically" — Sub-item associations are added into Mobilization automatically (and mirrored into Demobilization at 0).

- **Status:** answered by ticket owner 2026-10-14 — decision note pending (`tcg-scrum` writes it); not client-confirmed

### Q4 — Initial quantity/hours/rate of Mobilization lines
- **Question:** When a Sub-item line first appears inside Mobilization, what are its quantity, hours and rate (e.g. 1, price-list rate)?
- **Why:** 10-01 note settles only Demob (0) and mirrored lines (0); `2026-08-31-quotation-qty-not-das-sets.md` (child default 1) is cited by a note but not read here for Mob.
- **Blocked:** REQ-08.
- **Candidates:** 10-01 note (12 KB); visits note.
- **Owner:** ticket owner / Joe Schacatano.
- **Workaround:** none.
- **Research 2026-10-14 (`tcg-scrum`):** only Demob is sourced — Joe 2026-10-01 30:21, "I'd rather have it all populated 0 so that they have to manually put it in because they're all going to be different." Nothing written for Mob; FCC's template is "set at 0 right now" (Joe 48:46). Owner to decide or ask Joe. Not answered.
- **Answer (Syed Haris, ticket owner, 2026-10-14, Claude Code session):** "demob is 0 if joe has mentioned" — Demobilization lines start at 0 (Joe 2026-10-01 30:21, already sourced in REQ-08/11). **The Mobilization starting value stays open, to be asked of Joe.**

- **Answer (Syed Haris, ticket owner, 2026-10-14, Claude Code session):** "start at 0 we can present and if they want to change we can" — new lines inside Mobilization start at 0, like Demobilization. Ticket-owner decision, to be shown to Joe at the sprint review.
- **Status:** answered by ticket owner 2026-10-14 — decision note pending (`tcg-scrum`); not client-confirmed

### Q5 — Two main cranes on one Hourly w/ Mob quote before TCG-220
- **Question:** Until TCG-220 gives one Mob/Demob pair per crane, what does an Hourly w/ Mob quote with two main cranes show — one shared pair, or block the second crane?
- **Why:** the two-cranes note is client-stated but is TCG-220's scope; nothing says TCG-218's interim.
- **Blocked:** REQ-09.
- **Candidates:** two-cranes note (5.4 KB); `quotations/gaps.md:2635`.
- **Owner:** ticket owner.
- **Workaround:** none.
- **Answer (Syed Haris, ticket owner, 2026-10-14, Claude Code session):** "two pair of mob/demob 90 ton crane mob/demob 250 ton crane mob/demob and reflect on print as well" — each main crane gets its own crane-named Mobilization/Demobilization pair (e.g. "90 Ton Crane – Mobilization"), on the Resources tab and on the customer PDF and print. Client basis: Joe, `decisions/2026-10-07-two-cranes-on-one-job-one-quote-mob-demob-per-crane-options-are-separate-quotes.md`. **Scope change from `intent.md` §5:** the per-crane-pair part of TCG-220 is now in this run; the tab rename and activity log stay out. Follow-up: Q17 (group order).

- **Status:** answered by ticket owner 2026-10-14 — decision note pending (`tcg-scrum` writes it); not client-confirmed

### Q6 — "Sub-items its parent ticked" on Hourly
- **Question:** On Hourly, does "plus any sub-items its parent ticked" mean the "also brings along" rows with Hourly Show ticked under that parent?
- **Why:** the ticket and the type note word it differently.
- **Blocked:** REQ-06 (wording only).
- **Candidates:** type note; nested note (5 KB).
- **Owner:** ticket owner.
- **Workaround:** build per the note's wording.
- **Answer (Syed Haris, ticket owner, 2026-10-15, Claude Code session):** "whatever is hidden it's hidden, what's shown is shown" — on Hourly, an association or "also brings along" row appears exactly when its Hourly Show is ticked; hidden ones never appear.
- **Status:** answered by ticket owner 2026-10-15 — decision note pending (`tcg-scrum`); not client-confirmed

### Q7 — What the group line prints in Qty / Unit / Rate on customer documents
- **Question:** On the PDF and the print, does the Mobilization line show the visits as Qty and the per-visit rate, or "—" in Qty/Unit/Rate with only the amount?
- **Why:** TCG-202 says "one line (its rolled-up amount)". Today the PDF prints the group's qty, the print prints "—"; visits make the number meaningful and customer-visible.
- **Blocked:** REQ-14 (cell content only).
- **Candidates:** TCG-202 text in `intent.md`; 10-01 note; visits note.
- **Owner:** Joe Schacatano / ticket owner.
- **Workaround:** keep each document's current cell content.
- **Answer (Syed Haris, ticket owner, 2026-10-15, Claude Code session):** "Visits × rate = amount" — on BOTH the customer PDF and the browser print the Mobilization/Demobilization line shows the visits as Qty, the per-visit rate and the amount (e.g. Mobilization 3 visit $1,995 $5,985).
- **Status:** answered by ticket owner 2026-10-15 — decision note pending (`tcg-scrum`); not client-confirmed

### Q8 — Twin edge rules (rename/delete)
- **Question:** Confirm the build reading: a twin is left alone while another line in the source group still has its name, and a rename keeps the twin's quantity and re-prices it?
- **Why:** the 10-01 note update labels it a build reading recorded with the answer; Joe was not asked.
- **Blocked:** REQ-12 edge cases.
- **Candidates:** 10-01 note.
- **Owner:** ticket owner.
- **Workaround:** implement only "the twin follows".
- **Answer (Syed Haris, ticket owner, 2026-10-15, Claude Code session):** "Only the basic rule" — renaming or deleting a line in Mobilization renames/deletes its Demobilization twin, and the reverse; no special handling for duplicate names and no quantity rule beyond that.
- **Status:** answered by ticket owner 2026-10-15 — decision note pending (`tcg-scrum`); not client-confirmed

### Q9 — Mobile interim totals
- **Question:** A quote saved from mobile (group totals ×1) and shown on web/server (×visits): is that accepted until TCG-219, or must the shared function stay ×1 for mobile?
- **Why:** ticket-owner log says mobile computes ×1 until TCG-219 while visits note rule 7 says "one total on every surface"; both are `reference`.
- **Blocked:** REQ-10; D5.
- **Candidates:** ticket-owner log (11.4 KB); visits note.
- **Owner:** ticket owner.
- **Workaround:** none.
- **Answer (Syed Haris, ticket owner, 2026-10-14, Claude Code session):** "don't do mobile changes for now" — mobile is out of scope; mobile may show 1-visit totals until TCG-219.

- **Status:** answered by ticket owner 2026-10-14 — decision note pending (`tcg-scrum` writes it); not client-confirmed

### Q10 — Mobilization/Demobilization rows and their children on the job
- **Question:** After conversion, are the Mobilization/Demobilization group rows and their children absent from the job entirely, kept as non-dispatch rows, or kept for job financials?
- **Why:** the visit-days note fixes "no duplicate slots" but not what the job's money/payroll/ticket readers (~50 files) should see.
- **Blocked:** REQ-16; R8; D7.
- **Candidates:** visit-days note (7.2 KB).
- **Owner:** ticket owner; Lisette Anzaldo (DAS).
- **Workaround:** none.
- **Answer (Syed Haris, ticket owner, 2026-10-14, Claude Code session):** "they're dispatched rows, what is in the asset configuration as required, they will show on the dispatch".
- **Answer (Syed Haris, ticket owner, 2026-10-14, Claude Code session):** "dispatch comes from asset configuration, but let's say he added a support load which was not initially required then what? or added a new single asset" — **confirms the reading:** dispatch is driven by the asset configuration, and rows inside Mobilization/Demobilization do not add dispatch slots of their own. His follow-up is Q18.

- **Status:** answered by ticket owner 2026-10-14 (reading confirmed) — decision note pending (`tcg-scrum`); not client-confirmed

### Q11 — Which lines inside a group are dispatchable equipment
- **Question:** Is a line inside a group dispatched exactly when it is backed by an asset sub-category that is not already a Main item on the quote (price lines, Price Adjustment, crew overtime never), and how is "same machine as the main item" decided?
- **Why:** the note says price lines are not dispatched and each machine is one slot, with no rule for telling them apart.
- **Blocked:** REQ-16, REQ-17.
- **Candidates:** visit-days note; 10-01 note.
- **Owner:** ticket owner.
- **Workaround:** none.
- **Answered by Q18:** with the Q10 reading confirmed, whether a group-only or extra machine is dispatched is Q18, answered "yes" on 2026-10-15 (assumption pending Lisette). Q11 is not separately answered.
- **Status:** answered by Q18 (ticket-owner assumption — to be reviewed by Lisette Anzaldo at the demo)

### Q12 — Optional associations and the DAS (09-12 vs Q6/U8)
- **Question:** Should every Optional associated asset become a DAS slot on the job, or only the ones the salesperson kept on the quote?
- **Why:** two unverified developer rulings disagree; Joe/09-16 lean toward U8 without deciding Optional.
- **Blocked:** REQ-15.
- **Candidates:** 09-12 note (9.2 KB, 2026-09-12); ticket-owner log (11.4 KB, 2026-10-07); settings note.
- **Owner:** Lisette Anzaldo / Joe Schacatano (named in the notes); Melissa McNutt (09-12).
- **Workaround:** leave current behaviour (Always Included only).
- **Research 2026-10-14 (`tcg-scrum`):** NOT IN THE VAULT — both rulings are developer rulings. Closest client line: Joe 2026-09-16 7:09, "The billing codes should dictate the resources and the assets for dispatch." Owner: Lisette Anzaldo / Melissa McNutt.

- **Answer (Syed Haris, ticket owner, 2026-10-15, Claude Code session):** "no" — an Optional association left off the quote does not show on dispatch. This takes the 2026-09-12 side (not on the quote → not a DAS slot). **Note:** this reverses his own earlier Q6/U8 ruling in the 2026-10-07 log; Lisette has not been asked.
- **Status:** answered by ticket owner as an assumption — to be reviewed by Lisette Anzaldo at the demo

### Q13 — Which days are the extra visits?
- **Question:** With 3 visits, which calendar days is the group-only equipment required besides the first and last (user picks on the DAS, spread evenly, or every working day between)?
- **Why:** "three visits → three trips" is the ticket owner's, with no day mapping; quote dates are schedule placeholders.
- **Blocked:** REQ-18.
- **Candidates:** visit-days note; `2026-10-06-quotation-dates-are-schedule-placeholders.md` (12.7 KB).
- **Owner:** Lisette Anzaldo (DAS) / ticket owner.
- **Workaround:** implement REQ-17 only.
- **Research 2026-10-14 (`tcg-scrum`):** NOT IN THE VAULT (which days extra visits fall on). "3 visits → 3 trips" is Syed Haris's ruling.

- **Answer (Syed Haris, ticket owner, 2026-10-15, Claude Code session):** "we don't restrict day, where dispatch add it can be sent" — no day restriction for equipment quoted only inside Mobilization/Demobilization; dispatch sends it on whichever days they allocate it. Working assumption; Lisette not asked.
- **Status:** answered by ticket owner as an assumption — to be reviewed by Lisette Anzaldo at the demo

### Q14 — One-day job
- **Question:** On a one-day job, is group-only equipment required once (first day = last day) whatever the visits number?
- **Why:** not stated; Joe's one-day Operator Load 0.5/0.5 is about charging.
- **Blocked:** REQ-17/18.
- **Candidates:** 10-01 note; meeting 10-01 §6.
- **Owner:** ticket owner / Lisette Anzaldo.
- **Workaround:** none.
- **Research 2026-10-14 (`tcg-scrum`):** partly — Lisette 2026-05-21 59:00 (`meetings/transcripts/2026-05-21-crane-configurations-job-tickets.md:400`): "If it's for a single day, yeah, they'll go do the job and then come back to the yard with the crane." (one trip). The 0.5/0.5 is a charge split (Joe 2026-10-01 38:44), not a dispatch rule.

- **Answer (Syed Haris, ticket owner, 2026-10-15, Claude Code session):** "then yes" — on a one-day job it is one trip. Working assumption; Lisette not asked.
- **Status:** answered by ticket owner as an assumption — to be reviewed by Lisette Anzaldo at the demo

### Q15 — Operator Load and Sub-item dispatch days
- **Question:** Is Operator Load (and its tractor and operator) dispatched on the first and last day only like a build-only support load, or every day the crane works?
- **Why:** the visit-days note calls this an interpretation; Joe spoke about charging only.
- **Blocked:** REQ-19.
- **Candidates:** visit-days note.
- **Owner:** Joe Schacatano / Lisette Anzaldo (the note's own wording).
- **Workaround:** none.
- **Research 2026-10-14 (`tcg-scrum`):** partly — Joe 2026-10-01 39:09 (charges): operator load "is only needed to really build up the machine … we only bring it back into our charges on the last day"; Lisette 2026-05-21 59:11–1:00:32: tractor returns after the day-1 build and goes out on the last day, "there might be scenarios where it stays". Extension to every Sub item remains an interpretation.

- **Answer (Syed Haris, ticket owner, 2026-10-15, Claude Code session):** "we don't restrict for now" — no first/last-day restriction for Operator Load or Sub items. Working assumption; Lisette not asked.
- **Status:** answered by ticket owner as an assumption — to be reviewed by Lisette Anzaldo at the demo

### Q16 — Holdover and crew for visit-days items
- **Question:** For a holdover job, how do Make Holdover and Copy Allocations treat a visit-days item on the middle days, and does its crew follow the same days?
- **Why:** the note and `dispatch/gaps.md:1059` (c) say not settled.
- **Blocked:** REQ-20.
- **Candidates:** visit-days note; `dispatch/gaps.md` (193 KB, grep'd at the anchor only).
- **Owner:** Lisette Anzaldo.
- **Workaround:** none.
- **Research 2026-10-14 (`tcg-scrum`):** partly — a crane crew works every day on a holdover (Lisette 57:33 "they still have to do a ticket every single day"; Melissa's provisional answers in `decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md`). Build-only item crews and Copy Allocations: not in the vault (`dispatch/gaps.md:1038`, `:1059`).

- **Answer (Syed Haris, ticket owner, 2026-10-15, Claude Code session):** (1) "whoever is holdover can go to all days" — items marked holdover go to all days, as holdover works today; (2) "go with a" — a slot for equipment quoted only inside Mob/Demob that is NOT marked holdover is optional on the board: allocatable on any day, and an empty slot never blocks "allocation completed" / Send Tickets. Working assumption; Lisette not asked.
- **Status:** answered by ticket owner as an assumption — to be reviewed by Lisette Anzaldo at the demo

### Q17 — Order of the two cranes' groups (non-blocking)

- **Question:** With two cranes, do the groups sit as each crane's Mobilization then Demobilization together, or all Mobilizations then all Demobilizations?
- **Why it cannot be answered from what is written:** Q5 and the layout answer say all crane-named groups sit at the bottom; neither orders them.
- **Blocked:** REQ-09, REQ-21 (ordering only).
- **Candidates:** two-cranes note (5.4 KB, 2026-10-07).
- **Owner:** ticket owner.
- **Workaround, if any:** none needed to start; ordering is cosmetic.
- **Answer (Syed Haris, ticket owner, 2026-10-14, Claude Code session):** "90 Ton Mob, 90 Ton Demob, 250 Ton Mob, 250 Ton Demob" — each crane's pair sits together at the bottom, in the order of the cranes. He says it was discussed in the meeting; the 2026-10-07 transcript supports per-crane separation (Joe 45:24 "if we have two separate assets doing a job and they're both mobilizing, we would want to keep those separate"; Ehtesham 42:13 crane-named labels, Joe 42:33 "Yeah, I mean, you could do that") but states no order. The order is the ticket owner's decision.
- **Status:** answered by ticket owner 2026-10-14 — decision note pending (`tcg-scrum`); not client-confirmed

### Q18 — Equipment added that is not in the crane's configuration

- **Question:** If a salesperson adds equipment not in the crane's asset configuration — inside Mobilization (e.g. a support load to help build) or as its own line (e.g. a single extra asset) — does it appear on the dispatch board to assign, and on which days?
- **Why it cannot be answered from what is written:** the owner's Q10 answer says dispatch comes from the asset configuration; his follow-up asks about additions outside it. The visit-days note covers group-only equipment that is configured, and rules 1–3 are Joe's on a build-only support load, but no source says what happens to an unconfigured addition.
- **Blocked:** REQ-16, REQ-17, REQ-18 (answers Q11).
- **Candidates:** visit-days note (7.2 KB, 2026-10-08); Q10 answer above.
- **Owner:** Lisette Anzaldo (TCG); Syed Haris asked it.
- **Workaround, if any:** none.
- **Answer (Syed Haris, ticket owner, 2026-10-15, Claude Code session):** "yes" — equipment a salesperson adds that is not in the crane's configuration (inside Mobilization, or as its own line) shows on the dispatch board to assign. Working assumption; Lisette not asked.
- **Status:** answered by ticket owner as an assumption — to be reviewed by Lisette Anzaldo at the demo

### Q20 — Allowed values for a group's visits (non-blocking; raised by the decomposer 2026-10-15)

- **Question:** What values may a Mobilization/Demobilization group's visits (the group row `qty`, D4) take — whole numbers only or decimals, and is 0 allowed? (§9 lists "min/max/integer-only: NOT SPECIFIED"; a negative or fractional value changes money.)
- **Why it cannot be answered from what is written:** the visits note says "number of visits" and the default is 1; no source states a lower bound or integer-only. The line quantities inside a group are 0-allowed and 2 dp (REQ-11), which must not be assumed to apply to the group's own quantity.
- **Blocked:** the visits validation row of unit U7 only (REQ-10); every other part of U7 can proceed. Numbered Q20 because "TCG-218 Q19" is already an external Linear reference in §13.
- **Candidates:** visits note (`decisions/2026-10-08-…` per REQ-10 sources); §9 Validation rules.
- **Owner:** ticket owner (Syed Haris); Joe Schacatano if it is a product rule.
- **Workaround, if any:** none; the executor stops at the validation row of U7 rather than pick a bound.
- **Answer (Syed Haris, ticket owner, 2026-10-15, Claude Code session):** "agree but hours you can add 2.5" — a group's visits are whole numbers, at least 1; the lines inside a group keep two-decimal quantities (e.g. 2.5 hours, REQ-11).
- **Status:** answered by ticket owner 2026-10-15

## 13. What this spec deliberately does not specify

- Anything TCG-220 owns: crane-named pairs, the "Field Assets Configuration" rename, its activity log.
- Mobile quote builder behaviour (TCG-219); who may edit settings or switch the type (TCG-227).
- Whether a charged operator is reached by ticking Show on the employee type or only as a Certified Operator code (TCG-218 Q19, unanswered; Owner: Joe Schacatano).
- Whether invoices carry the same lines (`accounting/gaps.md` anchor in `mob-demob-current-rules.md`); no invoice model exists in the repo.
- Whether `QuotationRevision.snapshot` carries the type; the type-switch discard rule.
- Per-machine mob/demob template with minimum quantities, schedule-vs-quote alert (ticket's own Out of scope; "Main item → field-app stays on the job" likewise).
- Mob/Demob source-page authority (`mob-demob-INDEX.md`) — not adjudicated here.

## 14. Sign-off before build

- [ ] Re-diff this spec against the live Linear TCG-218 and TCG-202 text (not done in this run)
- [ ] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person
- [ ] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/` (REQ-15 / Q12)
- [ ] Answers written back into `spec.md` with their new sources and flags
- [ ] Every §12 question updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md`
- [ ] Every §11a ripple row has a source for what happens to that consumer, or a §12 question
- [ ] Every §11b row has _Chosen_ and _Decided by_ filled by a developer
- [ ] Every §11c sibling has a developer's yes / no / follow-up
- [ ] `tcg-prisma-guardian` and `tcg-contract-tracer` run (schema, response shape and `@tcg/shared` move)
- [ ] Decomposed into vertical units — `units.md` (stacked PRs, each ≤ ~400 source lines)

Answered by: ______________  Date: ______________

### Q21 — U1 review: defaults and write paths (raised by tcg-analyst / tcg-prisma-guardian / tcg-contract-tracer on U1, 2026-10-15)
- **Question:** (a) What Show settings does a *newly picked* association start with — hidden (unit U1 acceptance) or, for non-employee picks, shown as Main item (decisions/2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md)? (b) Do the single-association add/update endpoints carry the settings? (c) Does re-picking an item on a row reset its settings? (d) What does Main/Sub mean while Mob/Demob Show is off?
- **Answer (Syed Haris, ticket owner, 2026-10-15, Claude Code session):** (a) "Hidden, like everything" — every newly picked association starts with Hourly Show off, Mob/Demob Show off, Main item, whatever its kind; web, API and seed agree. This departs from the 2026-10-06 decision note's "a direct non-employee association starts shown on both quote types, as a Main item" — the note needs updating (`tcg-scrum`, at close-ticket). (b) "Fix in U1" — single add/update carry and persist the three settings; PATCH leaves an omitted setting unchanged; a whole-list save treats an omitted setting as hidden. (c) "Reset (as built)". (e) Re-adding an association that already exists (single add) keeps any setting the caller omits — "re-adding shouldn't wipe someone's ticks" (Syed Haris, 2026-10-16). (d) Kept as built: Mob/Demob Show off keeps the stored Main/Sub value (control disabled), and the API does not reject it — **units reading the settings (U3 onward) must ignore Main/Sub while Mob/Demob Show is off.**
- **Status:** answered by ticket owner 2026-10-15

### Q22 — Optional and hidden on both quote types (raised in U1 browser review, 2026-10-16)
- **Question:** Is Optional redundant with Show? An Optional association with Hourly Show and Mob/Demob Show both off is never added to a quote (Q6: hidden rows never appear) and so never dispatched (Q12: an Optional left off the quote is not a DAS slot) — it does nothing. Allow it, warn, or block the save?
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** "no ignore, revert this change let's ignore it" — the combination is allowed and the form shows nothing for it (a hint was built and reverted the same day). Inclusion and Show stay separate settings (Inclusion = locked line + always dispatched vs removable; Show = whether it is a quote line). No behaviour or data change.
- **Status:** answered by ticket owner 2026-10-16

### Q23 — U2 build: nested settings outside the whole-list save (raised by tcg-executor on U2, 2026-10-16)
- **Question:** (a) A brought-along item leaves the child's own list (Operator Load drops Tractor-Semi) and is later re-added: should the 100 Ton crane's earlier setting for it come back, or start hidden? *As built: it comes back — the crane's row is keyed by the item's identity and is not removed when the child's list changes.* (b) The single PATCH `/sub-categories/:id/associated-resources/:associationId` can turn a parent's Hourly or Mob/Demob Show off without touching its nested rows (D10 kept nested settings off that endpoint): should that PATCH also clear them, or do readers (U3 onward) treat a nested row under a hidden parent as hidden? *As built: the PATCH leaves them stored; the forms show them disabled and hidden, and the next whole-list save clears them. The web forms do not call that PATCH.*
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** (a) "Comes back" — as built; same spirit as Q21(e). (b) "Readers treat as hidden" — as built: the single PATCH leaves nested rows stored; **every reader from U3 on must read a nested row under a parent hidden on that quote type as hidden**; the next whole-list save clears them.
- **Status:** answered by ticket owner 2026-10-16

### Q24 — U2 review: validation, audit, deletes, reset (raised by tcg-prisma-guardian / tcg-contract-tracer on U2, 2026-10-16)
- **Question:** (a) Should a sent nested setting for an item that is not among the associated sub-category's own associations be rejected? (b) Should a save that changes only nested (or U1) settings write an Activity Log entry? (c) Hard-deleting an employee type / custom type / sub-category referenced only by a nested row fails on the RESTRICT FK — add a clean "in use" error? (d) Should demo-data reset (`clear-tenant-data.ts`) delete the nested table explicitly?
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** (a) "Reject with 400" — on the whole-list save a sent nested item must be one of that association's own associations; rows carried over for items later removed from the child's list are still kept (Q23a). (b) "No log for now" — same as U1's settings; add for both levels together later. (c) "Accept for now" — no hard delete of these exists in app code (archive is soft); the same gap already exists for association rows; follow-up. (d) "Rely on cascade" — verified correct ordering today.
- **Noted, not this ticket:** `apps/api/fcc-seeder/src/lib/reset-tenant.ts` deletes `billingCodeCustomType` (line ~94) before `subCategoryAssociatedResource` (line ~105) — pre-existing RESTRICT failure when an association uses a custom type.
- **Status:** answered by ticket owner 2026-10-16

### Q25 — Q23a and Q24a together on the detail form's save (raised by tcg-executor on U2, 2026-10-16)
- **Question:** The detail inline edit sends back every nested setting it loaded, and a sent array replaces what is stored. Take a crane that holds a setting for an item Operator Load later dropped. Q23a keeps that setting, so the form loads it. Q24a then rejects it as an orphan when it is sent back, so **every save of that crane's Associated Field Assets returns 400** until someone edits the data by hand. Which fix? (1) The API skips the Q24a check for a sent nested row that matches the stored row for that parent and item. Such a row is a carry-over, not a new setting. No web change. (2) The web sends only the items the preview shows, and the API keeps stored rows for items not in the child's list instead of replacing them. This changes "sent = full replace". (3) The web drops orphans on load, so the setting is lost on the next save. This contradicts Q23a for anyone who saves. *As built: the Q24a check is strict, so the 400 happens.* Recommendation: (1).
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** "API skips stored rows" — the Q24a 400 applies only to a sent nested row that is new or changed; a sent row identical to the stored row for the same crane association + item is a carry-over and passes. API only; the web keeps sending the full list. New exported repository method `findAssociatedItemsOf(parentSubCategoryIds)` (batched read of child association lists) — name confirmed by the ticket owner.
- **Status:** answered by ticket owner 2026-10-16

### Q26 — Q25 option 1 when the parent is hidden in the same save (raised by tcg-executor on U2, 2026-10-16)
- **Question:** The form clears a crane's nested settings in its state the moment the parent's Show is unticked (REQ-04), and that includes a kept setting for an item the child has dropped (Q23a). If that setting had both Hourly and Mob/Demob on and only Hourly is unticked on the parent, it goes back to the API with Hourly cleared. Its flags no longer equal the stored row, so the Q25 rule rejects it with 400. Should a sent row that equals the stored row *after the parent's clearing* also pass? The API would clear it on save anyway. *As built: exact equality per Q25, so the save is rejected; unticking the parent's other Show too, or re-ticking it, avoids the 400.*
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** "Allow turning things off" — a sent nested row for an item no longer in the child's list passes when, flag by flag, it is no more ticked than the stored row (each flag true only if stored true); anything new or newly ticked still gets the Q24a 400. Supersedes Q25's "all three flags equal" for these rows.
- **Status:** answered by ticket owner 2026-10-16

### Q27 — U2 analyst: all-off nested row for an item outside the child's list, nothing stored; and builder-chosen names/defaults (raised by tcg-analyst on U2, 2026-10-16)
- **Question:** (a) A sent nested row for an item not in the child's list, with every flag off and no stored row, is a no-op — reject (as built) or ignore? (b) Confirm the builder's names and unstated defaults.
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** (a) "Ignore it" — treated as nothing to store (no row already reads hidden); no 400. (b) "Sign D2a, OK all" — names `nestedSettings` (request/response field), `SubCategoryNestedAssociationSettingDto`, `NormalizedNestedAssociationSetting`, `NestedAssociationPreview`, `findAssociatedItemsOf`; defaults: an all-off nested row is not stored; `nestedSettings` on an employee-type or custom-type association is silently ignored; unticking a parent clears its nested ticks in form state immediately; a nested item may be the crane itself; the create form now shows "Also brings along" with the nested controls.
- **Status:** answered by ticket owner 2026-10-16

### Q28 — U3 build: virtual rows on saved quotes, rows below the nested level, placement (raised by tcg-executor on U3, 2026-10-16)
- **Question:** (a) The quote editor shows, under each row, the catalog associations that are not saved children as unsaved *virtual* placeholder rows (never saved, never printed, not on the job unless edited). As built, those placeholders follow Hourly Show everywhere — so on a quote saved before U3 a placeholder for an association that is now hidden no longer appears. Its saved lines are unchanged: real children always render and keep their Always Included lock, and a re-merge never drops a child. Keeping unfiltered placeholders on saved rows instead (the rows carry `_isNew: false`) would also show hidden placeholders on every quote saved *after* U3 when reopened, against REQ-06. Accept as built? (b) A child row whose parent's item has no association to it (the user added a child row and picked an item): as built its own associations follow their own Hourly Show, like a root row. Or none? (c) Rows two levels below a pick (crane → Operator Load → Tractor-Semi → …): as built the row above decides at every level, so they follow Operator Load's own "also brings along" settings for Tractor-Semi. Or always hidden (D2a: one nested level)? Local data has nothing below level 2. (d) Placement: the chip sits right of Price List; the detail view shows "Quotation Type" as a row in the Main tab's Other Information card, after Billing Type. Confirm? (e) A type change on update reaches the Activity Log through the generic field diff as `quotationType: hourly → hourly_w_mob` (raw values) — acceptable?
- **Why:** none of these is stated by REQ-05/06, D3a or Q6; each is a one-line choice the builder made to finish the unit.
- **Blocked:** nothing — built as described; reversible in the web only.
- **Owner:** ticket owner.
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** (a) "Follow Hourly Show" — as built: virtual placeholders follow Hourly Show on every quote, old or new; saved lines never change. (b) "OK" — as built: a hand-added child row's own associations follow their own Hourly Show. (c) "Always hidden" — nothing below the "also brings along" level auto-appears on a quote (D2a: one nested level). (d) "Chip first, left of Price List" — the Quotation Type chip leads the chip row; detail view as built (Main tab → Other Information, after Billing Type). (e) "Readable labels" — the activity log shows "Quotation Type: Hourly → Hourly w/ Mob", not the raw field/values.
- **Status:** answered by ticket owner 2026-10-16

### Q29 — U3 reviews: builder names, failing child-tree tests, demo-data expansion (raised by tcg-contract-tracer on U3, 2026-10-16)
- **Question:** (a) Confirm the builder's new names. (b) `resources-tab.child-tree.test.mjs` — 8 `buildChildTreeNodes` tests fail once run, because `resources-tab.child-tree.test-fixtures.mjs` builds associations without `showOnHourlyDocuments` / `nestedShownOnHourly` (everything reads hidden); fix now or leave? (c) The API demo-data builder (`usecase/demo-data/demo-flows.service.ts` `expandSet`) expands every association when seeding demo quotes, ignoring Hourly Show — align?
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** (a) "Sign D3a, OK all" — `QUOTATION_TYPE_VALUES`, `QuotationTypeValue`, `QUOTATION_TYPE_LABELS`, `hourlyShownAssociationNames`, `catalogAssociationName`, `nestedShownOnHourlyNames`, new file `lib/resource-catalog.associations.ts`, `getAssociatedAssetsForResource(resource, resources, map)`. (b) "Leave, note in PR" — no-tests rule; the PR lists the failures and the fixture fix for the end-of-feature run. (c) "Align in U3" — seeded demo quotes follow the same Hourly Show rules as the web (one nested level, nested under a hidden parent reads hidden), and the stale comment is fixed.
- **Noted:** mobile still auto-adds every association with no Show filter (Q9 — no mobile changes; TCG-219). Added after (a) was asked, still to confirm: `formatFieldValueFor(field, value)` in `activity-log-format.ts`; `hourlyShownAssociationNames` gains `rowDepth`.
- **Follow-up (ticket owner, 2026-10-16):** the two late names "OK". The demo catalogue (`apps/api/src/utility/demo-data/data/assets.ts`) ticks no Hourly Show, so after U3 every seeded demo quote is the crane line alone — fixed by a **separate small PR right after U3** (Path C): Operator Load and the travel permit shown on Hourly on the demo crane, tractor-semi and operator hidden (units.md U3 demo line).
- **Status:** answered by ticket owner 2026-10-16

### Q30 — The "In total" checkbox on Mob/Demob group lines (raised by the ticket owner in U3 browser review, 2026-10-16)
- **Question:** Lines inside a Mobilization/Demobilization group carry an "In total" checkbox (`resource-row.group-include.tsx`, stored as `QuotationResource.isIncluded`; detail view shows "Excluded"), added 2026-07-07 (`a837101e2`) with no vault or spec source. In the TCG-218 model a line is a Sub item (rolls up) or a Main item, and price changes go through the Price Adjustment line (U6) — keep it?
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** "i don't think i need in total" → **hide it in the web only, in U6**: remove the checkbox and the "Excluded" label from the web; every new group line is counted. The `isIncluded` column and the totals maths stay, so a quote already saved with an excluded line keeps its total (local data has none). Mobile keeps its toggle until TCG-219 (Q9). Full removal (schema, API, PDF, approvals, mobile — ~20+ files) is not part of TCG-218.
- **Status:** answered by ticket owner 2026-10-16

### Q31 — Removing a crane from an Hourly w/ Mob quote (raised before U4, 2026-10-16)
- **Question:** When a salesperson removes a crane line from an Hourly w/ Mob quote, what happens to that crane's Mobilization/Demobilization pair?
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** "Removed with it" — the crane's pair and the lines in it are removed with the crane in the builder; re-picking the crane rebuilds it. (The DB link is SET NULL as a safety net, D13a — the builder does the removal.)
- **Status:** answered by ticket owner 2026-10-16


### Q32 — U4 build: Main-item placement, which lines get a pair, edge cases (raised by tcg-executor on U4, 2026-10-16)
- **Question:** (a) **Main items:** "the item alone, then its Main items as their own lines" — as built they are lines *under* the crane (the Hourly mechanism, filtered to Mob/Demob Show + Main item), so they keep the Always Included lock, convert with the crane and leave with it. Or root lines beside the crane? (Root lines would get duplicate $0 children at conversion — `materialize-job-resources.ts` adds the crane's Always Included associations it does not find under it — and Q31 does not say whether they leave with the crane.) (b) **Which root lines get a pair:** as built, a root pick whose item has at least one Sub item; a crane with no Sub item gets no pair, and other root items (a permit, a forklift) get one only if they have Sub items. Or every root line, or crane sub-categories only? (c) **A nested row set Main under a parent that is a Sub item** (crane → Operator Load = Sub → Tractor-Semi = Main): as built *not added* (stopped — inside the group it would be hidden from the customer, under the crane it is not "with its parent"). Where does it go? (d) **Duplicate:** the link is not carried when a quote is duplicated (`buildResourceCloneData`), so a duplicated Hourly w/ Mob quote shows plain "Mobilization"/"Demobilization" and its pairs no longer leave with their crane. Carry it (remap to the new crane ids, ~10 lines in `quotations.service.ts`)? (e) **Changing or clearing the crane line's item** drops its pair (and any hand edits in it) and rebuilds it for the new item, the way the line's own children are dropped today. OK? (f) **Mobile saves (Q9):** mobile sends no link, and a whole-list save treats an omitted link as none (as with `parentId`), so a mobile save of a web Hourly w/ Mob quote unlinks its pairs. Accept until TCG-219? (g) **API message** for a link to a row not in the same save: "Invalid resources hierarchy. A group must reference a crane row in the same quotation." (400). OK? (h) **Group lines are removable** (no Always Included lock inside a group, because the lock cannot be re-derived after reload) and **lines inside a group list no rows under them** (a group total counts its direct lines only). OK? (i) Names to confirm: `craneResourceId` (DTO/types), `_displayLabel` (client-only), `ShownAssociationNames`, `DEEPEST_AUTO_ROW_DEPTH` now exported, `mobDemobSettings`, AssociatedAsset fields `showOnMobDemobDocuments` / `mobDemobSubItem` / `nestedMobMain` / `nestedMobSub`, file `resources-tab.mob-layout.ts` with `createResourceUpdateForQuoteType`, `associatedAssetsLookup`, `removeCraneMobPair`, `craneGroupLabels`; `getAssociatedAssetsForResource` gains an optional 4th parameter.
- **Why:** none of these is stated by REQ-07/08/09/21/22, D13/D13a/D14 or Q31; each is a choice the builder made to finish U4, reversible in the web (a–c, e, h) or the API (d, f, g).
- **Blocked:** (c) only — not built. Everything else is built as described.
- **Window not in units.md (U4 → U6):** an auto-filled line at quantity 0 fails today's web save check ("Quantity must be greater than 0", and the input shows integers only), so an Hourly w/ Mob quote with Sub items cannot be saved until each group line is above 0 — Demob twins included — until U6 allows 0 and two decimals. The API already accepts 0.
- **Owner:** ticket owner.
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** (a) "Under the crane" — as built: Main items are child lines of the crane (Always Included lock, convert and leave with it). (b) "Items with a Sub item" — as built: a picked item gets a pair only when it has at least one Sub item. (c) "Follows its parent" — a nested row set Main under a parent that is a Sub item goes into the Mobilization group with that parent (a Sub line, twin in Demobilization). (d) "Carry it" — duplicate remaps the link to the new quote's crane line ids (`buildResourceCloneData`), in U4a. (e)–(i) "OK all" — changing/clearing the crane's item drops and rebuilds its pair; a mobile save unlinks pairs until TCG-219; the 400 message as written; group lines removable and list no rows under them; the builder's names as listed. **Window U4→U6:** "Accept, no deploy between" — auto-filled group lines at 0 cannot be saved by the web until U6 allows 0; U4 and U6 merge normally but nothing deploys until U6 is in (deploy.yml is manual); the PRs say so.
- **Status:** answered by ticket owner 2026-10-16

### Q33 — U4 reviews: link rules, re-pick, ordering, deploy order, a pre-existing id hole (raised by tcg-prisma-guardian / tcg-contract-tracer / tcg-analyst on U4, 2026-10-16)
- **Question:** (a) Should the API enforce the link's shape (only Mob/Demob group rows carry `craneResourceId`; target is a top-level non-group row)? (b) A deleted group line comes back when the same crane item is re-picked — OK? (c) Drag-reorder and add-row can move groups out of "last / crane order" (only a pick re-sorts). (d) Tests deferred? (e) Deploy order. (f) Pre-existing: `quotations.repository.ts` `syncResources` upserts lines by client-sent id without checking the existing row belongs to the quotation, so a crafted id could move another quotation's (or tenant's) line.
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** (a) "Enforce in U4a" — extend the hierarchy 400 check. (b) "Comes back" — a re-pick fills in missing Sub items. (c) deferred to U5 (no change in U4). (d) deferred — standing no-tests rule; the PRs list the unverified acceptance lines. (e) the web sends `craneResourceId` on every line from U4a on and the API forbids unknown fields, so **the API deploys before or with the web**; and nothing deploys between U4 and U6 (Q32). (f) "Separate PR now" — a Path B fix outside TCG-218, not inside U4.
- **Noted for later units:** customer PDF / print still show plain "Mobilization"/"Demobilization" (U8); the job Resources tab and conversion don't carry the link (U9); the index on `crane_resource_id` is kept (SET NULL lookups on delete).
- **Status:** answered by ticket owner 2026-10-16

### Q34 — U5: what a type switch rebuilds; old groups; groups-last; copy (raised before U5 after the U1–U4 end-to-end test, 2026-10-16)
- **Question:** (a) After the user confirms a Quotation Type switch, what happens to existing crane lines? (b) Old quotes carry Mobilization/Demobilization groups with no crane link — what happens to them on a switch? (c) Enforce "groups last" on drag and Add line (deferred from U4, Q33c)? (d) Confirmation copy.
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** (a) "Re-lay out, keep edits" — each crane's auto lines are re-arranged for the new type (Hourly→Mob: Sub items move into a new linked pair, Main items stay under the crane; Mob→Hourly: the crane's linked pair is removed and its Hourly children added); a line that exists in both layouts keeps its qty/rate/comments; hand-added lines stay where they are. The confirmation is asked whenever the quote already has lines; an empty quote switches without asking (U5 note, 2026-10-15). (b) "Leave untouched" — unlinked groups are ignored by the rebuild. (c) "Enforce in U5" — on Hourly w/ Mob new lines insert above the groups, lines can't be dragged among/below the groups nor groups above lines, and crane order of pairs is re-applied after any drag. (d) Proposed copy: title "Change Quotation Type?", body "Switching to <type> rebuilds this quote's lines for the new layout. Lines you added by hand are kept.", buttons "Cancel" / "Change type".
- **Found in the U1–U4 end-to-end test (for U6):** QUOT-00022 and QUOT-00023 (local) each hold six pre-TCG-218 Mob/Demob lines at quantity 0, so the web cannot save those quotes at all today ("Quantity must be greater than 0"); U6's "0 allowed inside groups" must cover saved lines too.
- **Status:** answered by ticket owner 2026-10-16

### Q35 — U5 build: split at the size cap; header-row choices; what the switch rebuild needs answered (raised by tcg-executor on U5, 2026-10-16)
- **Size:** header rows, default collapse and groups-last measure **362 source lines in 14 files** against `origin/main`. The type-switch rebuild (Q34a) is estimated at **~250 more**: a relayout module (~110), dialog and hook (~55), and moving `ResourcesTab`'s catalog lookups into a hook to stay under the 200-line function limit (~85). Proposed split: **U5a** = header rows + collapse + groups-last (built); **U5b** = switch confirmation + re-layout, stacked on U5a's branch. The chip still switches without asking until U5b.
- **Question (U5a choices as built — confirm):** (a) **Visits** on the header is the group row's stored quantity (D4). New groups show 1; a saved group with another quantity shows that number until U7. The number sits in the Quantity column with an `aria-label` of "Visits" and no visible caption. Should it have a caption, and what copy? (b) **Header total** is the group's Amount-column value: the base of its included lines, with discount, price hike and surcharge staying footer rows, as today's group row shows. (c) **The header shows the name as text** with no item picker, so a group's item can no longer be changed from the row on Hourly w/ Mob. It keeps today's comments input, trash (with confirm), drag handle and hover "+ new item". (d) **Crane Time** groups are not header rows and are not collapsed, and for groups-last they count as ordinary lines (REQ-21 names Mobilization/Demobilization only). (e) **Collapse** happens once per visit to the Resources tab. Leaving the tab and coming back collapses the groups again, the same way coming back re-expands everything else today. A group with a line in error still auto-expands on save. The detail view opens collapsed. (f) **Groups-last:** a top-level line and a Mobilization/Demobilization group can never take each other's place, in either direction. Groups reorder among themselves, but linked pairs snap back to crane order after any drop, so an unlinked group ends up above the linked pairs. Add line inserts after the last non-group top-level line. A quote that is already out of order (an old unlinked group mid-list) is not re-sorted when it opens. (g) **Test IDs:** create/edit header `quotations-resource-group-header` (+ `-toggle`, `-label`, `-visits`, `-total`). On the detail view, the header toggle is `quotations-detail-group-header-toggle` and the row carries `data-group-header`. The detail header's total keeps the row's existing `quotations-resource-amount`, because wrapping it in a new ID re-indents ~17 lines. (h) **Names:** `ResourceGroupHeaderGrid` (new file `resource-row.group-header.tsx`), `isMobDemobGroupRow`, `orderMobGroupsLast` (now exported), `rowDropTargetProps` and `RowRemoveButton` (extracted from the row grid into `resource-row.cells.tsx`), `ReorderableResourceMeta.isMobDemobGroup`. New props: `isGroupHeader` (row view/content/grid; detail row), `groupHeaders` (rows list), `collapseGroups` (`useDefaultExpandAll`), `groupsLast` (`useResourceRowMutations`, `useResourcesDragDrop` 2nd argument), `RowActionCell.testId`, `RowLeadingControls.toggleTestId`.
- **Question (U5b, needed before it is built):** (i) **Hand-added lines whose place disappears.** Mob→Hourly removes the crane's linked pair, and a line someone added inside it with "+ new item" has nowhere to stay. Hourly→Mob moves an auto line into the group (group lines list nothing under them, Q32h), or drops it, and a line hand-added under it has the same problem. Should such lines move under the crane, keep their group (Mob→Hourly only), or be dropped? Proposal: under the crane. (ii) **Auto vs hand-added** is not stored. Proposal: decide by name. A line is auto when its name is one of its parent item's catalog associations (the rule `suppressReplacedChildAssociation` already uses), or, inside a linked group, one of the crane's Sub items. A hand-added line that carries an association's name is then treated as auto. (iii) **Lines deleted in the old layout** (`suppressedChildNames`). Proposal: they stay deleted after the switch. A re-pick brings them back (Q33b); confirm the switch should differ. (iv) **Auto lines that belong to neither layout** (shown on Hourly, Mob/Demob Show unticked, or the reverse) are dropped along with their edits. OK? (v) **"Same line"** — proposal: match by item name within the crane's lines, first match wins, a Mobilization line before its Demobilization twin (the twin is dropped on Mob→Hourly). The carried line keeps its id, so its Additional Information survives, and keeps every pricing field: qty, rate, unit, discount, price hike, surcharge, comments, and the "In total" flag. New lines are priced as a pick (price list, else billing code), and Demobilization twins start new at 0. (vi) **"Has resource lines"** = at least one top-level row, blank or not; a new quote starts with none. (vii) The dialog's "Change type" button is disabled, with no message, while the catalogs load; without them every line would read as hand-added. (viii) **Dialog test IDs:** the shared `ConfirmDeleteModal` hardcodes `confirm-modal-confirm` / `confirm-modal-cancel`, and `qa-automation`'s `ConfirmModal` page object drives every confirmation through them plus the title. Reuse those as they are, or extend the modal with call-site IDs (e.g. `quotations-type-switch-confirm`) and give this dialog its own page-object method? (ix) The rebuild runs over every top-level non-group line with an item, not only cranes, since a pair is built for any item with a Sub item (Q32b). OK?
- **Why:** none of (a)–(h) is fixed by REQ-21, Q34 or D4/D14; (i)–(ix) are not stated by Q34a ("re-lay out, keep edits; hand-added lines stay where they are").
- **Blocked:** U5b (i), (ii), (viii), and the split itself — **developer's call**. U5a is built and reversible in the web only.
- **Owner:** ticket owner.
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** Split "Yes, U5a + U5b" (U5b stacked on U5a). U5a (a)–(h) "OK all as built" (visits caption arrives with editable visits in U7). U5b: (i) "Dropped" — a hand-added line whose place the new layout removes (e.g. inside a linked pair on Mob→Hourly, or under an auto line that moves into a group) is dropped with it. (ii) "By name" — auto when its name is one of its parent's catalog associations or, inside a linked pair, one of the crane's Sub items. (iii)+(iv) "OK both" — lines deleted in the old layout stay deleted (a re-pick refills, Q33b); auto lines belonging to neither layout are dropped with their edits. (v)+(vi)+(vii)+(ix) "OK all" as proposed. (viii) "Reuse shared IDs" — `confirm-modal-confirm` / `confirm-modal-cancel`, found by the title. **Copy updated (supersedes Q34d body):** "Switching to <type> rebuilds this quote's lines for the new layout. Lines you added by hand are kept, except lines inside a Mobilization or Demobilization group the new layout removes."
- **Status:** answered by ticket owner 2026-10-16

### Q36 — U5b build: quantity of lines leaving a group, button colour, and as-built details (raised by tcg-executor on U5b, 2026-10-16)
- **Question:** (1) Mob→Hourly carries a Sub line back under the crane with its group quantity, usually 0, which the web cannot save. (2) "Change type" uses the shared modal's red danger style. (3) As built: a leftover linked pair on an Hourly quote (from a switch before U5b) is reused on Hourly→Mob; deleted-name rules (a name deleted only from Mobilization comes back on Mob→Hourly as the carried Demobilization twin); after a rebuild the new layout's lines come first, then hand-added ones; `ResourcesTab` sits at exactly its 200-line limit; names `relayoutForQuoteType` / `QuoteTypeRelayout` (`resources-tab.type-switch.ts`), `useQuotationTypeSwitch` (`hooks/use-quotation-type-switch.ts`), and four U4 builders now exported (`buildMobSubLineNodes`, `pairGroup`, `groupLine`, `shownNamesFor`).
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** (1) "0 becomes 1" — a carried line keeps its quantity unless it is 0, then it gets 1 (a pick's default); its other fields are still carried. (2) "Keep red". (3) "OK all" as built.
- **Status:** answered by ticket owner 2026-10-16

### Q37 — U5b review: same item name at two levels under one line (raised by tcg-analyst on U5b, 2026-10-16)
- **Question:** (F1) The rebuild matches carried lines by name across the whole line, so when one name exists at two levels (Operator under the crane and Operator under Tractor) a slot can take the other level's line and its qty/rate/notes. (F2) Deleted names are collected line-wide, so a name deleted at one level stays deleted at the other levels too.
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** (F1) "Fix: match by parent first" — a slot first takes a same-named old line from the same parent, then from anywhere under the line. (F2) "Accept as built" — deleted stays deleted line-wide; a re-pick refills.
- **Status:** answered by ticket owner 2026-10-16

### Q38 — U6 build: twins on unlinked groups, Price Adjustment outside a group, server-side billing-code rule, as-built details (raised by tcg-executor on U6, 2026-10-16)
- **Question:** (a) **Twins on unlinked groups.** The twin rule (add mirrors at 0; rename/delete follow, both directions) is built for a crane's **linked** pair only (D13 `craneResourceId`). Old quotes (QUOT-00022/23) and any quote with plain "Mobilization"/"Demobilization" groups have no link, and nothing says which Demobilization group is a Mobilization group's partner when there are several. Apply the rule there too (pair the first Mobilization with the first Demobilization when the quote has exactly one of each), or leave unlinked groups without twins (as Q34b left them out of the rebuild)? (b) **Price Adjustment outside a Mob/Demob group.** REQ-13 and the PA note make it the one hand-priced line *inside* a group; a PA line elsewhere (top level, under a crane, in Crane Time) is not addressed. As built it keeps today's rule there ("Billing Code missing.", whole-dollar rate). Keep, or exempt PA anywhere? (c) **Server-side billing-code rule.** units.md U6 lists an API check ("other code-less custom line rejected"), but the API today has no billing-code or whole-dollar check at all (only the web blocks). Not built: should the API reject a code-less line, and if so (i) by trusting the client's `pricingSource: 'none'` or by looking the custom type's billing codes/price-list items up on the server, (ii) custom types only (REQ-13's wording) or every type (the web flags every code-less type), and (iii) should it also start enforcing whole-dollar rates for ordinary lines? Mobile saves would be checked too. (d) **As built — confirm:** PA rate must still be greater than 0 (only the whole-dollar rule is lifted; is a 0 or negative "credit" PA wanted?); PA is recognised by the line's own name plus a custom-type FK (the name the line was picked under), not by re-reading the type's current title; on add, no twin is added when the partner group already has a line of that name, and the twin is appended last in Demobilization; a rename whose twin is missing does nothing; clearing a line's item leaves its twin; a renamed twin is re-priced like a pick (new item's rate) and keeps its quantity; a group-line quantity shows as typed ("0", "0.5", not "0.00"); API 400 text: `Quantity of "<item>" in a Mobilization or Demobilization group can have at most two decimal places.`; the demo seed's PA type has an empty description and also reaches the Crane Guys default-tenant seed (`seed-data.ts` reuses `DEMO_BILLING`); names `PRICE_ADJUSTMENT_LABEL`, `isPriceAdjustmentLabel` (`@tcg/shared`), `findGroupLineQuantityViolation` (API), `isHandPricedGroupLine`, `removeGroupLineTwin`, `createResourceUpdateWithTwins` (`resources-tab.group-twin.ts`), `applyCraneMobPair` now exported, props `fractional` / `allowCents`.
- **Why:** (a) D5b says "match by name in the paired group" and every pair it was written for is linked; (b) REQ-13 / D9a scope the exception to "inside a Mob/Demob group" only; (c) no source says how the server tells a line is code-less, and the existing API never checked; (d) builder choices, not stated by REQ-11/12/13, Q8 or D9a.
- **Blocked:** (a) twins on unlinked groups; (c) the API billing-code check. Everything else is built.
- **Owner:** ticket owner.
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** (a) "No, linked pairs only" — the twin rule mirrors only within a crane's linked pair; unlinked old groups behave as today. (b) "Inside groups only" — a Price Adjustment line is exempt from "Billing Code missing." and whole-dollar only inside a Mobilization/Demobilization group. (c) "No, follow-up" — the API keeps not checking billing codes or whole-dollar rates; logged in `vault/quotations/gaps.md`. (d) "OK all, sign D9a" — PA rate > 0; PA recognised by name + custom-type link; rename/delete mirror both ways (REQ-12/Q8 "and the reverse"), add mirrors Mob→Demob only; the API 400 text; the builder's names (`PRICE_ADJUSTMENT_LABEL`, `isPriceAdjustmentLabel`, `findGroupLineQuantityViolation`, `isHandPricedGroupLine`, `removeGroupLineTwin`, `createResourceUpdateWithTwins`, exported `applyCraneMobPair`, props `fractional` / `allowCents`).
- **Status:** answered by ticket owner 2026-10-16

### Q39 — U6 end-to-end test and contract trace: PA twin rate, legacy "Excluded", seed scope, mobile (raised 2026-10-16)
- **Question:** (1) The Demobilization twin of a Price Adjustment line is created with no rate (no billing code to price from), and "PA rate > 0" then blocks every save. (2) Removing "In total"/"Excluded" (Q30) also removed the detail view's cue on legacy lines saved as excluded (not counted, but now look included); Crane Time children lost the checkbox too. (3) The demo-billing seed also gives the Crane Guys seeded tenant a Price Adjustment type. (4) Mobile (untouched, Q9): a pasted group quantity with more than two decimals now gets the API 400; mobile cannot save a web quote that has group lines at 0 or a Price Adjustment with cents (its own validation rejects them).
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** (1) "Twin copies the rate" — a Price Adjustment twin takes its Mobilization line's rate when created, and the source's rate when it is first entered if the twin's is still empty. (2) "Keep 'Excluded' badge for legacy" — the detail view shows "Excluded" on a line whose `isIncluded` is false; no checkbox anywhere on web. (3) "OK, keep". (4) "Note for TCG-219" — mobile follow-ups: clamp group quantities to two decimals; accept 0 inside Mob/Demob groups; accept a Price Adjustment cents rate inside groups.
- **As built (U6, PR #802 — to confirm):** (1) the twin is not filled at creation, because the Mobilization line's rate is still 0 when its item is picked; instead the twin follows the Mobilization rate on each edit while the twin's rate is empty or still equal to the previous source rate, and stops once edited by hand. Verified in the browser 2026-10-16 (25.50 followed; twin hand-set to 40 stayed at 40 when Mobilization went to 60).
- **Status:** answered by ticket owner 2026-10-16

### Q40 — U7 before build: reset migration, group-kind detection, visits enforcement, split (raised 2026-10-16)
- **Question:** (1) The Q2 reset migration `reset_group_visits_to_one` is one-way: plain reset, snapshot old values first, or no migration? (2) How does the visits multiplier tell a Mob/Demob group from Crane Time — stored name, crane link, or name on Hourly w/ Mob quotes only? (3) Where is Q20 (whole visits, at least 1) enforced — web + API, or web only? (4) If U7 goes over 400 source lines?
- **Why:** units.md U7 names (1) and (2) as the developer's call and (4) as the at-risk split line; (3) Q20 gives the rule but not where it is enforced.
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** (1) "Plain reset" — UPDATE only Mob/Demob group rows with qty ≠ 1; Crane Time untouched; the PR carries a pre-deploy count query (local data: 0 rows to reset). (2) "Stored name, any quote type" — a group row named Mobilization/Demobilization (stored names unchanged, D14; same rule as U4a's API check), linked or not, on any quote type. (3) "Web + API 400" — the header input takes whole numbers ≥ 1; the API rejects a Mob/Demob group row qty that is not a whole number ≥ 1. (4) "Split U7b if needed" — approval margin (`quotation-resource-margins.ts` + approvals) moves to a stacked U7b.
- **Status:** answered by ticket owner 2026-10-16

### Q41 — U7 review and end-to-end test: visits input, error copy, rename into a group, spec typing (raised 2026-10-16)
- **Question:** (1) Typing "2.5" in the visits box gives 25 visits (the dot is dropped). (2) The web visits error reuses "Quantity must be greater than 0"; the API says "Visits of the "<group>" group must be a whole number of at least 1." — and the builder's new names (`getGroupVisits` in `@tcg/shared`, `findGroupVisitsViolation` in the API, `ResourceQuantityInputBlock` props `testId`/`ariaLabel`, `ResourceGroupHeaderGrid` props `fieldErrors`/`onFieldBlur`) have no row. (3) A line with quantity 8 or 2.5 whose item is changed to Mobilization/Demobilization becomes a group with 8 visits (or gets the 400), on web and mobile. (4) Making `resourceType`/`qty` required on `ResourceTotalRow` stops three API spec files from type-checking.
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** (1) "Stop at the dot" — keystrokes after a "." are ignored, so "2.5" stays "2". (2) "Visits must be at least 1, OK names" — web text "Visits must be a whole number of at least 1"; the builder's names are accepted. (3) "Web now, mobile in TCG-219" — on web a row resets to quantity 1 when it becomes a Mob/Demob group (U7); mobile gets the same with its other visits items under Q9/TCG-219: cost basis x visits, a visits display and input on the group card and detail, the reset on rename. (4) "Add the fields to the fixtures" — the three spec files' sample rows get `resourceType`/`qty`; nothing is run.
- **Follow-ups noted, not in U7:** approval margin and detail cost basis count unticked group lines (before U7 too, now x visits); the group-kind rule is kept in three copies (shared, API, web); an unlinked group on an Hourly quote multiplies by a quantity the user cannot edit there (locked cell; new groups are 1); QUOT-00017's list total ($2,589.44) differs from its stored total ($4,495.68) — no groups, not U7.
- **Status:** answered by ticket owner 2026-10-16

### Q42 — The crane itself inside its Mobilization/Demobilization pair (raised by the ticket owner in U7 browser review, 2026-10-16)
- **Question:** On an Hourly w/ Mob quote the crane is not inside its own Mobilization group — the groups hold only its Sub-item associations (REQ-07, type note point 3). FCC's Hourly w/ Mob template (`vault/quotations/fcc-estimate-templates-by-job-type.md` §2) puts the crane as the first line of both blocks ("Travel in and Build up" / "4 Hour Minimum Portal to Portal") as well as its own hours line. Should ours? And which items get a pair?
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** "Yes, auto-added first" — picking the item on an Hourly w/ Mob quote also puts **the item itself as the first line of its Mobilization group** (same item, priced like any new group line — customer price list, else billing code — at quantity 0, REQ-22), with its Demobilization twin at 0 (D5b); the item also stays as its own line on top. **Pair scope unchanged (Q32b, "Keep Q32b")**: only an item with at least one Sub item gets a pair; an item with no Sub items still has none. FCC's per-block comments are not adopted (lines start with no comment). **Amends** `decisions/2026-10-06-quotation-type-hourly-or-hourly-with-mob.md` point 3 and REQ-07 ("its Sub items" → "the item itself, then its Sub items"). Built as unit **U4d** before U8.
- **Status:** resolved — see `decisions/2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md`. Its two "not settled" points are already covered: the line is inside the group, so customer documents hide it (REQ-14, U8) and visits multiply it like every ticked line (REQ-10).

### Q43 — U4d as built: structure, saved quotes, re-pick order, all Sub lines deleted, unlinked item (raised by tcg-executor and tcg-analyst on U4d, 2026-10-16)
- **Question:** (1) New file `resources-tab.mob-item-line.ts` (`withItemLineFirst`, `joinGroupLines`), `resolveItemFks` newly exported from `resources-tab.callbacks.ts`, a 5th parameter on `updateCraneMobPair`; `mob-layout.ts` and `callbacks.ts` both at their 300-line limit. (2a) Saved Hourly w/ Mob quotes gain the item line only on a re-pick or a type switch; (2b) a refilled item line goes first; (2d) a hand-added line with the item's name inside a linked pair counts as the item line on a switch. (3) With every Sub line deleted, a type switch builds no pair (Q35 deleted-stays-deleted). (4) An item with no catalog link would get an unpriced, link-less item line.
- **Answer (Syed Haris, ticket owner, 2026-10-16, Claude Code session):** (1) "OK as built" — names accepted; the next unit touching `mob-layout.ts` or `callbacks.ts` splits it first. (2) "Accept all three" — no back-fill of saved quotes (said in the PR). (3) "Keep: no pair". (4) "Add the skip" — no item line when the item has no catalog link (the pair keeps its Sub items), like an unlinked Sub item.
- **Ripple to U9 (noted in units.md):** the item line carries the crane's `subCategoryId` inside a Mobilization group; U9's dispatch rule must key "lines inside Mob/Demob -> NONE" on the parent group, not the sub-category, so the crane's own Mob line does not become an extra slot.
- **Status:** answered by ticket owner 2026-10-16
