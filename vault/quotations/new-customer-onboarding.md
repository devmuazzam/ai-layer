---
title: New customer onboarding — the playbook, the packet and the tiering rule
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/New Customer Playbook.docx and New Customer Packet 1.14.26_1.pdf
migrated: 2026-09-04
updated: 2026-05-12
status: unverified
conflicts_with: []
jira: []
tags: [module/customers, module/quotations, module/accounting, kind/sop, compliance, requirements, reference-data]
entities: []
---

# New customer onboarding — the playbook, the packet and the tiering rule

**What this is.** The **New Customer Playbook** (Ryan Adams, created and last updated
**2026-05-12**, Team Sales, Associated Value Engine *Leads*) and the **New Customer Packet**
(`1.14.26`), the six-document bundle it sends. Together they define what must be true about a
customer before a crane is dispatched.

**Why it matters.** The quotation flow assumes a customer exists; the T&C on every quote says
*"For all first time customers their first job is COD with a 50% deposit required"*
([quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §7). **This playbook changes that
rule**, and it is the only document in the vault that describes credit tiering, the packet's
contents or the AR handoff.

> **The playbook announces a policy change:** *"**Effective immediately, first-time jobs for new
> customers are no longer automatically treated as COD only.** The sales team is responsible for
> evaluating the size and type of customer before determining payment expectations and submitting
> documentation to Accounts Receivable."* Its objective: *"provide flexibility for larger,
> established Tier 1 customers while minimizing financial risk on smaller or unestablished
> accounts."*

---

## 1. The tiering decision

**Step 1 — identify the customer type.** Evaluate on: company size · industry reputation ·
payment reliability/history if known · scope and value of work · *"Whether the customer is a
**Tier 1 contractor, utility, municipality, or established corporation**."*

| Given as Tier 1 examples | Given as smaller-customer examples |
| --- | --- |
| Southern California Edison · major utility contractors · large union contractors · national or regional construction firms · established industrial clients | Small owner-operators · mom-and-pop companies · small local subcontractors · first-time residential or small commercial customers |

**The decision guideline, verbatim:**

| Customer type | Deposit required | Terms consideration |
| --- | --- | --- |
| **Tier 1 / Large Established Company** | **No deposit required** | **Request payment terms review** |
| **Small / New / Unestablished Company** | **Yes** | **Remain COD until payment history established** |

**This is a two-tier rule with a judgement gate and no threshold.** The criteria are qualitative
("industry reputation", "company size") and the document gives examples rather than tests.
Nothing states who decides in a disputed case; §4 puts the *recommendation* on Sales and the
*decision* on AR.

## 2. The packet, and a stated conflict

The playbook lists the packet as: **Welcome Letter · Credit Card Authorization Form · Credit
Application Form · Deposit Form · Preliminary Notice Information Request Form · W-9 · Company
Capability Statement & Services Information.**

Its *required documents* list is slightly different — it adds **Signed Quote** and marks the
Capability Statement as *"optional reference material"*:

1. Credit Application Form
2. Credit Card Authorization Form
3. **Signed Quote**
4. Deposit Form (if applicable)
5. Preliminary Notice Information Request Form
6. W-9 (provided by TCG)
7. Capability Statement (optional)

**Important notes to communicate, per the Welcome Letter:**

- Payment may be made by **cash, check, ACH, or credit card**
- **QuickBooks invoices will be emailed after the job**
- *"**If no invoice response is received within 24 hours, payment may be processed using the card
  on file**"*
- *"**Customers must complete all forms before dispatching the crane**"*

> ### The packet and the playbook state different payment defaults
>
> The **Welcome Letter** in the packet says, unconditionally: *"As a new customer, we require a
> **50% deposit for the first job as well as the remaining balance to be paid on COD terms**."*
> The **playbook** says Tier 1 customers need no deposit and may be put up for terms review.
>
> **The Operating System Architecture flags this itself** as a governance decision still open:
> *"Confirm the final payment policy **where the New Customer Playbook and New Customer Packet
> contain different default deposit/COD rules**."* See
> [sales-operating-system/01-operating-system-architecture.md](sales-operating-system/01-operating-system-architecture.md)
> §12. **It is unresolved in this drop.** A third value exists too: the quote T&C's *"net 15 days
> from date of invoice"* for account holders, and the intake sheet's `CreditTerms` dropdown offers
> Net 15/30/45/60 ([sales-intake-and-job-walk.md](sales-intake-and-job-walk.md) §3).

> **A different version of the packet is also in this drop.**
> [customers/new-customer-packet.md](../customers/new-customer-packet.md) was written from
> `New Customer Packet 10-23-2025_1[70].pdf` in `TCG_FORMS_(paper_and_electronic)/`; this page's
> packet is `New Customer Packet 1.14.26_1.pdf` from Ryan's sales-process folder. **Two dated
> versions, October 2025 and January 2026.** The January copy is the one the playbook links to.
> Anyone specifying the packet should diff them; **nothing in the drop says the older one is
> retired.**

## 3. What the packet forms actually capture

Transcribed from the PDF's form fields. **No completed data exists in the file — it is a blank
packet.**

**Welcome Letter** — narrative, plus: *"If a different contact is needed to review and approve the
invoice, please include them on this email."*

**Credit Card Authorization** — Company Name · Address / City / State / Zip · E-Mail · Phone · Fax
· **Contractor License #** · **Union Affiliation (Yes/No)**; then billing information: card type,
name on card, company name on card, billing address, state/province, zip, billing phone, card
number, expiration, security code. The authorisation text: *"I authorize The Crane Guys, LLC to
charge my credit card for current and future purchases verbally (or written) approved by me and
am aware of the **3% service fee** for each use of my credit card."* Three invoice/amount pairs at
the foot for recording charges.

> **The card fields are collected on paper and the form says TCG keeps a *"card on file"*.** Any
> ERP that reproduces this form inherits a PCI-scope decision. **Nothing in the drop addresses
> it.**

**Credit Application Form** — Company Name · Address · State/Province/Zip · **E-Mail for
processing Invoices** · Phone · Fax; General Information: **Federal Tax Id #** · State of
Corporation · **Company Composition** (Individual / Partnership / LLC / Corporation / Sub-Chapter
S Corp) · Principal/Owner(s) ×2 with address, phone and email · **Union Affiliation and Name of
Union**; **Bank Information** (bank name, bank contact and number, address, type of account and
account number); **two trade References** each with name, address, phone/fax, email,
**Relationship, Years Known, Type of Account, Account Number**.

Its terms: *"Agrees **all accounts are COD until a credit application has been completed,
reviewed, and approved.** … Any balance so remaining unpaid shall bear interest at the lesser rate
of **1.5% per month** or the maximum rate permitted by applicable law."*

**Deposit Form** — Customer Name · **Date of Job** · **Quote #** · Sales Representative Name ·
Job Address · **Prevailing Wage (Yes/No)** · Method of Payment (Credit Card / Check / **ACH — "For
ACH please call for account information"**).

**Preliminary Notice Information Request Form** — Customer Name · Date · **Job #** · **P.O. #** ·
**Prevailing Wage (Yes/No)**; then name/address/phone for each of **Job Information**, **Owner**,
**Original Contractor**, and **Sub-Contractor (Our Customer)**; signed and dated.

**W-9** — TCG's own, Rev. March 2024: *"The Crane Guys, LLC"*, federal tax classification **LLC
taxed as S corporation**. `[TCG's EIN appears on this form in the source file — deliberately not
copied.]`

**Three things worth carrying into a data model.** The **Deposit Form and the Preliminary Notice
form both ask "Prevailing Wage: Yes/No"** — so prevailing-wage status is captured at customer
onboarding *and* at quote *and* by the Labor Compliance form, three times. **Union Affiliation is
asked of the customer** on two forms. And **the Preliminary Notice form is the mechanism behind
the quote's clause 20**, *"All jobs over $500 will be pre-liened per California law"* — it
collects the owner and original-contractor chain a California preliminary notice needs.

## 4. Steps 3–5 — review, submit, confirm

**Step 3 — review the completed packet.** A 10-item checklist:

☐ Signed quote received ☐ Credit application completed ☐ Credit card authorization completed
☐ Deposit form completed (if required) ☐ Preliminary notice form completed ☐ Customer contact
information verified ☐ **Billing email verified** ☐ **Tax ID/EIN included** ☐ **References
included on credit application** ☐ Signatures and dates completed

**Commonly missing:** missing billing contact email · unsigned credit application · **missing bank
references** · missing credit card information · **missing jobsite or PO information**.

> *"**Do not submit incomplete packets to AR.**"*

**Step 4 — submit to Accounts Receivable.** The submission itself is differentiated:

| For a Tier 1 customer, note clearly | For a smaller customer, submit as |
| --- | --- |
| *"Tier 1 Customer"* · *"Requesting payment terms consideration"* · *"Deposit not required"* — with supporting factors: established company, large contract value, recognised industry reputation, existing relationships with utilities or major GCs | COD customer · deposit required · *"Standard payment policy applies until payment history is established"* |

**Step 5 — confirm setup and job readiness.** After AR review: confirm the customer has been
entered into the system · verify payment status/terms · verify deposit status · **confirm dispatch
is approved** · **ensure the invoice contact is correct in QuickBooks**.

> *"**Only schedule and dispatch the crane once:** customer setup is complete, required payment
> arrangements are confirmed, **and signed quote has been received.**"*

That is the same gate the Master Process Map calls stage 6 *Customer Approval & Commercial
Clearance* and the architecture calls **Gate 4 — Financially Cleared**. Here it is stated as a
hard dispatch precondition.

## 5. What this means for the ERP

Nothing in the drop asks for any of this to be built, so the following are observations, not
requirements:

- **"Tier 1" is a customer attribute that drives payment terms** and has no counterpart in the
  vault's customer model. The HubSpot playbook asks for a *"Customer type (Utility, General
  Contractor, Industrial, Commercial, Municipality, EPC Contractor, etc.)"* field
  ([hubspot-sales-playbook.md](hubspot-sales-playbook.md) §3), which is a different axis.
- **The packet is a document bundle with a completion state**, and the ERP review log already
  carries a client request for exactly this: *"**Automatic customer packet generation** — Maybe we
  create a template"* ([erp-review-log.md](../erp-review-log.md) → *#3*). **This is the packet
  that request is about.**
- **Dispatch readiness depends on an AR outcome**, so the customer record needs a
  credit/terms/deposit status that scheduling can read.

## Source

- `3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/New Customer Playbook.docx`
  — 5 KB docx → pandoc gfm. Ryan Adams, 2026-05-12. Complete.
- `…/New Customer Packet 1.14.26_1.pdf` — multi-form PDF, `pdftotext -layout`. **Blank forms; no
  customer data.** TCG's EIN on the W-9 was deliberately not copied. Form field lists above are
  transcribed from the PDF's own labels.
