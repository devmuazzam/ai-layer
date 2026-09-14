---
title: Quotation Mark as Won — requires comment or dialog attachment — decision
source: decision/CodingCops build session
decided: 2026-09-14
decided_by: >-
  Product direction stated 2026-09-14 in a Cursor implementation session for the
  quotation detail Mark as Won flow. Not a TCG client-side product-owner
  sign-off. Recorded `status: reference` — binding on the CodingCops build, open
  to being overruled by TCG.
status: reference
conflicts_with: []
resolves: []
jira: []
tags: [module/quotations, kind/decision]
---

# Quotation Mark as Won: comment or dialog attachment required

## Decision

Manual **Mark as Won** (web dialog + `POST /quotations/:quoteNo/mark-won`) requires
**at least one of**:

1. A non-empty free-text **comment** (persisted as `Quotation.wonComments`), or
2. A file **uploaded in that Mark as Won dialog** (stored as a quotation attachment
   with category `WON_EVIDENCE`; attachment ids are sent on the mark-won request).

Existing quotation attachments do **not** satisfy the rule. Confirm Won stays
disabled until one of the two is present. The API rejects requests that provide
neither.

## Scope

- **In scope:** web Confirm Won dialog; API body validation and persistence.
- **Out of scope:** mobile Mark Won evidence UI; DocuSign / signature completion
  paths that set status to `WON` without going through `markWon`.

## Why

Symmetric to Mark as Lost (reason + comments), so a manual win leaves an auditable
comment or evidence file rather than a bare status flip.

## What this does not settle

- Whether won comments / evidence should be shown on the quotation detail page.
- Mobile Mark Won UX for the same gate.
