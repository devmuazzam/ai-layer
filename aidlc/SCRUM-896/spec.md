# Spec — SCRUM-896 Update Plan Navigation and Replace Delete with Archive

> Path C ticket. No full elaborator pass. This file exists so the product
> questions raised by the PR review have a durable §12 home (vault `gaps.md` is
> retired for new ticket questions).

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-896` (Task, epic `SCRUM-232`, reported by Aiman Farooq / QA, 2026-08-17) |
| Path | C |
| Branch | `scrum-896` |
| PR | — |
| Shipped behaviour | Plan save/submit redirects to `/projects/{id}/plans/{planId}`; row + bulk delete removed from the project Plans tab |
| Not shipped | Archive. `Plan` has no `archivedAt`; there is no archive/unarchive API or archived filter |
| Still present | Delete on the plan edit page; `DELETE /plans/:planId` — still a hard delete |
| Open questions raised by this ticket | 2 — §12 Q1, Q2 |

## 12. Open questions — the stop-and-ask list

### Q1 — Does "delete is replaced by archive across the app" apply to Plans, and is a Plan archivable?

- **Question:** Should `Plan` become archivable (soft `archivedAt` + archive/unarchive + archived filter, as on the other 17 models), and once it is, should hard delete be removed from **all** plan surfaces including the edit page and `DELETE /plans/:planId` — or do plans keep hard delete and only the listing entry point goes?
- **Why it cannot be answered from what is written:** The clause "across the app we are replacing delete functionality with archive" appears only on `SCRUM-896`, and a QA ticket is not a named product-owner decision. No vault file specifies plan deletion or plan archiving at all. `product/project-module/04-create-and-approve-lift-plans.md` (`status: unverified`) covers the plan lifecycle and is silent on both. The vault's only affirmative delete text points the other way for sibling modules — `product/vendors.md` ("Each vendor row has an Edit (pencil) and Delete (trash) icon"), `product/tool-and-rigging.md` ("edit/delete action"). The nearest archive text, `product/customer.md` items 11 and 15, is customer-specific and replaces the **edit** button, not delete. 17 Prisma models carry `archivedAt` and `Plan` does not, but code is not a requirement source.
- **Blocked:** Nothing for the Path C UI ship. Blocked for: a `Plan.archivedAt` migration, an archive/unarchive endpoint, an archived quick filter, removing the edit-page delete, and closing `DELETE /plans/:planId`.
- **Candidates:**
  - `SCRUM-896` — QA ticket; only source for the app-wide archive claim
  - `vault/gaps.md#feedback-punch-lists-are-not-scoped-to-the-module-they-are-filed-under` — names 896's intent, states the ticket is the only source, `Status: open`
  - `product/customer.md` items 11, 15 — archived filter "(across the app)"; archive replaces **edit** for customers
  - `product/vendors.md`, `product/tool-and-rigging.md` — specify delete icons on index pages
  - `product/project-module/04-create-and-approve-lift-plans.md` — plan lifecycle, silent on delete and archive
- **Owner:** product team (named product owner — not QA)
- **Workaround, if any:** The branch removes only the listing's row + bulk delete, as the ticket asks. Plans remain hard-deletable from the edit page and the API. Labelled a workaround until Q1 is answered — the ticket's stated goal (delete replaced by archive) is **not** met by this change.
- **Answer (2026-08-20, Fouzan Shakil):** Yes — archive replaces delete **app-wide**, using the existing `archivedAt` pattern the other 17 models already carry. `Plan` is in scope and must become archivable. **Still open and deliberately not answered:** whether `DELETE /plans/:planId` and sibling delete endpoints are withdrawn, whether an admin hard-delete escape hatch exists, whether sub-records (notes, contacts, attachments, custom-attribute rows) count as entities under this, and retention/permissions/backfill. See the note's *What this does not settle*.
- **Status:** resolved — see `.ai/vault/decisions/2026-08-20-archive-instead-of-delete-app-wide.md`

### Q2 — Is "after save, go to the detail page" a plan-only change or an app-wide navigation convention?

- **Question:** Should every module's save/update land on the record's detail page, or is this scoped to plans only?
- **Why it cannot be answered from what is written:** `SCRUM-896` states it for plans and says nothing about other modules. No vault file specifies post-save navigation for any module. `decisions/2026-08-12-plan-comments-page-scope.md` (`status: verified`) confirms the destination is the plan detail view at `/projects/{id}/plans/{id}` but says nothing about redirects.
- **Blocked:** Nothing. Plans behave as the ticket asks. Blocked only for applying the same change to other modules without a further ticket.
- **Candidates:**
  - `SCRUM-896` — only source, plans only
  - `decisions/2026-08-12-plan-comments-page-scope.md` — confirms the destination route and its name
- **Owner:** product team
- **Answer (2026-08-20, Fouzan Shakil):** App-wide convention, not plan-only — **after editing an entity, go to that entity's detail page; after creating one, go to the listing (table) page.** The shipped plan update behaviour is confirmed correct, and plan create already lands on the listing (checked 2026-08-20), so **no code change falls out of Q2 for this ticket**. **Still open:** cancel and error paths, modal/nested/wizard creates, "save and add another", whether mobile follows the same rule, and the sequencing of any retro-fit to other modules.
- **Status:** resolved — see `.ai/vault/decisions/2026-08-20-post-save-navigation-convention.md`

## 13. What this deliberately does not specify

- Whether `Plan` gains `archivedAt` and an archive API — see Q1
- Whether the edit-page delete and `DELETE /plans/:planId` are withdrawn — see Q1
- Post-save navigation for any module other than plans — see Q2
