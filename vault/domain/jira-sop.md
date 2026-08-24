---
title: Jira ( SOPs)
source: confluence/TPD/Jira ( SOPs)
migrated: 2026-08-10
updated: 2026-02-04
status: verified
conflicts_with: []
jira: []
tags: [module/field-ops, module/projects-jobs, kind/sop, sprint-planning, inspections, ticket-workflow, compliance, requirements]
entities: [field-ticket, sprint, task, project]
supersedes:
  - confluence/TCG/JIRA ( SOP's ) — TCG-space copy, last updated 2026-04-23, not migrated
  - confluence/~7120204da88543016f4083b9f7669a42b21ef3/(SOP): JIRA — personal-space copy, last updated 2026-04-16, not migrated
verified_because: >
  Part of the TPD SOP set, selected as authoritative because it is the only
  set containing the Development Process SOP. Resolved by content, not recency.
---

## **Standard Operating Procedure (SOP): JIRA**

## **Purpose**

This SOP defines a standardized approach to creating, updating, and managing Jira tickets so work is tracked clearly, ownership is visible, and nothing falls through the cracks during sprints.

## **Audience**

This SOP applies to all team members who work in Jira:

* Developers
* QA Engineers
* PM's
* Scrum Masters
* Team Leads

## **Roles & Responsibilities**

### **Product Manager**

* Create feature and user stories using proper user story format
* Define acceptance criteria and priority
* Ensure business requirements are clear before sprint planning

### **QA Engineer**

* Create bug tickets with:

    * Clear steps to reproduce
    * Expected vs actual results

* Verify fixes and validate acceptance criteria

### **Developer**

* Create technical tasks, implementation tickets, or internal bugs
* Update ticket status and add progress comments
* Raise blockers early if work cannot proceed

### **Scrum Master**

* Create process-related tasks and cross-team blockers
* Ensure Jira hygiene is maintained
* Monitor ticket flow and resolve dependencies

## **Mandatory Ticket Checklist (Definition of Ready)**

Every Jira ticket must include the following before it can move forward:

* Clear and meaningful title
* Detailed description

    * User story format (for features)
    * Bug report format (for issues)

* Acceptance criteria or test steps
* Linked designs or reference documents (if applicable)
* Assigned owner
* Linked Epic
* Start date and due date
* Estimated working hours
* Priority level (Low / Medium / High)

## **Ticket Lifecycle**

All tickets should follow this basic workflow:

**To Do → In Progress → In Review / QA → Done**

* Note : Workflow could be changed according to the needs
* Only the assignee moves a ticket to _In Progress_
* A ticket can move to _Done_ only after:

    * Acceptance criteria are met
    * QA validation is complete

## **Sprint Rules**

* Only tickets that meet the Mandatory Ticket Checklist can be added to a sprint
* Mid-sprint scope changes must be approved by the PM
* Unfinished tickets are reviewed and re-planned in the next sprint

**Compliance**

* Tickets that do not meet the mandatory checklist:

    * Must not be moved into a sprint
    * Must not be marked _In Progress_

* Tickets without updates for more than one working day may be flagged for review

## **Ownership & Accountability**

* The **assignee** is responsible for:

    * Keeping the ticket updated
    * Reporting blockers immediately

* Scrum Master / PM ensures tickets do not remain stuck without action

## **Conclusion**

Following this SOP ensures that all Jira tickets are clear, up-to-date, and properly managed. It helps the team stay organized, track work effectively, and complete sprints on time. Consistent use of this process improves accountability, communication, and overall project delivery.
