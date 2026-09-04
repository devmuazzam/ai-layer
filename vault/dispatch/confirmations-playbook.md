---
title: Confirmation procedures — how dispatch confirms tomorrow's jobs
source: shared-folder/Project-Repository-2026-09-04/TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/TCG Dispatch - VALUE ENGINES and PLAYBOOKS/Confirmation Procedures - Copy.docx (+ its cover sheet TCG Dispatch Confirmations - .docx)
migrated: 2026-09-04
updated: 2026-05-14
status: unverified
conflicts_with: []
jira: []
tags: [module/dispatch, module/customers, module/projects-jobs, kind/sop, scheduling, permits, notifications, compliance, lift-plans]
entities: []
---

# Confirmation procedures — how dispatch confirms tomorrow's jobs

**What this is.** `Confirmation Procedures - Copy.docx` — the written procedure behind the
**Confirmations** playbook, owned by **Lisette Anzaldo**, created 2026-04-01 and last updated
**2026-05-14**. It is the longest operational document in the dispatch group and the only one that
describes the daily confirmation round step by step, with named deadlines.

The rule it implements, from its cover sheet: ***"All jobs must be confirmed the business day
before the job is schedule either by email or call."***

**Why it matters.** *Customer Confirmation Tracking* is one of the fourteen dispatcher needs
([dispatcher-needs.md](dispatcher-needs.md)) and `Confirmations` is a named box on both value-engine
charts ([dispatch-value-engine-and-playbooks.md](dispatch-value-engine-and-playbooks.md)). Neither
says what confirming a job *consists of*. This does — and it turns out to be a data-validation pass
over the job, not a phone call.

> **Current manual practice.** Every step runs on the phone, on email, and against a shared Excel
> "Daily Sheet". Nothing here has been specified for the ERP.

> **Customer contacts not copied.** The source's second half is a per-customer email directory —
> roughly **60 named individuals at nine customer organisations**, with their email addresses, plus
> onsite-contact names and mobile numbers in the worked examples. **None of it is reproduced here.**
> §5 records the customer names, the routing rules and the message shape only. The directory is in
> the source file.

---

## 1. Before calling anyone

- ***"Review the job and read all the details carefully to ensure clarity."***
- **Check Attachments.** If attachments are missing, contact the Project Manager if one is needed;
  if not needed, **note it in the comments** — the stated wording is `No layout needed`.

## 2. The confirmation call

Call the **`Ordered By`** contact — the document names it *"the 'order by' contact"*, the same field
FCC carries on the job ([fcc-nexgen-dispatch-guide.md](fcc-nexgen-dispatch-guide.md) §2).

**Always confirm these seven, listed as a block in the source:**

`Jobsite address` · `Time` · `PO#` · `Onsite contact` · `Crane size` · `Riggers` · `Trucking`

### Job site details to verify

- **Job site address.**
- **Setup location — private property or the street?** If the street: *"do we have street permits?
  If so, are they attached?"* If not, **ask the customer for a copy immediately**, then *"verify
  that our crane is covered under the permits provided and traffic control will be provided."*
- **For PM-assigned jobs**, if the PM has noted a street setup, check the permits are attached and
  **ask the PM before asking the customer**.
- **If the setup is on the street, ask whether the customer has traffic control**; if so, request a
  copy of the permit or plan.
- **Obstructions** — *"Are there power lines, trees, or other obstacles? Ideal response no
  obstructions, if there is we might have issues please make sure to run that with Dispatch,
  Superintendent or a project manager."*

> Two things worth noting for the ERP. First, **a permit that TCG did not obtain still has to be
> validated against the specific crane going out** — coverage is not assumed from the permit's
> existence. Second, **traffic control is a separate provision from the permit**, and both are
> confirmed on the same call. The permit checkbox set the client asked to replace with *"an
> expandable checklist covering travel permits, lift plan, safety, FAA"*
> ([erp-review-log.md](../erp-review-log.md), 2026-05-05 extraction) would have to carry the
> *provided-by* dimension to capture this.

## 3. Trucking details

Asked whenever trucking is on the job:

- **What are we hauling?**
- **Confirm the dimensions of the load** to determine the trailer type, if not already specified.
- **Legal or oversized?** The thresholds are stated:
  - **over 8'6" in width is oversized**
  - **over 14' in height *loaded* (overall height) is oversized**
- **If oversized, oversized permits are needed and *"they usually take 3-5 days to process."***
- **If hauling AC units:** check whether the units are stored at the TCG shop and going out to a
  jobsite — if so, confirm the jobsite address and **request the yard field to load the specific
  units**, with *"the yard manager coordinat[ing] with customer which unit."*
- **Point A to point B moves: get both addresses.**
- **Legal loads need no permit; for oversized, confirm the address matches the permit.**
- If no units are stored at the shop, ***"clarify what the trucking is for"*** — and if TCG is
  hauling for the customer, **get the dimensions from the customer** to establish it is not
  oversized.

> The **3–5 day oversized-permit lead time** is the only numeric permit lead time stated in any
> dispatch source, and it sits directly against the sales-side board's 72-hour Green/Yellow/Red
> banding ([dispatch-value-engine-and-playbooks.md](dispatch-value-engine-and-playbooks.md) §3).
> **The two are not reconciled anywhere** — 3–5 days exceeds 72 hours, so an oversized haul appears
> to be a Yellow Path job by definition, but no source says so.

## 4. When the customer does not answer

- **Leave a voicemail** and note **`LM`** *(Left Message)* **next to the equipment required.**
- If an email address is available, send a confirmation email or request a call back, and note
  **`Sent Email` next to the crane size.**
- **Note any missing information** — the stated example: *"Need onsite time/contact/PO#"* — so that
  *"in case the customer returns the call later anyone else can assist and fill in the
  information."*

### Second round

- **Call everyone who has not confirmed.**
- No answer → *"Look up an email, call the company office number, or call the onsite contact (if
  available)."*
- ***"By 1:00 PM, if there's still no response, reach out to the PM."***
- **Clean up the job notes** — the stated example: change `90 Ton + Rigger (missing info/pending
  permit)` to `90 Ton + Rigger` once updated.
- **Confirm the needed documents are attached**: lift plans, job layouts, permits, or other
  job-related documents.
- **Follow up with PMs** — *"If a PM hasn't responded to a text, call them directly."*

### The deadline

***"By 1:30 PM, ensure all confirmations are completed and jobs are ready to be dispatch."***

> **1:00 PM escalate to the PM, 1:30 PM everything confirmed** — the day before the job. Together
> with the sales-side board's **8:00 AM day-prior arrival email to the customer** and the
> **12:00 PM cutoff for daily dispatch emails** (§5), these are the only clock times dispatch
> operates to that are written down anywhere in the vault.

## 5. Cancellations and date changes

- **If a job is cancelled during confirmation, notify the PM if one is assigned.** The stated note
  format goes in `Inhouse`: *"Jorge canceled during confirmation call on 10/27/26."*
- **If a customer reschedules, check availability first** — or confirm with Dispatch — **before
  agreeing to a new date.**
- ***"Confirm if any charges will apply and inform customer and PM to make sure the customer is
  aware of charges."***

That last line is the confirmation-side counterpart of the sales-side board's *"Send Accounting a
bill to charge for any Permit Costs, Rescheduling Fees and Email Customer"*
([dispatch-value-engine-and-playbooks.md](dispatch-value-engine-and-playbooks.md) §3). **Two
documents, two departments, the same rescheduling charge — and neither states what the charge is or
when it applies.**

## 6. Reconciling against the Daily Sheet

The step that ties confirmation back to the dispatch sheet
([dispatch-sheet-workbook.md](dispatch-sheet-workbook.md)):

- **Verify the crane size requested against the crane size assigned** — *"if it looks odd, ask
  questions."* The worked example: **a 90-ton job with a 265-ton assigned**, in which case confirm
  1. the **travel permit is approved for the assigned crane**, 2. the **in-house notes show all
  cranes pre-approved by the PM**, and 3. **whether any extra loads are required.**
- Once confirmed, **update the Daily Sheet and tell Dispatch what is confirmed and what is
  pending.**
- **If anything cancels during confirmation, tell dispatch.**
- **If jobs are missing from the Daily Sheet, add them and tell Dispatch** — stated example:
  *"If a rigger is required but not listed, add it."*
- **Note screenshots / job layouts, restriction lists, or paperwork on the Daily Sheet** — i.e.
  populate the `P/LP/RL/SS` column ([crane-configurations.md](crane-configurations.md) §2).
- **After reviewing all jobs, text or email each PM about missing details for their jobs.**

> The 265-for-90 example is a small but load-bearing observation: **substituting a larger crane
> re-opens both the permit question and the counterweight configuration.** That is the same
> coupling `crane-configuration-rules.md` §5.4 describes from the sales side — sales picks the
> counterweight, dispatch decides how to haul it — arriving here as a confirmation-time check.

## 7. Email-only customers

**Nine customers are confirmed by email only, never by call**, each with its own routing, subject
format and send window. Named in the source:

`Southern California Edison` · `Hotline Construction` · `Western Construction Specialists` ·
`City Light & Power (CLP)` · `Faith Electric` · `Ferreira Power West` ·
`Los Angeles Department of Water and Power (LADWP)` · `PAR Western Line Contractors` ·
`Asplundh Construction`

**All of these are utility and utility-contractor accounts.** The recipient lists, CC lists and
contact details are in the source and **are not copied here**; the *rules* are:

| Rule | Detail |
| --- | --- |
| **Hard send deadline** | ***"EMAILS MUST BE SENT BEFORE 12:00PM"*** — printed against seven of the nine |
| **Weekend batching** | *"On Friday's we send an email for Saturday, Sunday and Monday together in one email"* (Edison, Asplundh). CLP is batched differently: **Tue–Fri sent on Monday, Sat–Mon sent on Friday** |
| **Empty-day policy differs per customer** | Hotline and CLP **do** send "No job scheduled" lines for each empty day; Western, PAR, Faith and Ferreira explicitly do **not** — *"ONLY send emails if we have jobs scheduled"* |
| **Threading** | Hotline: *"Reply all to the email from the previous day to keep it all under the same email chain"* |
| **Recipient rule varies** | some go to a fixed dispatch mailbox, some *"to the contact who ordered the crane"*, Faith *"to the onsite contact only"* |
| **Standing CC list** | a fixed internal group on every one, plus **RCS Safety dispatch CC'd whenever the job has RCS** |
| **Permits from the traffic-control provider** | Western and PAR are annotated *"Must get Permits/Closure from RCS"* |
| **Subject-line format is per customer** | e.g. `Scheduled Jobs for 8/10`; `Job Scheduled for Tuesday 7/5`; `<Customer> – TCG Daily Dispatch Emails`; `TD1376090 - 931 Wandering Dr - 7/9`; `TD1704411 - 8399 San Carlos Way – 1/1` |

**The body is a fixed seven-line shape**, identical across all nine (values below are the source's
own examples, not real jobs):

```
<Day and date>
- <crane size> Crane
- <job site address>
- <customer reference numbers, e.g. TD…, STR#…, Par#…, CR-…, Order#…, Request#…>
- Crane on site at <time>          (Asplundh uses "Crane hook ready at <time>")
- (<qty>) <crane size>             (sometimes "+ Support Load", "+ RCS", "+ Rigger")
- Permits handled by <TCG|others> and traffic control handled by <customer|others|WESTERN|PAR|CLP>
- Onsite contact, <name and phone>
```

Two variants appear: *"Setting up on private property"* replaces the permits/traffic-control line
where neither applies, and **`please provide onsite contact.`** is used as an in-band request when
the contact is unknown.

> **This is the most specified customer-facing output in the whole dispatch group**, and none of it
> exists in the ERP record. Note what the message actually carries: crane size, quantity, customer
> reference number, on-site time, **who holds the permit and who holds traffic control**, and the
> onsite contact. Whether the ERP should generate these, and whether the per-customer routing rules
> become configuration, is **unstated everywhere**.

## 8. Open, and not to be inferred

- **What the rescheduling charge is**, and when it applies.
- **How the 3–5 day oversized permit lead time relates** to the 72-hour Green/Yellow/Red banding.
- **Whether the nine email-only customers are a fixed list or a customer-level flag.** The document
  reads as a list maintained by hand.
- **What `LM` and `Sent Email` are noted *on*** — the wording is *"next to equipment require"* and
  *"next to the crane size"*, which points at the Daily Sheet cell, but the document does not say.
- **Who does this work.** The document never names a role; the cover sheet names Lisette Anzaldo as
  playbook owner, and the process references "Dispatch" in the third person throughout — so the
  confirmer may not be the dispatcher.

## Source

`shared-folder/Project-Repository-2026-09-04/TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/TCG Dispatch - VALUE ENGINES and PLAYBOOKS/`

- `Confirmation Procedures - Copy.docx` — converted with pandoc to GFM. One screenshot (the Daily
  Sheet) not carried. **The conversion mangled the document's mailto links** — displayed addresses
  and link targets do not correspond — which is one more reason the contact directory is not
  transcribed here.
- `TCG Dispatch Confirmations - .docx` — the cover sheet: owner **Lisette Anzaldo**, created
  2026-04-01, updated 2026-05-14, team Dispatch, all five step slots blank, *Resources* pointing at
  the file above.
