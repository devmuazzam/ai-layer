# Intent — TCG-104

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `TCG-104` |
| Title | Send Quotation: warn when the quote has no items (source unknown) |
| Type | Enhancement (source unknown) |
| Branch | `fixes/TCG-15-OCT` (shared with the other 2026-10-15 tickets) |
| Captured on | `2026-10-16` |
| Captured by | Claude Opus 5.5, session for devmohsinakram |

## 2. Ticket text (as given)

**Problem.** A quote with no equipment, services or tools can still be sent. The PDF just says "No
equipment or services have been added". But we do not know who asked for a warning; no UAT session
contains this request.

**What should happen.** If confirmed: before sending, show a warning like "This quote has no
equipment, services or tools. Send anyway?" with Cancel and Send anyway. A quote with only tools is not
empty and should not show the warning. Warn only. Do not block sending.

## 3. Business intent

Stop an empty quote reaching a customer by accident, without ever preventing a deliberate send.

## 4. Where it went

Built as written, as a developer decision — the "if confirmed" was never confirmed by a named person
(`spec.md` §12). No UAT register row exists for it.
