# Intent — TCG-85

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `TCG-85` |
| Title | Quotation print: remove "Other" section and add Terms & Conditions |
| Type | UAT remediation |
| Branch | `fixes/TCG-15-OCT` (shared with the other 2026-10-15 tickets) |
| Captured on | `2026-10-15` |
| Captured by | Claude Opus 5.5, session for devmohsinakram |

## 2. Ticket text (as given)

**Problem.** UAT asked to remove the Other section from the quotation print view and add Terms
and Conditions. But there are two quote documents: the browser print view and the PDF. The
customer only ever gets the PDF, and the PDF already has the Terms and Conditions. The "Other"
section holds crane and equipment details, so removing it drops real data. Also, the Terms text
was copied from one customer's quote, nobody approved it, and it lists rates that do not match
what we charge.

**What should happen.** Fix now: when there is nothing in "Other", the print view should not show
the heading or "No additional information." (the PDF already does this). The rest waits on the
decision below.

**Blocked / needs decision.** Joe Schacatano / Ryan Adams (and Umair Khan, who was asked to compare
with FCC) must answer: should "Other" be removed from the PDF too, or only the print view? Who
owns and approves the Terms and Conditions text?

**Done when.** An empty "Other" section no longer shows on the print view. The decisions above are
written down before any Terms change.

**Notes for developer.** If Terms are added to the print view, use the same text source as the
PDF. Do not copy it a second time. Best done with TCG-28, TCG-37 and TCG-81, which change the same
documents.

## 3. Business intent

UAT 4 #14 (`vault/uat/register-2026-09-18.md:260`, NOT DONE). The browser print view should not
carry an empty section, and should carry the same Terms the customer sees on the PDF.

## 4. Where it went

The "fix now" item was built as asked. The developer also chose to show Terms on the print view
before the ticket's Terms questions were answered — `spec.md` §12. Scope: the browser print view.
The PDF is unchanged; its Terms text moved into `@tcg/shared` so both read one copy.
