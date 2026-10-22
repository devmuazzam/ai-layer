---
title: First live ADP Pay Data Input POST — 4RZ, three live employees, batch TCGAPITEST20261009 (2026-10-09)
source: syed.haris — ADP-testing Teams chat with Micaela Dipane (2026-10-07 → 2026-10-09, relayed 2026-10-15) and the local run of ~/Desktop/adp-api-test (out/ captured 2026-10-09 19:20 PKT)
migrated: 2026-10-15
updated: 2026-10-15
status: reference
conflicts_with: []
jira: []
tags: [module/payroll, kind/reference, adp, integrations, pay-data-input, temp-rate, boom]
entities: [adp-api, pay-data-input, adp-file-number, adp-company-code, earning-code]
part_of: payroll/INDEX.md
---

# First live ADP Pay Data Input POST — 2026-10-09

The first **write** the team has made to ADP. One `POST pay-data-input.modify` into the live `4RZ`
company, for three live field employees, carrying their week-41 figures. ADP accepted it and the
batch appeared as its own worksheet under *Manage payroll*. Micaela Dipane reviewed it:
*"Everything looks good!"*

Chat times below are as the chat showed them, in **PKT** (UTC+5); TCG is on Pacific time
(PDT, UTC−7), 12 hours behind.

> **The test worksheet was deleted** (syed.haris, 2026-10-15), so nothing from it reached the
> 2026-10-15 pay date. Who deleted it and when were not stated.

---

## 1. How the test was arranged — Teams chat

| When (PKT) | Who | What |
| --- | --- | --- |
| 10/7 2:41 PM | abdulrehman | Asked Micaela for the different worksheet variations TCG imports, *"mainly … field employees worksheets"* |
| 10/8 8:50 PM | syed.haris | No call needed — *"we just need you to be around to delete the test worksheet after we post it"*; asked for a time on **Fri 10/9** (backup Mon 10/12), **2–3 employees** (file number + position ID), and 2–3 saved field-worksheet CSVs with a temp-rate row, long boom and OT/DT |
| 10/8 9:12 PM | **Micaela Dipane** | *"Lets do 8am on Friday"* and named **three live employees**: file **`000288`**, **`000105`**, **`000459`** (position IDs `4RZ000288`, `4RZ000105`, `4RZ000459`). Names are in the Teams thread; not copied here |
| 10/8 10:39–10:46 PM | Micaela Dipane | Dropped `EPI4RZ38`–`41.csv`, *"previously imported into ADP for the field employees. They include temp rates, long boom and the ST/OT/DT hours."* Findings already recorded in [gaps.md](gaps.md) (two 2026-10-08 updates) |
| 10/8 11:09 PM | Micaela Dipane | On the `135.14` row: *"That is a special agreement for that employee."* (recorded in gaps.md) |
| **10/9 7:29 PM** | syed.haris | *"posted the API test batch `TCGAPITEST20261009` to 4RZ for 288, 105 and 459 using week 41 figures"* — should show under *Manage payroll* as a separate worksheet, possibly with digits appended |
| 10/9 7:40 PM | **Micaela Dipane** | ***"Everything looks good!"*** — so the 8am (PT) fallback call was skipped |
| 10/9 7:42 PM | syed.haris | Asked what payroll validates before submitting; *"You can delete this worksheet, I don't have access to delete it."* |
| 10/9 9:15 PM | **Micaela Dipane** | The validation steps — §4 |

**This replaces both earlier test-employee plans.** The 2026-09-28 meeting named dev-team hires
(abdulrehman, syed.haris, Ehtesham); Brian Petros's 2026-10-01 email asked ADP for six dummy hires
(Emily01–04, Marty01–02). Neither was used. **The test ran against real employees**, which is why
deleting the worksheet matters more than it would for an Emily/Marty batch: Jay (ADP, 2026-09-30)
said test data is harmless *"as long as we do not actually Accept or Approve that payroll"* — for a
real employee, an undeleted test batch is a real payment.

## 2. What was sent

Script: `~/Desktop/adp-api-test/adp-test.sh` + `build-payload.py` on syed.haris's machine
(reproduced in the appendix; credentials, token and `out/` are git-ignored there and not copied).

| Step | Call | Observed |
| --- | --- | --- |
| 1 token | `POST accounts.adp.com/auth/oauth/v2/token`, client credentials, **mTLS** cert + key | token issued |
| 2 AOIDs | `GET /hr/v2/workers?$select=workers/associateOID,workers/workAssignments/payrollFileNumber,workers/workAssignments/payrollGroupCode`, paged 100 | **461** `4RZ` file-number → AOID pairs; all three test file numbers resolved. `$select` keeps personal data out of the response |
| 3 cycle | `GET /payroll/v1/pay-schedule/payroll-groups/4RZ` | open period **`2026-42`**: `2026-10-03` → `2026-10-09`, expected pay date **`2026-10-15`** |
| 4 POST | `POST /events/payroll/v1/pay-data-input.modify`, headers `Authorization`, `Content-Type: application/json`, `roleCode: employee` | success, §3 |

**Body** — one event; `eventContext.payrollGroupCode = 4RZ`,
`eventContext.payrollProcessingJobID = "TCGAPITEST20261009"` (the Batch ID); one `payeePayInputs[]`
entry per employee with `associateOID`, `payNumber: "1"`, `payrollFileNumber` (6 digits, zero-padded),
and one `payInputs[]` with `_modificationTypeCode: "Add"`.

**CSV → `earningInputs[]` mapping** used by `build-payload.py`, from the employee's rows in
`EPI4RZ41.csv`:

| CSV column | API line |
| --- | --- |
| `Reg Hours` | `earningCode R` + `numberOfHours` |
| `O/T Hours` | `earningCode O` + `numberOfHours` |
| `Hours 3/4 Code` + `Amount` | that code + `numberOfHours` |
| `Earnings n Code` + `Amount` | that code + `earningsAmount { amountValue, currencyCode: USD }` |
| `Temp Rate` | `rate.rateValue` on every line built from that row |

So each employee went as **one `R`, one `O`, one `DT`, and one line per boom adder rate** —
`LBH` / `LBO` / `LBD`, with several `LBH` lines at different rates for one person. Only the boom
lines carried a `rateValue`; `R` / `O` / `DT` went without one. The three employees' week-41 rows
had no `SUB`, foreman, military or lattice lines, so **none of those were exercised.**

## 3. What came back

- The body is ADP's **success envelope**: `events[0].data.output.payDataInput` — a full echo of the
  input, each earning line padded with empty `memoInputs` / `configurationTags`, each `payInputs`
  padded with empty `codedHoursEarningInputs`, `deductionInputs`, `taxInputs`,
  `reimbursementInputs`, and `"links": []`.
- **No `confirmMessage`, no `confirmMessageID`, no batch identifier.** The echoed
  `payrollProcessingJobID` is our own `TCGAPITEST20261009`, not the name ADP gave the worksheet
  (ADP appends its own characters — request `672204`). This settles the *success envelope* entry in
  [gaps.md](gaps.md): **there is no receipt handle.**
- **Three-decimal temp rates were accepted and echoed unchanged** — `rateValue` `4.875`, `7.875`,
  `10.125` (the ×1.5 boom adders). The open doubt in gaps.md (*money fields allow two*) does not
  apply to `rate/rateValue`, at least at the API. Whether the WFN worksheet kept all three decimals
  was not checked separately; Micaela found nothing off.
- The HTTP status code was printed by the script but not saved. The body is the success shape.

## 4. What payroll does before submitting — Micaela Dipane, 2026-10-09 9:15 PM PKT

Verbatim:

> *"Once the Validation is Pending in ADP, we ensure the balances match in the worksheet vs. the
> ADP_Preview Batch Totals then click Auto Balance, Save, Then Done. After we click done it will
> change the status to "In Balance""*

So a worksheet goes **Validation Pending → (totals checked against `ADP_Preview Batch Totals`,
Auto Balance, Save, Done) → In Balance**. Unverified, one chat message; who produces
`ADP_Preview Batch Totals` and what it totals is not stated. If the ERP is to make that check pass
first time, it must produce the same batch totals itself — an open question for the export, not
answered here.

## 5. Still open

1. ~~Was the worksheet deleted?~~ **Yes** — confirmed by syed.haris on 2026-10-15 (deleted by
   payroll in the WFN UI; the API cannot delete or read a batch, request `672204`). Every future test
   needs the same manual delete before the week is calculated.
2. ~~**Events.**~~ **Settled by the second test (§7): no event for an edit.** The approval half runs
   on 2026-10-20.
3. **Untested code families:** `SUB` (earnings amount), foreman `FR*`, military `ML*`, lattice,
   `SIC`, holiday, and an override (`BASE_RATE_OVERRIDE`) row.
4. **Batch totals** — what `ADP_Preview Batch Totals` sums, so the ERP can match it (§4).

## 6. Second test requested — events (2026-10-15)

syed.haris messaged Micaela Dipane in the same Teams chat on 2026-10-15, verbatim:

> *"Hi Micaela, thanks again for last Friday's test! We'd like to run one more tomorrow at 8am with
> the same three employees. Right now our system has no way to know when a worksheet is changed,
> deleted or approved in ADP, so we want to check whether ADP sends us a notice when that happens.
> After I post the worksheet, could you make one small edit on it (e.g. change 1 hour to 2), let me
> know when you have, and then delete it? Also, when you're about to approve this week's real
> payroll, could you send me a quick message just before, so I can check whether ADP lets us know it
> was approved? Thanks!"*

Micaela Dipane replied the same day, verbatim:

> *"Hi! Of course! Yes, I can do that tomorrow morning once you've uploaded it. This week's payroll
> has already been approved, so the next payroll will be uploaded and approved on Tuesday. I'll set a
> reminder to let you know once it's been approved in ADP!"*

So the two halves split: the edit/delete test runs **2026-10-16 morning**, and the approval check
waits for the next payroll, **uploaded and approved Tuesday 2026-10-20**. She will message **after**
approving, not before. That is enough for polling: a queued message stays until it is `DELETE`d, so
reading the queue after her message still catches anything ADP sent at approval.

syed.haris answered (2026-10-15): *"Perfect, I'll upload around same time like last week"* — i.e.
about **7:30 AM PT / 7:30 PM PKT on 2026-10-16**, matching the 2026-10-09 post (7:29 PM PKT).

Plan:

- **Changed / deleted:** post a test worksheet for `000288`, `000105`, `000459`; Micaela edits one
  line, then deletes it. This is the subscribe-and-edit test in
  [adp-event-notifications.md](adp-event-notifications.md) → *The test that settles it*.
- **Approved:** the test worksheet is **not** approved (real employees would be paid). Instead the
  queue is read after Micaela confirms the real payroll of **2026-10-20** is approved.
- **Delivery: polling, not webhook.** Polling is the project's active method; activating a webhook
  disables polling and needs a public, US-hosted endpoint
  ([gaps.md](gaps.md) → *Polling or webhooks*). Prerequisite: subscribe the *TCG ERP Integration*
  project to `pay-data-input.modify` before posting, then poll
  `GET /core/v1/event-notification-messages` and `DELETE` each message read.
- **Expected:** nothing. ADP said no pay-data events fire (request `672204`), and the catalogue has
  no *payroll approved / processed* event. An empty queue confirms the ERP must track worksheet
  status by hand; a message would show ADP's answer is out of date.

## 7. Second test — result (2026-10-16 PT / 2026-10-17 PKT)

The agreed morning slot slipped. syed.haris asked Micaela Dipane whether she was still free that
Friday (*"Hi! No worries! Yes I am!"*) and the test ran in the Pacific afternoon. Times below are
PKT; Pacific was 12 hours earlier, still 2026-10-16.

| When (PKT, 10/17) | What |
| --- | --- |
| before | *TCG ERP Integration* subscribed to **`pay-data-input.modify`** (API Central → project → APIs → **Events (1)**, the event shows *Included*); delivery **Polling — Active**, webhook untouched. Baseline `GET /core/v1/event-notification-messages` → **204** (empty). Dry run: open period **`2026-43`** (`2026-10-10` → `2026-10-16`, pay date `2026-10-22`), the same three file numbers, 6 / 8 / 7 lines |
| ~01:14 | `POST pay-data-input.modify`, batch **`TCGAPITEST20261016`** (named for Micaela's date, not the local one), the same week-41 figures as §2 → **HTTP 200**, the same bare echo as §3: no `confirmMessage`, no ADP batch name, no status. Queue straight after → **204** |
| ~01:38 | **Micaela Dipane**, verbatim: *"I changed Brad #459 from 23.5 to 21.5 Regular hours and Travis #288 from 40 to 30 regular hours!"* — and, asked, confirmed she **saved** the worksheet (*"Yes I did!"*) |
| 01:23 → 02:12 | Queue polled every ~5 minutes, plus on demand: **204 every time — 0 messages**, for ~35 minutes after the saved edit |
| ~02:00 | syed.haris told the group chat (Brian Petros is in it) the result and asked Micaela to delete the worksheet |
| by 02:27 | **Micaela Dipane deleted the worksheet** (relayed by syed.haris). Queue polled at 02:20 and 02:27 → **204**: **a delete sends no event either** |

**Result — the edit sends nothing.** A practitioner editing and saving an API-posted worksheet
produces no event, even with `pay-data-input.modify` subscribed and polling active. That matches
ADP's Known Issue (*"Event notification is not supported"*, Payroll Data Input guide, added May
2020) and request `672204` point 8. The subscription itself is real (Events (1), *Included*); the
queue answers 204, not an auth error. **The ERP cannot learn of a change made in ADP after it posts.**

**No event exists for payroll status either.** The full catalogue (all 10 domains, 147 events) has
**no event path containing `payroll` or `payroll-job`**; `job` matches only four Staffing events.
`payroll-job-status.change`, which a third-party connector (StackOne) lists for Workforce Now, is not
offered to this project. So the 2026-10-20 approval check is expected to be empty too; it is still
worth one poll after Micaela's message.

**The read side is closed as well.** Read-only probes on 2026-10-17 (`get.sh`, appendix):

| Call | Result |
| --- | --- |
| `GET /payroll/v2/payroll-output` | **403** `Invalid Scope` |
| `GET /payroll/v1/payroll-output` | **403** `Invalid Scope` |
| `GET /payroll/v1/workers/{aoid}/pay-statements` | **403** `Invalid Scope` |

and **Discover APIs** (intent *Read or Write*, all domains) finds nothing for `payroll-output`,
`output`, `pay-statement` or `statement`. So ADP's point 9 (*"The Payroll Output API can be used
for getting details for preview complete for final payrolls"*) is **not available on TCG's API
Central project** — consistent with the 2026-08-18 finding that it is Marketplace-partner-only
([adp-read-write-boundary-2026-08-18.md](adp-read-write-boundary-2026-08-18.md) §1). syed.haris
replied to Nate on request `672204` (2026-10-17 1:57 AM PKT) asking whether it can be enabled, or
whether any other API shows a worksheet's status or contents after posting, and forwarded the whole
thread to Brian Petros.

**What the ERP can know today:** that it posted (the 200). Nothing after — not an edit, not a
delete, not a calculation, not an approval. ADP has no *reject* for a worksheet: payroll rejecting
an entry means editing or deleting it, and both were tested here — **neither produces an event**. Two process options remain, for Brian Petros and
Corrina Bustos to choose (not decided): corrections are made **only in the ERP** and re-sent
(`Append` updates an existing batch — point 1), or payroll **confirms or marks changes in the ERP**
after approving in ADP. Recorded as open in [gaps.md](gaps.md).


## 8. The approval check — week 43 processed (2026-10-20 PT / 2026-10-21 PKT)

Micaela Dipane submitted the real week-43 payroll (period `2026-43`, `2026-10-10` → `2026-10-16`, pay
date `2026-10-22`) — a worksheet **not** created by the API. Her ADP mobile app then showed, at
4:15 PM PT (screenshot shared in the Teams chat):

> *"Your payroll for company 4RZ, payroll week 43 was processed."*

| Check (PKT, 10/21) | Result |
| --- | --- |
| `GET /core/v1/event-notification-messages` at 04:15, then every 5 minutes | **204 — empty**. `pay-data-input.modify` is still the only subscription; nothing fires on processing |
| `GET /payroll/v1/pay-schedule/payroll-groups/4RZ` at 04:18 | `2026-43` still **`OPEN`** three minutes after "processed"; `2026-41`, `2026-42` show **`COMPLETE`**, `2026-44`+ `NOT_STARTED`. Re-checked every 10 minutes until 04:38 PKT: **still `OPEN`** (watcher stopped there). The flip to `COMPLETE` was not caught — check the period again after the 2026-10-22 pay date to learn when it changes |

**So ADP knows payroll was processed and tells the practitioner in its app, but sends the
integration nothing.** Whether the worksheet came from the API or not makes no difference: events
depend on the subscription, not on who created the data.

**One real event exists in ADP's documentation, not on this project.** The *Payroll Group List of
Pay Periods API Guide for ADP Workforce Now NextGen* (Chapter 4, *Receive Notifications when a Pay
Period Status Changes*) names
`/payroll/payrollManagement/payrollProcessingScheduleManagement/payScheduleManagement/payrollGroup.payPeriodStatus.change.eventNotify`,
fired *"When the status of a payroll period changes"*. The same guide's GET
(`/payroll/v1/pay-schedule/payroll-groups/{group-code}`) **is** on this project (*Discover APIs* →
*Payroll Group Pay Periods*, *Included*), and its data dictionary gives the status as *"open/close/
skipped etc."* (observed codes: `NOT_STARTED`, `OPEN`, `COMPLETE`). But all 147 subscribable events
were read page by page on 2026-10-21 (via Chrome): **`payrollGroup.payPeriodStatus.change` is not
among them.** syed.haris asked Nate on request `672204` (2026-10-21) whether it can be enabled.

**Fallback the ERP can build today, unconfirmed:** poll the pay-schedule GET and treat `OPEN` →
`COMPLETE` as "week processed". It works only if the status flips at processing rather than at the
pay date or a later close — the watcher above decides that. ADP has **not replied** to the
2026-10-17 follow-up (Payroll Output enablement) as of 2026-10-21.


## 9. ADP's answer — status event added; Payroll Output needs a security master (2026-10-22)

Nate (ADP API Central Support, request `672204`), received 2026-10-23 PKT, answering both follow-ups.
Key points, his words where quoted:

- **Pay-period status event: added.** *"I added the "payPeriodStatus.change" notification to your
  project and notified our dev team to add it for clients."* Delivery is the project's existing
  **polling** queue.
- **Payroll Output and Pay Statements: available, but never through API Central.** *"can only be
  activated by our support team and is NOT ever visible within API-Central."* Payroll Output
  *"return[s] all raw payroll data (including sensitive personal and executive data) without
  filtering"*; Pay Statements (WFN only) returns hours, earnings and statement data/images and
  *"cannot be limited by masking settings"*.
- **ADP's conditions to activate them:** (1) a clear **"Yes"** on the ticket; (2) **a TCG security
  master on the ticket** — he names Corrina Bustos or Melissa McNutt; (3) the **API Central project
  names** to assign them to (ours: *TCG ERP Integration*).
- Docs: the Payroll Output (Turbo) guide and the WFN Pay Statements API in API Explorer; a paid
  consultation is offered.

**This is a TCG decision, not CodingCops'.** Enabling it exposes all 4RZ payroll — salaried and
executive pay included, unfilterable — to the integration's credentials. Owner: Brian Petros /
Corrina Bustos (security master). Not yet asked when written.

**First check after the event was added (2026-10-23 04:12 PKT, Pacific still 10-22):** queue
**204**, and `2026-43` still **`OPEN`** on its own pay date (`2026-42` `COMPLETE`, `2026-44`
`NOT_STARTED`). So the period does not close at processing (§8) nor, so far, on the pay date. Lead,
unconfirmed: it flips when the next week is opened — which would make `payPeriodStatus.change` a
*"next week started"* signal rather than *"this week processed"*. The next poll after Micaela starts
week 44 settles it.

---

## Appendix — the test scripts, as run

`.gitignore` there: `credentials.conf`, `out/`. `credentials.conf` sets `ADP_CLIENT_ID`,
`ADP_CLIENT_SECRET`, `ADP_CERT`, `ADP_KEY` (PEM paths) — never committed.
`DRY_RUN=1` stops before the POST.

### `adp-test.sh`

```bash
#!/usr/bin/env bash
# One-shot ADP Pay Data Input test. Needs: ADP_CLIENT_ID ADP_CLIENT_SECRET ADP_CERT ADP_KEY (pem paths).
# Steps: 1 token  2 AOIDs for the test file numbers  3 pay-cycle status  4 POST  (5 = dry run, no POST)
set -euo pipefail
[ -f "$(dirname "$0")/credentials.conf" ] && { set -a; . "$(dirname "$0")/credentials.conf"; set +a; }
: "${ADP_CLIENT_ID:?}" "${ADP_CLIENT_SECRET:?}" "${ADP_CERT:?}" "${ADP_KEY:?}"
COMPANY=${COMPANY:-4RZ}
FILES=${FILES:-"000288 000105 000459"}
BATCH=${BATCH:-"TCGAPITEST$(date +%Y%m%d)"}
CSV=${CSV:-"$HOME/Downloads/EPI4RZ41.csv"}
OUT=${OUT:-"$(dirname "$0")/out"}; mkdir -p "$OUT"
MTLS=(--cert "$ADP_CERT" --key "$ADP_KEY")

echo "== 1. token"
TOKEN=$(curl -sS "${MTLS[@]}" -X POST https://accounts.adp.com/auth/oauth/v2/token \
  -u "$ADP_CLIENT_ID:$ADP_CLIENT_SECRET" -d grant_type=client_credentials | tee "$OUT/token.json" | jq -r .access_token)
[ "$TOKEN" != null ] || { echo "no token"; cat "$OUT/token.json"; exit 1; }
AUTH=(-H "Authorization: Bearer $TOKEN" -H "Accept: application/json")

echo "== 2. AOIDs (workers, \$select keeps PII out; paged 100 at a time)"
: > "$OUT/aoids.tsv"
for skip in 0 100 200 300 400 500; do
  curl -sS "${MTLS[@]}" "${AUTH[@]}" \
    "https://api.adp.com/hr/v2/workers?\$select=workers/associateOID,workers/workAssignments/payrollFileNumber,workers/workAssignments/payrollGroupCode&\$top=100&\$skip=$skip" \
    | jq -r '.workers[]? | .associateOID as $a | .workAssignments[]? | select(.payrollGroupCode=="'"$COMPANY"'") | "\(.payrollFileNumber)\t\($a)"' >> "$OUT/aoids.tsv" || break
done
jq -Rn '[inputs | split("\t") | {key:.[0], value:.[1]}] | from_entries' "$OUT/aoids.tsv" > "$OUT/aoids-all.json"
jq --arg f "$FILES" 'with_entries(select(.key as $k | ($f | split(" ")) | index($k)))' "$OUT/aoids-all.json" | tee "$OUT/aoids.json"
[ "$(jq length "$OUT/aoids.json")" = "$(wc -w <<<"$FILES" | tr -d " ")" ] || { echo "!! not every test file# resolved to an AOID"; exit 1; }

echo "== 3. pay cycle status for $COMPANY (need OPEN, and the WFN cycle in Entering Payroll Information)"
curl -sS "${MTLS[@]}" "${AUTH[@]}" "https://api.adp.com/payroll/v1/pay-schedule/payroll-groups/$COMPANY" \
  | tee "$OUT/pay-schedule.json" | jq '[.payrollGroupsPayPeriods[].payPeriods[] | select(.payPeriodStatus.code=="OPEN") | {id: .payPeriodID, start: .payPeriodStartDate, end: .payPeriodEndDate, pay: .expectedPayDate}] | .[0] // "no OPEN period found"'

echo "== 4. payload (batch $BATCH from $CSV)"
python3 -I "$(dirname "$0")/build-payload.py" "$CSV" "$BATCH" "$OUT/aoids.json" > "$OUT/payload.json"
jq '.events[0].data.transform.payDataInput.payeePayInputs | map({file: .payrollProfilePayInputs[0].payrollFileNumber, lines: (.payrollProfilePayInputs[0].payInputs[0].earningInputs|length)})' "$OUT/payload.json"
if [ "${DRY_RUN:-0}" = 1 ]; then echo "DRY_RUN=1: not posting"; exit 0; fi

echo "== 5. POST pay-data-input.modify"
HTTP=$(curl -sS "${MTLS[@]}" "${AUTH[@]}" -H "Content-Type: application/json" -H "roleCode: employee" \
  -o "$OUT/post-response.json" -w '%{http_code}' \
  -X POST https://api.adp.com/events/payroll/v1/pay-data-input.modify --data-binary @"$OUT/payload.json")
echo "HTTP $HTTP"; cat "$OUT/post-response.json"; echo
echo "200 = batch landed on the Paydata page as a worksheet named like ${BATCH}_nnnnnn. Tell Micaela the batch name."
```

### `build-payload.py`

```python
#!/usr/bin/env python3
"""Build a pay-data-input.modify body from an ADP paydata CSV (EPI4RZnn.csv).

usage: build-payload.py <csv> <batch-id> <aoids.json> [file# ...]
  aoids.json: {"000288": "<AOID>", ...}  (from the workers GET; see adp-test.sh step 2)
  file#: which File # rows to include (default: every file# present in aoids.json)
Layout per the vault: adp-read-write-boundary-2026-08-18.md §4 / adp-workbook-vba-macros.md.
Reg Hours -> R, O/T Hours -> O, Hours 3/4 Code+Amount -> that code with numberOfHours,
Temp Rate -> rate.rateValue on every code in that row, SUB/earnings codes -> earningsAmount.
"""
import csv, json, sys
from collections import defaultdict


csv_path, batch_id, aoid_path, *wanted = sys.argv[1:]
aoids = json.load(open(aoid_path))
wanted = set(wanted) or {k.lstrip('0') for k in aoids}

rows = list(csv.reader(open(csv_path, newline='')))
hdr, body = rows[0], [r for r in rows[1:] if len(r) > 2 and r[2].strip()]
company = body[0][0]

inputs = defaultdict(list)
for r in body:
    fn = r[2].strip()
    if fn not in wanted:
        continue
    cells = r + [''] * (len(hdr) - len(r))
    temp = cells[hdr.index('Temp Rate')].strip()
    rate = {'rate': {'rateValue': float(temp)}} if temp else {}
    if cells[3].strip():
        inputs[fn].append({'earningCode': {'codeValue': 'R'}, 'numberOfHours': float(cells[3]), **rate})
    if cells[4].strip():
        inputs[fn].append({'earningCode': {'codeValue': 'O'}, 'numberOfHours': float(cells[4]), **rate})
    for i, h in enumerate(hdr):
        if i < 5 or not h.endswith('Code') or not cells[i].strip() or not cells[i + 1].strip():
            continue  # columns 0-4 are Co Code / Batch ID / File # / Reg / OT, not code pairs
        code, amt = cells[i].strip(), float(cells[i + 1])
        if True:
            if h.startswith('Earnings'):
                inputs[fn].append({'earningCode': {'codeValue': code},
                                   'earningsAmount': {'amountValue': amt, 'currencyCode': 'USD'}})
            else:
                inputs[fn].append({'earningCode': {'codeValue': code}, 'numberOfHours': amt, **rate})

payees = []
for fn, earnings in inputs.items():
    padded = fn.zfill(6)
    payees.append({
        'associateOID': aoids.get(padded, aoids.get(fn, f'<AOID for {padded}>')),
        'payNumber': '1',
        'payrollProfilePayInputs': [{
            'payrollFileNumber': padded,
            'payInputs': [{'earningInputs': earnings, '_modificationTypeCode': 'Add'}],
        }],
    })

doc = {'events': [{'data': {
    'eventContext': {'payrollGroupCode': {'codeValue': company}, 'payrollProcessingJobID': batch_id},
    'transform': {'payDataInput': {'payeePayInputs': payees}},
}}]}
json.dump(doc, sys.stdout, indent=2)
print()
```

### `poll-events.sh` (added 2026-10-17)

```bash
#!/usr/bin/env bash
# Drain the ADP event-notification queue (polling delivery). Same credentials.conf as adp-test.sh.
# Each GET returns ONE message (200 + adp-msg-msgid header) or 204 when empty.
# Every message is saved to out/events/ and then acknowledged with DELETE so the queue advances.
# KEEP=1 saves without deleting (re-read the same message).
set -euo pipefail
[ -f "$(dirname "$0")/credentials.conf" ] && { set -a; . "$(dirname "$0")/credentials.conf"; set +a; }
: "${ADP_CLIENT_ID:?}" "${ADP_CLIENT_SECRET:?}" "${ADP_CERT:?}" "${ADP_KEY:?}"
OUT=${OUT:-"$(dirname "$0")/out/events"}; mkdir -p "$OUT"
MTLS=(--cert "$ADP_CERT" --key "$ADP_KEY")

TOKEN=$(curl -sS "${MTLS[@]}" -X POST https://accounts.adp.com/auth/oauth/v2/token \
  -u "$ADP_CLIENT_ID:$ADP_CLIENT_SECRET" -d grant_type=client_credentials | jq -r .access_token)
[ "$TOKEN" != null ] || { echo "no token"; exit 1; }
AUTH=(-H "Authorization: Bearer $TOKEN" -H "Accept: application/json")

n=0
while :; do
  stamp=$(date +%Y%m%d-%H%M%S)
  HTTP=$(curl -sS "${MTLS[@]}" "${AUTH[@]}" -D "$OUT/$stamp.headers" -o "$OUT/$stamp.json" \
    -w '%{http_code}' https://api.adp.com/core/v1/event-notification-messages)
  if [ "$HTTP" = 204 ]; then rm -f "$OUT/$stamp.headers" "$OUT/$stamp.json"; echo "queue empty (204) — $n message(s) read"; break; fi
  if [ "$HTTP" != 200 ]; then echo "HTTP $HTTP"; cat "$OUT/$stamp.json"; echo; exit 1; fi
  MSGID=$(grep -i '^adp-msg-msgid:' "$OUT/$stamp.headers" | cut -d' ' -f2 | tr -d '\r')
  n=$((n+1))
  echo "== message $n  id=$MSGID  saved $OUT/$stamp.json"
  jq '[.events[]? | {event: .eventNameCode.codeValue, status: .eventStatusCode.codeValue, recorded: .recordDateTime, actor: .actor.formattedName}]' "$OUT/$stamp.json" || cat "$OUT/$stamp.json"
  if [ "${KEEP:-0}" = 1 ]; then echo "KEEP=1: not acknowledging"; break; fi
  [ -n "$MSGID" ] || { echo "no adp-msg-msgid header; stopping"; break; }
  curl -sS "${MTLS[@]}" "${AUTH[@]}" -o /dev/null -w "DELETE %{http_code}\n" \
    -X DELETE "https://api.adp.com/core/v1/event-notification-messages/$MSGID"
  sleep 1
done
```

### `get.sh` — read-only probe (added 2026-10-17)

```bash
#!/usr/bin/env bash
# Read-only probe: GET one ADP path, save the body to out/probe/, print status + response shape only
# (keys and array lengths, never values — payroll responses carry real pay data).
# usage: ./get.sh '/payroll/v2/payroll-output?$filter=...'
set -euo pipefail
[ -f "$(dirname "$0")/credentials.conf" ] && { set -a; . "$(dirname "$0")/credentials.conf"; set +a; }
: "${ADP_CLIENT_ID:?}" "${ADP_CLIENT_SECRET:?}" "${ADP_CERT:?}" "${ADP_KEY:?}"
OUT=${OUT:-"$(dirname "$0")/out/probe"}; mkdir -p "$OUT"
MTLS=(--cert "$ADP_CERT" --key "$ADP_KEY")
TOKEN=$(curl -sS "${MTLS[@]}" -X POST https://accounts.adp.com/auth/oauth/v2/token \
  -u "$ADP_CLIENT_ID:$ADP_CLIENT_SECRET" -d grant_type=client_credentials | jq -r .access_token)
for path in "$@"; do
  f="$OUT/$(date +%H%M%S)-$(echo "$path" | tr -c 'A-Za-z0-9' '_' | cut -c1-80).json"
  # pass the path already URL-encoded (spaces as %20); -g stops curl globbing [] and {}
  code=$(curl -sS -g "${MTLS[@]}" -H "Authorization: Bearer $TOKEN" -H "Accept: application/json" \
    -o "$f" -w '%{http_code}' "https://api.adp.com${path}")
  echo "== $code  GET $path  -> $f"
  if jq -e . "$f" >/dev/null 2>&1; then
    # errors are safe to show in full; success bodies only as a shape
    if [ "${code:0:1}" != 2 ]; then jq -c '.confirmMessage // . | {status: .requestStatusCode?, msgs: [.resourceMessages[]?.processMessages[]? | {id: .processMessageID?.idValue?, text: .userMessage?.messageTxt?}]} // .' "$f" | cut -c1-600
    else jq -c '[paths(type != "object" and type != "array")] | map(map(if type=="number" then "[]" else . end) | join(".")) | unique | .[:40]' "$f"; fi
  else head -c 300 "$f"; echo; fi
done
```
