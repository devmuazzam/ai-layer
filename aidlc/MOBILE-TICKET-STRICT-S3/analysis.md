# Independent analysis — MOBILE-TICKET-STRICT-S3 U1

Recorded by the coordinator from tcg-analyst's final report, 2026-11-05.

**Verdict: DO NOT SHIP — requester acceptance criterion 4 remains unfulfilled.**
Implementation is complete and ready for normal review; no actionable source defect
survived the independent analyst's refutation pass. No waiver exists.

## Analyst's independent verification

- **VERIFIED:** `git diff --check` passed.
- **VERIFIED:** `node /tmp/ticket-u1-executor-smoke.cjs` passed with exit 0. It checks generic
  flat-key rejection, valid structured ticket reads, SUPER_ADMIN row-owner tenant handling,
  preserved non-ticket access, and incident list/upload rejection of flat/foreign keys.
  No network or data writes occurred.
- **VERIFIED:** `rg` searches enumerated upload/cover/delete/signing/streaming/mobile callers.
  No production `ticketAttachments.download`, `openAttachmentFile`, or scoped
  `attachments/:attachmentId/download` remains.
- **VERIFIED:** comparison against `git show HEAD:<file>` found no production file crossing
  from <=1,000 to >1,000 lines. Asset service was already large (1,043 to 1,053); field
  controller shrank (1,051 to 1,026).
- **VERIFIED:** processed.log contains the Path A entry. Schema/manifests/lockfile unchanged.

## Gate evidence inspected by analyst

| Evidence | Result | Limit |
| --- | --- | --- |
| `/tmp/ticket-u1-executor-api-tests.log` | 11 existing suites / 158 tests pass | Fresh final API selection; two prerequisite tasks cached |
| `/tmp/ticket-u1-executor-api-build.log` | API build passes | Fresh API task; two prerequisites cached |
| `/tmp/ticket-u1-executor-lint.log` | 5 projects pass, 0 errors | Three tasks cached |
| `/tmp/ticket-mobile-test-final.log` | 4 suites / 67 tests pass | Earlier run; no later mobile source edit |
| `/tmp/ticket-api-test-verified.log` | 313 suites / 3,663 tests pass, one payroll failure | Before final isolated generic/incident edits |
| `/tmp/ticket-api-payroll-baseline.log` | Same payroll failure on clean HEAD snapshot | One baseline suite: 15 pass, one fails |
| `/tmp/ticket-typecheck-verified.log` | Web passes; mobile TS2345 at unchanged app-version.test.ts:71,83 | Earlier run; mobile unchanged since |

Analyst inspected these logs rather than rerunning broad green checks. They do not establish
a clean origin/main baseline, full final-state API/typecheck pass, full workspace build or
live device/S3 demo. AC4 remains blocking even though the failures are pre-existing.

## Requirements, decisions and ripple

**INFERRED from actual source:** all five requirements and spec D1–D6 are implemented.
The guard rejects absent configuration before deduplication/write. Images use two variants,
plain files one object, and hierarchy checks precede access. Scoped field streaming and
mobile streaming contracts are removed. Mobile refresh returns fresh rows and retries the
same attachment directly from S3 once; sharing sits outside expiry recovery.

All ten ripple groups in units.md were reviewed: signature/lunch, checklist, incidents,
Attach File/controller, job-progress/web, meter photos/web, generic attachments, mobile
sheet/helper/hook, mobile service/HTTP/mock, web generic fallback/saved mobile drafts.
Existing suites plus compiled smoke cover the changed behaviors; source review establishes
unchanged response/consumer compatibility. Contract and tenancy specialists independently
passed; see specialist-audits.md.

No unsourced structural choice or skipped G1–G5 guardrail found. New dispatcher/barrel export
traces to D2; no schema, dependency, auth rule, response field or persistent state is added.

## Refutations and maintainability

- Valid structured generic streaming is retained by explicit REQ-04/D5 for independent
  non-sheet consumers; strict key checks still apply. It is not the removed mobile fallback.
- TicketCode ownership compatibility is explicitly preserved by D6, separately from storage.
- Meter singleton covers are the independent non-ticket flow preserved by D4.
- No new 1,000-line crossing or must-fix thermo-nuclear/ponytail regression found.
- Existing gate failures do not become clean acceptance because they predate the change.

No new open question, source edit, commit, push, PR, merge or deployment was performed by the
analyst. Analyse is recorded in state.md; next is a clearly labeled pre-merge reflection.

**Least confidence:** real native Expo cache/share behavior and simultaneous thumbnail/open
refreshes are not proved by mocks. Future drift risk is another ticket entry point bypassing
the strict dispatcher (INFERRED).
