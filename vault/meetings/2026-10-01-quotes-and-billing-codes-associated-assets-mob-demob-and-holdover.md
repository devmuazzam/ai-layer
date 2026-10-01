---
title: Quotes and Billing Codes — associated field assets on the quote, operator load as one billing code, mob/demob quantities, holdover and support loads (1 October 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-10-01_Quotes and Billing Codes - transcript.docx"
migrated: 2026-10-02
updated: 2026-10-02
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/assets, module/dispatch, module/accounting, module/payroll, kind/meeting-notes, mob-demob, billing-codes, associated-assets, holdover, adp, requirements]
entities: [quotation, billing-code, sub-category]
meeting_date: 2026-10-01
---

# Quotes and Billing Codes — associated field assets, mob/demob and holdover — 1 October 2026

Curated from [transcripts/2026-10-01-quotes-and-billing-codes.md](transcripts/2026-10-01-quotes-and-billing-codes.md)
(1 h 8 m 21 s, the regular CC/TCG ERP slot). This is the configuration follow-up promised on
2026-09-29 (that call's §8). **ehtesham.anwar** led it. **syed.haris** drove a prototype on screen,
and **Joe Schacatano** (VP of Sales) answered most questions and then walked through mob/demob in FCC.
TCG speakers: Joe, **Brian Petros**, **Melissa McNutt**. CodingCops: ehtesham.anwar, abdulrehman,
syed.haris. Dee Jones was present for the first nine minutes only.

> **What the prototype was.** It added two per-association settings to *Asset Management →
> Sub-Categories → Associated Field Assets*: **Hourly · Quote/Invoice: Show** (a checkbox) and
> **Mob/Demob · Quote/Invoice: Main item / Sub item**. The quote's Resources tab used them. It was
> built on a throwaway local branch for this meeting and **reverted on 2026-10-02 at syed.haris's
> request**. Nothing was merged, and no migration remains. Read every "the prototype does X" below as
> what was shown, not what is built.

> **Status.** Everything in §2–§8 is Joe and Melissa describing FCC practice and what they want. None
> of it was signed off as a spec, so the file is `status: unverified` and no decision note was
> written. Joe's statements are first-hand from the person who quotes, and they are specific.

## 1. Before the topic: ADP test employees (1:38–7:25)

- **ADP gives no sandbox to this kind of integration.** abdulrehman (3:00): ADP has a sandbox only for
  marketplace partners. TCG's is "client central", so the workaround is **test employees inside the
  live account**. Brian (2:27): ADP's convention is *"Emily employee and Marty manager"*, which ADP
  staff know not to pay.
- **ehtesham.anwar's fallback (3:54, 5:40):** use real **office employees'** data, run onboarding,
  tickets and payroll end to end, send the payable to ADP, and **never accept it** in ADP. Corrina
  confirms the data is right, and then testing stops.
- **abdulrehman (5:02, 7:00):** that is option two, after asking ADP support for test accounts. A
  worksheet not under Emily/Marty must be deleted at once, or ADP may process it. He also asked whether
  **ADP allows one SSN on several profiles**. Nobody knew.
- **Owner:** abdulrehman, to coordinate with Corrina and ADP. "Hardy" filed the ADP ticket.

## 2. The prototype: what goes on the quote (9:13–14:42)

- **ehtesham.anwar (9:13)** presented the two new columns. **Joe (11:07):** *"I think so. Can you show
  me an example through the quoting and then when it goes to the job?"*
- **Joe restated it (11:21, 11:29):** *"main item shows up, the sub will be there, but not on the
  quote, and it will transition to the job"*. A sub item is *"something that's required to complement
  the main item"*.
- **The hourly column worked as shown.** On the 100 ton crane, Oiler had *Show* unticked and was not
  on the hourly quote. Operator Load had it ticked and was.
- **Joe's correction (13:37–14:27): an association's own associations never go on the quote.**
  Operator Load's tractor-semi and operator showed as *"Always Included · Shown · Main item"*. Joe:
  *"It shouldn't be shown and it shouldn't be a main item. Always included on the job end when it's
  dispatched is how it should be."* ehtesham.anwar: *"these sub items should not be shown in
  quotation… It should be only operator load."* Joe: *"Correct… Exactly."*
- **Why (14:27):** *"the tractor and the operator… and the trailer, that's combined into what the
  operator load is… The operator load itself, the charges, is just the operator load."*
- **ehtesham.anwar's assumption, not confirmed (11:34):** *"everything that we see in quotation is…
  going to be the same things that we are going to [port] over [to] invoices."* Joe answered a
  different point, so this stays open (§10).

## 3. The "Units · People · Estimates" heading (14:49–16:05)

- **Joe:** the section heading on the quote's Resources tab is confusing. He wants something general,
  such as *"quotable items"*. ehtesham.anwar suggested *"Scope items"*, partly because the heading is
  also used on the quotation.
- **Not decided.** Joe: *"not that big of a deal"*. He will post a suggestion in the group if he
  thinks of one.

## 4. Billing codes behind a load (16:11–20:45)

- **Operator Load is one billing code (17:25–17:50).** Joe: *"It's just a single billing code."* The
  tractor *"wouldn't be a billing code on it"*. It feeds **equipment-utilisation reporting**. The
  operator feeds **labour hours**. *"That would be the only thing we're looking at from… [a] pricing
  standpoint."*
- **ehtesham.anwar (17:56):** this *"is going to change the way we have set up the system"*. Today
  each associated resource carries its own billing code onto the quote.
- **Tractor and operator still need billing codes for one-offs (18:24).** Joe: *"having the option
  to add them in as a billing code… in case there are one-offs"*.
- **A certified operator is a separate billing code (18:52–19:30).** It is used where the machine is
  charged monthly or weekly (Joe's examples: a crawler crane, a rough-terrain machine) and an operator
  charge is tied to it. On a 100 ton quote, *"we would add the billing code certified operator"*.
- **For dispatch, it is the same operator** that is configured in the associated field assets (19:51,
  *"Exactly"*). Joe would expect this *"every time"*. For trucking, the equivalent is the
  **tractor-semi driver** (20:07).

## 5. Mob/demob on the quote — Joe in FCC (21:05–39:30)

- **Several billing codes, each with its own quantity, totalling into one line (22:53–23:37).** Joe:
  *"So if I have five things that are included in my mobilization, it would be 5 billing codes. Every
  quantity would be different."* The customer sees *"just… the one mobilization line"*.
- **The rule ehtesham.anwar summarised, and Joe confirmed (26:50–27:11, *"Yes. Exactly"*):** every
  sub item and main item is quoted on its **own billing code**, and **every quantity is editable while
  quoting**. The customer receives **mob, demob and the main items** only.
- **The mobilization line's own quantity must be editable (29:02–29:35).** Brian noticed FCC fixes it
  at 1. Joe: *"that's an issue we have with this system… We need the option to be able to multiply
  the mobilization as many times as we want because we might be doing 5 different visits to the
  job."*
- **Demob quantities start at 0, not copied from mob (30:19–30:35).** Joe: *"I'd rather have it all
  populated 0 so that they have to manually put it in because they're all going to be different."*
  Later (1:02:57–1:03:07) the *lines* themselves should mirror: adding a line to mob adds it to demob
  (§8).
- **What the hours mean (32:24–36:23).**
  - **Mob** runs from leaving the yard until build-up is complete.
  - **Demob** runs from the start of breakdown until the crew is back at the yard.
  - **The crane line after them is hook time**, *"actually lifting, working"*.
  - Joe's analogy: buying a car, with a delivery charge, the car's price, and a charge to take the
    old one back. *"The cost of the car is the 100 ton at the bottom."*
- **Quoted versus actual mob hours (33:29–33:48).** Joe wants the system to say, *"based off the
  ticket time and the labor hours"*, whether the estimate was right, under or over.
- **Crew overtime and crew double time (34:05–34:45)** are the operator's and the oiler's overtime. A
  long travel-and-build day pushes them into overtime. They are put inside mob *"for the purpose of A,
  capturing the cost"*, and so the customer does not query an overtime line: *"hiding but capturing
  the cost at the same time."*
- **Price adjustment (37:16)** is a line inside mob/demob for extra money that has no billing code,
  such as a hotel or food.
- **Operator Load inside mob and demob (38:18–39:30).** It is not on the customer's list, because it
  is charged on the front and back end.
  - **One-day job:** 0.5 in mob and 0.5 in demob, which still captures the one-day charge.
  - **Multi-day (holdover):** charged on the first and last day only. *"It's not a daily charge… and
    it's not an hourly charge."*
- **A line left at quantity 0 stays out of the total (51:01–51:35).** On a 365 ton crane with only
  some support loads going, the unused ones stay at 0.

## 6. Support loads and "main item means it stays" (52:08–57:27)

- **Two scenarios (52:08–52:30).**
  - **(A) The support load stays on site.** Its hours match the crane's, and it is added as an item on
    the quote with the crane.
  - **(B) It only goes to build.** It sits inside mob with *more* hours than the crane, because it goes
    in, builds, and returns to the yard. A one-day job splits it 0.5 / 0.5 (53:02).
- **A main item means "working on the job for the duration" (55:00–56:17).** ehtesham.anwar asked
  whether a support load added as a main item, not inside mob/demob, means its trailer and truck stay
  until the job is done. Joe: yes, *"if it's a single day or a holdover"*. *"Anything as a main from
  the [mob]… means it's working on the job for the duration of the project. Or we're charging for
  it."*
- **ehtesham.anwar (56:26):** this answers an open field-mobile question, namely how to tell, on a
  holdover job, whether equipment goes, sets up and comes back, or stays.
- **A holdover is not always mob/demob (57:00–57:27).** Smaller machines may be quoted with travel and
  build-up spelled out as main items. A job quoted as one day can also turn into a holdover.

## 7. Hourly jobs over several days, and the schedule against the quote (40:21–47:36)

- **Multi-day hourly:** change the crane's hours to the total, e.g. 40 for five 8-hour days (40:35).
  With different hours on different days, the quote carries the **lump-sum total**, and the split goes
  in a **note** for dispatch (41:41, 42:27).
- **Dispatch schedules without seeing the quote (44:48).** ehtesham.anwar asked whether the ERP should
  warn when a schedule exceeds the quoted hours. **Joe (45:25):** if it is about to exceed, *"it sends
  a ping to us… because then it needs to go back to the… salesman… really the whole team"*, for a
  change order or a cost update.
- **Change orders today (46:23):** before the job, a new quotation. Mid-job, *"we typically just
  notify if we even know about it"*. Usually it surfaces after the job, at invoicing, *"providing the
  backups"*. Joe: it *"would be nice to know in the job… you're 5 hours from maxing out"*.
- **Melissa (47:15):** if time is recorded daily, the system could notify the salesperson that the job
  is approaching the quote.
- **An unplanned holdover (57:46–1:00:31)** stays in Dispatch: *"the time that it set and scheduled is
  just extended out"*. The machine stays on site. Dispatch adds a new day and shift with the same
  people, and **a new ticket goes out**.

## 8. Templates, minimums, and the prototype's second pass (47:38–1:03:22)

- **Melissa (47:38–48:37)** asked for a mob/demob **template** (travel in, travel out, build-up), so
  that salespeople fill in numbers instead of remembering every line. Joe: FCC has one only for the
  **550**, by configuration and minimum time. If the ERP builds this concept, lines could be **preset
  per machine**, populating 0 or a set quantity (48:14, 48:27).
- **ehtesham.anwar (49:16):** that needs a **minimum required quantity** in configuration, separate
  from the quote's own editable quantity. **Joe (49:59):** whatever is quoted, the back end tracks
  actual times against it.
- **syed.haris's second pass on the prototype (1:00:59–1:03:22)**, built during the call:
  - The hourly quote showed only the 100 ton crane and Operator Load, with no sub-items.
  - A button converted it to mob/demob.
- **Where mob/demob sit: the bottom (1:01:56–1:02:14).** Joe: *"like looking at a balance sheet.
  You're looking at the total on the bottom"*. It also means a salesperson changing the mob quantity
  from one to three won't miss it.
- **Adding a line to mob adds it to demob (1:02:57–1:03:07).** ehtesham.anwar asked for this. Joe:
  *"we want the numbers typically to match up"*. syed.haris noted that **mob's own quantity is not yet
  editable** in the prototype.

## 9. Close (1:04:34–1:08:07)

- **ehtesham.anwar (1:05:05):** all the billing codes stay. What changes is **how they are linked**:
  associated field resources and their sub-items are not added as billing-code lines when building an
  hourly or a mob/demob quote. The **invoicing flows are built**, but showing them now would raise the
  same question, so this is to be finalised first (1:05:59).
- **Brian (1:04:34, 1:06:56):** there are three phases: quoting, dispatching and invoicing. Invoicing
  was not covered. **Next session, Tuesday 2026-10-06: crane configuration**, i.e. what sales selects
  on a quote (crane type, configuration) and what that pre-fills.
- **ehtesham.anwar (1:07:33):** about 90% is covered from quotation through to the field. The team will
  write up the solution and its impacts for Tuesday.

## Against the vault

- **Confirms** [quotations/mobilization-and-demobilization.md](../quotations/mobilization-and-demobilization.md)
  FR-1 (mob and demob are parent lines with sub-items), FR-2 (sub-items roll up into the parent), FR-6
  (the customer sees only the totals) and FR-7 (staff see every sub-item).
- **Confirms 2026-09-16 §4.** Joe's *"so that we're not showing 50 billing codes"* is the same
  roll-up, now with the quantity rules.
- **New, not in the vault:**
  - The mob line's own quantity is editable (multiple visits).
  - Demob quantities start at 0.
  - Operator Load splits 0.5 / 0.5 on a one-day job.
  - Main item means it stays on the job.
  - A quoted-versus-scheduled hours alert.
  - A per-machine minimum-quantity template.
- **Refines 2026-09-15 / 09-16 ("oiler, operator and semi are never charged").** They are not charged
  as their own lines, but their cost is captured inside Operator Load's single billing code and, for
  overtime, inside mob/demob as crew OT/DT. A **certified operator** is the exception, with its own
  billing code.
- **Sits beside, does not answer,** the open question in [quotations/gaps.md](../quotations/gaps.md)
  → *Several main cranes on one quotation*.

## 10. Questions this raises (not yet filed)

No ticket covers this yet. When one does, these belong in its spec §12. Until then they are candidates
for [quotations/gaps.md](../quotations/gaps.md).

1. **What does the mobilization line's quantity multiply?** If it is set to 3 (three visits), is the
   customer total three times the rolled-up sum? Do the sub-item quantities stay per visit?
2. **Where is the per-machine mob/demob template configured, and what is its "minimum required
   quantity"?** A floor that blocks quoting lower, or a default the salesperson can lower?
3. **The schedule-versus-quote alert.** Who is notified (salesperson, "the whole team"), at what
   threshold, and is it computed from scheduled hours or from ticket time as it accrues?
4. **Do invoices carry exactly the quotation's lines?** This is ehtesham.anwar's 11:34 assumption,
   and Joe did not answer it.
5. **What replaces "Units · People · Estimates"?** "Quotable items" (Joe) and "Scope items"
   (ehtesham.anwar) were floated, and neither was chosen.
6. **Does ADP accept one SSN on several employee profiles?** This matters if office employees' data
   is reused for testing (§1).
