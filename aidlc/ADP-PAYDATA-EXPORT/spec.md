# Spec — ADP-PAYDATA-EXPORT (provisional id) — generate the real ADP paydata import file

> Written to `.ai/aidlc/ADP-PAYDATA-EXPORT/spec.md` by the elaborator. **No `intent.md` exists** and
> **no Jira/Linear ticket exists** — the request came as a prompt. **A real ticket id is owed**
> (Q17); rename the folder when it exists. Nothing here has been built, and nothing will be built
> by the elaborator.
>
> Reading rules used: every source line carries a status tag. Code is cited only descriptively
> (current behaviour, ripple). Meetings are cited as context for a question, never as the source of
> a requirement (elaborator §4).

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `ADP-PAYDATA-EXPORT` — **provisional; no ticket exists; real id owed (Q17)** |
| Intent | none on file. Request text: the payroll ADP export must produce the real ADP paydata import file (`EPI4RZnn.csv` / xlsx, company `4RZ`) matching the sample exports, not the human-readable breakdown emitted today |
| Elaborated on | 2026-10-15 |
| Vault state at elaboration | `domain/` six files verified, everything else `[UNVERIFIED]`. Every payroll/ADP source below is `status: unverified` or `reference` (not human-adjudicated). 0 `[VERIFIED]` sources used |
| Open questions raised by this spec | 18, all in §12 |
| Already-shipped behaviour reached | 8 consumers in §11a; 6 with no source for what happens to them |
| Rules consulted | `CLAUDE.md` (Architecture, Identity, Developers decide structure, Siblings); `.ai/claude/contexts/api.md`, `payroll-engine.md` named by `CLAUDE.md` as binding on `packages/payroll-engine/` — **not opened in this run (gap in my reading; executor must open before building)**; `patterns.md` searched for an export/CSV entry: none |

**Sources read.** `payroll/adp-workbook-v5.1-engine.md` (15 KB, 2026-09-06), `payroll/adp-workbook-column-rules.md` (13 KB, 2026-09-08), `payroll/adp-workbook-power-query-engine.md` (16 KB, 2026-09-08; §1, §2–§6 only), `payroll/adp-workbook-vba-macros.md` (7 KB, 2026-09-08; §2), `payroll/adp-sop-v5.1.md` (18 KB, 2026-09-06; §6.2 + "What the SOP does not say"), `payroll/adp-bucket-crosswalk.md` (23 KB, 2026-08-18), `payroll/adp-hour-earning-codes.md` (3.7 KB, 2026-06-04, **superseded** header), `payroll/adp-api-responses/pay-data-input-meta.md` (12.6 KB, 2026-08-13, `reference`), `payroll/rules/PAY-067-adp-export.md` (7.5 KB, `status: conflicted`, 2026-08-27), the three `payroll/sources/*.csv.md` stubs, `payroll/gaps.md` by heading (lines 78, 802, 1950, 3051, 3077, 4243, 4811, 4829), `meetings/2026-09-28-adp-integration-sync-…md` §1.4–1.6, §2, §5.2 (19.7 KB, context only).

**Not available.** The sample files themselves are redacted out of the vault; only column lists, counts and code lists survive (`payroll/sources/EPI4RZ36.csv.md`, `EPI4RZ32.csv.md`). Byte-level facts — quoting, line endings, encoding, trailing newline, header casing — are **NOT SPECIFIED**; the only description of them is the VBA exporter's comments (§2 REQ-08). I did not open the `~/Downloads/EPI4RZ*.xlsx` files: they are not vault sources, and may hold real pay data.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | The deliverable is the ADP paydata import file | api | `[CONFLICT]` | PAY-067, read-write-boundary, SOP v5.1 §6.2 | **yes** (Q1) |
| REQ-02 | Container is CSV | api | `[UNVERIFIED]` | SOP v5.1, VBA §2 | no |
| REQ-03 | An xlsx form of the import file | api | `[OPEN]` | none | **yes** (Q2) |
| REQ-04 | File name `EPI` + `4RZ` + 2-digit week | api | `[UNVERIFIED]` | SOP v5.1, PQ engine §2 | **yes** (Q3) |
| REQ-05 | Batch ID derivation | api | `[OPEN]` | none sufficient | **yes** (Q3) |
| REQ-06 | Co Code `4RZ` | api | `[UNVERIFIED]` | PQ engine, API meta, PAY-067 | no |
| REQ-07 | File # | api | `[CONFLICT]` | PAY-006 gap, crosswalk, API-regex gap | **yes** (Q4) |
| REQ-08 | Column set, order, pair omission, zero blanks | api | `[UNVERIFIED]` | v5.1 engine §1, VBA §2, crosswalk rules 4–6 | no |
| REQ-09 | Reg Hours / O/T Hours | api | `[UNVERIFIED]` | crosswalk, PQ engine §3 | no |
| REQ-10 | Hours-3 pairs: DT, HOL | api | `[UNVERIFIED]` | PQ engine §3–4, crosswalk | no |
| REQ-11 | H2x / Special Saturday / 2x boom hours | api | `[OPEN]` | none sufficient | **yes** (Q8) |
| REQ-12 | Temp-rate rows and the Hours-4 slot map | api | `[UNVERIFIED]` | PQ engine §4, v5.1 engine §1 | no |
| REQ-13 | Boom codes LBH/LBO/LBD/LBT and their Temp Rate | api | `[UNVERIFIED]` | column-rules, PQ engine §3 | no |
| REQ-14 | Lattice, shift, foreman, military code families and temp rates | api | `[UNVERIFIED]` | PQ engine §3, v5.1 engine §1/§5 | no (but see REQ-15) |
| REQ-15 | Attributing premium hours to buckets; operator vs oiler | api, shared | `[OPEN]` | none | **yes** (Q10, Q11) |
| REQ-16 | BASE_RATE_OVERRIDE rows | api | `[OPEN]` | none sufficient | **yes** (Q12) |
| REQ-17 | Subsistence as Earnings 3 `SUB` | api | `[UNVERIFIED]` | crosswalk, PQ engine §3 | no |
| REQ-18 | Sick hours as trailing Hours-3 `SIC` | api | `[OPEN]` | none for the ERP source | no for worked-time scope (Q15) |
| REQ-19 | Guarantee top-ups, rest premium, WTL, Special Saturday dollars, added hours | api | `[OPEN]` | none | **yes** (Q5–Q9) |
| REQ-20 | Row types and row order | api | `[UNVERIFIED]` | v5.1 engine §1–§2 | no |
| REQ-21 | Pre-export validation that refuses | api | `[UNVERIFIED]` | PQ engine §6, v5.1 engine §1–2, crosswalk rule 7 | no |
| REQ-22 | Which employees are in the file; salary | api | `[OPEN]` | conflicting context only | **yes** (Q13, Q14) |
| REQ-23 | What happens to today's readable workbook, per-employee export and web download | api, web | `[OPEN]` | none | **yes** (Q16) |

Counts: `23` total — `0` verified, `12` unverified, `2` conflicted, `9` open.

## 2. Requirements

### REQ-01 — The deliverable is the ADP paydata import file `[CONFLICT]`

- **Statement:** The system's payroll export for a period produces the file TCG imports into ADP Workforce Now (Payroll Dashboard → Manage payroll → Import file) for company `4RZ`.
- **Surface:** api
- **Sources:**
  - `payroll/adp-sop-v5.1.md` §6.2 — `[UNVERIFIED]` — kind: vault — the CSV is imported by drag-and-drop with "Reject values…" selected; ADP opens the Worksheet page for review.
  - `payroll/rules/PAY-067-adp-export.md` — `[UNVERIFIED]`, `status: conflicted` — kind: vault — rule: "Validate mappings and generate export-ready records"; the interim path is "manual CSV upload in the ADP browser UI … the bridge for the manual-CSV-upload interim is this workbook".
  - `payroll/gaps.md` → *Excel or API — the ADP submission path is not decided* (line 802) — `[UNVERIFIED]` — kind: vault — status open; "these are alternatives, not stages".
- **Conflict:** `payroll/gaps.md` line 802 and `PAY-067` *Open → Conflict*. Candidates: (a) the target design in the FRD/matrix, which "assumes API submission" (`payroll/erp-payroll-module-frd/10-approval-close-export-and-adjustments.md` `PR-055`, 2026-08; `payroll/codingcops-rule-matrix.md` `PR-067`, 20.8 KB); (b) `payroll/adp-read-write-boundary-2026-08-18.md` (21.9 KB, 2026-08-18, `reference`) — payroll-output write is Marketplace-partner-gated; (c) the interim CSV-in-browser path, and the Confluence "Payroll management" page staged at `sync/.conflict/2026-08-24-bootstrap/payroll-management.md` (9.8 KB, 2026-08-24). None is verified. **This spec does not choose.** Every requirement below that describes the file contract (REQ-02 to REQ-21) is conditional on the file path surviving; it is "what the ERP must reproduce if the interim CSV path is kept" (gaps line 802, update 2026-09-04).
- **Open question:** Q1 — is the CSV file the build target, with the API deferred?
- **Ripple:** see §11a (rows R1–R8). The decision in Q1 changes whether anything in the export surface is kept.
- **Acceptance:** `OPEN — cannot be stated until Q1 is answered.`
- **Notes for the executor:** blocked. Meeting `meetings/2026-09-28-adp-integration-sync-…md` §2 records that for the API route "Corrina still approves" a worksheet — context only, it decides nothing.

### REQ-02 — Container is CSV `[UNVERIFIED]`

- **Statement:** The ADP import file is a comma-separated text file whose extension is `.csv`.
- **Surface:** api
- **Sources:**
  - `payroll/adp-sop-v5.1.md` §6.2 — `[UNVERIFIED]` — kind: vault — "click the green CSV button"; the CSV is dragged into ADP.
  - `payroll/adp-workbook-vba-macros.md` §2 — `[UNVERIFIED]` — kind: vault — exporter forces the `.csv` extension; numbers are written invariant-culture; fields CSV-quoted when needed.
- **Conflict:** none.
- **Open question:** Q2 (xlsx), Q3 (name). Encoding, delimiter escaping beyond "quoted when needed", line ending, BOM and trailing newline: `NOT SPECIFIED`.
- **Ripple:** §11a R1, R2 (today's endpoints return xlsx and a csv of the readable layout).
- **Acceptance:** a file produced for a period has a `.csv` extension and imports into ADP without "Reject values" rejections — verified by a human with ADP access (no automated oracle exists; the vault holds no ADP import-spec document, see Q18).
- **Notes for the executor:** the vault mentions ADP's generic *Importing Paydata* guide (`wfn_importing_paydata.pdf`, `payroll/source-manifest.md`) and that Brian has import-specific documentation (meeting 2026-09-28 §1.6). Neither is in the vault in readable form. Ask for it before building.

### REQ-03 — An xlsx form of the import file `[OPEN]`

- **Statement:** `OPEN — the request names "csv / xlsx"; no source says ADP imports xlsx, or that any xlsx form of the paydata file is wanted.`
- **Surface:** api
- **Sources:** none — searched: `adp-sop-v5.1.md` §6.2 (CSV only), VBA §2 (extension forced to `.csv`), `adp-workbook-v5.1-engine.md` (the workbook's `ADP_PREVIEW` is a review sheet, not an import), the three sample stubs (all `.csv`/`.CSV`), `grep -n -i xlsx payroll/gaps.md`. "Nothing written" is the finding. The existing xlsx is the readable review layout.
- **Conflict:** n/a
- **Open question:** Q2.
- **Ripple:** `OPEN — see Q16.` The xlsx endpoint and the web download (§11a R1, R4) exist today and name `.xlsx`.
- **Acceptance:** `OPEN — cannot be stated until Q2 is answered.`
- **Notes for the executor:** blocked.

### REQ-04 — File name `EPI` + `4RZ` + two-digit week `[UNVERIFIED]`

- **Statement:** The file is named `EPI4RZnn.csv`, where `nn` is the payroll week.
- **Surface:** api
- **Sources:**
  - `payroll/adp-sop-v5.1.md` §6.2 — `[UNVERIFIED]` — kind: vault — "'EPI' is the type of file, '4RZ' is our company code, and the last two digits are the payroll week."
  - `payroll/adp-workbook-power-query-engine.md` §2 — `[UNVERIFIED]` — kind: vault — `ADP File Name` = `EPI4RZnn`; the counter restarts every payroll year, so names repeat across years (`EPI4RZ01` names 2025-07-05 and 2025-12-20).
  - `payroll/sources/EPI4RZ36.csv.md`, `EPI4RZ32.csv.md` — `[UNVERIFIED]` — kind: vault — week-36 file covers 2026-08-22 → 08-28; week-32 file covers July 25–31.
- **Conflict:** none between vault files, but the vault is **internally inconsistent about `nn`**: week 36 for 2026-08-22 does not fit the PQ engine's own rule ("week 01 begins on the first Saturday on or after January 1" — first Saturday of 2026 is Jan 3, and 2026-08-22 is then week 34), and the same page's example puts week 01 at 2025-07-05 *and* 2025-12-20. This spec does not resolve it.
- **Open question:** Q3.
- **Ripple:** §11a R1 — today's name is `EPI4RZ` + the Friday's `YYYYMMDD` (a third scheme); the web download falls back to `EPI4RZ.xlsx`.
- **Acceptance:** `OPEN — cannot be stated until Q3 is answered.`
- **Notes for the executor:** `payroll/adp-workbook-power-query-engine.md` §2 warns the name repeats across payroll years — do not key an archive by file name.

### REQ-05 — Batch ID derivation `[OPEN]`

- **Statement:** `OPEN — the Batch ID is the workbook's "Payroll YrMoWk" (examples 260103, 260936); no source states how year, month and week are derived.`
- **Surface:** api
- **Sources:** none sufficient. `payroll/adp-workbook-power-query-engine.md` §2 names it and gives one example; `payroll/sources/EPI4RZ36.csv.md` gives batch `260936` for 2026-08-22 → 08-28 (payday Thursday 2026-09-03). Whether "Mo" is the month of the week start, week end or payday, and what "week" counts from, is not written. Reading it back from the two examples would be inference.
- **Conflict:** n/a
- **Open question:** Q3.
- **Ripple:** none — new column; `grep -rn -i "batch" packages/payroll-engine/src apps/api/src/usecase/payroll` shows no existing Batch ID concept in the export path.
- **Acceptance:** `OPEN`
- **Notes for the executor:** blocked.

### REQ-06 — Co Code `4RZ` `[UNVERIFIED]`

- **Statement:** Every data row carries Co Code `4RZ` (THE CRANE GUYS LLC).
- **Surface:** api
- **Sources:**
  - `payroll/adp-api-responses/pay-data-input-meta.md` — `[UNVERIFIED]` (`status: reference`, 2026-08-13) — kind: vault — live ADP response: `4RZ` = THE CRANE GUYS LLC, `4RY` = Ventura; `631` is not a company code.
  - `payroll/rules/PAY-067-adp-export.md` — `[UNVERIFIED]` — kind: vault — "Export generation must target 4RZ"; audit for stale `631`.
  - `meetings/2026-09-28-…md` §5.2 — context only — `4RY` described as legacy/dormant.
- **Conflict:** none (the 631/4RZ ambiguity was closed in `payroll/gaps.md` line 78 by the live API pull).
- **Open question:** none.
- **Ripple:** §11a R1 — the company code is already a constant in the export service, used for the filename only.
- **Acceptance:** every row's first field equals `4RZ`.
- **Notes for the executor:** whether the code is a constant or tenant configuration is a §11b decision (D3). `Sample ADP Export - EPI63100.CSV` is the stale `631` file — do not copy values from it.

### REQ-07 — File # `[CONFLICT]`

- **Statement:** Each row identifies the employee by their ADP File #; export is keyed on Co Code + Batch ID + File #.
- **Surface:** api
- **Sources:**
  - `payroll/rules/PAY-067-adp-export.md` — `[UNVERIFIED]` — kind: vault — rows keyed `Co Code + Batch ID + File #`; File # numeric 51–999999 (client message 2026-08-27).
  - `payroll/adp-bucket-crosswalk.md` rule 8 — `[UNVERIFIED]` — kind: vault — text, leading zeros preserved, uppercase alphanumeric, max length 6.
  - `payroll/adp-workbook-vba-macros.md` §1 — `[UNVERIFIED]` — kind: vault — workbook accepts 1–6 ASCII letters/digits.
  - `payroll/adp-workbook-v5.1-engine.md` §1 — `[UNVERIFIED]` — kind: vault — `ADP_PREVIEW` pads File # to six digits; the sheets use the de-padded number. **What the CSV itself contains is not stated.**
- **Conflict:** `payroll/gaps.md` line 4829 (*ADP file number — uniqueness, change policy, and a format conflict*) and line 1950 (*Employee ↔ ADP position*). Candidates: ADP's own regex `^0*(5[1-9]|[6-9][0-9]|[1-9][0-9]{2,5})$` (digits only, ≥51) recorded in `gaps-2026-08-20-retired.md` and client-concurred (`payroll/client-message-findings.md`); `PAY-006`/crosswalk/TCG-169 "≤6 letters or digits". None verified. This spec does not choose.
- **Open question:** Q4.
- **Ripple:** §11a R6 — today's export already refuses employees with no file number.
- **Acceptance:** `OPEN — cannot be stated until Q4 is answered.`
- **Notes for the executor:** one employee may hold several ADP positions (line 1950) — the model has one nullable `adpFileNumber` today.

### REQ-08 — Column set, order, pair omission and zero handling `[UNVERIFIED]`

- **Statement:** The header is `Co Code · Batch ID · File # · Reg Hours · O/T Hours` → Hours-3 Code/Amount pairs 01–03 (DT, HDD, HOL) if used → `Temp Rate` → Hours-4 Code/Amount pairs 01–28 if used → Earnings 3 Code/Amount (SUB) → trailing Hours-3 Code/Amount (SIC); a pair is written only if some row uses it; repeated header names are written literally; zero quantities are blank; code and amount are never sent apart.
- **Surface:** api
- **Sources:**
  - `payroll/adp-workbook-v5.1-engine.md` §1 — `[UNVERIFIED]` — kind: vault — "CSV emission order, from the exporter"; `Temp Rate` written whenever any row carries one; week-36 file has 24 columns.
  - `payroll/adp-workbook-vba-macros.md` §2 — `[UNVERIFIED]` — kind: vault — omits unused pairs; repeated header names exactly as ADP expects; `ReviewRow` and `Name` excluded; quantitative zeros become blanks.
  - `payroll/adp-bucket-crosswalk.md` rules 5–6 — `[UNVERIFIED]` — kind: vault — never a code without its amount; omit zero pairs.
  - `payroll/sources/EPI4RZ36.csv.md`, `EPI4RZ32.csv.md` — `[UNVERIFIED]` — kind: vault — 24 columns / 184 rows / 61 File #s; 16 columns / 176 rows (the stub's verification note says 177) .
- **Conflict:** none. Note the width is **week-dependent** (16 columns in week 32, 24 in week 36), so a fixed header is wrong.
- **Open question:** none for layout. The `EPI63100` sample is a different single-column "!"-prefixed layout, not recorded — Q18.
- **Ripple:** §11a R1, R2 — replaces the 28-column readable layout.
- **Acceptance:** for a fixture period, the produced header and column order equal `EPI4RZ36.csv`'s when the same pairs are used; a pair no row uses is absent; no zero appears in a quantity or amount field.
- **Notes for the executor:** the real files are not in the repo, so a golden-file test needs the client's file, redacted or synthetic — ask (Q18). The "SIC after SUB" order is inherited and "unexplained in either version" (v5.1 engine §1).

### REQ-09 — Reg Hours / O/T Hours `[UNVERIFIED]`

- **Statement:** The primary row carries one week-total of straight-time hours in `Reg Hours` and one of ×1.5 hours in `O/T Hours`.
- **Surface:** api
- **Sources:**
  - `payroll/adp-bucket-crosswalk.md` — `[UNVERIFIED]` — kind: vault — REG/OT, CURRENT-implemented; "aggregate all payable straight-time components into the employee primary ADP row"; non-union CA OT also aggregates to O/T Hours (APPROVED DESIGN).
  - `payroll/adp-workbook-power-query-engine.md` §3–4 — `[UNVERIFIED]` — kind: vault — `ST`→`REG`, `OT`→`OT`; one primary row per employee per week.
  - `payroll/adp-workbook-column-rules.md` — `[UNVERIFIED]` — kind: vault — ST/OT/DT are rate buckets (×1.0 / ×1.5 / ≥×2.0), not clock bands.
- **Conflict:** none.
- **Open question:** whether guarantee or other added hours ride in these columns — Q5 (REQ-19).
- **Ripple:** §11a R1.
- **Acceptance:** for each employee, `Reg Hours` and `O/T Hours` equal the sum of the engine's weekly ST and OT buckets (jobDay-level hours summed across the week).
- **Notes for the executor:** the engine is one-row-per-job-day today; the file is one row per employee-week — aggregation is new.

### REQ-10 — Hours-3 pairs: DT and HOL `[UNVERIFIED]`

- **Statement:** DT hours go in Hours-3 pair 01 with code `DT`; ×3 holiday hours go in Hours-3 pair 03 with code `HOL`.
- **Surface:** api
- **Sources:**
  - `payroll/adp-workbook-power-query-engine.md` §3–4 — `[UNVERIFIED]` — kind: vault — `DT`→Hours 3; `H3x`→`HOL`; fixed order 01 DT · 02 HDD · 03 HOL · 04 SIC.
  - `payroll/adp-api-responses/pay-data-input-meta.md` — `[UNVERIFIED]` (`reference`) — kind: vault — `HDD` = Holiday Double; `HOL` = Holiday Triple (settles D-006).
  - `payroll/adp-bucket-crosswalk.md` — `[UNVERIFIED]` — kind: vault — HOL "CURRENT - verify semantics".
- **Conflict:** none. `adp-hour-earning-codes.md` (superseded) lists `HDD` as default field 4 and `HOL` as 3 — superseded by the live pull; not used.
- **Open question:** none for these two codes. `HDD` is REQ-11.
- **Ripple:** §11a R1.
- **Acceptance:** an employee with DT and holiday-×3 hours in the week produces `DT <h>` and `HOL <h>` pairs in Hours 3.
- **Notes for the executor:** `adp-workbook-column-rules.md` records that weekday DT below 12 h appears often in real weeks, likely a folded-in missed meal (inferred) — the ERP should not need to reproduce that.

### REQ-11 — H2x, Special Saturday and 2x boom hours `[OPEN]`

- **Statement:** `OPEN — the workbook sends the H2x bucket (special Saturday, ×2) as code HDD "Holiday Double"; the crosswalk says Special Saturday needs its own code (D-005, blocking), and Special-Saturday boom hours have no LB code.`
- **Surface:** api
- **Sources:** none sufficient. Searched: `adp-bucket-crosswalk.md` (D-005 open; HDD "verify semantics"), v5.1 engine §4 (client's own mapping table: H2x "maps to HDD/HOL; ADP semantics still need confirmation"), `payroll/gaps.md` line 78 (D-005 still blocking, "None of those codes exist in the live table"), the engine's own comment that the LBH/LBO/LBD/LBT set "has no 2x slot".
- **Conflict:** n/a — a gap, not a disagreement.
- **Open question:** Q8.
- **Ripple:** §11a R1 — today's `h2x` and `lb2x` columns.
- **Acceptance:** `OPEN`
- **Notes for the executor:** blocked. Do not send H2x as HDD pending Q8.

### REQ-12 — Temp-rate rows and the Hours-4 slot map `[UNVERIFIED]`

- **Statement:** For each distinct employee File # + ADP code + temp rate, the file has one further row carrying `Temp Rate` and exactly one Hours-4 Code/Amount pair, with hours summed over the week; the code determines its Hours-4 slot.
- **Surface:** api
- **Sources:**
  - `payroll/adp-workbook-power-query-engine.md` §4 — `[UNVERIFIED]` — kind: vault — one row per `File # + ADP code + Temp Rate`; same code at two rates gives two rows; slots `01 LBH 02 LBO 03 LBD 04 LBT · 05 LPR 06 LPO 07 LPD 08 LPT · 09 LOR 10 LOO 11 LOD 12 LOT · 13 S2R 14 S2O 15 S2D 16 S2T · 17 S3R 18 S3O 19 S3D 20 S3T`.
  - `payroll/adp-workbook-v5.1-engine.md` §1 — `[UNVERIFIED]` — kind: vault — 28 slots: adds `21 FRR 22 FRO 23 FRD 24 FRT · 25 MLR 26 MLO 27 MLD 28 MLT`.
  - `payroll/adp-bucket-crosswalk.md` rule 4 — `[UNVERIFIED]` — kind: vault — only one Hours-4 pair per temp-rate row.
  - `payroll/adp-workbook-column-rules.md` — `[UNVERIFIED]` — kind: vault — "Boom lines group by adder, not by date"; two days on the same bracket merge.
- **Conflict:** none. Meeting `2026-09-28` §1.5 ("a temp rate overrides the base rate for the whole row") agrees in substance and is context only — and it is why one pair per row matters: the temp rate applies to every hour on the row.
- **Open question:** none on the shape. Which ERP hours generate rows — Q10.
- **Ripple:** §11a R1.
- **Acceptance:** an employee with boom hours at two different adders gets two temp-rate rows; same adder across two days gets one row with summed hours; no temp-rate row has more or fewer than one Hours-4 pair.
- **Notes for the executor:** the slot position appears to be a validation (a code in the wrong slot is an ERROR, PQ engine §6) rather than ADP semantics — whether ADP requires the slot is unknown (Q18).

### REQ-13 — Boom codes and their Temp Rate `[UNVERIFIED]`

- **Statement:** Long-boom hours go on temp-rate rows as `LBH` (ST bucket), `LBO` (OT), `LBD` (DT), `LBT` (×3), with Temp Rate = bracket adder × 1 / 1.5 / 2 / 3 respectively.
- **Surface:** api
- **Sources:**
  - `payroll/adp-workbook-column-rules.md` — `[UNVERIFIED]` — kind: vault — table of codes; "the workbook pre-multiplies the adder; ADP does not"; operator adder n × $0.75, oiler n × $0.25 per 20-ft bracket.
  - `payroll/adp-workbook-power-query-engine.md` §3 — `[UNVERIFIED]` — kind: vault — `LB ST/OT/DT/3X` → `LBH/LBO/LBD/LBT` at the row's `LB … Rate`.
  - `payroll/adp-api-responses/pay-data-input-meta.md` — `[UNVERIFIED]` — kind: vault — `LBH/LBO/LBD/LBT` = BOOM REG/OT/DBL/TRI live in 4RZ.
- **Conflict:** none. `adp-hour-earning-codes.md` shows `LBH` long name "LONGBOOM HRLY" — superseded.
- **Open question:** none for LBH–LBT. 2x boom: REQ-11/Q8.
- **Ripple:** §11a R1 (existing `lbSt/lbOt/lbDt/lb3x` and `craftModifier` columns).
- **Acceptance:** a day with 4 boom hours in the ST bucket at a $0.75 adder yields `LBH 4` with Temp Rate `0.75`; the same hours in OT yield `LBO` at `1.125`.
- **Notes for the executor:** boom hours are a subset of worked hours, never extra (column-rules). The per-day adder is derived from the craft modifier; two modifiers the same day produce separate rows (v5.1 engine §3 item 7).

### REQ-14 — Lattice, shift, foreman and military code families `[UNVERIFIED]`

- **Statement:** Premium hours go on temp-rate rows using these code families and temp rates, per hour bucket (ST / OT / DT+H2x / H3x): lattice operator `LPR/LPO/LPD/LPT` at 1.00/1.50/2.00/3.00; lattice oiler `LOR/LOO/LOD/LOT` at 0.50/0.75/1.00/1.50; 2nd shift `S2R/S2O/S2D/S2T` at 3.00/4.50/6.00/9.00; 3rd shift `S3R/S3O/S3D/S3T` at 4.00/6.00/8.00/12.00; foreman `FRR/FRO/FRD/FRT` at 3.00/4.50/6.00/9.00; military `MLR/MLO/MLD/MLT` at 10.00/15.00/20.00/30.00.
- **Surface:** api
- **Sources:**
  - `payroll/adp-workbook-power-query-engine.md` §3 — `[UNVERIFIED]` — kind: vault — `tblCfgADPTempRates` for lattice and shift tokens.
  - `payroll/adp-workbook-v5.1-engine.md` §1, §5 — `[UNVERIFIED]` — kind: vault — `ADP TempRates` has 24 rows; foreman and military values; week 36 shipped `MLR/MLO/MLD` at 10/15/20.
  - `payroll/adp-api-responses/pay-data-input-meta.md` — `[UNVERIFIED]` — kind: vault — all codes live in 4RZ.
  - `payroll/adp-workbook-column-rules.md` — `[UNVERIFIED]` — kind: vault — lattice $1.00 operator / $0.50 oiler, Group 6+ only; shift $3/$4 (MLA).
- **Conflict:** none in the code tables. Two cautions, not conflicts: `LPR` is "Life Post" as a *deduction* in ADP (send only as an earning; `pay-data-input-meta.md`); and the v5.1 engine says the foreman/military multiplied reading is *confirmed* by the configured rates, while the underlying premium page labels it *inferred* (`payroll/foreman-and-military-premiums.md` — not re-read this run).
- **Open question:** how the ERP's hours map onto these buckets — REQ-15, Q10, Q11.
- **Ripple:** §11a R1.
- **Acceptance:** each code resolves to its slot (REQ-12) and temp rate from the table; no `Hours-4` code is emitted outside `earningInputs`-style fields (the CSV has none, but any later API path must be array-aware).
- **Notes for the executor:** the table is configuration, not logic (crosswalk rule 1: effective-dated, not hard-coded `CASE`). Where that table lives is a §11b decision (D1). The values are the workbook's; whether the ERP's engine rates (which fold shift and foreman into the base rate, per the engine's own comments) reconcile with them is a verification the executor cannot make from this spec.

### REQ-15 — Attributing premium hours to buckets; operator vs oiler `[OPEN]`

- **Statement:** `OPEN — the ERP stores lattice, shift, foreman and military hours as one total per day with no bucket split, and cannot say which of the day's ST/OT/DT/H3x hours the premium rides on; and it cannot tell the lattice operator's hours from the oiler's.`
- **Surface:** api, shared (the engine type)
- **Sources:** none. Searched: PQ engine §3 (token × hour bucket → code — the workbook applies the premium to whatever is in each bucket on the row, which says nothing about what the ERP should do), v5.1 engine §4 (client's own board: lattice, shift, foreman, military are `NOT_IMPLEMENTED`/`FUTURE_RECOMMENDATION` in the Payroll App's rules — the legacy app does not compute them), `payroll/gaps.md` line 4811 (TCG-163: the oiler/operator split is "its own ticket, not yet filed"; which cranes trigger the premium is a separate question for Joe and Kyle).
- **Conflict:** n/a
- **Open question:** Q10, Q11.
- **Ripple:** `OPEN — see Q10, Q11`; §11a R1 (the `latticeOper`/`latticeOiler` columns and the code comment documenting TCG-163).
- **Acceptance:** `OPEN`
- **Notes for the executor:** blocked. Do not look at the current ERP behaviour to answer it.

### REQ-16 — BASE_RATE_OVERRIDE rows `[OPEN]`

- **Statement:** `OPEN — the workbook can send a row's ST/OT/DT/H2x/H3x hours with a dollar override in Temp Rate and no Hours-4 pair; whether and from what data the ERP emits such rows is unspecified.`
- **Surface:** api
- **Sources:** none sufficient for a requirement. What is written is the mechanism: `payroll/adp-workbook-v5.1-engine.md` §2 (grouping by File # + override, merge rules, bounds `0 < rate ≤ 999.9999`, five blocking error codes, week 36 carried one at 72.16) — `[UNVERIFIED]`. Purpose: `payroll/gaps.md` line 3077 — open; as of 2026-10-08 at least two purposes (job/craft-group rate; a per-employee "special agreement" at 135.14, one-line Teams answer, not a decision). The ERP has no field for a special-agreement rate (SCRUM-928 / PAY-CC-03, unadjudicated).
- **Conflict:** n/a
- **Open question:** Q12.
- **Ripple:** §11a R1 — if the ERP prices at a labor-entry craft rate different from the employee's ADP base rate and the file sends only hours, ADP pays the employee's own rate. Whether that is acceptable is part of Q12.
- **Acceptance:** `OPEN`
- **Notes for the executor:** blocked.

### REQ-17 — Subsistence as Earnings 3 `SUB` `[UNVERIFIED]`

- **Statement:** Subsistence is sent as one weekly dollar amount per employee in the Earnings-3 pair with code `SUB`, never as hours.
- **Surface:** api
- **Sources:**
  - `payroll/adp-bucket-crosswalk.md` — `[UNVERIFIED]` — kind: vault — "Send one weekly amount using code SUB. Do not send as worked hours"; "confirm taxable/non-taxable setup in ADP".
  - `payroll/adp-workbook-power-query-engine.md` §3 — `[UNVERIFIED]` — kind: vault — `Subsistence` → `SUB`, an Amount, Earnings 3.
  - `payroll/adp-workbook-column-rules.md` — `[UNVERIFIED]` — kind: vault — short $85; long $85 Mon–Fri, $200 Sat/Sun; payable but excluded from final gross.
- **Conflict:** none on the code. A practice-vs-rule conflict (long subsistence paid at $200 on weekdays) is recorded in column-rules *Open questions*; that is a pay-rule question, not an export one.
- **Open question:** taxable/non-taxable treatment is D-009 (Q9).
- **Ripple:** §11a R1 (today's `subsistence` column sums PAY-048/049 amounts per day).
- **Acceptance:** an employee with two subsistence payments in the week has one `SUB` amount equal to their sum, in Earnings 3; no `SUB` hours.
- **Notes for the executor:** the weekly amount is a sum — ADP has one Earnings-3 pair on the primary row (REQ-08).

### REQ-18 — Sick hours as trailing Hours-3 `SIC` `[OPEN]`

- **Statement:** `OPEN — the file has a trailing Hours-3 pair for SIC, but the ERP has no source of paid non-worked hours.`
- **Surface:** api
- **Sources:** none for the ERP side. `payroll/adp-bucket-crosswalk.md` D-007 (open, not blocking worked-time scope): "needs a future/manual input source before generating this bucket"; v5.1 engine §4: `Sick Hrs` is `MANUAL_SOURCE` — "ERP paid-leave source not yet available".
- **Conflict:** n/a
- **Open question:** Q15.
- **Ripple:** §11a R1 — today's `sickHrs` is hardcoded 0.
- **Acceptance:** `OPEN`
- **Notes for the executor:** the smallest slice that does not depend on the answer: emit no `SIC` pair (the layout already omits an unused pair, REQ-08). Labelled a **workaround pending Q15**, not a decision.

### REQ-19 — Guarantee top-ups, rest premium, WTL, Special Saturday dollars, added hours, accumulators `[OPEN]`

- **Statement:** `OPEN — three of the engine's pay results (guarantee top-ups, rest premium, WTL/missed-meal) and the shift hours-add have dollars but no ADP code and no hours column; whether added hours ride the worked-hour codes or their own earning codes is undecided.`
- **Surface:** api
- **Sources:** none. Searched: crosswalk D-002, D-003, D-004, D-005, D-009 (all Open, "Blocks CodingCops: Yes"); `payroll/gaps.md` line 78 (none of those codes exist in the live ADP table; creating one is a manual WFN UI task); line 4243 (*Added hours* — Brian Petros asked on 2026-09-13 that "ADP reported hours" go on the next meeting's agenda; Haris asked Corrina on 2026-09-13 to bring a real ADP week with a guaranteed-hours entry; no answer on file); `adp-workbook-column-rules.md` *Open questions* (three of eleven pay rules have no route to payroll through this file); `PAY-067` *Added hours have no hours column in the export*. The legacy app folds holiday gap hours "reported as DT hours" — that is the legacy, not a decision.
- **Conflict:** n/a — a gap. (Brian's "separate pay component" vs the union BA's "counts toward the 12-hour rung" is a different, open question about thresholds, line 4243.)
- **Open question:** Q5 (guaranteed hours), Q6 (rest premium), Q7 (WTL), Q8 (Special Saturday), Q9 (accumulators / include-in-total-hours), and **added hours carry no hours** (inside Q5).
- **Ripple:** §11a R1 — the current export puts only worked hours in columns; added-hour dollars are in `totalAmount` but travel nowhere.
- **Acceptance:** `OPEN`
- **Notes for the executor:** blocked. The ERP must not report phantom hours as worked to ADP; today that is true "by omission, not by design" (gaps line 4243).

### REQ-20 — Row types and row order `[UNVERIFIED]`

- **Statement:** The file has three row types — `PRIMARY` (one per employee), `TEMP_RATE`, `BASE_RATE_OVERRIDE` — ordered by employee name (upper-case, blanks last), then File #, then PRIMARY / BASE_RATE_OVERRIDE / TEMP_RATE; the row type and the name are not in the CSV.
- **Surface:** api
- **Sources:**
  - `payroll/adp-workbook-v5.1-engine.md` §1 — `[UNVERIFIED]` — kind: vault — explicit review order; `ReviewRow` numbered after sorting so preview and CSV agree.
  - `payroll/adp-workbook-vba-macros.md` §2 — `[UNVERIFIED]` — kind: vault — `Name` and `ReviewRow` stripped.
  - `payroll/adp-workbook-power-query-engine.md` §4 — `[UNVERIFIED]` — kind: vault — within an employee, primary then boom, lattice oper, lattice oiler, 2nd shift, 3rd shift; same code at several rates sorted by rate. (v3.8; v5.1 sort replaces it — the two orders differ; v5.1 is the later source, but the vault does not say v3.8's within-type order still holds.)
- **Conflict:** none stated. Whether ADP requires any order at all: `NOT SPECIFIED`. ADP's worksheet "shows the employee name where the file has the file-number column" (meeting 2026-09-28 §1.6, context only).
- **Open question:** none; ordering beyond the v5.1 rule is `NOT SPECIFIED`.
- **Ripple:** none — new.
- **Acceptance:** for a fixture, rows appear in the stated order and no name or row-type field is in the file.
- **Notes for the executor:** the order is reproduced from the workbook's review convenience; do not present it as an ADP requirement.

### REQ-21 — Pre-export validation that refuses `[UNVERIFIED]`

- **Statement:** The export refuses to produce the file (ERROR) or flags it (WARNING) on the workbook's validation conditions, and produces nothing when any ERROR is present.
- **Surface:** api
- **Sources:**
  - `payroll/adp-workbook-power-query-engine.md` §6 — `[UNVERIFIED]` — kind: vault — 15 checks listed by category (company code, Batch ID, File #s, names, duplicate/missing primary rows, row types, temp-rate codes and rates, Hours-4 slot, one pair per rate row, unpaired fields, DT/HDD/HOL/SIC/SUB in the wrong place, File # vs sheet, hours with no rate, zeros that should be blank).
  - `payroll/adp-workbook-v5.1-engine.md` §1–§2 — `[UNVERIFIED]` — kind: vault — `MISSING_PRIMARY_ROW` → `MISSING_BASE_PAY_ROW`; five `BASE_OVERRIDE_*` ERROR codes and two `SOURCE_BASE_OVERRIDE_*`; 22 codes in all; "no more than one ordinary PRIMARY".
  - `payroll/adp-bucket-crosswalk.md` rule 7 — `[UNVERIFIED]` — kind: vault — every ADP code must be active in the company validation table before export.
- **Conflict:** none.
- **Open question:** the full list of the 22 code names and which are WARNING vs ERROR is **not recorded in the vault** — `NOT SPECIFIED` (Q18).
- **Ripple:** §11a R6 — today's export already refuses employees missing an ADP file number, and incomplete tickets, open flags, recalculation holds and unapproved weeks. These gates are specified elsewhere (payroll-flags decisions) and are not changed here.
- **Acceptance:** a period with an employee missing a primary row, an unpaired code/amount, or a code with no rate produces no file and a message naming the employee.
- **Notes for the executor:** keep the existing refusals (§11a R6); add only the conditions above.

### REQ-22 — Which employees are in the file; salary `[OPEN]`

- **Statement:** `OPEN — which payroll groups appear in the import file, and who owns the salary batch, are unspecified, and the sources disagree about non-union hourly staff.`
- **Surface:** api
- **Sources:** none that decide; the context is conflicting.
  - `payroll/adp-bucket-crosswalk.md` — `[UNVERIFIED]` — Non-Union Admin Hourly is "APPROVED DESIGN" into O/T/DT; Non-Union Admin Salary "OUT OF SCOPE FOR CURRENT IMPORT"; System-Testing-VendorAccess excluded.
  - `payroll/adp-sop-v5.1.md` and `payroll/gaps.md` line 3051 — `[UNVERIFIED]` — salary is entered into ADP separately by Corrina (`SALARY` batch, Manual Entry); post-import edits and additions are not described; open.
  - Meeting `2026-09-28` §1.4, §2 (context only) — three worksheets: Salary sheet holds **all office/admin staff, salaried and hourly**; Field worksheet = union hourly plus non-union yard, made by importing the CSV; phase 1 = union field only, mechanics not yet.
  - `payroll/adp-workbook-v5.1-engine.md` §5 — non-union: workbook applies no group logic.
- **Conflict:** the crosswalk puts Non-Union Admin Hourly in the CSV; the meeting puts admin hourly staff on the hand-keyed Salary sheet. **Not adjudicated.** No `gaps.md` entry names this conflict as such; Q14 is its first statement.
- **Open question:** Q13, Q14.
- **Ripple:** §11a R5 — today's export emits a `NON_UNION_SALARY` row with a `Salary` amount that the paydata layout has no column for, and refuses export if such an employee has no file number.
- **Acceptance:** `OPEN`
- **Notes for the executor:** blocked. Do not decide to drop or keep the salary row.

### REQ-23 — Today's readable workbook, per-employee export and web download `[OPEN]`

- **Statement:** `OPEN — the request replaces the human-readable breakdown, but nothing says whether the readable view is still wanted for review, whether the per-employee export should also become a paydata file, or what the web download should name/serve.`
- **Surface:** api, web
- **Sources:** none. Searched: SOP v5.1 §6.2 (the review step uses `ADP_IMPORT_REVIEW` / `ADP_PREVIEW`, i.e. a readable preview exists in the process being replaced), `payroll/gaps.md` line 802, PAY-067. The vault never says the ERP should drop the review view.
- **Conflict:** n/a
- **Open question:** Q16.
- **Ripple:** §11a R1–R4, R7, R8.
- **Acceptance:** `OPEN`
- **Notes for the executor:** blocked.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** `NOT SPECIFIED` — depends on §11b D1 (where the code/rate mapping lives) and Q4 (multi-position File #s), Q12 (special-agreement rate), Q5–Q9 (new ADP codes).
- **Migration required:** no, unless D1 chooses a table. If yes, `pnpm db:migrate`, committed (`.ai/claude/contexts/prisma.md`).
- **Data backfill required:** `NOT SPECIFIED`
- **Existing models considered:** `model Employee` (`adpFileNumber String? @db.VarChar(50)`, `schema.prisma:4180`) — holds File #, no uniqueness, no position; `model PayrollPeriod` (`schema.prisma:5370`; `periodCode`, `weekStart`, `weekEnd`, `status`) — the only period record, has no Batch ID or ADP week field; the persisted payroll run/components (comment at `schema.prisma:5723`, `5925`: "the ADP workbook builder filters components by rule id"). `grep -n -i adp apps/api/prisma/schema.prisma` found no ADP code, rate or slot table. No config model for the mapping exists.
- **New prefix introduced:** no

## 4. API surface — `apps/api`

- **Pattern:** none — `patterns.md` was searched for `export`/`csv`; no entry.
- **Existing functions/services to reuse:** `PayrollService.exportWorkbook` / `exportEmployeeWorkbook` (`apps/api/src/usecase/payroll/payroll.service.ts:1564`, `:1612`) already gate on calculated, approved, no open flags/incomplete tickets/hold; `findEmployeesMissingAdpFile` (`packages/payroll-engine/src/xlsx-rows.ts`) already lists employees with no File #; `buildAdpWorkbook` / `csvField` (`apps/api/src/usecase/payroll/payroll-export.ts`) already does RFC 4180 quoting.
- **New exported functions/services proposed:** none proposed by the elaborator — see §11b D2–D4.
- **Request/response, guards, errors:** existing `GET /v1/payroll/periods/:id/export` and `/export.csv` (`payroll.controller.ts` ~251/269) guard with `@RequirePermission('payroll-admin','edit')`. Response shape for the new file, errors and any route change: `NOT SPECIFIED` — D4.
- **Module registration:** N/A unless D2 adds a module.

## 5. Web surface — `apps/web`

`NOT SPECIFIED`. Only consumer: `features/payroll/services/payroll.service.ts` `downloadExport` (see R4). Whether the UI changes (button label, file name, which format) is Q16. No copy is proposed.

## 6. Mobile surface — `apps/mobile`

`N/A — grep found no export consumer` (`git grep -n -E "/export|exportWorkbook" -- apps/mobile` returned nothing).

## 7. Shared package — `packages/shared` / `packages/payroll-engine`

- `AdpWorkbookRow` and `toAdpWorkbookRows` are exported from `@tcg/payroll-engine` (`index.ts`). Whether the new file shape lives there (pure TS, testable) or in the API is §11b D2. Changing or replacing the exported type reaches every importer (R3).
- `packages/shared`: `NOT SPECIFIED` (no type proposed).

## 8. Permissions and tenancy

- **Roles permitted:** unchanged (`payroll-admin` `edit`) — existing behaviour; whether it should change: `NOT SPECIFIED`.
- **Tenant isolation:** standard (export reads the tenant's period). The company code `4RZ` is a TCG-wide constant today — whether it is per-tenant: D3.
- **Cross-tenant reads:** none.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| File # | `NOT SPECIFIED` — sources conflict (REQ-07) | — | `[CONFLICT]` |
| Temp Rate (override) | `0 < rate ≤ 999.9999` | `payroll/adp-workbook-v5.1-engine.md` §2 | `[UNVERIFIED]` — applies only if REQ-16 is ever built |
| Hours / amounts decimal places | `NOT SPECIFIED` | — | — |
| Co Code | equals `4RZ` | `payroll/adp-api-responses/pay-data-input-meta.md` | `[UNVERIFIED]` |

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit | header/column order/pair omission and zero-blanking against a fixture | REQ-08 |
| Unit | temp-rate grouping by File # + code + rate | REQ-12, REQ-13 |
| Unit | one pair per temp-rate row; one primary per employee | REQ-12, REQ-21 |
| Integration (API) | export refused while any ERROR condition holds | REQ-21 |
| Manual (human with ADP access) | file imports with "Reject values…" and the Worksheet matches | REQ-02, REQ-08 |

- Requirements with no testable acceptance criterion: REQ-01, REQ-03, REQ-05, REQ-07, REQ-11, REQ-15, REQ-16, REQ-18, REQ-19, REQ-22, REQ-23 (the `[OPEN]` and `[CONFLICT]` set).
- No golden file exists in the repo (samples are redacted out of the vault).

## 11. Non-functional

- **Performance:** `NOT SPECIFIED`
- **Concurrency:** `NOT SPECIFIED`. The existing export stamps the period `EXPORTED` as a side effect, and "once EXPORTED nothing in it can be priced again" (code comment) — keeping that stamp for the new file is not sourced (Q16).
- **Audit / activity log:** `NOT SPECIFIED`
- **Migration/rollout order:** `NOT SPECIFIED`. A parallel run against the workbook is implied by the vault ("which ADP totals the ERP is expected to match", gaps line 3051) but is not specified.

## 11a. Ripple — already-shipped behaviour these requirements reach

Enumerated by: `git grep -n -E 'toAdpWorkbookRows|findEmployeesMissingAdpFile|buildAdpWorkbook|exportWorkbook|exportEmployeeWorkbook|AdpWorkbookRow|useExportPeriod|useExportEmployee|downloadExport|EPI4RZ' -- apps packages qa-automation`, plus `git grep -n -E '/export' -- apps/web/src apps/mobile packages/shared qa-automation`.

| # | Existing consumer | Reached via | Req | What happens to it | Source | Enumerated by |
| --- | --- | --- | --- | --- | --- | --- |
| R1 | `PayrollService.exportWorkbook` / `exportEmployeeWorkbook` and the `EPI4RZ<YYYYMMDD>` file name (`apps/api/src/usecase/payroll/payroll.service.ts`) | the 28-column `AdpWorkbookRow` shape | REQ-02–REQ-23 | **OPEN — Q16** | none | grep above |
| R2 | `buildAdpWorkbook` / `csvField` (`apps/api/src/usecase/payroll/payroll-export.ts`) | `COLUMNS` readable layout | REQ-02, REQ-08 | **OPEN — Q16** | none | grep above |
| R3 | `toAdpWorkbookRows`, `findEmployeesMissingAdpFile`, `AdpWorkbookRow` (`packages/payroll-engine/src/xlsx-rows.ts`, `types.ts:313`, `index.ts`); specs `xlsx-rows.spec.ts`, `calculate.spec.ts:989` | exported engine API | REQ-09–REQ-15 | **OPEN — Q16** (replace vs add alongside) | none | grep above |
| R4 | Web `downloadExport` (`apps/web/src/features/payroll/services/payroll.service.ts`, fallback name `EPI4RZ.xlsx`), `useExportPeriod` (`use-payroll.ts:195`), `use-payroll-worklist.ts:255`, `use-payroll-employee.ts:217` | `GET …/export` returning xlsx | REQ-02, REQ-03 | **OPEN — Q16** | none | grep above |
| R5 | `NON_UNION_SALARY` row with `Salary` amount in today's workbook | `toAdpWorkbookRows` | REQ-22 | **OPEN — Q13, Q14** | none | grep above |
| R6 | Export gates (unapproved weeks, open flags, incomplete tickets, recalculation hold, send-backs, missing File #; `payroll.service.ts:1564–1601`) and `adpFileMissingException` | `exportWorkbook` | REQ-21 | unchanged — gates keep applying; the new file adds REQ-21 conditions only | the gates are specified in `.ai/vault/decisions/2026-09-30-incomplete-tickets-block-payroll-and-reviewed-no-change-clears-a-flag.md` and `2026-09-24-payroll-failed-recalculation-keeps-last-good-run-and-blocks-approval.md` (cited by title; not re-read this run) | `sed -n 1564,1605p …/payroll.service.ts` |
| R7 | `GET /v1/payroll/periods/:id/employees/:employeeId/export` (`payroll.controller.ts` ~165) | per-employee workbook | REQ-23 | **OPEN — Q16** | none | grep above |
| R8 | `staircase-seed.service.ts:331` calls `exportWorkbook` | demo/seed path | REQ-23 | **OPEN — Q16** (the seed will now run the new generator; if the generator refuses, the seed fails) | none | grep above |

- **Surfaces with no existing behaviour in this area:** mobile (`git grep -n -E "/export|exportWorkbook" -- apps/mobile` empty); `qa-automation` (`git grep -n -E "EPI4RZ|/export" -- qa-automation` empty); `packages/shared` (no export type).
- **Consumers with no source for what happens to them:** R1, R2, R3, R4, R5, R7, R8 (R6 is the only one with a stated outcome). Each is covered by Q13, Q14 or Q16.

## 11b. Developer decisions — structure is the developer's call

| ID | Decision | Options (with existing code found) | AI note | Chosen | Decided by | Date |
| --- | --- | --- | --- | --- | --- | --- |
| D1 | Where the ADP code / slot / temp-rate mapping lives | (a) constants in the engine package or API (as `ADP_COMPANY_CODE` is now at `payroll.service.ts:119`); (b) a new effective-dated config table — crosswalk rule 1 and rule 12 ask for effective dating; no ADP table exists (`grep -n -i adp schema.prisma`) | Crosswalk rules 1 and 12 point to (b); (a) is cheaper and reversible while Q5–Q9 are open. Neither is a sourced requirement | | | |
| D2 | Where the paydata serializer lives | (a) rewrite `apps/api/src/usecase/payroll/payroll-export.ts` and `AdpWorkbookRow`; (b) a pure function in `packages/payroll-engine` beside `toAdpWorkbookRows` (testable, shared); (c) a new module | (b) keeps tests in `dist`-based `node --test`; (a) is smallest. Either changes an exported type (R3) | | | |
| D3 | Co Code `4RZ`: constant or per-tenant setting | constant `ADP_COMPANY_CODE` (`payroll.service.ts:119`); tenant configuration; `4RY` is dormant | `NOT SPECIFIED` by any source | | | |
| D4 | Endpoint shape | reuse `GET …/export` and `/export.csv` unchanged in path; change the content; add a new route; the response header name/extension | depends on Q2 and Q16 | | | |
| D5 | Pattern | none exists (`patterns.md` has no export entry) — the shape is new | — | | | |

## 11c. Siblings — same pattern, same change?

| Sibling | Pattern | Same change? | Decided by | Enumerated by |
| --- | --- | --- | --- | --- |
| Per-employee export (`exportEmployeeWorkbook`, controller ~165, web `use-payroll-employee.ts`) | none | | | `git grep -n exportEmployeeWorkbook -- apps` |
| Any other payroll CSV/xlsx writer | none found | | | `git grep -n -i -E "csv\|xlsx" -- 'apps/api/src/**/*.ts' ':!*.spec.ts'` showed only the payroll export |

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** Nothing below is built until these are answered. Each is one-line-answerable by the person named. Search record is in each entry.

### Q1 — Is the CSV file the build target?
- **Question:** For this ticket, do we build the ADP paydata CSV (the interim browser-upload path), with the Pay Data Input API deferred — yes or no?
- **Why it cannot be answered from what is written:** `PAY-067` is `status: conflicted`: the FRD target design assumes API submission, `adp-read-write-boundary-2026-08-18.md` says payroll-output write is Marketplace-partner-gated, and the stated interim is manual CSV upload. `payroll/gaps.md` line 802 says "alternatives, not stages", status open. The RFP wording ("export") and the 2026-09-28 meeting do not decide it.
- **Blocked:** REQ-01 and by extension every file-contract requirement.
- **Candidates:** `payroll/rules/PAY-067-adp-export.md` (7.5 KB, 2026-08-27); `payroll/adp-read-write-boundary-2026-08-18.md` (21.9 KB, 2026-08-18); `payroll/adp-integration-capabilities.md` (33 KB); `payroll/gaps.md` line 802; `sync/.conflict/2026-08-24-bootstrap/payroll-management.md` (9.8 KB, 2026-08-24). None verified.
- **Owner:** TCG payroll + CodingCops, jointly (gaps line 802).
- **Workaround, if any:** none; building the CSV is the entire ticket.
- **Status:** open

### Q2 — Is there an xlsx form of the import file?
- **Question:** Does ADP import an xlsx, or is the CSV the only import format and the xlsx only a review sheet?
- **Why it cannot be answered from what is written:** SOP §6.2 and the VBA exporter say CSV only; no source mentions an xlsx import.
- **Blocked:** REQ-03; the xlsx response of `GET …/export`.
- **Candidates:** `adp-sop-v5.1.md` (17.5 KB); `adp-workbook-vba-macros.md`; the three sample stubs; `grep -n -i xlsx payroll/gaps.md`. ADP's `wfn_importing_paydata.pdf` is named in `payroll/source-manifest.md` but is not readable in the vault.
- **Owner:** Brian Petros (holds the import documentation, meeting 2026-09-28 §1.6).
- **Workaround, if any:** none.
- **Status:** open

### Q3 — File name week and Batch ID derivation
- **Question:** How is `nn` in `EPI4RZnn` derived, and how are the year, month and week of Batch ID `YrMoWk` (e.g. `260936`) derived — week-start, week-end or payday month, and counted from what?
- **Why it cannot be answered from what is written:** the PQ engine says "week 01 begins on the first Saturday on or after January 1", which makes 2026-08-22 week 34, yet the week-36 file covers that week; its own example also puts `EPI4RZ01` at both 2025-07-05 and 2025-12-20. Today's ERP file name uses a third scheme (the Friday's date).
- **Blocked:** REQ-04, REQ-05.
- **Candidates:** `adp-workbook-power-query-engine.md` §2; `adp-sop-v5.1.md` §6.2; `sources/EPI4RZ36.csv.md`, `EPI4RZ32.csv.md`.
- **Owner:** Brian Petros (author of the workbook).
- **Workaround, if any:** none.
- **Status:** open — §12.5 fixes the interim rule (ISO week of the Friday; Batch = YY+MM+WW); exact scheme still (→ Brian).
- **Executor note (U2, 2026-10-15):** built the §12.5 interim rule in `apps/api/src/usecase/payroll/adp-batch.ts` (`deriveAdpBatch`, one isolated pure function). Concrete divergence for Brian to resolve: the pay week ending **Friday 2026-08-28** is **ISO week 35**, so the interim rule produces file name `EPI4RZ35` and Batch ID `260835`. The vault's recorded golden file for that same week is **`EPI4RZ36.csv`** (week 36) with Batch ID `260936` — a **one-week offset** and a **month digit difference** (08 vs 09). So the ISO rule as decided does **not** reproduce the observed file name. Three numbers are now in play for that week: PQ-engine 34, ISO 35, observed-file 36. Brian's confirmation changes only `deriveAdpBatch`. Until then the exported file name will not match the historical one.

### Q4 — File # in the CSV
- **Question:** In the CSV, is File # the digits-only value ≥ 51 with or without leading zeros (ADP's regex), or up to 6 letters/digits (PAY-006 / crosswalk), and is it padded?
- **Why it cannot be answered from what is written:** see REQ-07 — four written sources disagree, the CSV's own form is unrecorded (only `ADP_PREVIEW` pads).
- **Blocked:** REQ-07; validation of File # in REQ-21.
- **Candidates:** `rules/PAY-006-adp-file-number-mapping.md` (`status: open`); `payroll/gaps.md` lines 4829, 1950; `adp-bucket-crosswalk.md` rule 8; `gaps-2026-08-20-retired.md` (closed entry, frozen).
- **Owner:** Brian Petros with Corrina Bustos (named in the gap).
- **Workaround, if any:** none.
- **Status:** open

### Q5 — Guaranteed hours: ADP code(s), and do added hours carry hours?
- **Question:** What ADP code(s) carry guaranteed-minimum ST / OT / DT (D-002), and are guarantee/shift/WTL "added hours" sent as hours under their own codes or as dollars only (or folded into DT, as legacy did)?
- **Why it cannot be answered from what is written:** D-002 open since 2026-08-05; none of the codes exist in ADP; Brian put "ADP reported hours" on the next meeting's agenda on 2026-09-13, no answer on file.
- **Blocked:** REQ-19 (and REQ-09 if the answer is "fold in").
- **Candidates:** crosswalk D-002; `payroll/gaps.md` lines 78, 4243; PAY-067 *Added hours have no hours column*.
- **Owner:** payroll manager (crosswalk); Corrina Bustos / Brian Petros (line 4243).
- **Workaround, if any:** omit added-hour dollars from the file — this under-pays; **labelled as unacceptable without a decision**, listed only so it is not done silently.
- **Status:** open

### Q6 — Rest-period premium code
- **Question:** Which ADP earning code, and sent as an amount or hours, carries the rest-period premium (D-003)?
- **Why it cannot be answered from what is written:** D-003 open; no live code; the client's own board marks it `SQL_READY_ADP_PENDING` ("dedicated ADP code still TBD").
- **Blocked:** REQ-19.
- **Candidates:** crosswalk D-003; `adp-workbook-v5.1-engine.md` §4; `payroll/gaps.md` line 78.
- **Owner:** payroll manager / ADP admin.
- **Workaround, if any:** none.
- **Status:** open

### Q7 — WTL / missed-meal premium code
- **Question:** Which ADP earning code carries the WTL / missed-meal premium (D-004), separate from rest premium?
- **Why it cannot be answered from what is written:** as Q6.
- **Blocked:** REQ-19.
- **Candidates:** crosswalk D-004; `adp-workbook-v5.1-engine.md` §4 and §5 item 1.
- **Owner:** payroll manager / ADP admin.
- **Workaround, if any:** none.
- **Status:** open

### Q8 — Special Saturday code (and the H2x / HDD mapping, and 2x boom)
- **Question:** What dedicated ADP code carries Special-Saturday ×2 hours (D-005), does H2x stop going to `HDD`, and which code carries Special-Saturday boom hours?
- **Why it cannot be answered from what is written:** D-005 open; the workbook sends H2x as `HDD`, which the client's board marks "ADP semantics still need confirmation"; the LB code set has no 2x slot.
- **Blocked:** REQ-11, REQ-19.
- **Candidates:** crosswalk D-005 and `HDD` row; `adp-workbook-v5.1-engine.md` §4; `gaps.md` line 78.
- **Owner:** payroll manager.
- **Workaround, if any:** none.
- **Status:** open

### Q9 — Accumulators / include-in-total-hours for the new codes (D-009)
- **Question:** What are the accumulator, category and include-in-total-hours-worked settings for every new code (and the taxability of `SUB`)?
- **Why it cannot be answered from what is written:** the live API pull does not return those attributes; the June CSV (24 codes) is the only source and is partial and superseded.
- **Blocked:** REQ-19; REQ-17's tax treatment.
- **Candidates:** crosswalk D-009; `adp-hour-earning-codes.md` (3.7 KB, 2026-06-04, superseded header); `adp-api-responses/pay-data-input-meta.md`.
- **Owner:** ADP admin.
- **Workaround, if any:** none.
- **Status:** open

### Q10 — Which hours does a premium ride on?
- **Question:** For lattice, shift, foreman and military, does the premium apply to every hour in each ST/OT/DT/H3x bucket that day (as the workbook's token × bucket table implies), or only to specific hours — and which hours does the ERP count as "premium hours"?
- **Why it cannot be answered from what is written:** the workbook types these by hand; the legacy app does not compute lattice, shift, foreman or military (`NOT_IMPLEMENTED`); the ERP stores a daily total with no bucket split.
- **Blocked:** REQ-15, REQ-14.
- **Candidates:** PQ engine §3; v5.1 engine §4–§5; `payroll/foreman-and-military-premiums.md`.
- **Owner:** Brian Petros.
- **Workaround, if any:** none.
- **Status:** open

### Q11 — Lattice oiler vs operator split (TCG-163)
- **Question:** Is the PayComponent split (operator vs oiler) to be done inside this ticket, or as the separate ticket noted on 2026-09-22, and which cranes trigger the premium?
- **Why it cannot be answered from what is written:** the gap says the split "needs its own ticket, not yet filed"; the crane question is for Joe and Kyle.
- **Blocked:** REQ-15, REQ-14 (lattice).
- **Candidates:** `payroll/gaps.md` line 4811 (TCG-163, status open).
- **Owner:** CodingCops to file; syed haris (ruled on TCG-163 2026-09-22); Joe and Kyle for the cranes.
- **Workaround, if any:** none; sending oiler hours as `LPR` pays the oiler the operator's $1.00 — wrong.
- **Status:** open

### Q12 — BASE_RATE_OVERRIDE rows
- **Question:** Does the ERP emit `BASE_RATE_OVERRIDE` rows, and from what data — a labor-entry craft rate above the employee's own, or a per-employee special agreement (no ERP field exists)?
- **Why it cannot be answered from what is written:** purpose is stated informally and partly (gaps line 3077, 2026-10-08, a one-line Teams answer); SCRUM-928 is unadjudicated.
- **Blocked:** REQ-16.
- **Candidates:** `adp-workbook-v5.1-engine.md` §2; `payroll/gaps.md` line 3077.
- **Owner:** Brian Petros; Corrina Bustos if it is a payroll-department convention.
- **Workaround, if any:** none; omitting the rows means ADP pays the employee's ADP rate on those hours.
- **Status:** open

### Q13 — Salary batch and post-import edits
- **Question:** Is the ERP expected to produce the `SALARY` batch, or does Corrina keep keying it (and the post-import edits) by hand, and what does the ERP file need to match?
- **Why it cannot be answered from what is written:** the client said he still needs to clarify it with Corrina (gaps line 3051, open).
- **Blocked:** REQ-22; the scope of any parallel-run comparison.
- **Candidates:** `payroll/gaps.md` line 3051; `adp-sop-v5.1.md` "What the SOP does not say"; `rules/PAY-013`.
- **Owner:** Brian Petros to clarify with Corrina Bustos (his own action item).
- **Workaround, if any:** drop the salary row from the file — **a workaround pending Q13, not a decision**.
- **Status:** open

### Q14 — Which payroll groups are in the CSV
- **Question:** Are union mechanics, non-union yard, and non-union admin/office hourly staff in the field CSV, or only union field employees (phase 1)?
- **Why it cannot be answered from what is written:** the crosswalk puts Non-Union Admin Hourly in the CSV; the 2026-09-28 meeting puts admin hourly on the hand-keyed Salary sheet and limits phase 1 to union field; unadjudicated.
- **Blocked:** REQ-22.
- **Candidates:** crosswalk; meeting `2026-09-28-…md` §1.4, §2 (19.7 KB, context only); gaps *Payroll has three populations* (not re-read this run).
- **Owner:** Brian Petros / Corrina Bustos.
- **Workaround, if any:** none.
- **Status:** open

### Q15 — Sick hours source
- **Question:** Where do paid non-worked (sick) hours come from in the ERP, or does `SIC` stay un-emitted for now?
- **Why it cannot be answered from what is written:** D-007 open, "ERP paid-leave source not yet available".
- **Blocked:** REQ-18 (not the worked-time scope).
- **Candidates:** crosswalk D-007; v5.1 engine §4.
- **Owner:** HR / CodingCops (crosswalk).
- **Workaround, if any:** emit no `SIC` pair — **workaround pending Q15**.
- **Status:** open

### Q16 — What happens to the readable workbook and its consumers
- **Question:** After this ticket, does the ERP still offer the readable review workbook (xlsx), the per-employee export, and the `EXPORTED` stamp, and what should the web "download" produce?
- **Why it cannot be answered from what is written:** the request says "not the current human-readable breakdown"; nothing says what the 8 consumers in §11a do. The process being replaced has a review view (SOP §6.2).
- **Blocked:** REQ-23; §11a R1–R4, R7, R8.
- **Candidates:** SOP v5.1 §6.2; the repo consumers listed in §11a (evidence, not intent).
- **Owner:** product team / Syed Haris.
- **Workaround, if any:** none.
- **Status:** open

### Q17 — Ticket id
- **Question:** What is the real Jira id for this work?
- **Why it cannot be answered from what is written:** the request names none; a search of Jira was not possible from a prompt alone.
- **Blocked:** folder name, PR naming (`commit` skill).
- **Candidates:** none: nothing written.
- **Owner:** Syed Haris.
- **Workaround, if any:** keep `ADP-PAYDATA-EXPORT`.
- **Status:** open

### Q18 — Import-spec evidence and the sample files
- **Question:** Can the client supply ADP's import-file documentation, a redacted/synthetic copy of `EPI4RZ36.csv` (as a golden file), the full list of the 22 validation codes, and an explanation of the `EPI63100` sample's single "!Do not change rows and column headers…" layout?
- **Why it cannot be answered from what is written:** the vault stubs record columns and counts only; byte-level format is unrecorded; the `EPI63100` stub lists one column and is the stale `631` company.
- **Blocked:** REQ-02, REQ-08, REQ-12, REQ-21 acceptance.
- **Candidates:** `sources/EPI4RZ36.csv.md`, `EPI4RZ32.csv.md`, `Sample ADP Export - EPI63100.CSV.md` (1.4 KB); `source-manifest.md`.
- **Owner:** Brian Petros.
- **Workaround, if any:** none.
- **Status:** open

### Q19 — Raised by the decomposer: what does the export do with an hour or dollar whose ADP code is still a placeholder?
- **Question:** §12.5 Q5–Q9 seeds placeholder mapping rows for D-002/003/004/005/009 (guarantee, rest, WTL, Special Saturday, accumulators), and Q8's H2x → HDD and 2x-boom codes are unconfirmed. When the engine produces a non-zero hour or amount for a component whose mapping row is a placeholder (or absent), does the export (a) refuse with a message naming the employee and component, (b) omit it and warn, or (c) something else?
- **Why it cannot be answered from what is written:** §12.5 says "emit via the table" but a placeholder has no real ADP code to emit. Sending an invented code gets rejected by ADP or pays wrong; omitting silently under-pays. `adp-bucket-crosswalk.md` rule 7 ("every ADP code must be active in the company validation table before export") points toward (a) but is `[UNVERIFIED]` and is not a ruling on this case.
- **Blocked:** `units.md` U6 builds (a) as the least-harm default and flags it; U4/U5 do not emit placeholder components either way.
- **Candidates:** (a) refuse; (b) omit + warn.
- **Owner:** Ali Riaz (behaviour), Brian Petros (real codes).
- **Workaround, if any:** (a), labelled a workaround pending this answer.
- **Status:** open

### Q20 — Raised by the decomposer: what is the "basic rule" for the pre-export File # check?
- **Question:** §12.5 Q4 says "emit stored `adpFileNumber` verbatim + pre-export validation of a basic rule". Which rule: non-empty only (what the export gate does today), ADP's regex `^0*(5[1-9]|[6-9][0-9]|[1-9][0-9]{2,5})$` (digits, >= 51), or "<= 6 letters or digits" (REQ-07)?
- **Why it cannot be answered from what is written:** REQ-07's two candidate rules conflict and neither is verified; "basic" does not select one.
- **Blocked:** the File # format check in U6 only. The existing non-empty gate stays.
- **Candidates:** the three above.
- **Owner:** Ali Riaz (which to enforce now); Brian Petros (canonical form).
- **Workaround, if any:** U6 keeps today's non-empty check and adds no format check.
- **Status:** open

### Q21 — Raised by the decomposer: does a missing File # on an out-of-scope payroll group still block the export?
- **Question:** Phase 1 puts only `L12_FIELD` employees in the file (Q14). Today's gate (`findEmployeesMissingAdpFile`) refuses the period for any employee with no File #, whatever group. Should an out-of-scope employee (salary, admin, SYS-excluded already) with no File # still block the export?
- **Why it cannot be answered from what is written:** §11a R6 says the gates are "unchanged"; Q14 says the file is union-field only. Both cannot hold for this case.
- **Blocked:** U3's gate extraction (which employees the File # gate looks at).
- **Candidates:** keep gate on every employee (unchanged, R6); scope gate to `L12_FIELD`.
- **Owner:** Ali Riaz.
- **Workaround, if any:** U3 keeps today's gate unchanged (every employee), i.e. R6 literally.
- **Status:** open

### Q22 — Raised by the decomposer: how does an engine pay component carry its identity (and hour bucket) to the exporter?
- **Question:** `PayComponent` is `{ruleId, label, hours, rate, amount}`; LATTICE_OP and LATTICE_OI share `ruleId` PAY-044 (`xlsx-rows.ts:91`), and the hour bucket (ST/OT/DT/H3x) exists only inside the `label` string ("Foreman premium ST"). Components are persisted by `payroll.repository.ts:1289` and the export reads them back through `rebuildEngineResult`. Which mechanism is used: (a) add a structured `componentCode` (+ `bucket`) to `PayComponent` and persist both on the component row (a migration); (b) give LATTICE_OI its own `ruleId` by data change and keep the bucket in the label; (c) other?
- **Why it cannot be answered from what is written:** this is a structural choice (an exported type and possibly a column) — CLAUDE.md reserves it for a developer. Parsing the label is not an option offered: a reworded label would silently change what is sent to ADP.
- **Blocked:** U2 (and therefore U4).
- **Candidates:** (a), (b) above; the options' cost: (a) migration + `PayComponent` ripple (payroll-explain, week-pricing-override, ingest); (b) no schema change but bucket still unstructured, so the Hours-4 slot cannot be picked without label parsing.
- **Owner:** Ali Riaz.
- **Workaround, if any:** none.
- **Resolution (Decided by: Ali Riaz, 2026-10-15):** option (a). U3 adds nullable `componentCode String?` + `bucket AdpHourBucket?` to `PayrollComponent` (reusing U1's enum) and the engine stamps both on each component it creates; LATTICE_OP/LATTICE_OI emit as distinct components. A **NULL** `componentCode` means a legacy/pre-U3 row — the serializer must skip/refuse it and never coalesce NULL→NONE. Active primary flat codes DT/HOL/SUB are stamped at bucket `NONE`; Reg/OT stay NULL (served by direct bucket aggregation); inactive-placeholder premiums stay NULL in phase 1. Contract-tracer: 0 breaks (fields don't reach web/mobile over the wire).
- **Status:** resolved

### Q23 — Raised by the decomposer: endpoint shape after the replace (D4)
- **Question:** After Q16's replace, which routes survive and what do they return? Today: `GET periods/:id/export` (xlsx), `GET periods/:id/export.csv`, `GET periods/:id/employees/:employeeId/export`. Options: keep `export.csv` as the one route and delete the other two; make `export` return the CSV and delete `export.csv`; keep both.
- **Why it cannot be answered from what is written:** §11b D4 is unfilled; §12.5 fixes the content (CSV) and the stamp, not the route.
- **Blocked:** U3 (which route it retargets) and U8a/U8b.
- **Candidates:** above.
- **Owner:** Ali Riaz.
- **Workaround, if any:** U3 retargets `export.csv` only (no path change); U8 removes the xlsx and per-employee routes — both are stated assumptions until answered.
- **Status:** open

### Q24 — Raised by the executor (U1): what string scheme keys `PayrollAdpEarningCodeMap.componentCode`?
- **Question:** The mapping table's unique key per tenant is `componentCode`, meant to key off `PayComponent.componentCode` — which does not exist yet (Q22/U3 adds it). U1 seeded provisional keys: the ADP code itself for confirmed rows (`DT`, `LBH`, `S2R`, …) and semantic UPPER_SNAKE names for the five placeholders (`GUARANTEED`, `REST_PREMIUM`, `WTL_MISSED_MEAL`, `SPECIAL_SATURDAY`, `ACCUMULATOR_SETTINGS`). Is that the intended key, or should it be the engine's component identifiers (e.g. `LATTICE_OP`/`LATTICE_OI`/`MILITARY` + hour bucket), which is what U4 will actually hold when it resolves a component to a row?
- **Why it cannot be answered from what is written:** §12.5 D-map fixes "component → ADP code + Hours-slot" but not the internal key's spelling; the engine emits rule-label components (`LATTICE_OP`, `LATTICE_OI`, `MILITARY`), and the canonical `componentCode` is Q22's structural call. The migration backfills these provisional keys into every existing tenant, so a later re-key is a data migration, not a code edit.
- **Blocked:** nothing in U1 (table is reversible + admin-editable in U7). U4's component→row lookup depends on this matching whatever Q22 lands.
- **Candidates:** (a) ADP code as the key; (b) engine component id + bucket; (c) decide together with Q22/U3.
- **Owner:** Ali Riaz.
- **Resolution (Decided by: Ali Riaz, 2026-10-15):** option (b). `componentCode` is the ERP-internal component identifier (`DT`, `HOL`, `SUB`, `SIC`, `LONG_BOOM`, `LATTICE_OP`, `LATTICE_OI`, `SHIFT_2ND`, `SHIFT_3RD`, `FOREMAN`, `MILITARY`, + the placeholders) and the row is keyed by **(componentCode, bucket)** via a new `AdpHourBucket` enum (`ST|OT|DT|H2X|H3X|NONE`); `adpEarningCode` holds the real ADP code. The 28 temp-rate codes collapse into their component × bucket. Member names line up with the `PayComponent.bucket` Q22/U3 will add. U1 re-keyed in place (same migration, still uncommitted).
- **Status:** resolved — see §12.5 §11b (Decided by Ali Riaz 2026-10-15).

### Q25 — Raised by the executor (U1): slot + value-kind for the placeholder rows
- **Question:** The five placeholder rows (D-002/003/004/005/009) have no confirmed ADP code (→ Brian). U1 still had to give each a non-null `adpSlot` and `valueKind` (the columns are not nullable). It used the crosswalk's *recommended* treatment: `GUARANTEED` → Hours-4/HOURS, `REST_PREMIUM`/`WTL_MISSED_MEAL`/`ACCUMULATOR_SETTINGS` → Earnings-3/AMOUNT, `SPECIAL_SATURDAY` → Hours-3/HOURS. Are those the intended placeholders, or should `adpSlot`/`valueKind` be nullable until Brian confirms?
- **Why it cannot be answered from what is written:** `adp-bucket-crosswalk.md` D-002/003/004/005/009 give *recommendations*, not confirmed ADP config; D-009 (accumulator settings) is not even a pay component with a natural slot. The rows are inactive, so they emit nothing today, but the stored slot is a guess.
- **Blocked:** nothing (rows inactive; U6 refuses any component that lands on a placeholder — Q19).
- **Candidates:** (a) keep the recommended slots; (b) make `adpSlot`/`valueKind` nullable for placeholders.
- **Owner:** Ali Riaz (shape), Brian Petros (real codes).
- **Resolution (Decided by: Ali Riaz, 2026-10-15):** option (a) — `adpSlot`/`valueKind` stay non-nullable and carry the crosswalk's recommended treatment for the placeholders. Real codes still owed by Brian; placeholders remain `status = INACTIVE` until then.
- **Status:** resolved — see §12.5 §11b (Decided by Ali Riaz 2026-10-15).

### Q26 — Raised by the executor (U5): neither rate the base-rate override compares is in the data the exporter reads back
- **Question:** D-override (§12.5 Q12) sources `BASE_RATE_OVERRIDE` rows from a labor entry's craft rate vs the employee's own base rate — so emitting them needs **both** numbers at export time. The exporter reads only the rebuilt approved run (`rebuildEngineResult` → `CalculatePayPeriodResult`). In it: (a) the employee's own ADP/home-craft base rate is **absent** — `PayrollEmployeeWeek` and its `employee` select in `findEmployeeWeek` carry only `id/employeeCode/firstName/lastName/employeeStatus/adpFileNumber/payrollGroup` (no base rate, craft assignment or `hourlyRate`); `PayrollJobDay` has `craftCode` but no rate column; `rebuildEngineResult` reconstructs no base rate; and the export is explicitly "read back from the run, never recomputed" (`payroll.service.ts` ~L1831). (b) the per-entry craft rate survives only implicitly as the straight-time base-pay component's `rate`, which carries **no** `componentCode` (NULL-vs-NONE: base-pay rows are skipped by the serializer) and is not addressable today. Where should the ERP obtain these two rates for the override comparison?
- **Why it cannot be answered from what is written:** §12.5 D-override fixes the *source concept* (labor-entry craft rate vs employee base rate) but not where either rate is persisted or resolved. Union base rates are effective-dated in `CraftCodeRate` (via the employee's home craft + wage group), non-union in `Employee.hourlyRate`; neither is stored on the run. Obtaining them is new persisted data or a new resolution path, not a serializer-only change — exactly the schema decision `units.md` U5 said to stop on ("assuming the labor-entry craft rate and the employee base rate are already on the persisted data the exporter reads. If either is not, the executor stops: that would be a schema change nobody has decided, and this unit becomes two").
- **Blocked:** all of U5 — its only build row is the builder change, which depends on both rates; nothing in the unit is independently buildable. U6 inherits the block (needs all row types to validate).
- **Candidates:** (a) persist at calculation time the employee's resolved base rate on the employee-week **and** each entry's craft rate on the job-day (new columns + migration; the run stays the single source, consistent with "never recompute"); (b) re-resolve both at export time via `CraftRateResolverService` + the employee's craft assignment + `CraftCodeRate`/`hourlyRate` effective-dated to the period end (no schema change, but recomputes rates the export was designed not to touch, and can drift from the approved run); (c) a narrower field set, if the "employee base rate" is defined differently.
- **Owner:** Ali Riaz (structure); route to `tcg-prisma-guardian` if (a).
- **Status:** open.

### Q27 — Raised by the executor (U6): does the HOLIDAY 8-hour-minimum guarantee top-up (PAY-033) carry its own ADP code, or fold into HOL?
- **Question:** U6 makes the exporter refuse any premium that lands on a placeholder/unmapped code, and to do that the engine now stamps a `componentCode` on each pending-code premium so a NULL strictly means legacy. The task's stamping set named the daily/boom guarantee (PAY-040/043 → `GUARANTEED`), rest (PAY-045), WTL (PAY-047), Special-Saturday worked hours (PAY-034 → `H2X`) and the Special-Saturday 8-hour minimum (`guarantee.ts` PAY-034 → `SPECIAL_SATURDAY`). It did **not** name the **HOLIDAY** 8-hour-minimum top-up (`guarantee.ts` emits it as **PAY-033** on a holiday, as the sibling of the special-Saturday PAY-034 top-up). It is left **unstamped** (NULL) — its prior behaviour — which means a holiday-minimum top-up's gap hours are still **silently dropped** from the CSV (the exact under-payment U6 exists to stop), because the serializer skips NULL-componentCode rows and the validator never sees it. Should PAY-033's holiday top-up (a) stamp `GUARANTEED` (treated as guaranteed hours, like PAY-040/043 — then U6 refuses it by name until a real code exists), (b) stamp a distinct holiday code, (c) fold into the active `HOL` Hours-3 code, or (d) stay NULL deliberately (accept the drop in phase 1)?
- **Why it cannot be answered from what is written:** REQ-19 lists "guarantee top-ups" generically; the vault does not separate the holiday minimum from the special-Saturday minimum for ADP, and the legacy app "folds holiday gap hours reported as DT hours" (REQ-19 notes) is legacy behaviour, not a decision. The spec's §12.5 D-map seeds a `GUARANTEED` placeholder but does not say which rule IDs route to it.
- **Blocked:** nothing in U6 — the other premiums refuse correctly; this is a residual silent-drop hole the executor found while building, not a blocker. Build shipped with PAY-033 unstamped.
- **Candidates:** (a) stamp `GUARANTEED`, `NONE` (recommended — consistent with PAY-040/043, makes the drop loud); (b) a new holiday-guarantee placeholder code; (c) fold into `HOL`; (d) leave NULL.
- **Owner:** Ali Riaz / Brian (which code).
- **Resolution (Decided by: Ali Riaz, 2026-10-15):** option (a) — stamp `PAY-033` as `GUARANTEED`, bucket `NONE`, the same guaranteed-hours family as PAY-040/043. A holiday week with a guarantee top-up now refuses by name (resolves to the INACTIVE `GUARANTEED` placeholder) instead of silently dropping the top-up. Applied in the engine (`guarantee.ts`) in U6.
- **Status:** resolved — see Resolution (Decided by Ali Riaz 2026-10-15).

### Q28 — Raised by the executor (U6): is the meal DEDUCTION (PAY-046) represented on the ADP file, and if so how?
- **Question:** U6 stamps the work-through-lunch **add-back** (PAY-047, a paid premium with dollars and no ADP code) as `WTL_MISSED_MEAL` so the export refuses on it. The meal **deduction** (PAY-046, a *negative* half-hour line that removes the pay for a taken/worked-through meal) is left **unstamped** (NULL), so it is skipped by the serializer and never refused. If the CSV's worked ST/OT hours still include the deducted half-hour and the deduction's dollars never reach ADP, the employee is **over-paid**; if the worked hours already exclude it, skipping is correct. The engine itself records this as unresolved (`types.ts` on `mealDeductHours`: "how a deducted meal should REPRESENT itself on the ADP export is `gaps.md` D-004 and is not settled"). Does PAY-046 (a) need its own representation on the file (its own code, or a reduction of the worked-hour count), or (b) is it correctly omitted because the worked-hour totals already net it out?
- **Why it cannot be answered from what is written:** D-004 ("WTL/missed meal") covers the premium side; the deduction side's ADP representation is explicitly open in the vault, and resolving it requires knowing whether the primary-row Reg/OT totals are pre- or post-meal-deduction — a pay-representation decision nobody has made. Stamping PAY-046 unilaterally would make nearly every L12_FIELD week with a meal refuse, on a semantics call the executor must not invent.
- **Blocked:** nothing in U6 — the paid WTL premium refuses correctly; this is the deduction's representation, a separate open item the executor surfaced. Build shipped with PAY-046 unstamped (phase-1 behaviour unchanged).
- **Candidates:** (a) give the deduction its own ADP representation (code or worked-hour reduction) and have U6 refuse until it exists; (b) confirm the worked-hour totals already net it out and keep it omitted.
- **Owner:** Brian (D-004) / Ali Riaz (structure).
- **Resolution (Decided by: Ali Riaz, 2026-10-15):** leave `PAY-046` **unstamped** in phase 1 (its prior behaviour — not refused, not emitted). Routed to Brian as a netting/correctness question: does the primary-row Reg/OT total already net out the unpaid meal half-hour, or must the deduction reach ADP as its own line? U6 ships with PAY-046 unstamped; the answer may add a representation (and a refusal) later.
- **Status:** pending Brian — phase-1 behaviour decided (leave unstamped); the netting/correctness question stays open with Brian (D-004).

## 12.5 Developer resolutions (2026-10-15)

All 18 §12 questions were answered by the developer. **Decided by: Ali Riaz, 2026-10-15.**
Phase 1 scope: **union field (L12_FIELD) only, CSV only.** Source for every row below is
*Developer decision 2026-10-15*; items marked **(→ Brian)** stay `[UNVERIFIED pending Brian]`
until the client confirms — build proceeds against the documented structure meanwhile.

| Q | Resolution | Still owed by Brian |
| --- | --- | --- |
| Q1 | Build the ADP paydata **CSV** (manual-upload path); API push deferred to a later ticket. | — |
| Q2 | **CSV only** — no xlsx. REQ-03 dropped. | — |
| Q3 | Filename week `nn` + Batch ID `YrMoWk` derived in **one isolated function** from the pay-period **end (Friday)** date (week = ISO week; Batch = YY+MM+WW). | Exact scheme (→ Brian). |
| Q4 | Emit stored `adpFileNumber` **verbatim** + pre-export validation of a basic rule. | Canonical form — padding / letters allowed (→ Brian). |
| Q5–Q9 | **Emit** premiums via a **new tenant-scoped DB reference table** (component → ADP code + Hours-slot), editable in the ERP (reference-code-list pattern). Seed known codes (DT, LBH, LBO, LBD, MLR/MLO/MLD, SUB, SIC); placeholder rows for D-002/003/004/005/009. | Real codes for guaranteed / rest / WTL-missed-meal / Special-Saturday; added-hours-as-hours-vs-dollars; H2x→HDD; Special-Saturday boom code; accumulator settings (→ Brian). |
| Q10 | Exporter uses the **engine's per-component hours** as-is. | Bucket-attribution rule (→ Brian). |
| Q11 | **Fix the lattice operator/oiler split (TCG-163) in the engine this cycle** — LATTICE_OP ($1.00) vs LATTICE_OI ($0.50) map to separate codes. Pulls `packages/payroll-engine` in (needs provenance). | Which cranes trigger it (→ Joe/Kyle). |
| Q12 | **Emit BASE_RATE_OVERRIDE** rows from the labor-entry craft rate when it differs from the employee's base rate. **DEFERRED to a follow-up (U5 2026-10-15):** neither the employee base rate nor the per-entry craft rate is in the persisted run (Q26) — building it needs a schema+engine change to persist them (splits into U5a persist + U5b builder), and the row semantics are still (→ Brian). Phase-1 ships without override rows. | Row semantics — full base rate vs difference (→ Brian); persistence approach — Q26 candidate (a)/(b)/(c). |
| Q13 | ERP does **not** produce the SALARY batch; salary + post-import edits stay hand-keyed. | — |
| Q14 | Phase 1 = **union field (L12_FIELD) only**. | — |
| Q15 | **Omit SIC** in phase 1 (no ERP paid-leave source). | Whether sick/PTO must flow from the ERP later (→ Brian). |
| Q16 | **Replace** the readable xlsx workbook and per-employee export entirely with the CSV; web Download produces the CSV; EXPORTED stamp stays on CSV generation. | — |
| Q17 | **No ticket** — feature branch only; keep provisional folder name. | — |
| Q18 | Build against documented structure now. | ADP import docs + redacted golden `EPI4RZ36.csv` + full 22 validation-code names (→ Brian). |

### §11b Developer decisions — filled (Decided by: Ali Riaz, 2026-10-15)

- **D-map:** a new **tenant-scoped DB reference table** (`PayrollAdpEarningCodeMap`, table `payroll_adp_earning_code_map`) holds the component → ADP-code + Hours-slot mapping (not a code constant), editable in the ERP. The decision covers the full shape (U1): keyed by **(tenantCompanyId, componentCode, bucket)** where `componentCode` is the ERP-internal identifier and `bucket` is the new `AdpHourBucket` enum (`ST|OT|DT|H2X|H3X|NONE`, resolving Q24); `adpEarningCode` (nullable) holds the real ADP code; `adpSlot` enum (`REG|OT|HOURS_3|HOURS_4|EARNINGS_3`); `valueKind` enum (`HOURS|AMOUNT`); a `status String @default("ACTIVE")` flag matching the P2 reference-code-list siblings (resolving the `active` vs `status` question); placeholder slot/valueKind kept non-null with the crosswalk's recommended treatment (resolving Q25). The 01..28 Hours-4 ordering is **not** stored — derived by a deterministic sort at serialize time (U4). Seeded per tenant (39 rows: 4 primary, 28 temp-rate, 7 inactive placeholders — the 5 D-codes + H2x + LB-2x); `clear-tenant-data.ts` wipes it like `PayrollPremiumType`.
- **D-override:** `BASE_RATE_OVERRIDE` rows are sourced from the **labor-entry craft rate** vs the employee's base rate.
- **D-lattice:** the operator/oiler split is **fixed in the engine this cycle** (not deferred).

## 13. What this spec deliberately does not specify

- Encoding, line endings, BOM, quoting beyond "when needed", header casing, trailing newline — no source (REQ-02, Q18).
- Batch ID and file-name week derivation — Q3.
- File # format — Q4 (sources conflict).
- Codes and import method for guarantee, rest, WTL, Special Saturday dollars, and added hours — Q5–Q9.
- Premium-hour bucket attribution, operator/oiler split — Q10, Q11.
- Base-rate override emission — Q12.
- Salary, group membership, post-import edits — Q13, Q14.
- Sick hours — Q15.
- Fate of the readable workbook, per-employee export, web download — Q16.
- Any UI copy, any new table or column, any new endpoint — §11b.
- The full list of 22 validation codes — Q18.

## 14. Sign-off before build

- [ ] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person
- [ ] Every `[CONFLICT]` requirement (REQ-01, REQ-07) has a decision note in `.ai/vault/decisions/`
- [ ] Answers written back into `spec.md` with their new sources and flags
- [ ] Every §12 question updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md`
- [ ] Every §11a ripple row has a source for what happens to that consumer, or a §12 question
- [ ] Every §11b row has _Chosen_ and _Decided by_ filled by a developer
- [ ] Every §11c sibling has a developer's yes / no / follow-up
- [ ] Decomposed into vertical units — `units.md`
- [ ] Re-diff every REQ's acceptance line against its own executor note (elaborator §8) — not yet done; no Jira ticket exists to re-read

Answered by: ______________  Date: ______________
