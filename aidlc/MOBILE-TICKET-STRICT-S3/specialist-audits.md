# Specialist audits — MOBILE-TICKET-STRICT-S3 U1

Recorded by the lifecycle coordinator from the named role agents' reports on 2026-11-05.
These are agent audit findings, not a human review or a waiver of AC4.

## tcg-contract-tracer — inception and final construction

All four passes ran: route strings, changed fields, shared types, service/hook wrappers.

- **VERIFIED by tracer:** Removed field-ticket streaming route, mobile `download` and
  `openAttachmentFile` have no remaining production callers. One production caller consumes
  the Promise-returning refresh hook; the sheet awaits fresh rows and handles thumbnail
  refresh rejection.
- **VERIFIED by tracer:** All five guard upload callers supply image/plain-file config.
  Web generic upload types exclude ticket feature types; mobile generic upload callers use
  EMPLOYEE or QUOTATION.
- Inception found incident plain-file presigning and generic ticket read routes missing
  strict validation. Elaborator amended spec/ripple and decomposer amended U1 before
  executor acceptance.
- **VERIFIED by final tracer:** Generic ticket links/download validate before presign/stream;
  both incident plain-file link paths validate; incident covers compare report ticket UUID.
  Obsolete D5 comment removed. Shared response fields remain unchanged.
- **INFERRED by tracer:** No current consumer break or flat ticket read bypass remains in
  traced production paths. Valid structured generic streaming/web fallback and historical
  draft URI header handling match the explicit spec boundary; the mobile sheet uses S3 only.

## tcg-prisma-guardian — inception and final construction

- **VERIFIED by guardian:** Attachment, JobTicket and TicketSignature stay tenant-allowlisted;
  no schema, migration, raw-query or Prisma extension change.
- **VERIFIED by guardian:** Config is checked before deduplication and uses resolved ticket
  UUID; generic upload rejects ticket feature types before flat storage.
- **VERIFIED by final guardian:** Generic/shared key validation compares supplied row-owner
  tenant, preserving SUPER_ADMIN behavior. Field usecase retains its explicit tenant/ticket
  resolver; incident file/image links also compare resolved/report ticket UUID.
- **INFERRED by guardian:** No blocking isolation regression or alternate flat ticket
  upload/read/delete path remains in examined flows.

Neither specialist edited source or ran tests. Commands enumerating consumers are recorded
in spec.md §11a. Executor gates and independent analyst review provide separate evidence.
