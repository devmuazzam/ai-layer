# Intent — SCRUM-EMPLOYEE-PROFILE

> Captured from the staged product document `employee-profile-feature.md` beside this file
> (composed 2026-09-15, `composer_run: manual-codex-2026-09-15`, `source_count: 0`) and the
> two instructions given with it in session on 2026-09-15. There is no Jira ticket yet — the
> folder name is a placeholder, as `SCRUM-CREW-TICKET` and `SCRUM-LIFECYCLE` are.

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-EMPLOYEE-PROFILE` — **placeholder, no Jira id yet** |
| Title | Employee Profile Feature |
| Type | Story |
| Status | Not on Jira |
| Epic | `NOT ON TICKET` |
| Sprint | `NOT ON TICKET` |
| Reporter | Syed Haris (hariscops) |
| Assignee | `NOT ON TICKET` |
| Captured on | `2026-09-15` |
| Captured by | Claude (Opus 5), in session for Syed Haris |

Ticket state moves. Everything below is a snapshot of the document on *Captured on*.

## 2. Business intent

- Intent: make the Employee Profile the single employee-specific record — identity, org
  placement, status, **a payroll profile whose fields follow the employee's compensation
  type** (craft-based hourly / hourly non-craft / salaried), managed assets, emergency
  contact and attachments/certifications — while every reusable list (departments, roles,
  craft codes, modifiers, payroll/subsistence/salary rules, ADP mapping) stays outside the
  record. `employee-profile-feature.md` §Purpose, §Final Model.
- Who benefits (role): payroll (Corrina Bustos' team), HR/onboarding, dispatch, admin.
- What is worse today without it: `NOT ON TICKET` — the document states the target model,
  not the pain. The observable gap is that today's form shows every payroll field to every
  employee regardless of how they are paid (`apps/web/src/features/employees/components/
  create/sections/payroll-fields.tsx`) and salaried pay has no fields of its own
  (`vault/payroll/rules/PAY-013` — "how salary *is* paid remains unspecified").

## 3. Definition of done, as the ticket states it

```
The document has no acceptance criteria. Its normative sentences, verbatim:

§1  "Employee ID may be manually entered or auto-generated."
    "SSN should be optional or dummy-only in UAT/demo tenants."
§2  "Each employee should belong to a department and have an operational role."
    "Department and operational role are employee/org configuration, not payroll configuration."
§3  "Employee status is different from payroll status."
§4  "The fields shown in the Payroll Profile depend on the employee's compensation type."
    "Recommended compensation types: Craft-Based Hourly / Hourly Non-Craft / Salaried"
§6  "Craft codes, craft modifiers, boom pay, and subsistence should not be required for salaried employees."
§7  "Hourly Non-Craft is for hourly employees whose payroll is not driven by craft code or boom/craft modifiers."
§8  "For Craft-Based Hourly employees, the employee's primary craft code should match the employee's operational role."
§9  "Secondary craft codes may differ from the employee's assigned operational role."
    "This should only be allowed when the employee is qualified/approved to work that higher-paid role."
    "Secondary craft codes should not reduce the employee's pay below their primary craft code rate."
§10 "Employee-specific over-scale should live on the employee payroll profile."
    "Final employee pay floor = craft rate + over-scale"
    "Do not modify shared craft code rates for one employee's special pay arrangement."
§11 "Union status cannot be derived only from craft code because salaried employees may also be union."
    "For Craft-Based Hourly employees, union status can be derived from the selected craft code."
    "For Salaried or Hourly Non-Craft employees, union status should be selected directly or derived from a separate payroll classification rule."
    "The resolved union status should be visible on the Payroll Profile."
§12 "If employees are assigned assets, the Employee Profile may include managed or assigned assets."
§13 "For now, certifications can be stored as attachments."
    "Later, certifications should become structured records with: Certificate type / Issuing agency / Issue date / Expiry date / Status / Attachment / Dispatch/payroll impact, if any"

Session instructions, 2026-09-15 (Syed Haris):
  "spec this feature, all of this will be in main"
  "The section separation will be like in agency with blue backgroung, and make sure to spec the conditional flow"
  "keep department role and employee type the same as we've now"
```

- Acceptance criteria present on the ticket: **no**
- If no: `OPEN — the document has no acceptance criteria; per domain/jira-sop.md it does not
  meet Definition of Ready. Its "should"/"may" sentences above are treated as the ask.`

## 4. In scope

Reading of *"all of this will be in main"*: **the whole document is one ticket** — nothing
in it is deferred to a later ticket except what the document itself defers (§13 "Later").

- [ ] Employee create/edit form rebuilt as **one page of `SectionCard`s with the in-card
      accent header** (icon tile + tinted gradient header — the agency form's look), replacing
      the five-tab wizard.
- [ ] Sections: Basic Information · Department & Role · Employee Status · Payroll Profile ·
      Managed Assets · Emergency Contact · Attachments & Certifications.
- [ ] **Compensation Type** on the payroll profile; the payroll fields shown, required and
      saved **follow the chosen type** (the conditional flow), with the switch-over behaviour
      when the type changes on an existing employee.
- [ ] Craft-Based Hourly: ADP file number, primary craft (filtered to the operational role's
      craft role type), secondary crafts, over-scale, payroll status, custom exceptions,
      custom subsistence.
- [ ] Salaried: ADP file number, salary amount, frequency, effective dates, payroll status,
      union status, earning code / export mapping, custom exceptions.
- [ ] Hourly Non-Craft: ADP file number, hourly rate, effective dates, payroll status, union
      status, export mapping, custom exceptions.
- [ ] Employee status list with **payroll status as a separate field**.
- [ ] Union status resolved (derived for craft-based, selected otherwise) and shown.
- [ ] Employee ID manual-or-generated; SSN masked and permission-controlled.
- [ ] Managed assets, emergency contact, attachments kept as they are, re-housed in sections.
- [ ] Detail page restructured to the same sections.

## 5. Out of scope

- [ ] **Department, Role (`DepartmentRole`) and Employee Type stay exactly as they are** —
      three fields, same pickers, same tables (instruction 3). The document's "operational
      role" maps onto today's Employee Type; no merge, no `DepartmentRole.usedAsEmployeeType`
      cut-over.
- [ ] Structured certifications (type / agency / dates / status / dispatch impact) — §13 says
      "Later"; this ticket keeps certificates as categorised attachments.
- [ ] Every "system-wide sub-doc" A–I — craft codes, craft modifiers, payroll rules,
      subsistence rules, salary rules, ADP export mapping, asset/crane payroll configuration.
      This ticket only *references* them from the employee record; it does not build or
      change their admin screens.
- [ ] Payroll-engine changes that would *use* the new fields (over-scale in the rate
      resolver, salary-period amount from a real salary, non-union effective dating) —
      `contexts/payroll-engine.md` forbids a pay-rule change without a provenance entry in
      the same commit, and no source supplies one. Fields are stored; the engine is not
      re-wired here.
- [ ] Leave requests, portal invitations, temp-employee wizard (`temp-employees/*` routes)
      — untouched except where the shared form components move.
- [ ] Mobile.
- [ ] ADP push/pull of the employee record.

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS) | yes | create/update employee DTO + service: compensation type, payroll status, salary fields, over-scale, resolved union status; per-type validation |
| `apps/api/prisma` | yes | new columns on `employees` (compensation type, payroll status, salary amount/frequency/effective dates, over-scale, custom exceptions/subsistence notes) — see spec §3 |
| `apps/web` | yes | employee create/edit rebuilt as sectioned single page; detail page sections; new payroll-profile components |
| `apps/mobile` | ? | reads employee type / role only; spec §11a must establish whether any moved field is read |
| `packages/shared` | yes | `CompensationType`, `PayrollStatus`, `SalaryFrequency` enums + labels; `derivePayrollGroup` / `payrollSetupWarnings` gain a compensation-type input |

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `Employee` | `employeeCode` / `EMP-#####` | reads, creates, edits (code stays manual-or-minted as today) |
| `EmployeeCraftAssignment` | — (child, by UUID) | reads / writes PRIMARY + SECONDARY rows |
| `CraftCode` | `code` | reads (picker) |
| `EmployeeUnionCode` | `code` | reads (union status picker) |
| `Department` / `DepartmentRole` / `EmployeeType` | `departmentCode` / `roleCode` / — | reads, unchanged |
| `EmployeeAsset`, `EmergencyContact`, `Address`, `Attachment` | — | reads / writes, unchanged shape |

- New entity introduced by this ticket: no (columns on `Employee`; see spec §3 for the one
  place a child table is the honest answer)
- New code prefix introduced: no
- Existing rows affected (backfill): **?** — every existing employee needs a compensation
  type; whether it is derived from `payType`/craft or left null is a spec §12 question

## 8. Roles and permissions

- Roles that can perform this: `NOT ON TICKET` — today's employee module permissions apply
- Roles explicitly excluded: `NOT ON TICKET`
- Tenant scope: standard per-tenant isolation
- SSN: "masked and permission controlled" — **which permission** is `NOT ON TICKET`

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | `NOT ON TICKET` — the visual reference is the shipped agency form (`apps/web/src/features/agencies/views/agency-form.tsx`, PR #593) |
| Jira attachments | `N/A — no ticket` |
| Related tickets | `SCRUM-926` / `SCRUM-927` (craft codes, primary/secondary assignments), `SCRUM-928` (employee-specific rate adjustments — named in `decisions/2026-08-25-craft-locked-rate-override-scoped-to-union.md`), `SCRUM-914` (employee types), PR #488 (`qa-automation` employee specs) |
| Existing repo docs | `.ai/vault/payroll/INDEX.md`, `.ai/vault/payroll/gaps.md` → *Employee-module rules the E2E suite asserts…*, *Payroll has three populations…*, *The union-classified employee…*, *Pay rate follows the employee…* |
| Vault area | `payroll/` (owns `employee*` per `STRUCTURE.md`), `decisions/2026-06-30-adp-erp-employee-data-ownership.md`, `decisions/2026-08-25-non-union-base-rate-per-person.md`, `decisions/2026-08-20-craft-locked-rate-override.md`, `decisions/2026-09-01-subsistence-not-a-craft-attribute.md` |

## 10. Terms used that may not be defined

- **Compensation type** — "The fields shown in the Payroll Profile depend on the employee's
  compensation type." Not a vault term; the vault's nearest concept is the five-value
  **Payroll Group** (`PayrollGroup` enum) and FCC's `PayType` H/S.
- **Operational role** — "Each employee should belong to a department and have an
  operational role." Per instruction 3, maps to today's Employee Type.
- **Payroll status** — "Employee status = Active / Payroll status = Hold payroll". Not a vault
  term. Nearest: ADP-owned "payroll status" in the 2026-06-30 decision; legacy
  `cfg.PayrollUI_ExcludedEmpID`.
- **Over-scale / additional hourly bump** — FCC has Over Scale ST/OT/DB columns; Kyle Harlow
  asked for an over-scale box (2026-08-13).
- **Custom payroll exceptions** — "Custom payroll exceptions" listed as a field; nothing says
  what shape (free text? structured?).
- **Custom subsistence/on-call arrangement** — Kyle Harlow 2026-08-13 20:34 (employee-level
  sub per employment agreement); "on-call" appears nowhere in the vault.
- **Salary earning code / payroll export mapping** — the ADP earning-code table exists
  (`payroll/adp-hour-earning-codes.md`); no salary code is named.
- **craft-code** — one of the nine known-undefined vault terms.

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| Compensation types: Craft-Based Hourly · Hourly Non-Craft · Salaried | `NOT ON TICKET — no origin cited` ("Recommended") |
| Employee statuses: Active · Inactive · Terminated · On leave · Pending onboarding | `NOT ON TICKET — no origin cited` ("Recommended") |
| Payroll statuses: Payroll eligible · Hold payroll | `NOT ON TICKET — given as examples only` |
| Salary frequencies: Weekly · Biweekly · Monthly | `NOT ON TICKET — "examples"` |
| Department examples (8) and operational role examples (9) | `NOT ON TICKET — "Examples"` |
| Attachment categories: Training records · Performance reports · Classification documents · Drug test reports · Certificates | `NOT ON TICKET — "may include"` |
| Pay floor formula `craft rate + over-scale` | `NOT ON TICKET — "Preferred model"` |

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: 9 — epic, sprint, assignee, pain today, roles permitted,
  roles excluded, SSN permission, design handoff, every enumerated value's origin
- Fields left as `OPEN`: 1 — acceptance criteria
- Is this ticket, as written, buildable without a product answer? **no**
- If no, the blocking questions are carried into `spec.md` §12: the compensation-type ↔
  payroll-group relationship and backfill; the payroll status vocabulary and what "hold"
  does; over-scale semantics (single ST amount vs FCC's ST/OT/DB triple, and whether payroll
  reads it in this ticket); the salaried field set (amount, frequency, earning code) and who
  owns the SALARY batch; union status source for non-craft employees; the shape of "custom
  payroll exceptions" and "custom subsistence"; the employee status list vs today's
  `status`/`terminated`/`employeeStatus` triple; SSN permission; which existing employee
  fields (`payRateOT/DB`, `billingRate*`, `payCycle`, `payType`, `type`, `classification`,
  `burden`, `certifiedPay`, `supervisor`, `workCompCodeId`, `rank`, `unit`) survive the new
  section layout.

---

**Next step:** `spec.md` beside this file.
