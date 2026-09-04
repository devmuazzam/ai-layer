---
title: FCC NexGen administration and security model
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/ (NexGen WPF Admin Guide v2.0, security cheat sheet, ATOM Google Play sysadmin guide) + 1.0.1_BUSINESS-REQUIREMENTS/FCC_NexGen_MENUS/FCC_MAINTAIN_COMPANY (reviewed by TCG).pptx (slide text, notes and the 34 embedded screenshots, read 2026-09-04)
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/admin, kind/source, permissions-roles, authentication, reference-data, architecture]
entities: []
---

# FCC NexGen administration and security model

**What this is.** How the legacy system's administration works, from four sources: FCC's own
**NexGen WPF Admin Guide v2.0** (David Thornton, 10 January 2022), FCC's one-page **security
cheat sheet** on Users/Profiles/Menu Security/Profile Screen Security, FCC's **ATOM Google Play
System Administrator's Guide v1.0** (June 2021), and a **TCG-annotated slide deck of the Maintain
Company screens** in which TCG marked which parts of company setup it does and does not need.

**Why it matters.** The RFP requires "role-based access control: permissions by department/role"
without saying what that means in practice. This page records what the system TCG is used to
actually does — a **four-layer** permission model that is materially more granular than a role
enum. It is background for designing the replacement, **not a requirement**: nothing here says the
new platform must work this way.

> **This is a description of a legacy vendor's product, not a specification for ours.** Per
> [../domain/fcc-nexgen-fms.md](../domain/fcc-nexgen-fms.md), no spec may cite "NexGen does X" as
> the basis for a requirement unless that behaviour is written down in the vault or on a ticket.

---

## The four layers of NexGen security

From the security cheat sheet, which gives them as an ordered setup procedure:

### 1. `Admin > Profiles` — create the profile

Profiles are the unit of permission. Create the profile name first; the screen offers a **Copy
Profile** function to clone an existing one.

### 2. `Admin > Menu Security` — which screens exist for this profile

Controls whether users can *see* individual screens. FCC's stated defaults:

- **Disable the "Delete Master" button on all screens.** Most users do not need to delete a master
  record — "however, there are exceptions".
- **Disable "Add" under File Links.** That option lets a user attach a file link visible only to
  themselves; in most cases file links should be visible to anyone with access to the screen.

### 3. `Admin > Profile Screen Settings` — field- and tab-level access

The finest layer: **edit / view-only / hidden, per individual tab and per individual field** on a
screen. FCC's stated default:

- **Always disable edit access to system-generated / auto-sequence numbered fields** — Job #,
  Quote #, Customer #, Vendor #, Purchase Order #, Work Order #, Voucher #, and so on.

The Admin Guide adds the mechanics: **required columns cannot be disabled individually** — to hide
a required column you must disable the whole containing object (window, pane, tab or grid). In the
settings UI, a greyed-out checkbox means the field is system-required; a white checkbox means it
may be disabled or hidden. **Changes take effect only after the user closes and reopens the
application.**

### 4. `Admin > Users` — the user record

Per the cheat sheet, each user is set up as:

- **User ID from Active Directory** — "this is for all users, including field employees".
- First and last name.
- **If the user will be dispatched on a job or work order, or will have hourly payroll captured
  through Atom/NexGen, tie their Employee record to the user.** This is the join between the login
  identity and the payroll/dispatch identity.
- Assign the appropriate profile.
- **Default Company** and **Default Yard** = their home company/yard.
- **My Companies** and **My Yards** = home company/yard *plus* any additional yard the user needs
  access to — the guide's example is dispatch needing neighbouring yards.
- **User Boxes: uncheck all options by default.** FCC's reasoning: "it's easier to give someone
  payrate access, ability to approve PO reqs, ability to change customer terms, etc. when
  required." These per-user capability flags sit *outside* the profile.

> Note what this model implies and the sources do not state: a permission in NexGen is a
> combination of **profile + per-user capability flags + company/yard scope**, and yard scope is
> multi-valued. Whether the replacement needs the same shape is not addressed by any source here.

## Profile Screen Settings coverage — the WPF screens

The Admin Guide v2.0 documents which panes of the modernised WPF screens have their own
profile-screen-settings section. Useful as an inventory of what NexGen considers separately
permissible on a job:

**`Schedule > Job – WPF`:** Main · Resource · Resource-Employees · Resource-Specifications ·
Resource-Telemetry · Resource-ETickets (the "Manage E-Tickets" pane) · Estimate · AIA Estimate ·
Parts Estimate–Parts · Parts Estimate–Shipments · Parts Estimate–Invoices · Line Items · Invoice
(invoice history) · Tools · Storage · In-House · Parameters · Purchase Orders.

**`Enter > Invoices – WPF (Rental)`:** Main · Details · E-Tickets · In-House Comments · PO.

**`Maintain > Codes > Billing Codes – WPF`:** Main · Price List · Price List Exceptions · Yards ·
Taxable.

**`Utilities > User Settings`:** one pane.

The estimate layout changes with the **Billing Type** set on the Parameters tab — the guide names
**Bare / Operated / NA**, **AIA**, **Percent** and **Parts** as billing types that each render a
different Estimate grid. When the system default **"Show 3 Rates on Billing Codes"** is enabled,
extra rate columns appear, but Quantity 2 and Quantity 3 are editable **only when the billing
code's Job Type is explicitly `Bare`**.

## System defaults (`Admin > Set System Defaults`)

Three tabs the guide documents:

- **Features** — new WPF screens ship available but **not enabled**; a system-default flag turns
  them on for all users and **hides the corresponding legacy screens**. *The new job screen does
  not support trucking jobs*; those keep using `Schedule > Trucking Jobs`.
- **WPF** — a colour theme applied to all users (Office 2013, Summer, Windows 7). **Themes are
  system-wide and cannot be set per user.**
- **System Maint.** — logging configuration: manual truncation of system logs, a retention period,
  who last truncated, and an application-logging toggle that records detailed per-screen
  performance data retained for **up to 90 days**.

## How NexGen changes reach Atom

From the Admin Guide's "Atom Changes Related to NexGen Modernization" section:

- **Changes applied to the Job – WPF screen in NexGen reflect in Atom as well.**
- NexGen **requires a date and time on all jobs**. Atom can still save a job without them when the
  **Flexible** checkbox is ticked, but opening that job in NexGen shows the fields as required
  (yellow background). Date Flexible and Time Flexible still drive the schedule icons; they do not
  waive the NexGen requirement.
- **Atom does not support nested grids.** The sub-item column still exists in Atom for Estimates,
  and what Atom marks as a sub-item becomes a nested grid row in NexGen. For employees on the
  Resources (Unit/People) tab, **NexGen uses unit assignment to decide whether an employee is shown
  nested under a unit or at job level**.
- Lift Info and Daily tabs carry over from Atom to NexGen, but **Atom does not support unit-level
  specifications**; specifications added in NexGen surface in Atom through the Daily tab.

## ATOM mobile administration (Google Play release)

From the ATOM System Administrator's Guide v1.0, June 2021 — dated, and about the Android build:

- ATOM 2021.2.4.0 targets **Android 10 (API 29)**; minimum supported is Android 4.2 (API 16–18),
  but FCC **recommends Android 8.0+** and explicitly does not support Android 7 or below because
  Google no longer ships security fixes for them.
- Version dependencies: NexGen 2021.2.3.1 recommended (also 3.5.580, 3.5.586); ATOM API 2021.2.3.2
  recommended (also 2.4.68, 2.4.73). **The app is backward compatible with the last two API
  versions** and shows a pop-up when app and API versions are incompatible.
- Users install or update from the Google Play Store by searching "NexGen ATOM"; a new user must
  enter **the company's ATOM URL, supplied by the administrator**, then log in. Distribution via
  an MDM system is supported and left to the local MDM administrator.
- **Operational warning:** users should complete any open E-Tickets (Operator, LEM, Trucking, Load)
  and labor entries *before* updating.

## What TCG said about Maintain Company

The `FCC_MAINTAIN_COMPANY (reviewed by TCG)` deck is a screenshot walkthrough of NexGen's company
setup with TCG's own annotations. The slides carry no text beyond those annotations; the
screenshots themselves are images — what they show is in *What the deck's screenshots show* below. TCG's comments, verbatim in substance:

| Screen area | TCG's annotation |
| --- | --- |
| **Counters** (twice — company and yard level) | "These are just database ID counters… not sure we need these visible in the user interface?" |
| **ODBC for QuickBooks** | "Not sure we need this visible in the user interface?" |
| **AvaTax** | "Not using this" |
| **Payroll Defaults** | "Will need most of these… (and additional configurations as well)… will discuss further when creating Payroll module." |
| **DocuSign** | "We will continue to use DocuSign and need these DocuSign settings." |
| **Terms & Conditions** (company) | "The Company's fine print on Job Quotes and Job Tickets." |
| **Company Documents** | "Documents uploaded specific to each Company." |
| **Terms & Conditions** (yard) | "The specific Yard's fine print on Job Quotes and Job Tickets." |
| **Certifications** | "These can be managed via document uploads." |
| **Employees ↔ Yards** | Marked **"*** NEW SECTION/FUNCTIONALITY ***"** — "Be able to assign/associate Employees to each Yard. That will enable reporting per Yard to see which Employees are working in each of the Yards. **Some Employees may be working/associated with more than one Yard.**" |
| **GL Accounts** | Marked **"*** Will need further discussion ***"** — "GL Accounts to be discussed more. Need to be integrated with accounting software (QuickBooks Online)." |
| **Storage Location** | "Used for warehouse storage" |

Two of these are requests, not observations, and are the only requirement-shaped statements in the
deck: **many-to-many employee-to-yard association with per-yard reporting** (marked new
functionality), and **retaining DocuSign settings**. The deck says nothing about how either should
work.

## What the deck's screenshots show — read 2026-09-04

The 34 images inside `FCC_MAINTAIN_COMPANY (reviewed by TCG).pptx` were extracted and read on
2026-09-04. They are NexGen screens of **TCG's own production configuration** (company `CG`,
yard `MY`), so beyond the labels they show what TCG actually has set. Only what the speaker notes
did not already give is recorded here; toolbars and menus are skipped except where the menu
itself is the fact.

**The menu (slides 1, 10, 19, 21, 22).** `Maintain → Company` has six entries: **Company · Yards ·
Departments · GL Accounts · GL Accounts by Company · Storage Location**. The deck walks exactly
those six, in that order.

### Company (slides 2–9)

Tabs: **Main · Counters · ODBC · AvaTax · Payroll Defaults · DocuSign · Mailing Address · T&Cs and
Footers · Brand.**

- **Main** — Code `CG`, name *The Crane Guys, LLC*, a Physical Address block (Name · Address ·
  City · State · Zip Code · Country · Phone · Fax) plus Email and WebSite; on the right **Year End
  Month `12`**, **Status `Active`**, **A/R GL Account `1201`**, **A/P GL Account `2000`**, Inventory
  GL Account *(blank)*, Cash GL Account *(blank)*, **Payroll Company** *(blank)*. The company
  selector at the top offers **Name / Code** radio buttons — the same pattern every master screen
  in these decks uses.
- **Counters** (slide 3, TCG: *"just database ID counters"*). "Last Counter Numbers" for the
  company: **Invoice No 92,813 · PO No 2,989 · Voucher No 3,151 · Receiver No 3,177 · Job No
  58,153 · WO No 22,100 · Recurring Billing No 40,001 · Order No 50,000 · Quote No 36,534 · PO Req
  No 1,865 · Shipping No** *(blank)*. These are the sequences behind the codes seen elsewhere in
  the decks: the Quote Lookup in the Quotes deck tops out at `OM-36540`, so a quote number is the
  **department prefix + this counter**, and the counter screenshot is a few quotes older than the
  lookup one.
- **ODBC** (slide 4) — a single field, **ODBC DSN**, populated with a DSN named for QuickBooks. TCG:
  *"Not sure we need this visible"*.
- **AvaTax** (slide 4) — AvaTax Company Code · API URL · Account No · License Key · a **Test**
  button; **all blank**, which matches TCG's *"Not using this"*.
- **Payroll Defaults** (slide 5) — the same pane
  [../payroll/fcc-union-code-configuration.md](../payroll/fcc-union-code-configuration.md)
  describes from the FCC guide, where the guide's screenshot was blank. **Here it carries TCG's
  values:** Payroll Week Ending **`Friday`** · Split Multiple Days **unchecked** · OT Eligible
  **`Day`, 8.00 Hrs** · DT Eligible **`Day`, 12.00 Hrs** · *Include ST Hours in Time Slot overlap*
  **unchecked** · Saturday **`OT All Time`** · Sunday **`OT After Hours Worked` 0.00 Hrs, or `DT All
  Time`** · Time Round To **`30` Mins** · Time Slot grid **empty** · Exclude Craft Codes grid
  **empty**. Two labels the payroll page did not have: **Payroll Week Ending** and **Include ST
  Hours in Time Slot overlap**. That page's open point 3 — *"The document does not say how TCG has
  [Split Multiple Days] set"* — is answered by this screenshot: **off**, at company level. Whether
  a union or employee record overrides it is not visible here.
- **DocuSign** (slide 6) — three fields: **User · Password · Key**.
  `[credentials present in the source file — deliberately not copied; see the deck, slide 6]`.
  TCG: *"need these DocuSign settings"*.
- **Mailing Address** (slide 6) — Name · Name2 · Address · Address2 · City · State · Zip · Phone ·
  Fax, **all blank** at company level (the Brand tab says e-tickets fall back to this block when
  no logo is set — see below).
- **T&Cs and Footers** (slide 7) — two groups of dropdowns. *Default T&Cs:* **Quotes** `Quote T&C`
  · **Jobs** `E-Ticket Standard` · Job Lease Agreement *(blank)* · Work Order *(blank)* · Order
  Entry *(blank)*. *Default Footers:* **Quote Footer** `Standard Quote T&M F…` · Invoice · PO
  Footer General · PO Footer Contract · Work Order · Order Entry *(all blank)*. So the "fine print"
  TCG's note refers to is **two selected records — one T&C for quotes, one for job tickets — plus
  one quote footer**, and nothing is set for invoices or POs.
- **Brand** (slide 8) — **Include Company Logo ☑**, with the on-screen rule *"If unchecked;
  e-tickets will display the company details from the Mailing Address tab"*; the logo shown is
  TCG's round *Family Owned and Operated — Since 2006* badge; constraints printed on the screen:
  **250×125 px max, 500 KB, .png/.jpeg/.jpg**; a **Theme Color** swatch with a HEX field, blank.
- **Company Documents** (slide 9) — the lightning-bolt icon opens **Maintain File Links – Company
  Code** (`Company Code-CG`): File Name · Comments · Created By · Modified By · Created Date ·
  Modified Date. Empty.

### Yards (slides 10–17)

Yard Name `Main Yard`, code **`MY`** — the only yard in the dropdown, consistent with
[../assets/crane-fleet-reference.md](../assets/crane-fleet-reference.md) (*every unit is
`YardCode = MY`*). Tabs: **Main · Counters · T&Cs and Footers · Unit Certifications · Emp
Certifications · Brand.**

- **Main** (slide 11) — Code · Yard Name · **DFLT GL Distr** *(blank dropdown)* · Physical Address
  (Address1 with a map button, Address2, City, State, Zip, Phone, Fax) · Status `Active` · a
  Mailing Address block filled in with the company's address.
- **Geofence Settings** (slide 12, opened from the map button) — **Latitude · Longitude · Radius**
  (`175` **Feet**, with the on-screen rule *"Minimum radius is 175 feet (50 meters)"*) · **Override
  Yard Address** checkbox · **View Larger Map**. The yard has coordinates set and the minimum
  radius. This is the yard end of the geofence the field-ops pages describe from the app side
  ([../field-ops/field-app-demo-2026-06.md](../field-ops/field-app-demo-2026-06.md)).
- **Counters** (slide 13) — the same eleven counters as the company, **all blank** at yard level.
  Read with slide 3: TCG's numbering runs at company level, not per yard.
- **T&Cs and Footers** (slide 14) — identical layout to the company tab and **the same three values
  selected** (`Quote T&C`, `E-Ticket Standard`, `Standard Quote T&M F…`). The deck does not say
  whether the yard values override or merely repeat the company's.
- **Unit Certifications** (slide 15) — grid **Activity Code · Description · Type · Status ·
  Comments**, empty. **Emp Certifications** — grid **Certificate Code · Certificate Name ·
  Certification Type · Status · Comments**, empty. These are the two grids TCG says *"can be
  managed via document uploads"*; the same slide carries the **Employees ↔ Yards** ask, for which
  there is **no screen at all** in the deck — it is written beside the certifications grids.
- **Brand** (slide 16) — **Yard Logo** only, same size rule as the company; no theme colour at
  yard level. Empty.
- **Maintain File Links – Yard** (`Yard-MY`, slide 17) — same columns as the company file links.
  Empty.

### Departments (slide 18)

One grid: **Dept · Description · Dflt GL Distr · Last Counter Numbers (Job · Quote · Invoice · PO)
· Status.** Ten rows, all `Active`, Dflt GL Distr and all four counters blank:

`CR` Customer Repair · `FL` FLEET · `ID` INTERNAL DAMAGE · `MC` MECHANICS · `OM` OPERATED &
MAINTAINED · `RG` RIGGING · `SH` SHOP · `ST` STORAGE · `TR` TRUCKING · `YD` YARD

— the same ten [../assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md)
recovers from the inventory export. What this screen adds is that **departments can carry their
own counters** (Job / Quote / Invoice / PO), and TCG has none set — so the `OM-` prefix on quote
and job numbers comes from the department while the number itself comes from the company counter.

### GL Accounts (slides 19–21) — and a second company

**GL Accounts** (slide 20): a `View` filter (`All`) over **GL Account · Description · Valid For All
Companies · Status**, with a lower pane **Company · Valid For This Company** for the selected
account. **That lower pane lists two companies: *The Crane Guys, LLC* and *The Repair Guys*,
both ticked.** This is the only place in the four decks where a second company appears; the
company dropdown on slide 2 was not opened, so whether *The Repair Guys* is a full second company
record or only a GL-scope entry is not visible. (The inventory export has one unit under
`CompanyCode = RG` — [../assets/crane-fleet-reference.md](../assets/crane-fleet-reference.md).)

The account list itself shows TCG's chart-of-accounts convention: **one income and one
repair-and-maintenance account per unit or per crane class**, named by unit number or tonnage —
`10001` *Craine Repair & Maintenance* (`Inactive`), `10001RM` … `10004RM` *Repairs & Maintenance*,
`100INC` *100 Ton Income*, `110INC` *110 Ton Crane*, `120INC` *120 Ton Crane*, `11001 OL RM` /
`11002 OL RM` (operator-load trailers), `1201` *Accounts Receivable (A/R)*, `1201 10001` *Accounts
Receivable (A/R)*, `1400.0000` *Department of Motor Vehicles*, `14001BD` / `14001RM`, `14002`
*140 Ton Crane -14002*, `14002BD` / `14002RM`. The suffixes seen are **`INC`, `RM`, `BD`, `OL RM`**;
what `BD` stands for is not stated on the screen. **GL Accounts By Company** (slide 21) is the
same list filtered to one company, with a **Valid For This Company** checkbox per account.

TCG's note on slide 20 — GL *"to be discussed more… integrated with QuickBooks Online"* — sits
against this per-unit chart. The deck does not say whether the per-unit accounts are to be kept.

### Storage Location (slide 22)

Grid **Description · Status**, three rows: **Inside Warehouse** `Active` · **Outside Yard** `Active`
· **Quad 1** `Inactive`. This is the three-row `FMS_STORAGE_LOCATION` table
[../assets/storage-and-warehouse-operations.md](../assets/storage-and-warehouse-operations.md)
§2 infers from the inventory export, now with its values. TCG: *"Used for warehouse storage"*.

### Where the screenshots and the notes disagree

- **Counters**: TCG asks whether they need to be visible; the screenshots show they exist at
  **three levels** (company, yard, department) and that only the company level is populated.
  Hiding them is a UI question; the numbering itself is what every code in the system rides on.
- **Certifications ↔ Employees-to-Yards**: the *new functionality* ask is attached to two empty
  certification grids that have nothing to do with it; there is no employee-yard screen in FCC to
  compare against.
- Nothing else contradicts a note. The AvaTax, Mailing Address and yard-level counter screens
  being empty is consistent with every "not using / not sure we need" comment.

---

## Source

- `1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/NexGen_WPF_Admin_User_Guide_v2.0.pdf` — 32.2 KB of
  extracted text, 30 pages, `pdftotext -layout`. Version 2.0 final, 10 January 2022, David
  Thornton; v1.0 was 21 December 2020. The guide is mostly annotated screenshots, so the *layout*
  of each settings pane is not recoverable from text — only its name and scope.
- `1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/Users, Profiles, Menu Security, and Profile Screen
  Security- A Cheat Sheet on Security in NexGen.pdf` — 2.3 KB, one page, undated, unattributed.
  Reproduced above in full.
- `1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/NexGen-ATOM-App-Google-Play-Store-System-Administrators-Guide.pdf`
  — 8.4 KB, 8 pages, version 1.0, June 2021.
- `1.0.1_BUSINESS-REQUIREMENTS/FCC_NexGen_MENUS/FCC_MAINTAIN_COMPANY (reviewed by TCG).pptx` — 22
  slides, of which **9 carry no text at all** (screenshot-only). All annotation text is above. The
  **34 embedded screenshots were extracted and read on 2026-09-04** — see *What the deck's
  screenshots show*. Slide 6 contains DocuSign credentials, not copied.
