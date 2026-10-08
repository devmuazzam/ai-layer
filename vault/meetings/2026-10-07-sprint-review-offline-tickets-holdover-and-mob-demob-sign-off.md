---
title: ERP Sprint Review — offline job tickets, payroll-admin entry fixes, holdover, what a holdover is, mob/demob configuration sign-off, two cranes on one quote (7 October 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-10-07_Offline Job Tickets - QuoteJobConfigurations - transcript.docx"
migrated: 2026-10-08
updated: 2026-10-08
status: unverified
conflicts_with: []
jira: []
tags: [module/field-ops, module/payroll, module/dispatch, module/quotations, module/assets, kind/meeting-notes, offline-sync, holdover, mob-demob, associated-assets, adp, loadout, requirements]
entities: [quotation, sub-category, job-ticket, job-resource]
meeting_date: 2026-10-07
---

# ERP Sprint Review — offline tickets, holdover, mob/demob sign-off — 7 October 2026

Curated from [transcripts/2026-10-07-erp-sprint-review-offline-tickets-holdover-and-mob-demob.md](transcripts/2026-10-07-erp-sprint-review-offline-tickets-holdover-and-mob-demob.md)
(56 m 16 s, the regular sprint-review slot). **abdulrehman** demoed two weeks of build from recorded
videos. **syed.haris** and **ehtesham.anwar** then took the mob/demob configuration, the follow-up to
[2026-10-01](2026-10-01-quotes-and-billing-codes-associated-assets-mob-demob-and-holdover.md), to
**Joe Schacatano** (VP of Sales) for final approval. TCG speakers: Joe (from 22:32), **Brian Petros**,
**Melissa McNutt**. Wes Staley was addressed but did not speak.

> **Status.** §2–§4 describe what CodingCops showed as built. §5–§8 are TCG describing practice and
> preference. Joe approved the mob/demob configuration approach (§7) in so many words, but it was not
> written down as a spec, so the file is `status: unverified` and no decision note was written. That
> is `tcg-scrum`'s call (see *Candidates for a decision note* below).

## 1. Setup (2:59–7:13)

- **abdulrehman (3:17)** emailed the two-week sprint report to Brian, also shared with Wes. Three
  build items first, then mob/demob led by ehtesham.anwar and syed.haris.
- **ehtesham.anwar (6:02):** the mob/demob configuration is *"completed"*. The call is for *"a final
  approval from Joe that, okay, this is the right solution"*.
- **Payroll testing with ADP is Friday 2026-10-09 (4:30, 5:05).** The ADP connection is read-only
  today (pay codes, employees). abdulrehman will POST worksheets to ADP Workforce Now, then delete
  them with Micaela and Corrina's help, on Friday and Monday. **Brian (5:34):** *"Ehtesham is right. We
  got to use the real people to do the testing"* (the office-employee fallback from 2026-10-01 §1).

## 2. Offline job tickets on mobile (7:25–11:31)

- **Shown:** ticket LEM 1330 on a job whose allocation was done. With a connection, the pre-trip
  inspection synced to the web in real time. With Wi-Fi off, an **offline banner** shows, and every
  step still works and is held in local storage: the timer keeps running, photos and videos, the
  terms, the JSA, boom time. On reconnect the ticket synced in about 5–10 seconds, and local storage
  is cleared after the sync.
- **Melissa (10:21):** *"Perfect. Yeah, we just want to make sure they could still do it so that
  works."*
- **Brian (10:55)** asked whether the app can use the cell network when there is no internet, as
  text messages do. **abdulrehman (11:10):** no; any real-time action, including sending a text,
  needs internet, because texts go through AWS SES/SNS.
- **Planned, not built (11:31):** an **AWS SQS** queue, so that tickets arriving while the API is
  down are processed when it comes back.

## 3. Payroll admin fixing a flagged entry (11:31)

- A flagged entry (invalid boom time, overlapping jobs and so on) is **sent back to the payroll
  admin**, who can edit any field or time in a modal (boom, breakdown and yard times, work through
  lunch, lunch break). **ST/OT/DT are recalculated**, and the previous and new values are both kept
  and shown in an activity log.
- **Still open, per abdulrehman:** sending a ticket back to a crew member (e.g. the oiler) to resubmit
  or fill a missed ticket. *"That conversation is still… ongoing"*, and a designer is working on the UI.

## 4. Holdover as built (11:31–22:55)

- **Shown:** a quotation dated 3–5 May 2027, marked won and converted, scheduled per day. **Make
  Holdover** on the schedule held three items: the all-terrain crane, the operator and the rigger.
- **On the DAS** the job shows a holdover indicator and the count of held items. Assigning a held
  item logs its allocation on every remaining day. Non-held items are assigned day by day.
- **In yard operations**, day 1 runs loadout normally. The held crane **cannot be offloaded until the
  last day**: its actions are disabled on 4 May, and on 5 May offload is enabled.
- **27:00:** the single-day block was shown. A one-day job cannot be made a holdover (see §6).

## 5. "Loadout" and "offload" are the wrong words (22:32–27:00)

- **Joe (22:32)** asked what offload and loadout mean. abdulrehman: offload means the job is done and
  the assets return to inventory for the next job.
- **Joe (23:15–23:26):** *"Can we try to think of a different word than loaded and offloaded?"* TCG
  uses loading and offloading for real loading, *"for like storage or… spreader bars"*, and he wants
  the words kept for that.
- **Ideas floated, none chosen:**
  - Melissa: *"return to yard, or scheduled for a return"* (24:31), *"on project"* (25:23).
  - Joe: *"available… when it's freed up"* (25:10). It applies to every job, not only holdover, so
    *"It should just be unavailable available"* (25:39).
  - syed.haris (25:50): *"start dispatch"* at the start and *"resources back at the yard"* at the end.
    Joe (26:05): *"I like that because then you kind of get more specific on what it's actually
    classified as at whatever… period in the project"*.
  - Brian (26:19–26:28): the terms TCG uses are **available** (to dispatch), **unavailable** (down or
    on a job) and **return to the yard**.
  - syed.haris (26:39): mobile already says *left job site* and *arrived at yard*.
- **Not decided.** Melissa (24:54): *"we'll think about it. We'll come back to you guys on that
  one."*

## 6. What a holdover is (27:00–32:15)

- **Melissa (27:31)** asked: if a one-day job needs the crane for a second day, can it become a
  holdover, and is two days a holdover at all? **abdulrehman (27:48):** the logic would have to change
  so that *"at any time we can change any job to hold over"*.
- **Joe's definition (28:04, 28:29, 29:04):** *"any time the machine stays on site, it's a holdover…
  regardless of how many days it is."* *"A holdover is when you go do a job, the machine holds over on
  the job site while work is not being conducted."* *"If a machine stays on site, it is held over."*
- **Brian (28:22, 28:48):** a one-day job that runs past midnight is tricky. He would tell the cases
  apart by the job ticket, i.e. whether work was submitted. Joe: it comes down to *"the job ticket and
  then the labor hours"*.
- **A one-day job that turns into two (29:28):** TCG wants the option to send an additional quotation
  or change order, though it is rarely needed because the customer has the rates. The system should
  allow a change order or additional quote *"regardless of whatever scenario we're in"*.
- **Holdover at quotation level (30:08–31:33).** syed.haris proposed marking holdover on the quotation
  so that scheduling knows. **Joe:** *"that would be great"*. Today sales writes it in the description,
  e.g. *"on site 4 days with equipment staying on site"*. *"Ultimately… if we select holdover, it has a
  dropdown that populates for the amount of days and you would select the amount of days and then that
  would carry over."*
- **The holdover use-case list (31:33–32:15).** Joe and Melissa have both answered it. Melissa asked
  Kyle to review it, and he will when he has better signal. This is the list recorded as
  [decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md](../decisions/2026-10-06-holdover-oiler-day-and-late-tickets-melissa-answers-provisional.md),
  which is still on hold for TCG's updated version.
- **Next, per abdulrehman (32:25):** mobile is to adjust build-up and breakdown per holdover day.

## 7. Mob/demob configuration — reviewed and approved (33:14–37:45, 48:42–51:24)

- **What syed.haris showed (33:36–37:45):**
  - On *Sub-Categories → Associated Field Assets*, a **Show** checkbox per association decides
    whether it appears on the quotation. Sub-items and employees start unticked, per 2026-10-01.
  - The quotation type switches between **Hourly** and **Hourly with Mob**, with a confirmation popup.
  - The hourly quote on the 100 ton hydraulic crane showed only the crane, Operator Load and the travel
    permit. The tractor-semi, its operator and the rest were hidden.
  - For mob/demob, a shown association is a **Sub item** (under the mobilization row) or a **Main item**
    (its own line on the quotation).
  - The mobilization quantity changed from 1 to 3 and the amount updated. A 0.5 quantity worked.
  - Still to do: put mob/demob **at the bottom**. syed.haris said it would be deployed by the next call
    and reviewed at the next sprint review.
- **Joe:** *"Yeah, it looks good"* (36:23) on the hourly quote, and *"Cool. Thank you"* (37:45).
- **Configurable, not hard-coded (48:42–50:30).** ehtesham.anwar: the oiler and Operator Load's
  sub-items also carry the Show and Sub/Main settings, so anyone with the permission can change them
  from the front end. The rule "sub-items are never shown" is **not** coded in. **Joe (49:55–50:25):**
  *"So we can customize it to however we want it to be basically. Yeah, and that's, I'd rather have it
  be that way… I like how that's built out… if we took the other route where we completely restricted
  it… we're gonna run into a scenario."*
- **Two additions announced by ehtesham.anwar (50:33),** with no reply from TCG:
  - Rename the tab from **Associated Field Assets** to **Field Assets Configuration**.
  - Give it **its own activity log**: who changed what, and when.
- **ehtesham.anwar (51:07):** *"we are pretty clear on what we need to build."* syed.haris is to
  finish it, clean it up with the edge cases and test cases tried, and push it *"maybe by Monday"*
  (2026-10-12).

## 8. Two cranes on one quote (37:46–48:21)

- **syed.haris's question (37:46, 38:24):** with two cranes on one quote (100 ton and 350 ton), how do
  mob and demob work?
- **Joe (38:29–40:32):**
  - For one job with two cranes, each crane gets its own populated mob/demob, *"separate but on the
    same quote"*.
  - Today sales does two separate quotes and schedules two separate jobs. *"It should be one invoice…
    for the same job."*
  - Separate invoices only if one machine stays longer than the other, or the customer asks.
- **Separate, not lumped (41:22–41:55, 43:57, 45:24).** abdulrehman asked whether two cranes should
  share one mob/demob line. Joe: separate, so the quote is clear, *"for the 100 ton, it's this much on
  your mobilization. For the 350, it's this much"*. It also avoids re-splitting if the cranes end up
  going on different days. *"If we have two separate assets doing a job and they're both mobilizing,
  we would want to keep those separate."* Melissa: *"No, I'm good."*
- **ehtesham.anwar (42:13):** label them, e.g. *"100 ton crane mobilization"* and *"350 ton crane
  mobilization"*. Joe: *"Yeah, I mean, you could do that."*
- **Two different situations (42:37–43:10).**
  - Brian: two cranes on one job can mean **two lifts with two main cranes**, or a **supporting crane**
    (a 90 ton helping set up a 350 or 550).
  - Joe: the supporting crane *"is associated in the mob and demob"*. This question is about two
    cranes *"to do 2 separate things"*.
  - Joe (44:35): anything can be added inside a mobilization, a 350 included. ehtesham.anwar: yes,
    *"mob demob is just mob demob"*.
- **Options and phases are separate quotes (45:51–48:21).**
  - Today, salespeople quote several cranes for different scenarios or options inside one quote.
    **Joe:** *"moving forward… we're going to tell them they can't do it within the same quote… They're
    gonna have to be separate quotes."* Phase one is a separate job from phase two.
  - Lumping them in one quote causes confusion and *"a lot of pending quotes just sitting there"*.
  - ehtesham.anwar (47:42): a **project** can hold several quotes and aggregate their numbers. Joe:
    *"Perfect"*.
- **Read together:** two cranes on the **same job** go on one quote with a mob/demob per crane.
  **Alternative options or phases** go on separate quotes under one project.
- **Brian (43:17)** noted that FCC has quite a few quotes with several jobs attached, and asked
  whether to keep doing that. Joe (43:57): *"we're going to quote out whatever the customer asks, and
  then however it falls, it's going to fall."*

## 9. Dev environment and user testing (51:39–55:23)

- **abdulrehman (51:39–52:05):** a new dev environment is coming, with DNS and SSL to be set up with
  Brian and Patrick, and CI/CD for it. The current portal becomes the **stable** one for TCG to test.
- **Brian (52:29–53:54):** user testing is next. He plans individual testing with **test scenarios and
  worksheets**, and possibly a side-by-side replay of a real day or week. He expects it to shift work
  from new enhancements to tweaks. ehtesham.anwar (54:06): it is already planned for.
- **syed.haris (54:54):** some flags need real field workers to test, e.g. the Samsara payroll flag
  (*"I have returned back to yard"* while Samsara puts them at the job site).

## 10. Next

- **Thursday 2026-10-08:** designs, i.e. the accounting designs and, if time allows, the safety and
  compliance discovery. Brian will invite Accounting.
- **Friday 2026-10-09:** ADP worksheet POST testing (§1).
- **By Monday 2026-10-12:** the mob/demob configuration finished and pushed (§7).

## Against the vault

- **Refines [2026-10-01 §2](2026-10-01-quotes-and-billing-codes-associated-assets-mob-demob-and-holdover.md).**
  On 10-01 Joe said an association's own associations *"shouldn't be shown"*. Here that is the
  **default**, and each association is configurable. Joe approved the configurable approach (§7).
- **Partly answers 2026-10-01 §10 Q1.** Setting the mobilization quantity to 3 multiplied the amount
  on screen. Whether sub-item quantities stay per visit was not discussed.
- **Partly answers** [quotations/gaps.md → *Several main cranes on one quotation*](../quotations/gaps.md#several-main-cranes-on-one-quotation--how-are-the-crane-packages-grouped-and-how-does-dispatch-see-them).
  For one job, it is one quote, with a mob/demob per crane and one invoice. Options and phases go on
  separate quotes. Still open: how dispatch sees the groups, and the customer PDF layout.
- **Gives TCG's definition for** [dispatch/gaps.md → *Does copying allocations make a job a holdover?*](../dispatch/gaps.md#does-copying-allocations-make-a-job-a-holdover).
  A holdover is the machine staying on site while no work is being done, however many days. That does
  not settle what Copy Allocations should do.
- **Sits beside**
  [decisions/2026-10-07-holdover-not-allowed-on-a-single-day-job.md](../decisions/2026-10-07-holdover-not-allowed-on-a-single-day-job.md)
  (a CodingCops ruling that TCG can overrule). The block was demoed (27:00) and nobody objected to it
  as such. But Melissa's case, a one-day job that needs a second day, and Joe's definition mean a job
  must be able to **become** a holdover once the machine stays. abdulrehman said the logic would have
  to change. Not a direct conflict, since an extended job is no longer single-day, but the decision's
  reading should be checked against this.
- **Consistent with** [dispatch/gaps.md → *An assist crane needed only on some days…*](../dispatch/gaps.md#an-assist-crane-needed-only-on-some-days-of-a-multi-day-job--setup-and-breakdown).
  Joe again puts a supporting crane inside mob/demob (§8), as on 2026-10-01 §6(B).
- **New, not in the vault:**
  - Rename loadout/offload (§5).
  - Holdover chosen on the quotation, with a number-of-days dropdown (§6).
  - A change order or additional quote for an unplanned extra day (§6).
  - Field Assets Configuration rename and its activity log (§7).
  - Separate quotes for options and phases (§8).

## Candidates for a decision note (for `tcg-scrum`)

- **Joe Schacatano, 2026-10-07 (49:55–50:30):** the quote visibility of associated field assets is
  **configurable per association** from the front end, defaulting sub-items and employees to hidden,
  and is not hard-coded. This is the approval ehtesham.anwar asked for at 6:02.
- **Joe Schacatano, 2026-10-07 (41:22, 45:24):** two cranes on one job get **separate mob/demob per
  crane** on one quote. Options and phases are **separate quotes** (46:45).

## 11. Questions this raises (not yet filed)

No ticket folder covers these yet. When one does, they belong in its spec §12. Until then they are
candidates for the module `gaps.md` named in each.

1. **What replaces "Loadout" and "Offload"?** Is it available / unavailable / return to yard, or
   *start dispatch* / *back at the yard*? Melissa will come back (dispatch).
2. **Holdover on the quotation.** How does a number of days chosen on the quote carry into the job
   schedule? Does it pre-set Make Holdover? Which items are held by default (quotations, dispatch)?
3. **A one-day job that becomes a holdover.** Should adding a second day with the machine staying
   unlock Make Holdover, and does it trigger the change-order prompt? This needs revisiting against
   the 2026-10-07 single-day decision, with Lisette and Joe (dispatch).
4. **Per-crane mob/demob on one quote.** Are the lines labelled per crane, as ehtesham.anwar
   suggested? How does the customer PDF show them? Is the one invoice per job split by crane anywhere
   (quotations, accounting)?
5. **Field Assets Configuration activity log.** Which fields does it track, and who may see it
   (assets)?
6. **Payroll admin sending a ticket back to a crew member** to resubmit or fill a missed ticket.
   Still being designed (payroll).
