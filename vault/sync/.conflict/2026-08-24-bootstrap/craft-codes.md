---
run: 2026-08-24-bootstrap
tier: CONFLICT
reason: new page on a topic the vault already covers (§4.3)
pageId: "151388161"
page_title: Craft codes
page_lastModified: 2026-08-20
page_size: ~2.5 KB
vault_overlap:
  - payroll/codingcops-rule-matrix.md          # section B — Payroll Group and Rate Determination
  - payroll/erp-payroll-module-frd/03-payroll-groups-and-rate-determination.md
  - payroll/foreman-and-military-premiums.md   # craft-modifier premiums
  - payroll/2026-08-20-payroll-rules-meeting-notes.md  # craft-code rate overrides — SAME DAY as this page
  - decisions/2026-06-30-adp-erp-employee-data-ownership.md  # craft & craft modifier are ERP-owned
staged: 2026-08-24
---

# New Confluence page: "Craft codes" — payroll topic, not in vault

Created/last edited **2026-08-20** — the same day as the payroll-rules SME discussion
recorded in `payroll/2026-08-20-payroll-rules-meeting-notes.md`. Likely the write-up of the
same conversation; nobody has confirmed that.

## Why this is CONFLICT tier, not just "new"

1. **It introduces a THIRD payroll requirement-id scheme: `PAY-CC-##`.** The vault already
   documents two independent `PR-###` numberings (FRD vs rule matrix) as a standing
   citation hazard. Do not cite bare `PAY-CC-##` ids; always cite this page.
2. **PAY-CC-03 (employee-specific rate above craft rate) overlaps the "base-rate override"
   topic** in the rule matrix and the 2026-08-20 meeting notes; whether it agrees with them
   has not been adjudicated.
3. The API already has an `employee-craft-codes` usecase module — the codebase leg exists in
   part. Nothing here has been checked against it.

## Page content (staged copy, converted, U+200C stripped)

### Epic: Payroll Rate & Craft Code Configuration

#### PAY-CC-01 — Manage Craft Codes and Base Rates

**As a** Payroll Administrator **I want to** configure craft codes and their base rates
**So that** employee payroll can use the correct contracted rate.

**Acceptance Criteria**

* The system allows a craft code to be configured with its identifier and name.
* A craft code can be marked **active/inactive** rather than deleted.
* Craft codes include the applicable union classification/rule classification.
* Craft code rates can have an effective date.
* The employee's assigned craft code determines their base payroll rate.
* Different craft groups can have different rates.

#### PAY-CC-02 — Assign Craft Codes to Employees

**As a** Payroll Administrator **I want to** assign craft codes to employees
**So that** each employee's payroll uses their applicable base rate.

**Acceptance Criteria**

* A craft code can be assigned to an employee.
* An employee can have a primary craft code or secondary one
* The employee's craft code and rate are available to payroll calculations.
* Employees on the same job can have different craft codes and pay rates.

#### PAY-CC-03 — Support Employee-Specific Rate Adjustments

**As a** Payroll Administrator **I want to** configure an additional rate for an individual
employee **So that** employees with a special rate agreement can be paid correctly without
changing the standard craft-code rate.

**Acceptance Criteria**

* The system allows an employee-specific rate adjustment above the default craft-code rate.
* The adjustment does not change the standard craft-code rate.
* The adjustment applies across the employee's applicable hours.
* The standard craft-code rate remains available as the default rate
