---
title: ERP Demo Walkthrough Part 1 — test tenant and login, yards, departments and roles, craft codes, agencies, tools and riggings, billing codes, price lists, vendors (21 October 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-10-21_ERP DEMO-WALKTHROUGH Part 1 - transcript.docx"
migrated: 2026-10-22
updated: 2026-10-22
status: unverified
conflicts_with: []
jira: []
tags: [module/admin, module/payroll, module/assets, module/quotations, module/customers, module/vendors-agencies, module/accounting, module/dispatch, kind/meeting-notes, authentication, permissions-roles, yards, craft-code, craft-modifier, permits, tools-rigging, pricing, purchase-orders, integrations, data-migration, requirements]
meeting_date: 2026-10-21
---

# ERP Demo Walkthrough Part 1 — configuration, billing codes, price lists, vendors — 21 October 2026

Curated from [transcripts/2026-10-21-erp-demo-walkthrough-part-1.md](transcripts/2026-10-21-erp-demo-walkthrough-part-1.md)
(59 m 7 s, transcribed 0:39–59:04). Booked as an *ERP Sprint Review*, it became the walkthrough
[2026-10-20 §5](2026-10-20-erp-documentation-portal-set-up-order-test-login-and-staging.md) could not give.
**ehtesham.anwar** walked TCG through the test tenant section by section, following the documentation.
It stopped before asset management and continues the next day. TCG speakers: **Brian Petros** (Data
Analyst, ERP Project Coordinator), **Melissa McNutt** (President), **Ryan Adams** (Sales Manager, on
Brian's microphone), **Sammy Garrett** (Controller), **Kaitlin Kiesel** (Accounts Receivable
Specialist), **Micaela Dipane**. CodingCops: ehtesham.anwar, abdulrehman. Roles are from
[../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md).

> **Speaker labels.** "Brian Petros" is TCG's conference-room microphone. **Ryan Adams speaks on it from
> 51:59 to 55:18**, and those turns are attributed to Ryan here. The transcript header gives the evidence.

> **Status.** §1–§9 are CodingCops describing what is **built** in the test tenant, with TCG's questions.
> Nothing was demonstrated against a spec. TCG asked for several things (vendor categories, tax, a PO
> from the quote, QuickBooks sync). Only one got a firm answer: the vendor category (§9). The file is
> `status: unverified`.

## 1. Test tenant, login and invitations (1:04–4:21)

- TCG tests on a **shared admin login on a dedicated test tenant**. Its seeded user shows as *"Alex
  Morgan"* (1:04, 3:26). abdulrehman: the application is multi-tenant, and this is *"a test tenant for
  you"* (2:18).
- The **documentation tab is now in the left sidebar**, and its content is generic for every tenant
  (2:18).
- **Employee invitations.** To create an employee, enter the employee ID, first name, last name and
  e-mail. The employee gets an invitation e-mail and follows it to sign in (3:47).
- **Work cell phone is required** because the mobile app signs in with an **OTP** to that phone
  (4:09–4:17).

## 2. Where the build stands, and what comes next (4:18–7:46)

- **Brian:** the first pass touched every department and process except **inventory and fleet
  maintenance** (Jeff Stricker). TCG can now *"officially go in and test … the full workflow, … on a
  basic level"*. A second pass follows, starting with Ryan's sales and quoting ideas (4:18).
- **ehtesham.anwar:** the loop is closed *"from creating a job where field people are required … up until
  the part that payroll can be processed and invoicing can be processed"*. Invoicing will be built
  *"within a couple of weeks"*. Then two more loops: **storage**, then **maintenance**, which covers
  inventories and the maintenance workflow and feeds payroll, employees and invoicing (6:06).
- **Who owns which part of the documentation** (8:54–11:42): configuration for Brian, Melissa, Kyle,
  Jeff and Wes; sales for Ryan; vendor creation and ticket dispatch for Lisette's team. Melissa: vendor
  creation is probably *"Sam and Sammy"* (11:18). Accounting will be added as **section 10** in a couple
  of weeks (11:42).

## 3. Yards (11:42)

- Fields are name, status, physical address and mailing address. A yard can be edited, made inactive or
  archived.
- An **inactive yard cannot be selected** in assets, quotations or anywhere else.
- The **physical address is where every job starts**: it is used to calculate travel time from the yard
  to the job site. The mailing address is stored but not used yet.

## 4. Departments and roles (11:42–19:34)

- No departments are created by default. TCG creates its own. A **department has only a name** (and a
  description) and carries **no permissions**. The test tenant has some seeded.
- **Roles live inside a department.** Each role sets an access level **per module**: no access (the
  default), view only, edit, or full access. The role list shows a summary of access.
- **Edit vs full access** (Brian, 16:27). Full access adds **creating**. Edit lets a user update or
  change status without creating. ehtesham.anwar's example: salespeople create quotations, and sales
  coordinators review them without creating any (16:33).
- **Per person or per department?** (Brian, 18:20). Permissions are on the role, not the department,
  so a person in sales who does some accounting work can have a role that covers both. One role can be
  attached to many people (18:31–19:13).

## 5. HR configuration: union codes, craft codes, agencies (19:34–26:34)

- **Covers** union codes, craft codes, craft code modifiers, employees, temp employees, *"work on codes"*
  (as transcribed), certifications and agencies (19:34).
- **Set up union and craft codes fully at the start.** They **can't be created from the employee
  profile**: *"these are not just one of values, they are important information for our payroll"*, so
  there is one place to create them (19:34). Union codes are under Settings. Craft codes and modifiers
  are under Payroll.
- **Craft codes** (21:26). A code can be created, given rates, have its current rate deactivated, or be
  deactivated itself. Its assigned users are listed, and users can be assigned from there, though that
  is *"not the recommended method"*.
- **The employee profile** is the recommended route. With compensation type *craft based hourly*, it
  shows payroll status, ADP file, primary craft code and union status (union status comes from the
  craft code).
- **Scale is overscale only.** *"If … we are paying them at 48, but the normal rate is 42 on this craft
  code, then we only need to add $6 here."*
- **Secondary craft codes** are added with a quick action and a **reason**.
- **Agencies** (21:26–26:34). Fields:
  - name, agency type (city, county, state or federal) and jurisdiction type;
  - **permit lead time**;
  - website, average cost, location coverage (state, city, county) and area notes;
  - requirements, e.g. parking or City Hall hours;
  - submission method: manual, e-mail, third-party vendor, or portal (with the portal's details);
  - notes and travel time restrictions;
  - plan requirements, plus a library of submittal applications and forms to upload.

  Each agency also has an **attachments** tab and an **activity log**.
- **Lead time is meant to drive a warning.** If an operation is created two days out and the agency's
  lead time is seven days, *"there's something wrong or we need to expedite … or we need to rethink of
  this schedule"*. This was described as what the field enables. It was not shown working.

## 6. Tools and riggings (27:47–28:08)

- Tools and riggings sit under Asset Management. **Utilization is calculated by the system**, and a
  date can be picked to see it on that day.
- Fields are name, quantity in inventory, serial number, images, and a flag transcribed as *"needs a
  spotted"*. When a flagged tool is on a job, the **yard-operations load-out card** shows an extra marker.
- The same items are used in yard management, in jobs, and on quotations.

## 7. Billing codes (28:08–36:55)

- **Created on asset subcategories, never on individual assets**, and also on **employee roles**.
  Accounting → Billing codes holds the list. A subcategory that already has a code shows *"already
  assigned"*. The fleet side configures categories; accounting creates the codes (31:30).
- **Fields:** unit of measure, default rate, **GL account** (not yet connected to QuickBooks), taxable,
  and **apply surcharge** (31:30). With apply surcharge off, the line gets no surcharge, either the
  general one or a customer price list's. The example was the **operator** (36:55).
- **Deactivating configuration that other records use** (Brian, 32:48). Hiding a subcategory removes it
  from pickers. **Archiving it is blocked** while assets or billing codes reference it: the dialog
  lists them (*"two assets … one billing code"*), and they must be removed or deactivated first (33:36).
  The subcategory page offers no action on them, because assets and billing codes are owned by other
  pages and people (35:02). A single pop-up to handle this is planned for the second pass (34:47).

## 8. Price lists (36:55–44:15)

- **A price list** has a name, a discount %, a surcharge %, effective dates, and **at least one
  billing code with its own rate**. The example was 100-ton and 200-ton cranes at 700 instead of 625.
  It can be linked to **one or many customers** (43:23).
- **What applies.** On a quote for a linked customer, within the effective dates, the list's rates,
  surcharge and discount apply to its codes. Any other code takes its rate from the **general list**,
  which is the billing codes page (*"We can rename the page as well to general price list"*, 41:01).
- **Surcharge precedence.** A price list's surcharge takes precedence over the general surcharge (42:30).
  The quote also has a per-line quick action that removes the surcharge (36:55).
- **One price list per quote** (Brian, 40:00; ehtesham.anwar, *"Yes, absolutely"*).
- **Melissa:** *"I like it separated"* — general and special lists kept apart (41:28). Several customers
  can share a list, e.g. the *"poll contractors"* (as transcribed) on a preferred list (43:13).
- **Kaitlin:** **Edison** has its own billing codes, different from every other customer's. A price list
  covers that (43:29). ehtesham.anwar asked accounting to check what Edison and the others need and report
  anything missing (43:39).
- **Unanswered: a price-list discount plus the quote's own discount or price hike** (Brian,
  41:33–41:53). *"It's going to combine both of those things together, right?"* The reply covered only
  surcharge precedence.

## 9. Vendors, tax, and POs from the quote (44:26–57:27)

- **Customers and vendors for testing** (Brian, 44:38). Should TCG type in 10–30 of each, then send the
  full lists for import? ehtesham.anwar described the plan instead:
  - TCG tests this first pass and gives feedback;
  - functions are added through that feedback loop, alongside new designs and discovery;
  - once TCG can run **100% of its operations**, the system moves to production.

  He also mentioned Melissa's message about **one job per day**, to be discussed (45:12). Separately, a
  tenant is being loaded with **FCC data** (about **2,200 customers**; abdulrehman leads it) to check the
  import ahead of production (47:51).
- **QuickBooks vendors** (Melissa, 47:02): *"Will it sync like FCC syncs right now? … will the vendors
  auto populate and it'll all match?"* ehtesham.anwar: not discussed yet. If the vendors are in QuickBooks,
  *"we will create a functionality to fetch that"* (47:08).
- **The vendor record** (48:24) has these fields:
  - general: phone, e-mail, type (individual or business), category (service, parts, subcontractor,
    renter), comments, and an address on a map;
  - contacts: several per vendor;
  - billing: tax ID, account number, 1099 type, default GL expense account, billing terms, discount %
    and date, and taxable.

  Associated assets and employees are **not entered on the vendor**. The dispatcher adds them in the
  **daily allocation system** (name and phone), and they then show on the vendor (48:24).
- **Vendor category becomes multi-select** (Sammy Garrett, 50:41–51:46). One vendor, e.g. Western, can
  supply parts, rent a crane, and work as a subcontractor. ehtesham.anwar: *"we will create this, convert
  this into a multi-select"*. TCG should also send any missing categories.
- **Sales tax by job site** (Ryan, 51:59–52:41). Materials going to a site are taxed at that city's
  rate. Ryan wants the tax set on the **quote**, editable, and carried through to the invoice.
  ehtesham.anwar: not possible now; *"We'll update the functionality while adding in the quotations"*
  (52:57).
- **Vendors on the quote, and a PO from it** (Ryan, 53:42). A quote can't take a vendor in its
  resources today (52:57). Ryan wants a quote line with the vendor's details and price that
  **creates the PO automatically**, hidden from the customer and tied to the same job. Sammy compared it
  to *"what Hayley does"* today when Jason subs a job out (54:17).
- **What DAS already does.** Allocating a vendor's asset in DAS **opens a purchase order**, and the
  allocation isn't complete until the PO is created (54:54).
- **Ryan on PO scope.** POs cover lift plans through third parties, trucking and more. He will work out
  the best path with Melissa and Brent (55:18).
- **Melissa on the PO flow.** The dispatch-side PO is *"pretty good … we just might need to add it to
  the quotes"* (55:38). ehtesham.anwar: to be discussed in detail.
- **Billing codes and QuickBooks** (Micaela, 56:00). In FCC an updated billing code must also be updated
  by hand in QuickBooks. Melissa wants a change to update both systems (56:22). ehtesham.anwar: there is
  no QuickBooks link for billing codes yet, but QuickBooks is planned across all accounting flows, so it
  can be added once TCG knows where the codes live in QuickBooks (56:14–56:22).
- **Melissa:** QuickBooks holds no cranes; *"it's not set up like the assets are set up in FCC"* (57:08).

## 10. What was not covered

- Asset management, sales and quotations, projects, DAS, yard and field operations, and payroll were
  left for the next session (57:27).
- So were the sprint-review items: mob/demob, holdover, ADP by API, and the new environment
  ([10-20 §6](2026-10-20-erp-documentation-portal-set-up-order-test-login-and-staging.md)).
- Melissa: no accounting or invoicing demo today (26:40–26:58).

## 11. Next

- **2026-10-22 (Thursday):** continue from **asset management**. Melissa asked for **Jeff Stricker** on
  the call (58:00).
- **Lisette is away until November 3** (58:10–58:19). Whoever runs dispatch now stands in, and she gets
  the recording (58:20–58:34).
- **Ryan's sales and quoting ideas:** Tuesday (58:44–58:56). That is 2026-10-27, if the next Tuesday
  was meant.
- **CodingCops:** vendor category to multi-select (§9). Discuss in detail: tax on quotes, a PO from
  the quote, QuickBooks vendors, and QuickBooks billing codes (§9).
- **TCG:** check price lists against Edison and other customer pricing (§8). Send vendor categories (§9).

## Against the vault

- **The approval wording in the documentation conflicts; the build does not.** [2026-10-20 §1](2026-10-20-erp-documentation-portal-set-up-order-test-login-and-staging.md)
  says any amount **changed** from the billing code needs approval.
  [../erp-review-log.md](../erp-review-log.md) *Quote approval (8)* (unverified) has approval only for
  rates **below** the standard or price-list rate (*"charging above standard rate is fine"*). The code
  agrees with the log: `quotation-approvals.service.ts` triggers on `RATE_BELOW_MINIMUM` or
  `TOTAL_EXCEEDS_LIMIT`, and otherwise routes every quote as `MANDATORY`. The $50K threshold matches. Whether it is inclusive is still open in
  [../quotations/gaps.md](../quotations/gaps.md) *Is the $50,000 approval threshold inclusive or exclusive?*
- **"Taxable" is in the build but TCG said it isn't needed.**
  [../quotations/billing-code-and-price-list.md](../quotations/billing-code-and-price-list.md) records
  TCG's own notes on the FCC screens: *"Taxable: Not needed"* and *"We don't use/need 'Taxable'"*. The
  built billing code (§7) and vendor (§9) both have a taxable flag. Ryan's per-job tax ask (§9) is about
  the quote, not the code. See [../quotations/gaps.md](../quotations/gaps.md) *Billing Code Flags and
  Surcharge checkboxes* and *Does a quotation carry sales tax at all, and if so on which amount?*.
  [../decisions/2026-09-28-quotation-pdf-carries-no-tax.md](../decisions/2026-09-28-quotation-pdf-carries-no-tax.md)
  keeps tax off the quote PDF until that is decided. This call is new evidence for the open question
  (Ryan wants tax on the quote). It is not an answer.
- **QuickBooks direction conflicts with Melissa's expectation.**
  [../accounting/nexgen-quickbooks-integration/01-fcc-connector-field-mapping.md](../accounting/nexgen-quickbooks-integration/01-fcc-connector-field-mapping.md)
  (unverified) says the FCC connector pushes **NexGen → QuickBooks throughout**, vendors included.
  Melissa expects vendors to *"auto populate"* from QuickBooks (§9). Either her description of FCC
  or the mapping is wrong. Pushing billing codes to QuickBooks as items (§9) would also be new, because
  the mapping sends invoice lines as GL-coded amounts.
- **Surcharge precedence and price-list override agree with
  [../decisions/2026-09-02-one-surcharge-per-quote.md](../decisions/2026-09-02-one-surcharge-per-quote.md)**
  (verified): the quote takes the price list's surcharge if it has one, otherwise the general one, and
  `applySurcharge` decides each line. **The discount combination question (§8)** is the same one
  [../quotations/fcc-billing-data-and-price-lists.md](../quotations/fcc-billing-data-and-price-lists.md)
  leaves open for FCC (*"does not say how they interact"*), and it touches
  [../quotations/gaps.md](../quotations/gaps.md) *Billing-code and price-list rules the E2E suite asserts*,
  item (e).
- **Roles agree with
  [../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md](../decisions/2026-10-20-departments-roles-main-role-and-can-also-fill-corrina.md)**
  (verified): the role carries the permissions. The four access levels and *edit = update but not
  create* (§4) are not in the vault.
- **Craft code scale agrees with
  [../decisions/2026-09-15-employee-profile-compensation-type-and-statuses.md](../decisions/2026-09-15-employee-profile-compensation-type-and-statuses.md)**:
  one overscale amount on top of the base rate, and a reason required on secondary rows.
- **Agency fields agree with
  [../decisions/2026-09-15-agency-creation-form-final-fields.md](../decisions/2026-09-15-agency-creation-form-final-fields.md)**
  (lead time in days; Manual · Email · 3rd Party Vendor · Portal). The **lead-time warning** (§5) is still
  open in [../projects-jobs/gaps.md](../projects-jobs/gaps.md) *"Latest Permit Submission" — should the
  app compute or warn on a lead-time deadline*.
- **Vendor category, terms and 1099** are open in
  [../vendors-agencies/gaps.md](../vendors-agencies/gaps.md) *PO and vendor/agency rules the E2E suite
  asserts with no written source — PR #488*. Sammy's multi-category need (§9) is new evidence there.
- **The vendor PO from DAS agrees** with
  [../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md](../decisions/2026-09-05-po-types-and-quote-to-invoice-workflow.md)
  (a vendor PO *"kicks off when the Quote is created and/or after the Job is created"*). Ryan's ask that
  the **quote** create it (§9) is the *"when the Quote is created"* branch, which is not built. The open
  question is [../vendors-agencies/gaps.md](../vendors-agencies/gaps.md) *Purchase orders at three levels*.
- **Sign-in.** [../admin/gaps.md](../admin/gaps.md) *Sign-in identity — Microsoft 365 (Entra)
  credentials, or phone number and SMS code, and for whom?* is open and owned by Patrick McKiernan. It
  blocks whether the work cell phone must be required. The build requires it for the mobile OTP (§1),
  and Brian asked about Entra on 10-20.
- **One job per day / invoice** (§9) is
  [../decisions/2026-10-20-holdovers-billed-weekly-or-monthly-other-jobs-daily-one-job-per-invoice.md](../decisions/2026-10-20-holdovers-billed-weekly-or-monthly-other-jobs-daily-one-job-per-invoice.md).
  Its exceptions are open in [../accounting/gaps.md](../accounting/gaps.md) *One job per invoice / PO*.
- **New, not in the vault:**
  - archiving a subcategory is blocked by dependent assets and billing codes (§7);
  - billing codes on employee roles (§7);
  - one price list per quote, and the fallback to general rates (§8);
  - storage, then maintenance, as the next loops (§2);
  - QuickBooks holds no cranes (§9).

## Candidates for a decision note (for `tcg-scrum`)

1. **A vendor can have several categories** (parts, rental, subcontractor, service). Sammy Garrett
   (Controller), 50:41–51:46, accepted by CodingCops. He described the need and agreed to the
   multi-select. The category list itself is not decided.
2. **Customer price lists stay separate from the general billing-code rates, and one list can cover many
   customers.** Melissa McNutt (President), 41:28 and 43:13. She endorsed what was shown and did not set a
   new rule. Write it only if the owner treats an endorsement as a decision.

**One written, one declined, 2026-10-22 (`tcg-scrum`, at syed.haris's request).**

1. **Written:** [../decisions/2026-10-21-a-vendor-can-carry-several-categories-multi-select.md](../decisions/2026-10-21-a-vendor-can-carry-several-categories-multi-select.md).
   It is `verified` on the folder's convention for a named TCG owner on a recorded call (*"Not
   confirmed in writing"* in its `decided_by:`). Sammy put the choice himself, one category plus a
   comment or several categories, and accepted the multi-select (51:46). Melissa named him as a
   vendor creator (11:18). Only multi-valued is decided. The category list, whether one is required
   and what a category drives are recorded as not decided. It partly answers (f) of
   [../vendors-agencies/gaps.md](../vendors-agencies/gaps.md) *PR #488*, which stays open and was
   not edited.
2. **Declined.** The folder's convention, as applied in
   [../decisions/2026-10-13-collections-worked-at-customer-level-not-invoice-level.md](../decisions/2026-10-13-collections-worked-at-customer-level-not-invoice-level.md),
   records only the point a TCG owner **chose between named alternatives**. Approval of a design
   on screen does not count; that note lists Brent's *"that's fantastic"* and *"Yep, exactly"* as
   design, not decided. Neither of Melissa's turns is a choice:
   - *"I like it separated"* (41:28) answers ehtesham.anwar's description of what is built (41:01).
     He offered no alternative to keeping the lists apart. The only option in that turn was
     renaming the billing codes page to *"general price list"*, and nobody took it up. Her line can
     also be read as being about that rename.
   - *"I think we could do multiple … attach multiple customers to a price list too"* (43:13)
     corrects Kaitlin's reading that each list is for one customer. ehtesham.anwar had already said
     the build allows this (41:01), and he answered that it allows *"only one customer or 100
     customers"* (43:23). Nothing was restricted or chosen, and *"could"* is tentative.

   Both points are still recorded as built in §8. They agree with FCC, where the price list is a
   field on the customer
   ([../quotations/fcc-billing-data-and-price-lists.md](../quotations/fcc-billing-data-and-price-lists.md),
   `unverified`). If TCG later states either point as a rule, in writing or as a choice on a call,
   it can be recorded then.

## 12. Questions this raises — filed 2026-10-22

No ticket covers these, so each went to a module register: a new entry where none existed, otherwise an
*Update 2026-10-22* on the open entry.

1. **Price-list discount plus the quote's own discount or price hike** (§8) — new:
   [../quotations/gaps.md](../quotations/gaps.md) *Price-list discount plus the quote's own discount or
   price hike — added, compounded, or exclusive?*
2. **Tax on the quote, by job site** (§9) — update on [../quotations/gaps.md](../quotations/gaps.md)
   *Does a quotation carry sales tax at all, and if so on which amount?*. The taxable flag on billing codes
   is an update on *Billing Code Flags and Surcharge checkboxes*.
3. **A vendor line on the quote that creates the PO** (§9) — update on
   [../vendors-agencies/gaps.md](../vendors-agencies/gaps.md) *Purchase orders at three levels*.
4. and 5. **QuickBooks vendors and billing codes** (§9) — one new entry:
   [../accounting/gaps.md](../accounting/gaps.md) *QuickBooks direction for vendors and billing codes*.
6. **Approval on any rate change, or only below** — update on [../quotations/gaps.md](../quotations/gaps.md)
   *Is the $50,000 approval threshold inclusive or exclusive?*. The code triggers only on a rate **below**
   the reference rate (or over the threshold), so the build matches the review log; the documentation's
   *"amount that is changed"* wording overstates it and is CodingCops' to correct. Not a TCG question.
7. **What the "storage" loop covers** (§2) — new: [../assets/gaps.md](../assets/gaps.md) *The "storage"
   loop after accounting — what does it cover?*

Sign-in (§1) also got an update on [../admin/gaps.md](../admin/gaps.md) *Sign-in identity*.
