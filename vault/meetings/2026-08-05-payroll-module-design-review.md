---
title: TCG – Meeting Minutes (5 August 2026)
source: user-supplied/meeting-minutes
migrated: 2026-08-13
updated: 2026-08-05
status: unverified
conflicts_with: []
jira: []
topics: [payroll, erp-payroll, adp-export, payroll-approval, meeting-minutes, shift-differential]
entities: [adp-code, payroll-rule, payroll-dashboard, flagged-exception, work-ticket, lattice-crane, shift-premium]
meeting_date: 2026-08-05
---

# TCG – Meeting Minutes, 5 August 2026

**Payroll Management module design review.** CC presented the proposed module; TCG responded
with requirements and corrections.

> **This is forward-looking, unlike the sprint plans in this folder.** The vault index warns
> that `meetings/` is retrospective — that caveat applies to the migrated Confluence sprint
> plans, **not** to this file. These are client meeting minutes carrying live commitments and
> named action items. Treat the action items as outstanding until someone confirms otherwise.

## Discussion points

- TCG team explained that several existing ADP payroll codes were updated.
- Approximately **16 new ADP payroll codes** were introduced to support more granular payroll
  data during ADP imports.
- CC team presented the proposed Payroll Management module design and walked through the overall
  payroll processing workflow.
- Discussed introducing a dedicated **Payroll Rules Configuration module** to centrally manage
  payroll calculation rules.
- Reviewed the proposed **Payroll Management Dashboard**, which will display weekly payroll
  periods along with their processing status.
- Discussed the **Employee Payroll Summary**, including a weekly view of all employees included
  in the selected payroll period.
- Discussed providing the ability to open an individual employee's payroll record to review
  detailed weekly payroll calculations.
- TCG team requested an **automatic reminder mechanism** for payroll items awaiting a user's
  response or action.
- Discussed the proposed **payroll approval workflow**, including the users involved in the
  approval process.
- Discussed incorporating the revised payroll calculation logic into the proposed payroll
  solution once finalized.
- Agreed to enhance the **Flagged Exceptions** workflow by retaining the option to send issues
  to the Crane Supervisor and adding an **Edit/Override** option for authorized payroll users.
- TCG team requested that the Payroll module **display the status of the associated work
  ticket**, including incomplete tickets, so payroll staff can identify outstanding submissions
  and follow up with workers before payroll processing.
- TCG team requested the ability to **filter payroll records by employee type** (e.g. employee
  role/category).
- **Melissa** requested a filter to display payroll records that have **not yet been submitted
  to ADP**, making it easier to identify outstanding payroll items.
- Discussed adding a **Ticket Sanitization** feature to allow authorized payroll users to edit
  ticket details directly from the Payroll module before payroll is finalized.
- **Brian** highlighted that the method for identifying **Lattice Crane** work requires further
  discussion with business stakeholders (e.g. Kyle and Joe) to determine whether it can be
  identified automatically or must be entered manually.
- Discussed the payroll rules for **Second Shift and Third Shift** work, including union-based
  shift differentials, additional compensation, notification requirements, and how these shift
  types affect employee base pay calculations.

## Action items

| Owner | Action |
| --- | --- |
| TCG Team | Share the updated and newly added ADP payroll codes with the CC team for incorporation into the Payroll module. |
| Brian (TCG) | Share the revised payroll calculation logic to enable the CC team to update the payroll rules and implementation accordingly. |
| TCG Team | Prepare and share comprehensive documentation covering all payroll calculation rules and business logic. |
| TCG Team | Share Corrina's existing **Value Engineering / Payroll Workflow** documentation. |
| CC Team | Review the Value Engineering workflow once received and validate the proposed Payroll module against the documented business process. |

## How this lands against the vault

Read with [payroll/INDEX.md](../payroll/INDEX.md). Several points here are the live edge of
things the payroll documents leave open:

- **The ~16 new ADP codes are not in the vault.** [payroll/adp-hour-earning-codes.md](../payroll/adp-hour-earning-codes.md)
  is a 24-code export dated 2026-06-04 and already known to be incomplete;
  [payroll/adp-bucket-crosswalk.md](../payroll/adp-bucket-crosswalk.md) decision **D-001** asks
  for exactly this re-export. The action item on TCG is the fix for D-001.
- **"Revised payroll calculation logic" (Brian) supersedes nothing yet.** Until it arrives, the
  rule catalog and the 68-rule matrix stand as written. Do not assume a rule has changed.
- **Lattice Crane identification** — the ADP crosswalk already carries `LPR/LPO/LPD/LPT` and
  `LOR/LOO/LOD/LOT` codes driven by `LATT_OPER` / `LATT_OILER` comment tokens, i.e. manual entry
  today. Brian's question is whether that can become automatic. Unresolved.
- **Second/Third Shift rules** are contract text in
  [payroll/mcog-l12-mla-2025-2028/01](../payroll/mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)
  (7 worked/8 paid +$3.00; 6½ worked/8 paid +$4.00; premium becomes the base rate for the
  shift; 3+ consecutive days and advance Union notification required). The **notification
  requirement has no data source** — flagged as `PR-036`/`PR-037` "Confirm union-notification
  data" in [payroll/codingcops-rule-matrix.md](../payroll/codingcops-rule-matrix.md).
- **Work-ticket status in the Payroll module** is a new requirement — it is not in the ERP
  requirements document, which covers ticket expectation warnings but not surfacing incomplete
  tickets to payroll staff for follow-up.
- **Ticket Sanitization** (payroll users editing ticket details) is also new, and sits awkwardly
  against the FRD's *No unexplained overwriting* design principle. Worth an explicit decision.
