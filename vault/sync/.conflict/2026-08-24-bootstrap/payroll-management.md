---
run: 2026-08-24-bootstrap
tier: CONFLICT
reason: new page on a topic the vault already covers (§4.3)
pageId: "150110210"
page_title: Payroll management
page_lastModified: 2026-08-20
page_size: ~7 KB
vault_overlap:
  - payroll/erp-payroll-module-frd/09-data-quality-ledger-and-review.md
  - payroll/erp-payroll-module-frd/10-approval-close-export-and-adjustments.md
  - payroll/codingcops-rule-matrix.md              # section G — Audit, Review, Approval, and Export
  - payroll/adp-read-write-boundary-2026-08-18.md  # what can actually be written to ADP
staged: 2026-08-24
---

# New Confluence page: "Payroll management" — weekly payroll workflow, not in vault

Created/last edited **2026-08-20**. An EPIC with four user stories covering the weekly
payroll cycle: review week → employee detail → exceptions/send-back → submit to ADP.

## Why this is CONFLICT tier, not just "new"

1. **Its ADP submission model must be read against
   `adp-read-write-boundary-2026-08-18.md`.** The page assumes payroll entries are
   "submitted to ADP individually or in bulk" with API status tracking. The vault's
   researched boundary says writing payroll output is **Marketplace-partner-gated**, with
   `pay-data-input.modify` as the constrained path. Whether this page's US-04 is achievable
   as written is exactly the kind of question the boundary document exists to answer —
   unadjudicated.
2. **Mixed id schemes on one page:** `US-01…US-03`, then `PAY-WP-04`. Fourth payroll
   numbering scheme in the record. Cite the page, never bare ids.
3. **Overlaps FRD parts 09–10 and rule-matrix section G** (review, approval, export) without
   referencing either — same failure mode as the two mob-demob pages.
4. Internal numbering defect: US-02's acceptance criteria jump 9 → 11.

## Page content (staged copy, converted, U+200C stripped)

# EPIC — Payroll Management

## Overview

The **Payroll Management module** manages the weekly payroll process from reviewing the
completed payroll week through employee-level payroll calculation, exception resolution,
approval, and submission to ADP.

The module allows Payroll users to:

* Open and review the applicable payroll week.
* Review weekly payroll KPIs, totals, exceptions, approvals, and ADP status.
* Review individual employee payroll calculations and ticket-level details.
* Identify **Clean**, **Flagged**, **Pending**, and **Sent Back** entries.
* Send payroll entries back to the Worker or Crane Superintendent for correction/review.
* Allow applicable Payroll and Crane Superintendent users to edit, override, sanitize, or approve entries.
* Track returned entries and reminders.
* Identify employees who are missing an ADP file.
* Review payroll entries that are ready to be sent to ADP.
* Submit eligible payroll entries to ADP individually or in bulk.
* Track the payroll week and employee payroll through the applicable status lifecycle.
* Automatically update employee payroll information when payroll reaches the Paid status.

# US-01 — Access & Review Weekly Payroll

**As a** Payroll User **I want to** access and review a payroll week **so that** I can see
the week's payroll status, payroll information, exceptions, and items requiring action.

### Acceptance Criteria

1. When the user opens Weekly Payroll, the previous week's payroll is opened for processing/review.
2. The Weekly Payroll overview provides a calendar/weekly view showing previous payroll weeks and their statuses.
3. The weekly overview displays the applicable week-level statuses: In Progress, Needs Processing, Submitted to ADP, Closed.
4. The current week is displayed as **In Progress** and is not submitted to ADP until the week has ended.
5. A week ready for processing is displayed as **Needs Processing** and provides the **Process Now / Process the Week** action.
6. The weekly overview displays: Total Submitted Tickets, Total Hours, Total Payable Amount, Exception, Approved Entries, Utilisation, Submission Date, API Submission Status, Checks Status.
7. The Weekly Payroll dashboard displays the discussed KPIs: Total Employees Pending Review; Flagged Entries; Sent Back Entries; Approved Entries; Entries with Notes Missing; Employees Missing ADP File / Not Onboarded; ADP-related status/information; Average Utilization per Employee.
8. User can select **Show More** to view previous payroll weeks.
9. User can filter and sort the employee payroll entries.
10. User can filter employees by employee type.
11. The Weekly Payroll dashboard automatically updates when a new entry/data point is triggered.

# US-02 — Review Employee Payroll Details

**As a** Payroll User **I want to** open an employee's payroll details for the selected week
**so that** I can review how the employee's payroll has been calculated and identify entries
requiring attention.

### Acceptance Criteria

1. User can select an employee from Weekly Payroll and open the employee's payroll details/profile.
2. The employee payroll view displays the employee's weekly calculation and hours breakdown.
3. Each ticket/payroll entry displays the applicable payroll information, including: Actual Hours, Payable Hours, Standard Rate, Double Time, Holiday 2X/3X where applicable, Adjustments where applicable.
4. Each payroll entry displays either **Clean** or **Flagged** status.
5. A Clean status indicates that no manual approval is required and no exception has been identified by the configured rules.
6. When an entry is Flagged, the system displays the applicable rule exception/reason.
7. User can open the underlying job/ticket directly from the payroll entry using the ticket link.
8. User can select another employee from the payroll view without leaving the weekly payroll workflow.
9. The calculation details section displays: Payable Breakdown, Rate Resolution, Pricing Slice, Applied Rules, Audit Trail, System Changes, User/Manual Changes.
11. Payroll entries can display applicable tags, such as **Holiday Pay**, where applicable.   <!-- upstream numbering jumps 9 → 11 -->
12. The employee payroll profile displays the employee-level payroll status, including: Submitted, Processing, Received, Paid.
13. When payroll reaches **Paid**, the applicable employee payroll information is automatically updated.
14. Incomplete ticket management remains within the applicable ticket/Daily Progress workflow rather than being treated as an employee-profile function.

# US-03 — Review & Resolve Payroll Exceptions

**As a** Payroll User **I want to** review and resolve flagged, incomplete, or returned
payroll entries **so that** the entries can be corrected, reviewed, or approved before
payroll submission.

### Acceptance Criteria

1. User can see why a payroll entry is flagged and the rule exception applied.
2. User can select **Send Back** for an entry requiring correction/review.
3. When sending an entry back, the user can select: Crane Superintendent, Worker.
4. If Worker is selected: Worker receives a mobile notification; the notification contains the reason for the send-back; Worker can edit/add information to the specified ticket; the Worker can only edit the ticket through this workflow after it has been sent back.
5. If Crane Superintendent is selected, the entry appears on the Crane Superintendent's dashboard for review.
6. Crane Superintendent can **Approve** or **Override** applicable flagged entries.
7. When the Crane Superintendent approves a flagged entry, its status changes to **Clean/Approved**.
8. When an entry is sent back to the Crane Superintendent, the system records the send-back status and time.
9. The system supports an automatic reminder when a returned item has not received a response for **3 hours**.
10. The reminder/communication workflow can be directed to the Worker and/or Crane Superintendent.
11. Incomplete tickets are visible with their ticket status so Payroll can identify entries requiring completion.
12. Payroll can use the send-back workflow to request completion/correction of an incomplete ticket.
13. Payroll has the applicable **Edit/Override** capability for flagged entries.
14. User can select multiple entries when using the send-back workflow.
15. Ticket notes entered on an entry are automatically identified/flagged for review.
16. Payroll can sanitize/edit manually entered ticket information/comments where required.
17. Crane Superintendent has the same applicable ticket-sanitization capability.

# PAY-WP-04 — Review & Submit Payroll to ADP

**As a** Payroll User **I want to** review payroll entries that are ready or pending for ADP
and submit eligible payroll **so that** approved payroll can proceed through the ADP process.

### Acceptance Criteria

1. Weekly Payroll displays the number of entries **Ready to Send to ADP**.
2. User can select the **Ready to Send to ADP** section to view eligible entries.
3. User can see entries that are still pending after being sent back to the Worker or Crane Superintendent.
4. The Weekly Payroll view separately identifies **Sent Back** entries.
5. User can filter payroll entries to identify entries that have **not yet been sent to ADP**.
6. User can submit eligible payroll entries to ADP: individually, in bulk.
7. The system displays the employee's applicable ADP/payroll information, including: ADP File, Actual Payable Amount, Total Payable Amount, Approval Status.
8. The system records/displays the **ADP Submission Date**.
9. The system displays the **API Submission Status**, including whether the submission was accepted.
10. The system displays the applicable **Checks Status**.
11. If an item is submitted to ADP without the required approval, the system identifies it as an **exception**.
12. The payroll week and employee payroll information reflect the applicable status as the payroll progresses through the ADP process.
