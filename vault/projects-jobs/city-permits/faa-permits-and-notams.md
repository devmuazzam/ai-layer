---
title: FAA permits, A1 surveys and NOTAMs
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/FAA Permit A1 Survey Playbook.docx · NOTAMS Playbook.docx · NOTAMS.docx (text and its four embedded images read)
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/projects-jobs, module/dispatch, module/field-ops, kind/sop, permits, compliance, safety, geolocation]
entities: []
---

# FAA permits, A1 surveys and NOTAMs

**What this is.** Three documents covering airspace clearance for crane work. Two are formal
playbooks written by **Ryan Adams** in June 2026 — `NOTAMS Playbook` (18 June) and
`FAA Permit A1 Survey Playbook` (19 June), both listing him as playbook owner. The third,
`NOTAMS.docx`, is the older desk note the playbook was written from; its embedded screenshots are
dated 2019 and attributed to a user named Ashley Gonzales. They cover two different obligations
that are often confused: the **NOTAM**, a same-week courtesy notification to an airport tower, and
the **FAA permit** (an OE/AAA case), which is a determination that can take up to 45 days.

## The two things, and the rule that connects them

| | NOTAM | FAA permit (OE/AAA) |
| --- | --- | --- |
| What it is | Notice to Airmen — tells the tower at one airport that a crane will be up nearby, so they can warn incoming aircraft | An FAA obstruction-evaluation determination for the crane as a structure |
| When | Anytime the crane will operate **within 3 miles of an airport** | "Technically anything that close to an airport requires an FAA permit" |
| Lead time | **Can only be ordered 3 days in advance**; the preferred practice is to process the day before the lift | **Up to 45 days for approval** |
| How | Phone call to the FAA NOTAM hotline | Case filed and tracked in the FAA OE/AAA portal |

**What to tell the customer** (verbatim from the source, and repeated in both the playbook and the
older note): a NOTAM **does not guarantee the lift will not be shut down**, but it helps; an FAA
permit may be required and can take 45 days; **the customer must sign the permit waiver before
setup**; and **always say that you recommend the FAA permit**. If the lift is taking place
**directly in a flight path** and is only a few miles out, **consult management before proceeding**.
The waiver referred to is the one in [permit-waiver.md](permit-waiver.md), whose text explicitly
covers "Travel Permit and/or FAA permit".

## Processing a NOTAM — the nine steps

**Step 1 — decide whether one is needed.** Review the job location; a NOTAM is processed anytime
the crane will operate within 3 miles of an airport.

**Step 2 — gather the required information.** The playbook heads this "the five required pieces"
and then lists six:

1. Latitude and longitude
2. Distance from the airport
3. AGL — above ground level
4. MSL — mean sea level / elevation
5. Date and time of the lift
6. Confirmation the crane will be lighted and flagged

**Step 3 — latitude and longitude.** From Google Earth; the coordinates sit in the lower-right
corner. Read the degrees/minutes/seconds straight through when speaking to the FAA — "33° 42' 13" N"
is read as "33, 42, 13 North"; "117° 50' 35" W" as "117, 50, 35 West".

**Step 4 — distance from the airport.** Use the Google Earth ruler tool from the crane location to
the **nearest runway**, measure **in feet**, and round. Give distance, direction and the airport
code. Airport identifiers are always three letters; Google an unlisted one.

**Step 5 — AGL and MSL.**

- `AGL = main boom height + jib length (if used)` — this is the crane **tip** height. Worked
  example: 100 ft boom + 35 ft jib = **135 ft**.
- `MSL = AGL + site elevation` — worked example: 135 + 62 = **197 ft**.
- **MSL is always a larger number than AGL.** (The older `NOTAMS.docx` note gives the same worked
  example but writes the result as **195 ft** — an arithmetic slip in the original; the playbook's
  197 is correct for the numbers given.)
- The boom and jib lengths come from the lift information / crane set-up details.

**Step 6 — date and time.** Confirm lift date, estimated arrival and estimated completion from the
system. NOTAMs may only be ordered 3 days in advance; process the day before. **Always overestimate
time on site rather than underestimate.** The older note adds a detail the playbook drops: TCG
"always order from 12 hundred Zulu to 4:59 Pacific daylight".

**Step 7 — lighting and flagging.** Always advise the FAA that the crane will be flagged and
lighted. All cranes carry FAA flags; **operators are responsible for installing and using them on
site**.

**Step 8 — call the hotline.** FAA NOTAM number **877-487-6867** → press **22** for California →
say "**Southern California**" → give latitude, longitude, distance from airport, airport code, AGL,
MSL, date and time, and the flagged-and-lighted confirmation.

**Step 9 — record the NOTAM number.** Format `SNA08/050` — first three letters the airport code,
first number pair the month, second the approval number. **Enter it into iCranetrax under the
FAA Permit / Permits section.**

### Airport code cheat sheet

Both documents carry the same 13-airport list.

| Airport | Code | | Airport | Code |
| --- | --- | --- | --- | --- |
| Los Angeles | LAX | | Van Nuys | VNY |
| Orange County / John Wayne | SNA | | Burbank / Bob Hope | BUR |
| Long Beach | LGB | | Santa Monica | SMO |
| Ontario | ONT | | Cable Airport | CCB |
| Riverside | RAL | | Compton | CPM |
| Chino | CNO | | Fullerton | FUL |
| | | | Hawthorne | HHR |

## The FAA permit / A1 survey path

This playbook covers what happens **after** an FAA OE/AAA case comes back with comments rather than
a clean determination. The FAA may be asking for an A1 survey, a crane height reduction, additional
review or documentation, marking and lighting, or an alternative crane configuration.

| Step | Action | Standard |
| --- | --- | --- |
| 1 | Review the OE/AAA case comments **immediately**; document them in the project file | — |
| 2 | Notify the assigned salesperson, project manager and customer, with the FAA case number, the comments, expected schedule impact, additional requirements and potential additional costs | **Same business day** |
| 3 | Contact the customer even before survey pricing exists — say the FAA has asked for a survey or review, **that the permit has not been denied**, that additional costs are expected, that pricing follows, and that schedule impacts may occur until FAA approval issues | **Same business day** |
| 4 | Request pricing from an approved survey company | **Within 24 hours** |
| 5 | Send the estimate to the assigned salesperson with survey cost, reason, FAA requirement detail and schedule impact | Immediately on receipt |
| 6 | The salesperson secures **written customer authorisation** — approval email and/or approved change order — before the survey is ordered; saved to the project file for documentation and billing | Without delay |
| 7 | Order an **FAA-compliant A1 survey**, verifying it includes crane location coordinates, ground elevation, crane centre point and **maximum crane tip elevation** | — |
| 8 | Upload the survey and supporting documents to the FAA OE/AAA case; save copies to the project file; **document the upload date** | Immediately after survey receipt |
| 9 | Monitor the case to final determination, updating customer, salesperson and project manager | Throughout |
| 10 | On final approval: save the determination to the project file, forward it to customer and salesperson, confirm crane scheduling and release the project for execution | — |

**Approved survey vendors** named in the playbook: Calvada Surveying, Inc.; Rosell Surveying &
Mapping, Inc.; Ray Lombera & Associates.

**Systems the playbook names:** the FAA OE/AAA portal, **NexgenFMS/FCC**, the company file
management system, and Outlook. Note that the NOTAM playbook instead names **iCranetrax** as where
the NOTAM number is filed — the two playbooks, written a day apart by the same author, name
different systems of record for FAA data, and neither reconciles them.

**Internal contacts the playbook assumes exist:** Permit Coordinator, Project Engineer, assigned
Salesperson, Project Manager.

## Where this connects to scheduling

`FAA Required?` and `NOTAM Required?` are both checklist items on the Ready to Schedule gate
([../scheduling/ready-to-schedule.md](../scheduling/ready-to-schedule.md)) and are reviewed again
on any schedule change ([../scheduling/schedule-changes-and-after-hours.md](../scheduling/schedule-changes-and-after-hours.md)).
The client has separately asked for the job-site map to **identify FAA airport zones** as a permit
trigger — [`../../erp-review-log.md`](../../erp-review-log.md) → *Job site and permits*. The
"within 3 miles of an airport" rule above is the geometry that request implies; **no source in this
drop states that the 3-mile rule should be automated, or how.**

## What the embedded images show — read 2026-09-04

The four screenshots in `NOTAMS.docx` — 2018 Google Earth imagery, captured 2019 — were extracted
and read on 2026-09-04. None contains credentials.

- **Image 1 — coordinates.** Google Earth with a pin at **1600 Barranca Pkwy** (Irvine) and three
  red call-outs — *Latitude*, *Longitude*, *Elevation/MSL* — pointing at the status bar, which
  reads **`33°42'20.21" N   117°50'43.52" W   elev 62 ft   eye alt 3192 ft`**. The 62 ft is the
  elevation of the worked example. The coordinates differ slightly from the example text
  (33 42 13 N / 117 50 35 W): the text example is not a transcription of the screenshot.
- **Image 2 — distance.** Google Earth Pro with the *Ruler* dialog on its *Line* tab: **Map Length
  2.00 Miles**, Ground Length 2.00, Heading 219.68°; a yellow line runs from the Barranca Pkwy pin
  south-west to the John Wayne (SNA) airfield, and a red arrow marks the ruler icon in the toolbar.
  Two things the text does not say: **the screenshot measures in miles, where the instruction is
  "always measure in feet"**; and the line ends at the airfield generally, not visibly at the
  nearest runway.
- **Image 3 — elevation.** The same view as image 1 without call-outs; the status bar again shows
  `elev 62 ft`. Adds nothing.
- **Image 4 — the iCranetrax field.** A crop of the legacy **iCranetrax** job screen. Above the
  fold, two permit dropdowns: **`State Permit: Not Needed`** and **`Miscellaneous Permit: Not
  Needed`**. Then a collapsible **`Additional Information`** panel (its header echoes `Crane Size:
  22`) with text fields, top to bottom: `Crane Size` (22) · `Quoted` · `Credit Application` ·
  `Confirmed` (yes) · `Scheduled` (yes) · `Unit #` · [one field cut off] · **`FAA Permit /Permits`**
  = **`NOTAM: SNA08/050`**, circled · [one field cut off] · `MOP /COD`. Below it a section
  **`Equipment and Personnel`** with *Show all notes · Hide all notes* and a row `Equipment ·
  (not set) · 1`. So in the legacy system the NOTAM number is **free text prefixed `NOTAM:` in a
  general permits field**, alongside per-type permit dropdowns whose visible option is `Not
  Needed`. This is the only picture of the iCranetrax permit fields in the drop; the rows above
  `State Permit` (presumably city/travel permits) are outside the crop.

## Source

- `3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/FAA Permit A1 Survey Playbook.docx`
  — ~5.8 KB, `.docx` → pandoc GFM. Header block: created by Ryan Adams 6/19/26, last update
  6/19/26, teams Permitting / Engineering / Sales / Project Management. Its "Walkthrough Video"
  section is an unfilled template placeholder.
- `3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/NOTAMS Playbook.docx`
  — ~5.7 KB. Created by Ryan Adams 6/18/26. Walkthrough video also unfilled.
- `3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/NOTAMS.docx`
  — ~4.7 KB, the older desk note. Four embedded screenshots (`media/image1.png`–`image4.png`)
  showing Google Earth coordinates, a distance measurement, an elevation readout and the iCranetrax
  FAA Permit field. **The images were extracted and read on 2026-09-04 — see *What the embedded
  images show* above.**
