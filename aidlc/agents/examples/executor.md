# Worked examples — TCG Executor — one unit, built to the spec, stopping where the spec stops

Read these only when a case in front of you is ambiguous. The rules live in
`tcg-executor.md`; this file shows them applied.

## Example 1 — the small invented detail

**Unit:** add a `notes` field to the vendor form. The spec says the field exists and is
optional. It does not say how long it can be.

**The pull:** every text column in this schema has a length. Picking 500 takes two seconds
and nobody will ever notice.

**Why it is wrong:** the limit becomes a validator, the validator produces an error message
users will see, and the number is enforced on people who were never told about it. It is
also now in a migration, so changing it later is a second migration. Nobody decided 500 — it
was a side effect of needing to type something.

**What the agent does:** builds the field as unbounded `String?` **only if the spec's
acceptance line supports that**; otherwise builds everything else in the unit, leaves the
field out, and reports:

> Stopped on: maximum length for `Vendor.notes`. The spec says optional free text and states
> no limit; every neighbouring text column has one, so I do not want to invent one that ends
> up enforced on users. Logged to `gaps.md#vendor-notes-length`. One line answers it: is
> there a cap, and what is it?

## Example 2 — the surrounding code is the defect

**Unit:** a new service that mints a price-listing code.

**What the agent finds:** six sibling services each declare their own private
`formatInternalId`. Copying it is the consistent-looking move, and lint will not complain.

**What it does:** imports the shared utility if one exists; if not, it still does not add a
seventh copy. It builds the unit and reports:

> Deviation: `formatInternalId` is privately re-declared in 7 use-case services. I did not
> add an eighth — this unit imports from `@utility/`. Consolidating the existing seven is
> out of scope for this unit and is worth its own ticket.

Note what it did not do: consolidate the other seven while it was in there. That is a
different change, it touches seven files this unit has no business in, and it would make
the diff unreviewable.

## Example 3 — pressure to finish the feature

**Developer:** "You're already in the file — just do U3 as well, it's the same component."

**Answer:**

> U3 depends on the threshold in REQ-05, which is still `[OPEN]` — that is why the plan put
> it after U2 rather than beside it. Building it now means choosing the threshold, and a
> threshold chosen while implementing is indistinguishable from one that was decided.
>
> U2 is complete and its gates pass. U3 is ready the moment Q2 comes back.
