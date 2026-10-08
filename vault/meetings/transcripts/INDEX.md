# meetings/transcripts/ — raw client meeting transcripts

**70 files, 2026-01-15 → 2026-10-07.** 57 migrated 2026-08-19 from a OneDrive/Teams/
Read.ai/Fireflies export (see `../../sync/` — there is no automated pipeline for this;
it was a one-time manual pull); two more added 2026-08-27 from a 2026-08-27 OneDrive drop; **two more added 2026-09-04 from the `OneDrive_1_9-4-2026` drop** (2026-09-01 accounting/onboarding, 2026-09-02 sprint demo — the second needed 61 ASR substitutions, the heaviest single-file pass in the corpus, almost all of them "Euler" for *oiler*); one each added 2026-09-04 (2026-09-03) and 2026-09-11 (2026-09-10); **two more added 2026-09-17 from the `OneDrive_1_9-17-2026` drop** (2026-09-15 ERP live demo 01, 2026-09-16 resource types and billing codes); one more added 2026-09-24 from a single `.docx` in Downloads (2026-09-22 ERP live demo 02); one more added 2026-09-28 the same way (2026-09-28 ADP integration sync); one more added 2026-10-01 the same way (2026-09-29 safety discussion); one more added 2026-10-02 the same way (2026-10-01 quotes and billing codes); one more added 2026-10-08 the same way (2026-10-07 ERP sprint review). Each file is a transcript **as captured**, not curated —
no analysis, no cross-referencing, no conflict-flagging. That work exists separately for
three of these dates as the curated minutes in `../` (2026-08-05, 08-07, 08-12) and, at a
broader scale, in the *Recordings vs. Confluence Audit*.

**`status: reference` does not mean verified.** It means the content came from an external
source (here: a live client call) rather than from Confluence. Nothing here has been
adjudicated against the rest of the vault — that is exactly the gap this folder exists to
close for future readers.

**Domain vocabulary has been normalized — read [NORMALIZATION.md](NORMALIZATION.md) before
quoting anything.** The ASR engines had no crane vocabulary and systematically mis-heard the
two terms this business runs on: **`craft code` came out as "graph code"** (also "draft code",
"graph board") and **`crane` came out as "train", "green", "grain" and "brain"**. 257
substitutions across 40 files fixed those, plus `GSA`→`JSA`, `lettuce`→`lattice` and
`substance`/`sustenance`→`subsistence`. Files that were touched say so in their frontmatter
(`normalized:`, `normalized_substitutions:`). Speaker labels and every other ASR defect are
**not** fixed — they are reproduced as captured.

Four `kind` values distinguish what actually got captured — most are full `transcript`s,
three early dates are only an `invite-thread` or `agenda-notes` (no verbatim discussion),
and two dates in July have `no-recording` at all.

| Date | Title | Kind | KB | File |
| --- | --- | --- | --- | --- |
| 2026-01-15 | TCG CodingCops Kickoff Invite | Invite/email thread only | 1.6 | [2026-01-15-tcg-codingcops-kickoff-invite.md](2026-01-15-tcg-codingcops-kickoff-invite.md) |
| 2026-01-26 | TCG CodingCops Meeting 2 Agenda Notes | Agenda + notes | 4.5 | [2026-01-26-tcg-codingcops-meeting-2-agenda-notes.md](2026-01-26-tcg-codingcops-meeting-2-agenda-notes.md) |
| 2026-02-09 | TCG Product Discovery Session Invite | Invite/email thread only | 1.9 | [2026-02-09-tcg-product-discovery-session-invite.md](2026-02-09-tcg-product-discovery-session-invite.md) |
| 2026-02-27 | Dispatch Scheduling Demo | Transcript | 65.8 | [2026-02-27-dispatch-scheduling-demo.md](2026-02-27-dispatch-scheduling-demo.md) |
| 2026-03-03 | IT Coordination And Wireframe Demo | Transcript | 80.2 | [2026-03-03-it-coordination-and-wireframe-demo.md](2026-03-03-it-coordination-and-wireframe-demo.md) |
| 2026-03-06 | Sales Quoting Figma Demo | Transcript | 105.3 | [2026-03-06-sales-quoting-figma-demo.md](2026-03-06-sales-quoting-figma-demo.md) |
| 2026-03-12 | Sales Pricing In FCC | Transcript | 82.9 | [2026-03-12-sales-pricing-in-fcc.md](2026-03-12-sales-pricing-in-fcc.md) |
| 2026-03-17 | Sales Quoting Figma Demo | Transcript | 56.1 | [2026-03-17-sales-quoting-figma-demo.md](2026-03-17-sales-quoting-figma-demo.md) |
| 2026-03-19 | Roles Permissions Figma Demo | Transcript | 58.8 | [2026-03-19-roles-permissions-figma-demo.md](2026-03-19-roles-permissions-figma-demo.md) |
| 2026-03-20 | FCC Fields Screens Review | Transcript | 48.5 | [2026-03-20-fcc-fields-screens-review.md](2026-03-20-fcc-fields-screens-review.md) |
| 2026-03-24 | TCG CC Product Sync Demo | Transcript | 55.7 | [2026-03-24-tcg-cc-product-sync-demo.md](2026-03-24-tcg-cc-product-sync-demo.md) |
| 2026-03-26 | TCG CC Product Sync Demo | Transcript | 71.0 | [2026-03-26-tcg-cc-product-sync-demo.md](2026-03-26-tcg-cc-product-sync-demo.md) |
| 2026-03-31 | Dispatch Scheduling Permits Figma Demo | Transcript | 88.1 | [2026-03-31-dispatch-scheduling-permits-figma-demo.md](2026-03-31-dispatch-scheduling-permits-figma-demo.md) |
| 2026-04-02 | Dispatch Scheduling Figma Demo | Transcript | 40.6 | [2026-04-02-dispatch-scheduling-figma-demo.md](2026-04-02-dispatch-scheduling-figma-demo.md) |
| 2026-04-07 | Dispatch Scheduling Figma Demo | Transcript | 59.5 | [2026-04-07-dispatch-scheduling-figma-demo.md](2026-04-07-dispatch-scheduling-figma-demo.md) |
| 2026-04-09 | Dispatch Scheduling Figma Demo | Transcript | 83.6 | [2026-04-09-dispatch-scheduling-figma-demo.md](2026-04-09-dispatch-scheduling-figma-demo.md) |
| 2026-04-14 | Dispatch Warehouse Loading | Transcript | 58.6 | [2026-04-14-dispatch-warehouse-loading.md](2026-04-14-dispatch-warehouse-loading.md) |
| 2026-04-21 | Dispatch Scheduling Figma Demo | Transcript | 58.7 | [2026-04-21-dispatch-scheduling-figma-demo.md](2026-04-21-dispatch-scheduling-figma-demo.md) |
| 2026-04-23 | Dispatch Scheduling Loading Vendors | Transcript | 83.2 | [2026-04-23-dispatch-scheduling-loading-vendors.md](2026-04-23-dispatch-scheduling-loading-vendors.md) |
| 2026-04-30 | Dispatch Scheduling Figma Demo | Transcript | 38.6 | [2026-04-30-dispatch-scheduling-figma-demo.md](2026-04-30-dispatch-scheduling-figma-demo.md) |
| 2026-05-05 | TCG ERP System | Transcript | 94.6 | [2026-05-05-tcg-erp-system.md](2026-05-05-tcg-erp-system.md) |
| 2026-05-07 | Loading And Project Module Overview | Transcript | 77.3 | [2026-05-07-loading-and-project-module-overview.md](2026-05-07-loading-and-project-module-overview.md) |
| 2026-05-12 | Loading Figma Demo | Transcript | 60.9 | [2026-05-12-loading-figma-demo.md](2026-05-12-loading-figma-demo.md) |
| 2026-05-14 | Loading Scheduling Pre Ticketing | Transcript | 63.9 | [2026-05-14-loading-scheduling-pre-ticketing.md](2026-05-14-loading-scheduling-pre-ticketing.md) |
| 2026-05-18 | Quotation And Job Lifecycle | Transcript | 74.0 | [2026-05-18-quotation-and-job-lifecycle.md](2026-05-18-quotation-and-job-lifecycle.md) |
| 2026-05-19 | Crane Configurations Job Tickets | Transcript | 64.6 | [2026-05-19-crane-configurations-job-tickets.md](2026-05-19-crane-configurations-job-tickets.md) |
| 2026-05-21 | Crane Configurations Job Tickets | Transcript | 88.7 | [2026-05-21-crane-configurations-job-tickets.md](2026-05-21-crane-configurations-job-tickets.md) |
| 2026-05-26 | Job Tickets Mobile App Demo | Transcript | 59.6 | [2026-05-26-job-tickets-mobile-app-demo.md](2026-05-26-job-tickets-mobile-app-demo.md) |
| 2026-05-28 | Mobile App Payroll | Transcript | 50.1 | [2026-05-28-mobile-app-payroll.md](2026-05-28-mobile-app-payroll.md) |
| 2026-06-02 | Mobile App Sales Dispatch | Transcript | 65.6 | [2026-06-02-mobile-app-sales-dispatch.md](2026-06-02-mobile-app-sales-dispatch.md) |
| 2026-06-04 | Mobile App Job LEM Tickets | Transcript | 89.0 | [2026-06-04-mobile-app-job-lem-tickets.md](2026-06-04-mobile-app-job-lem-tickets.md) |
| 2026-06-09 | Payroll App Demo 01 | Transcript | 65.6 | [2026-06-09-payroll-app-demo-01.md](2026-06-09-payroll-app-demo-01.md) |
| 2026-06-11 | Payroll App Demo 02 | Transcript | 65.0 | [2026-06-11-payroll-app-demo-02.md](2026-06-11-payroll-app-demo-02.md) |
| 2026-06-16 | Field Ops Mobile App Demo | Transcript | 65.5 | [2026-06-16-field-ops-mobile-app-demo.md](2026-06-16-field-ops-mobile-app-demo.md) |
| 2026-06-17 | ERP Sprint Review | Transcript | 78.0 | [2026-06-17-erp-sprint-review.md](2026-06-17-erp-sprint-review.md) |
| 2026-06-18 | Dispatch Permits | Transcript | 86.7 | [2026-06-18-dispatch-permits.md](2026-06-18-dispatch-permits.md) |
| 2026-06-23 | Mobile App Payroll ADP And Draft Workflows | Transcript | 48.7 | [2026-06-23-mobile-app-payroll-adp-and-draft-workflows.md](2026-06-23-mobile-app-payroll-adp-and-draft-workflows.md) |
| 2026-06-25 | CC TCG ERP System | Transcript | 50.3 | [2026-06-25-cc-tcg-erp-system.md](2026-06-25-cc-tcg-erp-system.md) |
| 2026-06-30 | Mobile Sales Quotes | Transcript | 48.4 | [2026-06-30-mobile-sales-quotes.md](2026-06-30-mobile-sales-quotes.md) |
| 2026-07-01 | ERP Sprint Reviews Loading Workflow | Transcript | 39.2 | [2026-07-01-erp-sprint-reviews-loading-workflow.md](2026-07-01-erp-sprint-reviews-loading-workflow.md) |
| 2026-07-02 | Mobile App Dispatch | Transcript | 61.3 | [2026-07-02-mobile-app-dispatch.md](2026-07-02-mobile-app-dispatch.md) |
| 2026-07-07 | CC TCG ERP System | Transcript | 39.9 | [2026-07-07-cc-tcg-erp-system.md](2026-07-07-cc-tcg-erp-system.md) |
| 2026-07-09 | ADP And Data Migration | Transcript | 64.6 | [2026-07-09-adp-and-data-migration.md](2026-07-09-adp-and-data-migration.md) |
| 2026-07-14 | Meeting Skipped For Development | No recording | 0.5 | [2026-07-14-meeting-skipped-for-development.md](2026-07-14-meeting-skipped-for-development.md) |
| 2026-07-15 | Met On Zoom Recorded By CodingCops | No recording | 0.6 | [2026-07-15-met-on-zoom-recorded-by-codingcops.md](2026-07-15-met-on-zoom-recorded-by-codingcops.md) |
| 2026-07-16 | Payroll Implementation Discussion | Transcript | 36.0 | [2026-07-16-payroll-implementation-discussion.md](2026-07-16-payroll-implementation-discussion.md) |
| 2026-07-21 | Accounting Discussion | Transcript | 56.7 | [2026-07-21-accounting-discussion.md](2026-07-21-accounting-discussion.md) |
| 2026-07-23 | Accounting Invoicing | Transcript | 74.6 | [2026-07-23-accounting-invoicing.md](2026-07-23-accounting-invoicing.md) |
| 2026-07-28 | Invoicing Details Contracts Certs Trainings | Transcript | 59.6 | [2026-07-28-invoicing-details-contracts-certs-trainings.md](2026-07-28-invoicing-details-contracts-certs-trainings.md) |
| 2026-07-29 | ERP Review Dispatch DAS Update | Transcript | 34.2 | [2026-07-29-erp-review-dispatch-das-update.md](2026-07-29-erp-review-dispatch-das-update.md) |
| 2026-07-30 | Invoice Processing | Transcript | 57.7 | [2026-07-30-invoice-processing.md](2026-07-30-invoice-processing.md) |
| 2026-08-04 | Payroll Process | Transcript | 61.0 | [2026-08-04-payroll-process.md](2026-08-04-payroll-process.md) |
| 2026-08-06 | Certified Payroll Labor Compliance | Transcript | 79.0 | [2026-08-06-certified-payroll-labor-compliance.md](2026-08-06-certified-payroll-labor-compliance.md) |
| 2026-08-11 | Sales Process | Transcript | 60.6 | [2026-08-11-sales-process.md](2026-08-11-sales-process.md) |
| 2026-08-12 | ERP Sprint Review | Transcript | 39.3 | [2026-08-12-erp-sprint-review.md](2026-08-12-erp-sprint-review.md) |
| 2026-08-13 | Payroll Process | Transcript | 69.2 | [2026-08-13-payroll-process.md](2026-08-13-payroll-process.md) |
| 2026-08-18 | Accounting Process | Transcript | 58.1 | [2026-08-18-accounting-process.md](2026-08-18-accounting-process.md) |
| 2026-08-25 | Accounting Process | Transcript | 58.0 | [2026-08-25-accounting-process.md](2026-08-25-accounting-process.md) |
| 2026-08-26 | ERP Sprint Review | Transcript | 51.4 | [2026-08-26-erp-sprint-review.md](2026-08-26-erp-sprint-review.md) |
| 2026-09-01 | Accounting and Payroll | Transcript | 43.1 | [2026-09-01-accounting-and-payroll.md](2026-09-01-accounting-and-payroll.md) |
| 2026-09-02 | ERP Sprint Review — Job Tickets and Payroll | Transcript | 51.9 | [2026-09-02-erp-job-tickets-and-payroll.md](2026-09-02-erp-job-tickets-and-payroll.md) |
| 2026-09-03 | Payroll — lunch rules, paid-time boundaries, boom window, rate updates | Transcript | 56.9 | [2026-09-03-payroll-lunch-rules-and-dispatch-times.md](2026-09-03-payroll-lunch-rules-and-dispatch-times.md) |
| 2026-09-10 | Mostly Payroll — ST/OT/DT buckets, rest chain, holiday minimum, work orders, paper tickets | Transcript | 58.9 | [2026-09-10-payroll-rate-buckets-work-orders-paper-tickets.md](2026-09-10-payroll-rate-buckets-work-orders-paper-tickets.md) |
| 2026-09-15 | ERP Live Demo 01 — configuration, assets, quotation to project and job, DAS and trackers | Transcript | 59.7 | [2026-09-15-erp-live-demo-01.md](2026-09-15-erp-live-demo-01.md) |
| 2026-09-16 | Resource Types and Billing Codes | Transcript | 31.7 | [2026-09-16-resource-types-and-billing-codes.md](2026-09-16-resource-types-and-billing-codes.md) |
| 2026-09-22 | ERP Live Demo 02 — quotation to project, job schedule, permit and plan trackers, DAS allocation and vendors | Transcript | 53.4 | [2026-09-22-erp-live-demo-02.md](2026-09-22-erp-live-demo-02.md) |
| 2026-09-28 | ADP Integration Sync — new-hire onboarding in ADP, employee types, weekly worksheets, temp rate and the paydata CSV | Transcript | 52.7 | [2026-09-28-adp-integration-sync.md](2026-09-28-adp-integration-sync.md) |
| 2026-09-29 | Safety Discussion — onboarding and safety training, certification matrix, accident / injury / incident reporting, facility compliance, dev environment | Transcript | 63.7 | [2026-09-29-safety-discussion.md](2026-09-29-safety-discussion.md) |
| 2026-10-01 | Quotes and Billing Codes — associated field assets on the quote, operator load as one billing code, mob/demob quantities, holdover and support loads | Transcript | 64.2 | [2026-10-01-quotes-and-billing-codes.md](2026-10-01-quotes-and-billing-codes.md) |
| 2026-10-07 | ERP Sprint Review — offline job tickets, payroll-admin entry fixes, holdover demo, loadout wording, what a holdover is, mob/demob configuration sign-off, two cranes on one quote | Transcript | 51.4 | [2026-10-07-erp-sprint-review-offline-tickets-holdover-and-mob-demob.md](2026-10-07-erp-sprint-review-offline-tickets-holdover-and-mob-demob.md) |
