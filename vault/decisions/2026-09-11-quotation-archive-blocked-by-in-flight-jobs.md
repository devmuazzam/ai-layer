---
title: Quotation archive — blocked while a linked job is ACTIVE or ON_HOLD — decision
source: decision/Fouzan Shakil
decided: 2026-09-11
decided_by: >-
  Fouzan Shakil (CodingCops), stated 2026-09-11 in a Claude Code review session
  of branch `fix/das-fixes`, in answer to explicit questions. Not a TCG
  client-side product-owner sign-off. Recorded `status: reference` — binding on
  the CodingCops build, open to being overruled by TCG.
status: reference
conflicts_with: []
resolves:
  # part (a); part (d), the revenue effect, is left open by this decision
  - quotations/gaps.md#branch-fixdas-fixes--archive-gate-rate-error-precedence-discount-and-price-hike-footer-rows
jira: []
tags: [module/quotations, module/projects-jobs, kind/decision, reporting]
---

# Quotation archive: blocked while any linked job is `ACTIVE` or `ON_HOLD`

## Decision

Fouzan Shakil, 2026-09-11:

1. Archiving a quotation is **blocked while any linked job is `ACTIVE` or `ON_HOLD`**.
2. It is **allowed once every linked job is `COMPLETED`, `INVOICED` or `CANCELLED`**.

Those five values are the whole `JobStatus` enum (`apps/api/prisma/schema.prisma`), so every job
state is covered. The gate depends only on the statuses of linked jobs. Nothing else, such as a
linked project, was named as a blocker.

## Why

No reason was stated. The context is
[2026-08-20-archive-instead-of-delete-app-wide.md](2026-08-20-archive-instead-of-delete-app-wide.md)
(Fouzan Shakil). That convention set no preconditions for archiving. This decision adds one for
quotations: jobs still in progress block archiving, and finished or cancelled jobs do not.

## Left open by this decision

- **What archiving a WON quotation does to revenue figures.** This is filed as part (d) of the
  gaps entry. As built today, archived quotations are left out of the per-customer won-revenue
  rollup (`apps/api/src/service/quotations/quotations.repository.ts`
  `findManyForCustomerMetrics`, `archivedAt: null`). The field there is named `revenueYtd` but
  holds all-time won revenue (`apps/api/src/usecase/customers/customer-quotation-metrics.ts`:9).
  So archiving a won quote currently lowers that customer's revenue figure, and it is open whether
  it should. The other WON-revenue KPIs were not checked.

## Effect on the vault

- **Done (gaps):**
  [`../quotations/gaps.md#branch-fixdas-fixes--archive-gate-rate-error-precedence-discount-and-price-hike-footer-rows`](../quotations/gaps.md#branch-fixdas-fixes--archive-gate-rate-error-precedence-discount-and-price-hike-footer-rows).
  (a) is resolved. (d), the revenue effect, is added as open.

## What this does not settle

- **Who may archive or unarchive.** See
  [`../quotations/gaps.md#q-11--archive-unarchive-upload-and-signature-routes-lack-permission-checks`](../quotations/gaps.md#q-11--archive-unarchive-upload-and-signature-routes-lack-permission-checks).
- **What an archived record still takes part in**, such as search, reports, and references from
  live records. The 2026-08-20 note leaves this open (lines 61-63). The revenue question above is
  one instance of it.
