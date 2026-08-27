---
title: Assets — open questions
status: reference
kind: gaps
updated: 2026-08-27
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

## Per-Day Utilization on the Tools & Rigging listing — day-vs-range, and the default date

- **Status:** open
- **Asked:** 2026-08-25 — SCRUM-908 close-ticket (platform PR #399). Path C (no spec.md
  folder), so this question has no ticket §12 to live in; it belongs here per
  [STRUCTURE.md](../STRUCTURE.md) → *Where a question goes*.
- **Question:** does "Per-Day Utilization" mean one selected day at a time (the date-range
  picker removed, defaulting to today), or should the range picker have stayed with a
  per-day breakdown across it? And is today the intended default date, or should it default
  to the last selected day?
- **Sources checked:** `SCRUM-908` Jira — summary only, verbatim: *"change the listing from
  'Today's Utilization' to 'Per-Day Utilization' to display daily utilization"*; description
  `null`, zero comments, zero linked issues. [tool-and-rigging.md](tool-and-rigging.md)
  (`status: unverified`) Story 5 *Dylan's Yard Dashboard* — the only vault language on
  utilization, and it covers the yard dashboard's live counters, not this listing page or a
  date control. [user-story-and-tasks.md](user-story-and-tasks.md) — no utilization.
  `../decisions/` — [2026-08-24-tool-in-use-after-completion.md](../decisions/2026-08-24-tool-in-use-after-completion.md)
  settles the In Use *rule* (Q1:B, Q3:B), which this listing already inherits because both
  the listing and detail endpoints resolve to the same
  `ToolsRepository.findUtilizationByDateRange` — that part is not in question. It says
  nothing about the date *control's* shape or default.
- **Note:** the shipped default (today) is behaviour-preserving — the prior range control
  also defaulted to today→today — so this is a confirm-after-merge, not something blocking
  what shipped. Reviewed in the PR review for `scrum-908` → main (2026-08-25); `tcg-scrum`
  confirmed unsourced at that time and could not find a decision either.
- **Blocked:** any future claim that single-day-defaulting-to-today is settled product
  behaviour for tool utilization date controls.
- **Owner:** needs assignment — route to Fouzan Shakil (SCRUM-908 assignee) to confirm.

## Customer-owned assets — what they are, and whether the ERP tracks them

- **Status:** open
- **Asked:** 2026-08-27 — Brian Petros, written message to the TCG team, 2026-08-27 ("A couple things that came up in my discussion with CodingCops today, that we'll discuss in future meetings"), following the 2026-08-26 ERP sprint review — logged in [payroll/client-message-findings.md](../payroll/client-message-findings.md#cross-module--2026-08-27-follow-ups-after-the-fcc-migration-first-pass-brian-petros)
- **Question:** Brian lists "ask owners about *customer-owned assets*" as a follow-up. The term
  appears nowhere in the vault. Does TCG operate, maintain or dispatch equipment it does not own
  (customer cranes on customer sites?), and if so is that an asset record with an owner attribute,
  a separate entity, or out of scope? Nothing in `asset-management` models ownership.
- **Candidates:** the annotated migration brief, [meetings/2026-08-26-fcc-migration-client-brief.md](../meetings/2026-08-26-fcc-migration-client-brief.md): FCC `FMS_CUSTOMER_UNITS` holds **12 rows**, extracted but with no TCG module ("Need to scope this functionality"); the FCC table is thinner than the TCG Asset form (meter/engine/trans make-model extras). Otherwise none — vault-wide grep for `customer-owned` returns nothing; `model Asset` has
  no owner/ownership field.
- **Blocked:** asset-master migration from FCC (whether such rows exist there is itself unknown).
- **Owner:** TCG owners, via Brian Petros; CodingCops to check the FCC extract for any ownership
  flag before the meeting.

## Unit / asset certifications — registrations, insurance, loan, maintenance, permits

- **Status:** open
- **Asked:** 2026-08-27 — Brian Petros, written message to the TCG team, 2026-08-27 ("A couple things that came up in my discussion with CodingCops today, that we'll discuss in future meetings"), following the 2026-08-26 ERP sprint review — logged in [payroll/client-message-findings.md](../payroll/client-message-findings.md#cross-module--2026-08-27-follow-ups-after-the-fcc-migration-first-pass-brian-petros)
- **Question:** Brian wants "more details regarding requirements for Units/Assets certifications
  (and types: like registrations, insurance, loan, maintenance, and all different types of
  permits)". Which of these are one attribute family with an expiry date and reminder, and which
  are distinct entities (a loan is financial, maintenance is a schedule, a permit may be job-bound —
  see projects-jobs → *Asset on a permit*)? No vault document enumerates an asset-certification
  type list.
- **Candidates:** the annotated migration brief, [meetings/2026-08-26-fcc-migration-client-brief.md](../meetings/2026-08-26-fcc-migration-client-brief.md) — FCC `FMS_UNIT_CHECK_LIST` (15 asset checklist types) and `FMS_UNIT_DOWN_REASON` extracted with no TCG home. [projects-jobs/gaps.md](../projects-jobs/gaps.md#permit-expiry-reminders--neither-90-nor-30-shipped)
  (the only expiry-reminder discussion, permits only); `user-story-and-tasks.md` (unverified,
  personal-space provenance). Employee-side counterpart: payroll → *Employee certifications*.
- **Blocked:** asset detail design; any expiry-reminder feature beyond permits.
- **Owner:** TCG (Dylan Masterson for yard/units, Brian Petros for the list), CodingCops to
  bring the FCC field inventory.
