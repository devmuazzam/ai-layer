---
title: ERP Documentation and Guides — the documentation portal and its set-up order, test login and mobile access, staging environment, managers' workflow ideas deferred (20 October 2026)
source: user-supplied/meeting-transcript — curated
original_file: "2026-10-20_ERP DOCUMENTATION-GUIDES provided - transcript.docx"
migrated: 2026-10-22
updated: 2026-10-22
status: unverified
conflicts_with: []
jira: []
tags: [module/admin, module/assets, module/quotations, module/payroll, kind/meeting-notes, authentication, integrations, adp, mob-demob, sprint-planning]
meeting_date: 2026-10-20
---

# ERP Documentation and Guides — documentation portal, set-up order, test login, staging — 20 October 2026

Curated from [transcripts/2026-10-20-erp-documentation-and-guides.md](transcripts/2026-10-20-erp-documentation-and-guides.md)
(transcribed 2:32–27:45; the recording header says 38 m 32 s).
A short Tuesday call. **ehtesham.anwar** handed TCG the system documentation and walked its structure on a
shared screen. The second agenda item, managers' updated workflows, was deferred. TCG speakers: **Brian
Petros** (Data Analyst, ERP Project Coordinator), **Kyle Harlow** (VP of Fleet and Field Operations),
**Melissa McNutt** (President), **Brent Wagstaff** (CFO), **Micaela Dipane**. CodingCops: ehtesham.anwar,
abdulrehman, syed.haris. Roles are from [../admin/engagement-directory-and-org-charts.md](../admin/engagement-directory-and-org-charts.md).

> **Speaker labels.** "Brian Petros" is TCG's conference-room microphone. Dee speaks on it at 3:16–3:27.
> Several of its turns answer ehtesham.anwar addressing **Wes** (11:00, 11:09, 19:12, 26:01), so some
> may be Wes Staley. Quotes below give the label as captured. The transcript header lists the evidence.

> **Status.** Everything here is CodingCops describing what it built or plans, plus TCG's requests.
> Nothing on this call was a TCG product decision. The file is `status: unverified`.

## 1. The documentation portal (5:21–14:40)

- **What was delivered.** ehtesham.anwar: *"the whole documentation of the system that is deployed as of
  yet on web"* (6:13). It covers each module's purpose, functions, listing and table structure, with
  screenshots (7:01). Link sent in the meeting chat (17:47).
- **Where it lives.** For now it is a separate site on **Netlify**; screenshots load slowly (7:01).
  abdulrehman: it will become *"a permanent part of our web app"*, hosted on AWS, opened from a
  **documentation link in the portal's left sidebar** (14:14). By 10-21 the tab was there ([10-21 §1](2026-10-21-erp-demo-walkthrough-part-1-roles-craft-codes-agencies-billing-codes-price-lists-and-vendors.md)).
- **The set-up order it teaches** (7:01, 11:48): yard → departments and roles → HR configurations →
  tools and riggings → asset configuration → billing codes and price lists → customers → quotations →
  project management (projects, jobs, the job schedule, permit and plan trackers) → daily allocation
  system → dispatch operations per job → vendors → task and ticket dispatch, yard operations, field
  operations on mobile, ticket tracking → payroll → dashboard notifications → PO. **PO** will be updated
  once accounting is built; the accounting designs are still being finalised with Brent's team (7:01).
- **Quotation approval triggers named in the docs** (7:01): a quotation **above 50K** needs approval, and
  so does an amount **changed from the billing code**. *"All of the triggers, their explanations are in
  the documentation. This quotation approval has a separate documentation as well."*
- **Brian Petros (11:00–12:30):** *"Basically, we got to get through one through 5 to get this system up
  and going, correct?"* ehtesham.anwar: yes. *"So that's the exact order we need to set this thing up
  in."* — *"Yes."* ehtesham.anwar asked TCG to work through steps 1–5 and report missing functions (11:09).
- **HR configuration** holds the payroll union codes, craft codes and modifiers (12:30). TCG should set
  up its own employees and profiles rather than only use the supplied login (12:30).
- **Demo videos.** A guided video for each section, shared by Drive link (12:30–14:05).

## 2. What TCG needs to start testing (18:05–18:56)

Brian Petros listed four things (18:05, 18:29):

1. the manifest (the documentation guide);
2. the links to the videos;
3. *"the exact place to go and the login to use to do testing"* — the same portal address;
4. the recommended way to access, download and test the **mobile app**.

ehtesham.anwar: one message with the web details right after the call, and a second for mobile access
(18:32). syed.haris supplies the credentials to ehtesham.anwar (14:51–15:04).

## 3. Managers' workflow updates — deferred (15:07–19:18)

- ehtesham.anwar had planned the second half for the workflow changes managers want to show, because
  they affect *"what we need to build right now and what we can defer"* (15:07). The example was
  **Ryan's** notes on the sales and quoting process (16:05).
- Brian Petros: Ryan and Joe wanted to explain more about sales and quoting. He proposed a dedicated
  slot later in the week, *"Thursday would be a better time"* (16:38). *"Let's focus on what it is
  currently, and then we'll give them a chance to review what it currently is, and then see how we can
  integrate the new ideas"* (17:02).
- On 10-21 the Ryan session moved again, to **Tuesday** ([10-21 §11](2026-10-21-erp-demo-walkthrough-part-1-roles-craft-codes-agencies-billing-codes-price-lists-and-vendors.md)).

## 4. Brent's pending replies (19:21–20:14)

ehtesham.anwar asked Brent for two replies: to ehtesham.anwar's e-mail (the
[2026-10-16 review thread](2026-10-16-accounting-prototype-review-email-brent-wagstaff-and-ehtesham-anwar.md))
and to a Teams message from **Omar** (designer). Brent: *"There's a lot on there, so I'm working through"*
it (19:45). ehtesham.anwar will forward the chain to **Wes and Melissa** so they can help (19:51–20:14).

## 5. A walkthrough asked for, blocked by a deployment (20:21–27:08)

- **Melissa** expected a demo (20:21). ehtesham.anwar: the portal is as already demoed. The one change is
  in **asset management**: two new settings, *"hourly quote/invoice versus mob demob … quotation and
  invoice"* (20:50). These are the per-association **Hourly · Quote/Invoice** and **Mob/Demob ·
  Quote/Invoice** settings in
  [../decisions/2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md](../decisions/2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md). He also started to say that the quotation no longer shows every
  associated field asset, but the session had logged out and the sentence was cut off.
- **Brian Petros** asked for a step-by-step walkthrough for the managers who had not seen the system
  (21:33–22:12).
- **A deployment was running** (abdulrehman, 23:04). The login showed *"user"* instead of a name, so
  the walkthrough was not done (25:09–25:35).
- **Staging.** The developers are building a **separate staging environment** so a deployment does
  not break TCG's testing. ehtesham.anwar: done *"by the end of day … today"* (25:35). TCG has no
  blocker; *"The blocker is on our side"* (26:19).
- **Microsoft sign-in.** Brian Petros asked when users would log in with their own e-mail through the
  **Entra ID** integration instead of a general test login (26:37). ehtesham.anwar: to be planned once
  staging is done (26:55).

## 6. The sprint-review plan for 10-21 (23:28)

abdulrehman said five items and named four:

1. **mob and demob** updates in the quotation and in asset configuration;
2. **holdover** updates on web and mobile;
3. a new **ADP integration by API**: *"Corrina do not need to manually upload the worksheets in the ADP
   … they just need to press the button and that will auto-populate in the ADP. This is done."*;
4. a new development environment, so CodingCops develops in one environment and TCG tests in another.

None of them was shown on 10-21. That call was the configuration walkthrough instead.

## 7. Next

- **CodingCops:** send the web login and documentation in one message, then mobile access (§2).
- **10-21:** sprint review / demo (it became the walkthrough, part 1).
- **Thursday:** the managers' session (§3). It later moved.
- **Brent:** reply to the e-mail and to Omar (§4).

## Against the vault

- **The approval triggers** (§1) are CodingCops' description of the documentation, not a TCG statement.
  *"An amount that is changed from the billing code"* overstates the build, which triggers only on a
  rate **below** the reference rate (or a total over the threshold), as the review log has it. See the
  10-21 notes' *Against the vault* and the update on [../quotations/gaps.md](../quotations/gaps.md)
  *Is the $50,000 approval threshold inclusive or exclusive?*
- **ADP by API** (§6) changes the 2026-09-28 picture, where worksheets were uploaded by hand
  ([2026-09-28 ADP sync](2026-09-28-adp-integration-sync-onboarding-worksheets-and-temp-rate.md)). This
  call is CodingCops saying it is built, not a demo.
- **Entra ID sign-in** for TCG users is asked for here. The vault has no answer to *when*.
- **Staging and a TCG-only test environment** follow the 2026-09-28 note that TCG had no sandbox.

## Candidates for a decision note (for `tcg-scrum`)

None. TCG agreed to work through the set-up order and to defer the managers' session. Neither is a product
rule.

## 8. Questions this raises

1. **When does Entra ID sign-in replace the shared test login?** (§5) Filed 2026-10-22 as new evidence
   on [../admin/gaps.md](../admin/gaps.md) *Sign-in identity — Microsoft 365 (Entra) credentials, or
   phone number and SMS code, and for whom?*

The two asset settings at 20:50 were first listed here as a question. They are not open: they are the
settings in the 2026-10-06 decision (§5).
