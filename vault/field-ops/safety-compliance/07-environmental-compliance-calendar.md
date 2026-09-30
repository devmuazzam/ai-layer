---
title: Environmental Compliance Calendar — TCG's recurring regulatory filings and the agencies behind them (Dennene Jones, 2026-09-30)
source: user-supplied/3.6.1_MODULE-SAFETY-COMPLIANCE.zip (2026-10-01) — Safety Module Ideas/Environmental Compliance Calendar.xlsx; covering e-mail Dennene Jones → Brian Petros (text relayed by syed.haris, 2026-10-01)
migrated: 2026-10-01
updated: 2026-09-30
status: unverified
conflicts_with: []
jira: []
tags: [module/field-ops, module/assets, module/admin, kind/reference, safety, compliance, notifications, reporting]
entities: []
---

# Environmental Compliance Calendar

**What this is.** A two-sheet Excel workbook, created and last saved by **Dennene Jones on
2026-09-30**, in the same `Safety Module Ideas` folder as the
[requirements specification](06-safety-data-platform-requirements-spec.md).
- **Sheet 1** lists **19 recurring regulatory obligations**, each with its agency and due date.
- **Sheet 2** lists **20 agency systems** and what each is used for.

It is the concrete form of what Dee asked for on the
[2026-09-29 call](../../meetings/2026-09-29-safety-discussion-onboarding-certifications-incidents-and-facility-compliance.md)
§7. She wanted *"an automated calendar"* for obligations due monthly or every one, two or five years,
and ehtesham.anwar asked her for *"the list of them and what we are submitting"*.

**What it is for, in Dee's words.** This is from her covering e-mail to Brian Petros (2026-09-30,
relayed by syed.haris on 2026-10-01):

> *"Also, they asked me for a list of compliance submission websites we report to in California in
> our Industry, and the submission dates to create a calendar so that we can receive email
> notifications 90, 60 and 30 days out. Spreadsheet attached."*

So the requirement it carries is **e-mail notifications at 90, 60 and 30 days before each due date**.
The workbook itself has no notification columns, and its `Days Left` column is only a snapshot. The
e-mail doesn't say who should receive the notifications. Note that these intervals differ from the
**60 days, 30 days, and expiry** that Dee gave for certifications on the call.

**It also confirms two corrections to that transcript.** The call's "SERS" and "Koopa" are
**CERS** and **CUPA**, which appear here together as *"CUPA via CERS"*.

> **A data list, with one stated behaviour.** The only behaviour asked for is the e-mail reminders at
> 90, 60 and 30 days. It is Dee's answer to CodingCops' request, which is a request for this feature,
> but it is not a scoped or accepted requirement. The AbInBev360 example spec puts environmental
> *metrics* out of scope, and it doesn't mention this calendar.

## 1. Sheet "Reporting Frequency" — 19 obligations

**How to read the columns.**
- `Due Month` and `Due Day` are the machine-readable form of `Due Date / Timing`. `One-time Date` is
  empty on every row.
- **`Next Due` and `Days Left` are typed values, not formulas.** They are a snapshot taken on
  **2026-09-30**: `Days Left` counts from that date, and the row due 2026-09-30 shows `0`.

The Type column is shortened: **Reg.** = *Regulatory deadline*; **Rec.** = *Recommended timing* (an
internal best-practice date, not a legal one).

| Operation | Requirement | Agency | Type | Frequency | Due |
| --- | --- | --- | --- | --- | --- |
| Trucks & trailers | Heavy Vehicle Use Tax, Form 2290 | IRS | Reg. | Annual | Aug 31 |
| Trucks & trailers | IFTA Q4 fuel tax return | CDTFA | Reg. | Quarterly | Jan 31 |
| Trucks & trailers | IFTA Q1 fuel tax return | CDTFA | Reg. | Quarterly | Apr 30 |
| Trucks & trailers | IFTA Q2 fuel tax return | CDTFA | Reg. | Quarterly | Jul 31 |
| Trucks & trailers | IFTA Q3 fuel tax return | CDTFA | Reg. | Quarterly | Oct 31 |
| Trucks & trailers | Unified Carrier Registration (UCR) for next year | UCR | Reg. | Annual | Dec 31 (opens Oct 1) |
| CDL operators | Clearinghouse annual limited query, **every CDL driver** | FMCSA | Reg. | Annual, per driver | Within 12 months of last query (batch in January; sheet uses Jan 15) |
| Forklifts & off-road equipment | DOORS annual report and ROAR | CARB | Reg. | Annual | Mar 1 (window opens Jan 1) |
| Fuel island (above-ground tanks) | APSA Tank Facility Statement | CUPA via CERS | Reg. | Annual | Mar 1 |
| Fuel island (above-ground tanks) | SPCC discharge-prevention briefing for oil-handling staff | EPA / CUPA | Rec. | Annual | May |
| Hazardous materials (facility-wide) | Hazardous Materials Business Plan (HMBP): inventory, site map, emergency plan | CUPA via CERS | Reg. | Annual | Mar 1 |
| Hazardous materials (facility-wide) | HMBP employee training refresher (documented) | CUPA | Rec. | Annual | June |
| Hazardous materials (facility-wide) | Mid-year CERS inventory check against what is on site | CUPA | Rec. | Annual | September |
| Mechanics shop | Hazardous Waste Generator fee return | CDTFA | Reg. | Annual | End of February |
| Mechanics shop | Year-end hazardous waste manifest close-out | Internal | Rec. | Annual | Dec 31 |
| Stormwater (yard) | Industrial General Permit (IGP) Annual Report | Regional Water Board via SMARTS | Reg. | Annual | Jul 15 |
| Stormwater (yard) | IGP stormwater sampling events | Regional Water Board | Reg. | 2 events Jul–Dec, 2 events Jan–Jun | By Dec 31 and Jun 30 |
| Workplace safety (all employees) | Post Form 300A summary | Cal/OSHA | Reg. | Annual | Posted Feb 1 through Apr 30 |
| Workplace safety (all employees) | Electronic Form 300A submission (ITA) | Federal OSHA | Reg. | Annual | Mar 2 |

**What the rows show about the model.**

- **There are three kinds of timing.**
  - A fixed date: most rows.
  - A window: *opens Oct 1*, *Feb 1 through Apr 30*.
  - A rolling per-person deadline: the Clearinghouse query is *within 12 months of the last one*, for
    each CDL driver.

  A single due-month and due-day pair can't represent the second and third kinds. The sheet
  approximates them.
- **Some obligations are per entity, not per company.** The Clearinghouse row is **per driver**. The
  IGP sampling row is **two events per half-year**, not one filing.
- **Everything is grouped by `Operation`**, meaning the physical or organisational thing that creates
  the obligation (trucks, the fuel island, the shop, the yard, all employees). This is closer to an
  asset or facility dimension than to the spec's location hierarchy.
- **The two OSHA 300A rows** are the same data as the spec's Module 5 *"OSHA 300 log and 300A
  summary"* report. They are the one place where the calendar and the spec overlap.

## 2. Sheet "Agency Links" — 20 agencies and systems

| Agency / system | Used for | Operations |
| --- | --- | --- |
| CARB Clean Truck Check (CTC-VIS) | Truck reporting, fees, test results | Trucks & trailers |
| CARB Truck & Bus Regulation | On-road diesel engine rules | Trucks & trailers |
| CARB Off-Road Zone (DOORS) | Diesel forklift and off-road reporting | Forklifts & off-road |
| CARB Zero-Emission Forklifts | Forklift rule status | Forklifts & off-road |
| South Coast AQMD Permits | Equipment permits and exemptions | Fuel island, welding, mechanics shop |
| South Coast AQMD Annual Emissions Reporting | AER filing | Fuel island |
| CERS (CalEPA) | HMBP, APSA, hazardous waste | Hazmat, fuel island, mechanics shop |
| OC Health Care Agency, Environmental Health | **CUPA for most Orange County cities** | Hazmat, fuel island |
| Orange County Fire Authority | **Sprinkler inspections**, high-piled storage permits | Fire risers, warehouse |
| EPA SPCC | Oil spill prevention plans | Fuel island |
| State Water Board SMARTS | IGP stormwater filings | Stormwater |
| Cal/OSHA | 300A posting, injury reporting, forklift training | Workplace safety, forklifts |
| Federal OSHA Injury Tracking Application | Electronic 300A | Workplace safety |
| FMCSA Registration | MCS-150, DOT inspections | Trucks & trailers, CDL operators |
| FMCSA Drug & Alcohol Clearinghouse | Driver queries | CDL operators |
| Unified Carrier Registration (UCR) | Annual carrier registration | Trucks & trailers |
| CA DMV Motor Carrier Services | Motor Carrier Permit, **Employer Pull Notice** | Trucks & trailers, CDL operators |
| California Highway Patrol | **BIT** programme | Trucks & trailers |
| IRS Form 2290 | Heavy Vehicle Use Tax | Trucks & trailers |
| CDTFA | IFTA, hazardous waste generator fee | Trucks & trailers, mechanics shop |

The source also gives each agency's public URL. They are omitted here because every one is the
agency's own home or programme page.

**The agencies place the yard in Orange County** (OC Health Care Agency as CUPA, OCFA, South Coast
AQMD).

## 3. What the calendar leaves out

The **agency sheet names obligations that have no calendar row**:
- CARB Clean Truck Check;
- South Coast AQMD annual emissions reporting and permits;
- **OCFA sprinkler inspections**;
- FMCSA **MCS-150** biennial update;
- the DMV Motor Carrier Permit and Employer Pull Notice;
- the CHP **BIT** terminal inspection.

**Two examples Dee gave on the call are also missing**: the *"annual sprinkler head inspection"* and
the annual *"exit signs … illuminating"* check. Both are internal, recurring facility inspections, the
kind the spec's Module 4 schedules. They are not agency filings, which may be why they are absent.

## 4. Open points

These are recorded for a human to route. They are **not** written to any `gaps.md`.

1. **Who receives the 90/60/30-day e-mails, and is anything required after the due date?** For
   example: a mark-as-filed step, proof of submission, or rolling to the next date. The e-mail gives
   only the three intervals.
2. **Which of these filings could the ERP populate from its own data?**
   - IFTA and Form 2290 need vehicle miles, fuel and weights, which Samsara or the ELD might supply.
   - The Clearinghouse query needs the CDL-driver roster.
   - The 300A needs Module 1's recordables and payroll hours.

   The rest (HMBP, APSA, IGP) are facility filings that the ERP holds no data for.
3. **Rolling and per-person deadlines.** Should the Clearinghouse query be tracked per driver, like a
   certification expiry, rather than as a company date?
4. Should the **agency-sheet obligations without dates** (§3) be completed before anything is built
   from this list?

## Source

`3.6.1_MODULE-SAFETY-COMPLIANCE/Safety Module Ideas/Environmental Compliance Calendar.xlsx` — 23 KB,
read cell by cell with openpyxl. Both sheets were read in full: `A1:K20` and `A1:D21`. There are no
formulas, merged cells or data validations. Workbook properties: creator and last-modified-by
*Dennene Jones*, created 2026-09-30 18:22, modified 18:25.
