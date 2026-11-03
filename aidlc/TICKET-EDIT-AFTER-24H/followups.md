# Open follow-ups — TICKET-EDIT-AFTER-24H

Recorded 2026-11-03 at the owner's request to close the merged Unit 1 age-cutoff work.
These items are **OPEN**, not fixed, waived, or accepted by the merge. The independent
`analysis.md` verdict remains historical evidence: do not ship as fully complete.
No external issue IDs were supplied or created. These local IDs preserve the work until
separate implementation tickets are assigned.

**Routing owner for F1–F4:** requesting developer, devmuazzam. Implementation/product owners
remain to be assigned; routing ownership does not imply a Payroll policy decision.

| ID | Status | Work and acceptance | Source / evidence |
| --- | --- | --- | --- |
| F1 | OPEN | Let the overview banner use deadline-aware editability. An elapsed APPROVED request must show Request approval without waiting for cron to rewrite its status. Preserve existing test IDs. | `analysis.md` finding 1; `apps/mobile/app/(field)/ticket/index.tsx:255-260`. Source inference; not reproduced on a device. |
| F2 | OPEN | Give the existing payroll void lock precedence over request state. A voided ticket with a live or pending request remains locked; server settlement guards stay intact. Do not infer a new mobile settlement contract. | `analysis.md` finding 2; `apps/mobile/data/ticket-editability.ts:119-133`. Inherited ordering; source inference, not a newly introduced regression. |
| F3 | OPEN | Select correction versus late-completion intro, reason placeholder and overview copy using the existing request kind/status. A SUBMITTED_EDIT must not ask why the worker is completing late. Preserve existing test IDs. | `analysis.md` finding 3; `apps/mobile/components/field/edit-request-sheet.tsx:113-122`, overview `ticket/index.tsx:292`. |
| F4 | OPEN | Run the configured-tenant/device demo: old COMPLETE ticket → request → approve → edit/save → payroll recalc → expiry/re-request, preserving saved values and COMPLETE status. Re-run affected existing gates after F1–F3 and obtain a new analyst verdict. | `units.md` Reviewable as; `implementation.md` evidence limits. Existing 116 passing tests do not establish this live flow. |

No new tests were requested at close. Use existing suites; obtain authorization before
adding test cases under the repository's standing rule.

## Separate product work

**Q1 / proposed Unit 2 remains OPEN** in `plan.md` §6: linked corrections versus reopening
finalized payroll/accounting records. It is outside this scoped Unit 1 close, and the
merge supplies no answer. Devmuazzam owns routing it to the Payroll/accounting policy
owner before Path A specification/execution. No finalized-record guards were removed.

## Release boundary

The four-file age-cutoff fix merged to client **staging** in PR #995 (`dbef9c1e5`);
client **main** did not contain `ea1e22d80` at close verification. Deployment was not
verified. Overlay PR #224 merged the handoff to overlay main; it did not fix F1–F4.
Closing the merged scope does not certify the whole original Unit 1 acceptance matrix.
