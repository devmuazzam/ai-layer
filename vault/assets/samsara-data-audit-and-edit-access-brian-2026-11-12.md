---
title: Samsara data audit and edit access — Brian Petros's email to Patrick McKiernan, 2026-11-12
source: Email from Brian Petros to Patrick McKiernan (IT Manager), shared with CodingCops 2026-11-12. Body pasted to the Claude Code session by Syed Haris; two of its three embedded images supplied (image001, the problems list, and the "official sources" image). The third image was not supplied.
migrated: 2026-11-12
updated: 2026-11-12
status: unverified
conflicts_with: []
jira: []
tags: [module/assets, module/admin, kind/reference, samsara, vin, master-data, data-migration, permissions, provenance]
entities: [asset, samsara-asset, gateway, vin, external-id, dmv-make-code]
---

# Samsara data audit and edit access (Brian Petros, 2026-11-12)

Brian Petros and **Jeff Stricker** (Fleet Manager) are auditing Samsara against FCC to clean
the data up before the ERP takes it. In this email Brian asks **Patrick McKiernan** (IT Manager,
who holds the Samsara account) to audit **who can edit asset data in Samsara**. He also sends
two findings lists, one of them marked *"for us and CodingCops to consider"*.

**This file records the email. It is not a spec.** The findings are Brian's own research. The
"official sources" image has citation chips (`dot`, `vpic.nhtsa.gov`, `ecfr`), which suggests
an AI research tool. CodingCops has not re-measured any of it. Where a finding matches our own
measurement from 2026-09-21, the table below says so.

## 1. The ask to Patrick: lock down who edits asset data in Samsara

Verbatim, in part:

> *"Can you please help do a review/audit of all users in Samsara and their access (ability to
> change information on the assets/units)? It seems too many users can change the info on
> assets in Samsara. We need to "lock this down" as much as possible so it stays
> consistent/more reliable and helps prevent accidental changes to really important
> information used for insurance, permits, registrations, etc."*

> *"Not sure who Joe and Kyle would like to allow to change the "core" data on assets/units in
> Samsara, but thinking maybe the only ones to allow to edit this would be: Kyle, Joe S.,
> Jeff S., Me and you"*

> *"…to make sure that after the changes/updates are made then we have enough restrictions in
> place to prevent the updated info from changing too easily over time (without proper approval
> from the ones responsible for maintaining/certifying it)."*

- **This is a proposal, not a decision.** Brian defers the list to Joe Schacatano (VP of
  Operations) and Kyle Harlow (VP Fleet & Field Ops). The five names he suggests are Kyle
  Harlow, Joe Schacatano, Jeff Stricker, Brian Petros and Patrick McKiernan.
- **The audit itself is TCG's internal Samsara admin work.** It does not ask CodingCops for
  anything.
- **How it applies to the ERP.** The same concern applies once the ERP holds this data. An
  ERP asset is edited under **one permission**, `asset-management: edit` (`PATCH /assets/:id`,
  `apps/api/src/presentation/asset-management/assets/assets.controller.ts:103-104`). Anyone
  with that permission can change the VIN, plate, serial number and Samsara link as easily as
  the description or the yard. Nothing separates "core" identity fields from the rest, and no
  approval step exists. Open question:
  [gaps.md → *Who may change an asset's core identity data in the ERP*](gaps.md#who-may-change-an-assets-core-identity-data-in-the-erp--and-does-it-need-approval).

## 2. "The problems most likely to break the ERP sync" (image001)

Each item is compared with
[fcc-samsara-reconciliation-2026-09-21.md](fcc-samsara-reconciliation-2026-09-21.md), which we
measured on 2026-09-22. That file used Samsara's 2026-09-21 export and FCC's 2026-07-02
extract.

| # | Brian's finding (verbatim) | What we already measured | Reading |
| --- | --- | --- | --- |
| 1 | *"9001 and 9002 have the same VIN. One of them is wrong."* | Samsara's `9002` has `9001`'s VIN `1F9N3J89X8L028858`. FCC has `1F9N3J7917L028490` for 9002 (§*Per-unit adjudications*). | **Already known.** FCC's VIN is the likely correct one for 9002. Still needs a check against the data plate. |
| 2 | *"9001 shows as a "Chevrolet Silverado" and 10002 as a "Nissan Altima." Both have crane VINs"* | Samsara calls 9001 a *2011 Chevrolet Silverado* and 10002 a *2023 Nissan Altima*. FCC has Link-Belt cranes. The VINs agree. | **Already known.** Only the descriptive fields are wrong. |
| 3 | *"Re Rent Bragg Flatbed" is in Samsara twice, with the same VIN and plate. One of its two gateways hasn't reported since Nov 2024.* | VIN `1FDRF3G64FED17871`, plate `74530W1`. One gateway last reported 2024-11-15, and the record was left over from a gateway swap. Both records match FCC `RE-RENT PT2`. | **Already known.** The stale record can be removed. |
| 4 | *"6001 has no VIN, and its gateway has been silent since April 2024."* | Last connected 2024-04-15 (888 days at export). FCC marks 6001 **inactive**. The gateway went silent around the time the unit was retired. | **Silence: already known. Missing VIN: new.** A retired unit is probably for removal from Samsara, not for correction. That is inference. |
| 5 | *"10004's VIN looks wrong for a crane. The federal VIN decoder reads it as a 2008 Kenworth truck-tractor."* | FCC gives **one Samsara id to both `10004` (active) and `AT07` (inactive)**. The client's comparison workbook already said *"Samsara says 10004 but the VIN points at inactive AT07"*. | **New decode, and it is consistent with what we found.** The likely explanation: AT07, a tractor, carried the gateway, which later moved to 10004 and was renamed, but the VIN was never updated. That reading is inference. Needs a physical check. |
| 6 | *"Ten gateways haven't reported in over 90 days."* | 8 had not reported in over **250** days at the 2026-09-21 export. These include the 200-ton-plus cranes `35001`, `20001` and `55001`. | **Consistent.** The threshold and the date differ, so the two counts cannot be compared directly. |
| 7 | *"15 unit names include driver names or other extra words. Four have no unit number at all."* | Not measured. We recorded the pairing typed into a name (`ST09 (AT for SL03)`). On 2026-09-22 we recommended setting `Name` to exactly the unit code (§*Field priority put to the client*). | **New count. It supports our recommendation.** |
| 8 | *"External IDs are empty on every vehicle. This is the field CodingCops should use to permanently link each Samsara record to its ERP unit."* | The 2026-09-21 CSV had **no vehicle-ID column**. External IDs were not in the export. | **New, and it changes the link design.** See §3. |

## 3. "For us and CodingCops to consider"

### External IDs as the permanent link

Brian's proposal: link each Samsara vehicle to its ERP unit through Samsara's **External IDs**
field. Today every vehicle's External IDs field is empty.

**What the build does today** (checked by reading the code on 2026-11-12):

- The link is held **on the ERP side**, in `Asset.samsaraAssetId` and `Asset.samsaraAssetType`,
  with `@@unique([tenantCompanyId, samsaraAssetId])`. Someone sets it by hand from the asset
  form's Samsara picker. abdulrehman said on 2026-10-22 that the test tenant's assets are
  linked and that a link can be changed by hand.
- The ERP **reads** from Samsara only. Nothing writes to Samsara. The stats mapper ignores
  `externalIds`: its own comment says *"Real responses also carry externalIds … the index
  signature tolerates them"* (`apps/api/src/service/samsara/samsara.mapper.ts:50`).
- The FCC seeder does not map FCC's `LowerGPSID` into `samsaraAssetId`. So no links come over
  from FCC on import (reconciliation file, §*FCC already carries the Samsara link*).

An External ID points the other way, from Samsara to the ERP. For it to stay correct,
**somebody has to write it into Samsara**: either the ERP through the Samsara API, which needs
an API token with write access to vehicles, or a person by hand. The ERP reads Samsara with a
token Patrick McKiernan controls, and whether that token can write has not been checked. Open
question:
[gaps.md → *Samsara External IDs as the link*](gaps.md#samsara-external-ids-as-the-link--who-writes-them-and-does-the-erp-keep-its-own-link-too).

### Where make, model and other fields should come from (image "Official sources")

Verbatim summary of Brian's three points:

- **Trucks, tractors and cars: NHTSA's VIN decoder (vPIC).** *"Samsara's make and model values
  already match it. For example, it returns "T8 Series" for your older Kenworths."*
- **Most cranes: the crane's data plate and title.** Liebherr, German-built Grove and `1F9…`
  crane VINs come back from NHTSA as *"Manufacturer is not registered with NHTSA for sale or
  importation in the U.S. for use on U.S roads"*. *"No federal decoder will fill those fields,
  so they have to come from your own records."* Six `1F9…` cranes come from the same
  low-volume builder. Under 49 CFR 565, for these builders VIN positions 1–3 together with
  12–14 identify the manufacturer, and all six share that code.
- **Plates and DMV make codes: the DMV registration card.** The short make codes come from the
  federal NCIC list (`KW` Kenworth, `PTRB` Peterbilt, `TADO` Tadano and Tadano Faun).
  *"Store these in their own ERP field, separate from the make."*

**What the ERP has today** (`apps/api/prisma/schema.prisma` → `model Asset`): `manufacture`,
`vehicleMake`, `vehicleModel`, `modelYear`, `license`, `state`, `serialNumber` and `vin`. There
is **no DMV make code field**. The ERP does not call any VIN decoder, and the email does not ask
it to. It names sources for the people cleaning the data. The DMV make code is the one stated
ask for a field. Open question:
[gaps.md → *DMV make code*](gaps.md#dmv-make-code--a-separate-asset-field-as-brian-petros-asked).

## 4. CodingCops' reply, 2026-11-12

Syed Haris replied to Brian Petros on 2026-11-12. The text was drafted in the Claude Code
session; Haris confirmed it was sent but did not say whether he edited it first.

- **Given to Brian** (from our 2026-09-21 measurements, each still to be checked against the
  data plate): FCC's VIN is the likely correct one for 9002. 10004 and the inactive tractor AT07
  share one Samsara ID, which explains the Kenworth decode. The Bragg record that last reported
  on 2024-11-15 is a leftover from a gateway swap. 6001 is inactive in FCC, so it may be one to
  remove from Samsara rather than fix.
- **Asked of Brian:** (1) who fills in the External IDs: the ERP, with a token from Patrick that
  can edit vehicles, or TCG by hand; (2) whether the ERP's core identity fields should be limited
  to the same short list, and whether changes need approval or just a record; (3) whether the
  DMV make code goes on every vehicle or only on registered units.
- **Offered by CodingCops, not decided by TCG:** we will use External IDs as the link, and we
  can add the DMV make code as its own field next to Make.

## What this does not establish

- **Any decision.** The editor list is a proposal that Joe Schacatano and Kyle Harlow have not
  confirmed. The External IDs link and the DMV make code field are Brian's suggestions.
- **Any re-measurement by CodingCops.** Items 4 (missing VIN), 5 (the Kenworth decode), 6 (the
  count of ten) and 7 (the count of fifteen) are Brian's, and nobody has checked them against a
  same-day export.
- **The third image.** The email mentions three images. Two were supplied.
