# Intent — MOBILE-REMAINING-PRESIGNED-FILES

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | None — requester confirmed; local identifier only |
| Title | Complete mobile presigned file reads and consistent attachment metadata |
| Type | Path A continuation: explicitly requested saved-file viewing/open/share plus existing transport parity |
| Status | Implementation authorized, 2026-11-03 |
| Epic / Sprint / Assignee | NOT ON TICKET |
| Reporter | Requester in this conversation; personal identity not established |
| Captured on / by | 2026-11-03 / Codex |

## 2. Business intent

Every mobile surface uploading an image/document must save consistent Attachment ownership/type/category and let authorized users retrieve saved files through S3 presigned GET URLs. Quotation and job-walk files were still missing the read migration after the metadata-only change. Complete the remaining work rather than treating metadata consistency as completion of the whole migration.

## 3. Definition of done, as requested

Original request: “Go through all the mobile code and identify the places where we are still using old S3 streaming image / attachments approach.” Use AI-DLC, ask questions and run appropriate agents.

Explicit answers received:

- “Presigned viewing/downloads; keep current uploads (Recommended)”.
- “No ticket”.
- “Include open/share in this follow-up”.
- Every mobile upload must use attachments with the resource UUID in feature_id and appropriate feature_type/category following patterns.md.

Latest requester direction, after the assistant confirmed that the metadata-only delivery did not implement remaining presigned reads:

> add this missing work in plan and update it as per AI DLC and perform all phases of AI DLC and implement it

This authorizes implementation. It supersedes the earlier planning-only and metadata-only scope restrictions. The requester specifically raised saved certification documents, job-walk signatures and incident-file viewing; those read surfaces are included in the completeness audit and delivery. Existing lifecycle/access rules remain the boundary; this request adds no new business workflow or access grant.

## 4. In scope

- Preserve completed metadata normalization (code commit 1d439ae58): UUID owner, correct feature type/category, tenant-safe compatible reads.
- Signed GET opening/sharing of saved files in BOTH quotation cards; preserve wizard staging/local preview and current upload/delete operations.
- Signed GET opening/sharing of ticket-linked permits, plans and purchase-order files.
- Saved certification-document opening and saved operator/foreman job-walk signature viewing/opening using signed links.
- Repair saved JSA image/signature rendering using existing covers.
- Verify and complete incident evidence/signature viewing with existing presigned response metadata and existing incident UI; reuse rather than duplicate a viewer.
- Whole-mobile read/upload audit, contract tracing, tenant review, existing validation, analysis and reflection.

## 5. Out of scope

Direct-to-S3 PUT uploads, data backfills/object moves, schema migrations, new dependencies, new test cases, unrelated web blob conversion, quotation lifecycle or incident reporting redesign. Keep API multipart uploads. Commit/push/PR/merge/deployment of this continuation are not requested by the latest instruction.

## 6. Surfaces touched

API signing/access boundaries and mobile file consumers. Web/shared callers are traced for compatibility when a response changes; no unrelated web UI work. No schema change expected.

## 7. Entities and business codes

Existing Attachment, Employee, Quotation, JobWalkReport, JobTicket and linked job-document owners. Stored feature_id is the resource UUID; route codes remain presentation identities. Incident evidence retains ticket UUID plus incidentReportId. Existing legacy aliases remain readable without rewriting rows.

## 8. Roles and permissions

Existing authenticated feature access only. Authenticate the signed-link request and explicitly verify attachment tenant before signing server-held keys, preserving existing generic download access and feature-specific list visibility; no new role matrix or access expansion. No bearer token accompanies S3 requests.

## 9. Designs and references

No design handoff or external ticket. Existing mobile cards/file opener/AttachmentImage establish the implementation vocabulary. Historical audit and archived presigned drafts remain evidence, not current scope. Vault conflicts in field-ops/quotation workflows are not adjudicated by this transport/read work.

## 10. Terms used

“Presigned approach” means API-authorized, transient signed GET links for viewing/opening/downloading/sharing, while API multipart uploads continue.

## 11. Numbers, thresholds and enumerated values

No new limits, TTLs or performance thresholds specified. Reuse existing signer configuration and MIME/size controls.

## 12. Capture completeness

No unanswered product scope question. Requester authorization above resolves implementation, quotation opening and formerly deferred saved-file readers. Technical endpoint/response/reuse choices are recorded in spec.md §11b and reviewed by guardian/tracer. Runtime/device/S3 verification must be reported separately from static checks.
