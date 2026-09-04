---
title: Creating Quotes SOP — TCG's own quoting procedure
source: shared-folder/Project-Repository-2026-09-04/3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/ — Creating Quotes SOP (1).pdf, Creating Quotes in FCC Playbook.docx, and the FCC SOP Training Guide / Step Library sheets of Sales Admin 60 day training.xlsx
migrated: 2026-09-04
updated: 2026-05-11
status: unverified
conflicts_with: []
jira: []
tags: [module/quotations, module/customers, kind/sop, lift-plans, pricing, requirements, reference-data]
entities: []
---

# Creating Quotes SOP — TCG's own quoting procedure

**What this is.** TCG's internal, branded procedure for building a quote, as against the FCC
vendor manual. A 31-page illustrated PDF, a one-page Playbook wrapper by **Ryan Adams (created
2026-05-11)**, and a training-workbook restatement that breaks the same procedure into
pass/fail steps. All three describe the same path and cite each other, so they are treated as one
procedure here.

**Why it matters.** It is the only document in the vault that states **how TCG decides what to
put in the quote** — the questions asked on the call, the arithmetic for lift radius, the
meaning of each Lift Info field, and the review gate before a quote reaches a customer. The FCC
manuals say where the fields are; this says what goes in them.

---

## 1. Who does this, and when

The PDF opens: *"**Dispatch and Sales Coordinators** receive numerous calls each day related to
pricing, quotes, and scheduling for returning and new customers. During each call, it is
essential to ask targeted questions and collect comprehensive job information. This allows the
crew and operator to be fully prepared for the lift on the scheduled date."*

The Playbook header records: Team **Sales**; Associated Value Engine **Leads**; created and last
updated **2026-05-11**; Playbook Owner blank.

## 2. The six intake questions

Asked on the call, before anything is entered:

1. **Crane setup location** — *"Where will the crane be set up?"*
2. **Site obstructions** — *"Are there any obstacles we should know about?"* — *"trees, power
   lines, gates, walls, or anything in the lift path."*
3. **Item being lifted** — *"What exactly are we lifting?"*
4. **Item weight** — *"How much does the item weigh?"*
5. **Reach / distance** — *"What is the distance from the center of the crane to where the item
   will be placed?"*
6. **Lift height** — *"How high will we lift and set the item? Ground level, rooftop, or other
   elevated locations?"*

The training workbook's Step Library expands the same track with four more: greeting and caller
control, **dimensions** (length, width, height, centre-of-gravity concerns, whether rigging
points exist), **photos and documents** (setup area, pick/set locations, path of travel, load
tag, drawings, cut sheets) and a **lead recap** — *"Repeat the facts back to the customer before
ending call."*

## 3. Calculating the lift radius when the customer cannot

The SOP's fallback, which is the only piece of quoting arithmetic written down anywhere in the
vault:

> If the customer does not know the radius, ask instead:
> 1. **Crane setup proximity** — *"How close can the crane be set up next to the building or
>    other structures?"*
> 2. **Item placement distance** — *"How far from the edge of the building does the item need to
>    be placed?"*
>
> **Lift Radius = Distance from crane to building + Distance from building edge to item
> placement.**

Worked example, verbatim: crane setup distance from building 20 ft, item placement 30 ft from the
edge, building 1 storey / 15 ft, item weight 500 lb → **radius 50 ft**.

Then the safety margin rule:

> *"Take the customer's measurements from the phone call as a baseline, but **it's recommended to
> add an extra 5–10 ft for simple lifts like an AC swap** to provide a safety margin."*

Second example with the margin applied: 20 + 30 + 5 = **55 ft**.

**The SOP does not say when the margin is not added**, nor whether the quoted radius or the raw
customer figure is the one that reaches the operator.

## 4. Entering the quote

`Enter → Job Quotes`. New customer → **New**, entering company name, contact person(s), phone
numbers (main and direct), email addresses (general and direct), physical **and** billing
addresses. Returning customer → pick from the dropdown.

Additional contacts: Contact tab → right-click → **Add Contact**; *"At minimum, enter the
contact's name and phone number."*

Save, then wait: *"The system may take **30 seconds to 1 minute** to finalize and save the
account. Wait until you see the account appear on the original Job Quotes page before
proceeding."*

Job site: from the Job Quotes page, **Jobsite → New**, fill the fields marked in red, save.

Then the four Main-tab fields the SOP prescribes conventions for:

| Field | TCG's rule |
| --- | --- |
| **Salesperson** | *"Enter your name (the person creating the quote)."* |
| **Taken By** | *"Enter your name (you are the person taking the call or entering the info)."* |
| **Checked By** | **"Always enter 'Customer' unless you have personally visited the jobsite and gathered measurements yourself."** |
| **Equipment Required** | *"List all machines and equipment needed for the job (e.g. **22 Ton Crane + Trucking**)."* |
| **Description of Work** | *"Provide a simple, clear explanation of the crane task on the job (e.g. **'Lift AC unit onto rooftop'**)."* |

> **`Checked By` records who verified the measurements, not who reviewed the quote.** That is a
> materially different meaning from the one the field name suggests, and it explains the real
> quote OM-36229, whose Equipment Required reads `40T + LP + NOTAM` — the same shorthand
> convention. [quotations.md](quotations.md) asks to *"remove `Checked By` from creation form"*;
> this SOP is the counter-evidence that the field carries a live convention. **Neither document
> is adjudicated.**

## 5. Units, and where the estimate comes from

Unit/People tab → right-click → **Add Unit** → type *"Mobile Crane"* → *"Specify which crane will
be used for the job. Example: For this job, select a 22 Ton crane."*

Then:

> *"After selecting the machine and equipment for the quote, **the system will automatically
> generate the details in the 'Estimate' tab.** … **FCC will automatically generate the crane and
> the minimum hours for the machine you are quoting.**"*

**Adjusting hours** — the SOP's five components of quoted time:

1. Travel to the jobsite (**portal to portal**)
2. Setup / buildup time
3. Hook / lift time
4. Breakdown time
5. Travel back to the yard

*"Quote the hours as accurately as possible to ensure the estimate reflects the full scope of
work."*

That five-part breakdown is the same span
[mobilization-and-demobilization.md](mobilization-and-demobilization.md) splits into Mobilization
(1–2), hook time (3) and Demobilization (4–5). **This SOP quotes all five as adjusted crane
hours on one line**, not as a mob/demob bundle. The document does not say when the bundled form
is used instead.

## 6. The Lift Info fields, defined

The SOP is the only source that defines each field. `Trucking Info` is explicitly out of scope:
*"Do not worry about the Trucking Info section only focusing on Lift Info."*

| Field | TCG's definition |
| --- | --- |
| **Main Boom Length** | *"Use the crane sizing info from the **3D Lift Plan**. If no 3D Lift Plan is available and the job is simple, refer to a **load chart** to determine enough boom length to complete the lift."* |
| **Jib / Luffer Length** | *"Only required if the crane is using a jib during the lift. Leave empty if not applicable."* |
| **CWT (Counterweight)** | *"Specify the amount of counterweight the crane will need. **For 22 Ton and 40 Ton cranes, this does not apply (they do not have removable counterweights)** – leave empty."* |
| **Radius** | *"Distance from the **center pin** of the crane to the point where the item will be set. Use measurements from the customer, including any safety margin (add 5–10 ft if needed)."* |
| **Load Weight** | *"Weight of the item being lifted, as provided by the customer."* |
| **Cap at Radius** | *"**Leave empty unless specifically required.** Avoid sending a machine that risks exceeding rated capacity at a given radius."* |
| **Lift Depth** | *"Use the measurement from the distance from the **edge of the building** to where the item will be placed."* |
| **Jib Offset** | *"Only required for jobs using a jib that needs offsetting."* |
| **Setup Distance** | *"Distance from the crane setup location to the building or obstruction, as provided by the customer."* |
| **Height** | *"Height of the building, obstruction, or general height where the item will be set (e.g. rooftop, house, etc.)."* |

And the accuracy instruction: *"**Double-check the measurements and information with the
customer** to ensure accuracy, as this information may also be visible to them in the quote."*

**These are exactly the ten fields printed on the real quote** — `Main Boom Length`, `Height`,
`Jib/Luffer Lgth`, `CWT`, `Radius`, `Load Weight`, `Cap at Radius`, `Lift Depth`, `Jib Offset`,
`Set up Distance` on OM-36229. See
[quote-terms-and-rate-card.md](quote-terms-and-rate-card.md) §0. They are also the list Melissa
asked for in the ERP review log — *"Lift information: main boom length, jib/luffer length, jib
offset, counterweight, radius, load weight (with a dropdown if there will be multiple picks),
capacity at radius (heaviest / most critical lift), lift depth, set-up distance, building
height"* ([erp-review-log.md](../erp-review-log.md) → *#9 Quotes*). **Her version adds two
things this SOP does not have: a multi-pick dropdown on load weight, and the definition of
capacity-at-radius as the heaviest / most critical lift.**

## 7. Finalising, exporting and the approval gate

1. Return to Main, **Save** once more. *"Once saved: a quote number will be generated."*
2. The **lightning bolt** icon appears. Click it → **New Doc** → in the dropdown select
   **"Detail Quote"** → OK. *"FCC will then generate the quote as a PDF ready to send to the
   customer."*
3. **Save As** into the **"Nex Gen" folder on your Desktop (Mac)**.
4. **File naming: `quote number _ company name`** — *"Example: `OM-12345_Company.pdf`"*.
5. **Verify the PDF.** *"Occasionally, the file may be saved incorrectly or become corrupted. If
   the PDF is corrupted: delete the corrupted file… save/export the PDF again. **Keep the FCC
   quote open until you have confirmed the PDF is saved correctly.**"*
6. Drag a copy to the Desktop, open it, and check **company information, jobsite address, lift
   information, line items, pricing**.
7. **The gate:**

> *"After reviewing, **submit the quote to a supervisor for review and approval. Only after
> supervisor approval should the quote be sent to the customer.** This final review helps prevent
> pricing errors, incorrect job details, or lift information issues before the quote is sent to
> the customer."*

Two facts follow. **"Detail Quote" is a named quote layout** — the FCC manuals say the New Doc
dropdown offers a choice of layouts but never name one; this is the one TCG picks. And
**supervisor approval before customer release is TCG's current, unconditional rule** — it is not
threshold-based here. The 2026-05-05 meeting later discussed a *conditional* approval workflow
(approval required only for rates **below** the allowed price, plus a $50,000 flag) —
[erp-review-log.md](../erp-review-log.md) → *Quote approval*. **The SOP and the meeting describe
different regimes and nothing says which governs.**

## 8. The Playbook wrapper

`Creating Quotes in FCC Playbook.docx` compresses the above into five steps — Gather Job
Information → Open Job Quotes in FCC → Enter Customer and Jobsite Details → Build the Quote
Details → Finalize, Export, and Review — and links to the SOP PDF on SharePoint plus a
walkthrough video. Its Step 4 names the same Main-tab fields and adds the Estimate-tab review
items: *"hours, pricing, travel, setup, lift time, and breakdown time."* Under Resources:
*"Access to FCC will be needed"*.

**The Playbook's own template fields are unfilled** — Playbook Owner is blank and the Resources
list still reads "Resource/Tool · Resource/Tool". The same is true of the COI and New Customer
playbooks in the same folder.

## 9. The training restatement

`Sales Admin 60 day training.xlsx` carries the whole procedure twice: as a 16-row **FCC SOP
Training Guide** sheet and again inside a 60-row **Step Library**, each row `Track | Step |
Detailed Action | Pass Criteria | Source`. Every row cites `Creating Quotes SOP (1)(3).pdf`. The
pass criteria are the useful addition, because they state the completion test for each step:

| Step | Pass criteria |
| --- | --- |
| Determine new vs returning | *Correct customer status confirmed.* |
| Create new customer | *Required fields complete and account saved.* |
| Save customer account | *Account is visible on Job Quotes page.* |
| Complete main quote fields | *Main quote page has no missing required fields.* |
| Add units and crew | *Correct unit/crane listed.* |
| Review Estimate tab | *Line items reviewed; issues flagged.* |
| Adjust quote hours | *Hours reflect full job scope.* |
| Enter Lift Info | *Lift info is complete and matches intake.* |
| Final save and quote number | *Quote number generated.* |
| Generate PDF | *PDF quote generated.* |
| Save PDF | *PDF saved using naming convention.* |
| Verify PDF | *PDF opens and matches quote details.* |
| **Submit for approval** | ***Approval requested; customer not sent before approval.*** |

The workbook's other tracks (Customer Intake, 3D Lift Planner, HubSpot CRM, Fleet Knowledge) are
summarised in [sales-reporting-workbooks.md](sales-reporting-workbooks.md) §4.

## 10. Two addresses, one company

The SOP's page footer gives **10850 Portal Dr., Los Alamitos, CA 90720**; the Damage Waiver and
the Absence Request form in the same drop give **14480 Alondra Blvd, La Mirada, CA 90638**. Both
carry the same office and fax numbers and CA Lic #967520. The Operating System Architecture flags
this itself as something to settle — *"Confirm current company address… before republishing
customer-facing material"*
([sales-operating-system/01-operating-system-architecture.md](sales-operating-system/01-operating-system-architecture.md)
§12). **Which is current is not stated in this drop.**

## Source

- `3.1.1_MODULE-CRM-SALES-QUOTES/__ERP_Sales Process (from Ryan 2026-08-06)/Creating Quotes SOP (1).pdf`
  — 31 pages, `pdftotext -layout`. Heavily illustrated with FCC screenshots; **the screenshots
  carry no extractable text**, so field values visible only in images are not recorded here.
- `…/Creating Quotes in FCC Playbook.docx` — 1 page, pandoc gfm. Ryan Adams, 2026-05-11.
- `…/Sales Admin 60 day training.xlsx` — sheets `FCC SOP Training Guide` (17 rows) and
  `Step Library` (61 rows) only; the workbook's scheduling sheets are bulk data and were not
  copied.
