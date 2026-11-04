# Intent — YARDS-2026-10-29

> What the ticket asks for. Written from the 2026-10-29 client sales-quoting meeting and the ticket
> text the developer drafted for Trello on 2026-11-02. No Trello/Jira ID yet — the folder and the
> branch (`fixes/yards-2026-10-29`) are named after the meeting until the developer gives one.

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | NOT YET — working id `YARDS-2026-10-29` |
| Title | Yards across quoting, dispatch and employees — quote from one yard, carry it to the job, show it on the DAS, employees in more than one yard |
| Type | NOT ON TICKET |
| Assignee | Asad Amanullah (CodingCops) |
| Captured on | `2026-11-03` |
| Captured by | Claude Code, from the developer's messages and the meeting record |
| Branch | `fixes/yards-2026-10-29` (platform and `.ai`), from `main` |

## 2. Business intent

- TCG bills the customer from the yard closest to the job site ("portal to portal"), never job to
  job. So every quote is made **from one yard**, and that yard must follow the work to the job and
  be visible on the Dispatch board — even when Dispatch actually sends equipment or crew from
  somewhere else.
- In FCC an employee could belong to one yard only; sending them to the other yard meant switching
  their yard and back, which *"messes up payroll"*. They want employees in more than one yard.
- Who benefits: sales (pick and see the yard), dispatch (see where the work is billed from and where
  equipment/crew come from), payroll (no yard toggling).

## 3. Source

- Meeting: [../../vault/meetings/2026-10-29-sales-quoting-crane-set-one-yard-third-party-pos-and-faa-flag.md](../../vault/meetings/2026-10-29-sales-quoting-crane-set-one-yard-third-party-pos-and-faa-flag.md) §4
- Transcript: [../../vault/meetings/transcripts/2026-10-29-sales-quoting.md](../../vault/meetings/transcripts/2026-10-29-sales-quoting.md) 17:22–25:36
- Open vault question this answers in part: [../../vault/projects-jobs/gaps.md](../../vault/projects-jobs/gaps.md) *Quote / Job yard free-text vs Yard master FK* (owner Lisette Anzaldo)

## 4. Not this ticket

- Per-yard record numbering / counter prefixes — **TCG-232, on hold** (branch `fixes/TCG-yard-counters`,
  local DB copy `tcg_db_232`). This ticket must not depend on it. TCG-232 U3/U4 also add a quote/job
  yard link; whichever merges second resolves the overlap.
