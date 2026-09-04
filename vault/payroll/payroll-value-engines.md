---
title: Payroll value engines — the weekly payroll flow, the payroll playbook, and the certified-payroll loop
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/WORKFLOWS_VALUE_ENGINES/ and TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/zzzOTHER/FLOWCHARTS_VALUE_ENGINES/
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/sop, certified-payroll, time-tracking, adp, legacy-payroll-app, compliance]
entities: []
---

# Payroll value engines

**What this is.** Three Visio flowcharts of how TCG actually runs payroll, drawn in **August and
September 2025** — before the ERP engagement, before the Payroll App, and a year before the
[ADP SOP v3.8](adp-sop-v3.8.md). They are the process-level companion to the rule documents in this
folder: not *what the numbers should be*, but *who touches payroll, in what order, and where it can
go wrong.*

**Why they matter.** Every other payroll document here describes calculation. These describe the
**people and the hand-offs** — GPS verification against Samsara, the crane-supervisor escalation
path, the payroll-manager audit, the employee-disagreement loop ending in a business agent, and
the retro-check path. Several of those roles and steps appear in **no other vault document**.

> **A note on the filenames, because it will mislead you.** `TCG_VE_PAYROLL_CERTIFIED.pdf` is
> **not** about certified payroll. Its own title block reads **"The Crane Guys Payroll Playbook"**
> and it charts the ordinary weekly payroll run (§2 below). The certified-payroll flow is
> `TCG_VE_PAYROLL_02_2025-09-12.pdf` (§3). Both names are used consistently across the two folders
> that carry these files, so the mislabelling is in the source, not the drop.

## 1. `TCG_VE_PAYROLL_01` — the weekly payroll flow (2025-08-16)

The earliest and simplest of the three; a single left-to-right lane.

**Collect Paperwork** (check FCC-NexGen for complete tickets) → **Dispatch Sheet Copied** →
*Missing?* → **Match Times in FCC-NexGen** → **Confirm Job Unit** → **Enter Hours in Excel** →
**Boom Pay / DT / OT** → **FCC-NexGen** → **Email Reports to Accounting** → **Distribute Checks**.

Two branches hang off it:

- **Time verification.** A parallel **Verify Times via GPS** step feeds *Time is Correct?* — on
  **No**, *"Reach Out to EE & Crane Supervisor"*.
- **Missing paperwork.** On *Missing? → Yes*, two escalations: **Reach Out to EE** and **Reach Out
  to Crane Supervisor**.

The tail is the interesting part: after **Distribute Checks**, *EE Paid Correctly?* On **No** →
**Call Payroll** → **Check Reissued** → *EE Paid*. And a separate terminal box, off to the side:
**Weekly Certified Payroll Processed & Submitted**.

**What this shows:** as of August 2025 the flow is *FCC → Excel → back to FCC → email to
accounting*. ADP is not in the chart at all. The hours are entered **in Excel**, and boom pay, DT
and OT are applied there — which is the process the
[ADP SOP v3.8](adp-sop-v3.8.md) and the workbooks later formalise, and which the ERP replaces.

## 2. `TCG_VE_PAYROLL_CERTIFIED` — "The Crane Guys Payroll Playbook" (undated; `.vsdx` alongside)

Despite the filename, this is the **mature weekly payroll run** with nine numbered SOPs. It is the
richest of the three and the only one that names ADP.

**The main line:**

| # | Step | SOP |
| --- | --- | --- |
| 1 | **Check Samsara Sheet [2025], Job Ticket & GPS Times to Verify Times** | SOP #1 |
| 2 | *Info Correct?* → **No** → **Research Job Ticket Times / Notes / Reach out to Crew & Crane Super** | SOP #4 |
| 3 | *Changed Time?* → **Yes** → **Verify Time Change & Note Time Change** → **Once Time is Adjusted then Notify Crane Super** | SOP #2 |
| 4 | → **Time is Approved and Noted in Samsara Sheet [2025] & FCC** | |
| 5 | **Use Payroll Dashboard Audit Tool** | SOP #2 |
| 6 | **Separate Hours / Boom Pay & Union Rules in Payroll Excel** | SOP #3 |
| 7 | **Payroll Manager Audit** → *Edits?* → **Yes** → **Manager Marks Findings on Payroll Sheet & Payroll Clerk Reviews & Updates** | |
| 8 | *Edits? → No* → **Process Payroll in ADP** | SOP #5 |
| 9 | → **Process Payroll in FCC** | SOP #6 |
| 10 | → *(connector)* → **Generate & Send Reports to / for Accounting** → **Handout Checks** | |

**The exception path**, which is where the process documentation is unusually candid:

**Check Errors?** → **Yes** → **Ask EE for their Breakdown** → **Review Hours / Payroll Excel with
EE** → *Disagreement* → **Involve: (a) Crane Super (b) Ownership** → *Resolve?*
→ **Yes** → **Update Payroll Excel & in FCC** (SOP #8) → **Process Retro Check through ADP** →
**Email Accounting Check Info** (SOP #9).
→ **No** → **Call BA** → **Discuss Resolution with EE & BA** → back into *Resolve?*

Five things worth extracting:

1. **Samsara is the GPS time source**, and it is checked *first*, before the job ticket is trusted.
   `PAY-017` (time-source selection) records the question of which time source wins; **this chart
   answers it for the manual process** — GPS verifies, the job ticket is the claim, and a change
   requires the crane supervisor to be notified. Samsara appears nowhere else in the payroll folder.
2. **Payroll runs in ADP *and* FCC** — two separate numbered SOPs (#5, #6), in that order, after the
   same audit. Both systems are written to every week.
3. **A "Payroll Dashboard Audit Tool"** sits between time approval and the Excel work. Named nowhere
   else; unexplained.
4. **The escalation ladder for a disputed check is written down**: employee → crane supervisor →
   ownership → **BA** (business agent — the union representative). That an unresolved payroll
   dispute goes to the union BA is a fact about the process that the union-issue value engine (§4)
   also documents from the other direction.
5. **The retro check exists today, and it goes through ADP** (SOP #8 → #9). This is the manual
   version of the delta-adjustment mechanism the
   [dependency matrix](payroll-rule-dependency-matrix.md) §13 proposes and
   [PAY-068](rules/PAY-068-retroactive-correction.md) has never specified — **there is an existing
   business process to model it on.** The chart does not say how the retro amount is computed.

## 3. `TCG_VE_PAYROLL_02` — the certified-payroll loop (2025-09-12; `.vsdx` alongside)

Two lanes for the same process, distinguished only by when TCG found out.

**Lane A — Notified Before Job Start.** **Salesperson Notification / FCC Check** (SOP #1) → *Yes* →
**Add to CPR Tracker** (SOP #6) → **Contact Customer Payroll/Contact** → **Payroll Compliance
Packet & Complete Start Job Forms** (SOP #2) → **Run Certified Payroll Report** (SOP #3) →
**Report Weekly Labor & Internal Tracker** (SOP #4) → *Non-Performance Weekly / End of Job?* →
**Yes** → **Generate CPR Report & Request Check Stubs** (SOP #5) → **Confirm w/Customer if Job
Complete & Check w/Salesperson** → *Yes* → **Close Out** (SOP #6); *No* → **Repeat Until Close Out**.

**Lane B — Notified After Job Start.** **Customer Non-Compliant Email Request** (SOP #7) →
**Verify with Sales & Accounting – Billing** → then the identical chain: Payroll Compliance Packet
(#2) → Run Certified Payroll (#3) → Report Weekly Reports & Tracker (#4) → Generate CPR Report &
Request Check Stubs (#5) → **Confirm if Job Complete & Close Out if Done** → Close Out (#6).

**What this adds** to the [Certified Payroll Playbook](certified-payroll-playbook.md):

- A named artefact, the **CPR Tracker**, plus an **internal tracker** for weekly labor — two
  registers, distinct from the customer-facing CPR report.
- A **weekly cadence with a non-performance branch**: the loop runs every week whether or not there
  was work, and only *End of Job* or a customer confirmation exits it.
- **Check stubs are requested as part of generating the CPR** — CPRs need per-employee pay evidence,
  not just hours.
- **Close-out requires two confirmations** — the customer *and* the salesperson.
- **`SOP #7` is the recovery path**, and its trigger is a *"Customer Non-Compliant Email Request"* —
  i.e. TCG usually learns it needed certified payroll because the customer chases it. That is the
  failure mode the playbook's intake checklist exists to prevent.

## 4. `Union issue Value Engine` (2026-06-23 samples)

A short swimlane chart — lanes **Union**, **Kyle**, **HR**, **Field** — for how a union question
gets answered.

**Contacted by** (HR or Field) → *Union handbook have answer?* → **Yes** → **Employee given area in
book to reference** → resolved. → **No** → **Contact union rep** → **Get answer from union** →
**Communicate with employee** → *Employee understands/agrees?* → **Yes** → **Issue resolved**. →
**No** → **Union notified and contacts employee** → *Employee understands/agrees?* → **Yes** →
resolved; → **No** → **Possible grievance**.

Small, but it records three things: a **union handbook** is the first-line reference; **Kyle** is
the named individual who owns union questions (the same Kyle whose lattice answers are recorded in
[client-message-findings.md](client-message-findings.md)); and the terminal state of an unresolved
union question is a **grievance**. Read alongside the payroll playbook's *Call BA* branch (§2),
these are the two documented routes by which a pay dispute leaves TCG's own process.

## Source

| File | Format | Note |
| --- | --- | --- |
| `1.0.1_BUSINESS-REQUIREMENTS/WORKFLOWS_VALUE_ENGINES/TCG_VE_PAYROLL_01_2025-08-16.pdf` | PDF, 1 page | `pdftotext -layout`; §1 |
| `1.0.1_BUSINESS-REQUIREMENTS/WORKFLOWS_VALUE_ENGINES/TCG_VE_PAYROLL_CERTIFIED.pdf` | PDF, 1 page | §2. **Filename misleading** — title block says "Payroll Playbook" |
| `1.0.1_BUSINESS-REQUIREMENTS/WORKFLOWS_VALUE_ENGINES/TCG_VE_PAYROLL_02_2025-09-12.pdf` | PDF, 1 page | §3 |
| `TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/zzzOTHER/FLOWCHARTS_VALUE_ENGINES/` | 3 PDF + 2 VSDX + 3 images | **Byte-identical duplicates** of the three PDFs above, plus the `.vsdx` originals of §2 and §3 and three raster exports |
| `TCG_Value_Engine_SAMPLES-ONLY/2026-06-23 samples/Union issue Value Engine.pdf` | PDF, 1 page | §4 |

The `.vsdx` files convert to bare Visio shape text with no geometry, so **arrow direction and
branch labels in §2 and §3 are read from the `-layout` PDF renderings**, where the spatial layout
survives; the `.vsdx` text was used only to confirm the shape inventory matches. The three raster
exports (`TCG_VE_PAYROLL_2025-08-16.jpg`, `TCG_VE_PAYROLL_2025-09-12.png`,
`TCG_VE_PAYROLL_CERTIFIED_2025-09-12.png`) were **read visually on 2026-09-04**. The two PNGs are
not renderings of the Visio charts — they are **photographs of the physical whiteboards the charts
were drawn from**: `…PAYROLL_2025-09-12.png` is the board headed *"Crane Guys Payroll Playbook"*
with the SOP #1–#9 stickies of §2 (it also carries three stickies the Visio dropped — *"Call BA"*
[business agent] → *"Discuss resolution with EE & BA"* on the dispute path, *"Involve crane super
— B. ownership"*, and a lower lane *Hand out checks → Check errors → No change* / *Ask EE for
their breakdown → Review hours/payroll Excel with EE → Dispute → Resolve*); and
`…PAYROLL_CERTIFIED_2025-09-12.png` is the board with the two lanes *"Notified Before Job Start"*
and *"Notified After Job Start"* of §3, sticky for sticky. The JPEG (`…2025-08-16.jpg`) is a raster
of the §1 chart. Every step in §2 and §3 is confirmed against the boards; no correction needed.
