---
title: Day-level rate deviations are locked to craft-code amounts, assigned by super/payroll — decision
source: decision/2026-08-20 payroll rules call (Zoom, "CC TCG ERP System", 40 min)
decided: 2026-08-20
decided_by: Corrina Bustos (TCG payroll), confirmed by Brian Petros ("that makes it easier") on the 2026-08-20 call; Abdulrehman (CodingCops) proposed the secondary-craft mechanism. Recorded in payroll/2026-08-20-payroll-rules-meeting-notes.md; corroborated by the 2026-08-21 minutes.
status: verified
resolves: payroll/gaps.md#pay-rate-follows-the-employee-not-the-role-worked--kyle-and-corrina-unrecorded
tags: [module/payroll, kind/decision, craft-code, payroll-rules]
---

# Decision

1. An employee's default base rate comes from their **employee-level craft code**.
2. When an employee works a different craft on a given day, the day's rate is driven by a
   **secondary craft code assigned for that day** — never a free-text dollar override.
   **"Locked to a craft-code amount"** (Corrina Bustos; Brian Petros: "that makes it easier").
3. Only the **crane superintendent or payroll** may set the day's craft/rate — never the
   employee (self-selection "would create extra double-checking").
4. Boom/modifier premiums are unaffected by the override — they ride whichever rate applies.

# Why this resolves the rate-resolution conflict

The 2026-08-13 recording ("he's paid the $70 even as a rigger") described **practice under
the old free-text model**; the 2026-06-09 message and the engine price by labor-row craft.
The decision reconciles both: rates always come from craft tables (labor-side mechanics
preserved), and the *choice* of craft for a day is a controlled human assignment (practice
preserved — a $70 operator stays $70 unless the super deliberately assigns otherwise).
Brian's "higher-of" floor proposal from 08-13 becomes unnecessary under controlled
assignment; if TCG still wants it as a guard, it is a validation warning, not a rate rule.
