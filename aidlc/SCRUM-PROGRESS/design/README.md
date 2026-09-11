# Design reference — SCRUM-PROGRESS

The only design source for this ticket. **Mock data and mock behaviour throughout** — it is a
clickable prototype, not a specification. It describes screens and states; it does not
establish that any value in it is captured, computed or allowed.

## Provenance

| Field | Value |
| --- | --- |
| Original file | `TCG Platform (standalone) for pregress tracking.html` (sic) — handed over in session by Syed Haris, 2026-09-11 |
| Where it was | `~/Downloads/` on the capturing machine — **not in any repo** |
| Size / mtime | 2,021,155 bytes · 2026-09-10 21:35 |
| Format | A "bundled page": a JSON manifest of base64 (+gzip) assets and a JSON-encoded `template.html` (1,579,305 bytes, 14,133 lines) rendered by an embedded React 18 UMD runtime |
| Extraction | `template.html` decoded from the `__bundler/template` script tag; manifest entries are fonts, React/ReactDOM, one logo PNG and the `x-dc` runtime — no design content outside `template.html` |

[`progress-tracking.design-extract.js`](progress-tracking.design-extract.js) is a verbatim copy of
the three progress-tracking ranges of `template.html`. It is not runnable on its own (it is a slice
of one large class). Cite it by **extract line number**; the template range each section came from
is in its header comment.

| Extract lines | Template lines | What |
| --- | --- | --- |
| 1–924 | 8949–9870 | **A — Job detail → Progress Tracking tab** (`progressTracking()`), plus the ticket-detail pieces the Daily module reuses |
| 926–1513 | 12078–12664 | **B — Top-level "Daily Progress Tracking" module** (`dailyProgressTracking()`) — **out of scope for this ticket**, see `intent.md` §5 |
| 1515–1520 | 827, 11057, 11075–76, 13618 | **C — wiring**: sidebar entry, job-detail tab list, tab dispatch, route dispatch |

## Index — Section A (in scope)

| Extract line | Definition | Role |
| --- | --- | --- |
| 4 | `PT_STEP_META` | The design's 16 step keys → label + icon (15 flow steps + `incident`) |
| 15 | `ptAllPending()` | The fixed 15-step order used for an unopened ticket |
| 18 | `ptAssetList()` | Pre/Post-Trip asset item lists (Crane 17 · Tractor 26 · Trailer 4) — **mock copy of checklist content** |
| 25 | `PT_CK_DEFS` | The 4 checklists: Pre-Trip (per asset), JSA (6 questions), Post-Trip (per asset), Compliance (4 questions) |
| 43, 49 | `PT_CK_ANSWERS`, `PT_CK_DEFECTS` | Mock answers; deficiency detail = desc · priority · photo · GPS · time |
| 62–100 | `ptCkStats` … `ptCkRollup` | Checklist rollup: answered/total, has-deficiency, "all done" gate |
| 75 | `PT_CK_STEP_GATE` | Which step captures which checklist |
| 176, 198 | `ptCkCard`, `ptChecklistsSection` | The CHECKLISTS section under the timeline ("Captured inside the step flow — listed here only for monitoring") |
| 215 | `PT_SCHEDULES` | Mock job schedule: dates with a status (`Ticket Sent` / `Allocation Completed` / `Open`) and per-ticket `summary` + `timeline` |
| 293, 297 | `ptOpenBadge`, `ptStatusBadge` | Ticket badge precedence: INCOMPLETE → FLAGGED → COMPLETED → Opened / NOT OPENED |
| 304 | `ptSidebar()` | Left rail: "Scheduled Date" list; expanding a date lists its tickets (code + badge) |
| 323 | `ptTicketCard()` | Card per ticket when a date is picked but no ticket: code, avatar, name, role, badge, *Send Reminder via Email*, *Contact &lt;role&gt;* |
| 335 | `ptVis()` | The 7 step states: done · progress · pending ("Not reached") · skipped ("Skipped / N/A") · flagged · incident · incomplete |
| 541 | `ptStepDetail()` | Per-step expanded body — **the richest part of the design; most of its fields have no capture behind them** (see `intent.md` §11) |
| 656 | `ptStepRow()` | Timeline row: node + header (label, time, sub-hits) + status chip + expandable body |
| 681 | `ptTicketStatus()` | Ticket-level status derivation and `pct = step / total` |
| 700 | `ptTicketSummary()` | Status-count KPI card — **defined but never rendered** by `ptDetail()` |
| 726 | `PT_TICKET_INFO` | Ticket info modal content — **unreachable**: only `ptTicketSummary()` opens it |
| 751 | `ptChatPanel()` | Right-hand chat drawer — **local-only mock** (seeded messages, nothing sent) |
| 829 | `ptSummaryCard()` | SHIFT SUMMARY: current step text, *Step n/N*, bar, boom hours, net billable, incidents, deficiencies |
| 845, 856 | `ptIncompleteBanner`, `ptIncidentBanner` | Top banners: "Ticket Incomplete — Allocated Time Expired" / "Ticket Flagged — Incident Reported" |
| 868 | `ptDetail()` | Ticket detail layout: banners · timeline (Expand all / Collapse all) + CHECKLISTS · side column (EMPLOYEE DETAILS, SHIFT SUMMARY, Live Tracking map) |
| 905 | `progressTracking()` | Tab root: rail + (empty "No data found — Select any date" · ticket cards · ticket detail) |

`ptTicketReport()` (471, a printable "Field Ticket Completion Report") is reachable only from
Section B's full-ticket view and is out of scope with it.

## Reading notes

- **The design's step list is not the field app's.** The mobile flow has 14 steps for an Oiler
  and 9 for every other role; End Work has no screen and Incident is not a step (it is filed
  from an SOS overlay at any time). Settled in session — see `intent.md` → *Session decisions*
  D2.
- **The design's Compliance is a 4-question checklist; the real Compliance step is a signature
  row** (per-diem selection + one attestation). The design's four questions have no capture.
- **Hex colours in the design are not tokens.** The web app forbids hardcoded colours
  (`contexts/web.md`); map every tone to a `--color-*` token.
