---
title: Field operations mobile app — conflict stub
source: generated/conflict-stub
migrated: 2026-08-10
updated: 2026-08-10
status: unverified
kind: conflict-stub
gap: gaps.md#field-operations-mobile-app
conflicts_with: [product/field-ops-frd/INDEX.md, product/frd-new-format-draft/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [requirements-spec, lunch-breaks, authentication, ticket-workflow, time-tracking, signatures, compliance, notifications]
entities: [field-ticket, lunch-record, vendor, signature]
---

# Field operations mobile app — three competing documents

**None of these is verified. Do not answer from one of them alone.**

Three documents describe the same mobile application for field crews. They were
never reconciled. Cite all three and say they disagree, or point the reader here.

| Candidate | Size | Updated | Doc ID / status | What it uniquely covers |
| --- | --- | --- | --- | --- |
| [frd-new-format-draft/INDEX.md](frd-new-format-draft/INDEX.md) | 55.6 KB, 9 parts | 2026-06-09 | **FR-TCG-FOP-001 v1.1 — REVIEWED** | 40 numbered requirements (FR-FOP-001…040). Only document with time rounding, auto-save, audit trail, live ticket visibility, signature fraud prevention, and a non-functional requirements section. Carries `_(Updated v1.1)_` / `_(New v1.1)_` revision markers. |
| [field-ops-frd/INDEX.md](field-ops-frd/INDEX.md) | 46.2 KB, 12 parts | 2026-06-16 | **FR-TCG-FOP-002 v2.0 — DRAFT** | 30 numbered requirements (FR-FOP-001…030). Only document with role definitions, an operational workflow overview, a requirements summary, workflow-affecting business rules, and ticket draft management. |
| [atom-mobile-app-user-stories/INDEX.md](atom-mobile-app-user-stories/INDEX.md) | 15.0 KB, 6 parts | 2026-07-22 | none | 20 user stories in 5 EPICs, written as user stories with acceptance criteria rather than numbered requirements. Only document with the end-to-end step flow written as a single line, and with temporary/vendor OTP access. |

## Why this cannot be resolved by any rule

Every ordering heuristic gives a different winner:

- **Newest** → the 15 KB user-story page
- **Largest** → FR-TCG-FOP-001
- **Only one marked REVIEWED** → FR-TCG-FOP-001
- **Highest version number** → FR-TCG-FOP-002

The two FRDs carry **different document IDs**, which suggests they are two separate
deliverables rather than two drafts of one. The newer document (FOP-002 v2.0) is the
one marked DRAFT; the older (FOP-001 v1.1) is the one marked REVIEWED.

Both FRDs number their requirements `FR-FOP-NNN` from 001, so **the same identifier
means different things in each document** — `FR-FOP-013` is "Lunch Monitoring" in
FOP-002 and "Lunch Timer and Alerts" in FOP-001. Always cite the document as well as
the requirement id.

See the full entry in [`gaps.md`](../gaps.md) → *Field operations mobile app*.

## What this app feeds

_Added 2026-08-13._ This app is the **capture side** of payroll. Lunch events
(`FR-FOP-013`/`014`/`015`), labor detail (`FR-FOP-023`), and start/end work
(`FR-FOP-012`/`016`) become the labor entries the payroll module prices.

Before specifying anything in that area, read [payroll/INDEX.md](../payroll/INDEX.md) — a
separate document set, migrated 2026-08-13 from a OneDrive drop, which carries the union rules
those captures have to satisfy. It is not one of the three candidates above and does not resolve
the conflict between them; it is a **fourth source that none of them cites**.

Two specific disagreements are already visible, both recorded in
[`gaps.md`](../gaps.md) → *Field-ops lunch capture vs payroll WTL*:

- the BRS lists **three** lunch thresholds and marks that ✓ Confirmed; payroll models **four**
- the BRS marks lunch threshold **values** as missing documentation; payroll has them
