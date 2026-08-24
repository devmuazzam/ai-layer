---
id: PAY-047
title: PAY-047 — Worked-through-lunch adjustment
section: F-contributions-other
status: conflicted
updated: 2026-08-24
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
