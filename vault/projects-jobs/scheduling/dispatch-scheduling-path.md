---
title: Green / Yellow / Red — the permit-driven scheduling decision
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Dispatch_Scheduling_Path_Playbook.docx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/projects-jobs, module/dispatch, kind/sop, scheduling, permits, compliance]
entities: []
---

# Green / Yellow / Red — the permit-driven scheduling decision

**What this is.** The Crane Guys' *Dispatch Scheduling — Green / Yellow / Red Path Playbook*, "a
permit-driven decision guide for Sales Coordinators scheduling jobs with Dispatch". It is the
single most rule-dense document in the scheduling set: it defines a **permit clock** that excludes
most of the week, and it turns the answer into one of three paths with different handoff
procedures. Everything downstream — the Scheduling Sheet, the Job Schedule Master workbook's
automatic path calculation, the permit waiver — hangs off this.

## The master rule

> First identify the permitting city and its required lead time on the approved Permit Lead-Time
> Chart. Then calculate **only eligible permit-processing time**. **If the full applicable lead time
> is unavailable, the job is Red.**

## The permit clock — the rule that does most of the work

> The period beginning **Thursday at 12:00 noon** and continuing through the start of the normal
> business day on **Monday** **does not count toward any permit lead time**. Cities are treated as
> unavailable to process permits during this period.

Count permit-processing time **only** from Monday morning through Thursday 12:00 noon. **Do not
count Thursday afternoon, Friday, Saturday or Sunday.** The exclusion applies to Green, Yellow and
Red decisions alike.

That is roughly **3.5 countable days in a 7-day week**. The per-city notes show where the rule comes
from: a large share of these jurisdictions close on Fridays or alternating Fridays — see
[../city-permits/permit-acquisition-process.md](../city-permits/permit-acquisition-process.md) →
*The Friday problem*. The playbook itself does not explain the rule's origin.

### Worked examples the playbook gives

| Situation | Correct treatment | Path impact |
| --- | --- | --- |
| Request received **Thursday after 12:00 noon** | The permit clock does not begin until the start of business Monday | Do not count the weekend toward Green or Yellow eligibility |
| Job date crosses Friday or the weekend | Thursday afternoon through Sunday contributes **zero** permit-processing time | Use Red if the remaining eligible time is short |
| City requires longer than 72 hours | Use the exact city-specific lead time on the Permit Chart | Yellow only when the **full** listed time is available; otherwise Red |

The playbook is explicit that these examples show the **counting method** only — "the approved
Permit Lead-Time Chart remains the controlling source for each city's actual requirement."

**Which chart that is, is not stated anywhere in this drop.** Three mutually inconsistent lead-time
datasets arrived — see
[../city-permits/permit-lead-times.md](../city-permits/permit-lead-times.md).

## The decision, in order

1. **Identify the city** from the job-site address — the correct permitting jurisdiction.
2. **Check the Permit Lead-Time Chart** — does the city use the standard 72-hour requirement, or a
   longer city-specific requirement of more than 72 hours through 10 days?
3. **Calculate eligible time**, excluding Thursday noon → Monday start of business.
4. **Choose the path.**

**The fast question:** after excluding Thursday 12:00 noon through Monday morning, is the remaining
lead time **equal to or greater than** the city's charted requirement? YES = Green or Yellow
depending on the city. NO = Red.

## The three paths

| | **GREEN** | **YELLOW** | **RED** |
| --- | --- | --- | --- |
| Permit rule | Standard 72-hour city | City-specific lead time **over 72 h through 10 days** | Applicable Green or Yellow lead time is **not** available |
| Timing test | ≥ 72 eligible working hours before the job | ≥ the full lead time listed on the chart | Less than the applicable requirement |
| Scheduling Sheet | Add the job | Add the job | **Do not treat as automatically accepted** |
| Dispatch notice | **Email** complete job information | **Email** complete job information | **Call Dispatch and request approval**, then send documentation |
| Permit waiver | Not required under normal process | Not required under normal process | **Required from the customer before proceeding** |
| Dispatch result | Automatically scheduled through the normal workflow | Automatically scheduled through the normal workflow | **Schedule only after Dispatch approves the exception** |

### Green workflow

Verify city and timing and document the 72-hour requirement and the eligible-time calculation ·
complete the Ready-to-Schedule review including the quote number and all required job, customer,
timing, equipment, compliance and supporting information · add the job to the Scheduling Sheet,
**selecting the city so the permit requirement stays visible** · email Dispatch the complete job
information, clearly identifying it as **Green Path / standard 72-hour permit timing** · stay
available and correct missing information immediately.

**Dispatch action:** Dispatch automatically schedules the job through the normal process **and
obtains the permit** when a complete Green Path submission is received.

**Do not use Green:** if fewer than 72 eligible working hours remain, move the job to Red
immediately — "even if the job appears simple or the customer says a permit should be easy."

### Yellow workflow

Look up the **exact** city requirement — do not apply the 72-hour rule to a city with a longer lead
time · calculate eligible lead time excluding the full Thursday-noon-to-Monday closure · confirm the
remaining eligible time **meets or exceeds the full number of days** on the chart · complete the
Ready-to-Schedule review · add the job to the Scheduling Sheet with the correct city and permit lead
time · email Dispatch identifying it as **Yellow Path**, naming the city and the applicable lead
time · respond promptly to any permit issue Dispatch raises.

**Automatic move to Red:** "If the job is even partly short of the city-specific lead time, Yellow
is no longer available." Obtain the customer's permit waiver and follow the Red Path.

### Red workflow — in this order

1. **Identify the permit shortfall** — document the city, required lead time, available eligible
   time, and why the requirement cannot be met.
2. **Obtain the customer permit waiver** — the customer must acknowledge and accept the permit risk
   on the approved waiver, which is kept with the job records. See
   [../city-permits/permit-waiver.md](../city-permits/permit-waiver.md).
3. **Call Dispatch** — speak directly, explain job, timing, city, shortfall and waiver, and ask
   whether the job can be accepted.
4. **Receive Dispatch approval** — **do not promise the customer or treat the job as scheduled**
   until Dispatch approves.
5. **Document the approval** — who approved, date and time, and any conditions; retain the written
   confirmation or follow-up email with the job.
6. **Add the approved job to the Scheduling Sheet**, marked **Red Path / permit exception**, noting
   the waiver and the Dispatch approval.
7. **Email the complete job package** — job information, customer waiver, approval reference, all
   required attachments.
8. **Notify the customer** — confirm scheduling only after Dispatch approval, and communicate any
   permit-related conditions or risks.

**Automatic Red triggers:** any job with less than 72 eligible working hours of notice · a standard
72-hour city where the full 72 eligible hours are not available · a longer-lead-time city where the
charted requirement is not available · a request received Thursday after 12:00 noon where the
non-counting period makes the window too short · **any situation where the city, permit requirement,
job date or lead-time calculation is uncertain**.

**Two stop rules, verbatim:**

> A permit waiver does not automatically authorize the job. The waiver **and** direct Dispatch
> approval are both required before the Red Path job may be scheduled.

> **No silent scheduling.** Never place a short-notice job on the Scheduling Sheet and assume
> Dispatch will make it work. Call first, obtain approval, document it, and then complete the
> Red Path handoff.

**Escalation rule:** "When in doubt, do not guess and do not use the easier path. **Treat the job
as Red** until the city requirement, eligible lead time, and Dispatch approval status are confirmed."

## The Dispatch handoff email

The Scheduling Sheet entry and the Dispatch email **must agree**. The email must carry, at minimum:

path (Green / Yellow / approved Red exception) · customer name and quote number · jobsite/project
name and complete address · job date, **leave time, onsite time and anticipated duration** ·
customer and onsite contacts · crane/equipment and requested services · job description and
comments · **permitting city and required lead time** · **the lead-time calculation, including the
Thursday-noon-to-Monday exclusion where relevant** · required plans, photos, lift-plan information,
permits, compliance documents and other attachments · **for Red Path only:** the customer permit
waiver, the Dispatch approver, the approval date/time, and the approval conditions.

**Subject-line format:** `[GREEN / YELLOW / RED] – [Job Date] – [Customer] – [Quote Number] – [City]`

## Sales Coordinator final check

Correct city and permit jurisdiction confirmed · Permit Lead-Time Chart checked · Thursday 12:00
noon through Monday morning excluded · correct path selected · Ready-to-Schedule information
complete · Scheduling Sheet entry complete and accurate · Dispatch email sent with all required
information · if Red: waiver obtained, Dispatch called, approval documented, conditions communicated.

## Two places the sources disagree

- The **Value Engine – Sales Coordinator Scheduling** playbook describes the **Red Path** as
  "job falls within 72 hours (**Monday–Thursday before 12:00 PM Thursday**)" and the **Yellow Path**
  as "permit lead times exceed the standard window", with a **schedule placeholder** created and
  Dispatch emailed. This playbook makes Yellow a *satisfied* longer lead time and never mentions a
  placeholder. The two descriptions of Yellow are not the same rule.
- The Job Schedule Master workbook adds a **fourth** reason for Red that no playbook states —
  **crane unavailable** — and adds a reason for **Yellow** that no playbook states: an active permit
  carrying special operating restrictions is routed Yellow so the restriction text is reviewed. See
  [job-schedule-master-workbook.md](job-schedule-master-workbook.md).

## Source

`3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Dispatch_Scheduling_Path_Playbook.docx`
— ~12.3 KB, `.docx` → pandoc GFM. Heavily table-formatted; the callout boxes rendered as
single-cell tables and are quoted above as block quotes. No version number, author or date on the
document itself.
