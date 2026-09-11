# Reflection — SCRUM-252 DAS Map View

> Written to `.ai/aidlc/SCRUM-252/reflection.md` after merge. Consumed by the reflector's
> own recurrence check on every future ticket.

## What this is for

Three questions, in this order — inverted for this ticket, because there was no pre-build
spec to miss anything: the branch ran with no `.ai/aidlc/SCRUM-252/` folder, no
`processed.log` row, no elaborator, no decomposer, no units, and no executor. Spec, seven
decision notes, gap dispositions and the ledger row were all written retroactively at PR
review, three rounds in. So §1 below asks what the *absent* spec cost, §2 asks what got
built wrong even measured against the retroactive record, and §3 is unusually load-bearing —
it is the only place any of this got checked at all.

## Fill rules

Every field is required. Findings are attributed to artifacts, not people.

---

## 0. Context

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-252` |
| Spec | `.ai/aidlc/SCRUM-252/spec.md` — **backfilled 2026-09-10, after the code**; not a pre-build spec |
| Units | none — no `units.md` ever existed. Ran as path C for work that needed path A |
| Reflected on | `2026-09-10` |
| Reviewer(s) | Not named in the retained record — `my-docs/scrum-252-map-view-review.md` (2026-09-09, outside `.ai/`) is cited by `spec.md` but not authored to a named reviewer there |
| Open questions at build time | **0 raised before build** (no spec existed to raise them). 5 raised at the 2026-09-09 review, plus 2 sub-questions (Q1a, Q1b) = 7. All 7 resolved by decision notes, all written 2026-09-10, all `status: reference` (developer-authored, standing in for an absent named product owner) |
| `[UNVERIFIED]` requirements built | 1 source cited for the entire feature — `dispatch/daily-allocation-system.md` → *USER STORY : Live Asset Map View*, `status: unverified`, updated 2026-04-30, 7 acceptance criteria. **3 of 7 proved wrong or stale** when checked at review (AC1, AC2, AC5); 1 more (AC6) is inapplicable to current DAS and always was |
| Unverified × irreversible | **0.** Every wrong/stale criterion was reversible when found — AC1 in one JSX file, AC2/AC5 simply unbuilt and deferred. The absence of a spec was expensive; the unverified content itself was not made hard to reverse |

## 1. Spec defects — what the spec (or its absence) missed

### SD-1 — The sole written source was never reverified, and was wrong in nearly half its claims

- **Where:** nowhere — no spec existed before the build to say the source needed checking.
- **What the executor needed to know:** whether `daily-allocation-system.md`'s *Live Asset
  Map View* user story still described the screen it claimed to.
- **What the spec said:** the story is `status: unverified`, last touched 2026-04-30 — over
  four months stale by the time of this build, and never adjudicated.
- **What was decided instead, and by whom:** the branch built against three of its seven
  criteria differently than written (AC1 full-board vs centre-panel, AC2 generic marker vs
  crane icons, AC5 no transit path/ETA), and shipped two behaviours the story does not
  mention at all (the Yard Operations mount, the job-stage badge taxonomy). Nobody flagged
  the mismatch until PR review; it was then resolved by the developer authoring seven
  decision notes, none of which is a named product owner's word — each is explicitly
  recorded as a developer decision standing in for one.
- **Was the decision right:** unknown. Two of the seven decision notes (Q3 transit/ETA →
  Brian Petros, Q4 Dylan's dashboard) are flagged in `spec.md` §14 as still needing to be
  shown to a named human; Q4's own note says it was decided **against the written record**
  on purpose, "so Dylan can be shown it and say no."
- **Cost:** three review rounds instead of one; a spec, seven decision notes and a
  `processed.log` correction row all had to be written after the fact instead of during
  elaboration, when the same questions would have cost a single conversation.
- **Class:** laundered an unverified source as settled — the only written brief for the
  feature was carried through an entire build with nobody checking it against current
  behaviour or a living person.
- **Fix:** see R7.

### SD-2 — Nothing rules on a DAS shift crossing midnight, and the branch silently picked the wrong answer

- **Where:** `apps/web/src/features/das/map-section/utils/shift-time.ts`.
- **What the executor needed to know:** whether a DAS shift's end time may fall on the
  calendar day after its start (18:00 → 02:00), and what the board must show while one is
  running.
- **What the spec said:** nothing, anywhere — `daily-allocation-system.md` names no shift
  clock or day boundary, and `decisions/` holds no DAS shift ruling.
- **What was decided instead, and by whom:** `shiftInstant(date, startTime)` and
  `shiftInstant(date, endTime)` both anchor to the same calendar `date`, so an 18:00 → 02:00
  shift resolves its end to 02:00 **that same morning** — `describeRemainingTime` reads
  `end - now <= 0` and shows **"Completed"** for a shift that just started; `isToday`
  additionally drops the clock the moment real midnight passes. Nobody decided this; it is
  the implicit consequence of the simplest implementation.
- **Was the decision right:** **no**, and this is the one live, unfixed defect in this
  reflection. `../decisions/2026-09-04-cross-midnight-day-type-and-holiday-minimum.md`
  (`status: verified`) already adjudicates how a shift that crosses midnight is *paid* —
  which presumes such shifts exist — and two already-shipped modules
  (`apps/web/.../schedule/utils/schedule-date-utils.ts`,
  `apps/api/src/service/employee/shift-hours.util.ts`) already treat `end < start` as a
  legitimate overnight shift, not a data error. The branch's implicit choice contradicts a
  `[VERIFIED]` sibling source that was never consulted.
- **Cost:** live defect, unfixed. Registered as open at
  [`vault/dispatch/gaps.md` → *Overnight DAS shifts*](../../vault/dispatch/gaps.md).
- **Class:** contradicted a source (specifically: an already-`[VERIFIED]` decision and two
  shipped sibling implementations, neither consulted).
- **Fix:** see R3.

### SD-3 — `isActive` on a job-schedule interval is undefined, and the map's query silently disagrees with the jobs board's

- **Where:** `apps/api/src/service/das/das.repository.ts` —
  `getSamsaraLinkedAllocationsByDate` (new, no filter) vs the existing DAS jobs-board query
  (`jobScheduleInterval: { isActive: true }`, line ~664).
- **What the executor needed to know:** whether the map query must apply the same
  `isActive` scope as the board it sits beside.
- **What the spec said:** nothing — `isActive` is not defined anywhere in the product
  record; it appears in the vault only inside `gaps.md` registers and unrelated
  accounting/payroll field maps, never as a DAS rule.
- **What was decided instead, and by whom:** the map query was written with no `isActive`
  filter, so a day hidden from the jobs board would still draw its units on the map — caught
  by the developer during the build, not by a written rule or by review.
- **Was the decision right:** caught before shipping, so no live defect, but the near-miss
  is the finding: nothing written would have caught it if the developer had not noticed.
- **Cost:** none yet — a near-miss. Registered as open at
  [`vault/dispatch/gaps.md` → *`isActive` on a job schedule interval*](../../vault/dispatch/gaps.md).
- **Class:** missing — no source states the rule at all.
- **Fix:** see R5.

### SD-4 — No written rule states that a Samsara fetch must stay id-filtered, and a retry path violated it

- **Where:** `apps/web/src/features/.../hooks/use-vehicles.ts` — `reload()`.
- **What the executor needed to know:** that `useVehicles`'s id-list parameter is not a
  convenience — it is the only thing bounding what could otherwise be a full-fleet Samsara
  fetch, and every call site (including retries) must respect it.
- **What the spec said:** nothing. `spec.md` §0 cites `CLAUDE.md` → *Vehicle tracking
  (Samsara)* as a rule consulted for this ticket; **no such section exists in any `CLAUDE.md`
  in the repository** (see ED-5 — this citation is itself a defect, not just a gap).
- **What was decided instead, and by whom:** `reload()` called React Query's `refetch()`,
  which does not consult `enabled` (verified against `@tanstack/query-core@5.101.2`,
  `queryObserver.js:158-162`). With an empty id list, "Try again" sent no filter at all,
  which the server reads as "every linked vehicle" — the exact cost the id list exists to
  prevent. Caught in the 2026-09-09 review, fixed with an early return on `!enabled`.
- **Was the decision right:** no, and it was caught before merge.
- **Cost:** one review round.
- **Class:** missing — the invariant exists only as an unstated property of one hook's
  parameter, with a spec citation pointing at a rule document section that was never real.
- **Fix:** see R6.

## 2. Executor defects — what was built against the (retroactive) record

### ED-1 — The branch never ran the loop, and the CI gate written to catch exactly this did not fire

- **Where:** the branch as a whole; `.github/workflows/affected.yml` (the gate that should
  have caught it).
- **Spec said:** N/A — there was no spec until after the fact. The relevant rule is
  `GUIDE.md` §2's escalation valve: *"any path becomes Path A the moment you have to decide
  something nobody specified."*
- **Built:** 57 files, merged as PR 522 (`25185b04`, tip `3733a11e`), with no
  `.ai/aidlc/SCRUM-252/` folder, no `processed.log` row, and none of
  elaborator/decomposer/executor ever invoked. Discovered only at PR review, three rounds
  in; spec, seven decision notes, gap entries and the ledger row were all written
  retroactively.
- **Caught by:** review, not by any automated gate.
- **This is the fifth occurrence of `gate-illusion`, and the fix applied for the third
  (SCRUM-926 ED-4, 2026-08-26) did not hold — see §5 for why.**
- **Class:** other — the loop itself was skipped, not a rule inside it broken.
- **Fix:** see R1, R2.

### ED-2 — Two independent reimplementations of the `SubJobStage` → display-bucket mapping, and a comment that asserted they could not diverge

- **Where:** `apps/api/src/usecase/das/das-map.service.ts:21` and
  `apps/web/src/features/dylen-dashboard/utils/map-das-job-to-dylen-card.ts:5`.
- **Spec said:** N/A — no written source names a bucket taxonomy at all (see
  [`vault/dispatch/gaps.md` → *DAS map job status buckets*](../../vault/dispatch/gaps.md)).
- **Built:** the DAS-side service and the Dylen-side mapper each carried their own copy of
  the nine-stage-to-four-bucket collapse, with a code comment in one asserting the two
  screens could never disagree. `map-das-job-to-dylen-card.ts` had no `CANCELLED` case and
  fell through to `default: return 'pending-loadout'` — a cancelled job read "Cancelled" on
  the map and "Pending Loadout" on Yard Ops.
- **Caught by:** review (Q5a).
- **Fixed:** by deleting the duplicate taxonomy on the DAS side entirely and reusing the
  jobs board's own `JOB_STAGE_LABELS`/`JOB_STAGE_BADGE_STYLES`; giving Yard Ops a real
  `cancelled` display status, filter and badge; and changing the Dylen mapper's `default`
  arm to `completed` instead of `pending-loadout`, since falling back to "the yard owes work
  on this" is what caused the defect and is the wrong default for any future stage value.
- **Class:** **new — `duplicated-logic`** (added to the index in this reflection; see §5).
- **Fix:** see R3, R4.

### ED-3 — A second, silently divergent private copy of `resolveDate`

- **Where:** `DasService` and `DasMapService`, `apps/api/src/usecase/das/`.
- **Spec said:** N/A.
- **Built:** each service carried its own private `resolveDate`, differing on empty-string
  handling.
- **Caught by:** review.
- **Fixed:** extraction to a shared `date-boundary.util.ts`.
- **Class:** `duplicated-logic` — **the second instance of this exact class within this one
  ticket.** Worth stating plainly: this is not cross-ticket recurrence, it is the same
  failure shape twice in one build, which is its own signal that "write it once, reuse it"
  was not a live habit on this branch.
- **Fix:** see R3.

### ED-4 — A shared marker component's rewrite silently changed an existing, already-shipped screen

- **Where:** `apps/web/src/features/vehicle-tracking/components/map/vehicle-marker.tsx`
  (`TruckMarker`), shared between the new DAS map and the existing fleet vehicle-tracking
  map.
- **Spec said:** N/A — the vehicle-tracking map was not in scope for this ticket.
- **Built:** the rewrite left `isSelected` affecting only `zIndex`; the brand-coloured
  selection ring the existing tracking map relied on was dropped. Not mentioned in the diff,
  not covered by any test, not in the ticket.
- **Caught by:** review.
- **Fixed:** a size-step cue (46 → 58px) restored as a selection signal; the ring
  deliberately not restored, and the dead `ROUTE_TOKENS.selected` token (and the comment
  describing a ring that no longer existed) removed. Whether a ring was the right cue at all
  stays open —
  [`vault/assets/gaps.md` → *Fleet tracking map*](../../vault/assets/gaps.md).
- **Class:** `refactor-untested` — **second occurrence** (first: SCRUM-900 SD-1, a different
  shape of the same failure — an extraction whose test plan covered only the new call site).
- **Fix:** see R4.

### ED-5 — `spec.md` cites a `CLAUDE.md` section that does not exist

- **Where:** `.ai/aidlc/SCRUM-252/spec.md` §0 (*"Rules consulted"*) and §13, both citing
  `CLAUDE.md` → *Vehicle tracking (Samsara)*.
- **Spec said:** (self-referential — this is a defect in the spec's own citations) that this
  section was consulted for tenancy/vehicle-tracking rules, and separately that it "already
  flags 'who may see the Tracking menu' as unowned."
- **Built:** `grep -rn "Samsara\|Tracking menu" apps/*/CLAUDE.md .ai/claude/CLAUDE.md`
  returns nothing. No `CLAUDE.md` anywhere in the repository — root or per-app — has a
  *Vehicle tracking* section. The citation is fabricated, not stale in the usual sense of
  "was true once."
- **Caught by:** this reflection.
- **Class:** `stale-reference`. **Third occurrence — escalated, see §5.**
- **Fix:** see R6, which also gives the citation something real to point to.

## 3. Source and vault findings

This is the section that matters most for this ticket, because it is the only place any of
the above got checked at all.

- **Sources that turned out to be wrong or stale:**
  `dispatch/daily-allocation-system.md` → *Live Asset Map View* — `status: unverified`
  (updated 2026-04-30). AC1 (centre-panel only) — wrong, branch replaces the full board. AC2
  (crane-specific icons) — stale, the same 2026-04-02 demo the criterion was written from
  calls the icon "a placeholder" in the same breath. AC5 (transit path + ETA) — not
  implemented, blocked on a missing destination (job site arrives as a name string, not
  coordinates) that the criterion's author could not have known about from a demo alone.
  **3 of 7 criteria (43%) in the one cited source proved wrong or stale, and it was tagged
  `[UNVERIFIED]` the whole time.** This is a genuine data point for the question the tag
  system exists to answer (per `CLAUDE.md` and the reflector's own charter): here, the tag
  predicted correctly — an unverified source with no reverification *was* wrong nearly half
  the time. Also `spec.md`'s own citation of `CLAUDE.md` → *Vehicle tracking (Samsara)*
  (ED-5) — not stale, **fabricated**; no version of that section has ever existed.
- **Unverified requirements made hard to reverse:** none. Every wrong criterion above was
  cheap to reverse when found (§0 table). Worth recording precisely because it means the
  danger here was procedural (no spec, no review before build) rather than that the
  unverified content itself was made irreversible — a different risk profile than
  `unverified-permanent` defects recorded elsewhere in this index.
- **Conflicts that surfaced only during build (or during this review):** the `CANCELLED`
  stage divergence (ED-2), the `resolveDate` divergence (ED-3), and the `isActive`
  divergence between the map query and the jobs-board query (SD-3) — none of these would
  have surfaced from reading, because nothing written describes either side of any of the
  three conflicts.
- **Questions answered by a named human during the build:** **zero.** All seven decision
  notes in `vault/decisions/` are `status: reference`, and every one is explicit that it was
  authored by the developer (Akif Farooq) standing in for an absent named product owner —
  Lisette Anzaldo (4 notes), Brian Petros (1), Dylan Masterson (1, decided *against* the
  written record on purpose so he can veto it), and one (no wall-display variant) resolved
  on a scope argument rather than a person's answer at all. They are correctly written —
  this is not a defect in how they were recorded, `status: reference` is the right tag for a
  developer decision — but §14 of `spec.md` still lists three named people who have not
  seen any of it. That confirmation, if and when it happens, is not yet written anywhere;
  whoever closes this ticket should watch for it and route it to `tcg-scrum` if it changes
  anything.
- **`gaps.md` entries this ticket should close:** one, already correctly closed — [`vault/dispatch/gaps.md`
  → *DAS map panel is also mounted on the Yard Operations / Dylen dashboard*](../../vault/dispatch/gaps.md)
  carries `Status: resolved 2026-09-10` with the resolution note in place; no further edit
  needed.
- **`gaps.md` entries this ticket opened (still open):** *DAS map job status buckets* (the
  Yard Operations half only — the DAS half was resolved by decision note), *Cancelled
  sub-jobs on the DAS map*, *`isActive` on a job schedule interval*, *Overnight DAS shifts*
  (the live defect, SD-2), *DAS map detail sidebar*, and, in `vault/assets/gaps.md`, *Fleet
  tracking map — selected-vehicle treatment*. Six open entries from one ticket that never
  ran elaboration — this is the concrete cost of skipping it: every one of these would have
  been a spec question asked once, before code, instead of a gap discovered by an
  after-the-fact audit.
- **Undefined terms hit:** `isActive` (schedule interval), the pending-loadout / in-progress
  boundary for `LOADOUT`, "in transit" as a system state — none newly named here, each
  already tracked in the `gaps.md` entries above.

## 4. Rule changes proposed

| # | File | Section | Exact change | Prevents | Accepted |
| --- | --- | --- | --- | --- | --- |
| R1 | `.github/workflows/affected.yml` | *AI-DLC ledger check* step | Replace the soft-fail branch `if [ -z "${{ secrets.AI_LAYER_DEPLOY_KEY }}" ]; then echo "::warning::..."; exit 0; fi` with a hard failure (`echo "::error::AI_LAYER_DEPLOY_KEY is not set — this gate cannot verify processed.log and must not silently pass."; exit 1`); and change the ticket-detection line to `ticket=$(printf '%s\n%s' "$HEAD_REF" "${{ github.event.pull_request.title }}" \| grep -oiE 'SCRUM-[0-9]+' \| head -1 \| tr '[:lower:]' '[:upper:]' \|\| true)` so it is case-insensitive and checks the PR title, not only a branch name that has no enforced convention | ED-1 | pending |
| R2 | `.ai/claude/skills/commit/SKILL.md` | §1 Branch | Add a line under the branch-naming table: "CI's AI-DLC ledger check derives the ticket id from the branch name **and** the PR title — a branch that skips the `feat/SCRUM-###-slug` convention does not skip the gate, it just makes the PR title the only thing that will." | ED-1 (secondary, documentation) | pending |
| R3 | `.ai/aidlc/agents/construction/tcg-executor.md` | §3 *Existing code is not intent, and not permission* | Broaden the existing "grep before writing" rule from its current scope — *"Before writing new pricing, rate, or premium logic of any kind"* — to *"Before writing new pricing, rate, premium, date/shift-boundary, or status-taxonomy logic of any kind"*. The mechanism (grep `.ai/vault/decisions/` and the repo for an existing implementation of the same rule) is unchanged; only the trigger list widens | SD-2, ED-2, ED-3 | pending |
| R4 | `.ai/aidlc/agents/construction/tcg-executor.md` | §4 *Reuse before creating* | Add: "Before changing a shared component's props or behaviour, `grep -rn` every existing consumer and confirm each one's behaviour is unchanged, or state the change explicitly in the diff and PR description — a shared marker component lost an existing screen's selection ring with nothing recording it (`SCRUM-252` ED-4)." | ED-4 | pending |
| R5 | `.ai/claude/contexts/prisma.md` | §Conventions | Add: "When a new query is added beside an existing query over the same board or entity, diff its `where` clause against the existing one field-by-field before merging — a scope filter present on one and silently absent on the other (e.g. `isActive`) is a defect the type system cannot catch." | SD-3 | pending |
| R6 | `.ai/claude/contexts/web.md` | new §*Vehicle tracking (Samsara)* | Add a section stating: "Every Samsara feed read must go through an id-filtered call — never fetch the full fleet from a retry, a remount, or a new call site without checking whether an id list is available first. React Query's `refetch()` does not consult `enabled`; gate any retry path with an explicit `if (!enabled) return` or equivalent." This also gives `spec.md`'s existing citation of `CLAUDE.md` → *Vehicle tracking (Samsara)* something real to point to | SD-4, ED-5 | pending |
| R7 | `.ai/aidlc/agents/inception/tcg-elaborator.md` | new bullet, near its sourcing rules | Add: "When a requirement's only source is `status: unverified` **and no other source exists for the feature**, attempt one live check before carrying its acceptance criteria into `spec.md` as settled — ask the named reachable owner, or check the current behaviour of the screen/module the source claims to describe. Do not let a sole `[UNVERIFIED]` source become the entire spec unchallenged." | SD-1 | pending |

**A caveat that applies to R2–R7 as a group, stated once rather than repeated seven times:**
none of them would have fired on this branch, because the agents and skills they live in
were never invoked — this ticket ran as path C with no loop at all. They are real fixes for
the next ticket that *does* run the loop and hits one of these defect shapes; they are not,
by themselves, a fix for "a branch skips the loop entirely." Only R1 (a CI check that runs
regardless of which agent, if any, a human chose to invoke) addresses that directly. This is
also why R1 is the one that must actually hold this time — see §5.

- **Rejected proposals, and why:** none. No candidate rule change was considered and
  rejected in this reflection; every defect that was not already a near-miss caught in
  review produced a proposal above.

## 5. Recurrence check

Checked against `.ai/aidlc/reflections/INDEX.md`, by grepping each defect's class against
the index as it stood before this reflection.

| Defect | Class | Prior rows | Occurrence | Why the previous fix did not hold |
| --- | --- | --- | --- | --- |
| SD-1 | `unverified-stale` (new) | none | 1st | N/A — new class |
| SD-2 | `contradicted-source` | SCRUM-926 ED-1 | 2nd | N/A — not yet at threshold |
| SD-3 | `missing-requirement` | SCRUM-877 SD-1, SD-2 | **3rd** | See below |
| SD-4 | `missing-requirement` | SCRUM-877 SD-1, SD-2 | **3rd/4th** (second instance in this same reflection) | See below |
| ED-1 | `gate-illusion` | SCRUM-900 ED-1, ED-2; SCRUM-926 ED-4, ED-5 | **5th** | See below |
| ED-2 | `duplicated-logic` (new) | none | 1st | N/A — new class |
| ED-3 | `duplicated-logic` (new) | none | 1st (2nd within this ticket) | N/A — new class |
| ED-4 | `refactor-untested` | SCRUM-900 SD-1 | 2nd | N/A — not yet at threshold |
| ED-5 | `stale-reference` | SCRUM-900 ED-3, SCRUM-926 ED-3 | **3rd** | See below |

### ESCALATION 1 — `gate-illusion`, 5th occurrence

The fix applied at SCRUM-926 (ED-4, 2026-08-26) added the "AI-DLC ledger check" to
`.github/workflows/affected.yml` specifically to catch a branch that merges with no
`processed.log` row. It was written correctly, in the right file, and is still there. **It
did not hold, for two independent reasons, both present on this exact branch:**

1. It soft-warns and exits 0 whenever `AI_LAYER_DEPLOY_KEY` is unset, and that secret has
   never been provisioned in the roughly two weeks since the check was written — every PR
   since has received a warning nobody reads instead of a check that runs.
2. Even granting the secret, its ticket-detection is `grep -oE 'SCRUM-[0-9]+'` against the
   branch name only, case-sensitive. This branch is named `scrum-252` — lowercase, and not
   following the `feat/SCRUM-###-slug` convention either — so the check would print "Branch
   names no SCRUM-### ticket — nothing to check" and pass regardless of the secret.

A gate that can silently no-op on either a missing secret or an unenforced naming
convention is not a gate; it is a gate-shaped comment. **Structural fix:** R1 removes both
escape hatches — the missing secret becomes a hard failure instead of a warning, and ticket
detection falls back to the PR title (which does not depend on branch naming at all) before
giving up. Whoever applies R1 should also treat provisioning `AI_LAYER_DEPLOY_KEY` as the
actual blocking action — the code change alone does not close this without the secret.

### ESCALATION 2 — `stale-reference`, 3rd occurrence

The first two occurrences (SCRUM-900 ED-3: a SHA in `units.md` that no longer existed after
a rebase; SCRUM-926 ED-3: a schema field described in spec/units after it was dropped two
migrations later) were both about facts that **were true once and went stale** as the
codebase moved. This one is different in kind: `spec.md` §0 and §13 cite `CLAUDE.md` →
*Vehicle tracking (Samsara)* as an existing, consulted rule source, and no version of that
section has ever existed in this repository. Nothing checked the citation because nothing
checks citations — `tcg-elaborator` and `tcg-scrum` write prose references to other files,
and there is no mechanical verification that a referenced heading actually resolves.
**Structural fix:** the fabrication is fixed at the source by R6 (write the section the
citation already claims exists), but the general problem — nobody checks whether a
`File → Heading` citation resolves — recurs regardless of which specific citation broke this
time, and is worth a lint-shaped check (grep every `→ *Heading*` style citation in a
`spec.md` against the actual `##`/`###` headings of the file it names) the next time this
class fires a 4th time.

### ESCALATION 3 — `missing-requirement`, 3rd occurrence (with a 4th in the same reflection)

The first two occurrences (SCRUM-877 SD-1, SD-2) were each closed by writing the missing
sentence into `contexts/api.md` once the specific gap was found — which fixes that exact
gap and nothing of its shape. This reflection produced two more instances of the identical
pattern in one ticket: SD-3 (a second query silently missing a scope filter the first
query has) and SD-4 (a cost-control invariant that lived only as an unstated property of a
hook's parameter). Writing two more sentences (R5, R6) repeats the same non-generalizing fix
a third and fourth time. **Structural fix:** R5's field-by-field diff instruction is a step
toward a checklist rather than a fact to remember, but the durable fix is mechanical — a
shared query-scope builder for sibling reads over the same entity, so parity is structural
rather than remembered. That refactor is out of scope for a proposal (the reflector does not
apply changes), but it should be the next `missing-requirement` reflection's first question
if this pattern fires again.

- **New class added to the index:** yes — two. `duplicated-logic` (ED-2, ED-3: the same
  domain computation, mapping, or taxonomy is implemented independently in two or more
  places instead of extracted once, and the copies diverge in behaviour) and
  `unverified-stale` (SD-1: an `[UNVERIFIED]` vault source was built against without
  reverification and proved wrong or outdated when checked — distinct from
  `unverified-permanent`, which tracks irreversibility rather than accuracy). Both added to
  the class vocabulary table in `reflections/INDEX.md` in this same edit, per that file's
  own instructions.
- **Rows appended to `reflections/INDEX.md`:** yes — 9, one per defect in §1 and §2.

## 6. Kept as-is

- **`isJobPrimaryActionDisabled` already refused loadout actions on a cancelled job**
  (`isDasStageLoadoutLocked`'s `LOADOUT_LOCKED_DAS_STAGES` has always included `CANCELLED`,
  mirroring the API's own `LOCKED_STAGES`) — the Q5a defect (ED-2) was entirely a labelling,
  counting and filtering problem. Dylan could never have actually marked a cancelled job
  available. Worth recording because the first reading of the defect overstated it.
- **Decision notes correctly recorded as `status: reference`, not `verified`** — every one
  of the seven is explicit that a developer, not the named product owner, made the call.
  This is the right tag for that situation and should not be "fixed" to `verified` by a
  later pass just because nobody has objected yet.
- **The Yard Operations mount question (Q4) was decided against the written record, on
  purpose, and says so in those words** — `assets/tool-and-rigging.md` → *Story 5: Dylan's
  Yard Dashboard* has no map in its nine criteria, and the decision note is explicit that it
  overrides that record so Dylan can be shown the feature and veto it rather than discover
  it silently. This is the sanctioned use of a developer decision under uncertainty, not a
  defect.
