# Intent — TCG-124

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `TCG-124` |
| Title | Assets: crane names and Upper/Lower meter fields are not consistent |
| Type | UAT remediation |
| Branch | `fixes/TCG-15-OCT` (shared with the other 2026-10-15 tickets) |
| Captured on | `2026-10-16` |
| Captured by | Claude Opus 5.5, session for devmohsinakram |

## 2. Ticket text (as given)

**Problem.** UAT 4 said "Crane names — Upper/Lower should be consistent." On the asset form, the
Odometer is partly saved under "lower" names, so "lower" means two different meters. Crane names in
the sample data also do not match: "Rt 9001" vs "RT", typos like "Truk" and "Hydralic", "Hydro" vs
"Hydraulic", and two 45 Ton cranes named "40 Ton". The same crane also shows a different name on
different screens.

**What should happen.** Odometer and Lower Meter should be clearly separate, with consistent names.
Crane names should be spelled correctly and match their tonnage. The same crane should show the same
name on every screen.

**Blocked / needs decision.** There is no naming rule for crane names and sub-categories. Product
must decide one. The real tonnage of cranes 4005 and 4006 must be checked with the yard before
changing them.

**Done when.** Typos (Truk, Hydralic) are fixed. Cranes 4005 / 4006 show the correct tonnage.
Odometer and Lower Meter save to separate, clearly named fields.

**Notes for developer.** The meter change needs a database migration. Also decide whether to remove
the old unused "Unit" table. Cranes imported from FCC show only their unit code, not a name. Decide
which to show. Full technical details are in the first comment (not available in this session).

## 3. Business intent

UAT 4 #25 (`vault/uat/register-2026-09-18.md:281`, NOT DONE). Meter fields and crane names should
mean one thing each and read the same everywhere.

## 4. Where it went

Only the two unblocked items were built — the meter separation and the two named typos — each the
narrowest way the developer chose (`spec.md` §12). Everything blocked on Product or the yard was left
untouched.
