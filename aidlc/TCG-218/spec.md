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
| REQ-07 | Hourly w/ Mob layout: item alone, Main items, Mob/Demob groups at the bottom | web / api | `[UNVERIFIED]` | type note; 10-01 note pt 9 | no |
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

- **Statement:** On an Hourly w/ Mob quote the item appears alone, its Main-item associations as their own lines, then the Mobilization and Demobilization groups (its Sub items) at the bottom.
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
| D3 | Quotation Type column | `Quotation` (:1826): String(`VarChar`) vs a Prisma `enum`; nullable vs `NOT NULL DEFAULT 'hourly'`; vault 10-06 note recorded a short string "because the job-type list is not closed" as the ticket owner's earlier choice — confirm or change | The list is not closed (quotations/gaps.md:1086 (a)); a string avoids an enum migration per new type but loses DB validation. | Short string, `NOT NULL DEFAULT 'hourly'`, values validated by the API (`hourly` \| `hourly_w_mob`). Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D4 | Where the visits number lives | (a) the existing group row `qty` (`QuotationResource.qty Decimal(10,2)`, ignored by rollups today); (b) a new `visits` column | (a) needs no schema change but makes `qty` on group rows carry two meanings across history (Q2). | (a) the existing group row `qty`; saved groups reset to 1 (Q2). Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D5 | Where the visits-aware group maths lives | (a) edit both `packages/shared/src/utils/quotation-pricing.ts` and `apps/api/src/usecase/quotations/quotation-resource-totals.ts` in place; (b) make the API import the shared function (API does not import `@tcg/shared` for this today — verify); (c) new util in `apps/api/src/utility/` | (b) removes a duplicated rollup, but widens a shared export that mobile also consumes (Q9). | Change the existing shared `getGroupTotal` (`packages/shared/src/utils/quotation-pricing.ts`) to visits x sum of included lines, and change the API's own flat-row copy (`quotation-resource-totals.ts`) to the same rule. Ticket owner, session 2026-10-15: "we need this on mobile at one place so would'nt it be good to change existing?" Mobile code is not touched (Q9); mobile has no visits field on a group row and saved groups are reset to 1 (Q2), so mobile totals stay x1 today. Merging the two copies is a possible follow-up. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D5b | How a Mob line is paired with its Demob twin | name match (as `isGroupResourceLabel` matches labels by name today) vs a stored twin link column | Rename detection (REQ-12) is fragile by name. | Match by name in the paired group; on rename the previous name is used. No schema change. Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D6 | Browser-print filtering | (a) filter in `buildPrintLineItems` (`print-quotation.helpers.ts`) mirroring the server's `getVisibleResources`; (b) filter in `print-quotation.model.ts`; (c) share one helper | Server and print should not drift; a shared helper would live in `packages/shared`. | One shared 'customer line items' helper in `@tcg/shared`, used by the server PDF (API) and the browser print (web): lines inside Mobilization/Demobilization hidden, the group line shows visits x rate = amount (Q7). Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D7 | How group lines are kept off the dispatch board | (a) skip group children in `createJobFromQuotationInTx` (`projects.service.ts:373` loop); (b) copy them but flag/exclude at read in `das.repository.ts`/`sub-job.mapper.ts`; (c) copy and mark with a new `JobResource` column | (a) is smallest but changes what job financial/payroll readers (~50 files) see — Q10. | Copy every quote line to the job as today (job financials unchanged) and add one column on `JobResource`, `dispatch`: `REQUIRED` (default, today's behaviour) / `OPTIONAL` / `NONE`, set at conversion: lines inside Mob/Demob `NONE`; equipment in a group that is not in the crane's configuration `OPTIONAL` (Q18, Q16a); everything else `REQUIRED`. DAS completion and the board read it. Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D8 | Representation of "required on first and last day, extra visits allocatable" | derive at read time from `JobSchedule*` + group qty; new `JobResource` columns; a new table of required days | Needs Q13/Q14 first. New concept in DAS: allocate/complete logic changes. | Same column as D7: an `OPTIONAL` slot is allocatable on any day and never blocks allocation completed / Send Tickets (Q13, Q15, Q16a); held items go to all days as holdover does today (Q16). No required-days storage. Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D9 | Identifying the Price Adjustment line | custom type title match (like `isGroupResourceLabel`); billing code `PA` match; a flag on `BillingCodeCustomType` (`schema.prisma:1483`) | Title matching is already how groups are detected; a flag is explicit but needs a column and seed. | Match the custom type's per-tenant code `PA` (`BillingCodeCustomType.billingCodeCustomTypeId`), not its title. No schema change. Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D10 | API shape | extend `SubCategoryAssociatedResourceDto` and the quotation DTO in place (changes response shape for web+mobile); or a new endpoint for per-parent nested settings | `tcg-contract-tracer` required. | Extend the existing sub-category association and quotation DTOs in place (fields added, none changed); the nested per-crane settings and the crane link travel with the existing sub-category / quotation save. `tcg-contract-tracer` to check every consumer. Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D11 | Quotation Type chip and layout rebuild | web builds rows (catalog in `lib/resource-catalog.ts`) and API stores; or API computes the layout | | Web builds the rows (as today, from the catalog in the Resources tab); the API stores them and computes totals. Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D12 | Pattern | `patterns.md` has no sub-category/quotation entry — follow existing modules, or add a pattern entry (Haris only) | | Follow the existing modules (sub-category association editor, quotation Resources tab); a `patterns.md` entry, if any, comes from the reflection (Haris only). Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
| D13 | How a crane-named group is tied to its crane (REQ-09) | name/label match (as `isGroupResourceLabel` matches by name); a stored link to the crane's quotation resource (`parentId` is already used for group children) | | A stored link on the group row to the crane line it belongs to (one nullable column on the quotation line); label, ordering (Q17) and dispatch read it. Stated by the ticket owner in session 2026-10-15. | Syed Haris (signed on his instruction "sign them", 2026-10-15) | 2026-10-15 |
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
