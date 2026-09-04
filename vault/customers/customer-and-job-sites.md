---
title: Customer and Job sites
source: confluence/TCG/Customer and Job sites — plus a 2026-09-04 pointer note from shared-folder/Project-Repository-2026-09-04
migrated: 2026-08-10
updated: 2026-09-04
status: unverified
conflicts_with: [customers/customer.md, meetings/2026-06-26-discussion-points-with-mohsin.md, meetings/2026-06-26-discussion-points-with-tcg-team.md, assets/user-story-and-tasks.md]
jira: []
tags: [module/customers, module/quotations, module/vendors-agencies, kind/reference, certifications, pricing, purchase-orders, reporting]
entities: [customer, job-site, certification, fcc, purchase-order, quotation, task, industry-code]
---

> **Two of the FCC questions below now have factual answers** (added 2026-09-04 from the Project
> Repository drop; the punch list itself is unchanged). FCC's own schema and screens are recorded
> in [fcc-legacy-customer-data-model.md](fcc-legacy-customer-data-model.md) and
> [fcc-maintain-customers-tcg-review.md](fcc-maintain-customers-tcg-review.md). In short: FCC has
> **one** contact table, and a job site points back into it by id for its Ordered-By and Report-To
> roles — there is no separate job-site contact table, though TCG's own review of the FCC screens
> asks for both mechanisms. FCC has **no certificate table at all** in the customer export set;
> TCG's review proposes handling certifications as documents per job site. FCC does have a
> `Directions` column on the job site, and it does have the `Insurance` / `Expires` /
> `ContractNumb` triple item 5 asks for — though the migration is not carrying them across, and
> TCG's screen review says insurance is "not needed". None of this is verified and none of it
> resolves [customers-INDEX.md](customers-INDEX.md).

## Customer-FCC

1. Ability to add industry codes

### Job Site

1. Add job site contact information -- need to verify from FCC if its [[customers/customers-INDEX|customer]] contact or seperate job site contact
2. fetch job site certificates -- need to verify from FCC if its customer certificates or seperate job site certificate
3. Add directions in job sites

### Customer

1. Remove tasks from customers
2. Notes - do TCG team use this feature ?
3. Need to ask TCG team to provide pre quote form -- we need to assicate this data with customers
4. Need to associate customer POs with customer -- need to ask TCG team to provide customer PO form / data
5. Insurance - if checked -- show expiry / contract number
6. Should we add billable work order / hike / discount on customer level
7. Add billing terms / calculate due date / discount date

> [image not migrated: screenshot embedded in the original Confluence page]

### Feedback on new Design

1. Remove forecast
2. Make need attention tab - coming soon
3. Show top 10 accounts based on highest revenue
4. Remove credit limit and forecaset from show page
5. Show tootlitps on all icons
6. Allow columns to be dragable
7. Allow horizontal scrolling on index table
