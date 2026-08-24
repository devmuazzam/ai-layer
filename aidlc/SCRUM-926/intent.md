# Intent — SCRUM-926

> Captured from the epic `SCRUM-926` *Craft code* and its four child tasks. One intent for
> the epic because the four tasks share one schema change and one resolver; the units in
> `units.md` map one-to-one onto the child tasks.
>
> This file captures **what the tickets ask for**, from the tickets. Nothing here is
> sourced from the vault yet — that happens in `spec.md`.

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-926` (epic) — children `SCRUM-925`, `SCRUM-927`, `SCRUM-934`, `SCRUM-935`; `SCRUM-928` is a child **excluded** from this intent (see §5) |
| Title | Craft code |
| Type | Epic, with Task children |
| Status | To Do (all) |
| Epic | `SCRUM-926` itself; the payroll parent epic is `SCRUM-920` *Payroll management* |
| Sprint | NOT ON TICKET |
| Reporter | Umair Khan (925/926/927/928), Syed Haris (934/935) |
| Assignee | ali riaz (925, 927, 934, 935); 926 and 928 unassigned |
| Captured on | 2026-08-24 |
| Captured by | Syed Haris (via Claude Code) |

Ticket state moves. Everything below is a snapshot of the tickets on *Captured on*.

## 2. Business intent

Payroll today prices union labor from a craft-rate table in FCC and non-union labor from a
per-person rate on the employee record, with the boom premium looked up from 33 hand-keyed
bracket rows. The ERP must replace all three with one backend foundation: a craft code that
carries the base rate (effective-dated), an employee that always has a primary craft, and a
boom modifier scale that reproduces the union brackets without storing them. The payroll
engine (later tickets under `SCRUM-920`) will call one resolver and never read a rate off
the employee.

- Intent: give payroll one explainable source for base rate and boom adder per labor entry.
- Who benefits (role): payroll admin, crane superintendent (day-level craft assignment),
  accounting (ADP export codes), dispatch (temp employees get a craft on creation).
- What is worse today without it: two rate sources that can disagree (`Employee.hourlyRate`
  vs craft table), a union flag that is a free-text label, and a bracket table nobody has
  versioned since 2020.

## 3. Definition of done, as the tickets state it

`SCRUM-925` *Manage Craft Code*:

```
* The system allows a craft code to be configured with its identifier and name.
* A craft code can be marked active/inactive rather than deleted.
* Craft codes include the applicable union classification/rule classification.
* Craft code rates can have an effective date.
* The employee's assigned craft code determines their base payroll rate.
* Different craft groups can have different rates.
```

`SCRUM-927` *Assign craft codes to Employees*:

```
* A craft code can be assigned to an employee.
* An employee can have a primary craft code or secondary one
* The employee's craft code and rate are available to payroll calculations.
* Employees on the same job can have different craft codes and pay rates.
```

`SCRUM-934` *Craft modifier scale — boom-length brackets computed at runtime*: acceptance
criteria as written on the ticket (created 2026-08-24 from the approved plan; see the ticket
body — scale fields, pure tier function `max(1, ceil((ft−initial)/gap))`, preview endpoint,
activity log, no dates, no seed, backend only).

`SCRUM-935` *Craft rate resolver service*: acceptance criteria as written on the ticket
(resolver methods, work-date keyed lookups, Blocked result on missing rate / window / scale,
employee rate fields never read, listed unit tests, backend only).

- Acceptance criteria present on the ticket: yes (all four)

## 4. In scope

- [ ] New `CraftCode` table replacing the FCC-migrated `EmployeeCraftCode` picklist: `code`, `label`, `description?`, `status`, `unionCodeId` (required), `roleType` (required enum), `startDate`, `endDate?`.
- [ ] New `CraftCodeRate` table: effective-dated base ST rate per craft; one row in force per date.
- [ ] `EmployeeUnionCode` extended with required `kind UNION | NON_UNION`, optional `localNumber`, `agreement`.
- [ ] New `EmployeeCraftAssignment`: `PRIMARY | SECONDARY`, current-state only, exactly one PRIMARY per employee, required on employee create (permanent and temporary).
- [ ] New `CraftModifierScale`: one ACTIVE per union code; tiers/adders/codes/labels computed at runtime; preview endpoint.
- [ ] `CraftRateResolverService` with the tests listed on `SCRUM-935`.
- [ ] Schema-only migrations (add tables/columns/enums). **No data migration**: `CraftCode` starts empty; admins create crafts, rates and PRIMARY assignments by hand; an admin report lists employees with no PRIMARY.
- [ ] DAS union filter (two call sites) uses the PRIMARY craft's `unionCode.kind`, falling back to the legacy `unionStatus` string while an employee has no PRIMARY.
- [ ] New `craft-codes` module; existing `employee-craft-codes` routes untouched for web/mobile.
- [ ] Non-union base rate stays per person on `Employee.hourlyRate` (FCC practice); resolver branches on `unionCode.kind`.

## 5. Out of scope

- [ ] `SCRUM-928` *Support Employee-Specific Rate Adjustments* — Confluence PAY-CC-03, unadjudicated; the resolver leaves an extension point, nothing is built.
- [ ] Per-day secondary craft **on the labor entry**, boom length on the labor entry, and pricing at final customer signature — payroll labor-entry tickets under `SCRUM-920`.
- [ ] Lattice, foreman, military-base and shift premiums — *Payroll Premiums*, separate tickets.
- [ ] Any web or mobile UI. Web/mobile only need to keep compiling against the renamed contract.
- [ ] Vendor employees (`VendorEmployee`) — paid by PO, never on payroll, no craft.
- [ ] Prevailing wage / jurisdiction / eligible assets / per-diem / billing linkage on the craft (present in the design mock, removed by product decision 2026-08-24).
- [ ] Seed data of any kind (L12 rates, L12 scale) — admins enter them through the API (decision 2026-08-24, Syed Haris).
- [ ] Craft history per employee (promotions). Assignments are current state; the activity log is the history.
- [ ] Dropping `employee_craft_codes`, `Employee.craftCodeId` / `unionCodeId` / `unionStatus`, `payRateOT` / `payRateDB`, and the `payRateDB → payRateDT` rename — a later cleanup ticket once every employee has a PRIMARY.

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS — presentation / usecase / service) | yes | `craft-codes` (replaces `employee-craft-codes`), `craft-modifier-scales`, `employee-craft-assignments` modules; `CraftRateResolverService`; `employee` create requires a primary craft; DAS union filter |
| `apps/api/prisma` (schema + migration) | yes | 4 new models, 1 extended (`EmployeeUnionCode.kind`, filled by label match in the ADD migration). **No drops, no data copy, no backfill** — legacy table/columns stay until a later cleanup |
| `apps/web` (Next.js — atoms → pages) | ? | no feature work; must keep compiling — `EmployeeCraftCode` select shape, `Employee.craftCodeId`, `unionStatus` are read today |
| `apps/mobile` (Expo Router) | ? | same as web |
| `packages/shared` (types shared across apps) | yes | craft-code / employee DTO shapes move |

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `CraftCode` (new) | `code` — admin-typed, e.g. `L12-G3-A`, `ADMIN-A`; `@@unique(tenant, code)`; **not** minted from `entity_sequences` | creates |
| `CraftCodeRate` (new) | none | creates |
| `EmployeeCraftAssignment` (new) | none | creates |
| `CraftModifierScale` (new) | none; derived codes `OP-BP-nn` / `OI-BP-nn` are computed, never stored | creates |
| `EmployeeUnionCode` | `code` existing | extends |
| `EmployeeCraftCode` | `code` existing | untouched; dropped in a later cleanup |
| `Employee` | `employeeCode` | `hourlyRate` = non-union base rate; create/update now requires a primary craft; legacy craft/union columns untouched |

- New entity introduced by this ticket: yes (4)
- New code prefix introduced: no — craft codes are admin-typed reference codes like union/work-comp codes today
- Existing rows affected (backfill / migration of data, not just schema): only `EmployeeUnionCode.kind` filled by label match inside the ADD migration; nothing else

## 8. Roles and permissions

- Roles that can perform this: craft / scale / rate admin — `Role.ADMIN` (existing admin-gated reference-code pattern). Craft assignment and reassignment — admin, payroll, crane superintendent per decision 2026-08-20 §3. Dispatch may set the primary craft when creating a temporary employee. `NOT ON TICKET` for the exact role enum values — elaborator to map to the role model.
- Roles explicitly excluded: the employee themselves (self-selection, decision 2026-08-20 §3).
- Tenant scope: standard per-tenant isolation; new models must be added to the `$extends` allowlist.

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | `~/Downloads/TCG Platform (standalone) (1).html` — Settings → Craft Codes, Settings → Craft Code Modifiers, Employee → Manage Craft Code. **Vault wins over this mock where they disagree** (rate columns, 5 tiers, flat adder, unit-derived modifier, employee-level modifier — all rejected) |
| Approved BE design | https://claude.ai/code/artifact/5865b593-1deb-4842-b5fa-9ab056ec2145 — class + flow diagrams |
| Jira attachments | none |
| Related tickets | `SCRUM-928` excluded; `SCRUM-929`/`930` payroll rule configuration (consume the resolver later); `SCRUM-910` DAS craft-code selection; `SCRUM-540`/`596` the existing settings CRUD being replaced |
| Existing repo docs | `.ai/claude/contexts/prisma.md`, `.ai/claude/contexts/api.md` |
| Vault area the reader thinks is relevant | `payroll/INDEX.md`, `payroll/rules/PAY-008`, `PAY-009`, `PAY-010`, `PAY-011`, `payroll/legacy-payroll-app-db-extract/`, `payroll/mcog-l12-mla-2025-2028/02-…`, `decisions/2026-08-20-craft-locked-rate-override.md`, `sync/.conflict/2026-08-24-bootstrap/craft-codes.md` (Confluence PAY-CC-01..03, unverified) |

## 10. Terms used that may not be defined

- `craft-code` — used on 925 as: *"configure craft codes and their base rates"*. Known-undefined in the vault README; first written definition candidate is the Confluence *Craft codes* page (unverified).
- `union classification / rule classification` — used on 925 as: *"Craft codes include the applicable union classification/rule classification"*. The ticket does not say whether these are one field or two.
- `craft group` — used on 925 as: *"Different craft groups can have different rates"*. Likely the MLA wage groups 1–9 / apprentice steps; NOT ON TICKET.
- `secondary craft code` — used on 927 as: *"An employee can have a primary craft code or secondary one"*. The ticket does not say who assigns it or when it applies.
- `boom length` — used on 934 as the input to the tier function; whether it is measured from the ticket, the unit, or entered by hand is NOT ON TICKET.

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| 80 · 440 · 20 ft, $0.75 / $0.25 per step | `SCRUM-934` cites MLA Art. IV and the legacy `FMS_UNION_CRAFT_MODIFIER` table |
| `OP-BP` / `OI-BP` prefixes, `Ft-{role}` suffix | `SCRUM-934` cites the legacy table (`OP-BP-06`, `181-200Ft-Operator`) |
| 195 ft → tier 6, $4.50 / $1.50 | `SCRUM-935` worked example from the MLA formula |
| `UNION | NON_UNION`, `PRIMARY | SECONDARY`, roleType enum values | plan decision 2026-08-24 — NOT ON TICKET — no origin cited beyond the legacy craft prefixes (`L12-*` union, `ADMIN-*`/`HDR-*`/`YARD-*` non-union) |
| non-union rate per person on `Employee.hourlyRate` | FCC practice (`FMS_EMPLOYEES.PayRate`, 21,348 legacy rows); confirmed 2026-08-25 |

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: 5 — sprint; exact role enum values; craft-group meaning; boom-length source; enum origins in §11.
- Fields left as `OPEN`: 0 in this file; the elaborator is expected to raise at least:
  - `PAY-011` rate-source half — modifier selected on the labor entry vs derived from the unit;
  - temps vs ADP onboarding gating (recording 07-09 vs decision 06-30 step 5).
- Is this ticket, as written, buildable without a product answer? Yes — all four units, under the 2026-08-24/25 planning decisions; the remaining TCG questions (adder into-rate vs on-top, modifier source, day-level true-up) affect later payroll tickets, not this epic's interfaces.
- If no, the blocking questions are: listed above; the elaborator carries each into `spec.md` §12.

---

**Next step:** run the elaborator (`.ai/aidlc/agents/inception/tcg-elaborator.md`) against this file.
