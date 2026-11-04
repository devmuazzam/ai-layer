---
title: "A quote keeps the asset configuration it went out with: a snapshot is taken at the first send to the customer, at Mark as Won if never sent, or at conversion; never refreshed; conversion, the dispatch board and the quote builder read it; the job reads its quote's snapshot; anything without one reads live (Syed Haris, ticket owner, 2026-10-16/17) — decision"
source: decision/Syed Haris — answers to TCG-218 questions Q51, Q56, Q57, Q58, Q59, Q61, Q64, 2026-10-16 and 2026-10-17
decided: 2026-10-16
decided_by: >-
  Syed Haris (syed.haris, CodingCops developer, assignee and owner of Linear TCG-218), in Claude Code
  sessions on 2026-10-16 (Q51, Q56, Q57, Q58, Q59, Q61) and 2026-10-17 (Q64), recorded in
  `.ai/aidlc/TCG-218/spec.md` §12. He raised the question himself on 2026-10-16: "if i quote someone
  and it's won then i change the asset configuration, will it affect the won quotes as well?" (as
  relayed to tcg-scrum when this note was commissioned; §12 Q51 records it in paraphrase). No TCG
  person (Joe Schacatano or anyone else) was asked. This is the ticket owner's ruling, not a TCG
  client confirmation, so the status is `reference`: it binds the build, and TCG can overrule it.
  Implemented under TCG-218 units U11a, U11b and U13. Recorded by tcg-scrum 2026-10-17.
status: reference
conflicts_with: []
resolves: aidlc/TCG-218/spec.md#q51--asset-configuration-changes-and-existing-quotesjobs-raised-by-the-ticket-owner-2026-10-16
related_decisions:
  - 2026-09-24-payroll-run-records-configuration-and-source-data-used.md
  - 2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md
  - 2026-10-06-nested-association-quote-visibility-stored-per-parent.md
  - 2026-10-07-field-assets-configuration-tab-rename-and-activity-log.md
  - 2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md
jira: []
tags: [module/quotations, module/assets, module/projects-jobs, module/dispatch, kind/decision, daily-allocation]
---

# A quote keeps the asset configuration it went out with

"Asset configuration" = a sub-category's **Field Assets Configuration**: its associations at every
depth (Always Included / Optional), their Hourly Show, Mob/Demob Show and Main / Sub item settings,
and the nested per-parent settings. See
[2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md](2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md)
and [2026-10-06-nested-association-quote-visibility-stored-per-parent.md](2026-10-06-nested-association-quote-visibility-stored-per-parent.md).

## The question

Syed Haris, 2026-10-16: *"if i quote someone and it's won then i change the asset configuration, will
it affect the won quotes as well?"* Q51 records what was found: the saved quote's lines and totals
never change, but the configuration was read again at quote → job conversion (auto-added Always
Included rows, dispatch classification) and live on every dispatch-board load, so a machine made
Always Included after conversion showed as "missing" on existing jobs.

## Decision

| # | Rule | Source (spec §12) |
| --- | --- | --- |
| 1 | **A configuration change affects only quotes that have not yet gone out.** The quote keeps a snapshot of the configuration of what it quotes. | Q51 — "Freeze at quote save" (first answer), then the U11 shape |
| 2 | **When it is taken:** when the quote is **first sent to the customer** (any send path that moves it to Sent to Customer); or at **Mark as Won** if it has none (won without being sent); or at **conversion** if it still has none. | Q51 U11 shape (2); Q58 — "Snapshot on Mark as Won" (option A) |
| 3 | **Never refreshed.** A re-send keeps it. "If client asks for changes, it will be on that snapshot not the config": edits to a quote that has a snapshot use the snapshot's configuration. | Q51 U11 shape (2) |
| 4 | **Who reads it:** conversion (auto-added rows and dispatch classification), the dispatch board's missing-components check, and the quote builder (pick / auto-fill / Quotation Type switch) once the quote has one. | Q51 U11 shape (2)–(3) |
| 5 | **The job reads its quote's snapshot** — no copy on the job. A job with no quote reads the live configuration, as before. | Q64 — "I want the best approach and no unnecessary tables"; supersedes Q51's "copied to the job" |
| 6 | **Anything without a snapshot reads live:** existing quotes and jobs from before (no backfill); a quote created directly as Sent to Customer takes its snapshot at its next real send, or at conversion; quotes sent before the snapshot shipped take one at their next send or signature sync. | Q51 U11 shape (4); Q57 — "C: no hook on create" (supersedes Q56(4)); Q56(3) |
| 7 | **A sub-category the snapshot does not cover** (an item added to the quote after it was sent, a line added on the job later) reads the **live** configuration. | Q56(1) — "Accept 1-3" |
| 8 | **Names stay live.** The snapshot holds ids and settings, not names, so a rename of a brought-along item shows on existing quotes and jobs. | Q56(2) |
| 9 | **Order** of brought-along lines in a snapshot is the configuration's order, read exactly as the live configuration is. | Q61 — "Snapshot keeps live order" |
| 10 | **Left open:** a direct status edit to Won (`PATCH`, which no client sends) skips Mark as Won and therefore its snapshot; the snapshot is then taken at conversion. Blocking Won on that path is a later guardrail, not part of this decision. | Q59 — "no need, for now, we can add these guardrails later" |

## Why

The ticket owner's reasoning, from §12: what the customer was quoted is what the job should be built
and dispatched from, so a later configuration change must not reach back into a quote that has gone
out. "First send" rather than "every save" (rule 2) because every edit before the send should still
see the current configuration; Mark as Won was added (Q58) after a scenario test showed a quote won
from Draft lost its Oiler when the configuration changed before conversion (QUOT-00027 → JOB-00015),
while a sent one kept it (QUOT-00029 → JOB-00014). The job reads its quote's snapshot (Q64) because
a quote's snapshot is never changed once set and a job links to at most one quote, so a copy could
only ever equal it. Precedent checked first (Q51, which characterizes it as "a snapshot, not a
pointer"): a payroll run records the configuration and source data it used —
[2026-09-24-payroll-run-records-configuration-and-source-data-used.md](2026-09-24-payroll-run-records-configuration-and-source-data-used.md).

## Structure — developer decisions, not product rules

Storage shape, which API responses carry the snapshot, logging and fallback on an unreadable
snapshot, and the stacking of PRs are developer decisions recorded in `.ai/aidlc/TCG-218/spec.md`
§12 Q51 (*U11 shape* (1)), Q56(5), Q57 (*U11a review decisions*) and Q64. They are not restated here
and are not requirements.

## Conflicts

None. No earlier decision note says a quote or job follows later configuration changes. The
[2026-10-07-field-assets-configuration-tab-rename-and-activity-log.md](2026-10-07-field-assets-configuration-tab-rename-and-activity-log.md)
activity log records configuration changes; this note decides which quotes they reach.

## Effect on the vault

- This note: `status: reference` (ticket owner, not client-confirmed). **Done.**
- `aidlc/TCG-218/spec.md` §12 Q51: `- **Decision note:**` line added. **Done.**
- `quotations/INDEX.md` and `quotations/mob-demob-current-rules.md`: rows added. **Done.**
- `assets/INDEX.md`, `projects-jobs/INDEX.md` and `dispatch/INDEX.md`: listed under *Decisions
  that bind this module*. **Done** 2026-10-17 (TCG-218 close-ticket pass).
- `quotations/gaps.md` → *Estimate defaults per resource type / job type / yard*, sub-question (e)
  (*"when a template changes, do existing quotations re-seed or stay a snapshot?"*): **not closed** —
  (e) asks about FCC's job-type estimate template, which TCG does not have; this note decides the
  asset configuration's effect on quotes that have gone out, not whether saved lines re-seed, and the
  entry's owners (Joe Schacatano / Ryan Adams) were not asked. A dated pointer was appended to the
  entry instead. 2026-10-17.
