---
title: Fresh-tenant demo walkthrough — quotation to calculated payroll
status: reference
kind: reference
updated: 2026-08-28
---

# Fresh-tenant demo walkthrough — quotation to calculated payroll

> ## ⛔ This describes what the code does. It is never a source for a spec.
>
> Everything below was read off the running application and the source tree. It is an
> **operational runbook**, not product memory — which is why it lives in `claude/skills/` and
> **not in `vault/`**. `close-ticket` → *The one thing this never does* forbids shipped behaviour
> becoming vault content, and that rule is not bent by this file's existence.
>
> **If you need to know what the platform is *supposed* to do, this file cannot tell you.**
> Read `.ai/vault/INDEX.md` → the module's `INDEX.md`. Where this file says something is a defect,
> that is a claim about code, not an adjudicated requirement — and where the product record is
> silent, it says so instead of guessing.

A step-by-step run of the whole platform on a **brand-new tenant with zero data**, ending with a
calculated, approved, exported payroll week. Every step names the URL, the sidebar path, what to
verify, and **what to deliberately poke at** — the edge cases and known defects that a happy-path
script would sail past.

- **Web:** `http://localhost:3001`
- **API:** `http://localhost:3000/api/v1` (Swagger at `http://localhost:3000/api/docs`)
- **Mobile:** Expo on `8081`

Written 2026-08-28. Sources: the route tree in `apps/web/src/app/(protected)/`, the sidebar
definitions in `apps/web/src/components/sidebar/`, the Prisma schema, and the black-box findings in
`E2E_PAYROLL_FLOW_REPORT.md` (main repo root). Where something is unspecified in the product record
I say so rather than inventing the intent.

**Kept current by `close-ticket` step 5.** If you find this file wrong, it is a bug in that step —
fix the file and say so, don't work around it.

---

## Contents

| # | Phase | Surface |
| --- | --- | --- |
| 0 | [Before you start](#0-before-you-start) | terminal |
| 1 | [Create the tenant + first login](#1-create-the-tenant--first-login) | web (admin) |
| 2 | [Reference data — Settings](#2-reference-data--settings) | web |
| 3 | [Payroll foundations — craft codes, rates, brackets, premiums](#3-payroll-foundations) | web |
| 4 | [Org — departments, yards, employees](#4-org--departments-yards-employees) | web |
| 5 | [Assets — categories, sub-categories, associated resources, the crane](#5-assets) | web |
| 6 | [Accounting — billing codes and the price list](#6-accounting--billing-codes-and-price-list) | web |
| 7 | [Customers and job sites](#7-customers-and-job-sites) | web |
| 8 | [Quotation](#8-quotation) | web |
| 9 | [Project and job](#9-project-and-job) | web |
| 10 | [Permits and POs](#10-permits-and-pos) | web |
| 11 | [DAS — allocate and send tickets](#11-das--allocate-and-send-tickets) | web |
| 12 | [Field ticket](#12-field-ticket--mobile) | **mobile** |
| 13 | [Payroll — calculate, review, approve, export](#13-payroll) | web |
| — | [Appendix A: placeholders and dead ends](#appendix-a-screens-that-are-placeholders-or-dead-ends) | |
| — | [Appendix B: known defects worth demonstrating](#appendix-b-known-defects-worth-demonstrating) | |
| — | [Appendix C: fresh-tenant pre-req checklist](#appendix-c-fresh-tenant-pre-req-checklist) | |

---

## 0. Before you start

### 0.1 Services

The dev containers are normally already running. Bring up the apps:

```bash
pnpm api:dev      # :3000
pnpm web:dev      # :3001
pnpm mobile:start # :8081
```

`@tcg/shared` is consumed as its built `dist/` — if the API or web fails on a `@tcg/shared` import,
build it first (`pnpm nx run @tcg/shared:build`).

### 0.2 Mobile data source — read this or the mobile half of the demo is fake

`apps/mobile/data/config.ts` resolves each domain's data source and **falls back to `mock`**:

```
resolveDataSource(domain) = EXPO_PUBLIC_DS_<DOMAIN> ?? EXPO_PUBLIC_DATA_SOURCE ?? 'mock'
```

In `apps/mobile/.env.local` set:

```
EXPO_PUBLIC_API_URL=http://<your-LAN-IP>:3000/api/v1   # not localhost, if on a device
EXPO_PUBLIC_DATA_SOURCE=api
```

> ⚠️ **Only the field-ops domains have a real backend.** The `sales` and `dispatch` personas are
> **mock-only** — their screens render fixtures regardless of this setting. Demo the mobile app as
> a **field worker (Operator/Oiler)**. If you show the dispatcher or sales personas, say out loud
> that they are UI-only.

### 0.3 Email

The only email provider wired up is SES (`apps/api/src/usecase/email/providers/ses.provider.ts`) —
there is no console/dev fallback. And `InvitationsService.invite()` **sends the email before
writing the DB row**, so with SES unconfigured an invite fails outright and no user is created.

That matters because **the portal invite is the only UI path that links a `User` to an `Employee`**
(`User.employeeId`). Admin → Users → Create makes a login with no employee link, and a mobile
login with no employee resolves to the "Not set up for the app yet" screen.

Two options for the demo:

- **Configure `SES_FROM_EMAIL` + AWS creds** in `apps/api/.env` and use real invites (best).
- **Fallback:** invite fails → open `pnpm db:studio`, find the `users` row, and set
  `employee_id`, `password_hash` (a bcrypt hash) and `status = ACTIVE` by hand. Ugly, but it is the
  documented state of the code today.

### 0.4 Accounts you will use

| Who | Login | Why |
| --- | --- | --- |
| Platform super-admin | `superadmin@tcg.com` / `Admin@1234` (tenant `PLATFORM`) | Only `SUPER_ADMIN` can reach `/admin` |
| Your new tenant admin | you create it in step 1.2 | `ADMIN` role → `full` on every module |
| Field worker | invited employee (step 4.3) | mobile |

`superadmin@tcg.com` only exists if `pnpm db:seed` has been run at least once on this database. That
seed also creates the `TCG-DEFAULT` demo tenant — leave that one alone; your fresh tenant is separate.

---

## 1. Create the tenant + first login

### 1.1 Create the tenant

- **Login:** `http://localhost:3001/login` as `superadmin@tcg.com`.
- **URL:** `http://localhost:3001/admin/tenants` (the admin app has its own two-item sidebar:
  Tenants, Users — the normal product sidebar is not present here).
- **Action:** *Create Tenant* → Company Name, **Tenant Code** (e.g. `DEMO-001`), Max Users, Domain.

**Verify:** the row appears with status `ACTIVE` and `0` users.

**Edge cases to poke:**
- Re-submit the same tenant code → `409` "Tenant code … is already in use". Tenant code is
  **globally unique**; every *other* business code in the app is only unique per tenant.
- Open the tenant detail (`/admin/tenants/<uuid>`). There is an **FCC Sync** action — it wipes the
  tenant and replaces it from an FCC extract. It refuses `TCG-DEFAULT` and `PLATFORM`, needs FCC env
  config, and takes minutes. **Do not run it mid-demo.** Mention it exists; that is the "real
  customer data" path, and it is the only supplier of craft codes and craft-modifier brackets that
  doesn't involve typing them in.

> 🔴 **The single biggest fresh-tenant gotcha.** `seedTenantDefaults()` in
> `apps/api/src/utility/seed-data.ts` — which seeds system departments, billing-code types,
> industries and **payroll premiums** — has **no callers anywhere in the codebase**. And
> `GET /seed/run` / `pnpm db:seed` is hardcoded to the `TCG-DEFAULT` tenant. So a tenant created
> through this screen starts with **literally nothing**, including no payroll premium rows — and
> the Payroll Premiums screen can only *edit* premiums, never create them (see 3.3).
>
> **This is an open product question, not a settled bug.** It is `vault/admin/gaps.md` → *What a
> newly created tenant must contain — provisioned defaults, or an empty portal*, raised 2026-08-27
> off the PR #421 review and still unowned-by-answer. Two closed Jira tickets (`SCRUM-467`,
> `SCRUM-593`) say seed the defaults; PR #421 removed that. Demo the consequence; do not assert
> which side is right.

### 1.2 Create the tenant's first admin

- **URL:** `http://localhost:3001/admin/users` → *Create User*.
- Tenant = your new tenant, email, password (min 8), **Role = Admin**, Status = Active.

**Verify:** log out, log in as that user. You land on `/dashboard` with the full product sidebar.

**Why Admin and not User:** `resolveEffectiveLevel()` in `packages/shared/src/constants/permissions.ts`
short-circuits `ADMIN`/`SUPER_ADMIN` to `full` on every module. A `USER`-role login gets its
permissions from its **department role's** permission map, and falls back to `USER_DEFAULTS` when it
has none.

**Edge case worth a minute:** later in the demo, make a second `USER`-role login with no department
role and show that **Payroll Management disappears from the sidebar entirely** — it is gated on
`can('payroll','view')` — and so does the Settings group (`can('settings','view')`).

### 1.3 Orient on the sidebar

Order, top to bottom (`sidebar-nav-items.tsx`):

```
Dashboard · Customers · Quotations · Projects
Permits ▸ (All Permits, Track Permits)
PO's ▸ (All PO's, Track PO's)
Daily Allocation System · Yard Operations · Agencies · Vendors · Planning Tracker
Asset Management ▸ (Overview, Categories, Sub-Categories, Assets, Tools & Riggings, Parts & Manufacturers)
Employees ▸ (All Employees, Temp Employees)
Departments · Yards
Accounting ▸ (Billing Codes, Price List)
Payroll Management ▸ (Weekly Payroll, Craft Codes, Craft Code Modifiers, Payroll Premiums,
                      Rules Configuration, ADP Payroll Files, Audit Log)     ← only if can('payroll','view')
Reporting
--- bottom block ---
Notification
Settings ▸ (Loss Reasons, Union Codes, Work Comp Codes, Billing Code Types,
            Certificates, Expense GL Accounts, Industry Codes)               ← only if can('settings','view')
<user avatar> ▸ Preferences, Change Password, Sign out
```

**Navigation gotchas to call out:**
- **Settings is at the very bottom**, below Notification, not in the main scroll list. People miss it.
- **Categories and Sub-Categories live under *Asset Management* in the sidebar but their URLs are
  `/settings/categories` and `/settings/sub-categories`.** Breadcrumbs say Asset Management.
- **Craft Codes / Craft Code Modifiers / Payroll Premiums are under *Payroll Management* but their
  URLs are `/settings/craft-codes`, `/settings/craft-modifiers`, `/settings/payroll-premiums`.**
- **"Billing Codes" exists twice.** The live one is Accounting → Billing Codes
  (`/accounting/billing-codes`). `/asset-management/billing-codes` is a legacy route that still
  resolves but is no longer in the sidebar — as are `/asset-management/units` and
  `/asset-management/unit-types`. All three highlight "Assets" if you land on them.
- `/tickets` ("My Job Tickets") has **no sidebar entry at all** — reachable only by typing the URL.

---

## 2. Reference data — Settings

**Sidebar:** Settings ▸ (bottom of sidebar). Each of these is the same table + create/edit modal
component (`reference-code-manager.tsx`), so once you have done one you have done all seven.

Do these **in this order** — later screens depend on them.

| # | Screen | URL | Needed by |
| --- | --- | --- | --- |
| 2.1 | **Union Codes** | `/settings/union-codes` | Craft Codes (required FK) |
| 2.2 | **Work Comp Codes** | `/settings/work-comp-codes` | Employee form |
| 2.3 | **Billing Code Types** | `/settings/billing-code-types` | Billing codes |
| 2.4 | **Industry Codes** | `/settings/industry-codes` | Customers |
| 2.5 | **Loss Reasons** | `/settings/loss-reasons` | Quotation → Mark Lost |
| 2.6 | **Certificates** | `/settings/certificates` | Employee certificates |
| 2.7 | **Expense GL Accounts** | `/settings/expense-gl-accounts` | Billing codes (GL account) |

### 2.1 Union Codes — the one that decides how people get paid

Create **at least two**, because the union/non-union split is a real fork in the pricing engine:

| Code | Label | Kind | Local # | Agreement |
| --- | --- | --- | --- | --- |
| `L12` | IUOE Local 12 | **UNION** | 12 | MLA 2025-2028 |
| `NU` | Non-Union | **NON_UNION** | — | — |

**Why it matters** (`EmployeeUnionCode.kind`, and `craft-rate-resolver.service.ts`):
- `UNION` → base rate comes from **`CraftCodeRate`** (an effective-dated table on the craft).
- `NON_UNION` → base rate comes from **`Employee.hourlyRate`** on the employee record.
- `resolveBoomAdder()` has an unconditional `if (unionKind !== 'UNION') return { adder: null }` —
  **a non-union employee never earns boom pay, whatever the crane's boom length.**

**Edge case to demo later:** put one crew member on the `NU` craft and show that their payroll
breakdown has no Long Boom lines while the union member on the same crane has them.

---

## 3. Payroll foundations

Everything here is under **Payroll Management** in the sidebar. All of it must exist before you
create a single employee, because "Payroll craft" is a **required** field on the employee form.

### 3.1 Craft Codes

- **Sidebar:** Payroll Management ▸ Craft Codes · **URL:** `/settings/craft-codes`

Create two, minimum:

| Craft Code | Name | Union/Class | Role Type | ST | OT |
| --- | --- | --- | --- | --- | --- |
| `L12-OP` | Local 12 Operator | `L12` | Operator | 66.18 | (derived) |
| `L12-OI` | Local 12 Oiler | `L12` | Oiler | 44.12 | (derived) |

Also make a `NU-OP` on the `NU` union code if you want the non-union comparison.

**Verify:** the craft card shows Union kind, role type, and the effective-dated rate you entered.
Open a craft → **Rates** panel to see/extend `CraftCodeRate` rows (effective from/to, base rate,
source). OT and DT are **never stored** — they are multipliers applied at pricing time.

> 🔴 **Known defect — `wageGroup` cannot be set from the UI or the API.**
> `CraftCode.wageGroup` exists in the schema ("only Group 6+ qualifies for the lattice-boom
> premium, PAY-044"), but there is **no field on the create/edit form**, no field in the DTOs, and
> it is not serialized in any craft-codes response. Consequence: the **Lattice premium can never
> pay out** for any craft created through this app — the calculation emits
> `LATTICE_GROUP_INELIGIBLE` on every lattice-flagged job day. Demo this in step 13 by flagging the
> job as Lattice and showing the issue in the employee's breakdown. Fixing it requires a direct DB
> edit.

**Secondary crafts:** open a craft → **Users** tab → assign an employee as **Primary** or
**Secondary**. Secondary matters when a person is allocated to a slot their primary craft doesn't
match — the resolver will match a `SECONDARY` assignment if you pass the craft explicitly.

### 3.2 Craft Code Modifiers (the long-boom bracket ladder)

- **Sidebar:** Payroll Management ▸ Craft Code Modifiers · **URL:** `/settings/craft-modifiers`

A fresh tenant has **zero brackets**. Use the **Generator** — start ft, end ft, gap, operator step,
oiler step, code prefix. `80 / 400 / 20` with prefix `LB` produces 80–100, 101–120, … 381–400.

**Verify:** the matrix lists contiguous brackets with per-hour operator and oiler adders. The
generator previews the row count before writing anything.

**Edge cases to build deliberately — all three are real behaviours worth showing:**
1. **Delete one middle bracket** (say 101–120) to leave a gap. `matchBracket`/`adderForRole` fall
   back to the **nearest lower bracket**, never $0. The seeded `TCG-DEFAULT` tenant genuinely has
   this hole between `LB-01` (80–100) and `LB-03` (121–140), so it is not hypothetical.
2. **A boom longer than your highest bracket** → same nearest-lower fallback, not $0.
3. **Deactivate every bracket** → the resolver returns `NO_ACTIVE_MODIFIER_SCALE` as a blocked-rate
   status rather than throwing. Re-activate afterwards.
4. Watch for **duplicate ranges** — the demo tenant has two rows both covering 181–200 with
   identical adders. Harmless (`matchBracket` only needs *a* match) but it is a data-hygiene trap
   the UI does not prevent.

### 3.3 Payroll Premiums

- **Sidebar:** Payroll Management ▸ Payroll Premiums · **URL:** `/settings/payroll-premiums`

> 🔴 **This screen is edit-only. There is no Create.** `PayrollPremiumsManager` wires up an update
> mutation and nothing else, and `PATCH /payroll/premiums/:id` only accepts `amount`, `label` and
> `status` — not `basis`, `appliesTo` or `trigger`. Combined with `seedTenantDefaults()` having no
> callers, **a fresh tenant's premium list is empty and cannot be populated from the UI.**

**An empty premium table does not price at zero — it prices from hardcoded constants, and two of
them are wrong.** `PayrollService.premiumRates()` (`apps/api/src/usecase/payroll/payroll.service.ts:424`)
reads the table and silently falls back:

```ts
foremanPerHour:          byCode.get('FOREMAN')     ?? 3,
militaryPerHour:         byCode.get('MILITARY')    ?? 10,
latticeOperatorPerHour:  byCode.get('LATTICE_OP')  ?? 1,
latticeOilerPerHour:     byCode.get('LATTICE_OI')  ?? 0.5,
shift2PerHour:           byCode.get('SHIFT_2')     ?? 1,    // vault says $3
shift3PerHour:           byCode.get('SHIFT_3')     ?? 1.5,  // vault says $4
```

Four of the six match the product record. **`SHIFT_2` and `SHIFT_3` do not**: `PAY-036` (*"seven
hours worked/eight paid; add **$3**/hour to base"*) and `PAY-037` (*"6.5 worked/eight paid; add
**$4**/hour"*), each corroborated four ways — the L12 MLA, the legacy engine extract, a client
screenshot of a priced slice, and the 2026-08-05 minutes. So a fresh tenant silently ships two
known-wrong shift rates. See `vault/payroll/gaps.md` → *Payroll premium catalog — configured per
tenant, or constants in the engine*.

**Do this before the demo:** copy the `payroll_premium_types` rows from `TCG-DEFAULT` in Prisma
Studio, changing `tenant_company_id` — or call `seedPayrollPremiums(prisma, tenantId)` from
`apps/api/src/utility/seed-data.ts` directly. The `SEED_TENANT_CODE` path that PR #421 left as the
only supported route **has no script behind it yet** (noted as open in the gap above).

**Verify on screen:** Foreman ($3/hr), Military Base ($10/hr), shift differentials, Lattice
operator/oiler adders. Edit an amount and confirm it is audit-stamped (`lastModifiedById`).

**Edge cases:**
- Run the calculation with the premium table **empty** and again with it **populated at the vault's
  $3/$4 shift rates**, and show the shift-differential lines differ. That is the whole gap in one
  screen.
- The `appliesTo` field on the Military premium reads `UNION` on tenants seeded before a code change
  that now defaults it to `ALL`. There is no backfill and no API to change it — **but it is inert**:
  nothing in the calculation engine reads `appliesTo` at all. A data-consistency wart, not a live bug.

> 📌 **Both fresh-tenant seeding questions are already open in the vault — cite them, don't re-raise
> them.** `vault/admin/gaps.md` → *What a newly created tenant must contain — provisioned defaults,
> or an empty portal* (owner: Fouzan Shakil, with Ehtesham Anwar), and the payroll one above. Jira
> `SCRUM-467` and `SCRUM-593` both say "seed defaults" and are both `Done`; PR #421 removed exactly
> that. Nobody has adjudicated it. **Whether the empty-tenant behaviour in this walkthrough is a bug
> or the intended design is genuinely undecided** — present it as an open question, not a defect.

### 3.4 The three payroll screens that are not built

Click each once so nobody discovers them live:

| Sidebar item | URL | Reality |
| --- | --- | --- |
| Rules Configuration | `/payroll/rules` | `PayrollSectionPlaceholder` — empty state only |
| ADP Payroll Files | `/payroll/adp` | placeholder |
| Audit Log | `/payroll/audit` | placeholder |

---

## 4. Org — departments, yards, employees

### 4.1 Departments

- **Sidebar:** Departments · **URL:** `/departments` → *Create* (`/departments/create`)

A fresh tenant has none (system departments are part of the un-called `seedTenantDefaults`). Create
at least **Dispatch**, **HR** and **Operations**. Department **roles** carry the permission map that
`USER`-role logins resolve against, so this is where you demo non-admin access control.

**Edge case:** `DISPATCH_DEPARTMENT_CODE` and `HR_DEPARTMENT_CODE` are API env vars used to route
notifications. If your department codes don't match those env values, dispatch/HR notifications go
nowhere — silently.

### 4.2 Yards

- **Sidebar:** Yards · **URL:** `/yards` → `/yards/create`

Create one. Employees and assets are yard-scoped, and the field ticket's Left Yard / Arrived at Yard
milestones are conceptually anchored here.

### 4.3 Employees

- **Sidebar:** Employees ▸ All Employees · **URL:** `/employees` → `/employees/create`

Create **two**, an Operator and an Oiler. Required fields (`create-employee-form.ts`):

- First name, last name, **email** (required — no email, no portal invite later)
- Work cell phone
- **Payroll craft** (`primaryCraftCodeId`) — **required**, this is why craft codes came first
- Employee Type, Union Code, Work Comp Code, Yard, Department + role
- Hourly / Salary Rate — **only used for `NON_UNION` crafts**; union crafts ignore it and read
  `CraftCodeRate`

> ⚠️ **Employee Type drives the mobile persona, and it is matched by *name*.**
> `PERSONA_BY_EMPLOYEE_TYPE` in `apps/mobile/data/contracts/identity.contract.ts`:
>
> | Employee Type name | Mobile persona |
> | --- | --- |
> | `Operator`, `Oiler`, `Rigger`, `3rd Man`, `Apprentice` | `fieldWorker` |
> | `Salesmen`, `Sales Admin` | `sales` (mock-only) |
> | `Dispatch Admin` | `dispatcher` (mock-only) |
> | Driver, Mechanic, Yard Man, Shop, Management, … | **unmapped → "Not set up for the app yet"** |
>
> `EmployeeType` is a **global** table (not tenant-scoped), seeded by migration, so your fresh
> tenant does inherit the full list. But pick `Operator` / `Oiler` or the mobile demo dead-ends on
> the not-provisioned screen. **This is a great deliberate edge case:** create a third employee as
> "Driver", invite them, log in on mobile, show the graceful lock screen.

**Portal invite:** employee row → ⋮ → *Invite*. Email → `/accept-invite?token=…` → set a password
→ auto-signed-in. See §0.3 if SES isn't configured.

**Edge cases:**
- Invite an employee with **no email** → clear 400 telling you to add an email first.
- Invite twice → "already has a pending invite. Use resend or revoke first."
- Two employees sharing an email → refused, with an explicit "fix the duplicate email" message.
- **Temp Employees** (`/employees/temp-employees`) is a separate list; temp crew have **no portal
  invite / resend / revoke** actions at all.

---

## 5. Assets

### 5.1 Categories → Sub-Categories

- **Sidebar:** Asset Management ▸ Categories · **URL:** `/settings/categories`
- then Asset Management ▸ Sub-Categories · **URL:** `/settings/sub-categories`

Create Category **Cranes**, then sub-category **Hydraulic Truck Crane** under it.

### 5.2 Associated resources — the step everyone skips, and the one boom pay depends on

On the **sub-category**, configure its **associated resources**: for the crane sub-category,
associate the **Operator** and **Oiler** employee types (`SubCategoryAssociatedResource`, with
`isRequired`).

**Why this is load-bearing.** When a quotation is converted to a project/job,
`materializeAssociatedJobResources()` walks each resource carrying a `subCategoryId`, reads its
associated-resource definitions, and creates **child `job_resources` rows** at $0 — building the
crane → operator/oiler **parent/child tree** the DAS board allocates against.

And the boom-pay chain runs entirely on that tree:

```
allocation.setResourceId  ──(snapshotted at write time from JobResource.parentId)
      └→ set root resource → crane asset → Asset.mainBoomLength → craft-modifier bracket → adder
```

> 🔴 **Known defect, and it is unrecoverable once it happens.**
> `setResourceId` is **computed once, when the allocation is written**, from the resource tree as it
> stands at that instant. If you allocate crew before the parent/child tree exists, boom length
> resolves to `null` **forever** — fixing the tree afterwards does not rewrite existing allocations,
> and once tickets are sent, `PUT /das/sub-jobs/{id}/allocations` returns
> `400 "Cannot modify allocations after tickets have been sent"`. There is **no error at allocation
> time, none at ticket-send, none at labor entry** — the field worker just sees a suggested bracket
> of "none" and payroll silently pays $0 boom.
>
> Related: the API's own documented `tempId`/`parentId` single-request linking pattern
> (`PUT /jobs/{jobId}/resources`) **silently does nothing** — children come back with
> `parentId: null`. The workaround is a second `PUT` repeating the crane's real UUID as the
> children's `parentId`.
>
> **Demo suggestion:** run the good path on your main job, then build a throwaway second job with a
> flat resource list and show `craneMainBoomLength: null` / bracket `"none"` on the crew card. It is
> the most valuable thing in this whole walkthrough.

### 5.3 Assets

- **Sidebar:** Asset Management ▸ Assets · **URL:** `/asset-management/assets` → Create

Required: **Unit Code**, **Category**, **Sub-Category** (sub-category list is disabled until a
category is picked). Then in the **Dimensions** section set **Main Boom Length** — a feet/inches
field. Use something that lands cleanly in a bracket, e.g. **197 ft** → `181–200`.

**Verify:** asset detail → Main Boom Length renders as `197 ft`.

**Edge cases:**
- Set a boom length **inside the gap you created in 3.2** (e.g. 110 ft) on a second crane and show
  the nearest-lower-bracket fallback in the payroll breakdown.
- Set a boom length **above your top bracket** → same fallback, not $0.
- Leave Main Boom Length **empty** → the set resolves no crane boom, bracket `none`, no boom pay.
  `pickSetCraneAsset` deliberately ignores allocated assets with no boom length (support trucks,
  operator load trucks), so an empty field makes the crane invisible to the resolver.

### 5.4 Tools & Riggings, Parts

- `/asset-management/tools-riggings`, `/asset-management/parts`

Not on the payroll path. Worth 60 seconds if the audience cares about equipment. There is also a
**public** barcode page at `/public/tools/[barcode]` that needs no login — nice demo moment.

---

## 6. Accounting — billing codes and price list

### 6.1 Billing Codes

- **Sidebar:** Accounting ▸ Billing Codes · **URL:** `/accounting/billing-codes` →
  `/accounting/billing-codes/create`

Required fields (`billing-code-form.schema`): **Name**, **Type** (`typeCategory`), **Unit of
measure**, **Default rate** (≥ 0). Then, conditionally:

| Type category | Also required |
| --- | --- |
| `ASSETS` | a **Sub-Category** |
| `EMPLOYEES` | an **Employee Type** |
| `CUSTOM` | a **Custom Type** (create inline) |

Optional: Billing Code Type, GL account, and the four flags — **Auto-allocate**, **Taxable**,
**Percent applied**, **Apply surcharge**.

Create at minimum:
- `ASSETS` → Hydraulic Truck Crane — hourly, e.g. $250/hr
- `EMPLOYEES` → Operator — hourly
- `EMPLOYEES` → Oiler — hourly

**Verify:** each appears in the list with its type, unit, and default rate.

**Edge cases:**
- Pick type `ASSETS` and try to save without a sub-category → inline "Select a sub-category".
- **Percent applied** + **Apply surcharge** together — surcharges compound onto quotation lines;
  worth showing the arithmetic on the quotation rather than asserting it.
- Archive (INACTIVE) a billing code, then reopen it: the Status field renders **disabled with a
  hint** — Inactive is never a form-selectable value, only a consequence of archiving.
- **A resource with no billing code still appears on a quotation.** That was a deliberate recent fix
  (commit `f7e102f9`, "show associated resources without a billing code") — an associated Operator
  with no billing code must still show as an operational requirement at $0, not vanish. Build one
  that way on purpose and confirm it renders.

### 6.2 Price List

- **Sidebar:** Accounting ▸ Price List · **URL:** `/accounting/price-list` →
  `/accounting/price-list/create`

Create e.g. **"Standard Rates"**. Add items — each is a billing code with a customer-facing rate
overriding the billing code's default. Use **Bulk Rates** to apply a % adjustment across the list.
Then **Link Customers** to it (or do that from the customer in step 7).

**Verify:** the detail page shows Items, Linked Customers and Surcharges as three separate cards.

**Edge cases:**
- Create a **second** price list ("Premium Customer Rates") at higher rates, link it to a different
  customer, and show the same crane quoting at two different rates. This is the cleanest
  demonstration of why price lists exist.
- Unlink a customer from a price list **after** a quotation was drafted against it — the quotation
  keeps its captured rates; it does not retro-reprice. Confirm on screen rather than assuming.
- A billing code present on the price list but **archived** afterwards.

---

## 7. Customers and job sites

- **Sidebar:** Customers · **URL:** `/customers` → `/customers/create`

Create a customer (industry code from step 2.4, billing contacts, price list link). Then add a
**Job Site** — either on the customer detail, or inline from the quotation via the *Add Job Site*
modal.

**Verify:** `/customers/<customerCode>` shows contacts, job sites, linked price list, and the
customer's quotations.

**Edge cases:**
- Customer with **no price list linked** → quoting them falls back to billing-code default rates.
  Show the difference.
- Customer with **multiple job sites** → the quotation's job-site picker; and check the site address
  actually flows through to the field ticket's Arrive-at-Job geofence.
- **Note the identity convention:** the URL uses the business code (`CUST-0004`), never the UUID.
  Codes are unique **per tenant only** — two tenants can both have `CUST-0001`.

---

## 8. Quotation

- **Sidebar:** Quotations · **URL:** `/quotations` → `/quotations/create`

Five tabs: **Main · Resources · Tool/Rigging · Additional Info · Attachments**.

### 8.1 Main

Customer, job site, **price list**, job date / job end date, salesperson.

> 🔴 **Known defect — dates.** `POST /quotations` (and `PATCH`) **500s** when `jobDate` /
> `jobEndDate` are sent as plain date-only strings (`"2026-08-27"`) — even though the DTO's own
> Swagger example shows exactly that, and the "cannot be in the past" validator accepts it. Full ISO
> datetimes work. The web form sends the right shape; this bites anyone driving the API directly, so
> **do not demo quotation creation via Swagger.**

**Edge case:** set a job date in the past → blocked by the validator with a clear message.

### 8.2 Resources — the tab that decides whether payroll works

Add the crane by its **sub-category**. Because you configured associated resources in 5.2, the
Operator and Oiler rows should be **offered as children of the crane**, with the crane as parent.

**Verify before leaving this tab:**
- The rows render as a **hierarchy** (crane, indented operator/oiler) — not three flat siblings.
- The pricing chips / sidebar show a subtotal equal to the sum of line `finalAmount`s.

**Edge cases:**
- **Quantity N.** Setting quantity 2 on the crane is a **billing** change only —
  convert still yields **one** DAS/Yard set with `qty=2` (decision
  `2026-08-31-quotation-qty-not-das-sets`, superseding the old explode rule).
  Child rows keep their own quantity and do not inherit the parent's.
- Add a resource **with no billing code** and confirm it still shows (the `f7e102f9` fix above).
- **Reorder** rows and re-check the subtotal.
- Add a **child of a child** — depth is capped at `MAX_QUOTATION_RESOURCE_DEPTH`.

### 8.3 Approval and status transitions

Statuses: `DRAFT → PENDING_INTERNAL_APPROVAL → IN_REVISION → INTERNAL_APPROVED → SENT_TO_CUSTOMER
→ CHANGES_REQUESTED → WON | LOST | EXPIRED`.

- **Sidebar:** Quotations ▸ Approvals · **URL:** `/quotations/approvals`

Request approval → the approvals inbox → approve, or *Request Changes* (→ `CHANGES_REQUESTED`).
Approval is triggered above `QUOTATION_APPROVAL_TOTAL_THRESHOLD` (an API env var) and on discount /
margin thresholds shown in the approval panel.

**Edge cases:**
- **Try *Mark as Won* on a `DRAFT`** → `409 Conflict`: "Must be Internal Approved, Sent to Customer,
  or Changes Requested." A clean, demonstrable state-machine guard.
- **Mark Lost** → forces a Loss Reason from your step-2.5 list.
- **Reactivate** a lost quotation.
- Set the quotation total just under, then just over, the approval threshold and show the approval
  requirement appear.

### 8.4 Mark Won

Quotation detail → **Mark as Won**. The action buttons then switch to **Create Project** (or
**Convert to Job** if a project is already linked).

---

## 9. Project and job

- **Action:** on the won quotation, **Create Project** → lands on `/projects/<id>/details`.
- **Sidebar:** Projects · **URL:** `/projects`

The conversion runs `materializeAssociatedJobResources()` — this is where the crane→crew tree
becomes real `job_resources` rows.

### 9.1 Job detail

`/projects/<projectId>/jobs/<jobId>` — tabs: **Main · Resources · Schedule · Tool/Rigging ·
Additional Info · Progress Tracking · Attachments · Activity Log**.

**Resources tab — verify the hierarchy survived the conversion.** Crane as parent, Operator and
Oiler indented beneath it. If they are flat here, stop and fix it before allocating (see 5.2).

**Schedule tab —** set the working interval, e.g. `06:00–20:00` on your chosen job date. This is
what puts the job on the DAS board for that date.

**Main tab — Job Payroll Flags card.** Toggle **Is Lattice**, **Is Military Base**, **Is Hazmat**,
and pick a **Foreman**. These directly drive premium lines in the calculation.

**Verify:** re-open the job; the flags persist.

**Edge cases:**
- Flag **Lattice** deliberately. In step 13 the breakdown will carry `LATTICE_GROUP_INELIGIBLE`
  because `wageGroup` is unsettable (3.1). Showing a premium that *can't* fire is more honest than
  hiding it.
- **Military Base** → flat `$10/hr × actual hours`, **not** multiplied through OT/DT. Foreman is
  flat `$3/hr` likewise. Both are an **open product question** — `PAY-070`/`PAY-071` note that the
  `FRT` (Foreman TRI) ADP code implies the premium *should* multiply through the tiers, and the
  vault explicitly says "that reading is not stated anywhere." The implementation picked flat
  without a recorded decision. Flag it; don't assert either way.
- Try `PATCH /payroll/jobs/JOB-00006/flags` in Swagger with the **business code** → 400,
  "Validation failed (uuid is expected)". That route is the **only** job-scoped route that demands
  the UUID; every other one takes the code. Minor, but a real inconsistency with the project's own
  identity convention.
- Open a **Completed** job → hard view-only (decision `2026-08-25-completed-job-view-only`).

---

## 10. Permits and POs

Not on the payroll critical path — do these if the audience is operations-facing, or skip to 11.

### 10.1 Permits

- **Sidebar:** Permits ▸ All Permits · **URL:** `/permits/all-permits` → `/permits/create`
- Project-scoped: `/projects/<id>/permits/create`
- Tracking board: `/permits/track-permits`

Types: `TRAVEL_ANNUAL_PURPLE_PERMIT`, `TRAVEL_CITY_STREET_PERMIT`,
`ASSET_LEVEL_CITY_AGENCY_PERMITS`, `FAA_PERMIT`, `ENCROACHMENT_PERMIT`, `SUB_HAULER`.
Statuses: `PENDING · ACTIVE · INACTIVE · DRAFT`.

**Edge case — the permit→PO bridge.** On a permit detail, **"Generate PO"** appears **only** when
the permit's type requires a PO **and** it has no linked PO yet
(`permitTypeRequiresPurchaseOrder(permit.type) && !permit.linkedPurchaseOrder`). So:
1. Create an `ENCROACHMENT_PERMIT` → *Generate PO* is there → click it.
2. Reload → the button is **gone** (PO now linked).
3. Create a `TRAVEL_ANNUAL_PURPLE_PERMIT` → the button **never** appears.

That asymmetry surprises people; show it rather than describe it.

The line is **annual vs single-job**, not travel vs non-travel: an annual purple permit is paid
once for the year and TCG absorbs the cost, so no PO is raised; a single-job city/street permit is
bought per job with the city as the vendor, so it does get one. `PO_EXEMPT_PERMIT_TYPES` therefore
holds `TRAVEL_ANNUAL_PURPLE_PERMIT` alone. Source:
[`vault/decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md`](../../../vault/decisions/2026-06-18-annual-permits-no-po-single-permits-need-po.md),
which names the older travel-wide exemption **wrong**. Before that decision was implemented the
predicate was `isTravelPermitType()` and `TRAVEL_CITY_STREET_PERMIT` was exempt — if you are
demoing against an older build, expect step 3 to behave differently.

### 10.2 Purchase Orders

- **Sidebar:** PO's ▸ All PO's · **URL:** `/pos/all-pos` → `/pos/create`
- Project-scoped: `/projects/<id>/pos/create`
- Tracking board: `/pos/track-pos`

Form (`po-form-fields.tsx`): **Vendor** (required — create one at `/vendors/create` first),
**PO Type** (`GENERAL` | `CONTRACT`), **Job**, Area, City, Valid Till, Invoice Number,
Discount %, PO Fee, Description, and **line items**.

**Line items** carry `belongsToAsset` and can point at either an **Asset** or a **Part**, with
UOM / quantity / unit rate → subtotal.

Statuses: `PENDING · DRAFT · PURCHASED · CANCELLED · ACTIVE · INACTIVE`.

**Edge cases:**
- The **Linked Permit** and **Linked Vendor Asset** fields on the form are **read-only** — they are
  populated by the permit's *Generate PO* flow or a vendor-asset assignment, never typed. Open a
  permit-generated PO and show them filled.
- **Discount % + PO Fee together** — check the arithmetic on the total, don't assume it.
- Delete a **vendor** that has POs: the FK is `onDelete: SetNull`, so the PO survives with a null
  vendor. Show what the detail page renders in that state.
- A PO line item pointing at an **archived** asset or part.

---

## 11. DAS — allocate and send tickets

- **Sidebar:** Daily Allocation System · **URL:** `/daily-allocation-system`

Three panels, drag-and-drop, live over a socket (`useDasSocket`):

| Panel | Contents |
| --- | --- |
| **Left** | Assets, Vendors |
| **Middle** | Jobs for the selected date → sub-jobs → allocation slots → tickets |
| **Right** | Employees, Temp Employees |

> On screens ≤1920px the side panels are **collapsed by default** and only one opens at a time.
> Above 1920px both are always visible. If a demo machine is on a laptop screen, know where the
> toggle tabs are before you're live.

### 11.1 Set the date

Use the header date picker to select your job's schedule date. Nothing appears until the date
matches the schedule you set in 9.1 — the commonest "why is the board empty" moment.

### 11.2 Allocate

**Order matters (see 5.2):** the parent/child resource tree must already exist. It does, if the
Resources tab in 9.1 showed a hierarchy.

1. Drag the **crane** from the left panel onto the crane slot.
2. Drag the **Operator** and **Oiler** employees from the right panel onto their slots.

`craftCodeId` auto-populates from the employee's **primary** craft when it matches the slot's role.
When it doesn't, the craft must be supplied explicitly and the resolver matches it against a
`SECONDARY` assignment.

**Verify:** the sub-job stage advances (`OPEN → ALLOCATION_COMPLETED`), and each crew card shows the
resolved craft.

**Edge cases:**
- **Quantity 2 on the quotation → two sets on the board.** Verify.
- Allocate an employee whose **primary craft doesn't match the slot** — expect the explicit-craft
  path, not a silent wrong rate.
- Allocate an employee with **no primary craft** → the resolver returns a `NO_PRIMARY_CRAFT`
  *blocked rate*, not an exception. Nothing crashes; the rate is simply unavailable.
- Mark an asset **in maintenance** (asset card popup) and try to allocate it.
- Double-book one employee across two jobs on the same day — **keep this one**, it sets up the
  headline payroll defect in step 13.

### 11.3 Send tickets

Job row → **Send Tickets** → confirmation modal (which also surfaces the **Job Payroll Flags** card,
a second place to set them).

**Verify:** the modal reports the ticket count; sub-job stage → `TICKET_SENT`; each allocated
employee now has a pending field ticket.

**Edge cases:**
- **After sending, allocations are frozen.** Re-open the allocation editor →
  `400 "Cannot modify allocations after tickets have been sent"`. Show this; it is what makes the
  5.2 defect unrecoverable.
- Send with an **unfilled slot**.
- Send to an employee **with no portal user** — the ticket exists but nobody can act on it. There is
  **no admin override**: `getTicketForEmployeeAction()` is a hard
  `user.employeeId !== ticket.employeeId → 403 "Not your ticket"` with **no ADMIN bypass**. Support
  and QA genuinely cannot drive a field ticket on someone's behalf. Worth flagging as an operational
  gap, though it may well be deliberate.

---

## 12. Field ticket — **mobile**

**This is the point in the demo to pick up the phone.** Everything before this was web; everything
after is web again.

### 12.1 Log in

Open Expo on `8081`, sign in as the invited Operator. Routing (`session/route.ts`):

```
unauthenticated                 → (auth)/login
authenticated + fieldWorker + !onboarded → (onboarding)/welcome
authenticated + fieldWorker + onboarded  → (field) tab app
authenticated + sales / dispatcher       → their group root (mock data)
authenticated + unmapped employee type   → (common)/not-provisioned
```

**Verify:** first login shows the **onboarding carousel** (tracked server-side per employee, not per
device — it will not reappear on a second device).

**Edge case:** log in as the "Driver" employee from step 4.3 → **"Not set up for the app yet.
Your role isn't configured for the field app."** with a Sign out button. Graceful, and it proves the
persona mapping is real.

### 12.2 The ticket — 15 steps

Field tab → **Jobs** → today's ticket → the step list. `TICKET_TOTAL = 15`:

| # | Key | Title | Kind |
| --- | --- | --- | --- |
| 1 | `pretrip` | Pre-Trip Inspection | checklist (+ photo slots per unit) |
| 2 | `leftYard` | Left Yard | GPS |
| 3 | `driving` | Driving to Site | GPS (ETA pill) |
| 4 | `arriveJob` | Arrived at Job Site | GPS (geofenced) |
| 5 | `sig1` | Customer First Signature | signature |
| 6 | `jsa` | JSA — Tailboard | checklist |
| 7 | `startWork` | **Start Work (Boom Time)** | timer |
| 8 | `endWork` | **End Work (Boom Time)** | timer |
| 9 | `sig2` | Customer Final Signature | signature |
| 10 | `leftJob` | Left Job Site | GPS |
| 11 | `arriveYard` | Arrived at Yard | GPS |
| 12 | `posttrip` | Post-Trip Inspection | checklist |
| 13 | `compliance` | Compliance | — |
| 14 | **`labor`** | **Labor & Unit** | **the payroll input** |
| 15 | `review` | Review & Submit | — |

Six of these write real time-tracking milestones (`PATCH /field/tickets/:id/steps`):
`leftYard · arriveJob · startWork · endWork · leftJob · arriveYard`.

**Run a full shift.** For the payroll demo, make `startWork → endWork` span **14 hours** (e.g.
06:00–20:00 local) so you cross both the 8h OT and 12h DT thresholds in one day.

**Verify on web while the phone is still in hand:** open the DAS board — the sub-job stage tracks
the milestones (`LOADOUT → EMPLOYEE_LEFT_YARD → WORK_IN_PROGRESS`). Two screens, one flow: this is
the best moment in the whole demo.

### 12.3 Step 14 — Labor & Unit (the one that matters)

The crew card list shows the caller plus every boom-working Operator-type teammate in the same set.
Per person: hours (auto-computed from the boom window), **lunches taken**, **work-through-lunch
(WTL) count**, and the **Craft Modifier / boom bracket**.

**Verify:** the app pre-fills the suggested bracket from the crane's boom length — with a 197 ft
crane it should read **`181–200 ft (+$4.50/hr)`**. If it says **"No boom pay"** or the crew card
shows no suggestion, your resource tree was flat — see 5.2.

**Edge cases — do all three, they take a minute each:**
1. **Override the bracket without a reason** → `400`: "craftModifierOverrideReason is required when
   overriding the suggested craftModifierBracket." The gate works.
2. **Override with a reason** → accepted, persisted with both fields.
3. > 🔴 **Then show that the override changes nobody's pay.** The persisted
   > `craftModifierBracket` is written by the labor-entry repository, selected once by the payroll
   > repository, and **never referenced in `payroll.service.ts` or the engine's `calculate.ts`**.
   > The boom adder actually paid comes solely from `CraftRateResolverService.resolveBoomAdder()`,
   > which re-derives the bracket from the crane's `mainBoomLength` and ignores the field entry
   > entirely. A fully-built, fully-validated override workflow with **no effect on wages**. Whether
   > it's dead code or a missing engine path is a product decision — say that, don't adjudicate it.
4. **Minor, but visible:** record an entry with an overridden bracket + reason, then re-submit the
   same entry with the *correct* (non-overridden) bracket — the stale
   `craftModifierOverrideReason` **does not clear to null**.
5. **WTL** — set `wtlCount: 1` on one employee. Work-through-lunch converts to 0.5h DT.

### 12.4 Submit

Step 15 → **Submit**. Ticket status → `COMPLETE`.

**Edge case worth raising deliberately:** submit **without completing Pre-Trip, JSA, Post-Trip or
either signature**. It succeeds. Empty `captures`/`summaries` are accepted. Whether a checklist
should gate submission is **genuinely unspecified** — `field-ops-mobile-INDEX.md` is an
un-reconciled three-way conflict between FR-TCG-FOP-001, FR-TCG-FOP-002 and the Atom user stories,
and none is authoritative. So this is an open product question, not a bug. Ask the room.

### 12.5 Mobile screens that are not real

- **Menu ▸ My Labor** (`(field)/menu/labor.tsx`) — hardcoded demo shift log
  (`Job #9921`, `$52.40/hr`, "Local 139"). **No payroll backend behind it.** Do not present it as
  the employee's real pay.
- The **sales** and **dispatch** personas — mock-only, per §0.2.

---

## 13. Payroll

Back on the web, as the tenant admin.

- **Sidebar:** Payroll Management ▸ Weekly Payroll · **URL:** `/payroll`

### 13.1 Open the week

Empty state → **Open Week**. Periods are **Saturday → Friday**
(`POST /payroll/periods` — "get or create the Saturday–Friday period containing weekOf"). For a job
worked Thu 2026-08-27 the period is **Sat 2026-08-22 → Fri 2026-08-28**.

Two views: **List** and **Calendar** (toggle in the hero). Calendar shows KPIs per week.

### 13.2 Calculate

Press **Calculate** — this ingests completed tickets and prices the whole period.

**Verify in the worklist:** employee rows with total hours, ST/OT/DT split, gross, and a status
(`FLAGGED` when the run raised issues).

### 13.3 Employee timesheet — where the numbers become explainable

Click an employee → `/payroll/<employeeId>?periodId=…`. Panels: hero, stats, daily rows, pay
breakdown, pricing slices, **rate resolution**, rest audit, guaranteed hours.

**Verify — the pieces that should be right:**
- **OT after 8h/day, DT after 12h/day.**
- Hours **outside the 06:00–17:00 window** price as OT even under 8 cumulative hours.
- **Saturday → all OT. Sunday → all DT.**
- "Special Saturday" (first Saturday of June/December) → 2×; L12 holiday calendar → 3×.
- **Long boom** priced **per bucket**: bracket adder × that bucket's multiplier (ST ×1, OT ×1.5,
  DT ×2). With the 181–200 bracket: $4.50 / $6.75 / $9.00 per hour.
- **Foreman $3/hr** on the flagged employee only, **flat**. **Military $10/hr**, flat.
- Every dollar is a **separate pay component**, never just a total (`PAY-059`).

**Verify — the pieces that should be wrong, and are:**

> 🔴 **1. Overlapping shifts are silently chained and mispriced. This is the headline defect.**
> If you double-booked an employee in step 11.2, this is where it pays off. `chainJobDays()` in
> `packages/payroll-engine/src/calculate.ts` groups an employee's entries into one continuous shift
> whenever the gap between them is **< 8 hours** — and it does **not distinguish a negative gap (an
> outright overlap) from a normal short rest period**. So the second job inherits the first job's
> cumulative hours: the very first slice is already priced as overtime, and double-time starts after
> 4 more hours instead of 8.
>
> Measured on the demo tenant: **$2,019.68 actual vs $1,454.24 correct — a $565.44 overpayment on
> one ticket**, and $396.00 on a second, independently. `PAY-029` ("Overlapping labor detection") is
> a **registered rule** for exactly this condition, and it is not implemented. The rule carries no
> body, so the *correct* response (reject? flag? cap?) is unspecified — but silently paying DT on
> hours recorded at two jobs simultaneously is very unlikely to be it.

> 🔴 **2. `LATTICE_GROUP_INELIGIBLE`** on every lattice-flagged job day — see 3.1. Check the
> `issues` array on the employee's day rows.

> 🔴 **3. The craft-modifier override you recorded on the phone had no effect** — see 12.3.

### 13.4 Approve

Select employees → **Bulk Approve** (per-employee-week approval), or approve the **whole period**.

**Verify:** approved rows change status; the period advances toward `APPROVED`.

**Edge cases:**
- **Recalculate after approval** → `400 "Cannot recalculate a period that is already approved"`.
  The lock works, and covers both `APPROVED` and `EXPORTED`.
- > 🔴 **Period-level approve bypasses per-employee approval entirely.** `approvePeriod()` calls
  > `approveAllWeeks()` directly with **no per-week status gate**, so it sets the period to
  > `APPROVED` even while every employee week is still `FLAGGED` — completely disconnected from the
  > `approveEmployee()` / `maybeAdvanceToApproved()` workflow that implies all weeks must be
  > approved first. Two approval surfaces with different guarantees. `PAY-065` is an un-detailed
  > register entry, so which behaviour is intended is a **product decision**, not a code bug.

### 13.5 Export to ADP

**Send to ADP** in the hero → confirmation dialog listing approved employees and a not-ready count →
confirm. Downloads an **XLSX**, with a **CSV** sibling. Filename convention:
`EPI<ADP_COMPANY_CODE><period-Friday-date>.xlsx`, e.g. `EPI4RZ20260828.xlsx`.

Export advances the period to `EXPORTED`.

**Verify:** open the CSV. Header row:

```
File #, Employee, Employee Code, Payroll Group, Unit_Asset, Date, Day, Total Hrs, ST, OT, DT, H2x, H3x,
Lattice Oper, Lattice Oiler, 2nd Shift, 3rd Shift, Craft Modifier, LB Total, LB ST, LB OT, LB DT, LB 3X,
Subsistence, Sick Hrs, Salary
```

Hour totals should match the timesheet exactly, and the Craft Modifier column should read
`181-200 ft`.

**Edge cases:**
- **CSV quoting** — an employee whose name needs quoting, e.g. `O'Connor, James` (curly apostrophe
  *and* the "Last, First" comma), must come back wrapped in double quotes and parse cleanly. It
  does. Name one of your demo employees this way on purpose.
- > 🔴 **Foreman and Military premium dollars are absent from the export entirely.** There is no
  > Foreman column and no Military column anywhere in that header. On the demo tenant that is
  > **$350 of correctly-computed, stored, API-visible premium pay for one employee for one week**
  > with nowhere to land in the one artifact this system produces to actually pay someone. Note that
  > "Lattice Oper" / "Lattice Oiler" **do** have dedicated columns — so the format has room for
  > premium columns; Foreman and Military are specifically missing. The ADP code families exist and
  > are confirmed live (`FRR/FRO/FRD/FRT`, `MLR/MLO/MLD/MLT`). This is the second most serious
  > finding on the payroll path.
- Export a period with **zero approved employees**.
- Export **twice** and check the period status and filename.

---

## Appendix A: screens that are placeholders or dead ends

Click through these before the demo so nobody finds them live.

| Screen | URL | State |
| --- | --- | --- |
| Reporting | `/reporting` | `EmptyState` — "Reporting hasn't been developed yet." |
| Payroll ▸ Rules Configuration | `/payroll/rules` | placeholder |
| Payroll ▸ ADP Payroll Files | `/payroll/adp` | placeholder |
| Payroll ▸ Audit Log | `/payroll/audit` | placeholder |
| Mobile ▸ Menu ▸ My Labor | `(field)/menu/labor` | hardcoded fixture, no backend |
| Mobile ▸ sales persona | `(sales)/*` | mock-only |
| Mobile ▸ dispatch persona | `(dispatch)/*` | mock-only |
| My Job Tickets | `/tickets` | works, but no sidebar link; shows only your own tickets |
| Legacy asset routes | `/asset-management/units`, `/unit-types`, `/billing-codes` | resolve, but removed from the sidebar |

---

## Appendix B: known defects worth demonstrating

Ranked by how much they cost, from [E2E_PAYROLL_FLOW_REPORT.md](../E2E_PAYROLL_FLOW_REPORT.md).
"Wrong dollars" first.

| # | Defect | Where in this doc |
| --- | --- | --- |
| 1 | Overlapping same-day labor entries chained and mispriced — **$565.44 + $396.00 measured overpayment**; `PAY-029` registered and unimplemented | 13.3 |
| 2 | Foreman + Military premium dollars absent from the ADP export — **$350/employee/week with no column** | 13.5 |
| 3 | `CraftCode.wageGroup` unsettable via UI or API → Lattice premium (`PAY-044`) can never pay | 3.1, 13.3 |
| 4 | Recorded/overridden `craftModifierBracket` has **zero effect** on boom pay | 12.3 |
| 5 | `POST/PATCH /quotations` 500s on a date-only `jobDate`/`jobEndDate` | 8.1 |
| 6 | `tempId`/`parentId` linking silently fails; allocations against a flat tree lose boom length **permanently** | 5.2, 11.3 |
| 7 | `PATCH /payroll/jobs/:jobId/flags` demands the UUID; every other job route takes the code | 9.1 |
| 8 | Period-level approve bypasses per-employee-week approval | 13.4 |
| 9 | `GET /projects/:id` returns null `job`/`quotation`/`customer` right after conversion while `metrics` counts them | 9 |
| 10 | No admin path to act on another employee's field ticket (may be deliberate) | 11.3 |
| 11 | Stale `craftModifierOverrideReason` after correcting a bracket | 12.3 |
| 12 | Craft-modifier table can hold duplicate ranges and gaps with no warning | 3.2 |

### Fixed — do not demo these

Rows leave the table above only into this one, with the PR that fixed them. Kept so a reader can
tell "fixed" from "never happened", and so a regression reads as a regression.

| Defect | Fixed by | Verified |
| --- | --- | --- |
| _(none yet — this table starts empty)_ | | |

**Open product questions — raise, don't adjudicate.** These are not defects; the product record is
either silent or self-contradictory, and a named human has to settle them.

| Question | Where it is already written down |
| --- | --- |
| What a newly created tenant must contain — defaults, or an empty portal | `vault/admin/gaps.md` → *What a newly created tenant must contain* |
| Premium catalog per-tenant vs engine constants, and what an empty table means | `vault/payroll/gaps.md` → *Payroll premium catalog* |
| `SHIFT_2`/`SHIFT_3` fallbacks ($1/$1.50) contradict `PAY-036`/`PAY-037` ($3/$4), four sources | same entry — flagged ⚠️ there |
| Foreman/Military flat vs multiplied through OT/DT/holiday tiers | `PAY-070` / `PAY-071`; `vault/payroll/foreman-and-military-premiums.md` |
| Are checklist/JSA/signature steps mandatory before ticket submit? | `vault/field-ops/field-ops-mobile-INDEX.md` — unreconciled three-way conflict |
| `MILITARY` premium `appliesTo` drift (real, currently inert) | `vault/payroll/gaps.md` |

**If you hit a new one during a demo, it goes in the module's `gaps.md` — never in this file.**
This file records how to *see* the question on screen; the vault records the question itself.

---

## Appendix C: fresh-tenant pre-req checklist

Tick every box before you start the demo narrative. Anything unticked fails **later**, mid-flow.

**Environment**
- [ ] API, web, mobile running; `@tcg/shared` built
- [ ] `EXPO_PUBLIC_DATA_SOURCE=api` and `EXPO_PUBLIC_API_URL` on a LAN IP
- [ ] `SES_FROM_EMAIL` configured — or a manual plan for linking the field worker's `User` to their `Employee`
- [ ] `ADP_COMPANY_CODE` set (drives the export filename)

**Tenant bootstrap**
- [ ] Tenant created via `/admin/tenants` (needs a `SUPER_ADMIN`)
- [ ] `ADMIN`-role user created for it via `/admin/users`
- [ ] **Payroll premium rows seeded by hand** — no UI creates them, `seedTenantDefaults()` has no callers, and an empty table falls back to engine constants (two of which contradict `PAY-036`/`PAY-037`)

**Reference data (Settings)**
- [ ] Union codes — at least one `UNION` and one `NON_UNION`
- [ ] Work comp codes · Billing code types · Industry codes · Loss reasons · Certificates · Expense GL accounts

**Payroll foundations**
- [ ] Craft codes with `CraftCodeRate` rows (Operator + Oiler minimum)
- [ ] Craft-modifier bracket ladder generated (and one gap left in deliberately)

**Org**
- [ ] Departments (Dispatch, HR, Operations) · Yard
- [ ] Employees with **Employee Type = Operator / Oiler** (persona mapping) and a **primary payroll craft**
- [ ] At least one employee **invited and able to log in on mobile**
- [ ] Optional: one "Driver" employee to demo the not-provisioned screen

**Assets**
- [ ] Category → Sub-Category
- [ ] **Sub-category associated resources configured (Operator, Oiler)** ← boom pay depends on this
- [ ] Crane asset with a **Main Boom Length** that lands in a bracket

**Commercial**
- [ ] Billing codes (asset + employee types) · Price list with items · Customer linked to it
- [ ] Customer with at least one job site
- [ ] Vendor (for the PO demo)

**The run itself**
- [ ] Quotation with a **hierarchical** resource tree — verified on the Resources tab
- [ ] Project + job created; **Schedule set**; **payroll flags set**
- [ ] DAS allocations made **after** the tree exists; tickets sent
- [ ] A deliberate **second overlapping ticket** on the same employee, same day (for 13.3)
- [ ] Field ticket completed on mobile with a 14-hour boom window
- [ ] Payroll period opened for the Sat–Fri week containing the job date
