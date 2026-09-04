---
title: FCC support case 39995 — the November 2025 customer data-sync incident
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/QB_Connector/Regarding Case_ 39995 _ ref_!00DU00Lkpf_!500QO0zDvDV_ref _.msg
migrated: 2026-09-04
updated: 2025-11-12
status: unverified
conflicts_with: []
jira: []
tags: [module/accounting, module/customers, kind/source, integrations, invoicing, data-migration, architecture]
entities: []
---

# FCC support case 39995 — the November 2025 customer data-sync incident

**What this is.** An Outlook message thread, 11–12 November 2025, between TCG IT and Fleet Cost
& Care support, on FCC case **39995**, subject *"Urgent: QB Connector Access Needed Following
Data Sync Issue"*. It is the covering thread under which FCC sent TCG the connector field
mapping ([01-fcc-connector-field-mapping.md](01-fcc-connector-field-mapping.md)), and it is the
event the reimplementation proposal was written in response to.

**Why it matters.** It is the only incident report in the vault for the accounting seam, and it
contains a statement of intent — **NexGen is the master customer database** — that TCG made
under the pressure of having just lost data. It also describes, concretely, how the seam fails.

> **Handle with care.** The message is a `.msg` file for which no Outlook parser was available;
> the text below was recovered by a raw string scan. The quoted passages are contiguous and
> internally coherent, but the **thread is not fully reconstructed** and the reply ordering is
> inferred from the quoted-message markers. Named participants and their email addresses are
> present in the source; only names and roles are reproduced here.

## Who is on it

FCC side: **Paul Paliwoda**, Director, Customer Service (Chicago, IL) — the sender of the
message that carries the case number; **Courtney Wagner**, addressed by TCG; **Nick**, assigned
the case for review; one further FCC support address.

TCG side: **IT Support** (the sender of the substantive reply), with **Wes Staley**,
**Kyle Harlow**, **Sammy Garrett**, **Melissa McNutt**, **Joe Schacatano** and **Brian Petros**
copied. FCC's reply is addressed to *"Patrick"*.

## What FCC said

> *"Case Subject: QB Connector Access Needed Following Data Sync Issue
> Good morning Patrick, Thank you for contacting support, case #39995 was generated and assigned
> to Nick for further review. **Attached is a field mapping documentation for NexGen → QuickBooks
> interface via QODBC.**"*

That attachment is the document now filed as
[01-fcc-connector-field-mapping.md](01-fcc-connector-field-mapping.md).

## What TCG said — the four substantive paragraphs

### 1. The incident, and its mechanism

> *"Our recent issue was resolved as of yesterday evening. Invoices are now progressing
> smoothly, and we can successfully import them into QuickBooks. **It seems that all our
> customers were flagged, prompting a mandatory sync for each.** Given the flurry of activity
> last week, this might have been a contributing factor. It's unclear whether this was due to
> updating all industry codes for our customers or a result of a significant customer file
> cleanup. As we know, **each time an invoice is exported from Nexgen to QuickBooks, it checks
> for new customers and updates existing ones before proceeding with the export.**"*
>
> *"**Since there was no clear indication of the process status during invoice export, many
> users canceled and retried the process.** Although not ideal, we eventually reviewed the QODBC
> logs and identified a few duplicates and email address updates. The QODBC adapter can be
> complex but is manageable with careful log analysis."*

**Three mechanisms named, all confirmed by the mapping document:** invoice export carries an
implicit full customer upsert; a bulk edit on the NexGen side (industry codes, or a file
cleanup) flags every customer for sync; and the export gives the operator **no progress
indication**, so users cancel and retry — producing duplicates.

### 2. The data loss, and the commitment made

> *"**We encountered an unfortunate data sync issue during the full sync of the customer
> database. While using Nexgen as the master customer database, it appears some customer data
> in QuickBooks was manually altered. Consequently, when we completed the full sync, some data
> was removed or overwritten.** We've discussed this and **are committed to using Nexgen as the
> master customer database.** We'll also utilize the Customer contact section for additional
> contact information. More updates to come."*

This is the closest thing in the drop to a stated ownership rule for customer master data, and
it is the same rule the reimplementation proposal formalises
([03-proposed-reimplementation.md](03-proposed-reimplementation.md)). It is a **commitment in
an email**, not a decision note — and it predates the ERP boundary discussion of 2026-09-01 by
ten months.

### 3. What TCG asked for

> *"I met with Brian earlier today… I'm confident we could **enable tracing** to better
> understand the data flow from Nexgen to QuickBooks. On the QuickBooks side, **reviewing the
> Audit log** might reveal what is being updated and stamped."*
>
> *"I believe there might be simpler data mapping schema documents that outline what is
> transferred from Nexgen to QuickBooks. **It would be great to obtain the data mappings for
> each of the below.**"*
>
> *"We also reviewed the QODBC connection setup. **If there's a way to gain read-only access to
> the linked servers or review the XML settings**, it would help us determine how much more we
> can leverage the QODBC connector."*

The read-only-access request is the *"QB Connector Access Needed"* of the subject line, and it
matches the checklist's finding that **TCG cannot change its own integration settings** —
*"This was setup by FCC, so they have to do the updates/changes"*
([02-integration-review-checklist.md](02-integration-review-checklist.md)).

## What this establishes

- The FCC → QuickBooks invoice export is **not** a transfer of invoices alone. It upserts
  customers first, every time.
- A **bulk data operation in NexGen can silently trigger a full customer sync** into
  QuickBooks, overwriting whatever was edited there.
- The export has **no observable progress state**, and cancel/retry produces duplicates.
- TCG's stated position, November 2025: **NexGen is the master customer database**, with
  additional contact detail held in the customer-contact section.
- TCG had, at that point, no read access to the connector's own configuration.

## What it does not establish

Which bulk operation actually caused it, what data was lost, whether anything was restored,
whether FCC ever supplied the further mappings, or whether read-only access was granted. The
thread ends with *"More updates to come."*

The customer-file audit export that sits beside this message in the same folder
([06-quickbooks-customer-contact-export.md](06-quickbooks-customer-contact-export.md)) is
almost certainly the *"significant customer file cleanup"* the message speculates about, or its
verification — but the files themselves do not say so, and this page does not assert it.

## Source

`1.0.2_FCC-RESOURCES-GUIDES/QB_Connector/Regarding Case_ 39995      _ ref_!00DU00Lkpf_!500QO0zDvDV_ref _.msg`
— Outlook `.msg`, 966 KB, recovered by raw string scan (`extract_msg` unavailable), so the
extraction is partial and the file also contains inline images and full mail headers. Personal
email addresses of the named participants are present in the source and were deliberately not
copied.

## Re-parsed 2026-09-04

The `.msg` was re-read with `extract_msg`. Headers: from **Paul Paliwoda, Director, Customer
Service, Fleet Cost & Care (Chicago)**, sent **2025-11-12**, to `itsupport@craneguys.com`; the
original 2025-11-11 message from TCG IT Support was copied to Wes Staley, Kyle Harlow, Patrick
McKiernan, Melissa McNutt, Joe Schacatano and Brian Petros, and to Courtney Wagner at FCC. The
case was **assigned to "Nick"** at FCC. The message carried **one file attachment — `External
Quickbooks Online Integration.pdf`**, byte-identical to the copy already in the `QB_Connector`
folder and migrated as [01-fcc-connector-field-mapping.md](01-fcc-connector-field-mapping.md);
the only other image is FCC's signature graphic. The body text matches the string-scan reading
above in every substantive paragraph; nothing here changes.
