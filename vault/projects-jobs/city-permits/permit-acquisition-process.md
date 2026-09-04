---
title: How TCG obtains a city travel permit — the cross-city pattern
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__CITY_PERMIT/ (153 per-city .docx notes, read via the pre-combined digest) and .../__Job Schedule Master (from Ryan 2026-08-11)/__CITY_PERMIT/ (44 byte-identical duplicates)
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/projects-jobs, module/dispatch, kind/reference, permits, compliance, reference-data]
entities: []
---

# How TCG obtains a city travel permit — the cross-city pattern

**What this is.** TCG's dispatch team keeps one Word note per permitting jurisdiction — 153 of
them, covering roughly 150 California cities and counties plus Caltrans — describing how to get
an oversize/overweight transportation ("travel") permit in that jurisdiction. The notes were
written and maintained by dispatch staff over several years; individual notes carry their own
"as of" dates ranging from 2022 to July 2026. **They are operating instructions, not a
specification.** This page records the *patterns* that recur across the whole library; the
per-jurisdiction detail is in [city-permit-reference-a-l.md](city-permit-reference-a-l.md) and
[city-permit-reference-m-z.md](city-permit-reference-m-z.md).

> ## Security: live credentials sit in plain text in this shared folder
>
> A large share of the per-city notes contain **live portal usernames, passwords, and the
> answers to account security questions** for city permitting portals (Accela, Tyler EnerGov,
> OpenGov/ViewpointCloud, eTRAKiT, iWorq, SmartGov, MyGovernmentOnline and others), written
> beside the URL. Several are shared accounts on `dispatch@craneguys.com`. One note
> (Lake Forest) additionally contains a captured OAuth `id_token`/`access_token` pair pasted
> into the login URL. One note (Temple City) records that a **business-licence application
> requires the owner's driver's licence number and Social Security number**.
>
> **None of that was copied into this vault.**
> `[portal credentials in the source file — deliberately not copied]` marks each place a
> credential exists; the source path is given so an authorised person can look it up.
> This is flagged as a real-world exposure, not a documentation problem: the credentials are
> readable by anyone with access to the SharePoint "Project Repository" share.

## How an application is submitted — five channels

The notes describe five ways a permit is obtained. Many jurisdictions use more than one
(apply online, then pay by phone; or apply by email, then a runner collects the paper).

| Channel | What the notes say | Examples named in the notes |
| --- | --- | --- |
| **Online portal** | Log into a named city portal, pick Public Works → transportation / oversize permit, complete the application. Several cities still require the paper PDF application to be *uploaded* into the portal as well. | Anaheim, Chino, Chino Hills, Cathedral City, Camarillo, Cypress, Downey, El Cajon, Fontana, Fullerton, Garden Grove, Glendale, Glendora, Hawthorne, Huntington Beach, La Palma, La Quinta, Lake Elsinore, Lake Forest, Loma Linda, Manhattan Beach, Mission Viejo, Montebello, Moreno Valley, Orange, Orange County, Placentia, Rancho Cucamonga, Redondo Beach, Riverside County, San Bernardino County, San Jacinto, Santa Barbara city & county, Santa Monica, Seal Beach, Simi Valley, Torrance, Tustin, Upland, Vernon, Victorville, Villa Park, Whittier, Caltrans |
| **Email the application** | Email the completed application PDF, usually with the certificate of insurance (COI) and often a photocopy of the payment check, to a named public-works address and/or named staff. | Alhambra, Aliso Viejo, Azusa, Barstow, Bell, Bell Gardens, Bellflower, Brea, Buena Park, Burbank, Calabasas, Colton, Compton, Covina, Duarte, Eastvale, Gardena, Goleta, Hemet, Hermosa Beach, Hesperia, Highland, Indian Wells, Inglewood, Inyo County, Irwindale, Kern County, La Cañada Flintridge, La Habra, La Puente, Laguna Hills, Laguna Woods, Los Alamitos, Monrovia, Monterey Park, Norwalk, Ontario, Oxnard, Palos Verdes Estates, Pasadena, Pomona, Rancho Mirage, Rancho Palos Verdes, Rancho Santa Margarita, Rolling Hills Estates, San Bernardino, San Gabriel, San Juan Capistrano, Santa Clarita, Santa Paula, Sierra Madre, Stanton, Tulare, Westminster, Yorba Linda, Yucaipa, Yucca Valley |
| **Fax** | Fax the application. | Redlands, South Pasadena, Brea (fax listed as an alternative to email) |
| **In person / runner** | A person must physically deliver the application, collect the permit, or pay at the counter. The notes call this "requires a runner". | Arcadia, Bell, Bell Gardens, Bellflower, Compton, Diamond Bar, Irwindale ("MUST PICK UP PERMIT"), La Verne, Perris, Pomona, San Diego, San Gabriel, Santa Ana ("must go to the city and obtain the permit in person — do not call"), Temple City, Ventura |
| **Third-party permit agency** | The permit is ordered through **Quality Permits** (contacts Ben Escobar `ben@qualitypermits.com`, Aallijah Granado; `permits@qualitypermits.com`; 909-748-7715), giving crane size, job-site address and job date. | Bishop, Banning, Calabasas (address check), Lake Arrowhead, La Puente, Murrieta, Perris, San Diego, Temple City, Visalia, Arleta (address check), Huntington Park (address check), Gardena (city-limit check), Fillmore, self-loader / pole permits |

The notes do not say who decides which channel applies when a jurisdiction offers several, and
do not state a fallback when a portal is down.

## Jurisdictions that do not issue their own permit

- **Laguna Beach** — "does not issue permits; they honor Caltrans" (per a Quality Permits email dated 2022-07-11).
- **Dana Point** — "City does not issue permits. Driver must have Caltrans."
- **Ojai** — "does not issue permits. You will need to call City and driver must have Caltrans permit with him." (805-646-1414)
- **El Centro** — "See County of Imperial."
- **Arleta**, **El Monte** — usually covered by the LA City / LA County annual; El Monte still requires an email to the city with job address, crane size, a copy of the LA County annual, and the time.

## Jurisdictions that require *stacked* permits

Several notes say the job needs permits from more than one agency for a single move — the note
usually tells dispatch to send the job-site address to Quality Permits first so the stack can be
worked out.

| Job location | Permits the note says are needed |
| --- | --- |
| Bishop | Inyo County **or** the TCG Caltrans annual, depending on address |
| Banning | possibly a single Caltrans, because part is a red route |
| Fillmore | Ventura County **and** Fillmore City |
| Huntington Park | Vernon, LA City and Huntington Park, depending on address |
| Lake Isabella | Los Alamitos, Caltrans and Kern County |
| Mammoth Lakes | Los Alamitos city, Caltrans and **verbal** Mono County approval; all oversize loads must call Mono County Sheriff dispatch (760-932-7549 opt 7, 24/7) before entering, who decide whether a Sheriff escort is required |
| Montecito | Santa Barbara County |
| Montrose | LA County, Caltrans and Los Alamitos |
| Palos Verdes Estates | usually Torrance and Rolling Hills Estates as well |
| Rancho Palos Verdes | usually Rolling Hills Estates and Torrance — "3 permits total" |
| Temple City | Rosemead permit as well |
| Trona | Inyo County |
| Visalia | Tulare County and/or Visalia, depending on address |
| Windsor Hills | Los Alamitos, Caltrans and LA County |

## Annual and blanket permits

The notes distinguish three things:

- **Annual permit** — covers one named crane (by licence plate / VIN) in one jurisdiction for a
  year. Typical stated price **$90**; also seen at $85 (Laguna Niguel), $95 (Inglewood), $105
  (Garden Grove, Hemet), $150 (Arcadia blanket).
- **Blanket permit** — covers *any* fleet vehicle. Explicitly offered by **Arcadia** ($150),
  **Cypress**, **Garden Grove** ("THEY OFFER BLANKET ANNUALS"), **Santa Ana**, and (per the
  Permit Tracker) Buena Park, Corona and Norco.
- **Address-specific annual** — an "annual" that only covers one job site. Named for
  **Compton** ("annuals are offered but covers 1 jobsite / address specific") and
  **La Palma** ("annuals are address specific only").

Cities the notes say offer **no annual**: Alhambra, Bellflower, Brea, Calabasas, Culver City,
Diamond Bar, Duarte, Eastvale, Fullerton, Glendora, Hermosa Beach, Indian Wells, La Habra,
La Verne, Monrovia, Norwalk, Rancho Palos Verdes, San Bernardino, Seal Beach, Vernon,
Westminster, Yucca Valley.

**Holding an annual does not always mean you can just drive in.** Several cities require a
notification per entry even with a valid annual:

- **Claremont** — "for annuals we must notify the city every time we enter the city. Only fill
  out the route portion and put 'see annual'."
- **Laguna Niguel** — "email Cyndee every time we will enter the city when we get an annual permit."
- **Manhattan Beach** — "If you have an annual you ALWAYS need to email Traffic and let them know
  when you will enter the city, the new address, and the route. They will email an updated permit."
  The note includes the exact email wording to use.
- **San Gabriel** — "We must email Laura to confirm the job address when we go into the city."
- **Corona** — an annual may carry up to **6 licence numbers**; requires an original current COI
  naming the City of Corona as additional insured, valid for the permit's whole duration.

## Fees

Where a fee is stated it is usually the California standard **$16.00** single-trip. Departures
recorded in the notes: Duarte $15, Laguna Niguel single $15, Thousand Oaks $17, Aliso Viejo $16,
Bell Gardens $18, Brea $20, San Jacinto $20, Garden Grove $30, San Juan Capistrano $32, Laguna
Woods $32, Rancho Santa Margarita $16 each way / $32 round trip, Vernon $16 each way, Hermosa
Beach $36, Rancho Palos Verdes $44 (**$224 if a traffic-control inspector is required** — the
note says an inspector is required when setting up on private property), Arcadia single $50,
San Gabriel $60, Calabasas $63, Compton $125, Redondo Beach $240, Glendora $250, **Temple City
$490**. **Kern County, Palm Desert and Yucca Valley are recorded as charging no permit fee.**

Payment methods the notes name: credit card over the phone; a payment link emailed after
approval; online payment inside the portal; a photocopy of a check emailed plus the physical
check mailed; cash or card at the counter (Bellflower — "permit MUST be paid in person");
and a separate city-treasurer step (Gardena — email the issued permit plus a completed credit-card
form to `citytreasurer@cityofgardena.org`, who validate the permit by return email).

## Insurance and other supporting documents

A certificate of liability insurance (COI) is the most frequently required attachment. Others
the notes name: a credit-card authorisation form (Calabasas, Colton, Placentia, Santa Clarita,
Los Alamitos, Hemet — Hemet's must be **faxed**); a current **business licence** (Covina,
San Bernardino, Temple City); the crane's **licence plate number** (Arcadia — all vehicle VINs;
Hawthorne, Irvine, La Habra, Lake Forest, Laguna Niguel, Mission Viejo, Ontario); a copy of the
**Caltrans** permit (Beaumont, Calabasas, Inyo County, Mission Viejo, Rancho Palos Verdes,
Rialto); a **hold-harmless attachment** (Rancho Palos Verdes); an **indemnification form**
(San Bernardino County, which "no longer uses COIs"); and an **encroachment permit copy** when
setting up in the street (Rancho Palos Verdes). Moreno Valley requires TCG's insurer to file the
COI with the city directly — a two-day step — *before* the permit application can be made.

## The Friday problem

A recurring, and operationally significant, pattern: **a large share of these jurisdictions are
closed on Fridays or on alternating Fridays.** Named as closed Fridays: Adelanto, Alhambra,
Anaheim, Azusa, Bell, Bell Gardens, Compton, Corona, El Cajon, Hemet, Hermosa Beach, Hesperia,
Highland, Huntington Beach, Irwindale, La Puente (also closes at noon Mon–Thu), La Quinta,
La Verne, Murrieta, Palos Verdes Estates, Rancho Palos Verdes, Rancho Santa Margarita, Redlands,
San Gabriel, San Jacinto, San Juan Capistrano, Seal Beach, Thousand Oaks, Torrance, Vernon,
Yorba Linda, Yucca Valley. Named as closed *alternating* Fridays: Costa Mesa, Culver City,
Garden Grove, Inglewood, Norwalk (open alternate Fridays), Orange, Oxnard, Palm Springs, Ventura,
Victorville. Glendora is open a half-day Friday; San Bernardino Friday 07:00–12:00.

This is the operational basis for the "permit clock" rule used by the scheduling path — see
[../scheduling/dispatch-scheduling-path.md](../scheduling/dispatch-scheduling-path.md), which
excludes Thursday noon through Monday morning from permit lead-time counting. The per-city notes
show *why* that exclusion exists; they do not themselves state the rule.

## Pole and self-loader jobs

From `__CITY_PERMIT/copy of all files/Self Loader oversize applications/For Self loader permits.docx`:

- Self-loader permits are ordered by emailing Quality Permits, always CC'ing `dispatch@craneguys.com`.
- **Any pole over 80 ft is a permitted load. An 80 ft pole does not require a permit.**
- Check the notification request: anything over 80 ft **and a wood pole** requires permits.
- Where the request says **TSP or light-weight steel (LWS)**, the pole can travel in sections and
  no oversize permit is required.

Pole jobs also appear in two city notes: **Palos Verdes Estates** — for pole jobs the application
goes to Stacy and Ryan at RCS Safety, who submit it with their traffic permits; **Rancho Palos
Verdes** — "for any pole job we need to send them the notification # or the TD #".

## Caltrans

TCG holds Caltrans annual permits for its cranes. A **single** Caltrans permit is needed when the
route runs through a **red route**. Applications go through the CalRoute portal
(`https://calroute.dot.ca.gov`) `[portal credentials in the source file — deliberately not copied;
see __CITY_PERMIT/copy of all files/Caltrans/Caltrans.docx]` — the note itself records the stored
password as out of date ("need to update"). Turnaround "depends on how busy they are — can take
from 24 hours to 7 days." Open Monday–Friday, closed holidays. The Permit Tracker adds that
Caltrans permits **cover State highways only** and that local city/county permits may also be
required.

## What these notes do not say

- No note states who owns the library or how often it is reviewed. Individual "updated" stamps are
  sporadic (Bell 11/2025, La Palma 12/24, Murrieta 5/13/26, Santa Barbara 2/25, Adelanto 3/2026,
  Palm Desert 4/2026, Compton July 2026).
- No note gives a rule for choosing between a single and an annual permit on a given job.
- Nothing states what happens if a permit is refused, or how a refusal reaches sales.

## What the ERP has been asked to do with this library

From the client's own feedback register, [`../../erp-review-log.md`](../../erp-review-log.md)
→ *Job site and permits (2)*, recorded at the 2026-05-05 review:

- **Map-based job-site permit intelligence** — the job-site map should identify FAA airport zones
  and other permit triggers.
- **Flag annual permit requirements by city / state / zip**, indicating whether an annual city
  permit is already in place or is required.

**This library and the Permit Tracker workbook are the raw data behind that second request.**
The per-city notes say which jurisdictions offer an annual or blanket permit at all and what it
costs; [permit-tracker-workbook.md](permit-tracker-workbook.md) is where TCG currently tracks
*which crane holds which annual, in which city, valid until when*. Together they are what a
"do we already have an annual here?" flag would have to read from. The review log does not say
where the flag should appear, nor what it should do when the answer is "required but expired".

The same register also asks (→ *Safety on the quote (2)*) to **replace the scattered permit
checkboxes with one expandable checklist** covering travel permits, lift plan, safety and FAA.

## Source

- `SCRATCH/city-permits-combined.txt` — pre-combined digest of 197 converted `.docx` notes
  (153 distinct under `__CITY_PERMIT/copy of all files/`, plus 44 byte-identical duplicates under
  `3.1.1_MODULE-CRM-SALES-QUOTES/__Job Schedule Master (from Ryan 2026-08-11)/__CITY_PERMIT/`).
  Duplication was verified by content hash: all 44 match their `copy of all files` counterpart exactly.
- `3.1.1_MODULE-CRM-SALES-QUOTES/__CITY_PERMIT/__CITY_PERMIT_APPLICATIONS.url` — a Windows
  internet shortcut, not a document. It points at a SharePoint folder,
  `craneguys-my.sharepoint.com/.../personal/bramirez_craneguys_com/Documents/City Permit Applications`,
  which the drop describes as holding blank transportation-permit application PDFs per crane
  tonnage per city. Those PDFs are not in this drop and were not read.
- Conversion: `.docx` → pandoc GFM. Two source notes converted to **empty files** and carry no
  content at all: `Fontana/Document.docx` and `Riverside City/Document.docx`.
