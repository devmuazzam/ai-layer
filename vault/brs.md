---
title: BRS
source: confluence/TCG/BRS
migrated: 2026-08-10
updated: 2026-06-10
status: unverified
conflicts_with: []
jira: []
tags: [module/field-ops, module/payroll, kind/reference, requirements, wtl, time-tracking, notifications, ticket-workflow, signatures]
entities: [lunch-record, field-ticket, notification, labor-record, deficiency, signature, employee, union-code, downtime, job]
---

> **Migration note, added 2026-08-13 — not part of the source document.**
> Three rules below are marked as needing documentation or validation, and a payroll document
> set migrated on 2026-08-13 (from a OneDrive drop, not Confluence) speaks directly to them:
>
> - **`BRS-LUNCH-005` Lunch Threshold Values** (📄 Needs Supporting Documentation) —
>   [payroll/wtl-charts.md](payroll/wtl-charts.md) gives four thresholds (5:01, 10.5:01,
>   16:01, 21.5:01); the union agreement gives the underlying 5-consecutive-hour rule.
> - **`BRS-LUNCH-002` Multiple Lunch Threshold Support** (✓ Confirmed) — lists **three** known
>   lunches. Payroll models **four**. **These disagree, and the BRS side is marked Confirmed.**
> - **`BRS-PAY-003` Previous Day Rest Validation** (⚠ Needs Client Validation) — the eight-hour
>   rest rule is contract text in
>   [payroll/mcog-l12-mla-2025-2028/01-article-iii-working-rules.md](payroll/mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)
>   and is already implemented in the legacy Payroll App.
>
> This note does **not** resolve those statuses — a payroll document is not a client validation,
> and the two sets were written by different people for different modules. See
> [gaps.md](gaps.md) → *Field-ops lunch capture vs payroll WTL*.

**The BRS is not a place to design future behavior.**

The BRS is a place to **capture discovered business rules**, identify **gaps**, and record **unknowns that require validation**.

# **TCG Mobile – Field Operations BRS**

## **Version**

```
Version: 0.1
Status: Working Draft – Rule Discovery & Consolidation
```

---

# **Sources**

```
Field Operations FRD v1
Meeting Transcripts
Consolidated MOMs
Product Analysis Sessions
```

---

# **Status Definitions**

| **Status** | **Meaning** |
| --- | --- |
| ✓ Confirmed | Explicitly discussed and supported by evidence |
| ⚠ Needs Client Validation | Rule exists but parameters are unconfirmed |
| 📄 Needs Supporting Documentation | Rule likely documented elsewhere |
| ❓ Needs Business Decision | No agreement identified |

---

# **Section 1 – Ticket Validation Rules (BRS-TVL)**

---

## **BRS-TVL-001**

**Rule Name**

Required Step Completion

**Description**

Mandatory workflow steps must be completed before ticket submission.

**Outcome**

Ticket submission blocked until required items are resolved.

**Status**

✓ Confirmed

---

## **BRS-TVL-002**

**Rule Name**

Missing Item Visibility

**Description**

Users must be informed of missing requirements.

**Outcome**

System displays unresolved items and allows navigation back.

**Status**

✓ Confirmed

---

## **BRS-TVL-003**

**Rule Name**

Incomplete Ticket Persistence

**Description**

Incomplete tickets remain visible until resolved.

**Outcome**

Tickets remain Draft/Incomplete.

**Status**

✓ Confirmed

---

## **BRS-TVL-004**

**Rule Name**

Previous Ticket Enforcement

**Description**

Unresolved tickets may restrict future ticket processing.

**Possible Outcomes**

```
Warning
Soft Block
Hard Block
```

**Status**

❓ Needs Business Decision

---

# **Section 2 – Time Processing Rules (BRS-TIME)**

---

## **BRS-TIME-001**

**Rule Name**

Exact Timestamp Preservation

**Description**

System stores actual event timestamps.

**Applies To**

```
Leave Yard
Arrive Job
Start Work
End Work
Leave Job
Arrive Yard
Lunch Events
```

**Status**

✓ Confirmed

---

## **BRS-TIME-002**

**Rule Name**

Rounded Payroll Timestamp

**Description**

Payroll-adjusted timestamps shall be maintained separately from actual timestamps.

**Status**

✓ Confirmed

---

## **BRS-TIME-003**

**Rule Name**

Manual Time Adjustments

**Description**

Manual time edits require justification.

**Required Audit Data**

```
Original Value
Updated Value
User
Timestamp
Reason
```

**Status**

✓ Confirmed

---

## **BRS-TIME-004**

**Rule Name**

Union Rounding Rules

**Description**

Time rounding follows union/company rules.

**Known Information**

```
30-minute increments
Employee-favorable rounding
```

**Status**

⚠ Needs Client Validation

---

# **Section 3 – Lunch Rules (BRS-LUNCH)**

---

## **BRS-LUNCH-001**

**Rule Name**

Lunch Monitoring

**Description**

System monitors lunch compliance.

**Status**

✓ Confirmed

---

## **BRS-LUNCH-002**

**Rule Name**

Multiple Lunch Threshold Support

**Description**

System supports multiple lunch events.

**Known Lunches**

```
First Lunch
Second Lunch
Third Lunch
```

**Status**

✓ Confirmed

---

## **BRS-LUNCH-003**

**Rule Name**

Lunch Notification Timing

**Description**

Users receive lunch reminders before penalties occur.

**Status**

⚠ Needs Client Validation

---

## **BRS-LUNCH-004**

**Rule Name**

Work Through Lunch Authorization

**Description**

Missed lunches trigger authorization requirements.

**Known Outcomes**

```
Comment Required
Signature May Be Required
Payroll Indicator Generated
```

**Status**

✓ Confirmed

---

## **BRS-LUNCH-005**

**Rule Name**

Lunch Threshold Values

**Description**

Threshold durations governing lunch obligations.

**Status**

📄 Needs Supporting Documentation

---

# **Section 4 – Payroll Rules (BRS-PAY)**

---

## **BRS-PAY-001**

**Rule Name**

Labor Transparency

**Description**

Employees can review payroll-related labor history.

**Status**

✓ Confirmed

---

## **BRS-PAY-002**

**Rule Name**

Payroll Modification Visibility

**Description**

Post-submission payroll edits remain visible to employees.

**Status**

✓ Confirmed

---

## **BRS-PAY-003**

**Rule Name**

Previous Day Rest Validation

**Description**

Previous-day work influences payroll treatment.

**Status**

⚠ Needs Client Validation

---

## **Known Mentions**

```
Eight-hour rest periods
Double-time implications
Previous-day shift consideration
```

---

## **BRS-PAY-004**

**Rule Name**

Operator/Oiler Separation

**Description**

Payroll records remain individually attributable.

**Status**

✓ Confirmed

---

# **Section 5 – Boom & Modifier Rules (BRS-BOOM)**

---

## **BRS-BOOM-001**

**Rule Name**

Boom Modifier Eligibility

**Description**

Boom modifiers depend on role and configuration.

**Status**

✓ Confirmed

---

## **BRS-BOOM-002**

**Rule Name**

Planned vs Actual Configuration

**Description**

Differences between planned and actual setups require tracking.

**Status**

✓ Confirmed

---

## **BRS-BOOM-003**

**Rule Name**

Boom Rate Matrix

**Description**

Role-specific modifier values.

**Status**

📄 Needs Supporting Documentation

---

## **BRS-BOOM-004**

**Rule Name**

Boom Eligible Activities

**Description**

Activities eligible for boom compensation.

**Status**

⚠ Needs Client Validation

---

# **Section 6 – Escalation Rules (BRS-ESC)**

---

## **BRS-ESC-001**

**Rule Name**

Blocking Deficiencies

**Description**

Blocking deficiencies require urgent escalation.

**Status**

✓ Confirmed

---

## **BRS-ESC-002**

**Rule Name**

Downtime Escalation

**Description**

Certain downtime classifications trigger escalation.

**Status**

⚠ Needs Client Validation

---

## **BRS-ESC-003**

**Rule Name**

Safety Escalations

**Description**

Safety deficiencies receive elevated treatment.

**Status**

✓ Confirmed

---

# **Section 7 – Notification Rules (BRS-NOTIF)**

---

## **BRS-NOTIF-001**

Ticket Assignment Notifications

**Status**

✓ Confirmed

---

## **BRS-NOTIF-002**

Incomplete Ticket Reminders

**Status**

✓ Confirmed

---

## **BRS-NOTIF-003**

Certification Expiry Notifications

**Status**

✓ Confirmed

---

## **BRS-NOTIF-004**

Lunch Notifications

**Status**

⚠ Needs Client Validation

---

## **BRS-NOTIF-005**

Escalation Notifications

**Status**

✓ Confirmed

---

## **BRS-NOTIF-006**

Task Notifications

**Status**

✓ Confirmed

---

# **Section 8 – Integration Rules (BRS-INT)**

---

## **BRS-INT-001**

GPS Validation

**Description**

GPS may support validation activities.

**Status**

⚠ Needs Client Validation

---

## **BRS-INT-002**

Samsara Reconciliation

**Description**

Samsara data may support operational verification.

**Status**

📄 Needs Supporting Documentation

---

## **BRS-INT-003**

ADP Payroll Integration

**Description**

ADP influences payroll outcomes.

**Status**

📄 Needs Supporting Documentation

---

## **BRS-INT-004**

Payroll Export Mapping

**Description**

Labor data requires export mapping.

**Status**

📄 Needs Supporting Documentation

---

# **Section 9 – Audit Rules (BRS-AUD)**

---

## **BRS-AUD-001**

Manual Time Edits

**Status**

✓ Confirmed

---

## **BRS-AUD-002**

Ticket Lifecycle Audit Trail

**Status**

✓ Confirmed

---

## **BRS-AUD-003**

Signature Metadata Retention

**Status**

✓ Confirmed

---

## **BRS-AUD-004**

Labor Modification Tracking

**Status**

✓ Confirmed

---

## **BRS-AUD-005**

Deficiency History Tracking

**Status**

✓ Confirmed

---

# **Section 10 – Retention Rules (BRS-RET)**

---

## **BRS-RET-001**

DOT Inspection Retention

**Known Information**

```
Three-year retention requirement mentioned.
```

**Status**

⚠ Needs Client Validation

---

## **BRS-RET-002**

Ticket Retention

**Status**

📄 Needs Supporting Documentation

---

## **BRS-RET-003**

Signature Retention

**Status**

📄 Needs Supporting Documentation

---

## **BRS-RET-004**

Labor History Retention

**Status**

📄 Needs Supporting Documentation

---

# **Section 11 – Open Decision Register**

| **ID** | **Topic** | **Status** |
| --- | --- | --- |
| OD-001 | Previous ticket enforcement behavior | ❓ Decision Needed |
| OD-002 | Exact lunch thresholds | 📄 Need Documentation |
| OD-003 | Second lunch requirements | 📄 Need Documentation |
| OD-004 | Third lunch requirements | 📄 Need Documentation |
| OD-005 | Union rounding matrix | 📄 Need Documentation |
| OD-006 | Boom modifier matrix | 📄 Need Documentation |
| OD-007 | Boom eligible activities | ⚠ Validate |
| OD-008 | Double-time thresholds | 📄 Need Documentation |
| OD-009 | Previous-day rest requirements | ⚠ Validate |
| OD-010 | Samsara reconciliation rules | 📄 Need Documentation |
| OD-011 | ADP export mappings | 📄 Need Documentation |
| OD-012 | GPS enforcement behavior | ❓ Decision Needed |
| OD-013 | Downtime escalation recipients | ⚠ Validate |
| OD-014 | Ticket retention periods | 📄 Need Documentation |
| OD-015 | Signature retention periods | 📄 Need Documentation |
| OD-016 | Labor retention periods | 📄 Need Documentation |

---

# **BRS v0.1 Outcome**

```
Confirmed Rules:
28

Needs Validation:
7

Needs Supporting Documentation:
12

Needs Business Decisions:
3
```
