# Reflection — MOBILE-CERT-VIEW View and download certificates (mobile)

> Path A, Trello #180, no Jira ticket. Written 2026-11-11 after U1 and U2 merged into
> `origin/staging`. Every finding is marked VERIFIED (read in a file or diff during this
> reflection) or INFERRED (taken from the caller's account, not re-checked). Findings are
> attributed to artifacts, not people. Rule changes are proposed here and applied nowhere.
>
> **Run on Sonnet-class.** §5 shows two classes at their third-or-later occurrence
> (`branch-ops`, `env-lesson`). Per the reflector's tier rule that run belongs on Opus;
> Haris should treat the two escalations below as a draft to confirm.

## 0. Context

| Field | Value |
| --- | --- |
| Ticket | `MOBILE-CERT-VIEW` (Trello #180, no Jira) |
| Spec | `.ai/aidlc/MOBILE-CERT-VIEW/spec.md`, elaborated 2026-11-10, signed off by haris 2026-11-10 |
| Units | U1 shipped (PR #1062, merge `c86612c06`; `76c675a90` + `8bc848789`, `apps/api/src/usecase/me/me.service.ts`). U2 shipped (PR #1063, merge `63e30c1ff`; `c3fb9b2b5`, `apps/mobile/app/(field)/menu/certifications.tsx`). Both merged by haris 2026-11-11. VERIFIED from `git show --stat`: one file each, parent of U2 is `fa83fe40f`. |
| Reflected on | 2026-11-11 |
| Reviewer(s) | haris (spec sign-off, §11b/§11c, PR merges). Analyst verdicts were chat-only: U1 ship with follow-up, U2 ship with follow-ups (INFERRED, no artifact to read). |
| Open questions at build time | 1 (Q1, base branch). Answered by haris before the executor started (VERIFIED, spec §12 Q1 *Answer*). |
| `[UNVERIFIED]` requirements built | 5 of 5 (REQ-01..REQ-05). 0 found wrong or stale. Not a strong signal: none was checked against a source beyond the developer's own decisions, and the real-phone check did not run. |
| Unverified × irreversible | 0. Read-path API change and a mobile label; no migration, enum or backfill (spec §3, units.md Risk). |

## 1. Spec defects — what the spec missed

### SD-1 — A known wrong-document risk was parked in §13, not raised

- **Where:** spec §13, third "Not verified" bullet: *"Name matching is by lower-cased trimmed name, so a `dbCerts` row can show another attachment's document when names collide … flagged, not raised as a question because the developer's decisions do not touch it."* (VERIFIED).
- **What the executor needed to know:** whether the document a card opens must be the one on the row the card shows.
- **What the spec said:** a prose note in §13 and nothing in §2, §11b or §12.
- **What was decided instead, and by whom:** haris chose to fix it in this ticket after the spec agent surfaced it; REQ-04 and D6 were added before sign-off (VERIFIED, spec §2 REQ-04, §11b D6).
- **Was the decision right:** yes. The analyst then found the fix was incomplete (SD-2), which confirms the area was fragile. The four-case DB demo passed (INFERRED, caller's account).
- **Cost:** none beyond a unit that was not in the card. The risk was caught before sign-off. It is recorded because it surfaced only because the spec agent chose to say it, in a section the template describes as "no source" items.
- **Class:** missing (a data-correctness risk filed under "not specified").
- **Fix:** R4.

### SD-2 — D6 did not say how ties between same-name rows are broken

- **Where:** spec §11b D6 and units.md U1 slice row. D6 says to link the winning row's own attachment id and says nothing about which row wins when two have equal expiry or both have none (VERIFIED: the D6 tiebreak sentence was added after the analyst's finding; units.md U1 has no tie rule).
- **What the executor needed to know:** what "the winner" is when the existing dedupe has no strict ordering.
- **What the spec said:** *"the final map links `attachmentId` to the winning row's own id"* (units.md U1).
- **What was decided instead, and by whom:** the executor built the link on the existing first-wins dedupe; once `attachmentId` rode on the winner, equal-expiry and both-null ties became database-row-order dependent (VERIFIED in the diff: `isNewerUpload`/`isReplacement` added in `8bc848789`). The analyst found it; haris approved the tiebreak (newest upload, then highest id).
- **Was the decision right:** yes, deterministic. Not run beyond the demo and the 4/4 `me` jest.
- **Cost:** one analyst finding and one extra commit, before merge.
- **Class:** missing. A right guess would have been a defect too: the existing code had the same gap for the expiry, it just did not matter until the document followed the winner.
- **Fix:** R3.

### SD-3 — Ticket artifacts drifted from the code they describe

- **Where:** VERIFIED in the files today:
  - spec §12 Q1 *Status:* still `open` though *Answer:* is filled and the build used it.
  - spec §4: *"On `main` (this worktree) the field does not exist"*; the base is now `origin/staging`.
  - spec §11b rows D1-D6 carry an extra cell, so *Reviewed by* is blank and `haris` sits in the *Date* column; §11c *Reviewed by* is empty while §14 ticks "A developer has reviewed §11b and §11c".
  - units.md *Gate baseline* holds a new result and, in the same paragraph, the old "NOT RUN … worktree has no `node_modules`" text.
  - state.md still read "no PR yet", Merged unchecked (INFERRED: the caller updates it).
- **What the spec said / decided:** contradictory states in one file. Nobody was misled into a wrong build, because the executor read the answered text. It is a defect because the next reader cannot tell which line is current.
- **Cost:** hand edits to units.md and state.md (per the caller); no wrong build.
- **Class:** stale-reference. Sixth-plus row in that class, with a `proposed` structural fix already waiting.
- **Fix:** carry forward HOLDOVER-YARD-GATE R1 (§5). No new rule.

## 2. Executor defects — what was built against the spec

The first two are tooling, not carelessness: the executor used the documented path
(`pnpm worktree:add`) and the path produced the wrong state. Class given as *other — tooling*.

### ED-1 — Worktree cut from `origin/main` while the code lived on `staging`; U2's overlay had no ticket folder

- **Where:** `scripts/worktree-add.sh:42` (`git worktree add --no-track -b "$BRANCH" "$WT_PATH" origin/main`) and `scripts/worktree-bootstrap.sh:111` (`git -C "$ai_repo" branch --no-track "$client_branch" origin/main`) (both VERIFIED). Documented in `.claude/skills/commit/SKILL.md:144` ("Always branch from `origin/main`") and `agents/construction/tcg-executor.md` lines 57-73 (VERIFIED).
- **Spec said:** units.md header: *"Base for every unit: `origin/staging` (spec D5 / Q1). PRs target `staging`."*
- **Built:** a branch from `main`, which lacks `openStoredAttachment`, `/attachments/:id/links` and the `attachmentId` field (VERIFIED, spec Q1). The spec agent found it; the branch was reset hard to `origin/staging` (`fa83fe40f`). The rebase had carried two unrelated main-only commits; both merge stats show one file each, so nothing leaked (VERIFIED).
- **Second symptom, same cause:** the second worktree (`mobile-cert-view-u2`) got an overlay branch cut from overlay `origin/main` (`worktree-bootstrap.sh:111`), which has no `aidlc/MOBILE-CERT-VIEW` folder. VERIFIED today: `ls .ai-worktrees/mobile-cert-view-u2/aidlc/MOBILE-CERT-VIEW` fails, and that overlay's branch is `feat/MOBILE-CERT-VIEW-u2-mobile-card` while the client branch is `...-u2-mobile-states`. Cause of the name difference not investigated. The executor could not see intent/spec/units and wrote ledger rows into the first worktree's overlay (INFERRED, caller's account).
- **Caught by:** the spec agent (base). The executor's missing-overlay was noticed in the run. Neither was caught by a rail.
- **Class:** other — tooling (index class `branch-ops`).
- **Fix:** R1 (script), R2 (executor instruction).

### ED-2 — Emulator on the worktree bundle failed: `Cannot find native module ExpoApplication`

- **Where:** `scripts/worktree-bootstrap.sh:70-75` links env files only; no `google-services.json`, `GoogleService-Info.plist` or `.eas` (VERIFIED: bootstrap's `link_env_files` list; the worktree holds only the `.example` files). `apps/mobile/.gitignore:13-14` ignores the two Firebase files (VERIFIED).
- **Built:** two emulator attempts failed; the primary checkout runs. **Cause not found.** The gitignored-files link is a hypothesis, untested (per the caller). Whether `ExpoApplication` is even related to those files is not established.
- **Result:** real-phone / emulator check of the cards did not happen from the loop.
- **Caught by:** the developer, at run time.
- **Class:** other — tooling (index class `env-lesson`).
- **Fix:** R5.

### ED-3 — Both units merged with the card's definition of done unmet, and gates partly unrun

- **Where:** intent §3 *"Done when tested on a real phone"*; units.md U2 *Demo*; state.md Resume (VERIFIED text).
- **Built / merged:** PRs #1062 and #1063 merged on 2026-11-11 with: no real-phone test; analyst did not run the gates (INFERRED, caller); REQ-05's 404 branch read, not run; card layout not seen rendered; `step-dispatch.test.tsx` red on staging, pre-existing (INFERRED from caller; the file does exist on `origin/staging`, VERIFIED). Executor-run gates passed: api lint 0 errors, api build pass, `me` jest 4/4, mobile typecheck pass, lint 0 errors, jest certifications+menu 28/28 (state.md, INFERRED as reported). The api typecheck/full suite and the mobile build did not run.
- **Read-only checks done in this reflection (not runs):** `openStoredAttachment` (`apps/mobile/lib/attachment-links.ts` on `origin/staging`) calls `api.get` and lets the axios error propagate unwrapped, including on the retry's second `load()`, so `axios.isAxiosError(error) && error.response?.status === 404` can fire (VERIFIED by reading). `axios` is a direct dependency of `apps/mobile` (`package.json:51`), so the new import is not a G5 dependency. The scope is a 404 on the links call only; a deleted S3 object keeps the generic toast, which REQ-05 and the units.md acceptance line allow.
- **Caught by:** nobody in the loop; this is a gap, not a finding by review.
- **Class:** gate-illusion (index definition is loose here; the nearest existing rows are red-baseline and merged-together rows).
- **Fix:** carry forward MOBILE-REMAINING-PRESIGNED-FILES R3 / HOLDOVER-YARD-GATE R2 (analyst §4 evidence). `close-ticket` must not report this ticket done on the card's terms until the real-phone check runs.

## 3. Source and vault findings

- **Sources that turned out to be wrong or stale:**
  - `vault/decisions/2026-11-04-mobile-presigned-reads-viewers-approved-employee-files-owner-or-admin.md` (S2): approves the label "View / Share Document". Now **superseded** by REQ-02's "View / Download / Share", not wrong. `[UNVERIFIED]` in the spec (status `reference`). Suggested outcome: a superseded line added via `tcg-scrum`.
  - `[UNVERIFIED]` tally: 5 requirements, 0 shown wrong. The tag predicted nothing here, mostly because no step checked it beyond the developer's own decisions.
  - `reflections/INDEX.md` records TCG-218 R9 (`pr-base.yml`) as applied. `.github/workflows/` in the primary checkout holds only `deploy.yml` and `monthly-full-check.yml` (VERIFIED). Why it is gone was not investigated. Suggested outcome: Haris checks whether the rail exists elsewhere; if not, the row's status is wrong.
- **Conflicts that surfaced only during build:** no vault conflict. One instruction conflict: `commit/SKILL.md:144` and `tcg-executor.md:57-73` say branch from `origin/main`; units.md and spec D5 say `origin/staging` for this ticket. Both are right in their own scope; nothing tells the executor which wins. Not a vault `gaps.md` item; handled by R2.
- **Questions answered by a named human during the build:** haris decided Q1 (rebase on `origin/staging`), the single-button label (Q5), the disabled state and "No document on file" (Q4), fix name collisions in this ticket (REQ-04), the REQ-05 wording (approved 2026-11-10), and the tiebreak (yes). **Written to `vault/decisions/`? no.** Spec §14 marks the §12 row `[S]` (skipped) and says "no vault decision note written". These are developer decisions, not client rulings (spec header). GUIDE §10 sends *a named human decided something* to `vault/decisions/` via `tcg-scrum`. Suggested outcome: one note, `2026-11-10-mobile-certificate-view-developer-decisions.md`, written by `tcg-scrum` at `close-ticket`, status `reference`.
- **`gaps.md` entries this ticket should close:** none. `grep -i certif` across the gaps files hit certified-payroll entries, a projects-jobs note on certifications as attachments with expiry (`vault/projects-jobs/gaps.md:149`) and asset certifications (`:212`); none asks what this ticket settled. Not read beyond the matched lines.
- **`gaps.md` / §12 entries this ticket opened:** spec §12 **Q2** (deleted S3 object detection), appended with this reflection.
- **§12 entries this ticket should close:** Q1: set `Status: resolved`, pointing at the decisions note above once it exists.
- **`field-ops/field-ops-mobile-INDEX.md` conflict:** not adjudicated; the three candidate INDEX files were never read for certificates (spec §13). Suggested outcome: leave open.
- **Undefined terms hit:** none.

## 4. Rule changes proposed

Tooling files are Haris-only. These go to Haris; none is applied.

| # | File | Section | Exact change | Prevents | Accepted |
| --- | --- | --- | --- | --- | --- |
| R1 | `scripts/worktree-add.sh` and `scripts/worktree-bootstrap.sh` | line 42 and line 111 | Add `--base <ref>` and `--overlay-base <ref>` to `worktree-add.sh`; replace the hardcoded `origin/main` at line 42 with `"${BASE:-origin/main}"`, and at `worktree-bootstrap.sh:111` with `"${OVERLAY_BASE:-origin/main}"` (passed through the environment). After `git fetch origin`, if `git rev-list --count origin/main..origin/staging` is above 0 and `--base` was not given, print to stderr: `origin/staging is N commits ahead of origin/main. If the files you edit are not on main, rerun with --base origin/staging.` (warning, not a failure). Adds ~14 lines, removes 2 (the two hardcoded refs). | ED-1 | pending |
| R2 | `.ai/aidlc/agents/construction/tcg-executor.md` | the branch step (lines ~57-73) | Replace `git switch -c <type>/SCRUM-###-u<n>-<slug> origin/main` and the sentence *"From `origin/main`, never local `main`"* with: *"Branch from the base named in `units.md` under 'Branch / PR base'; `origin/main` only when it names none. Never from local `main`."* Run `worktree:add` with `--base` and `--overlay-base` to match. Replaces 2 lines, adds 1; the same sentence in `commit/SKILL.md:144` links here instead of repeating it. | ED-1 | pending |
| R3 | `.ai/claude/contexts/api.md` | amend the still-proposed TICKET-FLOW-SLOTS-HOLDOVER R11 section | Rename the planned heading `Cron scans` to `Choosing one row among many` and use one sentence for the whole section: *"A query, map or dedupe that keeps one row among several with the same key states its tiebreak, ending in `id`; a `take` without an `orderBy` is a defect."* Replaces R11's cron-only sentence; adds 0 net lines. Tested against SD-2: an executor linking `attachmentId` to a dedupe winner would have met the sentence while editing `me.service.ts` and added the tiebreak in the first commit. | SD-2 | pending |
| R4 | `.ai/aidlc/templates/spec.md` | §13 intro (lines 386-388) | Append to the intro: *"A known risk that a user is shown the wrong data or document is not listed here: it is a §12 question or a §11b row."* Adds 1 line, removes 0 (nothing can go). Weaker than a rail; no mechanical check exists for prose in §13, so this is a reminder and is marked so. | SD-1 | pending |
| R5 | `scripts/worktree-bootstrap.sh` and `.ai/claude/contexts/mobile.md` | `link_env_files` (lines 69-76); carry forward MOBILE-OFFLINE-DELETE-QUEUE R11 | Add `link_path "apps/mobile/google-services.json"` and `link_path "apps/mobile/GoogleService-Info.plist"` to `link_env_files`. **First prove the hypothesis:** link them by hand, rebuild the bundle, and see whether `Cannot find native module ExpoApplication` goes away; if not, do not merge this and write only the line "run a device build from the primary checkout" under R11. Adds 2 lines, removes 0. | ED-2 | pending |
| R6 | carry forward, do not re-propose | HOLDOVER-YARD-GATE R1 (SD-3); MOBILE-REMAINING-PRESIGNED-FILES R3 / HOLDOVER-YARD-GATE R2 (ED-3) | Apply the existing proposals. Nothing new is added. | SD-3, ED-3 | pending |

- **Rejected proposals, and why:**
  - A test for the equal-expiry tiebreak: tests are not requested by default (`CLAUDE.md`); the 4-case DB demo covered it.
  - A typed error from `attachment-links.ts` for the S3 deleted-object path: it changes the shared opener used by quotation, job-artifact and job-walk-signature buttons (spec §11c) and was out of scope. Recorded as spec §12 Q2 instead.
  - A new `decisions/` rule for developer decisions: GUIDE §10 already says where they go; the gap was that `close-ticket` ran no step to write them, and `tcg-scrum` holds the path. Left as a finding in §3.

## 5. Recurrence check

Checked by grep of `reflections/INDEX.md` for the class names.

| Defect | Class | Prior rows | Occurrence | Why the previous fix did not hold |
| --- | --- | --- | --- | --- |
| SD-1 | missing-requirement | 28 | far past 3rd | N/A for the class (too broad to act on); this instance has its own cause (R4). |
| SD-2 | missing-requirement | 28 | far past 3rd | N/A, see R3. The nearest prior row is TICKET-FLOW-SLOTS-HOLDOVER ED-13 (`unbounded-scan`, 1 prior: unordered `take`), which R3 absorbs. |
| SD-3 | stale-reference | 9 | far past 3rd | Written and not applied. HOLDOVER-YARD-GATE SD-1 R1 is `proposed`; no rail enforces the reconciliation. |
| ED-1 | branch-ops | 4 (TCG-218 ED-2, ED-3; MOBILE-TICKET-PRESIGNED-IMAGES ED-5; MOBILE-OFFLINE-DELETE-QUEUE ED-5) | **5th** | **Written, applied, and it produced this one.** TCG-218 R10 (applied 2026-10-20) made `pnpm worktree:add` the required path; that script hardcodes `origin/main`, and the executor/commit docs say the same. R9's PR-base rail covers the base a PR targets, not the base a branch was cut from, and `pr-base.yml` is absent today. R12 rows are still `proposed`. |
| ED-2 | env-lesson | 2 (MOBILE-OFFLINE-DELETE-QUEUE ED-3, ED-4) | **3rd** | **Never written.** R11 (`mobile.md` "Running on a device") is `proposed`; `mobile.md` today has no device, emulator or worktree text (VERIFIED by grep). A lesson that was written down only in the index was relearned by hand. |
| ED-3 | gate-illusion | 19 | far past 3rd | Written and not applied; analyst §4 evidence proposals still `proposed`. |

- **Escalate:**
  - **`branch-ops` (5th) — not a reminder problem.** The prose rule ("branch from `origin/main`") is correct for most tickets and wrong for this one, and the tool that enforces it has no way to say otherwise. Structural fix: R1 (the script takes the base the ticket names and warns when `staging` is ahead of `main`) plus R2 (the executor takes the base from `units.md`), and the overlay branches from the ticket's overlay base instead of overlay `main`. The earlier fix did not hold because it was applied to the wrong layer: the PR base, not the branch base.
  - **`env-lesson` (3rd).** Not a reminder problem: the previous proposal is unapplied, so more prose repeats it. Structural fix: R5, a bootstrap that links the files the app needs, after the hypothesis is tested; if the hypothesis fails, the honest fix is the one line "device builds run from the primary checkout".
  - **A decision for Haris, not an agent:** `gate-illusion`, `stale-reference` and `missing-requirement` each already have `proposed` structural rows. The queue is not draining; the next reflection will add rows to the same classes until a human accepts or rejects them.
- **New class added to the index?** no.
- **Rows appended to `reflections/INDEX.md`:** yes, six (SD-1, SD-2, SD-3, ED-1, ED-2, ED-3).

## 6. Kept as-is

- **REQ-05 scope and the S3 limit.** The loop caught the scope gap (the developer's "missing certificate" first covered only no-attachment) before the build, added REQ-05, and the spec states in advance that a deleted S3 object may not be distinguishable. The mobile code keeps the generic toast for that path and for network errors, which was the stated requirement. Not a defect. Open follow-up only as Q2.
- **The four-case DB demo of U1** (run by hand against local `tcg_db`, rows cleaned up) is evidence for REQ-04 and the tiebreak, not an unrequested test: no spec file was added (INFERRED, caller's account; the diff shows no test file).
- **Sibling "open stored file" buttons left with generic toasts** (quotation cards, job artifacts, job-walk signatures, ticket incident files). Listed as a follow-up in spec §11c, which is how the siblings rule allows it; the rule was followed.
- **`axios` imported directly in `certifications.tsx`.** `axios` is already a direct dependency of `apps/mobile`; no G5 ask was needed.
- **Pre-existing red `step-dispatch.test.tsx` on staging.** Not caused by this ticket; recorded under ED-3 only as part of the red-baseline pattern.
- **Spec sign-off with the base question answered inline** (§14 `[S]` on the Q1 line): acceptable for a sequencing decision; the shortfall is the missing decisions note, in §3.
- **Two PRs instead of one.** Matches units.md; no cross-unit dependency, no stacked-PR issue.
