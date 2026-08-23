---
title: Planning Tracker must have a filter that shows archived plans — decision
source: decision/Fouzan Shakil
decided: 2026-08-20
decided_by: Fouzan Shakil (developer on TCG, assignee on SCRUM-896's branch) — stated directly in chat on 2026-08-20, against `SCRUM-896/spec.md` §12 Q3. He is not the client-side product owner; `spec.md` §12 Q3 nominated "product team (named product owner — not QA)" as owner. This is therefore an internal engineering-and-product decision by a named person on the team, binding on implementation, and open to being overruled by the client. `status: reference` rather than `verified` for that reason, matching `decisions/2026-08-20-archive-instead-of-delete-app-wide.md` and `decisions/2026-08-20-post-save-navigation-convention.md`.
status: reference
conflicts_with: []
resolves: SCRUM-896/spec.md#q3
jira: [SCRUM-896]
topics: [navigation-ui, requirements-spec, lift-plans]
entities: [lift-plan, project]
---

## Decision

**The Planning Tracker should have filters which can be changed to show archived plans.**

Those are Fouzan Shakil's words on 2026-08-20. Two things follow directly and nothing
else does:

1. **Archived plans are not permanently excluded from the tracker.** The
   `archivedAt: null` predicate branch `scrum-896` added to `findAllForTracker`
   (`apps/api/src/service/plans/plans.repository.ts:85`) is a **default**, not product law.
   `GET /plans/tracker` must eventually accept a parameter that relaxes it.
2. **The mechanism is a user-changeable filter on the tracker surface**, not a separate
   screen and not an admin-only or query-string-only affordance. "Filters which can be
   changed" is the whole of the design guidance given.

The phrasing also fixes the default: the filter is something the user *changes* in order
to see archived plans, so the tracker's out-of-the-box state continues to hide them. The
behaviour shipping on `scrum-896` is therefore correct as a default and wrong only as a
permanent rule.

**Implementation is deferred.** Fouzan asked for this to be written down for future work,
explicitly **not** built in the current `SCRUM-896` PR. Nothing here authorises adding a
tracker filter to that ship — it needs its own ticket.

## Why

§12 Q3 asked a binary question: is the hard exclude permanent, or does the endpoint gain
`includeArchived` / `onlyArchived`? Nothing written could answer it. `SCRUM-896` itself,
`decisions/2026-08-20-archive-instead-of-delete-app-wide.md` and
`projects-jobs/project-module/04-create-and-approve-lift-plans.md` are all silent on the tracker
and archive together, and the only precedent — the identical `archivedAt: null` exclude in
`apps/api/src/service/permits/permits.repository.ts` `findAllForTracker` — is code, which
is not a requirement source.

The answer matters beyond the filter itself because of what the alternative would have
implied. Had the exclude been permanent, an archived plan would have been reachable from
exactly one surface (the project Plans tab, Archived filter) and invisible from the
cross-project view — so a user who knew a plan existed but not which project it belonged
to could not find it at all. Making archived plans filterable rather than hidden keeps the
tracker the one place that can answer "where is that plan".

Recording it now, unimplemented, is the point: the exclude is already merged, and without
this note the next person reads the code and concludes the exclusion was intended to be
permanent.

## What this does NOT settle

Recorded explicitly so nothing broader is read out of one sentence. Each of these was
**not raised and not answered**:

- **The filter's UI shape.** Whether it is a status dropdown, an All / Active / Archived
  tab set, a checkbox, or the same control the project Plans tab already uses. "Filters"
  was the only word given.
- **The API shape.** Whether `QueryPlanTrackerDto` gains `includeArchived`, `onlyArchived`,
  both, or a single tri-state parameter. Q3 listed those as candidate shapes; Fouzan chose
  none of them.
- **Whether the Permits tracker follows the same rule.** `permits.repository.ts`
  `findAllForTracker` carries the identical exclude. He spoke about the Planning Tracker
  only. Do not assume either way — and do not treat this note as licence to change the
  permits tracker.
- **Whether other tracker or listing surfaces across the app inherit this.** Unlike
  `decisions/2026-08-20-archive-instead-of-delete-app-wide.md` and
  `decisions/2026-08-20-post-save-navigation-convention.md`, **this statement was not made
  app-wide.** It names one surface.
- **Whether archived plans can be restored *from* the tracker**, or whether the tracker
  only views them and restore stays on the project Plans tab.
- **What an archived plan looks like in the tracker** — row styling, a badge, whether its
  actions are disabled, and whether it still counts toward the tracker's status column
  totals.
- **Permissions.** Who may switch the filter on.

## Effect on the vault

- **No winner/loser flip applies.** No vault file specifies the Planning Tracker's
  treatment of archived plans, which is why §12 Q3's only candidates were the ticket
  itself, a sibling decision note, and a code precedent. Nothing is superseded; no
  `status:`, `superseded_by:` or `conflicts_with:` field changes on any vault file.
- `INDEX.md` → `decisions/` table: row added.
- `.ai/aidlc/SCRUM-896/spec.md` §12 Q3 → `Status: resolved — see this note`; §0 open-question
  count → 0; §13 entry rewritten to point here and to name what is still open.
- `vault/gaps.md` — **not touched.** It is retired for new entries as of 2026-08-20 and
  nothing in it covers this question.

## Effect on SCRUM-896

**No code change on this ticket.** The current PR ships the exclude as-is, and that is now
the confirmed correct *default*. What changes is the label on it: §12 Q3's workaround note
("labelled a workaround until Q3 is answered") is discharged — the tracker hiding archived
plans by default is the intended behaviour, not a stopgap.

The filter itself is **follow-up work**, not in scope here:

- `QueryPlanTrackerDto` gains an archived filter parameter (shape undecided, see above).
- `findAllForTracker` makes `archivedAt: null` conditional on it.
- The Planning Tracker UI gains the control.

Suggested follow-up ticket: *Planning Tracker — filter to show archived plans.* Scope is
the plans tracker only; the permits tracker is out of scope until someone decides it.
