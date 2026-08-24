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
| Shipped behaviour | Plan save/submit → detail; plan create → listing; row/bulk archive + All/Archived filter on project Plans tab; edit-page hard-delete removed |
| Not shipped | Withdrawing `DELETE /plans/:planId` (still open per decision); admin hard-delete escape hatch |
| Still present | `DELETE /plans/:planId` API — hard delete, disposition undecided |
| Open questions raised by this ticket | 0 — Q1, Q2, Q3 all resolved 2026-08-20 (Fouzan Shakil); residual unsettled items listed in each decision note and in §13 |

## 12. Open questions — the stop-and-ask list

### Q1 — Does "delete is replaced by archive across the app" apply to Plans, and is a Plan archivable?

- **Question:** Should `Plan` become archivable (soft `archivedAt` + archive/unarchive + archived filter, as on the other 17 models), and once it is, should hard delete be removed from **all** plan surfaces including the edit page and `DELETE /plans/:planId` — or do plans keep hard delete and only the listing entry point goes?
- **Why it cannot be answered from what is written:** The clause "across the app we are replacing delete functionality with archive" appears only on `SCRUM-896`, and a QA ticket is not a named product-owner decision. No vault file specifies plan deletion or plan archiving at all. `projects-jobs/project-module/04-create-and-approve-lift-plans.md` (`status: unverified`) covers the plan lifecycle and is silent on both. The vault's only affirmative delete text points the other way for sibling modules — `vendors-agencies/vendors.md` ("Each vendor row has an Edit (pencil) and Delete (trash) icon"), `assets/tool-and-rigging.md` ("edit/delete action"). The nearest archive text, `customers/customer.md` items 11 and 15, is customer-specific and replaces the **edit** button, not delete. 17 Prisma models carry `archivedAt` and `Plan` does not, but code is not a requirement source.
- **Blocked:** Nothing for the Path C UI ship. Blocked for: a `Plan.archivedAt` migration, an archive/unarchive endpoint, an archived quick filter, removing the edit-page delete, and closing `DELETE /plans/:planId`.
- **Candidates:**
  - `SCRUM-896` — QA ticket; only source for the app-wide archive claim
  - `vault/gaps.md#feedback-punch-lists-are-not-scoped-to-the-module-they-are-filed-under` — names 896's intent, states the ticket is the only source, `Status: open`
  - `customers/customer.md` items 11, 15 — archived filter "(across the app)"; archive replaces **edit** for customers
  - `vendors-agencies/vendors.md`, `assets/tool-and-rigging.md` — specify delete icons on index pages
  - `projects-jobs/project-module/04-create-and-approve-lift-plans.md` — plan lifecycle, silent on delete and archive
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

### Q3 — Should the Planning Tracker ever show archived plans?

- **Question:** Once a plan is archived, should it stay permanently out of `GET /plans/tracker` (Planning Tracker columns, including "All Plans"), or should that endpoint gain `includeArchived` / `onlyArchived` (or an equivalent) so archived plans can be viewed or restored from that surface?
- **Why it cannot be answered from what is written:** Branch `scrum-896` added `archivedAt: null` to `plans.repository.ts` `findAllForTracker` so archived plans disappear from the tracker, with no filter parameter on `QueryPlanTrackerDto` / `GET /plans/tracker`. Neither `SCRUM-896`, §12 Q1/Q2, `decisions/2026-08-20-archive-instead-of-delete-app-wide.md`, nor `projects-jobs/project-module/04-create-and-approve-lift-plans.md` mentions the Planning Tracker and archive. The same hard exclude exists on permits (`permits.repository.ts` `findAllForTracker`), but code is not a requirement source.
- **Blocked:** Nothing for the project Plans-tab archive ship. Blocked for treating "tracker never shows archived plans" as settled product law, and for adding tracker archive filters / restore UX without a further decision or ticket.
- **Candidates:**
  - `SCRUM-896` / this PR — introduced the tracker exclude as a side effect of making Plan archivable
  - `decisions/2026-08-20-archive-instead-of-delete-app-wide.md` — settles archive-vs-delete; silent on trackers
  - `apps/api/src/service/permits/permits.repository.ts` `findAllForTracker` — same `archivedAt: null` hard exclude (code precedent only)
- **Owner:** product team (named product owner — not QA)
- **Workaround, if any:** Tracker hides archived plans; restore remains available from the project Plans tab (Archived filter). Labelled a workaround until Q3 is answered.
- **Answer (2026-08-20, Fouzan Shakil):** The Planning Tracker should have **filters which can be changed to show archived plans** — so the `archivedAt: null` exclude is a **default, not permanent product law**, and `GET /plans/tracker` must eventually accept a parameter that relaxes it. **Implementation is deferred to a follow-up ticket, explicitly not this PR**, so no code change falls out of Q3 for `SCRUM-896`; the shipped default is confirmed correct and its workaround label is discharged. **Still open and deliberately not answered:** the filter's UI shape, the API parameter shape (`includeArchived` vs `onlyArchived` vs tri-state), **whether the Permits tracker follows the same rule**, whether this generalises to other tracker/listing surfaces (unlike Q1 and Q2 this was *not* stated app-wide), whether restore is possible from the tracker, how an archived row renders and whether it counts toward status totals, and who may switch the filter on. See the note's *What this does not settle*.
- **Status:** resolved — see `.ai/vault/decisions/2026-08-20-planning-tracker-archived-filter.md`

## 13. What this deliberately does not specify

- Whether `DELETE /plans/:planId` is withdrawn — still open in `decisions/2026-08-20-archive-instead-of-delete-app-wide.md`
- Whether an admin hard-delete escape hatch exists — same note
- Post-save navigation for modules other than plans — convention is app-wide but retro-fit sequencing is open in `decisions/2026-08-20-post-save-navigation-convention.md`
- The Planning Tracker's archived filter — **decided** (it must have one, `decisions/2026-08-20-planning-tracker-archived-filter.md`) but **not built here**; the filter's UI and API shape, whether restore works from the tracker, and how an archived row renders are all still open
- Whether the **Permits** tracker gains the same filter — not decided; `permits.repository.ts` `findAllForTracker` carries the identical `archivedAt: null` exclude and was not part of Q3's answer
