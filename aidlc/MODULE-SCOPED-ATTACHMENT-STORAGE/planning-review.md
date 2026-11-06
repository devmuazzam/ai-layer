# Planning review — MODULE-SCOPED-ATTACHMENT-STORAGE

2026-11-06 · Path A inception · planning only; no implementation verdict.

## Result

Source/contract inventory and independent ownership review support the deterministic
new-write design. The requester resolved Q1 by excluding historical-file handling and
retirement of existing availability. No migration, historical-access cutoff or generic-prefix
deletion is included. The current
request asks for analysis and planning; no unit may be executed solely because it appears
in units.md.

## Roles and artifacts

- tcg-scrum researched the root/module indexes and conflict stubs. No general storage
  hierarchy requirement exists in the unverified product sources; the current requester
  supplies the new technical direction. Existing quotation/job-walk compatibility and
  employee access decisions remain relevant. The subsequent explicit scope answer is recorded
  in decisions/2026-11-06-module-scoped-attachment-storage.md, without inferred identity.
- tcg-contract-tracer completed route, field, shared-type and wrapper passes across API,
  web and mobile, plus direct S3/email/public/background lifecycle consumers. See
  code-review.md. The report does not confuse generic API endpoints with flat S3 paths.
- tcg-prisma-guardian mapped all 21 feature types and owner/code relationships, privileged
  contexts, shared physical keys and direct key stores. See ownership-audit.md.
- tcg-elaborator reconciled spec.md to six sourced requirements and a resolved Q1;
  historical migration/retirement requirements were removed, not silently marked delivered.
- tcg-decomposer's three proposed vertical new-write slices are in units.md. No conditional
  historical transition/retirement stage remains in this ticket.

Construction executor, implementation analyst and post-shipment reflector do not run in
this planning-only request. The independent ownership review above is a planning review,
not a claim that application behavior or data has been tested.

## Findings that changed the plan

1. Changing the generic upload controller alone would miss generated PROJECT/JOB signed
   copies. The inventory covers all three remaining buildKey call sites.
2. Storage owner UUID must be resolved separately from existing featureId metadata. PO
   invoice status hooks, job mutability checks, lists, notes and notifications still use
   feature-dependent codes/aliases. No blanket metadata rewrite is proposed.
3. Independent review refuted an initial parentless job-walk design: quotationId is
   required by schema and create resolves a required quoteNo. The flat fallback and
   `unknown-quotation` sentinel are defensive debt, not a new workflow source. Final spec
   requires the real quotation UUID and rejects inconsistent ownership before writing.
4. PR #1049's confirmed P2 means changed key-validation errors must be traced through
   persistence order. Upload preflight, create compensation, explicit deletion and
   best-effort post-save replacement cleanup have distinct contracts. See spec REQ-05
   and the per-unit caller/error ledger requirement.
5. A separate future prefix-retirement project would need a manifest beyond Attachment.fileName: the signing
   master, legacy JobAttachment fields, duplicate physical-key references and discovered
   external/JSON stores would need classification. Their values/counts are not known; that
   historical work is excluded from the current plan and is not a prerequisite to new writes.

## Independent ownership verdict and limits

PASS for the deterministic new-write design after the required-quotation correction.
The initial guardian review checked the ownership/tenancy/cleanup sections against source, including
tenant/SUPER_ADMIN checks, all feature families, independent signed destinations, preflight/
compensation and explicit G2 fences. No remaining dangerous ownership design was found in
that reviewed scope. The clarified scope removes historical migration/retirement rather
than authorizing it. Q1 is resolved; no implementation or data destruction is authorized.

After the scope answer, the guardian rechecked the revised spec: existing non-ticket
reads/deletes retain current behavior, no historical scan/reconciliation/quarantine or G2
prerequisite is imposed on new-write work, and prior strict ticket behavior is retained.
Final scope-adjusted planning verdict: PASS; no unanswered scope question remains.

Verification here consists of source searches, schema/DTO/caller inspection, artifact
coverage checks and whitespace checks. Current baseline application is `fa83fe40f`.
Runtime/gates/DB/S3 counts/external-reference inventory are NOT RUN for this ticket.
Earlier ticket test and emulator results are historical and cannot certify this work.
No new repository tests, dependencies, schema, tooling or application source were added.
