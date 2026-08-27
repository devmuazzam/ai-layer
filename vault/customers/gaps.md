---
title: Customers — open questions
status: reference
kind: gaps
updated: 2026-08-27
tags: [module/customers, kind/gaps, open-questions]
---

# Customers — open questions

Live register per [STRUCTURE.md](../STRUCTURE.md) → *Where a question goes*. Ticket-raised
questions do **not** go here — they belong in that ticket's `spec.md` §12.

Entry format (unchanged from the retired registers, so the global sweep still works):

```markdown
## <question title>
- **Status:** open
- **Asked:** YYYY-MM-DD — by whom / which work raised it
- **Question:** one paragraph
- **Sources checked:** what was read before declaring this open
```

## Tasks on customers — reversed on tape, then removed with no artefact

- Question: should the customer record carry Tasks (a per-customer task manager, with CRM built on
  top), or were tasks correctly dropped?
- Candidates:
  - Recording **2026-03-20**, transcript lines 86–94 (**unattributable — no speaker labels**). The
    driver opens by proposing to drop them: *"Notes and tasks there. I think these are not being
    used… Should we not worry about notes and tasks for customers?"* A second voice pushes back:
    *"I mean, it would be nice. **I would keep them.**"* A third: *"because for tasks, like if we
    build it within the system like a **task manager**, if a customer needs certain things."* /
    *"It's like the **CRM will be built on top of this section** then kind of."* The driver closes:
    *"All right, so **we'll keep those**."* A fourth voice notes at line 90 that the mockups *"put the
    tab there, but they didn't actually build anything."*
  - `customers/customer-and-job-sites.md:25` — *"Remove tasks from customers"*, in a file updated
    **2026-06-12**, three months *after* the recording said keep them. :26 — *"Notes - do TCG team
    use this feature ?"* — is a **question**, and the recording answers it: yes. Both lines are
    duplicated verbatim into `meetings/2026-06-26-discussion-points-with-tcg-team.md` (see
    `customers/customers-INDEX.md` — one document's opinion appearing twice, not two sources agreeing).
  - `SCRUM-198` — **Done**, created 2026-04-27. Its premise is that *"Job Site tabs, Attachments,
    Notes, Certifications, **Tasks** are not available during Customer creation"* and are *"only
    visible and accessible in Edit mode"* — so **a Tasks tab existed on the customer edit screen in
    April**. `SCRUM-52` *Make Notes Section Functional* — **Done**.
  - A search of the whole project for task tickets returns exactly one issue: `SCRUM-198`. **There has
    never been a ticket to build, spec, or remove a customer task manager.**
- Note: notes and tasks diverged and should be answered separately. **Notes survived and were built**
  (`AttachmentFeatureType.CUSTOMER_NOTE`, plus continuous investment through June) — that half is
  settled by the sequence of events and matches the recording. **Tasks did not exist and do not
  exist**: there is no `Task` model anywhere in `apps/api/prisma/schema.prisma` and no task relation
  on `model Customer`. This is the one pair where **not even (b) can be established** — the removal
  left no ticket, no date and no author, so it cannot be attributed or dated at all. It may be that
  nothing was ever removed because nothing was ever built behind the tab, which is exactly what the
  line-90 voice suspected. The "CRM built on top" ambition has no vault or Jira presence of any kind.
- Blocked: any CRM scope discussion; whether the customer detail page should carry a Tasks tab.
- Owner: Melissa McNutt (policy/customer).
- Status: open
- **From (frozen original):** [gaps.md#tasks-on-customers-reversed-on-tape-then-removed-with-no-artefact](../gaps.md#tasks-on-customers-reversed-on-tape-then-removed-with-no-artefact)

## Customer-level comments — asked for on tape, removed by a QA ticket four weeks later

- Question: should the Customer show page carry an internal Comments section (visible to
  accounting, dispatch and anyone interacting with the customer) — and is that the same thing as
  the Notes tab that exists today, or a second feature alongside it?
- Candidates:
  - Recording **2026-03-06 "Sales-Quoting Figma demo"**, `ehtesham.anwar` (**CodingCops**) at 4:52,
    transcript line 154: *"Comments is going to be used for internal comments from from accounting,
    from dispatch, from from all of the all of the people who can interact with the customer."*
    **This is the vendor narrating his own Figma, not a TCG ask** — Ryan Adams' only reply (8:54) is
    about security and does not mention Comments.
  - Recording **2026-03-20 "FCC fields/screens review"** — the actual TCG ask, transcript lines
    72–84: *"there's just no comments here. But sometimes we do. Right. On customers."* / *"We want
    comments on the customer level."* / and the driver closing the item at line 84: *"So that's.
    Have comments on the customer level. Okay."* Fireflies summary line 44: *"The team wants to keep
    comments and notification features at the customer level."* **Unattributable — this transcript
    has no speaker labels.** At least three distinct voices participate.
  - `SCRUM-49` *Remove Comments Section from Customer Show Page* — **Done**, reporter Aiman Farooq
    (CodingCops QA), created **2026-04-16**, updated 2026-04-20. Its entire justification is
    *"It is not required as part of the current UI/UX scope."* **No requester, no meeting, no date
    cited.** It post-dates the TCG ask by four weeks.
  - `SCRUM-898` *Implement In-House Comment as Chat Functionality Across the Application* — **To
    Do**, created 2026-08-17, parent `SCRUM-24` (Across App), **not** the Customers epic. A
    cross-app UI-paradigm ticket, not a customer-comments re-add.
  - `customers/customer.md:35-40` — the lines the combined entry cites are about **notes**, not
    comments. **The word "comment" does not appear in that file.** No vault file covers customer
    comments at all; the citation in the pair row should be read as a near-miss.
- Note: **the chronology in the pair row is inverted.** TCG asked for customer comments on
  2026-03-20; QA removed the section on 2026-04-16; nobody re-added it. So this is not "the client
  changed its mind" — it is an ask that was overwritten by an internal scope judgement. Two further
  facts sharpen it: the data was never removed (`comments String[] @default([])` survives on
  `model Customer`, orphaned with no UI), and the in-house comments feature was rebuilt from scratch
  in May under a different name (`SCRUM-355`, `SCRUM-360`) on projects and plans, never re-attached
  to customers. **A second requirement rode along in the same passage and is recorded nowhere** —
  transcript lines 75–79 ask for customer-level **pop-up notifications that fire when a job or work
  order is opened** (*"if certain customers require certain things… there's a pop up notification"*),
  explicitly flagged in-meeting as *"a side note for coding cops"*. No vault entry, no ticket.
- Blocked: the Customer show page; whether `Customer.comments` should be wired up or dropped;
  `SCRUM-898`'s scope, which will decide the paradigm for every module.
- Owner: Melissa McNutt (policy/customer). The 03-20 speaker is unrecoverable, so this must be put
  to the customer owner rather than to "whoever said it".
- Status: open
- **From (frozen original):** [gaps.md](../gaps.md#customer-level-comments-asked-for-on-tape-removed-by-a-qa-ticket-four-weeks-later)

## Customer status values — neither side was built

- Question: what is the customer status value set — `Active / Inactive / Prospect / On hold` as asked
  for on 2026-03-20, or the auto-calculated activity indicator in the vault — and are those even the
  same field?
- Candidates:
  - Recording **2026-03-20 "FCC fields/screens review"**, transcript lines 57–58 (**unattributable —
    no speaker labels in this file**): *"Status or do we need anything other than. I think there's
    three statuses actually in fcc… But there's active, inactive, and prospect. Right."* / *"We
    should put maybe on hold. So. Yeah, active, inactive, prospect, and then on hold."* Fireflies
    summary line 39 confirms the ask.
  - `assets/user-story-and-tasks.md:100-108` — *"Customer records display status using colour-coded
    indicators: Green = Active, Yellow = Inactive for 6 months, Red = Inactive for 1 year"*, and
    *"Status is automatically calculated based on latest activity date"*. **This is a personal-space
    draft by Umair Khan (CodingCops)** — see its `provenance_note`; the same person is the Jira
    reporter on `SCRUM-715` and `SCRUM-468`.
  - **Jira: no ticket, ever.** A text search across the project and a full enumeration of the
    Customers epic (`parent = SCRUM-6`, ~90 issues) turn up nothing about the status value set.
- Note: **these are probably not the same field**, and that is the first thing to settle. The vault
  describes an *auto-calculated activity indicator* derived from last-activity date; the recording
  describes a *manually-set lifecycle status* including a commercial state (Prospect) and an
  operational hold. A system can reasonably have both. Two further facts: the built enum is
  `CustomerStatus { DRAFT, ACTIVE, INACTIVE }` — **neither side's proposal**, and its one extra value
  (`DRAFT`) traces to the draft-save punch-list theme, not to this conversation. And the meeting's
  own premise is shaky: the legacy FCC extract (`payroll/legacy-payroll-app-db-extract/data/source-feed.md:170`)
  shows FCC carried `Status` *and separately* `ProspectCode` / `ProspectStatus` — so "prospect" was a
  flag beside the status there, not a status value. **Both sides are unimplemented**, so nothing has
  to be unwound whichever way this goes.
- Blocked: the customer status filter (`SCRUM-191`, Done, ships a filter over the three-value enum);
  any CRM or pipeline work that needs a Prospect state; the unbuilt activity indicator.
- Owner: Melissa McNutt (policy/customer).
- Status: open
- **From (frozen original):** [gaps.md](../gaps.md#customer-status-values-neither-side-was-built)

## Job-site map — required on the form, and what shows when it is unavailable

- **Status:** open
- **Asked:** 2026-08-25 — SCRUM-936 PR review (branch `scrum-936`); tcg-scrum escalation
- **Question:** On the customer job-site form: (a) is the map **required** — must a job site carry
  a pin before it can be saved, or is it a convenience over manual address entry? (b) when no map
  can be shown, is *"Map view not available."* with manual address entry unchanged the intended
  behaviour, and is that the canonical copy? (c) which other address forms should show a map at
  all — vendor, yard, employee, quotation job site — now that the picker is a shared component?
- **Sources checked:** `customers/customers-INDEX.md` (the five-source conflict stub — **no
  candidate mentions a map**); `customers/customer.md` (Mohsin punch list, the largest customer
  source — **the word "map" does not appear in it**); `customers/customer-and-job-sites.md`, whose
  job-site asks are contacts, certificates and *"Add directions in job sites"* — that last one
  corresponds to the legacy FCC `Directions` **text** column, not a map;
  `assets/user-story-and-tasks.md`; `decisions/`. Jira `SCRUM-699`, `SCRUM-755`, `SCRUM-200` — all
  `description: null`.
- **Note:** the OpenStreetMap fallback on `SCRUM-936` traces to an **environment** problem rather
  than a product ask — `SCRUM-699` comment, Aiman Farooq 2026-08-24: *"unable to test it due to
  the Map APIs issue"*. Graceful degradation is reasonable engineering; what is unsourced is that
  a second map provider and this copy are what TCG wants users to see.
- **Blocked:** `SCRUM-936` sign-off; `SCRUM-699` QA; per-form wire-up of the shared picker.
- **Owner:** Melissa McNutt (policy/customer) for the form and the copy. Provider choice, fallback
  policy and coordinate ownership are the admin half —
  [admin/gaps.md](../admin/gaps.md#map-provider-no-key-fallback-and-which-table-owns-address-coordinates).

## Pointers — 2026-08-27 client follow-ups touching customers

- **Status:** open
- **Asked:** 2026-08-27 — Brian Petros, written message to the TCG team, 2026-08-27 ("A couple things that came up in my discussion with CodingCops today, that we'll discuss in future meetings"), following the 2026-08-26 ERP sprint review — logged in [payroll/client-message-findings.md](../payroll/client-message-findings.md#cross-module--2026-08-27-follow-ups-after-the-fcc-migration-first-pass-brian-petros)
- **Question:** two of Brian's items land on other modules but affect customer data: (a) which
  system holds the current contact record — HubSpot/Microsoft/Dialpad are synced, FCC is not →
  [admin/gaps.md](../admin/gaps.md#integrations--hubspot-microsoft-365-dialpad-mapsly); (b)
  "customer-owned assets" → [assets/gaps.md](../assets/gaps.md#customer-owned-assets--what-they-are-and-whether-the-erp-tracks-them).
  Also for the record: the FCC first-pass migration **redacted customer contact emails and phone
  numbers** and skipped SSNs (2026-08-26 sprint review); un-redaction is planned for production.
- **Owner:** see the two owning entries.
