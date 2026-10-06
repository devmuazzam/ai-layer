---
title: Crane lines of 550 t and up are pre-ticked in the Schedule tab's Make Holdover; nothing is held until Save (Fouzan Shakil, 2026-10-06) — decision
source: decision/Fouzan Shakil — a default for Make Holdover on the job Schedule tab
decided: 2026-10-06
decided_by: >-
  Fouzan Shakil (fouzan.shakil, CodingCops), stated in a Claude Code session on 2026-10-06 while
  building branch `feat/yard-holdover-loadout` (tcg). They wrote a one-line request, then picked one
  option for each of three questions. The option labels and descriptions were written by the
  session; the ruling is the pick. This is a CodingCops ruling, not a TCG client confirmation. Lisette Anzaldo
  (TCG dispatch) owns the related register entry and should confirm it. She has not been asked, and
  has not confirmed it. That is why the status is `reference`: it binds the CodingCops build, and
  TCG can overrule it. The basis is the same as
  decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md.
  Attribution corrected 2026-10-06: first recorded as Syed Haris; the developer confirmed in
  the same session that the ruling was Fouzan Shakil's.
status: reference
conflicts_with: []
resolves: []
related_decisions:
  - 2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md
  - 2026-10-01-multi-day-crane-offload-held-on-last-day-otherwise-daily.md
  - 2026-09-03-paid-time-boundaries-yard-to-yard.md
jira: []
tags: [module/dispatch, module/projects-jobs, kind/decision, scheduling, daily-allocation]
---

# Crane lines of 550 t and up are pre-ticked for holdover on the Schedule tab; Save still decides

## The exchange

Fouzan Shakil, 2026-10-06, verbatim:

> "one more rule to add, 550 ton crane and anything above will have holdover marked by default on
> schedule page"

Three questions followed, and one option was picked for each. Labels and descriptions are verbatim
as shown.

| Question | Picked | Rejected |
| --- | --- | --- |
| "What should \"marked by default\" do?" | **"Pre-ticked in the modal"**: *"Make Holdover opens with 550 t+ cranes ticked, but nothing is held until someone presses Save."* | **"Saved as held"**: *"When a 550 t+ crane line is added to a job it is saved held, so the Schedule badge, DAS and yard rules apply with no click. Dispatch can untick it in Make Holdover."* |
| "How should a crane line's tonnage be read?" | **"Number in the name"**: *"\"550 Ton Crane\" or \"600 T\" counts. Lines named only by type (\"Crawler Crane\") are never held by default. Same way the DAS reads crane size today."* | **"Name, else its assets"**: use the largest rated capacity among that sub-category's assets when the name has no number |
| "Which jobs get the default?" | **"New crane lines only"**: *"Applies to lines added from now on. Existing jobs are left as they are, so no held state changes under anyone's feet."* | **"Also open jobs today"**: a one-off migration marking 550 t+ crane lines on active jobs |

## Decision

**The ruling, from the picks:**

- On the **Schedule** tab, *Make Holdover* opens with crane lines of 550 t and above **already
  ticked**.
- A pre-tick is a suggestion. **Nothing is held until someone presses Save.** Until then no
  Schedule badge, no DAS carry or block, and no yard rule
  (decisions/2026-10-06-yard-holdover-loaded-out-once-offloaded-on-last-day.md) applies.
- Tonnage is read from **the number in the line's name**. A line named only by type is never
  pre-ticked.
- No migration. No existing job's held state is changed.

**Interpretation, not the ruling's words.**

- **"550 ton and anything above"** means 550 t **or more**.
- **"New crane lines only", under a pre-tick that saves nothing.** It is built as: the Schedule tab
  pre-ticks 550 t+ crane lines **only while nothing on the job is held yet**. Once a holdover has
  been saved for the job, the modal shows exactly what was saved and adds no pre-tick. Two
  consequences:
  - An existing job that has a 550 t+ crane line and nothing held will show the pre-tick when Make
    Holdover is opened. Nothing changes unless someone saves, so no held state moves under anyone.
  - A 550 t+ crane line added to a job that already has something held is **not** pre-ticked.
- **What counts as a crane line.** An asset line (a sub-category, no employee type) whose
  sub-category name or category name contains "crane".
- **How the number is read.** The number in the sub-category name followed by "t", "ton" or "tonne"
  ("550 Ton Crane", "Crawler Crane 600T"). If there is none, the name's leading number, as the DAS
  reads crane size in `getMaxCraneSizeFromLabels` (`apps/api/src/usecase/das/sub-job.mapper.ts`).
  - This reads slightly more than the DAS does. The DAS takes only a leading number, so it reads
    "Crawler Crane 600T" as 0; the pre-tick reads it as 600.
- **Schedule tab only.** The DAS also opens Make Holdover (the same modal). It does **not** pre-tick,
  because the request said "on schedule page".

## Why

No reason was given for the 550 t threshold. The option descriptions picked give two:

- a pre-tick means *"nothing is held until someone presses Save"*;
- new lines only means *"no held state changes under anyone's feet"*.

The record has related material. None of it rules on this default:

- **550 T is the top crane group in Lisette's workbook.** dispatch/crane-configuration-rules.md:23
  (`reference`) describes `ASSETS_DISPATCH_(Lisette-approved).xlsx` as having *"17 crane groups,
  22 T → 550 T."* It does not say the 550 T group is held over.
- **FCC has a mob/demob template only for the 550.** Joe Schacatano (TCG), 2026-10-01,
  meetings/2026-10-01-quotes-and-billing-codes-associated-assets-mob-demob-and-holdover.md §8
  (`unverified`, a retrospective record). The curated note, paraphrasing Joe (48:14, 48:27): FCC
  has a mob/demob template *"only for the **550**, by configuration and minimum time"*. That is
  about quoting, not about holdover.
- **A tower-crane job is always a holdover.** Kyle Harlow (TCG, VP of Fleet), 2026-09-03,
  decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md → *Boom window* (`verified`). Asked
  whether a tower-crane job is therefore always a holdover, he answered *"Yes."* (45:15). He was
  speaking of boom pay, not of Make Holdover. It is a different default, and it is **not built**
  (see *What this does NOT settle*).

## Relevant open register entries

This note does not close any entry.

- dispatch/gaps.md → *Which items of a holdover job go back to the yard between working days?*
  - It asks *"Is there a default the modal should pre-tick"*.
  - Partly answered here: 550 t+ crane lines, on the Schedule tab only, as a pre-tick only.
  - Not settled: which other items (tractor, trailer, counterweight trucks, crew vehicles, crew)
    stay on site; the first/last-day configuration variant.

## What is built

**Built on tcg branch `feat/yard-holdover-loadout`, not merged** (uncommitted on 2026-10-06):

- **API.** `apps/api/src/usecase/jobs/holdover-default.util.ts`: `DEFAULT_HOLDOVER_MIN_TONS = 550`,
  `craneTonsFromName`, `isDefaultHoldoverLine`. `apps/api/src/usecase/jobs/job-holdover.service.ts`:
  each Make Holdover item carries `suggested`.
- **Web.** `apps/web/src/features/job-holdover/utils/holdover-selection.ts` →
  `initialSelection(items, suggestDefaults)`: what is held now, or, with `suggestDefaults` and
  nothing held, the `suggested` items.
- `HoldoverModal` takes a `suggestDefaults` prop. Only the Schedule tab passes it
  (`apps/web/src/features/projects/jobs/job-details/schedule/components/schedule-holdover-action.tsx`).
  The DAS's call (`apps/web/src/features/das/middle-section/jobs/components/job-list-item-expanded.tsx`)
  does not.
- A pre-ticked row reads *"Ticked by default — 550 t or larger crane"*, with test ID
  `jobs-holdover-item-default-<jobResourceId>`.

## What this does NOT settle

- **Tower cranes.** Kyle's rule (a tower-crane job is always a holdover) is not built. A tower-crane
  line is pre-ticked only if its sub-category name carries a number of 550 t or more.
- **Lines named only by type** ("Crawler Crane") are never pre-ticked. Reading the tonnage from the
  sub-category's assets was offered and rejected.
- **The DAS's Make Holdover** does not pre-tick. Whether it should is not decided.
- **Whether the threshold should be a setting.** It is fixed at 550 t in code. Whether a tenant or
  dispatch should be able to change it is not decided.
- **Employee lines.** Whether the 550's crew (operator, oiler and other employee lines) should also
  be pre-ticked is not decided. Only the crane line is.
- **Other items of a 550 t job.** Tractor, trailer, counterweight trucks and support loads are not
  pre-ticked. Which of them stays on site is the open register question.
- **A job whose holdover was saved and then fully released.** Nothing on it is held again, so under
  the interpretation above the pre-tick returns. Whether that is wanted is not stated.

## Effect on the vault

- **No frontmatter edits.** No vault file specified a holdover default. So no file becomes
  `verified` or `superseded`, and no `conflicts_with:` pair is adjudicated. This note is `reference`,
  not `verified`.
- **Register:** a dated note pointing here was appended to dispatch/gaps.md → *Which items of a
  holdover job go back to the yard between working days?*. Its `Status:` line was not changed.
- **Not indexed.** Like the other 2026-10-01 and 2026-10-06 decisions, this note is not listed in
  INDEX.md or dispatch/INDEX.md. It is found by its `module/dispatch` tag.
