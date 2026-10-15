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
2. **Events.** No event was subscribed, so this test says nothing about notifications. ADP said on
   2026-10-07 that none fire for pay data ([adp-event-notifications.md](adp-event-notifications.md)).
   A second test to settle it is requested (§6).
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
