---
title: Travel permits SOP — how dispatch obtains a crane travel permit
source: shared-folder/Project-Repository-2026-09-04/TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/TCG Dispatch - VALUE ENGINES and PLAYBOOKS/Permits - Copy.docx (+ its cover sheet TCG Dispatch Permits-  -.docx) — caption text and all 34 embedded images read
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/dispatch, module/vendors-agencies, module/accounting, kind/sop, permits, scheduling, purchase-orders, compliance, geolocation]
entities: []
---

# Travel permits SOP — how dispatch obtains a crane travel permit

**What this is.** `Permits - Copy.docx`, the **Travel Permits SOP** — the written procedure behind
the **Permits** playbook, owned by **Liz Lopez**, created and last updated **2026-04-01**.

The rule it implements, from its cover sheet: ***"All cranes 40 ton or bigger required travel
permit, we must apply directly to city or permit agency."***

**Why it matters.** The 2026-08-12 client minutes record permits as having **no vault coverage at
all** — *"annual vs job-specific, city-by-city eligibility, crane-travel permits — have no vault
coverage. The field-ops FRD's BRS References table lists permits only as a Pending compliance
topic"*
([meetings/2026-08-12-sell-side-workflow-and-scheduling.md](../meetings/2026-08-12-sell-side-workflow-and-scheduling.md)).
This is the first source in the vault that describes the permit process end to end, and it answers
the annual-vs-single question directly.

> **Current manual practice, running entirely on OneDrive, Google Maps, email and a filing
> cabinet.** Nothing here has been specified for the ERP. It is recorded because the ERP is
> expected to replace it and nobody has written down what "it" is.

---

## 1. The threshold and the annual-permit rule

Two capacity statements, and they are the load-bearing content of the whole document:

1. **From the cover sheet:** ***"All cranes 40 ton or bigger required travel permit."***
2. **From the SOP body:** ***"Cranes ranging from 40ton–350 tons have Caltrans Annual Permits and
   are covered on the freeway; therefore, the ORIGIN will be the closest exit off the FWY to
   destination."***

**Read together: a 40-to-350-ton crane needs a city travel permit for the surface-street leg only,
because Caltrans annual permits already cover the freeway.** That is what "annual" means in
practice here — a **statewide freeway permit held per crane**, not a per-city annual. It is a
different thing from the city-by-city annual eligibility raised in the 2026-05-05 review-log
extraction (*"flag annual permit requirements by city / state / zip, indicating whether an annual
city permit is already in place or required"*, [erp-review-log.md](../erp-review-log.md)) — **the
Visio chart's `Single Permits` vs `Annuals` branch
([dispatch-value-engine-and-playbooks.md](dispatch-value-engine-and-playbooks.md) §1) could mean
either, and no source says which.**

**The routing consequence is concrete and unusual:** because the freeway leg is covered, the permit
application's route does **not** start at the yard. The stated worked example:

```
Origin:      I-10 Freeway @ Atlantic Blvd
Destination: 1209 S 7th Street, Alhambra
```

The route is built on **Google Maps**, entering the destination with the TCG yard as the starting
point, then trimming the origin to the nearest freeway exit.

> **The above-350-ton case is not covered.** The sentence names 40–350 tons; TCG's fleet runs to
> 550 tons ([crane-configurations.md](crane-configurations.md) §1). The document does not say what
> happens for a 360 or a 550.

## 2. The city folder — a per-city instruction set

The whole application process is keyed on a **OneDrive folder tree**, one folder per city:

1. Open OneDrive, search **"City Permit application"**, open the folder.
2. ***"All cities will be listed. Click on the city folder you need, and the permit ordering
   instructions will be provided."*** Worked example: a 90-ton job in the **City of Alhambra** →
   the `Alhambra` folder.
3. ***"Each city has a Word document containing all relevant city information"*** — open it and
   follow that city's instructions. Alhambra's instruction is to email the application to the city
   public-works requests address.
4. **The application form itself is in the city folder if the city requires one** —
   *"(Some cities use online systems and require an online application.)"*
5. ***"Most applications are prefilled; only the route needs to be added."***

> **This is a per-city configuration table maintained as Word documents in folders.** Submission
> route (city email / permit agency / online portal), whether a form exists, whether a check is
> required, and the city's conditions all vary per city and are held nowhere structured. Any ERP
> permit feature inherits this as reference data — and **nothing in the drop says how many cities
> there are, or who maintains the folders.**

## 3. Submitting

- **New email to the city's designated address, CC Dispatch**, attaching the completed application
  **and the Certificate of Insurance**.
- **COIs are requested from Leo Lopez** — *"He will send it once prepared."*
- **If the city requires a check, attach a copy of the check to the email.**
- **Subject line: city name with job date.**
- **Create a PO# against the job number** — cross-referenced to a separate *PO# SOP*.
- **Add the permit to the Daily Permit Sheet** (OneDrive).
- **Save the permit in the "Permit Application" folder with a sticky note** carrying: *job date,
  job number, crane size, status of permit ("pending" or "approved"), and form of permit
  submittal* — where submittal is one of **emailed to the city, submitted to a permit agency
  (Quality Permits), or submitted via an online portal.**
- **Once approved, the city sends a payment link.** If the city requires a check, mail the check
  **with a copy of the approved permit**.

**And the rule the document puts in bold capitals:**
***"ALL PERMITS NEED TO HAVE CITY ATTACHMENTS/CONDITIONS TO BE A VALID"*** — with the note that
*"We have copies of most city attachments in our file cabinet"* and *"You can also google the city
attachemnts"*.

> **A permit is not valid without its city attachments/conditions.** That is a validity rule with
> a document dependency, and it is stated nowhere else in the vault. The dispatch sheet's `P`
> column ([crane-configurations.md](crane-configurations.md) §2) records only *that* a permit was
> obtained — it cannot express whether the conditions are attached.

## 4. The Daily Permit Sheet — colour as status

A second Excel sheet on OneDrive, parallel to the dispatch sheet:

1. Go to OneDrive, search **Daily Permits List**.
2. Navigate to the **date of the job** and add the permit information.

**Status is carried by highlight colour, exactly as on the dispatch sheet:**

| Colour | Means |
| --- | --- |
| **Yellow** | permit **submitted** |
| **Pink** | **approved permit received** |

On receipt: ***"print it, verify that all information is correct, and file it in the 'Approved
Permits' folder."***

## 5. Ordering through a permit agency

*"Some cities require permits to be ordered through **Quality Permits**"* — a permit agency, emailed
with Dispatch CC'd.

**Subject format: `City Name – Job Date`.** Body must include:

- **Job Date**
- **Crane Size** — *"include license plate numbers if the city requires"*
- **Jobsite Address**
- **PO#**

**On receipt, six things must be verified before the permit is used:**

| Check | Stated as |
| --- | --- |
| `Name` | *The Crane Guys* |
| `Date` | job date requested |
| `Load equipment` | *"make sure it's the correct crane"* |
| `Destination` | *"make sure it matches with jobsite"* |
| `Hours of travel` | *"if there are restriction times, let the PM know"* |
| `Pilot` | *"if we need pilots, let the PM know, add sticky note on permit and scheduled a pilot"* — ***"We can schedule pilot in house"*** |

Plus: ***"Verify that the permit has a Permit Number before submission."***

> **Three things here have no home in the current model.** A permit carries **restricted travel
> hours** that constrain when the crane may move — which is a scheduling constraint, not a
> document attribute. A permit may require a **pilot car**, which is a resource TCG can supply
> in-house and therefore has to schedule. And the permit is checked against **the specific crane**,
> which is the same crane-substitution coupling the confirmation procedure catches from the other
> side ([confirmations-playbook.md](confirmations-playbook.md) §6).

## 6. Filing for billing

The last section exists so **Accounting can reach the permits**:

- OneDrive → search the **"Permits"** folder — *"a list of folders organized by date."*
- **Add copies of approved permits to the corresponding date folder so Accounting can access
  them.** New date folders are named `M.D.YY` — the stated example is `1.29.26`.
- **Rename the uploaded permit file with the job number.**

So a permit is filed **three times**: in the *Permit Application* folder with a sticky note (§3), in
the *Approved Permits* folder as a printout (§4), and in the dated *Permits* folder as a copy for
Accounting keyed on job number (§6). The permit cost itself is billed — the sales-side board's
reschedule path says *"Send Accounting a bill to charge for any Permit Costs"*
([dispatch-value-engine-and-playbooks.md](dispatch-value-engine-and-playbooks.md) §3) — and the PO
raised in §3 is presumably how, though **the document does not connect the PO to the billing.**

## 7. What this bears on, and what it leaves open

**Bears on:**

- The `Single Permits` / `Annuals` branch of the dispatch value engine (§1).
- The 2026-05-05 ask for **map-based permit intelligence** — *"the map should identify FAA airport
  zones and other permit triggers"* and *"flag annual permit requirements by city / state / zip"*
  ([erp-review-log.md](../erp-review-log.md)). This SOP shows the manual version: a Google Maps
  route, a per-city folder, and a person who knows which cities use Quality Permits.
- **FCC models permits as schedulable units** — `SP` Street Permit, `TP` Travel Permit, `FAA` FAA
  Permit are all schedule types
  ([assets/fcc-units-and-schedule-types.md](../assets/fcc-units-and-schedule-types.md) §1). This
  SOP describes the work behind one of those rows; the two are consistent and neither is a spec.

**Open — do not infer:**

- **What happens above 350 tons** (§1).
- **Whether `Annuals` on the value-engine chart means the Caltrans freeway annual or a city
  annual** (§1).
- **How many cities are in the folder tree, who maintains it, and what a city record contains.**
- **How restricted travel hours and pilot-car requirements are meant to reach the schedule** (§5).
- **Whether the permit PO is what bills the permit cost to the customer** (§6).
- The document is **entirely about travel permits**. Street permits, FAA permits, lift plans and
  restriction lists all appear in the dispatch sheet's `P/LP/RL/SS` column and in the value-engine
  charts, and **none of them has a procedure in this drop.**

## What the embedded images show — read 2026-09-04

The 34 screenshots and photographs in `Permits - Copy.docx` were extracted and read on
2026-09-04. This section records only what they show **beyond the caption text** used for §1–§6;
numbers are the `media/imageN` positions in the document. **No portal credentials appear in any
of the 34 images** — they show OneDrive, Outlook, Google Maps, macOS Finder and paper.

### The OneDrive stores (images 1–5, 20–21)

- **Image 1** is the Microsoft 365 app launcher with OneDrive highlighted — decorative, except
  that the background lists the dispatcher's recent files, among them an Excel workbook named
  **`City Time Restrictions`**. No page in the vault names that workbook; its content is not
  visible.
- **Image 2:** searching OneDrive for "city permit application" returns **two folders both named
  `City Permit Applications`** — one created by **Brenda Ramirez** (modified Feb 14, 2023) and
  one created by **Liz Lopez** (Sep 26, 2024, shown with a shortcut icon). The SOP does not say
  which is the master; images 4 and 20 open Brenda Ramirez's. Images 3 and 5 are zooms of 2 and 4.
- **Image 4:** the city folder tree lives at **`Brenda Ramirez › City Permit Applications`**
  (shared), columns `Name · Modified · Modified By · File size · Sharing`. First rows: Adelanto
  (10 items, Brenda Ramirez, Feb 2023) · Agoura Hills (1 item, Liz Lopez, Jul 21 2025) · Alhambra
  (13 items, Feb 2023) · Aliso Viejo (11 items) · Anaheim (2 items, "Guest Contributor", Mar 21
  2023) · Arcadia (3 items, Liz Lopez, Jul 26 2023) · Arleta (1 item, Liz Lopez, Jan 16) · Azusa
  (16 items, Feb 2023) · Bakersfield… — one folder per city holding 1–16 items, maintained by at
  least three people. This is the library that
  [permit-acquisition-process.md](../projects-jobs/city-permits/permit-acquisition-process.md)
  read as 153 Word notes.
- **Image 20:** searching "permits" returns three objects — the `City Permit Applications`
  folder (Brenda Ramirez), an Excel workbook **`Daily Permits`** (created by Brenda Ramirez, last
  modified by Liz Lopez "2h ago"), and a folder **`Permits`** created by **Sammy Garrett** on
  Jul 23 2025. So the Daily Permit Sheet of §4 is one workbook, and the billing folders of §6 sit
  under `Sammy Garrett › Permits`.
- **Image 21:** inside `Sammy Garrett › Permits`, one folder per calendar day — `1.17.26` …
  `1.28.26` — all modified by Liz Lopez, holding 0–6 items each (`1.28.26` 6 items, `1.24.26`
  0 items). **Days with no permits still get a folder, and folders are created ahead of the
  date** (`1.21.26`–`1.25.26` were all created on January 20).

### What a city record looks like — Alhambra (image 6)

The Word document in the Alhambra folder is one page: *City of Alhambra · [city phone] · Email
application to [the public-works requests mailbox] · 48 hours turn around · Open Monday–Thursday
7am–5:30PM · Closed on Friday · Email app to pw permits only · City does not allow payment over
the phone · City will send you a link for payment · 24 to 48 hrs for review and approval · Does
not offer annuals.* This matches the Alhambra row of
[city-permit-reference-a-l.md](../projects-jobs/city-permits/city-permit-reference-a-l.md)
field for field — confirms that page, nothing new.

### The prefilled applications are per crane-size class (image 7)

The city folder holds PDFs named **`40-Ton.pdf`, `60-Ton.pdf`, `90 & 100-Ton.pdf`** — the
"prefilled" applications of §2 are prefilled **per crane-size class**, one file per class. The
document does not say what classes exist for other cities.

### The route as written (images 8, 9)

Image 8 is Google Maps directions from *Your location* to `1209 S 7th St, Alhambra, CA 91803`:
driving, 43 min, 24.3 miles via I-605 N and I-5 N. Image 9 is a crop of the filled application:
`ORIGIN 10 fwy @ Atlantic blvd` · `DESTINATION 1209 S 7th st` · under *AUTHORIZED STATE
HIGHWAYS, COUNTY AND/OR CITY PERMITS REQUIRED* the route is written street by street —
**"10 fwy @ Atlantic blvd - valley blvd - 7th st to destaition and return"** — and the form
carries the printed line **"*HOURS VALID FROM 12:01 am – 6 am AND 9 am – 3:30 pm*"**. So the
route the SOP asks for is a **named-street sequence ending "and return"**, not a map.

### The submission email (image 10)

Subject `Alhambra permit for 7/13`, from Liz Lopez to the city's public-works mailbox, two PDF
attachments (`City of Alhambra.pdf`, 4 MB, and `City of Alhambra_Th…`, 1.6 MB — the application
and, presumably, the COI), body: *"Good afternoon. Can you please process this permit for
tomorrow. Please let me know if there is anything else you need."* Two things the caption does not
say: **the mailbox in the sent email is on an `alhambraca.gov` domain, while the city note
(image 6) gives a `cityofalhambra.org` address** — the document does not say which is current;
and no CC line is visible in the crop, so the CC-Dispatch rule cannot be confirmed from the image.

### The sticky note (image 11)

A photograph of the Alhambra application with a yellow note: **`Job Date 1/27 · OM12345 ·
-Pending Permit · -Email city · -40 Ton`** — the five fields of §3 (date, job number, status,
submittal channel, crane size) in that order; the job number is a sample. The form beneath shows
the equipment line **`Liebherr LTM1040-2.1 · 2 Axle Self Propelled Crane · 40 ton crane`**.

### City conditions — the Goleta example (image 12)

The example of "city attachments/conditions" is the **City of Goleta *Oversize Transportation
Permit — Provisions and Conditions***, items 1–5 legible: (1) *Responsibility of Permittee* —
knowledge of and compliance with California conditions for extralegal loads; (2) *Possession of
Permit* — the **original**, with the City's authorized signature, carried in the vehicle at all
times within city limits (CVC §35783); (3) *Annual Oversize Permit* — a copy of the permit and all
attachments, including the supplemental list of vehicles, accompanies each vehicle, and **only one
vehicle at a time may be travelling within the City of Goleta limits under the Annual Oversize
Permit**, the original being produced on request of a police officer; (4) *Acceptance of the
Provisions*; (5) *Carrier Identification Number* (cut off). This is Goleta's document; nothing in
the SOP says other cities' conditions match it.

### The file cabinet (image 13)

A drawer of hanging folders tabbed by city (legible tabs include Malibu, Oxnard, Lake Forest,
Fullerton, Hawthorne, Pomona, LA City, LA County, Torrance, La Verne) — the physical store of
city attachments. Dozens of tabs; not countable from the photograph.

### The Daily Permit Sheet — its columns (images 14–16)

Title **`DAILY PERMIT`**, with a green-shaded header cell labelled `Received`. Columns, left to
right:

| Order date | JOB # | City | Crane | Unit # | Customer | Inhouse/Quality | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1/27 | OM12345 | alhmabra | 40 ton | 4001 | Air control systems | inhouse | pending | 1209 S 7th st |

Image 15 is that row highlighted yellow with `Status = pending`; image 16 the row highlighted
pink with **`Status = approved`** — so the sheet carries status **both as a colour and as a
`Status` value**. `Inhouse/Quality` records whether the permit was pulled in-house or through
Quality Permits; `Unit #` is the crane unit number. **This is the only place in the vault where
the Daily Permit Sheet's structure is recorded.** (Row values are the document's sample.)

### The Approved Permits tray (image 17)

A photograph of the "Approved Permits" folder with a taped label giving a **five-point receipt
check: Check date · Check curfew times · Check Lic plates · Check if Pilot is required · Check
for attachments.** It overlaps the six-point list in §5 but adds **licence plates** and calls the
travel-hours check *curfew times*.

### The Quality Permits email (image 18)

Subject `Lakeside 2/2`, to the agency contact and Dispatch; one attachment, a PDF named
**`4002 INSPECTION R…`** (322.7 KB — an inspection report for unit 4002, which the caption does
not list as a required attachment); body: *"Can you please process this permit for 2/2 / Crane 40
ton / Jobsite [an address in Lakeside, CA 92040] / Date 2/2 / po# OM-2352."* Lakeside (San Diego
County) has no entry in the city library
([city-permit-reference-a-l.md](../projects-jobs/city-permits/city-permit-reference-a-l.md)).

### The approved permit — what a city permit carries (image 19)

City of Alhambra **Transportation Permit No. 2948**, the permit number highlighted as §5 requires.
Its fields are the data a permit record would have to hold:

| Field | Value on the sample |
| --- | --- |
| Permit valid between | `1/13/26` AM and `1/14/26` PM "and sunset" — highlighted |
| Moving authorized | Saturday / Sunday / Sunset to Sunrise — Yes/No boxes |
| Name / address / phone | The Crane Guys, LLC, 10850 Portal Dr, Los Alamitos — highlighted |
| Haul / Drive / Tow | checkboxes |
| Load or equipment and model no. | `Liebherr LTM1040-2.1` · `2 Axle Self Propelled Crane` |
| Type vehicle | `40-ton crane` — highlighted |
| King pin to last axle · Comb. vehicle length | `N/S` · `28'0` |
| Loaded dimensions | max height `14'0` · max width `8'6` · max overall length `65'0` · max overhang `F-13'10 / R-6'9` |
| Axles | 2 axles · 2 tires each · spacing `11'10` · axle width `8'2` / `8'2` · weights `27,992` / `26,432` |
| Origin / Destination | `10 FWY @ ATLANTIC BLVD` / `1209 S 7TH ST` (highlighted) · a `Trips` box |
| Authorized route | `10 FWY @ ATLANTIC BLVD TO VALLEY BLVD TO 7TH ST TO DESTINATION & RETURN` |
| Hours valid | `12:01 am – 6 am AND 9 am – 3:30 pm` — highlighted |
| Pilot car | Yes / **None required** (ticked) |
| Police / Public works | Public works ticked |
| Advance notice | **"48 hours advance notice required to Public Works … the Police Dept … prior to move"** |
| Issuance fee | **$16.00** |
| Attachments | a `Permit conditions` checklist box, unticked on the sample |
| Signatures | granted for the Public Works Director; permittee's authorised-agent signature dated `1/10/26` |

The city's fee account number is printed on the form and is deliberately not copied. Three
things the caption does not say: the permit carries **per-axle weights and loaded dimensions of
the specific crane** (the crane-substitution coupling of §5, seen from the permit side); it
carries a **48-hour advance-notice-before-move condition**, a scheduling constraint in addition to
the travel hours; and the fee is **$16.00**, where the Alhambra row of
[city-permit-reference-a-l.md](../projects-jobs/city-permits/city-permit-reference-a-l.md) has
none. The sample permit (valid 1/13–14/26), the sticky note (job 1/27) and the July email subject
are from different jobs — the screenshots were assembled from several cases, not one worked
example.

### The local Desktop — a second permit store (images 27–28)

The file-upload dialogue exposes the dispatcher's macOS Desktop, which no source describes:
folders **`approved permits and checks` (1,249 items)**, **`city permits` (295 items)**,
**`Calstrans 2024-2025` (97 items)**, `_ new COII` (184 items), `2026 COI` (57 items),
`TCG documents` (12 items); loose PDFs named by unit number and city — `11002 - LA County.pdf`,
`14001 santa clarita.pdf`, `14001 - LA County.pdf`, `Compton 14001.pdf`, `Upland 14002.pdf`,
`City of Covina_…1895.pdf`, `City of Glendor…6511.pdf`, `City of Tulare_The Crane G…754.pdf`,
`350 riverside city.pdf`, `thousand oaks.pdf`; plus `TCG Letterhead.docx` and a shared
`Confirmations.docx`. The file chosen for the upload example is
**`TOLP-26-0005A The Crane Guys ANNUAL…pdf`** — an *annual* permit — which the walkthrough then
renames to the job number `OM1234.pdf` (images 29–34). **So the worked example files an annual
permit under a single job's number**; the document does not say whether that is the intended
practice for annuals, and it is the fourth copy of a permit (after the three in §6).

### UI-only images (22–26, 29–34)

OneDrive mechanics only: *Create or upload* → *Folder* → a *Create a folder* dialog (name
`1.29.26`, a folder-colour picker) → `1.29.26` and `1.30.26` created together (image 25, circled)
→ *Files upload* → the uploaded file listed → ⋯ *More actions* → *Rename* → a *Rename* dialog
(`OM1234` `.pdf`) → *Update* → `OM1234.pdf` listed. Nothing in them beyond the captions.

## Source

`shared-folder/Project-Repository-2026-09-04/TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/TCG Dispatch - VALUE ENGINES and PLAYBOOKS/`

- `Permits - Copy.docx` — converted with pandoc to GFM. **The document is roughly 40 screenshots
  with captions**; every step above is from the caption text, and the screenshots themselves —
  which show the OneDrive folder tree, an actual application form, the Daily Permits List, and the
  approved-permit layout — are not carried by the conversion. **They were extracted and read on
  2026-09-04; what they add is in *What the embedded images show* above.** One external address (the Alhambra public-works requests mailbox, and
  the Quality Permits contact) appears in the source; the agency contact is referenced here by
  first name only and the addresses are not copied.
- `TCG Dispatch Permits-  -.docx` — the cover sheet: owner **Liz Lopez**, created and updated
  2026-04-01, team Dispatch, all five step slots blank, *Resources* pointing at the file above.
