---
title: Payroll sidebar open-flags badge moves to Weekly Payroll sub-item; Returned Entries keeps its own badge (Ali Riaz, 2026-10-07) — decision
source: decision/Ali Riaz — stated in a Claude Code session on 2026-10-07 while reviewing the sidebar after PAYROLL-FLAGS shipped
decided: 2026-10-07
decided_by: >-
  Ali Riaz (syedharis14, CodingCops developer), stated as a one-line correction during
  a post-merge review of the PAYROLL-FLAGS sidebar work. Verbatim: "notification count
  should show on weekly payroll tab and returned entries tab not on payroll management".
  No options were offered; the ruling overrides OQ-7 from the prior PAYROLL-FLAGS build.
status: reference
conflicts_with: []
resolves: []
related_decisions: []
jira: []
tags: [module/payroll, kind/decision, sidebar, navigation]
---

# Payroll sidebar badges belong on the child items, not the group header

## The exchange

Ali Riaz, 2026-10-07, verbatim:

> "notification count should show on weekly payroll tab and returned entries tab not on
> payroll management"

This overrides OQ-7 from the original PAYROLL-FLAGS build, which placed the open-flags
badge on the "Payroll Management" group header so it would also appear as a dot on the
collapsed sidebar rail.

## Decision

- The **open payroll review flags badge** (`openFlagsBadge`) belongs on the **Weekly
  Payroll** sub-item. It does not appear on the "Payroll Management" group header.
- The **returned-entries badge** (`correctionsBadge`) stays on the **Returned Entries**
  sub-item. It was already correct before this ruling.
- Neither badge appears on the group header. The collapsed-rail dot (the previous OQ-7
  behaviour) is removed.

## Why

He gave no explicit reason. The commit's reading: a badge on a child item names the
screen it belongs to, which is more accurate. The collapsed-rail dot traded precision
for visibility — the user did not want that trade.

## What is built

**tcg branch `fix/sidebar-payroll-badge-placement`, PR #737.**

- `apps/web/src/components/sidebar/sidebar-nav-groups.tsx` —
  `PayrollManagementGroup`'s `items` mapping adds `badge: openFlagsBadge` on the
  `payroll-weekly` entry. The `badge`, `badgeTestId` and `badgeLabel` props are removed
  from the `<SidebarGroup>` call. The `payrollFlagsNavBadgeLabel` import is removed as
  it is no longer used.
- `apps/web/src/lib/payroll-flags-nav-badge.test.mjs` — OQ-7 describe block updated
  to assert the new placement (badge on child item, not group header).

## What this does NOT settle

- Whether a dot should appear on the collapsed rail for either badge. The prior OQ-7
  note noted that child-item badges are invisible while the group is collapsed and have
  no `data-testid` or accessible label. This ruling removes the visible collapsed dot
  without replacing it; if a collapsed indicator is later wanted, it would need either
  a group-level badge or a new rail-dot mechanism.
