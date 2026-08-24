# Spec — SCRUM-899 Make Tool and Rigging Non-Editable in Jobs

> Path C ticket. No full elaborator pass. This file exists so the product-scope
> question raised by PR #379 review has a durable §12 home (vault `gaps.md` is
> retired for new ticket questions).

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-899` |
| Path | C |
| Branch | `scrum-899` |
| PR | [#379](https://github.com/TheCraneGuys/craneguys-platform/pull/379) |
| Shipped behaviour | Job Details → Tool/Rigging is view-only (no Edit / add / qty / remove) |
| Yard / Dylan | Job-tool mutation APIs left open — yard dashboard still needs them |
| Open questions raised by this ticket | 1 — §12 Q1 |

## 12. Open questions — the stop-and-ask list

### Q1 — Job Tool/Rigging read-only scope

- **Question:** Is Tool/Rigging on Job Details read-only in **all** cases (no add / edit qty / remove on the job), or only for **quote-inherited** tools — with job-specific additions still allowed later?
- **Why it cannot be answered from what is written:** Jira SCRUM-899 (QA, Aiman Farooq) says the section should be read-only, but a QA ticket is not a named product-owner decision. `projects-jobs/project-module/02-view-manage-job-details.md` (`status: unverified`) lists Tool/Rigging among tabs that “save independently,” which presupposes editable in-tab state. `assets/tool-and-rigging.md` (`status: unverified`) covers quote → job flow-through and yard-dashboard adds, not Job Details editability. `vault/gaps.md` already flagged SCRUM-899’s punch-list intent as unwritten product intent (13-august-QA, unmigrated).
- **Blocked:** Nothing for the Path C UI ship (PR #379 implements the ticket literally). Blocked for treating the behaviour as settled product law, for reconciling `02-view-manage-job-details.md`, and for deleting dead edit-mode UI branches.
- **Candidates:**
  - `SCRUM-899` — QA ticket; only affirmative “read-only” source
  - `projects-jobs/project-module/02-view-manage-job-details.md` — implies editable tab state
  - `assets/tool-and-rigging.md` — silent on Job Details editability; Story 5 allows Dylan to add tools from the yard dashboard
  - `vault/gaps.md` punch-list note (13-august-QA) — names the intent, says ticket is only source
- **Owner:** product team (named product owner — not QA)
- **Workaround, if any:** PR #379 ships full Job Details read-only as the ticket asks; Yard/Dylan mutation paths unchanged. Labelled workaround until Q1 is answered.
- **Status:** open

## 13. What this deliberately does not specify

- Whether job-specific tool additions return later — see Q1
- API-level lock of `POST/PATCH/DELETE /jobs/:id/tools*` — out of scope while Yard/Dylan need those endpoints
- Dead-code cleanup of `isEditing` branches in `ToolRiggingRow` / `ToolRiggingSelector` — premature until Q1 settles
