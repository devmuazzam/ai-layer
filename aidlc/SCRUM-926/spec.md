# Spec — SCRUM-926 Craft code

> Written to `.ai/aidlc/SCRUM-926/spec.md` by the elaborator
> (`.ai/aidlc/agents/inception/tcg-elaborator.md`) from `intent.md` beside it.
>
> This is the document an executor builds from. **Every requirement in it carries its
> sources, and every source carries its status.** A requirement with no source is not a
> requirement — it is an open question, and it stays marked as one.
>
> **Nothing here has been implemented.** The elaborator produced this file and stopped.

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-926` (epic) — children `SCRUM-925`, `SCRUM-927`, `SCRUM-934`, `SCRUM-935`. `SCRUM-928` is a child and is **out of scope** (intent §5) |
| Intent | `.ai/aidlc/SCRUM-926/intent.md`, captured `2026-08-24` |
| Elaborated on | `2026-08-24` |
| Jira drift check | All five tickets re-read from Jira on `2026-08-24`. `SCRUM-925` / `SCRUM-927` last updated `2026-08-24 22:52`, `SCRUM-934` / `SCRUM-935` created `2026-08-24 22:51`. **No drift from the intent snapshot.** `SCRUM-926` itself has an empty description — the epic carries no acceptance criteria of its own |
| Vault state at elaboration | *451 `.md` files under `.ai/vault/`; only the six `domain/` SOP files are `status: verified`; `payroll/gaps.md` (live register) has 39 open entries, the retired root `gaps.md` 29* |
| Open questions raised by this spec | *19 raised — **0 open**, 15 resolved, 3 withdrawn (Q5, Q14, Q17), 1 moved out (Q13 → payroll engine / `PAY-015`). All in §12* |
| Rules consulted | `.ai/claude/contexts/api.md`, `.ai/claude/contexts/prisma.md`, `CLAUDE.md` → *Architecture invariants*, *Identity Convention*, *Naming* |
| Revised | `2026-08-25`, folding in the `SCRUM-926` planning answers of `2026-08-24` and the planning decisions of `2026-08-25` (Syed Haris). See *Revision* below |

### Revision — the 2026-08-24 planning answers

Thirteen of this spec's questions were answered on `2026-08-24` by **Syed Haris** (CodingCops,
acting product owner for this epic) — ten closing the question outright, one withdrawing it as out
of scope (Q5), one (Q1) deciding what to build without closing it, and one (Q13) routing it to
another ticket. **Q15–Q17 were raised by the decomposer against this spec and answered in the same
session**; they are recorded here rather than in `units.md` because each one changed a requirement.
Every requirement they touch cites them as:

> `SCRUM-926 planning answers 2026-08-24 (Syed Haris)` — `[UNVERIFIED]` — kind: jira

**That tag is not decoration.** This is a CodingCops product owner speaking for the epic, not TCG
adjudicating the vault. Nothing below became `[VERIFIED]`, and **no decision note exists in
`.ai/vault/decisions/` for any of it** — recording one is `tcg-scrum`'s write path, not this
agent's. Where an answer stands against a written vault rule, the requirement proceeds under the
answer **and the conflict stays flagged**.

| Q | Answer | Effect |
| --- | --- | --- |
| Q1 | One rate per craft, non-union included; `Employee.hourlyRate` is never read | REQ-10 proceeds — **`[CONFLICT]` kept**, Brian Petros must confirm |
| Q4 | FCC copy collapses `-A`/`-B`/`-C`; `roleType` by prefix; unmapped → migration aborts | REQ-05 and REQ-23 resolved |
| Q5 | **Out of scope** — no rate seed and no scale seed in this epic | REQ-15, REQ-21, REQ-22 → `[N/A]`; Q5 withdrawn |
| Q7 | `kind` = `UNION \| NON_UNION`, required; "reunion" was a typo for non-union | REQ-09 resolved |
| Q8 | "type is required" = `CraftCode.roleType`, required | REQ-04 resolved |
| Q9 | Admin gate for CRUD; admin / payroll / crane superintendent for assignment; dispatch for a temp's PRIMARY | REQ-28 resolved as far as the `Role` enum reaches |
| Q10 | Employee-level SECONDARY rows are the **allowed alternates**; no pay effect on their own | REQ-08 acceptance defined |
| Q11 | Exactly 80 ft **is** tier 1 | REQ-14 resolved — **and raised Q12** |
| Q12 | `tier = max(1, ceil((L − initialFt) / gapFt))`; a role with no step rate → no modifier | REQ-12, REQ-13, REQ-14 resolved; no test left pending |
| Q13 | `PR-015` higher-rate-for-day is a payroll-engine rule | Routed to `SCRUM-920`; REQ-17 stays per-entry |
| Q14 | `roleType` has **six** values; `THIRD_MAN` / `MECHANIC` are admin-selectable post-migration | Enum settled (REQ-04, REQ-05, REQ-23); `L12-BG-*` still open |
| Q15 | Rates and step rates are `Decimal(10,4)`; rounding to cents happens only in the `PAY-069` ledger | §3, §9, REQ-02, REQ-11, REQ-12 |
| Q16 | U4 is reviewed by its test suite plus U2's preview endpoint; no resolver HTTP surface | REQ-17, §4 |
| Q17 | The backfill aborts while any employee has a null `craftCodeId` | **Withdrawn 2026-08-25** — no backfill |

**A second round of decisions landed on `2026-08-25`, and two of them changed the shape of the
epic rather than filling a gap in it.**

| Q | Decision (`2026-08-25`) | Effect |
| --- | --- | --- |
| Q1 | **Reversed.** Non-union base rate is **per person** on `Employee.hourlyRate`, as in FCC; the "one rate per craft" working decision is withdrawn | REQ-02, REQ-10, REQ-17, REQ-19, REQ-23 — and **REQ-10's `[CONFLICT]` clears** |
| Q2 | Boom length is chosen on the **ticket / labor entry** at close after final customer signature; never derived from the unit | REQ-17 |
| Q3 | Boom adder is paid **ON TOP** — flat $/h × boom hours, unmultiplied | REQ-20 **keeps `[CONFLICT]`** against MLA Art. IV; confirmation travels to `SCRUM-920` |
| Q6 | **No ADP gating of any kind**; ADP integration deferred entirely | REQ-27 — and the 06-30 verified decision is *not* amended |
| Q13 | Moved out — payroll-engine rule, tracked in `PAY-015` / `SCRUM-920` | REQ-08, REQ-17 |
| Q14 | **No data migrations in this epic.** No FCC copy, no backfill; the drops move to a later cleanup ticket | REQ-05, REQ-07, REQ-23, REQ-24, REQ-25, §11 — **raises Q19** |
| Q18 | The 2026-08-20 verified decision is **scoped to union crafts**, not overridden | REQ-10, REQ-19 — a **working reading**, pending `tcg-scrum` |
| Q19 | `EmployeeUnionCode.kind` is derived for existing rows by **label match**, reviewed row-by-row in the PR | REQ-09, REQ-23 — the one data write that survives Q14 |

**Read Q1 and Q14 together before decomposing.** Between them the epic stopped migrating anything
and stopped pricing non-union work from craft codes, which means it now ships **entirely empty** —
see §11, *Launch state* — and leaves `Employee.hourlyRate` permanently live rather than retired.

**Q2, Q3 and Q6 are untouched.** They belong to TCG, not to CodingCops, and this revision does not
adjudicate them.

**Three new questions came out of this revision; two were answered in the same session.** **Q12** —
Q11's formula fixed the 80-ft end of the bracket and broke all seventeen upper boundaries; now
resolved to `max(1, ceil(…))`, which ties out at every boundary and every legacy label, and which
also settled what a role with no step rate does (no modifier). **Q13** — rule-matrix §B `PR-015`
requires a higher-rate true-up when an employee works several crafts in a day, which is exactly
what Q10's allowed-alternates model enables; routed to the payroll-engine ticket under `SCRUM-920`,
leaving `SCRUM-935`'s per-entry interface unchanged. **Q14** — two role values (`THIRD_MAN`,
`MECHANIC`) were proposed that none of Q4's prefix rules produces; answered at six values, then
**withdrawn entirely on 2026-08-25** when the scope change removed the migration those rules
served.

**A further round on `2026-08-25` reversed one decision and cut the epic's scope.** Q1 flipped
non-union pricing back to **per person**, clearing REQ-10's `[CONFLICT]`; Q14 removed **every data
migration**, which withdrew Q17 with it and raised **Q19**; Q2, Q3 and Q6 closed, with REQ-20
keeping its `[CONFLICT]` against the MLA; and Q18 — raised by the decomposer against the reversal —
was answered as a **working reading** that the `[VERIFIED]` 2026-08-20 decision is union-scoped.
The full table is above.

### Precedence — planning decisions over ticket and Confluence text

Also directed `2026-08-24` by Syed Haris: **the governing requirement source for this epic is the
set of planning decisions** — intent §4 / §5 plus the Q-answers above — **not** the Jira or
Confluence ticket text. Where `SCRUM-925`, `SCRUM-927` or Confluence `PAY-CC-01..03` differ from a
planning decision, the decision wins, the ticket wording is recorded as *superseded by planning
decision 2026-08-24*, and **no `[CONFLICT]` or `[OPEN]` is raised on that basis alone.**
`SCRUM-925` and `SCRUM-927` are being updated to match. Those decisions are cited as:

> `SCRUM-926 planning decisions 2026-08-24 (Syed Haris) — recorded in intent.md and in the Jira
> comment on SCRUM-926` — `[UNVERIFIED]` — kind: jira

**What this rule does and does not reach.** It settles *ticket text vs planning decision*, and that
half of REQ-01, REQ-02 and REQ-07's conflict is now gone: the tickets are silent or looser where
the plan is specific, and the plan governs. It does **not** reach the other half, which is why
those three keep their flag. Their `[CONFLICT]` was never "the ticket might mean something else" —
it is that the staged Confluence page sits on a topic **three other unadjudicated documents also
specify**, in three mutually incompatible id schemes, and nobody has read them against each other:

| Document | Size | What it specifies on this topic |
| --- | --- | --- |
| `payroll/codingcops-rule-matrix.md` §B | 20.8 KB | `PR-009`–`PR-015` — group classification, L12 base rate, modifier rate, non-union rate, **rate comparison across sources**, **higher rate for day/job** |
| `payroll/erp-payroll-module-frd/03-payroll-groups-and-rate-determination.md` | 6.5 KB | `PR-006`–`PR-011` — *its own numbering*, same subject matter |
| `sync/.conflict/2026-08-24-bootstrap/craft-codes.md` | ~2.5 KB | `PAY-CC-01..03` — a **third** id scheme, staged at CONFLICT tier |

Declaring the plan the winner over the *ticket* changes nothing about whether these three agree
with the plan or with each other, because none of them is the ticket. Demoting that to a NOTE would
drop the one signal the decomposer reads when it decides how expensive a requirement is to reverse
(§4, *Status honesty*), on a payroll surface where being wrong means a wrong paycheck.

**This is cheap to clear and does not need the client.** Someone reads §B `PR-009`–`PR-015` and FRD
03 `PR-006`–`PR-011` — about 27 KB — against REQ-01, REQ-02 and REQ-07, and `tcg-scrum` records a
decision note; the flags come off the same day. Two of those rows already turned out to matter: 
`PR-014` treats the **employee rate as a live rate source alongside the craft rate**, which is Q1's
subject, and `PR-015` is a requirement this epic has never looked at — see **Q13**.

### Two things a reader must know before reading anything below

1. **`SCRUM-925` and `SCRUM-927` are verbatim copies of an unmigrated Confluence page.**
   Their acceptance criteria are word-for-word `PAY-CC-01` and `PAY-CC-02` from the Confluence
   page *Craft codes* (page id `151388161`, last edited `2026-08-20`), staged at
   `sync/.conflict/2026-08-24-bootstrap/craft-codes.md` at **CONFLICT tier** because it is a new
   page on a topic the vault already covers and **nobody has adjudicated it against
   `payroll/codingcops-rule-matrix.md` §B or `payroll/erp-payroll-module-frd/03-…`**. The ticket
   and the page are therefore **one voice, not two**. Requirements that rest on them alone are
   flagged `[CONFLICT]` for that reason, and the reason is stated in each block.
2. **`PAY-CC-##` is a third payroll id scheme.** The vault already carries two independent
   `PR-###` numberings (FRD vs matrix). Never cite a bare `PAY-CC-##` — cite the staged page.
   `PAY-###` (the register at `payroll/rules/INDEX.md`) is the only id safe to cite bare.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Craft code is a configurable reference entity | schema / api | `[CONFLICT]` | `SCRUM-925`, `sync/.conflict/2026-08-24-bootstrap/craft-codes.md` | no |
| REQ-02 | **Union** craft rates are effective-dated; base straight-time only | schema / api | `[CONFLICT]` | `SCRUM-925`, staged Confluence page, `payroll/rules/PAY-008-…`, planning decisions `2026-08-25` (Q1) | no |
| REQ-03 | A craft code belongs to exactly one union code | schema / api | `[UNVERIFIED]` | `SCRUM-925`, `SCRUM-934`, `payroll/legacy-payroll-app-db-extract/data/source-feed.md` | no |
| REQ-04 | A craft code carries a role type that selects the boom step rate | schema / api | `[UNVERIFIED]` | `payroll/mcog-l12-mla-2025-2028/02-…`, `SCRUM-934`, planning answers `2026-08-24` (Q8) | no |
| REQ-05 | The `roleType` value set — six values, admin-selected | schema | `[UNVERIFIED]` | planning answers `2026-08-24` (Q4, Q14), planning decisions `2026-08-25` (Q14), `payroll/rules/PAY-009-…` | no |
| REQ-06 | A craft code has a validity window | schema / api | `[UNVERIFIED]` | `SCRUM-935`, `payroll/legacy-payroll-app-db-extract/data/source-feed.md`, `payroll/rules/PAY-008-…` | no |
| REQ-07 | Exactly one PRIMARY craft per employee — enforced going forward, reported for existing | schema / api | `[CONFLICT]` | `SCRUM-927`, staged Confluence page, `decisions/2026-08-20-…`, planning decisions `2026-08-25` (Q14) | no |
| REQ-08 | Secondary craft assignments are the employee's allowed alternates | schema / api | `[UNVERIFIED]` | `SCRUM-927`, staged Confluence page, `decisions/2026-08-20-…`, planning answers `2026-08-24` (Q10) | no |
| REQ-09 | Union codes gain a required `kind` and optional local/agreement | schema / api | `[UNVERIFIED]` | `SCRUM-925`, `payroll/rules/PAY-009-…`, `payroll/gaps.md#union-codes…`, planning answers `2026-08-24` (Q7) | no |
| REQ-10 | Non-union employees are priced **per person** from the employee record | schema / api | `[UNVERIFIED]` | planning decisions `2026-08-25` (Q1), `payroll/rules/PAY-012-…`, legacy engine (21,348 rows), `payroll/rules/PAY-009-…` | no |
| REQ-11 | One ACTIVE craft-modifier scale per union code, no tier rows | schema / api | `[UNVERIFIED]` | `SCRUM-934`, `payroll/mcog-l12-mla-2025-2028/02-…` | no |
| REQ-12 | Boom tier and adder are computed by a pure function | api | `[UNVERIFIED]` | `payroll/mcog-l12-mla-2025-2028/02-…`, `payroll/legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md`, `SCRUM-934`, planning answers `2026-08-24` (Q11, Q12) | no |
| REQ-13 | Modifier code and label strings are derived, never stored | api | `[UNVERIFIED]` | `payroll/legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md`, `SCRUM-934`, planning answers `2026-08-24` (Q12) | no |
| REQ-14 | Behaviour at exactly `initialFt` (80 ft) — it **is** tier 1 | api | `[UNVERIFIED]` | planning answers `2026-08-24` (Q11), MLA Art. IV, legacy `080-100Ft` label | no |
| REQ-15 | L12 scale seed values — **as a test fixture only** | schema | `[N/A — OUT OF SCOPE]` | planning answers `2026-08-24` (Q5); values from `SCRUM-934`, legacy modifier table, MLA Art. IV | no |
| REQ-16 | Tier preview endpoint | api | `[UNVERIFIED]` | `SCRUM-934` | no |
| REQ-17 | `CraftRateResolverService` interface, keyed by work date | api | `[UNVERIFIED]` | `SCRUM-935`, `payroll/rules/PAY-008-…`, `payroll/rules/PAY-010-…` | no |
| REQ-18 | Missing rate / window / scale returns Blocked, never throws | api | `[UNVERIFIED]` | `SCRUM-935`, `payroll/rules/PAY-060-…` | no |
| REQ-19 | Which employee rate columns the resolver may read | api | `[UNVERIFIED]` | planning decisions `2026-08-25` (Q1, Q18), `payroll/rules/PAY-012-…`, `payroll/rules/PAY-010-…`, `decisions/2026-08-20-…` | no |
| REQ-20 | The boom adder is returned separately; composition is not decided here | api | `[CONFLICT]` | `payroll/rules/PAY-011-…`, `payroll/2026-08-20-payroll-rules-meeting-notes.md`, MLA Art. IV | no |
| REQ-21 | L12 craft rates seeded at the MLA 7/1/2025 column | schema | `[N/A — OUT OF SCOPE]` | planning answers `2026-08-24` (Q5) | no |
| REQ-22 | FY2026-27 L12 rate rows | schema | `[N/A — OUT OF SCOPE]` | planning answers `2026-08-24` (Q5) | no |
| REQ-23 | **Schema migration only** — add tables, columns and enums; move no data | schema | `[UNVERIFIED]` | planning decisions `2026-08-25` (Q14, Q17), `.ai/claude/contexts/prisma.md` | no — but raises Q19 |
| REQ-24 | The `unionStatus: 'Union'` filter moves to craft kind, with a legacy fallback | api | `[UNVERIFIED]` | intent §4, `payroll/rules/PAY-009-…`, planning decisions `2026-08-25` (Q14) | no |
| REQ-25 | The module is renamed `craft-codes`, old routes kept as aliases | api / shared | `[UNVERIFIED]` | intent §4, planning decisions `2026-08-25` (Q14 — the old table stays) | no |
| REQ-26 | Craft, rate, scale and assignment changes are written to the activity log | schema / api | `[UNVERIFIED]` | `SCRUM-934`, `payroll/rules/PAY-008-…`, `payroll/rules/PAY-068-…` | no |
| REQ-27 | Temporary employees also require a primary craft at create | schema / api | `[UNVERIFIED]` | intent §4, `dispatch/daily-allocation-system.md` (via `payroll/gaps.md`) | no |
| REQ-28 | Who may create and reassign craft assignments | api | `[UNVERIFIED]` | planning answers `2026-08-24` (Q9), `decisions/2026-08-20-…`, `apps/api/prisma/schema.prisma` line 18 | no — but see its NOTE |

Counts: **28 total — 0 verified, 21 unverified, 4 conflicted, 0 open, 3 out of scope.**

Before the 2026-08-24 answers: 18 unverified, 6 conflicted, **4 open**. REQ-05, REQ-14 and REQ-28
moved from `[OPEN]` to `[UNVERIFIED]`; REQ-08 from `[CONFLICT]` to `[UNVERIFIED]`; REQ-15, REQ-21
and REQ-22 left the epic. **REQ-10's `[CONFLICT]` cleared on 2026-08-25** when Q1 resolved *in the
vault's favour* — the plan yielded to `PAY-012`, so four sources now agree where two once
disagreed. That is the only flag in this spec cleared by **agreement** rather than by adjudication.
REQ-01, REQ-02, REQ-07 and REQ-20 keep theirs: the first three because the staged Confluence page
is still unadjudicated against rule-matrix §B and FRD 03 (§0, *Precedence*), and REQ-20 because
Q3's on-top decision stands against MLA Article IV pending labor counsel.

## 2. Requirements

### REQ-01 — Craft code is a configurable reference entity `[CONFLICT]`

- **Statement:** A payroll administrator can configure a craft code with an identifier, a name
  and a description, and can mark it active or inactive rather than deleting it.
- **Surface:** schema / api
- **Sources:**
  - `SCRUM-925` — `[UNVERIFIED]` — kind: jira — *"The system allows a craft code to be configured
    with its identifier and name."* / *"A craft code can be marked **active/inactive** rather than
    deleted."*
  - `sync/.conflict/2026-08-24-bootstrap/craft-codes.md` — `[UNVERIFIED]` — kind: vault —
    `PAY-CC-01`, the same two sentences verbatim. Staged at **CONFLICT tier**, unmigrated.
  - `decisions/2026-08-20-archive-instead-of-delete-app-wide.md` — `[VERIFIED]` — kind: decision —
    archive replaces delete app-wide, on the existing `archivedAt` pattern. Consistent with the
    active/inactive requirement but does **not** settle whether "inactive" here means a `status`
    value or `archivedAt`.
- **Conflict:** **narrowed 2026-08-24, not cleared.** The ticket-vs-plan half is gone by the
  precedence rule in §0 — where `SCRUM-925` and the plan differ, the plan governs, and the ticket
  wording is *superseded by planning decision 2026-08-24*. What remains is the vault half, which
  precedence does not touch: the ticket and the staged page are **the same text**, so the product
  statement rests on one voice, and that page is CONFLICT-tier because it overlaps
  `payroll/codingcops-rule-matrix.md` (20.8 KB, §B `PR-009`–`PR-015`) and
  `payroll/erp-payroll-module-frd/03-payroll-groups-and-rate-determination.md` (6.5 KB,
  `PR-006`–`PR-011`, its own numbering) and **nobody has read it against either**. None is
  verified. This spec does not choose. Register entry:
  `payroll/gaps.md#confluence-payroll-user-stories-first-payroll-pages-in-confluence-unmigrated`.
  Clearing it is a 27 KB read plus a decision note — see §0, *Precedence*.
- **Open question:** none blocking this requirement.
- **Acceptance:** a craft code can be created, edited, listed and set inactive; an inactive craft
  code is excluded from the pick list used on employee assignment but is still readable by the
  resolver for historical work dates (see REQ-06 and REQ-17).
- **Notes for the executor:** an admin CRUD module for this already exists —
  `apps/api/src/usecase/employee-craft-codes/` and
  `apps/api/src/presentation/employee-craft-codes/`, backed by the `EmployeeCraftCode` model at
  `apps/api/prisma/schema.prisma` ~line 2261, with `status` defaulting to `'ACTIVE'` and both
  `code` and `label` unique per tenant. Reuse its shape rather than reinventing it; see REQ-25 for
  the rename.

### REQ-02 — Craft code rates are effective-dated; base straight-time only `[CONFLICT]`

- **Statement:** A **union** craft code's rate is held as effective-dated rows carrying the **base
  straight-time rate only**; exactly one row is in force on any given date, and OT and DT are
  derived from it rather than stored. **Non-union craft codes carry no rate rows at all** — their
  employees are priced per person from `Employee.hourlyRate` (REQ-10, Q1) — so a craft with zero
  `CraftCodeRate` rows is valid, not incomplete.
- **Surface:** schema / api
- **Sources:**
  - `SCRUM-925` — `[UNVERIFIED]` — kind: jira — *"Craft code rates can have an effective date."* /
    *"Different craft groups can have different rates."*
  - `sync/.conflict/2026-08-24-bootstrap/craft-codes.md` — `[UNVERIFIED]` — kind: vault — same
    text as `PAY-CC-01`.
  - `payroll/gaps.md#confluence-payroll-user-stories-first-payroll-pages-in-confluence-unmigrated`
    — `[UNVERIFIED]` — kind: vault — records what the Confluence page says about the term
    `craft-code`: *"the group/pay classification at which employees are paid"*, groups are
    *"Apprentice 1–6 and Groups 1–9"*, it carries *"the **base rate only** (OT/DT derive from
    it)"*, and rates vary *"by fiscal year"*. This is the **only written support anywhere** for
    the base-rate-only decision, and the entry itself says it is not a glossary entry until
    re-migrated.
  - `payroll/rules/PAY-008-effective-dated-configuration.md` — `[UNVERIFIED]` — kind: vault —
    *"Historical recalculation must use rules effective on the work date"*; records that FCC's
    `UNION_CRAFT` **has** `StartDate`/`EndDate` columns *"but uses neither — rates are overwritten
    in place"*, and that union rates change every fiscal year (July–June). Status `open`, blocking
    item *"Confirm configuration ownership"*.
- **Conflict:** as REQ-01 — **narrowed, not cleared**. The plan governs over the ticket wording
  (§0, *Precedence*); what survives is that the product statement is the CONFLICT-tier staged page,
  unadjudicated against the rule matrix §B and FRD 03 — and §B's `PR-014` *"more than one rate
  source exists"* is squarely about this requirement's subject. `PAY-008` is `status: open`, so
  effective dating is a documented requirement whose *ownership* is unconfirmed. None is verified;
  this spec does not choose. Anchor as REQ-01.
- **Open question:** none. **Q5 is withdrawn** — seeding is out of scope (§0, and REQ-21 / REQ-22),
  so which fiscal-year columns exist at launch is no longer this epic's question: admins enter
  rates through the API. The effective-dating *mechanism* specified here is unaffected.
- **Acceptance:** given two rate rows for one union craft with adjacent effective windows, a lookup
  on the day before, the day of and the day after each boundary returns the correct single row;
  overlapping windows for the same craft are rejected; **a non-union craft with zero rate rows is
  accepted by validation and does not return Blocked for want of a rate** (REQ-10).
- **Notes for the executor:** `payroll/rules/PAY-008-…` also states the reason the ERP must do
  this: FCC overwrites in place and *"one row per craft, no history"*, so pre-July-2026
  recalculation is only recoverable from the vault's own extract archive. Do not build an
  overwrite-in-place table.

### REQ-03 — A craft code belongs to exactly one union code `[UNVERIFIED]`

- **Statement:** Every craft code references exactly one union code, and that reference is
  required.
- **Surface:** schema / api
- **Sources:**
  - `SCRUM-925` — `[UNVERIFIED]` — kind: jira — *"Craft codes include the applicable union
    classification/rule classification."* The ticket does **not** say whether that is one field or
    two (intent §10).
  - `SCRUM-934` — `[UNVERIFIED]` — kind: jira — the modifier scale is configured *"per union
    code"*, and the resolver reaches the scale via *"the craft's union"* (`SCRUM-935`). The
    craft→union link is what makes that traversal possible.
  - `payroll/legacy-payroll-app-db-extract/data/source-feed.md` — `[UNVERIFIED]` — kind: vault —
    `src.FMS_UNION_CRAFT_Raw` is keyed `UnionCode` + `CraftCode` (`UnionCode=L12;
    CraftCode=L12-G2-A; PayRate=66.180`), and `src.FMS_UNION_CRAFT_MODIFIER_Raw` likewise carries
    `UnionCode`. The legacy rate table is per union per craft.
  - `payroll/rules/PAY-009-payroll-group-classification.md` — `[UNVERIFIED]` — kind: vault — the
    five payroll groups are derived from the craft-code prefix (`L12%`, `ADMIN%`, `SYS%`) plus
    `EmpTypeID`, confirmed in writing by Brian Petros 2026-06-09.
- **Conflict:** none. But note `payroll/gaps.md#union-codes-one-value-so-the-crud-question-mostly-dissolves`:
  ADP holds exactly one union code, `L12 — Local 12`, and **union code cannot derive the payroll
  group** — `L12 Labor Union Field` and `L12 Labor Union Mechanic` both carry `L12`.
- **Open question:** whether the ticket's *"union classification/rule classification"* is this one
  field or two — see Q8.
- **Acceptance:** a craft code cannot be created without a union code; deleting a union code that
  has craft codes is refused.
- **Notes for the executor:** `EmployeeUnionCode` already exists (`schema.prisma` ~line 2290) with
  the same reference-code shape as `EmployeeCraftCode`. REQ-09 extends it.

### REQ-04 — A craft code carries a role type that selects the boom step rate `[UNVERIFIED]`

- **Statement:** Every craft code carries a role type, and that role type determines which of the
  scale's two step rates applies when a boom adder is computed.
- **Surface:** schema / api
- **Sources:**
  - `payroll/mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md` —
    `[UNVERIFIED]` — kind: vault — *"When the Operator receives the additional seventy-five cents
    (\$0.75) per hour, the Oilers on cranes with high booms shall receive twenty-five cents
    (\$0.25) per hour."* Two rates, split by role.
  - `payroll/legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md` —
    `[UNVERIFIED]` — kind: vault — the legacy modifier codes come in two families,
    `OP-BP-nn` / `…Ft-Operator` and `OI-BP-nn` / `…Ft-Oiler`, with adders at 3× the ratio
    ($4.500 vs $1.500 at tier 6).
  - `SCRUM-934` — `[UNVERIFIED]` — kind: jira — *"`adder = tier × stepRate(roleType)`"* and
    `codePrefixOperator` / `codePrefixOiler` on the scale.
  - `SCRUM-926 planning answers 2026-08-24 (Syed Haris)` — `[UNVERIFIED]` — kind: jira — Q8:
    *"type is required" = `CraftCode.roleType`, required.*
- **Conflict:** none.
- **Open question:** **none — Q8 is answered.** The planning note's *"type is required"* meant this
  field. It follows that a craft carries **two** required classifications, not one: the union
  reference (REQ-03, independently sourced) and the role type (this requirement) — which is the
  reading `SCRUM-925`'s undefined phrase *"union classification/rule classification"* left open in
  intent §10. The value set is REQ-05, answered by Q4.
- **Acceptance:** given a craft whose role type is the operator role and a craft whose role type is
  the oiler role, the same boom length yields the operator step rate and the oiler step rate
  respectively.
- **Notes for the executor:** `CraftCode.roleType` selects a step rate, and **the modifier scale
  carries exactly two** — `operatorStepRate` and `oilerStepRate` (REQ-11, `SCRUM-934`). So
  `stepRate(roleType)` is defined for `OPERATOR` and `OILER` and **undefined for the other four of
  the six values** — `THIRD_MAN`, `LABORER`, `ADMIN` and `MECHANIC` (REQ-05, Q14). Q12 settled what
  happens then: **no modifier**, at any boom length — see REQ-14's acceptance and notes. Implement
  it by asking whether the role *has* a step rate, never by matching role names: two-thirds of the
  enum has no step rate, so a name-matching check is the likelier thing to get wrong.

### REQ-05 — The `roleType` value set `[UNVERIFIED]`

- **Statement:** `roleType` is a required enum on the craft code with **six** values —
  **`OPERATOR`, `OILER`, `THIRD_MAN`, `LABORER`, `ADMIN`, `MECHANIC`**. Every value is
  **admin-selectable**; an administrator picks one when creating a craft code through the API.
- **Surface:** schema
- **Sources:**
  - `SCRUM-926 planning answers 2026-08-24 (Syed Haris)` — `[UNVERIFIED]` — kind: jira — Q4 and
    Q14: the six values, with `THIRD_MAN` and `MECHANIC` drawn from the design mock's role types
    and `PAY-009`'s L12 Mechanic group.
  - `SCRUM-926 planning decisions 2026-08-25 (Syed Haris)` — `[UNVERIFIED]` — kind: jira — Q14
    resolved by scope change: **there is no data migration in this epic**, so the FCC
    craft-code→`roleType` prefix mapping, the `-A`/`-B`/`-C` collapse and their abort-with-report
    path are **all withdrawn**. Craft codes are created by administrators, and `roleType` is simply
    one of the fields they set.
  - `payroll/rules/PAY-009-payroll-group-classification.md` — `[UNVERIFIED]` — kind: vault — names
    Operator, Oiler and Mechanic as FCC `EmpTypeID` values 1/2/3. This is an **employee** attribute
    in FCC, not a craft attribute; it is the closest written support for three of the six values
    and it does not reach the other three.
- **Conflict:** none — but the six values rest on **the planning answers alone**. No vault document
  names any of them as a craft attribute, and nothing anywhere names a "third man". That was worth
  flagging when a migration was going to stamp `roleType` onto ~45 legacy codes unattended; it
  matters less now that a human picks each one, which is the quiet benefit of the scope change.
- **Open question:** none. Q14's residual `L12-BG-*` question **went away with the migration** —
  see Q14, withdrawn.
- **Acceptance:** a craft code cannot be created without a `roleType`; all six values are
  selectable through the API; a seventh value is rejected.
- **Notes for the executor:** only `OPERATOR` and `OILER` have a step rate on the modifier scale;
  the other four earn **no boom modifier at any length** (REQ-14). Gate that on *whether the role
  has a step rate*, never on a list of role names — two-thirds of this enum has no step rate, so a
  name-matching check is the likelier thing to get wrong.

### REQ-06 — A craft code has a validity window `[UNVERIFIED]`

- **Statement:** A craft code carries a start date and an optional end date, and a rate lookup for
  a work date outside that window does not resolve.
- **Surface:** schema / api
- **Sources:**
  - `SCRUM-935` — `[UNVERIFIED]` — kind: jira — *"Craft must be ACTIVE and inside its
    `startDate`/`endDate` window on that date."*
  - `payroll/legacy-payroll-app-db-extract/data/source-feed.md` — `[UNVERIFIED]` — kind: vault —
    `src.FMS_UNION_CRAFT_Raw` carries `StartDate` and `EndDate` columns; the sample rows show
    `StartDate=04/09/2020` with `EndDate` absent.
  - `payroll/rules/PAY-008-effective-dated-configuration.md` — `[UNVERIFIED]` — kind: vault —
    FCC *"has `StartDate`/`EndDate` columns but uses neither"*.
- **Conflict:** none.
- **Open question:** none.
- **Acceptance:** a resolver call with a work date before `startDate` or after `endDate` returns
  Blocked (REQ-18), not a rate.
- **Notes for the executor:** the craft's window (this requirement) and the rate row's effective
  window (REQ-02) are two separate checks. `SCRUM-935` requires both.

### REQ-07 — Every employee has exactly one PRIMARY craft assignment `[CONFLICT]`

- **Statement:** An employee — union or non-union, permanent or temporary — has **exactly one**
  PRIMARY craft assignment. It is **required on employees created or updated after U3 ships**;
  **existing employees without one are not blocked**, they are **listed by an admin-gated `GET`
  report endpoint** so the gap is visible and can be worked down. The PRIMARY craft determines the
  employee's **union kind**, and for a union employee it is the source of the base rate; for a
  non-union employee the rate comes from `Employee.hourlyRate` (REQ-10).
- **Surface:** schema / api
- **Sources:**
  - `SCRUM-927` — `[UNVERIFIED]` — kind: jira — *"A craft code can be assigned to an employee."* /
    *"An employee can have a primary craft code or secondary one"* / *"The employee's craft code
    and rate are available to payroll calculations."*
  - `sync/.conflict/2026-08-24-bootstrap/craft-codes.md` — `[UNVERIFIED]` — kind: vault —
    `PAY-CC-02`, the same text verbatim.
  - `decisions/2026-08-20-craft-locked-rate-override.md` — `[VERIFIED]` — kind: decision — *"An
    employee's default base rate comes from their **employee-level craft code**."* Decided by
    Corrina Bustos, confirmed by Brian Petros, 2026-08-20.
  - `payroll/2026-08-20-payroll-rules-meeting-notes.md` — `[UNVERIFIED]` — kind: vault — *"For the
    ERP: employees carry a **craft code at the employee level**, which sets their default base
    rate."*
  - `payroll/rules/PAY-010-l12-union-base-rate.md` — `[UNVERIFIED]` — kind: vault — records the
    client's own frequency note: *"Employees are assigned one craft code at a time, and rarely
    ever work under a different craft code."*
- **Conflict:** **narrowed 2026-08-24, not cleared.** The *existence* of a primary craft is
  settled by a `[VERIFIED]` decision. "Exactly one PRIMARY" and "required at create" come from the
  planning decision, which now **governs over the ticket's looser wording** (§0, *Precedence*) —
  the staged page's *"a primary craft code or secondary one"* is silent, not contradictory, and is
  superseded. What precedence does not reach: that page is unadjudicated against
  `payroll/codingcops-rule-matrix.md` §B and `payroll/erp-payroll-module-frd/03-…`, and **§B's
  `PR-015` bears directly on this requirement** — *"Employee works at multiple qualifying rates →
  identify higher qualifying rate and create true-up component"*, marked *New ERP requirement,
  union/legal interpretation required*. A single-PRIMARY model with day-level alternates is one
  reading of that; nobody has checked. See **Q13**. None is verified; this spec does not choose.
  Anchor as REQ-01.
- **Open question:** who is permitted to set it — REQ-28 / Q9.
- **Acceptance:** creating an employee without a primary craft is rejected, **and so is updating
  one that has none**; an employee can never hold two PRIMARY assignments simultaneously;
  reassigning replaces the primary rather than adding a second; an **existing** employee with no
  PRIMARY continues to load, save and appear in lists, and **appears in the report endpoint's
  output** until one is assigned.
- **Notes for the executor:** **"exactly one PRIMARY" is now an invariant for new and updated rows
  only, not a property of the table** — Q14's scope change removed the backfill, so on day one
  *every* existing employee is in the no-PRIMARY population and the new table is empty. Two things
  follow. (a) Enforce single-PRIMARY with a **partial unique constraint** (§11), which permits zero
  and forbids two — exactly the right shape here, and not something a read-then-write check gets
  right under concurrency. (b) The report endpoint is the only thing that makes the gap visible, so
  it is not optional scaffolding: without it nobody can tell whether the population is shrinking,
  and the later cleanup ticket that drops `Employee.craftCodeId` cannot know when it is safe to
  run. Today `Employee.craftCodeId` is a nullable FK to `EmployeeCraftCode` (`schema.prisma`
  ~line 3521) with `onDelete: SetNull`; it **stays** (REQ-23) and is simply not read by payroll.

### REQ-08 — Secondary craft assignments are the employee's allowed alternates `[UNVERIFIED]`

- **Statement:** An employee may hold secondary craft assignments alongside the primary. A
  SECONDARY row is the employee's **allowed-alternate list** — the set of crafts a superintendent
  or payroll may choose from for a given day on that employee's labor entry. **A SECONDARY row has
  no pay effect on its own**; it only makes a craft selectable. The assignment record is **current
  state only** — no effective dates, no promotion history, changed by reassignment.
- **Surface:** schema / api
- **Sources:**
  - `SCRUM-927` — `[UNVERIFIED]` — kind: jira — *"An employee can have a primary craft code or
    secondary one"*. The ticket does not say who assigns the secondary or when it applies
    (intent §10).
  - `sync/.conflict/2026-08-24-bootstrap/craft-codes.md` — `[UNVERIFIED]` — kind: vault —
    `PAY-CC-02`, same sentence.
  - `decisions/2026-08-20-craft-locked-rate-override.md` — `[VERIFIED]` — kind: decision — *"When
    an employee works a different craft on a given day, the day's rate is driven by a **secondary
    craft code assigned for that day** — never a free-text dollar override."*
  - `SCRUM-935` — `[UNVERIFIED]` — kind: jira — the resolver takes the secondary as a **call
    argument** (`resolveEmployeeCraft(employeeId, secondaryCraftId?)`), not as a dated lookup —
    consistent with the answer below: the argument is the day's choice, the row is the permission
    to make it.
  - `SCRUM-926 planning answers 2026-08-24 (Syed Haris)` — `[UNVERIFIED]` — kind: jira — Q10:
    *employee-level SECONDARY assignments are the "allowed alternates" — the crafts a super or
    payroll may choose for a day on that employee's labor entry; the labor entry's
    `secondaryCraftId` must be one of the employee's SECONDARY rows; a SECONDARY row has no pay
    effect by itself.*
- **Conflict:** **resolved, and worth stating how.** The `[VERIFIED]` decision says the secondary
  is *"assigned for that day"*; intent §4's planning decision makes `EmployeeCraftAssignment`
  undated current state. Q10's answer says these are **two objects, not one reading of one
  object** — the undated employee row is eligibility, the dated per-day choice lives on the labor
  entry (a later ticket, intent §5) and is constrained to the employee's SECONDARY rows. That is an
  answer from the acting product owner, not an adjudication of the verified decision, so it is
  `[UNVERIFIED]` and **Corrina Bustos has not confirmed it** — she is the decision's own owner.
  `payroll/2026-08-20-payroll-rules-meeting-notes.md` describes the mechanism day-by-day (*"oiler
  one day, operator the next"*), which the two-object reading accommodates.
- **Open question:** none. Q10 is answered.
- **Acceptance:** a secondary can be added, listed and removed, and **no dates are persisted** on
  the assignment; adding the same craft twice for one employee is rejected; the PRIMARY craft is
  not also required to appear as a SECONDARY row; **a SECONDARY row on its own changes no rate** —
  a resolver call for that employee with no `secondaryCraftId` returns the PRIMARY craft's rate
  regardless of how many SECONDARY rows exist. The constraint that a labor entry's
  `secondaryCraftId` must be one of the employee's SECONDARY rows is **enforced by the labor-entry
  ticket, not here** (intent §5); this epic supplies the list it will validate against.
- **Notes for the executor:** **the resolver is per-labor-entry by design.** An employee with
  several allowed alternates may work more than one craft in a day, and
  `payroll/codingcops-rule-matrix.md` §B `PR-015` requires a higher-rate true-up when that happens
  — but that is a **payroll-engine** rule for a later ticket under `SCRUM-920`, not this epic's
  (Q13). Nothing here aggregates a day. Do not add a day-level method to the resolver to
  anticipate it. Then two things not to do with the storage. Do not add
  `effectiveFrom`/`effectiveTo` to the assignment — the answer is explicitly that dating belongs on
  the labor entry. And do not
  implement the "must be one of the employee's SECONDARY rows" check inside `resolveEmployeeCraft`
  as though it were this epic's: `SCRUM-935` specifies the resolver's behaviour and does not
  include it, so adding it here changes an interface another ticket is being written against.
  Whether the resolver should reject an off-list `secondaryCraftId` is `NOT SPECIFIED`.

### REQ-09 — Union codes gain a required `kind` and optional local/agreement `[UNVERIFIED]`

- **Statement:** `EmployeeUnionCode` carries a required kind distinguishing union from non-union,
  plus an optional local number and an optional agreement reference.
- **Surface:** schema / api
- **Sources:**
  - `SCRUM-925` — `[UNVERIFIED]` — kind: jira — *"Craft codes include the applicable union
    classification/rule classification."*
  - `payroll/rules/PAY-009-payroll-group-classification.md` — `[UNVERIFIED]` — kind: vault — the
    five payroll groups split union (`L12%`) from non-union (`ADMIN%` + `PayType H/S`); the
    predicates are confirmed in writing by Brian Petros 2026-06-09 and match
    `payroll/payroll-app-current-state/04-payroll-group-and-rule-applicability.md` row for row.
  - `payroll/gaps.md#union-codes-one-value-so-the-crud-question-mostly-dissolves` — `[UNVERIFIED]`
    — kind: vault — ADP holds exactly **one** union code, `L12 — Local 12`; *"union code cannot
    derive the Payroll Group"*.
  - `payroll/mcog-l12-mla-2025-2028/02-…` — `[UNVERIFIED]` — kind: vault — the agreement being
    referenced is the MCOG / Operating Engineers Local 12 Truck Crane MLA, 1 Jul 2025 – 30 Jun
    2028.
  - `SCRUM-926 planning answers 2026-08-24 (Syed Haris)` — `[UNVERIFIED]` — kind: jira — Q7:
    *union-code `kind` = `UNION | NON_UNION`, required. "reunion" was a typo for non-union.*
- **Conflict:** none.
- **Open question:** **none — Q7 is answered.** There is no third kind; the "reunion" in the
  planning note was a typo for *non-union*. The enum is two values.
- **Acceptance:** every existing union code row has a `kind` after migration; labels `Non-Union`,
  `non union` and `NONUNION` all derive `NON_UNION`, and `L12 — Local 12` derives `UNION`; a craft
  code's union code determines whether its employees count as union in REQ-24's filter; creating a
  union code without a `kind` is rejected. **The pull request description lists every
  `(tenant, code, label, derived kind)` row for administrator review before merge** — that review
  is the only control on the heuristic, so the migration does not merge without it.
- **Notes for the executor:** the two member names still rest on the planning answer alone — no
  vault document names them, and the answer settles that there are two, not what they are called
  beyond `UNION` / `NON_UNION`. `localNumber` and `agreement` field lengths remain
  `NOT SPECIFIED` — see §9.
  **Existing rows are filled by label match, once, in the ADD migration (Q19).** A label containing
  `non-union`, `non union` or `nonunion` — **case-insensitive** — derives `NON_UNION`; **everything
  else derives `UNION`.** Two things about that default direction are worth understanding rather
  than just implementing. It is chosen to **fail loud**: a row wrongly derived as `UNION` sends its
  employees down the `CraftCodeRate` path, which has no rows on day one, so they **Block**
  (REQ-18) and somebody notices. The opposite default would send them to `Employee.hourlyRate` and
  **pay them silently from the wrong source** (REQ-10) — a wrong paycheck instead of a stopped one.
  But the guarantee is about **pay, not reporting**: a mis-derived row still counts toward the
  wrong side of REQ-24's union/non-union headcount, quietly and with nothing to Block. The
  derivation is **one-shot** — union codes created afterwards take `kind` from the administrator,
  because it is required.

### REQ-10 — Non-union employees are priced per person, from the employee record `[UNVERIFIED]`

- **Statement:** Base-rate resolution **branches on the employee's primary craft's union kind**:
  - `craft.unionCode.kind = UNION` → the `CraftCodeRate` in force on the **work date** (REQ-02).
  - `craft.unionCode.kind = NON_UNION` → **`Employee.hourlyRate`**, its current value. **There is
    no effective dating on the non-union rate in this epic** — the resolver reads the column as it
    stands, not as it stood on the work date.

  **Non-union craft codes carry no `CraftCodeRate` rows at all**, and validation must not require
  one. A non-union craft still carries `roleType`, a union code of kind `NON_UNION`, and its
  validity window; what it does not carry is a rate.
- **Surface:** schema / api
- **Sources:**
  - `SCRUM-926 planning decisions 2026-08-25 (Syed Haris)` — `[UNVERIFIED]` — kind: jira — Q1,
    resolved: *non-union base rate is **per person** on the employee, as in FCC.* The
    2026-08-24 "one rate per craft, non-union included" working decision is **withdrawn**.
  - `payroll/rules/PAY-012-non-union-hourly-rate.md` — `[UNVERIFIED]` — kind: vault — *"Use
    employee-master hourly rate; do not use union craft rate."* Client confirmation, Brian Petros
    2026-06-09: *"`Base hourly rate = Employee.PayRate` ('very important')"*. Status `open`,
    blocking item *"Confirm rate-effective-date handling"* — **which this epic does not resolve;
    see the notes.**
  - `payroll/legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md` —
    `[UNVERIFIED]` — kind: vault — the as-built engine splits exactly this way:
    `PayrollBaseRateSource` = `Labor.CraftCode -> UNION_CRAFT.PayRate` on **59,655** rows and
    `Employee.PayRate` on **21,348** rows.
  - `payroll/rules/PAY-009-payroll-group-classification.md` — `[UNVERIFIED]` — kind: vault — the
    union/non-union split that drives the branch, client-confirmed by Brian Petros 2026-06-09.
- **Conflict:** **dissolved.** The pre-revision spec flagged this `[CONFLICT]` because the plan
  said one-rate-per-craft and `PAY-012` said per-person. Q1 resolved it **in `PAY-012`'s favour**,
  so the planning decision, the vault rule, the client's own written statement and the legacy
  engine's 21,348 rows now all agree. This is the **best-corroborated** requirement in the spec
  that is not about a specific dollar figure — note that it got there by the plan yielding to the
  vault, not the other way round.
- **Open question:** none. Q1 is resolved.
- **Acceptance:** an employee whose primary craft's union code is `UNION` resolves to the
  `CraftCodeRate` in force on the work date; an employee whose primary craft's union code is
  `NON_UNION` resolves to that employee's `Employee.hourlyRate`, and **two non-union employees on
  the same craft code with different `hourlyRate` values resolve to different rates**; creating a
  non-union craft code with no rate rows is accepted, and resolving against it does **not** return
  Blocked for want of a `CraftCodeRate`.
- **Notes for the executor:** three consequences, and the third is the one to carry forward.
  (a) `Employee.hourlyRate` is **not** retired by this epic — see REQ-19 and REQ-23. (b) The
  branch is on `craft.unionCode.kind`, not on a string label and not on the craft's prefix, so it
  depends on REQ-09's `kind` being correct — see **Q19**. (c) **The non-union rate has no history.**
  Reading `Employee.hourlyRate` as it stands today means a recalculation of a *past* pay period
  returns *today's* non-union rate, which contradicts `payroll/rules/PAY-008-…` (*"Historical
  recalculation must use rules effective on the work date"*) and is exactly the blocking item
  `PAY-012` still carries — *"Confirm rate-effective-date handling"*. Q1 scoped that out of this
  epic explicitly ("no effective dating in this epic"); it did not make it untrue. Anyone building
  retroactive correction (`PAY-068`) on top of this will meet it.

### REQ-11 — One ACTIVE craft-modifier scale per union code, no tier rows `[UNVERIFIED]`

- **Statement:** The long-boom modifier is configured as one scale per union code — initial feet,
  final feet, gap feet, an operator step rate, an oiler step rate, two code prefixes, a label
  suffix and a status — with at most one ACTIVE scale per union code, and **no tier rows are
  persisted**.
- **Surface:** schema / api
- **Sources:**
  - `SCRUM-934` — `[UNVERIFIED]` — kind: jira — the field list verbatim, *"Only one ACTIVE scale
    per union code"*, *"No tier rows are persisted."*
  - `payroll/mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md` —
    `[UNVERIFIED]` — kind: vault — the MLA states the premium as a formula, not a table:
    *"Eighty (80) feet up to one hundred (100) feet, including jib, seventy-five cents (\$0.75)
    per hour. Thereafter, they shall receive an additional seventy-five cents (\$0.75) per hour to
    the regular rate of pay for each additional twenty (20) feet of boom or part thereof."*
  - `payroll/legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md` —
    `[UNVERIFIED]` — kind: vault — 33 distinct modifier codes observed across 86,728 labor rows,
    hand-maintained as rows.
  - `payroll/rules/PAY-011-l12-modifier-boom-rate.md` — `[UNVERIFIED]` — kind: vault — status
    `open`, blocking item *"Confirm modifier source and windows"*.
- **Conflict:** none on the storage shape. On what the adder does once computed, see REQ-20.
- **Open question:** none for the storage shape.
- **Acceptance:** creating a second ACTIVE scale for the same union code is rejected; no table in
  the migration holds one row per tier.
- **Notes for the executor:** `SCRUM-934` justifies dropping effective dating with *"the MLA writes
  these in cents and they have not changed since 2020-04-10"* — corroborated by
  `payroll/legacy-payroll-app-db-extract/data/source-feed.md`, where every
  `FMS_UNION_CRAFT_MODIFIER` sample row carries `StartDate=04/10/2020` (one at `04/14/2020`) and
  no `EndDate`. That is a **fact about the legacy rows**, not a product decision that rates will
  never change; `payroll/rules/PAY-008-…` requires effective dating for configuration generally.

### REQ-12 — Boom tier and adder are computed by a pure function `[UNVERIFIED]`

- **Statement:** For a boom length in feet at or above `initialFt`, the tier is
  `max(1, ceil((boomLengthFt − initialFt) / gapFt))`, capped at
  `ceil((finalFt − initialFt) / gapFt)`; below `initialFt` there is no modifier. The adder is
  `tier × stepRate(roleType)` — and is **zero for a role with no step rate on the scale**
  (REQ-14).
- **Surface:** api
- **Sources:**
  - `payroll/mcog-l12-mla-2025-2028/02-…` — `[UNVERIFIED]` — kind: vault — *"each additional
    twenty (20) feet of boom **or part thereof**"* — the "part thereof" is what makes it a ceiling
    and not a floor.
  - `payroll/legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md` —
    `[UNVERIFIED]` — kind: vault — the observed adders tie out to the formula exactly at every
    sampled tier: `OP-BP-06` (181–200 ft) = `4.500` = 6 × 0.75; `OI-BP-06` = `1.500` = 6 × 0.25;
    `OP-BP-18` (421–440 ft) = `13.500` = 18 × 0.75.
  - `SCRUM-934` — `[UNVERIFIED]` — kind: jira — the formula as written.
  - `SCRUM-935` — `[UNVERIFIED]` — kind: jira — worked example: 195 ft → tier 6, $4.50 operator /
    $1.50 oiler. Both formulas agree here: `floor(115/20)+1 = 6`, `ceil(115/20) = 6`.
  - `SCRUM-926 planning answers 2026-08-24 (Syed Haris)` — `[UNVERIFIED]` — kind: jira — **Q11 then
    Q12.** Q11 settled the lower boundary (80 ft is tier 1); Q12 settled the formula that delivers
    it without breaking the upper boundaries. **`SCRUM-934`'s body is being corrected to the Q12
    formula.**
- **Conflict:** none. Q12 closed the last disagreement here.
- **Open question:** none.
- **Acceptance:** the function reproduces every one of the 33 legacy `CraftModifierCode` **adders**
  in `craft-modifiers-and-boom-status.md` from the L12 values, as a test, **and** the length→tier
  mapping now ties out at every boundary — 79 → none, 80 → 1, 100 → 1, 101 → 2, 120 → 2, 195 → 6,
  200 → 6, 440 → 18. No test is left pending.
- **Notes for the executor:** the tie-out is still the strongest evidence in this spec — use the
  legacy table as the fixture, not as a target to hand-tune toward. **Write the formula as
  `max(1, ceil(…))`, not as a `ceil` with an `if boomLengthFt == initialFt` special case.** They
  behave identically and the second invites someone to "simplify" the special case away, which
  silently restores the bug Q11 fixed. Two cautions. The `finalFt` cap means a boom above `finalFt`
  prices at tier 18 rather than failing; no source says that is right, and REQ-15's note records
  that 440 ft has no contractual basis at all. And the legacy `PayRateChange` values carry **three
  decimal places** (`0.750`, `4.500`, `13.500`), which `Decimal(10,4)` holds exactly (Q15) —
  **do not round the adder to cents here**; that happens once in the pay-component ledger
  (`PAY-069`), downstream of this epic. A craft whose `roleType` has no step rate gets no
  modifier — REQ-14.

### REQ-13 — Modifier code and label strings are derived, never stored `[UNVERIFIED]`

- **Statement:** A tier's code and label are derived from the scale — the code from the role's
  prefix and the zero-padded tier number, the label from the tier's foot range and the label
  suffix — and are never persisted.
- **Surface:** api
- **Sources:**
  - `payroll/legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md` —
    `[UNVERIFIED]` — kind: vault — the exact observed strings: `OP-BP-06` / `181-200Ft-Operator`,
    `OI-BP-01` / `080-100Ft-Oiler`, `OP-BP-18` / `421-440Ft-Operator`.
  - `SCRUM-934` — `[UNVERIFIED]` — kind: jira — *"its code (e.g. `OP-BP-06`) and its label (e.g.
    `181-200Ft-Operator`) are derived at pricing time"*; scale carries `codePrefixOperator`,
    `codePrefixOiler`, `labelSuffix` = `Ft-{role}`.
- **Conflict:** none.
- **Open question:** none. **Q12 settled the label's upper bound** — under
  `max(1, ceil(…))` tier 1 spans 80–100 ft and tier *n* ≥ 2 spans
  `initialFt + (n−1)·gapFt + 1` … `initialFt + n·gapFt`, which is exactly the legacy pattern.
- **Acceptance:** for the L12 values, the generated **code** and **label** strings are
  string-identical to all 33 legacy pairs, including the zero padding and the `080-100` /
  `101-120` irregularity at tier 1. Nothing is pending.
- **Notes for the executor:** two formatting facts are visible in the legacy strings and must be
  reproduced rather than reinvented. (a) The tier number is **two digits, zero-padded**
  (`OP-BP-01`, not `OP-BP-1`). (b) The label's lower bound is **three digits, zero-padded**
  (`080-100Ft-Oiler`), and for tiers 2 and above it is the previous tier's upper bound **plus
  one** (`101-120`, `181-200`) — while **tier 1's lower bound is `080`, not `081`.** Q11 and Q12
  together confirm that irregularity is intentional and reproduce it: 80 ft is tier 1, and tier 1's
  range genuinely runs `080`–`100`, which is why tier 1 is one foot wider than every other tier.
  **Do not "fix" that asymmetry**, and do not write the 33 legacy strings into a lookup table —
  REQ-13's whole point is that these strings are **derived**.

### REQ-14 — Behaviour at exactly `initialFt` (80 ft) — it **is** tier 1 `[UNVERIFIED]`

- **Statement:** A boom of exactly `initialFt` (80 ft on the L12 values) **is tier 1** and earns the
  tier-1 adder — `+$0.75` for an operator, `+$0.25` for an oiler. Below `initialFt` there is no
  modifier. **A craft whose `roleType` has no step rate on the scale earns no modifier at any boom
  length**, even when one is supplied.
- **Surface:** api
- **Sources:**
  - `SCRUM-926 planning answers 2026-08-24 (Syed Haris)` — `[UNVERIFIED]` — kind: jira — Q11:
    *exactly 80 ft IS tier 1 (`080-100Ft`, +$0.75)*, with the revised formula now in REQ-12 and a
    note that **`SCRUM-934`'s body is being corrected to match**.
  - `payroll/mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md` —
    `[UNVERIFIED]` — kind: vault — *"**Eighty (80) feet** up to one hundred (100) feet, including
    jib, seventy-five cents (\$0.75) per hour"* — the contract reads as the premium applying **at**
    80 ft, which the answer agrees with.
  - `payroll/legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md` —
    `[UNVERIFIED]` — kind: vault — tier 1 is labelled `080-100Ft-Operator`, a range that
    **includes 080**. Also agrees.
  - `SCRUM-926 planning answers 2026-08-24 (Syed Haris)` — `[UNVERIFIED]` — kind: jira — Q12, on the
    role half: *a `roleType` with no boom step rate returns **no modifier** even when a boom length
    is present.* This closes what the pre-revision spec left as `NOT SPECIFIED`.
- **Conflict:** none. The answer sided with the two sources against `SCRUM-934`'s original formula,
  and the ticket is being corrected rather than the sources reinterpreted — which is the right
  direction of travel.
- **Open question:** none. Q11 settled the lower boundary and Q12 the upper one (REQ-12).
- **Acceptance:** a boom of exactly 80 ft returns tier 1 and an adder of `$0.75` for an operator and
  `$0.25` for an oiler; 79 ft returns no modifier. **A craft whose `roleType` carries no step rate
  on the active scale returns no modifier at 80 ft, at 195 ft and at any other length** — not a
  Blocked result, and never the operator step rate. On the L12 values that is four of the six roles
  — `THIRD_MAN`, `LABORER`, `ADMIN` and `MECHANIC` — leaving only `OPERATOR` and `OILER` earning a
  boom adder.
- **Notes for the executor:** **"no modifier" here is a different outcome from REQ-18's Blocked, and
  the difference is deliberate.** Blocked means the data needed to price is missing — no rate row,
  no active scale, craft outside its window. This is not that: the scale exists and is complete,
  and the correct answer for this role simply *is* zero. Returning Blocked instead would stop a
  payroll run on a perfectly valid admin timecard. Gate on **whether the role has a step rate**,
  not on a hardcoded list of role names, so a fifth role value cannot silently inherit the
  operator rate.

### REQ-15 — L12 scale seed values — **as a test fixture only** `[N/A — OUT OF SCOPE]`

- **Statement:** **`N/A — OUT OF SCOPE.` No scale is seeded by this epic.** An administrator
  creates the scale through the API (REQ-11). The L12 values — initial 80 ft, final 440 ft, gap
  20 ft, operator step $0.75, oiler step $0.25, prefixes `OP-BP` / `OI-BP`, label suffix
  `Ft-{role}`, 18 tiers × 2 roles — **remain the fixture** for the tier-function and preview tests
  in REQ-12, REQ-13 and REQ-16, which `SCRUM-934` requires. They are test data, not seed data.
- **Surface:** schema (none) / api (tests)
- **Sources:**
  - `SCRUM-926 planning answers 2026-08-24 (Syed Haris)` — `[UNVERIFIED]` — kind: jira — Q5:
    *seeding is **out of scope** for this epic. No L12 rate seed, no scale seed; admins enter rates
    and the scale through the API.*
  - `SCRUM-934` — `[UNVERIFIED]` — kind: jira — *"Seed: one scale for L12 — 80 · 440 · 20 · 0.75 ·
    0.25 · `OP-BP` / `OI-BP` · `Ft-{role}` — reproducing the 33 legacy `FMS_UNION_CRAFT_MODIFIER`
    codes."* **Superseded as a seed by Q5**; the values survive as the fixture, and the
    "reproducing the 33 codes" tie-out survives with them.
  - `payroll/mcog-l12-mla-2025-2028/02-…` — `[UNVERIFIED]` — kind: vault — 80 ft, 20 ft steps,
    $0.75 operator, $0.25 oiler, all verbatim from Article IV. The MLA states **no upper bound**.
  - `payroll/legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md` —
    `[UNVERIFIED]` — kind: vault — the highest observed code is `OP-BP-18` = `421-440Ft-Operator`,
    which is where 440 comes from. `(440 − 80) / 20 = 18` tiers.
- **Conflict:** none.
- **Open question:** none. But note the **440 ft ceiling has no contractual basis** — it is the
  largest bracket anyone happened to key into FCC (one labor row in 86,728). The MLA's *"each
  additional twenty (20) feet"* is open-ended. What happens above 440 ft is `NOT SPECIFIED`; the
  ticket does not ask, and this spec does not invent an answer.
- **Acceptance:** `N/A` as a migration — **no seed row is written.** As a fixture: a scale built
  from these values previews 18 tiers per role, and the 33 codes present in the legacy table are
  all reproduced with matching adders.
- **Notes for the executor:** 18 × 2 = 36 derivable codes against 33 observed — the three missing
  ones (`OI-BP-16/17/18`) are simply brackets no oiler ever worked. That is not a defect. **Do not
  quietly reintroduce this as a seed** because the tests need a scale to exist: build the fixture
  in the test setup, not in a migration. The consequence of there being no scale in the database is
  intended and specified — REQ-18 returns Blocked until an administrator creates one.

### REQ-16 — Tier preview endpoint `[UNVERIFIED]`

- **Statement:** An endpoint lists every tier of a scale — tier number, foot range, adder, code and
  label, per role — computed with the same function used at pricing time.
- **Surface:** api
- **Sources:**
  - `SCRUM-934` — `[UNVERIFIED]` — kind: jira — *"A preview endpoint lists every tier for a scale
    using the same function (18 tiers × 2 roles for the L12 seed)."*
- **Conflict:** none.
- **Open question:** none.
- **Acceptance:** the preview output and the resolver's boom lookup agree for every tier — the
  same function, called twice, not two implementations. Tested against a scale **built in the test
  fixture** from REQ-15's values, since nothing is seeded (Q5).
- **Notes for the executor:** the point of *"using the same function"* is that a second
  implementation would drift. Put the function in the service layer and have both callers use it.

### REQ-17 — `CraftRateResolverService` interface, keyed by work date `[UNVERIFIED]`

- **Statement:** A service turns an employee, a work date, an optional secondary craft and an
  optional boom length into a base rate, a boom adder and the modifier code/label. **Every *union*
  lookup is keyed by the work date, never by today** — the craft window, the rate row and the
  scale. The **non-union** base rate is the exception and is deliberate: it reads
  `Employee.hourlyRate` as it currently stands (REQ-10, Q1), because no effective-dated non-union
  rate exists in this epic.
- **Surface:** api
- **Sources:**
  - `SCRUM-935` — `[UNVERIFIED]` — kind: jira — the three methods
    (`resolveEmployeeCraft`, `resolveBaseRate`, `resolveBoomAdder`), their arguments and returns,
    verbatim; *"Every lookup is keyed by the **work date**, never today."*
  - `payroll/rules/PAY-008-effective-dated-configuration.md` — `[UNVERIFIED]` — kind: vault —
    *"Historical recalculation must use rules effective on the work date."*
  - `payroll/rules/PAY-010-l12-union-base-rate.md` — `[UNVERIFIED]` — kind: vault — **`status:
    settled`** — *"Use effective union craft rate as base straight-time rate"*, requires
    *"Labor CraftCode; union craft rate; work date"*.
  - `decisions/2026-08-20-craft-locked-rate-override.md` — `[VERIFIED]` — kind: decision — rates
    always come from craft tables; day-level deviation is via a secondary craft code, never a
    free-text amount.
  - `payroll/rules/PAY-068-retroactive-correction.md` — `[UNVERIFIED]` — kind: vault — *"Calculate
    delta adjustment without rewriting original payroll"* — the reason work-date keying is
    load-bearing rather than tidy. Status `open`, blocking item *"Confirm correction workflow"*.
- **Conflict:** none on the interface. `payroll/rules/PAY-010-…` records that the rate-resolution
  conflict it once carried (labor-row craft vs employee's own rate) is **settled** by the verified
  decision above.
- **Open question:** none. **Q2 is answered** — `SCRUM-926 planning decisions 2026-08-25 (Syed Haris)` —
  `[UNVERIFIED]` — kind: jira: *the boom modifier (boom length) is chosen on the ticket / labor
  entry when the ticket is closed after the customer's final signature; it is **never derived from
  the unit**.* That confirms this interface: `resolveBoomAdder` takes `boomLengthFt` **from the
  entry**, which is what it already specified. The capture itself is the labor-entry ticket's work
  (intent §5), not this epic's.
- **Acceptance:** the unit tests listed on `SCRUM-935` — rate-window boundaries (day before, day
  of `effectiveFrom`, `effectiveTo`), secondary override, boom below scale, "part thereof"
  rounding (195 ft → tier 6, $4.50 / $1.50), missing rate, missing scale, inactive craft — **plus
  the union/non-union branch**: a `UNION` craft resolves from `CraftCodeRate` on the work date, a
  `NON_UNION` craft from `Employee.hourlyRate`, and a non-union resolve with **no** rate rows
  present succeeds rather than returning Blocked.
- **Notes for the executor:** service layer, no HTTP surface (`SCRUM-935`). Layering is
  `presentation → usecase → service → orm` and never upward (`.ai/claude/contexts/api.md`).
  **This interface is per labor entry by design, and that is now a decision rather than an
  oversight.** `payroll/codingcops-rule-matrix.md` §B `PR-015` / `payroll/rules/PAY-015-…` require
  identifying the higher qualifying rate across a day when an employee works several crafts and
  raising a true-up component — day-level work this interface cannot do, because it prices one
  entry at a time. Q13 confirms that rule belongs to the **payroll engine**, a later ticket under
  `SCRUM-920`. Build exactly the three methods `SCRUM-935` specifies; do not add a day-level
  variant here.
  **How this unit is reviewed, since it has no HTTP surface — answered (Q16):** its **test suite is
  the acceptance evidence**, together with U2's
  `GET /api/v1/craft-modifier-scales/:id/preview`, which exercises the same tier function through
  curl. **No diagnostic endpoint is added for the resolver.** The demo-via-curl constraint is
  satisfied by the preview route, so do not add a `craft-rate-resolver` route to make the unit
  demonstrable — that would put a surface in front of an interface `SCRUM-929`/`930` are being
  written against, and a later ticket would then have to decide whether to keep it.

### REQ-18 — Missing rate / window / scale returns Blocked, never throws `[UNVERIFIED]`

- **Statement:** When no rate is in force on the work date, the craft is outside its window, or a
  boom length is given but no active scale exists, the resolver returns a Blocked result carrying
  a missing-data issue rather than throwing to the caller.
- **Surface:** api
- **Sources:**
  - `SCRUM-935` — `[UNVERIFIED]` — kind: jira — *"→ returns a Blocked result (missing-data issue,
    PAY-060), never throws to the caller."*
  - `payroll/rules/PAY-060-missing-data-issues.md` — `[UNVERIFIED]` — kind: vault — *"Create
    Error, Warning, Review, or Informational issue"* when required information is unavailable.
    Status `open`, blocking item **"Confirm severity matrix"**.
- **Conflict:** none.
- **Open question:** none blocking — but **which severity** each of the three Blocked cases carries
  is `NOT SPECIFIED`: `PAY-060`'s own blocking item is exactly that the severity matrix is
  unconfirmed. Do not assign severities.
- **Acceptance:** each of the three failure cases returns a Blocked result naming the cause; no
  path throws. **On a freshly migrated database this is the normal path, not an edge case** — with
  seeding out of scope (Q5) there are no rate rows and no scale until an administrator enters them,
  so every resolver call returns Blocked. That is intended and must not be "fixed".
- **Notes for the executor:** the issue *record* (a persisted `PayrollIssue` or equivalent) is
  `PAY-060`'s own scope and is not in this epic. Return the Blocked result; do not invent a table
  to store it in.

### REQ-19 — Which employee rate columns the resolver may read `[UNVERIFIED]`

- **Statement:** The resolver reads **`Employee.hourlyRate` for `NON_UNION` employees only**
  (REQ-10), and never for union employees. **`Employee.payRateOT` and `Employee.payRateDB` are
  never read by anyone** — OT and DT derive from the base rate (REQ-02), they are not stored rates.
- **Surface:** api
- **Sources:**
  - `SCRUM-926 planning decisions 2026-08-25 (Syed Haris)` — `[UNVERIFIED]` — kind: jira — Q1:
    `NON_UNION` → `Employee.hourlyRate`; *"`payRateOT`/`payRateDB` still derived, not read"*.
  - `payroll/rules/PAY-012-non-union-hourly-rate.md` — `[UNVERIFIED]` — kind: vault — *"Use
    employee-master hourly rate"* for Non-Union Admin Hourly, client-confirmed 2026-06-09.
  - `payroll/rules/PAY-010-l12-union-base-rate.md` — `[UNVERIFIED]` — kind: vault — **`status:
    settled`** — for L12, *"use effective union craft rate as base straight-time rate"*. The union
    half of this requirement is the settled one.
  - `decisions/2026-08-20-craft-locked-rate-override.md` — `[VERIFIED]` — kind: decision — *"rates
    always come from craft tables"*, day deviations *"never a free-text dollar override"*.
  - `SCRUM-935` — `[UNVERIFIED]` — kind: jira — *"`Employee.hourlyRate` / `payRateOT` / `payRateDT`
    are never read."* **Superseded in part by Q1** for the `hourlyRate` half, under the precedence
    rule in §0; still authoritative for `payRateOT` / `payRateDB`.
- **Conflict:** none flagged, **but the scope of the verified decision is worth stating plainly.**
  `decisions/2026-08-20-…` says *"rates always come from craft tables"*, and under Q1 the non-union
  rate does not. Three things make that a scope question rather than a contradiction: the decision
  is about **craft-locked rates and day-level overrides** in an L12 context; its "never a free-text
  dollar override" concerns a per-day amount typed on a labor entry, not a master column on the
  employee; and `PAY-012` — with its own written client confirmation — states the non-union rule
  separately. So the two read as complementary, one per payroll group. **Nobody has confirmed that
  reading**, and if the verified decision was meant to cover every employee, this requirement
  contradicts it for 21,348 labor rows' worth of population.
- **Open question:** none raised. The scope note above is recorded rather than escalated, because
  four independent sources agree on the non-union half.
- **Acceptance:** a union employee whose `hourlyRate` differs from their craft rate resolves to the
  **craft rate**; a non-union employee resolves to **their own `hourlyRate`**; a grep of the
  resolver and its repository shows **no reference to `payRateOT` or `payRateDB`** on any path.
- **Notes for the executor:** `Employee.hourlyRate` is now **load-bearing for payroll**, which
  reverses the pre-revision reading of this requirement — it is not a legacy column awaiting
  removal, it is the non-union rate. It is therefore **removed from the retirement list** in
  REQ-23. `payRateOT` and `payRateDB` remain unread and their removal stays deferred (intent §5),
  as does the `payRateDB → payRateDT` rename; note the schema's column is `payRateDB`
  (`schema.prisma` ~line 3516) while `SCRUM-935` writes `payRateDT`.

### REQ-20 — The boom adder is returned separately; composition is not decided here `[CONFLICT]`

- **Statement:** `CONFLICT — the resolver returns the boom adder as its own value alongside the
  base rate. Whether that adder goes **into** the base rate before multipliers or is paid **on
  top** is unresolved, and this spec does not decide it.`
- **Surface:** api
- **Sources:**
  - `payroll/rules/PAY-011-l12-modifier-boom-rate.md` — `[UNVERIFIED]` — kind: vault — status
    `open`. Carries the conflict explicitly: *"MLA says boom/modifier-class premiums go **into the
    base rate** before multipliers; the legacy slice formula partly agrees; 'on top' never
    confirmed."* Its own working reading is *"Into-the-rate across the board"* with two carve-outs
    — and says plainly **"Decision note pending"**.
  - `payroll/mcog-l12-mla-2025-2028/02-…` — `[UNVERIFIED]` — kind: vault — *"The additional rate
    added to the regular rate shall be the base rate when computing overtime pay."*
  - `payroll/2026-08-20-payroll-rules-meeting-notes.md` — `[UNVERIFIED]` — kind: vault — the
    opposite reading, from a TCG payroll SME six days after: *"Boom-time premiums are unaffected —
    they add **on top** of whichever rate applies, override or not."*
  - `payroll/source-attribution-and-conflicts.md` → *Into the rate vs on top* — `[UNVERIFIED]` —
    kind: vault — the standing conflict register entry.
- **Conflict:** candidates — MLA Article IV (9.6 KB, contract text, `updated: 2026-06-23`) and
  `payroll/rules/PAY-011-…` (3.4 KB, `2026-08-24`) on the into-the-rate side; the 2026-08-20
  meeting notes (8.5 KB, `status: unverified`, cleaned from a transcript) on the on-top side.
  **None is verified**, `PAY-011` says its own reading is provisional and the decision note is
  pending, and this spec does not pick a winner. Register:
  `payroll/gaps.md` → the recordings-vs-vault entries, via `payroll/rules/PAY-011-…`.
- **Open question:** **Q3 answered as a working decision, and the `[CONFLICT]` stays.** `SCRUM-926 planning decisions 2026-08-25 (Syed Haris)`
  — `[UNVERIFIED]` — kind: jira: *the boom adder is paid **ON TOP** — a flat $/h × boom hours,
  **not** multiplied by OT / DT / holiday multipliers and **not** folded into the base rate for
  overtime.* That sides with `payroll/2026-08-20-payroll-rules-meeting-notes.md` (*"add on top of
  whichever rate applies"*) **against the MLA's Article IV wording** (*"The additional rate added
  to the regular rate shall be the base rate when computing overtime pay"*), which is a contract
  text and is not amended by a planning decision. **TCG payroll / labor counsel must confirm.**
  It still does not block this epic: the resolver returns two values and composes nothing.
- **Acceptance:** the resolver's return carries `baseRate` and `boomAdder` as distinct values; no
  code in this epic adds them together.
- **Notes for the executor:** if you find yourself writing `baseRate + boomAdder` anywhere in this
  epic, stop — the composition belongs to the payroll-engine ticket under `SCRUM-920`, which now
  carries Q3's working decision **and** its unresolved conflict with Article IV. Two things to hand
  that ticket. (a) *On top, unmultiplied* means the adder needs **boom hours** as its own quantity,
  not a rate adjustment to the entry's hours — a different shape from every other premium that
  rides the base rate. (b) **The ADP export is affected**: the decision notes an implication for
  the `LB` OT / DBL / TRI export columns. Treat that as the decision's own claim — `payroll/rules/PAY-067-adp-export.md`
  is `status: conflicted` and **no `LB` earning code appears anywhere in the vault**; the closest
  written analogue is the REG/OT/DT/TRI shape documented for the Foreman (`FRT`) and Military
  (`MLT`) premiums in `payroll/foreman-and-military-premiums.md`, which raises the same
  multiplied-or-not question. Do not invent the code set.

### REQ-21 — L12 craft rates seeded at the MLA 7/1/2025 column `[N/A — OUT OF SCOPE]`

- **Statement:** **`N/A — OUT OF SCOPE.` No craft rates are seeded by this epic.** Administrators
  enter rates through the API (REQ-02). The MLA figures below are retained as **reference**, not as
  a migration: they are the best-corroborated numbers in this spec and whoever enters the rates
  will want them.
- **Surface:** schema (none)
- **Sources:**
  - `SCRUM-926 planning answers 2026-08-24 (Syed Haris)` — `[UNVERIFIED]` — kind: jira — Q5:
    *seeding is **out of scope** for this epic. No L12 rate seed, no scale seed; admins enter rates
    and the scale through the API.*

  - `payroll/rules/PAY-010-l12-union-base-rate.md` — `[UNVERIFIED]` — kind: vault — **`status:
    settled`**, with a three-way tie-out verified 2026-08-24: *"MLA 7/1/2025 column (Group 1
    **$66.03**, Group 3 **$67.87**) = FCC `UNION_CRAFT` rows (extract snapshot 06-23) = the
    extract's worked examples = the client's own screenshots."*
  - `payroll/mcog-l12-mla-2025-2028/02-…` — `[UNVERIFIED]` — kind: vault — the 7/1/2025 column in
    full: Group 1 $66.03 · Group 2 $66.18 · Group 3 $67.87 · Group 4 $67.99 · Group 5 $68.16 ·
    Group 6 $68.41 · Group 7 $68.66 · Group 8 $69.16 · Group 9 $71.16.
  - `payroll/legacy-payroll-app-db-extract/data/source-feed.md` — `[UNVERIFIED]` — kind: vault —
    `FMS_UNION_CRAFT` row `UnionCode=L12; CraftCode=L12-G2-A; PayRate=66.180` corroborates the
    Group 2 figure at the `-A` suffix.
  - `payroll/mcog-l12-mla-2025-2028/02-…` — `[UNVERIFIED]` — kind: vault — apprentice steps are a
    **percentage of the Group 5 rate**: Step I 60%, II 65%, III 70%, IV 75%, V 80%.
- **Conflict:** none on the 7/1/2025 figures themselves — this is the best-corroborated data in
  the spec, which is why it is worth keeping visible even though nothing is seeded from it.
- **Open question:** none. **Q5 is withdrawn** — seeding left the epic.
- **Acceptance:** `N/A` — no seed row is written. If an administrator enters the Group 3 rate as
  $67.87 effective 2025-07-01, a resolver call for a September 2025 work date returns $67.87
  (that is REQ-02 and REQ-17, tested there).
- **Notes for the executor:** the `-A` / `-B` / `-C` suffixes on the legacy craft codes are **pay
  types**, not rate variants of the base — `FMS_CRAFTS` shows `ADMIN-A` = `PayType=R` /
  `AcctPayType=HOURLY`, `ADMIN-B` = `O` / `OVERTIME`, `ADMIN-C` = `D` / `DOUBLE TIME`, and
  `UNION_CRAFT` accordingly holds `L12-G2-A=66.180`, `L12-G2-B=99.270` (1.5×),
  `L12-G2-C=132.360` (2×). Under REQ-02 the craft carries **base straight-time only** and OT/DT
  derive — so the `-B` and `-C` rows must **not** be copied as separate crafts with their own
  rates. This is the single most likely way to get REQ-23 wrong. **Q4's answer now says this
  explicitly** — the migration collapses `-A`/`-B`/`-C` into one `CraftCode` per base code
  (REQ-05) — so the hazard is specified rather than merely warned about. Note the consequence for
  this requirement: because the copy brings across **crafts but not rates** (Q5), every collapsed
  craft arrives with **no rate row at all**, and stays Blocked until someone enters one.

### REQ-22 — FY2026-27 L12 rate rows `[N/A — OUT OF SCOPE]`

- **Statement:** **`N/A — OUT OF SCOPE.`** Seeding left the epic (Q5), so this spec does not decide
  which fiscal-year rate rows exist at launch — administrators enter them. **The question did not
  go away; it moved.** Whoever enters the FY2026-27 rates still has to know which figures are
  authoritative, and the vault still contradicts itself about that. It is recorded below and in
  §13 so that it is findable when someone reaches for it, and Q5 is withdrawn rather than answered.
- **Surface:** schema (none)
- **Sources:** none that settle which figures are right. What was read, and how it conflicts:
  `payroll/rules/PAY-010-l12-union-base-rate.md` (updated `2026-08-24`, `status: settled`):
  *"**FY2026-27 rates are not derivable from the vault:** the MLA shows the increase total
  (\*\$5.00) but the per-group allocation column is blank — the annual allocation decides the
  wage-vs-fringe split. **Get the new rate sheet.**"*
  `payroll/rules/PAY-008-effective-dated-configuration.md` (updated `2026-08-24`, same day):
  *"**FY2026-27 rates recovered from TCG's own workbook** (`CraftRates` sheet, July 25–31 week):
  G1–G9 each **+\$1.00** (67.03 … 72.16) … Two-year effective-dated rate history now complete in
  the record."*
  `payroll/rules/PAY-016-apprentice-wage-step.md` agrees with PAY-008: *"FY26-27 apprentice steps
  recovered (workbook `CraftRates`): APP1–APP6 = 41.50 / 44.95 / 48.41 / 51.87 / 55.33 / 62.24."*
  `payroll/mcog-l12-mla-2025-2028/02-…` — the 7/1/2026 and 7/1/2027 columns in the wage table are
  **empty**, with only the `* $5.00` / `* $4.50` increase totals and the Union's allocation option
  footnote.
  Two of the three register files say the figures are recovered; the one that is `status: settled`
  on this exact rule says they are not and asks for the sheet. **Neither is verified, and this
  spec does not adjudicate between two files updated the same day.**
- **Conflict:** n/a as a requirement — nothing is built from it.
- **Open question:** none owned by this epic. The underlying question — *are the workbook figures
  (G1–G9 = 67.03…72.16, APP1–6 = 41.50…62.24) authoritative, or must TCG supply the official Local
  12 rate sheet?* — is now a **data-entry** question for whoever enters rates, not a build blocker.
  It belongs in the payroll module's own register rather than this ticket's; `tcg-scrum` owns that
  write path. Q5 is withdrawn on that basis, not resolved.
- **Acceptance:** `N/A` — nothing is built.
- **Notes for the executor:** nothing to do here, but one thing not to do elsewhere. Out-of-scope
  seeding means the system ships **empty**, and every resolver call returns Blocked (REQ-18) until
  rates are entered. That will look like a bug during testing. It is not. **Do not seed a rate to
  make a test pass, and do not carry a 2025-07-01 row forward with an open-ended `effectiveTo`** —
  that fabricates a rate on every current labor entry and is indistinguishable from a real one.

### REQ-23 — Schema migration only: add the new tables, columns and enums `[UNVERIFIED]`

- **Statement:** This epic's migration **adds** structure and moves no data, **with one narrow and
  deliberate exception: it derives `EmployeeUnionCode.kind` for rows that already exist** (REQ-09,
  Q19), because the column is required and the table is populated. That is the only business column
  this migration writes. It creates
  `craft_codes`, `craft_code_rates`, `employee_craft_assignments` and `craft_modifier_scales`, adds
  the `RoleType` and `UnionKind` enums, adds `kind` / `localNumber` / `agreement` to
  `EmployeeUnionCode` **and populates `kind` by label match**, and adds the new
  `ActivityLogEntityType` members (REQ-26). **There is no FCC copy, no `-A`/`-B`/`-C` collapse, no
  prefix→`roleType` mapping, no PRIMARY backfill from `Employee.craftCodeId`, and no
  null-`craftCodeId` pre-check.** Administrators create craft codes, rates, scales and assignments
  through the API.
- **Surface:** schema
- **Sources:**
  - `SCRUM-926 planning decisions 2026-08-25 (Syed Haris)` — `[UNVERIFIED]` — kind: jira — Q14 and
    Q17 resolved by scope change: **no data migrations in this epic.** Schema migrations that
    *add* tables, columns and enums remain — *"they are unavoidable"*.
  - `.ai/claude/contexts/prisma.md` → *Migrations* — `[UNVERIFIED]` — kind: code/rules — a schema
    change requires a committed migration under `apps/api/prisma/migrations/`. That obligation is
    unchanged; only its **content** shrank.
- **Conflict:** none.
- **Open question:** none. **Q19 is answered** — `EmployeeUnionCode.kind` is derived for existing
  rows by label match (REQ-09). It is the sole data write in this migration, and it is reviewed
  row-by-row in the PR before merge.
- **Acceptance:** a committed migration exists under `apps/api/prisma/migrations/`; it creates the
  four tables and two enums and extends `EmployeeUnionCode`; **the only business column it writes
  is `EmployeeUnionCode.kind`** (REQ-09), with every derived value listed in the PR description for
  review before merge; `employee_craft_codes`, `Employee.craftCodeId`, `Employee.unionCodeId` and
  `Employee.unionStatus` are **still present and unchanged** after it runs; the migration is
  reversible without data loss.
- **Notes for the executor:** **the drops moved out of this epic**, and that changes the shape of
  the work more than it looks. `employee_craft_codes`, `Employee.craftCodeId`,
  `Employee.unionCodeId` and `Employee.unionStatus` all stay, and are simply **no longer read by
  payroll** — a later cleanup ticket removes them once every employee has a PRIMARY assignment
  (REQ-07). Three consequences. (a) **Two representations of an employee's craft are live at the
  same time**: the old `Employee.craftCodeId` and the new `EmployeeCraftAssignment`. Nothing keeps
  them in step, and no source says anything should. Do not add a sync — write to the new one from
  the new endpoints and leave the old column alone, or the cleanup ticket inherits a two-way
  merge. (b) `Employee.hourlyRate` is **not** on the retirement list at all — it is the non-union
  base rate (REQ-10, REQ-19), and it never gets dropped. (c) Because nothing is backfilled, the new
  tables are **empty on day one** and stay empty until administrators enter data — see §11,
  *Launch state*, and REQ-18.

### REQ-24 — The hard-coded `unionStatus: 'Union'` filter is replaced `[UNVERIFIED]`

- **Statement:** The employee KPI/list filter that counts union employees tests the employee's
  **primary craft's union code kind**, and **falls back to the legacy `unionStatus` string for
  employees who have no PRIMARY assignment yet**. Both paths stay live until every employee has a
  PRIMARY (REQ-07), at which point the later cleanup ticket removes the fallback with the column.
- **Surface:** api
- **Sources:**
  - intent §4 — `[UNVERIFIED]` — kind: jira — the 2026-08-24 planning decision.
  - `SCRUM-926 planning decisions 2026-08-25 (Syed Haris)` — `[UNVERIFIED]` — kind: jira — Q14: the filter
    *"switches to the PRIMARY craft's union kind with a fallback to the legacy `unionStatus` string
    while employees lack a PRIMARY."*
  - `payroll/rules/PAY-009-payroll-group-classification.md` — `[UNVERIFIED]` — kind: vault — the
    union/non-union split is derived from the **craft code prefix** plus `EmpTypeID`, never from a
    free-text label; the predicates are written down and client-confirmed.
  - `payroll/gaps.md#union-codes-one-value-so-the-crud-question-mostly-dissolves` —
    `[UNVERIFIED]` — kind: vault — *"union code cannot derive the Payroll Group"* — so this filter
    answers "is this employee union", not "which payroll group".
- **Conflict:** none.
- **Open question:** none.
- **Acceptance:** an employee **with** a PRIMARY is counted by their craft's union kind; an
  employee **without** one is counted by the legacy `unionStatus` string exactly as today; on a
  tenant where no employee has a PRIMARY yet — which is every tenant on day one — the counts are
  **identical to current behaviour**, including its existing case-sensitivity defect.
- **Notes for the executor:** the literal is at
  `apps/api/src/service/employee/employee.repository.ts` line 485 —
  `this.prisma.employee.count({ where: { ...finalizedScope, unionStatus: 'Union' } })`. It is a
  case-sensitive exact match on a denormalised label, so it already returns zero for any tenant
  that spelled the label differently. That is current behaviour, not a specification: this
  requirement is sourced from the plan and `PAY-009`, not from the bug. **The fallback preserves
  that defect for the un-migrated population**, deliberately — this ticket is not the place to
  change what those tenants' counts say, and a "fix" here would move numbers on a dashboard with
  no ticket asking for it. Note the fallback also means the filter's two branches can disagree for
  the same employee once a PRIMARY is assigned; the craft branch wins, and that is the point.

### REQ-25 — The module is renamed `craft-codes`, old routes kept as aliases `[UNVERIFIED]`

- **Statement:** The `employee-craft-codes` module becomes `craft-codes`; the old routes remain as
  aliases until web and mobile have moved. **The old `employee_craft_codes` table and its rows stay
  as they are** (REQ-23) — this is a rename of the API module, not of the storage behind it.
- **Surface:** api / shared
- **Sources:**
  - intent §4 / §6 — `[UNVERIFIED]` — kind: jira — the 2026-08-24 planning decision. **No ticket
    states this** — it appears on none of `SCRUM-925/927/934/935`.
- **Conflict:** none.
- **Open question:** none. How long the aliases live, and which ticket removes them, is
  `NOT SPECIFIED`.
- **Acceptance:** `GET /api/v1/employee-craft-codes` and `GET /api/v1/craft-codes` both resolve;
  `pnpm build` passes for `@tcg/web` and `@tcg/mobile` with no change to their source.
- **Notes for the executor:** the surfaces that consume the current contract are listed in intent
  §6 — the `EmployeeCraftCode` select shape, `Employee.craftCodeId` and `unionStatus` are read by
  web and mobile today. Run `tcg-contract-tracer` before changing the DTO shape; only files
  importing `@tcg/shared` are compile-checked. **Since the drops moved out of this epic (REQ-23),
  the aliased routes now serve a table that is still live and still written by the existing
  employee endpoints** — so `GET /api/v1/employee-craft-codes` and `GET /api/v1/craft-codes` return
  **different data**, not the same data under two names. That is a sharper trap than the
  pre-revision plan had: do not implement the alias as a passthrough to the new `craft_codes`
  table, and do not let a caller assume the two are interchangeable. Which of the two web and
  mobile should be reading, and when they switch, is `NOT SPECIFIED`.

### REQ-26 — Craft, rate, scale and assignment changes are written to the activity log `[UNVERIFIED]`

- **Statement:** Creating or changing a craft code, a rate row, a modifier scale or a craft
  assignment writes an activity-log entry naming who changed what.
- **Surface:** schema / api
- **Sources:**
  - `SCRUM-934` — `[UNVERIFIED]` — kind: jira — *"Changes are written to activity-logs."*
  - intent §5 — `[UNVERIFIED]` — kind: jira — assignments are current state and *"the activity log
    is the history"* — so the log is the only record of a craft change, not a convenience.
  - `payroll/rules/PAY-008-effective-dated-configuration.md` — `[UNVERIFIED]` — kind: vault —
    *"Requires: Effective from/to; rule version; **approver**."*
  - `payroll/rules/PAY-068-retroactive-correction.md` — `[UNVERIFIED]` — kind: vault — a
    retroactive correction needs the original and the corrected data; status `open`.
- **Conflict:** none.
- **Open question:** none. `PAY-008`'s **"approver"** is `NOT SPECIFIED` — no source says a craft
  or rate change needs approval, and this spec does not add an approval workflow.
- **Acceptance:** changing a craft rate produces a log entry naming the actor, the entity and the
  before/after values.
- **Notes for the executor:** `ActivityLogEntityType` (`schema.prisma` line 109) currently has no
  member for any of these four entities, so this requires new enum values and therefore a
  migration. `ActivityLogAction` has `CREATED`/`UPDATED`/`STATUS_CHANGED`, which cover it.

### REQ-27 — Temporary employees also require a primary craft at create `[UNVERIFIED]`

- **Statement:** A temporary employee (`employeeStatus = TEMPORARY`) is created with a primary
  craft assignment on the same terms as a permanent one.
- **Surface:** schema / api
- **Sources:**
  - intent §4 — `[UNVERIFIED]` — kind: jira — the 2026-08-24 planning decision: required on create,
    *"permanent and temporary"*; dispatch may set it when creating a temp.
  - `payroll/gaps.md#fill-in-field-employees-vs-the-adp-onboarding-dispatch-block` —
    `[UNVERIFIED]` — kind: vault — quotes `dispatch/daily-allocation-system.md` §*Temporary
    Employee management in DAS*: temps are assignable *"without creating full HR profiles"*, and
    Corrina Bustos's practice — *"right now with the fill-ins I give them until like Sunday to fill
    out all the ADP stuff"*. Temps do file labor, so they need a rate.
- **Conflict:** none on the craft requirement itself.
- **Open question:** none for this epic. **Q6 is answered** — `SCRUM-926 planning decisions 2026-08-25 (Syed Haris)` —
  `[UNVERIFIED]` — kind: jira: *no ADP gating of any kind. Craft assignment and temporary-employee
  creation do not check ADP onboarding status; ADP integration is deferred entirely.*
  **Read the scope of that carefully.** It settles what *this epic* builds — nothing here consults
  ADP — and it matches what already shipped (`SCRUM-254` / `SCRUM-304`). It does **not** amend
  `decisions/2026-06-30-adp-erp-employee-data-ownership.md` step 5 (`[VERIFIED]`), which blocks
  *scheduling, equipment assignment and job allocation* until ADP reports onboarding complete —
  none of which this epic touches. That decision still governs those surfaces, and whoever
  re-opens them inherits the same unresolved thread.
- **Acceptance:** creating a temporary employee without a primary craft is rejected by the same
  validation as a permanent one.
- **Notes for the executor:** `EmployeeStatus` is `PERMANENT | TEMPORARY` (`schema.prisma` line
  219). Vendor employees are a **different model** (`VendorEmployee`, ~line 2161) with no craft,
  no union code and no rate columns — they are out of scope (intent §5) and must not acquire an
  assignment.

### REQ-28 — Who may create and reassign craft assignments `[UNVERIFIED]`

- **Statement:** **Craft, rate and scale CRUD** sits behind the **existing admin gate** already
  used by the union-code and work-comp-code modules. **Craft assignment** — create, reassign, add
  a secondary — is permitted to **admin, payroll and the crane superintendent**; **dispatch** may
  set the **PRIMARY only, and only while creating a `TEMPORARY` employee**. The employee may never
  set their own.
- **Surface:** api
- **Sources:**
  - `SCRUM-926 planning answers 2026-08-24 (Syed Haris)` — `[UNVERIFIED]` — kind: jira — Q9, as
    stated above.
  - `decisions/2026-08-20-craft-locked-rate-override.md` — `[VERIFIED]` — kind: decision — *"Only
    the **crane superintendent or payroll** may set the day's craft/rate — never the employee
    (self-selection 'would create extra double-checking')."* The answer is consistent with it and
    adds admin and the dispatch carve-out.
  - `apps/api/prisma/schema.prisma` lines 18–22 — `[UNVERIFIED]` — kind: code — the `Role` enum is
    **`USER | ADMIN | SUPER_ADMIN`**, three values, nothing else.
  - `apps/api/src/presentation/employee-craft-codes/employee-craft-codes.controller.ts` lines 51,
    59, 68, 80; `…/employee-union-codes/employee-union-codes.controller.ts` lines 51, 59, 68, 80;
    `…/employee-work-comp-codes/…controller.ts` lines 53, 61, 70, 82 — `[UNVERIFIED]` — kind: code —
    the "existing admin gate" the answer refers to is literally
    `@Roles(Role.ADMIN, Role.SUPER_ADMIN)`, applied identically across all three reference-code
    modules. Cited as evidence of **what the gate is**, not as evidence of what it should be.
- **Conflict:** none. The answer and the verified decision agree on direction.
- **Open question:** none raised as a question — but see the NOTE, which is a real limit on how far
  the answer can be implemented.
- **Acceptance:** craft, rate and scale endpoints reject a `USER` and accept an `ADMIN`, matching
  the three existing reference-code modules exactly. **The assignment half cannot be fully
  acceptance-tested** — see the NOTE.
- **Notes for the executor:** **NOTE — the role values the answer needs do not exist.** The `Role`
  enum has `USER | ADMIN | SUPER_ADMIN`; there is **no `PAYROLL`, no `CRANE_SUPERINTENDENT` and no
  `DISPATCH` value**, and no source maps those three job titles onto the three enum members. So the
  CRUD half of this requirement is implementable exactly as answered, and the **assignment half is
  not**: "admin, payroll and crane superintendent, plus dispatch for a temp's PRIMARY" collapses to
  `@Roles(Role.ADMIN, Role.SUPER_ADMIN)`, which **over-grants** (every admin, not just payroll and
  the superintendent) and **under-grants** (no dispatch path for creating a temp — REQ-27). Gate on
  the existing pattern, and record the gap rather than inventing enum values: adding roles is a
  schema change with an auth blast radius well beyond this epic, and no source has asked for it.
  The one part that is settled and must hold regardless: **never the employee themselves**
  (`decisions/2026-08-20-…`, `[VERIFIED]`).

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** yes
- **Migration required:** yes — `pnpm db:migrate`, committed under
  `apps/api/prisma/migrations/`. Mandatory, not optional (`.ai/claude/contexts/prisma.md` →
  *Migrations*).
- **Data backfill required:** **no.** Q14's scope change removed every data migration from this
  epic — no FCC copy, no PRIMARY backfill, no rate seed (Q5). The migration **adds structure only**
  (REQ-23). One consequence to hold onto: `EmployeeUnionCode.kind` is a *required* column on an
  *already-populated* table, which needs a default or a nullable-then-tighten sequence that no
  source specifies — **Q19**.

### Current state, for orientation

Read descriptively, not as a specification of what should be:

| Thing | Where | What it is today |
| --- | --- | --- |
| `EmployeeCraftCode` | `schema.prisma` ~2261 | admin picklist: `code`, `label`, `description?`, `status`. No rate, no union link, no dates. Unique per tenant on both `code` and `label` |
| `EmployeeUnionCode` | `schema.prisma` ~2290 | same shape; no `kind` |
| `Employee.craftCodeId` | `schema.prisma` ~3521 | nullable FK, `onDelete: SetNull`. **Stays** — the drop moved to a later cleanup ticket (REQ-23) |
| `Employee.unionCodeId` / `unionStatus` | ~3495 | FK plus a denormalised label copy |
| `Employee.hourlyRate` / `payRateOT` / `payRateDB` | ~3501, ~3515 | `Decimal(10,2)?`. **`hourlyRate` is the non-union base rate and is never retired** (REQ-10, REQ-19); the other two stay unread |
| `VendorEmployee` | ~2161 | separate model, no craft/union/rate — out of scope |
| `ActivityLogEntityType` | line 109 | 21 members, none of them craft-related |
| Tenant `$extends` allowlist | `apps/api/src/orm/prisma.service.ts` lines 89–151 | **`employeecraftcode` and `employeeunioncode` are not in it** |

### New and changed models

```prisma
// Shapes below follow the Identity Convention (CLAUDE.md) and the existing
// reference-code models. Field names come from SCRUM-925/927/934/935 and the
// 2026-08-24 planning decision; anything no source states is marked below and
// is NOT to be chosen by the executor.

model CraftCode {
  id              String @id @default(uuid()) @db.Uuid
  tenantCompanyId String @map("tenant_company_id") @db.Uuid
  code            String @db.VarChar(50)      // admin-typed, e.g. L12-G3-A — NOT minted
  label           String @db.VarChar(255)
  description     String? @db.Text
  status          String @default("ACTIVE") @db.VarChar(50)   // REQ-01
  unionCodeId     String @map("union_code_id") @db.Uuid       // REQ-03, required
  roleType        RoleType                                     // REQ-05, required — Q4
  startDate       DateTime @map("start_date") @db.Date        // REQ-06
  endDate         DateTime? @map("end_date") @db.Date         // REQ-06
  // audit columns + createdBy/lastModifiedBy as on EmployeeCraftCode
  @@unique([tenantCompanyId, code], name: "uq_craft_codes_tenant_code")
  @@index([tenantCompanyId], name: "idx_craft_codes_tenant_company_id")
  @@map("craft_codes")
}

model CraftCodeRate {
  id            String   @id @default(uuid()) @db.Uuid
  tenantCompanyId String @map("tenant_company_id") @db.Uuid
  craftCodeId   String   @map("craft_code_id") @db.Uuid
  baseRate      Decimal  @map("base_rate") @db.Decimal(10, 4)   // Q15
  effectiveFrom DateTime @map("effective_from") @db.Date
  effectiveTo   DateTime? @map("effective_to") @db.Date
  @@map("craft_code_rates")
}

model EmployeeCraftAssignment {
  id            String @id @default(uuid()) @db.Uuid
  tenantCompanyId String @map("tenant_company_id") @db.Uuid
  employeeId    String @map("employee_id") @db.Uuid
  craftCodeId   String @map("craft_code_id") @db.Uuid
  assignmentType // PRIMARY | SECONDARY — REQ-07/REQ-08
  // no effective dates — REQ-08, and see Q10
  @@map("employee_craft_assignments")
}

model CraftModifierScale {
  id            String @id @default(uuid()) @db.Uuid
  tenantCompanyId String @map("tenant_company_id") @db.Uuid
  unionCodeId   String @map("union_code_id") @db.Uuid
  initialFt     Int    @map("initial_ft")
  finalFt       Int    @map("final_ft")
  gapFt         Int    @map("gap_ft")
  operatorStepRate Decimal @map("operator_step_rate") @db.Decimal(10, 4)  // Q15
  oilerStepRate    Decimal @map("oiler_step_rate") @db.Decimal(10, 4)      // Q15
  codePrefixOperator String @map("code_prefix_operator") @db.VarChar(50)
  codePrefixOiler    String @map("code_prefix_oiler") @db.VarChar(50)
  labelSuffix        String @map("label_suffix") @db.VarChar(50)
  status        String @default("ACTIVE") @db.VarChar(50)
  // no tier rows — REQ-11. No effective dating — REQ-11.
  // NOTE: exactly two step rates, for two of RoleType's six values. A role
  // with no step rate yields NO MODIFIER at any boom length — REQ-14, Q12.
  // Gate on "has a step rate", never on a list of role names.
  @@map("craft_modifier_scales")
}

// REQ-05 — Q4 + Q14, 2026-08-24. Sourced from the planning answer alone; no
// vault document names these as craft attributes.
// Only OPERATOR and OILER have a step rate on CraftModifierScale — the other
// four earn no boom modifier at any length (REQ-14).
// THIRD_MAN and MECHANIC are admin-selectable for crafts created AFTER the
// migration; no prefix rule populates them, and that is intended (Q14).
enum RoleType {
  OPERATOR
  OILER
  THIRD_MAN
  LABORER
  ADMIN
  MECHANIC
}

// REQ-09 — answered by Q7, 2026-08-24. "reunion" was a typo for non-union;
// there is no third kind.
enum UnionKind {
  UNION
  NON_UNION
}

// EmployeeUnionCode gains — REQ-09:
//   kind        UnionKind (required)
//   localNumber String?      length NOT SPECIFIED
//   agreement   String?      length NOT SPECIFIED
```

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| `CraftCode` | `code` | none — admin-typed reference code | **not** `entity_sequences` | REQ-01, intent §7 |
| `CraftCodeRate` | none | — | — | REQ-02 |
| `EmployeeCraftAssignment` | none | — | — | REQ-07 |
| `CraftModifierScale` | none (`OP-BP-nn` is computed, never stored) | — | — | REQ-11, REQ-13 |

- **New prefix introduced:** no. Craft codes are admin-typed reference codes on the pattern of the
  existing union and work-comp codes, not sequence-minted business codes.
- **Child relations:** all FKs reference the parent UUID `id`, never the business code
  (`CLAUDE.md` → *Identity Convention*).
- **Fields whose type/precision no source states:**
  - **Money precision — answered (Q15): `Decimal(10,4)`** on `CraftCodeRate.baseRate`,
    `CraftModifierScale.operatorStepRate` and `oilerStepRate`. The legacy feed carries **three**
    decimals (`66.180`, `0.750`, `13.500`) and four is a superset of it, so nothing truncates on
    the way in. Note this **diverges deliberately from the `Decimal(10,2)` house convention** used
    by `Employee.hourlyRate`/`payRateOT`/`payRateDB` — these are *rates that get multiplied*, not
    paid amounts, so precision lost here is amplified by every hour and every tier. **Rounding to
    cents happens once, downstream**, in the pay-component ledger under
    `payroll/rules/PAY-069-money-rounding-and-rounding-adjustment-components.md` (`status: open`,
    *"in no kept catalog"*) — **never in these tables and never in the resolver.**
  - `roleType` value set — **answered** (Q4 + Q14):
    `OPERATOR | OILER | THIRD_MAN | LABORER | ADMIN | MECHANIC`, REQ-05. The
    *enum's own name* and whether it is a Prisma enum or a `VarChar` are `NOT SPECIFIED`; the
    existing reference-code models use `String @db.VarChar(50)` for `status`, so either is
    defensible. What is **not** defensible is adding a **seventh** value — the set is closed at
    six (Q14), and an administrator picking a role for each craft by hand is now the only way one
    gets set (REQ-05).
  - `code`, `label`, `localNumber`, `agreement` max lengths — `NOT SPECIFIED`; the existing
    reference-code models use `VarChar(50)` / `VarChar(255)`, which is a convention, not a rule.
  - Whether "inactive" is a `status` value or `archivedAt` — `NOT SPECIFIED`;
    `decisions/2026-08-20-archive-instead-of-delete-app-wide.md` is app-wide but the existing
    reference-code modules use `status`.
- **Tenancy, and a finding:** the tenant `$extends` allowlist in
  `apps/api/src/orm/prisma.service.ts` (lines 89–151) **does not contain `employeecraftcode` or
  `employeeunioncode`** — those modules scope by hand, e.g.
  `where: { tenantCompanyId, status: 'ACTIVE' }` in the existing controller. All four new models
  hold tenant data. Per `.ai/claude/contexts/prisma.md` → *Tenant scoping is conditional*, a model
  holding tenant data that is absent from the allowlist **is a finding, not a detail**. Add them,
  or scope explicitly on every query and say so. Run `tcg-prisma-guardian` on the schema change.

## 4. API surface — `apps/api`

Layering is `presentation → usecase → service → orm`, never upward.

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/api/v1/craft-codes` | `craft-codes.controller.ts` | `craft-codes.service.ts` | `craft-codes.repository.ts` | REQ-01 |
| `GET` | `/api/v1/craft-codes/admin` | same | same | same | REQ-01 |
| `POST` | `/api/v1/craft-codes` | same | same | same | REQ-01, 03, 04, 06 |
| `PATCH` | `/api/v1/craft-codes/:id` | same | same | same | REQ-01 |
| `DELETE` | `/api/v1/craft-codes/:id` | same | same | same | REQ-01 |
| `GET`/`POST`/`PATCH` | `/api/v1/craft-codes/:id/rates` | same | same | same | REQ-02 |
| `GET`/`POST`/`PATCH` | `/api/v1/craft-modifier-scales` | `craft-modifier-scales.controller.ts` | `craft-modifier-scales.service.ts` | `craft-modifier-scales.repository.ts` | REQ-11 |
| `GET` | `/api/v1/craft-modifier-scales/:id/preview` | same | same | — | REQ-16 |
| `GET`/`POST`/`DELETE` | `/api/v1/employees/:id/craft-assignments` | `employee-craft-assignments.controller.ts` | `employee-craft-assignments.service.ts` | same | REQ-07, REQ-08 |
| `GET` | `/api/v1/employees/without-primary-craft` *(route name `NOT SPECIFIED`)* | same | same | same | REQ-07 — the admin report of employees with no PRIMARY |
| — | *(none — service only)* | — | `CraftRateResolverService` | — | REQ-17 |

Per endpoint:

- **Request DTOs:** `create-craft-code.dto.ts`, `update-craft-code.dto.ts`,
  `create-craft-code-rate.dto.ts`, `create-craft-modifier-scale.dto.ts`,
  `create-craft-assignment.dto.ts`, with `class-validator` rules per §9.
- **Response shape:** `NOT SPECIFIED` beyond the field lists in §3. The existing
  `employee-craft-codes` controller returns `{ id, code, label, description }` for the pick-list
  call; keep that shape for the aliased route (REQ-25).
- **Guards / roles:** `AccessTokenGuard` is global. **Answered by Q9** — REQ-28. CRUD on craft
  codes, rates and scales uses the existing admin gate,
  `@Roles(Role.ADMIN, Role.SUPER_ADMIN)`, identical to the three existing reference-code modules.
  The **assignment** endpoints are specified for admin, payroll and the crane superintendent, with
  dispatch limited to a temp's PRIMARY — but the `Role` enum has no such values, so they gate on
  the same admin pair. See REQ-28's NOTE: this over-grants and under-grants, knowingly.
- **Route param identity:** the existing reference-code modules take a **UUID** `:id`, not the
  business code, which diverges from `CLAUDE.md` → *Identity Convention* ("routes and DTOs use the
  code for UX"). No source resolves the divergence for this module; follow the existing
  reference-code pattern for consistency and flag it, rather than changing convention inside a
  payroll ticket.
- **Errors:** status and message per failure case — `NOT SPECIFIED`. The resolver's three failure
  cases return Blocked results rather than errors (REQ-18); their **severities** are `NOT
  SPECIFIED` (`PAY-060`'s blocking item).
- **Module registration:** each new module registered in `app.module.ts`; barrel `index.ts` at
  every layer boundary (`.ai/claude/contexts/api.md`).

## 5. Web surface — `apps/web`

`N/A — backend only.` `SCRUM-934` and `SCRUM-935` both say *"Backend only"*; intent §5 excludes
all web and mobile feature work.

- **Routes:** `N/A`
- **Existing components to reuse:** `N/A`
- **New components proposed:** none.
- **Table / Forms / Server state / Colors / Responsive / Copy:** `N/A`
- **One obligation only:** web must keep compiling. It reads the `EmployeeCraftCode` select shape,
  `Employee.craftCodeId` and `unionStatus` today (intent §6). See REQ-25 and run
  `tcg-contract-tracer` before the DTO moves — only files importing `@tcg/shared` are
  compile-checked.

## 6. Mobile surface — `apps/mobile`

`N/A — backend only.`

- **Screens / routes:** `N/A`
- **Components:** `N/A`
- **Offline / sync behavior:** `N/A` — nothing in this epic is captured on a device.
- **Touch targets:** `N/A`
- **Push / notifications involvement:** `N/A`
- **Obligation:** as web — must keep compiling against the renamed contract.

## 7. Shared package — `packages/shared`

- **Types added / changed:** the craft-code and employee DTO shapes move with REQ-25 — consumed by
  web and mobile both, as the built `dist/`.
- **Exact type list:** `NOT SPECIFIED` — depends on what `tcg-contract-tracer` finds is actually
  imported.

## 8. Permissions and tenancy

- **Roles permitted:** **answered by Q9** — REQ-28. CRUD behind the existing admin gate;
  assignment by admin, payroll and the crane superintendent; dispatch for a `TEMPORARY` employee's
  PRIMARY only. **Implementable only in part:** the `Role` enum is `USER | ADMIN | SUPER_ADMIN`
  (`apps/api/prisma/schema.prisma` lines 18–22) and has no payroll, superintendent or dispatch
  value, so everything gates on `@Roles(Role.ADMIN, Role.SUPER_ADMIN)`. Recorded as a NOTE on
  REQ-28, not silently absorbed.
- **Roles denied:** the employee themselves —
  `decisions/2026-08-20-craft-locked-rate-override.md` §3, `[VERIFIED]`: *"never the employee"*.
  This one is settled and must be enforced whatever Q9 returns.
- **Tenant isolation:** **not automatic here.** All four new models must be added to the
  `$extends` allowlist in `apps/api/src/orm/prisma.service.ts`, or scoped explicitly on every
  query — the two models this epic replaces are absent from it today. See §3.
- **Cross-tenant reads:** none.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| `CraftCode.code` | required; unique per tenant | `SCRUM-925`; `CLAUDE.md` Identity Convention | `[UNVERIFIED]` |
| `CraftCode.code` | max length | `NOT SPECIFIED` — no source states one | — |
| `CraftCode.label` | required | `SCRUM-925` ("identifier and name") | `[UNVERIFIED]` |
| `CraftCode.unionCodeId` | required | `SCRUM-925`, `SCRUM-934` | `[UNVERIFIED]` |
| `CraftCode.roleType` | required; `OPERATOR \| OILER \| THIRD_MAN \| LABORER \| ADMIN \| MECHANIC` | planning answers `2026-08-24` (Q4, Q14), REQ-05 | `[UNVERIFIED]` |
| `CraftCode.startDate` | required | `SCRUM-935` (window check) | `[UNVERIFIED]` |
| `CraftCodeRate` | exactly one row in force per craft per date; no overlapping windows | `SCRUM-925`, `payroll/rules/PAY-008-…` | `[UNVERIFIED]` |
| `CraftCodeRate.baseRate` | `Decimal(10,4)`; must be > 0 | planning answers `2026-08-24` (Q15) | `[UNVERIFIED]` |
| `CraftModifierScale.operatorStepRate` / `oilerStepRate` | `Decimal(10,4)` | planning answers `2026-08-24` (Q15) | `[UNVERIFIED]` |
| `EmployeeCraftAssignment` | exactly one PRIMARY per employee | intent §4 (plan) | `[UNVERIFIED]` |
| `EmployeeCraftAssignment` | required on employee create | intent §4 (plan) | `[UNVERIFIED]` |
| `EmployeeUnionCode.kind` | required; exactly two values (`UNION` / `NON_UNION`) — no third | planning answers `2026-08-24` (Q7) | `[UNVERIFIED]` |
| `EmployeeUnionCode.localNumber` / `agreement` | max length | `NOT SPECIFIED` | — |
| `CraftModifierScale` | at most one ACTIVE per union code | `SCRUM-934` | `[UNVERIFIED]` |
| `CraftModifierScale.gapFt` | must be > 0 (division) | derived from the formula, `SCRUM-934` | `[UNVERIFIED]` |
| `CraftModifierScale.finalFt` | must be > `initialFt`; whether it must be `initialFt + n×gapFt` | `NOT SPECIFIED` | — |
| boom length | at exactly `initialFt` → tier 1 | planning answers `2026-08-24` (Q11), REQ-14 | `[UNVERIFIED]` |
| boom length | at an exact multiple of `gapFt` (100 → tier 1, 120 → tier 2) | planning answers `2026-08-24` (Q12), REQ-12 | `[UNVERIFIED]` |
| `CraftCode.roleType` | a role with no step rate on the scale → no modifier, never Blocked | planning answers `2026-08-24` (Q12), REQ-14 | `[UNVERIFIED]` |
| boom length | unit (feet), lower bound, behaviour above `finalFt` | `NOT SPECIFIED` — REQ-12 and REQ-15 notes | — |
| `EmployeeCraftAssignment` | a SECONDARY row alone changes no rate | planning answers `2026-08-24` (Q10) | `[UNVERIFIED]` |

Invented validation is still invention. Every `NOT SPECIFIED` above stays that way until someone
writes it down.

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit | Rate window boundaries: day before `effectiveFrom`, day of, day of `effectiveTo`, day after | REQ-02, REQ-17 |
| Unit | Craft window: work date outside `startDate`/`endDate` → Blocked | REQ-06, REQ-18 |
| Unit | Secondary craft passed in overrides the primary | REQ-08, REQ-17 |
| Unit | Boom below `initialFt` (79 ft) → no modifier | REQ-12 |
| Unit | Boom at exactly `initialFt` (80 ft) → **tier 1**, $0.75 operator / $0.25 oiler | REQ-14 |
| Unit | "Part thereof" rounding: 195 ft → tier 6, $4.50 operator / $1.50 oiler | REQ-12 |
| Unit | Boom at an exact multiple of `gapFt`: 100 ft → tier 1, 101 ft → tier 2, 120 ft → tier 2, 200 ft → tier 6 | REQ-12, REQ-13 |
| Unit | A craft whose `roleType` has no step rate returns **no modifier** at 80 ft and at 195 ft — not Blocked, not the operator rate | REQ-14 |
| Unit | A SECONDARY assignment alone changes no rate — resolver with no `secondaryCraftId` returns the PRIMARY rate | REQ-08 |
| Unit | Missing rate in force → Blocked, not thrown | REQ-18 |
| Unit | Missing active scale with a boom length present → Blocked | REQ-18 |
| Unit | Inactive craft → Blocked | REQ-01, REQ-18 |
| Unit | A **union** employee whose `hourlyRate` differs from their craft rate resolves to the **craft rate** | REQ-19 |
| Unit | A **non-union** employee resolves to their own `Employee.hourlyRate`; two on the same craft with different rates resolve differently | REQ-10, REQ-19 |
| Unit | A non-union craft with **no** `CraftCodeRate` rows resolves successfully rather than returning Blocked | REQ-02, REQ-10 |
| Unit | `payRateOT` and `payRateDB` are referenced on no resolver path | REQ-19 |
| Unit | The L12 **fixture** (not a seed — Q5) reproduces all 33 legacy codes, adders **and label strings** | REQ-12, REQ-13, REQ-15 |
| Unit | Preview and resolver agree tier-for-tier | REQ-16 |
| Integration (API) | Craft code CRUD, rate CRUD, scale CRUD, assignment CRUD under tenant scope | REQ-01, 02, 07, 11 |
| Integration (API) | Second ACTIVE scale for one union code is rejected | REQ-11 |
| Integration (API) | Employee create **or update** without a primary craft is rejected | REQ-07, REQ-27 |
| Integration (API) | An **existing** employee with no PRIMARY still loads, saves and lists, and appears in the report endpoint | REQ-07 |
| Integration (API) | The union filter uses the PRIMARY craft's kind where present and the legacy `unionStatus` string where not | REQ-24 |
| Integration (API) | Old and new routes both resolve | REQ-25 |
| Migration | The migration **adds structure only** — afterwards `employee_craft_codes`, `Employee.craftCodeId`, `unionCodeId` and `unionStatus` are present and unchanged, and the four new tables are empty | REQ-23 |
| Migration | The migration is reversible without data loss | REQ-23 |
| Migration | `kind` derivation: `Non-Union`, `non union`, `NONUNION` → `NON_UNION`; `L12 — Local 12` and any unrecognised label → `UNION` | REQ-09, REQ-23 |
| Unit | A rate of `66.1800` and a step rate of `0.7500` round-trip without loss at `Decimal(10,4)` | REQ-02, REQ-11 |
| Integration (API) | On a freshly migrated database the resolver returns Blocked for every **union** call, until rates are entered | REQ-18, REQ-22 |
| E2E / manual | `pnpm build` passes for web and mobile with no source change | REQ-25 |

- Requirements with no testable acceptance criterion: **none remain fully untestable.** REQ-15,
  REQ-21 and REQ-22 are `[N/A]` — out of scope, nothing to test. REQ-28's CRUD half is testable and
  its **assignment half is not**, because the role values do not exist (its NOTE). REQ-12 and
  REQ-13 are now fully testable — Q12 closed the boundary. REQ-10 and
  REQ-08 are now both testable — Q1 and Q10 gave them acceptance criteria — though REQ-10 is tested
  against a working decision the client has not confirmed, which is what its `[CONFLICT]` records.

## 11. Non-functional

- **Performance:** `NOT SPECIFIED`. Note only that the resolver is called once per labor entry by
  the later payroll engine, so the rate and scale lookups are hot; the legacy view materialised
  86,728 labor rows in one pass.
- **Concurrency:** no code minting here — craft codes are admin-typed, not drawn from
  `entity_sequences`, so the concurrent-create hazard does not apply. Two concurrent writes that
  would each leave an employee with a PRIMARY assignment must not produce two (REQ-07); enforce it
  with a partial unique constraint rather than a read-then-write.
- **Audit / activity log:** REQ-26 — requires new `ActivityLogEntityType` members.
- **Migration/rollout order:** **schema-only migration** (add tables, columns, enums — REQ-23) →
  API (new modules, resolver) → **administrators create craft codes, rates, the modifier scale and
  assignments** through the API → alias removal and the column drops in a **later cleanup ticket**,
  which runs once REQ-07's report endpoint shows no employee lacking a PRIMARY. Nothing in this
  epic drops or copies anything, so the ordering hazard the pre-revision plan carried has moved to
  that cleanup ticket — where its precondition is at least observable.
- **Launch state, and it is deliberate — but it is far emptier than it was.** With both seeding
  (Q5) and every data migration (Q14) out of scope, the system ships with **all four new tables
  empty**: no craft codes, no rates, no scale, no assignments. Every union
  `CraftRateResolverService` call returns Blocked (REQ-18); every employee appears in REQ-07's
  no-PRIMARY report; REQ-24's filter runs entirely on its legacy fallback. All intended, all
  visible. **The risk is not technical, and it grew with the scope change:** the data-entry step
  that makes this epic useful has no ticket, no owner and no estimate anywhere in `SCRUM-926`, and
  it is now the whole FCC craft catalogue plus one PRIMARY assignment per employee, entered by hand
  through the API. Confirm that ticket exists before U1 starts, not after U4 merges. REQ-21 keeps
  the MLA 7/1/2025 figures visible for whoever does it.

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** 

**Revised `2026-08-25`.** Thirteen questions were answered on `2026-08-24` by Syed Haris and carry
an **Answer** line; one (Q5) is **withdrawn**; three (Q12, Q13, Q14) were raised by those answers
and by re-reading the vault against them; **three more (Q15–Q17) were raised by the decomposer**
and answered in the same session. Answered entries are kept, not deleted — the answer and the
search behind it are the record of why a requirement says what it says.

**Still open: Q13 only**, and it does not block this epic — it is deferred to the payroll-engine
ticket under `SCRUM-920`, where `PAY-015`'s higher-rate-for-day true-up belongs. Everything else is
resolved or withdrawn. **That is not the same as everything being settled**: REQ-01, REQ-02, REQ-07
and REQ-20 still carry `[CONFLICT]`, three of the resolutions are *working* decisions or readings
that the people who own the underlying sources have not confirmed (Q1's non-union model was
confirmed by matching `PAY-012`; Q3's on-top rule and Q18's union-scope reading were not), and no
decision note exists in `.ai/vault/decisions/` for any of it. See §14. Q1 does not block the build but blocks calling the non-union rate model correct. Q13
is deferred to `SCRUM-920`. Q2, Q3 and Q6 belong to TCG.

**This section is the ticket's gaps register — there is no separate `gaps.md` in a ticket
folder.** `.ai/vault/payroll/gaps.md` is cited by anchor below and **has not been appended to**.

```bash
grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/SCRUM-*/spec.md
```

### Q1 — Non-union base rate: one rate per craft, or one per person?

- **Question:** For non-union employees (`ADMIN-*`, `HDR-*`, `YARD-*` crafts), is the base rate a
  single rate held on the craft code — or a rate held per person, as it is today?
- **Why it cannot be answered from what is written:** `SCRUM-925` says *"The employee's assigned
  craft code determines their base payroll rate"* without qualifying by group, and the 2026-08-24
  planning decision makes craft the only base-rate source for everyone. `payroll/rules/PAY-012-…`
  says the opposite for non-union — *"Use employee-master hourly rate; do not use union craft
  rate"* — with a written client confirmation from Brian Petros (2026-06-09, *"very important"*),
  and the legacy engine agrees: 21,348 labor rows priced from `Employee.PayRate` against 59,655
  from the union craft table. Neither side is verified and nothing adjudicates between them.
- **Blocked:** REQ-10, REQ-19 (non-union half), REQ-07's "every employee", and the completeness of
  the REQ-21 seed. Nothing non-union can be priced until this lands.
- **Candidates:** `payroll/rules/PAY-012-non-union-hourly-rate.md` (2.0 KB, `2026-08-24`, status
  `open`); `sync/.conflict/2026-08-24-bootstrap/craft-codes.md` (3.5 KB, page edited
  `2026-08-20`, CONFLICT tier); `payroll/legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md`
  (6.5 KB, `2026-08-18`) → *Distinct PayrollBaseRateSource*;
  `payroll/gaps.md#non-union-pay-rates-have-no-upstream-source-adp-will-not-return-them`.
- **Owner:** Brian Petros (wrote the 2026-06-09 statement); Corrina Bustos for current practice.
- **Workaround, if any:** none needed — the build proceeds under the working decision below.
- **Answer (`2026-08-24`, Syed Haris — CodingCops, acting product owner):** **One rate per craft, non-union included.** Everyone on
  `ADMIN-A` earns `ADMIN-A`'s rate; the payroll administrator creates as many non-union craft codes
  as there are distinct rates. `Employee.hourlyRate` is never read. REQ-10 proceeds on this basis
  and is **not** marked `[OPEN]`.
- **Why this stays open anyway:** the answer is a CodingCops working decision. The other side is a
  vault rule with a **written client confirmation behind it** — Brian Petros, 2026-06-09, marked
  *"very important"* — and he has not been asked to reverse it. `payroll/codingcops-rule-matrix.md`
  §B `PR-014` independently assumes the employee rate is still a live rate source. Until Brian
  Petros confirms, this is what is being built, not what is agreed.
- **What would settle it, and one number to bring:** count the **distinct non-union
  `Employee.PayRate` values** in the current data. Under the working decision each becomes its own
  craft code. If that is six, the decision is easy; if it is six hundred, Brian Petros should see
  the number before he confirms. The legacy engine priced 21,348 labor rows this way.
- **Answer (`2026-08-25`, Syed Haris — CodingCops, acting product owner, via coordinator):** **RESOLVED — the non-union base rate is PER PERSON on the
  employee, as in FCC.** The resolver branches on the primary craft's union kind: `UNION` → the
  `CraftCodeRate` in force on the work date; `NON_UNION` → `Employee.hourlyRate`, its current value,
  **with no effective dating in this epic**. Non-union crafts carry **no** `CraftCodeRate` rows and
  validation must not require any. `Employee.hourlyRate` is therefore **not retired**;
  `payRateOT` / `payRateDB` remain derived and unread. **The 2026-08-24 "one rate per craft,
  non-union included" working decision is withdrawn.**
- **How this closed:** the plan yielded to the vault. `payroll/rules/PAY-012-…`, Brian Petros's
  written 2026-06-09 statement, the legacy engine's 21,348 `Employee.PayRate` rows and this
  decision now all say the same thing, so **REQ-10's `[CONFLICT]` dissolves** and it is re-flagged
  `[UNVERIFIED]`. This is the one place in the revision where a `[CONFLICT]` was cleared by
  agreement rather than by adjudication — which is the outcome the flag existed to make possible.
- **What is still not settled, and is now inside the build rather than beside it:** reading
  `Employee.hourlyRate` as it *currently stands* means recalculating a past period returns
  **today's** non-union rate. That contradicts `payroll/rules/PAY-008-…` (*"Historical
  recalculation must use rules effective on the work date"*) and is precisely `PAY-012`'s own open
  blocking item, *"Confirm rate-effective-date handling"*. Scoped out of this epic deliberately;
  it lands on `PAY-068` retroactive correction. Recorded in REQ-10's notes and §13.
- **Status:** resolved `2026-08-25` — REQ-02, REQ-10, REQ-17, REQ-19, REQ-23.

### Q2 — Boom modifier source: selected on the labor entry, or derived from the unit?

- **Question:** Is the boom modifier chosen by a person on the labor entry (as in FCC today), or
  derived automatically from the dispatched unit's boom length?
- **Why it cannot be answered from what is written:** `payroll/rules/PAY-011-…` is `status: open`
  with blocking item *"Confirm modifier source and windows"*. Its written client statement (Brian
  Petros, 2026-06-09) says the modifier rate applies *"only when a Craft Modifier Code is selected
  on the labor entry"* — selection-driven. The 2026-08-24 plan and the design mock derive it from
  the unit; intent §5 pushes boom length on the labor entry to a later ticket, and intent §10
  records that where boom length is measured is `NOT ON TICKET`.
- **Blocked:** the later payroll labor-entry ticket under `SCRUM-920`. **Not this epic** —
  `resolveBoomAdder(craftCodeId, boomLengthFt, workDate)` takes a length either way (REQ-17).
- **Candidates:** `payroll/rules/PAY-011-l12-modifier-boom-rate.md` (3.4 KB, `2026-08-24`);
  `payroll/legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md` (6.5 KB) →
  *Distinct BoomDisplayStatus*, which shows 15,373 rows at *"Ticket boom window only - no
  modifier"* and 2,183 at *"Modifier present, no boom hours"* — i.e. the two sources already
  disagree row-by-row in production.
- **Owner:** Brian Petros / Corrina Bustos (TCG payroll).
- **Workaround, if any:** none needed — the resolver interface was source-agnostic either way.
- **Answer (`2026-08-25`, Syed Haris — CodingCops, acting product owner, via coordinator):** **selected on the ticket / labor entry**, at the point the
  ticket is **closed after the customer's final signature**. It is **never derived from the unit.**
  That is consistent with `resolveBoomAdder` taking `boomLengthFt` from the entry (REQ-17), and it
  sides with FCC's existing behaviour and Brian Petros's 2026-06-09 statement rather than with the
  design mock.
- **Note:** the capture itself — boom length on the labor entry, and pricing at final signature —
  is **out of scope here** (intent §5) and belongs to the labor-entry ticket under `SCRUM-920`.
  What this epic needed was only the confirmation that the resolver is handed a length, and it is.
- **Status:** resolved `2026-08-25` — REQ-17.

### Q3 — Boom adder: into the base rate before multipliers, or on top?

- **Question:** Does the boom adder become part of the base rate before OT/DT multipliers are
  applied, or is it paid on top of the multiplied rate?
- **Why it cannot be answered from what is written:** the MLA says *"The additional rate added to
  the regular rate shall be the base rate when computing overtime pay"* (into the rate);
  the 2026-08-20 payroll-rules meeting notes say *"Boom-time premiums are unaffected — they add
  **on top** of whichever rate applies"*. `payroll/rules/PAY-011-…` reads the contract as
  into-the-rate across the board with two carve-outs, and states plainly **"Decision note
  pending"** — it is a working reading, not an adjudication.
- **Blocked:** the payroll calculation engine, not this epic. REQ-20 keeps the two values
  separate precisely so this stays answerable later.
- **Candidates:** `payroll/mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md`
  (9.6 KB, `updated: 2026-06-23`); `payroll/rules/PAY-011-l12-modifier-boom-rate.md` (3.4 KB,
  `2026-08-24`); `payroll/2026-08-20-payroll-rules-meeting-notes.md` (8.5 KB, `2026-08-20`,
  `status: unverified`, cleaned from a transcript); `payroll/source-attribution-and-conflicts.md`
  → *Into the rate vs on top*.
- **Owner:** TCG payroll (Corrina Bustos / Brian Petros); `PAY-011` notes this needs the
  composition stated **per pay component**, not once.
- **Workaround, if any:** return the two values separately and compose nothing — that is REQ-20,
  and it is a design choice that stays correct either way, not a workaround.
- **Answer (`2026-08-25`, Syed Haris — CodingCops, acting product owner, via coordinator):** **ON TOP.** The boom adder is a **flat $/h × boom hours**;
  it is **not** multiplied by OT / DT / holiday multipliers and **not** folded into the base rate
  for overtime.
- **Why REQ-20 keeps its `[CONFLICT]` anyway:** this decision sides with
  `payroll/2026-08-20-payroll-rules-meeting-notes.md` (*"add on top of whichever rate applies"*)
  **against the MLA's Article IV** (*"The additional rate added to the regular rate shall be the
  base rate when computing overtime pay"*). A planning decision does not amend a collective
  bargaining agreement, and getting this wrong underpays overtime on every long-boom hour. **TCG
  payroll / labor counsel must confirm.** It remains a **working decision**, and because this epic
  composes nothing, the confirmation obligation travels with the flag to the payroll-engine ticket
  under `SCRUM-920` rather than blocking anything here.
- **Two implications for that ticket:** *on top, unmultiplied* means the adder needs **boom hours**
  as its own quantity rather than a rate adjustment — a different shape from every premium that
  rides the base rate. And the **ADP export** is affected: the decision cites the `LB` OT / DBL /
  TRI columns. Treat that as the decision's own claim — `payroll/rules/PAY-067-adp-export.md` is
  `status: conflicted`, **no `LB` earning code appears anywhere in the vault**, and the closest
  written analogue is the REG/OT/DT/TRI shape recorded for the Foreman (`FRT`) and Military (`MLT`)
  premiums in `payroll/foreman-and-military-premiums.md`, which raise the same
  multiplied-or-not question.
- **Status:** resolved `2026-08-25` as a working decision — REQ-20 keeps `[CONFLICT]`; confirmation
  and composition both belong to `SCRUM-920`.

### Q4 — Who supplies the craft-code → role-type mapping, and what are the role-type values?

- **Question:** Who authors the mapping from the ~45 FCC craft codes to a role type, and what is
  the complete value set — is it just Operator and Oiler, or does it need values for `ADMIN-*`,
  `HDR-*`, `YARD-*`, `L12-BG-*` and `HOLIDAY`?
- **Why it cannot be answered from what is written:** no source lists role-type values. The MLA
  names Operator, Oiler, Shop Foreman and Heavy Duty Repairman/Welder as **classifications**, not
  as a craft attribute, and does not map them to FCC codes. `payroll/rules/PAY-009-…` gives
  `EmpTypeID` 1/2/3 = Operator/Oiler/Mechanic — an **employee** attribute in FCC, not a craft one.
  The legacy craft list carries 45 distinct codes with no role column. Intent §11 records the enum
  values as *"plan decision 2026-08-24 — NOT ON TICKET — no origin cited"*.
- **Blocked:** REQ-05 and, through it, REQ-23 — the migration cannot populate a required column.
  There is no partial workaround that ships the copy.
- **Candidates:** `payroll/legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md`
  (6.5 KB, `2026-08-18`) → *Distinct CraftCode*; `payroll/rules/PAY-009-payroll-group-classification.md`
  (1.7 KB, `2026-08-24`); `payroll/mcog-l12-mla-2025-2028/02-…` (9.6 KB);
  `payroll/legacy-payroll-app-db-extract/data/source-feed.md` → `src.FMS_CRAFTS_Raw`, which has
  `PayType`, `AcctPayType`, `UnionYN` and `EarningsType` columns but **no role column**.
- **Owner:** Corrina Bustos (maintains the FCC craft table); Brian Petros.
- **Workaround, if any:** no longer needed.
- **Answer (`2026-08-24`, Syed Haris — CodingCops, acting product owner):** answered as a **migration rule**, not a mapping table. The FCC
  copy collapses `-A`/`-B`/`-C` into **one `CraftCode` per base code**; `roleType` is mapped by
  prefix — `L12-G*` / `L12-APP*` → `OPERATOR` unless the FCC label says Oiler → `OILER`;
  `ADMIN*` → `ADMIN`; `HDR*` / `YARD*` → `LABORER`; **`HOLIDAY`, `SUB` and anything else unmapped
  → the migration aborts with a report listing them.** The enum is therefore
  `OPERATOR | OILER | ADMIN | LABORER` — **extended to six by Q14** (`THIRD_MAN`, `MECHANIC`, both
  admin-selectable post-migration); the prefix rules above are unchanged. See REQ-05 and REQ-23.
- **Two things the answer leaves for the executor, both safe by design:** `L12-BG-*` matches none
  of the prefix rules and so lands in the abort report — somebody must map it before the migration
  runs. And `ADMIN` / `LABORER` have no step rate on the modifier scale (REQ-04's notes, §13).
- **Status:** resolved `2026-08-24` — REQ-05, REQ-23. No decision note recorded; `tcg-scrum` owns
  that write path if this needs to become durable beyond the ticket.

### Q5 — Which fiscal-year rate rows does the L12 seed carry?

- **Question:** Are the FY2026-27 figures recovered from TCG's own workbook (G1–G9 = 67.03 …
  72.16; APP1–6 = 41.50 / 44.95 / 48.41 / 51.87 / 55.33 / 62.24) authoritative to seed, or must
  TCG supply the official Local 12 rate sheet first?
- **Why it cannot be answered from what is written:** **two register files updated on the same day
  say opposite things.** `payroll/rules/PAY-010-…` (`status: settled`): *"FY2026-27 rates are not
  derivable from the vault … Get the new rate sheet."* `payroll/rules/PAY-008-…`: *"FY2026-27
  rates recovered from TCG's own workbook … Two-year effective-dated rate history now complete in
  the record."* `payroll/rules/PAY-016-…` agrees with PAY-008 for apprentices. The MLA's 7/1/2026
  column is blank — only the `* $5.00` increase total and the Union's allocation-option footnote.
  Nothing adjudicates. This spec did not pick a side.
- **Blocked:** REQ-22, and in practice the whole feature for any current work date: with only the
  FY2025-26 seed, every resolver call after 2026-06-30 returns Blocked.
- **Candidates:** `payroll/rules/PAY-010-l12-union-base-rate.md` (2.9 KB, `2026-08-24`, status
  `settled`); `payroll/rules/PAY-008-effective-dated-configuration.md` (2.4 KB, `2026-08-24`,
  status `open`); `payroll/rules/PAY-016-apprentice-wage-step.md` (1.3 KB, `2026-08-24`);
  `payroll/mcog-l12-mla-2025-2028/02-…` (9.6 KB) — 7/1/2026 column empty.
- **Owner:** Brian Petros / Corrina Bustos for the official sheet; whoever ran the 2026-08-24
  verification for which of PAY-008 and PAY-010 is current.
- **Workaround, if any:** n/a — the question left the epic.
- **Answer (`2026-08-24`, Syed Haris — CodingCops, acting product owner):** **withdrawn — seeding is out of scope.** No L12 rate seed and
  no scale seed in this epic; administrators enter rates and the scale through the API. REQ-15,
  REQ-21 and REQ-22 become `[N/A — OUT OF SCOPE]`.
- **The consequence, which is intended:** with no rate rows and no scale, the resolver returns
  Blocked (REQ-18) for every call until administrators enter data. The system ships **rate-empty**.
  That will look like a broken migration to anyone testing it, so it belongs in the release
  runbook — see §11, *Launch state*.
- **What did not go away:** *which* FY2026-27 figures are authoritative is still unanswered, and
  the vault still contradicts itself about it (`PAY-010` says get the official sheet; `PAY-008` and
  `PAY-016` say the workbook figures are recovered). That is now a **data-entry** question with no
  owner in this epic. It belongs in the payroll module's own register, which `tcg-scrum` writes —
  not here, and not in the retired root `gaps.md`. REQ-22 keeps the search record findable.
- **Status:** withdrawn `2026-08-24` — out of scope. Row kept so the numbering stays stable.

### Q6 — May a temporary employee file labor before ADP onboarding completes?

- **Question:** Does step 5 of the 2026-06-30 ADP decision (the ERP blocks scheduling, equipment
  assignment and job allocation until ADP reports onboarding complete) apply to fill-in field
  employees, or may they be dispatched and file labor from a basic ERP record?
- **Why it cannot be answered from what is written:**
  `decisions/2026-06-30-adp-erp-employee-data-ownership.md` step 5 is `status: verified` and says
  blocked. Recording 2026-07-09, Brian Petros at 34:43 — nine days **after** he agreed to that
  decision — asks for the opposite for fill-ins, and Corrina Bustos confirms the current practice
  at 35:10. `SCRUM-254` and `SCRUM-304` are both **Done** and already implement the unblocked
  behaviour. The recording post-dates the decision, so it reads as an amendment request from the
  same person; recency cannot settle it in either direction.
- **Blocked:** REQ-27 in part — the craft requirement itself is unaffected, but what a temp may
  then *do* is not. `SCRUM-254` / `SCRUM-304` may need reopening.
- **Candidates:** `payroll/gaps.md#fill-in-field-employees-vs-the-adp-onboarding-dispatch-block`
  (the full search record, already written — cited, not restated);
  `decisions/2026-06-30-adp-erp-employee-data-ownership.md`;
  `dispatch/daily-allocation-system.md` §*Temporary Employee management in DAS*.
- **Owner:** Brian Petros (raised it and co-owns the 06-30 decision); Corrina Bustos for the
  until-Sunday practice. *(Owners as named in the vault entry.)*
- **Workaround, if any:** none needed.
- **Answer (`2026-08-25`, Syed Haris — CodingCops, acting product owner, via coordinator):** **no ADP gating of any kind** in this epic. Craft
  assignment and temporary-employee creation **do not check ADP onboarding status**; ADP
  integration is deferred entirely.
- **What this does and does not settle:** it settles this epic — nothing built here consults ADP —
  and it matches what already shipped in `SCRUM-254` / `SCRUM-304`. It does **not** amend
  `decisions/2026-06-30-adp-erp-employee-data-ownership.md` step 5 (`[VERIFIED]`), which blocks
  *scheduling, equipment assignment and job allocation* until ADP reports onboarding complete.
  None of those surfaces is in this epic, so the two do not collide here — but the underlying
  disagreement between that decision and Brian Petros's 2026-07-09 request is **still unresolved**,
  and whoever next touches those surfaces inherits it.
- **Status:** resolved `2026-08-25` for this epic — REQ-27. The 06-30 decision stands for
  scheduling, equipment and allocation.

### Q7 — Did "reunion" mean a third union-kind value?

- **Question:** In the 2026-08-24 planning request for a union `kind`, did "reunion" mean a third
  value beside `UNION` and `NON_UNION`, or was it a transcription of "re: union"?
- **Why it cannot be answered from what is written:** no source names any union kind at all.
  `payroll/rules/PAY-009-…` gives five payroll groups across two union states;
  `payroll/gaps.md#union-codes-one-value-so-the-crud-question-mostly-dissolves` says ADP holds
  exactly one union code, `L12 — Local 12`. Neither implies a third kind. The two-value enum comes
  only from the planning note.
- **Blocked:** REQ-09 — the enum cannot be finalised, and adding a value later is a migration.
- **Candidates:** `payroll/rules/PAY-009-payroll-group-classification.md` (1.7 KB, `2026-08-24`);
  `payroll/gaps.md#union-codes-one-value-so-the-crud-question-mostly-dissolves`;
  `payroll/payroll-app-current-state/04-payroll-group-and-rule-applicability.md`.
- **Owner:** Syed Haris (raised it in the 2026-08-24 planning session).
- **Workaround, if any:** no longer needed.
- **Answer (`2026-08-24`, Syed Haris — CodingCops, acting product owner):** `kind` = **`UNION | NON_UNION`**, required. *"reunion" was a
  typo for non-union* — there is no third value. REQ-09 resolved.
- **Status:** resolved `2026-08-24` — REQ-09.

### Q8 — Did "type is required" mean `roleType`?

- **Question:** In the 2026-08-24 planning note, did "type is required" on the craft code mean
  `roleType`, or another field — and is `SCRUM-925`'s *"union classification/rule classification"*
  one field or two?
- **Why it cannot be answered from what is written:** `SCRUM-925` uses the phrase
  *"union classification/rule classification"* once and never defines it; intent §10 records it as
  a term that may not be defined and notes *"The ticket does not say whether these are one field or
  two."* This spec assumed one required union reference (REQ-03) plus one required role type
  (REQ-04), which is an assumption, not a source.
- **Blocked:** REQ-04, and the shape of the create DTO in §4.
- **Candidates:** `SCRUM-925`; `sync/.conflict/2026-08-24-bootstrap/craft-codes.md` (3.5 KB) —
  same wording, no elaboration; `payroll/erp-payroll-module-frd/03-payroll-groups-and-rate-determination.md`
  (6.5 KB) — covers rate determination, does not define a craft's fields.
- **Owner:** Umair Khan (wrote the ticket and the Confluence page); Syed Haris for the planning
  note.
- **Workaround, if any:** none needed.
- **Answer (`2026-08-24`, Syed Haris — CodingCops, acting product owner):** *"type is required" = `CraftCode.roleType`, required.* It
  follows that the craft carries **two** required classifications — the union reference (REQ-03)
  and the role type (REQ-04) — which is the reading `SCRUM-925`'s undefined phrase left open.
- **Status:** resolved `2026-08-24` — REQ-04.

### Q9 — Which application roles may manage craft codes and craft assignments?

- **Question:** Is `Role.ADMIN` the intended gate for craft codes, rates, scales and assignments —
  or does this epic need role values for payroll, crane superintendent and dispatch?
- **Why it cannot be answered from what is written:**
  `decisions/2026-08-20-craft-locked-rate-override.md` is `[VERIFIED]` and names *"the crane
  superintendent or whoever manages payroll, not the employee"*; intent §8 adds dispatch for temp
  creation and marks the exact enum values `NOT ON TICKET`. The `Role` enum in
  `apps/api/prisma/schema.prisma` line 18 is `USER | ADMIN | SUPER_ADMIN`. No source maps the
  named human roles onto it, and none of the 39 open entries in `payroll/gaps.md` covers ERP role
  mapping.
- **Blocked:** REQ-28, and §8's permitted-roles line. Not the schema.
- **Candidates:** `decisions/2026-08-20-craft-locked-rate-override.md` (2.0 KB, `2026-08-20`,
  `status: verified`); `payroll/2026-08-20-payroll-rules-meeting-notes.md` (8.5 KB);
  `admin/INDEX.md`; `domain/` (six verified SOP files — process only, no role model).
- **Owner:** product team — Syed Haris to route; the decision's own owners are Corrina Bustos and
  Brian Petros for who may act, not for how it maps to the ERP role enum.
- **Workaround, if any:** see the NOTE below — it is now the specified behaviour, not a workaround.
- **Answer (`2026-08-24`, Syed Haris — CodingCops, acting product owner):** craft / rate / scale CRUD sits behind **the existing admin
  gate** used by the union-code and work-comp-code modules; **assignments** (create, reassign, add
  secondary) are for **admin, payroll and the crane superintendent**; **dispatch** may set the
  **PRIMARY only, while creating a `TEMPORARY` employee**.
- **NOTE — the answer outruns the role model, and this is the part to carry forward.** Verified in
  code: `apps/api/prisma/schema.prisma` lines 18–22 defines `Role` as **`USER | ADMIN |
  SUPER_ADMIN`**, and the existing gate is `@Roles(Role.ADMIN, Role.SUPER_ADMIN)` at
  `employee-craft-codes.controller.ts` lines 51/59/68/80, `employee-union-codes.controller.ts`
  lines 51/59/68/80 and `employee-work-comp-codes.controller.ts` lines 53/61/70/82. **There is no
  `PAYROLL`, `CRANE_SUPERINTENDENT` or `DISPATCH` value.** So the CRUD half is implementable as
  answered and the assignment half is not: it collapses to the same admin pair, which over-grants
  against the `[VERIFIED]` 2026-08-20 decision and under-grants for dispatch creating a temp
  (REQ-27). Adding role values is a schema change with an auth blast radius well beyond this epic
  and nobody has asked for it — so it is recorded, not done.
- **Status:** resolved `2026-08-24` for CRUD — REQ-28. The assignment gate is implemented as far as
  the enum reaches, with the gap recorded above rather than closed.

### Q10 — What does an employee-level SECONDARY craft assignment mean?

- **Question:** Is a SECONDARY assignment on the employee a list of crafts that employee is
  *eligible* to work — with the day's actual craft chosen later on the labor entry — or is it
  itself the "secondary craft code assigned for that day"?
- **Why it cannot be answered from what is written:**
  `decisions/2026-08-20-craft-locked-rate-override.md` (`[VERIFIED]`) says the day's rate is driven
  by *"a secondary craft code assigned **for that day**"* — day-scoped. The 2026-08-24 planning
  decision makes `EmployeeCraftAssignment` undated current state and defers the per-day craft to
  the labor-entry ticket. `SCRUM-927` says only *"An employee can have a primary craft code or
  secondary one"* and, per intent §10, *"does not say who assigns it or when it applies"*.
  `SCRUM-935` passes the secondary in as a call argument, which is consistent with either reading.
- **Blocked:** REQ-08's acceptance criterion — the storage is buildable, its meaning is not
  checkable. Also the scope boundary between this epic and the labor-entry ticket.
- **Candidates:** `decisions/2026-08-20-craft-locked-rate-override.md` (2.0 KB, `2026-08-20`,
  verified); `payroll/2026-08-20-payroll-rules-meeting-notes.md` (8.5 KB) — *"oiler one day,
  operator the next"*; `sync/.conflict/2026-08-24-bootstrap/craft-codes.md` (3.5 KB) —
  `PAY-CC-02`, one sentence; `payroll/rules/PAY-010-…` — *"rarely ever work under a different
  craft code"*.
- **Owner:** Abdulrehman (CodingCops — proposed the secondary-craft mechanism on the 2026-08-20
  call); Corrina Bustos to confirm.
- **Workaround, if any:** no longer needed.
- **Answer (`2026-08-24`, Syed Haris — CodingCops, acting product owner):** employee-level SECONDARY assignments are the **"allowed
  alternates"** — the crafts a superintendent or payroll may choose for a day on that employee's
  labor entry. The labor entry's `secondaryCraftId` **must be one of the employee's SECONDARY
  rows**, and **a SECONDARY row has no pay effect by itself**. So the verified decision's
  day-scoped craft and the plan's undated row are **two objects, not two readings of one**: the row
  is eligibility, the day's choice lives on the labor entry (a later ticket, intent §5).
- **Scope line this draws:** the "must be one of the employee's SECONDARY rows" check is enforced
  by the **labor-entry ticket**, not this epic; this epic supplies the list it validates against.
  `SCRUM-935` does not put that check in the resolver, so adding it here would change an interface
  another ticket is being written against.
- **Not confirmed by:** Corrina Bustos, who owns the `[VERIFIED]` 2026-08-20 decision this
  reconciles. The reconciliation is consistent with it, but it is a CodingCops reading of a TCG
  decision, which is why REQ-08 is `[UNVERIFIED]` rather than verified.
- **Status:** resolved `2026-08-24` — REQ-08 acceptance defined.

### Q11 — At exactly 80 ft of boom, is there a modifier?

- **Question:** At a boom length of exactly 80 feet, does the operator earn tier 1 ($0.75) or no
  modifier at all?
- **Why it cannot be answered from what is written:** `SCRUM-934`'s formula gives
  `ceil((80 − 80) / 20) = 0` → no modifier. The MLA says *"**Eighty (80) feet** up to one hundred
  (100) feet … seventy-five cents (\$0.75) per hour"* → a modifier. The legacy label for tier 1 is
  `080-100Ft-Operator`, whose range includes 080 → a modifier. So the ticket's formula and both
  sources it cites disagree at the lower boundary, and the extract carries no row-level boom
  lengths, so the as-built engine's behaviour there cannot be read off it. Neither
  `payroll/rules/PAY-011-…` nor `payroll/rules/PAY-043-long-boom-premium.md` states a boundary
  rule.
- **Blocked:** REQ-14. One comparison; everything else in REQ-12 ships without it.
- **Candidates:** `payroll/mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md`
  (9.6 KB) → *Additional rate for high booms*;
  `payroll/legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md` (6.5 KB) →
  `OP-BP-01` / `080-100Ft-Operator`; `SCRUM-934`;
  `payroll/rules/PAY-043-long-boom-premium.md`.
- **Owner:** TCG payroll (Corrina Bustos); it is a contract-reading question, so
  `payroll/INDEX.md` caveat 3 applies — *"Do not resolve a contract question by reading the
  contract harder."*
- **Workaround, if any:** n/a — answered.
- **Answer (`2026-08-24`, Syed Haris — CodingCops, acting product owner):** **exactly 80 ft IS tier 1** (`080-100Ft`, +$0.75). The
  formula becomes `tier = floor((boomLengthFt − initialFt) / gapFt) + 1` for
  `boomLengthFt ≥ initialFt`; below `initialFt` there is no modifier; capped at
  `ceil((finalFt − initialFt) / gapFt)`. REQ-14 resolved.
  **⚠ This formula was superseded the same day — see Q12.** It delivers the 80-ft answer but breaks
  every upper boundary. **Do not implement it**; the formula in force is
  `max(1, ceil((boomLengthFt − initialFt) / gapFt))`, and that is what `SCRUM-934` is being
  corrected to. Kept here because it is the record of how REQ-14 was answered.
- **Note — this answer raised Q12.** The answer sided with the MLA and the legacy `080-100Ft` label
  against `SCRUM-934`'s original `ceil` formula, which is the right direction. But the replacement
  formula and that same legacy label disagree at the **upper** end of every tier. See Q12.
- **Status:** resolved `2026-08-24` for the lower boundary — REQ-14. Upper boundary → Q12.

### Q12 — At an exact multiple of `gapFt` (100, 120 … 440 ft), which tier applies?

- **Question:** At a boom length of exactly 100 ft, is it tier 1 (label `080-100Ft`, +$0.75) or
  tier 2 (label `101-120Ft`, +$1.50)? The same question applies at every one of the seventeen
  boundaries 100, 120, 140 … 440 ft.
- **Why it cannot be answered from what is written:** **Q11's answer contains both halves of the
  contradiction.** It states that 80 ft is tier 1 *and cites the legacy label `080-100Ft`* as tier
  1's label — a range whose upper bound is **100**. But the formula it supplies,
  `floor((L − initialFt) / gapFt) + 1`, puts 100 ft in **tier 2**: `floor(20/20) + 1 = 2`. Those
  cannot both hold. The prior `ceil` formula had the mirror-image defect — it matched every label's
  upper bound and failed only at 80. The legacy table
  (`payroll/legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md`) carries **no
  row-level boom lengths**, so the as-built engine's behaviour at a boundary cannot be read off it,
  and neither `payroll/rules/PAY-011-…` nor `payroll/rules/PAY-043-long-boom-premium.md` states a
  boundary rule. The MLA's *"Eighty (80) feet up to one hundred (100) feet … thereafter … for each
  additional twenty (20) feet **or part thereof**"* reads most naturally as inclusive of 100, which
  favours `ceil` — but reading the contract harder is exactly what `payroll/INDEX.md` caveat 3
  forbids.
- **Blocked:** REQ-12's length→tier function at seventeen inputs, and REQ-13's label derivation at
  **every** tier (a label derived from the Q11 formula's actual span reads `080-099`, not
  `080-100`). Everything else in both requirements ships.
- **Candidates:** `SCRUM-926 planning answers 2026-08-24 (Syed Haris)` — the formula and the label
  cited in the same sentence; `payroll/mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md`
  (9.6 KB) → *Additional rate for high booms*;
  `payroll/legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md` (6.5 KB) → the 33
  labels; `SCRUM-934` (being corrected — the correction should settle this, and is the cheapest
  place to).
- **Owner:** Syed Haris in the first instance — he is correcting `SCRUM-934`'s body and can settle
  it there. TCG payroll (Corrina Bustos) if the answer is meant to reflect the contract rather than
  the ticket.
- **Workaround, if any:** none needed — answered.
- **Answer (`2026-08-24`, Syed Haris — CodingCops, acting product owner, via coordinator):** **`tier = max(1, ceil((boomLengthFt −
  initialFt) / gapFt))`** for `boomLengthFt ≥ initialFt`, capped at
  `ceil((finalFt − initialFt) / gapFt)`; below `initialFt` there is no modifier. This matches the
  MLA (*"eighty (80) feet up to one hundred (100) feet"* = tier 1) **and every legacy label** —
  80 → 1, 100 → 1, 101 → 2, 195 → 6, 440 → 18. **`SCRUM-934` is being corrected to this formula.**
  REQ-12, REQ-13 and REQ-14 updated; no boundary test is left pending.
- **And the role half:** a `roleType` with **no step rate on the scale returns no modifier** at any
  boom length, even when one is supplied — not a Blocked result, and never the operator step rate.
  That closes what this spec previously recorded as `NOT SPECIFIED` for `ADMIN` and `LABORER`. See
  REQ-14's acceptance; the distinction from REQ-18's Blocked is in its notes.
- **Status:** resolved `2026-08-24` — REQ-12, REQ-13, REQ-14.

### Q13 — Does an employee working two crafts in a day get the higher rate for the whole day?

- **Question:** `payroll/codingcops-rule-matrix.md` §B `PR-015` requires *"identify higher
  qualifying rate and create true-up component"* when an employee works at multiple qualifying
  rates. Does that apply to this epic's craft model — and if so, does the resolver need to see all
  of a day's crafts rather than one at a time?
- **Why it cannot be answered from what is written:** `payroll/rules/PAY-015-higher-rate-for-day-job.md`
  is `status: open` with the blocking item **"Union/legal interpretation required"**, is marked
  *New ERP requirement* with **no legacy counterpart**, and its FRD leg is `PR-029` under yet
  another numbering. Nothing in `SCRUM-925/927/934/935`, the intent, or any of the 2026-08-24
  answers mentions it. `SCRUM-935`'s `CraftRateResolverService` is specified **per labor entry** —
  `resolveEmployeeCraft(employeeId, secondaryCraftId?)` returns one craft's rate — which cannot
  compute a day-level higher-rate true-up without seeing the day.
- **Why it is raised now:** it surfaced from re-reading rule-matrix §B against REQ-01/02/07, which
  the precedence direction of 2026-08-24 prompted. It is exactly the kind of requirement the
  unadjudicated-overlap flag exists to catch: nobody in this epic had read `PR-015`, and Q10's
  answer — an employee with allowed alternates working a different craft on a given day — is
  precisely `PR-015`'s trigger condition.
- **Blocked:** nothing in this epic **if** the answer is "later ticket" — REQ-17's interface still
  works per entry. If the answer is that the resolver must expose a day-level view, that is an
  interface change to `SCRUM-935`, and it is much cheaper to know now than after it ships and the
  payroll engine is written against it.
- **Candidates:** `payroll/rules/PAY-015-higher-rate-for-day-job.md` (`status: open`, `2026-08-24`);
  `payroll/codingcops-rule-matrix.md` §B `PR-015` (20.8 KB);
  `payroll/erp-payroll-module-frd/06-boom-equipment-and-guaranteed-hours.md` `PR-029`;
  `decisions/2026-08-20-craft-locked-rate-override.md` (`[VERIFIED]`) — silent on it.
- **Owner:** TCG payroll (Corrina Bustos / Brian Petros) for whether the rule applies; Syed Haris
  to route the scope half — this epic or the labor-entry ticket.
- **Workaround, if any:** build `SCRUM-935`'s interface exactly as specified, per entry, and change
  nothing.
- **Answer (`2026-08-24`, Syed Haris — CodingCops, acting product owner, via coordinator):** **routed, not resolved.** The higher-rate-for-day true-up
  (`PR-015` / `PAY-015`) is a **payroll-engine rule for a later ticket under `SCRUM-920`**. It is
  **not blocking this epic**, and `SCRUM-935`'s per-entry resolver interface is unchanged: the
  resolver prices one labor entry, and aggregating a day is the engine's job. Recorded on REQ-08
  and REQ-17 so that neither gets a day-level method added in anticipation.
- **Where it stays open:** with the payroll-engine ticket under `SCRUM-920`, and in
  `payroll/rules/PAY-015-…`, which is `status: open` with the blocking item *"Union/legal
  interpretation required"*. That interpretation is still needed — routing it did not answer it.
- **Clarification (`2026-08-25`, Syed Haris, via coordinator) — the case, recorded verbatim:**
  *one employee working as an oiler on one job and as an operator on another in the same day, with
  oiler as his primary.* `PAY-015` / the MLA's **"higher rate for the entire day"** governs how
  that day's base rate is set. **The resolver stays per-entry** and returns each entry's own craft
  rate; the day-level true-up is `SCRUM-920` engine work.
- **Why the example matters more than the rule text:** it is exactly what Q10's allowed-alternates
  model makes routine — the employee's PRIMARY is oiler, the operator craft is one of his SECONDARY
  rows, and both jobs are priced on the same date. So this is not a rare edge case to be discovered
  later; it is the ordinary use of the mechanism this epic is building.
- **Status:** moved out (`2026-08-25`, Syed Haris) — this is not a question this epic raised or
  can answer; it belongs to the payroll engine. Tracked in `payroll/rules/PAY-015-…` (`status:
  open`) and to be carried by the engine ticket under `SCRUM-920`. Not counted against this spec.

### Q14 — What is `L12-BG-*`, and which `roleType` does it take?

- **Question:** What are the `L12-BG-*` craft codes in the FCC data, and which `roleType` should the
  migration assign them? (Same question for any other code the prefix rules do not match.)
- **Why it cannot be answered from what is written:** the enum half of this question **was
  answered** — see below. What is left is the data. `L12-BG-*` appears in
  `payroll/legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md`'s distinct-craft
  list **with no role column**, matches none of Q4's five prefix rules (it is neither `L12-G*` nor
  `L12-APP*`), and no source anywhere says what `BG` stands for. `payroll/rules/PAY-009-…` records
  `EmpTypeID` *"3 = Mechanic"*, which makes `MECHANIC` a **tempting** guess — and it is exactly the
  guess this entry exists to prevent, because nothing connects that employee-level code to this
  craft prefix.
- **Blocked:** **the migration run, not the build.** REQ-05 and REQ-23 are fully specified and
  buildable; the migration is designed to abort on precisely this and report it. But `L12-BG-*` is
  in the FCC data today, so the **first** real run will abort until an administrator supplies an
  explicit `code → roleType` entry for it. Answer this before scheduling the cutover, not during it.
- **Candidates:** `payroll/legacy-payroll-app-db-extract/data/craft-modifiers-and-boom-status.md`
  (6.5 KB, `2026-08-18`) → *Distinct CraftCode*;
  `payroll/legacy-payroll-app-db-extract/data/source-feed.md` → `src.FMS_CRAFTS_Raw`, whose
  `PayType` / `AcctPayType` / `UnionYN` / `EarningsType` columns may narrow it;
  `payroll/rules/PAY-009-payroll-group-classification.md` (1.7 KB);
  `payroll/mcog-l12-mla-2025-2028/02-…` (9.6 KB) — Article IV names Shop Foreman and Heavy Duty
  Repairman/Welder, neither of which is in the enum.
- **Owner:** **Corrina Bustos**, who maintains the FCC craft table.
- **Workaround, if any:** none needed for the build. The cheap preparatory step is to **list the
  distinct `L12-BG-*` codes and their `FMS_CRAFTS` rows** and take that list to her, so the answer
  arrives with its evidence rather than as a second round-trip.
- **Answer to the enum half (`2026-08-24`, Syed Haris — planning decision Q8, via coordinator):**
  `roleType` = **`OPERATOR | OILER | THIRD_MAN | LABORER | ADMIN | MECHANIC`**. `THIRD_MAN` and
  `MECHANIC` are **admin-selectable values for crafts created after migration** — from the design
  mock's role types and `PAY-009`'s L12 Mechanic group. **The prefix mapping is unchanged**: it does
  not populate either, and `L12-BG-*` and anything else unmapped still aborts the migration with a
  report, which the administrator resolves by supplying explicit `code → roleType` entries and
  re-running. REQ-04, REQ-05 and REQ-23 updated.
- **Answer (`2026-08-25`, Syed Haris — CodingCops, acting product owner, via coordinator):** **RESOLVED by scope change — there are no data migrations in
  this epic.** Administrators create `CraftCode` rows (code, `roleType`, union, dates, rates)
  through the API. **No FCC copy, no `-A`/`-B`/`-C` collapse, no prefix→`roleType` mapping — and so
  no `L12-BG-*` question.** Schema migrations that *add* tables, columns and enums remain; the
  **drops** (`employee_craft_codes`, `Employee.craftCodeId`, `unionCodeId`, `unionStatus`) move to
  a later cleanup ticket that runs once every employee has a PRIMARY. In this epic those columns
  stay and are simply no longer read by payroll.
- **And with it, Q17 goes too** — there is no backfill, so there is no null-`craftCodeId`
  pre-check. The required-PRIMARY rule now applies to employees **created or updated after U3
  ships**; existing employees without one are **listed by an admin `GET` report endpoint** rather
  than blocked (REQ-07). REQ-24's DAS filter gains a **fallback to the legacy `unionStatus`
  string** while employees lack a PRIMARY.
- **What this trades:** it removes every abort path, every mapping guess and the whole
  `L12-BG-*` problem — real risk, genuinely gone. It buys that by moving the work to people: the
  FCC craft catalogue and one assignment per employee now have to be **entered by hand**, and no
  ticket in `SCRUM-926` owns that. See §11, *Launch state*. It also leaves **two live
  representations of an employee's craft** — the old column and the new assignment table — with
  nothing keeping them in step (REQ-23 note (a)).
- **Status (`2026-08-24`, superseded):** open — reduced to the `L12-BG-*` data question; blocks the
  migration run, not the build
- **Status:** withdrawn `2026-08-25` — superseded by the scope change; there is no migration left to
  block. Row kept so the numbering stays stable.

---

**Q15–Q17 appended `2026-08-25` by the decomposer (`tcg-decomposer`), from slicing this spec
into `units.md`.** They are not new product scope — each is a `NOT SPECIFIED` or a gap that
`spec.md` already records, which becomes a *stop* the moment an executor has to write the line
of code it touches. The summary counts at the top of this section predate them.

### Q15 — What money precision do craft rates and boom step rates carry?

- **Question:** What Prisma/Postgres precision do `CraftCodeRate.baseRate`,
  `CraftModifierScale.operatorStepRate` and `CraftModifierScale.oilerStepRate` take —
  `Decimal(10,2)` or `Decimal(10,3)` (or something else)?
- **Why it cannot be answered from what is written:** §3 records the disagreement and declines to
  choose. The existing ERP money columns are `Decimal(10,2)`
  (`Employee.hourlyRate`/`payRateOT`/`payRateDB`, `schema.prisma` ~3501/~3515). The legacy feed
  carries **three** decimals on both craft rates (`66.180`) and modifier adders (`0.750`, `4.500`,
  `13.500`) — `payroll/legacy-payroll-app-db-extract/data/source-feed.md` and
  `…/craft-modifiers-and-boom-status.md`. The FY26-27 workbook figures quoted in
  `payroll/rules/PAY-008-…` are two-decimal (`67.03`). Two decimals is sufficient for every value
  any source **names**, but no source **states** the precision, and §3 says so verbatim: *"Raise it
  rather than silently choosing — a truncation here is a wrong paycheck."*
- **Blocked:** **the migrations in U1 and U2, not the rest of either unit.** A column type is a
  one-way commitment that every rate row will conform to; widening later is a migration over live
  payroll data and narrowing later silently truncates. Everything else in both units — the CRUD,
  the tier function, the tests — can be written against the decision once it exists.
- **Candidates:** `apps/api/prisma/schema.prisma` (the `Decimal(10,2)` house convention);
  `payroll/legacy-payroll-app-db-extract/data/source-feed.md` (three decimals, as fed);
  `payroll/rules/PAY-008-effective-dated-configuration.md` (two decimals, as quoted).
  Note the two are not in conflict about *money* — three decimals on `0.750` is a step rate that is
  multiplied by a tier, not a paid amount.
- **Owner:** Syed Haris to decide for the build; **Brian Petros** if it turns out any FCC rate in
  use carries a non-zero third decimal, because that is a rate someone is being paid.
- **Workaround, if any:** none needed — answered.
- **Answer (`2026-08-24`, Syed Haris — CodingCops, acting product owner, via coordinator):** **`Decimal(10,4)`** on `CraftCodeRate.baseRate`,
  `CraftModifierScale.operatorStepRate` and `oilerStepRate`, as on `SCRUM-925` / `SCRUM-934`. The
  legacy feed stores three decimals (`66.180`, `0.750`) and **four is a superset**, so nothing
  truncates on the way in. **Derived amounts round half-up to cents only in the pay-component
  ledger (`PAY-069`) — never in these tables and never in the resolver.**
- **Note on what this decides:** it takes these three columns **off** the `Decimal(10,2)` house
  convention used by `Employee.hourlyRate` / `payRateOT` / `payRateDB`, deliberately. Those hold
  paid amounts; these hold rates that get multiplied by hours and by tier, where lost precision is
  amplified rather than absorbed. The rounding boundary is now explicit and singular — one place,
  downstream — which also answers the question the original entry raised about a non-zero third
  decimal: it is representable, so nobody's rate is silently changed by the migration.
  `payroll/rules/PAY-069-…` is itself `status: open` and *"in no kept catalog"*, so the **ledger**
  rounding rule it names is not settled; what is settled here is only that this epic does not do it.
- **Status:** resolved `2026-08-24` — §3, §9, REQ-02, REQ-11, REQ-12.

### Q16 — How is `SCRUM-935` accepted, given it has no HTTP surface?

- **Question:** `SCRUM-935`'s `CraftRateResolverService` is specified as a service with **no HTTP
  surface** (REQ-17; §4's route table lists it as *"(none — service only)"*), while the
  `2026-08-24` product-owner constraint is that **every unit is demonstrable via curl/Swagger**,
  since there is no UI. Which gives: is the unit test suite `SCRUM-935`'s acceptance evidence, or
  should the epic add an admin-gated diagnostic endpoint?
- **Why it cannot be answered from what is written:** both statements are from the same owner, six
  hours apart, and neither anticipated the other. REQ-17's notes say to build **exactly** the three
  methods `SCRUM-935` specifies, and warn that anything added here *"changes an interface another
  ticket is being written against"* (`SCRUM-929`/`930`). Adding an endpoint on a decomposer's
  judgement would be inventing a requirement this spec does not make; dropping the demo constraint
  on a decomposer's judgement would be waiving a constraint that is not the decomposer's to waive.
- **Blocked:** **nothing in the build.** U4 is fully specified and buildable either way; what is
  unsettled is how it is *reviewed*. Answer it before U4 opens a PR, not before U1 starts.
- **Candidates:** `SCRUM-935` acceptance criteria (*"Backend only"*, listed unit tests); `spec.md`
  §4 route table; §10's fifteen resolver test rows; the `2026-08-24` demo constraint as captured in
  `units.md`.
- **Owner:** **Syed Haris.**
- **Workaround, if any:** two, and the second is not free. (a) **Accept the test suite** —
  `pnpm nx run @tcg/api:test` over the fifteen named cases is a real, reviewable artefact, and the
  boom half of the behaviour is already curl-visible through U2's
  `GET /api/v1/craft-modifier-scales/:id/preview`, which calls the same tier function. (b) **Add
  one `POST /api/v1/craft-rate-resolver/preview`**, admin-gated, explicitly diagnostic, explicitly
  not part of the interface `SCRUM-929`/`930` consume — which costs a route that a later ticket has
  to decide whether to keep. (a) is the smaller deviation.
- **Answer (`2026-08-24`, Syed Haris — CodingCops, acting product owner, via coordinator):** **(a) accepted.** `SCRUM-935` / U4 is reviewable by **its
  test suite plus U2's preview endpoint**, which exercises the same tier function over curl.
  **No HTTP surface is added for the resolver.**
- **What this means for the reviewer:** the demo-via-curl constraint is satisfied *for this unit*
  by `GET /api/v1/craft-modifier-scales/:id/preview`, not by a resolver route. Reviewing U4 means
  reading the fifteen named test cases in §10 and running them — so those tests are acceptance
  evidence, not developer convenience, and thinning them is a change to how the unit is accepted.
  Recorded in REQ-17's notes.
- **Status:** resolved `2026-08-24` — REQ-17, §4.

### Q17 — What happens to employees who have no craft code today?

- **Question:** `Employee.craftCodeId` is **nullable** (`schema.prisma` ~3521), so some employees
  have no craft at all. REQ-07 requires **every** employee to hold exactly one PRIMARY assignment;
  REQ-23's acceptance covers only *"every employee that had a `craftCodeId`"*. What does the
  backfill do with the remainder — leave them without a PRIMARY (and REQ-07's invariant is not
  enforceable for existing rows), assign a placeholder craft, or abort the way the unmapped-prefix
  path does?
- **Why it cannot be answered from what is written:** REQ-23's own note (a) identifies the
  population and stops short of an answer: *"the backfill will not produce a PRIMARY for them and
  REQ-07's 'exactly one' cannot be enforced until they are resolved; that population needs counting
  before the migration is written, not after."* Nothing anywhere says what "resolved" means. The
  three abort paths this spec **does** specify (unmapped craft prefix, unclassifiable union label)
  were each stated deliberately; this one was not stated at all, which is the difference between a
  designed abort and a gap.
- **Blocked:** **U3's backfill migration, and through it U3's drop migration.** It cannot be
  written without knowing which of the three behaviours is correct, and the drop migration destroys
  `Employee.craftCodeId` — the only remaining evidence of who was in this population.
- **Candidates:** `apps/api/prisma/schema.prisma` ~3521 (the column is nullable — a fact, not an
  intention); `payroll/rules/PAY-009-payroll-group-classification.md` (payroll group is derived from
  the craft prefix, so an employee with no craft has no payroll group either);
  `payroll/rules/PAY-060-missing-data-issues.md` (the Blocked-result pattern, which suggests these
  employees would simply not price rather than block the migration).
- **Owner:** **Corrina Bustos** for what these employees are in FCC; **Syed Haris** for the
  migration behaviour.
- **Workaround, if any:** the answer probably follows from the count. **Run
  `SELECT count(*) FROM employees WHERE craft_code_id IS NULL` per tenant before U3 is written.**
  If it is zero, the question is moot and REQ-07's invariant holds for existing rows as written. If
  it is not, the count tells you whether this is a data-cleanup task or a model problem.
- **Answer (`2026-08-24`, Syed Haris — CodingCops, acting product owner, via coordinator):** **abort, on the same pattern as the FCC copy.** U3's
  migration opens with a **pre-check that lists every employee with a null `craftCodeId` and aborts
  if any exist**. Administrators clear the list by setting `Employee.craftCodeId` through the
  **existing employee update endpoint**, and the migration is re-run once the list is empty.
  Explicitly **not** wanted: a "pre-migration mode" on U3's new assignment endpoint writing to the
  still-present column. Keep the remediation on the endpoint that already exists.
- **What this settles beyond the migration:** REQ-07's *"every employee has exactly one PRIMARY"*
  becomes **enforceable for existing rows**, not just for new ones — the invariant holds after
  migration precisely because the migration refuses to finish until it does. That was the gap this
  entry identified, and it is now closed by construction rather than by a data-cleanup promise.
  Neither placeholder-craft nor leave-them-null was chosen; both would have made REQ-07 false in
  the database on day one.
- **Superseded (`2026-08-25`, Syed Haris, via coordinator):** **moot — there is no backfill.**
  Q14's scope change removed every data migration, so the pre-check this question was answered with
  no longer exists. The population it identified did not go away: **every** existing employee now
  lacks a PRIMARY assignment on day one. They are **not blocked** — REQ-07's admin report endpoint
  lists them, and the later cleanup ticket that drops `Employee.craftCodeId` waits on that list
  reaching zero.
- **Status (`2026-08-24`, superseded):** resolved — the backfill aborts while any employee has a
  null `craftCodeId` (REQ-07, REQ-23)
- **Status:** withdrawn `2026-08-25` — moot after the scope change; there is no backfill. Row kept
  so the numbering stays stable.

### Q18 — Non-union pricing reversed to per-person: which source governs, and is the verified decision overridden?

- **Raised `2026-08-25` by the decomposer**, from the `2026-08-25` scope change (Syed Haris, via
  coordinator). **Q14 and Q17 are moot under the same change** — each existed only to protect a
  migration step the epic no longer performs. Their `Status` lines above are stale.
- **Question:** The build now prices **non-union employees from `Employee.hourlyRate`** — the
  resolver branches on `craft.unionCode.kind`, `UNION` → `CraftCodeRate`, `NON_UNION` →
  `Employee.hourlyRate` — and `Employee.hourlyRate` is **not** retired. **REQ-10 and REQ-19 as
  written say the opposite**, and REQ-19's statement rests on a **`[VERIFIED]`** source. Which
  governs, and does the planning direction override that decision or sit beside it?
- **Why it cannot be answered from what is written:** three documents now point three ways, and
  **the build follows none of them by name** — it follows a planning answer relayed on
  `2026-08-25`.
  - `decisions/2026-08-20-craft-locked-rate-override.md` — **`[VERIFIED]`**, decided by Corrina
    Bustos, confirmed by Brian Petros — *"rates always come from craft tables"*, day-level
    deviation *"never a free-text dollar override"*. The **only verified source in this epic**,
    and REQ-19 cites it. Reading a rate off the employee record is not obviously *"from craft
    tables"*. It is also not obviously a *"free-text dollar override"* — `Employee.hourlyRate` is
    a mastered column, and the decision's subject was day-level deviation on **union** work. **A
    narrow reading and a broad reading give opposite answers, and nobody has chosen between
    them.**
  - `payroll/rules/PAY-012-non-union-hourly-rate.md` — *"Use employee-master hourly rate; do not
    use union craft rate"*, with **Brian Petros's written confirmation `2026-06-09` marked "very
    important"**, corroborated by the legacy engine's **21,348** `Employee.PayRate` rows. **The
    new direction matches this exactly** — the reversal moves onto the better-sourced side, which
    is why this is a question about the record, not an objection to the decision.
  - `payroll/codingcops-rule-matrix.md` §B `PR-014` — treats *"source rate; craft rate; modifier;
    **employee rate**"* as four live rate sources to be compared. **Consistent with the new
    direction and inconsistent with the old one**, and still unadjudicated against either.
- **Blocked:** **nothing in the build.** The branch is specified unambiguously and U4 is buildable
  today. What is blocked is **§14 sign-off**: REQ-10 and REQ-19 currently describe behaviour
  nobody is building, their acceptance lines are false by direction (REQ-10's *"two non-union
  employees on the same craft code resolve to the same base rate"*; REQ-19's *"a grep of the
  resolver shows no reference to those three columns"*), and §14 already requires a decision note
  for every `[CONFLICT]` requirement — of which REQ-10 is one, **now pointing the other way**.
- **Also affected, and cheap to miss:** intent §5 said this ticket *"only stops payroll reading"*
  the employee rate columns — it no longer does. Any future cleanup ticket that drops
  `hourlyRate`/`payRateOT`/`payRateDB` must now **exclude `hourlyRate`**, which is live under this
  model rather than legacy. `SCRUM-928` (employee-specific rate adjustments, out of scope) also
  moves closer: a per-person non-union rate *is* an employee-level rate.
- **Candidates:** the three documents above, read against each other. The read is small — the
  decision note is ~2 KB, `PAY-012` is 2.0 KB, `PR-014` is one row of §B.
- **Owner:** **Corrina Bustos** (the decision's owner) and **Brian Petros** (whose `PAY-012`
  confirmation the new direction now follows) for whether the decision is overridden or merely
  narrowed to union work; **`tcg-scrum`** to record the outcome in `.ai/vault/decisions/`, which no
  planning answer in this epic has yet had.
- **Workaround, if any:** none needed to build. Two cheap preparatory steps. **(a)** Run the count
  `spec.md` REQ-10 already asked for — distinct non-union `Employee.PayRate` values — which is now
  evidence *for* the model rather than a cost against it. **(b)** When the decision note is
  written, say explicitly whether `decisions/2026-08-20-craft-locked-rate-override.md` is
  **overridden** or **scoped to union work**; those read the same today and diverge the first time
  someone asks whether a union employee may be priced per person.
- **Answer (`2026-08-25`, Syed Haris — CodingCops, acting product owner, via coordinator):**
  **the two sit beside each other; the verified decision is not overridden.**
  `decisions/2026-08-20-craft-locked-rate-override.md` was taken on the **union day-level override
  case** — Corrina Bustos and Brian Petros, in an L12 context — and is **read as scoped to UNION
  crafts**. Non-union per-person pricing on `Employee.hourlyRate` follows `payroll/rules/PAY-012-…`
  and FCC practice, and **is not a reversal of it**.
- **This is a working reading, and the word matters.** It is a *reading* of a `[VERIFIED]` decision
  by someone who did not take it. Corrina Bustos and Brian Petros have not confirmed that their
  decision was union-scoped — it is inferred from its subject matter, which is a good inference and
  still an inference. The narrow and broad readings diverge the first time anyone asks whether a
  *union* employee may be priced per person, and this spec answers that question **no** on the
  strength of the reading alone.
- **What has already been done in this spec:** REQ-10 and REQ-19 were **rewritten to the
  union/non-union branch** in this same revision, so the stale acceptance criteria this entry names
  (*"two non-union employees on the same craft code resolve to the same base rate"*, *"a grep shows
  no reference to those three columns"*) are gone — nothing in §2 now describes behaviour nobody
  builds. **REQ-10's `[CONFLICT]` is cleared** and it is `[UNVERIFIED]`: `PAY-012`, the client's
  written statement, the legacy engine's 21,348 rows and the decision all agree. REQ-19 carries the
  scope reading explicitly in its *Conflict* field rather than burying it.
- **What still has to happen, and it is not this agent's write path:** `tcg-scrum` must append the
  scope clarification to `.ai/vault/decisions/2026-08-20-craft-locked-rate-override.md` saying
  plainly that it is **scoped to union crafts** and **not overridden**. Until that lands, the only
  record of the reading is this spec, and the decision file still reads *"rates always come from
  craft tables"* with no qualifier. Added to §14.
- **Status:** resolved `2026-08-25` as a **working reading** — REQ-10, REQ-19. Pending `tcg-scrum`
  recording the scope clarification, and ideally Corrina Bustos confirming it.

### Q19 — How does `EmployeeUnionCode.kind` get a value on rows that already exist?

- **Raised `2026-08-25` by the elaborator**, created by the `2026-08-25` scope change rather than
  found in the sources.
- **Question:** REQ-09 adds `kind` to `EmployeeUnionCode` as a **required** column, and
  `EmployeeUnionCode` is an **existing table with existing rows**. With no data migration (Q14),
  what gives those rows a value — a database default, or a nullable-then-tighten sequence, and
  either way **which value**?
- **Why it cannot be answered from what is written:** the two decisions are individually clear and
  collide here. REQ-09 (Q7) makes `kind` required with no third value; Q14 removes every data
  migration. Nothing bridges them. A `DEFAULT 'UNION'` silently declares every existing union code
  union — including the non-union ones — and **REQ-24's employee filter reads exactly this column**,
  so the wrong default moves union/non-union headcounts without anyone touching the filter. A
  nullable column contradicts REQ-09's "required". `payroll/gaps.md#union-codes-one-value-so-the-crud-question-mostly-dissolves`
  records that ADP holds exactly **one** union code, `L12 — Local 12`, which suggests the affected
  row count is small — but "small" is not "zero", and the vault does not say what a tenant's
  `EmployeeUnionCode` table actually holds.
- **Blocked:** REQ-09's column definition and REQ-23's migration, both at write time. Not the API,
  not the resolver.
- **Candidates:** `apps/api/prisma/schema.prisma` ~2290 (`EmployeeUnionCode` as it stands, no
  `kind`); `payroll/gaps.md#union-codes-one-value-so-the-crud-question-mostly-dissolves`;
  `payroll/rules/PAY-009-payroll-group-classification.md` (the union/non-union predicates, which
  key off the **craft** prefix, not the union code);
  `apps/api/src/service/employee/employee.repository.ts` lines 169–186 (where
  `EmployeeUnionCode.label` is copied into `Employee.unionStatus` — the nearest thing to an
  existing classification, and it is per-tenant free text).
- **Owner:** Syed Haris for the migration behaviour; whoever can look at the actual
  `employee_union_codes` rows per tenant for whether any is non-union today.
- **Workaround, if any:** the answer probably follows from the count, as it did for Q17. **Run
  `SELECT tenant_company_id, code, label FROM employee_union_codes` before U1 is written.** If
  every row is `L12`-like, a default plus an admin correction pass is defensible and cheap to say
  so explicitly. If any tenant has non-union codes in there, defaulting is a silent data error in a
  column the DAS filter reads.
- **Answer (`2026-08-25`, via coordinator; consistent with `units.md` U1):** the **ADD migration
  fills existing rows by label match** — a label containing `non-union`, `non union` or `nonunion`,
  **case-insensitive**, derives `NON_UNION`; **everything else derives `UNION`**. **The PR
  description must list every `(tenant, code, label, derived kind)` row for administrator review
  before merge.**
- **Why the default direction is the right way round:** it **fails loud**. A row wrongly derived as
  `UNION` sends its employees down the `CraftCodeRate` path, which is empty on day one, so they
  **Block** (REQ-18) and someone investigates. The opposite default would route them to
  `Employee.hourlyRate` and **pay them from the wrong source silently** (REQ-10). Given a heuristic
  was going to be used at all, this is the asymmetry to choose — a stopped paycheck is recoverable,
  a wrong one is not.
- **Two limits worth carrying to the PR review, since the review is the only control:** the
  fail-loud property covers **pay, not reporting** — a mis-derived row still lands on the wrong
  side of REQ-24's union/non-union headcount with nothing to Block on. And the match is against
  `EmployeeUnionCode.label`, which is **per-tenant free text**, so a tenant that wrote "Open Shop",
  "Merit" or "Non Union Admin" gets `UNION` from a rule that never saw those strings. That is what
  the row-by-row listing is for: read the labels, not just the derived values.
- **Note on scope:** this is the **one data write** that survives Q14's no-data-migration decision,
  and it survives because a required column on a populated table leaves no alternative. Recorded as
  an explicit exception in REQ-23 rather than left to contradict it.
- **Status:** resolved `2026-08-25` — REQ-09, REQ-23.

## 13. What this spec deliberately does not specify

- **What a union-code label that says neither "union" nor "non-union" actually is** — Q19's label
  match derives `UNION` for anything unrecognised, deliberately, because that fails loud on pay.
  No source says what labels tenants actually use, so the PR's row-by-row listing is the control.
  See Q19 and REQ-09.
- **Effective dating for the non-union rate** — Q1 reads `Employee.hourlyRate` as it currently
  stands, so recalculating a past period returns today's rate. That contradicts
  `payroll/rules/PAY-008-…` and is `PAY-012`'s own open blocking item, *"Confirm rate-effective-date
  handling"*. Scoped out deliberately; it lands on `PAY-068`. See Q1 and REQ-10.
- **Whether the two live craft representations should agree** — `Employee.craftCodeId` and
  `EmployeeCraftAssignment` are both live after this epic (Q14), and nothing keeps them in step.
  No source says anything should. See REQ-23 note (a).
- **FY2026-27 craft rates** — two vault files updated the same day contradict each other. Seeding
  is out of scope (Q5), so this epic builds nothing from it, but **the contradiction is unresolved
  and now sits with whoever enters rates**; REQ-22 keeps the record findable.
- **How `SCRUM-925`/`SCRUM-927`/`PAY-CC-01..03` relate to the rule matrix §B and FRD 03** — the
  2026-08-24 precedence direction settles ticket-vs-plan, not vault-vs-plan; three documents in
  three id schemes still specify this topic and have never been read against each other. See §0,
  *Precedence*, and REQ-01/02/07's `[CONFLICT]`.
- **Whether the 2026-08-20 verified decision is *actually* union-scoped** — Q18 reads it that way
  and the build follows the reading, but Corrina Bustos and Brian Petros have not confirmed it and
  the decision file still says *"rates always come from craft tables"* with no qualifier. See Q18,
  REQ-19, and the `tcg-scrum` item in §14.
- **Whether the boom adder composes into the base rate** — sources conflict; see Q3 and REQ-20.
- **What happens above 440 ft** — the MLA's premium is open-ended; 440 is the largest bracket
  anyone happened to key into FCC. Q11's answer introduced a **cap** at
  `ceil((finalFt − initialFt) / gapFt)`, which silently prices a longer boom at tier 18 rather than
  failing. No source states that a cap is correct, and no source states what should happen instead.
- **Which application roles express "payroll", "crane superintendent" and "dispatch"** — Q9
  answered who may act; the `Role` enum has no values for them. See REQ-28's NOTE.
- **Field lengths, error statuses and messages, missing-data severities** — no source states any of
  them; §3 and §9 record them as `NOT SPECIFIED` rather than choosing. (**Money precision is no
  longer among them** — Q15 set `Decimal(10,4)`.)
- **Approval workflow for a craft or rate change** — `PAY-008` requires an *"approver"*; no source
  says what approval means here, so none is specified.
- **Employee-specific rate adjustments** (`SCRUM-928`, Confluence `PAY-CC-03`) — excluded by
  intent §5. The resolver leaves an extension point; nothing is built. Note that
  `sync/.conflict/2026-08-24-bootstrap/craft-codes.md` flags `PAY-CC-03` as overlapping the
  base-rate-override topic **unadjudicated**, and
  `payroll/gaps.md#pay-rate-follows-the-employee-not-the-role-worked…` records Kyle Harlow asking
  for an over-scale box on the employee profile. That is a live thread, not a settled exclusion.
- **Per-day secondary craft on the labor entry, boom length on the labor entry, pricing at final
  customer signature, lattice / foreman / military / shift premiums, prevailing wage,
  jurisdiction, per-diem, billing linkage, craft promotion history, vendor employees, and the
  `payRateDB → payRateDT` rename** — all excluded by intent §5.
- **Any web or mobile behaviour** — backend only; §5 and §6 are `N/A` by ticket, not by omission.

## 14. Sign-off before build

- [x] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person —
      **done 2026-08-24**: REQ-05 and REQ-28 answered, REQ-14 answered, REQ-22 out of scope
- [x] **Q12 answered `2026-08-24`** — `max(1, ceil(…))`; ties out at every boundary and at every
      derived label. `SCRUM-934` being corrected to match
- [x] **Q13 routed `2026-08-24`** — `PR-015`'s higher-rate-for-day true-up is a payroll-engine rule
      for a later ticket under `SCRUM-920`. `SCRUM-935`'s per-entry interface is unchanged
- [x] **Q14 enum half answered `2026-08-24`** — six values; `THIRD_MAN` / `MECHANIC` admin-selectable
      post-migration, prefix mapping unchanged
- [x] **Q14 and Q17 withdrawn `2026-08-25`** — the scope change removed every data migration, so
      the `L12-BG-*` question and the null-`craftCodeId` pre-check both went with it
- [x] **Q1 resolved `2026-08-25`** — non-union is **per person**, matching `PAY-012` and the
      client's own 2026-06-09 statement. REQ-10's `[CONFLICT]` cleared
- [ ] **`tcg-scrum` appends a scope clarification to
      `.ai/vault/decisions/2026-08-20-craft-locked-rate-override.md`** — that it is **scoped to
      UNION crafts** and is **not overridden** by non-union per-person pricing (Q18). *Only
      `tcg-scrum` writes to `.ai/vault/decisions/`; this spec did not edit it.* Until it lands, the
      only record of that reading is this file, and the decision still reads *"rates always come
      from craft tables"* unqualified
- [x] **Q19 answered `2026-08-25`** — `kind` derived by label match, defaulting to `UNION` so a
      mis-derived row Blocks rather than pays from the wrong source
- [ ] **The migration PR lists every `(tenant, code, label, derived kind)` row, and an administrator
      reads the *labels*** — not just the derived values (REQ-09). This is the only control on the
      heuristic, and it catches the "Open Shop" / "Merit" case the rule never saw
- [ ] **Q13 stays open under `SCRUM-920`** — the higher-rate-for-day true-up. Not this epic's, but
      the worked example (oiler on one job, operator on another, same day) is ordinary use of what
      this epic builds, so it will arrive early
- [ ] **A ticket exists for the data entry this epic now requires** — the whole craft catalogue and
      one PRIMARY assignment per employee, by hand through the API (Q5 + Q14). No ticket in
      `SCRUM-926` owns it. See §11, *Launch state*
- [ ] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/`
      (REQ-01, REQ-02, REQ-07, REQ-20) — **none exists yet**, including for the planning answers
      and decisions themselves. `tcg-scrum` owns that write path
- [ ] REQ-01, REQ-02 and REQ-07's flags cleared by reading `payroll/codingcops-rule-matrix.md` §B
      `PR-009`–`PR-015` and `payroll/erp-payroll-module-frd/03-…` `PR-006`–`PR-011` against them
      (~27 KB, no client needed) — see §0, *Precedence*
- [x] **Q15–Q17 answered `2026-08-24`** — `Decimal(10,4)`; U4 reviewed by tests + U2's preview;
      backfill aborts on null `craftCodeId`
- [ ] Q2, Q3 and Q6 answered by TCG, or explicitly deferred — none blocks this epic
- [ ] Decomposed into vertical units — `units.md`

**Note for the decomposer:** every requirement in this spec is `[UNVERIFIED]` or `[CONFLICT]`;
**none is `[VERIFIED]`**. The requirements resting on a planning answer alone, with no decision
note behind them, are `[UNVERIFIED]` on a single jira-kind source — REQ-05, REQ-09, REQ-14 and
REQ-28 most of all. **REQ-10 is no longer the reversibility risk it was**: Q1 moved it onto the
better-sourced side, where four independent sources agree. The two to weigh hardest now are
**REQ-20** (built on a working decision that stands against the MLA's contract text) and **REQ-19**
(built on a *reading* of the only `[VERIFIED]` decision in the epic, unconfirmed by the people who
took it). Both are cheap to reverse in code and expensive to reverse in paid wages.

Answered by: ______________  Date: ______________
