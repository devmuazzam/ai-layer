# Spec — SCRUM-877 Labor & Unit Details

> Written to `.ai/aidlc/SCRUM-877/spec.md` by the elaborator from the Jira ticket directly —
> **no `intent.md` exists for this ticket** (checked: `.ai/aidlc/SCRUM-877/` did not exist before
> this run). SCRUM-877 is "US-18 — Labor & Unit Details," fetched live via Atlassian MCP
> (cloudId `the-crane-guys.atlassian.net`, issue `SCRUM-877`), including its one clarifying
> comment (id `22923`, tcgproject12, 2026-08-20T19:13). The ticket description is a verbatim
> restatement of `product/atom-mobile-app-user-stories/05-compliance-labor-and-review.md` US-18 —
> confirmed by direct comparison, word for word identical.

## Fill rules

Every section below is required. **Never delete a section or a field inside a requirement
block.** A field that cannot be filled keeps its heading and takes one of `NOT SPECIFIED`,
`N/A — <reason>`, or `OPEN — <question>`.

## Source tagging

`[VERIFIED]` = adjudicated by a human (only `.ai/vault/domain/` + `.ai/vault/decisions/`
qualify today). `[UNVERIFIED]` = migrated/ticketed but never adjudicated — this is nearly
everything cited below, including the ticket itself. `kind: jira` sources are `[UNVERIFIED]`
by default: a ticket records what someone decided to build, not what product agreed.
`kind: code` sources describe current behavior only, never intended behavior.

---

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-877` — "Labor & Unit Details" (Task, status **In Review**, priority Medium, reporter Umair Khan, assignee tcgproject12, created 2026-08-11, updated 2026-08-20) |
| Intent | none exists — elaborated directly from the Jira ticket (description + comment `22923`) per instruction, since `.ai/aidlc/SCRUM-877/intent.md` was not present |
| Elaborated on | 2026-08-20 |
| Vault state at elaboration | 338 vault markdown files; six `domain/` files verified; ~90 open entries across `gaps.md` and `payroll/gaps.md` (counted by `grep -n '^## '`) |
| Gaps opened by this spec | `gaps.md#scrum-877-labor-and-unit-details-oiler-crew-linking` — opened 2026-08-20, updated three times 2026-08-21. Current state: Q1/Q2/Q4/Q5/Q6/Q9/Q10/Q11 resolved (two decision records), Q8 explicitly deferred, **only Q3 (data-readiness) and Q7 (images) remain open** |
| Rules consulted | `.ai/claude/contexts/api.md`, `.ai/claude/contexts/prisma.md`, `.ai/claude/contexts/mobile.md`, `CLAUDE.md` → Architecture / Identity Convention |

**On the two attachments** (`image-20260820-131819.png` id `12450`, `image-20260820-132954.png`
id `12449`, both uploaded by tcgproject12 same day as the comment): the comment body also embeds
two `blob:https://media.staging.atl-paas.net/...` image references inline. I attempted to fetch
attachment `12450` directly via its Atlassian API content URL and got **HTTP 403 Forbidden** —
the MCP-issued fetch context does not carry the auth needed for direct attachment binary access,
and no MCP tool available to me exposes attachment content as viewable media. **These images
remain unreadable to any agent in this loop as of this update** — see the *2026-08-21 update*
below for what has since been learned about them without actually viewing them.

**2026-08-21 update — decision record folded in.** `.ai/vault/decisions/
2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md` (`status: verified`,
`decided_by: tcgproject12` [comments `22923`, `23025`, `23064`, `23066`] `and Umair Khan,
reporter of SCRUM-877` [comment `23062`], all posted directly on the SCRUM-877 Jira ticket,
2026-08-20 through 2026-08-21, written by `tcg-scrum` after fetching the live comment thread
directly via Atlassian MCP) answers all nine of this spec's original open questions, either
fully, partially, or as an explicit scope deferral. Every requirement and question below has
been updated with that decision as its new source, citing the specific comment id, timestamp
and author the decision record traces each answer to — never the decision-record's own prose
as if it were the primary source. Two items the decision record itself flags as still
unresolved are carried forward unchanged: the literal `FMS_UNION_CRAFT_MODIFIER` 33-code rate
table (Q5), and the content of the two Jira attachment images (Q7, still unreadable by any
agent — a description of them reached this loop only as a coordinator relay of screenshots
pasted into a chat, which is not a durable, Jira-hosted, independently-checkable source and is
therefore not cited as one anywhere below; see Q7's update for exactly how that distinction is
handled). One additional correction is recorded here because it matters for trusting this
process: an earlier relay of "the product owner's answers" into this session, before the
decision record existed, mis-stated Q9 as contradicting itself between "Not required for now"
and "Yes." The decision record traced this to the live ticket and found no such contradiction
— comment `23066`'s Q9 answer reads "Yes," consistent with comment `23062`. That earlier,
uncited relay was correctly not folded into this spec at the time; this update uses only the
decision record's own verified reading.

**2026-08-21 update #2 — chat-relayed content, deliberately not treated as a source.** The
product owner has since supplied three further items — a rate table for Q5, a claim about where
boom length is recorded (Q6), and a refinement of Q3 — **directly to the coordinator in chat,
explicitly declining this time to post to Jira first** (the coordinator asked, matching the
channel that worked for the prior round; the product owner chose chat instead). This is a
deliberate choice not to use the durable channel, not a gap in effort by anyone — but it means
none of this content carries the provenance that let the prior round's answers become
`[VERIFIED]`. Nothing below treats it as settled. Two schema claims embedded in the relay
(`Asset.mainBoomLength` exists; `EmployeeCraftCode` has `code`+`label`) were independently
verified against the actual schema by this agent and are cited as `kind: code`, `[VERIFIED — by
direct schema read, not by the relay]`, exactly as any other code-observation would be — the
relay merely pointed at where to look. The rate table's 33-ish values and the "no seed value
needed" reasoning are recorded below as **unsourced content pending a durable citation** — see
Q5, Q6, and Q3's updates, and the corresponding gaps.md entry. If this content is posted to
Jira or otherwise made durable and checkable, it becomes citable and REQ-05/REQ-04/REQ-17 should
be revisited against the real source, not against this relay.

**2026-08-21 update #3 — second decision record, the round-2 rate table now durably sourced.**
`.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-boom-pay-rate-table.md`
(`status: verified`, `decided_by: tcgproject12, posted directly on the SCRUM-877 Jira ticket,
comment 23099, 2026-08-21T19:06:25.493+0500`, written by `tcg-scrum` after fetching the live
comment via Atlassian MCP) is a **second, separate** decision record for this ticket — not an
amendment of the first — resolving a disjoint question set: the literal
`FMS_UNION_CRAFT_MODIFIER` rate table (Q5), the above-380ft Oiler fallback (Q10, resolved as
option (a): `OI-BP-15`, $3.750/hr, with option (c) — a transcription gap — explicitly ruled out
by the same comment), and authorization for `Asset.mainBoomLength`'s migration to numeric
(Q11). It also re-confirms, with better provenance, the mechanism half of Q3 (no seed-value
question) that the round-2 chat relay had already surfaced — this does not newly resolve
anything Q3 didn't already have, since Q3's data-readiness half is untouched. **The values in
the table are identical to what update #2 recorded as an uncited chat relay** — this decision
changes the table's citability, not its content. Everything below that previously read "chat
relay, round 2, not cited as a source" for the rate table, the above-380ft rule, or the
mainBoomLength migration is updated to cite comment `23099` directly and is now `[VERIFIED]`
for those specific claims. Q3's data-readiness half, Q7 (images), and Q8 (deferred) are
untouched by this decision and remain open — this update does not over-resolve them.

---

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Labor Total Hours = boom + WTL×30min; Auto-Calculated Hours also displays yard/travel time (non-billable) | api, mobile | `[VERIFIED]` | decision 2026-08-21 (comments 22923, 23025, 23062, 23064) | no |
| REQ-02 | Net Billable Hours = boom time − lunch×30min + WTL×30min (no overtime term) | api, mobile | `[VERIFIED]` | decision 2026-08-21 (comments 22923, 23025, 23064) | no |
| REQ-03 | ~~Overtime = work end time beyond shift end time~~ — dropped from this ticket's scope | api, mobile | `[VERIFIED — deferred]` | decision 2026-08-21 Q1 (comment 23066) | no — removed |
| REQ-04 | Oiler card auto-populates Union Class + Craft Code from employee profile — `EmployeeCraftCode` confirmed tenant-configurable, not code-seeded | api, mobile | `[VERIFIED — mechanism]` / `[OPEN — data readiness]` | decision 2026-08-21 Q3 (comment 23066); schema verified directly (`EmployeeCraftCode.label`); chat relay round 2 not cited | no — pending real data, not code |
| REQ-05 | Craft Modifier/Boom Pay: boom-length bracket suggestion — mechanism, 16-row rate table (non-symmetric above 380ft, confirmed genuine not transcription), and above-380ft Oiler fallback (`OI-BP-15`) all now `[VERIFIED]`; only bracket-boundary edge semantics remain unstated | schema, api, mobile | `[VERIFIED]` / `[OPEN — boundary semantics only]` | decision 2026-08-21 (comments 23025, 23066); decision 2026-08-21 rate-table (comment 23099) | **no longer — boundary semantics is a small residual, not build-blocking** |
| REQ-06 | Only the Oiler's ticket carries Checklist/Labor/Unit steps | api, mobile | `[UNVERIFIED]` | `SCRUM-877` comment 22923; corroborated by current mobile code | no |
| REQ-07 | Oiler enters Labor/Unit data for Oiler + **Operator-type employees who work on boom** in the same set (narrowed from "every employee"), each on their own card; set resolved via `setResourceId` | schema, api, mobile | `[VERIFIED]` | decision 2026-08-21 Q2, Q5-scope-note (comments 23025, 23066) | no — mechanism confirmed |
| REQ-08 | Craft Modifier selected by the Oiler applies to all Oiler/Operator-type employees in the set | api | `[UNVERIFIED — propagation mechanism; rates now verified per REQ-05]` | `SCRUM-877` comment 22923; narrowed per REQ-07; rate values per decision 2026-08-21 rate-table | no — REQ-05's values no longer block this |
| REQ-09 | Net billing still computed per-employee off their own ticket's time | api | `[UNVERIFIED]` | `SCRUM-877` comment 22923 | no |
| REQ-10 | Backend persists Labor/Unit data against each individual employee's ticket via a shared, reusable server-side calculation function; not the Oiler's | schema, api | `[VERIFIED — mechanism]` / `[OPEN — model shape, now narrower]` | decision 2026-08-21 Q2, Q4 (comment 23066); rate-table decision informs field shape (comment 23099) | **yes — model shape, now largely just REQ-17's authorization + precision/scale/backfill** |
| REQ-11 | Labor Classification selection (Job Site Work / Shop Work / Travel / Site Inspection) | schema, api, mobile | `[UNVERIFIED]` | `product/atom-mobile-app-user-stories/05-compliance-labor-and-review.md` US-18 | no |
| REQ-12 | Employee can adjust Labor information within business-rule limits; comments field | api, mobile | `[UNVERIFIED]` | `product/atom-mobile-app-user-stories/05-compliance-labor-and-review.md` US-18 | no |
| REQ-13 | Unit/Asset information displayed on the Labor step | mobile | `[UNVERIFIED]` | `product/atom-mobile-app-user-stories/05-compliance-labor-and-review.md` US-18 | no |
| REQ-14 | Confirmed Labor information retained for downstream Payroll processing | schema, api | `[VERIFIED — deferred, not adjudicated]` | decision 2026-08-21, final line (comment 23066) | no — deferred to future payroll ticket |
| REQ-15 | Non-Oiler employee can view their own Labor/Unit data, read-only | mobile, api | `[VERIFIED]` | decision 2026-08-21 Q9 (comments 23025, 23062, 23066) | no |
| REQ-16 | `Asset.capacity` becomes numeric/decimal (tonnage), separate from the boom-length axis REQ-05 actually uses | schema | `[VERIFIED]` | decision 2026-08-21 Q6 (comment 23066) | **yes** |
| REQ-17 | `Asset.mainBoomLength` (already exists, currently free-text) — the actual field REQ-05 needs; migration to numeric now authorized | schema | `[VERIFIED — field location/type and migration authorization]` / `[OPEN — precision/scale/backfill]` | schema verified directly; decision 2026-08-21 rate-table, comment 23099, authorizes the migration directly | **yes — precision/scale/backfill only, not whether to migrate** |

Counts: **17 total** — updated 2026-08-21 after the second decision record (rate-table, comment
`23099`). **13 fully or mechanism-verified**, 4 unverified, 0 conflicted (both prior conflicts
deferred out of this ticket's scope by explicit product-owner instruction, not adjudicated — see
REQ-03, REQ-14). Remaining open/partial: REQ-05 (boundary-edge semantics only, not
build-blocking), REQ-08 (propagation mechanism itself, not rates), REQ-10 (model shape now
narrowed to precision/scale/backfill), REQ-16 and REQ-17 (both migrations authorized;
precision/scale/backfill `NOT SPECIFIED` for both — schema-blocking in the narrow sense that a
migration must still be written, not in the sense of an undecided product question). Q3's
data-readiness question and Q8 (deferred, not answered) remain genuinely open, along with Q7
(images) — see §12.

---

## 2. Requirements

### REQ-01 — Labor Total Hours and Auto-Calculated Hours display `[VERIFIED]`

- **Statement:** Labor Total Hours is a read-only, system-computed field equal to actual boom
  time plus 30 minutes for each WTL (Work Time Loss) taken. The Auto-Calculated Hours section of
  the Labor & Unit step additionally displays yard time and travel time as line items, even
  though neither feeds the Net Billable Hours calculation (REQ-02).
- **Surface:** api, mobile
- **Sources:**
  - `.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md` —
    `[VERIFIED]` — kind: decision — `decided_by: tcgproject12 (comments 22923, 23025, 23064)
    and Umair Khan (comment 23062)`. Comment `23025` (tcgproject12, 2026-08-21 14:46, edited
    15:01): net billable = boom + 30min/WTL; raises whether yard/travel should still display.
    Comment `23062` (Umair Khan, 2026-08-21 16:42): "Should this show in the Auto-Calculated
    Hours section?: Yes." Comment `23064` (tcgproject12, 2026-08-21 17:26, edited 17:26:54):
    confirms yard/travel display is cosmetic only, not part of net billable.
  - `SCRUM-877` comment `22923` (tcgproject12, 2026-08-20) — `[UNVERIFIED]` — kind: jira —
    original formula statement, superseded in detail by the decision above but consistent with
    it on the boom+WTL core.
  - `apps/mobile/features/field-ticket/steps/labor-hours.ts` — kind: code — **current behavior**:
    `computeLaborHours` already derives `boomMs`, `lunchMs`, `travelMs`, and `totalMs` (yard
    -to-yard), all as separate fields — the yard/travel display this decision asks for already
    has a computed source to draw from client-side. There is currently no explicit WTL-add term
    and no "Labor Total Hours" output distinct from `netMs`.
- **Conflict:** none — resolved by the decision record.
- **Open question:** none.
- **Acceptance:** Given a ticket with boom start/end timer captures, yard-to-yard gps captures,
  and N taken WTLs: Auto-Calculated Hours displays Total (yard→yard), Travel time, Boom time,
  and Lunch deduction as line items (per the now-viewable attachment images — see the updated
  Q7/§6 for the exact card layout this corresponds to); Labor Total Hours = `(boomEnd −
  boomStart) + N × 30min`, read-only, recalculating live as captures change.
- **Notes for the executor:** `computeLaborHours` already computes every field this display
  needs (`totalMs`, `travelMs`, `boomMs`, `lunchMs`) except the WTL-add term for Labor Total
  Hours — add that term without removing the existing yard/travel fields, which this decision
  confirms must still surface even though they are excluded from net billable hours (REQ-02).
  Per REQ-10/Q4 (now answered — server-side, reusable function), this display-side computation
  should call the same shared calculation function the backend uses, not reimplement the
  arithmetic separately on-device.

### REQ-02 — Net Billable Hours calculation `[VERIFIED]`

- **Statement:** Net Billable Hours = boom time, minus 30 minutes for each lunch actually taken,
  plus 30 minutes for each WTL taken instead of a lunch. Yard time and travel time are excluded
  from this figure (they are display-only, per REQ-01). No overtime term (see REQ-03).
- **Surface:** api, mobile
- **Sources:**
  - `.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md` —
    `[VERIFIED]` — kind: decision — comment `23025` (tcgproject12, 2026-08-21 14:46): "net
    billable = boom + 30min/WTL" and that yard/travel are excluded from the calculation; comment
    `23064` (tcgproject12, 2026-08-21 17:26) reconfirms yard/travel are display-only, not part of
    the net billable calculation.
  - `SCRUM-877` comment `22923` — `[UNVERIFIED]` — kind: jira — original lunch/WTL add-subtract
    statement, consistent with the decision.
  - `apps/mobile/features/field-ticket/steps/labor-hours.ts` — kind: code — current `netMs`
    mechanics (boom − taken-lunch, WTL contributes nothing to the deduction) are functionally
    consistent with this formula.
- **Conflict:** none — resolved by the decision record. The overtime term this spec's original
  REQ-02 statement included has been removed entirely; see REQ-03.
- **Open question:** none.
- **Acceptance:** Given boom time and a set of lunch/WTL events, Net Billable Hours reconciles
  to boom − (taken-lunch minutes) + (WTL-instead-of-lunch minutes), with yard/travel time never
  entering the figure regardless of what REQ-01 displays alongside it.
- **Notes for the executor:** Implement as the shared, reusable calculation function REQ-10/Q4
  now requires (server-side, anticipating reuse by the future payroll module) — not as a
  one-off inlined into a single service method, and not solely as client-side display logic.

### REQ-03 — Overtime `[VERIFIED — deferred, removed from ticket scope]`

- **Statement:** No overtime calculation is in scope for this ticket. The original ask
  ("work end time exceeds shift end time... added to Net Billable Hours") is not built here.
- **Surface:** n/a — removed
- **Sources:**
  - `.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md` Q1
    — `[VERIFIED]` — kind: decision — comment `23066` (tcgproject12, 2026-08-21 17:38): "We do
    not need to account for extra hours at this stage, as those will be handled through payroll,
    which will be implemented in the future. For the ticket, we only need to calculate billable
    hours based on boom time and lunch breaks/WLTs."
- **Conflict:** the field-ops-vs-payroll overtime-model disagreement this spec originally logged
  (field-ops-local additive figure vs. payroll's daily-accumulation Reg/OT/DT model — see
  `payroll/payroll-app-current-state/03-payroll-rule-catalog.md`, `PR-021`) is **not adjudicated
  by this decision — it is mooted for this ticket only.** The decision record is explicit:
  "It is deferred, not decided in either direction — when the payroll module is built, the
  question of which system owns overtime pricing will need to be asked again on its own terms."
  Do not cite this ticket as having settled that question for any other ticket.
- **Open question:** the general question (who owns overtime pricing, field-ops or payroll) is
  still open in principle, but no longer blocks this ticket. Not logged as a numbered Q here
  since nothing in this ticket depends on its answer any more.
- **Acceptance:** N/A — no overtime feature is built. Net Billable Hours per REQ-02 carries no
  overtime term.
- **Notes for the executor:** Do not add an overtime calculation to this ticket's scope even if
  it seems like a small addition once REQ-01/REQ-02 are built — this was a deliberate scope cut,
  not an oversight, and building it anyway would pre-empt a decision the payroll module still
  needs to make on its own terms.

### REQ-04 — Oiler card auto-populates Union Class + Craft Code `[VERIFIED — display mechanism]` / `[OPEN — data-readiness]`

- **Statement:** On the Oiler-type labor card, Union Class and Craft Code fields are
  pre-populated from the employee's profile, read-only. "Craft Code" reads
  `Employee.craftCodeId → EmployeeCraftCode.label` (field name confirmed, see sources).
  `EmployeeCraftCode` is a tenant-configurable admin reference table, managed under a settings
  -tab module — not a fixed enum this codebase seeds or hardcodes — so the display mechanism
  requires no code-level "Oiler" special-casing. **Whether a craft-code row usable for an Oiler
  employee actually exists in any given tenant's configured data today is a data-readiness
  question, not a code question, and remains genuinely unaddressed** — see Q3's update.
- **Surface:** api, mobile
- **Sources:**
  - `.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md` Q3
    — `[VERIFIED]` — kind: decision — comment `23066` (tcgproject12, 2026-08-21 17:38): "The
    Craft field in the Employee module maps to the Oiler value shown in the mock design card."
  - **Chat relay, 2026-08-21 (round 2, not posted to Jira)** — **not cited as a source for this
    requirement's acceptance criteria**, recorded for continuity only: the product owner told
    the coordinator, in chat, "Yes, it does come from EmployeeCraftCode, we record the craft
    codes in a module under the settings tab in the sidebar and one of these craft codes is
    assigned to the employee that we need to display here. Craft code has a code and label."
    This is a real, useful clarification of the *mechanism* (admin-configured table, not a
    hardcoded enum) but arrived through a channel this role does not treat as a citable source —
    see the *update #2* note in §0 for why, and Q3 below for what would make it citable.
  - `apps/api/prisma/schema.prisma:2261-2284` — kind: code — `[VERIFIED — by direct schema read]`
    — `EmployeeCraftCode` confirmed to have exactly: `id`, `tenantCompanyId`, `code String
    @db.VarChar(50)`, `label String @db.VarChar(255)` (the field is literally named `label`, not
    `name` — this agent's own earlier notes had guessed `label` and this confirms it directly,
    independent of the relay), `description String? @db.Text`, `status`, plus audit FKs. It is
    tenant-scoped (`@@unique([tenantCompanyId, code])`, `@@unique([tenantCompanyId, label])`),
    consistent with an admin-managed, per-tenant reference table rather than a global enum — this
    part of the relay's characterization matches what the schema itself shows, independent of
    trusting the relay for it.
  - `SCRUM-877` comment `22923` — `[UNVERIFIED]` — kind: jira — "The Union Class and Craft Code
    should be populated from the employee's profile."
  - `apps/api/prisma/schema.prisma:3493,3516` — kind: code — `Employee.unionCodeId` and
    `Employee.craftCodeId` exist today, FK to `EmployeeUnionCode` (line 3540) and
    `EmployeeCraftCode` (line 3538) respectively.
  - `apps/api/prisma/migrations/20260703100000_employee_craft_and_work_comp_codes/
    migration.sql:82-87` — kind: code — seeded craft codes today are `OPERATOR`, `LABORER`,
    `MECHANIC`, `SUPERVISOR`. **No `OILER`/`OI`-labeled row is seeded.** The relay's framing
    ("no seed-value question at all, since it's user-configured data") is a real point about
    *mechanism* — nothing in the code needs to special-case "Oiler" as a string — but it does not
    by itself put a usable row into any tenant's actual data. A configurable table with zero
    rows an Oiler could be assigned displays exactly as emptily as a missing enum value would.
- **Conflict:** none.
- **Open question:** see Q3 — now narrowed further: not "which field," not even "does this need
  code-level seeding," but specifically "does at least one tenant have an Oiler-appropriate
  `EmployeeCraftCode` row configured today, and if not, whose job is it to add one (a settings
  -tab admin action, not a schema migration, per the relay's own framing — but still a real
  action someone must take before this displays anything for a real Oiler)."
- **Acceptance:** Given an Oiler-type employee whose `Employee.craftCodeId` and `unionCodeId`
  are set, the Oiler card displays `EmployeeUnionCode.label` and `EmployeeCraftCode.label`,
  read-only. If either FK is null (e.g. no such craft code has been configured/assigned for this
  tenant yet), display behavior is `NOT SPECIFIED` — no source states whether the field shows
  blank, an error, or a prompt.
- **Notes for the executor:** No schema change and no seed migration is required by this
  requirement itself — build the display against `EmployeeCraftCode`/`EmployeeUnionCode` as a
  generic, already-existing, tenant-configurable reference, exactly as any other admin-managed
  lookup in this schema is displayed. Do not add a code-level `OILER` constant or special case.
  Whether TCG's own tenant data needs an admin to go configure an Oiler-appropriate craft code
  row is an operational/data task for whoever administers that settings-tab module, not an
  engineering task for this ticket — flag it to product/ops rather than building around it.

### REQ-05 — Craft Modifier/Boom Pay bracket suggestion `[VERIFIED]` / `[OPEN — bracket-boundary edge semantics only]`

- **Statement:** The Craft Modifier/Boom Pay axis is **boom length**, not crane tonnage. The
  reference source is the client-supplied `FMS_UNION_CRAFT_MODIFIER` table (16 rows, confirmed
  genuinely non-symmetric above 380 ft — not a transcription artifact). The system suggests a
  bracket, marked visually, and the employee can select any other option. For an Oiler on a
  crane whose boom length exceeds 380 ft, where no Oiler-specific bracket exists, the confirmed
  fallback is the 361–380 ft bracket's Oiler rate (`OI-BP-15`, $3.750/hr). **The literal table
  and the above-380ft fallback are now `[VERIFIED]`, sourced to a Jira comment with real
  provenance — this is a change from the previous update, where the same values had reached this
  spec only through an uncited chat relay.** The only remaining gap is exact bracket-boundary
  edge semantics (see below) — small enough that it does not block building this requirement,
  only its precise edge-case behavior.
- **Surface:** schema, api, mobile
- **Sources:**
  - `.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-boom-pay-rate-table.md` —
    `[VERIFIED]` — kind: decision — `decided_by: tcgproject12, posted directly on the SCRUM-877
    Jira ticket, comment 23099, 2026-08-21T19:06:25.493+0500`, fetched live via Atlassian MCP by
    `tcg-scrum`, independently re-verified by this agent against the current schema before
    folding in (see below). Comment `23099`, verbatim table:

    | Bracket | Operator code | $/h | Oiler code | $/h |
    |---|---|---|---|---|
    | 080–100 ft | OP-BP-01 | 0.750 | OI-BP-01 | 0.250 |
    | 101–120 ft | OP-BP-02 | 1.500 | OI-BP-02 | 0.500 |
    | 121–140 ft | OP-BP-03 | 2.250 | OI-BP-03 | 0.750 |
    | 141–160 ft | OP-BP-04 | 3.000 | OI-BP-04 | 1.000 |
    | 161–180 ft | OP-BP-05 | 3.750 | OI-BP-05 | 1.250 |
    | 181–200 ft | OP-BP-06 | 4.500 | OI-BP-06 | 1.500 |
    | 201–220 ft | OP-BP-07 | 5.250 | OI-BP-07 | 1.750 |
    | 221–240 ft | OP-BP-08 | 6.000 | OI-BP-08 | 2.000 |
    | 241–260 ft | OP-BP-09 | 6.750 | OI-BP-09 | 2.250 |
    | 261–280 ft | OP-BP-10 | 7.500 | OI-BP-10 | 2.500 |
    | 281–300 ft | OP-BP-11 | 8.250 | OI-BP-11 | 2.750 |
    | 301–320 ft | OP-BP-12 | 9.000 | OI-BP-12 | 3.000 |
    | 321–340 ft | OP-BP-13 | 9.750 | OI-BP-13 | 3.250 |
    | 341–360 ft | OP-BP-14 | 10.500 | OI-BP-14 | 3.500 |
    | 361–380 ft | OP-BP-15 | 11.250 | OI-BP-15 | 3.750 |
    | 381–400 ft | OP-BP-16 | 12.000 | — | — |
    | 421–440 ft | OP-BP-18 | 13.500 | — | — |

    16 rows total. Comment `23099`, verbatim: **"Confirmed: the table is genuinely not
    symmetric — `OP-BP-17` (401–420 ft) does not exist in the source data, and there is no Oiler
    bracket at all above 380 ft."** This explicitly forecloses the "transcription gap" reading
    this spec had left open in the prior update — the product owner states the 401–420ft
    bracket is genuinely absent from the source, not merely dropped when relayed. It also
    confirms directly, resolving the fallback question this spec had refused to guess at:
    **"Confirmed rule for an Oiler on a crane with boom length above 380 ft: use the 361–380 ft
    bracket's Oiler rate — `OI-BP-15`, $3.750/hr."** The values are identical to what the
    uncited round-2 chat relay had already surfaced — this decision changes their citability,
    not their content.
  - `apps/mobile/features/field-ticket/steps/LaborBody.tsx:31-46` — kind: code — superseded as a
    rate source; useful only for the UI pattern (suggested-option marker, override-with-reason).
  - `apps/api/prisma/schema.prisma:758` — kind: code — `[VERIFIED — by direct schema read,
    re-confirmed this update]` — `Asset.mainBoomLength String? @map("main_boom_length")
    @db.VarChar(30)`, free-text. Resolves *where* boom length is recorded; see REQ-17 for the
    now-authorized migration to numeric.
  - `apps/api/prisma/schema.prisma:707` — kind: code — `Asset.capacity` (tonnage, REQ-16) remains
    a distinct field from `mainBoomLength` — not to be conflated.
  - `payroll/codingcops-rule-matrix.md` `PR-011`, `product/frd-new-format-draft/
    08-open-questions.md` item 10 — kind: vault — unchanged; still not body-edited by this role.
- **Conflict:** none between documents. The table's asymmetry above 380 ft is not a document
  conflict — it is a confirmed, genuine property of the one real data set, not a disagreement
  between sources.
- **Open question:** one residual item, not build-blocking: **exact bracket-boundary edge
  semantics** — is a boom length of exactly 380.0 ft the top of the 361–380 ft bracket or the
  bottom of 381–400 ft; is exactly 440.0 ft in-range or does the >440 clamp apply at 440 itself?
  Comment `23099` does not address this; the bracket labels imply no overlap but no source states
  inclusive/exclusive semantics explicitly. See Q5's closing note.
- **Acceptance:** Given a crane's `mainBoomLength` (once numeric, per REQ-17) and an employee
  type (Oiler or Operator), the system selects and visually marks the matching bracket from the
  16-row table above as suggested; for an Oiler above 380 ft, the suggested bracket is `OI-BP-15`
  ($3.750/hr); the employee may select any other available option instead. Exact boundary
  -inclusion behavior at 380 ft and 440 ft: `NOT SPECIFIED`, flag for the executor to choose a
  convention (e.g. inclusive-upper) and note it, pending confirmation.
- **Notes for the executor:** The rate table above is now real build data — implement the
  bracket-matching logic against it directly. Do not implement it as a client-side hardcoded
  constant the way the old `BOOM_BRACKETS` was — treat it as seed/reference data, consistent with
  REQ-10's "shared, reusable function" requirement and this schema's general pattern for
  admin-configurable reference tables (cf. `EmployeeCraftCode`/`EmployeeUnionCode`). Depends on
  REQ-17 landing (`mainBoomLength` numeric) before this can run against real asset data end to
  end — build the bracket-matching function against a numeric input regardless of whether
  REQ-17's migration has shipped yet, so the two can land independently.

### REQ-06 — Only the Oiler's ticket carries Checklist/Labor/Unit steps `[UNVERIFIED]`

- **Statement:** Within a job set, only the ticket issued to the Oiler-type employee includes
  the Checklist, Labor, and Unit workflow steps; tickets issued to other employees in the same
  set do not include these steps.
- **Surface:** api, mobile
- **Sources:**
  - `SCRUM-877` comment `22923` — `[UNVERIFIED]` — kind: jira — "Only the Oiler's ticket should
    include the Checklist, Labor, and Unit steps. Tickets for other employees should not include
    these steps."
  - `apps/mobile/data/compose-ticket-detail.ts:22,62-70` — kind: code — this exact behavior
    **already exists client-side today**: `CHECKLIST_ONLY_FOR_OILER_KEYS` gates `pretrip`/`jsa`/
    `posttrip`/`compliance` steps, and `getVisibleSteps(employeeTypeName)` filters the step list
    for non-Oilers, renumbering `n`. Gating is driven by the logged-in user's own
    `employeeTypeName` (from `GET /users/me`, `apps/api/src/presentation/users/
    users.controller.ts:37`), not by any per-ticket/per-set backend flag.
  - `apps/mobile/app/(field)/ticket/step/[key].tsx:114-116` — kind: code — `isOiler =
    identity?.employeeType?.name === OILER_TYPE_NAME` confirms the same gate is checked again at
    the step-detail level.
- **Conflict:** none. Existing behavior already matches the ticket's ask for Checklist steps
  (`pretrip`/`jsa`/`posttrip`/`compliance`); **Labor and Unit steps are not currently included in
  `CHECKLIST_ONLY_FOR_OILER_KEYS`** — confirmed by reading the set literal, which lists only the
  four checklist/compliance keys, not `labor` or `unit`. This is a gap between current code and
  the ticket's ask, not a conflict between sources.
- **Open question:** none — this is additive to existing, working logic.
- **Acceptance:** For a non-Oiler employee's ticket, the Labor and Unit steps do not appear in
  the ticket's step list at all (not merely hidden/disabled). For the Oiler's ticket, they do.
- **Notes for the executor:** Extend `CHECKLIST_ONLY_FOR_OILER_KEYS` (or the mechanism it
  represents) to include `labor` and whatever key represents the Unit step — confirm the Unit
  step's key against `resolveStepKind` (`apps/mobile/features/field-ticket/steps/
  resolve-step-kind.ts`). Also note per REQ-10/Q4: today's gate is driven by the *global* logged
  -in identity's employee type, not by a backend-computed "is this the Oiler for this specific
  set" fact — the two coincide only because the app currently has one hardcoded mock crew.
  Moving to real multi-employee sets means the "am I the Oiler of this set" check must move
  server-side (or be validated server-side) rather than trusted from client identity alone —
  otherwise an Operator's app instance, if it ever received a payload shaped like a labor
  capture, has no reason server-side to reject it.

### REQ-07 — Oiler enters Labor/Unit data for Oiler + Operator-type employees on boom in the set `[VERIFIED]`

- **Statement:** The Oiler's ticket displays individual cards for the Oiler themselves and every
  **Operator-type employee who works on the boom** in the same set — **not every employee type in
  the set.** Employee types who do not work on the boom (e.g. Laborer, Supervisor, agency crew)
  are not given a Labor/Unit card at all and this step is never recorded for them. The set is
  resolved via `JobResourceAllocation.setResourceId`, confirmed sufficient by the product owner —
  no new junction/link table is required.
- **Surface:** schema, api, mobile
- **Sources:**
  - `.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md` Q2
    and the *Oiler's entry scope narrowed* section — `[VERIFIED]` — kind: decision. Comment
    `23025` (tcgproject12, 2026-08-21 14:46): "oiler will be responsible for filling the labour
    data for oiler and operator type employees only who work on boom. For rest of the employee
    type we do not record this step as they do not work on the boom." Comment `23066`
    (tcgproject12, 2026-08-21 17:38) Q2: "I believe the current information is sufficient... A
    per-day job can contain multiple sets per shift, and each shift will have either exactly one
    crane or no crane, along with an oiler and other resources such as operators, loads, and
    employees. We create tickets for the employees assigned to each group. Within each
    set/group, the oiler-type employee's ticket is responsible for entering the labor data for
    the other employees. Therefore, oiler tickets need to be linked to the corresponding employee
    tickets."
  - **On the "linked" wording specifically:** the decision record reads this precisely, and this
    spec adopts that reading rather than treating "linked" as a request for new schema: "the
    phrase 'oiler tickets need to be linked to the corresponding employee tickets' describes the
    outcome the `setResourceId` join must produce (the Oiler's write reaching each teammate's own
    ticket record), not a request for a new link/junction entity. No new table is authorized by
    this answer." The product owner's own words are quoted above in full so a future reader can
    verify this reading against the primary language rather than trusting this spec's paraphrase.
  - `apps/api/prisma/schema.prisma:3266,2968` — kind: code — `JobResourceAllocation.
    setResourceId` (plain UUID column, FK to `JobResource.id`, root of the `JobResource.parentId`
    self-referential chain) remains the mechanism, now confirmed adequate rather than merely
    proposed. `JobTicket` still has no direct `setResourceId` field — the join is
    `JobTicket.allocationId → JobResourceAllocation.setResourceId`.
  - `apps/api/src/usecase/das-allocations/das-allocations.service.ts:589-606` and
    `apps/api/src/usecase/das-loadout/das-loadout-defer-allocation.util.ts:82-91` — kind: code —
    the two existing, unshared `resolveSetRoot` implementations remain relevant precedent for
    building the (now confirmed-necessary) reusable set-resolution query.
  - `apps/mobile/data/compose-ticket-detail.ts` (`RAW_CREW` mock) — kind: code — still a
    two-person hardcoded fixture; must be replaced with a real `setResourceId`-based query per
    this requirement, now that the mechanism is confirmed rather than merely proposed.
- **Conflict:** none.
- **Open question:** none for the mechanism. The card content/layout is now informed by the
  viewable attachment images (see §6) but the exhaustive set of "which employee types count as
  working on boom" beyond Oiler/Operator is not separately enumerated anywhere — treated as
  `NOT SPECIFIED` beyond "Oiler and Operator only," per the decision's explicit narrowing.
- **Acceptance:** Given a set with one Oiler, N Operator-type employees who work on boom, and M
  other employee types who do not, the Oiler's ticket shows exactly `1 + N` cards (Oiler's own
  plus each qualifying Operator's), and none of the M non-boom employees' tickets ever gain a
  Labor/Unit step.
- **Notes for the executor:** Build the set-resolution query (`JobTicket → JobResourceAllocation.
  setResourceId → sibling JobResourceAllocations → sibling JobTickets`, filtered to Oiler +
  Operator employee types) as a single reusable repository method. Do not build a new junction
  table — the decision record is explicit that none is authorized. Consolidating the two existing
  `resolveSetRoot` copies into one shared utility would benefit this and other DAS work but is
  out of scope unless a unit is explicitly cut for it.

### REQ-08 — Craft Modifier selected by Oiler applies to Oiler + Operator-type set members `[UNVERIFIED — propagation mechanism]` / rate values now `[VERIFIED]` via REQ-05

- **Statement:** When the Oiler selects a Craft Modifier/Boom Pay bracket, that same bracket
  selection applies to every Oiler/Operator-type employee in the set (narrowed from "all
  employees," per REQ-07's scope correction) — subject to the oiler/operator rate split within
  that bracket, now `[VERIFIED]` per REQ-05's 16-row table (the bracket selection is shared; the
  resulting dollar rate is not identical across the two employee types even for the same
  bracket, per the table's own per-employee-type columns).
- **Surface:** api
- **Sources:**
  - `SCRUM-877` comment `22923` — `[UNVERIFIED]` — kind: jira — "The Craft Modifier selected by
    the Oiler should be applied to all other employees in the same set." This specific
    propagation clause remains sourced only to the original comment, still `[UNVERIFIED]` — no
    decision record has separately re-confirmed *that a shared selection propagates*, only that
    *what the rate would be once it does* is now known (REQ-05).
  - `.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-boom-pay-rate-table.md` —
    `[VERIFIED]` — kind: decision — the 16-row table (see REQ-05) confirms the rate split
    between Oiler and Operator codes for the same boom-length bracket is real and asymmetric at
    the top of the range — this settles what value gets propagated, not whether the propagation
    behavior itself was separately confirmed.
- **Conflict:** none stated. No longer blocked by REQ-07 (verified) or by missing rate values
  (REQ-05, now verified) — the only remaining gap is the propagation mechanism's own
  confirmation, which was never separately asked about beyond the original ticket comment.
- **Open question:** not separately logged as a numbered Q — the original comment's propagation
  claim (`22923`) has simply never been independently re-confirmed the way most of this ticket's
  other claims have been. Not blocking: the two prior decision records answered nine-plus
  questions between them without anyone flagging this one as contested, and building the
  propagation mechanism carries low risk of contradicting a future answer.
- **Acceptance:** Given an Oiler's bracket selection on their own set, every qualifying
  Oiler/Operator-type teammate's record reflects that same selected bracket, with each
  teammate's applied dollar rate drawn from REQ-05's table by their own employee type — not a
  single shared rate.
- **Notes for the executor:** Fully buildable now — REQ-05's rate values no longer block this.
  Build the propagation mechanism (one Oiler write updates the bracket field on every qualifying
  set member's record) and apply REQ-05's per-employee-type rate lookup independently per
  teammate.

### REQ-09 — Net billing computed per-employee `[UNVERIFIED]`

- **Statement:** Even though the Oiler enters all Labor/Unit data for the set from one screen,
  each employee's net billable hours are computed from that individual employee's own ticket
  timing, using the same net-billing logic as REQ-02.
- **Surface:** api
- **Sources:**
  - `SCRUM-877` comment `22923` — `[UNVERIFIED]` — kind: jira — "For each employee, the net
    billing should be calculated based on their individual ticket time, while following the same
    net billing calculation logic defined above."
- **Conflict:** none stated.
- **Open question:** none beyond REQ-02/REQ-03's own open items, which this inherits per
  employee.
- **Acceptance:** Given N employees in a set with N different sets of ticket timestamps, the
  system computes N independent net-billable-hours figures, none derived from another employee's
  time.
- **Notes for the executor:** This requirement is straightforward once REQ-02/REQ-03/REQ-07/
  REQ-10 are resolved — it mainly constrains the implementation to not accidentally broadcast one
  employee's boom/lunch timestamps onto another's calculation just because they share a Craft
  Modifier selection (REQ-08).

### REQ-10 — Backend persists against each individual employee's ticket, via a shared calculation function `[VERIFIED — mechanism]` / `[OPEN — model field list, now narrower]`

- **Statement:** The backend records Labor and Unit information against each individual
  employee's own ticket even when the Oiler entered it, using the `setResourceId`-based
  authorization mechanism confirmed in REQ-07 (no new junction table). The billable-hours
  calculation (REQ-01/REQ-02) runs **server-side** and is built as a **reusable, shared
  function/service** — not inlined into one endpoint — because the product owner has stated it
  will be reused by the future payroll module. **The new model's field list is narrower now**:
  REQ-05's rate table is `[VERIFIED]` and REQ-16/REQ-17's migrations are both authorized, so what
  remains open is precision/scale/backfill detail for those two migrations, not the shape of the
  reference data this model needs to point at.
- **Surface:** schema, api
- **Sources:**
  - `.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md` Q2
    and Q4 — `[VERIFIED]` — kind: decision. Q2 confirms the `setResourceId` mechanism is
    sufficient; Q4 confirms server-side, authoritative, reusable-function computation.
  - `.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-boom-pay-rate-table.md` —
    `[VERIFIED]` — kind: decision — supplies the actual rate table (REQ-05) and authorizes
    `mainBoomLength`'s migration (REQ-17), both of which this model's shared calculation function
    will read from — resolving what had been the two largest sources of shape-uncertainty for
    this requirement.
  - `SCRUM-877` comment `22923` — `[UNVERIFIED]` — kind: jira — original persistence-model
    language, superseded in specificity by both decisions above.
  - `apps/api/prisma/schema.prisma` — kind: code — the seven existing `jobTicketId`-FK models and
    the `capturedByUserId` pattern remain the correct precedent for the still-undesigned new
    model.
  - `apps/api/src/usecase/job-tickets/job-tickets.service.ts:648-657` —
    `getTicketForEmployeeAction` — kind: code — still cannot authorize an Oiler writing to a
    teammate's ticket; a new, additional, `setResourceId`-based authorization path is still
    required.
- **Conflict:** n/a.
- **Open question:** narrowed to: precision/scale and backfill strategy for REQ-16/REQ-17's
  migrations (see those requirements), and the implementation-design question of where the
  "reusable function" boundary sits (`packages/shared` vs. an `apps/api`-only injectable service)
  — the product owner said "reusable," not where. Not logged as a numbered Q; an
  implementation-design choice the executor can resolve within the stated constraint.
- **Acceptance:** Given an Oiler's write to a teammate's ticket within the same `setResourceId`,
  the resulting Labor/Unit record persists with `jobTicketId` = the teammate's ticket,
  `capturedByUserId` = the Oiler's `User.id`, and the billable-hours and applied-rate figures are
  produced by calling one shared calculation function, unit-testable in isolation, referencing
  REQ-05's rate table and REQ-17's numeric boom-length input. An Oiler on a different set (same
  `subJobId`, different `setResourceId`) is rejected.
- **Notes for the executor:** Structure the calculation as a pure function (inputs: timestamps,
  lunch/WTL events, numeric boom length; output: Labor Total Hours, Net Billable Hours, applied
  bracket + rate) callable from both the new Labor/Unit endpoint and, later, a payroll service —
  do not couple it to `JobTicket`-specific request/response shapes. New authorization method
  alongside (not replacing) `getTicketForEmployeeAction`, keyed on matching `setResourceId`.

### REQ-11 — Labor Classification selection `[UNVERIFIED]`

- **Statement:** The employee selects a Labor Classification for the entry, from configured
  system data that can include Job Site Work, Shop Work, Travel, and Site Inspection.
- **Surface:** schema, api, mobile
- **Sources:**
  - `product/atom-mobile-app-user-stories/05-compliance-labor-and-review.md` US-18 —
    `[UNVERIFIED]` — kind: vault — "Employee selects the applicable Labor Classification.
    Available classifications come from the applicable configured system data and can include
    Job Site Work, Shop Work, Travel and Site Inspection where applicable." The file's own
    migration note flags: "these values do not appear in any payroll document. Nothing states
    how a classification maps to a payroll group or affects pricing."
  - `SCRUM-877` description — `[UNVERIFIED]` — kind: jira — identical text (the ticket
    description is a verbatim copy of the US-18 acceptance criteria).
- **Conflict:** none between documents (ticket and vault story agree verbatim), but see the
  vault's own caveat above — this is a case where two sources agreeing is not two sources, since
  the ticket description appears to have been copy-pasted from the vault story rather than
  independently authored. Treated here as one source, not two.
- **Open question:** where "configured system data" for Labor Classification actually lives —
  no schema table, enum, or seed list for these four values exists today (not independently
  verified against the schema in this run; flagged as unconfirmed rather than asserted `[OPEN]`
  outright, since the ticket's own wording ("can include," "where applicable") suggests these
  four are illustrative, not exhaustive, and a schema search was out of this run's scope — see
  Q8).
- **Acceptance:** `NOT SPECIFIED` pending Q8.
- **Notes for the executor:** `NOT SPECIFIED` how classification affects payroll pricing — the
  vault source explicitly says this is undocumented anywhere. Do not infer a payroll-group
  mapping.

### REQ-12 — Employee can adjust Labor information; comments `[UNVERIFIED]`

- **Statement:** The employee can adjust Labor information where the applicable business rules
  permit, and can record comments on the entry.
- **Surface:** api, mobile
- **Sources:**
  - `product/atom-mobile-app-user-stories/05-compliance-labor-and-review.md` US-18 —
    `[UNVERIFIED]` — kind: vault — "Employee can adjust Labor information where permitted by the
    applicable business rules... Employee can record applicable comments."
  - `apps/mobile/features/field-ticket/steps/LaborBody.tsx:141-147` — kind: code — a comments
    `VoiceTextarea` already exists on the current Labor step UI.
- **Conflict:** none.
- **Open question:** "where permitted by the applicable business rules" names no rules — this
  spec does not know which fields are editable vs. locked, for whom, under what conditions. Not
  elevated to a full `[OPEN]` block because comments capture itself is unambiguous and already
  built; the "business rules" clause is `NOT SPECIFIED` rather than blocking.
- **Acceptance:** Comments field accepts free text, persisted with the Labor/Unit record.
  Adjustment-permission rules: `NOT SPECIFIED`.
- **Notes for the executor:** Reuse the existing `VoiceTextarea` comments pattern from
  `LaborBody.tsx`.

### REQ-13 — Unit/Asset information displayed `[UNVERIFIED]`

- **Statement:** Applicable Unit/Asset information is displayed on the Labor & Unit screen.
- **Surface:** mobile
- **Sources:**
  - `product/atom-mobile-app-user-stories/05-compliance-labor-and-review.md` US-18 —
    `[UNVERIFIED]` — kind: vault — "Applicable Unit/Asset information is displayed."
- **Conflict:** none.
- **Open question:** partially narrowed by the now-viewable attachment images (relayed as a
  description of screenshots, not a durable Jira-hosted source — see Q7's update), which show a
  single-screen "Labor & Unit Details" layout (Auto-Calculated Hours card, then one card per
  qualifying crew member, no separate "Unit" screen/step visible in either image) rather than a
  distinct Unit step. **This spec does not treat that description as settling the question**,
  because it did not reach this agent as a citable, durable source — it is a relay of what
  someone saw in a screenshot pasted into a chat, not a Jira attachment this agent or a future
  reader can independently open and re-check. See Q7.
- **Acceptance:** `NOT SPECIFIED` — no durably-sourced description states which asset fields
  display or in what exact layout.
- **Notes for the executor:** `NOT SPECIFIED`. If the images described in the coordinator relay
  are confirmed by re-attaching them to the ticket as text or by restoring agent access to the
  attachments, revisit this requirement with that as a proper citable source.

### REQ-14 — Confirmed Labor information retained for downstream Payroll `[VERIFIED — deferred, not adjudicated]`

- **Statement:** Retention for downstream Payroll processing is out of scope for this ticket's
  build. The field-ops-vs-payroll disagreement this spec originally logged as a conflict is not
  resolved by this decision — it is explicitly deferred to a future payroll-module ticket.
- **Surface:** schema, api
- **Sources:**
  - `.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md`,
    final section — `[VERIFIED — deferral, not adjudication]` — kind: decision — comment `23066`
    (tcgproject12, 2026-08-21 17:38), final line: "Please also skip the conflict-related point.
    Payroll has not been implemented yet, so any payroll-related requirements will be addressed
    as part of the payroll module in the future." The decision record is explicit that this
    "does not close `payroll/gaps.md#field-ops-lunch-capture-vs-payroll-wtl` — that gap is
    independently logged, is a payroll-domain gap... and remains open on its own record."
  - `payroll/gaps.md` → *Field-ops lunch capture vs payroll WTL* — `[UNVERIFIED]` — kind: vault —
    **left untouched by this update**, per the decision record's own statement and per this
    agent's write scope (this spec does not edit `payroll/gaps.md`). Still documents the live
    three-vs-four lunch-threshold disagreement between field-ops and payroll sources.
- **Conflict:** the two previously-logged conflicts (this ticket's field-ops-additive-overtime
  vs. payroll's daily-accumulation model, and the pre-existing lunch/WTL threshold mismatch) are
  **deferred by explicit product-owner instruction, not adjudicated.** Neither this spec nor the
  decision record picks a side. SCRUM-877 proceeds using its own stated formula (REQ-01/REQ-02)
  understanding that the resulting figures may not match whatever the future payroll engine
  computes from the same raw data — that mismatch risk is accepted, not eliminated.
- **Open question:** none new for this ticket. The general questions (who owns overtime pricing;
  which lunch-threshold values are correct) remain open for the future payroll ticket that will
  need to ask them again.
- **Acceptance:** N/A for this ticket — no payroll-retention-correctness acceptance criterion is
  being built here. REQ-01/REQ-02's figures persist as this ticket's own outputs; reconciling them
  against a payroll engine is out of scope.
- **Notes for the executor:** Do not attempt to reconcile the lunch-threshold disagreement or the
  overtime-ownership question as part of this ticket, even opportunistically. Persist Labor/Unit
  data (REQ-10) in a form that is at least inspectable later (raw timestamps alongside derived
  figures, not derived figures alone) so a future payroll ticket has what it needs to reconcile,
  without this ticket having to do the reconciling.

### REQ-15 — Non-Oiler employee can view their own Labor/Unit data, read-only `[VERIFIED]`

- **Statement:** An employee whose Labor/Unit data was entered by their Oiler can see that data
  themselves, read-only, even though their own ticket carries no Labor/Unit *entry* step
  (REQ-06 is unchanged — the step itself remains Oiler-only).
- **Surface:** mobile, api
- **Sources:**
  - `.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md` Q9
    — `[VERIFIED]` — kind: decision — comment `23025` (tcgproject12, 2026-08-21 14:46): "Can a
    non-Oiler ever see their own labor data, even read-only?" Comment `23062` (Umair Khan,
    2026-08-21 16:42): "Can a non-Oiler see their own labor data read-only?: They should see for
    read only" — Yes. Comment `23066` (tcgproject12, 2026-08-21 17:38), consolidated Q1–Q9 block:
    "Q9: Yes." The decision record independently verified these two comments agree with each
    other on direct re-fetch of the live thread, and that no self-contradiction exists in the
    actual ticket text — see the *2026-08-21 update* note at the top of this spec for why that
    verification mattered.
- **Conflict:** none.
- **Open question:** none for the yes/no. The read-only *view*'s layout/route is `NOT SPECIFIED`
  — nothing states where in the app this shows or what it looks like.
- **Acceptance:** A non-Oiler employee, viewing their own completed ticket, can see their
  Labor/Unit figures (at minimum Net Billable Hours and the applied Craft Modifier bracket) in
  some read-only presentation. Exact screen/route: `NOT SPECIFIED`.
- **Notes for the executor:** This is additive scope beyond REQ-06/REQ-07/REQ-10's write path —
  it requires only a read endpoint scoped by the existing `getTicketForEmployeeAction`
  ("this is my own ticket") check, which already works correctly for this case since it is the
  employee reading their own ticket, not writing to someone else's.

### REQ-16 — `Asset.capacity` becomes numeric/decimal `[VERIFIED]`

- **Statement:** `Asset.capacity` (currently `String? @db.VarChar(50)`, free text) is confirmed
  to become a numeric type accepting decimal values, storing the tonnage value.
- **Surface:** schema
- **Sources:**
  - `.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md` Q6
    — `[VERIFIED]` — kind: decision — comment `23066` (tcgproject12, 2026-08-21 17:38): "The
    Asset Capacity field, which stores the tonnage value, should be numeric and should accept
    decimal values."
  - `apps/api/prisma/schema.prisma:707` — kind: code — current type, confirmed unchanged as of
    this update: `capacity String? @db.VarChar(50)`.
- **Conflict:** none.
- **Open question:** none remaining for this requirement itself. (Previously flagged that
  REQ-05's bracket-matching axis is boom length, not tonnage, and that boom length's field was
  unlocated — **the field is now located, `Asset.mainBoomLength`, verified directly against the
  schema this update, see REQ-17.** It is a separate field from `capacity` and needs its own,
  separate migration; REQ-16 does not satisfy it.)
- **Acceptance:** `Asset.capacity` migrates from `String? @db.VarChar(50)` to a numeric/decimal
  type (e.g. `Decimal? @db.Decimal(8,2)` — precision/scale `NOT SPECIFIED` by the decision;
  choose per existing money/measurement field conventions in the schema) via a committed
  migration. Existing free-text values require a backfill/conversion strategy — `NOT SPECIFIED`
  by any source; flag for the executor.
- **Notes for the executor:** This is schema-blocking on its own, independent of REQ-17 — do
  this migration regardless. Check every existing consumer of `Asset.capacity` before converting
  (the field is read in at least the DAS/asset-management surfaces per prior investigation in
  this ticket's build-up); a free-text-to-numeric conversion has real backward-compatibility risk
  for any existing non-numeric values in production data.

### REQ-17 — `Asset.mainBoomLength` becomes numeric/decimal `[VERIFIED]` / `[OPEN — precision/scale/backfill only]`

- **Statement:** `Asset.mainBoomLength` already exists in the schema
  (`apps/api/prisma/schema.prisma:758`, `String? @map("main_boom_length") @db.VarChar(30)`) and
  is, independently, the field REQ-05's boom-length bracket-matching needs. It is currently
  free-text, in the same pattern `Asset.capacity` was in before REQ-16. **The migration to
  numeric is now directly authorized by the product owner**, not merely inferred by analogy to
  REQ-16 as in the prior update — comment `23099` addresses this field specifically.
- **Surface:** schema
- **Sources:**
  - `apps/api/prisma/schema.prisma:758` — kind: code — `[VERIFIED — by direct schema read,
    re-confirmed this update]` — exact current definition: `mainBoomLength String? @map
    ("main_boom_length") @db.VarChar(30)`. Distinguished from a same-named field on a different,
    unrelated model (`UnitVehicleRegistration.mainBoomLength`, line 1040) and from
    `Plan.boomLength` (line 2783) — this requirement concerns `Asset.mainBoomLength`
    specifically, since `Asset` is what REQ-05's bracket-matching reads from.
  - `.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-boom-pay-rate-table.md` —
    `[VERIFIED]` — kind: decision — comment `23099` (tcgproject12, 2026-08-21T19:06:25.493+0500),
    verbatim: "Main Boom Length field: recorded on the Asset module in feet, separate from Asset
    Capacity (tonnage). Confirmed: should also be converted to a numeric field, same as Asset
    Capacity." This is a direct, specific authorization — not an inference from REQ-16's
    precedent — and supersedes this requirement's prior `[OPEN — whether/when to migrate]` flag.
    The decision record is explicit that precision/scale and backfill strategy are **not**
    addressed by this comment, "exactly as they were not addressed for `Asset.capacity`/REQ-16
    either."
  - `apps/api/prisma/schema.prisma:707` (REQ-16) — kind: code — the sibling migration this one
    mirrors in shape; both are now authorized on their own, independently confirmed grounds.
- **Conflict:** none.
- **Open question:** precision/scale (e.g. `Decimal(p,s)` — not stated by any source, for either
  this field or `capacity`) and backfill/conversion strategy for existing free-text values —
  identical in kind to REQ-16's residual gap, not addressed by comment `23099`.
- **Acceptance:** `Asset.mainBoomLength` migrates from `String? @db.VarChar(30)` to a
  numeric/decimal type via a committed migration. Precision/scale and backfill strategy: `NOT
  SPECIFIED` by any source; flag for the executor, consistent with REQ-16's identical gap.
- **Notes for the executor:** Both REQ-16 and REQ-17 are now independently authorized migrations
  on the same `Asset` model — reasonable to design and review together (same model, same
  free-text-to-numeric shape, same unanswered precision/backfill questions) even though they
  were authorized in two separate conversations. Check every existing consumer of
  `Asset.mainBoomLength` before converting, same caution as REQ-16.

---

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** yes
- **Migration required:** yes — `pnpm db:migrate`, committed under
  `apps/api/prisma/migrations/`
- **Data backfill required:** `NOT SPECIFIED`

No model is proposed below, still — but nearly everything that would have shaped it is now
resolved. The mechanism questions (junction table? client- vs. server-side computation?) were
answered by the first decision record; the rate-table values, the above-380ft Oiler fallback,
and `mainBoomLength`'s migration authorization are now answered by the second
(`.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-boom-pay-rate-table.md`). What
remains before a real `prisma` block can be written is narrow: precision/scale and backfill for
two now-authorized migrations, and the executor's own choice of where the new labor/unit model's
reference-data FKs point. What is known without inventing shape:

- A new labor/unit record model will need `jobTicketId` (whose record — the target employee's
  ticket) and `capturedByUserId` (who entered it), following the existing
  `TicketLunchBreak`/`TicketSignature` pattern (`apps/api/prisma/schema.prisma:4131,4036`). This
  is a confirmed design direction (REQ-10).
- `Asset.capacity` (`apps/api/prisma/schema.prisma:707`, `String? @db.VarChar(50)`, tonnage) **is
  confirmed to become numeric/decimal** (REQ-16, `[VERIFIED]`) — a scheduled migration, precision
  /scale/backfill still `NOT SPECIFIED`.
- `Asset.mainBoomLength` (`apps/api/prisma/schema.prisma:758`, `String? @map("main_boom_length")
  @db.VarChar(30)`, boom length — a distinct field from `capacity`) **is now also confirmed to
  become numeric/decimal** (REQ-17, `[VERIFIED]`, authorized directly by comment `23099` —
  previously this spec only had this by analogy to REQ-16, now it is a direct answer). Same
  precision/scale/backfill gap as REQ-16.
- The Craft Modifier/Boom Pay bracket table (16 rows, boom-length ranges with per-employee-type
  rates, confirmed genuinely asymmetric above 380 ft) is now `[VERIFIED]` real reference data
  (REQ-05, comment `23099`) — no longer a candidate awaiting citation. It needs a home: either a
  new seed/reference table in the schema, or a configuration constant read by the shared
  calculation function (REQ-10) — the executor's call, since no source specifies the storage
  shape, only the values and the matching rule.

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| `OPEN` — see REQ-10 (field list now largely resolved; open only on precision/scale/backfill for REQ-16/REQ-17, and the bracket-table's storage shape) | — | — | — | REQ-10, REQ-05, REQ-16, REQ-17 |

- **New prefix introduced:** `OPEN` — depends on REQ-10's final model shape.
- **Child relations:** `NOT SPECIFIED` until the model shape resolves; will include `jobTicketId`
  and `capturedByUserId` FKs per REQ-10.
- **Fields whose type/precision no source states:** the new labor/unit model's full field list —
  still open pending REQ-05's rate values (and its new above-380ft question) and REQ-17's
  migration authorization.

---

## 4. API surface — `apps/api`

No endpoint table is written yet. The mechanism decisions that would have shaped it (set
-resolution approach, computation location, reuse requirement) are now answered — REQ-07/REQ-10
— but the endpoint still cannot be finalized until REQ-05's rate values and REQ-16's migration
land, since the request/response shape depends on what the new model actually holds.

What is known without inventing an endpoint:

- The existing `getTicketForEmployeeAction` guard (`apps/api/src/usecase/job-tickets/
  job-tickets.service.ts:648-657`) must gain a sibling authorization path for "acting user is the
  Oiler of the same set as the target ticket," confirmed `setResourceId`-based — this cannot be a
  modification of the existing method (used at four call sites for the ordinary "this is my
  ticket" case) but a new, additional check.
- `PATCH /field/tickets/:id/step-progress` (`apps/api/src/presentation/field-tickets/
  field-tickets.controller.ts:109-117`) is confirmed payload-less today (`RecordStepProgressDto`
  carries only `stepKey`) and is not a candidate to carry Labor/Unit payloads — every other step
  that reaches the backend with real data (signature, checklist) does so via its own dedicated,
  payload-bearing endpoint, then separately also fires the payload-less progress marker. The new
  Labor/Unit endpoint(s) should follow that same established pattern, not extend
  `step-progress`.
- A new read endpoint (or an existing ticket-detail endpoint extended) is needed for REQ-15 —
  non-Oiler read-only access to their own Labor/Unit data. This can use the existing
  `getTicketForEmployeeAction` check unmodified, since it is the ordinary "this is my own ticket"
  case.
- The shared calculation function (REQ-10/Q4) should be a plain, framework-agnostic
  service/utility callable from whatever endpoint(s) end up shaped once the model exists — not
  designed around one specific controller method.

---

## 5. Web surface — `apps/web`

- **Routes:** `N/A — this feature is described only as a mobile field-ticket step in every
  source consulted (the ticket, US-18, both FRDs' FR-FOP-023/024). No source mentions a web
  counterpart.`
- **Existing components to reuse:** `N/A`
- **New components proposed:** `N/A`
- **Table (if any):** `N/A`
- **Forms:** `N/A`
- **Server state:** `N/A`
- **Colors / spacing:** `N/A`
- **Responsive:** `N/A`
- **Copy:** `N/A`

---

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** The existing Labor step at `apps/mobile/app/(field)/ticket/step/
  [key].tsx` (via `LaborBody.tsx`). No new route is indicated by any source; this is a rework of
  an existing step, not a new screen. A read-only view for REQ-15 (non-Oiler viewing their own
  data) needs a route or a mode of this same screen — `NOT SPECIFIED` which.
- **Components:** `apps/mobile/features/field-ticket/steps/LaborBody.tsx` already implements:
  a per-crew-member card list (`CrewCard`), an auto-calculated-hours summary card
  (`AutoHoursCard`), a boom-bracket picker with an "auto-suggested, employee can override, must
  give a reason if overridden" interaction pattern (`BOOM_BRACKETS`, `SUGGESTED_BOOM`, `boomMod`/
  `boomReason`), and a comments `VoiceTextarea`. This remains a strong structural precedent for
  REQ-04/REQ-05/REQ-07/REQ-12/REQ-13's UI — the override-with-reason pattern matches REQ-05's
  confirmed "system-suggested, employee can select a different option" shape exactly, though the
  concrete `BOOM_BRACKETS` values are now confirmed product-incorrect (REQ-05) and the crew list
  is still backed by mock data (REQ-07, still pending real wiring). **Do not build a new UI
  pattern for the override-with-reason interaction — reuse this one; replace only the data it
  reads from and the concrete bracket values.**

  **On the design-reference description relayed this session** (not independently viewable by
  this agent — see the *2026-08-21 update* note in §0 and Q7 below): a coordinator described two
  screenshots said to show this same screen's Auto-Calculated Hours card (Total, Travel, Boom,
  Lunch deduction, Net billable hours, a "< 8 hrs rest · flagged for payroll" pill), a per-crew
  -member card list with name/role/craft-code/hours, an Oiler card with read-only Union
  Class/Craft Code fields, a Total Hours input, and a Craft Modifier/Boom Pay dropdown with a
  "★ suggested" marker and helper text, plus a second screenshot showing the bracket dropdown's
  full option list. **This spec records that description here for continuity but does not cite
  it as a source for any requirement's acceptance criteria**, because a chat-relayed description
  of a screenshot is not the durable, independently-checkable source this role requires — the
  same content, reached through the Jira attachments themselves (ids `12450`, `12449`) once
  readable, or re-posted as text on the ticket, would be citable. Treat everything in this
  paragraph as unconfirmed color, consistent with what REQ-05 and REQ-01 already establish from
  citable sources, not as new information those requirements' acceptance criteria depend on.
- **Offline / sync behavior:** `NOT SPECIFIED` — no source addresses what happens if an Oiler
  enters Labor/Unit data for the crew while offline, or how conflicting concurrent edits (e.g.
  the Oiler and, hypothetically, another authorized party) would resolve. This is exactly the
  kind of silent gap the spec template warns against inferring from web behavior — not inferred
  here.
- **Touch targets:** 48px (per `.ai/claude/contexts/mobile.md` — a rule, binding regardless of
  ticket content).
- **Push / notifications involvement:** `N/A — no source mentions a notification for this flow.`

---

## 7. Shared package — `packages/shared`

- **Types added / changed:** `NOT SPECIFIED` until REQ-10's persistence model is decided — at
  that point, the new Labor/Unit DTO/response shape would need a shared type per the existing
  convention (`@tcg/shared` consumed by both web and mobile). Since REQ-05 (web N/A) removes the
  web consumer, whether this still warrants a `packages/shared` type or can live mobile-local is
  itself unaddressed by any source — flagged as a build-time decision for the executor, not
  elevated to a numbered open question since it does not block product decisions, only code
  organization.

---

## 8. Permissions and tenancy

- **Roles permitted:** Field employee (own ticket, per existing `getTicketForEmployeeAction`);
  Oiler-type employee (own ticket, plus every ticket sharing their allocation's `setResourceId`
  — new authorization path, REQ-10).
- **Roles denied:** A non-Oiler employee must not be able to write Labor/Unit data to another
  employee's ticket, including another Oiler's set (cross-set write must fail, not merely
  cross-`subJobId` write — see REQ-10's note on why `subJobId`-only scoping is actively wrong,
  not just imprecise).
- **Tenant isolation:** `NOT SPECIFIED` explicitly by any source, but standard tenant-scoping
  applies per platform convention (`.ai/claude/contexts/prisma.md`) — the new Labor/Unit model
  would carry `tenantCompanyId` like every other business entity, and any set-resolution query
  must stay within it. Not independently verified in this run whether the Prisma tenant-scoping
  client extension's allowlist would need updating for a new model — the executor should check
  the extension's model allowlist against `.ai/claude/contexts/prisma.md`'s guidance that
  scoping is "not unconditional."
- **Cross-tenant reads:** none.

---

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| WTL count per ticket | `NOT SPECIFIED` — no source states a maximum | — | — |
| Boom Pay override reason | Required when the Oiler's selection differs from the system
  -suggested range (mirrors the existing `boomMod`/`boomReason` pattern in `LaborBody.tsx`) |
  `SCRUM-877` comment `22923` ("the employee must manually select one of the available options"
  when no range matches) + `apps/mobile/features/field-ticket/steps/LaborBody.tsx` (existing
  pattern) | `[UNVERIFIED]` |
| Labor Classification values | `NOT SPECIFIED` — see Q8 whether the four named values are
  exhaustive or illustrative, and where they are configured | — | — |
| Comments field length | `NOT SPECIFIED` | — | — |

---

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit | Shared calculation function produces Labor Total Hours = boom + WTL×30min | REQ-01 |
| Unit | Same function's Net Billable Hours reconciles boom − lunch×30min + WTL×30min, no overtime term, yard/travel excluded | REQ-02 |
| Unit | Boom-length bracket matching selects/clamps correctly once the real table is populated | REQ-05 |
| Integration (API) | Oiler can write to a same-set (`setResourceId`) teammate's ticket; a same-`subJobId`-different-set employee cannot | REQ-10 |
| Integration (API) | Only Oiler + boom-working Operator-type employees in the set get cards; other employee types never get a Labor/Unit step | REQ-07 |
| Integration (API) | Non-Oiler ticket omits Checklist/Labor/Unit steps entirely | REQ-06 |
| Integration (API) | Craft Modifier bracket selected by Oiler propagates to all qualifying set members; per-employee-type rate still differs | REQ-08 |
| Integration (API) | Non-Oiler employee can read their own Labor/Unit data; cannot write to it | REQ-15 |
| E2E / manual script | `NOT SPECIFIED` beyond the above — no source describes an end-to-end script |  |

- Requirements with no testable acceptance criterion yet: REQ-05 (rate values, Q5), REQ-10
  (exact model shape, pending REQ-05/REQ-16), REQ-16 (backfill strategy `NOT SPECIFIED`) — all
  narrowed from fully-open to blocked-on-specific-values. REQ-11 and REQ-13 remain `NOT
  SPECIFIED` (Q8 deferred; images still unreadable).

---

## 11. Non-functional

- **Performance:** `NOT SPECIFIED`.
- **Concurrency:** `NOT SPECIFIED` explicitly, but flagged: if the Oiler edits a teammate's
  record while that teammate's own device also has their now-confirmed read-only view (REQ-15)
  open, no source addresses conflicting reads/writes or live-refresh behavior.
- **Audit / activity log:** `NOT SPECIFIED` whether Labor/Unit edits need an `ActivityLog` entry,
  though the existing sibling models' `capturedByUserId` pattern (REQ-10) provides a minimal
  "who entered this" audit trail regardless.
- **Migration/rollout order:** `NOT SPECIFIED` by any source. Given the dependency chain
  (schema → set-resolution query → authorization → API → mobile UI), the natural build order
  is schema/REQ-10 first, but this is an inference from architecture, not a stated requirement.

---

## 12. Open questions — the stop-and-ask list

**Status as of 2026-08-21, three rounds.** Round 1 (first decision record, durably sourced): Q1,
Q2, Q4, and Q9 answered and closed below. Q8 explicitly **deferred, not answered**. Round 2
(chat relay, not posted to Jira, not treated as a citable source): narrowed Q3 and Q6, and
raised Q10 and Q11 as brand-new open questions rather than resolving anything, because the
relayed content itself contained an internal inconsistency (Q10) and an inference this spec was
not willing to make unasked (Q11). **Round 3 (second decision record, comment `23099`, durably
sourced)** answers Q5 in full, Q10 in full, Q11 in full, and both halves of Q6 — the same values
round 2 had relayed in chat, now reaching this ticket through a citable channel. **Remaining
open after round 3: Q3 (narrowed to data-readiness only — the mechanism half comment `23099`
also re-touches is already closed), Q7, and Q8 (deferred).** REQ-05's only residual gap
(bracket-boundary edge semantics) is tracked as a closing note under Q5 rather than its own
numbered question, since it is a small executor-flaggable detail, not a blocked decision.

### Q1 — RESOLVED — overtime dropped from this ticket's scope

- **Resolution:** `.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md`,
  comment `23066` (tcgproject12, 2026-08-21 17:38): "We do not need to account for extra hours at
  this stage... For the ticket, we only need to calculate billable hours based on boom time and
  lunch breaks/WLTs." REQ-03 is removed from scope, not answered on its merits — the general
  question of which system owns overtime pricing remains open for a future payroll ticket, but no
  longer blocks anything here. See REQ-03.

### Q2 — RESOLVED — `setResourceId`-based resolution confirmed sufficient, no new link table

- **Resolution:** same decision record, comment `23066`: "I believe the current information is
  sufficient... Therefore, oiler tickets need to be linked to the corresponding employee
  tickets." Read precisely (full reasoning under REQ-07): this confirms the `setResourceId` join
  is the mechanism, not a request for new schema. REQ-07 and REQ-10 are unblocked on this point.

### Q3 — STILL OPEN, NARROWED TO DATA-READINESS ONLY — is there actually a usable Oiler-appropriate `EmployeeCraftCode` row in real data, and who's responsible if not?

- **Question:** The mechanism half of this question is now closed **twice over**: the first
  decision record confirmed which field to read (`Employee.craftCodeId → EmployeeCraftCode.
  label`), and the second decision record
  (`.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-boom-pay-rate-table.md`,
  comment `23099`) independently re-confirms, with durable Jira provenance this time, that
  `EmployeeCraftCode` is a Settings-tab admin-configured table, "no hardcoded value, no seed
  data needed" — matching what the round-2 chat relay had already said, now on a citable
  source. **What remains is purely operational, not a mechanism question at all**: does any real
  tenant have an Oiler-appropriate `EmployeeCraftCode` row actually configured today, and whose
  job is it to add one if not? Comment `23099` speaks only to mechanism, not to today's
  configured data — the decision record itself is explicit about this distinction and does not
  claim to close it. Today's seeded craft codes remain `OPERATOR`/`LABORER`/`MECHANIC`/
  `SUPERVISOR` (unchanged, `apps/api/prisma/migrations/
  20260703100000_employee_craft_and_work_comp_codes/migration.sql:82-87`) — seed data, not
  necessarily what any tenant's admins have configured since, so this neither confirms nor
  refutes the gap.
- **Why it cannot be answered from what is written:** No source — chat relay or Jira comment —
  addresses today's actual configured data for any tenant. This is not a question a code read or
  a product-owner mechanism confirmation can answer; it requires checking (or being told) what a
  specific tenant's admin has actually set up.
- **Blocked:** REQ-04's practical display (mechanism is fully `[VERIFIED]` and unblocked; only
  whether it will actually show something for a real Oiler today remains open).
- **Owner:** product team / whoever administers the craft-code settings module for TCG's tenant.
- **Logged:** `.ai/vault/gaps.md#scrum-877-labor-and-unit-details-oiler-crew-linking` —
  `Status: open` (narrowed to data-readiness only).
- **Workaround, if any:** Build and ship the display regardless — it degrades gracefully to
  blank if no craft code is assigned, per REQ-04's stated `NOT SPECIFIED` on that display case.
  Flag the data-readiness question to ops/product as a parallel, non-blocking action item.

### Q4 — RESOLVED — server-side, authoritative, reusable function

- **Resolution:** same decision record, comment `23066`: "The billable-hours calculation should
  be handled on the backend. We should create a reusable function for this logic so it can also
  be used later in the payroll module." REQ-01/REQ-02/REQ-09/REQ-10 all updated to reflect
  server-side, shared-function computation as the confirmed design direction.

### Q5 — RESOLVED (rate table and above-380ft rule) — small residual on bracket-boundary edge semantics only

- **Resolution:** `.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-boom-pay-rate-table.md`,
  comment `23099` (tcgproject12, 2026-08-21T19:06:25.493+0500, verified live via Atlassian MCP by
  `tcg-scrum`): the full 16-row `FMS_UNION_CRAFT_MODIFIER` table (reproduced in REQ-05), plus
  "Confirmed: the table is genuinely not symmetric — `OP-BP-17` (401–420 ft) does not exist in
  the source data, and there is no Oiler bracket at all above 380 ft." This is the same table the
  round-2 chat relay had already surfaced, now with a citable source — the values did not
  change, their citability did. Independently re-verified this update: no drift in the schema
  facts the decision record cites (`Asset.capacity`, `Asset.mainBoomLength`,
  `EmployeeCraftCode` all re-checked and unchanged).
- **Residual, not blocking:** exact bracket-boundary edge semantics (is 380.0 ft in the 361–380
  or 381–400 bracket; is 440.0 ft in-range or does the clamp apply at 440 itself) — comment
  `23099` does not address this, and it is small enough not to block building REQ-05. Flagged for
  the executor to choose a convention and note it.
- **Logged:** `.ai/vault/gaps.md#scrum-877-labor-and-unit-details-oiler-crew-linking` —
  `Status: resolved for the rate table and the above-380ft rule; boundary-edge semantics carried
  forward as a small, non-blocking residual`.

### Q6 — RESOLVED, both halves

- **Resolution (tonnage):** first decision record, comment `23066`: "The Asset Capacity field...
  should be numeric and should accept decimal values." See REQ-16.
- **Resolution (boom-length field, both location and migration):** `Asset.mainBoomLength`
  location verified directly against the schema (`apps/api/prisma/schema.prisma:758`); its
  migration to numeric is now directly authorized by comment `23099`: "Main Boom Length field:
  recorded on the Asset module in feet, separate from Asset Capacity (tonnage). Confirmed: should
  also be converted to a numeric field, same as Asset Capacity." See REQ-17. Precision/scale and
  backfill for both fields remain `NOT SPECIFIED` by any source — tracked as its own residual
  item, not reopening Q6 itself.
- **Logged:** `.ai/vault/gaps.md#scrum-877-labor-and-unit-details-oiler-crew-linking` —
  `Status: resolved`.

### Q10 — RESOLVED — above-380ft Oiler rate = `OI-BP-15`, $3.750/hr; option (c) explicitly ruled out

- **Resolution:** comment `23099`: "Confirmed rule for an Oiler on a crane with boom length
  above 380 ft: use the 361–380 ft bracket's Oiler rate — `OI-BP-15`, $3.750/hr." This chooses
  option (a) from the three this spec had listed without picking among, and the same comment's
  "genuinely not symmetric... does not exist in the source data" language explicitly forecloses
  option (c) (a transcription gap) — the asymmetry is a real, confirmed property of the source
  data, not an artifact of how it reached this ticket.
- **Logged:** `.ai/vault/gaps.md#scrum-877-labor-and-unit-details-oiler-crew-linking` —
  `Status: resolved`.

### Q11 — RESOLVED — `Asset.mainBoomLength` migrates to numeric, directly authorized

- **Resolution:** comment `23099`, quoted in full under Q6 above — an explicit, specific
  authorization naming `mainBoomLength` directly, not an inference from REQ-16's precedent. This
  is exactly the direct confirmation this question asked for rather than assumed. See REQ-17.
- **Logged:** `.ai/vault/gaps.md#scrum-877-labor-and-unit-details-oiler-crew-linking` —
  `Status: resolved`.

### Q7 — STILL OPEN — the two attachment images remain unreadable by any agent in this loop

- **Question:** What do attachments `12450` (`image-20260820-131819.png`) and `12449`
  (`image-20260820-132954.png`) actually show?
- **Why it cannot be answered from what is written:** Direct Atlassian API attachment-content
  fetch still returns HTTP 403 for this role; no MCP tool available exposes Jira attachment
  binaries as viewable media. **A description of what these images are said to show reached this
  session once, via a coordinator relaying screenshots someone pasted into a chat.** That
  description is recorded, with full attribution to that channel, in §0 and §6 above — but it is
  **not treated as a citable source for any requirement's acceptance criteria in this spec**,
  because it is not durable or independently re-checkable the way a Jira-hosted attachment (or a
  decision record quoting one) would be. A future reader opening this ticket cannot verify a
  chat-relayed description the way they can verify a comment id and timestamp. If and when these
  images are re-attached to the ticket as text, re-shared with agent-readable access, or restored
  to fetchable form, they become a real source and REQ-05/REQ-07/REQ-13 should be revisited
  against them directly — not against the relay.
- **Blocked:** potentially refines REQ-07/REQ-13's exact layout once genuinely viewable; does not
  block either requirement's current, differently-sourced acceptance criteria.
- **Owner:** whoever can view the ticket in a browser (tcgproject12, or anyone with Jira UI
  access) — a "please describe/re-attach as citable text" request, not a product question.
- **Logged:** `.ai/vault/gaps.md#scrum-877-labor-and-unit-details-oiler-crew-linking` —
  `Status: open`.
- **Workaround, if any:** proceed on the decision record's text and the citable code/vault
  sources alone, as this spec now does.

### Q8 — DEFERRED, NOT ANSWERED — Are Job Site Work / Shop Work / Travel / Site Inspection the exhaustive set of Labor Classification values, and where are they configured?

- **Question:** US-18 says classifications "can include" these four "where applicable" —
  language that reads as illustrative, not exhaustive. Is there a configured list (and if so,
  where — no schema table for it was found), or are these four the complete list?
- **Why it cannot be answered from what is written:** The vault source itself flags that these
  values appear nowhere in any payroll document and nothing states how a classification affects
  pricing. **The product owner was asked directly and explicitly declined to answer:** decision
  record, comment `23066` (tcgproject12, 2026-08-21 17:38), Q8: "Skip this point." This is a
  deferral, not a resolution — the decision record is explicit that "REQ-11 in `spec.md` remains
  `NOT SPECIFIED`... this decision does not newly specify them or assert they are exhaustive."
  Treat this exactly as before this update: still genuinely open, now with a citable record that
  the question was asked and declined rather than merely unasked.
- **Blocked:** REQ-11.
- **Owner:** product team.
- **Logged:** `.ai/vault/gaps.md#scrum-877-labor-and-unit-details-oiler-crew-linking` —
  `Status: open` — deferred, not resolved.
- **Workaround, if any:** none that avoids guessing at the list.

### Q9 — RESOLVED — yes, a non-Oiler employee can see their own Labor/Unit data, read-only

- **Resolution:** decision record, comment `23062` (Umair Khan, 2026-08-21 16:42): "Can a
  non-Oiler see their own labor data read-only?: They should see for read only" — Yes. Comment
  `23066` (tcgproject12, 2026-08-21 17:38), Q9: "Yes." The decision record independently
  re-fetched the live thread and confirmed these two comments agree, with no contradiction and no
  stale/superseded answer to adjudicate. See REQ-15, newly added to this spec for this
  requirement. (An earlier relay into this session, before the decision record existed, had
  mis-stated Q9 as self-contradictory — "Not required for now" vs. "Yes" — which the decision
  record traced to the live ticket and found not to be the case. That earlier, uncited claim was
  never folded into this spec and is superseded by this resolution.)

---

## 13. What this spec deliberately does not specify

Updated 2026-08-21, three times. Items resolved by a durable source are removed from this list
as they resolve; items deferred, or still genuinely open, remain.

- **Whether real, usable Oiler-appropriate `EmployeeCraftCode` data exists for any tenant today**
  — the *mechanism* question is resolved twice over (round-1 decision record; round-3 decision
  record, comment `23099`, with better provenance than the round-2 relay that first surfaced it).
  Whether such a row has actually been configured for any tenant remains unaddressed by any
  source; see Q3, narrowed to data-readiness only.
- **The Labor Classification value list's completeness and configuration source** — the product
  owner was asked directly and declined to answer ("Skip this point") — a deferral, not a
  resolution; see Q8.
- **The exact content of the two Jira attachment images** — still unreadable by any agent tool
  available in this loop; see Q7, untouched by either decision record.
- **Who owns overtime pricing, field-ops or payroll, as a general product question** — REQ-03 is
  removed from this ticket's scope by explicit instruction, but the underlying question is
  deferred, not settled, and will need asking again for the future payroll module.
- **The pre-existing WTL-threshold disagreement between field-ops and payroll documents**
  (`payroll/gaps.md#field-ops-lunch-capture-vs-payroll-wtl`) — explicitly not re-litigated here;
  that gap remains open on its own record, untouched by any update to this ticket.
- Any web (`apps/web`) surface — no source describes one for this feature. (Unchanged.)
- The exact route/screen for REQ-15's non-Oiler read-only view — the *that* is confirmed; the
  *where/how* is not.
- Precision/scale and backfill strategy for `Asset.capacity`'s new numeric type (REQ-16) and
  `Asset.mainBoomLength`'s (REQ-17, migration itself now authorized) — not addressed by any
  source for either field.
- Exact bracket-boundary edge semantics for REQ-05's rate table (is 380.0 ft or 440.0 ft
  inclusive/exclusive of which bracket) — not addressed by comment `23099` or any other source; a
  small residual, not build-blocking.

---

## 14. Sign-off before build

- [x] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person — *nearly
  all.* Q1, Q2, Q4, Q5, Q6, Q9, Q10, Q11 answered via one of the two decision records. Q8
  explicitly deferred by the product owner (not answered). **Only Q3 (narrowed to
  data-readiness) and Q7 (attachment images) remain genuinely open** — see §12. This is a marked
  improvement from the prior update, where two new questions (Q10, Q11) had just been raised by
  uncited content; both are now resolved on durable sources.
- [x] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/` — both prior
  conflicts (REQ-03, REQ-14) are addressed in the first decision record, as explicit deferrals
  rather than adjudications. No `[CONFLICT]`-flagged requirement exists from either later round.
- [x] Answers written back into `spec.md` with their new sources and flags — done, this update.
  Every place that previously read "chat relay, round 2, not cited as a source" for the rate
  table, the above-380ft rule, or the `mainBoomLength` migration now cites comment `23099`
  directly.
- [x] `gaps.md` entries updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md` — the
  gaps.md entry's per-sub-question accounting is updated to reflect the second decision record;
  the entry's **overall** `Status` remains `open` (not fully `resolved`) because sub-questions 3
  (data-readiness) and 7 (images) are still unanswered — see the updated entry for the precise
  per-sub-question disposition.
- [ ] Decomposed into vertical units — `units.md` — **not yet.** See the closing report for
  which requirements are buildable now and which should wait — most of them, at this point.

Answered by: tcg-scrum (two decision records —
`.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-oiler-crew-linking.md`, and
`.ai/vault/decisions/2026-08-21-scrum-877-labor-and-unit-details-boom-pay-rate-table.md`); folded
in by tcg-elaborator
Date: 2026-08-21
