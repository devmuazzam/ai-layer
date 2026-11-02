# Units — YARDS-2026-10-29

> Four stacked units on one branch, `fixes/yards-2026-10-29` (from `main`), one local commit each; one PR.

| Unit | Outcome | Requirements | Layers | Depends on | Status |
| --- | --- | --- | --- | --- | --- |
| U1 | A quote is made from a real yard and the job carries it | REQ-01..06, 13 | schema, api, web, mobile, qa | — | not started |
| U2 | An employee has a Home yard and extra yards | REQ-09, 10, 11 | schema, api, web, qa | — | not started |
| U3 | The Dispatch board shows yards, filters by them and marks other-yard allocations | REQ-07, 08, 10 | api, web | U1, U2 | not started |
| U4 | A new quote suggests its yard | REQ-12 | api, web | U1 | not started |

---

## U1 — Quote and job carry a real yard

| Layer | Change |
| --- | --- |
| Schema | `Quotation.yardId` and `Job.yardId` — nullable UUID FK → `yards`, `onDelete: Restrict`, indexed. Migration backfills by matching the text `yard` to a yard's name (case/space-insensitive) or code within the tenant; jobs fall back to their quote's yard. Unmatched rows are counted in a `RAISE NOTICE`, left null. |
| API | Quote create requires `yardId` (uuid, must be an active yard of the tenant); update may change it while the quote is not converted; the `yard` text is set from the yard's name on every write (D2). Duplicate copies `yardId`. Conversion sets `job.yardId` from the quote. Yard rename rewrites `yard` text on its linked quotes and jobs. Yard guards count by `yardId` (fallback name for unlinked legacy rows). Jobs `yardId` filter matches the link (fallback name). Field-ticket yard address resolves by `yardId` first. |
| Web | Quote form picker stores the yard's uuid + name (`valueField="id"`); edit maps `yardId`; travel time resolves the yard by id. Job detail unchanged (reads name). |
| Mobile | Quote create sends `yardId` with the name. |
| qa | Quotation context/specs send `yardId`. |

## U2 — Home yard and extra yards

| Layer | Change |
| --- | --- |
| Schema | `EmployeeYard` (`employee_yards`): id, tenant, employee_id (cascade), yard_id (cascade), created_at; unique (employee, yard); tenant-scoped. `Employee.yardId` stays the Home yard. |
| API | Create requires `yardId` (Home); create/update take `additionalYardIds: uuid[]` (Home excluded, duplicates dropped, yards must exist in tenant); update with the field replaces the set. Employee read returns `additionalYards: { id, yardName, yardId }[]`. Payroll untouched (REQ-11). |
| Web | Employee form: "Also works out of" — repeat-row `YardSelect`s with "+ Add yard"; Home yard required; detail shows both. |
| qa | Employee helpers already send `yardId`; add a lifecycle check for extra yards. |

## U3 — Yards on the Dispatch board

| Layer | Change |
| --- | --- |
| API | DAS sub-job returns the job's quoted yard `{ id, name }`; DAS assets return `yardId`; DAS employees return Home + extra yards; allocation reads include the assignee's yard ids. |
| Web | Job card shows "Quoted from <yard>"; asset and employee cards show their yard(s); a Yard filter beside State/City (client-side, like them); an allocated slot whose asset/employee does not belong to the job's quoted yard shows "From <yard> · quoted from <yard>" (D1, REQ-08). Test ids: `das-jobs-filter-yard`, `das-job-quoted-yard`, `das-slot-other-yard`. |

## U4 — Yard suggestion on a new quote

| Layer | Change |
| --- | --- |
| API | `GET /yards/suggestions?jobSiteId=&subCategoryIds=` — active yards ranked: has an active, non-archived asset in every given sub-category first, then straight-line distance from the job site to the yard's physical address (D4); returns `{ id, yardId, yardName, distanceMiles, hasAllSubCategories }[]`. Picker route rules: `@SkipThrottle`, small result. |
| Web | New quote, Main step: when a job site is set and the yard is empty, show "Suggested: <yard> · <n> mi" with Use; never overwrites a chosen yard. |
