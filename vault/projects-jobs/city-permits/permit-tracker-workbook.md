---
title: Permit Tracker workbook — how TCG tracks which crane is permitted where
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__Job Schedule Master (from Ryan 2026-08-11)/Permit Tracker.xlsx and .../__ERP_Sales Process (from Ryan 2026-08-06)/Permit Tracker[88].xlsx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/projects-jobs, module/assets, module/dispatch, kind/reference, permits, compliance, reference-data, architecture]
entities: []
---

# Permit Tracker workbook — how TCG tracks which crane is permitted where

**What this is.** A single Excel workbook that is TCG's current system of record for
**annual and blanket travel permits held per crane per jurisdiction** — 338 permit records across
29 fleet units and 49 issuing agencies, with expiry dates, route/coverage text, per-permit
restrictions, and the source PDF each row was read from. Two copies arrived in the drop; they hold
the same 338 records but were last recalculated on different days, so their live status counts
differ. This page records the workbook's **structure and rules**; the 338 rows and the fleet
specification tables were not copied.

**This is the second half of the answer to the client's "flag annual permit requirements by
city / state / zip" request** in [`../../erp-review-log.md`](../../erp-review-log.md) → *Job site
and permits*. The per-city notes say which jurisdictions offer an annual at all; this workbook says
which of them TCG currently holds, for which crane, valid until when.

## The ten sheets

| Sheet | Dimensions | What it is |
| --- | --- | --- |
| `DISPATCH COMMAND CENTER` | A1:N38 | Landing page — live fleet metrics, a crane/city quick finder, the next 10 permits to renew, a permit-health count, navigation buttons, and five standing dispatch reminders |
| `ASSET PERMIT PROFILE` | A1:H24 | One-asset view: pick a unit, see everything needed to fill in a **new** permit application — dimensions, axle data, weights, plus the current Caltrans / LA City / LA County permit numbers and dates |
| `PERMIT FINDER` | A1:O52 | Pick a crane **or** a city; both result lists update and link back to the master row |
| `RENEWAL QUEUE` | A1:L362 | All 358 records sorted by expiry with a priority band |
| `CRANE INDEX` | A1:J36 | One row per unit: total permits, active, due ≤60, expired, next expiration |
| `CITY COVERAGE` | A1:I53 | One row per jurisdiction: total records, active, due ≤60, expired, unique cranes |
| `STATUS VIEWS` | A1:J100 | Four clickable KPI destinations — Active/Valid, Expiring ≤60 days, Expired/Not good, Not yet active |
| `Permit Tracker` | A1:R509 | **The master table** — one row per crane × permit agency |
| `Crane Permit Specs` | A1:AJ35 | 35 columns of permit-application source data per crane |
| `Lists` | A1:E49 | The validation lists: permit types, yes/no, crane list, city/agency list, status list |

## The master table's columns

`Permit Tracker` (A1:R509) has 18 columns and 338 data rows:

`Crane #` · `Crane Model` · `License Plate` · `Permit Agency / City` · `Permit Type` ·
`Permit Number` · `Valid From` · `Expiration Date` · `Days Remaining` · `Permit Status` ·
`Status` · `Route / Coverage` · `Restrictions / Notes` · `Source File` · `Verified?` ·
`Permit Application Specs` · `Crane Lookup Key` · `City Lookup Key`

`Days Remaining` and `Permit Status` are computed — the sheet's own header says "Status and days
remaining update automatically." The last two columns are `city|n` / `crane|n` concatenations that
drive the PERMIT FINDER lookups.

### The closed vocabularies (`Lists` sheet)

- **Permit Type:** `Annual` · `Blanket` · `Registration`
- **Permit Status:** `VALID` · `EXPIRING SOON` · `EXPIRED` · `NOT YET ACTIVE` · `MISSING EXPIRATION`
- **Crane list (31 values):** `4001`–`4006`, `6001`, `6002`, `9001`, `9002`, `10001`–`10004`,
  `11001`, `11002`, `14001`, `14002`, `19001`, `20001`, `26502`, `26503`, `27501`, `35001`,
  `36001`, plus five non-unit scope values — `14002 5AX`, `90/100 TON FLEET`, `BLANKET`,
  `MULTIPLE`, `UNASSIGNED`, `WIDE LOAD`
- **City / Agency list (48 values):** Anaheim, Arcadia, Azusa, Buena Park, Burbank, Caltrans,
  Caltrans / State Highways, Caltrans — 5 Axle, Caltrans — 7 Axle / Dolly, Chino, City of Orange,
  City of Riverside, Claremont, Corona, Costa Mesa, Cypress, DMV Registration, Fontana,
  Fountain Valley, Garden Grove, Hawthorne, Huntington Beach, Inglewood, Irvine, Irwindale,
  Lake Elsinore, Los Alamitos, Los Angeles City, Los Angeles County, Norco, Ontario, Orange,
  Orange County, Orange County — Unincorporated, Placentia, Pomona, Rancho Cucamonga, Redlands,
  Riverside, Riverside City, Riverside County, San Bernardino County, Santa Ana,
  Santa Barbara City, Santa Barbara County, Stanton, Torrance, Tustin

**Note that `Caltrans` and `Caltrans / State Highways`, `Orange` and `City of Orange`,
`Riverside` / `Riverside City` / `City of Riverside` are all separate list values** carrying
separate record counts. The list is not de-duplicated.

## The picture the workbook paints of permit health

As of the recalculation in the `__Job Schedule Master` copy:

| | Count |
| --- | --- |
| Total permit records | **338** |
| Valid | 184 |
| Expiring within 60 days | 32 |
| **Expired / not good** | **115** |
| Not yet active | 4 |
| Missing expiration | 3 |
| Annual | 326 |
| Blanket | 9 |
| Registration (DMV) | 3 |

`RENEWAL QUEUE` bands its 358 rows: `1 - EXPIRED` 124 · `2 - RENEW NOW` 36 · `3 - UPCOMING` 19 ·
`4 - MONITOR` 179. (The queue holds more rows than the master table has permits; the workbook does
not explain the difference.)

**Roughly a third of the fleet's permit records are expired.** The workbook's own build note says
historical and expired permits are *deliberately retained* alongside current ones when the permit
number or validity period differs, so an expired row is not automatically a gap — but the workbook
gives no way to tell "retained history" from "lapsed and needed".

`CITY COVERAGE` shows the jurisdictions where **no** permit is currently active:
Azusa (5 records, 0 active), Burbank (2/0), Cypress (2/0), DMV Registration (3/0), Irwindale (2/0),
Lake Elsinore (1/0), Norco (1/0), Orange County (5/0), Orange County — Unincorporated (2/0),
Placentia (2/0), Pomona (2/0), San Bernardino County (8/0), City of Orange (2/0), Arcadia (2 records,
0 active but 2 due ≤60).

## The rules the workbook states about itself

From the `Permit Tracker` sheet's build note (a single long cell) and the `DISPATCH COMMAND CENTER`
reminders:

- **"Permit PDFs control. The annual-expiration workbooks are reference-only."**
- **Files with a different licence plate or no reliable unit identification are not assigned to a
  specific crane until verified.** Named examples: Garden Grove is marked Pending Verification
  because the uploaded annual names no crane or plate; two Corona permits and a Buena Park permit
  were not assigned to unit 36001 because the listed plates do not include its plate; a Norco
  permit is expired and does not identify the unit.
- **Blanket permits are entered as separate fleet-level records under Crane # `BLANKET`** so they
  are not mistaken for single-crane permits — for Arcadia, Buena Park (two plate groups), Corona
  (two plate groups), Cypress, Garden Grove, Norco (historical) and Santa Ana.
  **Plate-specific blanket permits remain limited to the plates listed on the source permit.**
- Current, future and historical permits are retained **separately** when permit numbers or validity
  periods differ. Duplicate copies of the same permit are not entered twice.
- **Permit-specific restrictions must be reviewed before dispatch reliance.**
- Always open the permit and verify route-specific restrictions before dispatching.
- **LA County participating-city coverage can change each fiscal year** — confirm the current
  Attachment 13.
- **Caltrans permits cover State highways only.** Local city/county permits may also be required.
- Original or authorised permit copies and required attachments **must travel with the vehicle**.
- Yellow permits should enter renewal processing now; **red permits must not be relied upon**.
- A `WIDE LOAD` equipment record exists for the tractor/trailer combination, with its own Caltrans,
  LA County, Los Alamitos and LA City permits, dimensions, travel restrictions, pilot-car
  requirements and required attachments.

## The kinds of restriction that ride on a permit

The `Restrictions / Notes` column is free text and is where most of the operational risk lives.
The recurring shapes, quoted from sample rows (**the 338 rows themselves were not copied**):

- **Time-of-day curfews** — "no movement during peak hours 7–9 AM and 4–6 PM" (Costa Mesa);
  "curfew 7–9 AM and 3–6 PM" (Tustin); "movement windows 9 AM–3 PM and 6 PM–6 AM" (Anaheim).
- **Weekend / night authorisation, granted or withheld** — "Saturday/Sunday movement authorized"
  (Anaheim); "Saturday authorized; Sunday and 12:01–6 AM not authorized" (Irvine); "no weekend or
  holiday moves" (Rancho Cucamonga); "Saturday, Sunday, and darkness authorized" (LA City);
  "Saturday allowed; Sunday prohibited; sunset-to-sunrise allowed" (LA County).
- **Advance-notice obligations** — "48-hour advance inspection notice" (Fontana); "call Police
  Traffic Division before entering city" (Huntington Beach); "notify City in writing 24 hours before
  move" (Tustin); "call for route approval 48 hours before every move" (Riverside City);
  "minimum 12-hour notice for changes" (Rancho Cucamonga).
- **Pilot-car thresholds** — "front pilot car required" (Huntington Beach); "pole car required over
  14 ft" (Irvine); "pilot cars required at width/length/height thresholds" (Fountain Valley);
  "pilot cars as required by the Purple Weight Pilot Car Maps" (Caltrans).
- **Named clearance and route constraints** — "Westminster Ave clearance between Harbor Blvd and
  Fairview St is 14 ft" (Santa Ana); "no transportation on State Street between Cabrillo Blvd and
  Sola Street after 11:30 AM unless specifically authorized" (Santa Barbara); "posted truck routes
  only" (LA County); "plaza closure dates apply" (Orange).
- **Permit-validity conditions** — "permit void if copied/faxed or conditions are not attached"
  (Orange); "original permit and accompaniments required" (Caltrans).
- **Data conflicts flagged in the row itself** — a Fontana permit whose header expiry (4/21/2027)
  disagrees with the travel-end date in its description (4/28/2027), with the note "verify before
  relying after 4/21/2027".

Every row also carries a `Restriction Flag` of `REVIEW` or `STANDARD` in the Job Schedule Master's
mirror of this data, which is what routes a job to YELLOW rather than GREEN — see
[../scheduling/job-schedule-master-workbook.md](../scheduling/job-schedule-master-workbook.md).

## The formulas (read 2026-09-04)

4,044 formulas, 7 distinct patterns on the master table, all deterministic from two dates:

- **Status (`Permit Tracker!J`)**: `MISSING EXPIRATION` if there is no expiry → `NOT YET ACTIVE`
  if `Valid From > TODAY()` → `EXPIRED` if `Valid To < TODAY()` → **`EXPIRING SOON` if `Valid To ≤
  TODAY() + 60`** → otherwise `VALID`. So "expiring soon" is a **60-day** window, stated nowhere
  in the sheet's text. `I` = days to expiry; `K` mirrors `J`.
- **`DISPATCH COMMAND CENTER`** counts the four statuses plus a row count; its lower block
  re-derives status for an ad-hoc date with the same 60-day rule.
- **`PERMIT FINDER`** resolves up to 20 permits for a chosen crane by matching a hidden helper key
  `Crane|n` in column `Q` of the master (crane code plus an occurrence counter), and links each hit
  with `HYPERLINK("#'Permit Tracker'!A<row>","OPEN")`.
- **`RENEWAL QUEUE`**, **`CRANE INDEX`** and **`CITY COVERAGE`** use `AGGREGATE(15,6,…)`
  small-if constructions to list, per crane or per city, the count by status and the **nearest
  future expiry**; `STATUS VIEWS` lists the first 25 permits in each status.
- **`ASSET PERMIT PROFILE`** is a lookup into `Crane Permit Specs` (A5:A200) by unit.

`Permit Tracker[88].xlsx` (the sales-folder copy) has the identical formula set.

## The two copies

| Copy | Valid | Expiring ≤60 | Expired | Not yet active | Total |
| --- | --- | --- | --- | --- | --- |
| `__Job Schedule Master (from Ryan 2026-08-11)/Permit Tracker.xlsx` | 184 | 32 | 115 | 4 | 338 |
| `__ERP_Sales Process (from Ryan 2026-08-06)/Permit Tracker[88].xlsx` | 189 | 30 | 112 | 4 | 338 |

Same 338 records, different `Days Remaining` recalculation date. The `[88]` copy also has a
shorter `PERMIT FINDER` output block (its crane/city selections were left on different values).
**Neither is a newer version of the other in content terms**; the difference is a live-formula
artefact. Treat the `__Job Schedule Master` copy as the reference, because it ships alongside the
scheduler that consumes it.

## Source

- `3.1.1_MODULE-CRM-SALES-QUOTES/__Job Schedule Master (from Ryan 2026-08-11)/Permit Tracker.xlsx`
  — 10 sheets, ~241 KB of extracted text. `.xlsx` → per-sheet row dump.
- `3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/Permit Tracker[88].xlsx`
  — the same 10 sheets, ~234 KB. Duplicate of the above apart from recalculated live values.
- **338 permit rows, 29 crane specification rows and 35 specification columns were deliberately
  not copied** — they are fleet data, not specification. Column headers, closed vocabularies,
  counts, stated rules and representative restriction wording are above.
