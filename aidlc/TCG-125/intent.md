# Intent — TCG-125

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `TCG-125` |
| Title | Operator Load setup screen needs improving |
| Type | UAT remediation |
| Branch | `fixes/TCG-15-OCT` (shared with the other 2026-10-15 tickets) |
| Captured on | `2026-10-16` |
| Captured by | Claude Opus 5.5, session for devmohsinakram |

## 2. Ticket text (as given)

**Problem.** UAT 3 says: "Operator Load Configuration needs to be made better — discussion required."
The screen is Asset Management > Sub-Categories > Operator Load > Associated Field Assets. Today each
sub-category has one setup, but the client says Operator Load sometimes needs different setups (by job
type and yard).

**What should happen.** Small fixes that can be done now: the Always Included / Optional choice should
have its caption back; the detail screen should show a message when the list is empty, like the create
screen does; a save should not half-save and ask you to save again.

**Blocked / needs decision.** Brian Petros must decide if this setup should differ by job type and
yard. Wait for that before bigger changes (row order, loop checks, matching by ID).

**Done when.** The Always Included / Optional caption shows. An empty list shows a message. The
decision on job type and yard is recorded.

**Notes for developer.** Boom pay depends on this setup. Do not change what "Always Included" means
without checking the payroll rules first.

## 3. Business intent

UAT 3 (`vault/uat/register-2026-09-18.md:292`, NOT DONE). Make the Operator Load setup clearer and
safer to save, without changing what it means for boom pay.

## 4. Where it went

The caption and empty message were built (web only). The half-save fix was designed but not built —
the developer chose the safest scope (`spec.md` §12 Q2). Job type / yard waits on Brian Petros.
