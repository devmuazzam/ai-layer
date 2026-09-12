---
title: An Optional catalog association the quotation never priced is not a DAS slot — conversion does not materialise it, and the job Resources tab mirrors the quotation's priced lines
source: decision/CodingCops (Syed Haris), stated in the 2026-09-12 Claude Code session; recorded 2026-09-12
decided: 2026-09-12
decided_by: >-
  Syed Haris (CodingCops developer, author of PR #537 and PR #541), in the 2026-09-12 Claude Code
  session, verbatim: "it was decided by me, if it's an optional and it's not have any price, then
  it shouldn't be shown in DAS". No recording, no Jira ticket, no Confluence page. A developer's
  own decision, not a product owner's, and not a TCG decision-maker's; the client (Lisette
  Anzaldo, Ryan Adams, Melissa McNutt) has not confirmed it. Recorded as status: reference — a
  CodingCops-stated rule, shipped, not adjudicated by TCG.
status: reference
conflicts_with: []
resolves: [dispatch/gaps.md#branch-fixuat4-schedule-copy-allocation--a-das-slot-the-quotation-never-priced-the-job-resources-tab-now-hides-materialised-0-rows-the-board-still-allocates-against-them, projects-jobs/gaps.md#branch-fixuat4-schedule-copy-allocation--job-resources-tab-hides-rows-the-quotation-never-priced--see-dispatchgapsmd]
tags: [module/dispatch, module/projects-jobs, module/quotations, kind/decision, daily-allocation]
---

## Decision

A `SubCategoryAssociatedResource` with `isRequired = false` (**Optional**) that the quotation did
**not** carry as a priced line is **not a job resource and not a DAS allocation slot**.

- **Conversion** (`apps/api/src/usecase/projects/materialize-job-resources.ts`,
  `materializeAssociatedJobResources`) no longer creates a $0 `job_resources` row for an Optional
  association the quotation never persisted — `if (!association.isRequired) continue;`
  (line 142). **Always Included** (`isRequired = true`) associations still materialise as before.
- **Cleanup**: `apps/api/prisma/scripts/remove-optional-materialized-job-resources.ts` removes
  the $0 rows that earlier conversions created for Optional associations (a row with no
  `quotationResourceId`, $0 rate and amounts, whose parent's sub-category associates its FK with
  `isRequired = false`).
- **The job's read-only Resources tab mirrors the quotation's priced lines.** Materialised $0
  rows (no `quotationResourceId`, $0 rate/amounts) are dropped in `mapJobResourcesToFormValues`,
  and the shared `ResourcesTab` no longer synthesises virtual $0 catalog children on the job tab
  (`catalogAssociations` prop, passed `false`).

Shipped in PR #541 (`fix/das-optional-associations-not-materialized`, merged 2026-09-11;
`aidlc/processed.log` Path C row, line 95) commit
`765fffc8c` — *stop materialising Optional catalog associations on conversion* — as the follow-up
to PR #537 (`fix/uat4-schedule-copy-allocation`, merged 2026-09-11; `processed.log` line 92) commit `c6716980d` — *job
Resources tab shows only the quotation's priced lines*. Raised in UAT-4 when a Rigger the
quotation never carried appeared on a job's Resources tab at $0.

## Why

The decision follows from the one written rule the vault has about inclusion types.
[2026-09-04-always-included-associated-children-cannot-be-removed.md](2026-09-04-always-included-associated-children-cannot-be-removed.md)
(`reference`): an **Always Included** child is auto-populated on the quotation and cannot be
removed; an **Optional** child is auto-populated and **the salesperson may remove it**. If the
salesperson removed it, the quotation is the record that they did. Materialising it again at $0
on conversion — which `7b9d4818f` (*made allocation functional on DAS*, no ticket, no vault
source) did for every billable association regardless of inclusion type — silently reversed
that choice and put a slot on the board for a resource nobody priced. Syed's rule: *Optional*
and unpriced means it is not part of the job.

That is also the direction every written source points, none of them adjudicated:
`dispatch/daily-allocation-system.md:46` (`unverified`) — slots *"flowing from the quotation"*;
`projects-jobs/project-module/02-view-manage-job-details.md:22, :48-50` (`unverified`) — resources
*"pulled from the quotation"*; `2026-08-31-quotation-qty-not-das-sets.md` — convert-to-job copies
the tree 1:1. The materialisation was the only thing saying the catalog adds to the quote, and it
cited nothing.

## Why this is `reference` and not `verified`

The rule was decided by the **developer who wrote the fix**, on his own authority, and no TCG
voice has confirmed it. It is consistent with the 2026-09-04 rule (itself only `reference`) and
with every unverified spec, which is why it is recorded as the answer to build against rather
than left as a guess — but a developer's call about what a dispatcher sees on her board is exactly
the kind of decision this vault exists to get from the client. Upgrade to `verified` when Lisette
Anzaldo (whose allocation panel it is) or Melissa McNutt confirms. The one-line question: *"If a
salesperson removed an Optional associated resource from the quotation, should dispatch still see
an allocation slot for it on the job?"* — this note answers **no**.

## What this settles on the gaps entries

Of the three sub-questions on
`dispatch/gaps.md#branch-fixuat4-schedule-copy-allocation--a-das-slot-the-quotation-never-priced…`:

- **(a), Optional case only** — *should dispatch still see a slot for an Optional association the
  salesperson removed?* **No.** Settled.
- **(b)** — *is the job's Resources tab the operational requirement set or the quotation's priced
  lines?* **The quotation's priced lines**, as PR #537 renders it. Settled.
- **(c)** — *does conversion re-adding an Optional child at $0 override the salesperson's
  removal?* Moot: conversion no longer re-adds it. Settled by construction.

## What this does not settle

- **(a) for the two other unpriced cases.** An association **added to the catalog after the
  quotation was built**, and one **at a depth the quotation never persists**, still materialise
  as $0 rows **when they are Always Included** — `materializeAssociatedJobResources` skips only
  `isRequired = false`. For those rows the board still shows a slot and the Resources tab still
  hides it, so the tab/board split the gaps entry recorded remains for the Always Included case.
  Nobody has decided it. Stays **open** on the dispatch entry, owners as recorded.
- **Post-conversion resync between quotation and job.** Nothing changes an existing job when the
  quotation, or the catalog, changes afterwards. Stays **open**; it belongs with
  `dispatch/gaps.md#requested-vs-dispatched-resources--melissa-stated-it-the-vault-still-says-the-opposite`,
  which this note does **not** settle — Melissa McNutt's *"we don't re-quote"* two-record rule is
  the parent axis and still needs her one-line confirmation.
- **The rule for job dispatchers** named under *What this does not settle* in the 2026-09-04
  note — whether a dispatcher can remove an Always Included row from a job — is still unbuilt
  and unspecified.
- **TCG's view.** None yet.

## Effect on the vault

- No vault file body is a winner or loser: no source addressed a slot the quotation never priced,
  so nothing is marked `verified` or `superseded`. `daily-allocation-system.md` and
  `02-view-manage-job-details.md` remain `unverified`; this note agrees with both.
- `dispatch/gaps.md` → *Branch fix/uat4-schedule-copy-allocation — a DAS slot the quotation never
  priced…*: **Status flipped** to *partially resolved — (a) Optional case, (b) and (c) see this
  note; (a) for late-added / unpersisted-depth Always Included associations and post-conversion
  resync open* — **done** in the same pass, residual questions and owners kept on the entry.
- `projects-jobs/gaps.md` → *Branch fix/uat4-schedule-copy-allocation — job Resources tab hides
  rows the quotation never priced — see dispatch/gaps.md*: **Status flipped** to the same
  partial resolution — **done**.
- `dispatch/gaps.md` → *Requested vs dispatched resources…*: Status untouched; a one-line
  *see also* added pointing here — **done**.
- Both entries' *Asked* lines now cite the #537 row at `aidlc/processed.log` line 92 (corrected
  from 91 in the same pass); the #541 row is line 95.
- `2026-09-04-always-included-associated-children-cannot-be-removed.md` is unchanged; this note
  builds on it and does not upgrade it.
