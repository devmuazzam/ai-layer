# Spec — TCG-48 Quotation: Congratulations popup after a manual Won

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `TCG-48` — "Quotation: Show a Congratulations popup after Mark as Won" |
| Elaborated on | `2026-10-15`, in a working session with Asad |
| Product source | `.ai/vault/uat/sessions/uat-session-1-internal.md:61` — "When a quotation is won, a popup should automatically appear with a **Congratulations** message and options to **Create Project** or **Add to a Project**." Also `.ai/vault/uat/register-2026-09-18.md:225` (NOT DONE) |
| Code read at | `fixes/TCG-48` @ `857caf850` |

The ticket listed four "blocked / needs decision" items. None blocks the build — see §12.

## 1. Requirements

| Req | Requirement | Source |
| --- | --- | --- |
| REQ-01 | After a successful manual **Mark as Won** (`QuotationSalesActions`), a Congratulations popup opens. The existing Mark as Won dialog and mutation are unchanged; the popup follows them | ticket; UAT 1 |
| REQ-02 | After a successful manual **Mark as Signed** (`SignatureStatusPanel`), the same popup opens | §12 Q1 |
| REQ-03 | The popup shows the quote number and the customer name, a primary **Create Project** option and an **Add to a Project** option, and a way to close it ("I'll do this later" + ✕) that names Quick Actions as where to do this later | ticket; §12 Q3 |
| REQ-04 | Each option opens the existing convert popup with that option already picked — Create Project in `new` mode, Add to a Project in `existing` (attach) mode | ticket |
| REQ-05 | **Add to a Project** is hidden when the quote has no customer, or the customer has no open projects (same rule and hook — `useOpenProjectsTotal` — as the convert popup's own attach toggle). When shown, it states the open-project count | ticket; §12 Q4 |
| REQ-06 | If the quote already has a linked project, the popup offers only **Convert to Job** (opens `ConvertToJobModal`) | ticket |
| REQ-07 | When the popup shows, the success toast ("… marked as Won" / "Quotation marked as signed") is not shown | §12 Q2 |
| REQ-08 | Opening animation: trophy pop + ring pulse + one short confetti burst (~1 s), CSS only, no new dependency, none under `prefers-reduced-motion`. Colours from the theme tokens, so dark mode follows | §12 Q5 |
| REQ-09 | After closing the popup, the Quick Actions Create Project button still works | ticket "Done when" |
| REQ-10 | New controls carry `data-testid`s (`quotations-won-celebration-*`) | `contexts/web.md` → Test IDs |

## 12. Open questions

All decided 2026-10-15 by Asad (developer on the ticket), in session.

- **Q1 — Show after Mark as Signed too?** **Yes.** It is the same user-present, manual moment and ends in Won; UAT 1 says "when a quotation is won". **Status:** resolved.
- **Q2 — Toast as well as the popup?** **No** — the popup replaces the toast. **Status:** resolved.
- **Q3 — Customer name in the message?** **Yes.** **Status:** resolved.
- **Q4 — Show the open-project count on Add to a Project?** **Yes.** **Status:** resolved.
- **Q5 — Confetti?** **Yes, keep it.** **Status:** resolved.
- **Exact copy and button names** (ticket: open with Ryan Adams / Joe Schacatano) — not a blocker. Built with the UAT 1 names; a rename is a label change and test IDs do not depend on labels. **Status:** resolved for build; copy may change in review.

## 13. Deliberately out of scope

- **DocuSign-completed signing** — the quote turns Won from a webhook with no user on the page; there is no moment to show a popup.
- **Mobile** — mobile has no Create Project / attach flow to point to (only `ConvertToJobModal`).
