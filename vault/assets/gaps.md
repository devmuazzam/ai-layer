---
title: Assets — open questions
status: reference
kind: gaps
updated: 2026-08-24
tags: [module/assets, kind/gaps, open-questions]
---

# Assets — open questions

Live register per [STRUCTURE.md](../STRUCTURE.md) → *Where a question goes*. Ticket-raised
questions do **not** go here — they belong in that ticket's `spec.md` §12.

Entry format (unchanged from the retired registers, so the global sweep still works):

```markdown
## <question title>
- **Status:** open
- **Asked:** YYYY-MM-DD — by whom / which work raised it
- **Question:** one paragraph
- **Sources checked:** what was read before declaring this open
```

*No entries yet. Pre-2026-08-20 questions remain in the retired registers
([gaps.md](../gaps.md)); disposition into module files is phase 3.*

## One In Use rule or two — the yard panel and the tool detail page disagree

- **Status:** open
- **Asked:** 2026-08-25 — SCRUM-900 close-ticket (platform PR #394). The named follow-up in
  [2026-08-24-tool-in-use-after-completion.md](../decisions/2026-08-24-tool-in-use-after-completion.md)
  Q2:C — *"converge on one server-side utilization computation both surfaces consume (do not
  silently leave permanent duplication)"* — which until now existed only inside that decision's
  prose, so the `gaps.md` sweep could not surface it. **Not a ticket question:** SCRUM-900 is
  closed and Q2:C put the convergence explicitly outside its scope.
- **Question:** two screens now compute a tool's **In Use** from different rules. Which rule is
  the product rule — the yard panel's client-side release (partial mid-day remaining quantity,
  plus release when the schedule date passed and loadout never started), or the detail page's
  server-side closed-day full exclusion with historical past dates? And **which ticket, with
  which owner, does the rewiring** once that is settled — is the shared computation a follow-up
  ticket under the `SCRUM-454` epic, or does it wait for a surface to be rebuilt?
- **Sources checked:** [tool-and-rigging.md](tool-and-rigging.md) (`status: unverified`) Story 5
  *Dylan's Yard Dashboard* — :102 *"Each tool displays live status counters Total, In use and
  available"* and :104 *"At end of day Dylan can mark each piece of equipment as returned to yard
  or still on site"*. **That is the only vault language on In Use, and it defines neither release
  granularity nor partial quantities, and says nothing about the tool detail page at all.**
  [user-story-and-tasks.md](user-story-and-tasks.md) — yard management only, no utilization
  counters. `../decisions/` — the 2026-08-24 note above settles the detail page (Q1:B, Q2:C,
  Q3:B) and its *What this does not settle* section names both the rewiring and the partial-qty
  parity as open; [2026-08-20-job-completed-on-last-day-offload.md](../decisions/2026-08-20-job-completed-on-last-day-offload.md)
  settles day-level completion but not utilization display. Jira: `SCRUM-453` / `SCRUM-457`
  (tool detail + Dylan live In Use, both Done) — no ticket owns convergence.
- **Note:** the divergence is now three rules wide, not one, and all three are in shipped code.
  Yard panel — `apps/web/src/features/dylen-dashboard/utils/resolve-job-tool-in-use-quantity.ts`:
  releases the **remaining not-offloaded quantity** per loadout row (partial mid-day release),
  and `isJobDatePassedWithoutStart` releases a tool entirely when the schedule date has passed and
  loadout was never started. Detail page —
  `apps/api/src/service/asset-management/tools/tools.repository.ts` `findUtilizationByDateRange`
  (SCRUM-900): **full** exclusion of an assignment when its schedule day is closed
  (`closedStages` = COMPLETED / TICKET_SUBMITTED / CANCELLED, or loadout offload / force-complete
  / `phase` COMPLETED), applied **only to today-and-future rows** (`date >= startOfTodayUtc`);
  past-date rows accumulate unconditionally, and there is no partial-quantity math and no
  never-started release. So the same tool on the same day can read a different In Use on the two
  screens, and neither number is wrong against any written source — because no written source
  says which one is In Use. Converging is a product call before it is a refactor: adopting the
  API rule silently drops Dylan's partial release, adopting the client rule changes what the
  detail page's historical dates mean.
- **Blocked:** the convergence itself (no ticket exists); any future ticket that assumes one
  definition of In Use across both surfaces; `spec.md` §12 Q4 on SCRUM-900 (whether replaced tool
  assignments count as in use) bears on the same query and would be cheaper to answer once.
- **Owner:** **needs assignment — no one owns this today.** Fouzan Shakil is the obvious person
  to route it to (he is the SCRUM-900 assignee and wrote the follow-up sentence), but nothing on
  record says he owns the convergence, and the rule question is a product call rather than his to
  make by default.
