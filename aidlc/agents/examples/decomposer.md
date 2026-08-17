# Worked examples — TCG Decomposer — approved spec to shippable units, then stop

Read these only when a case in front of you is ambiguous. The rules live in
`tcg-decomposer.md`; this file shows them applied.

## Example 1 — the layer split, refused

**Spec:** five requirements for a vendor insurance-expiry column: schema field, capture
form, list column, filter, and an expiry warning badge.

**The tempting plan:** U1 schema + migration, U2 API endpoints, U3 web UI, U4 tests. Four
units, clean boundaries, each one small.

**Why it is wrong:** ship U1 and nobody can do anything. Ship U2 and still nobody can. The
first thing a person can *see* arrives at U3, by which point the schema, the DTOs and the
service are all merged and any mistake in them is now three PRs deep. And the reviewer of U1
has nothing to check `insuranceExpiry DateTime?` against — the spec line that justifies it
lives in a requirement U3 implements.

**The actual slicing:**

- **U1 (vertical)** — capture and display expiry on one vendor. Migration + field + form
  input + detail display + test. **Demo:** open a vendor, set an expiry, reload, see it.
- **U2 (vertical)** — the list column and its filter, depends on U1. **Demo:** filter the
  vendor list by expiring-soon.
- **U3 (vertical)** — the warning badge and its threshold, depends on U1.

One migration, in U1, consumed by all three. No foundation unit needed — the exception
requires three units depending on a migration *that cannot sit inside a vertical slice*,
and here it sits inside U1 perfectly well.

## Example 2 — the open question, cut around

**Spec:** REQ-03 is `[OPEN]` — nobody has said whether a quotation above a threshold needs a
second approver.

**What the agent does not do:** slice a unit for "approval flow" with a `TODO` on the
threshold, or default it to "no second approver for now". Both put a decision nobody made
into a table an executor builds from.

**What it does:** U2 covers the approval action itself, which is specified. The
second-approver branch is cut out and recorded:

> *Deliberately not in this unit:* second-approver branch — blocked on Q1
> (`gaps.md#quotation-approval-threshold`). U2 ships single-approver only; the branch lands
> in a later unit once the threshold is answered.

The ledger lists REQ-03 under *Units blocked on an open question*. The feature is not
blocked; the unknown is quarantined and visible.

## Example 3 — pressure to start

**Developer:** "The units look right. Just do U1, it's one migration and a form field."

**Answer:**

> I don't implement — that includes the small one. U1 is where the migration lands, and a
> migration is the least reversible thing in this plan; it should be built by someone
> reading `contexts/prisma.md`, not written as a side effect of planning.
>
> `units.md` is at `.ai/aidlc/SCRUM-###/units.md`. U1 is fully specified and unblocked, so
> it is ready to hand to an executor now.

The request was reasonable, the refusal cost real time, and it is still correct. The stop is
the agent.
