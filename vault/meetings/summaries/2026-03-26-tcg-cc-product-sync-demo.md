---
title: TCG CC Product Sync Demo — 2026-03-26 (Read.ai summary)
source: user-supplied/meeting-transcript
original_file: "2026-03-26_TCG CC Product Sync_demo -Read AI summary.txt"
migrated: 2026-08-19
updated: 2026-03-26
status: reference
conflicts_with: []
jira: []
topics: []
entities: []
meeting_date: 2026-03-26
kind: auto-summary
summary_tool: Read.ai
---

# TCG CC Product Sync Demo — 2026-03-26 (Read.ai auto-summary)

> Third-party AI-generated summary produced by Read.ai at capture time — not written or
> reviewed by a human. See `../transcripts/2026-03-26-tcg-cc-product-sync-demo.md` for the full transcript this
> summarizes.

TCG | CC Product Sync
Tue, Mar 24, 2026

Summary:

The meeting reviewed asset management, personnel qualification, quotation, and project workflow requirements and demonstrated current development progress. The session opened with coordination around migrating FCC fields and scheduling a focused migration review after Brian examines a recorded session; Kyle joined to provide operational feedback on units and assets. Ehtesham presented the asset-management design, describing a hierarchy of categories, subcategories, and assets with configurable attribute tables, reusable subcategory attributes, quick actions, tabs for vehicle and financial data, and planned handling for manuals, insurance, load charts, multi-company/multi-yard assignments, and maintenance/parts tracking.

Discussion then moved to personnel and operational requirements: customizable equipment records, asset-specific custom fields to keep reports relevant for sales and mechanics, certification tracking tied to assets with configurable SOP behavior for dispatch eligibility, and automated alerts for time-sensitive documents. The team also requested historical utilization and KPI tracking per employee to inform staffing and safety decisions. Finally, the group reviewed a recorded demo of authentication, customer creation, and a draft quotation flow, discussed quotation UX improvements and a contracts/MSA library with expiry and contract-balance tracking, noted remaining prerequisite modules, and confirmed an AWS account blockage delaying full deployment.

Chapters & Topics:

Meeting opening and administrative items
The meeting began with brief check-ins and a reminder that the prior Friday session covered FCC fields and migration details. Brian noted the previous meeting recording issue and that Wes recorded the session for transcription.

Plan for detailed migration review and timeline alignment
Brian proposed a smaller follow-up meeting to review field-level migration details and timelines and to ensure nothing is missed from the FCC fields discussion. Ehtesham agreed to convene once Brian compiles notes from the recorded session.
* The team agreed to perform a detailed follow-up on FCC field migration and timeline coordination outside this meeting.

Introduction of Kyle and intent to solicit operational feedback
With Kyle joining, the group decided to use the meeting to gather his operational perspective on the units/assets work and to invite him to provide input or simply observe and later annotate the designs.

Asset-management design walkthrough (categories, subcategories, attributes, assets)
Ehtesham presented the asset-management model: renaming units to assets; creating categories and subcategories; configuring attribute tables (types, required/optional, ranges); defining asset creation and tabs for vehicle, financial, and additional data; and using subcategory attributes to populate assets to eliminate duplication.
* The current UI replaces "units" with an asset hierarchy (categories → subcategories → assets) to centralize shared attributes and reduce duplication.
* Category-level attribute tables will be configurable and propagate to subcategories and assets to avoid repetitive edits.
* Asset records include vehicle details, buy/sell information, and additional attributes pulled from subcategories.

Sales integration, documentation, multi-yard/company, and maintenance considerations
Discussion covered how assets and subcategory inclusions feed sales quotations, the need to model multiple companies and yards for asset assignment, and the requirement to store and refresh time-based documents (insurance, certifications, manuals) plus maintenance and parts tracking for operational use.
* The team needs to define how assets are assigned to multiple companies and yards for scheduling and job use.
* Kyle requested printable pages to review and annotate the current asset-management pages before detailed input.
* Document management for manuals, insurance, and certifications is required and can be integrated into the system for easy sharing with contractors.

Custom asset fields and data cleanliness
Kyle emphasized the need for custom fields to capture certifications, inspections, service history, and measurements per asset to avoid irrelevant blank fields and unprofessional reports. He also requested quick access to asset documents for sales and mechanics as part of onboarding.
* The system must support custom fields per asset so reports show only relevant information.

Alerts and quoting integration
Ryan proposed time-based alerts and a quoting workflow that auto-includes required certifications and assets to reduce back-and-forth and safety checks, saving time in the overall flow. The group agreed notifications and cadence controls would be valuable.
* Time-based alerts/notifications are required for certifications and scheduled inspections to avoid manual report-running.

Asset documentation and onboarding requirements
Melissa and Wes requested that assets include manufacturer manuals, insurance, serial numbers, photos/videos, and an onboarding checklist, with asset permanence (daily/monthly/permanent) considered in the flow. Wes highlighted the need for parts-identifying data for maintenance.
* Asset records must include manufacturer documentation, serial numbers, insurance, and periodic photos/videos for onboarding and maintenance.

Certifications, qualifications, and dispatch rules
The team differentiated vehicle/machine certifications from employee certifications and described multiple certification types and cadences (quadrennial, annual, NCCCO five-year). They discussed internal qualifications, dispatch lists of who runs which machines, and system behaviors to block or warn on unqualified assignments per SOP.
* The platform should link asset certification requirements to employee qualifications and optionally block or warn on assignments per SOP.

Utilization tracking and profile KPIs
Wes and others recommended logging employees’ machine usage over time to build profiles showing hours per seat and strengths, enabling KPIs for billable ratios and safety or sales evidence. Ehtesham suggested department-specific profile views and processed summaries for dispatch and HR.
* The team wants historical utilization and KPI tracking for employees (hours per seat, billable ratios) to build operator profiles.

Deliverables, timeline, and next steps
Ehtesham requested Brian send asset designs to Kyle for detailed input and asked for initial data within a week to incorporate dispatcher and maintenance needs; Kyle agreed to provide feedback promptly and Brian agreed to send documentation as a PDF.
* Designs for the asset module will be shared with Kyle for detailed feedback and incorporation into jobs/maintenance workflows.
* The project timeline anticipates finalizing job/project definitions within the next week to accelerate maintenance module work.

Workflow and contract requirements
Ryan described the desired user flow improvements, including extra tabs, drag-and-drop attachments for quotes, and simpler step-to-step workflows to speed processing. He raised the need for a contracts/MSA library with alerts for expirations and a way to notify assigned owners ahead of renewals.
* The team prefers a streamlined quotation workflow with drag-and-drop attachments and signature/COI request capabilities 364
* A contracts/MSA library with alphabetical storage and expiry alerts was requested to manage renewals 365

Contract accounting and notifications
Wes and Melissa expanded on storing financing and payment details at the asset level and attaching contracts at both customer and job levels. Melissa requested PO-level balance tracking that deducts invoiced amounts and alerts when funds run low; the dev team confirmed accounting and notification support is feasible.
* The platform will include a project level that automatically links quotations, permits, and the customer record 372
* Contract or PO-based balances should auto-deduct as invoices are issued and trigger notifications as balances approach zero 381

Development status and analytics potential
The team noted benefits of centralizing data for analytics and reporting once core features are digitized into a single database. Ryan and others commented on workflow efficiencies and synergies from the integrated system.

Demo setup and technical notes
Ehtesham handed the call to Jhansi to present development progress and explained the team is currently blocked on the AWS account, so recorded loom videos were prepared for review. Jhansi began the demo and adjusted screen-sharing settings to proceed.
* Development is blocked pending AWS account access; loom videos were recorded and will be shared for interim review 401

Customer and quotation demo
Jhansi demoed authentication, dashboard, and the customer creation form with multiple contact entries and related subsections (certifications, notes, tasks). He also showed quotation thread operations and explained that several prerequisite modules (yards, pricing lists, asset management) must be completed before full quotation functionality is enabled.
* Customer and quotation modules have working basic functionality and UI that aligns closely with Figma mockups 423

Delivery, QA, and schedule
The developers committed to delivering UI that matches Figma and emphasized pixel-perfect design and quality testing for production releases. They confirmed they will deploy to the cloud after receiving the AWS account and scheduled a Thursday meeting to give a first pass on jobs and projects.
* The team scheduled a follow-up to give a first pass to jobs and product projects on Thursday 474

Recordings, access, and meeting close
Kyle asked about meeting recordings and access; Ehtesham confirmed recordings exist except one internal meeting, and Brian agreed to send Kyle instructions for access. The call closed with thanks and farewells.

Action Items:

* Brian Petros will review the Friday meeting transcript and compile a list of FCC fields that need attention
* Ehtesham Anwar will schedule a follow-up meeting once Brian shares his documentation and notes
* Kyle Harlow will review printable/exported pages of the current asset-management UI and provide annotated feedback
* The development/product team will incorporate document upload and sharing capability (manuals, insurance, load charts) into the asset records as requested
* Ehtesham Anwar will finalize the jobs/projects definition within the next week to enable maintenance work.
* Brian Petros will send the asset/design documentation to Kyle as a PDF in a few minutes.
* Kyle Harlow will complete and return his asset comments before he leaves tomorrow.
* Wes Staley will review Kyle’s asset feedback with Kyle after Kyle completes it.
* Brian Petros will suggest example programs used previously to Ed and his team via email or text for familiarization.
* Jahanzaib Nadeem will share the recorded loom demo videos via MS Teams for detailed review
* Jahanzaib Nadeem will deploy the application to the cloud once the AWS account is received and provide access for testing
* Ehtesham Anwar will lead the first pass review of jobs and product projects on Thursday
* Brian Petros will send Kyle Harlow an email explaining how to access meeting recordings

Key Questions:

* How should the system handle assets across multiple companies and yards for creation, assignment, scheduling, and job use?
* Can the system store and enable drag-and-drop sharing of crane manuals so a contractor can receive a single link per crane?
* Will the asset data and the application for field employees be the same system and produced by the same team?
* If Kyle returns his comments by next Tuesday, will that meet the timeline?
* Can Brian provide the paperwork/designs to Kyle today?
* Are warehousing capabilities being addressed now or later?
* Can the system deduct invoiced amounts from a contract/PO balance and notify when funds are low?
* Do you have recordings from prior meetings?
* Do I (Kyle) have access to those recordings?

Notepad:

* No notes
