---
title: "Boom adders (craft modifiers) belong to one union per company for now; existing adders go to the union the crafts use; a missing union modifier rate is a review flag, not an approval block — decision"
source: decision/Syed Haris (CodingCops) — TCG-140, 2026-09-25 Claude Code session
decided: 2026-09-25
decided_by: >-
  Syed Haris (syedharis14@gmail.com) — CodingCops developer/owner, answering directly in a
  Claude Code session on 2026-09-25 while TCG-140 was being closed. He is **not** the
  client-side product owner. Clauses 1–2 answer a written client ask: **Brian Petros** (Data
  Analyst, ERP Project Coordinator) asked on 2026-09-16 for craft modifier codes to be *"tied"*
  to a union *"for when/if there is more than one Union"* — this note gives him the link now and
  defers multi-union, so he should ratify that deferral. Clause 3 decides one code on PAY-065's
  critical list, which this register assigns to **Corrina Bustos** (Payroll Manager, named owner
  on TCG-164); she should ratify it. Clause 4 is a CodingCops display call. `status: reference`
  rather than `verified` for that reason — the same basis as
  `2026-09-10-pending-tickets-are-a-display-only-payroll-overlay.md` and
  `2026-09-25-craft-rate-succession-day-before-auto-end.md`: binding on implementation now, open
  to being overruled by TCG.
status: reference
supersedes: []
conflicts_with: []
resolves:
  - "payroll/gaps.md#boom-pay-rates-cannot-hold-a-second-union--and-the-failure-is-silent (partial — union link and single-union limit decided; multi-union shape stays open)"
  - "payroll/gaps.md#which-payroll-issues-block-approval-pay-065--a-provisional-list-is-live-in-every-tenant (partial — sub-question 4, RATE_NO_UNION_MODIFIER_RATE only; the entry stays open)"
jira: [TCG-140]
tags: [module/payroll, kind/decision, craft-modifier, union-agreement, payroll-rules, reference-data]
entities: []
---

# Boom adders belong to one union per company — for now

Settles what TCG-140 built without a decision: app PR #660 (`feat/craft-modifier-union-link`,
merged 2026-09-24 with 0 reviews) tied boom pay to a union, and PR #665 (merged 2026-09-24) made
mobile price each crew member from their own local. This note says how far that goes today, where
existing data lands, whether a missing union rate blocks approval, and what the review screen shows.

## Decision

1. **One union only.** Boom pay (craft modifier adders) supports **a single union per company**
   for now.
   - **Keep the structure #660 built:** union-neutral brackets (ft ranges) plus one
     `CraftModifierRate` row per (bracket, union) — FCC's own shape.
   - **But a company's boom adders may belong to ONE union code only.** The API refuses to price
     brackets for a second union while another union already has adders.
   - **Multi-union boom pay is not supported and not decided** — neither different $ per local nor
     different ft brackets per local. Lifting the limit later is additive (the table already keys
     on union).
   - This answers Brian Petros's 2026-09-16 ask with a union link **now** and multi-union
     **deferred**. It does **not** adopt the prediction in CodingCops' own 2026-09-16 reply that
     *"a second agreement would almost certainly have its own brackets and amounts"* — that stays
     an open question for when a second union arrives.

2. **Existing data goes to the union the crafts actually use.** Existing adders belong to the
   ACTIVE `UNION`-kind union code **referenced by the most union craft codes** in that company —
   not "Local 12 first" as #660's migration ranked them. A follow-up data migration moves them.

3. **A missing union modifier rate is a review flag, not an approval block.**
   `RATE_NO_UNION_MODIFIER_RATE` (the employee's union has not priced the bracket) is removed from
   the default PAY-065 blocking seed, and removed from any tenant it was seeded into. It stays a
   payroll issue shown for review. **This decides only this one code** — the rest of PAY-065's
   critical list stays Corrina Bustos's open question.

4. **Display.** The payroll review screen shows **which union's table paid the boom adder**, from
   the stored `payroll_job_days.boom_union_code`. Mobile keeps showing each crew member their own
   local's adder (#665); with one union that is the same figure for everyone.

## Why

- **The client asked for the link, not for multi-union pay.** Brian's ask is conditional —
  *"for when/if there is more than one Union"*. Today there is one: `FMS_UNION_MASTER` has
  exactly one row and ADP holds one union code, `L12`. A single-union limit gives the link now,
  stops the silent failure a second union would cause, and does not invent how a second local's
  boom schedule is shaped — nothing written says whether it would differ in brackets, in amounts,
  or at all.
- **FCC's shape is union-neutral brackets and per-union money.** `stg.FMS_UNION_CRAFT_MODIFIER_Raw`
  carries `UnionCode` plus the rate columns; the bracket master is union-neutral; all 52 rate rows
  are `L12`. #660 already matches that, so there is no reason to rework its schema — only to limit
  it to one union until the second-union question is answered.
- **Clause 2 — "Local 12 first" can stop boom pay.** Verified in code on 2026-09-25: the default
  tenant seed creates union codes `UNION` (kind `UNION`) and `NON_UNION`, not `L12`
  (`apps/api/src/utility/seed-data.ts:2510-2513`). #660's migration ranks `local_number = '12'`
  first, then a code starting `L12`, then the oldest union code
  (`apps/api/prisma/migrations/20260924000000_craft_modifier_union_rates/migration.sql:109-116`).
  In a tenant holding both an `L12` code and the seeded `UNION` code, adders can land on `L12`
  while every union craft points at `UNION`. The resolver then finds no rate for the employee's
  union and raises `NO_UNION_MODIFIER_RATE` (`apps/api/src/service/craft-rate-resolver/craft-rate-resolver.service.ts:349`)
  — boom pay stops, with nothing wrong on the screen that set it up. Following the crafts puts the
  money where payroll actually looks for it.
- **Clause 3 — the FRD treats a missing modifier rate as a review item.**
  [payroll/erp-payroll-module-frd/03-payroll-groups-and-rate-determination.md](../payroll/erp-payroll-module-frd/03-payroll-groups-and-rate-determination.md)
  PR-011 *Rate Validation* (lines 205–219) lists *"missing modifier rate"* among the conditions
  that *"produce review issues"*, and closes: *"Rate differences should normally be warnings or
  review items rather than silent substitutions."* (That FRD section maps to matrix PR-014 →
  [payroll/rules/PAY-014-rate-comparison-and-validation.md](../payroll/rules/PAY-014-rate-comparison-and-validation.md).)
  The resolver does not substitute — it never borrows another local's rate and does not pay the
  adder at $0 silently; it raises the flag. The base rate still prices.
- **Clause 3 — the seed and the backfill disagreed, unintentionally.** Verified in code on
  2026-09-25: `DEFAULT_PAYROLL_APPROVAL_BLOCKING_ISSUES`
  (`packages/shared/src/constants/payroll-issue-severity.ts`, ~line 150) builds the `RATE_*` rows
  from **every** key of `PAYROLL_RATE_ISSUE_REASONS`, which since #660 includes
  `NO_UNION_MODIFIER_RATE` — so a **new** tenant blocks on **seven** codes. The PAY-065 migration
  `20260924000000_payroll_approval_blocking_issues` backfilled existing tenants with a literal list
  of **six** (`NO_ADP_FILE` plus five `RATE_*`), without `RATE_NO_UNION_MODIFIER_RATE`. Found by a
  test run on 2026-09-24. Nobody chose for new and existing tenants to differ; clause 3 aligns them
  on the non-blocking side.
- **Clause 4 — the value is already stored.** #660 persists `payroll_job_days.boom_union_code`;
  nothing in `apps/web/src` reads it yet. Showing it is how a reviewer tells which union's table
  priced the adder, which is the question the original gaps entry said the ledger could not answer.

## Client record (verified by reading, 2026-09-25)

All sources below are `status: unverified` migrated records; they are cited as what was said, not
adjudicated by this note. **No meeting discussed boom pay per union.**

- [payroll/crew-assignment-and-rate-derivation-brian-2026-09-16.md](../payroll/crew-assignment-and-rate-derivation-brian-2026-09-16.md)
  lines 34–37, **Brian Petros, 2026-09-16 03:37 PKT**: *"Are these created/assigned/associated with
  a specific Union? We only have one Union right now, but I'm thinking would be good to have these
  codes "tied" to a Union... for when/if there is more than one Union."*
- Same file, lines 306–309, **CodingCops reply (Syed Haris), 2026-09-16 19:09 PKT** (section header
  line 261): *"Craft modifiers are not tied to a union today. They are one table per company. You
  are right that they should follow the union the same way the craft codes do, since a second
  agreement would almost certainly have its own brackets and amounts. It is a small change and we
  will add the union link on the modifiers."* — **Dated 2026-09-16**, not 2026-09-17 as the gaps
  entry and the TCG-140 comment say ("drafted" 2026-09-17).
- [payroll/tcg-rawfms-staging-database/ddl/stg.FMS_UNION_CRAFT_MODIFIER_Raw.sql](../payroll/tcg-rawfms-staging-database/ddl/stg.FMS_UNION_CRAFT_MODIFIER_Raw.sql)
  and [payroll/tcg-rawfms-staging-database/data/fcc-craft-modifiers-full-master.md](../payroll/tcg-rawfms-staging-database/data/fcc-craft-modifiers-full-master.md)
  — FCC's shape: union-neutral bracket master, money keyed by `UnionCode`, 52 rate rows all `L12`.
- [payroll/gaps.md](../payroll/gaps.md) → *Union codes — one value* (ADP holds exactly one union
  code, `L12 — Local 12`) and *Boom pay rates cannot hold a second union* (`FMS_UNION_MASTER` has
  exactly one row).
- [uat/sessions/17sep-internal-uat.md](../uat/sessions/17sep-internal-uat.md) lines 43–45 (internal
  UAT, 2026-09-17), under *Craft Modifiers*: *"Need to attach a union"* — the same ask from the
  screen.

## What this does NOT decide

- **Whether a second local would need different ft brackets, or only different amounts** — or a
  different schedule at all. Open until a second union exists; the gaps entry keeps it as an open
  remainder.
- **Effective-dating of boom adders** — stays with TCG-168,
  [payroll/gaps.md → *Effective-dating the rest of payroll's rates (PAY-008, TCG-168)*](../payroll/gaps.md#effective-dating-the-rest-of-payrolls-rates-pay-008-tcg-168).
- **The rest of PAY-065** — which other codes block, fixed vs per-company, approval levels, who may
  change the list, re-gating approved weeks, run-level codes. Corrina Bustos's open question.
- **TCG-137** (remove the top add-row control on the craft-modifier screen) — UI chrome, out of scope.
- **Into-the-rate vs on-top composition of the boom adder** — PAY-011's open item, unchanged.

## Who ratifies on the client side

- **Brian Petros** — clauses 1–2. He asked for the link; the single-union limit and the deferral
  of multi-union are CodingCops calls he has not heard.
- **Corrina Bustos** — clause 3, as the PAY-065 owner.

## Effect on the vault

Done in the same pass as this note:

- [payroll/gaps.md → *Boom pay rates cannot hold a second union — and the failure is silent*](../payroll/gaps.md#boom-pay-rates-cannot-hold-a-second-union--and-the-failure-is-silent)
  — **done**: `Status` set to resolved for the union link and the single-union limit, pointing
  here, with a marked **open remainder** (multi-union shape); reply date corrected to 2026-09-16;
  the TCG-140 audit's four questions each marked answered; history kept.
- [payroll/gaps.md → *Which payroll issues block approval (PAY-065)*](../payroll/gaps.md#which-payroll-issues-block-approval-pay-065--a-provisional-list-is-live-in-every-tenant)
  — **done**: sub-question 4 marked answered by this note; the "same six codes" line corrected to
  seven for new tenants; `Status` stays **open**.

Not done by this pass — rule and index **bodies** are outside the recording agent's write scope;
left for the calling agent:

- [payroll/rules/PAY-011-l12-modifier-boom-rate.md](../payroll/rules/PAY-011-l12-modifier-boom-rate.md)
  (the boom adder rule) — pointer under **Open**.
- [payroll/rules/PAY-065-payroll-approval.md](../payroll/rules/PAY-065-payroll-approval.md) — pointer
  under **Open** for the one code decided.
- [payroll/rules/PAY-014-rate-comparison-and-validation.md](../payroll/rules/PAY-014-rate-comparison-and-validation.md)
  — pointer under **Open** (the FRD PR-011 source for clause 3).
- [payroll/INDEX.md](../payroll/INDEX.md) → the `module/payroll` decisions list — needs this note.

No file is verified or superseded by this decision.
