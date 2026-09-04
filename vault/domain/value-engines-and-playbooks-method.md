---
title: Value engines and playbooks — TCG's process-mapping method
source: shared-folder/Project-Repository-2026-09-04/TCG_Value_Engine_SAMPLES-ONLY/ (__TCG_VE_SYMBOLS.xlsx, _TEMPLATE - TCG_NameOfProcess_VALUE_ENGINE.xlsx, TCG Value Engines SHARED.vsdx, zz_ARCHIVE/Visio_Data_Visualizer_Flowchart_Template (1).xlsx, Get Scalable - NOTES - Chapter 01 and Chapter 02.docx — text and its extracted embedded images read)
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/all, kind/sop, requirements, provenance]
entities: []
---

# Value engines and playbooks — TCG's process-mapping method

**What this is.** The house method TCG uses to write down how its business works. A **value
engine** is a one-page flowchart of an end-to-end process; a **playbook** is the numbered SOP for
one step of that flowchart. Both come from Ryan Deiss's book *Get Scalable*, and TCG has adopted
its vocabulary, its five symbols and its five-step mapping process wholesale.

**Why it matters — read this before reading any value engine.** Much of what TCG has given this
project is a value engine: the Sales, Dispatch, Payroll, Accounting, Storage, Safety and Equipment
Onboarding documents cited across this vault are all instances of this form. **This page is what
the form means.** Without it, a `.vsdx` page of forty short labels and a scatter of diamonds is
unreadable; with it, the diamonds are decision gateways, the `(SOP #n)` annotations are pointers to
playbooks, and the swimlane titles are the departments that own each stretch.

> **Method, not product.** Nothing on this page is a requirement of the platform. It describes how
> the client documents processes, so that the documents can be read correctly.

---

## What a value engine is

From TCG's own notes on *Get Scalable* chapter 2, quoted almost verbatim in both the notes
document and the workbook template:

> A Value Engine is a visual representation of how a company creates and captures marketplace value
> through the (1) acquisition of new customers, (2) fulfillment of existing customers, and (3)
> creation and/or improvement of the company's product and service offerings.

Three kinds follow from those three clauses, and a fourth is called out separately:

| Kind | Visualises |
| --- | --- |
| **Growth Engine** | The process by which new customers are acquired and sold |
| **Fulfillment Engine** | The process by which those customers receive the promised value after the sale |
| **Internal Fulfillment Engine** | Operational and administrative functions — the notes name **Accounting, HR, Production** |
| **Innovation Engine** | The process by which product and service offerings are created, updated and improved |

Reading TCG's own material against this taxonomy: *Sales Lead to Dispatch* is a growth engine;
*Field Personnel*, *Storage* and *Dispatch* are fulfilment engines; *Payroll*, *Accounts
Payable/Receivable*, *Safety & Audits* and **TCG IT's own App Development and Change Management
engines** are internal fulfilment engines. Nothing in the drop is presented as an innovation
engine.

## What a playbook is

A playbook is the SOP for **one numbered step** of a value engine. The flowchart carries `(SOP #1)`,
`(SOP #2)`, `(SOP #3)` annotations, and a matching document exists for each. The document template
TCG uses — visible in all nine
[TCG IT playbooks](tcg-it-value-engines-and-playbooks.md) — has a fixed shape:

```
Header table   Created by · Created on · Last update ·
               Associated Value Engine(s) · Playbook Owner(s) · Team
Overview       when to use it, and what it achieves
Walkthrough    a link or embed of a video walking through the playbook
Playbook       numbered steps, with an "Inputs required" list nested under step 1
Resources      tools and links needed to run it
Decision Rules the criteria that resolve the flowchart's decision diamonds
Definition of  the condition under which the step is complete
  Done
Tools Used     the systems it runs in
```

So the flowchart answers *what happens next*, and the playbook answers *what has to be true for it
to happen*. **The Decision Rules section is where a diamond in the diagram becomes a stated rule** —
which is why a value engine on its own is never a sufficient source for a requirement.

## The symbol set

Five symbols, given identically in three places (`__TCG_VE_SYMBOLS.xlsx`, the `SYMBOLS` sheet of the
blank template, and the *Get Scalable* notes):

| Symbol | Means |
| --- | --- |
| Terminator | Start / end of any process map |
| Process | A standalone task, activity or step |
| Decision | A decision point or gateway |
| Data | Data input / export |
| Connector | A directional connector between steps |

> The shapes themselves are images in every source and are **not recoverable as text**. Only the
> five names and meanings above survive conversion. The symbols workbook also distinguishes shapes
> that "move with text" from those that "do not move with text" — a Visio layout property, not a
> semantic one.

## How one is authored — the five-step mapping process

1. **Identify the value engines to be mapped.** Start with the most valuable products/services.
2. **Define the triggering (start) and ending events.** The notes give the canonical pairs:
   growth engine starts at *advertisement* and ends at *agreement/contract*; fulfilment engine
   starts at *completed purchase* and ends at *follow-up with the customer after delivery of
   service*.
3. **Brainstorm the tasks and activities** between the triggering and ending events.
4. **The stakeholder review.**
5. **Publish your value engines.**

Step 4 is the only quality gate in the method, and the sources do not say who the stakeholders are
or what approval looks like.

## The authoring toolchain

Three artefacts in the drop, each a different way of producing the same diagram:

**`_TEMPLATE - TCG_NameOfProcess_VALUE_ENGINE.xlsx`** — the blank TCG starts from. Four sheets:
`GET_SCALABLE_NOTES` (the chapter-2 notes, reproduced in every new file so the method travels with
the artefact), `SYMBOLS`, `TCG_NameOfProcess_NOTES` (empty) and
`TCG_NameOfProcess_VALUE_ENGINE` — the drawing canvas itself, an Excel sheet with shapes laid on
it. The demo content left in the blank is a **Receiving** value engine for "TCG or Loading
Customers", with `(SOP #1)` through `(SOP #7)` annotations positioned across the flow. **The
diagram is drawn as floating shapes over a spreadsheet**, so converting it to text yields the
annotations and titles but not the shapes or their connections.

**`TCG Value Engines SHARED.vsdx`** — the shared Visio stencil/workbook, four pages, one value
engine per page. See
[wes-whiteboard-value-engines.md](wes-whiteboard-value-engines.md) for what those four pages
contain.

**`zz_ARCHIVE/Visio_Data_Visualizer_Flowchart_Template (1).xlsx`** — a different and more
machine-readable approach: a **table that generates a Visio diagram**, via the *Visio Data
Visualizer* Excel add-in. Its README gives the workflow: keep the file in OneDrive or SharePoint →
Insert → Get Add-ins → *Visio Data Visualizer* → "Create from data" → basic or cross-functional
flowchart → point it at the `ProcessMap` sheet → the diagram generates and **stays linked to the
table**.

Its `ProcessMap` columns are the whole data model of a value engine expressed as rows:

| Column | Meaning |
| --- | --- |
| `Process Step ID` | Stable identifier (`S1`, `P_AP1`, `D_METHOD1`, `E_PAID` — S/P/D/E prefixes for start, process, decision, end) |
| `Process Step Description` | The label |
| `Next Step ID` | Comma-separated for branches (`P2,P3`) |
| `Connector Label` | The branch label (`Yes/No`, `Cash/Check/EFT`) |
| `Shape Type` | Start/End · Process · Decision · Subprocess · Data · Terminator |
| `Function` | **becomes a swimlane** — the department or role |
| `Phase` | optional stage grouping |
| `Hyperlink`, `Notes` | become shape data in Visio |

This is the only representation in the drop in which a value engine is **structured data rather
than a picture**, and it is the one worth knowing about: a process captured this way can be
diffed, queried and reviewed. The archived copy is populated with an accounts-payable /
collections / deposit flow — see
[wes-whiteboard-value-engines.md](wes-whiteboard-value-engines.md).

---

## Provenance of the method

*Get Scalable* by **Ryan Deiss** (Scalable.co, 2023, ISBN 979-8-9886737-0-5) is in the drop as a
full PDF. It is a **commercially published third-party book** and has **not** been migrated into
this vault; only TCG's own chapter-1/chapter-2 notes have, and those are what this page is built
from. Quote it sparingly and by attribution.

## What the embedded images show — read 2026-09-04

Three of the notes file's eight images were extracted and read on 2026-09-04 — `image1`, `image2`
and `image8`. The five symbol illustrations (`image3`–`image7`) were **not** among the extracted
set, so the statement above that the shapes are unrecoverable as text still stands.

- **Image 1 — the book cover.** *Get Scalable — The Operating System Your Business Needs to Run
  and Scale Without You*, Ryan Deiss. Decorative.
- **Image 2 — the operating-system pyramid** (placed at the head of the chapter-2 notes). It puts
  value engines inside a wider framework the notes never mention. Three tiers, bottom to top:
  **Set of Algorithms** — *Value Engines* (shaded black, the chapter's subject), *Playbook
  Library*, *H.O.T. Canvas*; **Common Language** — *Company Scorecard*, *Meeting Rhythm*;
  **Desired Outputs** — *Clarity Compass* at the apex, under a flag. So value engines and the
  playbook library are two of the three "algorithm" elements, and they are the only two that
  appear anywhere in TCG's material in the drop. Nothing in the drop shows TCG adopting the
  scorecard, meeting rhythm, H.O.T. canvas or clarity compass.
- **Image 8 — the book's example growth engine** (placed after the five-step mapping process). A
  hand-drawn-style flowchart: three sources (*FB/IG*, *Google Ads*, *Events*) → *Landing Page /
  Lead Form* → ◇ *Qualified?* — No → *Add To Email List* → back to the landing page; Yes → *Book
  Call* → ◇ *Show Up?* — No → back to *Book Call*; Yes → *Sales Demo* → ◇ *Schedule Follow Up?*
  — Yes → *Present Offer*; No → *30-Day Follow Up* → back to *Sales Demo* → ◇ *Closed/Won?* —
  Yes → *Sign Contract* → **$$$$** (terminator); No → *30-Day Follow Up*. It illustrates the
  step-2 rule — a growth engine starts at advertisement and ends at a signed contract — and shows
  every decision diamond with a labelled Yes/No exit and a loop back. The example is the book's,
  not TCG's.

## Source

- `TCG_Value_Engine_SAMPLES-ONLY/Get Scalable - NOTES - Chapter 01 and Chapter 02.docx` — 2.2 KB as
  converted text, pandoc GFM. Despite the filename it contains **only chapter 2**, "Mapping Your
  Value Engines"; there are no chapter-1 notes in the file. Its five symbol illustrations are
  images and did not convert; three other images (cover, pyramid, example flowchart) were read on
  2026-09-04 — see *What the embedded images show*.
- `TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/zzzOTHER/__TCG_VE_SYMBOLS.xlsx` — 378 bytes as
  converted text; one `SYMBOLS` sheet, five rows, shapes as embedded images.
- `TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/zzzOTHER/_TEMPLATE - TCG_NameOfProcess_VALUE_ENGINE.xlsx`
  — 2.7 KB as converted text, four sheets as described above.
- `TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/zzzOTHER/FLOWCHARTS_VALUE_ENGINES/zz_ARCHIVE/Visio_Data_Visualizer_Flowchart_Template (1).xlsx`
  — 9.1 KB as converted text; sheets `ProcessMap` (46 rows), `Sheet1` (a draw.io-shaped variant) and
  `README`.
- `TCG_Value_Engine_SAMPLES-ONLY/Get Scalable - BOOK.pdf` — **not migrated**; third-party
  commercial reference, recorded for provenance only.
