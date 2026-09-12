---
title: Edit leave confirmation offers Save — create stays Leave/Cancel — decision
source: decision/Fouzan Shakil
decided: 2026-09-12
decided_by: Fouzan Shakil (developer on TCG) — stated by accepting the 2026-09-12 leave-confirmation PR-review plan and confirming the convention already encoded in `useUnsavedChangesGuard` / the staged edit leave-Save wiring. Internal UI / form convention, same class as post-save navigation; `status: reference` rather than `verified` for that reason. Open to being overruled by the client.
status: reference
conflicts_with: []
supersedes: []
jira: []
tags: [module/all, kind/decision, requirements]
---

# Edit leave modal offers Save; create stays Leave / Cancel

Decided by **Fouzan Shakil** on 2026-09-12. Closes
[`admin/gaps.md` → *Edit-form leave confirmation offers Save…*](../admin/gaps.md#edit-form-leave-confirmation-offers-save-create-stays-leavecancel--app-wide-unwritten).

## The rule

App-wide web forms that use `useUnsavedChangesGuard` + `UnsavedChangesDialog`:

| Mode | Dirty leave modal |
| --- | --- |
| **Edit** | **Cancel / Leave / Save** — Save runs the feature's existing save (including its normal post-save navigation). |
| **Create** (no draft) | **Leave / Cancel** only — no full Save on the leave dialog. |
| **Create** with `onSaveDraft` | **Cancel / Leave / Save Draft** — draft success continues the pending navigation (`skipNavigation: true` on the draft handler). |

### Boolean Save contract (edit)

Leave-dialog **Save** must resolve `true` only on successful save. Validation failure, API failure, or throw → resolve `false` (or catch and return `false`). The dialog **stays open** so the user can fix, retry, or Leave. Never leave the dialog stuck in `isSaving`.

RHF forms should use `createRhfSaveFromLeave` (`apps/web/src/hooks/create-rhf-save-from-leave.ts`). Shared shells (`FeatureWorkspaceShell`, `PartsWorkspaceShell`) treat `onSave` success as `result === true` only.

## Answers to the gap questions

- **(a)** Dirty **edit** leave modal **offers Save** (persist via the page's save path).
- **(b)** Failed validation or API reject **keeps the dialog open** (boolean-success contract).
- **(c)** Create / edit asymmetry is **intentional app-wide** — create = Leave/Cancel (unless Save Draft); edit = Cancel/Leave/Save.

## What this does NOT settle

- Whether **Leave** on create **discards** in-memory draft state (`onDiscard`) — still
  [`admin/gaps.md` (d) on Leave discards the draft](../admin/gaps.md#branch-fixdas-fixes--state-beside-city-save-with-no-changes-back-in-multi-step-forms-leave-discards-the-draft-capped-percentages).
- What leave-Save means when **several tabs** are dirty / one PATCH per tab —
  [`assets/gaps.md` → *One tab, one PATCH…*](../assets/gaps.md#one-tab-one-patch--and-what-the-leave-guards-save-means-when-several-tabs-are-dirty).
- Whether create-form **prefill** should trip the dirty guard —
  [`assets/gaps.md` → *Create-form prefill…*](../assets/gaps.md#create-form-prefill-from-url-query-params--the-whole-contract-is-unwritten) Q3.
- Customer **create wizard** vs **edit workspace** split (wizard still create-only leave; edit lives in `CustomerEditWorkspaceView`) — existing surface carve-out, not reopened here.
- **Mobile (Expo).**
- Cancel / error paths beyond the leave dialog — still out of scope for
  [`decisions/2026-09-01-post-save-navigation-create-goes-to-detail.md`](2026-09-01-post-save-navigation-create-goes-to-detail.md).

## Implementation anchors

- `apps/web/src/hooks/use-unsaved-changes-guard.ts` — three dialog modes in JSDoc
- `apps/web/src/hooks/create-rhf-save-from-leave.ts`
- `apps/web/src/components/templates/feature-workspace-ui.tsx` — `FeatureWorkspaceShell`
- `apps/web/src/features/parts/components/parts-workspace-shell.tsx`
- `apps/web/src/components/molecules/unsaved-changes-dialog.tsx` — `unsaved-changes-*` test ids
