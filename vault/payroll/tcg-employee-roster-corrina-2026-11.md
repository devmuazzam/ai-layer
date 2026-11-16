---
title: TCG employee roster from Corrina Bustos — names, ADP job title and department (November 2026)
source: "ERP EE List(Data).csv", prepared by Corrina Bustos (HR Manager) from ADP for the ERP employee load; supplied by Syed Haris 2026-11-16. Columns kept here: name, Job Title Code, Department. Deliberately NOT kept: ADP file number (at Syed Haris's instruction), e-mail and phone (personal contact details).
migrated: 2026-11-16
updated: 2026-11-16
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, module/admin, kind/reference, employees, adp, roles, departments, provenance]
entities: [employee, role, department, adp-job-title]
---

# TCG employee roster (Corrina Bustos, November 2026)

The list Brian Petros used to enter and invite TCG's real employees on 2026-11-16 ([../admin/gaps.md](../admin/gaps.md) → *Departments, roles and their capabilities*). **104 people.** File numbers, e-mails and phones are not kept here; get them from Corrina or ADP.

## What the Job Title Code column shows

- **Field crew (65):** ADP's own job-title codes: `OILDRV` 32 (Oilers / Drivers, one code for both), `OPERATOR` 25, `MECHANIC` 8 (one written `Mechanic`). These are the broad ADP codes listed in [adp-api-responses/validation-tables-report-2026-08-18.md](adp-api-responses/validation-tables-report-2026-08-18.md).
- **Office staff (39):** 28 descriptive titles (below). **None of ADP's office codes from 2026-08-18** (`ACCOUNTG`, `ADM`, `DISPATCH`, `MNGMT`, `SAFETY`, `SALES`, `YARD`) appear. So either TCG has changed ADP's office job titles since August, or the titles were typed for this list. **Not established which**; it decides whether ADP can supply office positions.
- `OILDRV` does not say whether a person is an oiler or a driver, and `OPERATOR` does not give the union group, so field-crew roles and crafts cannot come from this column alone (see [adp-api-responses/INDEX.md](adp-api-responses/INDEX.md): *Can craft classification come from ADP? No*).

## Departments as listed

| Department | People |
| --- | --- |
| Field Operations | 58 |
| Sales | 10 |
| Shop | 10 |
| Accounting | 7 |
| Ownership | 5 |
| Yard | 4 |
| Safety | 3 |
| Dispatch | 2 |
| IT | 2 |
| HR | 1 |
| Marketing | 1 |
| ADMINISTRATOR | 1 |

`ADMINISTRATOR` is not a department; it is on one row (Aileen Ortega, title "Administration"). Brian entered her in Ownership as "Ownership Administrator".

## Points to check before loading the rest

- **Four people have no e-mail** ("does not have one"), all field crew; they can only be invited by text.
- **Patrick McKiernan has no ADP file number** ("Does not have").
- **Titles Brian changed when entering them in the ERP** (from his 2026-11-16 screenshots): Corrina "HR" → "HR Manager"; Dylan Masterson `OPERATOR` (Yard) → "Facility Manager"; Ashley Schacatano "Administration" (Accounting) → "Accounting Administrator"; Aileen Ortega "Administration" → "Ownership Administrator"; Brian Petros "IT" → "IT Data Analyst"; Patrick McKiernan "IT" → "IT Manager".
- **Joseph Deitrick**, "Field Operations PM", is listed under **Sales**.
- **Jonathan Lenton** (Shop, `MECHANIC`) has a **trg-service.com** e-mail, The Repair Guys' domain. That bears on the TCG / TRG company question ([../admin/gaps.md](../admin/gaps.md) → *Brian Petros's ERP spec and guidelines*).
- Two people named Samantha Garrett: Accounts Payable Specialist ("Samantha B") and Controller. Brian entered the Controller as "Sammy Garrett".
- About 17 names are in capitals; one phone number starts with a space.

## The list

### ADMINISTRATOR (1)

| Name | Job Title Code |
| --- | --- |
| Aileen Ortega | Administration |

### Accounting (7)

| Name | Job Title Code |
| --- | --- |
| Tia Brenneise | Accounts Receivable Lead |
| Samantha Garrett | Controller |
| Samantha B Garrett | Accounts Payable Specialist |
| Kaitlin Kiesel | Accounts Receivable Specialist |
| Ashley Schacatano | Administration |
| Micaela Slykhuis | Payroll and Compliance Specialist |
| Brent Wagstaff | Chief Financial Officer |

### Dispatch (2)

| Name | Job Title Code |
| --- | --- |
| Lisette Anzaldo | Dispatch Manager |
| Marisela Orejel | Dispatch Administrative Assistant |

### Field Operations (58)

| Name | Job Title Code |
| --- | --- |
| Anthony Albergo | OPERATOR |
| Jonathen Aldridge | OILDRV |
| Kyle Atkinson | OILDRV |
| Kyle Baker | OILDRV |
| Michael Berber | OILDRV |
| Edward Bill | OPERATOR |
| David Braden | OPERATOR |
| Jimmy Braden | OILDRV |
| David Bunch | OILDRV |
| Nathan Bunch | OILDRV |
| Rodolfo Castillo | OILDRV |
| Brad Combs | OILDRV |
| Guy Combs | OILDRV |
| Michael Cox | OILDRV |
| Austin Garabedian | OILDRV |
| Kylen Garcia | OILDRV |
| Rafael Garcia | OILDRV |
| Christopher Garofalo | OILDRV |
| Russell Garrett | OPERATOR |
| Travis Garrett | OPERATOR |
| Dana Gorman | OPERATOR |
| Teresa Greer | OILDRV |
| Leonardo Gutierrez | Crane Superintendent |
| Jeffrey Healy | OILDRV |
| Roberto Henderson | OILDRV |
| Jeffrey Kelley | Crane Superintendent |
| Devin Kelly | OPERATOR |
| Phillip Kramer | OPERATOR |
| Brett Lambert | OPERATOR |
| David Latham | OILDRV |
| Jeffrey Long | OPERATOR |
| Ernesto Lopez | OPERATOR |
| Aaron Malais | OPERATOR |
| Alejandro Marin | OPERATOR |
| Ralph Martinez | OPERATOR |
| Francisco Mejia-landa | OPERATOR |
| Martin Mighaccio | OPERATOR |
| Dillyn Munoz | OILDRV |
| Tanner Nelson | OILDRV |
| Manuel Ochoa | OILDRV |
| William Offer | OILDRV |
| Sergio Ontiveros | OILDRV |
| Alex Penman | OILDRV |
| Delbert Ramos | OPERATOR |
| Shawn Reed | OILDRV |
| Romel Sablay | OILDRV |
| Cory Schoppelrey | OILDRV |
| Trevor Shakespeare | OILDRV |
| David Thomas | OILDRV |
| John Thomas | OPERATOR |
| Shane Thomson | OPERATOR |
| Andrew Topete | OPERATOR |
| Christopher Trevizo | OPERATOR |
| Carlos Velez | OILDRV |
| William Vigil | OPERATOR |
| James Weaver | OPERATOR |
| Trenton Welty | OILDRV |
| Harry Wilson | OPERATOR |

### HR (1)

| Name | Job Title Code |
| --- | --- |
| Corrina Bustos | HR |

### IT (2)

| Name | Job Title Code |
| --- | --- |
| Patrick McKiernan | IT |
| Brian Petros | IT |

### Marketing (1)

| Name | Job Title Code |
| --- | --- |
| Noah Captain | Social Media Content Creator |

### Ownership (5)

| Name | Job Title Code |
| --- | --- |
| Kyle Harlow | Director of Fleet & Field Operations |
| Melissa McNutt | President |
| Joseph Schacatano | Chief Operating Officer |
| Michelle Staley | Owner |
| Wesley Staley | Founder |

### Safety (3)

| Name | Job Title Code |
| --- | --- |
| Nicholas Belmontez | Field Safety Specialist |
| Dennene Jones | Safety and Compliance Manager |
| Bernard Martin | Field Safety Specialist |

### Sales (10)

| Name | Job Title Code |
| --- | --- |
| Ryan Adams | Sales Manager |
| Adam Camasto | PM & Technical Sales Representative |
| Brian Cellier | PM & Technical Sales Representative |
| Hailee Connolly | Sales Coordinator |
| David Deitrick | PM & Technical Sales Representative |
| Joseph Deitrick | Field Operations PM |
| Christopher Fenimore | PM & Technical Sales Representative |
| Jason Flores Corona | PM & Technical Sales Representative |
| Leonard Lopez | Lead Project Engineer |
| Taylor O'Neill | PM & Technical Sales Representative |

### Shop (10)

| Name | Job Title Code |
| --- | --- |
| Richard Del Castillo | MECHANIC |
| Alexander Downs | MECHANIC |
| Elliott Gonzalez | Shop Manager |
| Garrett Harlow | MECHANIC |
| Jonathan Lenton | MECHANIC |
| Ethan McMahon | Mechanic |
| Logan Slykhuis | MECHANIC |
| Jeff Stricker | Fleet Compliance & Equipment Coordinator |
| William Thornton | MECHANIC |
| Joel Tucker | MECHANIC |

### Yard (4)

| Name | Job Title Code |
| --- | --- |
| Samuel Capt | Yard Technician |
| Dylan Masterson | OPERATOR |
| Joseph Mitchell | Yard Technician |
| David Orozco | Yard Technician |
