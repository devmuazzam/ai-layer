# Intent — TCG-102

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `TCG-102` |
| Title | Quotation print: review Billing Type on the customer quote |
| Type | UAT remediation |
| Branch | `fixes/TCG-15-OCT` (shared with the other 2026-10-15 tickets) |
| Captured on | `2026-10-15` |
| Captured by | Claude Opus 5.5, session for devmohsinakram |

## 2. Ticket text (as given)

**Problem.** UAT asked to "review the Billing Type field" in the quotation print view. Billing
Type (Rental / Parts) is the first line under Project Details on both the print view and the
Quotation PDF. It is an internal label. It is often empty and then prints a dash. It can also
hold values the dropdown does not offer.

**What should happen.** Unspecified until decided. Either remove it from the customer quote,
or keep it and make it required, limited to fixed values, and hidden when empty. Whatever is
decided should apply to both the print view and the PDF.

**Done when.**

- The print view and the PDF both follow the decision.
- If kept, an empty Billing Type does not print a dash.

## 3. Business intent

UAT 3 asked for the field to be reviewed
(`vault/uat/register-2026-09-18.md:289`, NOT DONE — "the review never happened and no decision
exists"). The customer-facing quote should not show a meaningless dash for an internal label.

## 4. Where it went

The ticket left the behaviour undecided. The developer chose the narrowest option — keep the
row, hide it when blank, change nothing else. That decision and what it leaves open are in
`spec.md` §12. Scope: the web print view and the API Quotation PDF; the quotation form and the
stored value are unchanged.
