# Spec — YARDS-2026-10-29

> Every requirement names its source. `[client]` = said on tape on 2026-10-29 (transcript time);
> `[developer]` = the developer's ticket text or a choice made in session, 2026-11-02/03; `[code]` = what
> `main` does today (exploration 2026-11-03). Nothing here is `verified` by the client in writing.

## 1. What `main` does today `[code]`

- `Quotation.yard` and `Job.yard` are free-text yard **names** (`VarChar(100)`), no FK. The quote form
  stores the picked yard's name; conversion copies the string (`projects.service.ts createJobFromQuotationInTx`).
- Name lookups depend on that string: yard inactive/delete/archive guards count quotations by name;
  the jobs list `yardId` filter matches `job.yard` against name or code; field tickets resolve the
  yard address by name; web travel time resolves the yard by name. Renaming a yard updates none of them.
- `Employee.yardId` — one optional FK. `Asset.yardId` — one optional FK (+ legacy `yardLocation` text).
- DAS: sub-jobs carry no yard; employees carry no yard; assets carry `yardName`, never rendered. Filters:
  shift, state, city.
- Conversion creates `JobResource` slots only; no allocation is ever made automatically.
- Yard addresses and job sites have `latitude`/`longitude`; no server-side distance; web has a Google
  Routes proxy for quote travel time.

## 2. Requirements

| ID | Requirement | Source |
| --- | --- | --- |
| REQ-01 | A quote's yard is picked from the Yards list and stored as a link to that yard (`Quotation.yardId`); a new quote cannot be saved without one. The name stays on the quote as a display copy. | [client] Joe 21:05 *"select the yard that we're quoting it out of"*; [developer] ticket §1 |
| REQ-02 | One quote = one yard. Cranes from two yards on one project are two quotes under that project. | [client] Joe 22:19, 24:23 *"Exactly correct"*; [developer] 2026-11-02 |
| REQ-03 | Converting a quote gives the job the quote's yard as a link (`Job.yardId`, the **quoted yard**). | [client] Joe 21:27; [developer] ticket §2 |
| REQ-04 | The quoted yard is the billing yard (yard → job site). Dispatch may send from anywhere; that never changes the job's yard. | [client] 22:25–24:23 |
| REQ-05 | Existing quotes and jobs are linked to the yard whose name (or code) matches their text; ones that match none stay unlinked and are reported — nothing is deleted. | [developer] ticket §1 |
| REQ-06 | Renaming a yard keeps its quotes and jobs showing the new name; yard guards (inactive / delete / archive) and the jobs yard filter work off the link. | [code] rename gap; [developer] |
| REQ-07 | The DAS shows each job's quoted yard, each asset's yard and each employee's yards, and can be filtered by yard. | [client] ehtesham.anwar 24:24, 25:06 (agreed); [developer] ticket §3 |
| REQ-08 | On the DAS, an asset or employee allocated to a job whose quoted yard is not theirs is marked (e.g. "From Ventura · quoted from LA") — shown, never blocked. | [developer] ticket §3 |
| REQ-09 | An employee has one Home yard (required for new employees) and any number of extra yards ("Also works out of"). | [client] Melissa 19:07; [developer] 2026-11-02 |
| REQ-10 | Dispatch treats an employee as belonging to every one of their yards; nobody's yard has to be switched to send them. | [client] Melissa 19:07 |
| REQ-11 | Payroll keeps using the Home yard (no change to payroll in this ticket). | [developer] — **pending client, §12 Q1** |
| REQ-12 | On a new quote, once the job site is set, the system suggests a yard: yards with an active asset in each quoted crane size first, then the nearest to the job site (straight line). The salesperson can ignore or change it. | [client] Kyle 18:03–18:49; [developer] — distance rule **pending §12 Q2** |
| REQ-13 | Changing an asset's yard never changes any quote's or job's yard. | [client] Joe 20:53; [developer] ticket §6 |

## 3. Decisions made in session (not client)

- **D1 — No automatic asset allocation on conversion.** Joe said *"if it auto-populates the asset"*;
  nothing allocates automatically today and dispatchers allocate by hand. This ticket shows the quoted
  yard on the board and lets dispatch filter by it (REQ-07/08) instead of creating allocations. [developer, 2026-11-03]
- **D2 — Keep the `yard` text columns** on quotes and jobs as a display copy, kept in step with the
  linked yard's name, so PDFs, mobile and field tickets that read the name keep working. [developer, 2026-11-03]
- **D3 — DB `yard_id` stays nullable**; "required" is enforced on create in the API and forms, so
  legacy rows that match no yard keep working. [developer, 2026-11-03]
- **D4 — Straight-line distance** (yard address lat/lng ↔ job site lat/lng) for the suggestion; no
  new maps API on the server. [developer, 2026-11-03; client confirmation §12 Q2]
- **D5 — The "quoted from" marker is office-only** (web DAS); mobile is unchanged. [developer, 2026-11-03; §12 Q3]
- **D6 — The Home yard is required on the web create form only.** The API keeps `yardId` optional on
  employee create: the qa employee helper and the tenant seed create employees without one, and edit
  never requires it (a legacy employee without a yard can still be saved). [developer, 2026-11-03]
- **D7 — The web suggestion sends the job site only.** The Yard is picked on the quote's Main step,
  before the crane sizes (Resources step); the API also takes `subCategoryIds` for when they are known.
  [developer, 2026-11-03]
- **D8 — Yard addresses are geocoded on the server** when saved without coordinates (as job sites
  are; client/map-pin coordinates kept; a saved address at the same place reuses its own). An address
  with no street, city or ZIP is never geocoded — the geocoder answers a bare "US" with the middle of
  the country. `prisma/scripts/backfill-yard-coordinates.ts` fills existing yards (dry run by default,
  `--apply` to write; run once per environment). Answers §12 Q5. [developer, 2026-11-03]
- **D9 — One "Yards" multi-select on the employee form, the starred chip is Home.** Replaces the
  "Also works out of" repeat rows and "+ Add yard". The first yard picked is Home until another is
  starred; removing Home makes the next one Home. Data and API unchanged (`yardId` = Home,
  `additionalYardIds` = the rest). New shared `components/ui/async-multi-combobox.tsx` — the first
  multi-select picker in the app; `contexts/web.md` → *Multi-select* still says there is none and
  repeat rows are the sanctioned pattern (a human updates contexts). [developer, 2026-11-03]

## 12. Questions

- **Q1 — Payroll for an employee with more than one yard.** Does payroll (subsistence distance etc.)
  always use the Home yard, or the yard of that day's job? Ask Melissa / Brian.
  - **Status:** open · **Blocks:** nothing built (REQ-11 builds no payroll change).
- **Q2 — The yard suggestion rule.** "Has the crane size, then closest" — straight-line or driving
  distance? Is there a fixed cutoff map? Ask Kyle / Joe.
  - **Status:** open · **Blocks:** nothing (D4 ships straight-line; changeable).
- **Q3 — Who sees "quoted from".** Office only, or field crews too? Ask Joe.
  - **Status:** open · **Blocks:** nothing (D5 ships office-only).
- **Q5 — Yards have no coordinates.** Found in the live check 2026-11-03: no local yard address has
  latitude/longitude — they are captured only when the address is picked through the Google address
  search on the yard form; nothing geocodes a yard on the server (job sites are geocoded). Until yards
  have coordinates, the suggestion ranks by crane size and then by name. Options: geocode yard addresses
  on save (as job sites are), and backfill existing yards. Ask the developer / Lisette.
  - **Status:** answered 2026-11-03 by the developer → D8 (geocode on save + backfill).
- **Q4 — One quote with several yards.** Joe allowed it for project quotes (22:01) before agreeing to
  one yard (24:23). REQ-02 ships one yard per quote.
  - **Status:** open (low) · **Blocks:** nothing.
