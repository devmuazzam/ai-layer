---
title: Sub out — hiring another crane or trucking company for a job
source: shared-folder/Project-Repository-2026-09-04/TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/TCG Dispatch - VALUE ENGINES and PLAYBOOKS/Sub Out.docx and TCG Dispatch Sub Out Playbook.docx
migrated: 2026-09-04
updated: 2026-05-14
status: unverified
conflicts_with: []
jira: []
tags: [module/vendors-agencies, module/dispatch, kind/sop, purchase-orders, scheduling, daily-allocation]
entities: []
---

# Sub out — hiring another crane or trucking company for a job

**What this is.** Dispatch's procedure for subbing work out to an outside crane or trucking
company when TCG is overbooked. Two files from the Value Engine sample set: a **playbook
cover sheet** created by **Lisette Anzaldo on 14 May 2026** (Team: Dispatch; Playbook Owner:
Lisette; Associated Value Engine: Sub Out), and the substantive **`Sub Out.docx`** it links
to. It sits in this module rather than `dispatch/` because the transaction it describes is a
**vendor engagement** — approved vendor, negotiated rate, PO number — but it is Dispatch's
procedure and is tagged `module/dispatch` accordingly.

Its opening framing:

> "When subbing out work is needed, it is important that everyone is aware and we follow the
> necessary steps: getting the right equipment, negotiating rates, providing PO, receiving
> jobs tickets, invoicing the customer, etc."

That sentence names the whole chain, but the document itself only covers up to sending job
details to the sub. Rate negotiation, ticket receipt and customer invoicing are named as part
of the process and then **not described anywhere in either file**.

## Subbing out a crane

**Before committing:**

1. **Confirm with the project manager / accounting that the crane company is an approved
   vendor.** This gate comes first, before any contact.
2. Reach out to the crane company by email or phone to check a crane is available.

**Once the company confirms:**

1. **Notify the customer that we are subbing out the equipment.**
2. **List the company covering the work under the "Equipment Section"** — the document's
   example is `40 ton (subbed to Hydraulic)`.
3. **Send job information to the covering company by email, CC'ing the Project Manager and
   Accounting.** It must include:
   - Description of work with equipment required — include the job layout if available
   - Onsite contact
   - Reporting time
   - **PO number** — the document's example is `OM-1234`, with the note *"Reference to PO #
     Playbook"*. That referenced PO playbook is **not in this drop**; the closest written
     source is [purchase-orders-fcc/](purchase-orders-fcc/INDEX.md), which covers third-party
     crane companies under PO-001's Dispatch scope. Note that `OM-1234` is the shape of a TCG
     **job/quote** number, not of an FCC PO number — the document does not explain which is
     meant.
4. **Update the dispatch sheet.**

**Closing instruction, verbatim:** *"If we sub a crane, we should do our best to be there the
day of onsite."*

## Subbing out trucking

**Before committing:**

1. **Confirm with the project manager / accounting that the trucking company is an approved
   vendor.**
2. Reach out by email or text to check availability. The worked example is a text to Piazza
   Trucking: *"Hello, do you have a stretch trailer to haul poles?"*

**Once the trucking company confirms:**

1. **Add the details to the "In-house Comments"** — example: *"Piazza Trucking provided a
   stretch trailer to haul poles"*.
2. **Text or email the job details**, which must include:
   - Description of work with equipment required
   - Onsite contact
   - Reporting time
   - **PO number** — same example, `OM-1234`, same reference to the PO playbook
   - **Ask for the driver's contact**
3. **Update the dispatch sheet.**

## The two paths compared

| | Crane | Trucking |
| --- | --- | --- |
| Approved-vendor check | Yes — PM / accounting | Yes — PM / accounting |
| Contact channel | Email or phone | Email or text |
| Customer notified? | **Yes, explicitly required** | **Not mentioned** |
| Where the sub is recorded | Equipment Section — "40 ton (subbed to Hydraulic)" | In-house Comments |
| PM and Accounting CC'd | Yes, on the job-info email | Not mentioned |
| Driver contact requested | Not mentioned | Yes |
| Dispatch sheet updated | Yes | Yes |
| TCG presence onsite | "do our best to be there the day of onsite" | Not mentioned |

The asymmetries are as the source has them. **The document does not say whether the crane-side
steps that are absent from the trucking side — notifying the customer, CC'ing PM and
accounting — are deliberately not required for trucking, or simply not written down.**

## The playbook cover sheet

`TCG Dispatch Sub Out Playbook.docx` is a **template that was never filled in**. Its Overview
reads *"When overbooked with cranes or trucking service and find an approved company that can
help us cover the job."* Its Walkthrough Video section still carries the template's own
instruction text ("Embed or link to a video walking through completing this playbook"), its
Playbook section says only *"Please see attached link"*, and **Steps 1 through 5 are all
empty headings**. Its single Resource is a SharePoint link to `Sub Out.docx`. So the playbook
adds metadata — owner, team, date, value-engine name — and no procedure.

| Field | Value |
| --- | --- |
| Created by | Lisette Anzaldo |
| Created on | 5/14/26 |
| Last update | 5/14/26 |
| Associated Value Engine | Sub Out |
| Playbook Owner | Lisette |
| Team | Dispatch |

## Where this meets the PO policies

[PO-001](purchase-orders-fcc/po-001-pre-job-purchase-orders.md) puts trucking/staking vendors
such as Piazza squarely in Dispatch's PO scope, and
[purchase-order.md](purchase-order.md) lists third-party crane companies
(Bragg, Hydraulic) as a PO sub-type used "when company cranes are unavailable" — matching this
document's Hydraulic example. **Neither sub-out file says who raises the PO or when in the
sequence**; both simply assume a PO number exists by the time job details are sent to the sub.
`purchase-order.md` says Liz creates the PO after the PM asks her to; this document says
Dispatch confirms the vendor is approved with the PM and accounting first. The two accounts
are compatible but neither states the ordering.

## Source

- `TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/TCG Dispatch - VALUE ENGINES and PLAYBOOKS/Sub Out.docx`
  — .docx → pandoc GFM, ~2.2 KB. Six embedded screenshots (an availability email, the
  Equipment Section, two job-detail messages, two dispatch-sheet views) were **not** converted,
  so the field layout of the dispatch sheet and the exact wording of the example emails are
  not recorded.
- `TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/TCG Dispatch - VALUE ENGINES and PLAYBOOKS/TCG Dispatch Sub Out Playbook.docx`
  — .docx → pandoc GFM, ~1.1 KB. Metadata table and unfilled template.

Both come from the `SAMPLES-ONLY` tree, dated 2026-06-16 in the folder name; the playbook's
own created/updated date is 2026-05-14, which is what `updated:` records.
