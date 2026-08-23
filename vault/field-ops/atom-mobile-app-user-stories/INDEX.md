---
title: Atom Mobile Application ( User stories )
source: confluence/TCG/Atom Mobile Application ( User stories )
migrated: 2026-08-10
remigrated: 2026-08-13
confluence_version: 10
updated: 2026-08-11
status: unverified
conflicts_with: [field-ops/field-ops-frd/INDEX.md, field-ops/frd-new-format-draft/INDEX.md]
jira: []
topics: [field-ops-mobile, safety, authentication, dashboard, ticket-workflow, lunch-breaks, labor-payroll, compliance]
entities: [field-ticket, employee, lunch-record, wtl, labor-record, subsistence, signature, inspection]
parts:
  - 00-overview.md
  - 01-authentication-and-dashboard.md
  - 02-ticket-assignment-and-pre-trip.md
  - 03-work-execution-and-lunch.md
  - 04-completion-and-return.md
  - 05-compliance-labor-and-review.md
  - 06-safety-and-self-service.md
---

# Atom Mobile Application ( User stories ) — section index

> **Re-migrated 2026-08-13 from Confluence version 10 (page updated 2026-08-11).** The vault
> previously held version ~7 as of 2026-07-22. **The page roughly doubled.** The earlier split
> (6 parts, 20 stories, 5 EPICs) has been replaced by the 7 parts below (**22 stories, EPIC 1–17
> as labelled**). Old part filenames are gone; update any bookmark.

| Part | Covers | Stories |
| --- | --- | --- |
| [00-overview.md](00-overview.md) | Application summary and the end-to-end field workflow line | — |
| [01-authentication-and-dashboard.md](01-authentication-and-dashboard.md) | EPIC 1–2 — phone sign-in, vendor OTP, dashboard | US-1 … US-3 |
| [02-ticket-assignment-and-pre-trip.md](02-ticket-assignment-and-pre-trip.md) | EPIC 3–4 — accept/reject, ticket details, pre-trip inspection, left yard, travel, arrival, JSA | US-4 … US-10 |
| [03-work-execution-and-lunch.md](03-work-execution-and-lunch.md) | **US-11 ×2** — work execution/boom time, and lunch/WTL | US-11, US-11 |
| [04-completion-and-return.md](04-completion-and-return.md) | "PIC 10", EPIC 11–12 — final signature, return travel, arrive yard, post-trip | US-13 … US-16 |
| [05-compliance-labor-and-review.md](05-compliance-labor-and-review.md) | EPIC 13–15 — compliance attestation, labor & unit details, review & complete | US-17 … US-19 |
| [06-safety-and-self-service.md](06-safety-and-self-service.md) | EPIC 16–17 — incident reporting, SOS, profile & certifications | US-20 … US-22 |

## Defects in the source page, reproduced not fixed

- **Two sections are both numbered `US-11`** — Work Execution, and Lunch & WTL. Citing "US-11"
  is therefore ambiguous within this single document.
- **`US-12` does not exist.** Numbering runs US-11, US-11, US-13.
- **`PIC 10 — Job Completion`** is an apparent typo for `EPIC 10`.
- **EPIC 5 through EPIC 9 do not exist.** Numbering runs EPIC 4 → (unlabelled US-11 sections) →
  PIC 10 → EPIC 11.

## What changed in version 10, and why it matters

The additions are concentrated exactly where this app meets payroll:

- **Explicit lunch thresholds** — Lunch 1/2/3/4 at 5 / 10.5 / 16.5 / 22 hours, with a
  notification one hour before each. This is new, and **two of the four values contradict the
  payroll WTL charts.** See the conflict box in
  [03-work-execution-and-lunch.md](03-work-execution-and-lunch.md).
- **Four lunches, not three** — which now contradicts `BRS-LUNCH-002` in [../../brs.md](../../brs.md),
  marked ✓ Confirmed at three.
- **Build-Up, Breakdown and Boom Time** as separately timestamped activities.
- **Compliance attestation** including Long Sub / Short Sub subsistence selection.
- **Labor & Unit Details** carrying WTL and Craft Modifier / Boom Pay into labor.

## Still one of three competing documents

This does **not** resolve the field-ops conflict. Read
[../field-ops-mobile-INDEX.md](../field-ops-mobile-INDEX.md) first. This page is now the
**newest and largest** of the three, which changes the "newest wins" and "largest wins"
heuristics but still leaves them pointing at different documents — and it still carries no
document ID or version, while the two FRDs do.
