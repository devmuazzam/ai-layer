---
title: Daily loading — the yard value engine and the daily loading report SOP
source: shared-folder/Project-Repository-2026-09-04/TCG_Value_Engine_SAMPLES-ONLY/2026-06-23 samples/Daily loading value engine.pdf + 2026-06-16 samples/TCG Yard - Daily Loading - Running Daily Loading Report 2026-05-12.docx
migrated: 2026-09-04
updated: 2026-05-12
status: unverified
conflicts_with: []
jira: []
tags: [module/dispatch, module/assets, module/field-ops, kind/sop, yards, scheduling, tools-rigging, mob-demob, reporting]
entities: []
---

# Daily loading — the yard value engine and the daily loading report SOP

**What this is.** Two documents describing the **yard's** morning process: the flowchart of the
*Daily Loading* value engine, and the step-by-step SOP for the report that starts it, written by
**Dylan Masterson** (playbook owner, team **Yard**) on **2026-05-12**.

**Why it matters.** The vault's only yard-operations page,
[yard-operations-jz.md](yard-operations-jz.md), is a fourteen-line punch list of defects in a
loadout screen. It says what is wrong with a UI; it never says what loading out *is*. **These two
documents are the first description of the yard's actual daily process, and of the decision tree
the yard runs when a load will not go out as planned.**

> **Current manual practice.** Every step below runs on **Microsoft Remote Desktop into
> NexGenFMS**, a handwritten list, and two group chats. Nothing here has been specified for the
> ERP.

---

## 1. Running the daily loading report

Source: `TCG Yard - Daily Loading - Running Daily Loading Report 2026-05-12.docx`. Owner **Dylan
Masterson**, created 2026-05-12, team Yard, associated value engine **Daily Loading**. Its stated
overview: *"Accessing jobs and running the daily loading report."* Eight steps, in full:

1. **Open Microsoft Remote Desktop.**
2. **Connect to `FCC – Craneguys`**, then open **NexGenFMS** and log in.
3. **Navigate `Reports → Jobs → Job LEMS → Daily Job LEMS`.**
4. **Change the date and select the `Job Starting` box**, then `View`.
5. **Review all jobs listed for the day** — check the **`Equipment Required`** section, and read
   **all job comments for any special rigging or loading instructions.**
6. **Check the unit code** to identify which crane, trailer or truck is assigned to the job.
7. **Create the loading list**, writing down for each job:
   - **Job number**
   - **Unit going and how many loads**
   - **Required rigging**
   - **Leave time**
8. **Send the completed loading list to two chats:** the **Yard Guy Loading Chat** and the
   **TCG Loading Chat**.

A walkthrough video is linked from the source (a SharePoint folder on Dylan Masterson's OneDrive);
the link is in the source file and is not copied here.

> **Three of the four loading-list fields are already vault-known and one is not.** *Job number*,
> *unit and how many loads* (the operator-load-plus-`.1/.2/.3` count of
> [crane-configurations.md](crane-configurations.md) §1) and *required rigging* all have
> antecedents. **`Leave time` does not.** It is the yard's organising field — the time the load has
> to be out of the gate — and it is exactly what
> [yard-operations-jz.md](yard-operations-jz.md) means by *"leave yard time should be first
> option"*. **These two sources agree that leave time is the primary key of the yard's day, and no
> specification in the vault treats it that way.**

> Note also that **the yard reads `Equipment Required` and the job comments to plan loading** —
> the same free-text field FCC says is *"a synopsis to field employees"* and *"should not be used
> to capture units"* ([fcc-nexgen-dispatch-guide.md](fcc-nexgen-dispatch-guide.md) §2). The
> rigging requirement for a load therefore lives in prose, not in a structured field.

## 2. The value engine — what the yard does when the plan does not hold

Source: `Daily loading value engine.pdf`, one landscape flowchart page (2026-06-23 sample set).
Shape text only; **connectors are lost in conversion**, so the branches below are read from label
grouping and phrasing, not from arrows.

**The trunk:**

`DAILY LOADING` → `Dispatch confirms loading is ready` → `Run daily report` →
`Generate loading list` → `Rigging availability` → `Crane back in yard?` →
`Crane is in yard. Does equipment fit?` → `Complete loading`

**Three decision points, and what happens at each:**

| Decision | Branch | Action |
| --- | --- | --- |
| **Rigging availability** | *"Rigging is available"* | continue |
| | *"Rigging is not available"* | **`Rent rigging or take from another crane that doesnt need it`** — and, alongside it, **`Talk to PM and come up with alternative`** |
| **Crane back in yard?** | *"Crane is not back in yard"* | **`Find out Arrival time and leave time`** → then either **`Wait for cranes arrival`** or **`Come in before leavetime`** |
| **Does equipment fit?** | *"Equipment fits"* | **`Proceed and load it`** → `Complete loading` |
| | *"Equipment doesnt fit"* | **`Coordinate with team to add trucking, change trucking, or out source trucking`** |

The chart also carries one bare annotation with no branch attached to it: **`Playbook needed`**,
sitting under the *Generate loading list* step — the yard flagging, on its own chart, that this step
has no written playbook. The SOP in §1 may be that playbook, written a month later; **the documents
do not say so.**

### What the three decisions actually tell you

- **`Dispatch confirms loading is ready` is the gate.** The yard does not start from the schedule;
  it starts from a dispatch confirmation. That is a handoff the DAS lifecycle
  ([daily-allocation-system.md](daily-allocation-system.md)) does not have — its states run
  `Allocation Completed → Ticket Sent → Load-out` with no yard-facing confirmation between ticketing
  and loadout.
- **Rigging is a shared, scarce pool that gets robbed from other cranes.** *"take from another crane
  that doesnt need it"* is a real allocation decision made in the yard, in the morning, outside any
  system. Compare [assets/tool-and-rigging.md](../assets/tool-and-rigging.md) and FCC's Tool List,
  which tracks rigging quantities out and in but — FCC states — *"does not currently pass to
  e-tickets; this is used for internal tracking only"*
  ([fcc-nexgen-dispatch-guide.md](fcc-nexgen-dispatch-guide.md) §10).
- **The crane may simply not be in the yard**, because it is on a holdover or a late return, and the
  yard resolves this by finding out its arrival time and comparing against leave time — *"come in
  before leavetime"* meaning the yard crew starts earlier. **Nothing in the vault models a crane's
  expected return time**, and holdover state is the largest acknowledged hole in the configuration
  rules ([crane-configuration-rules.md](crane-configuration-rules.md) §10).
- **"Does equipment fit?" is a trucking decision made after loading has started**, resolved by
  adding, changing or outsourcing trucking. That last option is the sub-out path
  ([dispatch-value-engine-and-playbooks.md](dispatch-value-engine-and-playbooks.md) §5) being
  triggered *from the yard, on the morning of the job* — not from dispatch, days ahead.

## 3. Against what the vault already holds

`yard-operations-jz.md` is a punch list against a built loadout screen. Read next to these two
documents, several of its lines stop being UI nitpicks and become process statements — but **it is
still a punch list and this page does not reinterpret it**:

| `yard-operations-jz.md` line | What these documents show behind it |
| --- | --- |
| *"Different assets can be loaded out at different times"* | the loading list is per **unit and load count**, with a **leave time** each |
| *"leave yard time should be first option"* | leave time is the fourth field of the loading list and the yard's scheduling key (§1) |
| *"print designs required"* | the loading list is **written down and sent to two chats** — there is no screen for it (§1) |
| *"if assets / people are not assigned – we should not be able to loadout that particular item"* | the yard's own gate is *"Dispatch confirms loading is ready"* (§2) |

**These are the same concern approached from two directions. Neither document states a rule for the
ERP, and this page does not derive one.**

## 4. Open — do not infer

- **What "dispatch confirms loading is ready" consists of**, and how the yard is told.
- **Who decides to rob rigging from another crane**, and whether that decision is recorded anywhere.
- **How the yard learns a crane's expected arrival time** when it is not in the yard.
- **Whether the `Playbook needed` note was closed** by the 2026-05-12 SOP.
- **Where the loading list lives after it is sent to the two chats** — it is written down, sent, and
  then apparently nowhere.
- The value engine is dated only by its sample folder (**2026-06-23**); the chart itself carries no
  date or author.

## Source

`shared-folder/Project-Repository-2026-09-04/`

- `TCG_Value_Engine_SAMPLES-ONLY/2026-06-23 samples/Daily loading value engine.pdf` — one landscape
  flowchart page, `pdftotext -layout`. **Connectors lost**; §2's branch structure is read from
  label text. No author or date on the chart.
- `TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/TCG Yard - Daily Loading - Running Daily Loading Report 2026-05-12.docx`
  — pandoc to GFM. Header block: created by **Dylan Masterson**, 2026-05-12, value engine
  *Daily Loading*, playbook owner Dylan Masterson, team **Yard**. Resources listed: *Microsoft
  Remote Desktop*, *NexGen FMS*. A SharePoint walkthrough-video link is in the source and is not
  copied here.
