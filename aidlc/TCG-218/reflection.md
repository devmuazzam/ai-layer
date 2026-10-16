# Reflection — TCG-218 Quotation: per-association quote visibility, Quotation Type (Hourly / Hourly w/ Mob), Mob/Demob groups, customer documents, dispatch slots, configuration snapshot

> Written by `tcg-reflector` on 2026-10-17 after the last unit (U13, #830) merged.
> **Proposals only.** Nothing under `.ai/claude/**`, `.ai/aidlc/agents/**`, `templates/` or `GUIDE.md` was changed — those go to Haris.
> Evidence: `spec.md` §11b/§12, `units.md` ledger, PR bodies (#789–#830), `git log origin/main --grep=TCG-218`. Items 6 and 7 of the brief come from the session, not from any PR body or artifact; they are marked "session-observed".

## 0. Context

| Field | Value |
| --- | --- |
| Ticket | `TCG-218` (Linear, TCG Platform, Cycle 2); `TCG-202` folded in |
| Spec | `.ai/aidlc/TCG-218/spec.md`, elaborated 2026-10-14 |
| Units | U1, U2 (a/b), U3, U4 (a/b/c/d), U5 (a/b), U6, U7, U8, U9, U10 — shipped as decomposed or split at build. **Added after decomposition: U4d, Q50, U11 (a-1/a-2/b), U12, U13** — shipped. 48 commits on main; ~28 PRs. |
| Reflected on | 2026-10-17 |
| Reviewer(s) | Syed Haris (ticket owner, developer); `tcg-analyst` verdicts in PR bodies are "ship" or "ship with follow-ups" throughout; U13 had no analyst or guardian run |
| Open questions at build time | **18 at sign-off (Q1–Q18, all answered before build). 64 by close.** 46 were raised during the build (Q19–Q64), almost all by `tcg-executor` / reviewers *before* writing the affected code, i.e. the stop-and-ask rail worked. The expensive ones are the ones the ticket owner raised himself while testing (Q30, Q42, Q50, Q51, Q64) |
| `[UNVERIFIED]` requirements built | **22 of 22** (every REQ is tagged). **4 proved wrong or incomplete**: REQ-07 (crane absent from its own pair, Q42), REQ-11/12 (add was one-way, Q50), REQ-13 / D9 (`PA` billing code cannot exist, D9 → D9a), REQ-14 (Mob/Demob lines only → every line net, Q45/Q62/Q63). The tag is uniform on this ticket, so it carries no signal here — see §3 |
| Unverified × irreversible | 3. **Flagged before build: 2** — U7 Q2 one-way reset of stored group quantities (named in `units.md`), U9/U10 enum members `OPTIONAL`/`NONE` (sequenced last). **Found during build: 1** — `jobs.configuration_snapshot`, added in U11a-1 and dropped by U13 a day later (reversible, caught fast, but not flagged because it rested on a ticket-owner answer that looked settled) |

---

## 1. Spec defects — what the spec missed

### SD-1 — Nothing stated whether quote/job behaviour reads the asset configuration live or as quoted

- **Where:** nowhere — §11a R8 lists conversion and the DAS as consumers of `isRequired` / association rows but has no column for *when* the read happens; REQ-01..04 add configuration settings that quotes then depend on.
- **What the executor needed to know:** whether a won quote, a converted job and the dispatch board see a configuration edited after the quote went out.
- **What the spec said:** nothing. R8 "what happens to it" described group rows and visit days only.
- **What was decided instead, and by whom:** the ticket owner asked it himself on 2026-10-16 ("if I change the asset config after a quote is won, does it affect it?") and answered "Freeze at quote save" (Q51). Q51's own findings: conversion (`materialize-job-resources.ts`, U9 `job-resource-dispatch.ts`) and the board (`missing-components`) read the **live** configuration, and (b)/(c) *predate* TCG-218 — but U9 and U10 extended both readers without a unit asking the question.
- **Was the decision right:** yes (precedent `PayrollRun.configurationSnapshot`). But it was unscheduled: U11a-1, U11a-2, U11b, plus Q56 (5 sub-decisions), Q57, Q60, Q61.
- **Cost:** three PRs and ~700 changed source lines after the units were "done"; two migrations; the Resources tab, conversion and the board were each re-touched.
- **Class:** missing — the spec tracked *what a quote shows* and never *which version of a mutable catalogue the quote is bound to*.
- **Fix:** R1.

### SD-2 — The snapshot was specified for "send", but the quote reaches Won/job by other paths

- **Where:** Q51 "when" clause (spec §12); `units.md` U11a.
- **What the executor needed to know:** every transition that makes the quote contractually fixed: send by email, send by signature, PATCH to Sent, **Mark as Won from Draft**, create-as-Sent, direct PATCH `status: WON`, conversion.
- **What the spec said:** "first sent to the client (any send path that moves it to Sent to Customer), or at conversion if never sent".
- **What was decided instead, and by whom:** Mark as Won from Draft was not a send. A scenario run (QUOT-00027 → JOB-00015, which took the *changed* configuration) found it; ticket owner chose A (Q58). The direct-PATCH sibling (Q59) was deliberately left open; create-as-Sent was deferred (Q57 C).
- **Was the decision right:** Q58 yes. Q59 still unknown — a direct API call sets WON with no snapshot, no award date, no evidence.
- **Cost:** a bug that reached a built, reviewed unit; found by a hand-run scenario, not by the analyst. The Q58 hook then pushed U11a-1 to 407 lines (see §6).
- **Class:** missing — the status-transition set was never enumerated, so "any send path" stood in for a list.
- **Fix:** R2.

### SD-3 — REQ-07 said the crane is not in its own Mobilization group; the vault's template said it is

- **Where:** REQ-07 and `decisions/2026-10-06-quotation-type-hourly-or-hourly-with-mob.md` point 3.
- **What the executor needed to know:** the shape of an Hourly w/ Mob block as FCC prices it.
- **What the spec said:** groups hold only the crane's Sub items.
- **What was decided instead, and by whom:** the ticket owner, in the U7 browser review, pointed at `vault/quotations/fcc-estimate-templates-by-job-type.md` §2 (crane is the first line of both blocks). Answer "Yes, auto-added first" (Q42) → new unit **U4d**, a decision note, and an amendment to REQ-07.
- **Was the decision right:** yes; the template is an existing, findable client artefact.
- **Cost:** one added unit (115 lines) and a ripple note into U9 (the crane's own Mob line must not become a slot — keyed on the parent group). U4–U7 were already built on the wrong shape.
- **Class:** missing, and **sourced from the wrong file** — the REQ was sourced from an `[UNVERIFIED]` decision note while a vault document for the same artefact was not compared.
- **Fix:** R3.

### SD-4 — "Twin" rule specified for one operation on one side

- **Where:** REQ-11 / REQ-12; Q38(d).
- **What the executor needed to know:** for add, rename, delete × Mobilization, Demobilization — which mirror, at what quantity.
- **What the spec said:** add Mob → Demob at 0; rename and delete follow in both directions. Add in Demob: nothing.
- **What was decided instead, and by whom:** Q38(d) fixed the asymmetric rule; the ticket owner found the one-way clone while testing U9 and ruled it symmetric (Q50: "deleting deletes both and adding adds on both as well"), with Demob → Mob twin starting at **1**, not 0, and quantities independent. Built as unit **Q50**; Q53 followed.
- **Was the decision right:** yes.
- **Cost:** a unit (76 lines) plus Q53; also the 0-vs-1 initial quantity (REQ-22) had to be restated per direction.
- **Class:** missing — a mirror rule has an operation × side matrix; the spec filled one cell.
- **Fix:** R4.

### SD-5 — Customer-document presentation was scoped to the lines the ticket was about

- **Where:** REQ-14 ("Customer documents show Mob/Demob lines only"), Q7, Q44–Q46; U8 → U12.
- **What the executor needed to know:** what the customer sees for discounts and price hikes, on every line.
- **What the spec said:** how Mob/Demob lines print; discounts only implicitly (footer rows per the 2026-09-11 decision).
- **What was decided instead, and by whom:** U8 built "Mob/Demob lines only". Joe Schacatano's replies of 2026-10-17 widened it in two steps (inner discount net on the Mob line → "Discount kept internal. We don't want a discount line to show to the customer."). The first step had already been built as a narrow U12 (Q62: ~uncommitted on the branch) when the second reply arrived; U12 was reworked and Q63 raised (net Rate rounding, "Reason for Internal Approval" box removed from print). It **reverses** `decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md` for customer documents.
- **Was the decision right:** yes, and client-confirmed — the only client-sourced answer on the ticket that changed built behaviour.
- **Cost:** a discarded narrow build, U12 at 331 lines / 224 deletions, a decision note owed, and a vault decision now contradicted.
- **Class:** missing. The client question asked the narrow thing ("Mob/Demob only?") before the scope thing ("does the customer ever see a discount?"), so the narrower answer was built before the broader one existed.
- **Fix:** R5.

### SD-6 — Units named "vertical" were split at build into halves that could not ship alone

- **Where:** `units.md` ledger — U2 "~370 at risk", U4 "~380 at risk", U5, U11 "size not estimated — shape open".
- **What the executor needed to know:** where to cut so each PR is demonstrable and deployable.
- **What the spec/units said:** "at risk" plus a named split line in prose; U11's original entry carried "Size estimate: not estimated".
- **What was decided instead, and by whom:** executors split at build into U2a/U2b (**API half / web half**), U4a/b/c (+d), U5a/b, U11a-1/a-2/b. #797's body states "Deploy: nothing deploys between U4 and U6" because lines auto-filled at quantity 0 are rejected by the web until U6. The ledger's own rule ("one unit = one vertical slice") was met in name by the unit and not by the PR.
- **Was the decision right:** the splits were forced by the 400-line budget, which held. The defect is that the decomposer put the cut on the executor.
- **Cost:** 4 stacked PRs for U4 alone; 2 stack mishaps (ED-2); U4's first PRs shippable only in combination.
- **Class:** `unit-not-vertical`.
- **Fix:** R6.

### SD-7 — The job's copy of the snapshot was specified without weighing a read through the relation

- **Where:** Q51 "U11 shape" (3): "copies it onto the job"; U11a slice rows.
- **What the executor needed to know:** whether a second persisted copy is needed when `jobs.quotation_id` already reaches the first.
- **What the spec said:** Q51's "Open for U11" listed *how jobs keep it* with the options "copied at conversion" and (implicitly) nothing else.
- **What was decided instead, and by whom:** the ticket owner decided "copy" (Q51), then reversed it a day later (Q64, "no unnecessary tables"): a quote's snapshot is never rewritten (conditional write, converted quote locked), a job links to at most one quote, so the copy always equalled the source. Checked on 6 of 6 local jobs. U13 dropped the column (32 lines, one more migration) — and was merged without a guardian or analyst run.
- **Was the decision right:** Q64 yes; Q51's job copy no.
- **Cost:** a migration pair, a deploy-order note, `OMIT_SNAPSHOT` plumbing added in U11a-2 and removed in U13.
- **Class:** `over-built`. The guardian's "is it redundant?" check did not catch it because the decision to copy was already a recorded developer decision — the redundancy test never ran against an explicit decision.
- **Fix:** R7.

## 2. Executor defects — what was built against the spec

### ED-1 — Snapshot reader broke `createdAt` ties by `id`; the live read does not

- **Where:** U11a-1 snapshot reader (`configuration-snapshot.ts`); fixed in the U11b PR (#828).
- **Spec said:** "same configuration as the live read" — snapshot reads must behave like live reads.
- **Built:** `orderBy: [createdAt, id]`. `createMany` rows share one `created_at`, so ties re-ordered brought-along lines against the configured order (JOB-00014: Oiler before Operator Load).
- **Caught by:** `tcg-analyst` on U11b (not by tests; none were run).
- **Class:** invented-value (a sort order tracing to no requirement) where the existing sibling read was in front of the executor.
- **Fix:** R8.

### ED-2 — Two stacked-PR merge mishaps on one ticket

- **Where:** #791 (U2b) merged into U2a's branch instead of `main`, then re-landed as #792; #797 (U4b) closed when its base branch (U4a's) went away, re-landed as #799.
- **Spec/rules said:** `CLAUDE.md` "Dependent units ship as stacked PRs… GitHub retargets U2 to `main`." #797's own body carries a banner "Merging a stacked PR into its old base is how #791 missed `main`" — written *after* the first mishap, *in* the PR that then had the second.
- **Built:** n/a — a merge-order failure, not a code one. No work lost (both re-landed).
- **Caught by:** the developer, afterwards. Nothing in `pr-size.yml` or any hook looks at a PR's base.
- **Class:** `branch-ops` (new — see §5).
- **Fix:** R9. This is "written and ignored" at the unit of one ticket: prose in a PR body did not hold.

### ED-3 — Branch creation moved the live dev checkout (session-observed)

- **Where:** the developer's primary checkout, mid-test.
- **Rules said:** `tcg-executor.md` "Before the first edit: One unit, one branch… branch from `origin/main`"; worktree guidance exists but is "the usual case for an agent", not required.
- **Built:** a branch in the primary checkout landed on a newer `origin/main` (schema and `@tcg/shared` changed) while the app was running, forcing `prisma generate`, a shared rebuild and an API restart. No PR records this; the evidence is the session.
- **Caught by:** the developer, by the app misbehaving.
- **Class:** `branch-ops`.
- **Fix:** R10.

### ED-4 — No gate ran on any unit, and `main` was red at the end

- **Where:** every PR from #796 on says "Not run: lint, build and tests, per the developer's instruction"; U11a-2/U11b/U12/U13 report ESLint clean on touched files and API `tsc` clean only. End-of-ticket `pnpm lint && pnpm build` failed on breakage **not from TCG-218** (session-observed: `calendar.tsx` type error from #709; a 365-line DAS test file from #827).
- **Spec said:** `spec.md` §10 test plan (integration: settings persist, type persists, backfill, …); `tcg-executor.md` "Before you hand back: `pnpm lint` and `pnpm build`… say which failures are pre-existing".
- **Built:** the deferral was the developer's explicit, recorded instruction (also in memory: long features defer lint/build to the end). The defect is what the deferral cost: the one run that was meant to certify the ticket hit a red `main` with no baseline recorded earlier, so TCG-218 cannot be certified by any gate and nobody can say which failures are the ticket's.
- **Caught by:** the end-of-ticket run itself, i.e. at the latest possible moment.
- **Class:** gate-illusion (the PRs read "ESLint clean on touched files"; that is not lint-clean, tsc-clean or tested).
- **Fix:** R11. Not proposed: forcing per-PR full lint/build — the developer's deferral is a deliberate trade for long features and is recorded in §6.

## 3. Source and vault findings

Every line has a proposed disposition. None is applied: `tcg-scrum` writes decision notes; any agent appends to spec §12.

**Sources that turned out to be wrong or stale**

| Source | What it says | What is true | `[UNVERIFIED]` in the spec? | Disposition |
| --- | --- | --- | --- | --- |
| `decisions/2026-10-06-quotation-type-hourly-or-hourly-with-mob.md` pt 3 | Groups hold only Sub items | Crane is the first line of both blocks (`fcc-estimate-templates-by-job-type.md` §2) | yes (REQ-07) | **Already** amended by `2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md`. Remaining edit: add `superseded_in_part_by` on the 10-06 note's frontmatter (`tcg-scrum`) |
| `decisions/2026-09-11-quotation-footer-discount-and-price-hike-rows.md` rules 2–3 | Row Amount is before adjustment; footer rows carry the adjustment money | On **customer documents** every line is net and there are no Discount / Price Hike rows (Joe, 2026-10-17); internal screens unchanged | n/a (status `reference`, Fouzan Shakil) | **New decision note** (see below) with `supersedes_in_part` the 09-11 note; set 09-11 `conflicts_with` the new note until the frontmatter edit lands. Also affects `quotations/gaps.md:1072-1080` (UAT 1 "Final Amount" entry cites rule 2/3) — append a pointer, do not edit |
| D9 / REQ-13: Price Adjustment billing code `PA` | Match code `PA` | Codes are minted by sequence (`BCCT-00021`); no tenant has `PA` | yes | **Already** D9a (title match). No further action |
| `spec.md` §12 Q1–Q18 statuses | "decision note pending" | `decisions/2026-10-07-tcg-218-open-questions-answered-by-the-ticket-owner.md` exists | — | Q65(c) below asks to confirm the 10-07 note covers them and flip the status lines |
| `spec.md` §0 "Open questions raised: 18", §14 sign-off checklist (all boxes unticked) | — | 64 questions; the build went on regardless | — | Q65(b) |
| `units.md` original U11 entry ("copies to `jobs.configuration_snapshot`") | job copy | dropped by U13 | — | Already annotated in the ledger; no action |

Tag outcome: all 22 REQs were `[UNVERIFIED]`; 4 proved wrong or incomplete (SD-3, SD-4, D9, SD-5) and 18 stood. On this ticket the tag cannot discriminate (it is blanket), so nothing here says the vault should be promoted in bulk. The signal worth having: **of the four wrong, three would have been caught by comparing against an existing vault/client artefact (the FCC template; footer decision; the DB itself)** — i.e. verification against a source, not a tag.

**Unverified requirements made hard to reverse** — U7 one-way reset (flagged before build; migration carried a pre-deploy count query), `OPTIONAL`/`NONE` enum members (flagged), the persisted snapshot JSON `{version:1,…}` (versioned, additive), `jobs.configuration_snapshot` (found during build, dropped). Pattern: the one found late was reached through an *accepted ticket-owner decision*, which the analyst's "unverified × hard-to-reverse" check does not look at. Covered by R7.

**Conflicts that surfaced only during build**

1. FCC template vs decision 10-06 pt 3 (SD-3) — resolved Q42; note written.
2. Footer decision (09-11) vs Joe 2026-10-17 (SD-5) — new note needed; see above.
3. "Send" vs "Won" as the moment a quote is fixed (SD-2) — resolved Q58; Q59 open (guardrail deferred).
4. Live ordering vs snapshot ordering (ED-1) — resolved Q61.
5. `fcc-seeder/reset-tenant.ts` deletes `billingCodeCustomType` before `subCategoryAssociatedResource` (spec line ~807, "noted, not this ticket") — pre-existing RESTRICT failure; **disposition: gap** — append to `vault/quotations/gaps.md`? It is a code defect, not a product question, so propose a ticket instead; no vault entry.

**Questions answered by a named human during the build — decision notes**

Written: 1 of ≥7 — `2026-10-16-hourly-w-mob-item-is-first-line-of-its-own-mob-demob-pair.md` (Q42). The `2026-10-07` note covers Q1–Q18 era answers. **Not written (all go to `tcg-scrum`):**

| # | Proposed file | Covers | Decided by | Why it matters |
| --- | --- | --- | --- | --- |
| 1 | `decisions/2026-10-17-customer-documents-print-net-amounts-discounts-internal.md` | Q45 (Joe, 2026-10-16/17 replies: Qty = visits, Rate = one visit's total, Amount = Qty × Rate; discount kept internal; "We don't want a discount line to show to the customer"), Q46 (Unit "Each"), Q62, Q63 (net Rate rounded to cents; surcharge row unchanged; approval box off the print) | **Joe Schacatano (client)** for the rule; Syed Haris for the readings. Highest value: the only client-confirmed answer and it contradicts a decision note | Status candidate `verified` for the client-stated parts |
| 2 | `decisions/2026-10-16-quote-freezes-the-asset-configuration-snapshot.md` | Q51, Q56, Q57, Q58, Q59 (guardrail deferred), Q60, Q61, Q64 (no job column; board reads `job.quotation.configurationSnapshot`; no backfill) | Syed Haris | Rule for every future reader of the configuration; includes the "never refreshed" invariant U13 relies on |
| 3 | `decisions/2026-10-16-mob-demob-twin-rule-is-symmetric.md` | Q38(d), Q50, Q53 (add both ways; Demob→Mob starts at 1; quantities independent; missing billing code warns and clears on either twin) | Syed Haris | Amends REQ-11/12/22 |
| 4 | `decisions/2026-10-16-type-switch-relays-out-and-keeps-edits.md` | Q34, Q35, Q30 (hide "In total" on web only), Q31 | Syed Haris | Behaviour the next ticket (TCG-219 mobile, TCG-220) must match |
| 5 | `decisions/2026-10-16-visits-are-whole-numbers-and-saved-groups-reset-to-one.md` | Q20, Q40 (plain reset of Mob/Demob group rows with qty ≠ 1; stored name, any quote type) | Syed Haris | The only irreversible data migration on the ticket; the old quantities are not recorded anywhere but the PR |
| 6 | `decisions/2026-10-16-dispatch-slots-per-configured-machine.md` | Q47–Q49, Q52, Q54, Q55 (own Set on the board; OPTIONAL display; completion recalculation) | Syed Haris | The sibling 2026-09-12 decision on Optional associations is in conflict stub REQ-15; this is its adjudication |

Count not yet written: **6**. Joe's 2026-10-08 Teams reply is already cited in the 10-07 note (Q30 there).

**`gaps.md` entries this ticket should close** (live register is `vault/quotations/gaps.md`, 274 KB — grep, never whole)

- `quotations/gaps.md` ~l.1109 "(e) when a template changes, do existing quotations re-seed or stay a snapshot?" — settled for the asset configuration by decision #2 (snapshot at send / Won / conversion; no re-seed). Edits needed: set the entry `Status: resolved — see decisions/2026-10-16-quote-freezes-the-asset-configuration-snapshot.md`; frontmatter of the new note `resolves: quotations/gaps.md (e)`. The template-seed half of (e) may remain open — verify before closing.
- `quotations/gaps.md` ~l.1110-1112 "(f) does the job type sit on the quotation as a whole or per resource row" — settled by the 2026-10-07 note (type once per quote) and Q5/Q31. Same edit pattern; the winning file is the 10-07 note, nothing loses.
- `quotations/gaps.md` ~l.1072-1080 UAT 1 "Final Amount" entry — **not closed**: partially superseded by decision #1 for customer documents only. Append a note; do not mark resolved.

**`gaps.md` entries this ticket opened:** none in the vault. All questions live in spec §12 (Q19–Q64). Open on exit: **Q59** (direct PATCH to WON) and the new **Q65**.

**Undefined terms hit:** "Sent to Customer" vs "send" (which transitions count — Q57/Q58), "Mark as Won" vs status WON, "slot" vs "Set" on the board (Q48/Q52), "frozen"/"snapshot" (payroll's meaning vs the quote's). New to the known nine; propose adding "snapshot (configuration)" and "twin" to the glossary.

## 4. Rule changes proposed

All are proposals to Haris. Each was tested against its defect; where the proposal is prose, that is said.

| # | File | Section | Exact change | Prevents | Accepted |
| --- | --- | --- | --- | --- | --- |
| R1 | `.ai/aidlc/templates/spec.md` + `.ai/aidlc/agents/inception/tcg-elaborator.md` | §11a Ripple table; elaborator "Ripple" step | Add a required column **`Read time`** to every §11a row whose consumer reads a catalogue/configuration table. Allowed values: `live`, `frozen at <event>`, `n/a — <why>`. Elaborator line: *"A §11a row whose consumer reads configuration without a stated Read time blocks sign-off; `live` for a quote, job or document that the customer has seen is a §12 question, not a default."* **Test:** with §11a row R8 (conversion / board) in front of it, the column cannot be left blank and `live` on a job is a question → Q51 asked on 2026-10-14, not 10-16. Mechanical (blank cell fails §14), not a reminder. | SD-1 | pending |
| R2 | `.ai/aidlc/templates/spec.md` | §2 requirement block | Add field **`Reached by`**: *"every action or endpoint that can reach the state this requirement keys on (e.g. send by email, send by signature, Mark as Won, PATCH status, convert, duplicate) — one line each; a path you did not hook gets a §12 line saying so."* **Test:** listing Mark as Won and PATCH for "quote is fixed" surfaces Q58 and Q59 at spec time. | SD-2 | pending |
| R3 | `.ai/aidlc/agents/inception/tcg-elaborator.md` | Sources step | Add: *"For a requirement that defines a layout, document or workflow, `ls` the module's vault folder for an existing client template of the same artefact (`*template*`, `*-by-*`, `*sop*`) and list it under Sources. A difference from it is stated as **`Differs from <file> §n because <source>`** or becomes a §12 question; never a silent choice."* **Test:** `quotations/fcc-estimate-templates-by-job-type.md` is in the module folder; REQ-07 would have carried a "Differs from…" line or Q42 would have been a pre-build question. | SD-3 | pending |
| R4 | `.ai/aidlc/templates/spec.md` | §2 requirement block (new optional field, required when the REQ says twin / mirror / follows / syncs) | Add field **`Matrix`**: *a table of operation (add, edit, rename, delete, reorder) × side, each cell "mirrors / does not mirror / starts at <value>" with a source.* **Test:** the Demob→Mob add cell is empty and must be filled → Q50 pre-build. | SD-4 | pending |
| R5 | `.ai/aidlc/agents/inception/tcg-elaborator.md` | Questions for the client | Add: *"A client question about how a figure is shown on a customer-facing document asks the **scope first**: 'does the customer ever see X, on any line?', before 'on this line?'. Do not build the narrower reading until the scope reply is in."* **Test:** Q45(2) is rewritten from "before or after, on Mob lines?" to "does any customer line show a discount?"; Joe's answer is the same as 2026-10-17 and the narrow U12 is never built. Prose — the weakest of the set — but it changes what is *sent*, which is the only place it can bite. | SD-5 | pending |
| R6 | `.ai/aidlc/agents/inception/tcg-decomposer.md` | Units output | Add a refusal: *"A unit marked 'at risk', or with Size 'not estimated', is not written. Split it now into parts that each have their own 'Reviewable as' line. A part whose PR would carry 'nothing deploys until Un' is not a part: reorder the slice, or put the dependent behaviour behind the same PR. Splits along API / web are not vertical."* **Test:** U4's first PR (crane link + qty-0 lines) would have been refused; the `(a)/(b)` labels in the ledger would not exist. Mechanical (the decomposer refuses). | SD-6 | pending |
| R7 | `.ai/claude/contexts/prisma.md` + `.ai/aidlc/agents/construction/tcg-prisma-guardian.md` | §Conventions (new bullet); guardian "Is it needed?" | prisma.md: *"A column that copies a value already reachable through an existing relation (a snapshot, a denormalised copy) is accepted only when the source can change after the copy. The migration PR names the path by which it can change, or the copy is not added and the reader joins through the relation."* Guardian: *"Run the redundancy test on every column even when a developer decided it; report `decided but source never changes` as a finding."* **Test:** U11a-1's `jobs.configuration_snapshot`: the quote's snapshot never changes after a conditional write and `jobs.quotation_id` is read-only → finding at U11a-1, no U13. | SD-7 | pending |
| R8 | `.ai/claude/contexts/api.md` | §Reading frozen or copied data (new) | *"A reader of a frozen copy (snapshot, history, revision) uses the **same exported `orderBy` constant** as the live read of the same data; it adds no tie-break. If the live order is unstable, that is a finding for the live read."* **Test:** `createdAt` ordering exported from the sub-category repository and imported by the snapshot reader makes the `id` tie-break a visible deviation in review. | ED-1 | pending |
| R9 | `.ai/claude/skills/commit/SKILL.md` §1 + new `.github/workflows/pr-base.yml` | Stacked PRs | Skill: *"Open a stacked PR as **draft** and mark it ready only after its parent has merged and its base shows `main`. Before merging a parent run `gh pr list --base <parent-branch>`; retarget each result with `gh pr edit <n> --base main` **first**."* Workflow: on `pull_request` events, fail the check when `base != main` and the base branch is not the head of an open PR; comment "merge the parent first". The free plan cannot block the merge (as with `pr-size.yml`), so it is a red check. **Test:** both #791 and #797 had a base that was not `main` at merge time; a red check on that state is visible where the merge button is. The prose banner in #797's body is the counter-example: written and present, ticket still had the second mishap. | ED-2 | pending |
| R10 | `.ai/aidlc/agents/construction/tcg-executor.md` | "Before the first edit" | Replace *"One unit, one branch, one PR"* preamble's checkout step with: *"Create the branch with `pnpm worktree:add <ticket>-<unit>`. Run `git checkout -b` / `git switch` in the primary checkout only if the developer says no dev server is running; otherwise stop and ask."* **Test:** the primary checkout never moves, so `prisma generate` / shared rebuild / API restart happen in the worktree. Mechanical to the extent the executor is told to refuse. | ED-3 | pending |
| R11 | `.ai/aidlc/templates/units.md` + `.ai/aidlc/agents/inception/tcg-decomposer.md` | Header block; output | Add a required header line **`Gate baseline: pnpm lint && pnpm build on origin/main @ <sha> → pass | fail (<N> failing, <paths>)`**, run by the decomposer once at decomposition. Executor "Gates:" line gains `vs baseline: <same | new: n>`. `close-ticket` step 2: *"A ticket whose baseline was `fail` is certified on `pnpm affected` for the paths it touched; say so."* **Test:** `calendar.tsx` (#709) and the DAS test file (#827) are in the baseline on 2026-10-14; the end-of-ticket run compares against them and TCG-218's own lint/tsc set is knowable. Does not override the developer's deferral of full gates. | ED-4 | pending |
| R12 | `.ai/claude/skills/close-ticket/SKILL.md` | New step before "reflection" | Add: *"Run `awk '/^### Q/{q=$0} /^- \*\*Answer \(/{a++} END{print a}' spec.md` against the count of notes in `vault/decisions/` dated in the ticket's span; hand every §12 `Answer (` line whose Status lacks `see decisions/` to `tcg-scrum` as one batch. A client-sourced answer (a named client in the Answer line) is written first."* **Test:** this ticket ended with 6 owed notes; the check names them at close instead of at reflection. Mechanical (a count that must be zero). | §3 finding | pending |

- **Rejected proposals, and why:**
  - *Require tests/lint/build per unit before merge* — rejected: the developer's deferral of gates for long features is recorded in every PR and is a deliberate trade-off; R11 makes it cheap instead of banning it.
  - *Add a lint rule for ordering in snapshot readers* — rejected: no lint rule exists for module conventions in this codebase; R8's shared constant is checkable by review and cheaper.
  - *Tighten the 400-line budget or require size estimates in lines* — rejected: the budget held on every PR (U11a-1 at 398, then 407 caught and moved); the problem was where the cut was made (R6), not the number.

## 5. Recurrence check

Grepped `reflections/INDEX.md` per class on 2026-10-17.

| Defect | Class | Prior rows | Occurrence | Why the previous fix did not hold |
| --- | --- | --- | --- | --- |
| SD-1 | missing-requirement | SCRUM-877 SD-1, SD-2; SCRUM-252 SD-3, SD-4; PAYROLL-FLAGS SD-1..SD-5 (9) | **3rd+ (10th)** | Prior fixes are narrow shape notes in `api.md` / `prisma.md` (e.g. "keep these arrays in sync") — each closed one *instance*. None added a field to the **spec template** that forces the question. Five PAYROLL-FLAGS rows are still `open`/`proposed`. |
| SD-2 | missing-requirement | same 9 | **3rd+** | Same |
| SD-3 | missing-requirement | same 9 | **3rd+** | Same; also sourcing: SCRUM-252 SD-1 (`unverified-stale`) is the nearest — a vault source used without comparison. |
| SD-4 | missing-requirement | same 9 | **3rd+** | Same |
| SD-5 | missing-requirement | same 9 | **3rd+** | Same |
| SD-6 | unit-not-vertical | none | 1st | N/A |
| SD-7 | over-built | none | 1st | N/A |
| ED-1 | invented-value | none | 1st | N/A |
| ED-2 | branch-ops (new) | none | 1st in the index; **2nd within this ticket** | The rule existed in `CLAUDE.md` and #797's body and was ignored (R9: mechanical) |
| ED-3 | branch-ops (new) | none | 2nd (this ticket) | Worktree is advised, not required (R10) |
| ED-4 | gate-illusion | SCRUM-900 ED-1, ED-2; SCRUM-926 ED-4, ED-5; SCRUM-252 ED-1; LOADOUT ED-1, ED-2 (7) | **3rd+ (8th)** | The CI ledger check (SCRUM-926 ED-4) is `applied` in the index but did not fire at SCRUM-252 and CLAUDE.md states "nothing runs lint, test or build automatically right now". Gates remain commands someone runs by hand — "was written and ignored" turned into "was written and switched off". |

- **ESCALATE (first line of the report):** `missing-requirement` is at its tenth occurrence and `gate-illusion` at its eighth. Neither is a reminder problem. Structural mechanisms: for `missing-requirement`, **required fields in `templates/spec.md`** (R1 Read time, R2 Reached by, R4 Matrix) that make sign-off fail on a blank cell, plus a refusal in the elaborator (R3); for `gate-illusion`, **a recorded gate baseline per ticket** (R11) and restoring one automatic check — at minimum the `.husky/pre-push` `nx affected` block, commented out today. Why the previous fixes did not hold: *not written where it binds* (shape notes in contexts, not the template that produces specs) and *written then switched off* (CI ledger check, pre-push gates).
- **New class added to the index?** **Yes: `branch-ops`** — a git or PR operation landed work on the wrong base or disturbed the developer's running checkout. None of the 20 existing classes fit: `layer-violation`, `pattern-drift` and `gate-illusion` all describe the diff, not the branch it travelled on. Row added to the index's class table in the same change.
- **Rows appended to `reflections/INDEX.md`:** yes — 11 rows (SD-1..SD-7, ED-1..ED-4), all `proposed`.

## 6. Kept as-is

- **Executor stop-and-ask on this ticket worked.** 46 questions after sign-off, almost all raised by `tcg-executor`, `tcg-analyst`, `tcg-prisma-guardian` and `tcg-contract-tracer` before code, with options and recommendations. That is the rail doing what it was built for; the defects above are the ones that rail could not see because nobody had been asked.
- **U11a-1 → U11a-2 split at 407 lines.** The Q58 hook pushed U11a-1 over ~400; it was moved to U11a-2, not waved through. The size rule held. Root cause (U11 entered build with "size not estimated") is SD-6.
- **No tests were written and spec mocks were edited only to compile.** Per the developer's recorded instruction in each PR ("Not run: lint, build and tests"). Not a defect against this ticket's rules. The unfulfilled §10 test plan is carried as Q65(a) so it is a decision, not a silent drop.
- **Q59 (direct `PATCH status: WON`) left open.** Deliberate ("we can add these guardrails later"); no client sends it. Re-open only if a client starts to.
- **Sanctioned module-imports-controller exception, `isGroupResourceLabel` unchanged by D14 (stored name stays "Mobilization"/"Demobilization", crane name is display-only).** Correct and kept: it is why the four detectors needed no change.
- **`ESLint clean on touched files` + `tsc` instead of `pnpm lint && pnpm build`.** The developer's long-feature rule; honest in each PR body. See ED-4 for what it cost.
- **#795 (reject resource ids of another quotation), #794 demo data, #807 Q50 as separate PRs.** One independent task each — within the one-task-per-PR rule.
- **U13 merged without a guardian/analyst run.** The PR says so and gives a 6-of-6 data check; a column drop of a copy proven equal is within reason. R7 would have moved the check to U11a-1, where it belonged.
