# Spec — SCRUM-903 Clarify Job Completion Logic in Project Jobs

> Path B ticket. No full elaborator pass. This file exists so product answers and
> remaining open questions have a durable home (vault `gaps.md` is retired for new
> ticket questions).

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-903` (Task, epic `SCRUM-232`, reported by Aiman Farooq / QA) |
| Path | B |
| Branch | `fix/SCRUM-903-job-completed-status` (client + overlay); reopen follow-up on `fix/reopened-qa-aug25` |
| PR | [#384](https://github.com/TheCraneGuys/craneguys-platform/pull/384) (platform); overlay [#20](https://github.com/devCodingcops/tcg-ai-layer/pull/20) |
| Source punch list | Confluence `13-august-QA` — after DAS/Yard completion, Project → Jobs stayed open |
| Clarification | Umair Khan (description): status = **Completed**, not Closed |
| Product answers | Umair Khan (Q1/Q2, Jira 2026-08-20); Fouzan Shakil assignee (Q3/Q4, working session 2026-08-20; **Q5, Jira comment #23785, 2026-08-25**) |
| Shipped behaviour (branch) | On full/force/defer offload complete → sub-job `dasStage` COMPLETED; parent `Job.status` ACTIVE → COMPLETED when every non-cancelled sub-job is done |
| Reopen follow-up (2026-08-25) | View-only when `Job.status === COMPLETED` — hard UI + API lock on all editable job tabs; branch `fix/reopened-qa-aug25` |
| Not shipped | Ticket-submit stage wiring; vendor/no-yard completion path; historical Job.status backfill; CANCELLED/INVOICED locks; unlock path |
| Open questions raised by this ticket | 0 — Q1–Q5 resolved |

## 12. Open questions — the stop-and-ask list

### Q1 — When should Project → Jobs flip to Completed?

- **Question:** Should the parent Job become Completed when yard offload finishes for a schedule day, or only after field tickets are submitted as well?
- **Why it cannot be answered from what is written:** Before Umair's reply, only the QA punch list and the ticket's Completed-vs-Closed clarification existed. No vault file specifies parent `Job.status` rollup after DAS/Yard.
- **Blocked:** Was blocking treating offload-complete as the trigger vs waiting on tickets.
- **Candidates:**
  - `SCRUM-903` / Confluence `13-august-QA` — symptom only
  - `SCRUM-553` DAS lifecycle — names Completed → Ticket Submitted as stages; does not say when parent Job.status flips
- **Owner:** product team
- **Answer (2026-08-20, Umair Khan):** Completed when the job is completed on its **last scheduled day** and the **applicable return/offload** is completed. Field-ticket submission must **not** be the sole completion trigger.
- **Status:** resolved — see `.ai/vault/decisions/2026-08-20-job-completed-on-last-day-offload.md`

### Q2 — Multi-day / multi-schedule parent Job

- **Question:** Does the parent stay Open until every schedule day is done, or become Completed after the first day / only when the last day finishes?
- **Why it cannot be answered from what is written:** Same as Q1 — no vault rollup rule.
- **Blocked:** Was blocking the all-sub-jobs-done vs first-day-done choice in `markCompletedIfAllSubJobsDone`.
- **Candidates:** same as Q1
- **Owner:** product team
- **Answer (2026-08-20, Umair Khan):** Parent stays **Open/Ongoing until the last scheduled day is completed**. Must **not** become Completed after the first day alone.
- **Status:** resolved — see `.ai/vault/decisions/2026-08-20-job-completed-on-last-day-offload.md`

### Q3 — Jobs that never go through yard loadout/offload

- **Question:** Jobs that never hit yard loadout/offload (e.g. vendor-covered, no yard ops) will **not** auto-complete with the SCRUM-903 path. Is that OK, or do they need a separate completion path?
- **Why it cannot be answered from what is written:** Umair's 2026-08-20 comment answered Q1/Q2 only and was silent on non-yard jobs. No vault file defines completion for vendor-only / no-loadout jobs.
- **Blocked:** Nothing for the Path B ship (yard offload path). Blocked for claiming vendor/no-yard jobs auto-complete, and for building a second trigger without a further decision.
- **Candidates:**
  - `SCRUM-903` Q3 (unanswered)
  - `decisions/2026-08-20-job-completed-on-last-day-offload.md` — settles yard last-day offload only
- **Owner:** product team
- **Answer (2026-08-20, Fouzan Shakil, assignee):** **OK that they do not auto-complete** on this ticket. No separate vendor/no-yard completion path. Follow-up ticket when product defines that trigger.
- **Status:** resolved — see `.ai/vault/decisions/2026-08-20-job-completion-scope-no-vendor-no-backfill.md`

### Q4 — Historical backfill

- **Question:** Existing jobs already finished in DAS/Yard but still showing **Open** in Project → Jobs — one-time backfill, or fix going forward only?
- **Why it cannot be answered from what is written:** Umair's comment did not address backfill. No vault retention/migration rule for Job.status.
- **Blocked:** Nothing for forward-looking completions. Was blocking writing a backfill vs accepting stale Open badges.
- **Candidates:**
  - `SCRUM-903` Q4
  - `decisions/2026-08-20-quantity-based-das-sets.md` — different ticket; shows backfill can be explicit opt-in, not a precedent for jobs
- **Owner:** product team
- **Answer (2026-08-20, Fouzan Shakil, assignee):** **Forward-only.** No historical backfill in this PR. Stale Open badges remain until a follow-up opts into a rewrite.
- **Status:** resolved — see `.ai/vault/decisions/2026-08-20-job-completion-scope-no-vendor-no-backfill.md`

### Q5 — Does a Completed job become read-only, and across which tabs?

- **Question:** Once a parent Job reaches COMPLETED, is the lock **total** (no schedule,
  additional-info, attachment, permit or plan changes ever again), or does an after-the-fact
  correction path stay open? And is it a hard reject or a confirm-then-proceed warning?
- **Why it cannot be answered from what is written:** The only provenance before this answer
  was a QA comment (Aiman Farooq, SCRUM-903 comment #23542, 2026-08-24). A QA comment is not
  a product decision on its own. The only written job-detail page,
  `vault/projects-jobs/project-module/02-view-manage-job-details.md` (unverified), described
  unconditional editability with no status gating.
- **Blocked:** Was blocking shipping the completed-job lock on `fix/reopened-qa-aug25` as
  product-approved behaviour.
- **Candidates:**
  - `SCRUM-903` QA comment #23542 — the origin, not a decision
  - `vault/projects-jobs/project-module/02-view-manage-job-details.md` — unconditional editability
  - `vault/dispatch/daily-allocation-system.md` — nearest lock rule is warning-based on
    allocation/ticket acceptance, not `Job.status`
- **Owner:** Umair Khan (completion semantics); Lisette Anzaldo (dispatcher-facing consequence)
- **Answer (2026-08-25, Fouzan Shakil, assignee — Jira comment #23785):** Completed jobs are
  **hard view-only across all tabs**. No unlock path for now. **`CANCELLED` / `INVOICED`
  unchanged** — out of scope for now.
- **Status:** resolved — see `.ai/vault/decisions/2026-08-25-completed-job-view-only.md`

## 13. What this deliberately does not specify

- Vendor / no-yard completion trigger — deferred; see Q3 decision
- Historical backfill mechanics — deferred; see Q4 decision
- `TICKET_SUBMITTED` stage transition on field-ticket submit — not required for parent Completed per Q1
- Whether `ON_HOLD` / `INVOICED` jobs can move to `COMPLETED` — branch leaves non-ACTIVE statuses alone
- Whether `CANCELLED` / `INVOICED` jobs become view-only — deferred; see Q5 decision
- Unlock / reopen path after Completed — deferred; see Q5 decision
- Manual Project → Jobs status editing — no UI/API added