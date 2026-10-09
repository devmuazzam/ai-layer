# mobile-ticket-fix — implementation record

Recorded 2026-10-08. Platform and overlay branch: `mobile-ticket-fix`.
Related platform PR: [#748](https://github.com/TheCraneGuys/craneguys-platform/pull/748),
identified by the final commit's message. PR merge/release status was not checked.

Platform checkpoint: `b0bfa0c335b604479e09f9291f7a23f3ddf266d2`.
Comparison: `origin/main...HEAD`, with local `origin/main` at
`2ae5262390636ec0aa01232c8cc1a3bac94a482d` and merge base
`8ea79319523daee8bf86abc0f4fc15b23f5c6f09`.
The comparison contains six commits and 56 changed files.

This is a retrospective as-built record, not a new approved spec, a full-loop
completion claim, or a runtime review verdict. Source paths below are relative to
the platform repository unless explicitly described as overlay paths.

## Evidence and product status

[VERIFIED — Git enumeration] `git log --reverse origin/main..HEAD`,
`git diff origin/main...HEAD --stat`, and `git diff --name-only origin/main...HEAD`
established the commits and changed-file inventory recorded below.

[VERIFIED — tracker reads] Read-only Linear `get_issue` calls for TCG-44, TCG-136,
TCG-110, TCG-201, TCG-8 and TCG-7, plus `list_comments` for the first five,
established the written requirements and outstanding questions. At recording,
the five principal tickets were `Dev Internal QA`; TCG-7 was `Done`. Tracker
status is not proof of delivery or acceptance. This writeback changes neither.

[INFERRED — code read] The behavior descriptions below come from the committed
diff and referenced implementations. They have not been verified on a device.
The field-ops sources remain unverified and conflicting; see overlay
`vault/field-ops/field-ops-mobile-INDEX.md` and its candidates
`field-ops/field-ops-frd/INDEX.md`, `field-ops/frd-new-format-draft/INDEX.md`, and
`field-ops/atom-mobile-app-user-stories/INDEX.md`. This record adjudicates none.

## TCG-44 — remove customer signature photos

Commit: `eef2248e3`.
Source: [TCG-44](https://linear.app/the-crane-guys/issue/TCG-44/removing-a-customer-signature-photo-does-not-delete-it),
description and Syed Haris's technical comment dated 2026-09-23.

- `components/capture/use-photo-removal.ts` gains a `signatures` target while
  retaining the default checklist target and existing local-attachment handling.
- `data/hooks/use-ticket-signatures.ts` adds `useDeleteTicketSignatureAttachment`,
  exported by the hooks barrel. It calls the existing signature-attachment delete
  service with the session epoch.
- `components/field/signer-capture.tsx` clears local photo state and the parent
  capture reference, attempts server deletion for non-mock attachments, and shows
  a failure toast. The shared component reaches Sig1, Sig2 and WTL sign-off.
- `apps/api/prisma/scripts/report-orphan-signature-attachments.ts` is a new
  read-only audit: enumerate `TICKET_SIGNATURE` attachments referenced by neither
  signature-image nor identity-photo fields; report rows, counts and byte totals
  grouped by tenant. It was not executed; no historical files were deleted.
- Added `use-photo-removal.test.ts` and `signer-capture.test.tsx`.

The deletion endpoint and backend `TicketSignaturesService.removeAttachment`
already exist in the comparison base; this branch wires the mobile consumer,
not a new API delete route. The backend delegates to `removeUnreferenced` after
resolving employee access to the ticket. Referenced-photo protection and
idempotence are inherited behavior, not newly runtime-tested here.

Still open: retention, post-submission removal policy, and whether a signer photo
is required or optional. TCG-44 and overlay `vault/field-ops/gaps.md` under
"Signer photo — CodingCops committed on the call and no ticket exists" retain
those questions. No cleanup/backfill approval or verified retention decision
is implied by this implementation.

## TCG-136 — signature drafts and guarded step exit

Commit: `244b5dd30`, with corrections in `b0bfa0c33` below.
Source: [TCG-136](https://linear.app/the-crane-guys/issue/TCG-136/mobile-go-back-to-ticket-after-taking-a-photo-source-unknown),
description and Syed Haris's technical comment dated 2026-09-23.

- `components/capture/signature-pad.tsx` and
  `components/field/signature-capture-field.tsx` accept initial paths/points and
  report stroke changes. Sig1 and Sig2 store these in their step drafts so drawn
  signatures survive unmount/remount, and clear them when starting a new drawing.
- `SignerCapture` exposes caller-controlled `onPhotoSaved` after successful
  capture. It does not navigate itself. Static `rg -n 'onPhotoSaved' apps/mobile
  -g '!*.test.*'` found only its declaration and invocations inside that component:
  no production caller supplies it, so automatic photo-to-ticket navigation is
  not implemented by this branch. The WTL caller gains no such navigation.
- `use-step-draft.ts` tracks dirty patches and supports discarding changes.
  `use-unsaved-changes-guard.ts` and `StepBodyShell.tsx` centralize leave prompts
  for dirty state or in-flight uploads, with read-only/saving exclusions.
- Guard inputs are connected to Sig1, Sig2, JSA, checklist views, Labor,
  Compliance, generic SignatureBody and TimeRecord. Some surfaces use persisted
  drafts; generic signature/compliance surfaces reset their local signature state.
- Added/updated signature-pad, draft and navigation-guard tests.

The ticket explicitly says to confirm the request's origin and target screen
before building photo-triggered navigation. Neither its description nor its only
comment records that confirmation. Preserve that open scope question; persistence
and leave protection here are as-built facts, not a claimed product ruling or
completion of the ticket's navigation acceptance criteria.

## TCG-110 — certificates without expiry dates

Commit: `b112c52ce`.
Source: [TCG-110](https://linear.app/the-crane-guys/issue/TCG-110/mobile-certificate-with-no-expiry-shows-as-expired),
description and technical comment.

- `apps/api/src/usecase/me/me.service.ts` stops substituting an attachment's
  upload date when no expiry can be resolved. Existing validity-period derivation
  remains. Responses add status `none` and omit `expires` for undated entries.
- Undated entries sort after dated entries; normalized-name deduplication treats
  an undated credential as taking precedence over a dated one. This precedence is
  an implementation choice recorded here, not a separately approved product rule.
- Mobile's certification contract accepts the fourth status and optional date;
  the Certifications screen shows a neutral "No expiry" badge without a renewal
  action. `cert-expiring-card.tsx` tolerates an absent expiry string.
- Added API certification cases and updated mobile contract/screen cases.

Still open on the ticket: whether no expiry counts as valid or is a separate
"not tracked" state. Web counts and the separate DAS expired-permit question
are not changed here. Do not infer that the new deduplication precedence settles
credential validity policy.

## TCG-201 — image compression and attachment limits

Commit: `bb0a3a30d`.
Source: [TCG-201](https://linear.app/the-crane-guys/issue/TCG-201/mobile-compress-attachments-and-enforce-an-attachment-size-limit).

- New shared attachment constants set ticket/general caps to `50 * 1024 * 1024`
  bytes (50 MiB), image max dimension to 1920 pixels, and JPEG quality to 0.75.
  Mobile re-exports the ticket cap through its existing attachment contract.
- General-attachment and field-ticket API controllers use shared limits instead
  of the prior 25 MiB caps. This reaches general uploads beyond field tickets.
- New `apps/mobile/lib/image-compression.ts` compresses eligible images to JPEG,
  resizes when dimensions are available and exceed the cap, normalizes filenames
  and MIME, and measures output size where possible. SVG/GIF and other files pass
  through; compression failure falls back to the original file.
- `use-photo-capture.ts` processes images before online upload or offline local
  storage. Ticket Attach File and incident-evidence pickers compress before
  passing files to the existing size-validation partitioner. Files with unknown
  size still rely on server enforcement; no universal client-limit guarantee
  is claimed for every capture path.
- Generic ticket-attachment HTTP timeout rises from 120 seconds to 300 seconds.
- Adds `expo-image-manipulator` and its lockfile entries. Adds image-compression
  cases and updates attachment-size/sheet cases and Jest native mocks.

The ticket requests decisions on file size, attachment count and image targets;
its description specifies no values and `list_comments(TCG-201)` returned none.
The 50 MiB / 1920 / 0.75 values are implemented defaults whose approval is not
established by this writeback. No agreed per-step attachment-count cap is recorded.
Runtime readability, offline queue behavior and oversized-file rejection remain
unverified in this session.

## TCG-8 / TCG-7 — remove developer switches from shipped profiles

Commit: `0935461a3`.
Sources: [TCG-8](https://linear.app/the-crane-guys/issue/TCG-8/mobile-crews-can-edit-recorded-work-times-dev-tool-left-on)
and [TCG-7](https://linear.app/the-crane-guys/issue/TCG-7/pre-trippost-tripjsa-checklists-are-pre-ticked-pass-in-every-shipped).

- Removes both `EXPO_PUBLIC_ENABLE_SEGMENT_TIME_ADJUST` and
  `EXPO_PUBLIC_ENABLE_CHECKLIST_AUTOFILL` from `eas.json` base environment.
- Adds `data/eas-build-env.guard.test.ts` checking every `EXPO_PUBLIC_ENABLE_*`
  key in base, preview and production, including inherited profile environments.
  Adds recorded-segment adjustment test coverage.
- These are committed config/test changes. No EAS build, store submission,
  installed-build check, or historical exposure report was performed here.

TCG-8 requires new builds and store submissions on both platforms and assessment
of tickets whose times could have been adjusted. TCG-7 additionally describes
inspection-history exposure and human disposition. Neither release nor historical
remediation is established by the branch diff. This record does not change the
existing UAT register or mark the flags' device acceptance criteria as verified.

## PR #748 feedback corrections

Commit: `b0bfa0c33`.

- `setStepData` gains an explicit replacement option; draft discard cancels
  pending work and replaces the saved draft with its entry snapshot instead of
  merging, removing newly added fields and retaining the original stamp.
- SignaturePad restores validation from stored points or decodes legacy M/L
  paths, and reports restored validity to the parent so resumed drawings submit.
- The leave guard uses native-stack-aware `usePreventRemove` rather than a
  manually managed removal listener.
- `ticket-step-screen.tsx` signals successful completion immediately before back
  navigation. A ticket/step-scoped context lets the guard allow that navigation
  without a false discard prompt; unsuccessful saves retain leave protection.
- Sig1 and Sig2 flush final attachment fields before completion removes drafts.
- Adds/updates draft replacement, restored-signature, completion-context and
  leave-guard cases; updates Jest setup for the navigation hooks.

These are recorded remediation behaviors, not a claim that PR feedback was
runtime-verified or that every original ticket requirement is complete.

## Validation and delivery status

No tests, builds or typechecking were run, as requested in this session.
No database audit script, EAS build, deployment, data cleanup or store release ran.
Added tests were inspected as source only; no passing counts are asserted.
The `.ai` writeback received static diff/whitespace inspection only.

Open items remain on their source tickets: TCG-136 request confirmation and
navigation scope; TCG-201 numeric defaults/count approval; TCG-110 validity and
deduplication policy; TCG-44 evidence retention; TCG-8/7 release validation and
historical exposure. No new verified vault decision is created.

## Complete platform changed-file inventory

Generated from the recorded merge base to the checkpoint; includes tests, mocks,
contracts, dependencies, API and shared changes as well as mobile behavior files.

- `apps/api/prisma/scripts/report-orphan-signature-attachments.ts`
- `apps/api/src/presentation/attachments/attachments.controller.ts`
- `apps/api/src/presentation/field-tickets/field-tickets.controller.ts`
- `apps/api/src/usecase/me/me.service.spec.ts`
- `apps/api/src/usecase/me/me.service.ts`
- `apps/mobile/app/(field)/menu/certifications.test.tsx`
- `apps/mobile/app/(field)/menu/certifications.tsx`
- `apps/mobile/components/capture/signature-pad.test.tsx`
- `apps/mobile/components/capture/signature-pad.tsx`
- `apps/mobile/components/capture/use-photo-capture.ts`
- `apps/mobile/components/capture/use-photo-removal.test.ts`
- `apps/mobile/components/capture/use-photo-removal.ts`
- `apps/mobile/components/field/cert-expiring-card.tsx`
- `apps/mobile/components/field/signature-capture-field.tsx`
- `apps/mobile/components/field/signer-capture.test.tsx`
- `apps/mobile/components/field/signer-capture.tsx`
- `apps/mobile/components/field/ticket-attachment-file.test.ts`
- `apps/mobile/components/field/ticket-attachment-file.ts`
- `apps/mobile/components/field/ticket-attachments-sheet.test.tsx`
- `apps/mobile/components/field/ticket-attachments-sheet.tsx`
- `apps/mobile/data/contracts/certifications.contract.test.ts`
- `apps/mobile/data/contracts/certifications.contract.ts`
- `apps/mobile/data/contracts/ticket-attachment.contract.ts`
- `apps/mobile/data/eas-build-env.guard.test.ts`
- `apps/mobile/data/hooks/index.ts`
- `apps/mobile/data/hooks/use-ticket-signatures.ts`
- `apps/mobile/data/services/ticket-attachments/ticket-attachments.http.ts`
- `apps/mobile/eas.json`
- `apps/mobile/features/field-ticket/flow/ticket-step-screen.tsx`
- `apps/mobile/features/field-ticket/incident-sheet.tsx`
- `apps/mobile/features/field-ticket/steps/compliance/ComplianceBody.tsx`
- `apps/mobile/features/field-ticket/steps/jsa/JsaBody.tsx`
- `apps/mobile/features/field-ticket/steps/labor/LaborBody.tsx`
- `apps/mobile/features/field-ticket/steps/shared/StepBodyShell.tsx`
- `apps/mobile/features/field-ticket/steps/shared/checklist/ChecklistBody.tsx`
- `apps/mobile/features/field-ticket/steps/shared/checklist/ChecklistEngine.tsx`
- `apps/mobile/features/field-ticket/steps/shared/fallback/SignatureBody.tsx`
- `apps/mobile/features/field-ticket/steps/shared/step-completion-context.test.tsx`
- `apps/mobile/features/field-ticket/steps/shared/step-completion-context.ts`
- `apps/mobile/features/field-ticket/steps/shared/time/TimeRecordBody.tsx`
- `apps/mobile/features/field-ticket/steps/shared/use-step-draft.test.ts`
- `apps/mobile/features/field-ticket/steps/shared/use-step-draft.ts`
- `apps/mobile/features/field-ticket/steps/shared/use-unsaved-changes-guard.test.ts`
- `apps/mobile/features/field-ticket/steps/shared/use-unsaved-changes-guard.ts`
- `apps/mobile/features/field-ticket/steps/sig1/Sig1Body.tsx`
- `apps/mobile/features/field-ticket/steps/sig2/Sig2Body.tsx`
- `apps/mobile/features/field-ticket/ticket-flow.store.test.ts`
- `apps/mobile/features/field-ticket/ticket-flow.store.ts`
- `apps/mobile/features/field-ticket/timers/segment-time-adjust.test.ts`
- `apps/mobile/jest.setup.js`
- `apps/mobile/lib/image-compression.test.ts`
- `apps/mobile/lib/image-compression.ts`
- `apps/mobile/package.json`
- `packages/shared/src/constants/attachments.ts`
- `packages/shared/src/constants/index.ts`
- `pnpm-lock.yaml`
