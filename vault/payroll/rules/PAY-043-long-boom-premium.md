---
id: PAY-043
title: PAY-043 — Long-boom premium
section: E-guarantees-special-pay
status: open
updated: 2026-08-24
tags: [module/payroll, kind/rule, open-questions]
---

# PAY-043 — Long-boom premium

**Rule:** Apply tiered premium and qualifying minimum.

**Applies to:** Eligible operators/oilers. **Trigger:** Qualifying boom length is used.
**Requires:** Boom length; crane type; classification; time window.

## Sources

- **Matrix** (spine): [codingcops-rule-matrix.md](../codingcops-rule-matrix.md) `PR-043` — baseline: *Partial baseline*
- **FRD** (target design): [06-boom-equipment-and-guaranteed-hours.md](../erp-payroll-module-frd/06-boom-equipment-and-guaranteed-hours.md) `PR-026` — ⚠️ FRD numbering ≠ matrix numbering
- **Legacy engine**: [rules-plain-language.md](../legacy-payroll-app-db-extract/rules-plain-language.md) §5
- **Contract**: [02-article-iv-classifications-and-wage-rates.md](../mcog-l12-mla-2025-2028/02-article-iv-classifications-and-wage-rates.md)
- **Test cases**: [rule-examples-catalog.md](../rule-examples-catalog.md) — long-boom rows

## Open

- **Blocking (matrix):** Confirm equipment source data
- **Conflict:** Into-the-rate vs on-top (see PAY-011); boom-length arithmetic not in the legacy engine.
- **Open contract doubt from the client's own message:** *"I don't think there is triple time for long boom mentioned in the labor union contract. I'll have to ask Corrina."* — never resolved in the thread. Yet the crosswalk implements **LBT (boom triple, Temp Rate = 3× premium) as CURRENT**, and the ADP sheet has an LB TRI column. Note: under the MLA's *into-the-rate* clause (boom adder "shall be the base rate when computing overtime"), holiday ×3 would naturally produce boom-at-3× — so LB TRI's legitimacy rides on the PAY-011 into-rate adjudication. Ask: did Corrina ever answer?
- **Nuance vs the client's blanket "as if actually worked":** the long-boom gap pays the **boom adder only** (not base + adder) at the boom slices' multiplier — the base hours were already paid; the guarantee tops up boom alone. His doctrine simplifies here; the engine's version is the precise one.
- **LB triple operationalized (July):** TCG **added the "long boom holiday (triple time)" code** (`LBT`) to ADP — after Brian's message doubting the contract supports it. Practice has now committed; the open ask flips from "does it exist?" to "**show the contract basis / Corrina's confirmation that motivated adding it**" — which also feeds the into-the-rate adjudication (PAY-011).
- **Time-scope contrast now explicit:** long-boom premium = **boom-window slices**; lattice premium (PAY-044) = **the entire job** (Corrina, message 20). Different scopes, and they stack — the ERP must not share one eligibility window between them.
- **Contract basis for LB TRI located:** the MLA's into-the-rate clause (boom adder becomes base when computing overtime — quoted verbatim in the attribution register) makes holiday ×3 apply to base+boom, so `LBT` is contract-derivable; the July code addition operationalized it. Question closed; the composition decision note will cite this.
