---
title: PAYROLL for ADP - Standard Operating Procedure v5.1
source: shared-folder/Project-Repository-2026-09-08/3.7.1_MODULE-HR-LABOR-PAYROLL/PAYROLL for ADP v5.1 - current/PAYROLL for ADP - SOP v5.1.docx (2.6 MB, 46 embedded images not transcribed)
migrated: 2026-09-08
updated: 2026-09-06
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, adp, legacy-payroll-app, wtl, foreman-premium, military-premium]
entities: [adp-export, payroll-week, excel-workbook, power-query, payroll-app]
---

# PAYROLL for ADP — Standard Operating Procedure v5.1

> **This is the process the ERP Payroll Module is meant to replace, as it runs today.** Version 5.1
> supersedes [adp-sop-v3.8.md](adp-sop-v3.8.md) (effective 2026-08-05). The client's covering
> message, 2026-09-08: *"This code I am providing you here is 100% functional and tested. We have
> been using this for the past 3 weeks (in production) and currently has no known issues."* Three
> weeks back from 2026-09-06 puts the v5 line in production from roughly **payroll week 34
> (2026-08-15 → 08-21)**; the copy shared is the processed **week 36, 2026-08-22 → 08-28**.
> Findings and questions: [client-message-findings.md](client-message-findings.md) → *2026-09-08*.
> The code behind it: [adp-workbook-v5.1-engine.md](adp-workbook-v5.1-engine.md).

Document control: *PAYROLL for ADP - SOP* · owner **Data Engineer** · department Human Resources –
Payroll · system *Excel workbook + Power Query + SQL + VBA, FCC-NexGen + ADP* · last updated
**September 06, 2026** · approver blank (as in v3.8).

## What changed since v3.8 — read this first

| Area | v3.8 (Aug 5) | v5.1 (Sep 6) |
| --- | --- | --- |
| **Data source** | Workbook queried **FCC-NexGen directly** for the roster | Workbook connects to **TCG's internal Payroll App database** (SQL Server, instance `TCG_APPS`), *"which pull data from our internal data warehouse, which pulls live data from FCC"*. The roster **and** the calculated payroll come from there |
| **Payroll App Recommendations** | none | New button on `PAYROLL_START`: pulls the week's labor entries into the Payroll App DB, runs *all* payroll rules, writes the results and rule narratives into the workbook, and loads them **under each employee sheet** as a read-only recommendation block (~1.5 min; re-runnable after FCC edits) |
| **What goes to ADP** | the hand-keyed rows | **Still the hand-keyed rows.** §6.2: the ADP review *"uses the data entered by our payroll department, **not** the 'Payroll App Recommendations'"* |
| **Premium columns on an employee sheet** | Lattice, Shift Differential | **Six** dropdown columns: Lattice Operator · Lattice Oiler · 2nd Shift · 3rd Shift · **Foreman** · **Military** |
| **Craft modifier** | one per day | one per row; *"if more than one Craft Code Modifier must be selected for the same day, then create separate row"* — sheets now carry **extra rows for custom entries** beyond the seven dated rows |
| **Notes** | a cell near the bottom | a **yellow box at the top** of each sheet, plus a yellow **feedback column** beside the recommendations (*"type in notes when the recommended data needs to be reviewed/fixed. This will help us fine tune the Payroll App logic"*) |
| **Close-out** | `Refresh All` on two sheets, then Create CSV | one button, **"ADP Review, Preview, and Validation"**, refreshes three sheets: `ADP_IMPORT_REVIEW`, **`ADP_PREVIEW` (new — the data as it will look on ADP's Worksheet screen)**, `ADP_IMPORT_VALIDATION` (~10–15 s) |
| **Buttons on `PAYROLL_START`** | Refresh · Create Employee Sheets | Refresh · **Show All Rows** (clears slicers and filters) · Create Employee Sheets · **Refresh Payroll App Recommendations** |
| **Hidden sheets** | 7 | **10**: adds `__PayrollAppMapping` (Payroll App field → sheet column), `__PayrollAppRecommendations` (the pulled data), `__PayrollAppRunInfo` (status of the last refresh); `__hiddenParams` now also holds the Payroll App server and database names |
| **Template handling** | open the master | **duplicate the master first**, rename by week (their example: `08.04-08.14 ADP`); the master will move from Corrina Bustos' OneDrive `Payroll` folder to the **HR department Teams shared folder** |
| **Access** | Windows/FCC security prompts | one **shared SQL login** (single username/password, saved in each user's Microsoft/Mac profile, never in the file, *"specially configured to provide very limited access"*, no expiry); an *unencrypted* warning at login because FCC has no certificate; **Patrick** is to provide a FQDN + certificate path |
| **Sheet protection** | — | `Emp_ADP#s and SheetNames` is protected; unprotect via *Review → Unprotect Sheet* to edit |
| **Tokens** | in `__hiddenParams` only | the token table is now **in the SOP**, addressed to the person keying comments in FCC's *Labor for Payroll Pre-Processor* screen, with the note *"the WTL rules (and tokens above) are currently in discussion and may change"* |
| **Web app** | — | the Payroll App is also *"viewed in the browser, with more detailed information… using the same source and matches the recommendations"* — three logins with different rights (below) |
| **Mac CSV save** | AppleScript | the AppleScript exists but *"Patrick does not agree with us using AppleScript"*; the SOP documents the manual Containers-folder workaround |
| **ADP import** | described in one line | step by step: Payroll Dashboard → the week → *Manage payroll* → *Import file* → **"Reject values…" option selected** → drag the CSV in → ADP opens the Worksheet page for review |

**What did not change:** the Saturday–Friday week; `Emp_ADP#s and SheetNames` as the manual
FCC-EmpID ↔ ADPFileNo ↔ SheetName map (FCC still has no ADP IDs; the workbook is still not connected
to ADP); the create-sheets rules (ADPFileNo *and* SheetName required, existing sheets untouched,
alphabetical order); the `Total Hrs` / `Hrs_Match` / ST·OT·DT·H2x·H3x entry; Subsistence as a
dollar amount, Sick Hrs for non-union, Holiday auto-lookup; `EPI` + `4RZ` + two-digit week as the
file name; the *"note any changes needed so we can update this Excel process"* loop.

## 5. Weekly payroll processing — the text, without the 46 screenshots

### 5.1–5.3 Duplicate, open, enable

Duplicate `__PAYROLL for ADP v5.1 (MASTER template)` from the OneDrive `Payroll` folder and rename
the copy with the payroll week. Open **in the desktop app** (macros; *"will not work properly in
Excel in the browser"*); keep Excel set to auto-update. Enable Macros and Enable Content. On **Excel
for Mac**, the first time: Data → Get Data → Launch Power Query Editor → Home → Options → Privacy →
tick the box → Save → Close & load → save the workbook.

*"Now, the Excel workbook should be fully functional with the ability to connect directly to our
internal PayrollApp database (which pull data directly from FCC)."* Excel prompts once for the
database login; credentials are stored in the user's profile.

**Technical notes regarding login/access** (verbatim in substance, Q&A form in the SOP):

- *Purpose* — access to *"our internal Payroll APP database (which pull data from our internal data
  warehouse, which pulls live data from FCC). The Payroll APP database contains the payroll
  calculation engine that automatically calculates payroll from live data in FCC. This gets loaded
  into the Excel sheet as 'Payroll App Recommendations'. This connection also provides the list of
  all active employees for the selected pay period."*
- *Where saved* — by Microsoft/Mac per user profile; entered once.
- *Why not in the file* — *"not secure (too easy to get access to it)"*.
- *Will it change* — *"Maybe… the username/password is controlled by us… no expiration"*; after
  Patrick sets up *"a more secure connection with a URL"* the credentials may need re-saving.
- *One login per person?* — **No.** *"Just one username and one password… anyone who knows it can
  use it to gain access."* Scope: *"the only thing it has access to are the things we see in the
  Excel file."*

**Encryption message** — the *"unencrypted"* warning appears *"because FCC does not have a
certificate of authentication"*; click OK. Then the list of what the Data Engineer needs from
Patrick before turning SQL *Force Encryption* on: the final FQDN; DNS working for office and remote
users; the certificate installed in `Local Computer\Personal` with its private key; subject, SAN,
issuer, expiry and thumbprint; read access on the private key for the `TCG_APPS` SQL Server service
account; whether it is a public or internal CA (and the root/intermediate chain for the Macs); and
the TCP port, routing and whitelist confirmed. *"Please leave SQL Force Encryption off until I bind
the certificate and we finish the Windows/Mac connection tests."*

> These are the client's own words on the security posture of the interim process: a shared,
> non-expiring SQL login and an unencrypted connection to a payroll database, with a certificate
> fix pending on Patrick. Recorded as fact, not as a recommendation; the credentials themselves are
> not in the SOP and are not here.

### 5.4 The visible sheets

**5.4.1 `Emp_ADP#s and SheetNames`** — unchanged in purpose (type in `FCC EmpID`, `ADPFileNo`,
`SheetName`; the two name columns are reference only). Now **protected**; unprotect to edit.

**5.4.2 `PAYROLL_START`** — Pay Period dropdown; the roster table for that period (*"all active
employees"*, refreshed by button); four macro buttons (Refresh · Show All Rows · Create Employee
Sheets · Refresh Payroll App Recommendations). The create-sheet rules are those of v3.8, with one
sharpened sentence: a sheet is created *"for each employee currently visible on the list when the
button is clicked"*.

**5.4.3 Refreshing Payroll App Recommendations** — what the button does, in the SOP's own list:

1. Looks at the pay period selected on `PAYROLL_START`.
2. *"Pulls live data of all labor entries for that week into our Payroll App database."*
3. *"Payroll App database runs all payroll calculation rules for all those labor entries."*
4. *"Saves the details and descriptions/comments of all Payroll Recommendations into the Excel file."*
5. *"Then loads those results into each individual employee sheet that currently exists."*

About 1.5 minutes. *"If there are any changes made in FCC, then this button can be used again."*

**5.4.4 Hidden sheets** — `__hiddenParams` (org/app name and version, FCC server and database,
**Payroll App server and database**, calendar start/end) · **`__PayrollAppMapping`** (*"map Payroll
App fields to fields on employee sheet"*) · `__PayrollWeeks` · `Holidays`, `CraftRates`,
`CraftModRates`, `ADP TempRates` (each still *"not connected to FCC"*) · `TEMPLATE` ·
**`__PayrollAppRecommendations`** · **`__PayrollAppRunInfo`**.

## 6. Entering data into employee sheets

### 6.1 Entry

Each generated sheet has the employee's name and grey formula cells; **one row per day plus
additional rows for custom entries**. `Unit_Asset` is free text (units used, or a note). Enter
`Total Hrs`, then the ST / OT / DT / H2x / H3x split until `Hrs_Match` turns green (H2x = the June
and December special union holidays; H3x = the other union holidays). Weekly summary below.

Then the **six premium dropdowns** — Lattice Operator, Lattice Oiler, 2nd Shift, 3rd Shift, Foreman,
Military — *"one option per column/row"*. Then `Craft Modifier` (dropdown) and boom hours; the rate
columns fill themselves; a second modifier on the same day needs its own row. Then `Subsistence`
(dollars for the day), `Sick Hrs` (non-union), `Holiday` (auto from the Holidays sheet). Weekly
notes go in the **yellow box at the top**.

**The recommendations block, at the bottom of every sheet.** *"The blue columns are displayed
directly below the recommended columns above"* — i.e. the app's figures sit under the human's
figures, column for column. The **yellow column** is for feedback when a recommendation is wrong.
**On the right: *"very detailed notes of all payroll rules applied and important things to
review"*** — the narrative text the legacy database's `v_UI_Payroll_*AppliedRule*` views generate
(see [legacy-payroll-app-db-backup-2026-09-07/INDEX.md](legacy-payroll-app-db-backup-2026-09-07/INDEX.md)
§6).

Rules of reading them:

- The app *"**cannot** process/calculate payroll rules if a **single** labor entry is longer than
  23.5 hours"* — the FCC date/time limitation already recorded on PAY-004 / PAY-018.
- Notes beginning **`INFO`** are informational — *"no action needs to be taken in FCC."*
- Notes beginning **`REVIEW`** *"need to be investigated/fixed/updated in FCC."* The two action
  types: **fix the times on the job ticket(s) in FCC**, or **enter a token in the comments of the
  Labor for Payroll Pre-Processor screen** for that labor entry.

**Tokens used in FCC** — *"FCC does not have the information available to process all payroll
rules"*, so these are typed into the pre-processor comment field on every labor entry the rule
applies to:

| Rule | Tokens | SOP note |
| --- | --- | --- |
| WTL — meal periods missed in the entry | `(PAY:WTL_4)` `(PAY:WTL_3)` `(PAY:WTL_2)` `(PAY:WTL_1)` `(PAY:WTL_0)` | *"the WTL rules (and tokens above) are currently in discussion and may change"* |
| Shift differential | `(PAY:SHIFT_2)` `(PAY:SHIFT_3)` | |
| Foreman for that job | `(PAY:FOREMAN)` | |
| Lattice job, by role | `(PAY:LATT_OILER)` `(PAY:LATT_OPER)` | |
| Military-base job site | `(PAY:MILITARY)` | |
| Subsistence tier | `(PAY:SUB_SHORT)` `(PAY:SUB_LONG)` | |

This is the same vocabulary `__hiddenParams` carried in v3.8; what is new is that it is now an
**operator instruction**, which confirms the comment token as the real integration surface between
FCC and the calculation ([foreman-and-military-premiums.md](foreman-and-military-premiums.md)
§*It confirms the comment-token pattern*).

**The Payroll App in the browser.** The same engine is viewable as a web app on the office LAN
(route: `/login?anyDateInWeek=<date>&next=/worklist`). *"This web app is using the same source and
matches the 'Payroll App Recommendations' pulled into the Excel file."* Three shared logins:

| Login | Can |
| --- | --- |
| `payrollmanager`, `itadmin` | use **Refresh data from FCC**; enter / modify / save employee ADP IDs |
| `payrollteam` | view ADP IDs only; no refresh |

### 6.2 Closing out and importing into ADP

On `ADP_IMPORT_REVIEW`, click **"ADP Review, Preview, and Validation"**. It *"pulls in all data from
all the individual employee sheets currently in the Excel workbook — **note: this uses the data
entered by our payroll department, not the 'Payroll App Recommendations'** — transforms all the
payroll data into the codes/columns required by ADP, [and] refreshes the tables on all three
sheets"* (10–15 s). The three tables: `ADP_IMPORT_REVIEW` (the CSV as it will be written),
**`ADP_PREVIEW`** (*"a similar format after imported into ADP (on the 'Worksheet' screen)"*), and
`ADP_IMPORT_VALIDATION` (ready-or-not plus the file name). Errors list on the validation sheet and
block the CSV button. On `PASS | READY`, click the green CSV button.

**Mac:** Excel can only save into its sandbox container; copy the folder path from the pop-up,
click Yes, then Finder → ⌘⇧G → paste the path to find the file. *"There is an AppleScript that can
be installed… however, Patrick does not agree with us using AppleScript for this… so the process
[above] is the workaround."*

File name: *"'EPI' is the type of file, '4RZ' is our company code, and the last two digits are the
payroll week."*

**In ADP Workforce Now:** Payroll Dashboard → find the week → *Manage payroll* → *Import file* →
make sure **"Reject values…"** is selected → drag-and-drop the CSV → ADP opens the Worksheet page
*"for review before submitting the payroll in ADP"*. Still: *"note any changes/modifications needed
so we can update this Excel process."*

## What the SOP does not say

- **What happens in ADP after the import.** The client's covering message: *"Need to clarify with
  Corrina on the modifications and additional payroll data entered into ADP system after this is
  imported."* The SOP ends at the Worksheet review.
- **Salary employees are outside this process entirely.** Same message: *"Corrina currently enters
  Salary employee payroll into ADP separately."* The 2026-08-18 ADP screenshots showed a separate
  `SALARY` batch marked *Manual Entry* — this is that batch. Consistent with PAY-013's open scope.
- **Which figures the clerk keys when the recommendation disagrees.** The SOP asks for a note in the
  yellow column; it does not say the recommendation is ever accepted as-is.
- **Whether the recommendations are union-only.** The SOP says *"all payroll calculation rules for
  all those labor entries"*; the non-union path in the app was only separated on 2026-09-07
  ([client-message-findings.md](client-message-findings.md) → *2026-09-07 comparison run*).

## Source

`PAYROLL for ADP - SOP v5.1.docx`, converted with pandoc on 2026-09-08 (≈2,900 words). 46 embedded
images not transcribed — the v3.8 page's screenshot section still describes the sheet layouts that
did not change. The LAN address of the web app, the FCC and Payroll App host names and the SQL port
are deliberately not recorded. Employee names appearing in the SOP's examples are not repeated here.
