---
title: "Ticket attachment category labels: the developer's label table, and the nearest existing label for the four items it does not name (mapping to confirm) — decision"
source: decision/Syed Haris (CodingCops) — label table in MOBILE-TICKET-PRESIGNED-IMAGES intent.md §4 (2026-10-27) and answer Q4 = C in spec §12 (2026-10-28)
decided: 2026-10-28
decided_by: >-
  Syed Haris (CodingCops), the requester of MOBILE-TICKET-PRESIGNED-IMAGES and the named
  owner of Q4. He chose the label table on 2026-10-27 while the plan was reviewed
  (intent.md §4 and §11, carried into spec REQ-04 and REQ-05). He answered Q4 = C in a live
  Claude Code session on 2026-10-28. The item-by-item mapping under Q4 was derived from
  option C when the Answer line was written. Haris did not state it item by item, and it is
  to be confirmed at review. tcg-scrum did not see the session and records from intent.md
  and spec.md. This is a developer and requester decision. It binds this build. It is not a
  TCG client ruling, so the status is reference.
status: reference
resolves:
  - MOBILE-TICKET-PRESIGNED-IMAGES/spec.md#q4
conflicts_with: []
related_tickets:
  - MOBILE-TICKET-PRESIGNED-IMAGES
related_decisions:
  - 2026-10-28-ticket-images-640-px-preview-32-px-blur-original-on-zoom-additive-fields.md
tags: [module/field-ops, kind/decision, signatures, wtl, ticket-workflow]
---

# Ticket attachment category labels

## Decision

**The label table** (Haris, 2026-10-27). Source: `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/intent.md`
§4 and §11, and `spec.md` REQ-04 and REQ-05. The strings are exact.

| Item | `featureType` | `category` |
| --- | --- | --- |
| Customer signature, step sig1 | `TICKET_SIGNATURE` | `Customer First Signature` |
| Customer signature, step sig2 | `TICKET_SIGNATURE` | `Customer Last Signature` |
| Compliance signature | `TICKET_SIGNATURE` | `Compliance Signature` |
| Identity photo, step sig1 | `TICKET_SIGNATURE` | `Customer First Identity Photo` |
| Identity photo, step sig2 | `TICKET_SIGNATURE` | `Customer Last Identity Photo` |
| Lunch WTL signature 1 to 4 | `TICKET_SIGNATURE` | `Lunch WTL 1` to `Lunch WTL 4` |
| Checklist photo, pre-trip / post-trip / JSA | `CHECKLIST` | `Pre-Trip Checklist` / `Post-Trip Checklist` / `JSA Checklist` |
| Incident evidence | `TICKET_INCIDENT` | `Incident Evidence` |

**Q4 = C** (Haris, 2026-10-28). Source: `spec.md` §12 Q4. The four linked items that the
table does not name reuse the nearest existing label. Option A (leave `category` empty) was
not chosen.

The mapping below was **derived from option C and is to be confirmed at review**. Haris did
not state it item by item:

- Incident customer signature: `Incident Evidence`
- Checklist signature: the checklist's own label (`Pre-Trip Checklist`, `Post-Trip Checklist`
  or `JSA Checklist`)
- Lunch WTL identity photo: its `Lunch WTL n` label, where n = `breakIndex + 1`
- Identity photo or signature on the `compliance` step: `Compliance Signature`

## Why

The intent records the table as the developer's choice. The Q4 Answer line gives no reason
beyond the choice of option C. Option C reuses label strings that already exist in the
table. Option B would have added four new strings.

## What this does not decide

- **How many lunch thresholds the product has.** The `Lunch WTL 1` to `4` labels follow the
  code's four-slot cap (`WTL_TRIGGERS`, `MAX_LUNCH_BREAK_INDEX = 3`). They settle nothing
  about the product. That conflict stays open and nobody has adjudicated it:
  `payroll/gaps.md#field-ops-lunch-capture-vs-payroll-wtl` and the stub
  `field-ops/field-ops-mobile-INDEX.md`. The candidates are FR-TCG-FOP-001
  (`field-ops/frd-new-format-draft/`), FR-TCG-FOP-002 (`field-ops/field-ops-frd/`) and the
  Atom user stories (`field-ops/atom-mobile-app-user-stories/`). None is verified. If
  product decides on three thresholds, the label set changes (spec REQ-05).
- A `category` for `JOB_TICKET` documents. The table names none, and documents keep their
  current value (spec REQ-04, an assumption).

## Effect on the vault

- No vault file changes status. This note takes no side in the field-ops lunch conflict and
  edits no frontmatter.
- `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` §12 Q4: `Status:` set to
  `resolved — see decisions/2026-10-28-ticket-attachment-category-labels.md`, with the
  "mapping to confirm at review" flag kept. **Done.**
