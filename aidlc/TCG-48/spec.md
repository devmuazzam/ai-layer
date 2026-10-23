# Spec — TCG-48 Quotation: Congratulations popup after a manual Won

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `TCG-48` — "Quotation: Show a Congratulations popup after Mark as Won" |
| Elaborated on | `2026-10-15`, in a working session with devmohsinakram |
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

All decided 2026-10-15 by devmohsinakram (developer on the ticket), in session.

- **Q1 — Show after Mark as Signed too?** **Yes.** It is the same user-present, manual moment and ends in Won; UAT 1 says "when a quotation is won". **Status:** resolved.
- **Q2 — Toast as well as the popup?** **No** — the popup replaces the toast. **Status:** resolved.
- **Q3 — Customer name in the message?** **Yes.** **Status:** resolved.
- **Q4 — Show the open-project count on Add to a Project?** **Yes.** **Status:** resolved.
- **Q5 — Confetti?** **Yes, keep it.** **Status:** resolved.
- **Exact copy and button names** (ticket: open with Ryan Adams / Joe Schacatano) — not a blocker. Built with the UAT 1 names; a rename is a label change and test IDs do not depend on labels. **Status:** resolved for build; copy may change in review.

### Q6 — Won popup redesigned after merge, on branch `fixes/TCG-22-OCT-UAT` (PR #926 review, tcg-scrum, 2026-10-23)

- **Question:** Does the Won popup keep **Add to a Project**, with its open-project count, next to Create Project, as UAT 1 asked and REQ-03/04/05 build? Or is it now one **Convert to Project** step (Convert to Job when a project exists) with a **Later** button, no ✕, a star badge instead of trophy + ring pulse (confetti kept), and **Job site** and **Quote total** shown?
- **Options:** (A) keep TCG-48 as specified and revert the redesign; (B) adopt PR #926's redesign, which supersedes REQ-03, REQ-04, REQ-05, REQ-08, REQ-10 and Q4; (C) mixed. Name the parts kept.
- **Candidates:** `vault/uat/sessions/uat-session-1-internal.md:61` (`unverified`): "options to Create Project or Add to a Project". `vault/uat/register-2026-09-18.md:225` (`unverified`, NOT DONE). This section's Q3–Q5 (devmohsinakram, 2026-10-15). **Nothing is written for the redesign.** There is no 2026-10-22 session in `vault/uat/sessions/` and no `decisions/` note. `aidlc/processed.log:245` says only "UAT feedback 2026-10-22".
- **Note:** The relabels (Create Project → Convert to Project, "I'll do this later" → Later) fall under the "copy may change in review" line above. These changes do not: removing an option, dropping Q4's count, removing the ✕ (REQ-03), changing the animation (REQ-08) and dropping the REQ-10 test IDs `quotations-won-celebration-close` and `-add-to-project`. A grep of `qa-automation/e2e` on 2026-10-23 found no use of either ID. Job site and Quote total have no source; REQ-03 names only the quote number and the customer.
- **Blocked:** merging PR #926 commit `99365758b` as a change to TCG-48.
- **Owner:** whoever gave the 2026-10-22 UAT feedback (give their name and where they said it). Otherwise Ryan Adams / Joe Schacatano, the ticket's named copy owners. devmohsinakram decided Q4 and can confirm reversing it.
- **Status:** resolved — see [decisions/2026-10-23-pr-926-won-popup-craneguys-domain-full-money-as-built.md](../../vault/decisions/2026-10-23-pr-926-won-popup-craneguys-domain-full-money-as-built.md). Option (B), decided by Asad Amanullah on 2026-10-23 (`reference`; he did not name who approved the redesign). The redesign stands as built in `99365758b`, and `30798b9ca` makes Quote total the computed total (TCG-255). **Superseded:** REQ-03, REQ-04, REQ-05, the ring pulse in REQ-08, the REQ-10 test IDs `quotations-won-celebration-close` and `-add-to-project`, and Q4. **Still in force:** REQ-01, REQ-02, REQ-06, REQ-07, REQ-09, the rest of REQ-08 and REQ-10, Q1–Q3 and Q5.

## 13. Deliberately out of scope

- **DocuSign-completed signing** — the quote turns Won from a webhook with no user on the page; there is no moment to show a popup.
- **Mobile** — mobile has no Create Project / attach flow to point to (only `ConvertToJobModal`).
