---
title: Employee Compensation Type is optional, and so are the craft, salary and hourly-rate fields under it; a blank-type employee stays payable with a non-blocking week-card warning — developer direction
source: decision/developer (git user Jz-Nd)
decided: 2026-11-11
decided_by: >-
  The developer working branch `feat/employee-compensation-type-optional-staging` in a Claude
  Code session on 2026-11-11 — git user `Jz-Nd`; commit 59c170088 is authored as
  `jahanzaib.nadeem@codingcops.com`; the session's account is `fouzanshakil.dev@gmail.com`. Which
  named person gave the instruction is therefore not established by the record; tcg-scrum saw only
  the launching session's summary, not the instruction itself. The developer instructed that
  Compensation Type, and the fields under it, stop being required. The recommendation for how to
  build it (what to derive, what to warn) was drafted by Claude from DEC-0915 and
  `payroll/payroll-rules-provenance.md` and adopted by the developer. **This is not a client or
  product-owner ruling.** It reverses parts of DEC-0915, which is itself a developer's reading (Syed
  Haris, drafted by Claude). `status: reference`: it binds the CodingCops build now, and Corrina
  Bustos / Brian Petros (payroll) can overrule it, as they can DEC-0915. Recorded by tcg-scrum on
  2026-11-11.
status: reference
conflicts_with: []
supersedes: [decisions/2026-09-15-employee-profile-compensation-type-and-statuses.md]
resolves: []
related_decisions:
  - 2026-09-15-employee-profile-compensation-type-and-statuses.md
jira: []
tags: [module/payroll, kind/decision, payroll-rules, craft-code, requirements, data-migration]
---

# Compensation Type is optional

**In short:** an employee can now be saved with no Compensation Type. When the type is blank, the
fields under it are not required either: payroll craft, salary amount and salary frequency, and
hourly rate. A blank-type employee keeps a payroll group derived the same way as before and stays
payable. Each week that prices them shows a warning on their card. The warning never blocks.
**Developer direction, not a TCG ruling.** It supersedes DEC-0915 **in part**: the sections listed
below. The rest of DEC-0915 stands.

Built on `feat/employee-compensation-type-optional-staging`: commits 6df40da35 (`.gitignore`),
59c170088 (the optional type) and 414cbb3c9 (the warning, which touches
`packages/shared/src/constants/payroll-issue-severity.ts`,
`apps/api/src/usecase/payroll-pricing/payroll-ingest.ts`,
`apps/api/src/usecase/payroll-pricing/pay-week-assembly.ts` and
`apps/api/src/usecase/payroll/payroll.service.ts`).

## What changed

1. **The column is nullable.** Migration `20261111120000_employee_compensation_type_optional`
   does only `ALTER TABLE "employees" ALTER COLUMN "compensation_type" DROP NOT NULL`. No row is
   rewritten, and every existing employee keeps its type. `null` means "not set yet".
2. **Nothing under the type is required, on create or update, in web or API.** That covers
   Compensation Type, payroll craft (`primaryCraftCodeId`, Craft-Based Hourly), salary amount and
   salary frequency (Salaried), and hourly rate (Hourly Non-Craft). Two checks remain:
   - A salary frequency that **is** sent must be one of the four allowed values (Weekly ·
     Bi-Weekly · Semi-Monthly · Monthly, DEC-0915 Q8).
   - Effective dates must still be in order.
3. **Create and update semantics.**
   - On create, a missing type is stored as `null`, and `payType` is `null`.
   - On update, an omitted type leaves it unchanged, and an explicit `null` clears it.
   - Type-specific fields are still stripped from what is saved. DEC-0915 Q12's "hide, never
     clear" still applies. With a null type, **all** type-specific fields are stripped.
4. **The role no longer pre-selects the type.** The create form's Compensation Type starts blank
   and can be cleared. Role (`roleCode`) is still required and now shows its asterisk.
5. **`GET /craft-assignments/missing-primary`** lists employees whose type is `CRAFT_HOURLY`
   **or null**. Before, it listed `CRAFT_HOURLY` only.
6. **A new pay-week warning, `EMPLOYEE_NO_COMPENSATION_TYPE`** (severity `warning`, never
   blocking). See below.

`packages/payroll-engine` is untouched.

## What this supersedes in DEC-0915

[decisions/2026-09-15-employee-profile-compensation-type-and-statuses.md](2026-09-15-employee-profile-compensation-type-and-statuses.md):

| DEC-0915 | Was | Now |
| --- | --- | --- |
| **Q4** | Compensation Type is the source, so `payType` and `payrollGroup` are derived from a **required** type. One-pass backfill, then `NOT NULL` | The type is optional and the column is nullable again. `payType` is `null` with no type. `payrollGroup` is still derived (see below). The backfill already ran; its values are kept |
| **Q5** | A field Employee Type **defaults** Compensation Type to Craft-Based Hourly. Primary craft is required iff `CRAFT_HOURLY`. `missing-primary` lists only `CRAFT_HOURLY` | No role-driven default. Primary craft is never required. `missing-primary` also lists null-type employees |
| **Q8** and the required set (REQ-08/10/11/12/29 of `SCRUM-EMPLOYEE-PROFILE`) | Salary Frequency is **required** for Salaried, and the type and its children are part of the required set | Nothing under the type is required. A frequency that is sent is still checked against the four values |

**Still standing:**
- Q1–Q3, Q6, Q7, Q9–Q15.
- Q4's manual payroll-group override.
- Q8's four-value list.
- Q12's hide-never-clear.

**Q3 is what the new warning follows:** HOLD excludes, ELIGIBLE is the default, and hours are
never silently dropped.

## A blank-type employee's payroll group, and why the Non-Union Hourly fallback stays

`derivePayrollGroup` still runs for a null type, and it falls through to the craft derivation:

- craft code `SYS*` → `SYS`
- mechanic → `L12_MECHANIC`
- union → `L12_FIELD`
- otherwise → `NON_UNION_HOURLY`

`payType` is `null`, so the salary branch never matches. The stored `payroll_group` is written on
every save, and `pay-week-assembly.ts` uses it first.

**Why the fallback stays `NON_UNION_HOURLY`:** it is the catch-all DEC-0915 Q4's own backfill used.
That backfill sent an employee with no salary pay type and no PRIMARY craft to `HOURLY_NON_CRAFT`,
which Q4 maps to `NON_UNION_HOURLY`. A blank-type employee with no craft lands where the backfill
would have put them. No new grouping rule is invented here. Whether TCG wants that is asked in
`payroll/gaps.md` (below).

## Why not default to HOLD

`payrollStatus` stays `ELIGIBLE` for a blank-type employee. It does not default to `HOLD`.

- DEC-0915 Q3 makes `ELIGIBLE` the default and `HOLD` a deliberate admin act.
- Auto-holding on a missing optional field would take a field worker's hours out of the worklist
  and the ADP export. Q3's protection would be the only trace: an `EMPLOYEE_ON_PAYROLL_HOLD` on the
  run, not on a week card.
- A missing setup field is not a reason to stop paying someone.

The developer chose "pay on the derived group, and say so on the card".

## The warning — `EMPLOYEE_NO_COMPENSATION_TYPE`

- Raised **once per priced employee whose compensation type is null**
  (`buildNoCompensationTypeIssue` in `apps/api/src/usecase/payroll-pricing/payroll-ingest.ts`;
  collected as `noCompensationType` in `pay-week-assembly.ts`).
- Carried on **that employee's own week card**, by the same path as
  `TICKET_PRICED_IN_OTHER_PERIOD` (`payroll.service.ts`, the `pricedElsewhere` loop).
- Severity `warning` (`packages/shared/src/constants/payroll-issue-severity.ts`). It never blocks
  calculate, approve or export.
- **Deliberately not added to the entry-fix preview note.** It is about the employee's profile,
  not an entry, and correcting an entry cannot clear it.

**Deviation, recorded:** the warning fires on a null type **alone**. It does **not** check for a
manual payroll-group override (DEC-0915 Q4/Q7). The stored `payroll_group` is written on every
save, so it cannot tell an admin's override from a derived value. An employee with a null type
whose group was set by hand will still warn.

## One-way migration

`DROP NOT NULL` is reversible only while no row is null. Once any employee is saved with a blank
type, restoring `NOT NULL` would need a backfill first. That is a rewrite of existing data, so G2
applies: developer approval, plus a guard run on a copy of staging data.

## Verified, and not verified

**Checked in the session (as reported by the launching session; tcg-scrum did not re-run them):**
- Web and API typecheck pass, and lint has 0 errors.
- The existing payroll tests (970) and employee tests pass.
- Chrome:
  - created an employee with no type and no craft;
  - edited it to Salaried with no amount;
  - then cleared the type.

  All three saves succeeded.
- DB: the row has null `compensation_type` and null `pay_type`.

tcg-scrum confirmed that the migration SQL, the warning code and the `noCompensationType` path
exist in the working tree.

**Not verified:**
- The new warning on a real week card. No end-to-end payroll run was done.
- The temp-employee form.
- Mobile.
- These API paths with a null type:
  - the payroll worklist;
  - the ADP export;
  - role-change approval.
- The stored `payroll_group` value for a blank-type employee.

## Needs the owner's yes

Corrina Bustos / Brian Petros, the owners DEC-0915 names:

1. Is a blank-type employee payable at all? Or should they get a "needs setup" status?
2. Should their group fall back to Non-Union Hourly?

These are open in
[payroll/gaps.md → *Employee with no Compensation Type…*](../payroll/gaps.md#employee-with-no-compensation-type--payable-as-eligible-or-held-for-setup-and-is-non-union-hourly-the-right-fallback).
The pay-rule row is in
[payroll/payroll-rules-provenance.md](../payroll/payroll-rules-provenance.md) §5, *No compensation
type warns, never holds* (**Pending**).

## Effect on the vault

All done in this pass:

- **Superseded in part:** `decisions/2026-09-15-employee-profile-compensation-type-and-statuses.md`.
  Its frontmatter now has `superseded_by:` pointing here, and a `provenance_note:` naming the parts
  this note supersedes (Q4, Q5, Q8/required set). Its `status:` stays `reference`, because the
  rest of it still binds. Its body is unchanged.
- `payroll/payroll-rules-provenance.md` §5: a **Pending** row for the warning (G4).
- `payroll/gaps.md`: one open question appended.
- `payroll/INDEX.md`: a decision line for this note. The DEC-0915 line now says it is superseded
  in part.
- **Not changed:** `payroll/rules/PAY-061-employee-payroll-worklist.md`. This change does not
  supersede any clause in it. Its superseded INACTIVE clause is about worklist status, and nothing
  here changes who is on the worklist. The root `INDEX.md` does not list payroll decisions (it
  routes to `payroll/INDEX.md`), so it gets no row.
