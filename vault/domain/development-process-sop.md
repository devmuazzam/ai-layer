---
title: Development Process SOP
source: confluence/TPD/Development Process SOP
migrated: 2026-08-10
updated: 2026-02-04
status: verified
conflicts_with: []
jira: []
topics: [engineering-process, scrum-process, inspections, tools-rigging, projects, purchase-orders]
entities: [sprint, project, tool-rigging, purchase-order, field-ticket, task]
supersedes:
  - confluence/TCG/Scrum Standard Operating Procedures (SOPs) — TCG-space copy, last updated 2026-04-23, not migrated
  - confluence/~7120204da88543016f4083b9f7669a42b21ef3/SOP:Full Development Process — personal-space copy, last updated 2026-04-16, not migrated
verified_because: >
  The TPD copy is the only one of the three SOP sets that contains this
  Development Process SOP. Resolved by content, not by recency — the newer
  TCG-space copy is the less complete set.
---

# **SOP: Full Development Process**

This document outlines the complete software development lifecycle used by our team from idea to production. It includes how work is planned, developed, tested, reviewed, deployed, and maintained.

## **Goals**

* Ensure consistent and predictable delivery
* Improve quality, reduce bugs, and minimize rework
* Increase team clarity and accountability
* Enable safe, frequent releases

##  **Overview of Development Stages**

| **Stage** | **Description** |
| --- | --- |
| Planning | Work is defined, estimated, and prioritized |
| Design (optional) | UX and system design are completed |
| Development | Code is written, tested locally |
| Code Review | PR is reviewed by peers |
| Testing | QA verifies functionality in staging |
| Release | Code is deployed to production |
| Monitoring | Health is tracked, bugs reported |

## **1. Planning**

### **Inputs:**

* Feature requests from product or stakeholders
* Bug reports, technical debt items
* Sprint backlog from planning session

### **Activities:**

* Product Manager writes user stories with clear acceptance criteria
* Team estimates complexity (Story Points)
* Stories are prioritized into the next sprint
* Developers clarify questions before work begins

### **Output:**

* Sprint backlog in project management tool (e.g. Jira)

## **2. Design**

If the task requires UI or architecture changes:

* UX Designers create wire-frames/prototypes
* Engineers create architecture diagrams (for large changes)
* Tech Lead and Product / Project Managers signs off on approach

### **Output:**

* Finalised mock ups or diagrams
* Approved solution approach

## **3. Development**

### **Practices:**

* Create feature branch (`feature/xyz`)
* Follow code style guide and naming conventions
* Write clear commit messages
* Ensure code meets Definition of Done:

    * Business logic implemented
    * Unit tests written
    * Feature tested locally
    * Feature flag added if risky

## **4. Code Review**

### **Rules:**

* PR opened against `main` or `develop`
* At least 1 reviewer (ideally 2)
* Automated tests must pass
* No self-merging unless urgent (and communicated)

### **Reviewer Checklist:**

* Code is clean and readable
* No hardcoded secrets
* Tests are included
* Logic is correct and efficient
* Follows team conventions

## **5. QA Testing**

### **Environment:**

* Code deployed to **staging**
* QA runs test cases manually or via automation
* Bug tickets created for anything broken

### **QA Checks:**

* Functionality matches acceptance criteria
* No regressions on related features
* Cross-device or cross-browser checks if needed

## **6. Release to Production**

### **Release Conditions:**

* All QA checks passed
* PO has approved
* Team agrees code is safe to ship

### **Deployment Process:**

* Merged to `main`
* CI/CD pipeline runs
* Feature is released behind a flag if needed
* Production logs monitored post-release

## **7. Monitoring & Maintenance**

### **After Deployment:**

* Engineers monitor key metrics (error rate, latency, usage)
* Any issues logged as bugs
* Rollback plan always available

### **Tools:**

* Monitoring: Datadog, Prometheus, Sentry
* Alerts: Slack/Email/PagerDuty for high-severity incidents

## **Tech Debt & Bug Handling**

* Bugs prioritized in weekly triage
* High-severity issues fixed immediately
* Tech debt logged and reviewed every sprint
* Engineering allocates 10–20% of time for internal improvements

## **Testing Expectations**

| **Type** | **Responsibility** | **Description** |
| --- | --- | --- |
| Unit Tests | Developer | For all new functions/modules |
| Integration Tests | Developer + QA | For workflows across modules |
| Regression Testing | QA | After changes to critical paths |
| Load Testing | DevOps/Backend | On major releases |

## **Communication**

| **Situation** | **Channel** |
| --- | --- |
| Questions/blockers | Standup / Slack |
|  |  |
| Feature clarification | Story comments or tag PO |
| Production issues | Slack channel / Call tech lead |
| Postmortems | Confluence / Shared drive |

### **Development Checklist**

Follow these steps for every feature or bug fix:

1. **Before You Start**

    * Story is written and clear
    * Acceptance criteria are included
    * Design is attached (if needed)
    * Story is estimated and approved for development

2. **While Developing**

    * Create a properly named branch (`feature/login-button`)
    * Write clean, tested code
    * Run the app locally to test your changes
    * Add unit tests if needed

3. **Code Review**

    * Open a pull request with a clear description
    * Get at least 1 code review
    * Fix any review comments
    * Make sure all tests pass (CI/CD ✅)

4. **Testing**

    * Deploy to staging
    * QA tests the feature
    * Fix any bugs found

5. **Release**

    * Merge code to main branch
    * Deploy to production
    * Monitor logs and metrics

6. **After Release**

    * Report any production issues
    * Note anything we should improve
    * Share feedback in the retrospective

### **Conclusion :**

This SOP establishes a clear and consistent software development lifecycle that enables reliable delivery, improved quality, and safe releases. Following this process ensures accountability, reduces risk, and supports continuous improvement across planning, development, testing, and production.
