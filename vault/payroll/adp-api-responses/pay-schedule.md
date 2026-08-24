---
title: Live ADP response — pay schedule for company 4RZ
source: live-api/GET https://api.adp.com/payroll/v1/pay-schedule/payroll-groups/4RZ
migrated: 2026-08-13
updated: 2026-08-13
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, adp, reference-data]
entities: [pay-period, payroll-cycle, adp-api, adp-company-code]
part_of: payroll/adp-api-responses/INDEX.md
---

# Pay schedule — company `4RZ`

**Captured 2026-08-13**, production.

```
GET /payroll/v1/pay-schedule/payroll-groups/4RZ
```

27 periods returned, `2026-21` through `2026-47` — **2026-05-09 to 2026-11-13**. Roughly ±13
weeks around the request date, not a full year. The window presumably rolls.

---

## 1. Saturday–Friday — verified

**The vault's most-repeated spine fact is confirmed against production for the first time.**

| Period | Start | End | Expected pay date | Status |
| --- | --- | --- | --- | --- |
| `2026-21` | **Sat** 2026-05-09 | **Fri** 2026-05-15 | **Thu** 2026-05-21 | COMPLETE |
| `2026-33` | **Sat** 2026-08-01 | **Fri** 2026-08-07 | **Thu** 2026-08-13 | COMPLETE |
| `2026-34` | **Sat** 2026-08-08 | **Fri** 2026-08-14 | **Thu** 2026-08-20 | **OPEN** |
| `2026-35` | **Sat** 2026-08-15 | **Fri** 2026-08-21 | **Thu** 2026-08-27 | NOT_STARTED |
| `2026-47` | **Sat** 2026-11-07 | **Fri** 2026-11-13 | **Thu** 2026-11-19 | NOT_STARTED |

Every period is exactly **7 days, Saturday to Friday**, without exception across all 27.

This corroborates [../INDEX.md](../INDEX.md) — *"The pay period is Saturday–Friday. Legal and
operational. Every accumulation is within it"* — and **PR-010**, which states the legal workweek
is Saturday–Friday for non-union California overtime. Those were design assertions sourced from
TCG documents; they now have independent confirmation from the payroll system itself.

**Pay date is always the Thursday six days after period end.** So the processing window between
the period closing (Friday) and money moving (Thursday) is six days. That is the whole operational
budget for: ERP calculation, submission, practitioner review on the Paydata page, and payroll
processing.

## 2. `payPeriodID` — use ADP's key, don't invent one

```
"payPeriodID": "2026-34"
```

Year plus sequential period number. **This is the batch key the ERP should adopt.**

Earlier guidance in [../adp-integration-capabilities.md](../adp-integration-capabilities.md) was to
invent a deterministic `payrollProcessingJobID` such as `TCG-2026-W33`, because the pay-data
success response carries no identifier and the job ID is the only correlation handle the ERP owns.
That still holds — but **it should be built from ADP's `payPeriodID`, not from an ERP-side week
number**, so that the string a practitioner sees in Workforce Now matches the period ADP itself
names.

Note the numbering is ADP's own sequence, not ISO week numbers. Do not compute it — read it.

## 3. ⚠ `payPeriodStatus` is not the gate the pay-data API checks

Three values observed, and **exactly one period is `OPEN` at any time**:

| Status | Meaning | Count on 2026-08-13 |
| --- | --- | --- |
| `COMPLETE` | period closed | 13 |
| **`OPEN`** | the current period | **1** (`2026-34`) |
| `NOT_STARTED` | future | 13 |

**But this is a different vocabulary from the one that gates submission.** The Payroll Data Input
guide says a `pay-data-input.modify` request is rejected unless the **payroll cycle** is in:

> *Entering Payroll* · *Correcting Input*

Neither string appears here. `OPEN`/`COMPLETE`/`NOT_STARTED` describe the **pay period**; *Entering
Payroll* / *Correcting Input* describe the **payroll cycle**, which is a separate state machine
inside Workforce Now that advances as the practitioner works.

**So `payPeriodStatus: OPEN` does not guarantee ADP will accept a batch.** It is a necessary
precondition, not a sufficient one. A submission into an `OPEN` period whose cycle has moved past
*Correcting Input* still fails — with `eventContext/payrollGroupCode is invalid`, the same message
returned for a wrong company code.

**No endpoint found so far exposes the payroll cycle status.** Recorded in
[payroll/gaps.md](../gaps.md).

## 4. Response shape

One object per period, each carrying its own `payScheduleID`:

```json
{ "payrollGroupsPayPeriods": [
    { "payrollGroupCode": "4RZ",
      "payScheduleID": "9204482677638_241152",
      "payCycleCode": { "code": "Weekly" },
      "payPeriods": [ { "payPeriodID": "2026-34",
                        "payPeriodStartDate": "2026-08-08",
                        "payPeriodEndDate":   "2026-08-14",
                        "payPeriodStatus": { "code": "OPEN" },
                        "expectedPayDate": "2026-08-20" } ] } ] }
```

`payPeriods` is an array but always contains exactly one element — the grouping is one wrapper per
period, not one wrapper per group. Don't write a loop expecting many periods per entry.

**`payScheduleID`** is `9204482677638_` plus an incrementing suffix (`241112`, `241114`, …,
`241221`). The increments are irregular — 2, then 3, then 5–6 — so **other schedules are
interleaved in the same sequence**. Not `4RY`'s, though: see below.

## 5. Ventura `4RY` has no payroll schedules at all

The same call for `4RY` fails:

> `"messageText": "Label not found, missing following key: No payroll schedules found for company code: 4RY"`

**A company with no pay schedule cannot run payroll.** Combined with the other evidence — no
worker in [workers-list.md](workers-list.md) carries `payrollGroupCode: 4RY`, and no worker sits on
location `VEN` — the reading is that **`4RY` is a configured but dormant company code**.

That does not fully close the question. The worker list was one page, and a company can exist for
future use or hold historical data. But it does mean **the ERP does not need multi-company
submission today**: there is exactly one company that can accept pay data, and it is `4RZ`.

## 6. ⚠ A second, incompatible error envelope

The `4RY` failure returns a **different shape** from the `403` recorded in
[codelist-worker-management.md](codelist-worker-management.md):

| | Code-list APIs | Pay-schedule API |
| --- | --- | --- |
| Root key | `confirmMessage` | **`_confirmMessage`** (leading underscore) |
| Request id | `confirmMessageID.idValue` | `messageID` **and** `requestID` |
| Timestamp | `createDateTime` (ISO 8601 UTC) | `messageDateTime` (**`Thu Aug 13 12:47:29 EDT 2026`**) |
| Status | `requestStatusCode.codeValue` | `requestStatus` (bare string) |
| Messages | `resourceMessages[].processMessages[]` | `messages[]` (flat) |
| Machine-readable code | `processMessageID.idValue` | **`messageCode: null`** |

**This corrects earlier guidance in this folder.** The advice to branch on `processMessageID` holds
only for the code-list family. The pay-schedule API has no equivalent — `messageCode` is `null`,
and the only discriminator is `messageText`, which is prose.

So the ERP needs **two error parsers**, and for at least one family it has no choice but to match
on human-readable text. Also note the non-ISO timestamp (`EDT`, not UTC) — do not feed it to a
standard date parser.

Both envelopes share one quirk worth knowing: the prefix **`"Label not found, missing following
key: "`** is generic ADP boilerplate wrapped around the real message. It appears here in front of
*"No payroll schedules found…"* and in the guide in front of the invalid-AOID message. Strip it
before showing anything to a user.

Both also leak the internal host `pulsar-marketplace-prod.es.oneadp.com` in `links[].href`. Do not
persist or display it.

**No `meta` or `confirmMessage` wrapper** on this response, unlike `/hr/v2/workers`. Envelope shape
is not consistent across ADP APIs; don't write one generic response parser.

`payCycleCode.code` is the literal string `"Weekly"` here, whereas the worker record uses
`payCycleCode.codeValue: "W"`. **Same concept, two encodings, two field names.**

---

## What the ERP should do with this

1. **Resolve a labour entry's pay period by date**, not by computing week numbers. Anchor on the
   entry's *start* time, per the vault's existing rule about entries crossing midnight.
2. **Check `payPeriodStatus == OPEN` before submitting** — cheap, and catches the obvious case.
3. **Do not treat `OPEN` as permission.** Expect `400` on a closed cycle and surface it as
   "ADP is not accepting input for this period", not as a data error, because the message is
   indistinguishable from a wrong company code.
4. **Build `payrollProcessingJobID` from `payPeriodID`**, so ERP batches and ADP periods share a
   name.
5. **Cache the schedule.** It changes rarely and the window is ±13 weeks; re-fetch weekly, not per
   submission.
