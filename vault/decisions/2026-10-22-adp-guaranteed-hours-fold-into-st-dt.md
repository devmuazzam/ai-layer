---
title: "Guaranteed-hours top-ups fold into the ADP ST/OT/DT/HOL columns, no separate earning code — decision"
source: decision/developer direction in Claude Code session, 2026-10-22 (approved by the product owner)
decided: 2026-10-22
decided_by: >-
  Directed in a Claude Code session on 2026-10-22 (branch
  `feat/payroll-adp-guaranteed-hours-fold`) and approved by the product owner the same day.
  Resolves the guaranteed-hours part of ADP-PAYDATA-EXPORT REQ-19 (previously [OPEN], D-002).
  An attribution/representation decision for the ADP file only — it does NOT change what any
  employee is paid; the guaranteed gap hours were already priced and paid. A developer direction,
  product-owner approved; `status: reference` on the same basis as the 2026-10-15 lattice-split note.
status: reference
conflicts_with: []
related:
  - ../payroll/payroll-rules-provenance.md
  - ../../aidlc/ADP-PAYDATA-EXPORT/spec.md
tags: [module/payroll, kind/decision, api, payroll-engine, adp-export]
entities: [PayComponent, PayrollEntryFix]
---

# Guaranteed-hours top-ups fold into the ADP ST/OT/DT/HOL columns

## Decision

On the ADP paydata import file, **guaranteed-hours gap top-ups do not get their own ADP earning
code or their own column.** They **fold into the existing worked-hour columns by the pay bucket
they priced at** — the same rule the rest of the file uses for worked hours:

| Guaranteed top-up priced at | Folds into |
| --- | --- |
| ST (×1) | `Reg Hours` |
| OT (×1.5) | `O/T Hours` |
| DT (×2) | `Hours 3` code `DT` |
| ×3 holiday (H3X) | `Hours 3` code `HOL` |

This covers the **daily 4-hour minimum (PAY-040)** and the **holiday 8-hour minimum (PAY-033)** —
the base-rate guaranteed family.

**Deliberately excluded (still documented gaps, still refused by the pre-export check):**

- **Long-boom 4-hour minimum (PAY-043)** — a *boom adder*, not base hours. It belongs on the LB
  Hours-4 codes, never ST/OT/DT. Left as `(GUARANTEED, NONE)` pending LB routing (follow-up).
- **Special-Saturday 8-hour minimum (PAY-034)** — its ×2 / HDD code is still unconfirmed (D-005);
  stays `(SPECIAL_SATURDAY, NONE)`.

## Why

The guaranteed gap hours were priced and paid, but had no route onto the ADP file — they stamped
`(GUARANTEED, NONE)` and the pre-export validator refused the whole export rather than drop them.
The product owner's direction: there is no separate ADP code and no separate variable for
guaranteed hours — they ride the ordinary ST/DT columns at the rate they were earned, exactly as a
legacy week reports "holiday gap hours as DT."

## Scope — this does NOT change pay

Pay amounts are unchanged. The engine still prices the gap hours identically and still keeps them
out of `stHours`/`otHours`, so the rest-period trigger and weekly-OT are untouched. The only change
is **which ADP column** the already-paid hours appear in.

## How it is built

- Engine (`packages/payroll-engine/src/guarantee.ts`): PAY-040 stamps the bucket the shift left off
  at (`endingBucket`); PAY-033 stamps `H3X`. (Previously both stamped `NONE`.) PAY-043 and PAY-034
  keep `NONE`.
- Exporter (`apps/api/.../payroll/adp-paydata-csv.ts`): a `componentCode === 'GUARANTEED'` component
  folds into the primary row's Reg/O-T/DT/HOL by bucket, on the **primary** row even on an override
  day (the gap is base-rate hours). Buckets `NONE`/`H2X` are not folded.
- Validator (`adp-paydata-validation.ts`): `GUARANTEED` in `{ST,OT,DT,H3X}` no longer refuses;
  `NONE`/`H2X` still do.

## Still open (unchanged by this)

SIC sick hours (Q15, no ERP source), HDD / Special-Saturday ×2 (D-005), and the rest-period /
WTL dollar premiums (no ADP code) remain documented gaps.
