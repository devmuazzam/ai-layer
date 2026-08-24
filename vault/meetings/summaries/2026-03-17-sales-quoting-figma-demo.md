---
title: Sales Quoting Figma Demo — 2026-03-17 (Read.ai summary)
source: user-supplied/meeting-transcript
original_file: "2026-03-17_Sales-Quoting_Figma_demo -ReadAI summary.txt"
migrated: 2026-08-19
updated: 2026-03-17
status: reference
conflicts_with: []
jira: []
tags: [module/quotations, kind/summary]
entities: []
meeting_date: 2026-03-17
kind: auto-summary
summary_tool: Read.ai
---

# Sales Quoting Figma Demo — 2026-03-17 (Read.ai auto-summary)

> Third-party AI-generated summary produced by Read.ai at capture time — not written or
> reviewed by a human. See `../transcripts/2026-03-17-sales-quoting-figma-demo.md` for the full transcript this
> summarizes.

TCG | CC Product Sync
Tue, Mar 17, 2026

Summary:

The meeting reviewed product mock-ups and the proposed asset-management data model to support quotations and job creation, with emphasis on categories, subcategories, and configurable attribute templates. Ehtesham demonstrated creating categories, attaching attribute-table templates, and editing statuses and attributes at category and subcategory levels; subcategories inherit category templates and may extend them with custom fields for specific unit types (for example, 100-ton versus 400-ton cranes). The group covered associated field assets and inclusion types so quotations and jobs auto-populate required or optional related assets or personnel, and confirmed the interfaces shown are mock-ups with an onboarding migration where the vendor will create initial fields and administrators will be trained to modify them.

Discussion then focused on how assets, validations, and associated field assets drive quoting and billing logic. Quotations will reference categories/subcategories (not individual assets) and auto-populate associated assets with optional removal where allowed. The team defined validation levels (warnings versus blocking errors), role-based visibility for asset financials, and billing codes as a master pricelist with customer-specific price lists, time-bound discounts or hikes, and bulk rate updates. Pricing will default at the category level, with customer-specific lists or quotation-time adjustments; dispatch-level overrides must notify stakeholders and capture actual asset cost for KPI and profitability reporting while preserving quoted customer pricing. The roadmap items agreed were implementing price-list and billing-code management, employee/roles/permissions configuration, an initial job-creation mock-up by Thursday with job design finalized the following week, and later additions including mobile time capture and KPI reporting.

Chapters & Topics:

Introductions and meeting setup
The call opened with greetings and brief logistical comments about cameras, backgrounds, and an upcoming HubSpot meeting. Attendees confirmed presence and noted initial informal observations about the Figma files.

Design sharing approach and review planning
Brian described exporting Figma work into a PDF to enable internal side-by-side review against FCC and to collect field-level feedback. He emphasized the need for internal review sessions where stakeholders (Joe, Ryan, others) will validate and propose changes.
* The visual designs shown are mock-ups and will be refined after internal review using PDFs shared with stakeholders

Process file and discovery findings overview
Ehtesham presented a process file containing discovery-call findings, project goals, pain points, must-haves, integrations, and call-to-actions that will inform design and development priorities. He framed the major agenda items: categories, subcategories, assets, quotations, and price lists.
* The team is converting FCC data and discovery findings into a design process file to drive development

Category creation and attribute tables
The team reviewed the category creation flow including naming, status, and adding attribute tables as templates. It was clarified that attribute tables serve as templates without instance values and can contain multiple named fields with selectable field types and required flags.
* Categories will act as parent templates with attribute tables that subcategories inherit and can extend

Subcategories and attribute inheritance
Subcategories (unit types) will be created under categories, inherit attribute tables, and allow addition of custom fields specific to that subcategory. The example of mobile cranes (100-ton vs 400-ton) illustrated how common lift information can be shared and extended.
* Subcategories represent unit types (e.g., 100-ton crane) and will auto-populate forms from category templates

Associated field assets and quotation behavior
The associated field assets concept was explained to link categories/subcategories to other assets or employees with inclusion types (always included vs optional). This linkage will drive auto-population and editability rules in quotation and job creation.
* Associated field assets and inclusion types will allow quotations and jobs to auto-include required or optional related assets or personnel

Administrative control, migration, and training
The presenters confirmed the UI is a mock-up and described planned vendor-led migration to pre-create fields based on FCC during onboarding. Administrators will be given tools and training to add, edit, and change field types and requirements thereafter.
* The vendor will perform an initial migration to create required custom fields and will train administrators to manage fields going forward

Subcategory and Asset Model Explanation
The team detailed that subcategories hold attribute templates and associated field assets while multiple physical assets can exist under a subcategory; attributes may be single values or ranges and drive quotation validations.
* Subcategories define attribute templates and associated field assets while individual assets capture specific unit details and buy/sell info.

Quotation Behavior and Validation Logic
Speakers explained that validation will alert or block quotation creators when entered values fall outside asset-defined ranges, and management must review persistent mismatches to correct asset data or user understanding.

Category Structure and Administrative Setup
Participants asked whether categories are grouped (e.g., cranes, trailers); presenters clarified administrators will define asset types and the assets tab will represent inventory and maintenance status.

Asset Selection vs. Category Selection in Quotes
The system will let quotation creators pick asset categories/subcategories (e.g., crane size) which then auto-attach related support items like spreader bars and slings, rather than selecting a specific physical asset.
* Quotations will be created by selecting a category/subcategory, not a specific physical asset, and the system will auto-populate associated assets accordingly.

Equipment as Assets and Associated Field Assets
The group confirmed that equipment is modeled as assets or associated field assets, and the same templating functionality can categorize equipment, permits, or other linked items.

Validation Governance and SOP Enforcement
Leadership will define system rules and boundaries per module; validations will be configured as warnings or blocking errors to enforce SOPs during workflows like quotation creation.

Billing Codes, Price Lists, and Rate Management
Billing codes will serve as a master pricelist; users can create multiple price lists, link them to customers, apply time-bound discounts or hikes, and perform bulk rate updates limited to selected codes within a price list.
* Role-based permissions in HR will control visibility of sensitive asset financial data like purchase price and insurance.
* Billing codes will act as a master pricelist; separate price lists can be linked to customers and adjusted with discounts, hikes, and bulk updates.
* Price-list discounts and hikes will include start dates and can be time-bound with automatic expiration.

Pricing model and category defaults
The group clarified that billing codes and price defaults are applied at the category level, so identical crane sizes (e.g., 100-ton or 40-ton cranes) typically share the same default rate. Participants confirmed the intended pricing approach and that the system assumes category-level rates rather than per-asset pricing by default.
* Pricing will be defined at the category level by default (e.g., all 100-ton cranes share one rate).

Exceptions and price-list variability
The team discussed variability introduced by price lists, noting that the same crane can have different effective pricing when attached to a different price list for a customer. Brian explained that dispatch or customer-specific price lists may raise or lower default rates, which must be manageable in the system.
* Individual price lists can override category defaults per customer, enabling hikes, discounts, and bulk rate updates without changing the master price list.

Dispatch overrides and profitability tracking
The participants described an override workflow for dispatch when the quoted asset is unavailable; the override should dispatch a larger crane, trigger management notification, and capture the actual costs for KPIs while preserving customer billing at the quoted rate. This captures reduced profit scenarios when a more expensive asset is used but the customer is charged the original quoted rate.
* Dispatch must support an override workflow that allows sending a different (larger) crane while preserving the original quoted customer price and capturing real costs for KPIs.

Missing rates and quotation behavior
The group identified the scenario where a category rate is not entered and the quotation displays $0, requiring the salesperson to manually enter an amount until accounting populates the price list. The team agreed this behavior is acceptable if accounting or admins later fill in the missing rates.
* If a category rate is missing in the system, the quotation will show $0 and the salesperson must enter a manual amount until accounting fills the price list.

Price-list operations and bulk updates
The team covered mechanics for overrides updating KPIs and for price-list operations such as applying discounts and hikes at quotation time, and performing bulk rate updates across equipment. They confirmed that discounts/hikes are applied at quotation level and bulk edits will be available on price lists.

Modules, roles, and timeline for job creation
The discussion summarized system components to develop (customers, yards, employees, assets, billing codes, and price lists) and outlined next steps: build employee roles/permissions and start job-creation mockups by Thursday with a final job design the following week. Ehtesham emphasized extensibility to add fields or processes as needed.
* The team will implement employee roles and permissions and begin job-creation design work, with an initial pass due Thursday and finalization the following week.

Mobile time capture, documentation, and closing logistics
Ryan requested automatic job-level time capture via ADP-like clocking; the team confirmed mobile app plans to capture time and later produce KPI reports. The meeting closed with action items to share FCC-to-new-system mapping (FigJam/Figma), encourage Teams adoption, and confirm hosting decisions with Patrick.
* Mobile time-capture for employees will be added to collect job-level hours and enable KPI reporting later.
* The designers will port FCC concepts (categories/subcategories/assets) into the new system and share mapping materials (FigJam/Figma) for review.

Action Items:

* Brian Petros will circulate the exported PDF of the Figma designs and schedule internal review meetings for stakeholder feedback
* Ans Nisar will perform the initial migration to create custom fields/templates in the system for onboarding based on FCC mappings
* Ans Nisar will train TCG administrators to tweak, update, and add custom fields after the initial migration
* Ehtesham Anwar will add a pointer/notification at the project level to alert sales and accounting when dispatch changes affect pricing.
* Ehtesham Anwar will process employee roles and permissions configuration by Thursday.
* Ehtesham Anwar will begin the initial job-creation mockup on Thursday.
* Ehtesham Anwar will finalize the job design the week after the initial mockup.
* Ehtesham Anwar will move the agreed quotation, price-list, and billing-code designs into development.
* Ehtesham Anwar will send the FCC-to-new-system mapping link (FigJam/Figma) to the team.
* Brian Petros will review FigJam/Figma, organize FCC screens alongside the designs, and prepare a clearer PDF for the team.
* Brian Petros will encourage the team to adopt Teams for communication and try to get everyone to install the Teams app.
* Brian Petros will check hosting options with Patrick and report back.

Key Questions:

* How will the "lift information" under the asset be used in the system and quotations?
* Is "lift information" the correct label for the template section, and can section names be changed?
* Is the category list organized into sections like cranes, trailers, and rigging to avoid long dropdowns?
* For a quotation, can you pick supporting equipment sizes (for example spreader bars, slings) and have them attach appropriately?
* How will equipment be differentiated from assets in the system—will equipment be separated or part of assets?
* How will associated field assets behave in a quote when marked optional versus required?
* Will discount or price-hike adjustments include start and end dates?
* Will billing codes/pricing be applied at the category level so all cranes of the same tonnage share the same default rate?
* Is there any case where one asset in a category would have a different rate than the category default?
* What happens in the quotation module if a category rate (e.g., 40-ton crane) was not entered into the system?
* Can the system support bulk rate updates across equipment (e.g., increase all equipment rates by 5%)?

Notepad:

* No notes
