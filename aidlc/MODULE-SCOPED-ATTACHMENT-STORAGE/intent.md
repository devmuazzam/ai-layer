# Intent — MODULE-SCOPED-ATTACHMENT-STORAGE

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `MODULE-SCOPED-ATTACHMENT-STORAGE` — local identifier; external issue NOT ON TICKET |
| Title | Plan remaining legacy tenant attachment storage retirement with module-specific S3 folders |
| Type | Task — AI-DLC analysis and planning only in this request |
| Status | Inception, not approved for implementation |
| Epic | NOT ON TICKET |
| Sprint | NOT ON TICKET |
| Reporter | Requester in this conversation; personal identity NOT ON TICKET |
| Assignee | NOT ON TICKET |
| Captured on | 2026-11-06 |
| Captured by | Workspace coordinator |

## 2. Business intent

- Intent: Plan elimination of remaining application dependencies on the generic tenant
  attachment prefix before its future deletion. The requester asks for module-specific
  S3 paths. The underlying crane-rental business reason is NOT ON TICKET.
- Who benefits: Current attachment consumers across modules; a new role policy is NOT ON TICKET.
- What is worse today: Generic flat storage still accepts non-ticket writes; deleting the
  prefix can break document access across mobile/web and server-generated documents.
  This is code-audit context, not a product source.

## 3. Definition of done, as the ticket states it

> This has been merged, next plan to fix all remaining places that uses legacy tenants attachments path with S3 folder path URLs specific to that module. Analyze the code review and then plan it using AI DLC

Earlier context:

> we need to delete this folder in near future, so what is the other places in mobile app that still uses that generic folder path and needs to be fixed?

Scope clarification, 2026-11-06:

> No need to handle historical files or retire their availability.

The current plan covers new uploads/generated files only. Existing files and their access
remain unchanged. Historical migration, retirement and physical prefix deletion are excluded.

- Acceptance criteria present on the ticket: no formal list; the request explicitly asks
  for analysis and a plan, not implementation or deletion.
- Planning deliverable: source-backed inventory, reviewed spec and implementation-unit
  proposal, with unresolved data policy visible. Sprint readiness is not claimed.

## 4. In scope

- [ ] Audit every remaining generic S3 writer, reader, signer, byte access, replacement and delete.
- [ ] Trace API, mobile, web, background/signing/email and shared attachment-reference consumers.
- [ ] Specify canonical tenant/module/owner UUID storage paths and module ownership checks.
- [ ] Plan elimination of flat-path fallbacks and preserve existing response/auth contracts.
- [ ] Review PR #1049's post-save cleanup defect and apply its failure-order lesson to the plan.
- [ ] Preserve existing-file behavior while eliminating flat-prefix use by future uploads/generated files.
- [ ] Produce AI-DLC artifacts; stop before implementation.

## 5. Out of scope

- Application source changes, new endpoints, dependency installation or schema changes in this turn.
- Any S3/DB mutation, backfill execution, physical folder deletion or production rollout.
- Historical data inventory/migration or retirement of existing-file availability, explicitly excluded by the requester.
- Rewriting business permissions, ticket workflows, photo-variant formats or retention policy.
- New tests or test cases unless separately requested; existing suites/manual checks may be planned.

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| apps/api | planning yes | Generic upload dispatch, signed copies, validation and reference handling |
| apps/api/prisma | data audit yes; schema undecided | Attachment owner aliases and historical references; no DB execution |
| apps/web | audit yes | Existing upload/view/delete clients; no UI redesign |
| apps/mobile | audit yes | Certification and job-document consumers; quotation/job-walk historical references |
| packages/shared | audit yes | Contracts inspected; new shared shape NOT ON TICKET |

## 7. Entities and business codes

| Entity | Code field / prefix | This ticket… |
| --- | --- | --- |
| Attachment and its polymorphic owners | Derive concrete code fields/prefixes from schema/repositories in code audit | Maps owner identities and stored keys; no new business code |

- New entity introduced: no entity requested; implementation design must justify any schema change.
- New code prefix: no.
- Existing rows affected: no planned rewrite/migration; requester excludes historical handling and availability retirement.

## 8. Roles and permissions

- Roles permitted/excluded: NOT ON TICKET; preserve current endpoint policy as a design constraint.
- Tenant scope: maintain existing isolation; guardian must check row tenant and canonical owner,
  including privileged contexts, rather than assuming ambient Prisma scoping.

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | N/A — storage planning, no UI redesign |
| Jira attachments | NOT ON TICKET |
| Related ticket | MOBILE-TICKET-STRICT-S3, merged staging PR #1049; ticket-only scope |
| Code review | PR #1049 review pasted in prior turn; P2 post-save cleanup finding confirmed and fixed by `1e4e375b5`; review-cleanup-fix.md records reproduction |
| Existing repo docs | Prior closure/reflection and MOBILE-REMAINING-PRESIGNED-FILES artifacts |
| Vault area | Root INDEX, module indexes and applicable conflict stubs; precise storage direction comes from this requester |

## 10. Terms used that may not be defined

- “legacy tenants attachments path”: `tenants/{tenantId}/attachments/{fileName}` in the preceding conversation.
- “URLs specific to that module”: proposed interpretation is canonical module-specific object keys
  served through existing presigned URLs, not permanent/public URLs or replacement API route names.

## 11. Numbers, thresholds and enumerated values

| Value | Origin |
| --- | --- |
| Near-future deletion deadline | NOT ON TICKET — no calendar date given |
| Bucket, environments, grace/rollback period | NOT ON TICKET |
| Storage hierarchy and presigned URL expiry | AI implementation decisions to record; preserve current expiry policy |

## 12. Capture completeness

- NOT ON TICKET: external issue, epic, sprint, personal reporter, assignee, business rationale,
  new role policy, release date/environments and retention window.
- OPEN: none; requester resolved the historical scope question by excluding that work.
- Buildable without another product answer: technical scope is specified; implementation
  still requires a later instruction, and routine AI decisions remain reviewable.
- Next: spec and the three new-write units are reconciled to this scope. Remaining gate: developer review of spec §11b/§11c (`state.md`).
