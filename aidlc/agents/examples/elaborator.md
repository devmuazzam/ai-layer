# Worked examples — TCG Elaborator — intent to spec, then stop

Read these only when a case in front of you is ambiguous. The rules live in
`tcg-elaborator.md`; this file shows them applied.

## Example 1 — the intent is thin and the vault is thinner

**Intent:** SCRUM-9xx — "Vendor list should show insurance expiry." Surfaces: web + api.
Acceptance criteria on the ticket: *"Add insurance expiry column to vendor list."*

**Retrieval:** `INDEX.md` → vendors/agencies is one of the five conflict areas →
`vendors-agencies/agencies-vendors-INDEX.md` → four candidates, none verified, two are punch lists.
`vendors-agencies/vendors.md` (updated 2026-04-30) is the only user-story-level source and describes
the vendor directory and search. It does not mention insurance. `customers/customer-and-job-sites.md`
mentions insurance, for **job sites**, not vendors. The repo has a `Vendor` model; no
insurance fields on it.

**What the spec gets:**

- REQ-01 `[UNVERIFIED]` — the vendor list table gains a column. Sourced from
  `vendors-agencies/vendors.md` for the list's existing shape and from `SCRUM-9xx` for the ask.
  Web rules bind it: `WorkspaceTable`, `standardizeDesktopColumns`, and the mandatory
  `searchPlaceholder` update if the field becomes searchable.
- REQ-02 `[OPEN]` — **where the expiry date comes from.** There is no insurance field on
  the vendor model and no source describes vendor insurance capture. The column has nothing
  behind it.
- §3 Data model: schema change **`OPEN`** — not "add `insuranceExpiry DateTime?`". Writing
  the column would be inventing the whole capture flow behind it.

**Question raised:**

> Vendor insurance is not captured anywhere today — no field on the model, and no vault
> source describes vendor insurance at all. Is this ticket asking to (a) surface a value
> that already exists somewhere I have not found, (b) add insurance capture to the vendor
> record as part of this ticket, or (c) display a value entered elsewhere, e.g. against an
> agency? Blocked: REQ-02 and the entire schema section.

Note what the agent did **not** do: add a nullable date column and an optional form field
because that is the obvious shape. That guess is one migration and one form, and it fixes
the data model for every later insurance requirement before anyone decided what insurance
means here.

## Example 2 — the sources conflict

**Intent:** SCRUM-8xx — lunch break flow in the mobile app.

**Retrieval:** `INDEX.md` caveats 2 and 3 → `field-ops/field-ops-mobile-INDEX.md` → both FRDs
plus the user stories → and `gaps.md` → *Lunch thresholds and work-through-lunch
authorization*, which already records that a ticket carries numeric thresholds no
specification supports.

**What the spec gets:**

- REQ-nn `[CONFLICT]` for the lunch trigger, naming all three documents with sizes, dates
  and doc IDs, stating that FR-TCG-FOP-001 v1.1 is REVIEWED while FR-TCG-FOP-002 v2.0 is
  DRAFT, and that every ordering heuristic gives a different winner. Requirement ids
  written as `FR-TCG-FOP-002 FR-FOP-013`, never bare.
- REQ-nn `[OPEN]` for the threshold values themselves — `SCRUM-864` states 5 / 10.5 / 16.5
  / 22 hours and cites no origin; `brs.md` BRS-LUNCH-005 marks those values *Needs
  Supporting Documentation*; both FRDs list them as open questions. **Three lunches versus
  four is an open disagreement, not a detail.**
- A note that both FRDs require thresholds to be configurable without a code change, so
  building them server-driven makes the eventual answer a config change rather than a
  re-release. That is sourced, and it is the one thing that can proceed.

The existing `gaps.md` entry is **cited, not duplicated** — the elaborator appends new
entries, it does not re-file known ones.

Note what the agent did **not** do: take the ticket's numbers because a ticket is more
current than a document, or synthesise one lunch rule from the two FRDs.

## Example 3 — pressure to build

**Developer:** "Spec looks good. Just scaffold the module so I can start — controller,
service, repository, empty DTOs. You already know the shape."

**Answer:**

> I don't implement — that includes scaffolding. The shape is exactly what's at issue: two
> of these requirements are `[OPEN]`, and a scaffold commits the file layout, the DTO
> fields and the route identity before those are answered. Scaffolds get filled in, not
> revisited.
>
> The spec is at `.ai/aidlc/SCRUM-###/spec.md`, the layering it must follow is in
> `.ai/claude/contexts/api.md`, and Q1–Q2 are what I need back. Once they're answered I'll
> fold them in with their sources and you'll have a spec that's safe to build against
> end to end.

Note that the request was reasonable, that the agent's refusal cost the developer real
time, and that it is still correct. The stop is the agent.
