# Reflection — HOLDOVER-YARD-GATE Yard-Operations dependency for holdover tickets

## What this is for

Record what the spec missed, what execution failed to demonstrate, and the smallest proposed prevention. Findings concern artifacts and evidence, not people. Proposed tooling changes are for Haris; none is applied here.

## Fill rules

All template fields are retained. `NONE FOUND` means the inspected records contain no supporting evidence, rather than proof that an event never occurred. A correct guess remains a spec defect; no additional product guess is inferred merely from a small implementation detail.

## 0. Context

| Field                             | Value                                                                                                                                                                                                                                |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Ticket                            | `HOLDOVER-YARD-GATE` (slug; no external ticket ID)                                                                                                                                                                                   |
| Spec                              | `.ai/aidlc/HOLDOVER-YARD-GATE/spec.md`, elaborated `2026-11-04`                                                                                                                                                                      |
| Units                             | U1 API and U2 Mobile — shipped together in platform PR #1042 to `staging`; code `5f42143fd2637d45f09045f30c638411cf95115e`, merge `c98b670da6155b180ba149c8cbcd9e5dc54196cf`                                                         |
| Reflected on                      | `2026-11-05`                                                                                                                                                                                                                         |
| Reviewer(s)                       | Post-merge reflector; coordinator verified platform merge ancestry and overlay PR #253 merge `dfa58dfa1732e47ca665e07fb5b87f0a0b3d50a0`. No independent analyst artifact or fresh device verification supplied.                      |
| Open questions at build time      | Three raised; Q1–Q3 recorded resolved on 2026-11-04 before the completed build record. Exact executor start chronology is not established independently.                                                                             |
| `[UNVERIFIED]` requirements built | Seven of seven; zero source claims proved wrong or stale by recorded validation. This is not product ratification or runtime proof.                                                                                                  |
| Unverified × irreversible         | Zero new schema migrations, backfills or persistent representations. REQ-06 populates an existing nullable response field for additional tickets; coordinated API/mobile release changes observable behavior but remains reversible. |

Evidence: the merged diff, ticket intent/spec/units/state and coordinator-supplied merge verification. API mapper suite: 29 passed; mobile ticket contract suite: 63 passed. Precommit lint/format passed. Mobile typecheck retained two unchanged `lib/app-version.test.ts:71,83` TS2345 errors. No full build, device walkthrough or independent analysis result is recorded. The merge target was staging, not platform main.

## 1. Spec defects — what the spec missed

### SD-1 — Resolved answers and claimed sign-off do not reconcile with their source

- **Where:** Original spec requirements ledger REQ-03, §2 REQ-03 and state.md Sign-off row.
- **What the executor needed to know:** Whether the Day 2+ pre-choice behavior still blocked building, and the actual evidence supporting sign-off.
- **What the spec said:** REQ-03 `Blocks build? yes (§12 Q1)` and `Open Question: See §12 Q1 & Q2`, while §12 marks both resolved. State claimed `Sign-off — spec.md §14`; that section did not exist.
- **What was decided instead, and by whom:** Execution followed the anonymous user/owner Q1/Q2 answers in §12; the records did not reconcile the blocker and nonexistent sign-off reference. No personal identity can be inferred from Git authorship.
- **Was the decision right:** The shipped helpers match the recorded answers: a Day 2+ ticket with no Home choice uses Gate 1, while Home exempts it. The sign-off claim remains unsupported; resolved questions are evidence of their answers, not evidence of a missing §14 ceremony.
- **Cost:** Closure must reconstruct and correct the artifact chain; no product rework demonstrated.
- **Class:** `stale-reference`.
- **Fix:** R1 adds required reconciliation evidence to the existing executor report field. This closeout has reconciled REQ-03, the ledger and state without inventing sign-off; the defect describes pre-close artifacts, not a remaining stale blocker.

## 2. Executor defects — what was built against the spec

### ED-1 — Merge completion exceeded the demonstrated unit and review evidence

- **Where:** units.md U1/U2; platform PR #1042; state.md build and commit-validation records.
- **Spec said:** The governing repository rule requires one unit per PR, with dependent units stacked; Path A includes analyse before reflect. The ledger declares two units. Executor §6 requires lint/build and unit checks before handoff.
- **Built:** Both declared units merged in one PR. No one-unit exception or independent analyst artifact was found. The evidence establishes 92 focused passing tests and precommit checks; it does not establish a full build, green mobile typecheck or device behavior. The original state correctly left Analyse unchecked; do not promote it during closure.
- **Caught by:** Post-merge artifact reconciliation, not a demonstrated runtime failure. This is a process/evidence defect, not an assertion that gating is broken.
- **Class:** `gate-illusion`.
- **Fix:** Carry forward the existing MOBILE-REMAINING-PRESIGNED-FILES R3 required PR/unit evidence (R2 below); retain explicit limitations in closure. A check that is never run cannot establish an analyst verdict. No history rewrite or unsolicited source/test change is justified.

## 3. Source and vault findings

- **Sources that turned out to be wrong or stale:** Zero product-vault claims disproved. SD-1 concerns the ticket's own status references. All seven requirements carry `[UNVERIFIED]`; focused tests cannot establish whether those source labels predict business correctness.
- **Conflicts that surfaced only during build:** NONE FOUND in the product vault. Q1's pre-choice restriction refines this ticket's initial Home/Yard description; its resolved answer is the ticket's authority and must be reflected in the requirements. This reflection does not settle wider vault conflict stubs.
- **Questions answered by a named human during the build:** NONE FOUND with a personal name. Q1–Q3 are anonymous user/owner answers retained at ticket level. `tcg-scrum` §8 requires named-human provenance for a decision note; do not create a verified vault ruling or name the Git author as decision-maker. Parent closure records non-blocking §12 Q4 for attribution and any future vault writeback; Q1–Q3 remain settled for this implementation.
- **`gaps.md` entries this ticket should close:** NONE FOUND. No module gap closure was identified in the ticket records; the walkthrough pinned-surface check is a separate runbook check. No winning/losing frontmatter edits are justified by the available evidence. Anonymous attribution follow-up concerns writeback, not an unresolved product acceptance choice.
- **`gaps.md` entries this ticket opened:** NONE FOUND. Remaining independent analyst/device/full-build validation and inherited typecheck errors are explicit follow-ups, not fabricated product gaps.
- **Undefined terms hit:** NONE FOUND; Day 1/Day 2+, Home/Yard, Available for Dispatch and Complete Loadout are defined in ticket intent and inherited decisions.

## 4. Rule changes proposed

| #   | File                                            | Section                    | Exact change                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | Prevents | Accepted                                  |
| --- | ----------------------------------------------- | -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ----------------------------------------- |
| R1  | `.ai/aidlc/agents/construction/tcg-executor.md` | Output shape, `Stopped on` | Replace `Open questions written to spec.md §12: <Q ids, or "none">` with `Open questions written to spec.md §12: <Q ids, or "none">; reconciliation: <each resolved Q → updated requirement/blocker, and each claimed sign-off → existing source section or "unsupported">. Do not report the unit complete while a resolved question still blocks its requirement or a claimed sign-off source is absent.` Adds 1 report line, removes 1. This required cross-reference would expose both SD-1 inconsistencies; another reminder outside the completion report would not.                                                                                                                                                                                                 | SD-1     | pending — Haris review                    |
| R2  | `.ai/aidlc/agents/construction/tcg-analyst.md`  | §4 Complete? bullet        | Carry forward MOBILE-REMAINING-PRESIGNED-FILES R3 unchanged: replace `- **Complete?** Every row delivered, tests included, migration committed if the schema moved.` with `- **Complete?** Every slice row delivered; map this PR to exactly one declared unit or cite a requester-approved exception. For each added test case, cite the developer request or report a scope violation; updated existing expectations are separate. New tests default to not requested. Migration committed if the schema moved.` Adds 1 line, removes 1; this is one existing pending proposal, not a second rule home. The required mapping would expose the combined PR when analysis runs. Missing analysis remains missing evidence, not retrospectively completed by this proposal. | ED-1     | pending — existing proposal, Haris review |

- **Rejected proposals, and why:** Do not add tests to compensate for missing analysis, rewrite merged history, require owner permission for ordinary implementation choices, or introduce a new class for these existing shapes. Do not copy R2 into surface contexts. No rule is proposed solely for the three corrected fixtures: the existing contract/typecheck caught them before merge. No unsupported claim is made that current checks enforce these proposals mechanically; the structural mechanism is a required report/mapping field, and unrun review remains visible.

## 5. Recurrence check

INDEX.md was 45,464 bytes: read vocabulary by section, grep each class and inspect only relevant defect/recurrence sections of the named reflections. Counts retain withdrawn historical rows explicitly; these are not all active defects.

| Defect | Class             | Prior rows                                                                                                                                                                                                                                                                                       | Occurrence                               | Why the previous fix did not hold                                                                                                                                                                                                                                                                                 |
| ------ | ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| SD-1   | `stale-reference` | Eight prior rows (seven active): SCRUM-900 ED-3; SCRUM-926 ED-3; SCRUM-252 ED-5; SCRUM-LOADOUT-UNASSIGNED SD-1; TICKET-FLOW-SLOTS-HOLDOVER SD-7/SD-8 (SD-8 withdrawn); MOBILE-TICKET-PRESIGNED-IMAGES SD-7; MOBILE-OFFLINE-DELETE-QUEUE SD-6                                                     | Ninth historical row; third+ active      | TICKET-FLOW-SLOTS-HOLDOVER R5 is marked applied in the index, but current executor output contains no required requirement/blocker/sign-off reconciliation evidence. Later amend-in-place/closure proposals remain pending. A rule-status label alone does not prove the current completion artifact checks this. |
| ED-1   | `gate-illusion`   | Eighteen prior rows (fifteen active), across SCRUM-900, SCRUM-926, SCRUM-252, SCRUM-LOADOUT-UNASSIGNED, TCG-218, TICKET-FLOW-SLOTS-HOLDOVER, MOBILE-TICKET-PRESIGNED-IMAGES, MOBILE-OFFLINE-DELETE-QUEUE and MOBILE-REMAINING-PRESIGNED-FILES; nearest exact PR/unit precedent: last ticket ED-2 | Nineteenth historical row; third+ active | Earlier checks address different conventions or only gate execution. The nearest PR/unit evidence proposal remains pending and no independent analyst artifact exists here. Passing focused checks do not inspect the process contract.                                                                           |

- **Escalate:** Both classes are already beyond the third occurrence. This is not a reminder problem. Use required reconciliation/report and PR/unit mapping fields (R1/R2), with human review of the missing evidence; do not add more surface prose or claim unrun gates passed. The known gap is review evidence, not a demonstrated source-code regression.
- **New class added to the index?** No.
- **Rows appended to `reflections/INDEX.md`:** Yes — SD-1 and ED-1, both proposed. Existing rows remain unchanged.

## 6. Kept as-is

- API sends a non-null gate for loadable holdover tickets regardless of Home/Yard; mobile applies the choice, per Q3. Non-loadable/no-sub-job tickets remain ungated. No schema migration is needed.
- Dashboard/Jobs use shared gate helpers; no per-card source change is required merely because units named those files. The Home exception includes the effective optimistic choice in step navigation and refreshed gate checks.
- Enforcement remains client-only and online-only under inherited D12. Adding a server guard would contradict scope.
- Existing U2 ticket instructions explicitly requested contract test updates. The merged test changes are not classified as an unauthorized-test defect; this closure adds no tests. Three incomplete timeTracking fixtures were corrected before merge; no new cases were added during commit preparation.
- Two unchanged app-version.test.ts TS2345 errors remain a known limitation. The startup native-module error in chat was reported fixed separately; no causal link to this diff is established.
- Staging merge plus the original overlay merge supports administrative closure with recorded limitations. This closeout corrects the ticket artifacts; closure publication still requires merging these new records into `.ai/main`. It does not certify platform main deployment, a completed analyst phase, green full builds, or device behavior. The owner-attribution/writeback follow-up remains separate.
- What the developer could have done differently: reconcile resolved Q answers into requirements before handoff and retain an independent analyst result plus the exact device scenario evidence before merge.
- One unrequested idea: show a ticket's current yard availability/loadout status and its last refresh time together so crews can understand what still blocks dispatch. Not built; a human may ticket or drop it.

I have proposed rule changes, not applied them.
