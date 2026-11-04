---
title: "Mobile presigned reads — viewers approved; employee files open only for the owner or an admin"
source: decision/requester — explicit answers in a Claude Code review session on PR #1018, 2026-11-04
decided: 2026-11-04
decided_by: >-
  The requester in this Claude Code session on 2026-11-04, who asked for the PR #1018
  review blocker to be fixed on branch fix/mobile-presigned-reads. Their name and
  organizational decision-making authority were not established here; no identity is
  inferred from Git configuration. This is requester direction, not a TCG client ruling.
status: reference
conflicts_with: []
related_tickets:
  - MOBILE-REMAINING-PRESIGNED-FILES
related_decisions:
  - 2026-11-03-mobile-remaining-presigned-files-scope.md
  - 2026-10-28-ticket-incident-video-plain-file-undecodable-image-rejected-no-viewer.md
tags: [module/field-ops, module/quotations, kind/decision, requirements]
---

# Viewer scope for PR #1018 and who may open employee files

## Why this note exists

The review of PR #1018 found commit 5d98ba184 built viewers that no record authorized.
`2026-11-03-mobile-remaining-presigned-files-scope.md` authorized planning only, and the
archived `presigned-read-spec.md` said implementation was not authorized. The review
verdict was "do not ship" under guardrail G1 until a decision was recorded.

## Decision 1 — the viewers are approved

Source: the requester's answer "Approve all viewers", 2026-11-04. The requester approved
all of the following as built in commit 5d98ba184:

- Mobile certifications screen: "View / Share Document" for the user's own latest
  certification document.
- Mobile job artifacts: open linked job permits, plans and POs through signed links.
- Mobile quotation attachment cards: open and share (quotation and general attachments).
- Mobile "Saved Job Walk Signatures" read-only card on the quotation attachments tab.
- Mobile ticket details: "Incident reports" list with open/preview of incident evidence.
- Mobile JSA step in read-only mode: view saved deficiency photos and signatures.

The incident viewer is a deliberate exception to Q8=A in
`MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` and to the 2026-10-28 decision "no viewer": the
requester approved it here, so that ticket's "viewer is a separate ticket" line no longer
blocks it. Which roles see the incident list is not narrowed: every field role that can
open ticket details sees it.

This does not adjudicate the field-ops source conflict recorded in
`field-ops/field-ops-mobile-INDEX.md` (FR-FOP-028 versus FR-FOP-032); the vault status of
those files is unchanged.

## Decision 2 — access rule for `GET /attachments/:id/links`

Source: the requester's answer "Restrict by owner type", 2026-11-04.

- Employee-owned attachments (`featureType` EMPLOYEE — certificates and renewals): signed
  links are given only to the employee the file belongs to, or to a user whose role is
  ADMIN or SUPER_ADMIN. Anyone else gets the same 404 as a missing file.
- Every other owner type keeps the tenant-wide read policy of
  `GET /attachments/:id/download`.
- "The employee the file belongs to" is resolved from the attachment's owner id, which may
  be the employee UUID, the employee code, the user UUID, or the legacy literal `me` with a
  matching uploader.

## Still open — not decided by this note

- Whether `GET /attachments/:id/download` should get the same employee-file rule. It is
  unchanged.
- Whether incident evidence and job-walk signatures need a role restriction. They are
  tenant-wide for now.
- The refusal to renew a certification when the profile has no linked employee, and the
  default attachment categories ('Quotation Attachment', 'Employee Attachment', 'Ticket
  Attachment' and similar), came from the upload-metadata task and were not covered by
  this decision.
