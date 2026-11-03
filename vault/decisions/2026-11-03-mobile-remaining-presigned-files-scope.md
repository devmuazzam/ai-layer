---
title: "Remaining mobile presigned file migration — planning scope"
source: decision/requester — explicit answers in this Codex conversation, 2026-11-03
decided: 2026-11-03
decided_by: >-
  The requester in this Codex session on 2026-11-03. Their personal name and
  organizational decision-making authority were not established; no identity is
  inferred from Git configuration. This records requester direction for planning,
  not a TCG client ruling or authorization to implement.
status: reference
superseded_by: decisions/2026-11-03-mobile-presigned-read-implementation.md
provenance_note: >-
  Planning-only and no-viewer exclusions are superseded by the requester implementation direction; retained GET-only and API-upload scope still applies. See decisions/2026-11-03-mobile-presigned-read-implementation.md
conflicts_with: []
related_tickets:
  - MOBILE-REMAINING-PRESIGNED-FILES
  - MOBILE-TICKET-PRESIGNED-IMAGES
related_decisions:
  - 2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md
  - 2026-10-28-ticket-incident-video-plain-file-undecodable-image-rejected-no-viewer.md
tags: [module/field-ops, module/quotations, kind/decision, requirements]
---

# Scope for the remaining mobile file migration plan

## Direction

Source: the requester's explicit answers in this Codex conversation, 2026-11-03,
paraphrased:

- Presigned viewing and downloads; keep current uploads.
- There is no external ticket.
- Include opening and sharing sales quotation attachments in the follow-up.

Plan the remaining mobile migration around presigned S3 GET links for viewing and
downloading. Keep the current API upload transport, including multipart uploads;
direct-to-S3 presigned PUT uploads are outside this plan. Include opening and
sharing sales quotation attachments in the proposed follow-up, even though the
current quotation cards do not expose those actions.

No external ticket was supplied. `MOBILE-REMAINING-PRESIGNED-FILES` is the local
planning identifier. The authorization is to audit and plan; implementation is
not authorized by these answers.

## Boundaries retained from the prior work

- No backfill or rewrite of existing image rows or S3 objects is proposed. The
  prior ticket's old-image fallback remains as recorded in
  `decisions/2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md`.
- A new mobile incident viewer remains a separate ticket, as recorded by Q8=A in
  `MOBILE-TICKET-PRESIGNED-IMAGES/spec.md` and
  `decisions/2026-10-28-ticket-incident-video-plain-file-undecodable-image-rejected-no-viewer.md`.

## Effect on the vault

No existing vault content, status, conflict, or tooling is changed. This note
records the scope answers for the new planning record; it does not reopen the
closed mobile ticket-image migration or adjudicate the field-ops source conflict.
