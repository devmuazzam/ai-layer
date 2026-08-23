---
title: The Crane Guys ERP Payroll Module - Work-time reconstruction, rounding and hour classification
source: onedrive/OneDrive_1_8-11-2026/The Crane Guys ERP Payroll Module.pdf
migrated: 2026-08-13
updated: 2026-08-05
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/frd, time-tracking, overtime]
entities: [labor-entry, pricing-slice, overtime, double-time]
part_of: payroll/erp-payroll-module-frd/INDEX.md
---

## 7. Work-Time Reconstruction and Rounding

### PR-012 — Time Source Priority

The system must establish a documented source priority for start and end times.

Potential sources include:

1. verified labor-entry start and end times;
2. job-ticket timeline;
3. employee schedule;
4. standard shift start plus reported hours;
5. authorized payroll override.

The source used must be visible in the audit record.

The current Payroll App recognizes that the date portion of some source start/end timestamps may be
unreliable. It anchors the date to WorkDate and uses the time-of-day portion to reconstruct the shift.

### PR-013 — Cross-Midnight Work

When an end time is earlier than the start time, the system should treat the end as occurring on the
following calendar day unless the source information indicates an error.

The system must separately determine:

- the payroll accumulation date;
- the calendar date of each worked segment;
- the applicable day type for each segment;
- the correct holiday, Sunday, or Saturday premium;
- whether daily accumulation continues from the original shift.

The currently implemented Payroll App uses a configurable cross-midnight day-type policy. The ERP should
retain this as an effective-dated configuration rather than hard-coding one behavior.

### PR-014 — Half-Hour Time Reckoning

The L12 agreement states that all time, including overtime, is reckoned in one-half-hour increments.

The ERP must document whether TCG intends to:

- round each start time down and each end time up;
- round the total duration;
- round individual work segments;
- use another approved method.

The existing Payroll App generates 30-minute pricing slices. This provides a useful audit model, but the
exact rounding interpretation should be approved before CodingCops finalizes the ERP calculation.

## 8. L12 Straight Time, Overtime, and Double Time

### PR-015 — Standard Work Window

The L12 agreement defines eight consecutive hours as a day’s work between 6:00 a.m. and 5:00 p.m., with
40 hours Monday through Friday constituting a straight-time week. Work outside regular working hours is
generally overtime, subject to the agreement’s other premium rules.

Required information

- Employee payroll group
- Work date
- Start and end times
- Accumulated daily hours
- Day type
- Applicable shift
- Rest-period status

Trigger

An L12-eligible labor entry is priced.

Processing

For standard weekday work:

- qualifying hours within the regular window are straight time until the daily threshold;
- qualifying hours outside the regular window are overtime;
- hours after the daily overtime threshold are classified according to the daily OT/DT rules;
- only one controlling multiplier is applied to each segment unless a rule expressly requires an
        additional premium.

### PR-016 — Daily Overtime and Double Time

Current L12 configuration:

- First 8 qualifying hours: straight time
- Hours over 8 through 12: 1.5 times
- Hours over 12: 2.0 times

The system must accumulate daily hours across all qualifying labor entries for the employee, not calculate
each labor entry independently.

The ERP must define the ordering of labor entries used for accumulation. Actual start time should be used
when reliable. When it is unavailable, the fallback ordering and warning must be recorded.

### PR-017 — No Pyramiding

The L12 agreement states that overtime is not pyramided.

The system must select the controlling multiplier for each segment.

A recommended priority is:

1. holiday;
2. special Saturday;
3. Sunday;
4. daily double time;
5. outside-window overtime;
6. daily overtime;
7. ordinary Saturday;
8. straight time.

The final priority and any exceptions must be approved as part of the rule matrix.

Additional hourly premiums that become part of the base rate—such as qualifying shift, hazardous-
material, or long-boom premiums—must be added to the base before multiplying when required by the
agreement.
