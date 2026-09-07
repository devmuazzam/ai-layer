---
id: PAY-043
title: PAY-043 — Long-boom premium
section: E-guarantees-special-pay
status: open
updated: 2026-09-07
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
- **Boom-window scope corroborated by Corrina in a worked example, 2026-09-04:** both of her
  hand-worked long-boom days mark **(Long boom pay)** on the `build up, work, breakdown` segment
  only, never on the drive segments either side of it — including the drive *of the long-boom crane
  itself*. Direct confirmation of the `ArrivedJob → LeftJob` window, and it sharpens the contrast
  with PAY-044 (lattice = the entire job) she drew in message 20. Also note her two-job example
  carries **two separate boom windows in one shift** (`8am-5:30pm` and `7:30-11:30pm`), which the
  engine handles per labor row — but the **4-hour long-boom minimum groups per `ShiftAnchorDate`,
  not per job** (§5), so a two-job day gets one minimum, not two. Both windows exceed 4 hours in
  her example so it never fires; unasked and unrecorded for the case where one of them does.
  Source: [client-message-findings.md](../client-message-findings.md#2026-09-04--long-boom-day-breakdowns-drive-time-included-corrina-bustos-teams).
- **Boom window, Operations' words (2026-09-03 call, Kyle Harlow 45:31–46:02; Corrina Bustos
  45:32 confirms current practice):** boom pay runs **from build-up through breakdown, including all
  hook work**; travel and meeting the customer / walking the job before the machine is set are not
  boom time. A crane already built on arrival is a **holdover** (tower-crane jobs always are) and
  has no build-up. **Multi-job day (Corrina 59:07):** the ST/OT/DT bucket a boom hour falls into is
  decided against the **whole day's work**, not the boom job alone — her worked examples are the
  2026-09-04 breakdowns in `client-message-findings.md`. Decision note [../../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md](../../decisions/2026-09-03-paid-time-boundaries-yard-to-yard.md).
