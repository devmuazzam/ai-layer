# Intent — TCG-35

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `TCG-35` |
| Title | Quotation Resources: "Final Amount" shows different numbers in different places |
| Type | UAT remediation |
| Branch | `fixes/TCG-15-OCT` (shared with the other 2026-10-15 tickets) |
| Captured on | `2026-10-16` |
| Captured by | Claude Opus 5.5, session for devmohsinakram |

## 2. Ticket text (as given)

**Problem.** UAT asked to remove the "Amount Total" in the Quotation > Resources tooltip. There is no
field with that name. The real problem: "Final Amount" means different numbers. The tooltip shows it
without surcharge, but the saved Final Amount includes surcharge. The tooltip also shows After
Adjustment and Final Amount with the same number every time.

**What should happen.** "Final Amount" should mean one number everywhere: create/edit, detail, the
saved value and the printed quote. The tooltip should not show the same number twice. The Amount column
should stay as it is today.

**Blocked / needs decision.** Fouzan Shakil to answer: should the tooltip row be renamed (e.g. "After
adjustments"), or match the saved Final Amount? Melissa McNutt to answer: should a row show surcharge
money at all? Do not just delete the tooltip total before these are answered.

**Done when.** Hovering over a row's amount shows no repeated number. "Final Amount" shows the same
number on every screen. The Amount column and totals are unchanged.

**Notes for developer.** The QA test cases for this tooltip are out of date. Fix them in the same change.

## 3. Business intent

UAT 1 (`vault/uat/register-2026-09-18.md:211`, NOT DONE). One unambiguous meaning for a row's total.

## 4. Where it went

The developer unblocked both questions from the recorded decisions (`spec.md` §12) and changed only the
tooltip; the QA docs were deliberately left for later.
