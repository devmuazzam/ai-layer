---
title: Field Operations App - FRD
source: confluence/TCG/Field Operations App - FRD
migrated: 2026-08-10
updated: 2026-06-16
status: unverified
conflicts_with: [product/frd-new-format-draft/INDEX.md, product/atom-mobile-app-user-stories/INDEX.md]
jira: []
topics: [field-ops-mobile, safety, escalation, deficiencies, jobs, time-tracking, signatures, documents-attachments]
entities: [tailboard-jsa, job, deficiency, field-ticket, employee, signature, attachment]
part_of: product/field-ops-frd/08-functional-requirements/INDEX.md
---
### FR-FOP-011 — Job Safety Analysis (JSA)

| Field | Detail |
| --- | --- |
| ID | FR-FOP-011 |
| Module | Safety |
| Title | Job Safety Analysis |
| Description | The Application shall support completion of Job Safety Analysis activities prior to the commencement of work activities. The purpose of JSA is to ensure employees acknowledge job-specific hazards, understand required controls, and confirm readiness to proceed. |
| Functional requirements | The Application shall support configurable JSA templates. The Application shall display JSA questions applicable to the assigned job. The Application shall support acknowledgement of JSA items, capturing comments, and photo attachments where applicable. The Application shall support electronic signatures where required. The Application shall support saving progress and displaying previously completed JSA information during ticket continuation. The Application shall support deficiency escalation when hazards cannot be mitigated. |
| Business rules | JSA completion shall occur prior to Start Work activities. Required JSA items shall prevent workflow progression until completed. JSA requirements shall be configurable. Escalated hazards shall follow deficiency escalation workflows. |
| Acceptance criteria | **AC-001** Given JSA is required, When the user accesses JSA, Then required JSA items shall be displayed. **AC-002** Given mandatory JSA items remain incomplete, When the user attempts progression, Then progression shall be prevented. **AC-003** Given unresolved hazards exist, When the user completes JSA, Then escalation workflows shall be initiated. |

---

