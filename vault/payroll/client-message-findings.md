---
title: Client message verification — running findings
status: reference
kind: reference
updated: 2026-08-24
tags: [module/payroll, kind/reference, payroll-rules, open-questions]
---

# Client message verification — running findings

One section per verified client message. Each claim: **agrees / contradicts / new** against
the rule register (`rules/`), the live gaps register, and the meeting record. The meeting
sheet ("in this meeting you said X, the rule says Y, your message says Z") is assembled from
the ⚠️ rows.

## 2026-06-09 — Payroll-group determination (Brian Petros)

| Claim | Verdict | Register |
| --- | --- | --- |
| 5 payroll groups, exact predicates (`L12%`, `EmpTypeID=3`, `ADMIN%`+`H/S`, `SYS%`) | ✅ agrees, row-for-row with current-state + extract | PAY-009 |
| Labor-entry craft (not employee craft) prices L12 rows | ✅ agrees with rule + engine — **⚠️ but the 2026-08-13 recording says the opposite; message is the earliest written source. CLIENT QUESTION #1** | PAY-010 |
| Modifier only when selected on labor entry; `PayRateChange` amount | ✅ agrees; adds the selection condition. Into-rate vs on-top still open | PAY-011 |
| `Source_Rate_Raw` audit-only; duration-based fallback with warning | ✅ agrees; confirms extract §13 semantics (fallback → suppress). Which survives in ERP still open | PAY-014 |
| Admin Hourly: `Employee.PayRate`, CA DIR rules, ×40/×2080 approximations | ✅ agrees (approximations verified in `v_UI_Employee_TypeRate.VIEW.sql`) | PAY-012, PAY-025 |
| Admin Salary: may lack PayRate, scope "still undecided" | ✅ matches the rule's open scope | PAY-013 |
| `SYS%` hidden | ✅ agrees — 🆕 written exclusion pattern; current-state describes a broader set (fake/default) — confirm which | PAY-007 |
| Worklist: Active + Inactive-with-labor for the week | 🆕 new detail, consistent with extract | PAY-061 |
| FCC profile screenshot: **"Certified Pay" checkbox** | 🆕 **in no vault document** — certified-pay flag exists upstream today | PAY-072 |
| Union field greyed on profile; union comes via craft | ✅ consistent | PAY-009 |

**Client questions from this message:** (1) rate resolution — app prices by labor-entry
craft (your 2026-06-09 message), practice pays the employee's own rate (Kyle/Corrina,
2026-08-13), Brian proposed higher-of: which ships? (2) exclusion set — `SYS%` only, or
also fake/default? (3) what does the FCC "Certified Pay" checkbox drive today?
