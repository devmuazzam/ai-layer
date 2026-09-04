---
title: Sprint demo — mobile quoting, payroll module, and crew configuration (2 September 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-09-02_ERP Job Tickets and Payroll - transcript.docx"
migrated: 2026-09-04
updated: 2026-09-02
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, module/quotations, module/dispatch, module/field-ops, module/assets, kind/meeting-notes, craft-code, craft-modifier, boom, signatures, daily-allocation, time-tracking, sprint-planning]
entities: [quotation, docusign, craft-code, craft-modifier, premium, job-ticket, oiler, rigger, operator-load, resource-type]
meeting_date: 2026-09-02
---

# Sprint demo — mobile quoting, payroll module, and crew configuration — 2 September 2026

Curated from [transcripts/2026-09-02-erp-job-tickets-and-payroll.md](transcripts/2026-09-02-erp-job-tickets-and-payroll.md)
(1 h 5 m). Present: ehtesham.anwar, Joe Schacatano, Abdul Rehman, Corrina Bustos, Brian Petros,
Wes Staley, Melissa McNutt, syed.haris. Ryan and Lisette absent — Brian sent them the recording.

> **Forward-looking.** Client statements in a live demo are asks and reactions, not signed
> requirements. Every item below that needs a decision says where it is now registered.

## What was demonstrated

**Mobile quotation, end to end** — salesperson creates a quotation on the phone (customer or new
customer, job site, line items with the hierarchy shown, operator load), submits for approval;
sales manager approves on mobile; status returns to the salesperson as *internal approved*; the
same quotation is live on the web in real time; DocuSign goes out, the webhook lands and flips the
status to signed over sockets; a project and job are created from it. Mobile is Android-only until
the Apple account clears, and lacks the socket refresh the web has (a manual refresh button for now).

**Payroll module, partially live** — craft codes with labels, assignment to employee types/roles
and to individual employees (primary or secondary); **craft modifier brackets generated from a
start length, an end length and a step** (demoed as 80 ft → 520 ft in 20 ft steps, +0.75/hr
operator, +4.25/hr oiler, later rows auto-calculated); payroll premiums with a *show on dispatch*
flag; and a full path from DAS assignment → mobile logging (rigger, oiler, operator) → priced
slices in the payroll module with ST/OT and long-boom hours segregated.

**A known calculation defect was demoed and named:** total shows **6 hours where the mobile logged
5** — the yard-departure and job-site-arrival 30-minute segments are being counted twice. Abdul
says it is understood and being fixed.

## Product questions raised, and where each went

**1. DocuSign is not TCG's voice — Joe.** *"It's not us, it's not our voice."* He wants the
signing email to appear to come from the salesperson while keeping digital signing. Ehtesham
offered **Outlook integration so the system sends from the individual's own address** before the
first scope closes, with a **customer portal** (quotation, first-time-customer packet, signing)
planned after it. Registered in [quotations/gaps.md](../quotations/gaps.md).

**2. The quote should pre-populate from Resource Types — Joe, unprompted.** *"You need to share
with them the pictures of the resource types, which is how the quotes populate currently, because
that's how they should be populated on the quotes. And the additional items like the riggers, we
can add them specific to the job. We don't want that to populate."* Brian initially called the
tab *schedule types*; Joe corrected him — **resource types**. This is the module owner asking for
exactly the FCC estimate-template behaviour recorded in
[quotations/fcc-estimate-templates-by-job-type.md](../quotations/fcc-estimate-templates-by-job-type.md),
and it is the strongest sourcing that entry has. Ehtesham put *"schedule types vs asset
configurations"* on the next day's agenda.

**3. Premiums belong to the job, not the employee — Brian.** Lattice, military and shift adders
are currently shown as if attached to an employee; *"it needs to be at the job level."* Joe went
further and gave the trigger rules: **a crawler on the job populates lattice pay**, and federal
wages populate only when **certified payroll / federal job is checked at the quoting stage or on
the job** — not as a dispatch-time pop-up. Ehtesham added that some of this may belong on the
**customer profile** too. Registered in [payroll/gaps.md](../payroll/gaps.md).

**4. Craft-rate changes are annual and should be applied in bulk — Corrina.** Effective-dated
rates are built (adding a rate auto-ends the previous one the day before). Her ask: *"there's nine
different craft codes for everyone in Local 12 — do we have to go into each one separately, or can
we do one mass change?"* The rule is the union handbook's **1 July** annual change; she will send
the handbook verbiage. Ehtesham: buildable if the rule is written down. Registered in
[payroll/gaps.md](../payroll/gaps.md).

**5. Craft assignment needs history — Brian and Corrina.** *"They were this craft code from this
date to this date"* — Corrina compares it to ADP's automatic change history (what changed, when).
Registered in [payroll/gaps.md](../payroll/gaps.md).

**6. The oiler who also rigs — Wes.** A third man drives the support load and rigs on site. Joe's
position: it changes neither dispatch nor pay, so it belongs in the **note / description of work
on the ticket**, or possibly a *third man acts as rigger* checkbox at quoting — not a combined
"oiler/rigger" resource, because a combined label tells the employee nothing about which role they
are doing. Wes's concern is that the ticket must *tell* the man he is rigging. Ehtesham accepted
neither answer as final and asked TCG for **more use cases of this shape**, warning that
configurations like this *"are going to get lost"*. Registered in [dispatch/gaps.md](../dispatch/gaps.md)
against the existing *Default crew per unit* entry.

**7. Time display — military vs 12-hour.** Melissa: military time avoids AM/PM entry errors in
boom pay. Ehtesham: the system can handle both. Joe: make it a **per-user preference**. Brian:
whatever the format, **show the date** because jobs cross midnight. Registered in
[admin/gaps.md](../admin/gaps.md).

**8. Stop making the field bend the clock — Brian.** Today employees are, in some cases,
instructed to **inflate their reported hours so minimum-pay rules come out right**. His position:
the system should record **actual** hours and let the rules produce the payable result — which
changes what the field is told to do and what payroll sees. Registered in
[payroll/gaps.md](../payroll/gaps.md); it bears directly on `PAY-039`/`PAY-040` (reporting pay,
work-provided minimum) and on the phantom-hours doctrine already on `PAY-029`.

**9. Labels that mislead — Joe.** *"Start work"* and *"labor"* on the mobile ticket read wrongly
when the same fields carry **build-up, breakdown and boom pay**: *"we need to relabel that as boom
pay hours or something, because labor is going to throw people off."* Copy, not schema; noted for
the field-ops build.

## Client verdict on the demo

Joe: *"user friendly is a good way to describe it… so far it looks really cool."* Wes: *"you guys
have a clear understanding of our business."* Melissa: *"excited to have the payroll and the
tickets — I think it'll solve a lot of our problems in the field."* Next two weeks: finish the
ticketing module in the web app, complete payroll, Samsara vehicle locations, and the UAT/feedback
pass before the 15 September walkthrough.
