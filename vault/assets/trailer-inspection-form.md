---
title: Trailer inspection form — the paper checklist, version 1
source: shared-folder/Project-Repository-2026-09-04/1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/TRAILER INSPECTION  FORM (version 1).xlsx
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/assets, module/field-ops, kind/source, inspections, safety, signatures]
entities: []
---

# Trailer inspection form

**What this is.** TCG's paper trailer-inspection checklist, from the
`TCG_FORMS_(paper_and_electronic)` folder — the drop's collection of forms the ERP is expected to
replace. One sheet, 65 rows, laid out for printing: underscore blanks for the truck and trailer
numbers, `q`-prefixed checkbox rows (the Wingdings box, flattened to `q` by the text conversion),
and a name / signature / date block at the foot. **Undated, marked "(version 1)".**

> **Routing note.** This sits in `assets/` because it arrived with the fleet material and its
> subject is a trailer — an asset. Its *use* is a field inspection, so it also carries
> `module/field-ops`. If the vault is ever re-routed by use rather than subject, it belongs there.

---

## The form

**Header:** `Truck Number: ______` and `Trailer Number: ______` — two identifiers, so an inspection
is against a **tractor/trailer pair**, not a single unit.

### Truck column — 5 items

- Be sure king pin locks
- Do not jack knife truck and trailer as to cause damage to either truck or trailer
- Make sure you have your assigned winch bar
- Extras chains and binders as needed
- Over sized load signs as needed

Note that these are not all *checks* — two are instructions ("do not jack knife…", "make sure you
have your assigned winch bar") sharing the same checkbox as the inspection items.

### Right Side / Left Side — the same 12 items, checked twice

`Clearance lights` · `Mud flaps` · `Tires` · `Trailer chains` · `Landing gear` · `Tie downs` ·
`Glad hands` · `Turn Signals` · `Brake lights` · `Running lights` · `Load secure` · `Oil in hubs`

**The item list is identical on both sides and both must be ticked** — so the data model is
(item × side), not item. 24 checkboxes, not 12.

### Tractor with Trailer Checklist — 8 items

- Load is properly secured
- Flags and/or beacon lights with signage applied accordingly for oversized load
- Tractor & trailer brakes are engaged **(when parked)**
- Tires are turned away if on an uphill or towards curb if on downhill grade
- Tires are chocked **(no matter if on flat or sloped ground)**
- Dunnage under landing gear **(when trailer is dropped)**
- Tractor put in low gear and shut down **(when parked)**
- Chocks and/or dunnage is picked up and loaded **(when not in use)**

Six of the eight are **conditional** — parenthesised on the form as *(when parked)*, *(when trailer
is dropped)*, *(when not in use)*, *(no matter if on flat or sloped ground)*. The form does not say
whether a non-applicable item should be ticked, left blank, or marked N/A. Any digital version has
to answer that; the paper one does not.

### Foot

`Comments:` (free text) · `Name: ______` · `Signature: ______` · `Date: ______`

**A signature and a date, no time.** No pass/fail verdict, no defect field, no photo, and no place
to record which items failed — the only failure channel is the free-text `Comments` box.

---

## What it does not say

- Who inspects, how often, or whether this is per trip, per day or per job.
- What happens when an item fails. There is no deficiency, out-of-service or follow-up field —
  which is the gap the vault's `inspections` material (deficiencies) exists to close, and this form
  predates any of it.
- Whether the trailer number is the FCC unit code. TCG's trailers *do* carry codes —
  `36001 OL`, `26502 .3` and so on, catalogued in
  [crane-fleet-reference.md](crane-fleet-reference.md) §4 — but the form is a blank line, not a
  lookup.
- What "version 1" supersedes or is superseded by. No other version is in this drop.

---

## Source

`1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/TRAILER INSPECTION  FORM (version
1).xlsx` — one sheet (`Sheet1`, A1:L65), converted by per-sheet row dump. Reproduced above in
full; the source has no data rows, only the blank form.
