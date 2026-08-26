# Reflection — SCRUM-926 Craft code (epic: craft codes, rates, assignments, boom modifiers, resolver)

> Written to `.ai/aidlc/SCRUM-926/reflection.md` after PR #412 merged. Consumed by the
> reflector's own index and by whoever applies §4.

## 0. Context

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-926` (epic) — children `SCRUM-925` (U1), `SCRUM-934` (U2), `SCRUM-927` (U3), `SCRUM-935` (U4) |
| Spec | `.ai/aidlc/SCRUM-926/spec.md`, elaborated `2026-08-24`, revised `2026-08-25`, amended again `2026-08-25` post-merge with Q20–Q26 |
| Units | U1 (SCRUM-925) — shipped, matches spec. U2 (SCRUM-934) — shipped, **different system than specified** (Q20). U3 (SCRUM-927) — shipped, matches spec with one open self-contradiction (Q23). U4 (SCRUM-935) — shipped, inherits U2's divergence and one further undocumented contradiction (Q20 b/c) |
| Merged | PR #412, `feat/SCRUM-925-u1-craft-codes-rates` → `main`, merge commit `74e9ee3b`, base `9e3a8c97`, tip `61d0fd7d`, 2026-08-25 |
| Reflected on | `2026-08-26` |
| Reviewer(s) | `tcg-reflector` (this document), reading `tcg-analyst`'s post-merge sweep (Q20–Q21, 2026-08-25) and `tcg-scrum`'s post-merge sweep (Q22–Q26, 2026-08-25) as the analyst's verdict — no pre-merge analyst pass exists for this epic (see ED-4) |
| Open questions at build time | 0 blocking — Q1–Q19 were resolved, withdrawn or explicitly deferred to `SCRUM-920` by the `2026-08-25` revision, before any unit was built against them. **Q20–Q26 (7) did not exist until after merge** — they were found by review that ran only because someone asked for it after the fact, not because a gate required it |
| `[UNVERIFIED]` requirements built | 21 of 28 REQs `[UNVERIFIED]`, 4 more `[CONFLICT]` (REQ-01, REQ-02, REQ-07, REQ-20) — 25 of 28 built requirements carried less than `[VERIFIED]` confidence, 0 carried `[VERIFIED]`. None turned out factually *wrong or stale*. Two (REQ-11, REQ-06) turned out to describe a design the build did not follow — a materially worse finding than staleness, because tightening the vault's verification process would not have prevented either (see §3) |
| Unverified × irreversible | 2 — REQ-11 (Q20a: persisted migration + generator endpoint + wired-in Settings UI, all built against a scale REQ-11 says must never be persisted) and REQ-06 (Q21: fields added then dropped two migrations later). **Both found after merge by the analyst; neither was flagged before or during the build**, despite `tcg-executor.md` §2b existing specifically to require exactly that flag |

### A commit shipped in the same PR that this reflection cannot close

`61d0fd7d` ("feat(payroll): add payroll module with core functionality", ~18k lines: payroll
periods/runs/weeks/premiums) merged in the same PR with **no ticket key, no spec, no unit,
no reflection possible**. `processed.log` now carries a flagged, unbackfillable row for it
(*"no ticket, no spec, no unit; never ran the loop... needs its own ticket, not a
retrofit"*). It plausibly implements Jira epic `SCRUM-920`'s children (`SCRUM-921/922/923`,
all still "To Do") but cites none of them anywhere in its 12 commits.

Three of the four pay-correctness bugs fixed on 2026-08-26 (`PAYROLL_ISSUES.md`) —
`derivePayrollGroup` misclassification, the union-only military premium, and the unsourced
`FOUR_MAN` premium — live in this commit's code, not in SCRUM-926's units. They cannot
become SD/ED rows here because no ticket owns them. They **are** cited below (§3, R6)
because they are the clearest evidence for the pattern this reflection's rule proposals are
built to stop, and because their total absence of process — no spec, no units, no analyst,
no reflection, caught only by the same accident of a post-merge sweep — is the sharpest
version of ED-4's finding, just one order of magnitude less accountable since no ticket
folder exists to even backfill. **This needs its own elaboration pass against `SCRUM-920`'s
children, not a retrofit onto this ticket.**

## 1. Spec defects — what the spec missed

### SD-1 — REQ-08 and `SCRUM-935`'s current ticket text specify opposite resolver behaviour, and the spec was never re-read after the ticket changed

- **Where:** REQ-08 (*Notes for the executor*, final paragraph) vs. `SCRUM-935`'s description as updated `2026-08-25T11:15` (Q24)
- **What the executor needed to know:** whether `resolveEmployeeCraft`'s off-list
  `secondaryCraftId` must be rejected by the resolver itself, or left to the labor-entry
  ticket
- **What the spec said:** REQ-08's note says explicitly *"do not implement... `SCRUM-935`
  specifies the resolver's behaviour and does not include it... `NOT SPECIFIED`"*, and
  `units.md` U4 lists it under *"Deliberately not in this unit."* The ticket, read again
  after it was edited, says the resolver **must** reject it and lists a required test for
  exactly that case.
- **What was decided instead, and by whom:** the executor built the ticket's (newer) version
  — `BLOCKED / SECONDARY_NOT_ASSIGNED` — which is defensible, but nothing recorded that the
  spec's explicit instruction was being overridden by a source the spec claims to be quoting
  verbatim.
- **Was the decision right:** unknown — it satisfies the ticket as it now reads, but REQ-08's
  stated reason for keeping the check out (the labor-entry ticket needs to own it) is
  unaffected by the ticket text changing, and nobody has weighed the two against each other.
- **Cost:** REQ-08's sign-off blocked, U4's acceptance blocked, and the labor-entry ticket now
  has an ambiguous boundary with this one.
- **Class:** `doc-conflict` — two written, loaded sources (`spec.md` and the live Jira ticket
  it cites) say opposite things, and the spec was authored against a snapshot of the ticket
  that has since moved.
- **Fix:** see R1.

### SD-2 — REQ-07's own acceptance line contradicts its own executor note

- **Where:** REQ-07 acceptance criteria vs. REQ-07 executor note (b), same file, same
  requirement block (Q23)
- **What the executor needed to know:** whether `PATCH /employee/:code` on an employee with
  no PRIMARY craft must be rejected
- **What the spec said:** the acceptance line reads *"creating an employee without a primary
  craft is rejected, **and so is updating one that has none**"*; two paragraphs later, the
  same requirement's executor note says such an employee *"continues to load, **save** and
  appear in lists"* — the permissive reading, stated as fact.
- **What was decided instead, and by whom:** the executor (commit `1c9b9455`, message *"update
  reassigns when one is sent and leaves it alone otherwise"*) built the permissive reading.
  No requirement, ticket comment or decision note is cited for the choice beyond the commit
  message.
- **Was the decision right:** unknown, but it is the reversible direction (Q23's own
  workaround note: tightening later is cheap, loosening later breaks nothing) — the one place
  in this whole review where the executor's unstated choice happens to be the safe one by
  construction, not by verification.
- **Cost:** REQ-07's sign-off blocked; whether the missing-primary report endpoint is a
  work-down tool or a hard gate is now undecided in production.
- **Class:** `doc-conflict` — same document, two passages, opposite normative statements. (No
  existing class distinguishes a within-document contradiction from a cross-document one;
  I did not add a new one for this — see the note under R1.)
- **Fix:** see R1.

## 2. Executor defects — what was built against the spec

### ED-1 — The boom-adder resolver silently contradicts a `[VERIFIED]` decision already in production

- **Where:** `apps/api/src/service/craft-rate-resolver/craft-rate-resolver.service.ts`
  `resolveBoomAdder` (lines 145–165); `apps/api/src/service/craft-modifiers/craft-modifiers.repository.ts`
  `findForBoomLength`
- **Spec said:** REQ-18 — a boom length with no active scale returns **Blocked**, and its own
  acceptance note calls that *"the normal path, not an edge case… intended and must not be
  'fixed.'"* Separately, `.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-boom-pay-rate-table.md`
  §2 — `status: verified`, decided by name on `SCRUM-877` comment `23099` — states plainly
  that an Oiler above 380 ft is paid the 361–380 ft bracket's rate, not $0. That exact
  fallback is already implemented correctly and running in production at
  `packages/shared/src/constants/craft-modifiers.ts` (`matchBracket`, `rateForBracket`),
  consumed today by `ticket-labor-entries` and mobile's `LaborBody.tsx`.
- **Built:** a boom length in a genuine gap between configured brackets, or a bracket with an
  empty cell for one role, returns **`null` — no adder** on this path, and an unconfigured
  tenant's empty table returns **`RESOLVED` with a null adder** rather than `BLOCKED`. Same
  tenant, same boom length: $12.00/h on the ticket-labor path, $0 on the resolver path, for
  the same 410 ft operator.
- **Caught by:** production, for roughly 24 hours, until the post-merge review (`tcg-scrum`,
  2026-08-25/26) found it. Fixed 2026-08-26.
- **Class:** `contradicted-source` (new — see below). Not `unverified-permanent`: the source
  here was not merely unverified, it was `[VERIFIED]`, findable by name, and already
  correctly implemented in a sibling file in the same repository. The gap was not that the
  source didn't exist — it was that nobody checked for one, and nobody compared the new
  logic against the existing implementation of the identical rule sitting a few directories
  away.
- **Fix:** see R6.

### ED-2 — U2 shipped an unauthorized redesign of the modifier scale, expensive to reverse, never flagged

- **Where:** `apps/api/prisma/schema.prisma` lines 2354–2380 (`CraftModifier`, as built);
  migration `20260825060000_craft_modifiers_and_rate_windows`;
  `apps/api/src/usecase/craft-modifiers/craft-modifiers.service.ts` `generate()` (lines
  109–176)
- **Spec said:** REQ-11/REQ-12/REQ-13/REQ-14/REQ-16 — one `CraftModifierScale` row per union
  code, tiers computed at request time by a pure function, no tier rows ever persisted, codes
  and labels derived and never stored. `units.md` U2's own outcome line: *"no tier row
  persisted anywhere and no seed involved."*
- **Built:** `CraftModifier`, a different model — one persisted row per bracket, no
  `unionCodeId` at all, plus a generator endpoint that writes N rows in a loop. No commit
  message, code comment, `spec.md` line, or `.ai/vault/decisions/` note references
  `SCRUM-934`, REQ-11, REQ-12, REQ-13 or REQ-16, or explains the substitution — confirmed by
  `git log -p origin/main..HEAD | grep -c CraftModifierScale` → `0`.
- **Caught by:** post-merge review (`tcg-analyst`, 2026-08-25), roughly 24 hours after merge.
  Still open (Q20) — this is the one entry the PR-review that produced Q20–Q26 says to read
  first.
- **Class:** `unverified-permanent` — REQ-11 was `[UNVERIFIED]`, and what got built is exactly
  the shape `tcg-executor.md` §2b names as the thing to flag before merging: a migration, a
  response shape, and (uniquely bad here) a UI wired to depend on it, none of it flagged.
- **Fix:** see R2.

### ED-3 — A required schema field was built, then dropped two migrations later, with spec and units left describing the field that no longer exists

- **Where:** `apps/api/prisma/schema.prisma` (`CraftCode` — no `startDate`/`endDate`);
  migration `20260825020000_add_craft_codes_rates_and_union_kind` (adds them); migration
  `20260825060000_craft_modifiers_and_rate_windows`, commit `ce597540` (drops them, same
  branch); `craft-codes.service.spec.ts` (asserts their absence)
- **Spec said:** REQ-06 — a craft code "carries a start date and an optional end date."
  `units.md` U1's slice-contents table lists both fields, each tagged `// REQ-06`, and U1's
  own written demo line says `POST /api/v1/craft-codes` with `{ ..., startDate }` → `201`.
- **Built:** the fields were added, then dropped on the same branch by a later, reasoned
  commit (*"Craft codes no longer carry a validity window… Two dates that had to be kept in
  step with each other were one pair too many"*) that cites no requirement, ticket comment,
  or decision note, and touches no file under `.ai/` (`git diff origin/main...branch --stat
  -- .ai/` is empty). U1's own demo line, replayed today, now 400s instead of 201s because
  `ValidationPipe` runs `forbidNonWhitelisted: true`.
- **Caught by:** post-merge review (`tcg-analyst`, 2026-08-25).
- **Class:** `stale-reference` — `spec.md` REQ-06 and `units.md` U1 are AI-layer facts that no
  longer resolve against the code they describe, in the same repo, from the same branch.
- **Fix:** see R2.

### ED-4 — The AI-DLC trail for the entire epic (5 tickets) stayed off the vault overlay through merge, and neither `commit` nor `close-ticket` ran

- **Where:** `.ai/aidlc/processed.log` — the rows for `SCRUM-926/925/934/927/935` are all
  marked *"row backfilled 2026-08-26… no ledger line existed at merge"*; vault overlay commit
  `94e2e2f`, where `.ai/aidlc/SCRUM-926/{intent,spec,units}.md` were merged to overlay
  **main** *during the PR review*, not before; no `.ai/aidlc/reflections/SCRUM-926/` entry
  existed before this document.
- **Spec said (the convention):** `GUIDE.md` §"Every path leaves one line" — *"The `commit`
  skill appends one line to `.ai/aidlc/processed.log` at branch creation, on every path… It
  is the one artifact every ticket produces regardless of path."* `close-ticket` step 6:
  pushing the overlay is what turns the reflection, decisions and index rows into memory
  anyone but the original session can read; §"How much of this runs" lists steps 4–6 as
  having "no exemption."
- **Built (what happened):** none of it ran, for five tickets, until a human or agent forced
  a review after the PR had already merged. The `.github/workflows/affected.yml` gate that
  actually blocks a merge checks lint, build and test only — it has no awareness of
  `.ai/aidlc/` state, so a green CI run was indistinguishable from "the loop ran."
- **Caught by:** the same post-merge review that produced Q20–Q26 — not by any pre-merge
  check.
- **Class:** `gate-illusion` — the PR's gates (lint, build, test, human review, merge) all
  passed while the documented convention that every ticket leaves a ledger line and pushes
  its trail to the overlay was violated for an entire epic.
- **Fix:** this is a **third occurrence** of this class in the index — see §4/§5 escalation
  (R3, R4).

### ED-5 — ~2,100 lines of web UI were built against four ticket sources and the spec that all say backend-only

- **Where:** `apps/web/src/features/craft-codes/` (13 files: Settings → Craft Codes, Settings
  → Craft Code Modifiers), `apps/web/src/features/employees/components/create/sections/employment-details-fields.tsx`
  (a second, separately required "Payroll craft" field beside the legacy Craft field) — 51
  files total (Q22)
- **Spec said:** `SCRUM-925`/`SCRUM-927` list *"web/mobile UI"* under **Not in scope**;
  `SCRUM-934` says *"Backend only. No web/mobile in this ticket"*; `SCRUM-935` says *"Backend
  only"*; `spec.md` §5/§6 say `N/A — backend only`; §13 says that is *"by ticket, not by
  omission."*
- **Built:** the full Settings surface, an editable-and-generative Modifiers tab (where the
  one written source that touches this at all, `SCRUM-934` comment `23677`, says
  **read-only**), an employee-detail card, and the second required employee-form field —
  which is the one with a real production consequence, since it sits next to the legacy Craft
  field with no UX decision recorded anywhere, and `SCRUM-926` comment `23678` itself flagged
  that two-field transition state as *"something to know before merge."*
- **Caught by:** post-merge review (`tcg-scrum`, 2026-08-25). The code builds and works; the
  question is scope, not defects in the code itself.
- **Class:** `gate-illusion` — build and lint passed, and a PR merged, while an explicit,
  four-times-repeated, unambiguous "backend only" constraint was violated at ~2,100-line
  scale with no PR description, commit message, or decision note acknowledging the scope
  change.
- **Fix:** see R5.

## 3. Source and vault findings

- **Sources that turned out to be wrong or stale:** **none** in this ticket's own build. The
  more concerning finding is the reverse: `decisions/2026-08-21-…boom-pay-rate-table.md` §2
  is `[VERIFIED]`, specific, and correct — and ED-1 contradicted it anyway. Tightening how
  much the vault verifies would not have prevented ED-1; the source was already as verified
  as this vault gets. The predictive question §3 usually asks — does `[UNVERIFIED]` predict
  wrongness — is not answered by this ticket in either direction, because the two
  `[UNVERIFIED]`-and-irreversible cases found (REQ-11/Q20a, REQ-06/Q21) were not the source
  being *wrong*; they were the source being right and unbuilt-to, silently.
- **Unverified × irreversible, flagged before or during the build:** neither. Both (REQ-11,
  REQ-06) were found only by the post-merge analyst pass, despite `tcg-executor.md` §2b and
  the decomposer's own Risk-block convention existing specifically to catch this before
  merge. `units.md` U2's own Risk section pre-emptively names the exact tension REQ-11 later
  broke (*"`PAY-008` still requires effective dating for configuration generally… do not
  treat its absence as settled"*) — the document already contained the warning; nobody read
  it against what got built.
- **Conflicts that surfaced only during build:** Q20(a)'s storage-model fork and Q21's
  validity-window drop both surfaced only in the post-merge review, not during the build
  itself, even though both are visible from `units.md` alone without reading any code.
- **Questions answered by a named human during the build, and whether they were written
  down:** **no, and this is current, not historical.** `spec.md` §12's own preamble states it
  outright: *"three of the resolutions are working decisions... that the people who own the
  underlying sources have not confirmed... and no decision note exists in
  `.ai/vault/decisions/` for any of it."* Specifically: Q1's non-union rate model (confirmed
  against `PAY-012`), Q3's on-top boom-adder composition, and Q18's union-scope reading of the
  `2026-08-20` craft-locked-rate-override decision were all settled by Syed Haris in a
  `2026-08-24` planning session and never promoted to `vault/decisions/`. `close-ticket` step
  3 names exactly this path (*"named human answered → `tcg-scrum` → `vault/decisions/`, now"*)
  and it has not run for any of the three.
- **`gaps.md` entries this ticket should close:** none closed. Two remain open and adjacent:
  `payroll/gaps.md:390` (`PAY-012`, non-union hourly rate — Q1 scoped its rate-effective-date
  half out of this epic explicitly, "it did not make it untrue" per U4's own Risk note) and
  the `PAY-067` ADP-export rows (`status: conflicted`, no `LB` earning code anywhere in the
  vault) that REQ-20's boom-adder composition answer will need once `SCRUM-920` picks it up.
  Neither should be closed by this ticket; both should be cited by whichever ticket resolves
  Q3.
- **`gaps.md` entries this ticket opened:** none in a module `gaps.md` — everything above
  landed in `spec.md` §12 (Q20–Q26), which is the correct register for a ticket-scoped
  question. This reflection has no write access to `payroll/gaps.md` and does not attempt to
  file the sibling-commit finding (§0) there; that needs a human or `tcg-scrum` to open it
  against `SCRUM-920`.
- **Undefined terms hit:** `craft group` (spec §10 / intent §10) — still `NOT ON TICKET`,
  still undefined, not touched by this build.

## 4. Rule changes proposed

| # | File | Section | Exact change | Prevents | Accepted |
| --- | --- | --- | --- | --- | --- |
| R1 | `.ai/aidlc/agents/inception/tcg-elaborator.md` | wherever REQ acceptance criteria are authored | Add: "Before sign-off, re-read each REQ's acceptance line against its own executor notes and against the live ticket it cites. A spec that quotes a ticket verbatim must be re-diffed against that ticket's current text before the spec is marked ready for decomposition — quoting a snapshot is not quoting the source." | SD-1, SD-2 |
| R2 | `.ai/claude/contexts/prisma.md` | §Migrations | Add, after the existing sentence: "A migration that drops, renames, or otherwise reverses a field already recorded in an open ticket's `spec.md` REQ or `units.md` slice-contents table must update that REQ/unit in the same commit. Reverting a documented field without updating the document that documents it is an incomplete change, not a pending one — the same standard this file already holds a model edit without a migration to." | ED-2, ED-3 |
| R3 | `.github/workflows/affected.yml` | new step, before `Affected build` | Add a required step that fails the PR when the branch name matches `(feat\|fix\|task)/SCRUM-\d+.*` and `.ai/aidlc/processed.log` (read from the vault overlay checkout) has no row for that ticket number — mirroring the check already described in prose at `GUIDE.md` §"Every path leaves one line" but never enforced by CI. | ED-4 (escalation — see §5) |
| R4 | `.ai/claude/skills/close-ticket/SKILL.md` | §6 hand-back | Add: "Before printing the hand-back, grep `.ai/aidlc/reflections/INDEX.md` for `Status: proposed` rows older than the immediately preceding ticket's close, and list their count and classes in the hand-back even when this ticket did not cause them. A proposal queue that only close-ticket ever reads is a queue nobody reads." | ED-4 (escalation — see §5) |
| R5 | `.ai/claude/contexts/web.md` | new section, "Scope guard" | Add a pre-push check description: "If `.ai/aidlc/SCRUM-###/spec.md` §5 and §6 both read `N/A — backend only` for the ticket a branch is named for, and the diff touches `apps/web/` or `apps/mobile/`, the push must fail with an explicit override required (`SCOPE_OVERRIDE=1`), not just a warning." | ED-5 |
| R6 | `.ai/aidlc/agents/construction/tcg-executor.md` | §3 "Existing code is not intent, and not permission" | Add: "Before writing new pricing, rate, or premium logic of any kind, `grep -rn` `.ai/vault/decisions/` for the entity and rule name, and grep the repo for any existing implementation of the same rule (a sibling `packages/shared` constant, a repository method with a similar name) before deciding how a fallback or edge case behaves. Matching behaviour already shipped elsewhere for the same rule is a source; failing to check for one is not a judgement call." | ED-1, and the three pay-correctness bugs in the untracked sibling commit (§0) — same failure shape, no ticket to own an index row for them |

- **New class added:** `contradicted-source` — *"Built behaviour contradicts a specific,
  findable, already-`[VERIFIED]` source (a decision note, a rule doc, or an existing sibling
  implementation of the same rule) that was not consulted before writing new code for the
  same rule."* Distinct from `unverified-permanent`: that class is about an `[UNVERIFIED]`
  source made expensive to reverse; this one is about a source that was *already verified*
  and simply not checked. Four known instances exist as of this reflection — ED-1 here, plus
  the three uncredited pay-correctness bugs in the sibling commit (military premium,
  `derivePayrollGroup`, the unsourced `FOUR_MAN` premium) — none of which have an index row
  because none has a ticket, which is itself the strongest argument for R6 being mechanical
  rather than a reminder.
- **Rejected proposals, and why:** a blanket "no `apps/web` changes on any branch" pre-push
  rule was considered for R5 and rejected — it would false-positive on genuinely shared
  component work incidental to a backend ticket. Scoping the check to the ticket's own
  declared backend-only status keeps it targeted. A proposal to have the reflector itself
  file the sibling-commit finding into `payroll/gaps.md` was considered and rejected — the
  reflector has no write access there by design (see tool-access table), and the finding
  belongs to a ticket that does not exist yet, not to this one's gap register.

## 5. Recurrence check

```bash
grep -i 'gate-illusion' .ai/aidlc/reflections/INDEX.md    # 2 prior rows (SCRUM-900 ED-1, ED-2)
grep -i 'stale-reference' .ai/aidlc/reflections/INDEX.md  # 1 prior row (SCRUM-900 ED-3)
grep -i 'unverified-permanent' .ai/aidlc/reflections/INDEX.md  # 0 prior rows
grep -i 'doc-conflict' .ai/aidlc/reflections/INDEX.md     # 0 prior rows
grep -i 'contradicted-source' .ai/aidlc/reflections/INDEX.md  # 0 — new class
```

| Defect | Class | Prior rows | Occurrence | Why the previous fix did not hold |
| --- | --- | --- | --- | --- |
| ED-4 | gate-illusion | SCRUM-900 ED-1, ED-2 | **3rd** | Neither prior proposal (`prisma.md` §Conventions, `tcg-executor.md` §Output shape) was ever applied — both still `Status: proposed`. Not "written and ignored": never enacted. The queue itself has no mechanism forcing a human to clear it, so a proposal sitting in `INDEX.md` is currently indistinguishable in effect from no proposal at all. |
| ED-5 | gate-illusion | SCRUM-900 ED-1, ED-2 (+ ED-4 above, same reflection) | **3rd/4th** | Same root cause as ED-4 — no mechanical check exists for *any* documented convention at merge time, so a green PR carries no information about whether conventions held. This occurrence is a different convention ("backend only") than ED-4's ("push the trail"), which is itself evidence the gap is structural, not specific to one rule. |
| ED-2 | unverified-permanent | none | 1st | N/A — first occurrence |
| ED-3 | stale-reference | SCRUM-900 ED-3 | 2nd | SCRUM-900 ED-3's proposal (`templates/units.md` — Status column fill rule) targeted a different sub-case (a stale build SHA) and is also still `proposed`, unapplied. Same underlying cause as the escalation above: proposed, not applied. |
| SD-1, SD-2 | doc-conflict | none | 1st | N/A — first occurrence |
| ED-1 | contradicted-source | none (new class) | 1st | N/A — new class, first occurrence |

- **Escalate:** **Yes — `gate-illusion` is at its third occurrence** (and arguably its fourth,
  counting ED-5 separately within this same reflection). This is not a reminder problem, and
  writing a fourth context-file sentence asking people to remember would repeat the exact
  failure it is diagnosing. The structural fix is R3 + R4: a CI check that fails a PR when the
  AI-DLC ledger has no row for the branch's ticket (R3), and a close-ticket hand-back that
  surfaces the *count* of unapplied proposals at every single close so the queue cannot go
  silently stale the way it did for both of SCRUM-900's gate-illusion proposals (R4). The
  reason the first two fixes did not hold is not that they were wrong or unread — it is that
  "propose, and a human applies later" has no forcing function once the ticket that produced
  the proposal is closed and everyone's attention has moved on. R3 does not depend on anyone
  reading a context file; it fails the build.
- **New class added to the index?** Yes — `contradicted-source`, defined above, added to
  `INDEX.md`'s class table in the same edit as the index rows below.
- **Rows appended to `reflections/INDEX.md`:** yes — 7 (SD-1, SD-2, ED-1 through ED-5).

## 6. Kept as-is

- **The non-union base-rate model (Q1: per-person `Employee.hourlyRate`, not a craft rate)** —
  correct as built. Confirmed against `PAY-012` and Brian Petros's written "very important"
  confirmation, and backed by 21,348 legacy rows. The only gap is that the confirmation was
  never written to `vault/decisions/` (§3) — the model itself is not in question.
- **`REQ-19`'s absolute prohibition on reading `Employee.payRateOT` / `Employee.payRateDB`** —
  correctly honored; `units.md` U4's acceptance line names the exact grep that proves it, and
  it was run.
- **Q25(a) and Q25(b)** — rejecting a rate row on a non-union craft, and the `CraftCodeRate.source`
  provenance column — both unsourced, both flagged by `tcg-scrum`, and both explicitly judged
  in the spec's own words as *"cheap to reverse in either direction"* with *"nothing… blocked
  either way."* These are exactly the class of silent, reasonable, low-stakes call the
  executor is supposed to be free to make without stopping the unit. Not defects; do not
  re-raise them as if they were.
- **Q26's ungated `GET /craft-codes` list route** — matches the named, existing pick-list
  pattern on the sibling reference-code controllers exactly (`employee-craft-codes.controller.ts`).
  The two genuinely unprecedented reads (`GET /craft-codes/:id`, `GET /craft-modifiers`) were
  real gaps, but they are already fixed (`PAYROLL_ISSUES.md`, 2026-08-26) and do not need a
  fresh index row here — Q26 stays open only for the roles/permissions sign-off paperwork,
  not for a code change.
