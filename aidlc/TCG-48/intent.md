# Intent — TCG-48

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `TCG-48` |
| Title | Quotation: Show a Congratulations popup after Mark as Won |
| Type | UAT remediation |
| Branch | `fixes/TCG-48` |
| Captured on | `2026-10-15` |
| Captured by | Claude Opus 5.5, session for devmohsinakram |

## 2. Ticket text (as given)

**Problem.** In Quotation, after Mark as Won, only a small message shows. UAT asked for a
Congratulations popup with Create Project and Add to a Project options. Both options already
exist in the convert popup (via the Create Project button in Quick Actions), but nothing
points the user to them.

**What should happen.**

- After a manual Mark as Won, show a Congratulations popup with the quote number, Create
  Project, Add to a Project, and a way to close it.
- Each button opens the existing convert popup with that option picked.
- Hide Add to a Project when it cannot be used (no customer or no open projects). If the
  quote already has a project, show only Convert to Job.
- The current Mark as Won steps stay the same. The popup comes after them.

**Blocked / needs decision (as the ticket stated it).** Only one sentence describes this
popup. Not decided: the exact wording, whether it shows after DocuSign signing too, and
whether it is on mobile too. The button names are also an open question with Ryan Adams /
Joe Schacatano.

**Done when.**

- After Mark as Won, the popup shows and both buttons open the right option.
- After closing the popup, the Create Project button still works.

## 3. Business intent

UAT 1 (`vault/uat/sessions/uat-session-1-internal.md:61`) asked that winning a quote lead the
user straight to the next step — creating a project or adding the quote to one. The options
exist but are unannounced; the popup is how the user finds them.

## 4. Where it went

The "blocked" list did not block the build. How each item was settled, and the two further
decisions taken (Mark as Signed included, toast dropped), are in `spec.md` §12. Scope:
web only; DocuSign-completed signing is out (no user on the page).
