---
title: "UAT register — the 100 DONE rows re-verified against platform main at 72d6cc4c9 (19 September 2026)"
source: internal verification — four read-only analyst passes over the platform repo, consolidated by Syed Haris, 2026-09-19; checks every DONE row of register-2026-09-18.md
migrated: 2026-09-19
updated: 2026-09-19
status: reference
conflicts_with: []
jira: []
tags: [module/all, kind/verification, uat, as-built]
---

# The 100 DONE rows, re-verified — 2026-09-19

The register ([register-2026-09-18.md](register-2026-09-18.md)) marks 100 rows DONE, checked
against `origin/main` at `f800a3972` on 2026-09-18. This page re-checks each of them against
platform `main` at **`72d6cc4c9`** (2026-09-19), eight commits later. Row numbers are the order
of the register's *Done* table.

> **Describes code, never a source for a spec.** A VERIFIED verdict means the UAT complaint no
> longer reproduces in the code as read; it does not mean the behaviour is the product's
> intent. Nothing on this page was changed on Confluence — the register is a migrated snapshot
> and its two wrong rows are wrong there too.

## Summary

| Verdict | Rows |
| --- | --- |
| **VERIFIED** | 94 |
| **PARTIAL** — built, but the row overstates | 2 — #4, #66 |
| **NOT VERIFIED** — the claim is wrong | 2 — #36, #62 |
| **CANNOT VERIFY STATICALLY** | 1 — #97; plus the human-confirmation half of #93 and #95 |
| Weakly checked | #25 — commit confirmed on main, diff not read |

**Nothing moved between `f800a3972` and `72d6cc4c9`.** The eight commits in the window are
mobile field-ticket timing and signature work, Crashlytics, and a Firebase-prebuild guard. No
caveat the register recorded on 2026-09-18 has been resolved by any of them.

## The two rows that are wrong

**#62 — "One person cannot be assigned to two jobs."** The register says *"Overlaps are refused
server-side"* and cites `das-allocations.service.ts:290-299`. That code exists, but its own
comment (line 288) reads *"must not fill two slots in one shift **on this sub-job**"* — it is
the same-sub-job stacking guard, not a cross-job one. For a normal allocation save, the
cross-job path (`upsertAllocation` → `resolveOrClearPriorCommitments`, lines 305–333 / 882–925)
**does not refuse**: `clearPriorAllocationForReassignment` (line 937) silently deletes the
person's allocation on the other job and moves them. It throws only when the other job has
already loaded them out from the yard (`LOADED_OUT` / `AVAILABLE_FOR_LOADOUT`) or the ticket is
payroll-locked. The invariant holds — nobody ends the save on two jobs — but the dispatcher
gets no warning and Job A quietly loses the person. Only COPY-origin saves
(`findCopyAvailabilityConflict`, ~line 267) hard-refuse. This matters against
[../decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md](../decisions/2026-09-15-fix-15-sep-das-and-quotations-as-built.md)
§5, which describes the same-sub-job rule only and leaves cross-job double-booking unchanged;
the register's wording claims more than either the decision or the code.

**#36 — "Copy assets from shift one" ("both on by default").**
`apps/web/src/features/das/middle-section/jobs/hooks/use-sub-job-allocation-controller.ts:95-96`:
`sameAssets` defaults `true`, `sameResources` defaults **`false`**. "Same Assets of Shift 1" is
on; "Same Employees of Shift 1" is off. No hydration effect overrides this; only the two toggle
handlers (lines 174/180) call the setters. The checkbox itself is shipped
(`job-allocation-sections.tsx:792`); the default-state claim is wrong.

## The two partials

**#4 — Push notification delivery, server side.** The server half is fully built:
`notification-catalog.ts` has 16 `'PUSH'` entries, `device-tokens.controller.ts` and its DTO
exist, `channels/fcm.channel.ts` exists. The caveat is still open: in-window commit
`59416101c` (*"resolve native prebuild missing firebase configs"*) only lets the Expo prebuild
degrade gracefully when the credential files are absent. `apps/mobile/GoogleService-Info.plist`
and `apps/mobile/google-services.json` **do not exist** on main. Anyone reading that commit as
"push fixed" would be wrong.

**#66 — Oiler warning updated.** Fully built and verified through commit `198c49a11` (message,
`craft-code-picker-modal.tsx`, `secondary-craft-picker-dialog.tsx`, `parse-craft-mismatch.ts`
all match). The second cited commit **`5788400ee` does not exist in the repository** —
`git rev-parse --verify` fails and `git log --all` has no near match. A citation defect, not a
functionality gap.

## Citation defects — feature real, pointer wrong

| # | What is off |
| --- | --- |
| 30 | `054840d01` is a 14-file "Updated design of schedule tab" refactor (6 Jul), not the scoped fix; the behaviour is present at `use-schedule.ts:217-235` |
| 35 | The quoted dialog text (*"The Oiler slot for `<name>` must have an Oiler craft code"*) comes from **`198c49a11`** (2026-09-15), not the cited `43d533a20`, which only added the name to a secondary line |
| 42 | `Sig1Body.tsx:727-746` is the `SignatureCaptureField` block; the two controls are at ~750–768 |
| 43 | `Sig1Body.tsx:406-413` is the `TERMS_CLAUSES` ScrollView; the cue text is at line 422, the checkbox at ~265 |
| 51 | `sos-overlay.tsx:96` is generic modal markup; the button is at lines 116–125 and the wiring at `sos-provider.tsx:91` |
| 5 | The web file cited alongside is 79 lines long; the citation resolves to the API file (`das-allocations.service.ts:658`) |

## Caveats confirmed still true on main

| # | Caveat | Where |
| --- | --- | --- |
| 33 | `emitSubJobsChanged` is a bare Socket.IO broadcast to every connected client, no tenant scoping | `das.gateway.ts:99-104` |
| 50 | `EXPO_PUBLIC_ENABLE_CHECKLIST_AUTOFILL: "true"` on the base EAS profile, inherited by every shipped build | `apps/mobile/eas.json` |
| 55 | The subtotal strip still renders on the Resources tab | `detail-resources-tab.tsx`, `resources-table-content.tsx` |
| 72 | Rigger-at-$0 fix is display-only; the commit says so itself. (The later `765fffc8c` / PR #541 half is recorded in [../decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md](../decisions/2026-09-12-optional-catalog-association-without-price-is-not-a-das-slot.md)) | `c6716980d` |
| 75 | `use-notification-deep-links.ts` is implemented and **never mounted** — the only reference is its own definition | `apps/mobile/hooks/` |
| 76 | 19 models carry `archivedAt`; **56 `@Delete(` routes remain hard deletes**, including `departments.service.ts:490` `removeRole` | `apps/api/src/presentation` |
| 88 | `"The Crane Guys, LLC"` still hardcoded | `job-info-card.tsx:23` |
| 90 | The chrome-autofill follow-ups (`cc6f0b79b`, `ce2388fdb`, `a0ab43316`, `d3a370da6`, `0504bf15a`) are on unmerged branches `fix/remove-chrome-suggestions` / `backup/chrome-suggestions-latest` — not ancestors of main | — |

## Rows that are decisions, not fixes

#91–#97 record a product or business call rather than a code change. Every checkable fact in
them held (e.g. #91: *"Travel – Job Level"* never existed anywhere in git history; #94: the
"Customer Packet" is a static PDF at `apps/api/src/assets/quotation-forms/`, the quotation PDF
is generated in code). But #93 (*"check the screen resolution with Akif"*), #95 (departments,
roles, crafts and employees "fit together") and #97 (Resources colour and spacing, no design
reference ever recorded) each have a human-confirmation half no repo state can settle. They
should not be read with the same evidentiary weight as the commit-cited rows.

## All 100 rows

Evidence is the command or file:line that proves the verdict. INFERRED marks a conclusion
reasoned from reads rather than a single reproducible check.

| # | Item | Verdict | Evidence |
| --- | --- | --- | --- |
| 1 | Async (non-blocking) photo upload | VERIFIED (INFERRED) | `camera-sim.tsx:128-141` fires `onSnapped` synchronously; `ChecklistEngine.tsx:1020-1027` closes the modal before `await capturePhoto`; Complete gated on `anyPhotoUploading` (:592/:708) |
| 2 | Photo capture no longer stalls Pre-Inspection | VERIFIED | `321ca1955` on main; touches `camera-sim.tsx`, `use-photo-capture.ts`, `photo-thumb.tsx` (Retry at :114-119). "Slow on device" caveat unresolvable statically |
| 3 | Uploading a PNG in Incident Reporting | VERIFIED | `incident-sheet.tsx:84` → `partitionUploads`; `ticket-attachment-file.ts:40-46` rejects on size only; `DocumentPicker` has no type filter |
| 4 | Push notification delivery — server side | **PARTIAL** | Server verified (16 `'PUSH'` entries, token controller, FCM channel); Firebase config files absent on main; `59416101c` only guards the prebuild |
| 5 | Holdover functionality | VERIFIED | `das-allocations.service.ts:658` `applyCarryForwardAllocations` (manual copy); `subsistenceHoldover` `schema.prisma:3432`, `isHoldover` :3845; "On Hold" in `job-status-badge.tsx` |
| 6 | Copy Allocation stays available after ticket sent | VERIFIED | `job-list-item-expanded.tsx:76-84` whitelists `TICKET_SENT` and skips the save gate when sent |
| 7 | Build-Up Complete and Start Work added | VERIFIED | `ea50fff24`, `5c45ee9a8` on main; `StartWorkBody.tsx:970` `completeLabel="Complete Build Up"`; `work-time-banner.tsx:42` |
| 8 | Cancel Job under the three-dot menu | VERIFIED | `job-context-menu.tsx:95` `das-job-context-menu-cancel`; wired `job-list-item.tsx:198` |
| 9 | Weekend jobs show in DAS | VERIFIED | `das.repository.ts:702` exact-date query, no day-of-week exclusion; no `isWeekend`/`getDay()` gating in `features/das` |
| 10 | Billing code rate can never be zero | VERIFIED | `ba99841ee` on main; `@IsPositive()` in `create-billing-code.dto.ts:59`, `add-price-listing-item.dto.ts:31`, `create-price-listing.dto.ts:42,72` |
| 11 | Serial Number and VIN are separate fields | VERIFIED | `1bc69602c`; `schema.prisma:824-825` on `Asset`; combined `serialNumberVin` survives on `UnitVehicleRegistration` :1144 and `VendorAsset` :2312 |
| 12 | Unit Code is the unique identifier | VERIFIED | migration `20260909010000_unique_active_and_archived_non_name` partial unique indexes; `Asset.name` :798 "deliberately not unique" |
| 13 | Job Walk tab says "Coming Soon" | VERIFIED | `621fb47cd`; `create-quotation-wizard-nav.tsx:20-35` — 5 create steps, 6 edit steps |
| 14 | Print view: Internal Use section removed | VERIFIED | `bbee817da` deletes `print-quotation-document.footer.tsx`; zero "Internal Use" hits |
| 15 | Print view: Adjustment column removed | VERIFIED | `print-quotation-document.body.tsx:28-32` headers; adjustments as foot rows via `print-quotation.helpers.ts:118` |
| 16 | Mark a quotation as Won without sending it | VERIFIED | `quotations.service.ts:2051` `markWon`, `wonEligible` includes `DRAFT` |
| 17 | Margins column removed from Resources | VERIFIED | `resources-table-content.tsx:190-206`; zero "margin" hits |
| 18 | Warning when leaving unsaved quotation resources | VERIFIED | `use-unsaved-changes-guard.ts` (push/back/popstate/anchor/beforeunload); `create-quotation-form-model.ts:81-90` includes resources in dirty check |
| 19 | Oiler allocation carries across days | VERIFIED (INFERRED) | Same generic `applyCarryForwardAllocations` path; no oiler special-casing found |
| 20 | Quotation logs in the Activity Log tab | VERIFIED | `4955e3368`; 15 `quotationActivityLogger` call sites in `quotations.service.ts` |
| 21 | Shared Marked-as-Signed / Marked-as-Won popup | VERIFIED | `088564a97` adds `mark-signed.dto.ts`, edits `mark-won.dto.ts` and both controllers |
| 22 | DocuSign dates used properly | VERIFIED | `quotation-signatures.service.ts:990-1055` maps the 5 DocuSign dates; webhook forwards all 5 (`docusign-webhook.controller.ts:80-88`) |
| 23 | Customer PO shown and saved on the quotation | VERIFIED | `547648dae`; `Quotation.customerPo`; DocuSign backfill `quotation-signatures.service.ts:3262-3264` |
| 24 | Job Project has a Customer PO link | VERIFIED | `job-quick-access-card.tsx:47-53`; two-way sync `jobs.service.ts:327-365` |
| 25 | Job site auto-selected after Create | VERIFIED (weak) | `41ad31309` on main, message consistent; diff not read |
| 26 | Job Site dropdown empty until customer selected | VERIFIED | `main-tab.tsx:307-316` `disabled={!hasCustomer}`; clearing customer clears `jobSiteId` (:159/:161) |
| 27 | Clicking Leave actually leaves the page | VERIFIED | `0a259f5d2`, `770efd2a2` on main |
| 28 | Yellow warning colour in Tools & Rigging | VERIFIED | `ff41b05e4` swaps undefined `--color-utility-warning-*` for `--color-fg/bg-warning-primary`; "12 other files" caveat is in the commit body |
| 29 | Schedule times not pre-filled when editing | VERIFIED | `969b61d27`; `schedule-bulk-apply.tsx:24-26` all `useState('')` |
| 30 | Last date added becomes final schedule date | VERIFIED (citation loose) | `use-schedule.ts:217-235`; cited sha is a broad refactor |
| 31 | Start/End Date taken from selected schedule | VERIFIED | `eb199fc2b`; `resolve-job-schedule-display.ts` + 95-line test |
| 32 | Apply Times to Multiple Days closed by default | VERIFIED | `schedule-bulk-apply.tsx:24` `useState(false)`; component still renders |
| 33 | Removing a shift updates DAS without refresh | VERIFIED (caveat holds) | `jobs.service.ts:1419` → `das.gateway.ts:99-104` bare broadcast, no tenant room |
| 34 | Previous Night logic | VERIFIED | `e5e792adb`; `das.repository.ts` `getPreviousNightEmployeeIds` (shift 2 on date−1) |
| 35 | Oiler name visible in Role Mismatch dialog | VERIFIED (citation incomplete) | `parse-craft-mismatch.ts:47-58`; text added by uncited `198c49a11` |
| 36 | Copy assets from shift one | **NOT VERIFIED** | `use-sub-job-allocation-controller.ts:95-96` — employees toggle defaults off |
| 37 | Permits and Plans in ticket details on phone | VERIFIED (INFERRED for "every step") | `job-artifacts-section.tsx:163+`; `ticket-details.tsx:101`; `StepBodyShell.tsx:170` shared by all steps |
| 38 | Log Deficiency and Continue removed from JSA | VERIFIED | `7054c4531` deletes the button and `saveDef`; zero `<Button` in `JsaBody.tsx` |
| 39 | People remain available under a later shift | VERIFIED | `das.repository.ts:334-341`, `:809-820` — date-equality only, no time comparison |
| 40 | Live ETA and distance on driving screen | VERIFIED | `route-distance.ts` → `routes.googleapis.com/directions/v2:computeRoutes`; only `distanceMeters: 0` is the explicit unavailable fallback |
| 41 | Image preview with retake and delete | VERIFIED | `photo-preview-modal.tsx:23-30,86,97` |
| 42 | Customer not available / leaving before crew | VERIFIED (citation off) | `Sig1Body.tsx` ~750–768 |
| 43 | T&C checkbox and scroll cue | VERIFIED (citation off) | `Sig1Body.tsx:422` cue; checkbox ~:265 |
| 44 | JSA checklist is a flat list | VERIFIED | `58b0cbc00`; `JsaBody.tsx` `hazardItems.map`, OK/Issue/NA pills |
| 45 | Identity photo is live | VERIFIED | `use-photo-capture.ts:88` `launchCameraAsync`; zero gallery-picker hits; `eas.json` `EXPO_PUBLIC_CAMERA_MODE: "real"` |
| 46 | Ticket visible in Weekly Payroll | VERIFIED | `74b3ae607` (21 files, `deriveTicketProgress`, `payroll-overlay-entries.tsx`) |
| 47 | No logout when app is closed | VERIFIED | `token-storage.ts:5,11-25` `expo-secure-store` |
| 48 | Start Work retained after app closes | VERIFIED | `shift-clock.ts:9,17-31,54-61` persisted `startedAt`, `hydrate()`, `syncFromTickets` |
| 49 | Photos can be removed after adding | VERIFIED | `ChecklistEngine.tsx:887-899` `handleRemove` → `removePhoto(attachmentId)`; control at :967+ |
| 50 | Nothing pre-selected as OK — the code | VERIFIED (caveat holds) | `checklist-autofill.ts` defaults off; `eas.json` base profile turns it on for every build |
| 51 | Report Incident moved into Emergency SOS | VERIFIED (citation off) | `sos-provider.tsx:91`; `sos-overlay.tsx:116-125`; mounted in `persona-shell.tsx` |
| 52 | Build-Up to Break Time counts as Boom | VERIFIED | `a7961b6b9`; `field-ticket.mapper.ts:175-176` sums build-up + boom + breakdown. (Wording hazard: "Break Time" = breakdown — see [../payroll/gaps.md](../payroll/gaps.md) → *Boom window as built*) |
| 53 | Boom Time Running step removed | VERIFIED (commit) / INFERRED (UI) | `86ab089f8` touches time-entries repo, breakdowns, work-segments, `resume-step.ts` |
| 54 | Back button alongside Next | VERIFIED (broader than claimed) | `b928ec388` also covers employee, vendor and yard forms |
| 55 | Running total removed from Quotation and Edit Customer | VERIFIED (caveat holds) | `a8df9b398`; subtotal strip still in two Resources files |
| 56 | Customer PO attachment error resolved | VERIFIED | `547648dae` |
| 57 | Tools & Rigging allows over-max with a warning | VERIFIED | `905c5d566` soft-validate with inline hover warning |
| 58 | DAS font size scales automatically | VERIFIED | `9403d77f6` rem-based ultrawide scaling |
| 59 | Pre-Job Checklist links open in a new tab | VERIFIED | `a1b86ac0d` forces `window.open` |
| 60 | Permits and Plan card UI updated | VERIFIED | `255d5a8ec`, `44dab19cc` |
| 61 | Ticket date visible on the card | VERIFIED | `dfe02df8c`; `shift-label.ts:61-68` date first in the label (mobile) |
| 62 | One person cannot be assigned to two jobs | **NOT VERIFIED** | Cited guard is same-sub-job only; cross-job save silently reassigns (see above) |
| 63 | Pay Rate DB and OT are view-only | VERIFIED | `payroll-advanced-fields.tsx:167` and :181 `readOnly`, not registered |
| 64 | Loadout unchecked by default | VERIFIED | `bfdc9c3a5` |
| 65 | Cancel Changes in DAS Jobs | VERIFIED | `524550d3c`; "Cancel Allocations" at `job-list-item-expanded.tsx:72` |
| 66 | Oiler warning updated | **PARTIAL** | `198c49a11` verified; cited `5788400ee` does not exist |
| 67 | Add Job Site popup has no Status selection | VERIFIED | `f121dd7bf` |
| 68 | Permits not shown green unless approved | VERIFIED | `build-pre-checklist-items.ts:10` `TRACKABLE_APPROVED = 'APPROVED'` |
| 69 | Copy Allocation scrollbar and day counts | VERIFIED | `copy-allocation-modal.tsx:105` `overflow-y-auto`; `target-selector.tsx:76` day counter |
| 70 | Weekend and Sunday rows visible in Edit Schedule | VERIFIED | `schedule-date-range.ts:54` symmetric Sat/Sun gating |
| 71 | Pre-job warning and sticky Edit Schedule header | VERIFIED | `job-schedule-tab.tsx:157` `sticky top-0 z-20` |
| 72 | Removed rigger no longer shows as $0 | VERIFIED (caveat holds) | `c6716980d`, display-only by its own message |
| 73 | Start Work does not show on a past ticket | VERIFIED | `ticket-card.tsx:471`; tests `ticket-card.test.tsx:353,363,488` |
| 74 | Send Ticket becomes View Progress | VERIFIED | `job-list-item-parts.tsx:60` `HAS_SENT_TICKETS`; text at :99/:112; web only |
| 75 | Notification opens the ticket steps | VERIFIED (caveat holds) | `use-notification-deep-links.ts` implemented, never mounted |
| 76 | Departments editable, roles, soft delete, checklist enum | VERIFIED (caveat holds) | 19 `archivedAt` models; 56 `@Delete(` routes; `AssetChecklistType` `schema.prisma:60` |
| 77 | Surcharge shows on hover and toggles off | VERIFIED | `be1f02310`, `ae695f004`; `resource-row.amount-cell.tsx:129` |
| 78 | View & Sign Quote link fixed | VERIFIED | `12b32d3bd` (envelope vs quoteNo cross-tenant lookup) |
| 79 | Schedule Start and End Date auto-populated | VERIFIED | `schedule-initial-state.ts` `resolveInitialState()` |
| 80 | Yard loadout phases | VERIFIED | `10feb705b`; `SubJobLoadoutPhase` 4 values `schema.prisma:1715`; header renders Phase 1/2/3 |
| 81 | Start Loadout does not auto-check, supports photos | VERIFIED | `bfdc9c3a5`; `das-loadout-save-photos.spec.ts` |
| 82 | Planning tracker flow follows agreed states | VERIFIED | `TrackableStatus` `schema.prisma:3972`; `canAdvanceTrackableStatus` in plans and permits services |
| 83 | Quotation states delivered | VERIFIED | `1715173d5`; `QuotationStatus` 9 states, no "Upload"; uploads live in `attachments-tab.tsx` |
| 84 | Created / updated timestamps on all tables | VERIFIED | 126 of 126 models carry `createdAt` and `updatedAt` |
| 85 | Cap discount percentage at 100 in the UI | VERIFIED | `percentage-input.ts:59` `DISCOUNT_PERCENT_RANGE` max 100; `sanitizePercentageInput` rejects above max |
| 86 | Remove billing code type across the app | VERIFIED | `71ccc21aa`; zero `BillingCodeType` hits; `typeCategory` picker deliberately kept |
| 87 | Saving a customer no longer triggers the leave modal | VERIFIED | `ba042a4bf` |
| 88 | Company picker shows the current tenant | VERIFIED (caveat holds) | `quote-info-section.tsx:133` bound to tenant; `job-info-card.tsx:23` still hardcoded |
| 89 | Photo compression on capture | VERIFIED | `use-photo-capture.ts:89` `quality: 0.7` |
| 90 | Chrome autofill suppressed | VERIFIED (caveat open) | `d542dba42` on main; five follow-ups on unmerged branches |
| 91 | Heading "Permits" not "Travel – Job Level" | VERIFIED | Phrase never existed in git history; "Permits" in `sidebar-nav-groups.tsx:231` |
| 92 | First DAS tab should be Assets | VERIFIED | No tab component in `features/das`; `left-panel.tsx` renders `AssetsPanel` first |
| 93 | DAS screen resolution | VERIFIED (code) / CANNOT VERIFY (Akif confirmation) | PR #606 `19c2e0b76`; `root-font-scale.ts` |
| 94 | Quote header and footer like the Customer Packet | VERIFIED | "New Customer Packet.pdf" is a static asset; `quotation-pdf.service.ts` generates in code |
| 95 | Departments, roles, crafts and employees fit together | VERIFIED (schema) / CANNOT VERIFY (business fit) | Models and links present in `schema.prisma`; TCG never confirmed |
| 96 | Add New Item on hover in Resources | VERIFIED | `resource-row.add-child-insert.tsx` hover-insert slot; no design file to compare |
| 97 | Resources colour and spacing | CANNOT VERIFY STATICALLY | No file, commit or design reference cited or existing |
| 98 | Remove Quick Access on jobs | VERIFIED | `d30f90eaa` removes the POs/Tool/Storage placeholders; card keeps Quotation, Price List, Customer PO |
| 99 | Subcategory tab order | VERIFIED | `create-sub-category-view.tsx:24`; `sub-category-show-view.tsx:31` |
| 100 | Purchase Order heading on Upload Approved Permit popup | VERIFIED | `artifact-po-widget.tsx:171-179` heading and conditional asterisk |

## Method

Four independent read-only passes of 25 rows each, then consolidated. For every cited commit:
`git merge-base --is-ancestor <sha> main` (or `git branch --contains`) and `git show --stat`.
For every cited file:line: the file read at that line on `72d6cc4c9`. For every claim: a grep of
the feature beyond the cited spot. For every caveat: `git log f800a3972..main` checked for a
resolving change. Rows #36 and #62 were re-confirmed by a second grep after consolidation.
