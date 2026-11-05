# Intent — MOBILE-TICKET-STRICT-S3

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | MOBILE-TICKET-STRICT-S3 — local work identifier; external Jira id NOT ON TICKET |
| Title | Remove Legacy Ticket Attachment Fallbacks & Enforce Strict S3 Presigned Hierarchy |
| Type | Task |
| Status | Re-entering full AI-DLC before accepting provisional implementation |
| Epic | NOT ON TICKET |
| Sprint | NOT ON TICKET |
| Reporter | Requesting developer in the current Codex conversation; human name NOT ON TICKET |
| Assignee | NOT ON TICKET |
| Captured on | 2026-11-05 |
| Captured by | Codex, using the developer's request verbatim for acceptance criteria |

## 2. Business intent

- Intent: retire historical attachment compatibility and enforce the existing direct S3
  presigned ticket-file architecture.
- Who benefits (role): mobile field crew; maintainers of the ticket attachment flow.
- What is worse today without it: legacy flat upload/read/delete branches and API byte
  streaming remain reachable; expired mobile URLs fall back to API streaming.

## 3. Definition of done, as the ticket states it

> 1. No ticket upload can ever generate or save to `tenants/{tenantId}/attachments/{uuid}{ext}`.
> 2. Ticket image/document reads and deletions strictly operate on the structured `job-tickets/{ticketId}/...` hierarchy.
> 3. Mobile ticket attachment view/download flows interact directly with AWS S3 via presigned URLs and never stream payload bytes through the API server.
> 4. Existing test suites (`pnpm api:test`, `pnpm lint`, `pnpm typecheck`) pass cleanly.

- Acceptance criteria present on the ticket: yes, supplied directly by the developer.
- Additional lifecycle direction, verbatim: "We need to plan and implement this using AI DLC life cycle
  all agents should run in each stage of AI DLC".

## 4. In scope

- Remove `TicketAttachmentGuardService.storeFlatObject`; reject `storeUpload` without
  `image` or `plainFile`; update existing guard tests relying on flat storage.
- Remove `TICKET_IMAGE_ORIGINAL_KEY` legacy detection and the legacy `toTicketCover` branch.
  Ticket images always use original/preview WebP variants and delete both objects.
- Remove or deprecate `TicketAttachmentsService.download` and the matching field-ticket
  controller streaming route; downloads rely on `url` or `image.originalUrl`.
- Remove mobile service and sheet API-streaming fallback. On failed expired links, refresh
  attachment metadata and open the fresh presigned S3 URL.
- Trace and fix consumers/siblings that these shared helper changes reach in the same task.
- Run every stage through its AI-DLC role agent, including specialist contract/tenancy checks.

## 5. Out of scope

- Database backfills/data rewrites: the requester explicitly no longer wants historical
  pre-migration compatibility; no backfill requested.
- New dependency, schema, permission or payroll behavior: NOT ON TICKET.
- Commit, publish, open PR, merge or deploy: NOT ON TICKET. Implementation remains reviewable
  and uncommitted unless the developer asks otherwise.
- New test files/cases: not requested. Update affected existing cases and run existing suites.

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| apps/api | yes | Ticket storage helpers, guard, attachment usecase, controller and reached callers |
| apps/api/prisma | no | No schema/data change requested |
| apps/web | no planned source edit | Trace shared helper/endpoint impact on web responses |
| apps/mobile | yes | Direct presigned download, fresh-link retry, service interface and mocks |
| packages/shared | no planned edit | Existing EntityImageCover reused |

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| Attachment | N/A — UUID attachment identity | reads/writes/deletes existing metadata shape |
| JobTicket | NOT ON TICKET — derive code details from schema/service if needed | uses resolved UUID in the S3 hierarchy |

- New entity introduced: no.
- New code prefix introduced: no.
- Existing rows affected by backfill/data migration: no.

## 8. Roles and permissions

- Roles that can perform this: NOT ON TICKET — retain existing ticket ownership and authorization.
- Roles explicitly excluded: NOT ON TICKET — no permission change requested.
- Tenant scope: retain existing per-tenant isolation; structured paths include tenant identity.

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | N/A — storage/access cleanup, existing sheet UI |
| Jira attachments | NOT ON TICKET |
| Related tickets | MOBILE-TICKET-PRESIGNED-IMAGES (migration, closed); current request explicitly retires its legacy fallbacks |
| Existing repo docs | Original state/spec/units in `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/`; read large files by section |
| Vault area | field-ops indexes/conflict stub; attachment decisions; technical requirements come from this explicit developer request |

## 10. Terms used that may not be defined

- S3 presigned link: developer identifies `url` and `image.originalUrl` as direct AWS S3 file links.
- Legacy: historical ticket files stored before the structured hierarchy migration in late October 2026.

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| `original.webp`, `preview.webp` | Developer's Context, Images hierarchy |
| `tenants/{tenantId}/job-tickets/{ticketId}/attachments/{attachmentId}/…` | Developer's Context, Images hierarchy |
| `tenants/{tenantId}/job-tickets/{ticketId}/documents/{fileId}.{ext}` | Developer's Context, Documents hierarchy |
| Retry count/timeouts | NOT ON TICKET — implementation choice to record in spec §11b |

## 12. Capture completeness

- NOT ON TICKET: external Jira id, epic, sprint, requester human name, assignee, business-code
  details, exact permission roles, design/Jira attachments, retry count, new behavior outside scope.
- OPEN: none identified at capture; elaborator must independently check rather than treating
  provisional code as product intent.
- Buildable without a new product answer: yes for explicitly requested behavior; verify in elaboration.
- Provisional code already exists in the working tree from an earlier Path C pass. It has
  not been committed or accepted. The lifecycle must audit/reconcile it against the new spec.

Next: tcg-elaborator writes spec.md, then tcg-decomposer writes units.md, then executor,
analyst, reflector; tcg-scrum and contract/Prisma specialists run in their relevant roles.
