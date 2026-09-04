---
title: FCC employee master — the real code lists, the import schema, and the migration SQL
source: shared-folder/Project-Repository-2026-09-04 — FCC_EMPLOYEES_20260705.xlsx, 2026-05-29_FCC_EMPLOYEES_REPORT.xlsx, Employee Data v.5.25_TEMPLATE.xlsx, SQL_FCC_CORE_TABLES/EMPLOYEES/*.sql, FCC_MAINTAIN_EMPLOYEES (reviewed by TCG).pptx (slide text and notes, plus all 60 embedded screenshots read 2026-09-04)
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, module/dispatch, kind/reference, reference-data, data-migration, craft-code, craft-modifier, certifications, pricing, certified-payroll]
entities: []
---

# FCC employee master — code lists, import schema, migration SQL

**What this is.** Five sources that together give the **actual FCC vocabulary for an employee**:
the live code tables as of 2026-07-02, the vendor's blank import template with its validation
rules, the SQL used to extract the employee tables for migration, and TCG's own annotated
walkthrough of the FCC Maintain-Employees screens. This is the reference-data companion to
[fcc-employee-types-and-crafts.md](fcc-employee-types-and-crafts.md), which covers the multi-type
join and the craft-code working sheets.

> **No employee rows were copied.** `FMS_EMPLOYEES` (283 rows), `EMPLOYEES` (252),
> `FMS_EMPLOYEE_TYPE_DETAILS` (783), `EMP_CERTIFICATES` (523) and the template's 4,000-row
> employee sheets contain names, addresses, **Social Security Numbers**, birth dates, ethnicity and
> pay rates. Structure, column names, row counts and code lists only. The `Employees_SQL` /
> `EmpCertificates_SQL` / `EmployeesTypeDetails_SQL` sheets embed generated `INSERT` statements
> carrying the same personal data — **not copied; see the source files.**

---

## 1. The `lkup_*.sql` files are mostly empty — a fact worth knowing before you look

The migration folder contains six files named as if they were code lists. **Four of them contain
nothing but a one-line comment naming the source table.** In full:

| File | Actual content |
| --- | --- |
| `lkup_CERTIFICATES.sql` | `-- FROM [NexGenFMS].[dbo].[FMS_CERTIFICATES]` — nothing else (44 bytes) |
| `lkup_EMPLOYEE_TYPES.sql` | `-- FROM [NexGenFMS].[dbo].[FMS_EMPLOYEE_TYPES]` — nothing else (46 bytes) |
| `lkup_ETHNICITY.sql` | `-- FROM [NexGenFMS].[dbo].[FMS_ETHNICITY]` — nothing else (41 bytes) |
| `lkup_UNION_CRAFT.sql` | `-- FROM [NexGenFMS].[dbo].[FMS_UNION_CRAFT]` — nothing else (43 bytes) |
| `lkup_CLASSIFICATIONS.sql` | The table pointer **plus** the `Labor` field's values: `L` = Labor · `M` = Material · `B` = Both |
| `lkup_CRAFTS.sql` | The table pointer **plus** the `PayType` values: `R` = Regular Earnings · `O` = Overtime Earnings · `D` = Doubletime Earnings · `S` = Salary · `M` = Misc-Other |

They are table *pointers*, not extracts. **The actual code lists are in the workbooks**, tabulated
below, and that is where to look. Recording this so nobody opens the six files expecting
vocabularies and concludes the lists were never delivered.

The two real SQL files are extraction queries, not data:

- **`FCC_EMPLOYEES.sql`** — selects from `dbo.FMS_EMPLOYEES` with `LEFT JOIN`s to
  `FMS_EMPLOYEE_TYPES`, `FMS_CRAFTS`, `FMS_UNION_CRAFT`, `FMS_CLASSIFICATIONS` and `FMS_ETHNICITY`,
  resolving each code to its description.
- **`EmpCertificates.sql`** — `FMS_EMP_CERTIFICATES` joined to `FMS_EMPLOYEES` and
  `FMS_CERTIFICATES`, ordered by `EmpID`, `CertificateCode`, `ExpireDate`.
- **`EmployeesTypeDetails.sql`** — `FMS_EMPLOYEE_TYPE_DETAILS` joined to employees and types,
  ordered by `EmpID`, `PrimaryType DESC`.

All three do the same defensive text scrubbing on every `nvarchar` column — CRLF, CR, LF → `' | '`
and TAB → `' '` — because the extract is delimited output and free-text fields (`Comments`,
`CertName`) contain line breaks. Two of them also join on **`GroupNumb`** as well as `EmpID`
(`emp.EmpID = cert.EmpID AND emp.GroupNumb = cert.GroupNumb`), so **`EmpID` alone is not the key**
in FCC — there is a company/group discriminator alongside it. Nothing in the vault has said that
before, and it matters for the ERP's own `(tenant, code) → id` resolution.

---

## 2. Employee types — **15, not 16, and Third Man is one of them**

`FMS_EMPLOYEE_TYPES`, identical in both the 2026-05-29 report and the 2026-07-05 extract:

| ID | Description | Created | ID | Description | Created |
| ---: | --- | --- | ---: | --- | --- |
| 1 | Operator | 2019-07-03 | 9 | Sales Admin | 2019-08-01 |
| 2 | Oiler | 2019-07-03 | 10 | Accounting Admin | 2019-08-01 |
| 3 | Mechanic | 2019-07-03 | 11 | Dispatch Admin | 2019-08-01 |
| 4 | Yard Man | 2019-07-03 | 12 | Safety Admin | 2019-08-01 |
| 5 | Rigger | 2019-07-03 | 13 | Salesmen | 2019-08-01 |
| 6 | Driver | 2019-07-03 | **14** | **3rd Man** | **2021-11-09** |
| 7 | Shop | 2019-07-10 | **15** | **Job Foreman** | **2026-02-18** (corrinab) |
| 8 | Management | 2019-08-01 | | | |

All 15 are `Status = 1` (active) and all carry `Type = B`.

> **⚠️ This corrects [fcc-employee-types-and-crafts.md](fcc-employee-types-and-crafts.md)**, which
> states *"16 rows"* and *"**Third Man is not in this list** — despite `CraftRoleType.THIRD_MAN`
> existing in `@tcg/shared` and the client asking for it in UAT. So Third Man is a craft-code
> concept in FCC, not an employee type."* **`3rd Man` is `EmpTypeID` 14 and has existed since
> 2021-11-09.** Both workbooks agree, and the earlier one is the very file that page was written
> from. The conclusion drawn there — that Third Man is craft-only — does not hold. That page has
> been corrected; this row is the evidence.
>
> **`Job Foreman` (15) is also new to the vault**, created 2026-02-18 by Corrina Bustos — during
> the ERP engagement. It bears on [PAY-070](rules/PAY-070-foreman-premium.md) (foreman premium),
> which the register notes is *"in no other document"*: FCC now has a foreman employee type.

**The vendor's own rules for the concept**, from the import template's guidance sheet:

- *"Employee types are the different types of work/roles employees do."*
- *"Each employee needs to have **at least one** employee type assigned as the **primary** employee
  type."*
- *"**Unlimited secondary** employee types can be added to each employee profile."*
- *"Each employee type can either be selected to be **dispatched on jobs/quotes, on work orders, on
  both, or for neither** (for example, office employees)"* — the import field is
  `Dispatchable on: Jobs/Quotes (J), Work Orders (W), Both (B), or None (N)`.
- Name up to 60 characters.
- Suggested starter set: Operator, Oiler, Rigger, Driver, Dispatcher, Foreman, Flagger/Signalman,
  Office.

Two consequences. First, the **multi-type model is vendor-documented policy**, not a TCG local
custom — which strengthens the case already made in
[fcc-employee-types-and-crafts.md](fcc-employee-types-and-crafts.md) that the ERP's single
nullable `Employee.employeeTypeId` FK discards real data. Second, **`Dispatchable on` is an
attribute of the employee *type*** — a field the ERP has nowhere, and the natural place to hang the
field-role/system-role distinction the departments-and-roles discussion keeps returning to.

---

## 3. Classifications — 24 codes, and three of them are payroll rules in disguise

`FMS_CLASSIFICATIONS` as of 2026-07-02. Columns: `ClassCode`, `Description`, `Labor` (L/M/B),
`Status`, audit columns, **`UseCertifiedPayroll`**.

| Code | Description | Labor | CertPay | Code | Description | Labor | CertPay |
| --- | --- | :-: | :-: | --- | --- | :-: | :-: |
| `ACCOUNTING` | Accounting | L | 1 | `MECH LABOR` | Mechanic Labor | L | 1 |
| `ADMIN PTO` | Admin PTO | L | 1 | **`NO 8 HR GP`** | **No 8 Hour Gap** | L | 1 |
| **`ANNIVERSAR`** | **L12 Anniversary** | L | **0** | `OFC ADMIN` | Office Admin | L | 1 |
| `BER` | Bereavement | L | 1 | `ON CALL` | Dispatch on Call | B | 1 |
| `DISPATCH` | Dispatch | L | 1 | `OWNER` | Owner | L | 1 |
| `DRUG` | Drug Testing | B | 1 | `PARTS` | PARTS | B | 1 |
| `FIELD EMP` | Field Employees | B | 1 | **`S-SUB`** | **Subsistence** | L | 1 |
| `HK` | Housekeeping | B | 1 | `SAFETY DEP` | Safety Dept | L | 1 |
| `HR` | HR Dept | L | 1 | `SALES` | Sales Admin | L | 1 |
| **`L- SUB`** | **Long Subsistence** | L | **0** | `SICK` | Sick | L | 1 |
| `MANAGEMENT` | Management | L | 1 | **`ST`** | **Short Subsistence** | L | 1 |
| `SUPERINTEN` | Superintendent | L | 1 | `YARD LABOR` | Yardman Labor | L | 1 |

All 24 are active. Findings:

- **`NO 8 HR GP` — "No 8 Hour Gap" — is a classification, created 2020-07-21.** The eight-hour rest
  rule ([PAY-045](rules/PAY-045-rest-period-premium.md)) is flagged in FCC by *classifying the
  labor*, not by the engine deriving it from timestamps. That is a **third mechanism** alongside
  the legacy Payroll App's `PunitiveUntil8Off` chain logic and the
  [dependency matrix](payroll-rule-dependency-matrix.md) §10's derive-from-gaps model. Whether the
  classification is an input, an output, or a manual override is **not stated anywhere.**
- **Three subsistence classifications, and the naming is a trap.** `ST` = *Short Subsistence*
  (2019), `S-SUB` = *Subsistence* (2020, modified 2026-01-19), `L- SUB` = *Long Subsistence*
  (created 2026-01-19). `ST` reads as "straight time" to every payroll reader alive and is not.
  The 2026-01-19 edits look like a rework of the pair — `S-SUB` and `ST` were both touched the same
  minute `L- SUB` was created. Bears on [PAY-048](rules/PAY-048-standard-subsistence.md) /
  [PAY-049](rules/PAY-049-weekend-subsistence.md).
- **`ANNIVERSAR` — "L12 Anniversary"** (created 2026-01-15) is not a concept the register has.
- **`UseCertifiedPayroll` is per classification**, and only two codes are excluded — `ANNIVERSAR`
  and `L- SUB`. Feeds [PAY-072](rules/PAY-072-certified-payroll-davis-bacon-reporting.md).

---

## 4. Craft codes — the `-A` / `-B` / `-C` convention, and the apprentice rework

`FMS_CRAFTS`, 86 rows as of 2026-07-02. Key columns: `CraftCode`, `Description`, `PayType`
(R/O/D/S/M), `PromptText` (`Hours` or `Days`), `BurdenYN`, `WCYN`, `UnionYN`, `AcctPayType`,
`Billable`, `Status`, `PayTypeOrder`. The import template adds one the extract does not show:
**`Exempt Apprentice % Factor`** — a per-craft flag exempting a craft from the apprentice
percentage, which is new to the vault and bears on
[PAY-016](rules/PAY-016-apprentice-wage-step.md).

**The convention: one logical craft becomes three codes**, suffixed `-A`, `-B`, `-C`, matching the
`PayType` R / O / D. The TCG-annotated Maintain-Employees deck states it plainly, three times over:
*"These A/B/C code are: **A = Standard Time (ST), B = Overtime (OT), C = Double Time (DT)**."*
`AcctPayType` follows: `HOURLY` / `OVERTIME` / `DOUBLE TIME`.

The active L12 operator/oiler ladder, by tonnage:

| Craft | Description | Craft | Description |
| --- | --- | --- | --- |
| `L12-G1` | Oiler 80T & under | `L12-G6` | OP >80T–200T |
| `L12-G2` | Oiler >80T | `L12-G7` | OP & Tower OP >200T–350T, Shop |
| `L12-G3` | OP up to 40T | `L12-G8` | OP & Tower OP >350T–550T |
| `L12-G4` | OP >40T–80T | `L12-G9` | OP & Tower OP >550T, HDR |
| `L12-G5` | Tower OP up to 200T | | |

**`L12-G9` was created 2026-06-06 by `bpetros`** — a new top band for >550T and HDR, added during
the ERP engagement.

**The apprentice rework, same day.** The old single `L12-APP-A/B/C` (created 2020-04-14) was marked
**INACTIVE** and replaced on **2026-06-06** by **six steps**, `L12-APP1` through `L12-APP6`, each
with its own A/B/C triple — 18 new craft codes. This is
[PAY-016](rules/PAY-016-apprentice-wage-step.md) made concrete, and it dates the change: the
apprentice wage ladder became six explicit steps in June 2026.

Also present and worth naming: `ADMIN-A/B/C` (non-union admin), `SYS-ACCESS`
(*System-Testing-VendorAccess*, `PayType M`, active — the excluded payroll group of
[PAY-007](rules/PAY-007-system-testing-employee-exclusion.md), and it is a **craft code**), `SUB`
(*Subsistence*, `PayType M`, **`PromptText = Days` not Hours**, now inactive), `HOLIDAY`
(*Holiday Pay*, `PayType M`, inactive), and the inactive legacy `DRIVER-*`, `YARD-*`, `OILER-1-*`,
`OILER-2-*`, `HDR-*`, `CRANE SUP`, `L12-BG-*`.

`SUB`'s `PromptText = Days` is the schema-level confirmation that subsistence is counted in **days,
not hours** — consistent with the
[dependency matrix](payroll-rule-dependency-matrix.md) §12 (*"a fixed pay component/allowance, not
worked hours subject to an hourly multiplier"*).

---

## 5. Union craft rates — pre-multiplied, and effective-dated in the schema

`FMS_UNION_CRAFT`, 57 rows, all `UnionCode = L12`, last modified **2026-07-01**. Columns:
`UnioncraftID`, `UnionCode`, `CraftCode`, **`PayRate`**, `BillingRate`, `Comments`, audit columns,
**`StartDate`**, **`EndDate`**.

The rate for each craft's `-A` row, with `-B` and `-C` at exactly 1.5× and 2×:

| Craft | ST (`-A`) | Craft | ST (`-A`) |
| --- | ---: | --- | ---: |
| `L12-G1` Oiler ≤80T | 67.03 | `L12-G7` OP/Tower >200–350T | 69.66 |
| `L12-G2` Oiler >80T | 67.18 | `L12-G8` OP/Tower >350–550T | 70.16 |
| `L12-G3` OP ≤40T | 68.87 | `L12-G9` OP/Tower >550T, HDR | 72.16 |
| `L12-G4` OP >40–80T | 68.99 | `HDR-A` | 71.16 |
| `L12-G5` Tower OP ≤200T | 69.16 | `L12-APP-A` *(inactive)* | 40.90 |
| `L12-G6` OP >80–200T | 69.41 | | |

Apprentice steps (`-A` rows, added 2026-06-06): **APP1 41.50 · APP2 44.95 · APP3 48.41 ·
APP4 51.87 · APP5 55.33 · APP6 62.24**. And two non-hourly rows: **`SUB` = 200** (matching the
$200 weekend subsistence of [PAY-049](rules/PAY-049-weekend-subsistence.md)) and **`HOLIDAY` = 0**.

Three observations:

1. **`BillingRate` is 0 for every single row.** The pay-rate/billing-rate pairing the
   [Union Codes Guide](fcc-union-code-configuration.md) describes for T&M work is configured but
   unused.
2. **`-B` and `-C` are stored, not derived.** Every `-B` is exactly 1.5× and every `-C` exactly 2×
   its `-A`, but the ratio is a data convention, not a constraint. A migration that copies these
   rows inherits pre-multiplied rates — which does not compose with the
   [dependency matrix](payroll-rule-dependency-matrix.md)'s single-base-rate-times-controlling-
   multiplier model. **Not adjudicated.**
3. **`StartDate` / `EndDate` exist** — the pre-2026 rows carry a `StartDate` matching their
   creation and no `EndDate`; the June 2026 rows have neither populated in the extract. So the
   schema supports effective dating but the data does not consistently use it, and the union
   *reports* explicitly do not (see
   [fcc-union-code-configuration.md](fcc-union-code-configuration.md) §6). Bears on
   [PAY-008](rules/PAY-008-effective-dated-configuration.md).

**These are craft rates, not employee pay data**, and are reproduced here because they are the
authoritative L12 rate card the ERP must migrate. No employee is associated with any of them here.

---

## 6. Ethnicity and certificates

**`FMS_ETHNICITY`** — 7 codes: `A` Asian · `B` Black · `C` Caucasian · `H` Hispanic · `I` Indian ·
`M` Amer Indian · `O` Other. All active, no audit metadata.

> **A defect in the vendor import template.** Its `Ethnicity` column reads: *"Amer Indian (M), Asian
> (A), Black (B), Caucasian (C), Hispanic (H), Indian (I), or Other (O) — **(Enter M, A, B, C, H or
> I)**"*. The instruction omits `O`, which the list it just gave includes and the live table holds.
> An import following the parenthetical drops Other.

**`FMS_CERTIFICATES`** — the certificate catalogue (24 rows, 11 legible in conversion). Columns:
`CertificateCode`, `CertName`, `MaintEvery` + `TimePeriod` (and a second pair), `Status`,
**`CertificationType`**, `LinkTo`, `UnitCertificateType`, `ITICourseSKU`, `DontPromptExpCert`.

`CertificationType` is `G` (general), `C` (customer/location) or `U` (unit) — the import template
spells it out: *"Unit (U), General (G), or Customer/Location (C)"*. Named certificates and their
renewal intervals:

| Code | Name | Renew | Type | Code | Name | Renew | Type |
| --- | --- | --- | :-: | --- | --- | --- | :-: |
| `NCCCO` | NCCCO Certification | 60 mo | G | `MEDICAL` | Medical Card | 24 mo | G |
| `DL` | Drivers License | 60 mo | G | `MSHA` | MSHA-5023 | 12 mo | G |
| `CPR` | CPR | 12 mo | G | `MSHA-VULCAN` | MSHA Vulcan | 12 mo | **C** |
| `FIRST AID` | First Aid | 12 mo | G | `NBIS` | NBIS Defensive Driving | 12 mo | G |
| `HARR` | Harrassemnt *(sic)* | 12 mo | G | `BECHTEL` | Bechtel Passport | — | **C** |
| `FORKLIFT` | Forklift | — | G | | | | |

The two `C`-type entries — **Bechtel Passport** and **MSHA Vulcan** — are the interesting ones: a
certification required by a *specific customer or site*, not by the trade. Dispatch eligibility can
therefore depend on the customer. That is a payroll↔dispatch↔customers seam not drawn anywhere in
the vault. `EmpCertificates.sql` also exposes `ValidityDate` alongside `IssueDate`/`ExpireDate` —
three dates, purpose of the third unexplained.

---

## 7. The import template's employee schema

`Employee Data v.5.25_TEMPLATE.xlsx` — **14 sheets, entirely blank of data**; every row shows the
validation formulas' `No Match` / `OK` output against empty cells. Its value is the **schema and the
required/optional split**. Sheets: `1. Employee Information` (up to 4,000 rows) · `2. Employee
Profile Example` · `3. Companies in NexGen` · `4. Yards in NexGen` · `5. States in NexGen` ·
`6. Unions in NexGen` · `7. Craft Codes in NexGen` · `8. Burden Codes in NexGen` ·
`9. Employee Types` · `10. Workers Comp Codes` · `11. Classifications` · `12. Classifications
Example` · `13. Certifications` · `14. Employee Certifications`.

**Required** on an employee: Employee ID · Last Name · First Name · **Social Security Number**
(9 digits) · **Company** · **Yard** · **Pay Cycle** · **Pay Type** · **Default Craft Code** ·
Status · **Type** · **Default Employee Type**.

**Optional:** address, city, state, zip, three separate phone numbers (Phone / Work Cell /
Personal Cell), email, Default Union, six non-union rate fields, Start / Rehire / Term dates,
Term Reason, Supervisor, **Certified Pay**, Burden Code, Workers Comp Code, Default Classification,
Birth Date, Gender, Ethnicity, Marital Status, **Apprentice**, **Apprentice %**,
**Registration Number**.

Enumerations the template fixes:

| Field | Values |
| --- | --- |
| **Pay Cycle** | Weekly (W) · BiWeekly (B) · Monthly (M) · SemiMonthly (S) · Quarterly (Q) · Daily (D) |
| **Pay Type** | Hourly (H) · Salary (S) |
| **Status** | Active (A) · Inactive (**T**) |
| **Type** | Scheduling · Maintenance · Scheduling & Maintenance · In Office |
| **Gender** | Male (M) · Female (F) |
| **Marital Status** | Single (S) · Married (M) |
| **Supervisor / Certified Pay / Apprentice** | Y · N |
| **Classification `Labor`** | Labor (L) · Material (M) · Both (B) |
| **Certification type** | Unit (U) · General (G) · Customer/Location (C) |
| **Certificate `Link To`** | Job Employee (E) · Work Order Employee (W) |
| **Employee type `Dispatchable on`** | Jobs/Quotes (J) · Work Orders (W) · Both (B) · None (N) |

Three things to note. **`Type`** (Scheduling / Maintenance / Scheduling & Maintenance / In Office) is
a *different field* from `Employee Type` and from `Classification` — FCC has three overlapping
role-ish fields on one employee, which is the mess behind Corrina's *"Department — what is this
field used for?"* in [erp-review-log.md](../erp-review-log.md) §12. **Six separate non-union rate
fields** exist (ST/OT/DT pay and ST/OT/DT billing), mirroring the union table's pre-multiplied
shape — bears on [PAY-012](rules/PAY-012-non-union-hourly-rate.md) and the decision
[2026-08-25-non-union-base-rate-per-person](../decisions/2026-08-25-non-union-base-rate-per-person.md).
And **`Apprentice %` + `Registration Number`** are employee-level fields for
[PAY-016](rules/PAY-016-apprentice-wage-step.md) — the registration number being the DAS/state
apprenticeship registration that certified-payroll reporting needs
([PAY-072](rules/PAY-072-certified-payroll-davis-bacon-reporting.md)).

---

## 8. What TCG asked FCC to change — the annotated Maintain-Employees deck

`FCC_MAINTAIN_EMPLOYEES (reviewed by TCG).pptx` — 34 slides of FCC employee screens with TCG's own
annotations, several marked `*** NEW SECTION/FUNCTIONALITY ***`. The requests:

- **Assign employees to yards, many-to-many.** *"Be able to assign/associate Employees to each
  Yard… Some Employees may be working/associated with more than one Yard."* The import template has
  a single required `Yard`; TCG wants several, for per-yard reporting.
- **Union Info block** — *Union Class Type (Operator Group)*: **Steward · Regular · Apprentice**.
  A three-way union standing that is **in no other vault document** and is not the same axis as
  employee type or craft code. Steward in particular has no representation anywhere.
- **Cranes Qualified to Operate** — select all crane types an employee may operate; and, on a later
  slide, *"should also be able to select which **Asset Types** are allowed to operate."*
- **Apprentice Info** — *"Need to see current Apprentice status. There are multiple levels of
  Apprentice status (according to the Labor Union). **Based on number of hours worked.** Should
  also be able to modify."* This is the requirement behind the six `L12-APP1..6` craft codes.
  **Confirms** [PAY-016](rules/PAY-016-apprentice-wage-step.md), whose trigger is already
  *"employee reaches configured accumulated-hour threshold"* — the deck is an independent
  statement of the same driver, from the client, plus the ask that the level be **manually
  modifiable**, which the rule does not mention.
- **Certifications & trainings** — *"This screen only shows Certifications, but we could also enter
  Trainings required/attended here as well. Many of the Trainings come with a Certification."*
- **Multiple labor unions** — *"We currently only work with one Union; however, need the ability to
  have multiple Labor Unions."*
- **Document upload** on both the employee profile and the union profile.

> **⚠️ Collision — where the Certified Pay flag lives.** The deck says: *"**Certified Pay:** This
> should be **'Job specific'**. Certified Pay is more granular than Customer (needs to be per Job
> or defaulted per Job Site)."* But the FCC import template carries **`Certified Pay` as an
> optional Y/N on the employee record**, and the
> [Certified Payroll Playbook](certified-payroll-playbook.md) §5 instructs the Sales Coordinator to
> *"Mark Labor compliance in FCC so it populates to labor compliance"* without saying on what. So
> the record holds an **employee-level flag**, a **classification-level flag**
> (`UseCertifiedPayroll`, §3 above), and a **TCG request for a job/job-site-level flag** — three
> levels for one concept. Nobody has adjudicated which is authoritative. Bears on
> [PAY-072](rules/PAY-072-certified-payroll-davis-bacon-reporting.md).

Slides 7, 8, 9 and 19 — Employee Rates, Employee Payroll Defaults, Employee Unions and Union
Payroll Defaults — are each annotated only *"To be discussed more when working on Payroll"*, with
one substantive note: *"FCC has **multiple places for rates** (depending on Employee Union
status)."* Those discussions are the ones this folder records; the deck itself defers them.

## FCC's employee import template — the validation rules (read 2026-09-04)

`1.0.2_FCC-RESOURCES-GUIDES/FCC-IMPORT-Templates/Employee Data v.5.25_TEMPLATE.xlsx` is 193,260
formulas of validation over blank rows — 24 patterns on `1. Employee Information`, which are
FCC's field contract for an employee: name ≤ 50 · **state must exist in `5. States in NexGen`** ·
phone ≤ 12 · **SSN exactly 9 digits** · **zip exactly 10** · **company and yard must exist in
`3. Companies` / `4. Yards`** · a 40-char text field · **pay frequency ∈ `W B M S Q D`** (weekly,
bi-weekly, monthly, semi-monthly, quarterly, daily) · **pay type ∈ `H S`** (hourly / salary) ·
**union must exist in `6. Unions in NexGen`** · **craft code must exist in `7. Craft Codes in
NexGen`** · pay rate numeric to two decimals. Nothing here is TCG data; it is what FCC will
accept, and therefore the shape the migration extracts were cut to.

## Source

- `2.1.1_DATA-MIGRATION/NexGenFMS_for_ERP/FCC_EMPLOYEES_20260705.xlsx` — 256 KB, **12 sheets**; the
  six code-list sheets (`CRAFTS` 86 rows, `UNION_CRAFT` 57, `EMPLOYEE_TYPES` 15, `CLASSIFICATIONS`
  24, `ETHNICITY` 7, `CERTIFICATES` 24) are the primary source for §2–§6. Extract run **2026-07-02**;
  each sheet is annotated by the client with `keep` / `lookup` / `n/a` / `system`.
- `2.0.1_DATABASE-SCHEMA/2026-05-29_FCC_EMPLOYEES_REPORT.xlsx` — 1.4 MB, 13 sheets; already covered
  by [fcc-employee-types-and-crafts.md](fcc-employee-types-and-crafts.md). Used here only to confirm
  `FMS_EMPLOYEE_TYPES` is identical in both extracts.
- `1.0.2_FCC-RESOURCES-GUIDES/FCC-IMPORT-Templates/Employee Data v.5.25_TEMPLATE.xlsx` — 2.5 MB,
  14 sheets, **no data rows**; source for §7.
- `2.1.1_DATA-MIGRATION/…/SQL_FCC_CORE_TABLES/EMPLOYEES/` — `FCC_EMPLOYEES.sql`,
  `EmployeesTypeDetails.sql`, `EmpCertificates.sql` and six `lkup_*.sql`; source for §1.
- `1.0.1_BUSINESS-REQUIREMENTS/FCC_NexGen_MENUS/FCC_MAINTAIN_EMPLOYEES (reviewed by TCG).pptx` —
  1.6 MB, 34 slides, text on 15 of them; source for §8. The screenshots do not survive text
  conversion; the 60 embedded images were extracted and read on 2026-09-04 — see the final section.

---

## What the deck's screenshots show — read 2026-09-04

All 60 images embedded in `FCC_MAINTAIN_EMPLOYEES (reviewed by TCG).pptx` were extracted and
viewed on 2026-09-04; §8's *"the screenshots do not survive conversion"* no longer applies. Only
what the annotations and the workbooks above did not already give is recorded: tab names, field
labels, dropdown domains, checkbox options, defaults, and the example rows that reveal a
convention.

> **The Employees slides show one real employee record, and slide 30 lists real employees with
> licence numbers.** Names, birth date, pay rate, certificate and licence numbers, phone numbers,
> addresses, the attached file's name and the user ids in audit stamps are **deliberately not
> copied** — fields only, never values. The union's own address and phone on the Union Codes
> Main tab are likewise omitted.

### The `Maintain → Employees` menu, and where Classifications lives

Fourteen entries, in FCC's order: **Employees · Employee Types · Certifications · Union Codes ·
Craft Codes · Craft Craft Modifier** (sic) **· Union Pay and Billing Rates · Non-Union Billing Rates
· Employee Pay Rates · Workers Comp Codes · Certifications By Employee · Employee Down Reason ·
Marital Status · Ethnicity.** The deck opens every one (slides 2–33). **Classifications is not
under Employees** — slide 34 reaches it from the `Maintain` root, whose lower half also lists
*Chk\Taken By · Job Types · Line Items · Quote Status · Classifications · Geographies · WO Reason ·
WO Priorities · Work Order Status · Units of Measure · Terms · Documents · Vendors · Salespeople ·
Field Names · Recurring Billings · Job Checklist · Export Status · Deficiency Degree/Priority ·
Telematics Provider · Regions*.

### The Employees window — eight tabs (slides 2–10)

Header: **Company · Yard · Name** (lookup, with a **Name / ID** radio) **· Status** (`All`). Tabs:
**Main · Addtional Info** (sic) **· Comments · Emp Types · Certifications · Rates · Payroll
Defaults · Unions.**

**Main (slide 2 — the *Yard association*, *Union Info*, *Cranes Qualified* and *Certified Pay*
annotations).** Left column: Employee ID · Last / First / Middle Name · Address1 / Address2 · City
· State & Zip · SSN · Home Phone · Work Cell Phone · Personal Cell Phone · Company · **Yard** (one
dropdown) · E-Mail · **Payroll Exported** (a date). Middle: Pay Cycle (`Weekly`) · **Union** (greyed;
`L12`) · Pay Rate · **Over Scale ST · Over Scale DB** · Start Date · **Terminated** ☐ · Term Reason
(memo) · **Type** (`Scheduling & Maintenance`) · **Employee Type** (greyed; `Operator`). Right: Pay
Type (`Hourly`) · **Craft** (`L12-G7-A`) · Billing Rate · **Over Scale OT** · **Minimum Rate** ☐ ·
Rehire Date · Term Date · **Supervisor** ☐ · **Certified Pay** ☑. Bottom: **Burden** (`STD`) ·
**Work Comp** (`OPERATOR RATE`) · **Classification** (`Field Employees`). Audit stamps below.

- **Yard is a single dropdown** — the many-to-many the annotation asks for has no foothold on
  the screen, which is the point of the ask.
- **Union and Employee Type are read-only on Main**: Employee Type is whichever *Emp Types* row
  is Primary (below); the screen does not say where Union comes from — the *Unions* tab note
  (below) is the nearest explanation.
- **The default craft is stored with its `-A` suffix** (`L12-G7-A`): an employee's craft is the
  straight-time member of the A/B/C triple, and FCC picks `-B`/`-C` from it.
- **Over Scale ST / OT / DB and Minimum Rate** are on the screen but in **no rule in this
  folder and not in the import template's field list (§7)**. They are the `UnionOverScale*` and
  `MinimumRate` columns of the legacy extract
  ([legacy-payroll-app-db-extract/data/source-feed.md](legacy-payroll-app-db-extract/data/source-feed.md)),
  all zero on the sampled rows there. Above-scale pay is a concept the register does not have.
- **Certified Pay is ticked on the example** — a field operator carrying the employee-level flag,
  which is the first of the three levels in §8's collision note in live use.
- **Pay Rate is populated on a union employee** even though the union craft table governs the
  rate. Whether it is copied in or typed is not shown. Value not copied.
- `Payroll Exported` is a date stamp on the employee, not a flag — the last export that
  carried this person.

**Addtional Info (slide 3 — the *Apprentice Info* annotation).** Birth Date · Gender · Ethnic ·
**Class ID** · Marital Status (all dropdowns) · **Union Apprentice** ☐ · **Union Optional1 …
Optional7** ☐ · two *Emergency Contact* blocks (Name · Address · City · State & Zip · Work Phone ·
Cell Phone · Home Phone · Email). **FCC's apprentice standing on this screen is one checkbox** — the
`Apprentice %` and `Registration Number` of the template (§7) are not on this tab — which is
exactly why TCG asks for levels here. `Class ID` is a fourth role-ish field beside Type, Employee
Type and Classification.

**Emp Types (slide 4 — annotation repeats *Union Info* and adds *"select which Asset Types are
allowed to operate"*).** Grid **Employee Type · Primary ☑ · Status.** The example holds **five
types — 3rd Man, Driver, Oiler, Operator (Primary), Rigger** — the multi-type model in live use,
with **`3rd Man` assigned as a secondary type on a real record** (the evidence §2 wanted). No
column relates a type to an asset type; the annotation asks for one.

**Certifications (slide 5).** Two-row header **Certification Code · Certification Name ·
Certificate Numb · Issue Date · Expire Date · Link To · Status** / **Comments · Certificate Type ·
File Links**, filtered by *View* (`Active`). The example holds **CPR, DL, MEDICAL, NCCCO and OSHA**;
OSHA has an issue date and no expiry. *Link To* and *Certificate Type* are blank on every row.
**Slide 6 — `Maintain File Links – Employee Certifications`**, headed *Certification Code-CPR*:
**File Name · Comments · Created By · Modified By** / **Include in E-Documents ☐ · Status · Created
Date · Modified Date.** One PDF is attached to the CPR row (its name embeds the employee's name and
expiry date — not copied). **`Include in E-Documents`** is new to the vault: a per-file switch to
push a certificate into the e-documents set. The annotation's *Upload Documents* describes what is
shown; the *Trainings* ask has no column.

**Rates (slide 7 — *"FCC has multiple places for rates"*).** **Craft Code · Description · Pay Type
· Pay Rate · Billing Rate · Comments** — **empty on the union example.** The deck's screens show
the "multiple places": (1) Employee Main — Pay Rate, Billing Rate, Over Scale ×3; (2) this Rates
tab, which is the same table as the **Employee Pay Rates** screen (slide 28: an Employee lookup
with Name/Code radio over the same six columns; also empty for the example); (3) Union Codes →
Pay Rates (slide 17), which is the same table as **Union Pay and Billing Rates** (slide 26 — same
31 rows with a *Union Code · Description* pair prefixed); (4) **Non-Union Billing Rates** (slide
27: **Craft Code · Description · Billing Rate · Yard · Comments** — empty). Five screens over three
tables, and **the non-union billing rate is per yard**.

**Payroll Defaults (slide 8).** The same layout as the union-level tab in
[fcc-union-code-configuration.md](fcc-union-code-configuration.md) §5: Split Multiple Days ☐ · OT
Eligible · DT Eligible · Include ST Hours in Time Slot overlap ☐ · Saturday · Sunday · Time Round
To … Mins. · a *Time Slot* grid (Week Days · Time Start · Time End · Pay Type) · an *Exclude Craft
Codes* grid. **Every field is blank on the example** — the per-employee override exists and is
unused; the union's defaults govern.

**Unions (slide 9 — *"need the ability to have multiple Labor Unions"*).** Grid **Union ·
Description · Primary · Comments**, empty, with FCC's own instruction printed on the tab:

> *"To limit the number of unions an employee can select in Atom, add the union records here. Once
> any record is added to this tab, this is the only source of unions for the employee - they will
> not be able to select any union that is not present here."*

Two things follow. **FCC already models several unions per employee, with a primary** — the
annotation's ask is about union *codes* (the Union Codes dropdown on slide 14 holds only `L12`),
not the employee link. And **the operator chooses the union in Atom** — union is a per-timesheet
selection constrained by this tab, not only a master-data fact. Neither is in the vault.

**Slide 10 — `Maintain File Links – Employee`**, headed *Employee-<ID>*: **File Name · Comments ·
Created By · Modified By · Created Date · Modified Date.** Employee-level attachments already
exist; the annotation describes the dialog.

### Employee Types and Certifications lookups (slides 11–13)

- **Employee Types** (11): **Description · Type · Status.** The 15 of §2, every one `Type = Both`
  and Active. `Both` is the *Dispatchable on: Jobs/Quotes and Work Orders* value of the template.
- **Certifications** (12–13): tabs **Main · Yard Restrictions.** Columns **Certification Code ·
  Certification Name · Certification Type** (`General` | `Customer/Location`) **· Link To ·
  Certificate Type · Maintenance Every · Maintenance Period · Do not Prompt when Certificate is
  Expired ☐ · Status.** Fourteen rows are legible and **three are not in §6**: **`OSHA`** (no
  interval), **`RIG-SIGNAL` Rigger and Signalperson (24 Months)**, **`TWIC` (24 Months)**.
  `FORKLIFT` has no interval either. `BECHTEL` and `MSHA-VULCAN` are the two `Customer/Location`
  rows, confirming §6. *Link To* and *Certificate Type* are blank on all fourteen; no row has
  *Do not Prompt* ticked. *Yard Restrictions* (headed **"Any Yard Listed will not Apply to this
  Yard"**: Yard · Applies to this Yard(s) · Comments) means a certificate requirement can be
  switched off per yard — a customer-specific certificate like Bechtel Passport can be scoped.

### Union Codes — TCG's live L12 configuration (slides 14–20)

The screen layout is already recorded from the vendor guide in
[fcc-union-code-configuration.md](fcc-union-code-configuration.md) (*What the screenshots show*),
against demo data. **This deck shows the real `L12` record**, and that is what is new:

- **Main (slide 15, annotated *Employee Unions — to be discussed*).** Code `L12`, Description
  `Local 12`, Status `Active`, address block filled (not copied). Shift Premium Type = **Amount**,
  Pay Rate Options **Default / Default**, **all six shift premiums (ST/OT/DB × 2nd/3rd shift) are
  `$0.00`**, Ignore Time Slots unticked. **FCC holds no shift premium for L12.** The shift
  component that [client-message-findings.md](client-message-findings.md) decomposes from the
  legacy Payroll App is not configured here — it lives elsewhere.
- **Benefits (slide 16).** Seven lines, every one `Type = Hrs Worked`, `Union / Vac = Union`:
  **Annuity 5.0000 · Contract Administration 0.1000 · Health and Welfare 14.2000 · Joint
  Apprenticeship 1.1000 · Pension 10.6500 · Supplemental Dues 1.7000 · Vacation / Holiday 2.7500**
  (dollars per hour worked; 35.50 in total). The Annuity detail pane: *Add to Gross* and *Subtract
  from Net* both unticked; *Applies To* ST, OT and DB Earnings all ticked; *Apply This To* `All`;
  both *Include…* boxes unticked; no daily/weekly/monthly maximum. These are employer fringe
  rates, not employee data; they are the FCC-side counterpart of
  [PAY-050](rules/PAY-050-union-fringe-contributions.md) and the MLA fund articles. **Vacation /
  Holiday is typed `Union`, not `Vac`** — the *Union / Vac* distinction the guide describes is
  not used.
- **Pay Rates (slide 17 — the A/B/C annotation).** **31 rows**: `HDR-A/B/C` (*Mech*), `HOLIDAY`
  (Misc, 0), `L12-APP-A/B/C` (*Apprentice*), `L12-G1` … `L12-G8` × 3, `SUB` (Misc, 200). **No
  `L12-G9` and no `L12-APP1..6`** — the screenshot predates the 2026-06-06 changes in §4. Two
  differences from the 2026-07-02 extract:
  1. **Descriptions were rewritten between the two.** On screen: G1 *80 Below Oiler* · G2 *80
     Above-Oiler* · G3 *40 Below-Operator* · G4 *80 Below-Operator* · **G5 *2 Ops
     Required-Operator*** · G6 *200 Below-Operator* · G7 *350 Below-Operator* · **G8 *350
     Above-Mech-Operator***. §4 has G5 as *Tower OP up to 200T* and G8 as *OP & Tower OP
     >350T–550T*. The band a code covers did not move; the wording did — G5's older name says a
     two-operator requirement, not a tower crane.
  2. **Every `L12-G` straight-time rate is exactly $1.00 lower than §5** (G1 66.03 → 67.03 … G7
     68.66 → 69.66, G8 69.16 → 70.16); `HDR-A` 71.16, `L12-APP-A` 40.90 and `SUB` 200 are
     unchanged. `-B` = 1.5× and `-C` = 2× hold in both. A flat $1.00/h L12 increase landed
     between the screenshot and 2026-07-01; the deck does not date itself, so which increase is
     not stated.
- **Craft Modifier (slide 18 — *"used for qualifying additional pay"*).** Columns **Craft
  Modifier · Description · Pay Rate Change ST · Pay Rate Change OT · Pay Rate Change DB · Status.**
  Two families in **20-foot boom-length bands from `080-100Ft` to `581-600Ft`**: **`OI-BP-01…26`
  (Oiler)** at **+$0.25 ST per band** (0.250, 0.500, … 6.500), and **`OP-BP-01…`(Operator)** at
  **+$0.75 ST per band** (0.750, 1.500, 2.250, 3.000 …); OT = 1.5× and DB = 2× of the ST change
  on every row. Slide 24's **Craft Craft Modifier** master (**Craft Modifier · Description · Status
  ·** audit columns) dates them: `OI-BP-01..15` created 04/10/2020; **`OI-BP-16..17` created
  01/20/2026 and `OI-BP-18..26` created 02/05/2026**, all rows modified on one of those two dates.
  So the bands above 380 ft were added in January–February 2026, which is the 18-vs-26-bracket
  discrepancy [source-attribution-and-conflicts.md](source-attribution-and-conflicts.md) records
  and the rate table behind [PAY-011](rules/PAY-011-l12-modifier-boom-rate.md).
- **Payroll Defaults (slide 19 — *Union Payroll Defaults*).** The L12 values, which the guide's
  section leaves blank: Split Multiple Days ☐ · **OT Eligible = `Day`, 8.00 Hrs · DT Eligible =
  `Day`, 12.00 Hrs** · Include ST Hours in Time Slot overlap ☐ · **Saturday = `OT All Time`** ·
  **Sunday = `OT After Hrs Worked`, 0.00 Hrs, OR `DT All Time`** (both boxes populated; the screen
  does not say which governs) · **Time Round To `30` Mins.** · *Time Slots*: **Monday 12:00 AM –
  06:00 AM `OT`, Monday 05:00 PM – 11:59 PM `OT`, Tuesday 12:00 AM – 06:00 AM `OT`, Tuesday 05:00
  PM – 11:59 PM `OT` …** (the grid scrolls; later weekdays not visible) · *Exclude Craft Codes*
  empty. This is FCC's encoding of daily OT after 8 / DT after 12, Saturday all-OT, Sunday DT, and
  an **overtime window before 06:00 and after 17:00 on weekdays**.
- **Slide 20 — `Maintain File Links – Union Codes`**, headed *Union-L12*: File Name · Comments ·
  Created By · Modified By · Created / Modified Date; empty.

### Craft Codes (slide 22 — the A/B/C annotation)

Columns: **Craft Code · Description · Pay Type · Prompt Text · Apply Burden ☑ · Apply W/C ☑ ·
Apply Union ☑ · Acct Pay Type · Default Sales Acct For T&M & Service Invoices · Exempt Apprentice
% Factor ☐ · Status.** *Pay Type* values on screen: `Regular Earnings · Overtime Earnings ·
Doubletime Earnings · Salary · Misc - Other`. *Prompt Text* is `Hours` on every visible row. *Acct
Pay Type* (`HOURLY / OVERTIME / DOUBLETIME`) is filled **only on `L12-*` codes** and blank on
`ADMIN-*`, `HDR-*`, `CRANE SUP`, `HOLIDAY` and `L12-BG-*`. All three *Apply* boxes are ticked on
every visible row, `ADMIN-*` included. *Exempt Apprentice % Factor* is unticked on all. *Default
Sales Acct* is blank on all.

> **⚠️ Contradicts §4.** That section groups `HDR-*`, `CRANE SUP` and `L12-BG-*` with the
> *"inactive legacy"* codes. On this screen **`HDR-A/B/C` (*Mech*), `CRANE SUP` (*Crane Super*,
> Pay Type `Salary`) and `L12-BG-A/B/C` (*BG*) are all `Active`**; only `DRIVER-*` and `OILER-1-*`
> show `Inactive`. `HDR` also carries live union rates on slides 17 and 26. Either the three were
> inactivated between the screenshot and the July extract, or §4 over-grouped them. The July
> `CRAFTS` sheet is the place to check.

### The remaining lookups (slides 27–34)

- **Non-Union Billing Rates** (27) and **Employee Pay Rates** (28) — shapes given under *Rates*
  above; both empty.
- **Workers Comp Codes** (29): **Code · Description · Amount Per Thousand · Status** — **`CLERICAL`
  Office 1.8000 · `OPERATOR RATE` Operator Rate 48.4000 · `SALESMEN` Salesmen 1.8000 · `YARD
  RATE` Yard Rate 48.4000.** Four codes, a rate per $1,000 of payroll. New to the vault — §7 only
  names the template sheet.
- **Certifications By Employee** (30 — *"Report view"*): a **Certificate Name** filter (dropdown;
  *Drivers License* selected) over **Employee Name · Certificate Numb · Issue Date · Expire Date ·
  Link To · Certificate Type · Status** / **Comments.** It lists every holder of the chosen
  certificate with their licence number — **PII, not copied.** Several rows show a **four-digit
  number in the *Employee Name* column** instead of a name, while the Employees screen's example
  uses a two-letter Employee ID: two identifier styles coexist in the live data. The deck does not
  explain either.
- **Employee Down Reason** (31): **`DC` Cust Payroll · `ML` Maternity Leave · `DO` Off · `DS` Sick
  · `DV` Vacation.** New. Note that *Maternity Leave* exists here as a down reason although
  [hr-onboarding-and-employee-forms.md](hr-onboarding-and-employee-forms.md) §4.1 finds no
  classification for it. What *Cust Payroll* means as a reason for an employee being down is not
  stated.
- **Marital Status** (32): `M` Married · `S` Single. **Ethnicity** (33): the seven codes of §6,
  `O` Other included — confirming the template's parenthetical is the defect, not the table.
- **Classifications** (34): **Classification Code · Classification Description ·
  Labor/Material/Both · Status**, 24 rows identical to §3. `UseCertifiedPayroll` is not a column
  on this grid — it is set somewhere the deck does not show.

### Where a screenshot contradicts an annotation or this page

| Slide | Annotation or page says | Screen shows |
| --- | --- | --- |
| 9 / §8 | *"need the ability to have multiple Labor Unions"* | A per-employee **Unions** tab with a Primary flag already exists; only the union *code* list is single |
| 17 / §4–§5 | descriptions and rates as of 2026-07-02 | An earlier snapshot: G5/G8 named differently, every `L12-G` ST rate $1.00 lower, no G9 or APP1–6 |
| 22 / §4 | `HDR-*`, `CRANE SUP`, `L12-BG-*` are inactive legacy | All three **Active** |
| 15 / rules | a shift premium is paid | L12's six shift-premium cells are all `$0.00` in FCC |
| 3 / §7 | `Apprentice %` and `Registration Number` on the employee | Only a **Union Apprentice** checkbox is on the Addtional Info tab |
| 2 / §7 | template field list | **Over Scale ST/OT/DB**, **Minimum Rate**, **Payroll Exported**, **Class ID** are on screen and not in §7 |

Nothing was unreadable. The Craft Modifier, Craft Codes and Payroll Defaults grids are cropped by
scrolling (the operator bands end at `OP-BP-04` on slide 18 and `OP-BP-12` on slide 24; craft codes
end at `OILER-1-B`; time slots end at Tuesday).
