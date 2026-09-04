---
title: FCC NexGen database catalogue and migration profiling scripts
source: shared-folder/Project-Repository-2026-09-04/2.0.1_DATABASE-SCHEMA/FCC-NexGen SCHEMA/FCC-NexGen_TABLES_VIEWS.xlsx + 2.1.1_DATA-MIGRATION/NexGenFMS_for_ERP/__VS_CODE_DataMigration/__SQL_FCC_DATABASE/*.sql
migrated: 2026-09-04
updated: 2026-02-18
status: unverified
conflicts_with: []
jira: []
tags: [module/admin, module/all, kind/reference, architecture, data-migration, provenance]
entities: []
---

# FCC NexGen database catalogue and migration profiling scripts

**What this is.** Two related artefacts about the legacy database TCG must migrate off:

1. **`FCC-NexGen_TABLES_VIEWS.xlsx`** — a full object catalogue of the `NexGenFMS` SQL Server
   database, produced by running two T-SQL inventory queries (both included in the workbook) and
   pasting the results back into it.
2. **Seven `.sql` profiling scripts** under `2.1.1_DATA-MIGRATION` — a hand-written toolkit that
   inventories, classifies and tiers the same database for migration planning.

**Why it matters.** The RFP makes "full data migration from the FCC NexGen SQL Server database" a
must-have and asks vendors to say what can be migrated and where the risks are. These files are the
raw material for that answer: what the database contains, how big it is, where the personal and
payroll data sits, and a first pass at what to extract.

> **This is legacy structure, not a target data model.** Nothing here says the new platform should
> mirror any of it. Row data was **not** copied into the vault — only shape, counts and the
> classification scheme.

---

## The database at a glance

> **Real DDL for 40 of these tables** — column types, nullability, primary keys and 2026-06-23 row counts — is in [../payroll/tcg-rawfms-staging-database/ddl/](../payroll/tcg-rawfms-staging-database/ddl/), read from the restored `TCG_RawFMS` staging copy ([../payroll/tcg-rawfms-staging-database/INDEX.md](../payroll/tcg-rawfms-staging-database/INDEX.md)). The workbook below lists names and counts; the DDL is what the columns actually are.

All figures from the workbook's `FCC-NexGen_TABLES_VIEWS_simple` sheet, 692 objects, one schema.

| | |
| --- | --- |
| Schema | **`dbo` only** — every one of the 692 objects |
| User tables | **444** |
| Views | **248** |
| Total columns across tables | **9,096** |
| Total columns across views | 4,232 |
| Total rows across all tables | **≈ 8.54 million** |
| Tables holding data | **226** |
| Tables empty at inventory time | **218** — just under half |
| Object create dates | 2019-04-09 → 2026-02-18 |

**Naming conventions.** Every object is prefixed `FMS_` (Fleet Management System). Views are
uniformly `FMS_VW_*`. Table names are `UPPER_SNAKE_CASE` and read as `FMS_<entity>_<facet>` —
`FMS_JOB_MASTER`, `FMS_JOB_DETAILS`, `FMS_JOB_TICKET_EMP_UNIT`. **A `_MASTER` suffix marks the
header/parent table of an entity and `_DETAILS` its line items** (`FMS_JOB_MASTER` /
`FMS_JOB_DETAILS`, `FMS_QUOTE_MASTER` / `FMS_QUOTE_DETAILS`, `FMS_INVOICE_DETAILS`).

**Entity families**, by count of tables carrying that word: JOB 34 · UNIT 23 · CUSTOMER 20 · USER
14 · INVOICE 13 · WORKORDER 13 · GRID 11 · LABOR 11 · EMPLOYEE 9 · PARTS 9 · QUOTE 9 · BILLING 8 ·
COMPONENT 8 · RESOURCE 8. The GRID and SCREEN families are UI-layout persistence, not business
data.

### The largest tables by row count

| Table | Columns | Rows |
| --- | ---: | ---: |
| `FMS_JOB_UNIT_CHECK_LIST` | 37 | 3,968,608 |
| `FMS_APPLICATION_LOG` | 22 | 1,505,762 |
| `FMS_LABOR_UNION_DETAILS` | 21 | 732,284 |
| `FMS_AUDIT_TRAIL` | 6 | 390,306 |
| `FMS_QUOTE_DETAILS` | 59 | 144,649 |
| `FMS_LABOR_DETAILS` | 67 | 124,725 |
| `FMS_CHECK_LIST_SIGNATURES` | 17 | 121,682 |
| `FMS_JOB_DETAILS` | 70 | 118,580 |
| `FMS_JOB_TICKET_EMP_UNIT` | 42 | 116,978 |
| `FMS_INVOICE_DETAILS` | 91 | 109,213 |
| `FMS_SCREEN_ACCESS` | 27 | 100,741 |
| `FMS_LABOR_PAYROLL` | 82 | 79,374 |
| `FMS_FILELINKS` | 61 | 73,128 |
| `FMS_JOB_MASTER` | 212 | 27,950 |
| `FMS_QUOTE_MASTER` | 121 | 26,371 |

Two observations the numbers make plainly, which no document in the drop states:

- **Checklists dominate the database.** `FMS_JOB_UNIT_CHECK_LIST` alone is 46% of all rows — more
  than every job, quote, invoice, ticket and labour row combined. Any migration plan that treats
  checklist history as ordinary business data is planning to move four million rows.
- **`FMS_SCREEN_ACCESS` has 100,741 rows.** That is the profile-screen-settings model from
  [fcc-nexgen-administration-and-security.md](fcc-nexgen-administration-and-security.md) —
  field-level permissions stored per profile per screen per column — and it is the concrete cost of
  that granularity.

### The widest tables

`FMS_SYSTEM_DEFAULT` **455 columns** · `FMS_JOB_MASTER` 212 · `FMS_COMPANIES` 192 · `FMS_UNITS` 156
· `FMS_JOB_TICKET` 148 · `FMS_EMPLOYEES` 127 · `FMS_QUOTE_MASTER` 121 · `FMS_CUSTOMERS` 101.

A single-row-per-tenant settings table with **455 columns** is worth registering: NexGen's
configuration surface is that wide, and the TCG-annotated Maintain Company deck is a tour of part
of it.

### Column-level conventions

From the workbook's `..._detail` sheet, **all 13,037 column rows across all 692 objects**
(8,843 table columns, 4,194 view columns).

- **User-defined types are the norm, not the exception.** **11,546 of 13,037 columns — 88.6% —
  are declared with a SQL Server UDT rather than a base type**, drawn from **72 distinct UDT
  names**. The most used are `UDT_NO` (1,350), `UDT_MODIFIED_DATE` (1,298), `UDT_BIT_CODE`
  (1,189), `UDT_INT_CODE` (1,053), `UDT_CREATED_BY` (1,017), `UDT_CHAR_NAME` (674), `UDT_DATE1`
  (462), then a family of fixed-width code types — `UDT_CHAR1_CODE`, `UDT_CHAR2_CODE`,
  `UDT_CHAR10_CODE`, `UDT_CHAR30_DESC`, `UDT_CHAR_CODE`. Domain-specific ones include
  `UDT_NUMERIC_RATE` (218), `UDT_PHONE` (182), `UDT_GL_ACCOUNT` (133), `UDT_NUMERIC_EST_AMT`
  (121), `UDT_VARCHAR_EMAIL` (121), `UDT_NUMERIC_REV` (97), `UDT_VARCHAR_URL` (92).
  **The domain vocabulary is encoded in the type system**, which is the single most important
  fact about this schema for a migration: a column's *meaning* is often carried by its type name
  rather than by its column name, and 188 distinct type strings appear in total.
- **Money and measure precision is wildly inconsistent** where base types are used: 22 distinct
  `numeric(p,s)` scales appear, from `numeric(11,3)` to `numeric(31,4)`, plus `numeric(25,14)`,
  `numeric(26,13)` and `numeric(19,9)`, alongside `money` and `float(53)`. Four hand-rolled type
  aliases (`NUMERIC15`, `NUMERIC15_4`, `NUMERIC_15_1`, `NUMERIC_17_2`) sit beside the UDTs doing
  the same job. Anything numeric crossing the migration boundary needs its precision checked
  individually.
- **A uniform audit quartet.** `CreatedDate` (427), `CreatedBy` (422), `ModifiedBy` (419) and
  `ModifiedDate` (419) — and **418 of the 444 tables, 94.1%, carry all four**. 1,431 table columns
  have default constraints, most of them these. Only **17 tables have none of the four**, and they
  are almost all accounting-export staging tables (`FMS_*_EXPORT_MAS90` / `_MAS91`,
  `FMS_VOUCHER_EXPORT_*`) plus `FMS_DATE_DIMENSION` and `FMS_GEOFENCE_NOTIFICATIONS`.
- **Nullability is permissive.** Only **2,167 of 8,843 table columns (24.5%) are `NOT NULL`** —
  three quarters of the schema is optional. Migration validation cannot lean on the source's
  constraints.
- **Recurring business keys** as column names: `Status` (142 tables), `GroupNumb` (112),
  `Description` (73), `JobCode` (64), `Comments` (60), `CompanyCode` (56), `YardCode` (56),
  `EmpID` (49), `CustCode` (35), `SortNumb` (28). **Codes, not surrogate integers, are the join
  keys** — see the key section below.
- **Almost no in-database documentation.** The catalogue has a `Description` column for extended
  properties; it is **empty for all 13,037 rows**. Nothing in this database explains itself.
- Collation is `SQL_Latin1_General_CP1_CI_AS` — **case-insensitive** — on all 4,111 character
  columns that carry one.
- **No computed columns at all** (0 of 8,843). All derivation happens in application code or in
  the 248 views.
- **Almost no binary in the tables.** Despite the classification script's binary detector, only
  **two columns are genuinely binary-typed**: `FMS_SYSTEM_DEFAULT.ITILogo` and
  `FMS_UNIT_COMPONENTS.QRImage`. Attachments are handled by reference — `FMS_FILELINKS`
  (61 columns, 73,128 rows) — not by blob storage. **That matters for migration: the documents
  themselves are not in this database**, only paths to them, which is also why the FCC health
  check worries about drive-letter vs UNC paths.

### Keys and relationships

Now measurable across the whole schema:

- **Primary keys.** **413 of 444 tables have one; 31 do not.** The no-PK set is again dominated by
  accounting-export staging (`FMS_CUSTOMER_EXPORT_MAS90/91`, `FMS_EMPLOYEE_EXPORT_MAS90/91`,
  `FMS_INVOICE_EXPORT_MAS90/91/TRAVERSE`, `FMS_LABOR_EXPORT_MAS90/91`) plus `FMS_DEVICES`,
  `FMS_CUSTOMER_LEGAL`, `FMS_GEOFENCE_NOTIFICATIONS`, `FMS_BARCODE_FIELDS` and
  `FMS_LABOR_DETAILS_OLD`. This is exactly the hazard `TableClassification.sql` warns about —
  "vendor should confirm natural key or legacy identifier strategy".
- **PK shape.** 349 single-column, 53 two-column, 11 three-column. **The three-column composites
  are the association tables** — `FMS_PEOPLE_UNIT_ASSOCIATIONS`, `FMS_PART_YARD`,
  `FMS_GRID_SETTING_YARDS`, `FMS_JOB_FAA_EMPLOYEES`, `FMS_JOB_LOAD_AXLES`,
  `FMS_QUOTE_LOAD_AXLES`, `FMS_FIELDNAMES_SCREEN_COLUMNS`, `FMS_ETS_TICKET_SUB_SECTION`.
- **Identity columns are rare: 174, one per table, in 174 of 444 tables.** The other 270 tables
  key on business codes. This corroborates the code-as-key pattern from the column names.
- **Foreign keys.** **1,476 distinct FK constraints over 1,559 FK columns, in 294 of 444 tables,
  pointing at 186 distinct parent tables.** So two thirds of the schema is relationally wired,
  and 150 tables are not.
- **Referential actions are conservative:** `ON DELETE NO ACTION` on 1,279 FK columns vs
  **`CASCADE` on 280**; `ON UPDATE` is `NO ACTION` on all but 6. Deleting a master record mostly
  fails rather than cascades.
- **The most-referenced parent tables** — effectively the schema's centre of gravity:

  | Parent | Inbound FK columns |
  | --- | ---: |
  | `FMS_EMPLOYEES` | 77 |
  | `FMS_CUSTOMERS` | 74 |
  | `FMS_UNITS` | 59 |
  | `FMS_GL_ACCOUNTS` | 57 |
  | `FMS_YARD_MASTER` | 55 |
  | `FMS_JOB_MASTER` | 55 |
  | `FMS_COMPANIES` | 50 |
  | `FMS_ACTIVITIES` | 45 |
  | `FMS_STATES` | 34 |
  | `FMS_FOOTERS` | 32 |
  | `FMS_DEPARTMENTS` | 30 |
  | `FMS_CUSTOMER_UNITS` / `FMS_WORKORDER_MASTER` | 27 each |

  > **This independently confirms the extract roots.** `LinkedTables.sql` hard-codes Customers,
  > Units and Employees as the three core entities; the FK graph says the same three are the top
  > three most-referenced tables in the database. It also shows what the script's three roots
  > *miss*: `FMS_GL_ACCOUNTS`, `FMS_YARD_MASTER`, `FMS_COMPANIES` and `FMS_ACTIVITIES` are as
  > heavily referenced as Units, and `FMS_JOB_MASTER` more so — none of them is a declared root.

- **The most FK-dependent children** are `FMS_MAT_TRANS` (41 FK columns), `FMS_SYSTEM_DEFAULT`
  (37), `FMS_FILELINKS` (34), `FMS_INVOICE_DETAILS` (32), `FMS_JOB_MASTER` and
  `FMS_LABOR_DETAILS` (30 each), `FMS_COMPANIES` and `FMS_LABOR_PAYROLL` (29 each),
  `FMS_PURCHASE_DETAILS` (28). A row in any of these cannot be inserted until dozens of lookups
  exist — which fixes the load order for any migration.
- **1,380 table columns carry a non-PK index**; only 5 sit in a unique constraint other than the
  primary key. **Uniqueness is almost entirely unenforced below the PK.**

### Data sensitivity across the whole schema

Applying `TableClassification.sql`'s own detectors to all 444 tables, rather than to a sample:

| Classification | Tables |
| --- | ---: |
| General Business Data | 152 |
| Financial | 127 |
| Payroll / Labor | 92 |
| PII / Personal Data | 32 |
| **PII + Payroll** | **21** |
| Security / Access | 12 |
| Documents / Binary | 8 |

> **113 tables trip the payroll/labour detector and 53 trip the PII detector.** That is a quarter
> of the schema carrying personal or payroll signals by column name alone. Any extract touching
> them carries employee PII and must be handled accordingly. **No such data was copied into this
> vault** — this page contains structure and counts only.
>
> The detectors are deliberately broad (`Rate`, `Time`, `Hours`, `AR`, `AP`, `GL` all match as
> substrings), so these counts are an **upper bound for triage**, not an audit finding.

### Views

248 views, all `FMS_VW_*`, 4,232 columns between them — a substantial reporting layer sitting over
the tables. Names visible in the catalogue include `FMS_VW_CERTIFIED_PAYROLL`,
`FMS_VW_COMING_DUE`, `FMS_VW_BARE_RENTAL`, `FMS_VW_BILLING_CODE_HISTORY`,
`FMS_VW_ACTIVITIES_MASTER_LIST`, and a family of certification views
(`FMS_VW_CUST_EMP_CERT`, `FMS_VW_CUST_EMP_UNIT_CERT`, `FMS_VW_CUST_LOC_EMP_UNIT_CERT`,
`FMS_VW_CUST_UNIT_CERT`). The view definitions themselves are **not** in the workbook — only names,
column counts and dates.

---

## The migration profiling scripts

Seven T-SQL scripts, all headed `-- FROM [NexGenFMS]`, all read-only `SELECT`s against system
catalog views. They are a **profiling toolkit, not a migration** — none of them moves data. No
connection strings or credentials appear in any of them.

| Script | What it produces |
| --- | --- |
| `All_Tables.sql` | Exact row counts for every non-system table, via a cursor with `COUNT_BIG(*) WITH (NOLOCK)` and per-table `TRY/CATCH`, then three result sets: everything, tables with data, empty tables |
| `AllColumns.sql` | Full column inventory — resolved data type with length/precision, nullability, identity, computed flag, default definition |
| `PrimaryKeys.sql` | Primary keys and unique constraints, with key columns concatenated in ordinal order |
| `ForeignKeys.sql` | Every FK with child and parent tables and columns, plus `is_disabled` and `is_not_trusted` |
| `InferredLookup.sql` | Candidate lookup relationships **where no FK exists** — matched by column name and type against other tables' PK columns |
| `LinkedTables.sql` | Everything related to three named core entities, tiered for extraction |
| `TableClassification.sql` | The classification scheme below — the most consequential of the seven |

### The classification scheme (`TableClassification.sql`)

For every table it derives three judgements from row counts, column-name patterns, table-name
patterns, PK presence and FK degree. This is the **shared vocabulary any migration conversation
should use**, and it is written down nowhere else in the vault.

**`TableRole`**, evaluated in order — the first match wins:

`Permission / Access Review` (row count failed) → `Empty / Dormant` (zero rows) →
`Audit / Log / History` → `Attachment / Binary / Document` → `Security / Admin` →
`Lookup / Config` (name matches `_TYPE`, `_STATUS`, `_CATEGORY`, `_CLASS`, `_CODE`, `_STATE`,
`_COUNTRY`, `_CRAFT`, `_CURRENCY`) → `Possible Lookup / Master Reference` (inbound FKs and 1–10,000
rows) → `Master Data` (customer/employee/equipment/unit/vendor/contact/company/yard) →
`Transaction / Operational` (job/ticket/invoice/payroll/trans/order/quote/activity/check_list) →
`Bridge / Mapping / Detail` (two or more outbound FKs) → `Unknown / Needs Review`.

**`DataSensitivity`**: `PII + Payroll` → `Payroll / Labor` → `PII / Personal Data` → `Financial` →
`Security / Access` → `Documents / Binary` → `General Business Data`. PII is detected by column
names containing SSN, Social, Birth, DOB, Driver, License, Phone, Email or Address; payroll by
Payroll, PayRate, Rate, Wage, Salary, Hours or Time; financial by Amount, Price, Cost, Invoice, AR,
AP, GL or Tax.

> **The PII detector is the reason this catalogue matters for handling.** It flags, by name alone,
> which of the 444 tables hold personal and payroll data. Any extract from those tables carries
> employee PII and must be handled accordingly. **No such data was copied into this vault.**

**`SuggestedMigrationDisposition`**: `Need Access Review` · `Do Not Extract Now / Keep in
Inventory` (empty) · `Archive / Reference Only` (logs, audit, history) · `Review Carefully /
Usually Do Not Migrate Directly` (users, access, security, profile, screen) · `Archive or Migrate
Separately` (attachments and binaries) · `Reference / Config Mapping` (lookups) · `Likely Migrate /
Business Review` (the master and transaction families) · `Business Review Needed`.

**`ReviewNotes`** flags three specific hazards: a table whose rows could not be counted "is not
safe to assume empty or irrelevant"; a table with **no primary key** means "vendor should confirm
natural key or legacy identifier strategy"; and a table with **no FK relationships** may still have
them "logically in application code".

### Core-entity tiering (`LinkedTables.sql`)

Three entities are hard-coded as the roots of the extract:

```
Customers → dbo.FMS_CUSTOMERS
Units     → dbo.FMS_UNITS
Employees → dbo.FMS_EMPLOYEES
```

Everything else is attached to one of the three by declared FK, by column match, or by table-name
keyword (customer/cust/bill_to/job_site/contact → Customers; unit/equip/crane/truck/trailer/vehicle
→ Units; employee/emp/craft/payroll/operator/driver → Employees), then labelled
**`Tier 1 – Core Master`**, **`Tier 2 – Direct Related / Lookup`** or **`Tier 3 – Candidate
Related`**, with a `Confidence` of `Confirmed` (FK-backed) or `Candidate - Review` (name-matched).

The resulting `SuggestedFirstExtractDecision` is: **Include** (Tier 1) · **Include / Review**
(confirmed and non-empty) · **Review Before Include** (candidate and non-empty) · **Do Not Extract
Now / Keep in Inventory** (empty) · **Need Access Review** (count failed).

> Note what the three roots imply: the first extract is scoped to **customers, units and
> employees** — master data — and jobs, quotes, invoices and tickets are reachable only as related
> tables. No document in the drop states this as a decision, and **nothing says who wrote these
> scripts or whether they were ever run against production.** The workbook, by contrast, plainly
> *was* run: it contains its results.

---

## Source

- `2.0.1_DATABASE-SCHEMA/FCC-NexGen SCHEMA/FCC-NexGen_TABLES_VIEWS.xlsx` — four sheets:
  `SQL_Script_simple-list` (the query, 326 lines), **`FCC-NexGen_TABLES_VIEWS_simple`** (692 object
  rows — the source of every count above), `SQL_Script_list-with-columns` (the second query), and
  **`FCC-NexGen_TABLES_VIEWS_detail`** (declared dimensions `A1:AE13038`, 31 columns of per-column
  metadata).
  Both data sheets were read **complete** — 692 object rows and **all 13,037 column rows** — from
  a full re-conversion of the workbook (`FCC-NexGen_TABLES_VIEWS.xlsx.FULL.txt`, 14,096 lines). An
  earlier partial conversion capped the detail sheet at 4,000 rows; **that cap is gone and every
  figure on this page is drawn from the whole catalogue.** Re-reading in full **changed none of
  the object-level figures** published earlier — 692 objects, 444 tables, 248 views, 8,537,984
  rows, the 226/218 split, `FMS_JOB_UNIT_CHECK_LIST` at 46.5% of all rows, `FMS_SCREEN_ACCESS` at
  100,741 rows — and added the column, key, relationship and sensitivity sections above.
  **No row data from any business table is in this workbook** — it is metadata only.

  **One internal inconsistency in the workbook itself**, visible only on a full read: the two data
  sheets were produced by two different queries and **disagree about column counts for 135 of the
  692 objects** (102 tables, 33 views). The `_detail` sheet is always the lower of the two — 13,037
  column rows against the `_simple` sheet's declared 13,328, a shortfall of 291 columns, largest on
  `FMS_JOB_MASTER` (212 declared, 189 enumerated), `FMS_JOB_TICKET` (148 / 133),
  `FMS_UNIT_COMPONENTS` (75 / 51) and `FMS_USER_LOOKUP_FILTERS` (20 / 6). **The workbook does not
  say why**, and the two SQL scripts it embeds carry no capture dates. The most likely reading is
  that the sheets were captured at different times against a changing schema, but that is
  inference. Column-level percentages above are over the 13,037 rows that exist; object-level
  counts use the `_simple` sheet.
- `2.1.1_DATA-MIGRATION/NexGenFMS_for_ERP/__VS_CODE_DataMigration/__SQL_FCC_DATABASE/` — seven
  files, 1.1–18.0 KB, copied as-is: `All_Tables.sql`, `AllColumns.sql`, `PrimaryKeys.sql`,
  `ForeignKeys.sql`, `InferredLookup.sql`, `LinkedTables.sql`, `TableClassification.sql`. All
  read-only; **no credentials or connection strings present**. Their *output* is not in the drop —
  only the scripts.
