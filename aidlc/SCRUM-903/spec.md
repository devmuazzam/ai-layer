# Spec — SCRUM-903 Clarify Job Completion Logic in Project Jobs

> Path B ticket. No full elaborator pass. This file exists so product answers and
> remaining open questions have a durable home (vault `gaps.md` is retired for new
> ticket questions).

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-903` (Task, epic `SCRUM-232`, reported by Aiman Farooq / QA) |
| Path | B |
| Branch | `fix/SCRUM-903-job-completed-status` (client + overlay) |
| PR | — |
| Source punch list | Confluence `13-august-QA` — after DAS/Yard completion, Project → Jobs stayed open |
| Clarification | Umair Khan (description): status = **Completed**, not Closed |
| Product answers | Umair Khan (Q1/Q2, Jira 2026-08-20); Fouzan Shakil assignee (Q3/Q4, working session 2026-08-20) |
| Shipped behaviour (branch) | On full/force/defer offload complete → sub-job `dasStage` COMPLETED; parent `Job.status` ACTIVE → COMPLETED when every non-cancelled sub-job is done |
| Not shipped | Ticket-submit stage wiring; vendor/no-yard completion path; historical Job.status backfill |
| Open questions raised by this ticket | 0 — Q1–Q4 resolved 2026-08-20 |

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

## 13. What this deliberately does not specify

- Vendor / no-yard completion trigger — deferred; see Q3 decision
- Historical backfill mechanics — deferred; see Q4 decision
- `TICKET_SUBMITTED` stage transition on field-ticket submit — not required for parent Completed per Q1
- Whether `ON_HOLD` / `INVOICED` jobs can move to `COMPLETED` — branch leaves non-ACTIVE statuses alone
- Manual Project → Jobs status editing — no UI/API added