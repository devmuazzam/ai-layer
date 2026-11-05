# Closure — MOBILE-TICKET-STRICT-S3

Closed 2026-11-06 at the developer's explicit request after merge into staging.

## Shipped scope and merge evidence

U1 is merged through [PR #1049](https://github.com/TheCraneGuys/craneguys-platform/pull/1049).
`git fetch origin` and `git log origin/staging` verified merge
`2e2ff31d91a231e3d8d4f8e1e756e6e6b0c90dbd` on 2026-11-06. The merge includes:

- `0232d577c`: strict structured ticket storage/access and mobile presigned-link recovery.
- `9b8afbf11`: explicit attachment-row owner validation.
- `1e4e375b5`: rejected stale-key cleanup cannot fail an already-saved replacement.

All planned units shipped; none was cut or left partly implemented. No application-main
merge or production deployment is inferred from the staging merge.

## Validation and exact limits

Final cleanup patch: API build/lint and 328 API suites / 3,845 tests passed; independent
Path B analyst and temporary before/after runtime reproduction passed. Six HTTP suites
initially failed only because the sandbox denied local port binding; the final suite ran
with local-port access and passed. See review-cleanup-fix.md for evidence and D7.

Earlier workspace lint/typecheck, API build and native Android attachment-flow results
remain in emulator-validation.md. Existing structured-key replacement cases were exercised
on the emulator; the later rejected stale-key fix was checked with the real guard and
mocked storage/repository, not a new emulator scenario. Office meter/job-progress UI checks
and a live SUPER_ADMIN demonstration remain unperformed. Closure does not convert those
limits into completed checks.

## Reflection, source findings and questions

reflection.md retains the historical construction result and superseding live-QA/post-merge
addenda. SD-1 (missed storage entry points), ED-1 (owner-field mapping) and ED-2 (post-save
cleanup failure) are recorded in the reflections index. Prevention proposals remain
proposals; no agent, skill, guide, template or other protected tooling was changed.

Reflection §3 disposition: the two superseded historical fallback directions were already
recorded by the requester decision at
`vault/decisions/2026-11-05-ticket-attachments-retire-flat-keys-and-api-streaming.md`.
No new vault content, unresolved conflict adjudication or unwritten human decision is
needed for this closeout. Spec §12 has no open ticket questions. Gaps opened: 0; closed: 0;
partially closed: 0. The broader field-ops source conflict remains outside this ticket.

## Separate follow-ups

This ticket removes legacy ticket fallbacks; most ticket subgroup uploads were already
structured before it. It does not retire the generic `tenants/{tenantId}/attachments/`
folder across the application, migrate existing rows/objects, or authorize deletion.

The subsequent read-only mobile audit identified remaining dependencies: certification
upload/view; linked permit/plan/purchase-order documents displayed in ticket details;
historical quotation attachments; and historical job-walk signatures. New quotation and
dedicated job-walk signature uploads are already structured. Backend signed quotation
copies attached to projects/jobs and the generic job-walk fallback also still write to the
generic folder. A separate storage/DB audit and scoped migration or explicit retirement
decision are needed before folder removal. No historical-row counts or data migration are
claimed here, and no follow-up issue number was supplied or invented.

## Walkthrough and ledger

The complete merged changed-file list has no pinned walkthrough URL/sidebar/form/payroll/
seed/environment surface match. Appendix B contains no matching attachment defect row.
The walkthrough is unchanged. Only the ticket row's `pr` cell in processed.log is changed
to `#1049`; its earlier notes remain historical.

## Proposal queue and publication

Before the preceding recorded close (HOLDOVER-YARD-GATE, 2026-11-05), the index has 33 rows
still marked proposed: branch-ops (2), contract-drift (1), contradicted-source (1),
duplicated-logic (1), env-lesson (2), gate-illusion (4), ignored-spec-edge (2),
layer-violation (1), missing-requirement (6), open-built-anyway (2), over-broad-condition (1),
over-built (1), pattern-drift (2), phase-skipped (1), stale-reference (2), stale-ui-state (3),
unbounded-scan (1). Counted from dated table rows with final status `proposed` and date
strictly before 2026-11-05. No existing proposal status was changed.

The closeout is committed on the matching overlay task branch and published to overlay
main as the shared team memory. The application checkout remains on staging; no source
changes or application push are part of this closeout. Existing stashes are preserved.
