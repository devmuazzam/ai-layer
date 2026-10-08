---
title: "The sub-category tab 'Associated Field Assets' is renamed 'Field Assets Configuration' and gets its own activity log — who changed what, and when (ehtesham.anwar, CodingCops, 2026-10-07) — decision"
source: decision/ehtesham.anwar (CodingCops), announced on the recorded 2026-10-07 ERP sprint review
decided: 2026-10-07
decided_by: >-
  ehtesham.anwar (CodingCops PM), announced to TCG on the recorded 2026-10-07 ERP sprint
  review (meetings/2026-10-07-sprint-review-offline-tickets-holdover-and-mob-demob-sign-off.md §7;
  transcript meetings/transcripts/2026-10-07-erp-sprint-review-offline-tickets-holdover-and-mob-demob.md,
  50:33). TCG did not answer it — Joe Schacatano's next turn (51:05) is an unintelligible one-word
  ASR fragment, and nobody else spoke to it. This is a CodingCops decision, not a TCG client
  confirmation, so the status is `reference`: it binds the build, and TCG can overrule it. Built
  under Linear TCG-220 on branch feat/association-document-visibility, under review.
status: reference
conflicts_with: []
resolves: []
related_decisions:
  - 2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md
  - 2026-10-06-nested-association-quote-visibility-stored-per-parent.md
jira: []
tags: [module/assets, module/quotations, kind/decision]
---

# Field Assets Configuration: rename and activity log

## Decision

ehtesham.anwar, 2026-10-07 (50:33):

1. **Rename the sub-category tab** *Associated Field Assets* → **Field Assets Configuration**.
2. **Give it its own activity log**: *"so that whatever is being changed within the associated field
   assets configuration, we can see who is changing, what are they changing, when they are
   changing."*

## Why

The tab now holds configuration that changes what every new quote shows (the per-association Hourly
and Mob/Demob Show and Main/Sub settings, approved by Joe Schacatano the same day as configurable by
anyone with the permission —
[2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md](2026-10-06-association-quote-visibility-hourly-and-mob-demob-settings.md)).
A change there needs to be traceable to a person.

## What this does not settle

- **Which fields the log tracks**, and **who may see it** (meeting §11 Q5, filed for `assets`).
  Not asked of TCG.

## Effect on the vault

- No status flips.
