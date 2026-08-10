# Units — SCRUM-### <feature name>

> Written to `.ai/aidlc/SCRUM-###/units.md` from the approved `spec.md` beside it.
> Consumed by the decomposer and then by an executor, one unit at a time.
>
> **Skeleton only in this run** — the decomposer agent that fills it does not exist yet.
> The field list is the contract; treat it as fixed.

## What a unit is

A unit is a **vertical shippable slice**: schema → API → web and/or mobile → tests, for one
piece of behavior. It is reviewable on its own and it demonstrates something a person can
see working.

A unit is **not** a layer. "Add the Prisma model", "write the endpoints", "build the UI"
are three-eighths of a feature each, and none of them can be reviewed against the spec —
the reviewer has nothing to check the schema against until the UI exists, by which point
all three are in flight. Layer splits also hide integration failures until the last merge,
which is exactly when they cost the most.

**The test:** if the unit ships alone, what can someone do that they could not do before?
If the answer is "nothing, it's the backend half", it is not a unit. Merge it into the
slice it serves.

Legitimate exceptions, and they are narrow:

- A **schema-only foundation unit** when three or more later units all depend on one
  migration and splitting it per-unit would mean three migrations against the same table.
  Mark it `kind: foundation` and say which units consume it.
- A **shared-types unit** in `packages/shared` under the same condition.

Everything else is vertical.

## Fill rules

Every field is required per unit. **Never delete a field.** Unfilled fields take
`NOT SPECIFIED`, `N/A — <reason>`, or `OPEN — <question>`, as in `spec.md`.

A unit may not depend on an `[OPEN]` requirement. If it does, either the question gets
answered first or the unit is cut down to the part that does not depend on it — and the
cut is recorded in *Deliberately not in this unit*.

---

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | | REQ-01, REQ-03 | schema, api, web | — | S / M / L | not started |
| U2 | | | | U1 | | |

- Requirements not covered by any unit: *list them, with why — usually `[OPEN]`*
- Units blocked on an open question: *list them, with the `gaps.md` anchor*

---

## U1 — <name>

- **Outcome:** *one sentence: what a person can do after this ships that they could not
  before. Not "adds the customer code column".*
- **Kind:** vertical / foundation *(foundation requires the justification above)*
- **Requirements covered:** REQ-nn, REQ-nn — *fully, or name the part*
- **Depends on:** *unit ids, or `—`*

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | | *migration name; `N/A` if none* |
| API (`apps/api`) | | *controller / service / repository files* |
| Web (`apps/web`) | | *route + components; reuse before creating* |
| Mobile (`apps/mobile`) | | |
| Shared (`packages/shared`) | | |
| Tests | | *unit / integration / e2e* |

### Reviewable as

- **Demo:** *the exact thing to click or call to see it work — a route, a request, a screen*
- **Acceptance:** *checked against which REQ acceptance lines*
- **Reviewer can verify without:** *e.g. without U2, without seed data, without a real tenant*

### Risk

- **Migration reversible:** yes / no — *if no, say what makes it one-way*
- **Behind a flag:** yes / no — *name it*
- **Touches existing data:** yes / no — *backfill described where*
- **Blast radius:** *what breaks if this is wrong*

### Deliberately not in this unit

- *thing* — *lands in U*n*, or is blocked on Q*n**

---

## U2 — <name>

*(repeat the block)*

---

## Sequencing

```
U1 ──▶ U2 ──▶ U4
  └──▶ U3
```

- **Parallelisable:** *which units can run concurrently and why they will not collide —
  name the files or tables they share*
- **Merge order constraint:** *e.g. migrations must land in unit order*
- **First unit to ship:** *and what it proves about the rest of the plan*
