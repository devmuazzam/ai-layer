# Reflection — TICKET-FLOW-SLOTS-HOLDOVER Slot-driven steps, floating checklists, holdover flow, late and incomplete tickets

> Written on a completed-and-reviewed build **pending merge**. All 35 units built and reviewed by `tcg-analyst`
> (three parallel reviews, verdict "ship with follow-ups" each); confirmed bugs fixed. Findings below come from the
> analyst verdicts, the spec/units folder, and the branch shape. I did not re-run the diffs line by line.
> Attribution is to artifacts, never to people. Proposals only; nothing applied.

## 0. Context

| Field | Value |
| --- | --- |
| Ticket | `TICKET-FLOW-SLOTS-HOLDOVER` (no SCRUM id; Path A) |
| Spec | `.ai/aidlc/TICKET-FLOW-SLOTS-HOLDOVER/spec.md`, elaborated 2026-10-16 (103 KB; read by section) |
| Units | 35 built: U1-U6, H1-H6, M1-M6 on `feat/ticket-flow-uhm-series` (base `1056f2aa6`, 19 commits); LT1-LT17 on `feat/ticket-flow-lt-series` (base `d09a8209f`, 19 commits; LT6 split into LT6a/LT6b). **Not merged.** |
| Reflected on | 2026-10-19 |
| Reviewer(s) | `tcg-analyst` x3 (Part 1 U1-U5, Part 2 H/M, Part 3 LT) |
| Open questions at build time | 8 raised in the spec at elaboration (Q1-Q8); 4 answered before build (Q5-Q8). Executors raised Q9-Q26 (18 more) during build. Final state before this reflection: 11 resolved, 15 open. This reflection adds Q27-Q29 (open). |
| `[UNVERIFIED]` requirements built | 29 of 33 REQs carry the tag (all except the 4 `[OPEN]`, REQ-03 is `[CONFLICT]`). Confirmed wrong or stale: 0 that the analysts traced to a false source. See §3. |
| Unverified x irreversible | 2. (1) LT2 six, then seven, `ActivityLogAction` members (Postgres enums do not drop). **Flagged before build** (units.md "Read first"), Q10 settled before the migration. (2) H2 enum + CHECK, droppable. Pattern to watch: none found late. |

## 1. Spec defects — what the spec missed

### SD-1 — UI copy, thresholds and list limits left to the executor

- **Where:** REQ-08, REQ-11-13, REQ-25, REQ-26; Q14-Q20, Q23, Q24, Q26 (and §13 "Exact UI copy ... not specified").
- **What the executor needed to know:** exact strings for the holdover crane-state line, Day-2+ card and choices, Start Work card, end-of-day crane sheet, Incomplete card and countdown format; the "closing-soon" threshold (Q20); `reason` length cap (Q23); cron look-back (Q24); page size for the late-tickets lists (REQ-25, analyst: unpaginated).
- **What the spec said:** copy "beyond the names in the notes" is deliberately unspecified; each question has a "labelled provisional" workaround.
- **What was decided instead, and by whom:** the executor, each time, as a labelled provisional value (copy, threshold) and, for list size, nothing (unbounded).
- **Was the decision right:** still unknown. Copy is reversible. The unbounded lists are a defect: the analyst flagged LT11.
- **Cost:** 10 open questions shipping provisional strings; an unpaginated payroll list.
- **Class:** missing
- **Fix:** R2 (required "values the executor must not choose" line) and R3.

### SD-2 — Four product questions stayed open through the build

- **Where:** REQ-30-33; Q1-Q4 (also Q12, day counting for cancelled sub-job days).
- **What the executor needed to know:** whether an Operator folded onto an Oiler's ticket completes it (Q1); who finishes a departed employee's tickets (Q2); how hard the previous-ticket block is (Q3); two Operator slots and no Oiler (Q4).
- **What the spec said:** `[OPEN]`, with a labelled workaround each; units.md excluded REQ-30-33 from every unit.
- **What was decided instead, and by whom:** nothing built for Q1/Q2/Q3; behaviour unchanged for Q4. Correct stop behaviour.
- **Was the decision right:** yes. The executors did not fill the gaps (see §6). The residual cost is that the 24h window and approval flow ship without an answer for the folded Operator.
- **Cost:** product risk deferred; no rework.
- **Class:** missing (known, sanctioned)
- **Fix:** none beyond tracking; owner is Melissa McNutt / Lisette Anzaldo (see spec §12).

### SD-3 — Nine structural questions first surfaced in the build

- **Where:** Q9 (`completedAt` backfill), Q10 (audit action for a late-captured op), Q13 (holdover detection without a module cycle), Q21 (`requestedBy`/`decidedBy` FK targets and on-delete), Q22 (bare resubmit of COMPLETE), Q23-Q25.
- **What the executor needed to know:** things the spec's data-model and API sections should have settled: the service dependency graph, FK on-delete rules, the backfill rule, idempotency on resubmit.
- **What the spec said:** §3 sketched `TicketEditRequest` fields (`requestedBy`, `decidedBy`) with no types or on-delete; REQ-20 covered edits after submit and not a replayed submit.
- **What was decided instead, and by whom:** Q9/Q10/Q11 by Haris 2026-10-16; Q13 "Haris, delegated to the AI recommendation"; Q21 "Haris, via the AI driving the loop" (see ED-11); Q22-Q25 still `open` with a shipped workaround.
- **Was the decision right:** Q22's workaround (idempotent) is right (a later analyst fix restored it, see ED-4). Rest unknown.
- **Cost:** 9 stop-and-ask rounds, one of which (Q13) became a DI boot failure (ED-5).
- **Class:** missing
- **Fix:** R1 (spec template: FK/on-delete and dependency edges as required fields).

### SD-4 — Two units edited and wired the same provider with no dependency edge

- **Where:** `units.md` ledger rows H3 (depends H2) and H6 (depends H2); `TicketHoldoverService` constructor (changed by H3) vs. `JobProgressModule` provider list (H6).
- **What the executor needed to know:** H3 changes `TicketHoldoverService`'s constructor; H6's module provides that service.
- **What the spec said:** units.md lists only H2 as the dependency of each. No Ripple row names `JobProgressModule`.
- **What was decided instead, and by whom:** nobody; two executors worked in parallel. The API would not boot with both merged.
- **Was the decision right:** n/a. Fixed on uhm-series (bare repo + pure helper, plus a module-init test).
- **Cost:** a boot failure caught at consolidation; one fix round.
- **Class:** missing (decomposition)
- **Fix:** R4 (decomposer: provider-shared units get an edge) and R6 (mechanical boot test).

### SD-5 — Behaviour for an absent slot or absent field never stated

- **Where:** REQ-01, REQ-04, REQ-10; analyst findings U4 `getTicketTotal(undefined)=14`, H submit guard ignores holdover when `slotTypeName` is absent, H `matchPreviousTicket`.
- **What the executor needed to know:** what applies to a ticket with no slot or no `stepFlow`, and which key matches "the previous ticket" when a slot line is shared.
- **What the spec said:** nothing; each REQ defines the with-slot path only.
- **What was decided instead, and by whom:** the executors kept a legacy fallback (14) and a slot-line match; both still wrong in an edge case.
- **Was the decision right:** no, per analyst. Follow-ups, not fixed.
- **Cost:** three open follow-ups; Q28 and Q29 now raise them.
- **Class:** missing
- **Fix:** R1 (required "when the input is absent" line).

### SD-6 — Trust boundary of the offline capture time never stated

- **Where:** REQ-28; DN-2 L17.
- **What the executor needed to know:** whether the server may trust `X-Captured-At`.
- **What the spec said:** the server "accepts it when captured before the window ended and arriving within 72h". No trust statement.
- **What was decided instead, and by whom:** the executor trusted the header. A forged header can push a late write past the window.
- **Was the decision right:** unknown; no one decided. S5 recorded an accepted risk for last-day break-down only, not this.
- **Cost:** a security finding with no owner. Q27 raises it.
- **Class:** missing
- **Fix:** R1.

### SD-7 — Resolved answers never written back; the ledger says "not started" for 35 built units

- **Where:** `spec.md` §2 REQ-02, 09, 15, 22 still read "OPEN / blocked on Q5, Q6, Q8" although §12 resolves them; §14 sign-off boxes all unchecked; Q22 `open` while the shipped behaviour is the answer; `units.md` ledger Status = `not started` on all 35 rows.
- **What the executor needed to know:** the current state. Units.md itself warns of the §2 contradiction ("Someone should update §2").
- **What was decided instead, and by whom:** executors followed §12. Nobody updated §2, §14 or the ledger.
- **Was the decision right:** right call, stale record. This is `stale-reference` again.
- **Cost:** the next reader gets contradictions; the ledger cannot answer "what is built".
- **Class:** stale reference
- **Fix:** R5.

## 2. Executor defects — what was built against the spec

### ED-1 — Floating step raised the sequential high-water mark (U5)

- **Where:** web progress derivation in `apps/web` (U5).
- **Spec said:** REQ-03 Pre-Trip, Post-Trip and JSA float, i.e. they sit outside the sequence.
- **Built:** a floating step's own capture advanced the sequential mark, so earlier steps inferred as done.
- **Caught by:** analyst review. Fixed on uhm-series.
- **Class:** over-broad condition (new class). The high-water rule applied to steps it was never meant for.
- **Fix:** R2 (negative-case rows), R6.

### ED-2 — `leftJob` closed `WORK_AT_JOB_SITE_TIME` for every flow (U3)

- **Where:** U3 `leftJob` handler.
- **Spec said:** REQ-02 "Left Job closes their `WORK_AT_JOB_SITE_TIME`" for STANDARD tickets.
- **Built:** closed for all flows (FULL too).
- **Caught by:** analyst review. Fixed.
- **Class:** over-broad condition.
- **Fix:** R2.

### ED-3 — Window guard accepted any APPROVED request regardless of kind (LT)

- **Where:** `ticket-write-window.util.ts`, `resolveTicketWriteGrant`.
- **Spec said:** REQ-20 "editing a COMPLETE ticket goes through the request flow (kind `SUBMITTED_EDIT`)"; Q7 resolved two kinds.
- **Built:** an approved `LATE_COMPLETION` unlocked edits like `SUBMITTED_EDIT`.
- **Caught by:** analyst review. Fixed (now `SUBMITTED_EDIT`-only for edits). REQ-19's `APPROVED_EDIT` mode note did not name a kind, which contributed; REQ-20 did.
- **Class:** over-broad condition.
- **Fix:** R2.

### ED-4 — Replayed submit of a COMPLETE ticket after the window returned 409 (LT5)

- **Where:** `enforceTicketWriteWindow` / `submitTicket`.
- **Spec said:** Q22 workaround, labelled: bare resubmit stays idempotent (preserves SCRUM-OFFLINE-SYNC U7 idempotency).
- **Built:** the window guard 409'd the replay after the window closed, contradicting the labelled workaround and the shipped outbox-idempotency rule.
- **Caught by:** analyst review. Fixed (idempotent).
- **Class:** contradicted source (an existing verified idempotency path).
- **Fix:** R2 (a regression row for "replay after the window").

### ED-5 — API would not boot when H3 and H6 merged (DI)

- **Where:** `JobProgressModule` providing `TicketHoldoverService` after H3 changed its constructor to need `JobTicketsService`.
- **Spec said:** Q13 decision: pure extract, bare `TicketHoldoverRepository`; no module cycle.
- **Built:** each unit passed its own tests; nothing compiled the Nest module graph. Found at consolidation.
- **Caught by:** consolidation review. Fixed; a module-init regression test was added.
- **Class:** gate illusion. Per-unit gates cannot see a cross-unit provider wiring break.
- **Fix:** R6.

### ED-6 — The two consolidated branches sit on different bases

- **Where:** `feat/ticket-flow-uhm-series` on `1056f2aa6`; `feat/ticket-flow-lt-series` on `d09a8209f` (38 commits ahead; `1056f2aa6` is its ancestor).
- **Spec said:** executor instructions: branch from `origin/main` first; units.md chain keeps stacked ids.
- **Built:** LT executors re-fetched a newer `origin/main` mid-run, so the series split. The two will conflict at merge; the units that cross the series (LT10 after H3, LT5 "rebase after U5", LT17 after U5/M6) were built against different bases.
- **Caught by:** noticed during consolidation. Not caught by any gate.
- **Class:** gate illusion. Nothing checks that every unit in one ticket shares a base.
- **Fix:** R7.

### ED-7 — Two stated REQ-21 pieces not built (LT)

- **Where:** `TicketEditRequest.submittedAt` (REQ-21 field list, spec §3) never written; the partial unique index violation has no `P2002` to 409 mapping.
- **Spec said:** REQ-21 "partial unique index makes a second open request fail"; the model lists `submittedAt`.
- **Built:** the field exists and is never set; a second open request surfaces as a Prisma error, not a 409.
- **Caught by:** analyst review. Follow-up, not fixed.
- **Class:** gate illusion. Tests asserted the index exists, not the API response.
- **Fix:** R2.

### ED-8 — Reminder cron marks dedup before notifying and has no offset upper bound (LT8)

- **Where:** `notification-scheduled-jobs.service.ts`, LT8 reminder scan.
- **Spec said:** REQ-23 +12h/+20h reminders; Q24 look-back open.
- **Built:** dedup row written before the notify call (a failed notify is never retried); no upper bound on the offset window.
- **Caught by:** analyst review. Follow-up, not fixed.
- **Class:** gate illusion.
- **Fix:** R2.

### ED-9 — Resubmit of a returned ticket bypasses the missing-steps block; a wrapper is left behind (U5/U6)

- **Where:** U5/U6 submit guard; `compose-ticket-detail.ts` still calls the `visibleFlowStepKeys` wrapper.
- **Spec said:** REQ-04 "blocked ... when any required step ... is missing."
- **Built:** the returned-ticket resubmit path skips the check; the old wrapper remains in use.
- **Caught by:** analyst review. Follow-ups.
- **Class:** gate illusion.
- **Fix:** R2.

### ED-10 — Three units exceeded the ~400-line cap

- **Where:** H2 451 lines, LT6 690 (split into LT6a/LT6b), LT16 545.
- **Spec said:** root `CLAUDE.md` cap of ~400 source lines; units.md sized H2, LT6, LT16 as M.
- **Built:** LT6 split (genuinely two seams); H2 and LT16 are `size-exception` candidates and need the label plus a written reason before push; I cannot confirm that happened.
- **Caught by:** `pr-size.yml` red check at best (it cannot block on the free plan).
- **Class:** gate illusion. The ledger's S/M size column carries no line estimate, so the cap was found after the build.
- **Fix:** R8.

### ED-11 — Two structural choices recorded as Haris's with the AI as the actual chooser

- **Where:** `spec.md` §12 Q13 ("Haris, 2026-10-16, delegated to the AI recommendation") and Q21 ("Haris, 2026-10-17, via the AI driving the loop").
- **Spec said:** root `CLAUDE.md`: an AI never fills the *Decided by* column and never records its own suggestion as decided.
- **Built:** Q13 chose Option C (a third option, not the AI's recommended A) and Q21 fixed FK targets and on-delete; both are recorded under Haris. I cannot tell from the files whether Haris stated either choice.
- **Caught by:** not caught. Flagged here for a human to confirm or correct.
- **Class:** undecided structure (new to this index's vocabulary use).
- **Fix:** R9.

### ED-12 — A service imports a usecase type (layering nit)

- **Where:** a `service/` file with a type-only import from `usecase/` (H series).
- **Spec said:** `presentation -> usecase -> service -> orm`, never upward.
- **Built:** type-only upward import. No runtime cycle.
- **Caught by:** analyst review (nit).
- **Class:** layer violation. Lint has no rule for it, so passing lint proves nothing.
- **Fix:** R10.

## 3. Source and vault findings

- **Sources that turned out to be wrong or stale:**
  - `spec.md` §2 REQ-02, 09, 15, 22 and the §14 boxes — say OPEN/unchecked; §12 says resolved. Tagged: the REQs `[UNVERIFIED]`.
  - `units.md` ledger — Status `not started` on 35 built units; true is built (two branches).
  - `/home/codingcops/.claude/plans/right-now-we-display-whimsical-squirrel.md` — the PLAN is outside the repo and the overlay; the spec cites it as source for REQ-07, 11, 14, 20 and Q7/Q8. If it is lost, those answers lose their source.
  - **Does the `[UNVERIFIED]` tag predict anything here?** Not measurable. 29 of 33 REQs carry it because both decision notes are `status: reference`; a uniform tag has no information. Zero analyst findings trace to a false source; the defects trace to a thin spec (SD-1, SD-5, SD-6) and executor scope errors (ED-1 to ED-3). Promoting DN-1/DN-2 to `verified` (a TCG ratification) is the useful action, not per-REQ re-verification.
- **Conflicts that surfaced only during build:** none found in the vault. One internal conflict: REQ-20 vs. Q22 (edit locks at once vs. what a replayed submit does), which the build settled in code (ED-4).
- **Questions answered by a named human during the build, and whether written to `decisions/`:**
  - Both decision notes dated 2026-10-15 are **still untracked in the overlay** (`git -C .ai status`: `??`), and `spec.md` §14 asks for them committed.
  - Captured in a note: Q6 (PM gets `payroll-admin:edit`) matches DN-2 L5; Q7 and Q8 came from the plan (not in a note).
  - **Not in any `decisions/` note: Q5** (Home-start paid time = Arrive Job to Left Job; STANDARD meal fallback without payroll sign-off), **Q9** (backfill rule from `ActivityLog`), **Q10** (seventh member `TICKET_LATE_CAPTURE_ACCEPTED`), **Q13** (Option C pure extract), **Q21** (FK targets, `Restrict`/`SetNull`). The answers sit only in `spec.md` §12, which is ticket-local.
  - Answer: written = 0 of 5. `tcg-scrum` holds the write path. Q5 is a pay-rule change; no engine file changed in either diff, so no provenance entry is required, but a payroll owner has not been told of the Home-start rule.
- **`gaps.md` entries this ticket should close:** `field-ops/gaps.md:905` (Q1), `:927` (Q2), `:987` (Q3), `:1032` (Q4) stay **open** — the build did not answer them. Nothing to close. When Q1-Q4 are answered, the frontmatter edits fall on the winning and losing files of the three field-ops FRDs named in the spec's conflict stub (`conflicts_with`); the build did not adjudicate them.
- **Questions this ticket opened:** spec §12 Q1-Q26 (executor-raised Q9-Q26), plus **Q27** (X-Captured-At trust), **Q28** (previous-ticket match on a shared slot line), **Q29** (no `slotTypeName`) appended by this reflection. Q22 should be set to `resolved` with the idempotent behaviour; I could not edit an existing status.
- **Undefined terms hit:** "worker" (DN-2 L7 for a folded Operator), "previous ticket" for a shared slot line, "closing-soon" (Q20).

## 4. Rule changes proposed

Haris-only files (`.ai/claude/**`, `.ai/aidlc/agents/**`, `.ai/aidlc/templates/**`). `git -C .ai config user.email` here is `abdulmuazzam@codingcops.org`, not Haris's; I did not edit any of them.

| # | File | Section | Exact change | Prevents | Accepted |
| --- | --- | --- | --- | --- | --- |
| R1 | `.ai/aidlc/templates/spec.md` | requirement block | Add two required fields after *Acceptance*: `**When the input is absent:** <behaviour, or NONE FOUND -> raise a Q>` and `**Trust boundary:** <who supplies each input and whether the server believes it, or N/A>`. Add to `agents/inception/tcg-elaborator.md`: "A requirement with either field blank is not emitted; raise a §12 question." | SD-3, SD-5, SD-6 | pending |
| R2 | `.ai/aidlc/templates/spec.md` + `templates/units.md` | requirement *Acceptance*; unit *Test plan* | Add required field `**Does NOT apply when:** <the cases the rule must leave alone>` on every requirement that has a condition (STANDARD only, one kind, floating). In units.md the test plan needs one row per `Does NOT apply when` item. Also require, per unit, one test for each REQ field the model lists (a field written at least once) and one API-level test for each uniqueness or window constraint (response code, not index existence). | ED-1, ED-2, ED-3, ED-4, ED-7, ED-8, ED-9 | pending |
| R3 | `.ai/aidlc/templates/spec.md` | §9 Validation rules | Add: "Every list endpoint states its page size and max; every free-text field states its length cap; every user-visible string is listed with its source or marked `COPY: provisional`." | SD-1 | pending |
| R4 | `.ai/aidlc/agents/inception/tcg-decomposer.md` | slicing rules | Add: "If two units name the same provider, constructor or module in their Slice contents, one `Depends on` the other, or the ledger notes why not. Check with `git grep -ln '<ProviderName>' -- apps/api/src` per provider." | SD-4 | pending |
| R5 | `.ai/aidlc/agents/construction/tcg-executor.md` | §Output shape | Add: "When a unit's `Status` becomes `built`, set the ledger cell to `built — <branch>` and, if a §12 question was resolved in the unit, mirror the answer into the matching §2 REQ line and set `Status: resolved`. The unit is not reported complete until both are done." | SD-7 | pending |
| R6 | `.ai/claude/contexts/api.md` | Testing | Add: "A unit that changes a provider constructor, module `providers` or `imports` array must pass a Nest module-compile test: `Test.createTestingModule({ imports: [AppModule] }).compile()`. Keep one such test in the repo so `pnpm test` runs it on every consolidation." Mechanical rail: the same test, run in `.github/workflows/`. | ED-5, ED-1 (partly) | pending |
| R7 | `.ai/aidlc/agents/construction/tcg-executor.md` | §1 first step | Add: "Record `git merge-base HEAD origin/main` in the ledger on unit 1 of a ticket. For every later unit, branch from the stacked parent branch, never from a fresh `origin/main`. If `origin/main` moved mid-ticket, stop and ask: do not rebase some units and not others." | ED-6 | pending |
| R8 | `.ai/aidlc/templates/units.md` | Size column | Replace S/M/L with `~<n> src lines`; a unit estimated over 350 carries `size-exception? yes/no + reason` filled by the decomposer. | ED-10 | pending |
| R9 | `.ai/aidlc/templates/spec.md` | §11b/§12 *Decision* line | Make a Decision line require `Stated by: <developer> in <PR comment / Slack permalink / session date>`. A decision "delegated to" or "via the AI" is recorded as `AI proposal, pending developer confirmation`, and the unit does not merge until a developer confirms. | ED-11 | pending |
| R10 | `eslint.config` (root) | `import-x/no-restricted-paths` | Add zones: `apps/api/src/service` may not import from `apps/api/src/usecase` or `presentation`; `usecase` may not import from `presentation` (module-registration files excepted). | ED-12 | pending |

- **Test against the defect.** R2 would have prevented ED-1, 2, 3: each had a stated qualifier ("STANDARD", "floating", "SUBMITTED_EDIT") that a `Does NOT apply when` test row would have exercised. R6 would have failed ED-5 at the unit that introduced it. R7 is a prose rail that executors already carry ("branch from origin/main first") and ignored under a moved main; the rail that actually holds is the merge-base line in the ledger, which a reviewer can check by eye. R9 is process, not mechanical; it needs `review-pr` to flag a structural decision with a `via the AI` note.
- **Rejected proposals, and why:**
  - A "no `origin/main` fetch mid-ticket" rule in the executor prompt alone: the existing "branch from origin/main first" already reads as an invitation to fetch. Replaced by R7's merge-base record.
  - Add a size-cap block to `pr-size.yml`: the free plan cannot block a merge; covered by R8 at decomposition time instead.
  - A new `ActivityLogAction` lint: Q10 was settled by a human before the migration; no defect.

## 5. Recurrence check

| Defect | Class | Prior rows | Occurrence | Why the previous fix did not hold |
| --- | --- | --- | --- | --- |
| SD-1 | invented-value | none | 1st | N/A |
| SD-2 | missing-requirement | 9 (SCRUM-877 SD-1/2; SCRUM-252 SD-3/4; PAYROLL-FLAGS SD-1-5) | **3rd+** | see ESCALATION |
| SD-3 | missing-requirement | same 9 | **3rd+** | see ESCALATION |
| SD-4 | missing-requirement | same 9 | **3rd+** | see ESCALATION |
| SD-5 | missing-requirement | same 9 | **3rd+** | see ESCALATION |
| SD-6 | missing-requirement | same 9 | **3rd+** | see ESCALATION |
| SD-7 | stale-reference | 4 (SCRUM-900 ED-3, SCRUM-926 ED-3, SCRUM-252 ED-5, LOADOUT SD-1) | **3rd+** (5th) | SCRUM-900 ED-3 (a ledger cell that does not match the repo) is still `proposed`, never written; same cell wrong here |
| ED-1, 2, 3 | over-broad-condition (new) | none | 1st by ticket, 3x inside this one | N/A |
| ED-4 | contradicted-source | 2 (SCRUM-926 ED-1, SCRUM-252 SD-2) | **3rd** | fix at SCRUM-926 ED-1 is `applied` in `tcg-executor.md` §3, but a labelled workaround in the spec was the contradicted source, which §3 does not cover |
| ED-5 to ED-10 | gate-illusion | 7 (SCRUM-900 ED-1/2, SCRUM-926 ED-4/5, SCRUM-252 ED-1, LOADOUT ED-1/2) | **3rd+** (8th-13th) | Prior fixes are prose or a CI step that soft-warns (SCRUM-252 ED-1: `AI_LAYER_DEPLOY_KEY` never provisioned). Written, and not enforced: `.github/workflows/` still runs nothing but `pr-size.yml` and `deploy.yml` |
| ED-11 | undecided-structure | none | 1st | N/A |
| ED-12 | layer-violation | none | 1st | N/A |

- **Escalate (first):**
  - **`missing-requirement` (third+ occurrence, 9 prior rows):** this is not a reminder problem. Prior fixes were applied to prose in `contexts/api.md` and none to the spec template that creates the gap. The structural mechanism is a **required field in the spec template and a refusal in the elaborator** (R1, R3): a requirement without *When the input is absent* and *Trust boundary* cannot be emitted. Nine classes of silence from nine tickets share this shape (a degenerate or absent input).
  - **`gate-illusion` (13th row):** previous fixes were written and ignored or soft-warned. Remedy is a **test that fails**, not another line: the AppModule compile test (R6) and the stacked-base merge-base record (R7). Until CI runs `pnpm test`, R6 is also a hand-run gate; say so in api.md.
  - **`stale-reference`, ledger status:** SCRUM-900 ED-3 asked for the ledger Status fill rule in `templates/units.md`. It is still `proposed`. R5 moves the duty into the executor's own report so a unit cannot be reported complete with the cell wrong.
  - **`contradicted-source` (3rd):** the source this time was a spec-labelled workaround, not a decision note. Add to R2: every labelled workaround in §12 becomes a test row in the unit that builds it.
- **New class added to the index?** yes: `over-broad-condition` — a rule, guard or effect built to fire on a wider set than the spec's qualifier (all flows for STANDARD, any request kind for one, all steps for floating ones), found by review not tests. None of the existing classes fit: `gate-illusion` covers "lint passed", and this is about the shape of the condition. Row added to the index table.
- **Rows appended to `reflections/INDEX.md`:** yes (19, one per SD/ED group above).

## 6. Kept as-is

- **Not building REQ-30-33 and keeping the Q1-Q4 workarounds** — correct: the units list them under *Deliberately not in this unit*, and no executor filled the gap. SD-2 records it; it is not an executor fault.
- **Last-day break-down enforced on mobile only, not the API** — S5 in DN-1 is an accepted risk, a decision, not an oversight. Do not reopen unless the API gains a reason to enforce it.
- **LT6 split into LT6a/LT6b (690 lines)** — the split was warranted by a real seam.
- **A usecase module importing its controller** — the sanctioned NestJS registration exception.
- **Idempotent bare resubmit (Q22 workaround)** — preserves outbox U7; keep it, and close Q22 as resolved.
- **Q13 Option C (pure extract plus bare repository)** — consistent with `JobTicketsModule` injecting `TicketTimeEntriesRepository` bare. The choice is fine; only its recorded author is queried (ED-11).
