---
title: Equipment on-boarding — the value engine and the FCC creation playbook
source: shared-folder/Project-Repository-2026-09-04 — TCG_Value_Engine_SAMPLES-ONLY/2026-06-23 samples/Equipment ON-Boarding Value Engine (1).pdf, TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/TCG FLEET - FCC Equipment Creation Playbook.docx
migrated: 2026-09-04
updated: 2026-06-23
status: unverified
conflicts_with: []
jira: []
tags: [module/assets, module/vendors-agencies, kind/sop, permits, compliance, tools-rigging, inspections, provenance]
entities: []
---

# Equipment on-boarding

**What this is.** How a newly acquired crane, truck or trailer becomes a dispatchable asset at TCG
— as a one-page process diagram (the *value engine*) and one of the playbooks it points at. Both
came from the `TCG_Value_Engine_SAMPLES-ONLY` folder, which is TCG's own set of process maps built
on the *Get Scalable* method described in
[storage-and-warehouse-operations.md](storage-and-warehouse-operations.md) §4.

> **Both documents are thin, and that is the finding.** The value engine is a diagram whose boxes
> converted to text but whose arrows did not; the playbook is a five-step stub with placeholder
> sections still in it. Neither states a rule, an owner per step, or a required field. They tell
> you the **shape** of on-boarding and nothing more.

---

## 1. The on-boarding value engine

*Source: `Equipment ON-Boarding Value Engine (1).pdf`, 1 page, landscape process diagram.
`pdftotext -layout` recovered the box labels; **the connectors, swimlanes and gateway directions
did not convert**, so the sequence below is read off the horizontal layout and should be treated
as approximate.*

The main line, left to right:

```
Equipment On-Boarding → Notification of New Equip → Docs Provided → Profile Created In FCC (Play Book)
  → Permits → Insurance → Registration → Transport → Take Delivery / Inspection (Playbook)
  → Upfitting → In Service
```

Three decision points (`Y` / `N`) branch off it:

| Decision | Yes branch |
| --- | --- |
| after **Profile Created in FCC** | **Order Permits Through Dispatch** |
| **Rigging**? | **Order Rigging (Playbook)** |
| **Decals**? | **Coordinate with Vendor** |

A `S&S Reg.` box sits above the Registration step, and **Safety Equipment** and **Dispatch** boxes
sit off the later stages. `Upfitting` runs into `In Service`, which is the terminal state.

**Two things the diagram establishes:**

1. **The FCC profile is created early — before permits, insurance, registration and delivery.** The
   asset record exists while the machine is still being bought, not when it arrives. So an asset
   has a meaningful life before it is dispatchable, and `In Service` is a distinct state at the far
   end of the line.
2. **Three steps are marked `(Playbook)`** — *Profile Created In FCC*, *Take Delivery / Inspection*,
   and *Order Rigging*. Only the first is in this drop (§2). The delivery-inspection and rigging
   playbooks are referenced and **not supplied**.

The diagram carries no owner, no SLA, no required documents beyond the box labelled *Docs
Provided*, and no definition of `S&S Reg.`, `Upfitting` or `Decals`.

---

## 2. The FCC equipment creation playbook

*Source: `TCG FLEET - FCC Equipment Creation Playbook.docx`.*

| | |
| --- | --- |
| Created by | **Jeff Stricker** |
| Created on | **2026-05-11** |
| Last update | 2026-05-11 |
| Associated Value Engine | **Equipment Onboarding** |
| Playbook Owner | Jeff Stricker |
| Team | *(blank)* |

**Overview:** *"This playbook will demonstrate how to create a new unit in FCC."*

**The procedure, complete and verbatim:**

1. Log into FCC
2. Select Units Tab on Top Task Bar
3. Select New Unit Tab on Top Task Bar
4. **Input Data in required fields**
5. **Upload File Documentation and Save**

That is the whole of it. The template's own instruction text is still present unedited —
*"Create a step-by-step procedure to complete this process. Add screen recordings and images to
provide a visual aid"*, a *Walkthrough Video* section reading *"Embed or link to a video walking
through completing this playbook"*, and a *Resources* list holding two literal
`Resource/Tool` placeholders. **No video, no screenshots, no resources.**

**What step 4 does not say is what the required fields are.** The drop answers that from the other
side: the FCC *Unit Data* import template marks which fields are required, with lengths and code
domains, and it is transcribed in
[fcc-units-and-schedule-types.md](fcc-units-and-schedule-types.md) §6. Step 5's *"File
Documentation"* is the asset-attachments ask in
[asset-record-requested-additions.md](asset-record-requested-additions.md) §2.

`jstricker` also appears as the `CreatedBy` on the newest FCC unit types — Pilot Truck, Man Basket,
Two Way Radio, Boom Dolly, 110 Ton All Terrain Crane, 275 Ton All Terrain Crane — so the playbook's
author is the person who has actually been creating these records.

---

## 3. Open, for the human

Observations only; not written to any gaps register.

1. **Three playbooks are named and two are missing** — delivery/inspection and rigging. If they
   exist, they are not in this drop.
2. **`In Service` is a state the ERP would need**, and no source in the vault defines TCG's asset
   lifecycle states. FCC has only `Status` Active/Inactive and `OwnedOrRent`.
3. **`S&S Reg.`, `Upfitting`, `Decals` are undefined terms** appearing nowhere else in the drop.
4. Whether permits ordered *through Dispatch* at on-boarding are the same permit entity as job
   permits is unstated.

---

## Source

- `TCG_Value_Engine_SAMPLES-ONLY/2026-06-23 samples/Equipment ON-Boarding Value Engine (1).pdf` —
  1 page, process diagram; box labels only, connectors lost in conversion
- `TCG_Value_Engine_SAMPLES-ONLY/2026-06-16 samples/TCG FLEET - FCC Equipment Creation Playbook.docx`
  — 1 page, converted by pandoc; reproduced above in full apart from template boilerplate
