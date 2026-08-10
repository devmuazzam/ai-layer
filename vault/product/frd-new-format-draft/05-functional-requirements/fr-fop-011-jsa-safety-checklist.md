---
title: FRD - [New Format - Draft]
source: confluence/TCG/FRD - [New Format - Draft]
migrated: 2026-08-10
updated: 2026-06-09
status: unverified
conflicts_with: [product/field-ops-frd/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, safety, time-tracking, inspections, signatures, job-sites]
entities: [tailboard-jsa, field-ticket, job, job-site, signature]
part_of: product/frd-new-format-draft/05-functional-requirements/INDEX.md
---
### FR-FOP-011 — JSA / Safety Checklist

| Field | Detail |
| --- | --- |
| ID | FR-FOP-011 |
| Title | JSA / Safety Checklist |
| Workflow position | Previous: User arrives at job site. Current: User completes JSA/safety checklist. Next: Start Work. |
| Description | The Application must support digital JSA/safety checklist completion before work begins. Start Work must not be available until this step is satisfied. |
| Functional requirements | Provide JSA/safety checklist before Start Work. Require mandatory safety confirmations. Support signatures or acknowledgements where required. Associate JSA with ticket, job, user, and timestamp. Allow placeholder confirmation if JSA remains paper-based temporarily. |
| Business rules | Start Work is not available until required JSA/safety requirements are completed. Future JSA format must be configurable. |
| Acceptance criteria | User can complete required JSA step. Start Work is enabled only after required safety step is satisfied. JSA record is attached to ticket. |
| Priority | Must have |

---

