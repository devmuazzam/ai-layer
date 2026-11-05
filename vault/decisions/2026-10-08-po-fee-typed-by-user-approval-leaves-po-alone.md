---
title: PO Fee is typed by the user; permit approval no longer writes it, leaves a CLOSED PO alone, and nothing recomputes the PO total (Syed Haris, 2026-10-08) — decision
source: decision/Syed Haris — answers to three blockers raised while building TCG-89 (Linear), tcg branch `fix/8-oct`
decided: 2026-10-08
decided_by: >-
  Syed Haris (CodingCops developer working Linear TCG-89, "Approving a permit overwrites fields on
  the linked PO"), stated 2026-10-08 in a Claude Code session, answering three blockers tcg-scrum
  reported earlier that session. Clauses 1 and 3 are his words. Clause 2 he delegated to the
  implementer ("use your best judgement"); the ruling recorded there is the implementer's
  judgement, made within the authority he delegated. This is a CodingCops developer-side ruling,
  not a TCG client sign-off. The named owners of the question — Liz Lopez (the permit-driven PO
  process) and Brian Petros — were not asked and have not confirmed it. That is why the status is
  `reference`: it binds the CodingCops build, and TCG can overrule it.
status: reference
provenance_note: >-
  Partly settled further 2026-10-29 by
  decisions/2026-10-29-all-permits-create-permit-modal.md (Syed Haris, TCG-132, `reference`).
  The create-time PO fee default, left open here, is settled for the Create Permit modal's
  nested "Create new" PO only: prefilled from the permit's service fee, editable. Everything
  else in this note stands. Recorded by tcg-scrum.
conflicts_with: []
resolves:
  # resolved at reference status; TCG (Liz Lopez / Brian Petros) can overrule
  - projects-jobs/gaps.md#permit-cost-vs-po-fee--uat-says-keep-them-separate-an-untraced-row-says-auto-populate-and-approval-already-overwrites-the-fee
  # part (b) only; (a), (c)-(i) stay open
  - vendors-agencies/gaps.md#po-and-vendoragency-rules-the-e2e-suite-asserts-with-no-written-source--pr-488
related_decisions:
  - 2026-09-11-po-closed-means-closed-out-not-cancelled.md
  - 2026-09-11-permit-approval-requires-linked-po.md
  - 2026-09-05-po-types-and-quote-to-invoice-workflow.md
jira: []
tags: [module/projects-jobs, module/vendors-agencies, kind/decision, purchase-orders, permits]
---

# PO Fee is typed by the user; permit approval leaves the PO's fee, a CLOSED PO and the PO total alone

## Decision

Syed Haris, 2026-10-08, three answers:

1. **PO Fee is typed by the user.** Permit approval no longer writes `poFee`. Before this, it
   replaced the linked PO's fee with Σ (`serviceFee` + `permitCost`) over the permits the PO
   covers, discarding whatever was typed. **Permit Cost** (on the permit) and **PO Fee** (on the
   PO) are two separate fields, and nothing copies one into the other in either direction. So the
   untraced UAT register row *"Auto-populate permit cost from the linked PO"* is not built.
2. **A CLOSED PO is left untouched by permit approval** — no field is written or filled. To change
   a closed PO, reopen it with the existing Close / Reopen control. *Delegated:* Syed Haris told
   the implementer to "use your best judgement"; this clause is the implementer's ruling within
   that delegation, not his own words.
3. **No PO-total computation.** In his words: *"no need of computations, manual entries will be
   made."* The PO total stays line items − discount. PO Fee is not part of the total, and nothing
   derives PO Fee from anything.

## Why

- **Clause 1.** A figure the user types was being silently replaced on approval
  ([../uat/register-2026-09-18.md](../uat/register-2026-09-18.md):263, audit finding *"Approving a
  permit overwrites a hand-entered PO Fee"*). Keeping the fields separate matches the only
  traceable UAT ask, UAT 4 #30: *"Permit Cost should be the same as the PO Fee. For now, leave it
  as a separate field"* (same register, :284). It also matches the 2026-03-26 product sync, where
  the PO amount and the permit cost are different figures — Ryan Adams, *"The PO may be 8 bucks if
  we got to go to the city, but the overall cost would be $145"*, Melissa McNutt *"Yeah"*
  ([../meetings/transcripts/2026-03-26-tcg-cc-product-sync-demo.md](../meetings/transcripts/2026-03-26-tcg-cc-product-sync-demo.md):203-204,
  `reference`).
- **Clause 2.** [2026-09-11-po-closed-means-closed-out-not-cancelled.md](2026-09-11-po-closed-means-closed-out-not-cancelled.md)
  makes `CLOSED` mean the PO is done (invoiced), with an explicit Close / Reopen control. It is
  silent on edits after close. Writing into a closed-out PO from another record's approval would
  change an invoiced document without anyone opening it; reopening is the existing, deliberate path.
  This **extends** that decision and changes none of its rules.
- **Clause 3.** The developer's answer: entries are manual, so there is nothing to compute.

**Against this decision, recorded not reconciled:**
[../vendors-agencies/purchase-order.md](../vendors-agencies/purchase-order.md):283-288 (`unverified`,
June Confluence design, itself under a `conflicts_with`), Step 6 – PO Update: *"System
automatically updates the PO with the final permit cost. No manual adjustment by Kaitlin is
required."* This decision goes the other way. If TCG wants Step 6, this note is what they overrule.

## Built alongside on the same branch (implementation, not product decisions)

- Approval fills a linked PO's **Area / City / Valid Till only when they are blank**. Previously
  it overwrote them on a single-permit PO.
- The permit write and the PO write commit in **one transaction**.
- Client branch `fix/8-oct`, uncommitted when this was written.
  Code: `apps/api/src/usecase/permits/permits.service.ts`,
  `apps/api/src/usecase/purchase-orders/purchase-orders.service.ts` and their specs.

## Effect on the vault

- **Done (gaps):** [../projects-jobs/gaps.md → *Permit Cost vs PO Fee…*](../projects-jobs/gaps.md#permit-cost-vs-po-fee--uat-says-keep-them-separate-an-untraced-row-says-auto-populate-and-approval-already-overwrites-the-fee)
  — marked resolved 2026-10-08 at `reference` status; TCG can overrule.
- **Done (gaps):** [../vendors-agencies/gaps.md → *PO and vendor/agency rules… PR #488*](../vendors-agencies/gaps.md#po-and-vendoragency-rules-the-e2e-suite-asserts-with-no-written-source--pr-488)
  — update line: part (b)'s first half (total = line subtotals − discount, PO fee excluded) answered.
  The rest of (b) (discount over 100% floors at 0) and (a), (c)–(i) stay open.
- **Done (gaps):** [../vendors-agencies/gaps.md → *Permit Cost vs PO Fee — pointer…*](../vendors-agencies/gaps.md#permit-cost-vs-po-fee--pointer-owned-by-projects-jobs)
  and [*Branch fix/das-fixes…*](../vendors-agencies/gaps.md#branch-fixdas-fixes--one-closed-status-for-invoiced-and-cancelled-pos-and-the-legacy-remap)
  — update lines; (e) of the das-fixes entry recorded as **not** settled.
- No vault file body or `status:` changes. This is a CodingCops `reference` call, not an
  adjudication between competing TCG sources — `vendors-agencies/purchase-order.md` stays
  `unverified` and is not superseded.

## What this does not settle

- **The create-time PO Fee fallback.** PO create still does `poFee: dto.poFee ?? total ?? 0`, with
  helper text *"Defaults to the PO items total when left blank"*. That is part (e) of
  [../vendors-agencies/gaps.md → *Branch fix/das-fixes…*](../vendors-agencies/gaps.md#branch-fixdas-fixes--one-closed-status-for-invoiced-and-cancelled-pos-and-the-legacy-remap)
  (*"should PO fee default to the line-item total?"*), and it **stays open**. "Manual entries will be
  made" points toward no default, but he was answering the total question, not the create fallback.
- **Whether a discount over 100% floors the total at 0** — the second half of PR #488 part (b).
- **Whether the permit PO bills the permit cost to the customer** —
  [../dispatch/travel-permits-playbook.md](../dispatch/travel-permits-playbook.md):202, still open there.
- **Whether a `CLOSED` PO may be newly attached to a permit** — second half of (c) of the das-fixes
  entry, unchanged.
