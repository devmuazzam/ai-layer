# Intent — TCG-237

> Ticket capture from Linear (`the-crane-guys` workspace). Not a spec, not a design. Nothing
> here is sourced from the vault yet — that happens in `spec.md`.
>
> Capture is by the elaborator run for Syed Haris, from the Linear issue read on 2026-10-20
> and from the developer's scope instructions given in the same session. Where a line comes
> from the session rather than the ticket, it says so.

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `TCG-237` (Linear) — https://linear.app/the-crane-guys/issue/TCG-237 |
| Title | One role per employee: replace Employee Type with departments and roles |
| Type | Feature (Linear label), labels also `mobile`, `frontend`, `backend`, `admin`, `payroll` |
| Status | In Progress |
| Epic | `NOT ON TICKET` (no parent issue shown) |
| Sprint | `NOT ON TICKET` (Linear shows no cycle on the issue) |
| Reporter | syed haris |
| Assignee | syed haris |
| Captured on | `2026-10-20` (ticket `createdAt` and `updatedAt` are both 2026-10-20T00:20Z) |
| Captured by | tcg-elaborator (Claude Code session for Syed Haris, developer of record) |

Ticket state moves. If the Linear description is edited after 2026-10-20, the spec built
from this intent is stale and §8 of the elaborator's sign-off check re-diffs it.

## 2. Business intent

- Intent: today an employee has three separate picks — Department, Role and Employee Type
  — that overlap, and the app decides behaviour by matching names such as "Operator" or
  "Salesmen". The ticket replaces Employee Type with roles so there is one list; a person's
  role decides both their job and what they can see in the system.
- Who benefits (role): dispatcher (who can be scheduled into which position), admin / HR
  (one list to maintain), sales (not appearing in dispatch), field crew (app experience and
  access follow the role).
- What is worse today without it: `NOT ON TICKET` beyond the Goal sentence above. The vault
  records the symptoms (UAT 1 "Sales Persons should not be displayed" in DAS; FCC secondary
  types dropped by the seeder) but the ticket does not cite them.

## 3. Definition of done, as the ticket states it

The ticket has no acceptance-criteria section. It has a **Goal**, **What TCG agreed**, and
**Still open**. Verbatim:

```
## Goal

Today an employee has three separate picks: **Department**, **Role** and **Employee Type**. They overlap, and the app decides things by matching names like "Operator" or "Salesmen". This ticket replaces Employee Type with roles, so there is one list. A person's role decides both their job and what they can see in the system.

## What TCG agreed (Corrina Bustos, 2026-10-20)

* **Nine departments:** Field Operations, Shop, Yard, Dispatch, Sales, Accounting, Safety, HR, Management.
* **One main role per person, plus a list of other positions they can fill.** For example, an Operator can also fill Oiler, Rigger or 3rd Man, and an HDR mechanic can also fill 3rd Man or Rigger. The main role decides what they can see.
* **Who can go on a job ticket:** field crew, HDRs, the Crane Superintendent and Local 12 managers, each in the position they fill that day. Yard techs never go on a job ticket.
* **Job Foreman is not a role.** The foreman is picked per job.
* **Payroll Admin sits in HR.** A temp fill-in uses the same role as a regular employee.
* **Changing roles:** the Dispatcher assigns someone's role, and the Dispatch Manager approves. Corrina, Melissa, Joe or Lisette change what a role is allowed to do.

## Still open

* Can one person get extra access on top of their role? Corrina is checking with Ryan.
* Can Sales Coordinators still assign roles, or only the Dispatcher?
* What each role is allowed to see and do. Roles start from templates, and TCG adjusts them.

## Where the detail lives

The decision record is in the vault: `vault/decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md`. The spec will follow in `.ai/aidlc/`.
```

- Acceptance criteria present on the ticket: **no**
- `OPEN — ticket has no acceptance criteria; per domain/jira-sop.md it does not meet Definition of Ready.` The "What TCG agreed" list is a record of a client decision, not a testable done-condition. The spec writes acceptance lines per requirement.

## 4. In scope

From the developer's session instructions (2026-10-20), not from the ticket text. These are
scope statements, not decided structure.

- [ ] Roles replace Employee Type everywhere it is picked or read: slot / resource pickers,
      billing codes, DAS employee list and slot fit, mobile persona.
- [ ] Behaviour flags on the role replace name matching.
- [ ] A "can also fill" list per employee.
- [ ] Dispatchability as a role setting, closing the UAT-1 Sales-in-DAS row by rule rather
      than by a hardcoded exclusion.
- [ ] Seeding the nine departments and their roles.
- [ ] Migrating existing employees' types to roles.
- [ ] The role-behaviour editor section: rename "Use as an employee type", show boom pay /
      inspections only when the role is dispatchable, hide quote approval for dispatchable
      roles. **Proposals needing a decision, not settled.**

## 5. Out of scope

From the developer's session instructions.

- [ ] The request / approval flow for role changes (Corrina Q7 — unbuilt; new behaviour).
- [ ] Per-person extra access on top of a role (pending Ryan Adams via Corrina).
- [ ] Work orders (yard / mechanic time).
- [ ] Foreman designation per job (the per-job pick itself).
- [ ] Pay rules and pay derivation (`CraftRoleType`, craft codes) — `contexts/payroll-engine.md`
      forbids a pay-rule change without provenance.
- [ ] **This ticket overrides one earlier scope note, explicitly.**
      `.ai/aidlc/SCRUM-EMPLOYEE-PROFILE/intent.md` §5 kept Department / Role / Employee Type
      "exactly as they are … no `DepartmentRole.usedAsEmployeeType` cut-over". That was a
      scoping instruction for that ticket (session instruction 3, 2026-09-15), not a product
      ruling. TCG-237 supersedes it for this area.

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS — presentation / usecase / service) | yes | Pickers and readers move from `EmployeeType` to role; name-matching checks; DAS employee query; seeding; employee DTOs |
| `apps/api/prisma` (schema + migration) | yes | Role-side model for can-also-fill; data migration of employee types to roles; fate of `EmployeeType` table and its FKs |
| `apps/web` (Next.js) | yes | Employee form, quotation / billing-code / DAS / sub-category pickers, role editor |
| `apps/mobile` (Expo Router) | yes | Persona resolution (reads `employeeType.name` today), quote picker, field-ticket flow steps |
| `packages/shared` (types shared across apps) | yes | Name constants and helpers (`SALESPERSON_TYPE_NAME`, `OILER_TYPE_NAME`, `visibleFlowStepKeys`, `RoleAppPersona`) — web and mobile both downstream |

Notes for the elaborator: a `yes` on `apps/api/prisma` means a committed migration is
mandatory; a `yes` on `packages/shared` means both front-ends are downstream.

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `Department` | `departmentCode` / `DEPT-…` (seed uses `DEPT-ACCOUNTS`, `DEPT-SALES`, …) | reads / creates (nine) / possibly retires the fifteen seeded |
| `DepartmentRole` | `roleCode` | reads / creates / extends |
| `Employee` | `employeeCode` | reads / changes its type and role links |
| `EmployeeType` | none — global table, `name` unique, no tenant column | reads / retires or freezes — `NOT ON TICKET` |
| `BillingCode`, `QuotationResource`, `JobResource`, `SubCategoryAssociatedResource` (+ nested setting) | existing | change the FK they pick from |

- New entity introduced by this ticket: **? — NOT ON TICKET.** "Can also fill" needs
  somewhere to live; whether that is a new table is a developer decision (spec §11b).
- New code prefix introduced: **no, as far as the ticket says.** `NOT ON TICKET`.
- Existing rows affected (backfill / migration of data, not just schema): **yes** — every
  employee with a type, and every quotation resource, job resource, billing code and
  sub-category association that points at an `EmployeeType` row.

## 8. Roles and permissions

- Roles that can perform this: `NOT ON TICKET` for performing the migration or using the
  new pickers. For the later flows the ticket names: Dispatcher assigns a role; Dispatch
  Manager approves; Corrina, Melissa, Joe or Lisette edit what a role can do.
- Roles explicitly excluded: yard techs from job tickets. Nothing else is stated.
- Tenant scope: standard per-tenant isolation assumed; `NOT ON TICKET`. Note `EmployeeType`
  is global (no tenant column) while `DepartmentRole` is per tenant.

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | `NOT ON TICKET` |
| Linear attachments / documents | none on the issue |
| Related tickets | `SCRUM-EMPLOYEE-PROFILE` (scope note it overrides); `TCG-218` / `SCRUM-877` / `SCRUM-914` mentioned by vault entries as neighbours |
| Existing repo docs | `.ai/vault/decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md` (named on the ticket) |
| Vault area the reader thinks is relevant | `admin/gaps.md` (departments and roles; per-person access), `payroll/gaps.md` (employee types; field role vs portal role), `dispatch/gaps.md` (Sales Persons in DAS), `payroll/adp-api-responses/workers-departments-2026-10-20.md`, `decisions/2026-09-04-system-departments-and-roles-carry-no-restrictions.md` |

## 10. Terms used that may not be defined

- **HDR** — ticket: "field crew, HDRs, the Crane Superintendent and Local 12 managers" and
  "an HDR mechanic can also fill 3rd Man or Rigger". Not defined on the ticket.
- **Local 12** — "Local 12 managers". Union local; no definition on the ticket.
- **3rd Man** — "can also fill Oiler, Rigger or 3rd Man". Position name; no definition.
- **Crane Superintendent**, **Dispatcher**, **Dispatch Manager** — used as roles; the role
  list is not on the ticket.
- **Dispatchable** — used in the developer's scope instruction ("dispatchability as a role
  setting"), not on the ticket. FCC's own attribute is `Dispatchable on`.
- Known-undefined vault terms touched: `fcc`, `das`, `craft-code`.

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| Nine departments (Field Operations, Shop, Yard, Dispatch, Sales, Accounting, Safety, HR, Management) | "Corrina Bustos, 2026-10-20" |
| Example can-also-fill sets (Operator → Oiler, Rigger, 3rd Man; HDR mechanic → 3rd Man, Rigger) | "Corrina Bustos, 2026-10-20" (examples, not the complete set) |
| Named approvers / editors (Dispatch Manager; Corrina, Melissa, Joe, Lisette) | "Corrina Bustos, 2026-10-20" |

No thresholds, lengths or timings on the ticket.

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: Epic, Sprint, "what is worse today", design handoff, new
  entity / prefix, roles that can perform, tenant-scope exception, plus all of §4 and §5
  (those come from the session, not the ticket) — **8**
- Fields left as `OPEN`: acceptance criteria — **1**
- Is this ticket, as written, buildable without a product answer? **No.**
- Blocking questions, which the elaborator carries into `spec.md` §12: the full role list
  per department; what each existing employee type becomes; whether FCC's secondary types
  load as can-also-fill; what each role may do; per-person access (Ryan Adams); whether
  Sales Coordinators assign roles; the mobile app experience per kind of user.

---

**Next step:** `spec.md` beside this file. The elaborator stops after writing it.
