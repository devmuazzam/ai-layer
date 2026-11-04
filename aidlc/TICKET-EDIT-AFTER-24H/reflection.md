# Reflection — TICKET-EDIT-AFTER-24H Unit 1 completed-ticket age cutoff

## 0. Context

| Field | Value |
| --- | --- |
| Ticket | `TICKET-EDIT-AFTER-24H` — scoped U1 closeout |
| Spec | `plan.md` (Path B; no separate spec), 2026-11-02, and `units.md`; underlying TICKET-FLOW-SLOTS-HOLDOVER REQ-19–21 |
| Units | U1 partially shipped: core age-cutoff removal merged in application PR #995 to `staging`, merge `dbef9c1e560e4737d2040a78db647e06d39f39ea`, containing `ea1e22d80`. Not application `main`. Overlay handoff PR #224 merged to overlay `main`, merge `2b58629`, containing `24b9ee5`. U2 unbuilt/outside this scoped close. |
| Reflected on | 2026-11-03 |
| Reviewer(s) | Codex `tcg-reflector`; source review and recorded executor evidence, no live demo or new gates |
| Open questions at build time | 1: `plan.md` §6 Q1, unanswered; blocks U2 only. None blocking U1. |
| `[UNVERIFIED]` requirements built | 3 referenced requirements (REQ-19–21), limited to age eligibility; 0 shown wrong or stale. Source decisions remain `reference`, not promoted. |
| Unverified × irreversible | 0 — no schema/data rewrite, dependency, endpoint or response-shape change. |

## 1. Spec defects — what the spec missed

NONE FOUND in the scoped age-cutoff change. `plan.md` and `units.md` already required
expiry/re-request, genuine void/settlement locks and correction-specific copy. The omitted
mobile obligations are delivery gaps, not missing requirements. Q1 was explicitly excluded
and remains open; leaving it unbuilt is correct.

## 2. Executor defects — what was built against the spec

### ED-1 — Delivered mobile slice omits specified approval-state edges and correction copy

- **Where:** `apps/mobile/app/(field)/ticket/index.tsx`, `apps/mobile/data/ticket-editability.ts`, `apps/mobile/components/field/edit-request-sheet.tsx`; `analysis.md` findings 1–3.
- **Spec said:** `units.md` Mobile row: “Retain genuine payroll-void/settlement LOCKED”; check approval precedence so “a stale approval never shows an unusable edit screen”; adjust copy for “correction” versus “finish incomplete”. U1 outcome explicitly permits a fresh request after expiry.
- **Built:** `ea1e22d80` changes the API/mobile age policy and two existing assertions, but leaves raw APPROVED status suppressing an expired grant's request banner, live approval preceding the void lock, and late-completion strings for submitted corrections. All three are **INFERRED**, inherited source defects reached by the specified slice, not regressions authored by this commit. They remain **OPEN followups**; merge does not overturn `analysis.md`'s “do not ship as complete” verdict.
- **Caught by:** independent analyst source review; not reproduced on a device. The executor arrived after the four-file fix was committed and verified it rather than writing it; attribution here is to the delivered slice, not a claim about who authored the inherited code.
- **Class:** ignored a stated requirement; index `ignored-spec-edge` (approval exceptions/expiry). Copy is recorded with the same incomplete slice, not counted as a separate recurrence.
- **Fix:** R1 — require evidence for each slice obligation, including inherited branches and explicit open items. Existing green suites are not acceptance evidence for these untested UI branches.

## 3. Source and vault findings

- **Sources that turned out to be wrong or stale:** NONE FOUND in product sources. `implementation.md` records that the isolated overlay lacked canonical `units.md` and held stale `state.md`; these were handoff artifacts, not evidence that a vault requirement was wrong. No pre-edit baseline exists; 8 suites / 116 tests and API/mobile gates passed on committed `ea1e22d80` only.
- **Conflicts that surfaced only during build:** NONE FOUND. One known policy conflict remains open: Payroll-at-all-times versus L8/REQ-19 finalized-payroll prohibition, explicitly isolated in `plan.md` §4/§6 Q1 before execution. It is not resolved by this merge.
- **Questions answered by a named human during the build:** NONE FOUND. No new product answer or decision-note writeback is implied by the user's merge/closure instruction.
- **`gaps.md` entries this ticket should close:** NONE FOUND. No winning/losing source or frontmatter change is justified; retain `reference`/`unverified` and existing conflict stubs. Q1 remains in `plan.md` §6 for separate Path A work.
- **`gaps.md` entries this ticket opened:** NONE FOUND. The three specified mobile omissions are implementation followups, carried explicitly by closeout, not new product-policy questions.
- **Undefined terms hit:** NONE FOUND in U1. Finalized-record adjustment versus reopening remains Q1, outside the scoped close.

## 4. Rule changes proposed

Proposals only; tooling is Haris-only. No tooling or vault source edited.

| # | File | Section | Exact change | Prevents | Accepted |
| --- | --- | --- | --- | --- | --- |
| R1 | `.ai/aidlc/agents/construction/tcg-executor.md` | Output shape | Replace the single line `Slice delivered:` with `Slice delivered: <each units.md slice obligation → implemented: file:line; verified unchanged: evidence; or OPEN: reason/followup. Include inherited branches and copy; a precommitted fix is checked against the full slice. Any OPEN obligation means partial delivery.>` Adds 1 line, removes 1. Test against ED-1: the expiry banner, lock precedence and copy obligations each need their own evidence or explicit OPEN entry; two changed policy sites plus green tests cannot stand in for them. This is a required report field, not a test or automatic source verifier. | ED-1 | pending — Haris review |

- **Rejected proposals, and why:** No new regression tests (not requested); no additional reminder duplicating the existing “every row” instruction; no policy change to finalized payroll. No new component or abstraction is needed merely to correct these three branches. The previous YARD-TICKET-GATE R7 remains separate: it maps formal spec edges; R1 maps the whole Path B slice, including copy and inherited code.

## 5. Recurrence check

Checked `reflections/INDEX.md` by class, then read YARD-TICKET-GATE reflection ED-2 and R7.

| Defect | Class | Prior rows | Occurrence | Why the previous fix did not hold |
| --- | --- | --- | --- | --- |
| ED-1 | `ignored-spec-edge` | YARD-TICKET-GATE ED-2 (2026-11-02) | 2nd | R7 is still proposed, not applied; current output lists files without mapping every slice obligation. There is no evidence an applied edge-report rule was ignored. |

- **Escalate:** none — 1 prior row, this is the second occurrence. R1 proposes a required evidence field, without claiming an automated gate exists.
- **New class added to the index?** no.
- **Rows appended to `reflections/INDEX.md`:** yes — one ED-1 row; no SD rows.

## 6. Kept as-is

- The API/mobile age-cutoff deletion is narrow and reversible. Shared incomplete-ticket 24h, approval 4h and offline-capture 72h windows remain unchanged, as do server tenant/ownership, lock, send-back and duplicate-request guards.
- The executor's refusal to overwrite missing/stale canonical overlay artifacts was an honest stop, not a defect. Recovered evidence is labeled retrospective; no baseline, device demo, deployment, or full acceptance is inferred.
- Analyst findings remain source inferences; the verdict remains “do not ship as complete”. A scoped close after merge records disposition and open followups, not a new analyst approval. U2/Q1 and configured-tenant demo remain deferred.
- Process improvement for the developer: make canonical unit artifacts available in the isolated overlay before execution and reconcile the analyst's open findings before merging, or explicitly record their followup disposition.
- One unrequested idea: show a worker the approval deadline beside correction eligibility, using the same deadline-aware projection as the request action. Not built or specified; a human may ticket or drop it.
