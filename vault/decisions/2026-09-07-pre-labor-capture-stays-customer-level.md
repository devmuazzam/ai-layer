---
title: Pre-Labor capture stays a customer-level singleton for this phase — decision
source: decision/product team (verbal), relayed by Jahanzaib Nadeem
decided: 2026-09-07
decided_by: >-
  Product team, verbally, in an undated discussion. Relayed to this session on 2026-09-07 by
  Jahanzaib Nadeem (jahanzaib.nadeem@codingcops.com, git `Jz-Nd`), the developer of branch
  `feat/customer-billing-pre-labor-forms`. **No individual Product person is named and no
  meeting, message or recording is citable.** This is a second-hand report of a verbal
  decision, recorded because the alternative is losing it — treat the attribution as weaker
  than every other note in this folder, and re-confirm with a named owner (Corrina Bustos or
  Melissa McNutt) before extending the pattern to anything beyond the branch it scopes.
status: verified
resolves: customers/gaps.md#pre-labor--labor-compliance-capture--one-customer-level-blob-or-one-record-per-jobquote
tags: [module/customers, module/payroll, kind/decision, certified-payroll, compliance]
---

## Decision

`Customer.preLaborData` **stays a single JSON blob on the Customer record** — one instance
per customer, overwritten on each save. Option (a) of the gap entry. Not one record per
job, not one per quote, and no customer-level default flag that pre-populates per-job
instances.

This is what branch `feat/customer-billing-pre-labor-forms` already builds. Product
reviewed the shape as built and chose to proceed with it.

## What this decision is, and what it is not

**It is a scoping decision for the current phase.** Product accepted a known and stated
limitation: a customer with more than one job retains only the **most recently saved**
project's compliance data. The seven required per-project fields on the blob —
`projectName`, `jobLocation`, `projectId`, `projectValue`, `estimatedStartDate`,
`estimatedEndDate`, `generalContractor` (`packages/shared/src/types/pre-labor-data.ts`,
`REQUIRED_STRING_FIELDS`) — are per-project fields living on a per-customer record, and
the overwrite is understood and accepted, not overlooked.

**It is not a finding that the vault sources were wrong.** Three independent sources say
labor compliance is job-scoped, and this decision contradicts none of them:

- [quotations/sales-operating-system/05-forms-and-records-matrix.md](../quotations/sales-operating-system/05-forms-and-records-matrix.md)
  §2 row 2 — *Labor Compliance & Payroll Requirement Form*, system of record **"FCC job
  record and compliance folder"**. Client-authored (Ryan Adams, 2026-08-06),
  `status: unverified`.
- [meetings/transcripts/2026-08-06-certified-payroll-labor-compliance.md](../meetings/transcripts/2026-08-06-certified-payroll-labor-compliance.md)
  — Corrina Bustos 18:46 and Melissa McNutt 18:55 rule out a single customer-level value
  outright: **"it's per job site … it's not all or nothing"**. Corrina's 17:59–18:28 ask is
  for a customer-level **default** that auto-marks jobs, not a customer-level **store**.
- The 2026-03-20 Kyle transcript, on certified payroll being keyed to the job.

Those sources remain `status: unverified`, uncontradicted, and the correct thing to build
against when the job-scoped model is designed. **The underlying job-vs-customer scope
question is deferred, not answered.**

## Why

Product weighed a known data-loss edge against shipping the branch and chose to ship. The
customers who need this capture at all are, at this stage, the ones with a single active
compliance project, so the overwrite is tolerable now and expensive to design around now.
The per-job model is a larger piece of work that belongs with the certified-payroll job
flag the payroll report depends on — and that flag does not exist yet either, so building
per-job storage ahead of it would be building half a mechanism.

The reasoning that should carry forward: **this is a deliberate phase-scoping trade, taken
with the contrary evidence on the table.** The next person to touch labor-compliance
capture should not read `Customer.preLaborData` as evidence that TCG wants compliance data
at the customer level. It is evidence that TCG accepted a customer-level store for one
build.

## What stays open

- The **certified-payroll job flag** the payroll report keys off (2026-08-06 transcript
  17:49 — *"if the job is not marked on there, that job won't even pop up on the report"*)
  is untouched by this decision. Tracked at
  [payroll/gaps.md → *Labor Compliance module — no vault coverage*](../payroll/gaps.md#labor-compliance-module--no-vault-coverage).
- Corrina's customer-level **auto-mark default** — a flag that pre-populates per-job
  records — is neither built nor decided. This decision does not implement it; a singleton
  data store is not a default.
- The migration `20260907120000_drop_customer_pre_quote_data` drops the `pre_quote_data`
  column that [customers/fcc-legacy-customer-data-model.md](../customers/fcc-legacy-customer-data-model.md)
  documents as the JSON compliance/onboarding blob matching the paper packet. **The drop
  was not put to Product and is not authorised by this decision.** Whether any tenant holds
  data in that column is still an unrun check, and the drop is irreversible.

## Effect on the vault

- **No winner/loser flip applies, and none was made.** This gap is not a conflict set
  between vault documents — the sources agree with each other and disagree with the build.
  Per [README.md](../README.md) → *How a gap gets closed*, steps 2 and 3 are written for
  conflict sets; only the decision note and the gaps-entry status change apply here.
- **No `status:`, `verified_because:`, `superseded_by:` or `conflicts_with:` field on any
  product file was changed.** In particular `05-forms-and-records-matrix.md` and the
  2026-08-06 transcript are **not** superseded — a phase-scoping decision cannot supersede
  a requirements source, and marking them superseded would erase the job-scoped evidence
  the next phase needs.
- [customers/gaps.md#pre-labor--labor-compliance-capture--one-customer-level-blob-or-one-record-per-jobquote](../customers/gaps.md#pre-labor--labor-compliance-capture--one-customer-level-blob-or-one-record-per-jobquote)
  → `Status: resolved` — **done**, in this pass.

## Effect on the branch

Sign-off of `feat/customer-billing-pre-labor-forms` is unblocked **on this question only**.
The `pre_quote_data` drop and the send-flow relationship are separate — the latter is
settled by [2026-09-07-pre-labor-pdf-and-structured-tabs-complementary.md](2026-09-07-pre-labor-pdf-and-structured-tabs-complementary.md).
