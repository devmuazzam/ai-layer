---
title: Post-save navigation — create goes to the new entity's detail page — decision
source: decision/Fouzan Shakil
decided: 2026-09-01
decided_by: Fouzan Shakil (developer on TCG) — stated directly on 2026-09-01, reversing his own 2026-08-20 statement: "create lands on detail page throughout all modules." He is not the client-side product owner; `SCRUM-896/spec.md` §12 Q2, the question the superseded note answered, nominated "product team" as owner. This is an internal navigation convention decided by a named person on the team, binding on implementation now, and open to being overruled by the client. `status: reference` rather than `verified` for that reason, matching `decisions/2026-08-20-post-save-navigation-convention.md`, which it supersedes in part.
status: reference
conflicts_with: []
supersedes: [decisions/2026-08-20-post-save-navigation-convention.md]
jira: [SCRUM-893, SCRUM-896]
tags: [module/all, kind/decision, requirements]
---

# Create lands on the new entity's detail page

Decided by **Fouzan Shakil** on 2026-09-01, stated directly: *"create lands on detail page
throughout all modules."*

This **reverses the create half** of
[`decisions/2026-08-20-post-save-navigation-convention.md`](2026-08-20-post-save-navigation-convention.md).
That note's **edit → detail** half is **unchanged and still stands.**

## The rule

| After the user… | Land on |
| --- | --- |
| **edits** an entity | that entity's **detail page** — unchanged from 2026-08-20 |
| **creates** an entity | **that new entity's detail page** — reversed; was the listing |

App-wide, both rows. Post-save success path only.

## Why

Two reasons, one practical and one from a survey of the build.

**The practical one, in the change that prompted the reversal.** Commit `891811af` on branch
`fix/quotation-das-resources`: creating a quotation dropped the user on the listing, where
they had to hunt for the row they had just made in order to check it or act on it. The
callback already carried the new quote's number and discarded it.

**The survey.** A pass over `apps/web` on 2026-09-01 found the 2026-08-20 rule was already
the **minority** behaviour in the codebase — the convention had been stated once and then
contradicted module by module ever since:

| Where create lands today | Count | Modules |
| --- | --- | --- |
| **detail** | 13 | agencies, assets (finalize), categories, departments, employees, temp employees, global POs, price listings, projects (from quotation), quotations, sub-categories, vendors, yards |
| **listing** | 6 | billing codes, customers, manufacturers, parts, global permits, tools & riggings |
| **parent context** | 6 | nested project/asset creates, department roles |

Every one of the six listing modules **already has the new entity's id or code available at
the call site and discards it** — so conforming them is a use of what is already there, not
new plumbing.

The six parent-context modules are **not violations**. They are the nested carve-out below,
and they stay as they are.

The survey's own summary line read 14 and 7 against these same lists; the counts here are
the named modules, which are what it actually enumerated with `file:line` evidence. Re-run
the survey before retro-fitting rather than treating either list as closed.

## What this does NOT settle

Not asked, not answered, do not infer. Every carve-out from the 2026-08-20 note survives
unchanged:

- **A create nested inside another record's context still returns to that context.** The
  worked example is the quotation create reached with `?projectId=`, which still returns to
  `/projects/{id}` — `apps/web/src/features/quotations/views/quotations.tsx:183-189`. The
  new rule is about where an *ordinary* create lands, not about breaking a user out of the
  record they started from.
- **Cancel, and error paths.** Still out of scope. Only the success path was decided.
- **Draft-save paths still go to the listing.** Quotations' `onDraftClose`, employees,
  assets and customers all do this today and are untouched by this note. Quotations'
  draft path also still seeds the list-URL snapshot
  (`apps/web/src/features/quotations/views/quotations.tsx:107`).
- **"Save and add another"** or any variant that deliberately stays put. Still undecided.
- **Mobile (Expo).** The statement was about the app's modules generally; nothing was said
  about whether persona-driven mobile navigation follows the same rule. Undecided rather
  than either way.
- **Which existing modules are retro-fitted, and when.** The convention binds new and
  touched code; it does not by itself authorise a sweep across every module in one PR.

## Effect on the vault

- `decisions/2026-08-20-post-save-navigation-convention.md` → **superseded in part.** Its
  `superseded_by:` now points here and a scope note sits at the top of its body. Its
  `status:` stays `reference` **deliberately** — the edit → detail half is still live
  product law, so flipping the whole file to `superseded` would retire a rule nothing
  replaced. Done in this pass.
- `INDEX.md` → *Start here* routing row added, and its `decisions/` table row for the
  2026-08-20 note now says the create half is superseded. Done in this pass.
- Module indexes → listed under *Decisions that bind this module* in all six module
  indexes that carry that section (`assets`, `customers`, `dispatch`, `projects-jobs`,
  `quotations`, `vendors-agencies`). The rule is app-wide, so stopping at the modules named
  in the survey would imply a boundary it does not have. Done in this pass.
- **Not done, and outstanding:** `.ai/aidlc/SCRUM-896/spec.md` §12 Q2 records the
  2026-08-20 answer as `resolved`, and its answer text still reads *"after creating one, go
  to the listing (table) page."* The forward pointer is reachable through the note it
  cites, but the sentence itself is now wrong. Same for §13's post-save bullet. Left for
  whoever owns that ticket's file.
- `assets/gaps.md` cites the 2026-08-20 note's *creates that do not start from a listing*
  carve-out. That carve-out **survives this note**, so the citation is still sound; no edit
  made.
- `accounting/gaps.md` cites the 2026-08-20 note only as an example of an app-wide UI
  policy owned by Fouzan. Unaffected; no edit made.

## Effect on SCRUM-893

`.ai/aidlc/processed.log` carries a 2026-08-24 row for `SCRUM-893` (branch
`feat/SCRUM-893`, areeba): *"Quote Info Company/Yard gap, Cancel border, create → listing
All"*. Part of what that ticket shipped was the quotation create landing on the listing
with the view filter cleared to All, via `seedListUrlSnapshot('/quotations', '')`.

Commit `891811af` removed that call **on the create path only**. This note **supersedes
that shipped behaviour deliberately** — it is a reversal of a decision, not a regression
against `SCRUM-893`. The ticket built what the 2026-08-20 convention asked for at the time;
the convention changed underneath it.

The draft path is unchanged and still seeds the snapshot
(`apps/web/src/features/quotations/views/quotations.tsx:107`), because a draft save does
still land on the listing and the remembered `view=draft` filter still has to be cleared
there.
