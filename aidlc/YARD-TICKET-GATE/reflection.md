# Reflection — YARD-TICKET-GATE Yard-Operations dependency for employee tickets

> Written to `.ai/aidlc/YARD-TICKET-GATE/reflection.md` after the units shipped (PR #993, merge
> `37fa7d285`; work = `22c650d71` + `d337e93cb` on `feat/yard-ops-ticket-start-gate`).
> Filled by `tcg-reflector`. Proposes rule changes; applies none.

## 0. Context

| Field | Value |
| --- | --- |
| Ticket | `none` — slug `YARD-TICKET-GATE` (no Jira ticket) |
| Spec | `.ai/aidlc/YARD-TICKET-GATE/spec.md`, elaborated `2026-11-02` — **retrofitted after the code was written**, not via `tcg-elaborator` |
| Units | U1 (API) and U2 (mobile) — shipped, on one branch and one PR (deviation recorded in `units.md`). Decomposed after the build, not via `tcg-decomposer` |
| Reflected on | `2026-11-02` |
| Reviewer(s) | haris (sign-offs D1, D4, D12, Q5, Q6); `tcg-prisma-guardian`, `tcg-contract-tracer`, `tcg-analyst` U1 + U2; PR-review round (7 findings) |
| Open questions at build time | 4 (Q1–Q4) at elaboration, 2 more (Q5, Q6) raised by PR review. 0 were answered before the executor started: the spec did not exist until after the build. All 6 are answered (haris, 2026-11-02). One stale duplicate Q6 block remains in §12 (see §3) |
| `[UNVERIFIED]` requirements built | 5 of 5. 0 proved wrong on the facts they cite (stages, field names, code paths all held). The defects were in edges and design, which the `[UNVERIFIED]` tag does not predict. One ambiguity in the request itself ("Load Out / Start Load Out — confirm"), resolved by Q1 = A |
| Unverified × irreversible | 0. Migration is an additive nullable JSONB column (reversible); `yardGate` is an additive optional response field (G5, signed). Whether either was flagged *before* the build cannot be measured: the spec was written after the code |

## 1. Spec defects — what the spec missed

### SD-1 — "Online only" had no server-visible signal

- **Where:** REQ-01 / REQ-02 *Trust boundary* ("server-derived; the client gate is advisory, the API guard authoritative"); §12 Q4 (client + server); §11b D11 (online-only).
- **What the executor needed to know:** how the server tells a live online punch from an offline-captured one, and whether it can at all.
- **What the spec said:** Q4 = A "client + server guard"; later D11 "gate enforced only while online; offline completion bypasses it". Nothing named the field the server would read to tell the cases apart.
- **What was decided instead, and by whom:** the executor keyed the server guard on `capturedAt` / `X-Captured-At`. That header cannot separate the two cases: the step screen persists a retry replay op (carrying `capturedAt`) before the live send, and the online finalization review punch is sent without it. The guard therefore leaked (a 409'd online punch drained later and succeeded) and 409'd finalization. PR review found both (findings 2 and 6). D12 removed server enforcement and reversed the G4 "client + server" answer.
- **Was the decision right:** no. Known from PR review plus reading the send sites.
- **Cost:** a built-and-reviewed server guard (`assertYardGateAllowsStep`, `isLeftYardOrLater`, `findYardGateForTicket`) deleted; a G4 reversal needing a second sign-off; two PR-review findings; Q4's answer overturned.
- **Class:** missing — and the *Trust boundary* field was present and filled. It was filled `server-derived`, which is true of `yardGate` but not of the *enforcement-mode trigger*, which arrived afterwards as a §11b row (D11) that never sent anyone back to the §2 edges.
- **Fix:** R2 (the field must name the bypass signal and every client send site; a §11b/§12 change to enforcement re-opens it), R3 (executor stop).

### SD-2 — Gate-2 step set came from array order and swallowed REQ-01's own punch

- **Where:** REQ-02 *Reached by* (lists `startWork`) and Source 4 (`ALL_TICKET_FLOW_STEP_KEYS`: "`leftYard` precedes … `startWork`"); REQ-01.
- **What the executor needed to know:** which clock-order the steps really fire in. `startWork` is the gate-1 punch-in (the dashboard Start Work), so it fires *before* Left Yard in time though it sorts after it in the array.
- **What the spec said:** gate 2 = `leftYard` and every later step by flow-array index, including `startWork`. REQ-01 says gate 1 blocks Start Work. The two requirements disagreed about the same step.
- **What was decided instead, and by whom:** D2 (AI, post-review): exclude `startWork`. Before that, gate 2 409'd the dashboard Start Work.
- **Was the decision right:** yes (D2 fix). It is the *spec's* set that was wrong.
- **Cost:** a regression in the main dashboard action, found after the build; D2 rewritten.
- **Class:** contradicted a source — the existing Start Work wiring (`recordTicketStep` with `startWork`), which §11a did not list as a consumer.
- **Fix:** R10 (a "from X onward" statement must be enumerated key by key with the owning REQ).

### SD-3 — "Does not apply when" omitted the ticket lifecycle states

- **Where:** REQ-01 and REQ-02 *Does not apply when*: "holdover ticket; a future-dated ticket". Nothing about status.
- **What the executor needed to know:** the gate is a pre-start concept and must not fire on COMPLETE, returned-correction or approved-edit tickets, which exist so a user can view or correct recorded data.
- **What the spec said:** `nothing` on those states.
- **What was decided instead, and by whom:** the first build gated them: it blocked viewing finished tickets and late completions. Fixed through D3, D7 and PR-review finding 3 (`isYardLeaveBlocked` approved-edit exemption), each AI, post-review.
- **Was the decision right:** yes after the fix; the original omission was wrong.
- **Cost:** analyst U1 F2, analyst U2 F3, PR-review F3 — three rounds on one omission.
- **Class:** missing (over-broad condition).
- **Fix:** R1.

### SD-4 — The sibling enumeration was rooted too deep

- **Where:** §11c `Enumerated by`: `grep -rn 'isFuture' apps/mobile/components/field`; REQ-01 *Reached by* (card tap, `openFieldTicket`, `recordTicketStep`).
- **What the executor needed to know:** every screen that renders or opens a ticket card. The Jobs tab (`apps/mobile/app/(field)/jobs.tsx`) renders `TicketCard` and opens tickets via its own `handleOpenTicket`.
- **What the spec said:** the grep scoped to `components/field` (finds the card's internals, not its callers); the Jobs tab appears nowhere in §11a/§11c or *Reached by*.
- **What was decided instead, and by whom:** the analyst (U2 F1) found it; the gate was added to `jobs.tsx` in the same diff (`22c650d71`).
- **Was the decision right:** yes.
- **Cost:** one analyst round; the sibling was ungated until then.
- **Class:** missing — the enumeration command named an implementation detail (`isFuture`) and a sub-directory instead of the entry symbol (`TicketCard`) and the surface root.
- **Fix:** R4.

### SD-5 — No-load sub-jobs: an open vault gap was not consulted, and the answer may be unreachable

- **Where:** nowhere — the spec had no requirement or question for sub-jobs with nothing loadable until PR-review finding 1 (Q6).
- **What the executor needed to know:** what a ticket does when its sub-job has no loadable item. `vault/dispatch/gaps.md` → *Should the yard board show jobs that have nothing to load — one-day, no-equipment, trucking-only* (line 907) already records two opposing client positions. `das-loadout.service.ts` rejects an empty loadout (`Nothing to dispatch for this shift.`, SCRUM-LOADOUT-UNASSIGNED).
- **What the spec said:** `nothing`; §0 *Vault state at elaboration* cites `dispatch/daily-allocation-system.md` and `yard-operations-jz.md` only.
- **What was decided instead, and by whom:** Q6 = C (haris, 2026-11-02): the gate stays, no-load tickets "wait for a yard action". But if no yard action can mark such a sub-job available or complete its loadout, they wait forever, and gate 2 (Complete Loadout) cannot pass for them even if Mark Available were possible. Written to `spec.md` §12 as **Q7**.
- **Was the decision right:** still unknown. Q6 = C is only safe if a yard action exists; the code and gap say it does not.
- **Cost:** a PR-review finding, an owner round, and a possible permanent block of real crew tickets.
- **Class:** missing — a known open gap not cited at elaboration.
- **Fix:** R9.

## 2. Executor defects — what was built against the spec

### ED-1 — `isShiftLoadedOut` copied the sibling's unconditional shift-1 fallback, and the fix reached only one twin

- **Where:** `apps/api/src/service/das-loadout/das-loadout-shift-keys.util.ts` (`isShiftLoadedOut` new; `isShiftMarkedAvailable` pre-existing).
- **Spec said:** REQ-03 *When an input is absent*: "legacy rows (null column) read via the shift-1 `loadoutCompletedAt` fallback"; *Notes*: "mirror `markAvailable`'s `mergedShifts` merge; add `isShiftLoadedOut`".
- **Built:** `isShiftLoadedOut` fell back to the whole-sub-job timestamp for shift 1 even when the per-shift map had entries, copying the pre-existing `isShiftMarkedAvailable` bug. Marking only shift 2 then read shift 1 as done. The guardian flagged the new function (F1, fix D5). The identical bug in `isShiftMarkedAvailable` was left until PR review (F5), hours later and after D5 was already written.
- **Caught by:** `tcg-prisma-guardian` (new copy), PR review (original twin). Not by the executor, not by tests.
- **Class:** copied a sibling's bug instead of extracting one shared body, and applied the D5 fix to one instance only (`tcg-executor.md` §3 "Never write a second copy that can diverge" and §4b "carry the change to the siblings").
- **Fix:** R5; R6 as the mechanical option.

### ED-2 — Mapper sent `yardGate: null` for a missing loadout row

- **Where:** `apps/api/src/usecase/field-tickets/field-ticket.mapper.ts`.
- **Spec said:** REQ-01 *When an input is absent*: "no `SubJobLoadout` row ⇒ not available ⇒ blocked"; REQ-04: "no loadout row ⇒ `available=false, loadedOut=false`"; `null` only for "holdover ticket or no sub-job".
- **Built:** `null` for a missing loadout row. On mobile `null` means "no gate", so a not-yet-available ticket showed Start and then failed.
- **Caught by:** `tcg-analyst` (U1 F1 / U2 F2). Fixed as D6.
- **Class:** ignored a stated requirement.
- **Fix:** R7.

### ED-3 — Path A work started with no ticket, spec or units

- **Where:** `intent.md`, `spec.md` and `units.md` all open with "Retrofitted"; `state.md`: "retrofitted; not via `tcg-elaborator`" / "not via `tcg-decomposer`".
- **Spec said:** root `CLAUDE.md` → _Build requests enter AI-DLC — through triage_: path A is "intent → spec → units → execute → analyse → reflect".
- **Built:** the code first; the spec was then written to match it. Edges (SD-1, SD-3, SD-4) were therefore drawn from the diff, not from the request, and the elaborator's source and sibling passes did not run.
- **Caught by:** `close-ticket` checkpoint noticed the missing merge, not the order. Not caught as a defect until this reflection.
- **Class:** skipped a phase.
- **Fix:** R8.

### ED-4 — Employee-facing labels with no source and no reviewer

- **Where:** `spec.md` §11b D8: "Pending" status pill, "Waiting on the yard" locked-step title.
- **Spec said:** Q3 = A mandated the future treatment and the body sentence only. G1: client-facing behaviour nobody specified goes to the owner.
- **Built:** two strings chosen by the AI, marked `Needs developer: no`, `Reviewed by` left blank (the only blank in §11b/§11c).
- **Caught by:** this reflection. Nobody objected; per rule, a right guess is still a defect.
- **Class:** invented value (copy).
- **Fix:** R11.

## 3. Source and vault findings

- **Sources that turned out to be wrong or stale:** `NONE FOUND` on facts. All five `[UNVERIFIED]` requirements cited sources whose facts held (`markAvailable` / `completeLoadout` stages, the flow-array order, `resolveHoldoverForTicket`). So this ticket gives the tag **0 wrong of 5**; the real defects (SD-1..SD-4) were in edges and design, which no source tag measures. One more data point against reading `[UNVERIFIED]` as a risk signal for *behavioural* requirements.
  - `decisions/2026-10-15-late-and-incomplete-tickets.md:131` documents what `capturedAt` means ("each queued op carries `capturedAt` … accepted when captured before the window ended … 72h grace"): a captured-time stamp for window acceptance, not an online/offline flag. It was not cited as a source for SD-1 and would have shown the header was the wrong signal.
- **Conflicts that surfaced only during build:**
  - Q6 = C versus `vault/dispatch/gaps.md` → *Should the yard board show jobs that have nothing to load…* (line 907). That entry says "Blocked: nothing hard" and lists position (a) "hide it … Dylan won't need to mark them". This ticket now makes ticket start depend on the answer; Q6 = C assumes a yard action that the code and the gap say does not exist. New question **Q7** appended to `spec.md` §12. The gap entry should be annotated that YARD-TICKET-GATE depends on it, not closed.
  - `spec.md` §12 holds **two Q6 blocks**: the resolved one and a stale open copy with a blank answer. Greppers see an unanswered question on a closed ticket. Remove the stale block (owner of the spec; this run is append-only).
  - `field-ops/field-ops-mobile-INDEX.md` is a known conflict stub; it was not needed. The step flow, `startWork` ordering and offline outbox semantics have no vault source at all and were read from code only.
- **Questions answered by a named human during the build:** Q1 = A, Q2 = A, Q3 = A, Q4 = A (owner, 2026-11-02); Q5 = A, Q6 = C, D12 G4-reversal (haris, 2026-11-02); owner feedback D10 (navigation block + toast) and D11 (online-only). **Written to `decisions/`? no** — `ls .ai/vault/decisions | grep` shows no `2026-11-02-*yard*` note; `state.md` lists it as pending for Q1–Q4 and omits Q5, Q6, D10, D11, D12. Nine answers are unwritten. `tcg-scrum` holds the write path. Suggested notes: `2026-11-02-yard-ticket-gate-stages-and-scope.md` (Q1–Q3, Q5), `2026-11-02-yard-ticket-gate-client-only-online.md` (Q4 reversed by D11 + D12), `2026-11-02-yard-ticket-gate-no-load-subjobs.md` (Q6, pending Q7).
- **`gaps.md` entries this ticket should close:** `NONE FOUND`. `dispatch/gaps.md` line 907 is *not* closed by Q6 (it asks about board visibility; Q6 only answers ticket gating). Spec-local: Q5 and Q6 are `resolved` and need no frontmatter edits (no vault file is a winner or loser here); decision notes carry the rulings.
- **`gaps.md` entries this ticket opened:** none in vault `gaps.md`. In `spec.md` §12: **Q7** (no-load release path), appended by this reflection.
- **Undefined terms hit:** "Load Out / Start Load Out — confirm" (the request's second stage; resolved Q1 = A, Complete Loadout). "Available for Dispatch" had to be mapped to `markAvailable` / `dasStage LOADOUT` from code. Neither is in the known nine; new.

## 4. Rule changes proposed

Haris-only files (`templates/`, `agents/`). None applied. Each says what it removes.

| # | File | Section | Exact change | Prevents | Accepted |
| --- | --- | --- | --- | --- | --- |
| R1 | `.ai/aidlc/templates/spec.md` | §2 Edges → `Does not apply when` | Replace the bullet with: "**Does not apply when:** one row per value of every status or enum this requirement keys on — enumerate with `grep -n 'enum <Name>' apps/api/prisma/schema.prisma` and the mobile status selectors — as `<value> — applies` or `<value> — exempt: <reason>`. A value left off the list counts as *applies*. Other flows, kinds and holdover go here too." Adds 3 lines, removes 3 (the free-text bullet). Test against SD-3: enumerating `TicketStatus` and the edit-request states puts COMPLETE, returned-correction and APPROVED edit in front of the author; a free-text list did not (and the field already existed, applied 2026-10-20) | SD-3 | pending |
| R2 | `.ai/aidlc/templates/spec.md` | §2 Edges → `Trust boundary` | Replace the bullet with: "**Trust boundary / bypass signal:** who supplies each input and whether the server believes it. If the requirement is enforced only in some mode (online, offline, replay, retry, admin), name the exact field the server reads to tell the modes apart and list every client call site that sets or omits it (`grep -rn '<field>' apps/mobile apps/web`), one line each. If the two modes look identical to the server, the requirement is client-only: write that and add no server guard. `N/A — server-derived` only when no input comes from a client. A §11b or §12 answer that changes where or when it is enforced re-opens this line." Adds 6 lines, removes 3. Test against SD-1: the call-site list would have shown the replay op persisted before the live send and the finalization punch with no `capturedAt`; the "look identical ⇒ client-only" line gives the conclusion D12 reached after review | SD-1 | pending |
| R3 | `.ai/aidlc/agents/construction/tcg-executor.md` | §2, after the guardrail list | Add one sentence: "A server check whose trigger is a client-supplied value (header, flag, timestamp, id) is `needs developer`: list every client send site of that value in the §11b row before building it." Adds 1 line, removes 0 — nothing in §2 covers it; backstop for the case where the spec is silent | SD-1 | pending |
| R4 | `.ai/aidlc/templates/spec.md` | §11a and §11c `Enumerated by` column | Replace the cell's example `git grep -rn '<term>' <paths>` with `git grep -rn '<exported symbol, route or component the change reaches>' <surface root>` and add under the table: "Run from the surface root (`apps/mobile`, `apps/web/src`, `apps/api/src`), never a sub-directory of the file being edited; a narrower path states why. Grep the entry symbol (`TicketCard`), not an internal (`isFuture`)." Adds 2 lines, removes 1. Test against SD-4: `grep -rn TicketCard apps/mobile` lists `jobs.tsx` and `field.tsx`; the grep that was used could not | SD-4 | pending |
| R5 | `.ai/aidlc/agents/construction/tcg-executor.md` | §4, last paragraph | Replace "Copying a private helper into your module (the way `formatInternalId` and `mapWriteError` were copied) is the duplication this rule exists to stop." with: "Copying a helper — into another module, or beside its twin in the same file — is the duplication this rule exists to stop. When the spec says *mirror* or *symmetric with*, read the twin for defects first, then extract one body parameterised by the field it reads and have both call it; a fix then lands once. If your unit corrects the twin's defect, fix every twin in the same unit." Adds 3 lines, removes 2. Honest limit: §3 already says "never write a second copy" and was ignored, so this is partly prose; R6 is the rail | ED-1 | pending |
| R6 | `.ai/aidlc/agents/construction/tcg-executor.md` §6 (gates) + `package.json` lint target | duplication check | Add a duplicate-code check (for example `jscpd`, `--min-tokens 60`, scoped to `apps/api/src/service` and `apps/mobile/data`) as a reported, non-blocking step in the Gates line, and delete the sentence in root `CLAUDE.md` Code quality "Lint does not check module boundaries, duplication or hardcoded colours" down to "module boundaries or hardcoded colours". **Needs a G5 yes from Haris (new dependency) and a baseline run before it is useful.** Adds 1 line + dev dependency, removes ~0.5 line. Duplicated-logic is now at its 4th row; four prose fixes have not held | ED-1 | pending |
| R7 | `.ai/aidlc/agents/construction/tcg-executor.md` | Output shape, after `Rule sources checked:` | Add the line `Edges implemented: <for each REQ "When an input is absent" and "Does not apply when" line — file:line that implements it>`. Adds 1 line, removes 0 — nothing at executor stage checks edges; today the analyst is the only check. Test against ED-2: the line for REQ-04 "no loadout row ⇒ false/false" forces the author to open the mapper branch that returned `null` | ED-2 | pending |
| R8 | `.ai/aidlc/agents/construction/tcg-executor.md` | §0, first bullet | Add: "On Path A, refuse to write code until `.ai/aidlc/<TICKET>/spec.md` §14 is ticked and `units.md` exists; a spec written after the code is not a sign-off. Say 'run `tcg-elaborator`' and stop." Adds 2 lines, removes 0. A `guard-edits.mjs` hook was considered and rejected below | ED-3 | pending |
| R9 | `.ai/aidlc/templates/spec.md` | §0 Provenance table | Replace the `Vault state at elaboration` row's value hint with: "…; and `Gap headings matched`: `grep -n '^## ' vault/<module>/gaps.md \| grep -i '<requirement nouns>'` → hits, or none" (one row, replaces the free-text row). Adds 1 line, removes 1. Test against SD-5: nouns `loadout`, `load`, `yard` hit line 907 | SD-5 | pending |
| R10 | `.ai/aidlc/templates/spec.md` | §2 Edges → `Matrix` | Change "only when the statement says twin, mirror, sync or follows" to "only when the statement says twin, mirror, sync, follows, *or 'and later' / 'from X onward' / 'every subsequent'*", and add: "For an ordered set, list each member by key with the REQ that owns it and its clock order, not the array order." Adds 1 line, removes 0 (edit of an existing sentence). Test against SD-2: enumerating the steps puts `startWork` against REQ-01 | SD-2 | pending |
| R11 | `.claude/skills/close-ticket/SKILL.md` | §1 (before merge checks) | Add a check: "Fail if any `spec.md` §11b/§11c row has an empty `Reviewed by`, or any user-visible string in the diff appears in a §11b row marked `Needs developer: no`." Adds 2 lines, removes 0. Mechanical on the blank; the string half is left to the analyst | ED-4 | pending |

- **Rejected proposals, and why:**
  - **A `guard-edits.mjs` hook that blocks code edits when no overlay lists the branch** (for ED-3): Path C legitimately has no overlay, and the branch (`feat/yard-ops-ticket-start-gate`) does not map to the slug (`YARD-TICKET-GATE`). The hook cannot tell a skipped phase from a legal Path C. R8 is the executor-side refusal instead.
  - **"Never use `capturedAt` for server decisions" in `contexts/api.md`:** names one header; the next client-supplied flag escapes it. R2 covers the class.
  - **A new `contexts/mobile.md` section on offline replay-op semantics:** a pure addition, and R2's send-site list forces the same reading at the point of need. Revisit only if a client-supplied replay field is mis-used a third time.
  - **Closing `dispatch/gaps.md` line 907 on the strength of Q6:** Q6 answers ticket gating, not board visibility.

## 5. Recurrence check

| Defect | Class | Prior rows | Occurrence | Why the previous fix did not hold |
| --- | --- | --- | --- | --- |
| SD-1 | `missing-requirement` | 24 rows; same header: TICKET-FLOW-SLOTS-HOLDOVER SD-6 (`X-Captured-At` trust) | **3rd+** class; 2nd on the header | Written and filled, then bypassed: R1 of 2026-10-20 added `Trust boundary`, but its `N/A — server-derived` escape fits any requirement whose *data* is server-derived, and a mode switch added later in §11b never reopened it |
| SD-2 | `contradicted-source` | SCRUM-926 ED-1, SCRUM-252 SD-2, TICKET-FLOW-SLOTS-HOLDOVER ED-4, MOBILE-TICKET-PRESIGNED-IMAGES SD-2 | **3rd+** (5th) | Rule is in `tcg-executor.md` §3 and applied, but it asks the *executor* to grep before building; this miss was in the spec's own ordering claim and §11a consumer list, upstream of §3 |
| SD-3 | `over-broad-condition` | TICKET-FLOW-SLOTS-HOLDOVER ED-1/2/3, TCG-218 ED-5 | **3rd+** (5th) | Field written (`Does not apply when`, applied 2026-10-20) and filled, but free text: the author lists the exemptions they thought of. Not enumerated from the status enum, so COMPLETE, returned and approved-edit never appeared. R1 makes it a matrix |
| SD-4 | `pattern-drift` | MOBILE-TICKET-PRESIGNED-IMAGES SD-1 | 2nd | Sibling rule exists and was applied (§11c filled, Jobs tab then fixed), but the enumeration command's scope is unconstrained. R4 fixes the scope |
| SD-5 | `missing-requirement` | as SD-1 | **3rd+** | Written where nobody reads: no step makes the elaborator match gap headings against the requirement's nouns (R9) |
| ED-1 | `duplicated-logic` | SCRUM-252 ED-2, ED-3; MOBILE-TICKET-PRESIGNED-IMAGES ED-1 | **3rd+** (4th) | Written and ignored: `tcg-executor.md` §3 ("never write a second copy") and §4 already apply, and the spec's own "mirror" note pointed the other way. Prose has now failed four times |
| ED-2 | `ignored-spec-edge` | none | 1st | New class; no executor-stage check of edges exists |
| ED-3 | `phase-skipped` | none | 1st | New class; rule written in root `CLAUDE.md` triage and ignored; no refusal exists in the executor |
| ED-4 | `invented-value` | 3 rows (see index) | **3rd+** (4th) | Written and ignored: G1 and `Assumed` exist; `Reviewed by` can stay blank and nothing checks it |

- **Escalate:** these are not reminder problems. In order of weight:
  1. **`duplicated-logic` (4th): prose has failed four times.** Mechanical remedy: R6, a duplicate-code check reported in the executor's Gates line, plus R5 so the unit that fixes a twin must fix every twin. Needs a G5 yes.
  2. **`over-broad-condition` (5th): the field exists and is free text.** Mechanical remedy: R1, an enumerated status matrix so an omitted value means *applies* and shows up in review.
  3. **`missing-requirement` (SD-1, SD-5) and `contradicted-source` (SD-2): fields are present, filled nominally.** Remedy: R2 and R10 turn each into a required enumeration (call sites, members), plus R9 for the gap match. R7 adds an executor-stage check.
  4. **`invented-value` (4th): blank `Reviewed by`.** Remedy: R11, a `close-ticket` refusal.
  
  This reflection ran on a Sonnet-class tier. §4 of the reflector calls for Opus on a third occurrence; the proposals above should be re-read by an Opus-tier run before Haris accepts them.
- **New class added to the index?** Yes, two: `ignored-spec-edge` (a stated "when an input is absent" / "does not apply when" line the build contradicts; none of `contradicted-source`, whose sources are `[VERIFIED]` artefacts, or `over-broad-condition`, which is the wider-than-spec direction, fits) and `phase-skipped` (code written before the spec or units existed; `branch-ops` is about git bases, not phases). Added to the table in `reflections/INDEX.md`.
- **Rows appended to `reflections/INDEX.md`:** yes — 9 rows (SD-1..SD-5, ED-1..ED-4).

## 6. Kept as-is

- **U1 + U2 on one branch and one PR.** Recorded in `units.md`; U2 reads `yardGate` from U1 and neither can be demonstrated alone to the owner. Acceptable deviation, explained.
- **D12 — removing server enforcement.** Correct call: a guard that leaks and 409s finalization is worse than none. Trade-off (a tampered or old client is ungated; the gate is a dispatch convenience) is written in §13 and was signed by haris. Do not re-propose a server guard keyed on `capturedAt`; a server guard would need a distinguishing signal that does not exist today.
- **Additive nullable `loadout_completed_shifts_at` with no backfill (Q5 = A).** Live tickets at deploy are almost all COMPLETE, so gate 2 never fires on legacy shift-2 rows.
- **Concurrent `completeLoadout` JSON-merge race (PR-review F7 / guardian F3).** Same read-modify-write as `markAvailable`; needs two yard users in the same instant; follow-up sweep PR, not a defect of this ticket.
- **No new tests.** `not requested` per root `CLAUDE.md`; existing `das-loadout-*.spec.ts` and `job-tickets.service.spec.ts` updated for arity only.
- **Holdover exemption** (`yardGate: null` for holdover, selectors false) behaved as specified in every review round.
- **`processed.log` row** was already written for this ticket (`2026-11-02 | YARD-TICKET-GATE | A … pr: 993`); `state.md` Resume still says it needs one and is stale on that point.
