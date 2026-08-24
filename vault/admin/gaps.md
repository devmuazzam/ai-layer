---
title: Admin — open questions
status: reference
kind: gaps
updated: 2026-08-24
tags: [module/admin, kind/gaps, open-questions]
---

# Admin — open questions

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

## Integrations — HubSpot, Microsoft 365, Dialpad, Mapsly

- Question: what do the existing integrations do, and what should move into the ERP?
- Candidates: **none of substance.** HubSpot appears once, in `assets/user-story-and-tasks.md`,
  which was migrated from an individual's personal Confluence space and carries a
  `provenance_note` warning it may be a private draft rather than agreed specification.
  **Dialpad, Mapsly and Microsoft 365 appear nowhere in the vault.**
- Note: the 12 August minutes record that Patrick will demonstrate the working solution at the next
  meeting. Until then there is no written source, and the one HubSpot mention should not be treated
  as one.
- Blocked: the action item to review existing integrations for ERP incorporation.
- Owner: Patrick (demo), then whoever writes it down.
- Status: open
- **From (frozen original):** [gaps.md#integrations-hubspot-microsoft-365-dialpad-mapsly](../gaps.md#integrations-hubspot-microsoft-365-dialpad-mapsly)

## Map provider, no-key fallback, and which table owns address coordinates

- **Status:** open
- **Asked:** 2026-08-25 — SCRUM-936 PR review (branch `scrum-936`); tcg-scrum escalation
- **Question:** Three parts, each answerable in a line. (a) Which map provider is TCG's for
  address and job-site display — Google Maps, or the existing **Mapsly** integration that nobody
  has described (see *Integrations* above)? (b) When the Google Maps key is absent or rejected, is
  a **read-only OpenStreetMap embed** an acceptable production fallback, or should the map simply
  be absent until the key works? (c) Do address coordinates belong on each owning entity (today:
  `JobSite.latitude/longitude`) or on the shared `addresses` reference table, so that any address
  in the app can carry a pin?
- **Sources checked:** vault-wide grep for `openstreetmap|OSM|geocod|latitude|longitude|map view|
  api key` — **no vault file names a map provider, a fallback, or a coordinate owner**;
  [STRUCTURE.md](../STRUCTURE.md):42 assigns `geocoding` and address reference data to `admin/`,
  but no content exists behind that facet; `decisions/` (13 notes, none about maps);
  `customers/customers-INDEX.md` and its five candidates. Jira: **every map ticket has
  `description: null`** — `SCRUM-699` and `SCRUM-755` (duplicate, closed as such) *"need to
  integrate map for jobsite"*, `SCRUM-414` *Quotation: Job Site: Map View with FAA Radius and
  Permit Auto-Detection* (Blocked), `SCRUM-252` *Live Asset Map View* (To Do). `SCRUM-936` was
  created 2026-08-25 02:08 by the implementing developer and describes the code as built, so it
  cannot be cited as the requirement for it.
- **Weak signals, not answers:** `payroll/legacy-payroll-app-db-extract/data/source-feed.md`
  shows legacy FCC carrying `Latitude`, `Longitude`, `GeoFenceRadius` **and** `Directions` on the
  customer-location (job-site) row — coordinates owned by the location record. That is a
  migration-source precedent for (c), not a product decision.
  `meetings/transcripts/2026-07-09-adp-and-data-migration.md` — Brian Petros on FCC addresses:
  *"obviously it needs to be verified on entering because we'll need this for a lot of things for
  the mapping functionality"*. A meetings record, not a commitment, and what it asks for is
  **verification on entry** (forward geocoding), which `SCRUM-936` puts out of scope.
- **Blocked:** `SCRUM-936` (In Review) cannot be signed off as product-correct; `SCRUM-699` (In
  Review — QA blocked, Aiman Farooq 2026-08-24: *"unable to test it due to the Map APIs issue"*);
  `SCRUM-414` (Blocked); any move of coordinates onto `addresses`.
- **Owner:** Brian Petros (data and integrations — the only recorded voice on address
  coordinates), with Patrick for the Mapsly half.

