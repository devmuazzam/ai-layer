---
title: Post-save navigation — edit goes to detail, create goes to listing — decision
source: decision/Fouzan Shakil
decided: 2026-08-20
decided_by: Fouzan Shakil (developer on TCG, assignee on SCRUM-896's branch) — stated directly in chat on 2026-08-20, against `SCRUM-896/spec.md` §12 Q2. He is not the client-side product owner; `spec.md` §12 Q2 nominated "product team" as owner. This is an internal navigation convention decided by a named person on the team, binding on implementation now, and open to being overruled by the client. `status: reference` rather than `verified` for that reason, matching `decisions/2026-08-20-quantity-based-das-sets.md`.
status: reference
superseded_by: decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md
conflicts_with: []
resolves: SCRUM-896/spec.md#q2
jira: [SCRUM-896]
tags: [module/projects-jobs, kind/decision, requirements, lift-plans]
entities: [lift-plan, project]
---

> **Superseded in part, 2026-09-01**, by
> [`decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md`](2026-09-01-post-save-navigation-create-goes-to-detail.md).
> **The create half below is dead** — after creating an entity the user now lands on that
> **new entity's detail page**, app-wide, not on the listing. Fouzan Shakil reversed his own
> statement. **The edit → detail half of this note is unchanged and still stands**, which is
> why `status:` here is still `reference` and not `superseded`. Every carve-out under *What
> this does NOT settle* also survives. Read the 2026-09-01 note before acting on anything
> below.

## Decision

Two rules, app-wide, in Fouzan Shakil's words on 2026-08-20:

| After the user… | Land on |
| --- | --- |
| **edits** an entity — post-save on update | that entity's **detail page** |
| **creates** an entity | the **listing (table) page** |

This is a **convention, not a plan-only change**. It answers `SCRUM-896/spec.md` §12 Q2,
which asked exactly whether the ticket's plan behaviour generalises: it does.

The plan destination is already named: `decisions/2026-08-12-plan-comments-page-scope.md`
establishes the plan detail view as `/projects/{id}/plans/{planId}`, which is where branch
`scrum-896` already sends plan save/submit.

## Why

Update and create are asymmetric on purpose. Editing an existing record is a return to
something the user already had a relationship with — the detail page is where they were
going anyway, and it confirms the change landed. Creating one is the end of a task, and
the listing is where the user picks up the next one and sees the new row in context.

The convention exists because the alternative is per-module drift: fourteen modules each
picking a post-save destination, and a user who cannot predict where a Save button leaves
them. `SCRUM-896` asked for it on plans; without a stated convention, the same question
returns on the next module and gets answered differently.

## What this does NOT settle

Not asked, not answered, do not infer:

- **Cancel, and error paths.** Only the success path was decided.
- **Creates that do not start from a listing** — a create nested inside another record's
  page, a modal or drawer create, an inline row add, or a create reached from a wizard.
  Whether these also land on the listing, or return to where they were opened from, is
  undecided. The rule was stated for the ordinary full-page create.
- **"Save and add another"** or any variant that deliberately stays put.
- **Mobile (Expo).** The statement was about the app's save flows generally; nothing was
  said about whether the persona-driven mobile navigation follows the same rule. Treat as
  undecided rather than assuming either way.
- **Which existing modules are retro-fitted, and when.** The convention binds new and
  touched code; it does not by itself authorise a sweep across every module in one PR.

## Effect on the vault

- **No winner/loser flip applies.** No vault file specifies post-save navigation for any
  module, which is why §12 Q2 recorded `SCRUM-896` as its only candidate. Nothing is
  superseded; no `status:`, `superseded_by:` or `conflicts_with:` field changes anywhere.
- `.ai/aidlc/SCRUM-896/spec.md` §12 Q2 → `Status: resolved — see this note`.

## Effect on SCRUM-896

- The plan behaviour already shipped on branch `scrum-896` — save/submit → `/projects/{id}/plans/{planId}`
  — is **confirmed correct** and is now the app-wide rule rather than a local choice.
- Plan **create** already conforms — checked against branch `scrum-896` on 2026-08-20:
  `apps/web/src/app/(protected)/projects/[id]/plans/create/page.tsx` pushes
  `/projects/{id}/plans`, and the edit page pushes `/projects/{id}/plans/{planId}` after
  `executeSave`. **Q2's answer therefore requires no code change on this ticket.**
- Applying the convention to other modules still needs its own ticket. This note removes the
  product blocker, not the work.
