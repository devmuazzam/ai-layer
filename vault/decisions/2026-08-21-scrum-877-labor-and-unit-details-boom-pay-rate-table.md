---
title: SCRUM-877 Labor & Unit Details — Craft Modifier/Boom Pay rate table, above-380ft Oiler fallback, and Asset.mainBoomLength numeric authorization
source: decision/product-owner
decided: 2026-08-21
decided_by: tcgproject12, posted directly on the SCRUM-877 Jira ticket, comment 23099, 2026-08-21T19:06:25.493+0500
status: verified
resolves: gaps.md#scrum-877-labor-and-unit-details-oiler-crew-linking
topics: [labor-payroll, field-ops-mobile, time-tracking, requirements-spec]
entities: [field-ticket, labor-record, employee, craft-code, boom-time, asset]
---

## Decision

Comment `23099` on `SCRUM-877`, posted by `tcgproject12` on 2026-08-21T19:06:25.493+0500, supplies
the literal `FMS_UNION_CRAFT_MODIFIER` rate table this ticket's spec had been carrying as
`[OPEN]` since the prior decision record
(`.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md`), answers
the above-380ft Oiler fallback question that table's own asymmetry raised, and authorizes
`Asset.mainBoomLength`'s migration to numeric. **Fetched and verified live via Atlassian MCP**
(`cloudId the-crane-guys.atlassian.net`, issue `SCRUM-877`, `mcp__atlassian__getJiraIssue` with
`fields: ["summary","status","comment","attachment","updated"]`) — not taken from any summary.
The comment's text, reproduced below, matches verbatim what was relayed into this task.

This is a **second, separate decision record for `SCRUM-877`**, not an amendment of the first.
The two records answer disjoint question sets (the first: Q1/Q2/Q4/Q9, plus Q8's deferral; this
one: Q5's rate table, the new above-380ft question the first record logged as unresolved, and the
boom-length-numeric authorization) and cite different comments (`22923`/`23025`/`23062`/`23064`/
`23066` vs. `23099`). Per this role's own convention (`README.md` → *How a gap gets closed*, and
this vault's practice of one dated file per distinct resolved question-set even on the same
ticket), a new answer arriving after a decision record has already been written and its
frontmatter edits applied gets its own dated file rather than a rewrite of the first — the first
record's `verified_because:`-pointing frontmatter edits are already applied and should not be
disturbed by reopening that file.

### 1. The full `FMS_UNION_CRAFT_MODIFIER` rate table — 16 rows, confirmed non-symmetric

Comment `23099`, verbatim table:

| Bracket | Operator code | $/h | Oiler code | $/h |
| --- | --- | --- | --- | --- |
| 080–100 ft | OP-BP-01 | 0.750 | OI-BP-01 | 0.250 |
| 101–120 ft | OP-BP-02 | 1.500 | OI-BP-02 | 0.500 |
| 121–140 ft | OP-BP-03 | 2.250 | OI-BP-03 | 0.750 |
| 141–160 ft | OP-BP-04 | 3.000 | OI-BP-04 | 1.000 |
| 161–180 ft | OP-BP-05 | 3.750 | OI-BP-05 | 1.250 |
| 181–200 ft | OP-BP-06 | 4.500 | OI-BP-06 | 1.500 |
| 201–220 ft | OP-BP-07 | 5.250 | OI-BP-07 | 1.750 |
| 221–240 ft | OP-BP-08 | 6.000 | OI-BP-08 | 2.000 |
| 241–260 ft | OP-BP-09 | 6.750 | OI-BP-09 | 2.250 |
| 261–280 ft | OP-BP-10 | 7.500 | OI-BP-10 | 2.500 |
| 281–300 ft | OP-BP-11 | 8.250 | OI-BP-11 | 2.750 |
| 301–320 ft | OP-BP-12 | 9.000 | OI-BP-12 | 3.000 |
| 321–340 ft | OP-BP-13 | 9.750 | OI-BP-13 | 3.250 |
| 341–360 ft | OP-BP-14 | 10.500 | OI-BP-14 | 3.500 |
| 361–380 ft | OP-BP-15 | 11.250 | OI-BP-15 | 3.750 |
| 381–400 ft | OP-BP-16 | 12.000 | — | — |
| 421–440 ft | OP-BP-18 | 13.500 | — | — |

16 rows total (14 paired brackets 080–100ft through 361–380ft, plus two Operator-only brackets at
381–400ft and 421–440ft). Comment `23099`'s own text: **"Confirmed: the table is genuinely not
symmetric — `OP-BP-17` (401–420 ft) does not exist in the source data, and there is no Oiler
bracket at all above 380 ft."** This explicitly forecloses the reading that 401–420ft is a
transcription gap — the product owner states directly that the bracket is genuinely absent from
the source data, not merely omitted when relayed. This corrects the "symmetrical pattern" language
attributed to comments `23025`/`23066` in the prior decision record and in `spec.md` REQ-05/Q5/Q10:
the pattern is symmetric only within the shared 080–380ft range: above that, the table is
Operator-only, and one bracket boundary (401–420ft) is simply missing outright for both employee
types.

This directly resolves the data half of what `spec.md` currently logs as **Q5** ("STILL OPEN,
NARROWED — the literal `FMS_UNION_CRAFT_MODIFIER` rate table") and **REQ-05** ("`[VERIFIED —
mechanism]` / `[OPEN — rate values, and a new gap the values themselves raised]`"). The table
reproduced in `spec.md` REQ-05 under "chat relay, round 2, not cited as a source" is **the same
table**, now reaching the ticket through a durable, citable channel (a Jira comment) rather than an
uncited chat relay. This decision supersedes that relay's status as uncitable — the values
themselves are unchanged from what was relayed, but the source is no longer a chat relay, it is
comment `23099`.

### 2. Above-380ft Oiler fallback — resolved, not the "invent a rule" case `spec.md` warned against

`spec.md`'s **Q10** ("NEW — what rate applies to an Oiler on a crane with boom length above 380
ft, if the relayed table's asymmetry is real?") listed three unchosen options: (a) fall back to the
highest available Oiler bracket (`OI-BP-15`, 361–380ft); (b) treat as an error state requiring
manual entry; (c) the real table has a row that was dropped in transcription.

Comment `23099` answers directly, choosing (a) explicitly and ruling out (c): **"Confirmed rule for
an Oiler on a crane with boom length above 380 ft: use the 361–380 ft bracket's Oiler rate —
`OI-BP-15`, $3.750/hr."** Combined with point 1 above ("does not exist in the source data" — not a
transcription artifact), option (c) is explicitly foreclosed by the same comment, not merely left
unchosen. This resolves **Q10** in full and un-blocks the above-380ft-Oiler portion of **REQ-05**'s
rate application that `spec.md` had marked open.

### 3. `Asset.mainBoomLength` numeric conversion — authorized

`spec.md`'s **REQ-17** and **Q11** ask whether `Asset.mainBoomLength` (`apps/api/prisma/
schema.prisma:758`, currently `String? @map("main_boom_length") @db.VarChar(30)`) should migrate
to numeric, noting explicitly that — unlike `Asset.capacity`/REQ-16, which the product owner
confirmed directly in comment `23066` — no one had yet been asked about `mainBoomLength`
specifically, and that `spec.md` was deliberately not treating the REQ-16 analogy as authorization
on its own.

Comment `23099` closes this directly: **"Main Boom Length field: recorded on the Asset module in
feet, separate from Asset Capacity (tonnage). Confirmed: should also be converted to a numeric
field, same as Asset Capacity."** This is an explicit, direct authorization — not an inference from
the REQ-16 precedent — resolving **Q11** and removing the "whether/when to migrate" half of
**REQ-17**'s open status. Precision/scale and backfill strategy are **not** addressed by this
comment, exactly as they were not addressed for `Asset.capacity`/REQ-16 either — those specifics
remain `NOT SPECIFIED` for both fields, per `spec.md` §13's existing note, and this decision does
not supply them.

### 4. Craft Code — re-confirms the first decision record, no new content

Comment `23099`: **"Craft Code source: confirmed. Configured via a Settings-tab admin module
(`code` + `label`). The 'Craft Code' on the Oiler's card is whichever Craft Code is assigned to
that employee's profile — no hardcoded value, no seed data needed."**

This restates, using Jira-comment provenance instead of the prior uncited chat relay, exactly what
`spec.md`'s **REQ-04** and **Q3** already carried under "chat relay, round 2, not cited as a
source": `EmployeeCraftCode` is a tenant-configurable admin table (`code` + `label` fields,
independently verified against the schema at `apps/api/prisma/schema.prisma:2261-2284` by the
elaborator's prior pass), not a hardcoded enum, and there is no "seed value" question in the sense
originally framed. **This does not fully close Q3 as `spec.md` currently frames it.** `spec.md`'s
Q3 was explicitly re-framed, after the round-2 relay, from "which field / does this need a seed
value" (mechanism — now doubly confirmed, first by relay and now by this durable comment) to "is
there actually a usable Oiler-appropriate `EmployeeCraftCode` row configured in real tenant data
today, and whose job is it to add one if not" (data-readiness, an operational question about
today's configured data, not a mechanism question). Comment `23099` speaks only to mechanism —
"no hardcoded value, no seed data needed" describes the code-level pattern, not whether any tenant
has actually configured an Oiler-appropriate row. **The data-readiness half of Q3 remains open**;
see *What remains open* below.

## Why

The product owner chose, this time, to post the rate table and both remaining schema questions
directly to Jira as a comment rather than relay them through chat — the same durable channel that
produced the first decision record's Q1–Q9 answers. This matters for exactly the reason
`spec.md` §0's "update #2" note flagged when the same content had arrived only through chat: a
chat relay is not independently re-checkable by a future reader the way a comment id and
timestamp are. Comment `23099` gives this rate table, for the first time, a citation a future
reader can open and verify themselves — this is the material change from `spec.md`'s current
state, not the content of the table (which matches, value for value, what the uncited round-2
relay had already surfaced).

The above-380ft Oiler question mattered enough to verify precisely because `spec.md`'s own
instructions (REQ-05's executor notes) explicitly forbade assuming option (a) as a default:
"Do not adopt the relayed table as build data... it contains an unresolved internal question (the
above-380ft Oiler gap) that a human needs to answer, not an engineer to guess." Comment `23099` is
that human answering it directly, in the same message that supplies the table — both were checked
against the live comment text rather than assumed to align with the options `spec.md` had already
enumerated, and they do align: option (a), with option (c) explicitly ruled out by the same
comment's "genuinely not symmetric... does not exist in the source data" language.

## Effect on the vault

- **No vault document `status:`/`conflicts_with:`/`superseded_by:` frontmatter changes.** As with
  the first `SCRUM-877` decision record, this decision does not resolve a conflict between two
  vault documents — it answers open questions raised while elaborating a ticket. No vault file's
  `conflicts_with:` points at this ticket's gap entry. Checked and confirmed, same as the prior
  record's finding.
- **`gaps.md#scrum-877-labor-and-unit-details-oiler-crew-linking`** — **not edited by this note.**
  Per this role's write scope and the same deliberate departure the first decision record
  documented: `gaps.md` is reserved for the elaborator's next pass, so the corresponding `spec.md`
  rewrite and the `gaps.md` status update happen together, in one pass, by the elaborator. This
  decision record does not by itself close the overall gap entry — sub-questions 3 (data-readiness
  half), 7 (attachment images), and 8 (Labor Classification list, deferred) remain open per the
  gaps.md entry's own accounting, so `Status: open` likely still applies even after this decision,
  pending the elaborator's judgment on exactly how to phrase the next update block.
- **`spec.md`** — **not edited by this note**, per this task's explicit instruction. The elaborator
  should, on its next pass:
  - Mark **Q5** resolved for the rate-table values (citing comment `23099`), superseding the
    "chat relay, round 2, not cited as a source" framing currently in REQ-05's sources — the same
    table now has a citable source.
  - Mark **Q10** resolved (above-380ft Oiler fallback = `OI-BP-15`, $3.750/hr, per comment `23099`).
  - Mark **Q11** resolved (yes, `Asset.mainBoomLength` migrates to numeric, per comment `23099`) and
    update **REQ-17**'s flag from `[OPEN — whether/when to migrate...]` to reflect that the
    migration itself is now authorized (precision/scale/backfill still `NOT SPECIFIED`).
  - Update **REQ-05**'s flag: mechanism was already `[VERIFIED]`; the rate values and the
    above-380ft rule are now sourced to comment `23099` rather than an uncited relay. Whether REQ-05
    becomes fully `[VERIFIED]` or keeps a narrower `[OPEN]` for precision/edge-case details (e.g.
    exact boundary handling — is 380.0ft itself in the 361–380 or 381–400 bracket? not stated by
    any source) is the elaborator's call, not asserted here.
  - **Q3** stays open, re-narrowed once more to purely the data-readiness question (does a usable
    Oiler-appropriate `EmployeeCraftCode` row exist in real tenant data) — comment `23099`
    reconfirms mechanism only, exactly as the round-2 chat relay had, now with a citable source for
    that mechanism confirmation but no new content on data readiness.
  - **Q6**'s "boron-length field location resolved, still open whether it migrates" framing is
    superseded — the migration is now authorized (see Q11 above); Q6 should be marked resolved in
    both halves.

## What remains open after this decision

1. **Q3, data-readiness half — still open.** Whether any tenant has an Oiler-appropriate
   `EmployeeCraftCode` row actually configured today, and whose operational responsibility it is
   to add one if not, is not addressed by comment `23099` or any other source. Today's seeded
   craft codes remain `OPERATOR`/`LABORER`/`MECHANIC`/`SUPERVISOR`
   (`apps/api/prisma/migrations/20260703100000_employee_craft_and_work_comp_codes/
   migration.sql:82-87`, unchanged) — this is seed data, not necessarily what a tenant's admins
   have since configured, so it does not by itself confirm the gap, only that it is not closed by
   seed data either.
2. **Q7 — the two Jira attachment images remain unread by any agent.** Comment `23099` does not
   touch this; it was answered (as a deferral, "I have attached the relevant images") only in
   comment `23066`, already logged as still-unresolved by the prior decision record. Direct
   attachment-content fetch was not re-attempted in this pass — no new tool became available,
   and comment `23099`'s content did not require checking the attachments to verify.
3. **Q8 — Labor Classification list — remains an explicit deferral, not an answer.** Untouched by
   comment `23099`. Comment `23066`'s "Skip this point" stands as the only disposition.
4. **Precision/scale and backfill strategy for both numeric migrations** (`Asset.capacity`/REQ-16
   and now `Asset.mainBoomLength`/REQ-17) are authorized in principle but not specified in detail
   by any source, including this comment.
5. **Boundary-value handling at bracket edges** (e.g., is exactly 380ft the top of 361–380 or does
   381–400 start there; is exactly 440ft in-range or does the >440 clamp rule apply at 440 itself)
   is not addressed by comment `23099` — the table's own bracket labels ("361–380 ft", "381–400
   ft") imply no overlap, but no source states inclusive/exclusive boundary semantics explicitly.
   Flagged for the executor, not asserted as settled here.
