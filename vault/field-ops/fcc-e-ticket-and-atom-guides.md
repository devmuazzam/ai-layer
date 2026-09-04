---
title: How the e-ticket works in FCC NexGen and Atom — the vendor's own user guides
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/ — NexGen_Modular_ETicket_User_Guide_v.3.0.pdf, FCC_AdvancedChecklistsUserGuide_2025.pdf, Atom-MFA_2FA-Biometrict-Authentication-User-Guide-v1.0.pdf, OneDrive_2025-10-29/Operator User Guide (Atom)v.1.0.docx (text and its embedded screenshots, read 2026-09-04)
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/field-ops, module/dispatch, module/payroll, module/assets, module/admin, kind/reference, ticket-workflow, time-tracking, inspections, signatures, wtl, craft-code, union-agreement, offline, geolocation, notifications, authentication, permissions-roles]
entities: []
---

# How the e-ticket works in FCC NexGen and Atom

**What this is.** Four manuals written by **Fleet Cost & Care** (Detroit, MI), vendor of **NexGen
FMS** and its mobile companion **Atom** — the systems TCG's field crews use today. They arrived in
the 2026-09-04 Project Repository drop under `1.0.2_FCC-RESOURCES-GUIDES`.

**Why it matters.** Three FRDs and a set of user stories in this folder all describe a *replacement*
for this software, and the vault holds two completed tickets it produced
([e-ticket-worked-example.md](e-ticket-worked-example.md),
[e-ticket-worked-example-44944.md](e-ticket-worked-example-44944.md)) — but until now nothing that
says **how the current e-ticket actually behaves**. Several features named on those printed tickets
(`Ad-hoc Checklist`, `As recorded for the customer`, `Derived Hours`, phase sections such as
*Before Left Yard*) are defined nowhere else in the vault. They are defined here.

> **Legacy behaviour, not a TCG requirement.** The rule in
> [domain/fcc-nexgen-fms.md](../domain/fcc-nexgen-fms.md) applies: no spec may cite "FCC does X" as
> the basis for a requirement unless that behaviour is written down in the vault or on a ticket.
> This page makes the behaviour *checkable*. It is also **vendor-generic** — every guide says
> repeatedly that features are switched on or off per organisation, so nothing here is evidence
> that TCG has a given feature enabled. Where a printed TCG ticket shows a feature in use, that is
> said explicitly.

| Guide | Version / date | Covers |
| --- | --- | --- |
| `NexGen_Modular_ETicket_User_Guide_v.3.0.pdf` | **v3.0, December 2022** | 51 pages. The modular e-ticket: its three tabs, cancellation and reconstitution, lift info & specifications, the Atom side (statuses, workflow, editable times, checklists, labor), and the settings that enable it all |
| `FCC_AdvancedChecklistsUserGuide_2025.pdf` | **v1, January 2025** | 16 pages. Ad-hoc checklists for units and components, checklists inserted into an existing e-ticket, checklist history |
| `Operator User Guide (Atom)v.1.0.docx` | **v1.0, "1st Draft"**, undated | The **pre-modular** Atom: dashboard icons, Operator/Job ticket, LEM ticket, Trucking ticket, the `Hours & Miles` tab, My Labor, FAQs |
| `Atom-MFA_2FA-Biometrict-Authentication-User-Guide-v1.0.pdf` | **v1.0, July 2024** (release 2024.1) | 20 pages. TOTP two-factor and biometric login for Atom |

`Operator Only User Guide (Atom).docx` in the same folder is **byte-identical in converted text** to
`Operator User Guide (Atom)v.1.0.docx` — the same document under two names, migrated once.

**The operator guide and the modular guide describe two generations of the same app.** The operator
guide's `Hours & Miles` tab is explicitly *replaced* by the modular guide's `Labor & Unit Details`
tab. TCG's printed tickets show the **modular** generation. The older guide is kept here because it
is the only document that explains the **Trucking Ticket** and the dashboard icon model, neither of
which the modular guide covers.

---

## 1. The modular e-ticket is three tabs, and only two of them face the customer

> *"An e-ticket is comprised of three main components – the e-ticket (Main tab), Checklist, and
> Labor & Unit Details. The Main tab is equivalent to the paper job ticketing solution and can be
> sent to customers... The Checklist tab, if configured to do so, can be signed by, and sent to the
> customer from within Atom. The Labor & Unit Details tab replaces the Hours & Miles tab."*

| Tab | Audience | On the printed TCG tickets |
| --- | --- | --- |
| **E-Ticket (Main)** | customer | `Job E-Ticket - 44944.pdf` |
| **Checklist(s)** | customer, if configured | `Job E-Ticket Checklist - 44944.pdf` |
| **Labor & Unit Details** | *"for internal purposes"* | `Job E-Ticket Labor & Unit Details - 44944.pdf` |

So TCG's three PDFs are exactly this three-tab structure, printed.

### What is on the Main tab, and what is configurable

Nearly every block on the Main tab can be **relabelled, reordered, or hidden**, separately for Atom
and for print, in `Maintain > E-Ticket Settings`:

- **Company Header** — salespersons, company address, job number, ticket number, date. Address comes
  from the **company + yard** combination declared on the job. Can be hidden in Atom or in print.
- **Hook Ready Time** — *"an additional, generic time field – you may rename this field"*. Displays
  as a banner: at the top for Job Tickets, under the unit banner for LEM Tickets, where it *"may be
  unique to each unit"*. Defined at unit level only; varied per day via a specifications record.
  (TCG ticket 44944 carries `hook ready 8AM` in the job `Comments` field rather than in this
  field — the guide does not say why an organisation would do that.)
- **Job Information** — a compound section of sub-sections, each individually relabelled and
  reordered; `Directions` always renders last and only when the job site has directions.
- **Equipment Required**, **Description of Work**, **Comments** — three rich-text fields populated
  from the job of the same names.
- **Lift Information** — up to ten fields; *"the e-ticket will only display populated fields"*.
- **Team Information** — a titled section of sub-sections. *"If a label/value pair is removed from
  view in mobile, it is also removed from view in print and vice versa."*
- **Ticket Comments** — displays only if a field employee entered comments; plain text; *"only
  updated within the e-ticket in Atom"*.
- **Display Times & Signatures** — Start and End times sit on the Main tab; visibility of each time
  is configurable per medium. *"Controlling the visibility of times does not affect the workflow
  button or the workflow in general."*

### Lift info has two levels, and the unit level wins

`Lift Info` is a **job-level** pane; `Specifications` is the **unit-level** equivalent with more
fields, on the Resources tab. *"When Specifications-based lift info exists in the job, this
information will override any Lift Info (Main tab)"* — for any date the specification is scheduled
for. On job tickets the specification replaces the ticket-level lift info; on LEM tickets it renders
inside the **Team Information** section instead. If lift information is to live only at unit level,
the guide says to leave the job-level pane blank.

---

## 2. Checklists: job, unit, and ad-hoc

### Three checkboxes, one of which has logic

> *"The checklist feature works with up to three checkboxes of definable purpose, with one checkbox
> having reserved functionality due to logic. This checkbox is the 'Deficiency' checkbox and when
> checked requires the user to declare a **priority** and add a **comment**. The 'Completed' and
> 'N/A' checkboxes do not have conditionals."*

This is the `Completed · Deficiency · N/A` triple printed on both TCG tickets. **Column labels are
renameable in NexGen and the change applies to all job checklists**, so `Deficiency` may read
differently elsewhere. Priority and comment are entered by tapping the comment icon on the row.

**Deficiencies on unit checklists flow onward:** *"Deficiencies declared on unit checklists will be
passed to NexGen and can be managed in the `Enter > Work Orders from Deficiencies` screen."* That is
the mechanism behind `FR-FOP-025 Deficiency Reporting`; see
[fcc-nexgen-service-guide.md](fcc-nexgen-service-guide.md) for the work-order side.

### Job vs unit vs ad-hoc

| Kind | Defined in | Applies |
| --- | --- | --- |
| **Job checklist** | `Maintain > Job Checklists`, assigned per job; a default may be set in `Set System Defaults` | to every e-ticket issued for that job. *"used to support job-related tasks like OSHA powerline checklists or Job Safety Assessments (JSAs/JHAs)"* |
| **Unit checklist** | `Maintain > Units`; included on all e-tickets by default | every time that unit is on an e-ticket. *"common practice to mirror the checklist to the steps defined in the operating/service manual"*. If several units on one ticket have checklists, **the primary employee receives them all** |
| **Ad-hoc checklist** | `Maintain > Resources > Ad-hoc checklists` | see below |

A unit checklist renders as `Unit (<Unit Code>) <title>` — which is exactly the
`Unit Checklist - 10002 - Crane Pre-Trip Inspection` heading on TCG's ticket.

### The `Section` dropdown is what prints the phase headers

> *"All checklists are defined in NexGen and during the process, timing of the checklist is set. The
> Section dropdown ... is used to denote the timing and allow you to navigate between different
> segments of checklists (e.g., 'before left yard', 'after arrived job')."*

**This is the origin of `Before Left Yard` / `After Arrived Job` / `Before Left Job` on TCG's printed
tickets.** They are a per-checklist `Section` value, configured in NexGen — not a hard-coded
workflow stage. A checklist whose Section is **`NA`** *"will not download onto an e-ticket"* and is
instead available in Atom by Unit ID on its own.

### Ad-hoc checklists — the fourth phase on TCG's tickets

From the Advanced Checklists guide (Jan 2025). Two system-default switches, `Ad-hoc Checklists for
Units` and `Ad-hoc Checklists for Components`, plus *advanced checklist functionality*:

> *"Advanced checklist functionality allows users to define a class of checklists associated with
> jobs or units. These checklists can be appended to an existing, uncompleted e-ticket by an Atom
> user in the field (as long as there is internet connectivity). Once assigned to an e-ticket, they
> **must be completed before the e-ticket can be finalized**."*

In Atom this is `Add Checklist` on the Checklists tab: a default checklist from NexGen shows, and a
dropdown lists everything defined on the Ad-hoc Checklist screen; **both job and unit checklists are
offered**, and choosing a unit checklist prompts for which unit on the job. The user need not
complete it at once, but *"they will receive a warning message"* if they try to complete the ticket
first. **`This functionality is only available in LEM tickets.`**

Two more things it defines:

- **Ad-hoc checklists not tied to a ticket** — Atom gains two widgets, `Ad-hoc Checklist` and
  `Checklist History`, that work by Unit ID or Component ID with no e-ticket at all. Results are
  stored back on the unit or component record.
- **Checklist History**, in Atom and in NexGen, filterable to `Ad-hoc Unit (NA)`, `Ad-hoc e-ticket
  (inserted)`, `e-ticket (legacy)` or all. **Default view is the last 90 days**; the user can widen
  it. This is the closest thing in any source to a retention/visibility rule for inspection history,
  and the FRD lists "Inspection retention requirements" as still *Pending*.

Options per ad-hoc checklist: save a PDF copy back to NexGen (needs a document template record),
**require a signature**, and **mark tasks to be added to the work order deficiency report if they do
not pass**.

> **On TCG's tickets**, `Work Through Lunch Authorization` is filed under the `Ad-hoc Checklist`
> header on both 45954 and 44944 — i.e. TCG uses the ad-hoc mechanism to attach the WTL
> authorization to a live ticket in the field, which is consistent with it being a
> *"job"*-type ad-hoc checklist added when the missed meal actually happens.

---

## 3. Labor & Unit Details — the internal tab

> *"it shows all times according to when the workflow button was tapped, the location where the
> event occurred (if permissions are granted), and a breakdown of labor for all employees."*

- **Ticket Summary** — every timestamp recorded by the primary ticket holder plus locations, and the
  total hours across all employees. *"Total Ticket Hours do not factor in any entry that is linked
  to a MISC-related pay type craft code. This field will only show labor hours, no per diem, missed
  meals, or the like."* Any geo-coordinate is clickable and opens a map.
- **Primary Employee** — `REG` hours first; a second block, `Other Entries`, shows **only
  MISC-related entries**: the guide's own example is *"a MISC-OTHER pay type labor entry ... added
  for a missed meal"*, alongside *"Per Diem, Late Meals, Mileage"*. Below the labor entries sit unit
  hours and miles, which can be hidden where a GPS integration supplies them.
- **`Hours Worked` vs `Derived Hours`** — *"Hours Worked is the value entered/overwritten in the
  Hours field of the ticket; Derived Hours is the difference between the End and Start times."*
- **Secondary Employees** — same two blocks; **no unit details**; a **red caret** marks a labor entry
  *added on behalf of* a secondary employee by the primary. (TCG's 44944 print carries exactly that
  caret on the second employee's row.)
- **Footer** — a non-editable system disclaimer that GPS accuracy is not guaranteed and the user
  cannot be forced to keep location on.

### Primary vs secondary tickets

> *"A primary ticket refers to a ticket that includes the workflow and requires the collection of
> customer signatures. Additionally, primary tickets allow labor entry for secondary employees (as
> long as your organization allows it). Secondary tickets are only used for informational purposes
> and collecting individual labor entries."*

Secondary holders have **read-only access to everything operational including the checklist**, no
workflow buttons, and may not add ticket comments or modify a checklist — but may enter their own
labor and upload files. Primary tickets show black labels in the card's left column, secondary blue.
`Job Tickets` carry at most **two** employees; `LEM` tickets have **no limit**.

The older operator guide describes the LEM shape in the same terms: *"a rigging foreman and four
riggers would receive LEM tickets. This works as a single Job Ticket plus four read-only tickets."*

---

## 4. The Atom workflow — statuses, editable times, offline

### Status model

```
New → Downloaded → Not Started → Started → Left Yard → Arrived Job
    → First Signature → Second Signature → Left Job → Arrived Yard → Ended → Completed
                                    Canceled ↙ (any point up to first signature)
```

*"When a ticket is first viewed in Card View, its delivery state will be 'Viewed'. Once opened, this
status will change to 'Downloaded'."* **Any e-ticket up to the point of first signature may be
cancelled**; after that it cannot.

Cards sort reverse-chronologically. **A ticket issued for a future date opens read-only**, with a
notification, *"to prevent the inadvertent starting of a ticket for a future date"*. Completed
tickets are cleared by `Remove Completed Tickets` with a cut-off date; a cancelled ticket clears when
tapped.

### Editable times — four settings, and the "as recorded for customer" split

Set in `Admin > Set System Defaults`, **E-Documents** tab. Four progressively looser options:

| Setting | Effect |
| --- | --- |
| *(none checked)* — default | **No workflow time may be edited at all.** |
| `Allow Editing of Leave Yard & Arrive Yard` | those two only, and *"editing of either time may only be done during that portion of the workflow. Once the workflow is advanced, the user will not be able to modify the time."* |
| `Enable Start and Stop Times` | adds two more time entry points and two more workflow buttons; workflow taps auto-populate Labor & Unit Details, hours auto-calculate from stop − start, and both may be overridden |
| `Allow modification of all dates and times for Job and LEM Tickets` | everything, subject to the four constraints below. Supersedes the Leave/Arrive Yard option, which can then no longer be turned off. Applies to **Job and LEM tickets only** — not Trucking or Load tickets |

The four constraints on full modification:

1. all preceding time entries **lock when the second signature is applied**;
2. all entries after the second signature **lock when the ticket is completed**;
3. **all original workflow times are still recorded and available in NexGen**;
4. **the user must provide a justification for the modification of a time.**

And the reporting consequence, which is exactly what TCG's ticket 44944 prints:

> *"The Job E-Ticket Report will display a new section called '**As recorded for customer**.' This
> section displays all of the times that were ultimately entered on the e-ticket as presented to the
> customer. To the left of this section is a listing of time stamps that relate to the workflow
> button in Atom."*

The guide's own worked example has **workflow hours of 0.05 and customer hours of 3.00**. Modified
times then propagate: they *"replace the workflow times"* on `E-Ticket Not Approved or Invoiced`,
`E-Tickets Not Invoiced` and the `Rental Invoice`, shown **orange and italic** to mark them as not
original. On `Labor` and `Labor for Payroll Preprocessor` the e-ticket times appear read-only with
modified ones distinguished; a user with permission can still change Start/End there, *"but changes
will not reflect for billing purposes"*.

> **This is the single most consequential behaviour on this page for the ERP.** The current system
> deliberately keeps two answers to "when did this happen", routes the customer-facing one to
> billing, and keeps the device one for audit. Neither FRD in this folder mentions it. See
> [e-ticket-worked-example-44944.md](e-ticket-worked-example-44944.md) §3 for the artifact.

### Connectivity

> *"Once a ticket is downloaded, the ticket will be available to work through while disconnected
> from any service. The only steps that are prevented during no connectivity are **completing the
> ticket** and **entering labor information**."*

Atom stores everything in a local database on the device regardless. Wi-fi-only devices are
supported (some features, e.g. tel: links, are not). Note the asymmetry against the FRD/demo, which
treat offline as fully transparent: FCC's Atom **cannot take labor entry offline**.

### Cancellation, reconstitution, forced completion

Managing ticket state from NexGen is *"not a best-practice"*; the guide restricts it to cases the
ticket holder cannot resolve — a personnel change, a cancelled visit, a dead device.

- **Cancellation** prompts the dispatcher with any labor already on the ticket — entries that
  *"have not been committed to the Labor for Payroll Preprocess screen yet but are in the
  database."*
- **Enhanced E-Ticket Cancelation** is on by default with modular e-tickets: any cancelled or
  completed ticket is **auto-converted to PDF and stored on the job**, and the option to *delete* an
  e-ticket is removed. Cancelled PDFs carry a watermark and `- Canceled` appended in Comments.
- **Reconstitution** — *"E-Ticket reconstitution cannot be disabled and is the only recourse for a
  field employee if communication breaks down from the office (e.g., no cell service)."* If dispatch
  cancels while the crew is out of coverage, Atom lets them advance the ticket anyway and NexGen
  resumes tracking it on reconnect. The issuing user is emailed, subject
  *"Ticket cancelation has been revoked"*. If the resource was reassigned in the meantime, the
  employee is blocked from continuing.
- **Forced completion from NexGen** is permanent — *"There is no recourse for a completed e-ticket."*
  Labor already present is passed to the Labor for Payroll Preprocessor; labor added later still
  flows, **up to the point of labor approval for the period or invoicing**.

### Granular union access control

A `Unions` tab on `Maintain > Employees`. Blank by default, in which case *"the existing default
union will apply and all other unions will be available to select from in Atom"*. Populate it and
the employee sees only those unions in e-tickets and My Labor — *"avoid the risk of someone
selecting an inappropriate union"*. Nothing in the guide says which unions TCG has configured.

---

## 5. The older Atom operator guide — what only it covers

- **Login** requires an **Atom URL** obtained from an administrator (it links the app to NexGen),
  then username/password, then a database selection if several exist (*"Most often, the
  FCC_NEXGENFMS is the default"*). *"Atom does not provide the option to save a password, this is
  to ensure the system remains secure."*
- **Dashboard icons** — Operator/Job Ticket, LEM Ticket, Trucking Ticket, My Work Orders, My Labor.
  Each ticket icon carries a red count bubble for newly issued tickets that clears on tap
  *"even if the user does not action any tickets"*. Which icons appear is permission-controlled in
  NexGen.
- **Ticket list colour code** — *"Rows in red are new tickets that have not been completed, blue
  tickets are read only, and black means that the ticket has been completed."* Sorted by **ticket
  number, not date**.
- **The workflow button** is one button that changes label as work progresses:
  `Start Time` (optional) → `Left Yard` → `Arrived Job` → `Terms & Conditions` → `First Signature`
  → `Worked Through Lunch` → `Second Signature` → `Left Job` → `Arrived Yard` → `End Time`
  (optional).
  Two notes matter. The **Terms & Conditions** step is a shortcut to the T&C block and
  *"must be tapped before obtaining the customer's signature"*. And **`Worked Through Lunch` is a
  yes/no toggle** — *"If selected, the button will highlight to an orange color and additional
  information will be added to the ticket"*. In this generation WTL is a single boolean on the
  ticket, with no times, no count, and no customer signature of its own.
- **File Links** — view job attachments (a site plan or permit saved in NexGen and flagged visible
  in Atom), take a photo, upload a photo, upload a file; all of it returns to NexGen.
- **E-Mail** generates a PDF of the ticket and hands it to the device's mail client.
- **Complete** *"can only be tapped once"*; **labor can still be adjusted after Complete**.
- **Trucking Ticket** — same shape as a job ticket, differing by *"the use of multiple addresses
  (pickup location, drop-off location)"*. No other source in the vault describes it.
- **My Labor** — labor from job tickets, trucking tickets, work orders and **manual entries for yard
  or miscellaneous work**, browsable by date range. A new entry pre-populates `Craft Code`, `Union`,
  `Position`, `Dept`, `Work Comp`, `Burden`, `Class` from configuration. *"If a Work Order number is
  entered, a Job number cannot be added and vice versa."*
- **The labor lock rule**, from the FAQ: *"Labor can be modified up to the point when management
  reviews and approves the labor. After the labor is marked 'approved', no further changes can be
  made from Atom."*

---

## 6. Atom MFA and biometric login

From the July 2024 guide (release **2024.1**). Both features are **off until a client administrator
enables them in NexGen**; only then does the option appear on the device.

- **MFA/2FA** is TOTP via an authenticator app — *"Support a second factor of authentication using
  the authentication apps like Microsoft or Google Authenticator. **Currently push notifications to
  the user's device is not supported.**"* Setup is `Settings > Enable 2FA` → QR code or manual setup
  code → enter the generated code to confirm. Thereafter the code is prompted at every login. The
  user can turn it off from `Disable 2FA` on the home-screen overflow menu. *"FCC highly recommends
  leaving this feature turned ON."*
- **Biometric** is fingerprint or Face ID, iOS and Android. Biometric material stays *"within the
  device's secure enclave"*. Once enabled, *"they can directly hit 'Login' without entering the
  username or password"*, and un-checking the setting restores username/password as the fallback.

Both are **per-user opt-ins under an org-level switch**, and 2FA is disableable by the end user.
`FR-FOP-001`-series requirements and the Atom user stories describe biometric login for the new app;
nothing in this guide says what TCG has enabled today.

---

## 7. Where each printed feature on TCG's tickets is defined

| Seen on TCG's e-tickets | Defined by |
| --- | --- |
| `Before Left Yard` / `After Arrived Job` / `Before Left Job` headers | the checklist **`Section`** value, per checklist, in NexGen |
| `Ad-hoc Checklist` header | advanced checklists inserted into a live LEM ticket, **LEM only** |
| `Completed · Deficiency · N/A` columns | the three configurable checkboxes; `Deficiency` forces priority + comment |
| `Unit Checklist - 10002 - …` heading | unit checklists render as `Unit (<code>) <title>` |
| `As recorded for the customer` vs `by the workflow` | `Allow modification of all dates and times` |
| `Hours Worked` vs `Derived Hours` | override value vs End − Start |
| `Other Entries: No non-labor entries were entered` | the MISC-pay-type block (per diem, missed meals, mileage) |
| `^ Recorded on primary device` caret | a labor entry added by the primary on a secondary's behalf |
| The GPS accuracy footer | the fixed, non-editable Labor & Unit Details footer |

## Source

- `1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/NexGen_Modular_ETicket_User_Guide_v.3.0.pdf` — 2.4 MB, 51 pages, `pdftotext -layout`. Every screenshot lost in conversion; several sections (the status diagram, settings tabs) are image-led and only their captions and surrounding prose survive.
- `1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/FCC_AdvancedChecklistsUserGuide_2025.pdf` — 3.4 MB, 16 pages, `pdftotext -layout`. Heavily screenshot-led; the menu paths quoted here come from the figure captions, which did survive.
- `1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/Atom-MFA_2FA-Biometrict-Authentication-User-Guide-v1.0.pdf` — 2.2 MB, 20 pages, `pdftotext -layout`.
- `1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/OneDrive_2025-10-29/Operator User Guide (Atom)v.1.0.docx` — 1.6 MB, pandoc gfm; its embedded screenshots were extracted and viewed on 2026-09-04 (see *What the screenshots show*). Its twin `Operator Only User Guide (Atom).docx` (1.6 MB) converts to byte-identical text and is not migrated separately.

No credentials, tokens or personal data appear in these guides.

## What the screenshots show — read 2026-09-04

The screenshots embedded in `Operator User Guide (Atom)v.1.0.docx` were extracted and viewed
on 2026-09-04. The file stores its images in two places: 13 in the usual `word/media/`
(12 PNGs plus one JPEG-XR `hdphoto3.wdp`, which is a high-definition duplicate of the
`image27.png` camera screenshot beside it and was not rendered separately), and a further
28 PNGs in a root-level `media/` folder that the text conversion references and the first
image extraction missed. The 17 of those that are screens rather than icons were viewed too;
the icons are the dashboard glyphs and button chips the text already describes. This section
covers **only the older operator guide**; the three PDF guides on this page were not
re-read. Only what §5 did not already say is recorded.

### Dating and platform

Every screen shows **Atom 2.2.83, © 2013-2016 Fleet Cost & Care**, on an Android tablet;
the ticket dates on the screens are **August 2017**. So the "undated 1st Draft" is a
mid-2017 document about the 2.2.x app — the same vintage as the Payroll and Purchasing guides.

### Login and dashboard

- The login screen is two-stage: an **Atom Url** field with a **Connect** button first; once
  connected, **Username · Password · Database** (dropdown, demo `FCC_NEXGENFMS`) and
  **Login / Cancel** appear. The URL has the shape `https://<host>/atom/`.
- The dashboard is titled **Main** and has **two groups, not one**. **E-Documents**: Operator
  Ticket · LEM Ticket · Trucking Ticket · My Work Orders · My Labor. **Enter**: **Labor ·
  Work Orders**. The text describes only the first group; the second — direct labor and
  work-order entry outside any ticket — is visible but not explained anywhere in the guide.
- The header **overflow menu** holds **Display Registration · Contact Support · Request
  Assistance · Change Password**.

### Ticket list screens

- **Job Tickets** list: legend *"Tickets in Red are not Completed / Tickets in Blue are read
  only"*; columns **Ticket No · Ticket Date · Est. Start · Est. End · Job No · Customer ·
  Unit Code · Act. Start…** (more columns off-screen). Sorted by ticket number descending.
  Demo ticket numbers are four digits; demo job numbers are both plain (`2379`) and prefixed
  (`CC-982372`), so the job-number field is free-form text. Est. Start/End are the job's
  scheduled times (demo `7:30 AM` / `4:30 PM`).
- **Job LEM** list: same legend worded for LEMs; columns **Ticket No · Date · Est. Start ·
  Est. End · Job No · Customer · Act. Start · Act. End · In Signed By…**.
- **Trucking Tickets** list: columns **Ticket No · Ticket Date · Est. Start · Est. End · Job
  No · Customer · Unit Code · Act. End · Report To…**.

### The Job Ticket

Tabs **Main · Check List · Hours & Miles**; header buttons **SAVE · FILE LINKS · ⋮**. Main
opens with the **Start Time** workflow button, then **Date · Job No · Ticket No**, the yard
name, **Ph / Fax**, **PO #(Req)**, **Salesperson · Phone**, **Customer · Address · Terms ·
City, State Zip · Phone** (phone numbers render as tap-to-dial links). The label
**`PO #(Req)`** marks the PO number as required on this job — a per-job required-PO flag the
text does not mention.

The workflow buttons render as paired chips — `First Signature | Accept Terms & Conditions`
and `Second Signature | Worked through lunch` — confirming the button order in §5.

**Check List tab**: header Date / Job No / Ticket No; each numbered item has **Completed**
and **N/A** checkboxes and a **Comments** box. **Two checkboxes only** — this generation has
no *Deficiency* column, which is consistent with the three-checkbox model being a modular
(2022) feature.

**Hours & Miles tab**: **Operator** (`<role> - <name>`); **Start Time / End Time** buttons
(blank `--:-- --`; tapping opens an Android clock picker with **Clear / Set**); **Operator
Hrs** `0.00`; **Craft Code** (demo `DFLTA`) with a picker arrow; **Position** dropdown (demo
`Crane Sh…`); **Comments**; then **Unit Hrs/Up · Unit Hrs/Lo · Unit Mi/KM** — unit hours split
**upper / lower**, as on the printed e-ticket; and an **Additional Hours** link for further
labor lines.

### The LEM ticket

Tabs **Main · Hours & Miles** — **no Check List tab** on the LEM screens shown (the text
has a "Checklist" heading under LEM Ticket with no body; the screenshot suggests it was not
present in this build). Main carries the company name/address/phone header, **PO #**,
**Salesperson · Phone** in the same layout as the job ticket.

**Hours & Miles** has two sections. **Labor**: one numbered block per employee with
**Employee Type** (demo `Operater, 1st class` — a labour classification, not a craft code) ·
**Employee** · **Comments** · **Start Time / End Time** · **Hours** · **Craft Code** ·
**Position** · **Comments** · and a **`Worked Through Lunch` checkbox per employee**.
**Units**: one numbered block per unit with **Sched Type** (demo `Crane - Mobile, Hydraulic`)
· **Unit Type** (`100 Ton Mobile`) · **Unit Code** (four-digit, `5835`) · **Comments** ·
**Hrs/Up · Hrs/Lo · Mi/KM**. **Additional Hours** at the foot.

**This refines §5's WTL note.** On a job ticket WTL is the workflow toggle; on a LEM the same
fact is a **checkbox on each employee's labor block**, so a multi-employee LEM records it per
person. The guide does not say whether the two feed the same field in NexGen.

### The Trucking ticket

Tabs **Main · Hours & Miles**. Main, top to bottom: **Start Time**; **Date · Job · Ticket No**;
yard address; **Ph / Fax**; **PO #**; **Terms** (demo `Net 30`); **Salesperson · Phone**;
**Cust Code** (four-digit, `0335`) · **Customer Phone** · **Customer · Address · City, State
Zip**; then a **Ship From** block (name, **Address** and **City, State Zip** as map links,
Phone, Alt Phone, **Directions**); a **Ship To** block (name, Address, Phone, Alt Phone,
**Report To**, **Cell Phone**, **Work Phone**, Directions); **Items To Ship**;
**Instructions**; **Work Desc**; **Equipment** (`Truck, Y34`); **Employee** (`Driver -
<name>`); **Oiler**. This is the concrete form of "multiple addresses (pickup location,
drop-off location)": the ship-from and ship-to blocks replace the job-site block.

Hours & Miles: **Driver** · **Start Time / End Time** · **Driver Hrs** · **Craft Code** ·
**Position** · **Comments** · **Unit Hrs/Up · Unit Hrs/Lo · Unit Mi/KM** · Additional Hours.

### File Links

Screen title **Job File Links**, headed by the job as `Job - <job no>`; actions **TAKE PHOTO ·
UPLOAD PHOTO · UPLOAD FILE**. Empty state: *"Filelinks are empty. Please add a file from the
menu."* A saved file shows as a card with the filename, a description, uploader and timestamp,
and an **`Available on Tickets ✓`** flag. Photos taken in Atom are named
**`<job no>_<yyyymmddHHMMSS>.jpg`**. Upload Photo hands off to the device gallery; Upload
File opens the device file system at `/storage/emulated/0`, where an `atom` folder exists.

### My Labor

Opens on **From / To** date buttons and **View**, with a green **+** (`ADD`) top right. The
list is headed by the date range and the employee, and each entry card shows **Work Date ·
Craft Code · Quantity · Rate · Amount · Job · WO · Unit Code · Activity Code · Start Time ·
Stop Time** — **the employee can see Rate and Amount on their own labor** (demo values were
zero). The new-entry form (tab **Main**, button **SAVE**): **Employee** (search) · **Work Date**
· **Union** (dropdown) · **Craft Code** (search) · **Start Time / Stop Time** · **Hours** ·
**Rate** · **Amount** · **Job** (search) · **Job Line Item** (disabled until a job is chosen)
on the left; **Work Order** (search) · **Unit Code** (search) · **Activity** (code + name,
demo `100SRVU – 100 hr. serv. upper`) · **Position** · **Dept** · **Work Comp** · **Burden** ·
**Class** · **Comments** on the right. Demo values name a `Mechanic` department, `Crane Shop
Labor` position and `Mechanic Labor` class — the pre-populated defaults §5 lists.

### FAQ dialog

Tapping a ticket the dispatcher has deleted shows a **Job Tickets** dialog reading
**"Job Ticket doesn't exist"** with a single **OK**; dismissing it is what clears the ticket.
