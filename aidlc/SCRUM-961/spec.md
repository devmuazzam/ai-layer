# Spec — SCRUM-961 Craft code form: remove unbacked controls, expose wage group, consolidate rate editing

> **Backfilled 2026-09-01, after the code was written.** This is not a pre-build spec and
> should not be read as one. The work began as an ad-hoc cleanup with no ticket; it hit the
> escalation rule in `GUIDE.md` §2 partway through — *"any path becomes Path A the moment
> you have to decide something nobody specified"* — and the ticket plus this file were
> created retrospectively so the decision and the open questions have a durable home.
>
> Two escalation triggers fired: a product decision about subsistence (§11), and a change to
> an API response shape (`CRAFT_CODE_SELECT`, both craft-code DTOs).

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-961`, child of epic `SCRUM-926` *Craft code* |
| Path | A by escalation — began as C |
| Branch | `feat/craft-code-form-cleanup` — **does not follow `feat/SCRUM-###-…`**, created before the ticket existed |
| PR | [#446](https://github.com/TheCraneGuys/craneguys-platform/pull/446) |
| Commits | `a7ad86c1`, `1f26a4d3` |
| Review | `review-pr` skill, 2026-09-01 — verdict *ship*, after the §11 decision closed the one Conflicted finding |
| Open questions raised | 3 — §12 Q1–Q3 |

## 1. What shipped

Five controls on the craft-code create/edit form had **no backing column**. They lived in a
client-side `extrasById` map, were sent to no endpoint, and were lost on refresh: Eligible
Roles/Assets, Prevailing wage + Jurisdiction, Per diem / subsistence eligible, and Billing
linkage. All removed, with the now-unused `CraftChipPick`.

| Change | Why |
| --- | --- |
| `label` and `description` split into two fields | One input labelled *"Craft Name / Description"* was bound to `label`; `description` was never captured, though the API accepted it |
| `wageGroup` exposed, DTO → service → `CRAFT_CODE_SELECT` | On the model and read by `CraftRateResolverService`, but in **no DTO** — unsettable through the API, not just the UI. Only Group 6+ earns the lattice-boom premium |
| Rate ST / effective-date / OT inputs removed from the dialog | `CraftCodeRatesPanel` already had the complete form. The dialog held a worse subset and **silently rewrote the current rate's `effectiveFrom` on every craft edit**. The OT input could never persist — `CraftCodeRate` stores only `baseRate`, OT/DT are derived |
| Edit action per rate-history row | Restores editing, which removing the dialog path would otherwise have taken away |
| `UpdateCraftCodeRatePayload` retyped | Was `Partial<CreateCraftCodeRatePayload>`; its `effectiveTo?: string` could not express *"clear this"*, so an end date could be set and never removed |
| Union picklist returns `kind` | So the form can tell `NON_UNION` from `UNION` |
| 9 `data-testid` added, `payroll-craft-codes-*` | Per the `apps/web/CLAUDE.md` contract. None collided; no `qa-automation` spec referenced any |
| Wage group validated against its tuple on submit | The dropdown constrains it; form state holds a string, so the value is now checked |

## 11. The decision this ticket made

**Subsistence eligibility is not an attribute of a craft code.** Decided by Syed Haris,
2026-09-01. Full note: [`vault/decisions/2026-09-01-subsistence-not-a-craft-attribute.md`](../../vault/decisions/2026-09-01-subsistence-not-a-craft-attribute.md).

It supersedes the per-craft *"eligible for subsistence"* modifier described in
`vault/meetings/transcripts/2026-08-13-payroll-process.md:127`, and Kyle Harlow's ask at
18:07 to expand it to short / long / custom. Recorded because the next reader of that
transcript will otherwise put the control back.

## 12. Open questions — the stop-and-ask list

### Q1 — Should `wageGroup` be hand-editable, or derived from the craft code?

- **Question:** the form now offers Groups 1–9 as a free choice. The FCC seeder instead
  *derives* it, parsing `-G4-` out of the code (`inferWageGroup`, `fcc-seeder/src/lib/link-craft-codes.ts`).
  Two sources of truth for a payroll-significant value — Group 6+ gates the lattice-boom
  premium (PAY-044).
- **Why it cannot be answered from what is written:** MLA Article IV defines Groups 1–9 and
  the Group 6+ premium, so the *range* is sourced; nothing says who sets it. Searched
  `payroll/rules/`, `payroll/INDEX.md`, `mcog-l12-mla-2025-2028/`.
- **Blocked:** nothing shipped. Blocked for deciding whether a hand-set value that disagrees
  with its code is a validation error.
- **Owner:** Corrina Bustos, or whoever owns the FCC craft import.
- **Status:** open

### Q2 — How is a rate removed once entered by mistake?

- **Question:** there is no delete or archive for a `CraftCodeRate`. Editing covers a typo,
  but not a row that should never have existed.
- **Why it cannot be answered from what is written:** no DELETE endpoint exists, and
  `CraftCodeRate` has no `archivedAt` — so honouring
  [`decisions/2026-08-20-archive-instead-of-delete-app-wide.md`](../../vault/decisions/2026-08-20-archive-instead-of-delete-app-wide.md)
  needs a schema change. Underneath sits a real product question nobody has answered: what
  happens to a rate already used in a **calculated** payroll period? Removing or editing it
  retroactively changes what someone was paid.
- **Blocked:** rate correction beyond an in-place edit.
- **Owner:** product, with payroll.
- **Status:** open

### Q3 — Does any union craft exist that is covered by the agreement but never eligible for subsistence?

- **Question:** the residual form of the §11 decision. If such a craft exists, something
  needs to express it — though probably still not the craft code.
- **Why it cannot be answered from what is written:** **provisionally answered — no.**
  MLA Article V names no classification (grepped for group/craft/operator/oiler/apprentice/
  mechanic — no hits). Article III §2 *"Craft Pay Rate"* is the only other subsistence
  mention in the extract, and its variable is *"the building trades craft with which they
  are working"* — another trade's agreement on that job, not the employee's own. **Caveat:**
  our copy is headed *"Payroll-relevant sections only"*, so it is an extract, not the whole
  contract. And an agreement is a floor — TCG may pay more by past practice or individual
  employment agreement, which is exactly what Kyle Harlow described at 20:34.
- **Blocked:** nothing. Left open because "the extract says no" is weaker than "someone who
  runs payroll says no".
- **Owner:** Corrina Bustos — for what is *paid*, not for what is *owed*.
- **Status:** open — needs confirmation
- **Update 2026-09-04 (Project Repository ingest):** the caveat above is lifted. The **complete**
  Truck Crane MLA 2025–2028 is now in the vault as clean Word text —
  `.ai/vault/payroll/mcog-l12-mla-2025-2028/truck-crane-mla-2025-2028-full-text.md` (17 articles,
  Appendix A, camera MOU) — and Article V *Subsistence Allowance* §1 reads *"Employees covered by
  this Agreement who are required by the Employer to remain away from home overnight will be paid
  a subsistence allowance"*: no classification, group or craft is named anywhere in the article,
  and the only other subsistence clause (Article III, *Craft Pay Rate*) still keys on the building
  trades craft being worked with, not on the employee's craft. So the whole contract, not just an
  extract, says no craft is excluded. Still open for the reason already given — Corrina Bustos has
  to say what is *paid* by practice.

## 13. What this deliberately does not specify

- Whether `source` should be clearable on a rate edit — `UpdateCraftCodeRateDto` types it
  `string` with no null. Pre-existing; not touched.
- Whether the removed *Prevailing wage* control belongs anywhere else. Certified payroll is
  triggered per project (quote terms: $500/project + 3% per trip after the first), so if it
  returns it is not on the craft — but that is not this ticket's call.
- Whether `roleType` should allow more than one value. MLA Groups 7 and 9 each span two
  roles (*Operator … Shop Foreman*; *Heavy Duty Repairman and/or Welder … Operator*), and
  the resolver treats role as binary — `roleType === 'OPERATOR' ? operatorAdder : oilerAdder`
  — so a `MECHANIC` craft silently receives the oiler boom adder. FCC sidesteps this with a
  separate `L12-HDR-A` craft. Noted, not addressed.
