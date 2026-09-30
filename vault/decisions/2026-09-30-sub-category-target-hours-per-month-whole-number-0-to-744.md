---
title: Sub-category "Target Hours Per Month" is optional, a whole number, 0 to 744 (24 x 31), validated on web and API (Syed Haris, TCG-153) — decision
source: decision/Syed Haris (CodingCops developer) — TCG-153, Claude Code session 2026-09-30
decided: 2026-09-30
decided_by: >-
  Syed Haris (CodingCops, developer on the TCG platform team), in a Claude Code session on
  2026-09-30 while reviewing PR branch `fixes/TCG-153` (Linear TCG-153). A
  developer ruling, not a product decision: TCG-153 had flagged this rule as blocked on a
  product / web UX owner, and no product owner has seen or ratified it. Binding on the
  CodingCops build now; open to being revisited by product. Hence `status: reference`.
status: reference
conflicts_with: []
resolves: []
jira: [TCG-153]
tags: [module/assets, kind/decision]
entities: [category, fcc]
---

# Sub-category "Target Hours Per Month": optional, whole number, 0 to 744

## Decision

1. **Optional.** The field may be left blank.
2. **Whole number only.** No decimals.
3. **Cannot be negative.** Minimum 0.
4. **Maximum 744** = 24 hours x 31 days — the most a crane could run if it ran around the
   clock for the longest month. In Haris's words: *"these hours come from if someone works 24
   hours and the crane doesn't stop"*. He first said 24 x 30 = 720, then chose 31 days so no
   real month is excluded, saying the exact cap *"is not that important"*.
5. **Enforced on both surfaces:**
   - **Web** — create and edit sub-category forms; the error shows under the field as the
     value is typed.
   - **API** — class-validator `@IsInt() @Min(0) @Max(744)` on `CreateSubCategoryDto`,
     inherited by `UpdateSubCategoryDto` via `PartialType`.
6. **Error copy, as implemented:**
   - "Enter a whole number of hours"
   - "Target hours per month cannot be negative"
   - "Target hours per month cannot exceed 744 (24 x 31 hours)"

   The copy was chosen by the PR author, not by product. Haris accepted it by testing it.

## Why

- **Nothing in the vault sets a cap, copy or error timing.** The only source for the field
  is the line *"Need to add target hours per month - FCC"*
  (`assets/categories-and-sub-categories.md`, `unverified`). tcg-scrum confirmed before this
  ruling that no vault source states a range, error copy or when the error shows.
- **744 is a physical ceiling, not a business target.** It rejects impossible values without
  guessing at a business range. FCC practice values sit well inside it, at 160–200
  (`field-ops/fcc-nexgen-service-guide.md`:219-220,
  `quotations/fcc-estimate-templates-by-job-type.md`:394, both `unverified`). A tighter
  business cap would need product.
- **Both surfaces validate** so the API cannot store a value the form would reject.

## Not decided here

- **Duplicate sub-category name** — whether a name collision shows an inline field error or
  only a toast — is a separate open question: `assets/gaps.md#duplicate-sub-category-name--inline-field-error-or-toast-only`
  (`assets/gaps.md`:533). This note does not answer it.
- **Any business meaning of the target** (how it is used against actual hours, per-crane vs
  per-sub-category) is not settled.

## Revisit

Decided by a developer, not the product owner. If product sets a different cap, different
copy or a different error timing, that decision supersedes this one, and the web helper and
the API DTO change together.

## Effect on the vault

- `assets/categories-and-sub-categories.md` — **done:** `provenance_note:` added pointing
  here. `status:` stays `unverified`; a developer ruling does not verify the source file.
- No gap entry resolved: no vault `gaps.md` entry or ticket `spec.md` §12 entry exists for
  this rule (TCG-153 has no `.ai/aidlc/` folder).
- Listed in `INDEX.md` → *decisions/* and `assets/INDEX.md` → *Decisions that bind this
  module*.
