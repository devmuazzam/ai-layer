---
title: "L12 craft rates move by one uniform dollar amount across all nine groups — bulk update with a future effective date — decision"
source: decision/client recorded call (Corrina Bustos, 2026-09-03 payroll call) + transcript + published union rate sheets
decided: 2026-09-03
decided_by: Corrina Bustos (Payroll Manager; the engagement directory lists her as HR Manager — [../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md)) stated the rule on the recorded 2026-09-03 "CC TCG ERP System" call at 56:42. Brian Petros (Data Analyst, ERP Project Coordinator) added the effective-dating requirement at 57:21 and 57:44. Ehtesham Anwar (CodingCops Product Manager) committed the build at 56:52 and specified the auto-end behaviour at 58:07; abdulrehman confirmed the arithmetic at 57:08. The published record independently agrees — see *Corroboration* below.
status: verified
resolves: [PAY-008, PAY-010, payroll/gaps.md#annual-craft-rate-change--nine-codes-one-rule-no-bulk-path]
tags: [module/payroll, kind/decision, craft-code, pricing, union-agreement, reference-data, payroll-rules]
---

# Decision

**The annual Local 12 craft-rate change may be applied as one bulk add-amount across all nine
groups, dated forward.** The ERP gets a craft-code bulk rate updater modelled on the one already
shipped in Accounting.

## The rule, in the payroll manager's words

Ehtesham Anwar had demoed the Accounting bulk-rate updater on screen (**55:15–56:35**: *"you enter
the amount. Let's say you say that I need to update all of the values that I select by $15 and you
select all of those that need to be updated"*) and asked whether the same shape fits craft codes.

Corrina Bustos, **56:42**:

> Yes, because all of the groups, so groups one through 9, they always increase in the same dollar
> amount.

That is the answer
[`payroll/gaps.md#annual-craft-rate-change--nine-codes-one-rule-no-bulk-path`](../payroll/gaps.md#annual-craft-rate-change--nine-codes-one-rule-no-bulk-path)
had been waiting for since 2026-09-02: the union prints nine figures each year and the agreement
never *says* the delta is uniform, so only the payroll manager could confirm that "add one amount
to all nine" is a rule and not a coincidence.

## The build, committed on the call

Ehtesham Anwar, **56:52**:

> All right, then this is what we can implement this. Bulk rates update as well.

abdulrehman, **57:08**, pinning the arithmetic:

> So the bulk updation means that would be the addition of their existing value, right, in the
> existing value. Not overriding.

Ehtesham at **57:17**: *"Yeah."* — **the amount is added to each selected rate; it does not replace
it.** A $1.00 update takes 67.03 to 68.03, it does not set every group to $1.00.

## Effective dating — set in advance, previous rates auto-end

Brian Petros, **57:21**:

> And the bulk update would have the ability to identify the ending effective dates, the start and
> the end effective dates.

Ehtesham's first answer (**57:29**) was that the previous rates *"become ineffective immediately"*.
Brian rejected that, **57:44**:

> Yeah, I understand, but maybe we would want to do it in advance. So the new rates go in effect in a
> couple days and we'd want to set those rates in the system. So instead of immediately, so we don't
> have to be up at like 1159 at night or something, we should, I think we'd be able to set like an end
> effective date and start effective date.

Ehtesham Anwar, **58:07**, the agreed behaviour:

> Maybe whenever we are updating the rates, we only get the new effective date. For example, if it's
> in future, automatically the previous ones get updated as well. So for example, today's 3rd for you
> guys, right? So today's 3rd, we enter the new rates with bulk rates update. and we say they are
> going to get effectively added from 10th. Automatically, the previous rates get the date 9th.

Brian, **58:37**: *"Oh, okay, so it would have the start date on there."*

**So the operator supplies exactly one date — the new rates' start — and the system ends the
previous rates the day before.** The July-1 change is entered whenever it is published; it takes
effect on July 1 without anyone being at a keyboard at 23:59 on June 30. This is the same
auto-end-the-day-before behaviour already built and demoed for single-rate effective dating; the
bulk path inherits it rather than introducing a second convention.

# Corroboration — the uniform delta already held for two consecutive years

Corrina's statement is not the only evidence. The published record showed the same pattern before
she confirmed it, which is why this note is `verified` on a single speaker.

- [`payroll/mcog-l12-mla-2025-2028/local-12-wage-notice-2025-08-15.md`](../payroll/mcog-l12-mla-2025-2028/local-12-wage-notice-2025-08-15.md)
  (pp. 1–3) — the 2025-07-01 change. Of the MLA's $6.00 package, **$5.00 went to wages and $1.00 to
  Health & Welfare**, and the notice prints all nine group rates each exactly **+$5.00** on its
  7-01-24 figure (61.03→66.03 … 66.16→71.16).
- [`payroll/mcog-l12-mla-2025-2028/wage-rate-sheet-2026-07-01.md`](../payroll/mcog-l12-mla-2025-2028/wage-rate-sheet-2026-07-01.md)
  (*Revised June 2026, Supersedes August 2025*) — the 2026-07-01 change. **$1.00 of the $5.00
  package on wages, on every group**, 67.03 … 72.16.

Two years, two packages, one uniform wage delta each time. The MLA's own
*Increase Effective Dates* line (7-01-25 $6.00 · 7-01-26 $5.00 · 7-01-27 $4.50, Article IV) governs
the **package**, and the union allocates it across wages and funds by notice — so the amount typed
into the bulk updater is the **published wage allocation**, not the package figure. The 2027-07-01
$4.50 package is not yet split.

# Not decided: the apprentice steps

The MLA derives apprentice rates from Group 5 — *"Based on Group 5 rate"* at 60 / 65 / 70 / 75 / 80
/ 90 % by hours worked (Article IV; recorded in the gaps entry, and matched in practice by FCC's
`FMS_UNION_CRAFT`, where `APP1` = 60 % of G5). **A flat add-amount applied to Group 5 does not
reproduce a percentage-derived apprentice rate**, so the six apprentice steps either need
recomputation from the new G5 or they are not "groups one through 9" at all.

**The meeting did not discuss apprentices.** Corrina's sentence is scoped to groups 1–9 and nothing
on the call extends it. Whether the bulk updater must recompute APP1–6 from Group 5, or whether
apprentice rates are maintained separately, is **unstated** — do not infer it from this note. It is
a one-line question for Corrina Bustos, and it does not block the bulk updater for groups 1–9.

# Effect on the vault

Register edits were made by the calling agent on 2026-09-07, in the same pass. Nothing here is a
handoff.

- [`payroll/gaps.md#annual-craft-rate-change--nine-codes-one-rule-no-bulk-path`](../payroll/gaps.md#annual-craft-rate-change--nine-codes-one-rule-no-bulk-path)
  — **done**, `resolved 2026-09-07`, carrying Corrina's quote and the two-part resolution (the rule,
  and the future-dated bulk path).
- [`payroll/rules/PAY-008-effective-dated-configuration.md`](../payroll/rules/PAY-008-effective-dated-configuration.md)
  — the bulk path must write real effective dates, not "now": a future start with the previous rate
  auto-ended the day before, so a historical recalculation still reads the rate in force on the work
  date. The rule's wider scope (all rules, not just rates) stays `open`.
- [`payroll/rules/PAY-010-l12-union-base-rate.md`](../payroll/rules/PAY-010-l12-union-base-rate.md)
  — already `settled`; unchanged in substance. The base rate is still the effective union craft rate
  for the labor entry's craft code; this decision only settles **how that rate gets maintained**.
- Sources cited above are unchanged and stay `status: unverified` — they are migrated union
  documents, and this decision does not adjudicate between them (they agree).
- Curated meeting notes:
  [`meetings/2026-09-03-payroll-lunch-rules-boom-window-and-rate-updates.md`](../meetings/2026-09-03-payroll-lunch-rules-boom-window-and-rate-updates.md) §4.
- **No vault file body was edited by this note, and no frontmatter was flipped by it.**
