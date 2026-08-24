---
title: Sales Pricing In FCC — 2026-03-12 (Read.ai summary)
source: user-supplied/meeting-transcript
original_file: "2026-03-12_Sales-Pricing in FCC -ReadAI summary.txt"
migrated: 2026-08-19
updated: 2026-03-12
status: reference
conflicts_with: []
jira: []
tags: [module/quotations, kind/summary]
entities: []
meeting_date: 2026-03-12
kind: auto-summary
summary_tool: Read.ai
---

# Sales Pricing In FCC — 2026-03-12 (Read.ai auto-summary)

> Third-party AI-generated summary produced by Read.ai at capture time — not written or
> reviewed by a human. See `../transcripts/2026-03-12-sales-pricing-in-fcc.md` for the full transcript this
> summarizes.

TCG | CC Product Sync
Thu, Mar 12, 2026

Summary:

The meeting reviewed requirements for asset management, price-list functionality, and purchase order (PO) integration to support quoting, job tracking, and utilization reporting in the FCC system. The team confirmed multi-yard support and asset-to-yard linking with a main-yard selection, and discussed asset listings, reusable unit-type definitions that group assets and employees, and required ancillary items auto-populating for unit types. Participants agreed unit types should be reusable across similar machines, with customer-specific price exceptions handled separately.

Discussion then focused on price-list design and placement; the group agreed to rename billing codes to "price list," consider status states (draft/in progress/active), and prefer list-level adjustments over per-asset edits. Joe offered to share current price-list UI screenshots and an SOP to clarify expectations. The team debated group-based versus per-customer price lists and a percentage-discount overlay versus base-rate changes; Ryan suggested a global percentage with per-line edits remaining available. A mandatory override/approval rule for lowering prices was requested and accepted for backend implementation.

Finally, the group addressed third-party vendor and subcontractor line items, PO generation timing, and re-quoting controls when vendor costs change. Joe proposed a vendor-managed flag that immediately generates a PO; Ehtesham agreed to investigate PO creation from resource changes and surfacing required re-signing flows. Ryan noted PO closure on lost jobs and limited BO access. Orion was asked to review the resources tab and pricing rules for additional updates.

Chapters & Topics:

Opening, attendance, and meeting start
The meeting opened with informal check-ins and attendance coordination while waiting for Brian and others to join. Participants confirmed they would proceed despite some absences and agreed to begin the design discussion.
* Assets and their listings/filters will exist in the FCC and support adding additional information at creation
* Pricing for quotes will come from a general or quote-specific price list and can be switched per quotation

Design meeting kickoff and scope overview
Ehtesham initiated the design discussion and summarized features already discussed, including employee basic flow, login capability, and asset management updates. He requested examples for price lists and noted a need to incorporate price-list data into quotation creation.
* The meeting focused on asset management, pricing integration, and naming conventions for units/assets.

Joe explains current price-list functionality and screenshots offered
Joe described the existing per-customer price-list tab that stores billing codes and populates standard codes with overridable prices, and offered to share screenshots from the current system to illustrate the workflow. The team asked for those visuals to clarify hidden details.
* Price lists are currently a per-customer tab that populates billing codes and allows price overrides.

Requirements and structural recommendations for price lists
The team discussed creating price-list groups (attach multiple customers to a group), having a list page and descriptions, and treating price lists as a central sheet of billing codes rather than per-unit edits. They debated placement under asset management versus a future accounting module and favored simplicity and group associations.
* The system now supports multiple yards and associating assets to a selected yard via dropdown or main-yard designation.
* The team prefers a group-based price-list model where one price list can be attached to multiple customers.
* There is a proposal to move pricing features under an accounting area when accounting is introduced.

Asset terminology, categorization, and price-adjustment controls
The team proposed renaming "units" to "assets," adding subcategories (cranes, trailer, work trucks) and status tracking, and discussed mechanisms for global price adjustments via price-list level discounts or modifiers instead of editing each asset individually. They agreed to rename billing codes to price lists and to add status states for price lists (draft/in progress/active).
* The team agreed to change "billing codes" terminology to "price list" and to include status states for price lists.

Asset creation and FCC asset-level fields
The team confirmed assets will be created in the FCC with listings, filters, and the ability to add additional main information at creation. Participants asked whether price lists or hourly rates should be stored at the asset level and clarified the current approach.

Unit types and subcomponents structure
Discussion defined unit types as groupings of categories, assets, and employees (subcomponents) that populate when a unit type is selected, and that subcomponents can be marked required or optional for estimates. The conversation covered examples (crane plus trailers and operators) and how optional items appear in estimates but can be removed by salespersons.
* Unit types group categories, assets, and employees and can mark subcomponents as required or optional for estimates

Reusability versus individual units and population behavior
Attendees debated whether to create distinct unit types per physical unit or to use shared unit-type definitions across identical machines, with consensus toward shared definitions and the ability to alter specific instances as needed. The group noted customer-specific price exceptions as a reason to allow per-customer overrides.
* Unit-type definitions should be reusable across identical machine categories, with customer-specific pricing handled separately

Pricing, price lists, and override rules
Pricing for resources was explained to come from general or prioritized price lists and can be changed per quotation by selecting an active price list. Ryan requested a mandatory override approval rule to prevent unauthorized price reductions, and the team agreed this would be implemented in backend rules.
* A mandatory price-override approval rule for lowering prices will be implemented in the backend

Utilization reporting, permissions, and next review request
The team agreed the system will calculate asset utilization from quotations and jobs and surface those rates to owners and select managers (e.g., Ryan) to drive sales focus and capacity planning. Participants confirmed admin capabilities for adding or removing users, and Ehtesham asked Orion for any further tab updates or rules to implement.
* The system will calculate asset utilization rates from quotations and jobs and show them to owners and selected managers
* Orion was asked to review the resources/pricing tab for further updates or rule requests

Subcontractor line-item and markup capability
The group discussed adding blank or free-text sub-items for subcontractors and entering the subcontractor amount and internal markup percentage so an internal total can be calculated without exposing it to customers. Ehtesham confirmed the interface can accept new units, individual units, and units with subcategories and that custom fields can be added to capture such charges.
* The system must allow free-text or miscellaneous subcontractor line items with internal-only markup calculations

PO linking, job association, and visibility questions
Ryan asked whether the quotation UI can auto-populate a PO number and tie vendor charges to a job, and the team explored implications for enforcing change-order flow so sales must update quotes when vendor costs change. Ehtesham clarified the PM process is not fully integrated and the system currently only exposes a PO number from the quotation main page.
* Current capability only exposes a PO number from the quotation main page; deeper PO creation and PM integration are not yet implemented
* The resources tab on the quotation page should display whether a line item is third‑party and support vendor assignment

Dispatch, assets, and vendor assignment
Joe described dispatch versus quotation distinctions and explained that vendor-assigned support assets are handled in dispatch; he proposed treating third-party services in quotations as vendor line items to preserve margins and avoid translation loss between quote and schedule. He recommended a simple UI to mark a line item as a vendor which would populate the PO.

Change-orders, enforcement, and accounting visibility
The participants emphasized preventing lost change orders by requiring users to update the original quote and generate a new PO when vendor costs increase, so the customer receives an updated quote and accounting always sees job-level spend. Ehtesham and Joe agreed that creating POs from resource changes and detecting quote updates for re-signing is the intended flow.
* The preferred workflow is to create or generate POs after quotation approval/conversion to a job and to auto-create POs when resource lines change and a vendor checkbox is set
* The system should force re-quoting and customer re-signature when vendor-driven cost changes affect quotation totals

Unit types and required ancillary items
The team reviewed asset/unit definitions and agreed that required items (travel permits, lift plans, rigger fees) are not assets themselves but requirements tied to an asset and should be defined so they auto-populate when the asset is selected. Ehtesham reported the team is extracting unique variables from the database to support these definitions.
* Unit (asset) definitions should include required ancillary items that auto-populate when that unit is selected (e.g., travel permits, lift plans)

Access and BO/PO visibility discussion
The conversation opened with a request for Ryan to show the BO creation system and its impact on his workflow, but Ryan said he did not yet have access. He described desired behaviors: placing a third party in the name, generating PO numbers from quotes, and surfacing quote context to approvers to explain amounts over approval thresholds. Ryan also raised concerns about open POs remaining when jobs cancel and suggested marking cancelled work as lost to clear backend statuses.
* Ryan lacks access to the BO creation system and cannot show it now.
* Generating PO numbers directly from quotes and attaching third-party names was identified as a valuable prior capability.
* The team wants canceled jobs to close or mark related POs as lost to prevent open PO amounts from affecting the books.

SOP and information handoff for PO process
The team agreed they could not show certain items immediately but committed to sending supporting materials; Joe offered to send a brief SOP and to provide information on the PO process. Ehtesham indicated that receiving site information would allow the team to add PO functionality to the quotation creation flow and to update communications and the communications tab accordingly. Joe noted Melissa or Wes could also demonstrate the PO process if needed.

Live demonstration of price lists and customer assignment
Joe shared his screen and demonstrated creating a price list, selecting machines, viewing default rates, and overriding those defaults to set discounted rates. He showed assigning a created price list to a customer and the expectation that quotes for that customer inherit the assigned price list. Joe invited questions and confirmed the steps were clear to participants.
* Joe offered to share a brief SOP describing the current PO process despite calling the system "horrible".
* The application currently supports creating price lists, assigning them to customers, and overriding default machine rates per line item.

Quoting workflow and discount mechanics discussion
Joe began creating a job/quote to illustrate how assigned price lists affect quotes and rates. Ryan proposed adding a global percentage discount feature to shift all rates (for example, a 2% off special rate) while preserving the ability to adjust individual line items. Ehtesham asked for clarification on whether a percentage change should alter base prices or act as a calculative overlay and whether the adjustment would be persistent or only on-the-fly; Ryan’s prior comment served as the basis for that question and suggested the overlay approach.
* The group discussed adding a global percentage discount to shift all rates while retaining per-line editability.

Action Items:

* Joe Schacatano will provide screenshots of the current system's price-list UI and send them to the team.
* Joe Schacatano will offer to share his screen and walk the team through the current system when requested.
* ehtesham.anwar will discuss renaming "units" to "assets" with his team and report back.
* UX/dev team will add an option in the unit-type UI to delete or alter populated subcomponents on the far right while preserving defaults
* Product team will incorporate unit-type definitions into units so subcomponents populate consistently across units of the same category
* Ehtesham Anwar will implement a mandatory price-override approval rule in the backend so price reductions require approval
* Ehtesham Anwar will add utilization-rate calculation and reporting for each asset and ensure owners and specified managers can view it
* Orion will review the resources/pricing tab and provide additional update requests or rules to implement
* Ehtesham Anwar will investigate and design the PO creation flow that triggers from resource changes after quotation approval and define the vendor-checkbox behavior in the resources tab
* Ans Nisar will review and finalize the notation sheet and confirm the set of unit types and required ancillary items to include in the assets module
* Ehtesham Anwar will create the quotation resources view needed to enter and display third-party/vendor line items and confirm how PO numbers will be generated from that view
* Ehtesham Anwar will extract unique asset and unit variables from the database to support auto-populated unit definitions and requirements
* Joe Schacatano will send a brief SOP describing the current PO process to the team
* ehtesham.anwar will add PO functionality into the quotation creation flow after receiving the requested site information
* Joe Schacatano will share his screen and run through the price listing and unit population for the team (demonstration and walkthrough)

Key Questions:

* Are price lists simple text entries or do they use unit types and structured billing codes?
* Is the "price list" name a new term or already used in the client's FCC system?
* Would changing the naming scheme from "units" to "assets" increase complexity for the client team?
* Can you zoom in and store an hourly rate or price list on the asset itself?
* If two cranes have the same tonnage, should they have identical pricing, or are there one-off cost differences between units?
* Can we enforce a mandatory override so prices cannot be reduced below an approved threshold without executive approval?
* Can the quotation UI auto-populate a PO number and tie third-party line items to a job so vendor POs are generated from the quote?
* Should accounting be concerned with vendor spend at the job level or only the quotation level?
* If a vendor increases cost and the PO is increased, will that immediately change the customer quotation and require sign-off?
* How should a percentage discount feature behave—should it change base prices or act as a calculative overlay, and should the percentage remain editable later?

Notepad:

* No notes
