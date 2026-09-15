# Spec — SCRUM-EMPLOYEE-PROFILE Employee Profile

> Written to `.ai/aidlc/SCRUM-EMPLOYEE-PROFILE/spec.md` from `intent.md` beside it, following
> `.ai/aidlc/agents/inception/tcg-elaborator.md`. The ask is the staged document
> `employee-profile-feature.md` in this folder (cited below as `EPF §n`, kind: jira,
> `[UNVERIFIED]` — `source_count: 0`, it cites nothing itself) plus four session instructions
> from Syed Haris on 2026-09-15, quoted in `intent.md` §3.
>
> **Revision 2 (2026-09-15).** The fourteen questions the first pass raised were answered the
> same day by developer decision —
> `decisions/2026-09-15-employee-profile-compensation-type-and-statuses.md` (`status:
> reference`, cited below as **DEC-0915**). Every former `[OPEN]` block now carries that
> decision as its source and is `[UNVERIFIED]`; §12 keeps each question with `resolved — see`.
>
> **This is a brownfield ticket.** `Employee`, `EmployeeCraftAssignment`, `CraftCode`,
> `Department`, `DepartmentRole`, `EmployeeType`, `EmployeeAsset`, `EmergencyContact`,
> `Attachment` and a five-tab employee form all ship today. Every requirement below changes
> something that works; §11a lists what.

## Reading guide

| Marker | Means |
| --- | --- |
| `[UNVERIFIED]` | Sourced, but no TCG human adjudicated the source. **Every requirement here.** |
| `NOT SPECIFIED` | No source says anything; the executor does not fill it. |

Source kinds: `vault` (root-relative path), `jira` (`EPF §n`, session instruction, `SCRUM-###`),
`code` (`apps/…` — what ships today, never what should), `decision`
(`.ai/vault/decisions/…`), `rule` (`.ai/claude/contexts/…`).

---

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-EMPLOYEE-PROFILE` — placeholder, no Jira id yet |
| Intent | `.ai/aidlc/SCRUM-EMPLOYEE-PROFILE/intent.md`, captured `2026-09-15` |
| Elaborated on | `2026-09-15`; revised `2026-09-15` after DEC-0915 |
| Vault state at elaboration | `payroll/` module; six `domain/` files verified; `payroll/gaps.md` → *Employee-module rules the E2E suite asserts with no written source — PR #488* states *"The vault has no product specification for the ERP's employee-module CRUD at all"* |
| Open questions raised by this spec | **14 — all resolved**, see §12 (`decisions/2026-09-15-employee-profile-compensation-type-and-statuses.md`) |
| Already-shipped behaviour reached | 33 consumers in §11a; 0 with no source for what happens to them |
| Rules consulted | `.ai/claude/contexts/web.md` (Forms, Dropdowns, Multi-select, Test IDs), `api.md`, `prisma.md`, `payroll-engine.md` |
| Session instructions applied | (1) *"all of this will be in main"* → one ticket, whole document; (2) sections styled like the agency form, conditional flow spec'd; (3) Department, Role, Employee Type unchanged; (4) *"no need to write e2es, skip those"*; (5) *"use your best judgment to answer all these"* → DEC-0915 |

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | One-page form of accent-header `SectionCard`s replaces the tabbed wizard | web | `[UNVERIFIED]` | instruction 2, `decisions/2026-09-15-agency-creation-form-final-fields.md`, code | no |
| REQ-02 | Section set and order — eight sections | web | `[UNVERIFIED]` | `EPF §Final Model`, DEC-0915 Q10 | no |
| REQ-03 | Basic Information fields | web / api | `[UNVERIFIED]` | `EPF §1`, `payroll/fcc-employee-master-reference-data.md` | no |
| REQ-04 | SSN masked for non-admin readers, at the API | web / api | `[UNVERIFIED]` | `EPF §1`, DEC-0915 Q1 | no |
| REQ-05 | Department, Role, Employee Type unchanged; "operational role" = Employee Type | web / api | `[UNVERIFIED]` | instruction 3, `EPF §2` | no |
| REQ-06 | Employee status vocabulary and gates | schema / api / web | `[UNVERIFIED]` | `EPF §3`, DEC-0915 Q2, `decisions/2026-06-30` | no |
| REQ-07 | Payroll status — `ELIGIBLE` / `HOLD` | schema / api / web | `[UNVERIFIED]` | `EPF §3`, DEC-0915 Q3 | no |
| REQ-08 | Compensation Type selects the payroll profile | schema / api / web / shared | `[UNVERIFIED]` | `EPF §4`, `payroll/INDEX.md`, `PAY-009` | no |
| REQ-09 | Compensation Type drives Pay Type and Payroll Group; backfill | schema / api / shared | `[UNVERIFIED]` | DEC-0915 Q4 | no |
| REQ-10 | Craft-Based Hourly profile — conditional field set | web / api | `[UNVERIFIED]` | `EPF §5`, `decisions/2026-08-20`, `decisions/2026-08-25`, `SCRUM-926` REQ-07/08, DEC-0915 Q5 | no |
| REQ-11 | Salaried profile — conditional field set | schema / web / api | `[UNVERIFIED]` | `EPF §6`, `PAY-013`, DEC-0915 Q8/Q14 | no |
| REQ-12 | Hourly Non-Craft profile — conditional field set | web / api | `[UNVERIFIED]` | `EPF §7`, `PAY-012`, `decisions/2026-08-25`, DEC-0915 Q14 | no |
| REQ-13 | Over-scale on the employee payroll profile | schema / api / web | `[UNVERIFIED]` | `EPF §10`, `payroll/gaps.md`, FCC master, DEC-0915 Q6 | no |
| REQ-14 | Primary craft eligibility follows the operational role | web / api | `[UNVERIFIED]` | `EPF §8`, code | no |
| REQ-15 | Secondary crafts on the profile, reason required | web / api | `[UNVERIFIED]` | `EPF §9`, `SCRUM-926` REQ-08, `decisions/2026-08-20`, DEC-0915 Q7 | no |
| REQ-16 | Union status derived from the primary craft, shown on the profile | web / api | `[UNVERIFIED]` | `EPF §11`, `decisions/2026-08-25`, `PAY-009` | no |
| REQ-17 | Union status for Salaried / Hourly Non-Craft — selected, informational | api / web | `[UNVERIFIED]` | `EPF §11`, DEC-0915 Q9 | no |
| REQ-18 | Custom payroll exceptions — group override + note | schema / api / web | `[UNVERIFIED]` | `EPF §5–7`, `payroll/gaps.md`, DEC-0915 Q7 | no |
| REQ-19 | Custom subsistence overrides | schema / api / web | `[UNVERIFIED]` | `EPF §5`, `decisions/2026-09-01`, DEC-0915 Q11 | no |
| REQ-20 | Changing Compensation Type — hide, never clear | api / web | `[UNVERIFIED]` | DEC-0915 Q12 | no |
| REQ-21 | Managed Assets section | web | `[UNVERIFIED]` | `EPF §12`, code | no |
| REQ-22 | Emergency Contact section | web | `[UNVERIFIED]` | `EPF §1`, code | no |
| REQ-23 | Attachments & Certifications section | web | `[UNVERIFIED]` | `EPF §13`, code | no |
| REQ-24 | Detail page mirrors the sections | web | `[UNVERIFIED]` | `EPF §Purpose`, `EPF §Final Model` | no |
| REQ-25 | Employment Details section and the *Advanced* disclosure — nothing dropped | schema / api / web | `[UNVERIFIED]` | DEC-0915 Q10 | no |
| REQ-26 | Employee ID manual or auto-generated | api / web | `[UNVERIFIED]` | `EPF §1`, code | no |
| REQ-27 | Salary frequency is Pay Cycle | shared / web | `[UNVERIFIED]` | DEC-0915 Q8 | no |
| REQ-28 | Temporary-employee variant — same page minus Managed Assets | web | `[UNVERIFIED]` | DEC-0915 Q13, `SCRUM-926` REQ-27 | no |
| REQ-29 | Failed submit focuses the first invalid field across sections | web | `[UNVERIFIED]` | rule `web.md` → Forms | no |
| REQ-30 | Test IDs on every new control; surviving IDs kept | web | `[UNVERIFIED]` | rule `web.md` → Test IDs | no |
| REQ-31 | Employee and payroll status gate the payroll worklist | api | `[UNVERIFIED]` | DEC-0915 Q2/Q3 | no |

Counts: `31` total — `0` verified, `31` unverified, `0` conflicted, `0` open.

**Self-check (elaborator §1):** sources cited behind requirements — 38 vault/jira/decision,
15 `apps/…`. Code is cited descriptively and for ripple, never as sole support.

## 2. Requirements

### REQ-01 — One-page form of accent-header `SectionCard`s replaces the tabbed wizard `[UNVERIFIED]`

- **Statement:** The employee create and edit screens are one scrolling page of sections, each
  a `SectionCard` with the in-card accent header (icon tile, tinted gradient header bar,
  left accent rail — `heading={false}` + `icon`), exactly as the agency form renders its
  sections; the Main / Additional Info / Managed Assets / Notes / Attachments tab stepper is
  removed.
- **Surface:** web
- **Sources:**
  - Session instruction 2 (Syed Haris, 2026-09-15) — `[UNVERIFIED]` — kind: jira — *"The
    section separation will be like in agency with blue backgroung"*.
  - `decisions/2026-09-15-agency-creation-form-final-fields.md` — `[UNVERIFIED]` (`status:
    reference`) — kind: decision — the agency form this instruction points at; §*Effect on
    the build* names PR `feat/agency-form-rework`.
  - `apps/web/src/features/agencies/views/agency-form.tsx:441-503` — kind: code — `PageHero`
    then `SectionCard heading={false} icon={…} title="…"` per section, `WorkspaceFooterBar`
    with `SaveStateIndicator`, `UnsavedChangesDialog`.
  - `apps/web/src/components/patterns/section-card.tsx:64-160` — kind: code — the "blue
    background" is the header gradient from `--color-ws-accent` plus the accent icon tile;
    nothing hardcoded.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** `apps/web/src/features/employees/components/create/create-employee.tsx` (tab
  state, `resolveInitialEmployeeTab`, `findEmployeeTabForErrors`, `requestValidationFocus`),
  `create-employee-actions.tsx` (`employee-wizard-*`), `create-employee-form-section.tsx`,
  `create-employee-additional-info-tab.tsx`, `create-employee-managed-assets-tab.tsx`,
  `create-employee-attachments-tab.tsx`, `create-employee-validation-focus.ts`;
  `views/employees.tsx:23-53` (tab ↔ route via `useUrlTab`); `qa-automation` addresses the
  wizard IDs — §11a, instruction 4. Enumerated by `git grep -n 'employee-wizard-' apps/web qa-automation`.
- **Acceptance:** `/employees/create` and `/employees/<code>/edit` render every section of
  REQ-02 on one page with no tab strip; each section header shows the icon tile and the
  accent gradient; the footer bar carries Cancel, Save as Draft (create only, as today) and
  the primary action (`getWizardFinalActionLabel(mode, 'Employee')`) plus the dirty
  indicator; leaving a dirty form prompts `UnsavedChangesDialog`; create lands on the new
  employee's detail page (`decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md`).
- **Notes for the executor:** reuse `AgencyForm`'s skeleton (`FormProvider`, `useForm` with
  `formZodResolver`, `mode: 'onBlur'`, `useSubmitPipeline`, `useUnsavedChangesGuard`,
  `createRhfSaveFromLeave`, `abortIfNoFormChanges`). Do not port the wizard's per-tab
  validation routing — REQ-29 replaces it. Keep `create-employee-archived-conflict.ts` and
  `EntityProfilePictureSection`. Colours only from `theme.css` variables.

### REQ-02 — Section set and order — eight sections `[UNVERIFIED]`

- **Statement:** The profile has these sections, in this order, on both the form and the
  detail page: **Basic Information · Department & Role · Employee Status · Employment Details
  · Payroll Profile · Managed Assets · Emergency Contact · Attachments & Certifications.**
- **Surface:** web
- **Sources:**
  - `EPF §Final Model` — `[UNVERIFIED]` — kind: jira — *"Basic information / Department /
    Operational role / Employee status / Payroll profile (…) / Managed assets / Emergency
    contact / Attachments/certifications"*.
  - `EPF §1` — `[UNVERIFIED]` — kind: jira — lists Department, Operational role, Employee
    status, Address and Emergency contact *inside* Basic Information. **Read as: §Final Model
    gives the sections; §1 gives the fields.** Address stays inside Basic Information.
  - DEC-0915 Q10 — `[UNVERIFIED]` — kind: decision — *Employment Details* is *"a permanent
    eighth section, between Employee Status and Payroll Profile"* for the migrated FCC
    fields EPF does not mention.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** today's grouping — `create-employee-main-tab.tsx:47-110`,
  `create-employee.tsx:151-168`; detail tabs `employee-detail-body.tsx:112-122`. Notes stays a
  detail-page tab (DEC-0915 Q10).
- **Acceptance:** the eight sections appear in that order with distinct icons; the payroll
  section's body changes with Compensation Type (REQ-08).
- **Notes for the executor:** titles verbatim as above. Icons `NOT SPECIFIED` — pick from the
  `@untitledui/icons` set the agency form and asset workspace use.

### REQ-03 — Basic Information fields `[UNVERIFIED]`

- **Statement:** Basic Information holds: profile picture · Employee ID · First name · Middle
  name · Last name · Work cell phone · SMS opt-in · Personal cell phone · Home phone · Email ·
  Date of birth · SSN · Hiring date · Joining date · Address (street, street 2, city, state,
  ZIP, country, phone). Required: first name, last name, email, work cell phone (as today).
- **Surface:** web / api
- **Sources:**
  - `EPF §1` — `[UNVERIFIED]` — kind: jira — the field list, minus the items §Final Model
    makes sections.
  - `payroll/fcc-employee-master-reference-data.md` §*The Employees window* — `[UNVERIFIED]`
    — kind: vault — FCC's Main tab carries the same identity set.
  - DEC-0915 Q10 — `[UNVERIFIED]` — kind: decision — SMS opt-in sits beside Work cell phone.
  - `apps/api/src/presentation/employee/dto/create-employee.dto.ts:79-195` — kind: code —
    every field exists; `workCellPhone` `@IsNotEmpty` (*"becomes the mobile login
    identifier"*); `email` `@IsEmail`.
  - `sections/personal-information-fields.tsx`, `contact-details-fields.tsx`,
    `employee-sms-opt-in-field.tsx` — kind: code — the controls to move.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** `packages/shared/src/types/employee.types.ts`; uniqueness of email / work cell /
  employee ID per tenant and archive-does-not-free are shipped, unsourced
  (`payroll/gaps.md` → PR #488 (b)) and **unchanged**.
- **Acceptance:** all listed fields render in a 4-column grid on desktop, 1-column at phone
  width; four required markers as today; `AddressSection` with `isRequired={false}`; save
  round-trips every field.
- **Notes for the executor:** move `PersonalInformationFields` (minus Department / Role /
  Employee Type / Union Status), `ContactDetailsFields`, the SMS field and `AddressSection`
  into `EmployeeBasicInformationSection`. Do not re-implement the inputs.

### REQ-04 — SSN masked for non-admin readers, at the API `[UNVERIFIED]`

- **Statement:** The API returns the full SSN only to `Role.ADMIN` / `SUPER_ADMIN`; every
  other reader receives `***-**-1234` (last four) on the list, detail and temp-employee list.
  The form's `SsnField` behaves as today (9 digits, optional) and is editable by admins only
  (writes are already admin-gated). No new permission is created. Seeds write dummy SSNs;
  nothing validates "realness".
- **Surface:** web / api
- **Sources:**
  - `EPF §1` — `[UNVERIFIED]` — kind: jira — *"SSN, masked and permission controlled"*; *"SSN
    should be optional or dummy-only in UAT/demo tenants."*
  - DEC-0915 Q1 — `[UNVERIFIED]` — kind: decision — full SSN to admin only, masked at the
    API; no new permission because the module-permission layer is unbuilt (`admin/gaps.md` →
    *Departments, roles and their capabilities*); "dummy-only" is seeder guidance.
  - `decisions/2026-06-30-adp-erp-employee-data-ownership.md` — `[VERIFIED]` — kind: decision
    — SSN is ADP-owned; the ERP copy is a convenience.
  - `apps/api/src/utility/employee-ssn.util.ts:13-17` — kind: code — `maskSsnForLog` already
    produces `***-**-####`; reuse it for the response.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** `GET /employee` list (`query-employee-list.dto.ts:91,104` sortable `ssn` — sort
  stays server-side, value masked), `GET /employee/:code`, temp list SSN column
  (`employee-list-columns.tsx:185-227`), `formatSsnDisplay`, `SsnField`. The web must not
  round-trip a masked value into an update: **the edit form leaves `ssn` untouched unless the
  user changes it** (send `undefined`, not the masked string). Enumerated by
  `git grep -n -i ssn apps/api/src/presentation/employee apps/web/src/features/employees`.
- **Acceptance:** a `USER`-role session sees `***-**-1234` on list and detail; an `ADMIN`
  session sees the full value; saving the edit form as admin without touching SSN leaves
  the stored SSN unchanged; the seeders write `000-00-00nn`-style values.
- **Notes for the executor:** mask in `EmployeeService` response mapping using
  `@GetCurrentUser()`'s role; the DTO for update treats a value matching `^\*{3}-\*{2}-\d{4}$`
  as "unchanged" defensively.

### REQ-05 — Department, Role, Employee Type unchanged; "operational role" = Employee Type `[UNVERIFIED]`

- **Statement:** The *Department & Role* section holds today's three fields exactly as they
  are — Department (`DepartmentSelect`), Role (`RoleSelect`, filtered by department) and
  Employee Type (`EmployeeTypeSelect`). Where EPF says "operational role", this ticket reads
  **Employee Type**. No field is added, renamed, merged or made required. Employee Type
  additionally **defaults** Compensation Type (REQ-10).
- **Surface:** web / api
- **Sources:**
  - Session instruction 3 — `[UNVERIFIED]` — kind: jira — *"keep department role and employee
    type the same as we've now"*.
  - `EPF §2` — `[UNVERIFIED]` — kind: jira — *"Department and operational role are employee/org
    configuration, not payroll configuration."* The examples are EmployeeType-shaped.
  - `payroll/gaps.md` → *Field role vs portal role* — `[UNVERIFIED]` — kind: vault — three
    representations; *"Still needs the client."* Not answered here.
  - `employee-selects/index.tsx`, `create-employee-main-tab-fields.tsx:15-45` — kind: code.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** `DepartmentRole` behaviour settings (migration
  `20260904153222_role_as_employee_type_settings`, *"nothing reads them yet"*) not advanced.
  Name-based consumers (mobile persona, approval routing, salesperson filter, DAS cards)
  unchanged. Enumerated by `git grep -n -E "employeeTypeName|departmentRoleName|usedAsEmployeeType" apps packages`.
- **Acceptance:** the three pickers behave as today with the same test IDs
  (`employee-department-select`, `employees-role`, `employees-main-employee-type`).
- **Notes for the executor:** a move. Label stays *"Employee Type"*.

### REQ-06 — Employee status vocabulary and gates `[UNVERIFIED]`

- **Statement:** `Employee.status` takes `ACTIVE` · `INACTIVE` · `ON_LEAVE` · `TERMINATED` ·
  `PENDING_ONBOARDING`, plus the internal pre-finalize `DRAFT` (one-way, as today). The
  *Employee Status* section shows: Status (picklist over the five), Termination Date
  (required when `TERMINATED`), Termination Reason (optional, ≤ 400 plain chars as today),
  Rehire Date, and the read-only Permanent/Temporary badge. The `terminated` column becomes
  derived (`status === 'TERMINATED'`) and leaves the form. Gates:

  | Status | Assignable (DAS, pickers, `resolveAssignableEmployeeId`) | Portal invite | Payroll worklist (REQ-31) |
  | --- | --- | --- | --- |
  | `ACTIVE` | yes | yes | included |
  | `ON_LEAVE` | visible, not assignable | yes | included |
  | `PENDING_ONBOARDING` | not assignable | yes | excluded |
  | `INACTIVE` | no; hidden from default pickers | no | excluded |
  | `TERMINATED` | no; hidden from default pickers | no (revoked) | excluded |
- **Surface:** schema / api / web
- **Sources:**
  - `EPF §3` — `[UNVERIFIED]` — kind: jira — the five statuses; *"Employee status is different
    from payroll status."*
  - DEC-0915 Q2 — `[UNVERIFIED]` — kind: decision — the vocabulary, the gate table, `terminated`
    superseded, `employeeStatus` untouched.
  - `decisions/2026-06-30-adp-erp-employee-data-ownership.md` — `[VERIFIED]` — kind: decision
    — *"the ERP treats the employee as pending and blocks scheduling, equipment assignment and
    job allocation"* — the meaning of `PENDING_ONBOARDING`.
  - `dispatch/daily-allocation-system.md` §*Employee & Asset Availability Management* —
    `[UNVERIFIED]` — kind: vault — on-leave employees *"greyed out with a 'Leave' tag; they
    remain visible but non-assignable."*
  - `payroll/fcc-employee-master-reference-data.md` §7 — `[UNVERIFIED]` — kind: vault — FCC
    Terminated ☐ + Term Date/Reason + Rehire Date; Term fields optional there.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** list filter `employee-list.helpers.ts:14,96-111` (INACTIVE = not DRAFT/ACTIVE —
  **change**: each value is its own filter; the *Inactive* view shows `INACTIVE` only; new
  views are `NOT SPECIFIED`, none added), `EmployeeSelect` default `status = ACTIVE`
  (unchanged), `resolveAssignableEmployeeId` (unchanged: ACTIVE only), DAS availability
  (`das.repository.ts` — treats non-ACTIVE as unavailable; `ON_LEAVE` gets the existing
  Leave tag), status toggle `use-employee-status-controls.ts:19-33` (stays Active ↔ Inactive;
  a row in any other status renders the switch disabled with the status label), draft pill,
  finalize rule `employee.service.ts:726-729`. `terminated` readers:
  `employment-details-fields.tsx:40-134`, detail `:185-193`, `create-employee-form.ts:85`.
  Portal invite revoke on `TERMINATED`: `employee.controller.ts:207` path, reused.
  Enumerated by `git grep -n -E "'ACTIVE'|'INACTIVE'|'DRAFT'|terminated" apps/api/src/usecase/employee apps/api/src/service/das apps/web/src/features/employees`.
- **Acceptance:** setting `TERMINATED` without a termination date fails on that field
  (today's message); saving `TERMINATED` writes `terminated = true` and revokes a pending
  invite; a `PENDING_ONBOARDING` employee is absent from `EmployeeSelect` and from DAS
  drag sources; an `ON_LEAVE` employee is visible in DAS with the Leave tag and cannot be
  dropped on a slot; the list switch is disabled for `ON_LEAVE`/`TERMINATED`/`PENDING_ONBOARDING`.
- **Notes for the executor:** `EMPLOYEE_STATUSES` + labels in `@tcg/shared`; the API DTO
  changes `status` from free `@IsString` to `@IsIn(EMPLOYEE_STATUSES)` (plus `DRAFT` on
  create). Migration: `UPDATE employees SET status = 'TERMINATED' WHERE terminated = true`.

### REQ-07 — Payroll status — `ELIGIBLE` / `HOLD` `[UNVERIFIED]`

- **Statement:** Every payroll profile carries **Payroll status**: `ELIGIBLE` (default) or
  `HOLD`. `HOLD` excludes the employee from the weekly worklist build and from the ADP
  export; a held employee with labor in the week raises the issue
  `EMPLOYEE_ON_PAYROLL_HOLD` on that week (REQ-31). Admin-set, ERP-owned.
- **Surface:** schema / api / web
- **Sources:**
  - `EPF §3, §5–7` — `[UNVERIFIED]` — kind: jira — *"Payroll status = Hold payroll"* example;
    the field on every profile.
  - DEC-0915 Q3 — `[UNVERIFIED]` — kind: decision — the two values, the worklist/export
    exclusion, the issue, ERP ownership; *"a worklist filter… not a pricing rule"*.
  - `payroll/gaps.md` → *The union-classified employee who must not be paid on union rules*
    — `[UNVERIFIED]` — kind: vault — the legacy per-employee exclusion table
    `cfg.PayrollUI_ExcludedEmpID` with a reason — the precedent.
  - `packages/payroll-engine/src/calculate.ts:978,996` — kind: code — today's exclusions are
    `SYS` group and missing ADP number only.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** `apps/api/src/usecase/payroll/payroll.service.ts:806-918` (worklist build — the
  filter goes here), `payroll-export.ts` / `xlsx-rows.ts` (export skip), payroll-week overlay
  cards (show the hold). `packages/payroll-engine` **untouched**. Provenance entry in
  `payroll/payroll-rules-provenance.md` citing DEC-0915 (scoping rule, same commit —
  `contexts/payroll-engine.md`).
- **Acceptance:** a `HOLD` employee with job-ticket labor in the week does not appear in the
  worklist and the week carries `EMPLOYEE_ON_PAYROLL_HOLD`; flipping back to `ELIGIBLE` and
  recalculating includes them; the ADP CSV omits held employees.
- **Notes for the executor:** enum `PayrollStatus { ELIGIBLE, HOLD }` in shared and Prisma,
  column `payroll_status` default `ELIGIBLE`. The picklist is a two-option `NativeSelect`.

### REQ-08 — Compensation Type selects the payroll profile `[UNVERIFIED]`

- **Statement:** Every employee carries a **Compensation Type** — *Craft-Based Hourly*,
  *Hourly Non-Craft*, *Salaried* — required on a finalized employee, chosen at the top of the
  Payroll Profile. The fields shown, required and saved below it are that type's set
  (REQ-10/11/12); other types' fields are not rendered. Employee Type **defaults** it on
  create: a field/shop type (`FIELD_EMPLOYEE_TYPE_NAMES`) → Craft-Based Hourly, anything else
  → Hourly Non-Craft; the user may change it.
- **Surface:** schema / api / web / shared
- **Sources:**
  - `EPF §4` — `[UNVERIFIED]` — kind: jira — *"The fields shown in the Payroll Profile depend
    on the employee's compensation type."* The three values and their definitions.
  - `payroll/INDEX.md` → *The spine of the domain* — `[UNVERIFIED]` — kind: vault — five
    Payroll Groups; rule applicability *"not settled."*
  - `payroll/rules/PAY-009-payroll-group-classification.md` — `[UNVERIFIED]` (`status: open`)
    — kind: vault — group as a predicate over craft prefix, `EmpTypeID`, `PayType`.
  - `payroll/gaps.md` → *Payroll has three populations…* — `[UNVERIFIED]` — kind: vault —
    Brian Petros 2026-09-10: job tickets (union field), work orders (non-union hourly and
    union mechanics), salaried.
  - DEC-0915 Q4/Q5 — `[UNVERIFIED]` — kind: decision — Compensation Type is the source; the
    field-type default.
- **Conflict:** none — the axis mismatch the first pass noted is resolved by REQ-09.
- **Open question:** none.
- **Ripple:** REQ-09. `payrollSetupWarnings` takes `payType` → now derived (REQ-09).
  Enumerated by `git grep -n -E "derivePayrollGroup|payrollSetupWarnings" apps packages`.
- **Acceptance:** the control is the first field of the Payroll Profile, required on
  finalize, labels verbatim; changing it swaps the section body without losing Basic
  Information values; on create, picking an Oiler Employee Type pre-selects Craft-Based
  Hourly and the user can change it; `GET /employee/:code` returns it; the detail page shows it.
- **Notes for the executor:** enum `CompensationType { CRAFT_HOURLY, HOURLY_NON_CRAFT,
  SALARIED }` + `COMPENSATION_TYPE_LABELS` in `packages/shared/src/enums`, mirrored in Prisma.
  Static three-option `NativeSelect` (the `web.md` Dropdowns rule is about entity tables).

### REQ-09 — Compensation Type drives Pay Type and Payroll Group; backfill `[UNVERIFIED]`

- **Statement:** `payType` and `payrollGroup` are **derived** from Compensation Type on every
  save: `payType` = `SALARY` for `SALARIED`, else `HOURLY`; `payrollGroup` = `NON_UNION_SALARY`
  for `SALARIED`, `NON_UNION_HOURLY` for `HOURLY_NON_CRAFT`, and today's craft derivation for
  `CRAFT_HOURLY` (`SYS*` → SYS, MECHANIC → L12_MECHANIC, UNION → L12_FIELD, else
  NON_UNION_HOURLY). An explicit `payrollGroup` override (REQ-18) still wins. **Backfill by
  migration, all rows:** `payType ILIKE '%SALARY%'` → `SALARIED`; else a PRIMARY craft exists →
  `CRAFT_HOURLY`; else `HOURLY_NON_CRAFT`; then `compensation_type` is `NOT NULL`.
- **Surface:** schema / api / shared
- **Sources:**
  - DEC-0915 Q4 — `[UNVERIFIED]` — kind: decision — the derivation and the backfill rule,
    verbatim.
  - `packages/shared/src/utils/payroll-group.ts:14-30` — kind: code — today's derivation;
    gains a `compensationType` input that short-circuits the first two cases.
  - `apps/api/src/service/employee/employee.repository.ts:512-536` — kind: code —
    `syncPayrollGroup` reads the PRIMARY craft + `payType`; now also the compensation type.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** `payType` leaves the form (`payroll-fields.tsx`, `PAY_TYPE_OPTIONS`), the DTO
  keeps accepting it for API compatibility but the service overwrites it; payroll UI group
  filters, export column, worklist, `seed-payroll-demo.ts` — unchanged (they read
  `payrollGroup`). `payrollSetupWarnings` input `payType` is fed the derived value.
  Enumerated by `git grep -n -E "payType|PAY_TYPE_OPTIONS" apps packages`.
- **Acceptance:** saving a Salaried employee yields `payType = SALARY`, `payrollGroup =
  NON_UNION_SALARY`; saving a Craft-Based Hourly employee with an L12 UNION craft yields
  `L12_FIELD`; the migration leaves no null `compensation_type`; a row with `payType =
  'Salary'` (mixed case) backfills to `SALARIED`; a row with a manual `payrollGroup` keeps it.
- **Notes for the executor:** `derivePayrollGroup({ compensationType, craftCode, roleType,
  unionKind })` — drop the `payType` parameter once no caller needs it. The migration is SQL
  in the same migration folder as the column (`prisma.md` → Migrations).

### REQ-10 — Craft-Based Hourly profile — conditional field set `[UNVERIFIED]`

- **Statement:** When Compensation Type = *Craft-Based Hourly*, the Payroll Profile shows:
  Payroll status (REQ-07) · ADP file number · **Primary craft (required)** · Secondary crafts
  (REQ-15) · Union status, read-only, derived (REQ-16) · Payroll Group, read-only, derived ·
  Hourly rate **only when the primary craft's union kind is NON_UNION** (then warned-not-
  blocked when blank, as today) · Over-scale (REQ-13) · Custom subsistence overrides (REQ-19)
  · Payroll exception note (REQ-18) · the setup warnings (`PayrollSetupWarnings`) · the
  *Advanced* disclosure (REQ-25). Salary fields are never shown. The primary craft is required
  **because the type is Craft-Based Hourly**, not because of the Employee Type; the type-based
  hard check is retired.
- **Surface:** web / api
- **Sources:**
  - `EPF §5` — `[UNVERIFIED]` — kind: jira — the field list.
  - `EPF §4` — `[UNVERIFIED]` — kind: jira — *"payroll is driven by craft code, job ticket
    hours, role worked, craft modifiers, boom pay, subsistence, and payroll rules."*
  - `decisions/2026-08-20-craft-locked-rate-override.md` — `[VERIFIED]` — kind: decision —
    *"An employee's default base rate comes from their employee-level craft code."*
  - `decisions/2026-08-25-non-union-base-rate-per-person.md` — `[VERIFIED]` — kind: decision —
    UNION craft → `CraftCodeRate`; NON_UNION craft → `Employee.hourlyRate`.
  - `SCRUM-926/spec.md` REQ-07 — `[UNVERIFIED]` — kind: jira — exactly one PRIMARY craft,
    required on create/update; narrowed to craft-based employees by DEC-0915 Q5.
  - DEC-0915 Q5 — `[UNVERIFIED]` — kind: decision — *"Compensation Type governs. The
    type-based rule (`2d3eca09a`) is retired as a hard check"*; field types default the
    compensation type; the `missing-primary` report lists `CRAFT_HOURLY` only.
  - `apps/api/src/usecase/employee/employee.service.ts:346-356` — kind: code — the check to
    replace.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** `PayrollFields`, `EmploymentDetailsFields` (craft picker moves), `PayrollSetupWarnings`,
  `EmployeeCraftCard`, `assertCraftNotRequired` / `isFieldEmployeeTypeName` (API + web —
  replaced by the compensation check), `GET /craft-assignments/missing-primary` (filter on
  `compensationType = CRAFT_HOURLY`), `qa-automation` `validation.spec.ts:25-32` (the fifth
  required field is now conditional — instruction 4). Enumerated by
  `git grep -n -E 'isFieldEmployeeTypeName|primaryCraftCodeId|missing-primary' apps packages`.
- **Acceptance:** Craft-Based Hourly with no primary craft → submit fails on the craft field
  with *"Payroll craft is required"* and the API returns 400; a UNION craft hides Hourly
  rate and shows *Union — <code>*; a NON_UNION craft shows Hourly rate and the existing
  `NO_HOURLY_RATE_FOR_NON_UNION_CRAFT` warning when blank; Payroll Group displays the derived
  value; salary fields are absent from the DOM; a Rigger-type employee saved as Hourly
  Non-Craft with no craft is accepted; `missing-primary` no longer lists salaried employees.
- **Notes for the executor:** enforce the per-type required set in `EmployeeService` (create
  and update, DRAFT exempt). Keep `PayrollCraftCodeSelect` with the `roleType` filter
  (REQ-14). Delete `assertCraftNotRequired`; keep `FIELD_EMPLOYEE_TYPE_NAMES` for the
  default only.

### REQ-11 — Salaried profile — conditional field set `[UNVERIFIED]`

- **Statement:** When Compensation Type = *Salaried*, the Payroll Profile shows: Payroll
  status · ADP file number · **Salary amount (required)** · **Salary frequency (required —
  `payCycle`, REQ-27)** · Effective from · Effective to · Union status, selected (REQ-17) ·
  Payroll Group, read-only (`NON_UNION_SALARY`) · Hourly / Salary Rate, labelled *"Weekly
  amount payroll uses until PAY-013 is settled"* · Payroll exception note · *Advanced*. No
  craft, over-scale, subsistence or boom controls. No earning-code field (DEC-0915 Q14).
- **Surface:** schema / web / api
- **Sources:**
  - `EPF §6` — `[UNVERIFIED]` — kind: jira — the field list; *"Craft codes, craft modifiers,
    boom pay, and subsistence should not be required for salaried employees."*
  - `payroll/rules/PAY-013-non-union-salary-rate.md` — `[UNVERIFIED]` (`status: open`) — kind:
    vault — *"Requires: Salary/rate; pay frequency; effective date"*; *"how salary is paid
    remains unspecified"*; Corrina keys the SALARY batch by hand.
  - `payroll/non-union-hourly-rules-2026-09-07.md` §15 — `[UNVERIFIED]` — kind: vault — *"no
    boom/modifier calculations."*
  - DEC-0915 Q8 — `[UNVERIFIED]` — kind: decision — salary frequency is `payCycle`, four
    values. DEC-0915 Q14 — earning code not on the employee.
  - `packages/payroll-engine/src/calculate.ts:1218-1232` — kind: code — a `NON_UNION_SALARY`
    week takes `hourlyRate` as the weekly amount (`SALARY_AMOUNT_ASSUMED`); **this ticket adds
    the real field and does not rewire the engine** (`contexts/payroll-engine.md`).
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** `hourlyRate` stays writable on Salaried employees so existing salaried weeks
  keep pricing; `payCycle` picklist narrows for this type (REQ-27).
- **Acceptance:** with Salaried selected, craft picker, secondary rows, over-scale and
  subsistence inputs are absent from the DOM; submit without salary amount or frequency
  fails on those fields; salary amount is a non-negative decimal (2 dp); effective to ≥
  effective from when both set; a stale `primaryCraftCodeId` in the payload is ignored, not
  rejected (REQ-20).
- **Notes for the executor:** columns `salary_amount Decimal(12,2)`, `salary_effective_from`,
  `salary_effective_to` (`@db.Date`). Do not touch `packages/payroll-engine`.

### REQ-12 — Hourly Non-Craft profile — conditional field set `[UNVERIFIED]`

- **Statement:** When Compensation Type = *Hourly Non-Craft*, the Payroll Profile shows:
  Payroll status · ADP file number · **Hourly rate (required)** · Effective from · Effective
  to · Union status, selected (REQ-17) · Payroll Group, read-only (`NON_UNION_HOURLY`) · Payroll
  exception note · *Advanced*. No craft, over-scale, salary or subsistence fields. No export-
  mapping field (DEC-0915 Q14).
- **Surface:** web / api
- **Sources:**
  - `EPF §7` — `[UNVERIFIED]` — kind: jira — the field list; *"hourly employees whose payroll
    is not driven by craft code or boom/craft modifiers."*
  - `payroll/rules/PAY-012-non-union-hourly-rate.md` — `[UNVERIFIED]` (`status: open`) — kind:
    vault — *"Use employee-master hourly rate"*; blocking item *"Confirm rate-effective-date
    handling"*.
  - `decisions/2026-08-25-non-union-base-rate-per-person.md` — `[VERIFIED]` — kind: decision
    — `Employee.hourlyRate` *"at its current value, with no effective dating"* — dating scoped
    out of SCRUM-926, not decided against.
  - DEC-0915 Q14 — `[UNVERIFIED]` — kind: decision — export mapping is not an employee field.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** the craft-rate resolver (`craft-rate-resolver.service.ts:360-371`) prices
  `hourlyRate` only through a NON_UNION *craft*; an employee with no craft is `Blocked` at
  resolution today — **unchanged**, consistent with Brian's unbuilt "work orders" population.
  `missing-primary` no longer lists them (REQ-10).
- **Acceptance:** submit without hourly rate fails on that field; craft picker absent;
  `GET /employee/:code` returns `primaryCraftCodeId: null` without error; effective to ≥ from.
- **Notes for the executor:** `hourly_rate_effective_from` / `_to` are new nullable Date
  columns **stored for the record only** — comment on the column that nothing reads them.

### REQ-13 — Over-scale on the employee payroll profile `[UNVERIFIED]`

- **Statement:** A Craft-Based Hourly employee may carry **Over-scale** — one amount in
  dollars per hour, the employee-specific adder on top of the craft's straight-time rate,
  to be added before the OT/DT multipliers. This ticket **stores and displays** it; pricing
  with it is `SCRUM-928`'s. Shared craft rates are never modified for one employee.
- **Surface:** schema / api / web
- **Sources:**
  - `EPF §10` — `[UNVERIFIED]` — kind: jira — *"Final employee pay floor = craft rate +
    over-scale. Do not modify shared craft code rates…"*
  - `payroll/gaps.md` → *Pay rate follows the employee, not the role worked* — `[UNVERIFIED]`
    — kind: vault — Kyle Harlow 2026-08-13 asks for *"an over-scale box on the employee
    profile"*; `PAY-CC-02` AC 4–6 corroborate.
  - `payroll/fcc-employee-master-reference-data.md` §*The Employees window* — `[UNVERIFIED]` —
    kind: vault — FCC's Over Scale ST/OT/DB + Minimum Rate, in no rule.
  - DEC-0915 Q6 — `[UNVERIFIED]` — kind: decision — one `$/h` amount into the base rate before
    multipliers (the `2026-09-10-craft-adders-are-into-the-rate-multiplied.md` model); OT/DB
    not stored; Minimum Rate not adopted; pricing deferred to `SCRUM-928`.
  - `decisions/2026-08-20-craft-locked-rate-override.md` — `[VERIFIED]` — forbids a per-day
    dollar override; a standing per-employee adder is a different object.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** none today; `SCRUM-928` will read it with a provenance entry.
- **Acceptance:** renders only under Craft-Based Hourly; blank saves null; round-trips; shown
  on the detail page; **no payroll amount changes** when set (calculate a week before/after).
- **Notes for the executor:** `over_scale_rate Decimal(10,4)` nullable; label *"Over-scale
  ($/hour)"*.

### REQ-14 — Primary craft eligibility follows the operational role `[UNVERIFIED]`

- **Statement:** For a Craft-Based Hourly employee the primary craft picker lists only crafts
  whose `roleType` matches the craft role of the employee's Employee Type; the API rejects a
  primary craft whose `roleType` does not match when the Employee Type maps to a craft role.
  Employee Types with no craft role impose no filter.
- **Surface:** web / api
- **Sources:**
  - `EPF §8` — `[UNVERIFIED]` — kind: jira — *"the employee's primary craft code should match
    the employee's operational role… prevents an Oiler employee from accidentally receiving an
    Operator primary craft code."*
  - `EPF §C` — `[UNVERIFIED]` — kind: jira — eligibility rule verbatim.
  - `packages/shared/src/constants/employee-types.ts:83-136` — kind: code — the name link
    (`CRAFT_ROLE_TYPE_EMPLOYEE_TYPE_NAMES`, `craftRoleTypeForEmployeeTypeName`);
    `employment-details-fields.tsx:172-213` filters the picker. **The web filters; the API
    does not enforce.**
  - `payroll/gaps.md` → *Craft assignment has no history* — `[UNVERIFIED]` — kind: vault —
    FCC's labor craft disagrees with the employee craft on 27% of rows; recorded, not
    adjudicated.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** types outside the six `CraftRoleType` names see every active craft (kept).
  Existing mismatches: checked on the next save that changes craft or type — no report.
- **Acceptance:** an Oiler-type employee's picker lists no OPERATOR craft; `POST/PATCH` with an
  OPERATOR craft on an Oiler-type employee → 400 naming both; a Sales Admin-type employee can
  pick any craft; changing Employee Type to a mismatching one clears the craft client-side.
- **Notes for the executor:** check in `EmployeeService` beside the compensation check, using
  `craftRoleTypeForEmployeeTypeName`. No `roleType` column on `EmployeeType` (instruction 3).

### REQ-15 — Secondary crafts on the profile, reason required `[UNVERIFIED]`

- **Statement:** The Craft-Based Hourly profile lists SECONDARY craft assignments as repeat
  rows — craft picker (any `roleType`) + **reason (required)** — saved through the existing
  craft-assignment endpoints. Each row shows who assigned it and when. Approval *is* the row
  (`assignedById` + `reason`); no certification check.
- **Surface:** web / api
- **Sources:**
  - `EPF §9` — `[UNVERIFIED]` — kind: jira — *"Secondary craft codes may differ… only be
    allowed when the employee is qualified/approved to work that higher-paid role."*
  - `SCRUM-926/spec.md` REQ-08 — `[UNVERIFIED]` — kind: jira — allowed-alternate list, no pay
    effect, no dates.
  - `decisions/2026-08-20-craft-locked-rate-override.md` — `[VERIFIED]` — only the
    superintendent or payroll set the day's craft.
  - DEC-0915 Q7 — `[UNVERIFIED]` — kind: decision — *"reason… becomes required for SECONDARY
    rows. No certification check."*
  - `employee-craft-assignments.controller.ts:26-58` — kind: code — the endpoints; `reason`,
    `assignedById` exist.
  - `.ai/claude/contexts/web.md` → *Multi-select* — kind: rule — repeat a row.
- **Conflict:** none. *"Should not reduce pay below the primary rate"* is a pricing rule —
  §13.
- **Open question:** none.
- **Ripple:** `EmployeeCraftCard`, `craft-code-picker-modal.tsx` (gain the required reason),
  DAS secondary pickers, `payroll-secondary-craft.ts` — unchanged readers.
- **Acceptance:** rows render under Craft-Based Hourly only; a row without a reason cannot be
  saved (web + API 400 for SECONDARY); duplicate craft → today's 409; PRIMARY never appears;
  on create, secondaries are posted after the employee exists.
- **Notes for the executor:** `PayrollCraftCodeSelect` without a `roleType` filter per row;
  `reason` `@IsNotEmpty` when `assignmentType = SECONDARY` in the assignment DTO.

### REQ-16 — Union status derived from the primary craft, shown on the profile `[UNVERIFIED]`

- **Statement:** For a Craft-Based Hourly employee Union status is not entered: it is the
  primary craft's union code (`kind` + label), displayed read-only. On save the service writes
  `unionCodeId` = the craft's union code and `unionStatus` = its label so every existing
  reader keeps working; the `UNION_STATUS_DISAGREES_WITH_CRAFT` warning is retired for this
  type.
- **Surface:** web / api
- **Sources:**
  - `EPF §11` — `[UNVERIFIED]` — kind: jira — derived for craft-based; *"The resolved union
    status should be visible on the Payroll Profile."*
  - `decisions/2026-08-25-non-union-base-rate-per-person.md` — `[VERIFIED]` — branches on the
    primary craft's union kind.
  - `decisions/2026-06-30-adp-erp-employee-data-ownership.md` — `[VERIFIED]` — union/non-union
    classification is ERP-owned.
  - DEC-0915 Q9 — `[UNVERIFIED]` — kind: decision — `resolvedUnionKind` definition; warning
    retired for craft-based input.
  - `employee.repository.ts:33-34,178-202` — kind: code — only the craft's kind is reliable;
    `unionCodeId` → denormalised `unionStatus`.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** list Union column / Union · Non-Union views (`employee-workspace.config.tsx`),
  `employee-list.helpers.ts` union filter, DAS `das.repository.ts:651,793`, mobile
  `ticket-labor-entry.contract.ts:66-69` — all keep working via the written-through label.
  `payrollSetupWarnings` loses one warning path for craft-based input.
- **Acceptance:** picking a craft updates the read-only Union status immediately; saving
  writes `unionCodeId`/`unionStatus` from the craft; the list's Union view includes the
  employee.
- **Notes for the executor:** derive in `EmployeeService` when `compensationType =
  CRAFT_HOURLY`, ignoring any `unionCodeId` in the DTO for that type.

### REQ-17 — Union status for Salaried / Hourly Non-Craft — selected, informational `[UNVERIFIED]`

- **Statement:** For the two non-craft types the existing Union Status picker (union codes)
  is shown, optional. A salaried employee may be recorded as union. `resolvedUnionKind` is
  the picked code's kind (null when none). Nothing prices, reports or exports from it in this
  ticket.
- **Surface:** api / web
- **Sources:**
  - `EPF §11` — `[UNVERIFIED]` — kind: jira — *"should be selected directly or derived from a
    separate payroll classification rule… salaried employees may also be union."*
  - DEC-0915 Q9 — `[UNVERIFIED]` — kind: decision — *"Selected, optional, informational."*
  - `payroll/gaps.md` → *Payroll has three populations…* — `[UNVERIFIED]` — kind: vault —
    every vault salaried reference is non-union admin; recorded as the counter-evidence the
    decision overrides.
  - `create-employee-main-tab-fields.tsx:47-76` — kind: code — `UnionStatusField`.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** `UnionStatusField` moves into the two non-craft bodies; hidden for craft-based.
- **Acceptance:** a Salaried employee can save with a UNION code; `resolvedUnionKind = UNION`
  is returned; no payroll week changes.
- **Notes for the executor:** a move.

### REQ-18 — Custom payroll exceptions — group override + note `[UNVERIFIED]`

- **Statement:** *Custom payroll exceptions* is two things on every profile type: the manual
  **Payroll Group override** (today's select, under *Advanced*, explicit value wins over
  derivation) and a free-text **Payroll exception note** (`Text`) shown on the profile and on
  the employee's payroll-week card.
- **Surface:** schema / api / web
- **Sources:**
  - `EPF §5–7` — `[UNVERIFIED]` — kind: jira — *"Custom payroll exceptions"* on every profile.
  - DEC-0915 Q7 — `[UNVERIFIED]` — kind: decision — override + note; no flag set.
  - `payroll/gaps.md` → *The union-classified employee who must not be paid on union rules*
    — `[UNVERIFIED]` — kind: vault — the case the override serves; Brian wants it handled *"with
    the initial setup of employees."*
  - `payroll-fields.tsx:48-54`, `employee.repository.ts:512-520` — kind: code — the override
    exists and is honoured.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** payroll-week employee cards (`payroll-employee-card.tsx`,
  `payroll-overlay-employee-card.tsx`) gain the note; the `UNION_CRAFT_ON_NON_UNION_GROUP`
  warning keeps firing for the override case (warned, not blocked).
- **Acceptance:** setting the override to `NON_UNION_HOURLY` on a UNION-craft employee saves,
  warns, and `payrollGroup` stays as set after a later save that changes nothing else; the
  note round-trips and appears on the week card.
- **Notes for the executor:** column `payroll_exception_note Text` nullable. Override select
  keeps its placeholder *"Derived from craft"* and an explicit *Clear* to return to derivation.

### REQ-19 — Custom subsistence overrides `[UNVERIFIED]`

- **Statement:** A Craft-Based Hourly employee may carry two optional per-employee daily
  subsistence overrides — **short** and **long** (money, 2 dp) — and a free-text
  **Subsistence agreement note**. When set, the override is intended to replace the standard
  daily amount for that employee; the short/long trigger stays job-level. **Stored and
  displayed only** in this ticket; the engine's subsistence step is unchanged. On-call is not
  built.
- **Surface:** schema / api / web
- **Sources:**
  - `EPF §5` — `[UNVERIFIED]` — kind: jira — *"Custom subsistence/on-call arrangement, if
    applicable"*.
  - `decisions/2026-09-01-subsistence-not-a-craft-attribute.md` — `[UNVERIFIED]` (`status:
    reference`) — kind: decision — Kyle Harlow 2026-08-13 20:34: *"in the employee's profile,
    you could modify the sub according to the agreement"*; *"custom amounts are employee-level"*;
    location on the record unsettled → settled by DEC-0915.
  - `payroll/gaps.md` → *Subsistence — the recording and the engine disagree* — `[UNVERIFIED]`
    — kind: vault — the standard amounts ($85 short / $200 long) the overrides replace.
  - DEC-0915 Q11 — `[UNVERIFIED]` — kind: decision — two overrides + note; stored only;
    on-call not built.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** none today; the engine's subsistence step is a later provenance-backed change.
- **Acceptance:** fields render only under Craft-Based Hourly; round-trip; no payroll amount
  changes when set.
- **Notes for the executor:** `subsistence_short_override Decimal(10,2)`,
  `subsistence_long_override Decimal(10,2)`, `subsistence_agreement_note Text`, all nullable.

### REQ-20 — Changing Compensation Type — hide, never clear `[UNVERIFIED]`

- **Statement:** When an employee's Compensation Type changes, the previous type's stored
  values (craft assignments, over-scale, hourly rate, salary fields, subsistence overrides)
  stay on the row and are not rendered; the API ignores payload fields that do not belong
  to the submitted type instead of rejecting them; the switch is never blocked; the change
  is written to the activity log.
- **Surface:** api / web
- **Sources:**
  - DEC-0915 Q12 — `[UNVERIFIED]` — kind: decision — *"Hide, never clear, never block"*;
    activity log is the history; no effective date on the switch.
  - `payroll/gaps.md` → *Craft assignment has no history* — `[UNVERIFIED]` — kind: vault —
    why clearing the PRIMARY on a switch would be destructive.
  - `employee-craft-assignments.service.ts:74` — kind: code — PRIMARY is not deletable via
    the endpoint; the row simply stops being rendered.
- **Conflict:** none.
- **Open question:** none.
- **Ripple:** `payroll.service.ts:806-822` still finds the retained PRIMARY on a now-Salaried
  employee — harmless: `payrollGroup` is `NON_UNION_SALARY` and the salary branch runs first.
  DAS mismatch prompts read the retained PRIMARY — acceptable; the employee is not a craft
  worker for dispatch purposes only if their status/type says so.
- **Acceptance:** switch Craft-Based Hourly → Salaried, save, switch back: the primary craft,
  secondaries and over-scale reappear unchanged; the activity log shows the two
  `compensationType` changes.
- **Notes for the executor:** add `compensationType`, `payrollStatus`, `salaryAmount`,
  `payCycle`, `overScaleRate`, `subsistence*Override` to the tracked activity fields.

### REQ-21 — Managed Assets section `[UNVERIFIED]`

- **Statement:** Today's managed-assets tab content, unchanged, as a section. Omitted for
  temporary employees (REQ-28).
- **Surface:** web
- **Sources:** `EPF §12` — `[UNVERIFIED]` — kind: jira — *"operational tracking, not payroll
  setup"*; `create-employee-managed-assets-*.tsx`, `employee.repository.ts:475-497,829-890` —
  kind: code; `dispatch/gaps.md` → *Default crew per unit* — `[UNVERIFIED]` — the ownership-vs-
  default question stays open, not this ticket's.
- **Conflict:** none. **Open question:** none.
- **Ripple:** `?include=managedAssets`, detail tab, asset delete guards — unchanged.
- **Acceptance:** as today; activity log still records added/removed unit codes.
- **Notes for the executor:** move; keep `employee-managed-asset-select*` IDs.

### REQ-22 — Emergency Contact section `[UNVERIFIED]`

- **Statement:** Today's Additional Info tab content (name, work/home/cell phone, email,
  address), unchanged, as a section.
- **Surface:** web
- **Sources:** `EPF §1` — `[UNVERIFIED]`; `create-employee-additional-info-tab.tsx` — code;
  `erp-review-log.md`:166-171 — `[UNVERIFIED]` — Corrina asked for multiple contacts; not in
  EPF, not built (§13).
- **Conflict:** none. **Open question:** none.
- **Ripple:** the *emergency work phone ≠ work cell* rule stays.
- **Acceptance:** as today. **Notes for the executor:** move.

### REQ-23 — Attachments & Certifications section `[UNVERIFIED]`

- **Statement:** One section: categorised attachments (today's four categories) above, the
  certificates list (attachments tagged with a catalog certificate + expiry) below.
  Certificates stay attachment-based; no fifth category added.
- **Surface:** web
- **Sources:** `EPF §13` — `[UNVERIFIED]` — *"For now, certifications can be stored as
  attachments… Later, structured records"*; `employee-attachment-categories.ts`,
  `employee-certificates-section.tsx:73,108` — code; `payroll/gaps.md` → *Employee
  certifications — types and scope* — open, deferred by EPF's "Later";
  `decisions/2026-06-30` — certifications ERP-owned.
- **Conflict:** none. **Open question:** none.
- **Ripple:** `CreateEmployeeAttachmentsSection`, `EmployeeCertificatesSection`,
  `AddCertificateModal`, `certificate-*` IDs — unchanged.
- **Acceptance:** upload/list/expire/delete as today; last section on the page.
- **Notes for the executor:** move.

### REQ-24 — Detail page mirrors the sections `[UNVERIFIED]`

- **Statement:** `/employees/<code>` presents the eight sections as read-only
  `FieldGrid`/`Field` groups; the payroll section shows only the employee's Compensation
  Type's fields, the resolved union status and the derived payroll group; masked SSN per
  REQ-04. Employment History, Leaves, Activity Logs and Notes keep their tabs; the status
  quick-action select offers the five statuses.
- **Surface:** web
- **Sources:** `EPF §Purpose`, `§11` — `[UNVERIFIED]`; `employee-detail-general-tab.tsx:107-193`
  — code.
- **Conflict:** none. **Open question:** none.
- **Ripple:** `qa-automation` `create.spec.ts:313-358` asserts InfoRow labels — instruction 4.
- **Acceptance:** a Salaried employee's payroll block shows salary amount / frequency /
  effective dates and no craft; a Craft-Based Hourly employee's shows the craft card.
- **Notes for the executor:** `SectionCard` + `FieldGrid`/`Field`; keep `EmployeeCraftCard`
  inside the payroll section for craft-based employees.

### REQ-25 — Employment Details section and the *Advanced* disclosure — nothing dropped `[UNVERIFIED]`

- **Statement:** Every shipped field EPF does not mention is kept, re-housed:

  | Home | Fields |
  | --- | --- |
  | Basic Information | SMS opt-in |
  | Employee Status | Termination Date · Termination Reason · Rehire Date |
  | **Employment Details** (new section, after Employee Status) | Yard · Type · Classification · Work Comp · Standard Burden Code · Supervisor · Certified Pay · Rank · Unit |
  | Payroll Profile → *Advanced* (collapsed disclosure, all types) | Pay Cycle (hourly types; salaried shows it as Salary Frequency above) · Pay Rate OT · Pay Rate DB · Billing Rate · Billing Rate OT · Billing Rate DB · Payroll Exported · Payroll Group override |
  | Detail tab, unchanged | Notes |

  `payType` leaves the UI (derived, REQ-09); `terminated` leaves the UI (derived, REQ-06).
- **Surface:** schema / api / web
- **Sources:**
  - DEC-0915 Q10 — `[UNVERIFIED]` — kind: decision — the table, verbatim; *"Nothing is
    dropped — they are migrated FCC data and the migration cut is still open."*
  - `payroll/fcc-employee-master-reference-data.md` §*The Employees window* — `[UNVERIFIED]`
    — kind: vault — all of them are FCC Main-tab fields.
  - `payroll/gaps.md` → *Home yard cannot come from ADP* — `[UNVERIFIED]` — kind: vault —
    Yard must be ERP-mastered.
- **Conflict:** none. **Open question:** none.
- **Ripple:** none of the *Advanced* rate columns is read by payroll (`git grep -n -E
  "payRateOT|payRateDB|billingRate" packages apps/api/src/usecase/payroll` → nothing);
  `yardId` by DAS/loadout — unchanged.
- **Acceptance:** every field in the table saves and displays as today; *Advanced* is
  collapsed by default and expands to reveal its fields; `Pay Type` and `Terminated` are not
  in the DOM.
- **Notes for the executor:** the disclosure is a plain `<details>`-style toggle inside the
  payroll `SectionCard` body — `NOT SPECIFIED` beyond that; reuse whatever collapsible the
  quotation form uses if one exists (`find-component` first).

### REQ-26 — Employee ID manual or auto-generated `[UNVERIFIED]`

- **Statement:** Unchanged: typed (`^[A-Za-z0-9][A-Za-z0-9._-]{0,49}$`, unique per tenant) or
  blank → `EMP-#####`; editable on edit with reference migration.
- **Surface:** api / web
- **Sources:** `EPF §1` — `[UNVERIFIED]`; `employee.service.ts:315-343` — code;
  `payroll/gaps.md` → PR #488 (a) — the prefix is shipped behaviour, unchanged here.
- **Conflict:** none. **Open question:** none. **Ripple:** none.
- **Acceptance:** as today. **Notes for the executor:** move.

### REQ-27 — Salary frequency is Pay Cycle `[UNVERIFIED]`

- **Statement:** No new column. For `SALARIED`, `payCycle` is shown as **Salary Frequency**,
  required, over `WEEKLY · BIWEEKLY · SEMI_MONTHLY · MONTHLY`; for the hourly types Pay Cycle
  stays optional under *Advanced* with today's six values. A salaried row holding `QUARTERLY`
  or `DAILY` displays the stored value and must be changed on the next save.
- **Surface:** shared / web
- **Sources:** DEC-0915 Q8 — `[UNVERIFIED]` — kind: decision; `EPF §6` — `[UNVERIFIED]` —
  *"Weekly / Biweekly / Monthly"* examples; `payroll/rules/PAY-013` — *"pay frequency"*;
  `employee-form-options.ts:1-8` — code.
- **Conflict:** none. **Open question:** none.
- **Ripple:** `PAY_CYCLE_OPTIONS` gains a `SALARY_FREQUENCY_OPTIONS` subset in `@tcg/shared`.
- **Acceptance:** a Salaried save without a frequency fails on the field; the picklist shows
  four values; an hourly employee's *Advanced* Pay Cycle shows six.
- **Notes for the executor:** API validates `payCycle` `@IsIn` the six; the service requires
  it for `SALARIED` and rejects `QUARTERLY`/`DAILY` for `SALARIED` on save.

### REQ-28 — Temporary-employee variant — same page minus Managed Assets `[UNVERIFIED]`

- **Statement:** `/employees/temp-employees/create` and `/…/edit` render the same sectioned
  page without the Managed Assets section, with `employeeStatus = TEMPORARY` and the *Temp
  Employee ID* label — today's one-flag `variant`. Temps get the full payroll profile; a
  craft-based temp needs a primary craft.
- **Surface:** web
- **Sources:** DEC-0915 Q13 — `[UNVERIFIED]` — kind: decision; `SCRUM-926/spec.md` REQ-27 —
  `[UNVERIFIED]` — temps require a craft (now: craft-based temps); `views/employees.tsx:23-53`,
  `create-employee.tsx:151-168,209-211,465` — code; `payroll/gaps.md` → PR #488 (a) — the
  3-step wizard was unsourced and is replaced.
- **Conflict:** none. **Open question:** none.
- **Ripple:** temp list columns unchanged (SSN masked per REQ-04).
- **Acceptance:** the temp create page has seven sections (no Managed Assets); saving yields
  `employeeStatus = TEMPORARY`.
- **Notes for the executor:** keep `variant` as the single switch.

### REQ-29 — Failed submit focuses the first invalid field across sections `[UNVERIFIED]`

- **Statement:** On a failed submit the page scrolls to and focuses the first invalid
  rendered control in DOM order; validation clears as the field becomes valid; no
  top-of-form summary; a collapsed *Advanced* disclosure containing an invalid field is
  expanded first.
- **Surface:** web
- **Sources:** `.ai/claude/contexts/web.md` → *Forms* — kind: rule; `agency-form.tsx:299-303`
  `deferFocusFirstInvalidElement` — code.
- **Conflict:** none. **Open question:** none.
- **Ripple:** replaces `findEmployeeTabForErrors` / `requestValidationFocus`.
- **Acceptance:** empty first name + empty salary amount → focus first name; fix, submit →
  focus salary amount without a second attempt at the first.
- **Notes for the executor:** the Zod schema becomes type-aware via `superRefine` on
  `compensationType`.

### REQ-30 — Test IDs on every new control; surviving IDs kept `[UNVERIFIED]`

- **Statement:** Every new interactive control carries a `data-testid` in the
  `employees-<flow>-<element>` scheme; existing IDs whose element survives keep their string;
  `employee-wizard-next` / `-back` are removed and listed in the PR description. The E2E
  suite is not updated (instruction 4).
- **Surface:** web
- **Sources:** `.ai/claude/contexts/web.md` → *Test IDs* — kind: rule; session instruction 4 —
  `[UNVERIFIED]` — kind: jira.
- **Conflict:** none. **Open question:** none.
- **Ripple:** `qa-automation/e2e/specs/employees/employees.page.ts` will fail after merge —
  recorded in §11a and §13.
- **Acceptance:** `git grep -n 'employee-wizard-' apps/web` returns only `cancel`, `save`,
  `save-draft`, `submit`; new IDs: `employees-payroll-compensation-type`,
  `employees-payroll-status`, `employees-payroll-salary-amount`,
  `employees-payroll-salary-frequency`, `employees-payroll-salary-effective-from/-to`,
  `employees-payroll-hourly-rate-effective-from/-to`, `employees-payroll-over-scale`,
  `employees-payroll-secondary-craft-row`, `-add`, `-remove`, `-reason`,
  `employees-payroll-union-status`, `employees-payroll-exception-note`,
  `employees-payroll-subsistence-short/-long/-note`, `employees-payroll-advanced-toggle`,
  `employees-status-select`, `employees-status-term-date`, `employees-status-term-reason`.
- **Notes for the executor:** shared components take the ID from the call site.

### REQ-31 — Employee and payroll status gate the payroll worklist `[UNVERIFIED]`

- **Statement:** The weekly worklist build and the ADP export include an employee only when
  `payrollStatus = ELIGIBLE` **and** `status ∈ {ACTIVE, ON_LEAVE}`; an excluded employee who
  has labor in the week raises `EMPLOYEE_ON_PAYROLL_HOLD` (payroll status) or
  `EMPLOYEE_STATUS_EXCLUDED` (employee status) on the week so the hours are visible. This is
  a worklist filter in the payroll usecase; the engine is unchanged.
- **Surface:** api
- **Sources:** DEC-0915 Q2 gate table and Q3 — `[UNVERIFIED]` — kind: decision;
  `packages/payroll-engine/src/calculate.ts:978,996` — code — today's exclusions;
  `payroll/gaps.md` → *The union-classified employee…* — `[UNVERIFIED]` — the legacy exclusion
  table precedent.
- **Conflict:** none. **Open question:** none.
- **Ripple:** `payroll.service.ts:806-918`, `payroll-export.ts`, `xlsx-rows.ts`,
  `payroll-issue-catalog.ts` (two new issue codes). Provenance entry in
  `payroll/payroll-rules-provenance.md`, same commit.
- **Acceptance:** a `TERMINATED` employee with ticket labor in the week is absent from the
  worklist and the week shows `EMPLOYEE_STATUS_EXCLUDED`; an `ON_LEAVE` employee is included.
- **Notes for the executor:** filter in the usecase before building `PayrollEmployeeInput`;
  do not add a status field to the engine's input type.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** yes
- **Migration required:** yes — `pnpm db:migrate`, committed under
  `apps/api/prisma/migrations/`, **including the backfill SQL** (REQ-09, REQ-06).
- **Data backfill required:** yes — `compensation_type` (REQ-09 rule) and `status =
  'TERMINATED' WHERE terminated` (REQ-06).

```prisma
enum CompensationType {
  CRAFT_HOURLY       // "Craft-Based Hourly"
  HOURLY_NON_CRAFT   // "Hourly Non-Craft"
  SALARIED           // "Salaried"
}

enum PayrollStatus {
  ELIGIBLE
  HOLD
}

model Employee {
  // … existing columns unchanged (employeeCode EMP-#####, payrollGroup, payType, payCycle,
  //     hourlyRate, unionCodeId, unionStatus, terminated, termDate, termReason …)

  /// REQ-08/09. Source of payType and payrollGroup. Backfilled, then NOT NULL.
  compensationType        CompensationType @map("compensation_type")
  /// REQ-07/31. Worklist + export gate; not read by packages/payroll-engine.
  payrollStatus           PayrollStatus    @default(ELIGIBLE) @map("payroll_status")

  /// REQ-11. Stored for the record; the engine still reads hourlyRate for NON_UNION_SALARY
  /// weeks (PAY-013 open) — not wired here. Frequency is payCycle (REQ-27).
  salaryAmount            Decimal?  @map("salary_amount") @db.Decimal(12, 2)
  salaryEffectiveFrom     DateTime? @map("salary_effective_from") @db.Date
  salaryEffectiveTo       DateTime? @map("salary_effective_to") @db.Date

  /// REQ-12. Stored only; the craft-rate resolver reads hourlyRate as it stands
  /// (decisions/2026-08-25). Nothing honours these dates yet.
  hourlyRateEffectiveFrom DateTime? @map("hourly_rate_effective_from") @db.Date
  hourlyRateEffectiveTo   DateTime? @map("hourly_rate_effective_to") @db.Date

  /// REQ-13. $/hour adder into the straight-time base rate before multipliers
  /// (DEC-0915 Q6). Stored, displayed, NOT applied by payroll here — SCRUM-928.
  overScaleRate           Decimal?  @map("over_scale_rate") @db.Decimal(10, 4)

  /// REQ-18. Free text beside the manual payrollGroup override.
  payrollExceptionNote    String?   @map("payroll_exception_note") @db.Text

  /// REQ-19. Per-employee daily overrides of the standard subsistence amounts; stored only.
  subsistenceShortOverride Decimal? @map("subsistence_short_override") @db.Decimal(10, 2)
  subsistenceLongOverride  Decimal? @map("subsistence_long_override") @db.Decimal(10, 2)
  subsistenceAgreementNote String?  @map("subsistence_agreement_note") @db.Text

  // status VarChar(50) keeps its type; the value set is enforced by the DTO (REQ-06):
  //   ACTIVE · INACTIVE · ON_LEAVE · TERMINATED · PENDING_ONBOARDING · DRAFT
  // terminated Boolean becomes derived from status (written by the service, never by the DTO).
}
```

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| `Employee` | `employeeCode` | `EMP-#####` (existing) | `entity_sequences` (`SequenceRepository.getNextValue('EMP')`) | REQ-26 |

- **New prefix introduced:** no
- **Child relations:** none new. `EmployeeCraftAssignment.reason` becomes required for
  SECONDARY at the DTO/service level (no schema change — column is already `Text?`).
- **Fields whose type/precision no source states:** `salaryAmount` 2 dp (money, assumed);
  `overScaleRate` 4 dp (matches `CraftCodeRate.baseRate`); subsistence overrides 2 dp (the
  standard amounts are whole dollars). `NOT SPECIFIED` max lengths on the two notes.
- **Tenant isolation:** `Employee` is already in the `$extends` allowlist; no new model.
  `tcg-prisma-guardian` runs on the migration.
- **Indexes:** `idx_employees_tenant_compensation_type (tenant_company_id, compensation_type)`
  and `idx_employees_tenant_payroll_status (tenant_company_id, payroll_status)` — the
  worklist and `missing-primary` filter on them.

## 4. API surface — `apps/api`

No new routes. Existing routes gain fields, per-type validation and response masking.

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| `POST` | `/employee` | `employee.controller.ts` (`@Roles(ADMIN)`) | `employee.service.ts` `create` | `employee.repository.ts` | REQ-06…20, 26 |
| `PATCH` | `/employee/:employeeCode` | same | `update` | same | REQ-06…20 |
| `GET` | `/employee/:employeeCode`, `GET /employee` | same | `findOne`, `findAll` | same | REQ-04 (masking), REQ-24 |
| `GET/POST/DELETE` | `/employee/:employeeCode/craft-assignments[/:id]` | `employee-craft-assignments.controller.ts` | existing | existing | REQ-15 (reason required for SECONDARY) |
| `GET` | `/v1/craft-assignments/missing-primary` | same | existing | existing | REQ-10 (filter `CRAFT_HOURLY`) |
| — | payroll worklist build / export | `payroll.controller.ts` (existing) | `payroll.service.ts` | `payroll.repository.ts` | REQ-31 |

Per endpoint:

- **Request DTO:** `create-employee.dto.ts` / `UpdateEmployeeDto` add: `compensationType`
  `@IsEnum(CompensationType)` (required on non-DRAFT create; the service checks) ·
  `payrollStatus` `@IsEnum(PayrollStatus) @IsOptional` · `salaryAmount`, `overScaleRate`,
  `subsistenceShortOverride`, `subsistenceLongOverride` `@IsNumberString @IsOptional` ·
  `salaryEffectiveFrom/To`, `hourlyRateEffectiveFrom/To` `@IsDateString @IsOptional` ·
  `payrollExceptionNote`, `subsistenceAgreementNote` `@IsString @IsOptional` ·
  `secondaryCrafts: { craftCodeId: uuid; reason: string }[]` (create only) · `status`
  `@IsIn([...EMPLOYEE_STATUSES, 'DRAFT'])` · `payCycle` `@IsIn(PAY_CYCLE_VALUES)`. `payType`
  and `terminated` stay accepted for compatibility and are **overwritten** by the service.
- **Response shape:** today's payload plus the new columns, `resolvedUnionKind`, and `ssn`
  masked per REQ-04 unless the caller is ADMIN/SUPER_ADMIN.
- **Guards / roles:** unchanged.
- **Route param identity:** `employeeCode` on the boundary; `(tenant, code) → id` once.
- **Errors (400 unless noted):** *"Compensation type is required"* · *"Payroll craft is
  required for Craft-Based Hourly employees"* · *"<craft> is a <roleType> craft; <Employee
  Type> employees take a <expected> craft"* · *"Salary amount is required for Salaried
  employees"* · *"Salary frequency is required for Salaried employees"* · *"Salary frequency
  must be Weekly, Bi-Weekly, Semi-Monthly or Monthly"* · *"Hourly rate is required for Hourly
  Non-Craft employees"* · *"Effective end date must be on or after the start date"* ·
  *"Termination date is required when employee is terminated"* (existing) · *"A reason is
  required for a secondary craft"*. Copy is the executor's; `NOT SPECIFIED` by any source.
- **Module registration:** no new module.

## 5. Web surface — `apps/web`

- **Routes:** unchanged.
- **Existing components to reuse** (checked): `PageHero`, `SectionCard` (`heading={false}`,
  `icon`), `FieldGrid`, `Field`, `InfoRow`, `FormField`, `Input`, `TextInput`, `NumberInput`,
  `NativeSelect`, `DateField`, `Checkbox`, `Textarea`, `ContactNumberInput`, `SsnField`,
  `EmailField`, `AddressSection`, `EntityProfilePictureSection`, `DepartmentSelect`,
  `RoleSelect`, `EmployeeTypeSelect`, `PayrollCraftCodeSelect`, `ReferenceCodeSelect`,
  `WarningList` (`PayrollSetupWarnings`), `EmployeeCraftCard`, `CreateEmployeeAttachmentsSection`,
  `EmployeeCertificatesSection`, `CreateEmployeeManagedAssetsSection`, `EmployeeYardField`,
  `OptionSelectField`, `RichTextArea`, `WorkspaceFooterBar`, `SaveStateIndicator`,
  `UnsavedChangesDialog`, `PrimaryButton`, `SecondaryButton`.
- **New components proposed** (`features/employees/components/form/`):
  - `employee-form.tsx` — the page shell (replaces the wizard shell in `create-employee.tsx`).
  - `sections/basic-information-section.tsx`, `department-role-section.tsx`,
    `employee-status-section.tsx`, `employment-details-section.tsx`,
    `payroll-profile-section.tsx`, `managed-assets-section.tsx`,
    `emergency-contact-section.tsx`, `attachments-certifications-section.tsx`.
  - `payroll/compensation-type-field.tsx`, `payroll-status-field.tsx` — static selects.
  - `payroll/craft-hourly-fields.tsx`, `salaried-fields.tsx`, `hourly-non-craft-fields.tsx` —
    the three bodies; `payroll-profile-section.tsx` switches on `watch('compensationType')`.
  - `payroll/secondary-craft-rows.tsx` — repeat rows (craft + reason).
  - `payroll/resolved-union-status.tsx` — read-only region.
  - `payroll/payroll-advanced-fields.tsx` — the disclosure.
  Why nothing existing fits: no component renders a type-switched form body; the rest are
  moves.

### The conditional flow

`S` = shown, `R` = required on a finalized save, `—` = not rendered, `RO` = read-only,
`(A)` = inside the *Advanced* disclosure.

| Field | Craft-Based Hourly | Hourly Non-Craft | Salaried | Req |
| --- | --- | --- | --- | --- |
| Compensation Type | R | R | R | REQ-08 |
| Payroll status | S (default Eligible) | S | S | REQ-07 |
| ADP file number | S | S | S | REQ-10/11/12 |
| Primary craft | **R** — picker filtered by Employee Type's craft role | — | — | REQ-10, 14 |
| Secondary crafts (rows: craft + reason) | S | — | — | REQ-15 |
| Union status | RO, derived from primary craft | S picker, optional | S picker, optional | REQ-16, 17 |
| Payroll Group | RO derived; override under (A) | RO `NON_UNION_HOURLY`; override (A) | RO `NON_UNION_SALARY`; override (A) | REQ-09, 18 |
| Hourly rate | S **only if** primary craft is NON_UNION (warned when blank) | **R** | S — labelled *"Weekly amount payroll uses until PAY-013 is settled"* | REQ-10, 11, 12 |
| Hourly rate effective from / to | — | S | — | REQ-12 |
| Salary amount | — | — | **R** | REQ-11 |
| Salary frequency (= Pay Cycle) | (A) six values, optional | (A) six values, optional | **R**, four values, shown as *Salary Frequency* | REQ-27 |
| Salary effective from / to | — | — | S | REQ-11 |
| Over-scale ($/hour) | S | — | — | REQ-13 |
| Subsistence short / long override + note | S | — | — | REQ-19 |
| Payroll exception note | S | S | S | REQ-18 |
| Setup warnings (`PayrollSetupWarnings`) | S | — | — | REQ-10 |
| Pay Rate OT/DB · Billing Rate/OT/DB · Payroll Exported | (A) | (A) | (A) | REQ-25 |
| Pay Type · Terminated | — (derived) | — | — | REQ-09, 06 |

Transitions:

- **Selecting a type** renders that column; values typed under another type are retained in
  form state and stripped from the payload for the active type (REQ-20).
- **Employee Type on create** pre-selects Compensation Type (field/shop → Craft-Based
  Hourly, else Hourly Non-Craft) until the user touches the field (REQ-08).
- **Changing Employee Type** to one whose craft role no longer matches the chosen primary
  craft clears the craft field client-side and shows the required marker (REQ-14); changing
  the primary craft still auto-selects the matching Employee Type.
- **Changing the primary craft** re-derives Union status and Payroll Group in place; a
  NON_UNION craft reveals Hourly rate; a UNION craft hides it.
- **Status = Terminated** reveals Termination Date (required) and Reason; any other status
  hides them (REQ-06).
- **DRAFT save** skips every `R` except first/last name, email, work cell; **finalize**
  applies the column.
- **Edit of a backfilled employee**: the select shows the migrated value; the user may
  correct it (REQ-09).

- **Table:** none new.
- **Forms:** react-hook-form + Zod v4; type-aware `superRefine`; `mode: 'onBlur'`,
  `reValidateMode: 'onChange'`; failed submit → REQ-29.
- **Server state:** TanStack Query v5 — existing `employeeKeys`; secondary-craft rows
  invalidate the craft-assignment keys as `EmployeeCraftCard` does.
- **Colors / spacing:** `theme.css` variables via `SectionCard`; no hex.
- **Responsive:** 1-column at phone width; 44px targets.
- **Copy:** section titles from REQ-02; field labels: *"Compensation Type"*, *"Craft-Based
  Hourly"*, *"Hourly Non-Craft"*, *"Salaried"*, *"Payroll Status"*, *"Eligible"*, *"Hold"*,
  *"Salary Amount"*, *"Salary Frequency"*, *"Effective From"*, *"Effective To"*, *"Over-scale
  ($/hour)"*, *"Union Status"*, *"Payroll Exception Note"*, *"Subsistence — Short (per day)"*,
  *"Subsistence — Long (per day)"*, *"Subsistence Agreement Note"*, *"Advanced"*, statuses
  *"Active"*, *"Inactive"*, *"On Leave"*, *"Terminated"*, *"Pending Onboarding"*. Everything
  else keeps today's label.

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** `N/A — no mobile change.` Mobile reads `employeeType.name`,
  `departmentRole` name and the crew's PRIMARY craft/union code — none move (REQ-05,
  REQ-16). Established by `git grep -n -E "employeeType|payrollGroup|hourlyRate|unionCode|craftCode|departmentRole" apps/mobile`.
  `employee.types.ts` gains fields — additive; `tcg-contract-tracer` confirms.
- **Offline / sync behavior:** `N/A` · **Touch targets:** `N/A` · **Push:** `N/A`

## 7. Shared package — `packages/shared`

- **Types added / changed:** `enum CompensationType` + `COMPENSATION_TYPE_LABELS`; `enum
  PayrollStatus` + labels; `EMPLOYEE_STATUSES` + `EMPLOYEE_STATUS_LABELS`;
  `SALARY_FREQUENCY_OPTIONS` (subset of `PAY_CYCLE_OPTIONS`, which moves here from
  `apps/web`); `derivePayrollGroup` gains `compensationType` (REQ-09);
  `payrollSetupWarnings` skips `UNION_STATUS_DISAGREES_WITH_CRAFT` when
  `compensationType = CRAFT_HOURLY`; `employee.types.ts` gains the new fields and
  `resolvedUnionKind`. `tcg-contract-tracer` on the change — web, mobile and the payroll
  engine import from here.

## 8. Permissions and tenancy

- **Roles permitted:** writes `Role.ADMIN` (today); reads any authenticated user; **full SSN
  `ADMIN`/`SUPER_ADMIN` only** (REQ-04).
- **Roles denied:** non-admin readers see masked SSN.
- **Tenant isolation:** standard `$extends` scoping; `Employee` allowlisted.
- **Cross-tenant reads:** none.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| Compensation Type | required on non-DRAFT save | `EPF §4`, DEC-0915 Q4 | `[UNVERIFIED]` |
| Primary craft | required iff `CRAFT_HOURLY`; `roleType` must match the Employee Type's craft role when one exists | `EPF §5`, `§8`; DEC-0915 Q5 | `[UNVERIFIED]` |
| Hourly rate | required iff `HOURLY_NON_CRAFT`; warned-not-blocked for `CRAFT_HOURLY` + NON_UNION craft | `EPF §7`; `PAY-012`; `decisions/2026-08-25` | `[UNVERIFIED]` |
| Salary amount | required iff `SALARIED`; ≥ 0; 2 dp | `EPF §6`; `PAY-013` | `[UNVERIFIED]` |
| Salary frequency (`payCycle`) | required iff `SALARIED`; one of WEEKLY · BIWEEKLY · SEMI_MONTHLY · MONTHLY | DEC-0915 Q8 | `[UNVERIFIED]` |
| Effective to ≥ effective from (salary, hourly) | when both set | DEC-0915 (executor's reading of "start/end") | `[UNVERIFIED]` |
| Over-scale | ≥ 0; 4 dp; only `CRAFT_HOURLY` | `EPF §10`; DEC-0915 Q6 | `[UNVERIFIED]` |
| Subsistence overrides | ≥ 0; 2 dp; only `CRAFT_HOURLY` | DEC-0915 Q11 | `[UNVERIFIED]` |
| Secondary craft | not already assigned; not the PRIMARY; **reason required** | `SCRUM-926` REQ-08; DEC-0915 Q7 | `[UNVERIFIED]` |
| Status | one of the five (+ DRAFT); `TERMINATED` ⇒ termination date required | `EPF §3`; DEC-0915 Q2; shipped rule | `[UNVERIFIED]` |
| Payroll status | one of ELIGIBLE / HOLD; default ELIGIBLE | DEC-0915 Q3 | `[UNVERIFIED]` |
| SSN 9 digits | unchanged; masked value never written back | FCC import contract; DEC-0915 Q1 | `[UNVERIFIED]` |
| Email / work cell / employee ID unique per tenant; archive does not free | unchanged | shipped, `payroll/gaps.md` PR #488 (b) | not this ticket's |
| Joining ≥ hiring; reason ≤ 400 | unchanged | shipped, unsourced (PR #488 (e)) | not this ticket's |
| Max lengths on the two notes | `NOT SPECIFIED` | — | — |

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit (`packages/shared`, node `--test`) | `derivePayrollGroup` with `compensationType`: SALARIED → NON_UNION_SALARY, HOURLY_NON_CRAFT → NON_UNION_HOURLY, CRAFT_HOURLY → craft cases unchanged; `payrollSetupWarnings` skips the union-disagree warning for craft-based input; label maps cover the enums | REQ-08, 09, 16 |
| Unit (web, node `--test`) | type-aware Zod schema: each type's required set; DRAFT exemption; effective-date ordering; Terminated ⇒ term date; payload strips other-type fields; salaried frequency subset | REQ-06, 10/11/12, 20, 27, 29 |
| Integration (API, jest) | per-type 400s; REQ-14 mismatch 400; SECONDARY without reason 400; `CRAFT_HOURLY` save derives `unionCodeId`/`unionStatus`/`payrollGroup`/`payType`; `SALARIED` save derives `NON_UNION_SALARY`/`SALARY`; stale `primaryCraftCodeId` on a salaried save ignored; SSN masked for `USER`, full for `ADMIN`; masked value on update leaves SSN unchanged; `TERMINATED` sets `terminated = true` and revokes a pending invite; `missing-primary` lists `CRAFT_HOURLY` only; migration backfill on a fixture of the three row shapes | REQ-04, 06, 09, 10…17 |
| Integration (API, jest — payroll) | `HOLD` / `TERMINATED` / `PENDING_ONBOARDING` employees excluded from the worklist with the issue raised; `ON_LEAVE` included; over-scale and subsistence overrides change no week total | REQ-13, 19, 31 |
| E2E | **skipped — instruction 4.** `qa-automation/e2e/specs/employees/*` will fail on the wizard IDs, the fifth required field and the detail labels after merge; not updated here. | — |
| Manual script | create one employee per type; switch types on edit; confirm existing payroll worklist unchanged after the migration | REQ-08, 09, 20 |

- Requirements with no testable acceptance criterion: none.

## 11. Non-functional

- **Performance:** two new composite indexes (§3); no new list queries.
- **Concurrency:** employee-code minting unchanged; secondary rows on create are sequential
  POSTs after the employee exists; the PRIMARY partial unique index is untouched.
- **Audit / activity log:** `compensationType`, `payrollStatus`, `salaryAmount`, `payCycle`,
  `overScaleRate`, `subsistenceShortOverride`, `subsistenceLongOverride`, `status` join the
  tracked field set (`employee.service.ts:741-757`).
- **Migration/rollout order:** shared → schema + migration (with backfill) → API → web. No
  feature flag. The backfill runs once; a row it misclassifies is corrected by an admin on
  the form and logged.
- **Provenance:** `payroll/payroll-rules-provenance.md` gains two scoping rows (payroll hold;
  employee-status exclusion) citing DEC-0915, in the same commit as REQ-31.

## 11a. Ripple — already-shipped behaviour these requirements reach

| Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- |
| `create-employee.tsx` wizard, `create-employee-actions.tsx`, tab components | component | REQ-01 | replaced | instruction 2 | `ls apps/web/src/features/employees/components/create` |
| `views/employees.tsx` tab ↔ route mapping | `useUrlTab` | REQ-01 | detail tabs stay; form tab param dropped | code | `git grep -n useUrlTab apps/web/src/features/employees` |
| `qa-automation/e2e/specs/employees/*` (11 specs, `employees.page.ts`) | wizard IDs, `#create-employee-form`, InfoRow labels, "FIVE required fields" | REQ-01, 10, 24, 30 | **breaks; not updated** | instruction 4 | `git grep -n -E "employee-wizard|getByText" qa-automation/e2e/specs/employees` |
| `PayrollFields` (all-employees grid) | component | REQ-10/11/12/25 | split by type; leftover fields under *Advanced* | DEC-0915 Q10 | `git grep -n PayrollFields apps/web` |
| `EmploymentDetailsFields` | component | REQ-10, 25 | craft → payroll section; flags → Employment Details | DEC-0915 Q10 | same |
| `PAY_TYPE_OPTIONS`, `payType` on the form | form | REQ-09 | removed from UI; derived | DEC-0915 Q4 | `git grep -n -E "PAY_TYPE_OPTIONS|payType" apps/web` |
| `PayrollSetupWarnings` | `payrollSetupWarnings` | REQ-10, 16 | craft-based only; union-disagree warning retired there | DEC-0915 Q9 | `git grep -n PayrollSetupWarnings apps/web` |
| `derivePayrollGroup`, `syncPayrollGroup` | `payType`, PRIMARY craft | REQ-09 | gain `compensationType`; short-circuit for the two non-craft types | DEC-0915 Q4 | `git grep -n derivePayrollGroup apps packages` |
| `packages/payroll-engine` `PayrollEmployeeInput` | engine contract | REQ-11, 13, 19, 31 | **unchanged**; salary weeks keep reading `hourlyRate`; no new inputs | `contexts/payroll-engine.md`; DEC-0915 | `sed -n 24,33p packages/payroll-engine/src/types.ts` |
| `payroll.service.ts:806-918` worklist build; `payroll-export.ts`; `xlsx-rows.ts` | worklist | REQ-31 | filter on `payrollStatus` + `status`; two issue codes | DEC-0915 Q2/Q3 | `git grep -n -E "adpFileNumber|payrollGroup" apps/api/src/usecase/payroll` |
| `payroll-issue-catalog.ts` | issue codes | REQ-31 | two entries added | DEC-0915 Q3 | `git grep -n payroll-issue-catalog apps/web` |
| Payroll-week employee cards | display | REQ-18 | show the exception note and hold | DEC-0915 Q7 | `git grep -n -E "payroll-employee-card|overlay-employee-card" apps/web` |
| `craft-rate-resolver.service.ts:360-371` | `Employee.hourlyRate` via NON_UNION craft | REQ-12 | unchanged; non-craft employees still `Blocked` | `decisions/2026-08-25` | `git grep -n hourlyRate apps/api/src/service/craft-rate-resolver` |
| Payroll UI group filters / export column / worklist | `payrollGroup` | REQ-09 | unchanged (still the field) | code | `git grep -n payrollGroup apps/web/src/features/payroll` |
| `GET /craft-assignments/missing-primary` | PRIMARY absence | REQ-10 | filtered to `CRAFT_HOURLY` | DEC-0915 Q5 | `git grep -n missing-primary apps/api` |
| `assertCraftNotRequired` / `isFieldEmployeeTypeName` (API + web) | type-based craft rule | REQ-10 | hard check removed; name list kept for the default | DEC-0915 Q5 | `git grep -n isFieldEmployeeTypeName apps packages` |
| `EmployeeCraftCard`, `craft-code-picker-modal.tsx` | craft assignments | REQ-15, 24 | reason required for SECONDARY; kept in the payroll section | DEC-0915 Q7 | `git grep -n EmployeeCraftCard apps/web` |
| Craft-assignment DTO | `reason` | REQ-15 | `@IsNotEmpty` for SECONDARY | DEC-0915 Q7 | `git grep -n reason apps/api/src/presentation/employee-craft-assignments` |
| DAS `parse-craft-mismatch.ts`, secondary pickers | craft assignments | REQ-15 | unchanged | code | `git grep -n -E "craftAssignment|secondaryCraft" apps/web/src/features/das` |
| `payroll-secondary-craft.ts` | SECONDARY rows | REQ-15 | unchanged | code | `git grep -n SECONDARY apps/api/src/usecase/payroll` |
| Employee list Union column / views; `employee-list.helpers.ts` union filter; DAS `das.repository.ts:651,793`; mobile crew display | `unionStatus` / PRIMARY craft | REQ-16 | keep working — derived label written through | DEC-0915 Q9 | `git grep -n unionStatus apps/web/src/features/employees apps/api/src/usecase/employee apps/api/src/service/das` |
| `UnionStatusField` | `unionCodeId` | REQ-16, 17 | hidden for craft-based; optional for the other two | DEC-0915 Q9 | `git grep -n UnionStatusField apps/web` |
| `Employee.status` readers: list filter, views, `EmployeeSelect`, `resolveAssignableEmployeeId`, DAS availability, status toggle, draft/finalize | status string | REQ-06 | per-value filters; toggle disabled off ACTIVE/INACTIVE; new values not assignable per the gate table | DEC-0915 Q2 | `git grep -n -E "'ACTIVE'|'INACTIVE'|'DRAFT'" apps/api/src/usecase/employee apps/api/src/service/das apps/web/src/features/employees` |
| `terminated` / `termDate` / `termReason` form + detail | form | REQ-06 | `terminated` derived from status; date/reason under Employee Status | DEC-0915 Q2 | `git grep -n terminated apps/web/src/features/employees apps/api/src/usecase/employee` |
| Portal invite revoke path | `DELETE /employee/:code/invite` | REQ-06 | called on `TERMINATED` | DEC-0915 Q2 | `git grep -n revokeInvite apps/api/src/usecase/employee` |
| SSN on list (sortable, temp column), detail, `formatSsnDisplay`, `SsnField` | API + web | REQ-04 | masked for non-admin at the API; edit never round-trips the mask | DEC-0915 Q1 | `git grep -n -i ssn apps/api/src/presentation/employee apps/web/src/features/employees` |
| Seeders (`apps/api/prisma/scripts`, `fcc-seeder`) | SSN values | REQ-04 | dummy SSNs | DEC-0915 Q1 | `git grep -n -i ssn apps/api/prisma/scripts fcc-seeder/src` |
| Department / Role / Employee Type pickers and name-based consumers | `employeeTypeId`, `roleId`, names | REQ-05 | **unchanged** | instruction 3 | `git grep -n -E "employeeTypeName|departmentRoleName" apps packages` |
| `DepartmentRole` behaviour settings | schema | REQ-05 | not advanced | instruction 3 | `git grep -n -E "usedAsEmployeeType|appPersona" apps packages` |
| Managed assets (`managedAssetIds`, include, activity diff, delete guards) | API + tab | REQ-21 | moved, unchanged | `EPF §12` | `git grep -n -E "managedAssets|EmployeeAsset" apps packages` |
| Emergency contact + address | form | REQ-22 | moved | `EPF §1` | — |
| Attachments categories, certificates | components | REQ-23 | moved; no fifth category | `EPF §13` | `git grep -n -E "EMPLOYEE_ATTACHMENT_CATEGORIES|certificateId" apps/web/src/features/employees` |
| `EmployeeNotesTab` | tab | REQ-25 | stays a detail tab | DEC-0915 Q10 | `git grep -n EmployeeNotesTab apps/web` |
| `employee-sms-opt-in-field.tsx` | form | REQ-03 | Basic Information | DEC-0915 Q10 | `git grep -n smsOptIn apps/web/src/features/employees` |
| `payCycle`, `payRateOT/DB`, `billingRate*`, `payrollExported`, `yardId`, `type`, `classification`, `burden`, `workCompCodeId`, `supervisor`, `certifiedPay`, `rank`, `unitId`, `rehireDate` | DTO + form | REQ-25, 27 | re-housed, kept | DEC-0915 Q10 | `sed -n 79,352p apps/api/src/presentation/employee/dto/create-employee.dto.ts` |
| `PAY_CYCLE_OPTIONS` (`apps/web`) | options | REQ-27 | moves to `@tcg/shared`; salaried subset | DEC-0915 Q8 | `git grep -n PAY_CYCLE_OPTIONS apps` |
| Temp-employee routes and `variant` | `views/employees.tsx` | REQ-28 | same page minus Managed Assets | DEC-0915 Q13 | `git grep -n variant apps/web/src/features/employees/views` |
| `employee.types.ts` importers (web, mobile) | shared type | §7 | additive; `tcg-contract-tracer` | rule | `git grep -n "employee.types" apps packages` |
| `decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md` | create flow | REQ-01 | honoured | decision (reference) | — |

- **Surfaces with no existing behaviour in this area:** mobile (§6 grep);
  `packages/payroll-engine` has no over-scale, salary-amount, subsistence-override or
  effective-date input (`git grep -n -E "overScale|salaryAmount|effectiveFrom|subsistence.*Override" packages/payroll-engine/src` → nothing).
- **Consumers with no source for what happens to them:** none. The E2E suite's breakage is
  decided (instruction 4), not unsourced.

## 12. Open questions — the stop-and-ask list

All fourteen were answered on 2026-09-15 by developer decision at the user's instruction —
`decisions/2026-09-15-employee-profile-compensation-type-and-statuses.md` (`status:
reference`; each names the TCG person who would overrule it). The questions stay here so the
answer and the search that produced it are read together. Sweep:
`grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/SCRUM-*/spec.md`.

### Q1 — SSN: which permission unmasks it, and what does "dummy-only in UAT" mean?

- **Question:** Who may see the full SSN; does the list keep its column; is "dummy-only" a
  tenant setting?
- **Why it cannot be answered from what is written:** EPF §1 says "masked and permission
  controlled" only; no SSN handling rule in the vault; the 2026-06-30 decision makes SSN
  ADP-owned.
- **Blocked:** REQ-04.
- **Candidates:** `decisions/2026-06-30-adp-erp-employee-data-ownership.md` (verified);
  `payroll/hr-onboarding-and-employee-forms.md`; `payroll/fcc-employee-master-reference-data.md`
  §7; `admin/gaps.md` → *Departments, roles and their capabilities*.
- **Owner:** Corrina Bustos; Ehtesham Anwar for the permission model.
- **Workaround, if any:** n/a — answered.
- **Status:** resolved — see `decisions/2026-09-15-employee-profile-compensation-type-and-statuses.md` §Q1 (admin-only full SSN, API masks, seeder guidance).

### Q2 — Employee status: which values, and what does each one gate?

- **Question:** The five statuses vs today's three overlapping fields; the gates for each.
- **Why it cannot be answered from what is written:** no employee status vocabulary in the
  vault (`payroll/gaps.md` → PR #488); only *pending* has a written meaning (ADP gate).
- **Blocked:** REQ-06, REQ-31.
- **Candidates:** `payroll/gaps.md` → *Employee-module rules the E2E suite asserts…*;
  `decisions/2026-06-30-adp-erp-employee-data-ownership.md`;
  `dispatch/daily-allocation-system.md` §*Employee & Asset Availability*;
  `payroll/fcc-employee-master-reference-data.md` §7; `payroll/hr-onboarding-and-employee-forms.md` §3.
- **Owner:** Corrina Bustos / Brian Petros; Lisette Anzaldo for dispatch gates.
- **Status:** resolved — see DEC-0915 §Q2 (five values + DRAFT; gate table; `terminated` derived).

### Q3 — Payroll status: values, effect, and owner?

- **Question:** Values, what *Hold* does, who sets it, ERP or ADP field.
- **Why it cannot be answered from what is written:** field exists in no document; nearest
  are the legacy exclusion table and FCC `InOffice`.
- **Blocked:** REQ-07, REQ-31.
- **Candidates:** `payroll/gaps.md` → *The union-classified employee…*, → *Weekly payroll
  week statuses*; `decisions/2026-06-30`; `packages/payroll-engine/src/calculate.ts:978,996`.
- **Owner:** Corrina Bustos.
- **Status:** resolved — see DEC-0915 §Q3 (`ELIGIBLE` / `HOLD`; worklist + export exclusion with issue; ERP-owned).

### Q4 — Compensation Type vs Payroll Group / Pay Type; backfill?

- **Question:** Replace, derive or coexist; what existing rows get.
- **Why it cannot be answered from what is written:** EPF and the vault split on different
  axes; `PAY-009` is itself open.
- **Blocked:** REQ-09.
- **Candidates:** `payroll/INDEX.md`; `payroll/rules/PAY-009`; `payroll/gaps.md` → *Payroll
  has three populations…*; FCC master §7; `packages/shared/src/utils/payroll-group.ts`.
- **Owner:** Brian Petros with Corrina Bustos.
- **Status:** resolved — see DEC-0915 §Q4 (Compensation Type is the source; `payType`/`payrollGroup` derived; override survives; migration backfill; NOT NULL).

### Q5 — Does the field-Employee-Type craft rule survive, and what does the missing-primary report mean now?

- **Question:** Craft required by compensation type only, or also by field type; report scope.
- **Why it cannot be answered from what is written:** `2d3eca09a` is a developer "for now";
  `SCRUM-926` REQ-07 says every employee; EPF §6–7 says non-craft employees need none.
- **Blocked:** REQ-10.
- **Candidates:** commit `2d3eca09a`; `SCRUM-926/spec.md` REQ-07, REQ-27; `payroll/gaps.md`
  → PR #488 (e); `payroll/fcc-employee-types-and-crafts.md` §1.
- **Owner:** Corrina Bustos / Brian Petros.
- **Status:** resolved — see DEC-0915 §Q5 (compensation type governs; type-based hard check retired; field types default the type; report scoped to `CRAFT_HOURLY`).

### Q6 — Over-scale: one amount or FCC's ST/OT/DB triple; does payroll apply it here?

- **Question:** Shape and unit; store-only or price.
- **Why it cannot be answered from what is written:** Kyle's ask and `PAY-CC-02` say "an
  additional rate"; FCC has three columns; `SCRUM-928` owns per-person union pricing.
- **Blocked:** REQ-13.
- **Candidates:** `payroll/gaps.md` → *Pay rate follows the employee…*, → *Confluence payroll
  user stories*; FCC master §*The Employees window*;
  `decisions/2026-08-25-craft-locked-rate-override-scoped-to-union.md`;
  `decisions/2026-09-10-craft-adders-are-into-the-rate-multiplied.md`.
- **Owner:** Corrina Bustos (Kyle Harlow raised it).
- **Status:** resolved — see DEC-0915 §Q6 (one `$/h` amount into the base before multipliers; stored only; `SCRUM-928` prices).

### Q7 — "Custom payroll exceptions" and secondary-craft "approval": what are they?

- **Question:** Shape of the exceptions field; what counts as approval of a secondary craft.
- **Why it cannot be answered from what is written:** EPF lists the field without shape; the
  vault's only exception mechanism is the legacy exclusion table; `SCRUM-926` REQ-08 gives
  secondaries no approval semantics.
- **Blocked:** REQ-15, REQ-18.
- **Candidates:** `payroll/gaps.md` → *The union-classified employee…*; `SCRUM-926/spec.md`
  REQ-08, Q10; `EmployeeCraftAssignment.reason/assignedById`.
- **Owner:** Corrina Bustos; Brian Petros.
- **Status:** resolved — see DEC-0915 §Q7 (group override + free-text note; secondary approval = row with required reason).

### Q8 — Salary frequency: is it Pay Cycle, and which values?

- **Question:** Rename of Pay Cycle or new field; value set.
- **Why it cannot be answered from what is written:** EPF's list is "examples"; `PAY-013`
  names no values; FCC's Pay Cycle is an import field.
- **Blocked:** REQ-27.
- **Candidates:** `payroll/rules/PAY-013`; `payroll/gaps.md` → *Post-import ADP entry… salary
  batch*; `employee-form-options.ts`.
- **Owner:** Corrina Bustos.
- **Status:** resolved — see DEC-0915 §Q8 (it is `payCycle`; four values for salaried; six under *Advanced* for hourly).

### Q9 — Union status for Salaried and Hourly Non-Craft: selected, and does it change anything?

- **Question:** Whether salaried employees carry *Union*, via which control, with what effect.
- **Why it cannot be answered from what is written:** EPF asserts salaried union employees;
  every vault salaried reference is non-union admin.
- **Blocked:** REQ-17.
- **Candidates:** `payroll/rules/PAY-013`; `payroll/gaps.md` → *Payroll has three
  populations…* (Corrina 40:36), → *The union-classified employee…*; FCC master §*Unions
  tab*; `decisions/2026-08-25`.
- **Owner:** Corrina Bustos.
- **Status:** resolved — see DEC-0915 §Q9 (selected, optional, informational; `resolvedUnionKind` defined).

### Q10 — The nineteen shipped fields EPF does not mention: keep, move, or drop?

- **Question:** Per field: keep where, or drop.
- **Why it cannot be answered from what is written:** EPF is silent; they exist because the
  FCC import brought them.
- **Blocked:** REQ-02, REQ-25.
- **Candidates:** FCC master §7, §*The Employees window*; `payroll/gaps.md` → *Home yard cannot
  come from ADP*; `decisions/2026-06-30`; `erp-review-log.md`:166-171.
- **Owner:** Corrina Bustos / Brian Petros.
- **Status:** resolved — see DEC-0915 §Q10 (nothing dropped; Employment Details section; *Advanced* disclosure; Notes stays a tab).

### Q11 — Custom subsistence / on-call: what is stored on the employee?

- **Question:** Amount override, flag, or note; what "on-call" is.
- **Why it cannot be answered from what is written:** the 2026-09-01 decision leaves the field
  unsettled; "on-call" appears nowhere.
- **Blocked:** REQ-19.
- **Candidates:** `decisions/2026-09-01-subsistence-not-a-craft-attribute.md`;
  `payroll/gaps.md` → *Subsistence — the recording and the engine disagree*, → *Home yard
  cannot come from ADP*; Kyle Harlow 2026-08-13 20:34.
- **Owner:** Corrina Bustos.
- **Status:** resolved — see DEC-0915 §Q11 (short + long daily overrides + note; stored only; on-call not built).

### Q12 — Changing Compensation Type on an existing employee: retain, clear, or block?

- **Question:** Fate of the previous type's values; whether to record the switch date.
- **Why it cannot be answered from what is written:** EPF describes end states only; the
  craft-history gap is open.
- **Blocked:** REQ-20.
- **Candidates:** `payroll/gaps.md` → *Craft assignment has no history*; Brian Petros
  2026-09-10; `employee-craft-assignments.service.ts:74`.
- **Owner:** Corrina Bustos / Brian Petros.
- **Status:** resolved — see DEC-0915 §Q12 (hide, never clear, never block; activity log is the history).

### Q13 — Temporary employees: the same sectioned page minus Managed Assets?

- **Question:** Same page minus one section, or a shorter profile.
- **Why it cannot be answered from what is written:** EPF never mentions temps; the 3-step
  wizard is unsourced.
- **Blocked:** REQ-28.
- **Candidates:** `payroll/gaps.md` → PR #488 (a), → *Fill-in field employees…*;
  `dispatch/daily-allocation-system.md` §*Temporary Employee management*; `SCRUM-926` REQ-27.
- **Owner:** Lisette Anzaldo with Corrina Bustos.
- **Status:** resolved — see DEC-0915 §Q13 (same page minus Managed Assets; full payroll profile).

### Q14 — Salary earning code / payroll export mapping on the employee: which code, from where?

- **Question:** Picklist over ADP earning codes, free string, or not on the employee.
- **Why it cannot be answered from what is written:** no salary earning code appears in any
  export the vault has seen; the SALARY batch is manual.
- **Blocked:** REQ-11, REQ-12 (the two bullets).
- **Candidates:** `payroll/adp-hour-earning-codes.md`; `payroll/adp-workbook-vba-macros.md`;
  `payroll/gaps.md` → *Post-import ADP entry… salary batch*.
- **Owner:** Corrina Bustos.
- **Status:** resolved — see DEC-0915 §Q14 (not on the employee; belongs to export configuration).

### Q15 — Secondary craft rows: no "who assigned it" in the read select (found building U7)

- **Question:** REQ-15 says each secondary-craft row shows who assigned it and when. The
  craft-assignment read select
  (`apps/api/src/service/employee-craft-assignments/employee-craft-assignments.repository.ts`
  `CRAFT_ASSIGNMENT_SELECT`) returns `createdAt` (now surfaced in
  `apps/web/src/features/craft-codes/services/craft-assignments.service.ts`'s `CraftAssignment`
  type, U7) but never joins `assignedBy`, even though `EmployeeCraftAssignment.assignedById`
  is a real column the assign endpoint writes. Should the select gain
  `assignedBy: { select: { id, name } }` so the web can show a name, or is "when" (already
  shown) enough for this ticket?
- **Why it cannot be answered from what is written:** REQ-15's own source citations
  (`EPF §9`, `SCRUM-926/spec.md` REQ-08, DEC-0915 Q7) describe the requirement but not the
  select shape; nothing in the vault says the name was deliberately left out.
- **Blocked:** REQ-15's "who assigned it" half only — "when" ships in this unit.
- **Candidates:** none found; a straightforward select-clause addition once someone confirms
  it's wanted.
- **Owner:** whoever owns the craft-assignment API surface next (U4's author or later).
- **Workaround shipped:** `apps/web/.../form/payroll/secondary-craft-rows.tsx`'s edit-mode
  rows show the assigning date only ("Assigned <date>"), no name.
- **Status:** open.

## 13. What this spec deliberately does not specify

- **Pricing** with over-scale, salary amount, hourly-rate effective dates or the subsistence
  overrides — stored only. `contexts/payroll-engine.md` forbids a pay-rule change without
  provenance; `SCRUM-928`, `PAY-013`, `PAY-068` and the subsistence rule own these.
- **"Secondary craft codes should not reduce the employee's pay below their primary craft
  code rate"** (EPF §9) — a pricing rule; `SCRUM-926` Q13 / `PR-015` is the open item.
- **Structured certifications** (EPF §13 "Later") — `payroll/gaps.md` → *Employee
  certifications — types and scope* stays open.
- **A fifth attachment category *Certificates*** — not added; the certificate-tagged view is
  the certificates list.
- **Multiple emergency contacts** (Corrina 2026-05-04) — not in EPF.
- **Department / Role / Employee Type consolidation** — instruction 3; `payroll/gaps.md` →
  *Field role vs portal role* stays open.
- **Salary earning code / export mapping on the employee** — DEC-0915 Q14; export config.
- **On-call arrangements** — DEC-0915 Q11; nothing at TCG asks for it.
- **New list views for the new statuses** — `NOT SPECIFIED`; the existing views keep their
  semantics (Inactive = `INACTIVE` only).
- **Wiring `ON_LEAVE` to the leave-request module** — DEC-0915 Q2 leaves it unwired.
- **The E2E suite** — instruction 4. `qa-automation/e2e/specs/employees/*` will fail after
  merge on `employee-wizard-next/back`, the stepper, the fifth required field and the
  detail-page labels; recorded so the failure is read as expected.
- **Every system-wide sub-doc A–I** — referenced, not built.
- **ADP push/pull of the employee record** — `decisions/2026-06-30` lifecycle; not here.
- **TCG's agreement** — every DEC-0915 answer is `status: reference`; the owners named in §12
  can overrule any of them, and the spec then changes.

## 14. Sign-off before build

- [x] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person —
      Q1–Q14 answered by Syed Haris (developer) on 2026-09-15, DEC-0915
- [x] Every `[CONFLICT]` requirement has a decision note — `N/A — none flagged`
- [x] Answers written back into `spec.md` with their new sources and flags — revision 2
- [x] Every §12 question updated to `Status: resolved — see decisions/…`
- [x] Every §11a ripple row has a source for what happens to that consumer, or a §12 question
- [ ] Decomposed into vertical units — `units.md`

Answered by: Syed Haris (developer decision, `status: reference`)  Date: 2026-09-15

---

**Closing block (elaborator §1).** This run produced `intent.md`, `spec.md` (two revisions)
and one decision note, and built nothing. All 31 requirements are sourced; none is open. The
answers are a developer's, recorded as such, and every one names the TCG person who would
overrule it. Next step: `tcg-decomposer` → `units.md`.
