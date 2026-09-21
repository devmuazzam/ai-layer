---
title: UAT — folder index
status: reference
kind: index
updated: 2026-09-19
tags: [module/all, kind/index, requirements, open-questions]
---

# UAT — the user-acceptance sessions and their register

What TCG and CodingCops raised in the six UAT sessions run between 9 and 17 September 2026,
and what the 2026-09-18 audit found had actually been built. Migrated from Confluence space
TCG on 2026-09-19.

> **This folder is a record of requests and their build status, never a source for a spec.**
> A UAT row is a client or internal **ask** — someone sat in front of a screen and said what
> they wanted changed. Nothing here was adjudicated. Where a row asserts how the product must
> behave ("Permit Cost should be the same as the PO Fee", "One person cannot be assigned to
> two jobs"), that assertion carries no more authority than the person who said it in the
> room. **Do not cite a UAT row as product intent.** If a row states a rule the vault does not
> already hold, it is an open question for the owning module's `gaps.md` or a decision note —
> not a requirement. Everything in this folder is `status: unverified`.

## Files

| File | Answers | KB |
| --- | --- | --- |
| [register-2026-09-18.md](register-2026-09-18.md) | **Every UAT request across sessions 1–6, with what the code actually does.** 252 rows, two tables, verified against `origin/main` at `f800a3972`. Fouzan Shakil, 2026-09-18 | 105 |
| [sessions/](sessions/) | The six raw session sheets, verbatim — the register's sources | 25 |
| [done-verification-2026-09-19.md](done-verification-2026-09-19.md) | **Do the 100 DONE rows actually hold?** Re-checked against platform main at `72d6cc4c9` on 2026-09-19: 94 verified, 2 partial (#4 push server-side, #66 Oiler warning), **2 wrong (#36 shift-1 employees toggle defaults off; #62 cross-job double-booking silently reassigns, never refuses)**, 1 unverifiable. Every caveat from 09-18 still open. Six citation defects listed | 22.2 |

## The sessions

| # | Page | Session date | Page ID | Author | Rows in the register |
| --- | --- | --- | --- | ---: | --- |
| 1 | [UAT session 1 ( Internal )](sessions/uat-session-1-internal.md) | *not stated on the page* | `170229761` | Umair Khan | 34 — 13 done, 21 not done |
| 2 | [UAT Session 2](sessions/uat-session-2.md) | 2026-09-09 | `170360833` | Umair Khan | 45 — 24 done, 21 not done |
| 3 | [UAT session 3](sessions/uat-session-3.md) | *not stated on the page* | `170491905` | Umair Khan | 39 — 20 done, 19 not done |
| 4 | [UAT session 4](sessions/uat-session-4.md) | 2026-09-14 | `170786817` | Umair Khan | 53 — 27 done, 26 not done |
| 5 | [UAT session 5](sessions/uat-session-5.md) | *not stated — the heading says only "Tuesday \| 1:00 AM"* | `170950664` | Umair Khan | 16 — 7 done, 9 not done |
| 6 | [17Sep Internal UAT](sessions/17sep-internal-uat.md) | 2026-09-17 | `174850050` | Fouzan Shakil | 38 — 0 done, 38 not done |
| — | *no source — untraceable to a session* | — | — | — | 27 — 9 done, 18 not done |
| | | | | **Total** | **252 — 100 done, 152 not done** |

**100 done, 152 not done — 40% / 60%.** The register calls the six pages "UAT 1" through
"UAT 6"; the Confluence page titled *17Sep Internal UAT* is the one it calls UAT 6.

**Two caveats the register states about its own numbers**, and both matter before anyone
works from a status:

- **The 38 UAT 6 rows were never checked against code.** They were entered as NOT DONE on
  the assumption that the 17 Sep session listed outstanding work. Their status is assumed.
- **27 rows have no traceable source.** Nine are bugs found during the audit itself; the rest
  came from a list whose origin is unrecorded. The register says nobody should act on one
  until its origin is confirmed.

## Read this first — the three headline defects

Quoted from the register's own *Read this first* section. All three are things widely
believed finished that are not:

> **Push notifications do not work on any phone.** There is no Firebase config file in the
> app at all, so Android never gets a token and iOS sends a token the server rejects and
> deletes. The server half is complete and correct — only the app's native config is missing.

> **Allocations can still be removed after the time has passed.** The delete check looks at
> payroll locks and whether tickets were sent — it never looks at the clock.

> **The Pre-Inspection checklist still pre-ticks every item.** The fix exists, but a build
> setting turns the autofill back on in every build we ship, including production.

A fourth line in the same section is the reason the register exists at all: *"Nine items
widely believed outstanding are already built — anyone working from an older list will
rebuild finished work."*

## How to read a row

Five columns: **Status** (DONE / NOT DONE), **Item** (the request in plain words), **Src**
(a link to the exact point on the session sheet — blank where untraceable), **Comments** (the
finding, usually naming the file that proves it), **Owner** (blank on purpose). A row is DONE
only if the thing complained about no longer happens; anything half-built sits in NOT DONE
with the remaining gap spelled out.

## Where this register contradicts the vault — six conflicts, logged 2026-09-19

Found while routing the register's rows into the module `gaps.md` registers. **None of them is
adjudicated here**, and no row on the register was changed — it is a migrated snapshot. Each is
recorded as an update on the vault entry a reader would actually meet, and this list is the index
to them. Two general points first, because they apply to all six:

- **The register never cites a decision note.** It was checked against `origin/main @ f800a3972`,
  so a DONE row means *the build does this now*, never *this is what the product should do*.
- **Five of the seven decision notes named below are `status: reference`** — decided by CodingCops
  and explicitly open to being overruled by TCG. **A UAT row contradicting a `reference` note is a
  legitimate product input; a UAT row contradicting a `verified` one is a regression against a
  client statement.** Only conflict 1 and the wording hazard at the end touch `verified` notes
  (2026-09-16 and 2026-09-03); 2, 3, 4, 5 and 6 are all against `reference` notes.

| # | The conflict | One line | Detail lives at |
| --- | --- | --- | --- |
| 1 | **The whole Resources screen vs the only `verified` quotation decision** | 20+ register rows treat quotation resources as priced lines; [decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md](../decisions/2026-09-16-quotation-carries-billing-codes-resources-are-dispatch-side.md) (`verified`, Joe Schacatano) says a quotation carries **billing codes only** and resources are dispatch-side. The register, written two days later, never mentions it. **The largest of the six.** | [quotations/gaps.md → *Quote line items vs dispatch resources…*](../quotations/gaps.md#quote-line-items-vs-dispatch-resources--the-associated-set-auto-fills-the-quote-and-the-sales-owner-says-dispatch-resources-must-not-be-quoted) |
| 2 | **Rigger at $0 — a DONE row's caveat is one commit out of date** | The DONE row cites `c6716980d` (the PR #537 display-only half) and calls the dispatch-slot question open; `765fffc8c` / PR #541 and [decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md](../decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md) settled it for the Optional case. Only the **Always Included** late-added / unpersisted-depth case is still open. | [dispatch/gaps.md → *Branch fix/uat4-schedule-copy-allocation…*](../dispatch/gaps.md#branch-fixuat4-schedule-copy-allocation--a-das-slot-the-quotation-never-priced-the-job-resources-tab-now-hides-materialised-0-rows-the-board-still-allocates-against-them) |
| 3 | **Double-booking — two rows pulling opposite ways, both behind one decision** | UAT 5's DONE *One person cannot be assigned to two jobs* and UAT 4 #31's NOT DONE *People still available under an 11:30 shift* are both scoped by [decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md](../decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md) → *DAS allocation (new)* item 5, which neither row cites. **Employee case — not the crane one.** | [dispatch/gaps.md → *Schedule fields…*](../dispatch/gaps.md#schedule-fields--the-build-already-agrees-and-the-new-fields-are-written-nowhere) |
| 4 | **Archive marked DONE with 56 hard deletes surviving** | The UAT 1 row is DONE with the caveat that *"56 delete routes remain hard deletes, including removing a role from a department"*, against [decisions/2026-08-20-archive-instead-of-delete-app-wide.md](../decisions/2026-08-20-archive-instead-of-delete-app-wide.md)'s *"archive is the entity-removal action **across the app**"*. That note leaves the `DELETE` endpoints' fate open, so the 56 are **undecided, not non-compliant**. | [admin/gaps.md → *Departments — does archive replace delete outright…*](../admin/gaps.md#departments--does-archive-replace-delete-outright-and-what-may-an-archived-department-still-be-used-for) |
| 5 | **PO state following Vendor state vs an auto-close rule written as "only"** | UAT 3 asks for a second automatic PO transition; [decisions/2026-09-11-po-closed-means-closed-out-not-cancelled.md](../decisions/2026-09-11-po-closed-means-closed-out-not-cancelled.md) rule 3 closes a PO *"**only** when an attachment in an Invoice category is uploaded"*. Also opened as its own question, because *"vendor state"* means two different things. | [vendors-agencies/gaps.md → *Branch fix/das-fixes — one CLOSED status…*](../vendors-agencies/gaps.md#branch-fixdas-fixes--one-closed-status-for-invoiced-and-cancelled-pos-and-the-legacy-remap) |
| 6 | **Per-row "Final Amount" on hover vs adjustment money in the footer** — ⚠️ **weakest of the six** | A *Final Amount* still appears on a resource row's hover when a discount or price hike is present, against [decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md](../decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md) rules 2–3, which put adjustment money in the footer rows. **Flagged as weak:** the decision governs the Amount **column**, and a tooltip is not the column; the UAT row also mis-names what it wants removed. | [quotations/gaps.md → *Per-row surcharge now has no UI on create/edit…*](../quotations/gaps.md#per-row-surcharge-now-has-no-ui-on-createedit-and-final-amount-means-two-different-numbers) |

**One wording hazard, recorded with them.** UAT 2's *"From Build-Up to **Break Time**, everything
should be considered Boom"* was built as build-up + boom + **breakdown**, which matches
[decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md](../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md)
(`verified`). Read literally, *"Break Time"* would make a **paid meal break** part of the boom
premium window. Nothing needs changing; cite the decision, never the row, for what counts as boom —
[payroll/gaps.md → *Boom window as built…*](../payroll/gaps.md#boom-window-as-built--the-erp-pays-the-adder-across-the-whole-paid-shift-not-build-upbreakdown).

**Fifteen register rows that assert a product rule nothing else covers** were opened as new
questions in the module registers on the same day, and one existing entry was updated rather than
duplicated. The all-modules sweep finds them with the rest:
`grep -rn '^- \*\*Status:\*\* open' vault/*/gaps.md`.

## Related

- [../erp-review-log.md](../erp-review-log.md) — the client's **own** feedback register, kept
  separately. Same class of artefact, different author and a different period; also unadjudicated.
- [../decisions/](../decisions/) — where a UAT question becomes binding, once a named human
  answers it.
- `../<module>/gaps.md` — where a UAT row that states an unsettled product rule belongs.
