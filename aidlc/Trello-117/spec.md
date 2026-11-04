# Spec — Trello-117 Job Walk Web Tab

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | Trello #117 — "Job walk — show it in web (design needed from Umar)" |
| Trello link | https://trello.com/c/oDAwqPpf/117 |
| Elaborated on | 2026-11-02 |
| Open questions raised by this spec | 2, in §12 |
| Already-shipped behaviour reached | Job Walk API (7 endpoints, unguarded), mobile Job Walk flow (Salesperson only) |
| Rules consulted | `contexts/api.md`, `contexts/web.md`, `contexts/prisma.md`, `contexts/patterns.md` |

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | New `job-walks` permission module | shared, api, web | `[UNVERIFIED]` | Developer decision D2 | no |
| REQ-02 | API permission guards on Job Walk endpoints | api | `[UNVERIFIED]` | Developer decision D5 | no |
| REQ-03 | Web Job Walk tab — view mode | web | `[UNVERIFIED]` | Developer decision, design HTML | no |
| REQ-04 | Job Walk step in Edit Quotation | web | `[UNVERIFIED]` | Developer decision D3, D18 | no |
| REQ-05 | Signatures read-only on web | api, web | `[UNVERIFIED]` | Developer decision D4 | no |
| REQ-06 | Audit logging for Job Walk changes | api, schema | `[UNVERIFIED]` | Developer decision D6 | no |
| REQ-07 | No Job Walk creation on web | web | `[UNVERIFIED]` | Developer decision D1 | no |
| REQ-08 | Mobile unchanged | mobile | `[UNVERIFIED]` | Developer decision | no |
| REQ-09 | Existing tenant migration for new permission | api | `[UNVERIFIED]` | Risk R2 | no |

Counts: 9 total — 0 verified, 9 unverified, 0 conflicted, 0 open.

## 2. Requirements

### REQ-01 — New `job-walks` permission module `[UNVERIFIED]`

- **Statement:** A new `job-walks` permission module is registered in `@tcg/shared`, independent from `quotations`, with levels `none < view < edit < full`.
- **Surface:** shared, api, web
- **Sources:**
  - Developer decision D2 — `[UNVERIFIED]` — kind: decision — "Create a separate job-walks permission module with independent view and edit permissions"
- **Conflict:** none
- **Open question:** none
- **Ripple:** `PERMISSION_MODULES` array in `packages/shared/src/constants/permissions.ts` gains one entry; `pnpm nx run @tcg/shared:build` required. Web permission UI (`apps/web/src/features/departments/constants/role-permissions.ts`) must display it.
- **Acceptance:** `job-walks` appears in Settings → Departments → Role Permissions; levels configurable per role.
- **Edges:**
  - **Reached by:** any authenticated request to `/job-walks/*`; Settings → Departments UI
  - **Does not apply when:** `quotations` permission — independent, never checked for Job Walk access
  - **When an input is absent:** missing key in role permissions → `'none'`
  - **Trust boundary:** server-resolved from the user's department role
- **Notes for the executor:** Follow exact pattern of existing modules in `PERMISSION_MODULES`. ADMIN/SUPER_ADMIN auto-bypass to `full` on web modules. Add to `MODULE_PERMISSIONS` in web with icon and template defaults.

**Default grants (seed data):**

| Role Template | Level |
| --- | --- |
| ADMIN / SUPER_ADMIN | `full` (auto bypass) |
| Sales Manager (`manager` template) | `edit` |
| Sales Coordinator (`admin` template) | `edit` |
| Salesperson (`contributor` template) | `edit` |
| All other roles | `none` (default) |
| USER baseline (no dept role) | `view` (not in `USER_RESTRICTED_MODULES`) |

### REQ-02 — API permission guards `[UNVERIFIED]`

- **Statement:** All Job Walk API endpoints enforce permissions at the backend via `@RequirePermission('job-walks', level)`.
- **Surface:** api
- **Sources:**
  - Developer decision D5 — `[UNVERIFIED]` — kind: decision — "Enforce all Job Walk permissions at the API level"
  - Code: `apps/api/src/presentation/job-walk-reports/job-walk-reports.controller.ts` — currently has zero permission guards
- **Conflict:** none
- **Open question:** none
- **Ripple:** Mobile Salesperson role must include `'job-walks': 'edit'` in seed data, otherwise existing mobile create/update breaks (the `PermissionsGuard` resolves missing key as `'none'`).
- **Acceptance:** Unauthenticated or unauthorized API call to any Job Walk endpoint returns 403. Mobile create/update still works for Salesperson.
- **Edges:**
  - **Reached by:** every HTTP request to `/job-walks/*`
  - **Create is the exception:** `POST /job-walks` is guarded by `mobile-quotations: edit`, not `job-walks` — creation is a mobile Salesperson action (D1). Salesperson already holds `mobile-quotations: edit` (`seed-data.ts:244` `MOBILE_QUOTATIONS_GRANT`), so mobile create keeps working; an operator or any web-only role gets 403.
  - **When an input is absent:** missing permission key → `'none'` → 403
  - **Trust boundary:** server-side guard, not frontend-only

**Guard mapping:**

| Endpoint | Guard |
| --- | --- |
| `GET /job-walks` | `@RequirePermission('job-walks', 'view')` |
| `GET /job-walks/:code` | `@RequirePermission('job-walks', 'view')` |
| `POST /job-walks` | `@RequirePermission('mobile-quotations', 'edit')` |
| `PATCH /job-walks/:code` | `@RequirePermission('job-walks', 'edit')` |
| `POST /job-walks/:code/complete` | `@RequirePermission('job-walks', 'edit')` |
| `PUT /job-walks/:code/signatures/:role` | `@RequirePermission('job-walks', 'edit')` |
| `DELETE /job-walks/:code/signatures/:role` | `@RequirePermission('job-walks', 'edit')` |

### REQ-03 — Web Job Walk tab — view mode `[UNVERIFIED]`

- **Statement:** The quotation detail page shows a "Job Walk" tab when the user has `job-walks: view` or higher, and a Job Walk exists for that quotation.
- **Surface:** web
- **Sources:**
  - Developer decision — `[UNVERIFIED]` — kind: decision
  - Design: `file:///C:/Users/CodingCops/Downloads/TCG%20Whole%20App.html` (design HTML, Job Walk tab screenshots) — approved by Umar, confirmed by the developer 2026-11-02
- **Conflict:** none
- **Open question:** none
- **Ripple:** `view-quotation.tsx` gains one tab in the `TABS` array and one case in the switch. `TabName` type union extended.
- **Acceptance:** Job Walk tab renders all survey fields and signature images in a two-column SectionCard grid matching the design screenshots. Tab hidden when the user lacks `job-walks: view` **or** the quotation has no Job Walk (D16 — no empty-state message).
- **Edges:**
  - **Reached by:** navigating to quotation detail → Job Walk tab
  - **Does not apply when:** quotation has no Job Walk; user has `job-walks: none`
  - **When an input is absent:** no Job Walk → the tab is not shown; a `?tab=Job Walk` link opens Main once the Job Walk query settles (D16, developer decision 2026-11-02).
- **Notes for the executor:** Reuse `SectionCard` from `@/components/patterns`. Follow `detail-info-cards.tsx` pattern for card grid layout. Data fetched via separate `GET /job-walks?quoteNo=` (not included in quotation response).

**Tab sections (from schema + design):**

| Card | Fields | Layout |
| --- | --- | --- |
| Crane Information | Unit #, Make, Model, Capacity | 2-col grid |
| Jib | Will jib be used?, Will jib be stowed? | Boolean Yn display |
| Outrigger Position | Outrigger position | Single value |
| Counterweight | Counterweight (lbs) | Single value |
| Crane Configuration | Boom Length, Boom Tip Height, Boom Angle, Load Radius, Weight of Load | 2-col grid |
| Capacity | Gross Capacity, Total Deductions, Net Capacity (computed), Weight of Load, Rated Line Pull, Parts of Line | Net Capacity = Gross − Deductions |
| Critical Lift | Is crane at 75%+?, Requires 2+ cranes? | Boolean Yn display |
| Personnel Platform | Personnel platform attached?, Load >50%? | Boolean Yn display |
| Signatures | Operator (name, signature image, date), Foreman (name, signature image, date) | Always read-only, image display |

### REQ-04 — Job Walk step in Edit Quotation `[UNVERIFIED]`

- **Statement:** Survey fields are edited only from Edit Quotation (D18): the wizard shows a Job Walk step, between Additional Info and Attachments, to a user with `job-walks: edit` on a quote that has a Job Walk. The detail tab is read-only, with no Edit button of its own.
- **Surface:** web
- **Sources:**
  - Developer decision D2, D3 — `[UNVERIFIED]` — kind: decision
- **Conflict:** none
- **Open question:** none
- **Ripple:** none — new UI only
- **Acceptance:** With `job-walks: edit` the step shows and its changes save with the wizard's Update; without it the step is hidden. WON/LOST: Edit Quotation is already disabled, so the step is unreachable from the page. Saving a Job Walk change runs the normal quotation update, so a quote in a locked status starts a revision like any other edit (developer rule 2026-11-02). Exception: a user without `quotations: edit` saves only the Job Walk, with no revision.
- **Edges:**
  - **Reached by:** clicking Edit button on Job Walk tab
  - **Does not apply when:** `job-walks: view` only (button hidden)
  - **Quotation WON/LOST:** disabled, not hidden — same pattern as the quotation header (`view-quotation.tsx:91-100`, `isEditable`). Developer decision 2026-11-02: "WON/LOST mein edit button disable ho jata hai, phir hide kyun karein". Pass `isEditable` from `view-quotation.tsx` into the tab instead of re-deriving it. Web-only; the API does not block a PATCH on a WON/LOST quotation's Job Walk.
  - **When an input is absent:** empty field → send as `null`
- **Notes for the executor:** `useWizardJobWalk` holds the step state. Signature panel stays read-only inside the step.

### REQ-05 — Signatures read-only on web `[UNVERIFIED]`

- **Statement:** Operator and Foreman signatures (printed name, signature image, date) cannot be modified from the web. The API strips signature fields from non-mobile update requests.
- **Surface:** api, web
- **Sources:**
  - Developer decision D4 — `[UNVERIFIED]` — kind: decision — "Signatures must remain read-only on web"
- **Conflict:** none
- **Open question:** none
- **Ripple:** Current PATCH DTO accepts `operatorPrintedName`, `operatorDate`, `foremanPrintedName`, `foremanDate` as regular fields — these must be stripped for web requests.
- **Acceptance:** Web update request with signature fields → fields silently ignored. Signature images remain from mobile upload.
- **Edges:**
  - **Reached by:** `PATCH /job-walks/:code` from web (no `x-app-platform` header or non-mobile platform)
  - **Does not apply when:** request from mobile (`x-app-platform: ios` or `android`) — signature fields pass through
  - **When an input is absent:** missing, invalid or unknown `x-app-platform` → treated as web → signature fields stripped
  - **Trust boundary:** `x-app-platform` is **client-declared**, not a trusted identity — the API has no server-side client identification (DS9). It keeps the web app and casual API use away from signatures; a caller who forges the header and holds `job-walks: edit` can still change them.
  - **Old mobile builds:** builds released before Trello-115 send no header, so their signature name/date edits are stripped and their signature upload/delete gets 403 until the user updates. U2 must not reach production before the Trello-115 mobile build is live.

**Three-layer protection:**
1. Web UI: signature card renders read-only, no edit controls
2. API: PATCH strips signature name/date fields unless the platform header is `ios`/`android`
3. API: signature `PUT`/`DELETE` return 403 unless the platform header is `ios`/`android` (DS9)

### REQ-06 — Audit logging `[UNVERIFIED]`

- **Statement:** Job Walk changes appear on the quotation's Activity Log, labelled with the Job Walk tab (D17), recording who changed what and when.
- **Surface:** api, schema
- **Sources:**
  - Developer decision D6 — `[UNVERIFIED]` — kind: decision — "Track Job Walk field changes"
  - Code: `apps/api/src/usecase/activity-logs/` — existing `EntityActivityLogger` pattern
- **Conflict:** none
- **Open question:** none
- **Ripple:** No schema change. `QuotationsModule` exports `QuotationActivityLogger`; `QUOTATION_ACTIVITY_TABS` gains `Job Walk`.
- **Acceptance:** After updating a Job Walk field via web or mobile, the quotation Activity Log and Recent Activity show "updated a field in Job Walk" with old/new values, user and timestamp. Tradeoff accepted: every saved mobile change adds an entry to the quotation timeline.
- **Edges:**
  - **Reached by:** `POST /job-walks` (create), `PATCH /job-walks/:code` (update), `POST /job-walks/:code/complete` (complete), `PUT /DELETE /signatures/:role` (signature changes)
  - **Does not apply when:** read-only access
  - **When an input is absent:** logging failure never blocks the primary operation (`safeActivityLog` wrapper)
  - **Empty diff:** when `computeFieldDiff()` returns no changed fields, no `UPDATED` row is written. Mobile autosaves by PATCH on every field change, often with unchanged values; without this the Change history fills with empty entries.

**Events logged:**

| Event | Action | Details |
| --- | --- | --- |
| Create | `CREATED` | Full initial snapshot |
| Update | `UPDATED` | Field diff: `{ field: { from, to } }` via `computeFieldDiff()` |
| Complete | `STATUS_CHANGED` | `{ status: { from: 'DRAFT', to: 'COMPLETED' } }` |
| Signature upload | `UPDATED` | `{ operatorSignature: { from: null, to: 'signed' } }` |
| Signature cleared | `UPDATED` | `{ operatorSignature: { from: 'signed', to: null } }` |

### REQ-07 — No Job Walk creation on web `[UNVERIFIED]`

- **Statement:** The web quotation detail Job Walk tab shows no create button. Job Walk creation remains mobile-only.
- **Surface:** web
- **Sources:**
  - Developer decision D1 — `[UNVERIFIED]` — kind: decision
- **Conflict:** none
- **Open question:** none
- **Ripple:** none — web has no UI to invoke `POST /job-walks`; the endpoint itself is guarded by `mobile-quotations: edit` (REQ-02).
- **Acceptance:** When a quotation has no Job Walk, there is no Job Walk tab (D16); nowhere on the web offers a create button.

### REQ-08 — Mobile unchanged `[UNVERIFIED]`

- **Statement:** Zero mobile files are modified. Existing Job Walk creation, editing, signature capture, and completion flows remain unchanged.
- **Surface:** mobile
- **Sources:**
  - Developer decision — `[UNVERIFIED]` — kind: decision
- **Conflict:** none
- **Open question:** none
- **Ripple:** The Salesperson seed must include `'job-walks': 'edit'` so the API's new `@RequirePermission` guards don't block existing mobile operations.
- **Acceptance:** All existing mobile Job Walk tests pass unchanged. Salesperson can still create, edit, sign, and complete Job Walks from mobile.

### REQ-09 — Existing tenant migration `[UNVERIFIED]`

- **Statement:** A one-time data migration grants `'job-walks': 'view'` to existing department roles that can see quotations (empty maps excluded — see DS3). A second step grants `'job-walks': 'edit'` only to roles holding `mobile-quotations` at edit or above (i.e. roles that use mobile Job Walk). Admins can then dynamically adjust edit access via department role settings.
- **Surface:** api
- **Sources:**
  - Risk R2 — `[UNVERIFIED]` — kind: decision — seed data only runs on new tenants
  - Developer decision (2026-11-02) — "existing ko hum sirf view ki day gay"
- **Conflict:** none
- **Open question:** none
- **Ripple:** All existing tenants' roles gain `job-walks: view`. Only Sales roles with `mobile-quotations` gain `job-walks: edit` to keep mobile working. Admin can upgrade any role to `edit` from Settings → Departments.
- **Acceptance:** After migration, all users see Job Walk tab (view). Existing mobile Salesperson can still create/edit Job Walks. Non-Sales roles default to view-only.

## 3. Data model

- **Schema change required:** no
- **Migration required:** data only — `20261102150000_grant_job_walks_permission` (DS3)
- **Data backfill required:** no (new enum value only)
- **Existing models considered:** `JobWalkReport` already exists (schema.prisma:1850), no new model needed.

No new Prisma model. No new columns. Only an enum value addition.

## 4. API surface

- **Pattern:** none — existing Job Walk API is already built; changes are guards and logging only
- **Existing functions/services to reuse:**
  - `JobWalkReportsController` — `apps/api/src/presentation/job-walk-reports/job-walk-reports.controller.ts`
  - `JobWalkReportsService` — `apps/api/src/usecase/job-walk-reports/job-walk-reports.service.ts`
  - `JobWalkReportsRepository` — `apps/api/src/service/job-walk-reports/job-walk-reports.repository.ts`
  - `EntityActivityLogger` — `apps/api/src/usecase/activity-logs/domain-activity-loggers.ts`
  - `computeFieldDiff` — `apps/api/src/usecase/activity-logs/activity-log.helpers.ts`
  - `safeActivityLog` — `apps/api/src/usecase/activity-logs/activity-log.helpers.ts`
- **New exported functions/services proposed:**
  - none — reuses `QuotationActivityLogger`

No new endpoints. Existing 7 endpoints gain permission guards and audit logging.

## 5. Web surface

- **Feature location:** `apps/web/src/features/quotations/` (Job Walk tab lives within quotation feature, not a separate feature folder)
- **Existing components to reuse:**
  - `SectionCard` — `apps/web/src/components/patterns/` — card layout
  - `Field` / `InfoRow` / `Yn` — `apps/web/src/features/quotations/workspace/detail/detail-ui.tsx` — field display
  - `usePermission()` — `apps/web/src/hooks/use-permission.ts` — permission checking
  - Quotation Activity Log tab (existing) — audit display
- **New components:**
  - `QuotationJobWalkTab` — `apps/web/src/features/quotations/workspace/detail/detail-job-walk-tab.tsx`
- **New hooks:**
  - `useJobWalkByQuoteNo` — `apps/web/src/features/quotations/hooks/use-job-walks.ts`
- **New services:**
  - `jobWalkService` — `apps/web/src/features/quotations/services/job-walk.service.ts`

## 6. Mobile surface

No changes.

## 7. Notifications

No notifications.

## 8. State diagram

```
[No Job Walk] → (Salesperson creates on mobile) → [DRAFT]
[DRAFT] → (complete on mobile) → [COMPLETED]
[DRAFT] → (edit fields on web/mobile) → [DRAFT]
[COMPLETED] → (edit fields on web/mobile) → [COMPLETED]
```

## 9. Guardrail check

- G1 (client-facing unspecified): ✅ All client-facing behaviour specified
- G2 (rewriting data): ⚠️ The DS3 permission migration rewrites `department_roles.permissions` JSON on every existing role (additive keys only). Needs developer approval and a run on a copy of staging data, with role counts recorded before and after.
- G3 (tenant data): ✅ Job Walk is tenant-scoped via `tenantCompanyId`; `JobWalkReport` is in tenant extension allowlist
- G4 (pay rules): N/A
- G5 (new dependency): ✅ No new dependencies
- G6 (push to main): N/A

## 10. Invariants this feature must not break

- Quotation detail page loads correctly without a Job Walk
- Mobile Job Walk creation/editing flow works unchanged
- Existing quotation permissions are independent of job-walks permissions
- Activity logging never blocks primary operations

## 11a. Existing consumers reached

| Consumer | Reached via | How we know it still works |
| --- | --- | --- |
| Mobile Job Walk (`apps/mobile/app/(sales)/job-walk.tsx`) | API guards on existing endpoints | Create: Salesperson already has `mobile-quotations: edit`. Update/complete/signatures: Salesperson seed + DS3 step 2 grant `job-walks: edit`. Manual test: mobile create/edit/sign/complete still works |
| Web quotation detail (`view-quotation.tsx`) | New tab added to TABS array | Existing tabs unaffected; new tab is additive |
| Settings → Departments → Permissions | New module in `MODULE_PERMISSIONS` | Existing modules unchanged; new module appended |

## 11b. Developer decisions

| # | Decision | Rationale |
| --- | --- | --- |
| DS1 | `POST /job-walks` guarded by `mobile-quotations: edit` | Creation is a mobile Salesperson action. Without a guard any authenticated user (operator included) could create via the API. Salesperson already holds this permission, so mobile create is unaffected. **Limit (verified 2026-11-02):** `PermissionsGuard` bypasses every module for portal ADMIN/SUPER_ADMIN, so an admin calling the API directly can still create; the web offers no create control. |
| DS2 | Signature protection uses the `x-app-platform` header (absent/invalid = web); scope in DS9 | The header is sent by Trello-115 U2a (`appVersionHeaders()` in mobile `base-api.ts`), not yet merged. Until then the API reads the literal header name from a local constant, to be swapped for `APP_PLATFORM_HEADER` from `@tcg/shared` once Trello-115 U1 merges (follow-up). |
| DS3 | Two-step data migration `20261102150000_grant_job_walks_permission`: (1) `job-walks: view` to every role with a non-empty map whose `quotations` is view/edit/full, (2) `job-walks: edit` to every role whose `mobile-quotations` is edit/full | Developer decision: "existing ko sirf view day gay". Empty maps are skipped — they resolve to the USER baseline (which now includes `job-walks: view`), and writing one key into them would drop every other module to `none` (trap documented in `20261020210000_grant_salesperson_permission`). Roles without quotation access (Field Operations) stay at `none`. |
| DS8 | New-tenant seeds mirror DS3: `FULL_PERMISSIONS` gives `job-walks: view`; Sales Coordinator and Salesperson get `edit` (`JOB_WALKS_EDIT_GRANT`); Sales Manager `view`; Field roles `none` | Approved by the developer 2026-11-02 — new and existing tenants start identical; edit is raised per role in Settings. Web role templates (`TEMPLATE_PERMISSION_CONFIG`) are unchanged: a template applies its default level to `job-walks` like any web module. |
| DS10 | Web shows the quotation's **latest** Job Walk (`GET /job-walks?quoteNo=` is newest-first; the tab takes the first) | Mobile creates one per quote in practice; if several exist, the newest is the current survey. Older ones stay reachable through the API. |
| DS11 | Signature images on the web load through the existing `GET /attachments/:id/download` (`useAttachmentImageUrl`), no new endpoint | Same path the asset meter-reading drawer uses; download is auth + tenant scoped. |
| DS12 | Web edit sends only changed survey fields; a cleared field is sent as `null`; non-numeric input in a number field is blocked client-side with an inline error | Verified `@Type(() => Number)` keeps `null` as `null` (class-transformer), so clearing does not save `0`. |
| DS9 | Header check scope (U2): PATCH strips signature name/date unless `x-app-platform` is `ios`/`android`; signature PUT/DELETE return 403 without it; GET and complete have none; POST uses the `mobile-quotations: edit` policy | Developer decision 2026-11-02. Header comes from Trello-115 U2a (`appVersionHeaders()` in `base-api.ts`) — U2 stacks on Trello-115. The header is client-declared, not a trusted identity: the API has no server-side client identification. Builds released before Trello-115 send no header, so their signature name/date edits are stripped until the user updates. |
| DS4 | Net Capacity computed in UI (Gross − Deductions) | Not stored in schema; matches mobile behaviour |
| DS6 | Job Walk tab position: after "Additional Information", before "Attachments" | Logical grouping: survey data sits with other quotation detail |
| DS7 | Superseded by D17: no separate Change history section | The approved design has none; Job Walk changes go to the quotation Activity Log. |

## 12. Open questions

### Q1 — Capacity percentage label

**Status:** closed 2026-11-03. The developer asked for the design copied exactly, and the design source defines it: Weight of Load ÷ Net Capacity. Hidden when either value is missing or Net Capacity is not above 0. The figure is display only; `criticalAt75` stays the stored answer.

### Q2 — Job Walk tab visibility for roles without quotation access

Should the Job Walk tab show for a user who has `job-walks: view` but `quotations: none`? They wouldn't be able to navigate to the quotation detail page in the first place. This is an edge case with no practical impact.

**Owner:** Developer · **Status:** unblocked (no practical impact — the quotation page itself handles access)

## 13. Tests

`not requested`

## 14. Sign-off

- [ ] Requirements ledger reviewed — *developer name, date*
- [ ] Developer decisions (§11b) reviewed — *developer name, date*
- [ ] Open questions (§12) reviewed — *developer name, date*
- [ ] Guardrail check (§9) reviewed — *developer name, date*
