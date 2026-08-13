---
title: ADP integration — what ADP actually provides, and what it requires of us
source: research/developers.adp.com + apps.adp.com
migrated: 2026-08-13
updated: 2026-08-13
status: reference
conflicts_with: []
jira: []
topics: [payroll, adp-export, integration, api, architecture]
entities: [adp-code, pay-data-input, api-central, associate-oid, payroll-file-number, webhook]
---

# ADP integration capabilities

**Researched 2026-08-13 from ADP's own developer documentation.** `status: reference` — this
describes a vendor product that demonstrably exists, not a TCG decision. It is here because two
architecture drafts (a TPM diagram and a design-team prototype) both assume an ERP↔ADP sync, and
neither states what ADP actually permits.

> **Product confirmed 2026-08-13: TCG is on ADP Workforce Now (classic).** Established from a
> screenshot of Ehtesham's live session — `workforcenow.adp.com/theme/admin.html#/home`, branded
> "ADP Workforce Now", with the classic nav (Home · Resources · Myself · People · Process ·
> Reports & Analytics · **Setup**). The `/theme/admin.html` path and that nav are classic WFN, not
> **WFN Next Generation**, which is a separate product with separate API guides. Everything in
> this file is therefore the right documentation set.
>
> The session also shows a **practitioner-level profile** — the `Setup` menu and *Customize
> Layout* / *Create article* controls are not visible to employee or manager profiles. That
> matters: `Setup > Tools > Validation Tables` (where earning codes live) and the **Marketplace**
> icon (where API Central is bought) are both reachable from this account.
>
> Still unresolved: the "Company Code 631" vs "Co Code 4RZ" identifier conflict flagged in
> [adp-bucket-crosswalk.md](adp-bucket-crosswalk.md). The product is settled; the company code is
> not.

## The gate: ADP API Central — **TCG already has it**

**Confirmed 2026-08-13** from the ADP Marketplace `My Apps` screen on TCG's own account. Two apps
are entitled:

- **ADP® API Central for ADP Workforce Now® [Launchpad]** — with a live `Launch App` button
- **ADP® API Central Help Center**

**This removes the single largest blocker on the integration.** No purchase, no procurement
conversation, no unbudgeted cost, no lead time. The Launchpad is where projects, API scopes,
Client ID/Secret and the mTLS certificate are managed — everything in *"Where to get credentials"*
below is reachable today.

**`My Apps` also shows what TCG does *not* have: no certified-payroll connector.** No Points
North, no allGeo, nothing in that category. So WH-347 generation is genuinely unbuilt — the
Labor Compliance module is greenfield, and the TPM architecture's separate SMG Compliance box is
not duplicating something already licensed.

### For reference — the general rule

API access is **not included** with a Workforce Now subscription. It is a separate purchase —
**ADP API Central** — from the ADP Marketplace.

- It **does** support **client-built** integrations. TCG does not need a marketplace partner, and
  does not need to become an ADP partner, to build this. (ADP also lists partners — Aquera,
  DataBlend, Flexspring, RCM HCM — as an alternative, not a requirement.)
- It provides credential and certificate management, API discovery, code samples, and support
  tickets to ADP API specialists.
- **Pricing is not public** — the Marketplace listing requires login to see prices.

*(TCG's entitlement is already in place — see above. This section is kept for context on what the
entitlement actually is.)*

## Authentication

OAuth 2.0 / OpenID Connect **plus mutual-TLS client certificates**. Not an API key. TCG will hold
an ADP-issued client certificate and must manage its rotation and storage — that is an
infrastructure requirement, not just a code one.

## Sending payroll to ADP — the Payroll Data Input API

The relevant API is **Pay Data Input** (`/events/payroll/v1/pay-data-input.add`). It creates a
**Pay Data batch** against a payroll cycle.

### What it accepts

| Type | Schema location |
| --- | --- |
| Regular & Overtime earnings | `…/payInputs/earningInputs` |
| **Coded hours and earnings** (client-defined codes) | `…/payInputs/earningInputs` |
| Deductions | `…/payInputs/deductionInputs` |
| **Shift** (values 2–9, for special calculations) | `…/earningInputs/configurationTags/tagCode` + `tagValues` |
| Temp Cost Number / Temp Department Number / Allocations | `…/payInputs/payAllocation` |
| Memos | `…/payInputs/memoInputs` |
| Cancel Automatic Payment | `…/payInputs/cancelAutomaticPayIndicator` |
| Tax frequency | `…/payInputs/taxInputs/taxCycleCode` |

**"Coded hours and earnings" is the one that matters for TCG.** Every custom code in the
crosswalk — `LPR`, `LOO`, `FRR`, `FRT`, the shift differentials — goes through `earningInputs`
with a client-defined `earningCode`. ADP reserves only `R` (Regular) and `O` (Overtime) out of the
box; everything else is client configuration.

**The Shift tag is worth noting** — ADP has native support for shift values 2–9 driving special
calculations, which maps onto the Second/Third Shift differentials discussed on 5 August. Whether
to use ADP's shift mechanism or to send pre-calculated shift-premium earning codes is a real
design decision nobody has made.

### What it will not accept

Documented as **not handled** by the API (file-based import is ADP's suggested workaround):

- All **tax adjustment** fields — federal, state, local, lived-in/worked-in
- Medicare, SUI/SDI, Soc Sec adjustments
- Advance Pay Date (Wage Garnishment Processing Service)
- **Clock** — the API always uses the employee's *default* clock value. If an employee has
  multiple clock values, only the Paydata page can select a non-default one
- Deduction by Week

### Preconditions ADP enforces

These are hard gates. A batch fails if any is unmet.

1. **Client must be US, Canada (AutoPay), or cross-border.**
2. **Every earning and deduction code must already be configured in Workforce Now** —
   `Setup > Tools > Validation Tables > Payroll > Paydata`. The API sends codes; it does not
   create them. **All 24+ TCG codes must exist on ADP's side first.**
3. A **Memo Code of `5`** and an **Hours & Earnings Code of `T`** must exist for each active
   company — unless the call passes `autoGenerateMemoCode=false`.
4. **The API user's profile** needs menu access to `Process > Payroll > Pay Data` *or*
   `Process > Payroll > Payroll Dashboard`, plus view-and-edit access to the target company codes.
5. **The payroll cycle status must be `Entering Payroll Information` or `Correcting Input`.**
   Outside that window the request errors. **This is a timing constraint on TCG's whole weekly
   process** — the ERP cannot push whenever it likes.
6. **Every employee must be in an ADP Workforce Now paid position.**

### How employees are matched

Three identifiers appear in the payload:

- `…/payeePayInputs/associateOID` — ADP's internal worker ID. **Retrieved via `GET workers`.**
- `…/payrollProfilePayInputs/payrollFileNumber` — **the "File #"**. This is the field TCG already
  tracks as *ADP File #* and already treats as a blocking exception when missing or malformed
  ([adp-bucket-crosswalk.md](adp-bucket-crosswalk.md) decision D-001, and the
  `payroll-weekly` worklist). **The existing exception handling is correctly aimed.**
- `…/payeePayInputs/payNumber` — assigned by the client, used for all entries in the batch.

Also required at batch level: `…/eventContext/payrollGroupCode/codeValue` — the **company code**,
and `…/eventContext/payrollProcessingJobID` — the **batch ID**. ADP notes the batch ID **need not
be unique** — it appends system-generated characters if it collides.

## Who owns the earning codes — TCG, not ADP

**ADP does not supply a standard or unified code set.** Out of the box it reserves exactly two:

- `R` — Regular earnings
- `O` — Overtime earnings

Plus the two structural ones the API requires: **Memo Code `5`** and **Hours & Earnings Code `T`**
per active company (waivable with `autoGenerateMemoCode=false`).

**Everything else is client-defined and TCG creates it.** ADP's own wording: the API *"supports
all earning and deduction codes, **including the earning and deduction codes added by clients**"*,
and *"clients need to make sure the codes and numbers used by your data connector application are
added and configured in ADP Workforce Now"* at:

`Setup > Tools > Validation Tables > Payroll > Paydata > Hours & Earnings Codes`

So `FRR`, `FRO`, `FRD`, `FRT`, `LPR`, `LOO`, the shift differentials — **all TCG inventions**.
They mean nothing to ADP beyond a label to bucket money under. There is no industry registry, no
Davis-Bacon standard code list, nothing ADP publishes. Two contractors doing identical government
work will have entirely different code sets.

The practical consequence: **the ERP cannot send a code ADP has never heard of.** Sending an
unconfigured code returns `codedHoursEarning: VV is invalid`. Code creation in WFN is a manual,
one-time, practitioner task that must happen *before* the first API call carrying that code.

### Government / prevailing-wage work specifically

There is no unified "government job" earning code. Prevailing-wage work needs two *different*
things, and they are separate mechanisms in ADP:

| Need | Mechanism |
| --- | --- |
| **Pay the hour differently** (prevailing rate, fringe) | Earning codes and/or `rateCode` + `rate/rateValue` on `earningInputs` |
| **Attribute the hour to a job** (which is what certified payroll reports on) | **Temporary Cost Number**, **Temporary Department Number**, **Allocations** — `…/payInputs/payAllocation` |

The second is the one usually missed. Certified payroll reporting is fundamentally *"which hours,
at which rate, on which job"* — job attribution, not just a pay bucket.

**Certified payroll itself is not native to Workforce Now.** WH-347 generation is served by ADP
**Marketplace partners** — Points North Certified Payroll Reporting, allGeo Construction
Connector — which read hours-by-day, rates and paycheck data out of WFN. This corroborates the
TPM architecture's separate **SMG Compliance** box: a third system generating the reports is the
normal shape, not a workaround. It also means **"does TCG already have such a connector?"** is a
question worth asking before designing Labor Compliance.

## Inside API Central — confirmed layout and access

**Console:** `api-central.adp.com`. Four sections in the left nav:

| Section | What it holds |
| --- | --- |
| **Projects** | Create a project, access API credentials, manage existing projects |
| **Certificate** | Request a new security certificate, upload an existing one, track expiration |
| **Members** | Team access and roles |
| **Integration Services** | **Nothing functional** — a marketing page listing three ADP Marketplace consultancies (Flexspring, DataBlend, Aquera) who will build integrations for you. No settings, no configuration |

**Events are therefore per-project.** They are not a top-level nav item, and Integration Services
is now ruled out. The only place left is inside a project (`Projects > … > APIs > Events`), which
matches ADP's webhook guide. **The event catalogue cannot be read until a project exists.**

### Current state: nothing has been started

Confirmed 2026-08-13 — both **Projects** and **Certificate** are empty.

- **Projects:** *"Let's get started by creating a project"* with a single `Create a project`
  button. Zero projects.
- **Certificate:** *"Need a certificate?"* with `Request certificate` and `Upload signed
  certificate`. Zero certificates.

Clean slate. Nothing to inherit, nothing to reconcile.

### The certificate is one credential for everything — including production

ADP's own wording on the Certificate page:

> "A signed certificate from ADP's Certificate Authority (CA) must be presented in order to fetch
> an access token from ADP and for every subsequent API request to ADP's API Gateway.
> **A certificate created here will be used across all projects you create in both development and
> production.**"

**Read the last sentence carefully — this is a real security constraint, not a detail.** There is
no separate development certificate. One certificate, issued once, authenticates every project in
both environments. Whoever holds that certificate and a set of client credentials can reach
**production payroll**.

Consequences worth deciding before requesting it:

- **A developer cannot be given a "dev-only" credential at the certificate layer.** Environment
  separation, if it exists at all, has to come from the *project* — which is why the dev/prod
  distinction, and whether a sandbox company exists, must be established when the first project is
  created.
- **The private key needs a proper home from day one** — a secret manager, not a repo, not a
  laptop, not a shared drive. It is a production payroll credential from the moment it is issued.
- **Rotation is a planned event, not an incident response.** ADP offers expiry tracking on this
  page, which is worth using.

### What kind of certificate — and where it can come from

**An X.509 client certificate for mutual-TLS client authentication, signed by ADP's own
Certificate Authority.**

**It cannot be bought.** This is not a web/SSL server certificate and no public CA — DigiCert,
Let's Encrypt, GoDaddy — can issue it. Only ADP's CA can sign it, from the API Central Certificate
page. There is no alternative supplier.

Two issuance routes:

| Route | What happens | Private key |
| --- | --- | --- |
| **`Request certificate`** | ADP generates and signs; you download a `.pem` | Originates at ADP |
| **`Upload signed certificate`** (CSR) | You generate the keypair and a CSR; ADP's CA signs it; you receive the signed `.pem` | **Never leaves your infrastructure** |

**The CSR route is the stronger posture** and is the one to use given the certificate reaches
production payroll.

ADP's documented CSR requirements:

- **RSA, 2048-bit** private key
- **The CSR must not request S/MIME capabilities**
- **Challenge password left blank**
- **Plain ASCII only** in the company information fields — special characters are the most common
  cause of ADP rejecting a CSR

**Does requesting it cost anything?** No evidence of a charge, and three reasons to think not:
the Certificate page carries **no pricing, no cart and no purchase step** (unlike the Marketplace
listing, which says *"Login to see prices"*); certificate issuance is a credential function of
**API Central, which TCG already pays for**; and on the CSR route ADP is only *signing* a request,
not provisioning anything. **Not independently verified** — ADP pricing is not public. If
certainty is wanted before clicking, ADP Assist or `Contact support` answers it in a minute.

You end up holding two files — a `.key` (private key) and a `.csr` (the request). After ADP signs
it you download the signed `.pem`. Private key and certificate can then be combined into a single
`.pfx` / `.p12` for whatever HTTP client the ERP uses.

### Also present

- **ADP Assist** — an AI chat on the Projects page, *"Find, activate and troubleshoot APIs"*. A
  plausible fast route to the pay-data-event question without opening a support ticket.
- **Consulting hours** and `Contact support` — ADP client support specialists, linked from
  Projects.

### Roles

Three roles, and they are separable:

- **P — Project user** — create projects, **access API credentials**, manage existing projects
- **C — Certificate user** — request a new certificate, upload an existing one, track expiry
- **M — Member user** — view Members, manage access and roles

### Who holds them at TCG

As of 2026-08-13 the tenant (`THE CRANE GUYS LLC`) has **three members, each holding all three
roles**:

| Member | Organisation |
| --- | --- |
| Corrina Bustos | TCG |
| Melissa Mcnutt | TCG |
| **Ehtesham Anwar** | **CodingCops — project manager** |

**The external-member route is already proven.** Ehtesham is CodingCops, not TCG, and he is in the
tenant with full `P`/`C`/`M`. So granting API Central access across the org boundary is not a
theoretical capability described on a help page — **it has already been done once**, and the
mechanism works. All three user IDs carry the same `@blsr1` realm suffix, i.e. external members are
issued an ADP identity inside TCG's tenant rather than federating their own domain.

Two of the TCG names matter beyond access control. **Corrina Bustos** is the Corrina who owes Ryan
the Davis-Bacon business rules per the
[7 Aug minutes](../meetings/2026-08-07-labor-compliance-certified-payroll.md) — the same
determination that gates the Military Base premium. **Melissa Mcnutt** is the Melissa who asked
for the *not-yet-submitted-to-ADP* filter in the
[5 Aug review](../meetings/2026-08-05-payroll-module-design-review.md). The people holding the API
keys are the same people holding the unanswered payroll questions.

### The remaining access gap is narrow, and CodingCops can close it alone

The PM has access; **the implementing developers do not**. Nobody who will actually write the
integration can reach a credential, a certificate or a project.

**This does not require a request to TCG.** Ehtesham holds the **M (Member user)** role, which is
defined as *"manage access and roles for internal and external users"*. CodingCops can add its own
developers to the tenant without a procurement step, a licensing question, or a TCG approval
cycle.

## Where to get credentials, from this account

The path starts inside the WFN session in the screenshot.

1. **Marketplace** — the icon in the WFN top nav. Search **ADP API Central for ADP Workforce
   Now**. This is the paid entitlement; without it there are no credentials to get.
2. **[developers.adp.com](https://developers.adp.com)** — once entitled, create a **project**.
3. **`Projects > select a project > APIs`** — add the APIs the project may call. Pay Data Input
   must be added explicitly; its canonical scope is
   `/payroll/payrollManagement/payrollProcessing/payDataInputManagement/pay-data-input.modify`,
   registered in the **Consumer Application Registry (CAR)**.
4. **`Projects > select a project > APIs > Events > Add Events`** — for webhooks, separately.
5. **Credentials**, issued per project: a **Client ID**, a **Client Secret**, and an **X.509
   client certificate** downloaded as a `.pem` from the portal.

### Getting a token

`POST https://accounts.adp.com/auth/oauth/v2/token`

- `grant_type=client_credentials`
- Client ID and Secret **base64-encoded in the `Authorization` header**
- **The mTLS client certificate must be presented on this call and on every subsequent API
  call.** ADP is not "OAuth *or* certificate" — it is both, always.

**This is the step that makes ADP different from most integrations.** A token alone gets you
nothing; the certificate is transport-layer and has to be configured wherever the ERP makes the
call — which means the cert and its private key need a home in TCG's infrastructure and a rotation
plan. Worth deciding early, because it constrains where the payroll sync can run.

## What ADP sends back, and when

**The response is synchronous HTTP.** There is no async confirmation, no callback, no job to poll.
You POST a batch, ADP answers in the same exchange.

ADP's documented call sequence is four steps and includes a **pre-validation call**:

1. `GET /events/payroll/v1/pay-data-input.modify/meta` → returns the event metadata
2. **Your app processes the meta payload to validate your data and prompt the user to fix issues**
3. `POST /events/payroll/v1/pay-data-input.modify` → the batch
4. ADP responds with the outcome

The meta call takes a filter — `…/meta?companyCode=94N&fileNumber=078765` — and returns **the
valid earning codes, deduction codes and so on for that company**. This is how the ERP can check a
code exists in ADP's validation tables *before* sending, rather than discovering it in a 400.

### Response codes

| Code | Meaning |
| --- | --- |
| **`200 OK`** | Request processed successfully — batch created (or appended) |
| **`400 Bad Request`** | Rejected, with a specific `messageText` |

Documented `messageText` values, verbatim, each with ADP's own handling tip:

| Condition | `messageText` |
| --- | --- |
| Payroll cycle not in `Entering Payroll Information` / `Correcting Input` | `eventContext/payrollGroupCode is invalid` |
| Invalid company code | `eventContext/payrollGroupCode is invalid` |
| Invalid Associate OID for the file number sent | `Label not found, missing following key: access.invalid associateOid: G3E82PE9GT1Q8VENN` |
| **Invalid `payrollFileNumber`** | `payrollFileNumber:8118799 is invalid` — *"Check if the employee is still active and eligible for payroll processing."* |
| Invalid `payNumber` | `payNumber:100 is invalid` |
| **Earning code not in the Validation table** | `codedHoursEarning: VV is invalid` — *"Your data connector application should validate that the hoursEarningCode is set up… in the Validation table."* |
| Deduction code not in the Validation table | `…/deductionInputs/deductionCode/codeValue is invalid` |
| Memo code inactive or empty | `Memo codeValue does not exist in Validation Table, or MemoCode is not an active memo code` |

**Note what the cycle-status error looks like.** A payroll cycle in the wrong state returns
`payrollGroupCode is invalid` — the *same message* as a genuinely bad company code. The ERP cannot
tell those two apart from the message alone, and one is "you sent garbage" while the other is
"you sent it at the wrong time". Check the cycle status before blaming the payload.

### What `200 OK` does and does not mean

**It means: the batch landed on the Paydata page.** It does **not** mean payroll ran, that anyone
reviewed it, that the numbers were accepted, or that a cheque exists. Those are all downstream of
a practitioner. An ERP that renders `200 OK` as "submitted to ADP ✓" is accurate; one that renders
it as "paid" is not.

### Appending to a batch

`pay-data-input.modify` with `"_modificationTypeCode": "Append"` adds to an existing batch. Two
behaviours worth knowing before relying on it:

- **ADP appends random numeric characters to your batch name.** You send `Batch`, you get
  `Batch_654321`. The batch ID you chose is not the batch ID that exists.
- **If several batches share a name prefix, Append targets the *latest* one.** Sending
  `payrollProcessingJobID: 'Batch'` when `Batch_123456`, `Batch_654321` and `Batch_987654` exist
  appends to `Batch_987654`. **Store the returned batch ID; never re-derive it from the name.**

### The Excel path returns nothing machine-readable

The current process ([adp-sop-v3.8.md](adp-sop-v3.8.md)) produces a **spreadsheet a practitioner
imports through the ADP UI**. That is file-based import, not the API. Its only "response" is what
the practitioner sees on their own screen — there is no payload, no status code, nothing the ERP
can capture. **Excel and API are alternatives, not stages of one pipeline.** Any ERP screen
showing ADP responses presupposes the API path.

## Employee records — which direction actually works

**ADP mints worker identity, and that settles the argument.** A worker in ADP carries one
`associateOID`, one `workerID`, and one `positionID` per position — all ADP-generated. The
**File ID / File Number lives on the worker's ADP profile**. The ERP cannot invent any of them.

This is consistent with what the pay-data API already told us: send an unknown `payrollFileNumber`
and ADP answers `payrollFileNumber:8118799 is invalid` — it is validating against its own worker
master.

### ADP → ERP (inbound)

Straightforward and well supported. `GET workers` retrieves the roster; a **`Worker Hire` event
notification** fires on new hires, which is ADP's own documented webhook example. This is the
direction the vault's existing exception handling assumes — the ERP holds an ADP File # per
employee and blocks payroll when it is missing or malformed.

### ERP → ADP (outbound)

Possible, but narrower and messier:

- **The `Worker Hire` Event API (`POST /events/hr/v1/worker.hire`) is being deprecated.** ADP
  directs new work to the **Applicant Onboard V2 API** instead.
- Its documented limitations are not trivial: no FLSA codelist support, no international
  templates, limited *State Worked In* support, and — most dangerous — **"in some cases a new hire
  record is created by the API even when an error response is returned."** An outbound hire sync
  built naively will create duplicate or orphaned workers in the payroll system of record.
- For changes rather than creation, WFN has a **Worker Management API** and an **Employee Job
  Change API** (e.g. adding a position).

### The recommendation this points to

**Treat ADP as the master for worker identity and the ERP as the master for operational employee
data.** Hire in ADP; sync inbound to the ERP; let the ERP own craft codes, yard, certifications,
crew assignment and everything payroll-operational that ADP has no opinion about.

Attempting true bidirectional creation means owning duplicate-detection against a system that will
sometimes create a record *and* return an error on the same call. That is a real reconciliation
burden for a benefit — "I can add an employee without opening ADP" — that no requirement in the
vault has asked for.

## The part that decides the architecture

ADP's own **Process Overview** for this API is five steps, and **three of them are a human**:

| | Actor | Task |
| --- | --- | --- |
| 1 | **Payroll Practitioner** | Selects company code, employees and file numbers to import |
| 2 | **Payroll Practitioner** | Enters a batch number, initiates the import |
| 3 | *Your application* | Creates the batch and imports the pay data |
| 4 | **Payroll Practitioner** | Reviews the result on the ADP **Paydata page** |
| 5 | **Payroll Practitioner** | Balances and adjusts as needed |

And ADP's note on step 5:

> "**To keep your data in sync with what's on the Paydata page in ADP Workforce Now, data must be
> adjusted in your data connector application.**"

**Read that carefully. ADP is saying the sync is one-way and the reconciliation is manual.** If a
practitioner edits the batch inside ADP, nothing tells the ERP. ADP's stated remedy is that
someone re-enters the change in the source system.

## Event notifications — what ADP *will* push back

ADP does support **webhooks** and **event notifications**, added per-project under
`Projects > Select a Project > APIs > Events > Add Events`. ADP monitors a message queue and
pushes to a subscriber endpoint, so polling is not required.

Requirements:

- A **publicly accessible endpoint hosted in the US**, secured with one of ADP's supported auth
  types.
- ADP emails all registered users on delivery failure.

Events are **data-change events** — the documented example is *Worker Hire*. **Nothing found
confirms an event for "a practitioner edited your pay-data batch."** Until that is confirmed with
ADP directly, assume it does not exist.

## So: can the ERP be the system of record?

**For payroll input — yes, and this is the normal pattern.** The ERP owns hours, rules,
rate resolution and the pay-component ledger, and pushes coded earnings into an ADP batch. Nothing
in ADP's model resists that.

**For the round trip — not as either architecture draft currently assumes.** Three specific gaps:

1. **ADP's Paydata page stays editable after import**, and ADP explicitly expects manual
   re-entry to resync. An ERP that treats its own numbers as authoritative will silently diverge
   from what ADP actually paid.
2. **The batch is created inside a practitioner-driven window.** The cycle must be in
   `Entering Payroll Information` or `Correcting Input`. A fully unattended "sync with ADP"
   button is not what the API describes.
3. **The payroll *output* side is unverified.** Both drafts show payroll results, check status and
   distribution flowing back. A *Payroll Output API* exists for **ADP Link** — a different
   product — and no Workforce Now equivalent was found. **The "checks received / distributed"
   states in the prototype are almost certainly manual states in the ERP, not data from ADP.**
   That is a fine design; it is just not an integration, and the architecture should say so.

The honest formulation: **ERP is the system of record for *what should be paid*. ADP remains the
system of record for *what was actually paid*.** Any design that claims otherwise has to explain
what happens when a practitioner edits the batch — and right now neither draft does.

## Sandbox and Postman

- ADP's developer portal does provide **sandbox/test environment support, Postman/Insomnia
  collections, OpenAPI/Swagger specs, an API Explorer and an OAuth playground**.
- ADP's documented onboarding path is explicitly **Postman first**: test the certificate, Client
  ID, Client Secret and every API you intend to use in Postman, and only then move to your
  development environment.
- **There is no public Postman repository.** The collections are behind the developer portal, and
  the certificate/credentials that make them work are issued per client project. So the answer to
  *"we have an ADP account but no sandbox"* is that the sandbox and the collections both arrive
  with the API Central project — **they are not something to go and find, they are something to
  ask ADP to provision.**

## What to ask ADP, in order

1. ~~Which ADP product is TCG on?~~ **Answered: Workforce Now (classic).**
2. ~~Do we have API Central?~~ **Answered: yes, already entitled.**
3. Provision a **sandbox / test company** and issue the client certificate + Client ID/Secret —
   start in the **API Central Launchpad**, which is live on the account today.
4. Confirm **all TCG earning codes exist in the Paydata validation tables** — including the four
   new Foreman codes (`FRR`/`FRO`/`FRD`/`FRT`) and whatever the Military premium turns out to use.
5. Confirm whether **Memo Code 5 / Earnings Code T** exist per company, or whether we pass
   `autoGenerateMemoCode=false`.
6. Confirm the **payroll cycle window** in practice — how long is the cycle in
   `Entering Payroll Information`, and who moves it?
7. **Ask directly whether any event notification fires on pay-data-batch edits.** This is the
   single question that decides whether the round trip can be automated.
8. Confirm whether a **payroll output / results API** is available on TCG's product, or whether
   post-payroll data is report-only.

---

## Sources

- [Payroll Data Input API Guide for ADP Workforce Now](https://developers.adp.com/articles/preview/guide-payroll-data-input-api--guide-for-adp-workforce-now-0) — chapters 1 and 6 extracted 2026-08-13
- [ADP API Central for ADP Workforce Now — Features](https://apps.adp.com/en-US/apps/410612/adp-api-central-for-adp-workforce-now-and-adp-workforce-now-next-generation/features)
- [ADP Marketplace API Catalog for ADP Workforce Now](https://developers.adp.com/articles/guides/adp-workforce-now-api-catalog)
- [Webhooks — ADP Marketplace Integration Guides](https://developers.adp.com/guides/adp-marketplace-integration-guides/webhooks)
- [ADP Marketplace ESI — Event notifications](https://developers.adp.com/guides/adp-marketplace-integration-guides/event-notifications)
- [Payroll Output API Guide for ADP Link](https://developers.adp.com/articles/guides/payroll-output-api-guide-for-adp-link) — *different product; noted as not-Workforce-Now*
