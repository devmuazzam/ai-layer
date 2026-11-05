# Proposal — say how you know, and debug before fixing

**Status:** applied to `.ai/claude/CLAUDE.md` on 2026-11-05, as written · **Date:** 2026-11-05 · **Decided by:** Haris (tooling owner)

## The change

Add one short section to `.ai/claude/CLAUDE.md`: about eight lines, no new skill, agent or tool.
It takes two ideas from `obra/superpowers` (`verification-before-completion` and
`systematic-debugging`) and leaves the rest of that repo out, because its enforced TDD conflicts
with the no-new-tests rule.

## Proposed text

Add to `.ai/claude/CLAUDE.md`, after _Code quality_:

```markdown
## Say how you know

Before saying something works, is fixed or is done, check the thing the claim is about, and say
what you checked. A fix is checked by repeating the original symptom, not by changing the code.
A screen is checked on the screen, in the right tenant and date. Data is checked by querying it. A
subagent's report is a lead, not a result. If you did not check it, say "not run" or "not checked":
that is always acceptable, and it never needs a new test.

**Debugging:** reproduce it and find the cause before changing code. Rule out the local state first:
branch, pending migrations, stale Prisma client or `@tcg/shared` build, tenant, date. Change one
thing at a time. After two failed fixes, stop and report what you know. API failures: `debug-api`.
```

## Why this is worth adding

- **It's a recurring problem.** `gate-illusion` is the second most common defect class in
  `aidlc/reflections/INDEX.md`, with 17 rows (`missing-requirement` is first, with 26). One example
  is SCRUM-900 ED-2: a promised test was not built, and the unit was still reported complete.
- **The existing rule doesn't reach this far.** `tcg-analyst`'s VERIFIED and INFERRED tags and the
  executor's `checked` line apply only inside those agents. Paths B and C, and ordinary sessions, have
  no such rule.
- **It happened in the session that produced this proposal:**
  - A developer was told to open a seeded payroll period without anyone checking that the screen
    could read it. It could not, because the run was left at `STARTED`.
  - A vault answer said no client had spoken on a topic, based on searching only recent transcripts.
    Older transcripts showed a client had.
  - A failing seeder looked like a code bug at first. One failure was a stale Prisma client.
- **Debugging has thin evidence.** One reflection row is a clear match: `MOBILE-TICKET-PRESIGNED-IMAGES`
  ED-2, where two fixes went in and the root cause was never reproduced. That supports two lines, not a
  skill.

## What this will not fix

- **Skipped process.** Many `gate-illusion` rows are the loop not running at all, such as SCRUM-252
  ED-1. A sentence can't make someone run the loop. Those need a mechanical check.
- **The analyst not running.** `MOBILE-OFFLINE-DELETE-QUEUE` ED-2 is unchanged by this.
- **Agents ignoring it.** This is a reminder, not a rail. `GUIDE.md` §13 explains how far reminders go.

## What was left out, and why

| In `superpowers` | Decision | Why |
| --- | --- | --- |
| "Skipping a step counts as lying", the "Iron Law" tone | Left out | The plain rule is enough, and "not run" must stay an acceptable answer |
| Full re-run of every command before every claim | Left out | Conflicts with the lint-only and no-build-until-push preferences on long tickets |
| Failing test before each fix | Left out | Conflicts with root `CLAUDE.md`: no new tests unless the developer asks |
| Three-fix rule | Changed to two | Each failed fix costs tokens on a $20 plan, and stopping only means reporting |
| Diagnostic logging at each boundary | Left out | Too detailed for always-on context |
| A new debugging skill | Left out | One reflection row doesn't justify it; a skill would duplicate `debug-api` for API work |

## Cost

- About 800 bytes on a 10 KB always-loaded file, sent once and cached per `GUIDE.md` §14.
- `.ai/claude/CLAUDE.md` is tooling, so only Haris can change it.

## How to tell if it worked

At the next reflection pass, check whether new `gate-illusion` rows are of the "reported complete
without checking" kind. If they still appear, this reminder isn't enough, and the reflector's
third-occurrence rule should push for a mechanical check instead.

## Decision for Haris

Apply as written, or change the wording. Nothing else depends on it.
