# Intent — TCG-32

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `TCG-32` |
| Title | DAS Pre-Checklist: permit and plan row colours should follow status |
| Type | UAT remediation |
| Branch | `fixes/TCG-15-OCT` (shared with the other 2026-10-15 tickets) |
| Captured on | `2026-10-16` |
| Captured by | Claude Opus 5.5, session for devmohsinakram |

## 2. Ticket text (as given)

**Problem.** In DAS > Pre-Checklist > Permits and Plan Status, the row colours do not follow the permit
or plan status. Approved rows show green. Open, Application Submitted and Cancelled all show the same
amber. The UAT example asks for a Draft colour, but permits and plans on this list never have a Draft
status, so that part cannot be built.

**What should happen.** Each status should have its own clear colour, with no status falling to grey by
accident. Other screens that use the same status colours (Permits & Plans, the DAS Legend) should be
checked after any change.

**Blocked / needs decision.** Status colours on these rows were tried on 2026-09-12 and removed on
purpose to match the DAS Legend. Lisette Anzaldo (with Liz Lopez) must decide: bring status colours
back, or show Open / Application Submitted / Cancelled differently inside the amber?

**Done when.** Rows show the colours agreed in the decision above. The DAS Legend matches the row
colours.

**Notes for developer.** Do not change the shared status badge used across the app. Add test IDs to
the rows. None exist today.

## 3. Business intent

UAT 2 (`vault/uat/register-2026-09-18.md:206`, NOT DONE). A dispatcher should read a permit or plan's
status from its Pre-Checklist row.

## 4. Where it went

Checked first whether it had been done: a local `fixes/TCG-32` branch existed with no commits, and its
stash held only local Windows env files — no TCG-32 work. Only the unblocked developer note (test IDs)
was built; the colours wait on Lisette Anzaldo (`spec.md` §12).
