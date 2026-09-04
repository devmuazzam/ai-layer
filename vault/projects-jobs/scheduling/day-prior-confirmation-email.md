---
title: Day-prior customer confirmation email
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Playbook_-_Day_Prior_Automatic_Email_v2.docx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/projects-jobs, module/dispatch, module/customers, kind/sop, scheduling, notifications]
entities: []
---

# Day-prior customer confirmation email

**What this is.** *THE CRANE GUYS — Day-Prior Customer Confirmation Email: Outlook Template and
8:00 A.M. Scheduled Send Process*, Executive Playbook **Version 2.0**. It standardises the last
customer touchpoint before a job: a confirmation email that goes out at 08:00 the day before, with
Dispatch copied, giving the customer one final chance to report a change before the crew mobilises.
**It is entirely manual and runs on Outlook's scheduled-send feature.** Nothing in the drop
suggests an automated version exists.

## The operating rule

> **Prepare the email when the job is scheduled and set it to send at 8:00 a.m. on the calendar day
> before the job. Dispatch must be included in CC on every email.**

Restated as three standard rules: schedule the email for 08:00 the day before the job · always place
the **approved Dispatch mailbox or distribution address** in CC · for same-day or next-morning jobs
scheduled too late for the normal process, **send the confirmation immediately and notify Dispatch**.

The playbook flags the obvious failure mode explicitly: **"Outlook does not know the job date
automatically. The Sales Coordinator must select the correct calendar date and 8:00 a.m. delivery
time for each job."**

## Information required before the email is scheduled

**"Do not schedule an incomplete email."** Twelve items:

`Customer contact name and email address` · `Approved Dispatch email address in the CC field` ·
`Job number or quote number` · `Customer and project or job-site name` · `Confirmed job date` ·
`Leave-yard, arrival, or on-site time, as applicable` · `Complete job-site address` ·
`On-site contact name and phone number` · `Crane or service being provided` · `Brief scope of work` ·
`Access, parking, gate, PPE, or check-in instructions` · `Required attachments, when applicable`

## Creating and scheduling it in Outlook

**Template** — compose the standard subject and body, put the Dispatch address in CC, then save it:
in New Outlook / Outlook on the web via *Message → Mail template → Save email as template*; in
classic Outlook via *File → Save As → Outlook Template (.oft)*. Name it **"Day-Prior Job
Confirmation"**. Replace every bracketed placeholder before scheduling.

**Scheduling — New Outlook / web:** open the template, enter the customer address, confirm Dispatch
is still in CC, replace all placeholders, then *arrow next to Send → Schedule send → Custom time*,
choose **the calendar day immediately before the job** at **08:00**, Send. **Open Drafts and verify
the message shows the correct scheduled date and time.**

**Scheduling — classic Outlook for Windows:** open the template, enter the address, confirm CC,
replace placeholders, then *Options → Delay Delivery → Do not deliver before*, set the day before
the job at 08:00, Close, Send. Confirm the message appears in the Outbox. **Classic Outlook must be
open and connected for the delayed message to send.**

## Final quality check

`Correct customer in To` · `Dispatch included in CC` · `Correct job date and time` ·
`Correct address and on-site contact` · `Correct crane or service` · `Required attachments included` ·
`All placeholders removed` · `Scheduled for 8:00 a.m. on the day before the job`

## The email itself

Subject line format: **`Job Confirmation – [Customer / Project Name] – [Job Date]`**

The body confirms tomorrow's job and asks the customer to notify TCG immediately if anything has
changed, then lists: **Job Date · Arrival / On-Site Time · Project / Job-Site Name · Job-Site
Address · On-Site Contact (name and phone) · Crane / Service · Scope of Work · Special Instructions
(access, parking, PPE, gate, check-in or other)**.

Two sentences in the template do commercial work and are worth quoting:

> Please confirm that the information above is correct and that **the site will be ready for our crew
> and equipment**. Changes to the date, time, location, scope, crane requirements, permits, lift
> plans, traffic control, or third-party services **may affect availability and may result in
> additional charges**.

> Dispatch has been copied so our operations team has the same confirmed information.

## Exception handling

| Situation | Required action |
| --- | --- |
| **Same-day job** | Send the confirmation immediately and notify Dispatch |
| **Customer changes the job** | Edit or cancel the scheduled email, update the scheduling sheet, review cost impacts, notify Dispatch, and send a corrected confirmation |
| **Job canceled** | **Cancel the scheduled email immediately** and follow the cancellation process |
| **Permits, lift plans or third parties affected** | Follow the Schedule Change playbook and obtain customer approval for applicable additional charges **before** confirming the change |
| **Scheduled send unavailable** | Send manually at 08:00 the day before, and report the Outlook issue to the appropriate administrator |

## Roles

**Sales Coordinator** — create and schedule the email · verify every job detail · always CC Dispatch ·
update or cancel the email when the job changes · document customer responses and communicate
changes to Dispatch.

**Dispatch** — review copied confirmations for operational changes · respond when customer
information conflicts with the dispatch schedule · **use the email as supporting job documentation**.

**Sales Manager / Supervisor** — audit compliance · correct repeated missed confirmations,
inaccurate information, or missing Dispatch copies.

**Manager audit:** email scheduled for 08:00 the day before · Dispatch copied · job details complete
and accurate · customer changes documented and communicated · **scheduled email updated or canceled
when the job changed**.

**Success standard:** "Every scheduled job receives a clear customer confirmation at 8:00 a.m. on
the day before the job, Dispatch is copied, all job details are accurate, and **customer changes are
identified before mobilization**."

## What this implies but does not say

The playbook is a manual workaround for a notification the product could send. It names the exact
payload (12 fields), the exact timing (08:00 the day before), the exact recipients (customer, CC
Dispatch), and the exact cancel/amend rules. **It does not say that the ERP should take this over,
and no source in the drop says so** — but this is the most fully specified customer notification in
the whole scheduling set, and the fields it needs are the same ones the Scheduling Sheet already
collects (see [ready-to-schedule.md](ready-to-schedule.md)).

## Source

`3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/The_Crane_Guys_Playbook_-_Day_Prior_Automatic_Email_v2.docx`
— ~7.4 KB, 13 sections, `.docx` → pandoc GFM. Marked "Executive Playbook | Version 2.0".
Version 1 is not in the drop.
