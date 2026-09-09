---
title: The business timezone is a property of the tenant, and every tenant today operates in exactly one zone — decision
source: decision/Syed Haris
decided: 2026-09-09
decided_by: >-
  Syed Haris (syedharis14@gmail.com) — developer/owner directing the `SCRUM-TZ` /
  `fix/timezone-business-day` work; stated directly in a working session on 2026-09-09.
  He relayed it as an approval from his TPM, but **the TPM's name and the date of that
  approval were not captured in the session and are not recorded anywhere** — see *What is
  weak about this attribution* below. The approval is therefore not independently
  verifiable, and this note does not assert it as such. `status: reference` rather than
  `verified` for that reason — binding on implementation now, open to being overruled by
  TCG. Same basis and same precedent as
  `2026-09-08-artifact-due-date-seeded-from-first-job-day.md` and
  `2026-09-01-subsistence-not-a-craft-attribute.md`.
status: reference
conflicts_with: []
resolves: [SCRUM-TZ/spec.md#q1--who-approved-per-tenant-and-on-what-date, SCRUM-TZ/spec.md#q3--is-the-business-timezone-a-property-of-the-tenant-the-yard-or-the-job-site]
jira: []
tags: [module/admin, module/all, kind/decision, time-tracking, architecture, reference-data, requirements, yards]
entities: [tenant-company, employee, job]
---

# The business timezone is a tenant property, under a stated single-zone constraint

Settles the **grain** of the business timezone — which entity owns it — and nothing else
about time. It is the answer to `SCRUM-TZ` REQ-01 and to §12 Q1 and Q3 of
`.ai/aidlc/SCRUM-TZ/spec.md`.

## Decision

Two clauses. The second is what makes the first safe, and it is not optional wording.

1. **Grain.** The business timezone — the zone in which the business day, and therefore
   every day-boundary and labor-rule decision, is evaluated — is a **property of the
   tenant**, stored on `TenantCompany` as an IANA zone. Not a yard, not a job site, not a
   process-wide constant.
2. **Constraint, recorded deliberately.** **Every tenant today operates in exactly one
   timezone.** Syed Haris accepted this explicitly as part of the decision, and asked that
   it be written down rather than left implicit, *so that it is visible when it stops being
   true.* It is a statement about the world as of 2026-09-09, not a permanent property of
   the domain.

Clause 2 is the load-bearing half. "Tenant" is only a complete answer while it holds; the
moment a single tenant works in two zones, clause 1 stops being an answer and the question
reopens at the grain the record already leans toward (below). Anyone who reads this note
later and finds clause 2 false should treat clause 1 as **expired, not overruled** — the
correct response is to reopen the grain question, not to argue from precedent.

## Why this is load-bearing rather than obvious

It looks like a formality. It is not, for three reasons.

### 1. Before this, the vault contained no business timezone at all

Not for the company, not for a tenant, not for a yard, not for the product.
[`../assets/gaps.md`](../assets/gaps.md) → *The fleet day* (`Status: open`) records a full
sweep of `meetings/` — **65 transcripts, 17 curated minutes, 8 summaries** — that found **no
statement of a fleet day, a fleet timezone or a company timezone**, and concludes that

> a single process-wide constant is a stronger assumption than anything written supports.

That sweep is the reason this decision creates a fact rather than confirming one. It is
also why no vault file body needed to change: there was no competing document to supersede.

### 2. The only zone in the codebase had zero written backing

`packages/shared/src/utils/business-time.ts:44` has hardcoded

```ts
export const BUSINESS_TIMEZONE = 'America/Los_Angeles';
```

documented as *"a constant today because every tenant is Local 12 / California."* Code is
evidence of what is, never of what should be — and nothing in the vault supported it. The
**only** `America/Los_Angeles` anywhere in the vault is ADP vendor data on a worker record,
[`../payroll/adp-api-responses/workers-meta.md`](../payroll/adp-api-responses/workers-meta.md)
L224 (`timeZoneCode` … *"consistent with a California employer"*), which `assets/gaps.md`
flags **explicitly** as *"not a product decision and not a fleet-day definition."*

So this decision is what makes a tenant zone a legitimate thing to build. It does **not**
retroactively bless the constant; it authorises the column the constant becomes a default
for.

### 3. The meeting record supports other grains at least as well — this overrides it

This is the part most likely to be lost. The written record leans **away** from "tenant",
and the decision is taken over that lean, not in agreement with it. From
[`../meetings/transcripts/2026-03-19-roles-permissions-figma-demo.md`](../meetings/transcripts/2026-03-19-roles-permissions-figma-demo.md)
(`status: reference`), 36:23–39:45:

- **Ryan Adams**, 36:23, on growth: *"as you guys continue to grow, right? If you guys show
  up in Arizona and Nevada and Texas and."*
- **Ehtesham Anwar**, 37:40, proposing the opposite grain: *"we can shift this whole
  dashboard into a tenant kind of system where **a yard is a tenant**."*
- **Brian Petros**, 38:54 and 39:31, confirming the yard is a physical place: *"each yard is
  associated with just one address, right?"* … *"there's only one address per yard, right?"*

A yard with exactly one address is a perfectly good carrier for a timezone — arguably a
better one. And `business-time.ts`'s own docblock claims business-day decisions *"follow the
**work location**, never the viewer"* — **a work location is a site, not a company.**

**This decision is therefore explicitly narrower than the code comment that preceded it**,
and the single-zone constraint is exactly what reconciles the two: while every tenant is in
one zone, "the tenant's zone" and "the work location's zone" are the same value, so the
docblock's promise is kept without the site-level model it implies. When that stops being
true they diverge, and the docblock — not this note — describes the behaviour the product
will owe.

A transcript is a record, not a commitment (`meetings/` files are never commitments), so
nothing above was binding. But it is the strongest written signal there is, it points
elsewhere, and a note that did not say so would be hiding the cost of the decision.

## What is weak about this attribution

Stated plainly, because the whole value of a decision note is that the next reader can judge
its weight:

- **The decider of record is Syed Haris**, in session, 2026-09-09. That is a real, named,
  datable human, and it is the basis on which this note is written.
- **He stated that a TPM approved it. That TPM was not named and the approval date was not
  captured.** No message, meeting, ticket or document records it. It cannot be checked by
  anyone reading this later, and this note does not treat it as evidence.
- Consequently the TPM approval adds **no** weight beyond Syed's own statement. `status:` is
  `reference`, not `verified`: binding on implementation now, open to being overruled by a
  named TCG product owner.
- `../assets/gaps.md` → *The fleet day* names its owners as **Brian Petros**, with
  **Corrina Bustos** where it touches payroll. Neither has spoken to this. If the TPM
  approval is ever reconstructed — a name and a date — this note should be amended and
  `status:` reconsidered.

## What this does NOT settle

The grain is one question. Three others were open before this and remain open after it, and
none is answered by knowing which row the zone sits on.

- **When the business day starts** — `SCRUM-TZ` spec §12 **Q8**. The vault names this as a
  hole in its own dependency matrix:
  [`../payroll/payroll-rule-dependency-matrix.md`](../payroll/payroll-rule-dependency-matrix.md)
  row 14 (`unverified`) — *"no workday-start concept exists anywhere in the vault… every
  daily-OT rule in the register presumes a workday boundary nobody has defined."* Knowing
  *whose* zone does not tell you *when* the day starts in it. Owner: Corrina Bustos.
- **What the end user is shown, and in whose zone** — `SCRUM-TZ` spec §12 **Q7**, over
  [`../admin/gaps.md`](../admin/gaps.md) → *Time display — military, 12-hour, or per-user*
  (`Status: open`). The business zone governs *computation*; it does not follow that it
  governs *display*, and shipped code already disagrees with itself across mobile and web.
- **How the eight cross-tenant nightly sweeps behave once tenants differ** — `SCRUM-TZ` spec
  §12 **Q4**. `@Cron`'s `timeZone` is a decorator argument and cannot vary per tenant, so
  per-tenant zones and a single global sweep are not automatically compatible. Note this
  question is *created* by this decision, not merely left by it: while the zone was one
  constant the sweeps could not disagree with anything.

Also unchanged: **the fleet-day gap stays open.** [`../assets/gaps.md`](../assets/gaps.md) →
*The fleet day* asks a broader question — in whose timezone a **fleet day** starts, and
whether it must agree with the job/payroll day. This note answers the grain of the *business*
timezone only. It does not define a fleet day, does not say the fleet day must use the tenant
zone, and does not close that entry.

## Effect on the vault

- **No vault file body was edited by this note, and no frontmatter was flipped by it.** This
  was never a conflict set between vault documents — the vault contained **no business
  timezone at all**, which is why no file can be a winner and none can be superseded. The
  four-step closure in `README.md` → *How a gap gets closed* is written for conflict sets and
  does not apply here. `assets/gaps.md`, `admin/gaps.md`,
  `payroll/payroll-rule-dependency-matrix.md`, `payroll/adp-api-responses/workers-meta.md`
  and `meetings/transcripts/2026-03-19-roles-permissions-figma-demo.md` all keep their
  existing `status:` and gain no `superseded_by:`.
- **Not done here, by instruction:** `.ai/aidlc/SCRUM-TZ/spec.md` — REQ-01 `[OPEN]` →
  resolved against this note, and §12 **Q1** and **Q3** → `Status: resolved — see
  decisions/2026-09-09-business-timezone-is-a-tenant-property.md`. Syed Haris was editing
  that file in the same session and is applying those edits himself. **Q4, Q7 and Q8 stay
  `open`** so the ticket sweep
  (`grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/SCRUM-*/spec.md`) keeps finding them.
- **Deliberately not done:** [`../assets/gaps.md`](../assets/gaps.md) → *The fleet day* stays
  `Status: open`, untouched. It is a product-wide question about the fleet day, which this
  decision does not cover. [`../admin/gaps.md`](../admin/gaps.md) → *Time display* likewise
  stays open.
- **Flagged, not done:** [`../admin/INDEX.md`](../admin/INDEX.md) has no *Decisions that bind
  this module* section, so there is nowhere to list this note in the admin module the way
  [`../assets/INDEX.md`](../assets/INDEX.md):39 lists decisions for assets. `tcg-scrum` has no
  write access to that body. Whoever adds the section should list this note there.
- **No code change is authorised or implied by this note.** In particular it does not by
  itself authorise deleting `BUSINESS_TIMEZONE`: it authorises the `TenantCompany` column
  that the constant becomes the migration default for, which is `SCRUM-TZ` REQ-01's job and
  is still gated on §12 Q5 (what existing tenants get, and whether the column may be null).
