---
id: PAY-047
title: PAY-047 — Worked-through-lunch adjustment
section: F-contributions-other
status: open
updated: 2026-09-07
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-047 — Worked-through-lunch adjustment

**Rule:** Create explicit WTL pay component and exceptions.

**Applies to:** Eligible L12 employees. **Trigger:** Expected meal is worked or WTL token indicates missed meal.
**Requires:** WTL token/meal record; day type; rate.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-047` — baseline: *Existing baseline*
- **FRD** (target design): [07-rest-meal-and-subsistence.md](../erp-payroll-module-frd/07-rest-meal-and-subsistence.md) `PR-036` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §10
- **Contract**: [01-article-iii-working-rules.md](../mcog-l12-mla-2025-2028/01-article-iii-working-rules.md)
- **Test cases**: [rule-examples-catalog.md](../rule-examples-catalog.md) — WTL rows

## Open

- **Blocking (matrix):** Confirm contract interpretation by day type
- **Conflict:** Contract interpretation **by day type** unconfirmed (matrix open decision); the payroll team’s own lookup: `../wtl-charts.md`.
- **Client message 2026-06-10 ("WTL priced automatically at double time") — agrees, and the vault is more precise.** Extract §10 + `cfg.WTL_Rule` row `L12_WTL_2025`: *taken* meal → `WTL_MEAL_DEDUCT` removes the whole priced slice (base+shift+boom × multiplier); *worked-through* meal → `WTL_APPLICABLE_ADD` = 0.5 × (base + shift) × 2.0 — **boom excluded, per explicit config `BASE_PLUS_SHIFT_EXCLUDE_BOOM`** — with `WTL_DT_FLOOR` topping weekday ST-start blocks to ×2.0. The client's screenshot reproduces the extract's own worked example to the cent: +$69.03 = 0.5 × (66.03 base + 3.00 shift-2) × 2.0 (entry 84393); slice $111.42 = (66.03 + 3.00 + 5.25 boom `OP-BP-07`) × 1.5.
- **Contract question raised by the asymmetry:** deduct includes boom, add excludes it — deliberate in config, but is boom-exclusion from the WTL premium MLA-compliant/intended? Sits alongside this rule's open day-type interpretation.
- **Production-scale token failure (exhibit + distinct-codes data):** the drug-test ticket's comment — *"(NO LUNCH TAKEN - 0.5 DBL 1st WTL + 0.5 DBL 2nd WTL)"* — is prose, not the `(PAY:WTL_n)` token the parser needs. Production counts: **9,297** "no WTL token found; assuming WTL_0" warnings; **16,106** meal deducts (**−$669,283.56**) vs only **411** worked-through adds (+$27,493.92). The human wrote the correct outcome in words; the engine reads *no token → meals taken → deduct*. Either payroll fixes these by hand today, or worked-through meals are being systematically deducted. **ERP fix is structural:** the Atom app captures Take Lunch / WTL as data with customer authorization (US-11), retiring comment tokens entirely — this exhibit is the justification.
- **Client's two-type taxonomy (added-hours message):** Type 1 = the worked break itself — placed at the actual break time when known, else at the 5-consecutive-hour schedule (✅ exactly the engine's opportunity placement at 5.0/10.5/16.0/21.5 h); "converted to double time" ✅ matches `WTL_DT_FLOOR` on weekday ST-start blocks. His deduct-then-add-back framing is ✅ literally the engine's model. Type 2 = the 30-minute penalty add.
- **⚠️ New contradiction — holiday WTL penalty multiplier:** client: *"if the lunch/break is during a triple time period, then it is triple time instead of double"*. Engine as built: `WTL_APPLICABLE_ADD` is a **flat ×2.0** (formula and `cfg.WTL_Rule` both; no ×3 branch exists). On the 9 holidays a worked meal's penalty pays ×2 while surrounding slices pay ×3. Client-stated intent vs as-built — joins the day-type interpretation bundle; the WTL charts + MLA meal clause should adjudicate.
- **The e-ticket already asks for lunch times** (items 9–12: "enter time here… Lunch 12 pm to 12:30 pm", plus 2nd/3rd/4th) — the "what time" wish is on paper today, but answers land in a checklist and comments, never as structured data the engine can read. The token failure (9,297 warnings) coexists with a form that collects the right information in the wrong place.
- **Practice data point for the ×3 question:** TCG's July ADP changes extended holiday-**triple** treatment to premium families (LBT added; a holiday code changed). The client's claim that the WTL penalty goes ×3 in triple-time periods now has operational-practice support — the engine's flat ×2.0 increasingly reads as the defect, not the rule. Still needs the written adjudication (question 18).
- **CONFLICT RESOLVED — the engine was right (four sources):** MLA Meal Periods §1: worked meals *"paid at **double (2) time the straight hourly rate**, in addition to the minimum pay requirements"* — a flat 2× penalty. The 08-20 SME call gives the precise model: the **first** missed lunch's worked half-hour is *absorbed* (bumped to ≥DT, stays at TT if already TT — Jonathan Aldridge example); each **additional** missed lunch *adds* a new half-hour at DT on top (Travis Garrett, 13.5h worked → 14.0h paid). The WTL charts state the same ("1st DBL WTL already included; additional penalties added"). Brian's message-13 "×3 for Type 2" conflated Type 1's stays-at-triple with the penalty add. Engine = charts = contract = SME. Remaining open here: only the ADP representation (gap D-004 — line-item on the primary row, Corrina's proposal).
- **Shadow-mode revelation (08-20):** the app's numbers are **recommendations; the manual entry still ships** — so the 16,106 deducts / −$669k are shadow calculations, not payments. No underpayment implied; the token failure is a data-quality tax on the recommendation engine, and the ERP replaces the manual path with the (now four-source-verified) rule.
- **Order of operations, verified in the 2026-09-07 backup ([legacy-payroll-app-db-backup-2026-09-07/INDEX.md](../legacy-payroll-app-db-backup-2026-09-07/INDEX.md)):** `usp_Apply_WTL_MealPeriods`
  now sources its slices from `v_UI_Pricing_Slices_PayrollEffective` — the rest-adjusted view — so
  the deduct basis `FULL_SELECTED_PRICED_SLICE` is priced after the rest floor. Rest before WTL.
  `cfg.WTL_Rule` itself is unchanged (2026-05-25 row); Brian's WTL rework is still pending.
- **"Paid straight through" is not a WTL variant the ERP will price (2026-09-03 call):** all lunches
  marked taken with no times, no customer signature, no penalty, paid start to end — Wes Staley:
  *"I don't think that we can put this in our system. It's illegal."* Decision note
  [../../decisions/2026-09-03-paid-straight-through-not-in-erp.md](../../decisions/2026-09-03-paid-straight-through-not-in-erp.md). Brian Petros 34:20 restates the rule this file prices: a worked-through
  30 minutes is **double time, triple on a holiday**. Self-signed WTL only with a stated reason
  (Corrina 12:59). Union clarification (Brian's questions) and labor-law counsel (Wes) are pending
  on TCG's side; nothing here changes until they land.
- **Client-authored worked example for a *taken* meal (2026-09-11, `___LUNCH-BREAK_SCENARIOS.xlsx`
  sheet *#1 example (2)* — [../lunch-break-scenarios-2026-09-11.md](../lunch-break-scenarios-2026-09-11.md)):** TCG prices the deduct
  **at the bucket the meal falls in** and **at the whole priced slice including boom** — $42.00 for a
  10:30 AM meal in ST with boom running, $60.00 for a 4:00 PM meal in OT after boom ended, on an
  $80.00 base / $4.00 boom shift. That is `WTL_MEAL_DEDUCT`'s `FULL_SELECTED_PRICED_SLICE` basis,
  now asserted by the client rather than only read out of the legacy engine. **Two things it does
  not answer:** whether boom is *multiplied* inside the deduct — the legacy formula is
  `(base + shift + boom) × multiplier`, which would price an OT-with-boom meal at $63.00, while the
  sheet's own grid prices an OT-with-boom *worked* slot at $62.00 (flat adder, per
  [../../decisions/2026-08-25-boom-adder-on-top-unmultiplied.md](../../decisions/2026-08-25-boom-adder-on-top-unmultiplied.md)); the example places meal 2 thirty minutes
  after boom ends, so it never tests the case. And the sheet's stated total ($1,012.00) deducts the
  first break twice — the method gives $1,054.00. Both raised with TCG 2026-09-11, unanswered.
