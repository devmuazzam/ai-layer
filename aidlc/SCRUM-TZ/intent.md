# Intent — SCRUM-TZ

> **No Jira ticket exists and none will be created** (stated by Syed Haris, 2026-09-09).
> The folder is named `SCRUM-TZ` rather than a bare `TZ` so that it is caught by the
> two sweeps that are hardcoded to the `SCRUM-*` glob:
> `grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/SCRUM-*/spec.md`. A folder named
> anything else makes this ticket's open questions invisible to the only command that
> looks for them.

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-TZ` — **synthetic id, no Jira issue** |
| Title | Lock the business timezone per tenant |
| Type | Story |
| Status | In progress — code for the prerequisite work already exists on `fix/timezone-business-day` |
| Epic | `NOT ON TICKET` |
| Sprint | `NOT ON TICKET` |
| Reporter | Syed Haris (verbal, 2026-09-09) |
| Assignee | Syed Haris |
| Captured on | `2026-09-09` |
| Captured by | Syed Haris |

## 2. Business intent

- **Intent:** The platform currently decides "what business day is it" from a single
  process-wide constant, `BUSINESS_TIMEZONE = 'America/Los_Angeles'`
  (`packages/shared/src/utils/business-time.ts:44`). That constant governs payroll week
  boundaries, rate-in-force resolution, day-type classification, dispatch board dates,
  expiry sweeps and eight cron schedules. The ask is to make that zone a property of the
  **tenant** rather than of the process, so a tenant that does not operate in Pacific gets
  its own business day rather than California's.
- **Who benefits (role):** payroll clerk and dispatcher at any tenant not operating in
  `America/Los_Angeles`; and every reviewer, because a labelled per-tenant zone makes a
  displayed time falsifiable.
- **What is worse today without it:** every business-day decision for every tenant is
  Pacific. A tenant operating anywhere else has its payroll week, its rate-change
  boundary, its dispatch board day and its reminder lead times computed against a zone it
  does not work in. The defect is silent — it agrees with the truth for a Pacific tenant
  and is off by one day for everyone else, in the direction of money.

## 3. Definition of done, as the ticket states it

```
"now i need to run it with proper AIDLC, not just implementation
Also my TPM has approved
Let's lock timezone per tenant
so need to know where the changes will be made, how the time will be saved in the db
and what will be shown to the end user, as for this branch there is no AIDLC folder,
there is no JIRA ticket and we'll not make one as well"
```

- Acceptance criteria present on the ticket: **no**
- `OPEN — there is no ticket, therefore no acceptance criteria; per domain/jira-sop.md
  this does not meet Definition of Ready. The three questions quoted above are treated as
  the acceptance criteria for the SPEC, not for the build.`

## 4. In scope

- [ ] A tenant-level timezone becomes a stored, readable property of `TenantCompany`
- [ ] Business-day decisions in `apps/api` resolve the zone from the acting tenant instead
      of the `BUSINESS_TIMEZONE` default
- [ ] `packages/payroll-engine` takes the zone as an input rather than importing the constant
- [ ] `apps/web` and `apps/mobile` learn the tenant zone and label what they display
- [ ] A stated, sourced answer to: where changes are made, how time is stored, what the
      end user sees

## 5. Out of scope

- [ ] Changing the storage convention for instants or calendar dates — `timestamptz` for
      instants and `@db.Date` for calendar dates is already settled and already applied
      (commit `047f9f4a` typed the last two naive columns). This ticket changes **which
      zone a decision is made in**, never how a value is stored.
- [ ] Re-pricing or re-computing any historical payroll period under a new zone
- [ ] Per-yard, per-job-site, per-employee or per-user timezone — see §12
- [ ] A user-facing 12h/24h time-format preference (a separate open question,
      `.ai/vault/admin/gaps.md` → *Time display*)
- [ ] Reverting or re-scoping the four commits already on `fix/timezone-business-day`

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS — presentation / usecase / service) | yes | 43 call sites in 14 files pass an explicit zone; 8 `@Cron` schedules can no longer be pinned by decorator |
| `apps/api/prisma` (schema + migration) | yes | new column on `TenantCompany` + backfill of existing rows |
| `apps/web` (Next.js) | yes | 2 `businessToday()` call sites; must obtain the zone from the session/API |
| `apps/mobile` (Expo Router) | ? | `features/field-ticket/timers/zone-label.ts` imports the constant; whether mobile converts or only labels is `OPEN` |
| `packages/shared` (types shared across apps) | yes | the constant's role changes from "the answer" to "the fallback"; `JwtPayload` may gain a field |

- `apps/api/prisma` is `yes`, so a committed migration under `apps/api/prisma/migrations/`
  is mandatory.
- `packages/shared` is `yes`, so web and mobile are downstream regardless.
- `packages/payroll-engine` is not a row in this template's fixed table but **is touched**:
  `src/slices.ts:13` `toPacific()` hardcodes the constant and
  `CalculatePayPeriodInput` has no zone field.

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `TenantCompany` | `tenantCode` / no mint prefix — `@unique`, **globally** unique, not per-tenant | adds a field; does not touch the code |

- New entity introduced by this ticket: **no**
- New code prefix introduced: **no**
- Existing rows affected (backfill / migration of data, not just schema): **yes** — every
  existing `tenant_companies` row needs a value. What that value is, is `OPEN` (§12 Q5).

`TenantCompany` is the tenant root, so it is the one model that does not follow the
per-tenant `@@unique([tenantCompanyId, …])` code convention. Verified:
`grep -n -A12 'model TenantCompany ' apps/api/prisma/schema.prisma`.

## 8. Roles and permissions

- Roles that can perform this: `OPEN — who edits a tenant's timezone?` `TenantCompany`
  is writable today only through `admin/tenants`, guarded `@Roles(Role.SUPER_ADMIN)`
  (`apps/api/src/presentation/admin/admin-tenants.controller.ts:13`). There is also a
  tenant-scoped `/settings` area in web (`apps/web/src/app/(protected)/settings/`) with
  ten existing sub-pages. Nothing states which is correct. See §12 Q6.
- Roles explicitly excluded: `NOT ON TICKET`
- Tenant scope: **something else** — `TenantCompany` is the tenant root itself, and the
  8 cron sweeps read across all tenants with no tenant filter at all. See §12 Q4.

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | `NOT ON TICKET` |
| Jira attachments | `N/A — no ticket` |
| Related tickets | `N/A — no ticket`. The nearest prior art is the branch itself: `cdc34c30`, `c5c7f6a9`, `35d84071`, `45934840`, `047f9f4a` on `fix/timezone-business-day` |
| Existing repo docs | `packages/shared/src/utils/business-time.ts` module docblock — states the three kinds of temporal value and that the constant is "a *parameter* on every function below so that making it `TenantCompany.timezone` is a wiring change, not a rewrite" |
| Vault area the reader thinks is relevant | `payroll/`, `assets/gaps.md`, `admin/gaps.md` — **verified by the elaborator; all three are relevant, and none contains a business timezone** |

## 10. Terms used that may not be defined

- **business day** — used as: *"business-day boundaries for payroll navigation, filters,
  dispatch and dates shown to people"* (commit `35d84071`). The repo defines it as the
  calendar day read in `BUSINESS_TIMEZONE`. **The vault does not define it at all**, and
  `.ai/vault/assets/gaps.md` → *The fleet day* is an open question asking for exactly this.
- **workday start** — not used on the ticket, but load-bearing and undefined:
  `payroll/payroll-rule-dependency-matrix.md` row 14 records that *"no workday-start
  concept exists anywhere in the vault… every daily-OT rule in the register presumes a
  workday boundary nobody has defined."*
- **tenant** — used as: *"lock timezone per tenant"*. The vault's only recorded discussion
  of what a tenant is includes a suggestion that *"a yard is a tenant"*
  (`meetings/transcripts/2026-03-19-roles-permissions-figma-demo.md` 36:23–38:18,
  `status: reference`). Unadjudicated.

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| *(none stated on the ticket)* | `N/A — the ticket states no numbers` |
| `America/Los_Angeles` — the value in code today | `NOT ON TICKET — no origin cited.` The elaborator's vault sweep found **zero** written backing for it. Its only occurrence in the vault is ADP vendor data on a worker record (`payroll/adp-api-responses/workers-meta.md` L224), which `assets/gaps.md` explicitly flags as *not a product decision and not a day definition*. |
| Saturday–Friday payroll week | `payroll/rules/PAY-001-saturday-friday-payroll-week.md`, `status: settled`, quadruple-sourced. Settles the *week*; **does not settle when Saturday begins**. |

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: **5** — Epic, Sprint, Jira attachments, design handoff,
  roles explicitly excluded
- Fields left as `OPEN`: **3** — acceptance criteria (§3), who edits the zone (§8),
  backfill value (§7)
- Is this ticket, as written, buildable without a product answer? **no**
- The blocking questions are carried into `spec.md` §12 as Q1–Q8.

---

**Next step:** `spec.md`, beside this file.
