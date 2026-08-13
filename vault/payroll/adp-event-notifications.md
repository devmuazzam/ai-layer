---
title: ADP event notifications — the mechanism, and what it constrains
source: api-central.adp.com/projects/{project}/APIs > Events
migrated: 2026-08-13
updated: 2026-08-13
status: reference
conflicts_with: []
jira: []
topics: [payroll, adp-integration, adp-api, events, webhooks, architecture]
entities: [adp-api, event-notification, webhook, employee, worker]
---

# ADP event notifications

**Observed 2026-08-13** in the API Central console, project `TCG ERP Integration`.

This is the mechanism behind the ERP↔ADP round-trip question. It is real, it is richer than the
Postman collection suggests, and it comes with constraints that shape the ERP design.

> **Read with [adp-integration-capabilities.md](adp-integration-capabilities.md)** — that file
> holds the architecture verdict. This one holds how the event layer actually works.

---

## Current state

| | |
| --- | --- |
| **Allowed APIs** | 15 |
| **Events subscribed** | **0** |
| **Events available to subscribe** | **147** |
| **Delivery method** | **Polling — Active.** Webhook — Inactive |

So the earlier `204 No Content` from `GET /core/v1/event-notification-messages` is fully explained:
the queue is entitled and working, and **nothing is subscribed**. It was never going to contain
anything.

## ⚠ Polling and webhooks are mutually exclusive

ADP's own note, verbatim:

> "There can only be one event delivery method selected per project. **If webhooks is activated,
> polling will be immediately disabled.**"

And below the panel:

> "If you need to use both polling and webhooks for your application, contact your ADP Marketplace
> Technical Advisor."

**This is an architectural decision, not a preference**, and it is per project. Choosing webhooks
means the ERP must expose a public HTTPS endpoint that ADP can reach — a deployment and security
requirement the current architecture drafts do not account for. Choosing polling means a scheduled
job and an acknowledgement loop.

Polling is currently active, which is the lower-risk default. Switching is reversible but not
simultaneous.

## The queue is acknowledge-based — the collection omits half of it

The console lists **two** operations:

```
GET     /core/v1/event-notification-messages
DELETE  /core/v1/event-notification-messages/{adp-msg-msgid}
```

**The Postman collection ships only the `GET`.** The `DELETE` is how a consumer acknowledges a
message and advances the queue. An ERP poller that never deletes will re-read the same messages
forever, or stall.

*(This corrects a note elsewhere in this vault that said no `DELETE` existed. It exists; ADP just
did not put it in the collection.)*

## Webhook specifics, if that route is chosen

- **Authentication:** ADP supports **OAuth 2.0, API Key, or Basic Authentication** on the
  receiving endpoint.
- **Signature verification is required** — ADP's tip: *"Be sure to verify the signature to ensure
  events are coming from ADP."*
- **The payload differs from polling.** *"An event body sent through webhooks differs slightly from
  that which is received through polling. There are additional items in a meta structure to provide
  more event context."* So the two delivery methods are **not** drop-in replacements for each
  other — switching later means changing the parser.

---

## Two ADP rules that constrain the ERP design

### 1. Events are triggers, not data

> "We recommend your application use event notifications as a **trigger** instead of the true
> source of real-time data, as there is always a time lag between when a notification was generated
> and when your application receives it. For example, if a notification indicates a worker is
> hired, your application should do `GET /hr/v2/workers/{aoid}` to retrieve the real-time data …
> as the data may have changed since the notification was generated."

**The ERP must never write ADP payload values straight from an event.** The pattern is:
event arrives → extract the identifier → re-read the resource → then act. Anything else risks
persisting a value ADP has already superseded.

This is also why `/hr/v2/workers/{aoid}` exists as a separate request in the collection despite the
list endpoint returning everything — it is the follow-up call for exactly this pattern.

### 2. ⚠ Notifications fire on **issue** date, not effective date

> "In regard to effective dating: in most cases, when a change has an effective date, the
> notification is generated **at the time when the change is issued, and not on the effective
> date**. Your application should be able to look up the effective date in the notification
> response payload."

**This matters more for payroll than for anything else.** The worker records already show
`baseRemuneration.effectiveDate` values of `2026-07-01` — the MLA wage-increase date — which would
have been *entered* weeks earlier. A naive consumer would apply a July rate change in May.

The ERP must read `effectiveDate` out of every notification payload and schedule the change, never
apply it on receipt. The vault's existing effective-dating requirement
([erp-payroll-module-frd/01](erp-payroll-module-frd/01-purpose-scope-and-design-principles.md) —
*"Rates, rules, holidays, classifications, contribution amounts, and policies must be
effective-dated"*) turns out to be a hard requirement of the ADP integration too, not only of the
payroll rules.

### 3. Event schema varies per event type

> "The schema of event notifications varies depending on `/events/eventNameCode/codeValue` and the
> ADP product."

There is no single event payload shape. `eventNameCode/codeValue` is the discriminator. Consistent
with the four success envelopes and two error envelopes already catalogued in
[adp-api-responses/codelist-endpoint-catalog.md](adp-api-responses/codelist-endpoint-catalog.md) —
**per-type adapters, not one parser.**

---

## The catalogue — 147 events, filterable

`Discover APIs to add to your project` with **API Intent = "Subscribe to events"** returns **147
results** across **10 domains** and **249 sub-categories**.

Events are named as dotted paths. The three visible on the first page are all HR worker events:

| Event | Category |
| --- | --- |
| `worker.workAssignment.additionalRemuneration.add` | HR > Add Additional Remuneration |
| `worker.personalContact.add` | HR > Add Personal Contact |
| `worker.businessCommunication.email.add` | HR > Add Worker Business Email |

### What this already unlocks

**Worker events exist.** That partly answers the employee-sync question from a different angle:
ADP masters worker identity, and if a `worker.hire`-style event can be subscribed, **the ERP can
learn about new employees without polling the full roster** — which also avoids the bulk personal
data pull flagged in
[adp-api-responses/workers-list.md](adp-api-responses/workers-list.md).

ADP's own polling description names this case explicitly: *"you can subscribe to the Worker Hire
event to be notified when a new hire is added."*

---

## The Payroll domain — 12 events, and one of them matters

Filtering **API Domain → Payroll** returns **12 events**:

| Event | Category | Relevant to TCG? |
| --- | --- | --- |
| **`pay-data-input.modify`** | **Pay Data Input Modify** | **★ the one that matters** |
| `worker.payDistribution.change` | Change Pay Distribution | no — payroll owns direct deposit |
| `worker.depositAccount.change` | Change Worker Deposit Account | no |
| `worker.depositAccount.remove` | Remove Worker Deposit Account | no |
| `usTaxProfileFederalIncomeTaxInstruction.add` / `.change` | US Federal Tax Profile | no |
| `usTaxProfileStateIncomeTaxInstruction.add` / `.change` / `.approve` | US State Tax Profile | no |
| `usTaxProfileLocalIncomeTaxInstruction.add` / `.change` / `.remove` | US Local Tax Profile | no |

Eight of the twelve are tax-instruction events, outside the ERP's scope. Three are direct-deposit
events. **One is pay data.**

### ⚠ `pay-data-input.modify` exists — but its semantics are unverified

**This appears to contradict the Payroll Data Input guide**, whose Known Issues state:

> "Event notification is not supported."

Either that note is stale, or it means something narrower than it reads. **Do not treat the event's
existence as proof the round trip works.** The event name is character-for-character the API
operation name (`pay-data-input.modify`), which admits two very different readings:

| Reading | What fires | Value to the ERP |
| --- | --- | --- |
| **Echo** | only when *the API* is called — i.e. the ERP's own submission | **Low.** The ERP already knows it submitted. Might still carry an identifier the `200 OK` withholds |
| **Change notification** | whenever the pay-data batch changes, **including a practitioner editing the Paydata page** | **High — this closes the loop.** The ERP would learn its batch was altered |

Nothing observed so far distinguishes them. The distinction decides whether both architecture
drafts keep their inbound arrows.

### The schema tilts strongly toward "change notification"

The event's JSON Schema (`PayDataInputModifyEvent`, draft-04) was read on 2026-08-13. Four blocks
of it make no sense for a pure API echo:

| Field | Description in the schema |
| --- | --- |
| **`originator`** | *"a user, machine or event that triggered the event"* |
| **`actor`** | *"the party that completed the recording of the event"* — with `associateOID`, `formattedName`, `deviceID`, `geoCoordinate`, `deviceUserAgentID` |
| **`actAsParty`** | *"An ADP Support User (principal A = Actor) views data within an ADP Application as a client employee (principal B) in read only mode"* |
| **`onBehalfOfParty`** | *"…can take action on that person's behalf"* |

**A field describing an ADP support user acting inside the ADP UI on behalf of a client employee
is not describing an API call.** Neither are device IDs, user-agent IDs and geo-coordinates. These
exist to record *a human doing something in a screen*.

Combined with `eventStatusCode` (`created` / `inProgress` / `complete`, *"set by the system of
record"*) and `assignedGroups` / `assignedGroupMembers` for review workflows, the schema describes
a business event with a human lifecycle — not an echo of an HTTP request.

**This is inference, not proof.** The schema is ADP's canonical event model, shared across
products; WFN may implement only part of it. The practical test below still settles it.

### If it does fire, the ERP gets more than a receipt

| Field | What it gives the ERP |
| --- | --- |
| **`eventID`** | *"set by the system of record once an event is recorded"* — **the correlation handle the `200 OK` withholds** |
| **`actor.formattedName`** + `associateOID` | **which practitioner changed the batch** |
| `recordDateTime` / `creationDateTime` / `effectiveDateTime` | when it was entered vs when it takes effect |
| `eventStatusCode` | whether the change is in progress or complete |
| `eventReasonCode` | why |

That is not just "your batch was edited" — it is a **who, what, when audit trail**, which is
materially better than the manual reconciliation the architecture currently assumes.

### ⚠ `payrollProcessingJobID` may not be ours to invent

The schema says:

> `payrollProcessingJobID` — *"The unique identifier of the related payroll processing job. **This
> is generated as the result of the `payrollProcessingJob.initiate` event.**"*

**This contradicts the WFN implementation.** The pay-data `/meta` response labels the same field
**"Batch ID"**, marks it `optional: false`, and ADP's own Postman example supplies free text
(`"Regular, OT"`). So in Workforce Now it is client-supplied, and the guidance elsewhere in this
vault — build it from `payPeriodID` — stands.

**But it names an event nobody has looked for: `payrollProcessingJob.initiate`.** That is
conceptually *"a payroll run was started"* — the closest thing yet to output-side visibility.
It did not appear in the 12 Payroll-domain events, so it is likely not available to WFN clients,
but the Payroll filter was one of ten domains. Worth one search of the catalogue.

### ⚠ This schema is ADP's generic model, not WFN's implementation

It contains fields the WFN `/meta` response does **not** expose. Do not build against them without
confirming:

| Field in the event schema | Not in WFN `/meta` | Why TCG would care |
| --- | --- | --- |
| **`workDate`** | ✗ | *"the date on which the worker clocked overtime"* — **daily OT attribution** |
| **`earnedPayPeriodStartDate` / `EndDate`** | ✗ | *"used for FLSA in CA in the US"* — **California overtime** |
| `earnedPayPeriodWeekNumber` | ✗ | FLSA week |
| `workWeekDatePeriod` | ✗ | 7-day earning period (marked DEPRECATED at payee level) |
| `modifierCode` | ✗ | *"Used to modify the earning code, e.g. field number"* |
| **`additionalPayAllocations[]`** | ✗ | **an array** of allocations, versus the single `payAllocation` WFN exposes |
| `payTypeCode` | ✗ | *"regular, bonus"* — splits pay across cheques |
| per-payee `payPeriodStartDate` / `EndDate` | ✗ | period dates per employee |
| `earningInputs[].memoInputs[]` | ✗ | memos nested inside an earning |

**The first two matter.** TCG's California daily-OT, seventh-day and FLSA rules all need work
dates, and the generic schema has fields for exactly that — but the WFN meta does not offer them.
If WFN supported `workDate`, the ERP could send per-day attribution instead of weekly totals.
**Worth one question to ADP.** Recorded in [../gaps.md](../gaps.md).

Also note `_modificationTypeCode` is documented here as **`add`, `change`, or `remove`**, whereas
ADP's WFN examples use `Add` and `Append`. Another generic-vs-WFN divergence — trust `/meta`.

### One operational limit, stated plainly

> *"Manual and voided checks are not supported in this context."*

Off-cycle corrections and voids are a Workforce Now UI task. The ERP cannot issue them.

### The test that settles it, without writing anything

1. Subscribe to `pay-data-input.modify` (polling stays active; no webhook endpoint needed).
2. **Ask a TCG practitioner to make a trivial edit on the Paydata page** in Workforce Now — no ERP
   submission involved.
3. Poll `GET /core/v1/event-notification-messages`.

- **A message appears** → it is a change notification. The loop closes, and the payload shows what
  the ERP can learn.
- **`204` again** → it is an echo of API calls only, ADP's Known Issue stands, and reconciliation
  stays manual.

**This requires no `POST` to production payroll.** The write comes from a human doing their normal
job in the ADP UI. That is the safest possible way to answer the question, and it also captures a
real event payload — which nothing in ADP's documentation or Postman collection provides.

Remember to `DELETE /core/v1/event-notification-messages/{adp-msg-msgid}` afterwards.

### What is still absent — the boundary holds

**There is no "payroll processed", "payroll completed", or "pay statement available" event.**
Twelve payroll events, and none of them announce that payroll ran or that anyone was paid.

So even in the optimistic reading, what closes is *"your batch was edited"* — **not** *"here is
what was actually paid"*. That is consistent with payroll-output APIs not being sold to Workforce
Now clients ([adp-integration-capabilities.md](adp-integration-capabilities.md)), and it means the
central formulation survives unchanged:

> **The ERP is the system of record for what should be paid. ADP remains the system of record for
> what was actually paid — and it will not tell you.**

Events could make the *input* side of the loop trustworthy. They do not open the *output* side.
