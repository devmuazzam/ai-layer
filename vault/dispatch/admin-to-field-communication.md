---
title: Communication from the admin departments to the field — the FLEET value engine
source: shared-folder/Project-Repository-2026-09-04/TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/TCG FLEET - Communication Admin to Field - VALUE ENGINE 2026-04-29.vsdx
migrated: 2026-09-04
updated: 2026-04-29
status: unverified
conflicts_with: []
jira: []
tags: [module/dispatch, module/field-ops, module/payroll, module/admin, module/assets, kind/sop, notifications, scheduling, safety, union-agreement, time-tracking, certifications, overtime]
entities: []
---

# Communication from the admin departments to the field — the FLEET value engine

**What this is.** `TCG FLEET - Communication Admin to Field - VALUE ENGINE 2026-04-29.vsdx` — one
Visio page dated **2026-04-29**, titled *"Communication Admin Dept. to the Field"*. It maps **seven
admin functions, each with a named owner, and what each one has to get to the field crews.**

**Why it matters.** It is the only document in the drop that treats *field communication* as one
process rather than seven departmental ones — and it names, on one page, every channel the ERP's
notification design would have to account for. Dispatch is one of its seven lanes, and the lane
Dylan (Warehouse) and Garret (Dispatch) share is the daily loading handoff already described in
[daily-loading-value-engine.md](daily-loading-value-engine.md).

> **A department map, not a specification.** It states who talks to the field about what. It states
> almost nothing about *how*, and where it does — *"morning call or text"* — the mechanism is a
> phone. Nothing here has been asked for or accepted as ERP behaviour.

> **Shape text only.** The `.vsdx` conversion carries shape labels; **connectors are lost.** The
> lane assignments below are read from label adjacency and the owner blocks, and the flows are read
> from the phrasing of the shapes themselves. Where a link is inferred it is marked.

---

## The seven lanes

The page names a function, an owner, and the traffic it carries:

| Function | Owner named | What goes to the field |
| --- | --- | --- |
| **Owner** | **Kyle** | *(the lane the union-issue escalation resolves back to — see below)* |
| **Dispatch** | **Garret** | `Daily Schedule` · `Changes` · `Permits` · `Crews on D.T.` · `Notify Crews` |
| **Mechanic Shop** | **Jeff S.** | `Morning update on downed equipment` |
| **Parts** | **Nick** *(and Safety)* | parts availability and delays |
| **Safety** | **Corrina** | training scheduling and field safety issues |
| **H.R.** | **Rose** | new-hire orientation, union issues, apprentice reviews |
| **Payroll** | *(with)* **Time Tickets** | time discrepancies against tickets |
| **Warehouse** | **Dylan** | `Daily Loading` |

## What each lane carries

### Dispatch — Garret

The dispatch lane is the widest on the page. Its shapes:

- **`Daily Schedule`** and **`Changes`**
- **`Permits`**
- **`Crews on D.T.`** — crews on double time
- **`Notify Crews`**, with four stated reasons spelled out as sub-items:
  - **going out of town**
  - **permit issues**
  - **night & day**
  - **work multiple shifts**
- **`Change schedule and double stack jobs with Dispatch`** — the response path when equipment is
  down

> **Every one of those four notify-reasons is an exception to a normal day**, and each has a home
> elsewhere in this module: *out of town* and *night & day* are the shift and travel markers on the
> dispatch sheet ([dispatch-sheet-workbook.md](dispatch-sheet-workbook.md) §4), *permit issues* is
> the after-hours schedule-change case the permit column exists for
> ([crane-configurations.md](crane-configurations.md) §2), and *work multiple shifts* is the
> multiple-unit-rows problem FCC solves at ticketing
> ([fcc-nexgen-dispatch-guide.md](fcc-nexgen-dispatch-guide.md) §5).
>
> **`Crews on D.T.` appearing as a standing dispatch-to-field communication** is the third
> independent source pointing at the same thing: the double-time colour on the dispatch sheet, the
> *"make sure a crew isn't on double time and if they are that we are charging accordingly"* check
> in the Set Schedule playbook
> ([dispatch-value-engine-and-playbooks.md](dispatch-value-engine-and-playbooks.md) §4), and
> review-log entry **#14**'s ask to *notify dispatch when an employee is working more than 10–12
> hours* ([erp-review-log.md](../erp-review-log.md)). **Four documents; no decision.**

### Mechanic Shop — Jeff S.

`Morning update on downed equipment` → **`Is equipment fixed?`** → **`Yes (up)`** / **`No (down)`**.
On *no*, the flow reads across to dispatch: **`Change schedule and double stack jobs with
Dispatch`**.

**"Double stack jobs" is the term the business uses for the deliberate double booking** the client
asked the ERP to support in the 2026-08-12 minutes — *"support double booking when short jobs allow
the same crane to perform multiple jobs in one day"*
([meetings/2026-08-12-sell-side-workflow-and-scheduling.md](../meetings/2026-08-12-sell-side-workflow-and-scheduling.md)).
Here it appears as the **standard response to equipment going down**, which is a different trigger
from the one in the minutes. **Neither source defines it.**

### Parts — Jeff Stricker

`Follow up with Jeff Stricker on parts or time delays` — the shop's dependency on parts, escalated
by name.

### Safety — Corrina

- `Schedule training C.P.R. A.E.D. for new hires`, and `address safety issues in the field`
- `Contact crews and discuss safety violations in the field. Take corrective actions`
- `Morning call or text on daily job audits`

### H.R. — Rose

Three distinct flows, and the union one is the most specified thing on the page:

- **Union escalation.** `Union issues with crews need addresing` →
  **`Does union handbook have clear answer?`** →
  - **Yes** → `Refer to answer in handbook and notify crew of the answer`
  - **No** → `Call union rep (Danny Bryant) Local 12` → `Notify crew of Danny's resolution of
    problem` → `Notify Kyle issue has been resolved by Local 12`
- **Apprentice reviews.** `Complete apprentice monthly reviews for Union` →
  `Set up meeting with apprentice to discuss & sign monthly review` → `Turn in signed review to
  Corrina`
- **New hires.** `New hire oreintation time issues`, `union issues`, `new hires`,
  `C.P.R. schedule` → `Reach out to employee to resolve problem`

> **A two-step union escalation with a named external authority and a defined close-out.** The
> handbook is consulted first; **Local 12** is the escalation; the resolution is communicated to the
> crew *and* back to the owner. The vault's union material
> ([payroll/rules/](../payroll/rules/INDEX.md), and review-log entry **#4**'s tier order and
> last-crew entitlement) is all about *what the rules are*. **This is the only source describing
> what happens when the rules do not answer the question**, and it is entirely manual.
>
> **Monthly signed apprentice reviews owed to the union** appear nowhere else in the vault.

### Payroll / Time Tickets

`Contact crews with time issues that do not match tickets` →
`Explain to crane crews the problem with time tickets and resolve issue`.

The reconciliation this describes is the same one FCC puts in dispatch's hands at the payroll
pre-processor ([fcc-nexgen-dispatch-guide.md](fcc-nexgen-dispatch-guide.md) §6) — **but here it is
payroll contacting the crew directly, not dispatch approving in a screen.** The two sources place
the same work in two different departments. **Neither is authoritative and this page does not
choose.**

### Warehouse — Dylan

`Morning meeting discussing load outs and crane schedule for loading` →
`Set up times for crane work as per trucking schedule`.

That is the yard-side view of the handoff in
[daily-loading-value-engine.md](daily-loading-value-engine.md) §2 — and it adds one thing that page
does not: **the loading times are set *from* the trucking schedule**, not the other way round.

---

## What this establishes, and what it does not

**Establishes:**

- Seven admin functions communicate with the field, each with a named owner as of 2026-04-29.
- Dispatch's field traffic is: daily schedule, changes, permits, double-time crews, and four named
  exception notifications.
- "Double stacking" is the business's own term, and equipment going down is one of its triggers.
- A defined two-step union escalation path ending at Local 12, with a named rep.
- Monthly apprentice reviews are owed to the union and signed.

**Does not establish — do not infer:**

- **No channel is specified** for anything except *"morning call or text"*. Whether any of this
  should become a system notification is unstated.
- **No timing is specified** beyond "morning".
- **Nothing says which of these the ERP is meant to absorb.** Several are conversations, not
  messages.
- The owner names are a **2026-04-29 snapshot** of who held each function.
- **Garret** is named as the dispatch owner here; every other dispatch source in this module names
  **Lisette Anzaldo** or **Liz Lopez**. The documents do not reconcile the roles, and this page does
  not guess at them.

## Source

`shared-folder/Project-Repository-2026-09-04/TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/TCG FLEET - Communication Admin to Field - VALUE ENGINE 2026-04-29.vsdx`
— one Visio page, converted to per-page shape text. **Connectors, lanes and layout are lost**; the
lane assignments and flow order above are read from shape-label adjacency and phrasing. Dated
2026-04-29 in the filename; the chart carries no other date and no author.
