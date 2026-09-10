---
title: The business day starts at 00:00 in the tenant's own timezone — decision
source: decision/Syed Haris
decided: 2026-09-09
decided_by: >-
  Syed Haris (syedharis14@gmail.com) — developer/owner directing the `SCRUM-TZ` /
  `fix/timezone-business-day` work; stated directly in a working session on 2026-09-09, as
  a follow-on to `2026-09-09-business-timezone-is-a-tenant-property.md`. He is **not** the
  client-side product owner, and the owner this question is nominated to has not spoken to
  it: `.ai/aidlc/SCRUM-TZ/spec.md` §12 Q8 names **Corrina Bustos** (TCG Payroll Manager) —
  the named human on `2026-09-04-cross-midnight-day-type-and-holiday-minimum.md` — and
  `../assets/gaps.md` → *The fleet day* names **Brian Petros**, with Corrina where it
  touches payroll. `status: reference` rather than `verified` for that reason: binding on
  implementation now, open to being overruled by TCG. Same basis and same precedent chain as
  `2026-09-09-business-timezone-is-a-tenant-property.md`,
  `2026-09-08-artifact-due-date-seeded-from-first-job-day.md` and
  `2026-09-01-subsistence-not-a-craft-attribute.md`. A developer's confirmation is weaker
  than a payroll owner's, and this is a payroll question — **Corrina Bustos should still
  ratify it**; see *What is weak about this attribution*.
status: reference
conflicts_with: []
resolves: [SCRUM-TZ/spec.md#q8--when-does-the-business-day-start]
jira: []
tags: [module/payroll, module/all, kind/decision, time-tracking, payroll-rules, overtime, requirements]
---

# The business day starts at midnight, local to the tenant

Settles **when** the business day begins. It is the companion to
[`2026-09-09-business-timezone-is-a-tenant-property.md`](2026-09-09-business-timezone-is-a-tenant-property.md),
which settled **whose** zone that is and explicitly did not settle this. Together they are a
complete day boundary; separately neither is one. It is the answer to `SCRUM-TZ` REQ-09 and
to §12 **Q8** of [`.ai/aidlc/SCRUM-TZ/spec.md`](../../aidlc/SCRUM-TZ/spec.md).

## Decision

**The business day starts at 00:00 local — midnight in the tenant's own timezone, not a
global instant.**

Syed Haris, verbatim:

> at 00:00 local, 12 am pakistan is different then 12 am us

Two clauses, and the second is the whole point of the sentence:

1. **The boundary is midnight.** There is no `WorkdayStartTime` offset. The business day
   runs `[00:00, 24:00)` on the wall clock.
2. **"Midnight" is a wall-clock time in a zone, never an instant.** It is resolved against
   the tenant's zone at the moment it is asked, so two tenants in two zones start their days
   at two different UTC instants, and the same tenant's midnight moves by an hour across a
   DST transition. Midnight UTC is not the business day boundary for anybody.

Clause 2 is what makes clause 1 safe. "Starts at midnight" is exactly the statement that has
been silently true and silently wrong in this codebase — true as a wall-clock rule, wrong
every time it was computed as a UTC instant. Recording only clause 1 would re-authorise the
defect `SCRUM-TZ` exists to end.

## Why

### 1. It fills a hole the vault names in its own dependency matrix

This is not a formality: the vault says out loud that this concept is missing.
[`../payroll/payroll-rule-dependency-matrix.md`](../payroll/payroll-rule-dependency-matrix.md)
(`status: unverified`) §4 — *Section A, foundational time and calculation rules* — carries an
**ADD**:

> **Workday definition (ADD).** Every employee/rule set must carry an explicit
> **`WorkdayStartTime`** defining the fixed 24-hour workday. *"Do not assume that a shift
> start, payroll date, or midnight automatically defines the legal workday."* California
> requires a consistently recurring 24-hour workday.

and row 14 of the same file's *Collisions* table repeats it as a genuinely new requirement:

> An explicit `WorkdayStartTime` per employee/rule set; the workweek is a fixed 168-hour
> window **including its exact start time** … **No workday-start concept exists anywhere in
> the vault** … Genuinely new requirement, and load-bearing. **Every daily-OT rule in the
> register presumes a workday boundary nobody has defined.**

That is the hole this note closes. Until now every daily-overtime, meal-period, rest-period
and continuous-work rule in the register rested on a boundary no document stated.

**California's requirement is what the matrix was worried about, and midnight satisfies it.**
The legal requirement is that the 24-hour workday be *consistently recurring* and
*designated* — not that it start at any particular hour. Midnight is consistently recurring
by construction. The defect the matrix warns against is an *undeclared* boundary, and the
cure is declaring one, which is what this note does. What it does **not** do is make the
declaration audit-proof: a written statement from TCG's payroll owner is worth more in a wage
claim than a decision note signed by a developer, which is the substance of the weakness
recorded below.

### 2. It ratifies what the code already does — it does not change behaviour

Say this plainly, because it changes what this note authorises. **No shipped behaviour
changes.** [`packages/shared/src/utils/business-time.ts`](../../../packages/shared/src/utils/business-time.ts)
already implements midnight unconditionally, with no offset anywhere:

- `startOfBusinessDay(isoDate, timeZone)` is `zonedWallClockToInstant(isoDate, 0, timeZone)` —
  the literal `0` is minutes-into-the-day, i.e. midnight, and there is no parameter to change
  it.
- `minutesFromBusinessMidnight(...)` names the same assumption in its own signature, and is
  documented as *"the input to any 06:00–17:00 window test"* — Local 12's shift window is
  measured from it.

So this decision **ratifies**, it does not migrate. The value of ratifying is that until
today the code implemented an answer to a question nobody had asked: `SCRUM-TZ` REQ-09
recorded it as *"the code currently implements an answer (`00:00` local) that only the
day-type decision supports, for a question that decision did not ask."* After this note the
code and the record agree, and `SCRUM-TZ` REQ-09 becomes a no-op rather than a rewrite.

REQ-09's own ripple list is the measure of what was at stake in the other answer:
`startOfBusinessDay`, `endOfBusinessDayExclusive`, `businessDayRange`, `businessToday` and
every daily-OT and rest-period computation in the engine — *"potentially larger than the
timezone change itself."* Midnight takes all of that out of scope.

### 3. It is consistent with the one `verified` decision anywhere near it

[`2026-09-04-cross-midnight-day-type-and-holiday-minimum.md`](2026-09-04-cross-midnight-day-type-and-holiday-minimum.md)
(`status: verified`, **Corrina Bustos**, TCG Payroll Manager, in writing on Teams) put the
cross-midnight **day-type** change at **00:00 by calendar day** — the active
`cfg.CrossMidnightDayTypePolicy = CalendarDay`, with the higher rate governing after the
boundary.

That decision settles *day type*, not *the workday*, and it did not ask this question. But it
is the closest the record comes, it was made by the person Q8 nominates, and it points the
same way. **A workday boundary anywhere other than midnight would have put the day-type
boundary and the workday boundary in two different places** — hours after 00:00 pricing at
Sunday's rate while still counting against Saturday's 8-hour OT threshold. This decision
keeps them on the same line, which is the cheaper and more defensible arrangement and is
almost certainly what Corrina assumed on 2026-09-04.

### 4. It is what finally says when Saturday begins

[`../payroll/rules/PAY-001-saturday-friday-payroll-week.md`](../payroll/rules/PAY-001-saturday-friday-payroll-week.md)
(`status: settled`, quadruple-sourced) fixes the payroll week as **Saturday–Friday**. It
never says when Saturday starts, and a 168-hour window is not defined by its day names alone.

PAY-001 + this note + the tenant-zone decision = a fully specified payroll week: **it opens
at 00:00 on Saturday in the tenant's timezone and closes at 00:00 on the following
Saturday.** Each of the three is necessary; none of them is sufficient. That composition is
the practical output of this note.

## What is weak about this attribution

Stated plainly, because the whole value of a decision note is that the next reader can judge
its weight.

- **The decider of record is Syed Haris**, in session, 2026-09-09 — a real, named, datable
  human, and the basis on which this note is written. He directs the work and the decision
  binds the build.
- **He is a developer, not TCG's payroll owner, and this is a payroll question.** `SCRUM-TZ`
  §12 Q8 nominates **Corrina Bustos**, and she has not spoken to it. A developer's
  confirmation of a payroll boundary is materially weaker than the payroll manager's,
  particularly for a rule whose failure mode is a wage-and-hour exposure rather than a bug.
  **Corrina should still ratify this**, and if she does, this note should be re-issued or
  amended with her as `decided_by` and `status:` reconsidered as `verified`.
- **Unlike the grain decision, this one had no TPM approval claimed** — it was answered
  directly in session. Nothing is being relayed second-hand here, which is a small point in
  its favour; it simply has no more authority behind it than the one person named.
- Ratifying existing behaviour lowers the cost of being wrong but does not lower the
  probability. The code has always done this; nobody had checked whether it should.

## What this does NOT settle

- **Whether the boundary must be configurable at all.** The matrix asks for
  `WorkdayStartTime` **per employee/rule set**; this note answers with **one uniform value
  for everybody**. That is a narrower answer than the matrix's ADD requests. It is adequate
  while every employee shares a boundary, and it stops being adequate the moment TCG needs to
  designate a different workday for a group — a night-shift crew, or a second union
  agreement. Treat this as **expired, not overruled**, if that day comes: reopen the
  configurability question, do not argue from this precedent.
- **Whether the workweek's start instant is thereby settled for every purpose.** It settles
  the *day*; PAY-001 settles the *week's day names*; nothing here speaks to retroactive
  re-derivation of historical weeks, which `SCRUM-TZ` §11 puts out of scope.
- **The fleet day.** [`../assets/gaps.md`](../assets/gaps.md) → *The fleet day* stays
  `Status: open` — see *Effect on the vault* for why this note narrows it without closing it.
- **What the user sees, and in what format.** Display is governed by
  [`2026-09-09-tenant-timezone-configuration.md`](2026-09-09-tenant-timezone-configuration.md)
  item 5 for *zone*, and by nothing at all for 12h/24h *format* —
  [`../admin/gaps.md`](../admin/gaps.md) → *Time display* remains open on that.
- **Any DST-transition arithmetic.** Midnight-in-a-zone is well defined across a transition
  and `business-time.ts` resolves it through `Intl`; but a 23- or 25-hour business day is a
  real consequence of clause 2 and no rule states how daily-OT thresholds behave on those two
  days a year. Not asked, not answered, and not currently on any register.

## Effect on the vault

- **No vault file body was edited by this note, and no frontmatter was flipped by it.** This
  was never a conflict set — the vault contained **no workday-start concept at all**, which
  is the defect the dependency matrix records. There is therefore no winner to mark
  `verified` and no loser to mark `superseded`, and the four-step closure in `README.md` →
  *How a gap gets closed* does not apply.
  [`../payroll/payroll-rule-dependency-matrix.md`](../payroll/payroll-rule-dependency-matrix.md),
  [`../payroll/rules/PAY-001-saturday-friday-payroll-week.md`](../payroll/rules/PAY-001-saturday-friday-payroll-week.md)
  and
  [`2026-09-04-cross-midnight-day-type-and-holiday-minimum.md`](2026-09-04-cross-midnight-day-type-and-holiday-minimum.md)
  all keep their existing `status:` and gain no `superseded_by:`. The matrix's row-14 ADD is
  **answered by this note, not retracted** — its `status: unverified` is accurate and unchanged.
- **[`../assets/gaps.md`](../assets/gaps.md) → *The fleet day* stays `Status: open`, and an
  update line was appended recording what this narrows.** Judgement, stated because it is a
  close call: that entry asks **two** questions. *"In whose timezone does a fleet day start?"*
  is now answered for the tenant's business day — this note plus the grain decision give
  option (c), the tenant, at 00:00. But its second line — *"must the fleet day agree with the
  job/payroll day, given both count hours against the same machine and crew?"* — is a
  **three-way agreement question** between the fleet day, the job day and the payroll day, and
  nothing here says the fleet day must adopt the business day at all. **It currently does not,
  and that is live on `main`, not hypothetical** — see the finding below. Closing the entry would
  assert an alignment nobody decided, so it stays open with the answered half recorded.
- **Finding, recorded because it contradicts the grain decision on its face: there is a second,
  process-wide, env-var-configured business timezone shipped on `main` today.** The fleet day is
  not a future question. `Fetaure/samsara-integration` **has merged**, and on `main`:
  `apps/api/src/usecase/vehicle-tracking/fleet-day.ts`:29 resolves
  `process.env.FLEET_TIMEZONE || DEFAULT_FLEET_TIMEZONE` — `||` deliberately, per its own comment,
  because *"a blank value from a secrets store or an empty Docker ARG is as good as absent, and an
  empty zone string throws inside dayjs"*; `apps/api/src/config/env.validation.ts`:79 supplies the
  default via `Joi.string().optional().empty('').default(DEFAULT_FLEET_TIMEZONE)`; and
  `packages/shared/src/constants/vehicle-tracking.ts`:27 sets that default to
  `America/Los_Angeles`. Web carries **its own second copy** —
  `apps/web/src/features/vehicle-tracking/utils/fleet-date.ts`:33 reads
  `NEXT_PUBLIC_FLEET_TIMEZONE`, and `apps/web/.env.example`:37 instructs that it *"Must match the
  API's FLEET_TIMEZONE"*, i.e. two env vars kept in sync by hand. **This is exactly the shape
  [`2026-09-09-business-timezone-is-a-tenant-property.md`](2026-09-09-business-timezone-is-a-tenant-property.md)
  decided against** — a single process-wide constant, here promoted to an environment variable,
  which cannot vary per tenant at all. `cdc34c30`'s premise was that three competing definitions of
  *"what day is it"* — Pacific in the pricing engine, UTC in period ranges and expiry sweeps,
  server-local in the crons — were being collapsed onto one; a **fourth** was merging into `main`
  in parallel and is there now.
- **The two implementations do not even share a library, and only one of them is shipped.**
  `fleet-day.ts` uses **dayjs** (`dayjs/plugin/timezone` + `dayjs/plugin/utc`);
  [`business-time.ts`](../../../packages/shared/src/utils/business-time.ts) uses **native `Intl`**
  and imports no dayjs at all — two libraries answering the same question with different DST and
  parsing behaviour. The asymmetry matters for sequencing: **`fleet-day.ts` is on `main`;
  `business-time.ts` is not**, existing only on `fix/timezone-business-day`. So the reconciliation
  is not "align two shipped modules" but "do not merge a second answer without deciding which one
  the fleet day uses."
- **Decided the same day, after this note was written:**
  [`2026-09-09-fleet-timezone-retired-onto-tenant-zone.md`](2026-09-09-fleet-timezone-retired-onto-tenant-zone.md)
  (`status: reference`) retires `FLEET_TIMEZONE`, `NEXT_PUBLIC_FLEET_TIMEZONE` and
  `DEFAULT_FLEET_TIMEZONE` in favour of `TenantCompany.timezone`, and converges both fleet-day
  implementations onto `business-time.ts`. The finding above therefore describes a contradiction
  that **has been decided, not one still standing** — the fleet day and the business day become
  one value. `../assets/gaps.md` → *The fleet day* nonetheless stays open on the **job** day; see
  that note's *Effect on the vault*.
- **[`../admin/gaps.md`](../admin/gaps.md) → *Time display* stays open, untouched by this
  note.** It is about 12-hour versus military format and whether a date rides along with a
  time; a day boundary settles neither.
- **Not done here, by instruction:** [`.ai/aidlc/SCRUM-TZ/spec.md`](../../aidlc/SCRUM-TZ/spec.md)
  — REQ-09 `[OPEN]` → resolved against this note, and §12 **Q8** → `Status: resolved — see
  decisions/2026-09-09-business-day-starts-at-midnight-local.md`. Syed Haris was editing that
  file and `units.md` in the same session and is applying those edits himself.
- **Flagged, not done:** [`../payroll/INDEX.md`](../payroll/INDEX.md):140 has a *Decisions
  that bind this module* section listing seven notes; this one carries `module/payroll` and
  belongs in it. `tcg-scrum` has no write access to that body — whoever maintains the index
  should add it, and update the "Seven `decisions/` notes" count on line 142.
- **No code change is authorised or implied.** `business-time.ts` already implements this and
  needs no edit. In particular this note does **not** authorise adding a `WorkdayStartTime`
  column, parameter or setting — the decision is that there isn't one.
