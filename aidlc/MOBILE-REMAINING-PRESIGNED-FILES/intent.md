# Intent — MOBILE-REMAINING-PRESIGNED-FILES

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | None — requester confirmed; local planning identifier only |
| Title | Audit and plan the remaining mobile presigned file migration |
| Type | Audit and planning; implementation not requested |
| Status | Inception, 2026-11-03 |
| Epic / Sprint | NOT ON TICKET |
| Reporter | Requester in this conversation; personal name not established |
| Assignee | NOT ON TICKET |
| Captured on / by | 2026-11-03 / Codex |

## 2. Business intent

- Intent: identify every remaining mobile image/attachment stream and prepare a migration plan using AI-DLC and specialist agents.
- Who benefits: mobile users; specific business roles NOT ON TICKET.
- What is worse today: requester reports remaining legacy S3 streaming outside migrated ticket flows; audit must establish the actual callers.

## 3. Definition of done, as requested

> Go through all the mobile code and identify the places where we are still using old S3 streaming image / attachments approach.
>
> Use AI DLC and follow its steps to review and make plan. ask questions and run appropiate agents

Scope answers received on 2026-11-03:

> Presigned viewing/downloads; keep current uploads (Recommended)
>
> No ticket
>
> Include open/share in this follow-up

Acceptance criteria present: task and scope stated in this conversation; no external ticket or sprint entry. Build acceptance is proposed in spec.md, not represented as requester-authored text.

## 4. In scope

- Whole-mobile source audit, including ticketing, sales, profile, local/offline helpers and attachment APIs.
- Distinguish active streaming, compatibility fallbacks, incomplete presigned rendering, and upload-only surfaces.
- Plan presigned GET viewing/downloads, retaining API uploads.
- Include opening/sharing sales quotation attachments in the proposed implementation scope.
- Save findings, source provenance, contract/tenancy risks and vertical implementation candidates.

## 5. Out of scope

- Application implementation, commits, pushes or external ticket creation in this session.
- Direct-to-S3 uploads, data backfills, object moves, new incident viewer, unrelated web attachment migration.
- New tests: not requested.

## 6. Surfaces touched

| Surface | Now | Proposed implementation |
| --- | --- | --- |
| apps/api | read only | signed file metadata on authorized reads |
| apps/api/prisma | read only | no schema change expected |
| apps/web | read only | compatibility review of shared endpoint consumers |
| apps/mobile | read only | job artifacts, quotation open/share, JSA rendering repair |
| packages/shared | read only | reuse existing image shape; no new export expected |

## 7. Entities and business codes

Existing Attachment, JobTicket, Job, Quotation and artifact owners; no new entity or code prefix, no backfill. Preserve current route identities; derive business code/prefix only if implementation changes their handling. This plan does not mint codes.

## 8. Roles and permissions

NOT ON TICKET as a new role matrix. Plan within existing file visibility; inspect authorization before issuing signed links. Tenant scope must be verified, not assumed from the Prisma extension.

## 9. Designs and references

- Design handoff / Jira attachments: NOT ON TICKET.
- Related work: MOBILE-TICKET-PRESIGNED-IMAGES, TCG-241.
- Process: ../GUIDE.md §2, §4, §8, §10.
- Sources: ../../vault/INDEX.md; field-ops conflict stub; requester scope decision `2026-11-03-mobile-remaining-presigned-files-scope.md`.

## 10. Terms used

“Presigned approach” means signed GET viewing/downloads in this follow-up, as explicitly clarified. Existing multipart upload transport remains in scope only for compatibility review.

## 11. Numbers, thresholds and enumerated values

NOT ON TICKET — no new limits, TTL or performance thresholds requested. Preserve existing constraints unless a source or owner directs otherwise.

## 12. Capture completeness

- NOT ON TICKET: epic, sprint, assignee, business role matrix, design handoff, Jira attachments, new numeric thresholds.
- Product scope questions asked and answered: upload transport, ticket ID, quotation open/share.
- Current audit/plan deliverable is authorized. Proposed implementation requires a separate build request; spec and candidate units are not approval or evidence of implementation.
