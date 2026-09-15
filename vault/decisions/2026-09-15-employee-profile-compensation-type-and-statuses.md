---
title: Employee Profile — compensation type, statuses, over-scale, and the fourteen open questions of SCRUM-EMPLOYEE-PROFILE — decision
source: decision/Syed Haris
decided: 2026-09-15
decided_by: >-
  Syed Haris (developer on TCG) — instructed in session that every open question in
  `.ai/aidlc/SCRUM-EMPLOYEE-PROFILE/spec.md` §12 be answered by best judgment rather than
  left for the client ("use your best judgment to answer all these, there should be
  answer"). The answers were drafted by Claude (Opus 5) from the closest written source for
  each and adopted by Syed Haris. He is not the client-side product owner. `status:
  reference` — binding on the CodingCops build now, open to being overruled by Corrina
  Bustos / Brian Petros / Lisette Anzaldo, each of whom is named as owner on the question
  they would overrule.
status: reference
conflicts_with: []
resolves: SCRUM-EMPLOYEE-PROFILE/spec.md#12
jira: [SCRUM-EMPLOYEE-PROFILE, SCRUM-926, SCRUM-928]
tags: [module/payroll, kind/decision, employee, compensation-type, payroll-group, craft-code, subsistence, union-status, requirements]
entities: [Employee, EmployeeCraftAssignment, CraftCode, EmployeeUnionCode, PayrollGroup]
---

# Employee Profile — the fourteen answers

The staged document `employee-profile-feature.md` (2026-09-15, `source_count: 0`) asks for
an Employee Profile whose payroll section follows a three-way **Compensation Type**. Its
elaboration (`.ai/aidlc/SCRUM-EMPLOYEE-PROFILE/spec.md`) found fourteen questions no written
source answers. This note answers them so the ticket can be built. **Every answer below is a
developer's reading, not a client ruling**; where a payroll figure is involved the answer
stores the value and leaves pricing to a later, provenance-backed change.

## Q1 — SSN visibility

**Full SSN is visible only to `Role.ADMIN` / `SUPER_ADMIN`.** Every other authenticated
reader gets the masked form `***-**-1234` from the API itself (list, detail, temp-employee
list column), so no client can leak it by forgetting to mask. No new permission is minted —
the module-permission layer is unbuilt (`admin/gaps.md` → *Departments, roles and their
capabilities*), and admin already gates every employee write. *"Dummy-only in UAT/demo
tenants"* is guidance to the seeder (`apps/api/prisma/scripts/`, `fcc-seeder`), not a tenant
setting: seeds write `000-00-0000`-style values; nothing rejects a real-looking SSN.

## Q2 — Employee status vocabulary

`Employee.status` takes **`ACTIVE` · `INACTIVE` · `ON_LEAVE` · `TERMINATED` ·
`PENDING_ONBOARDING`**, plus the pre-finalize **`DRAFT`** that exists today and stays
one-way. The `terminated` boolean is **superseded** by `status = TERMINATED` (kept as a
column, written from the status, never edited directly); `termDate` is required and
`termReason` optional when the status is `TERMINATED`; `rehireDate` stays. `employeeStatus`
(`PERMANENT` / `TEMPORARY`) is a different axis and is untouched.

What each status gates, in this ticket:

| Status | Dispatch / DAS / resource pickers | Portal invite | Payroll worklist |
| --- | --- | --- | --- |
| `ACTIVE` | assignable | yes | included |
| `ON_LEAVE` | visible, **not assignable** (the DAS "Leave" chip made a record) | yes | included (PTO/sick are payroll's business, not the status's) |
| `PENDING_ONBOARDING` | **not assignable** — the 2026-06-30 decision's ADP gate, made a status | yes | excluded |
| `INACTIVE` | not assignable, hidden from default pickers | no | excluded |
| `TERMINATED` | not assignable, hidden from default pickers | no (revoked) | excluded |

`EmployeeSelect` and `resolveAssignableEmployeeId` keep their `status = ACTIVE` default.
The list's Active/Inactive switch stays; the other three are set on the form. The leave-request
module is not wired to `ON_LEAVE` in this ticket.

## Q3 — Payroll status

A new **`payrollStatus`**: **`ELIGIBLE`** (default) · **`HOLD`**. ERP-owned, set by admin on
the payroll profile; not a mirror of ADP's payroll status. **`HOLD` excludes the employee from
the weekly worklist build and from the ADP export**; if labor exists for a held employee in
the week, the week carries a visible issue `EMPLOYEE_ON_PAYROLL_HOLD` so hours are never
silently dropped. This is a worklist filter in `apps/api/src/usecase/payroll`, not a pricing
rule — `packages/payroll-engine` is untouched. Recorded in `payroll-rules-provenance.md` as a
scoping rule with this note as its source.

## Q4 — Compensation Type vs Payroll Group / Pay Type; backfill

**Compensation Type is the source; `payType` and `payrollGroup` are derived from it.**

- `payType` = `SALARY` for `SALARIED`, `HOURLY` otherwise. It leaves the form.
- `payrollGroup`: `SALARIED` → `NON_UNION_SALARY`; `HOURLY_NON_CRAFT` → `NON_UNION_HOURLY`;
  `CRAFT_HOURLY` → today's craft derivation (`SYS*` → SYS, MECHANIC → L12_MECHANIC, UNION →
  L12_FIELD, else NON_UNION_HOURLY). `derivePayrollGroup` gains a `compensationType` input
  and short-circuits on the first two.
- The **manual `payrollGroup` override survives** (Q7) and still wins when set explicitly.

**Backfill by migration, one pass, all rows including drafts:** `payType` contains `SALARY`
→ `SALARIED`; else a PRIMARY craft assignment exists → `CRAFT_HOURLY`; else `HOURLY_NON_CRAFT`.
The column is then **required** (`NOT NULL`) on `employees`. Rows the rule misclassifies are
corrected by editing the employee; the activity log records the correction.

## Q5 — The field-Employee-Type craft rule

**Compensation Type governs. The type-based rule (`2d3eca09a`, `isFieldEmployeeTypeName`) is
retired** as a hard check: a field Employee Type (Operator, Oiler, Rigger…) **defaults**
Compensation Type to *Craft-Based Hourly* on the form, and the user may change it. A primary
craft is required iff the type is `CRAFT_HOURLY`. `GET /craft-assignments/missing-primary`
lists only `CRAFT_HOURLY` employees. `FIELD_EMPLOYEE_TYPE_NAMES` stays in `@tcg/shared` for
the default. `SCRUM-926` REQ-07's "every employee" is narrowed to craft-based employees by
this note; REQ-27 (temps require a craft) holds for craft-based temps.

## Q6 — Over-scale shape

**One amount, dollars per hour, added to the straight-time base rate before the OT/DT
multipliers** — the same "into the rate, multiplied" model
`2026-09-10-craft-adders-are-into-the-rate-multiplied.md` settled for craft adders. FCC's
Over Scale OT / DB are derivable under that model and are not stored; the *Minimum Rate*
flag is not adopted. **This ticket stores and displays `overScaleRate`; pricing with it is
`SCRUM-928`'s**, with its own provenance entry.

## Q7 — Custom payroll exceptions; secondary-craft approval

**Custom payroll exceptions = the manual Payroll Group override (structured) plus a free-text
`payrollExceptionNote`** shown on the payroll profile and on the employee's payroll-week card.
The override is the mechanism `payroll/gaps.md` → *The union-classified employee who must not
be paid on union rules* needs (a union craft on `NON_UNION_HOURLY`, warned not blocked). No
flag set is invented.

**A secondary craft's "approval" is the assignment row itself**: `assignedById` (the admin
saving it) plus **`reason`, which becomes required for SECONDARY rows**. No certification
check.

## Q8 — Salary frequency

**Salary frequency is `payCycle`.** No new column. For `SALARIED` the field is shown as
*Salary Frequency*, required, over **Weekly · Bi-Weekly · Semi-Monthly · Monthly**; for the
two hourly types *Pay Cycle* stays optional under the payroll section's *Advanced* disclosure
with today's six values. Existing `QUARTERLY` / `DAILY` values on salaried rows are shown as
the stored value and must be changed on the next save.

## Q9 — Union status for Salaried and Hourly Non-Craft

**Selected, optional, informational.** The existing union-code picker is shown for both
types; a salaried employee may be recorded as union (the document's ask), and **nothing
prices, reports or exports from it in this ticket**. `resolvedUnionKind` is the primary
craft's union kind for `CRAFT_HOURLY` and the picked union code's kind otherwise (null when
none). The `UNION_STATUS_DISAGREES_WITH_CRAFT` warning is retired for craft-based employees
(it can no longer disagree).

## Q10 — The nineteen unhoused fields

**Nothing is dropped** — they are migrated FCC data and the migration cut is still open.
Homes:

| Section | Fields |
| --- | --- |
| Basic Information | SMS opt-in (beside Work cell phone, which it consents) |
| Employee Status | Termination Date · Termination Reason · Rehire Date |
| **Employment Details** (a permanent eighth section, between Employee Status and Payroll Profile) | Yard · Type · Classification · Work Comp · Standard Burden Code · Supervisor · Certified Pay · Rank · Unit |
| Payroll Profile → *Advanced* disclosure (all types) | Pay Cycle (hourly types only — see Q8) · Pay Rate OT · Pay Rate DB · Billing Rate · Billing Rate OT · Billing Rate DB · Payroll Exported · Payroll Group override (Q7) |
| Detail page tab, unchanged | Notes |

`payType` leaves the UI (derived, Q4).

## Q11 — Custom subsistence / on-call

**Two optional per-employee daily overrides — `subsistenceShortOverride`,
`subsistenceLongOverride` (money, 2 dp) — and a free-text `subsistenceAgreementNote`.** When
set, the override replaces the standard daily amount ($85 / $200) for that employee; the
short/long trigger stays job-level (the 2026-09-01 decision). **Stored and displayed only;
the engine's subsistence step is not changed here** — that is a `PAY-###` provenance change.
"On-call" is **not built**: it appears nowhere in the vault and no one at TCG has asked for it.

## Q12 — Changing Compensation Type on an existing employee

**Hide, never clear, never block.** The previous type's values (craft assignments, over-scale,
hourly rate, salary fields) stay on the row and are not rendered; the API ignores fields that
do not belong to the submitted type. The change itself is written to the activity log
(`compensationType` joins the tracked field set), which is the history — no effective date
on the switch, consistent with `SCRUM-926`'s undated craft assignments.

## Q13 — Temporary employees

**The same sectioned page minus Managed Assets**, `employeeStatus = TEMPORARY`, *Temp
Employee ID* label — today's one-flag `variant`. Temps get the full payroll profile; a
craft-based temp needs a primary craft (`SCRUM-926` REQ-27).

## Q14 — Salary earning code / payroll export mapping on the employee

**Not on the employee.** Earning-code and export mapping belong to the export configuration
(the document's own §H); the employee carries only the ADP file number. The two "earning
code / export mapping" bullets in §6–7 of the document are dropped from the profile.

## Effect on the build

- `employees` gains `compensation_type` (required after backfill), `payroll_status`,
  `salary_amount`, `salary_effective_from/to`, `hourly_rate_effective_from/to`,
  `over_scale_rate`, `payroll_exception_note`, `subsistence_short_override`,
  `subsistence_long_override`, `subsistence_agreement_note`; `status` gains `ON_LEAVE` and
  `PENDING_ONBOARDING`; `terminated` becomes derived.
- `@tcg/shared`: `CompensationType`, `PayrollStatus`, `EMPLOYEE_STATUSES`,
  `SALARY_FREQUENCY_OPTIONS`; `derivePayrollGroup(compensationType, …)`;
  `payrollSetupWarnings` drops `UNION_STATUS_DISAGREES_WITH_CRAFT` for craft-based input.
- `packages/payroll-engine` is **not** changed. The worklist filter for `HOLD` and
  `PENDING_ONBOARDING` / `INACTIVE` / `TERMINATED` lives in `apps/api/src/usecase/payroll`.

## What this does not settle

- Whether TCG agrees. Each answer names the person who would overrule it; the questions
  stay readable in `SCRUM-EMPLOYEE-PROFILE/spec.md` §12 with `resolved — see` pointing here.
- Pricing with over-scale, salary amount, hourly-rate effective dates or the subsistence
  overrides — `SCRUM-928`, `PAY-013`, `PAY-068` and the subsistence rule respectively, each
  with its own provenance entry.
- The vault's own open items this bears on and does not close: `payroll/gaps.md` →
  *Employee-module rules the E2E suite asserts…* item (e) (the finalize required set is now
  compensation-driven, still unratified), → *The union-classified employee…* (the override
  is kept, the client's preferred model is still unknown), → *Field role vs portal role*
  (untouched — Department, Role and Employee Type stay as they are by the same session's
  instruction).
