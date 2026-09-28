---
title: "Secondary-craft days: boom adder from the worked craft's union, dispatch may set the day's craft, the primary base rate is a floor, and what the crew card shows — decision"
source: decision/Syed Haris (CodingCops) — TCG-140, 2026-09-28 Claude Code session
decided: 2026-09-28
decided_by: >-
  The CodingCops developer working TCG-140 (git user devmohsinakram, in a Syed Haris Claude Code
  session), answering directly on 2026-09-28 while building the per-union craft code modifiers.
  All seven clauses come from that developer. This is a **developer's decision**, not a
  client-side product decision. `status: reference` for that reason, on the same basis as
  `2026-09-25-boom-adders-single-union-per-company.md`: it binds implementation now and TCG can
  overrule it. **Clauses 5 and 6 go further than the verified**
  `2026-08-20-craft-locked-rate-override.md` (Corrina Bustos, confirmed by Brian Petros).
  Clause 5 adds dispatch to that note's list of who may set the day's craft. Clause 6 makes a
  rate rule of the floor that note called unnecessary. Neither clause overrides the verified
  note until a ratifier confirms it. Ratifiers: **Brian Petros** (Data Analyst, ERP Project
  Coordinator) and **Corrina Bustos** (Payroll Manager).
status: reference
supersedes: []
conflicts_with: []
resolves:
  - "payroll/gaps.md#is-a-secondary-craft-paid-only-when-it-is-higher-than-the-primary (provisional — clause 6; developer answer pending Brian Petros / Corrina Bustos ratification)"
  - "dispatch/gaps.md#changing-an-employees-craft-code-in-das--pointer-owned-by-payroll (provisional — clause 5; pointer entry)"
  - "payroll/gaps.md#primary-craft-code-constrained-to-the-employee-type-and-changing-a-craft-code-in-das (partial, provisional — sub-question (b) only, clause 5; (a) employee-type constraint stays open)"
jira: [TCG-140]
tags: [module/payroll, kind/decision, craft-modifier, union-agreement, craft-code, payroll-rules]
entities: []
---

# Secondary-craft days: which union, who sets the craft, and the pay floor

**Nothing written answered clauses 1–4 and 7 before.** No vault source said whose union's boom
adder applies when an employee works a secondary craft that belongs to a different union.
Clauses 5 and 6 answer questions that were open in the module registers (see *Effect on the
vault*). All seven are the TCG-140 developer's answers from 2026-09-28.

## Question

When an employee works a ticket under a **secondary** craft:

- Whose union's craft code modifiers (boom ranges and amounts) apply?
- Who may set that day's craft?
- Is the employee's primary base rate a floor?
- What does the mobile Labor & Unit crew card show?

## Decision

1. **The boom union is the union of the craft that payroll prices the ticket under, not
   `Employee.unionCodeId`.** That craft is picked by the rule payroll already uses,
   `secondaryCraftCodeIdForRateResolve` in
   `apps/api/src/usecase/payroll/payroll-secondary-craft.ts`:
   - if the ticket allocation's craft (`job_resource_allocations.craft_code_id`) is one of the
     employee's **SECONDARY** craft assignments, that craft is used;
   - otherwise the employee's **PRIMARY** craft is used.
2. **The mobile crew card follows that same craft.**
   - On a secondary-craft day the card lists and prices the boom ranges of the **secondary
     craft's union**, and its "Craft code" field shows the secondary craft.
   - A **NON_UNION** craft earns no boom adder, so the card offers only "No boom pay".
   - A union with no **ACTIVE** craft code modifiers (none set up yet, or its set archived) also
     offers only "No boom pay". Once the catalog has loaded, mobile no longer substitutes a
     built-in ladder. The message shown for this case is in clause 7.
3. **Payroll's boom pricing does not change.** The rate resolver already prices boom from the
   resolved craft's union: `unionScope = { kind: craft.unionCode.kind, id: craft.unionCode.id }`
   in `apps/api/src/service/craft-rate-resolver/craft-rate-resolver.service.ts`. Clauses 1–2
   bring the crew card in line with payroll. The base-rate floor in clause 6 is a separate
   change to payroll.
4. **Shared crew ticket: keep payroll's rule.** A teammate's boom ranges come from their own
   **PRIMARY** craft unless the ticket allocation's craft is one of *their* **SECONDARY**
   assignments. The ticket gets **no per-member worked-craft field**.
5. **Who sets the day's craft.** Three roles may set it:
   - **dispatch**, in DAS, when seating the employee (this sets the allocation's craft);
   - the **crane superintendent**, who may correct it afterwards;
   - **payroll**, who may also correct it afterwards.

   This goes further than clause 3 of the verified
   [2026-08-20-craft-locked-rate-override.md](2026-08-20-craft-locked-rate-override.md)
   (*"Only the crane superintendent or payroll may set the day's craft/rate — never the
   employee"*) by adding dispatch. The employee still may not set it. The code already supports
   this: the DAS change-craft-code dialog
   (`apps/web/src/features/das/middle-section/jobs/components/change-craft-code-dialog.tsx`)
   only offers the employee's **SECONDARY** assignments. So dispatch picks a controlled,
   craft-locked assignment and never enters a free-text rate, which keeps the 2026-08-20
   "locked to a craft-code amount" rule.
6. **Pay floor: the primary rate is kept when it is higher.** On a day worked on a craft other
   than the primary, the base rate is the **higher** of two figures on that work date: the worked
   craft's base and the primary craft's base.
   - **The day stays on the worked craft.** Craft code, union kind, boom union and wage group
     don't change. Only the base rate and the recorded rate row move.
   - **If the primary can't be priced that day, no floor applies.** The worked rate stands and
     the day is not Blocked.
   - **It is raised as a payroll issue:** `PRIMARY_RATE_FLOOR`, severity `info`, titled
     "Primary rate kept — secondary craft lower".
   - **Where it is built:** `applyPrimaryRateFloor` in
     `apps/api/src/service/craft-rate-resolver/craft-rate-resolver.service.ts`, and the issue
     entry in `packages/shared/src/constants/payroll-issue-severity.ts`. Both were checked in the
     working tree on 2026-09-28 (not yet committed).
7. **Mobile, union with no active craft code modifiers** (none set up, or its set archived): the
   crew card offers only "No boom pay" and shows the note *"No boom rates are set up for
   \<union\> — boom pay can't be selected."* A non-union craft gets **no** note.
   (`apps/mobile/features/field-ticket/steps/labor/LaborBody.tsx`, working tree 2026-09-28.)

## Why

- **One day, one craft, one union (clauses 1–4).** Payroll already prices both the base rate and
  the boom adder from the resolved craft and that craft's union. If the crew card priced boom
  from the employee's own union, a secondary-craft day would show one adder on mobile and pay
  another. Using the rule payroll already uses, including on shared crew tickets, means the card
  and the pay stub can't disagree. Per-member craft on a crew ticket would be a new data shape
  that nothing written asks for.
- **Clauses 1–2 refine "own local".** Clause 4 of
  [2026-09-25-boom-adders-single-union-per-company.md](2026-09-25-boom-adders-single-union-per-company.md)
  says *"Mobile keeps showing each crew member their own local's adder"*. This note reads "own
  local" as **the union of the craft worked that day**. On a primary-craft day that is the
  employee's union, so nothing changes. It only differs on a secondary-craft day.
- **Clauses 1–2 are consistent with the verified rate-override decision.** Clause 4 of
  [2026-08-20-craft-locked-rate-override.md](2026-08-20-craft-locked-rate-override.md) says
  *"Boom/modifier premiums are unaffected by the override — they ride whichever rate applies."*
  Clause 6 keeps this: the floor moves the base rate only, so boom still comes from the worked
  craft's union.
- **Per-union modifiers made the question real.** TCG-140 work from 2026-09-25 to 2026-09-28 gave
  each union its own set of craft code modifiers, managed from the union list page (create, edit,
  archive, restore). Once two unions can hold different sets, "which union's set?" needs a
  single answer.
- **No invented ladder (clauses 2 and 7).** Showing a built-in fallback ladder for a union with
  no active set would put a boom amount on screen that payroll would not pay. The resolver raises
  `NO_UNION_MODIFIER_RATE` as a review flag instead of borrowing another union's rate
  (2026-09-25 note, clause 3). "No boom pay" plus a note saying why is the honest display.
- **Clause 5 names the role that already does it.** Dispatch seats the employee, and seating
  sets the allocation's craft. The UAT 6 row asks for *"a way to change an allocated employee's
  craft code"* in DAS ([uat/register-2026-09-18.md](../uat/register-2026-09-18.md)). Limiting the
  pick to SECONDARY assignments keeps the control craft-locked.
- **Clause 6 follows Brian's proposal from the 2026-08-13 call.** Kyle Harlow agreed with that
  proposal, and it is what the 2026-09-17 reply to Brian described (see the payroll gaps entry).
  The verified 2026-08-20 note called the floor unnecessary under controlled assignment. It said
  that if TCG still wanted it, *"it is a validation warning, not a rate rule"*. **This clause
  makes it a rate rule, plus an info-level issue.** Treat that as a provisional developer call
  until Corrina Bustos or Brian Petros ratifies it.

## What this does NOT decide

- **Sub-question (a) of the payroll entry:** whether the primary craft offered for an employee is
  constrained by their employee type. Still open:
  [payroll/gaps.md → *Primary craft code constrained to the employee type, and changing a craft code in DAS*](../payroll/gaps.md#primary-craft-code-constrained-to-the-employee-type-and-changing-a-craft-code-in-das).
- **The provenance record for the floor.** `payroll/payroll-rules-provenance.md` has no row for
  the clause 6 floor. Adding one is outside the recording agent's write scope.
- **Multi-union boom schedules** (different brackets or amounts per local). These stay open, as
  in the 2026-09-25 note.
- **Higher rate for the day (MLA Art. IV-C)** is a separate contract rule and is not addressed
  here.

## Who ratifies on the client side

- **Brian Petros**, for clauses 1, 2, 4 and 7 (what is priced and shown on a secondary-craft
  day), and for clause 5 with Corrina.
- **Corrina Bustos**, for clause 5 (it expands the list of who may set the day's craft in her
  verified 2026-08-20 decision) and clause 6 (a pay rule). **Lisette Anzaldo** is the DAS side of
  clause 5, as named in the payroll gaps entry.

## Effect on the vault

Done in the same pass as this note:

- [payroll/gaps.md → *Is a secondary craft paid only when it is higher than the primary?*](../payroll/gaps.md#is-a-secondary-craft-paid-only-when-it-is-higher-than-the-primary)
  — **done**: `Status` now says answered provisionally by clause 6 and points here. The entry
  stays open for owner ratification; the rest of it is unchanged.
- [payroll/gaps.md → *Primary craft code constrained to the employee type, and changing a craft code in DAS*](../payroll/gaps.md#primary-craft-code-constrained-to-the-employee-type-and-changing-a-craft-code-in-das)
  — **done**: `Status` now says (b) is answered provisionally by clause 5 and (a) stays open.
- [dispatch/gaps.md → *Changing an employee's craft code in DAS — pointer, owned by payroll*](../dispatch/gaps.md#changing-an-employees-craft-code-in-das--pointer-owned-by-payroll)
  — **done**: `Status` now says answered provisionally by clause 5 and points here.

Not changed:

- [2026-08-20-craft-locked-rate-override.md](2026-08-20-craft-locked-rate-override.md) stays
  `verified` and is **not superseded**. A developer's reference decision can't supersede a
  verified client decision.
- No frontmatter was edited.
- Not done, because index and rule **bodies** are outside the recording agent's write scope:
  - [payroll/INDEX.md](../payroll/INDEX.md): the `module/payroll` decisions list needs a line for
    this note.
  - `payroll/payroll-rules-provenance.md`: needs a row for the floor.
  - [payroll/rules/PAY-010-l12-union-base-rate.md](../payroll/rules/PAY-010-l12-union-base-rate.md)
    (it covers secondary-craft pricing) needs a pointer under **Open** for the clause 6 floor.
