---
project: TCG
module: Employees
feature: Employee Profile Feature
status: staged
composed: 2026-09-15
composer_run: manual-codex-2026-09-15
source_count: 0
promoted_sha256:
---

> STAGED — NOT VAULT CONTENT. This is the ticket's ask, kept beside `intent.md` so
> `spec.md` can cite it by section (`kind: jira`, `[UNVERIFIED]`). `source_count: 0` — it
> cites nothing itself. It is not promoted into `.ai/vault/`.

# Employee Profile Feature

## Purpose

The Employee Profile is the central record for each employee. It stores the employee's basic information, department, operational role, employment status, payroll profile, managed assets, emergency contact details, and supporting attachments/certifications.

The Employee Profile owns employee-specific setup. It references system-wide configuration such as departments, roles, craft codes, craft modifiers, payroll rules, subsistence rules, salary rules, and payroll export mappings.

This document focuses on the employee record and the employee-side payroll setup. It does not replace the system-wide payroll configuration documents.

## Main Employee Profile Sections

### 1. Basic Information

Basic information identifies the employee and supports HR, operations, payroll, and system access.

Recommended fields:

- Employee ID
- First name
- Middle name
- Last name
- Work cell phone
- Personal cell phone
- Home phone
- Email
- Date of birth
- SSN, masked and permission controlled
- Department
- Operational role
- Employee status
- Hiring date
- Joining date
- Address
- Emergency contact

Employee ID may be manually entered or auto-generated.

SSN should be optional or dummy-only in UAT/demo tenants.

### 2. Department and Operational Role

Each employee should belong to a department and have an operational role.

Examples of departments:

- Dispatch
- Sales
- Field Operations
- Payroll
- Accounting
- Maintenance
- Yard
- Admin

Examples of operational roles:

- Operator
- Oiler
- Rigger
- Driver
- Mechanic
- Dispatcher
- Salesperson
- Payroll Manager
- Accounting User

Department and operational role are employee/org configuration, not payroll configuration.

### 3. Employee Status

Employee status defines whether the employee is active in the business.

Recommended statuses:

- Active
- Inactive
- Terminated
- On leave
- Pending onboarding

Employee status is different from payroll status.

Example:

```text
Employee status = Active
Payroll status = Payroll eligible
```

or:

```text
Employee status = Active
Payroll status = Hold payroll
```

### 4. Payroll Profile

Each employee should have a Payroll Profile section inside the Employee Profile.

The fields shown in the Payroll Profile depend on the employee's compensation type.

Recommended compensation types:

- Craft-Based Hourly
- Hourly Non-Craft
- Salaried

Craft-Based Hourly employees are employees whose payroll is driven by craft code, job ticket hours, role worked, craft modifiers, boom pay, subsistence, and payroll rules.

Salaried employees are employees whose payroll is driven by salary amount and salary frequency. They may still be union employees, but craft codes and craft modifiers do not apply unless the business defines a special exception.

### 5. Craft-Based Hourly Payroll Profile

Recommended fields:

- ADP file number / payroll provider identifier
- Primary craft code
- Secondary craft codes
- Over-scale / additional hourly bump
- Payroll status
- Custom payroll exceptions
- Custom subsistence/on-call arrangement, if applicable

Craft-based hourly payroll calculation references:

- Craft codes
- Craft modifiers
- Payroll rules
- Subsistence rules
- Job ticket data
- Asset/crane payroll configuration
- Payroll export mapping

### 6. Salaried Payroll Profile

Recommended fields:

- ADP file number / payroll provider identifier
- Salary amount
- Salary frequency
- Effective start date
- Effective end date, if applicable
- Payroll status
- Union status, if applicable
- Salary earning code / payroll export mapping
- Custom payroll exceptions, if applicable

Salary frequency examples:

- Weekly
- Biweekly
- Monthly

Craft codes, craft modifiers, boom pay, and subsistence should not be required for salaried employees.

### 7. Hourly Non-Craft Payroll Profile

Recommended fields:

- ADP file number / payroll provider identifier
- Hourly rate
- Effective start date
- Effective end date, if applicable
- Payroll status
- Union status, if applicable
- Payroll export mapping
- Custom payroll exceptions, if applicable

Hourly Non-Craft is for hourly employees whose payroll is not driven by craft code or boom/craft modifiers.

### 8. Primary Craft Code Eligibility

Each craft code should have a craft role/category.

Example:

```text
Craft Code: L12-OILER
Craft Role/Category: Oiler
```

For Craft-Based Hourly employees, the employee's primary craft code should match the employee's operational role.

Example:

```text
Employee Operational Role: Oiler
Eligible Primary Craft Codes: craft codes where Craft Role/Category = Oiler
```

This prevents an Oiler employee from accidentally receiving an Operator primary craft code.

### 9. Secondary Craft Codes

Secondary craft codes may differ from the employee's assigned operational role.

Example:

```text
Employee Operational Role: Oiler
Primary Craft Code: Oiler
Secondary Craft Code: Operator
```

This should only be allowed when the employee is qualified/approved to work that higher-paid role.

Secondary craft codes should not reduce the employee's pay below their primary craft code rate.

### 10. Over-Scale / Additional Hourly Bump

Employee-specific over-scale should live on the employee payroll profile.

Preferred model:

```text
Base rate = craft code effective rate
Employee over-scale = optional additional amount
Final employee pay floor = craft rate + over-scale
```

Do not modify shared craft code rates for one employee's special pay arrangement.

### 11. Union Status

Union status cannot be derived only from craft code because salaried employees may also be union.

Recommended model:

- For Craft-Based Hourly employees, union status can be derived from the selected craft code.
- For Salaried or Hourly Non-Craft employees, union status should be selected directly or derived from a separate payroll classification rule.

The resolved union status should be visible on the Payroll Profile.

### 12. Managed Assets

If employees are assigned assets, the Employee Profile may include managed or assigned assets.

Examples:

- Assigned truck
- Assigned crane
- Assigned tools
- Assigned phone/tablet
- Assigned yard equipment

This is operational tracking, not payroll setup, although asset usage may affect job ticket/payroll calculation later.

### 13. Attachments and Certifications

For now, certifications can be stored as attachments.

Attachment categories may include:

- Training records
- Performance reports
- Classification documents
- Drug test reports
- Certificates

Later, certifications should become structured records with:

- Certificate type
- Issuing agency
- Issue date
- Expiry date
- Status
- Attachment
- Dispatch/payroll impact, if any

## Related System-Wide Sub-Docs

### A. Departments and Roles

Defines departments and operational roles used by Employee Profile.

Owns:

- Department list
- Operational role list
- Role-to-department mapping
- Role permissions, if applicable

Used by:

- Employee Profile
- Access Control
- Dispatch
- Payroll Profile
- Job Tickets

### B. Compensation Types

Defines which payroll profile path applies to an employee.

Owns:

- Craft-Based Hourly
- Hourly Non-Craft
- Salaried

Used by:

- Employee Profile
- Payroll Profile
- Payroll Review
- Payroll Export

### C. Craft Codes

Defines payroll classifications and standard base rates for Craft-Based Hourly employees.

Owns:

- Craft code
- Craft code name
- Craft role/category
- Union/non-union classification
- Effective start date
- Effective end date
- Standard hourly rate
- Active/inactive status

Used by:

- Employee Payroll Profile
- Weekly Payroll Processing
- Job Ticket Payroll Calculation
- Certified Payroll Reporting

Eligibility rule:

```text
For Craft-Based Hourly employees, primary craft code must match employee operational role/category.
Secondary craft codes may differ if approved and qualified.
```

### D. Craft Modifiers

Defines payroll add-ons such as boom pay.

Owns:

- Modifier code
- Modifier name
- Modifier type
- Amount
- Boom range or condition
- Role applicability
- Effective dates
- Active/inactive status

Used by:

- Job Tickets
- Asset/Crane Configuration
- Payroll Calculation

Craft modifiers should be separate from craft codes.

### E. Payroll Rules

Defines payroll calculation rules.

Owns:

- Straight time
- Overtime
- Double time
- Triple time
- Holiday rules
- Meal penalty
- Worked-through-lunch rules
- Rest period rules
- Shift premium rules
- Premium pay rules

Used by:

- Weekly Payroll Processing
- Payroll Review
- Payroll Calculation Ledger
- Payroll Export

### F. Subsistence Rules

Defines job/location-based subsistence behavior.

Owns:

- Short subsistence rule
- Long subsistence rule
- Distance thresholds
- Daily amount
- Holdover behavior
- Presence requirement
- Employee custom exception handling

Used by:

- Employee Payroll Profile
- Job Setup
- Payroll Calculation

Subsistence should not be attached mainly to craft code. It should be driven by job location, distance, and payroll rules.

### G. Salary Rules

Defines salary-specific payroll behavior.

Owns:

- Salary frequency options
- Salary effective dates
- Salary earning codes
- Salary export mapping
- Salary exception handling

Used by:

- Salaried Employee Payroll Profile
- Payroll Review
- Payroll Export

### H. ADP / Payroll Export Mapping

Defines how approved payroll results export to payroll provider systems.

Owns:

- ADP company code
- ADP file number mapping
- Earning code mapping
- Hour bucket mapping
- Temporary rate mapping, if applicable
- Export validation rules

Used by:

- Payroll Review
- Payroll Export
- Payroll Calculation Ledger

### I. Asset / Crane Payroll Configuration

Defines which payroll modifiers are valid for specific cranes/assets.

Owns:

- Crane/unit
- Boom configuration
- Maximum boom length
- Allowed boom modifier ranges
- Operator/oiler applicability
- Valid payroll modifiers

Used by:

- Job Tickets
- Dispatch
- Payroll Calculation

## Final Model

```text
Employee Profile
- Basic information
- Department
- Operational role
- Employee status
- Payroll profile
  - Craft-Based Hourly profile, OR
  - Hourly Non-Craft profile, OR
  - Salaried profile
- Managed assets
- Emergency contact
- Attachments/certifications

System-Wide Employee/Org Config
- Departments
- Operational roles
- Employee statuses
- Compensation types
- Attachment categories

System-Wide Payroll Config
- Craft Codes
- Craft Modifiers
- Payroll Rules
- Subsistence Rules
- Salary Rules
- ADP / Payroll Export Mapping
- Asset / Crane Payroll Configuration
```

The Employee Profile should hold employee-specific setup. System-wide configuration should stay reusable and controlled outside the employee record.
