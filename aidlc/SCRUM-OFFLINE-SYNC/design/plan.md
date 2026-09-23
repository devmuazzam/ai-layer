# SCRUM-OFFLINE-SYNC — review and implementation plan

Status: **ready to build, 2026-09-24 (rev 2).** Written from a code review in a working
session. It is not a spec, and `spec.md` (from the elaborator) is still owed. All three
questions in `intent.md` §12 have been answered:
- the step list moves to `@tcg/shared`;
- a checklist keeps the crew's actual finish time;
- the three new mobile dependencies are approved.

The only default not yet confirmed is resend-then-block on a verification mismatch (§3 U6). File references are as of commit `2b6b0d527` on `main`.

Findings are tagged **[V]** when read directly in the code in that session, and **[A]** when
taken from a subagent audit and not re-read line by line. Re-check an [A] line before
building on it.

---

## 1. What the code does today

### 1.1 Storage

- One zustand store, `features/field-ticket/ticket-flow.store.ts`, persists the whole ticket
  as a single AsyncStorage JSON blob under `ticket:<id>` via `lib/kv.ts`. **[V]**
- `setStepData(key, patch)` merges and persists immediately. It exists, but most step
  bodies never call it. **[V]**
- `kv.setJSON` swallows every error, so the store's `persistFailed` can never become true. **[V]**
- Persist writes are unawaited and unserialized; the store's own comment says Android
  new-arch AsyncStorage can reorder them. **[V]**
- `<key>:draft` entries are never cleared. **[A]**
- `setCapture` at `app/(field)/ticket/step/[key].tsx:663` replaces the step's data, so
  Driving loses `startedAt`/`endedAt`. **[V]** (the replace) / **[A]** (the effect on Driving)
- There is no react-query persistence, and `gcTime` is 5 minutes (`lib/query-client.ts`). An
  app restart while offline cannot load the ticket list, so the step screen renders blank. **[V]**
- Logout does not clear `ticket:*` keys. **[V]**

### 1.2 Per-step state while editing

| Step | Drafted as it changes? | Lost on leaving mid-step |
|---|---|---|
| Pre-Trip / Post-Trip / JSA | yes: answers, reasons, priorities, photo refs → `<key>:draft`, on every keystroke with no debounce | inspection signature (never stored anywhere), emergency banner, in-flight photos **[A]** |
| Left Yard / Arrive Job / Left Job / Arrive Yard (`TimeRecordBody`) | only after RECORD or a ± tap | Left Yard note, ± taps before recording, auto-stamped time (re-stamped on return) **[A]** |
| Sig1 / Sig2 / Signature | identity-photo URI only | signer name, comments, terms, approvals, early sign-off, unavailable + reason, drawn signature. `hydrateSig1/2` already read `draft.signerName` / `draft.comments`, but nothing writes them **[A]** |
| Labor | nothing (no `setStepData`; the `capture` prop is ignored) | bracket/unit picks, comments **[A]** |
| Start Work | lunches and segments drafted, **and** written to the backend per tap | in-progress adjustments; the WTL sheet (name, comment, signature, ID photo) **[A]** |
| Driving | `startedAt` on mount | see `setCapture` above |
| Review | stop/adjust drafted | nothing **[A]** |

### 1.3 Photos

- Every photo uploads **when captured**, as a multipart POST to the API; the API then puts
  it in S3. No presigned URLs are involved. **[V]**
- The file stays in ImagePicker's cache directory, which the OS may purge. **[A]**
- Offline, the upload fails immediately and nothing retries it. **[A]**
- Leaving mid-upload leaves `photoUri` without `photoAttachmentId`, and a deficiency photo
  still renders as attached. **[A]**
- Signature images upload at Next, but a retry re-uploads and orphans the previous file. **[A]**

### 1.4 Saving at Next

| Step keys | Next today |
|---|---|
| leftYard, arriveJob, endWork, leftJob, arriveYard | blocking `PATCH :id/steps`, refused offline **[V]** |
| pretrip, jsa, posttrip | blocking checklist submit + progress ack, refused offline **[V]** |
| sig1, sig2, compliance | blocking signature POST + progress ack, refused offline **[V]** |
| driving, startWork, labor, review | local `completeStep`, fire-and-forget progress ack **[V]**; Labor sends labor entries first **[A]** |

### 1.5 Completing the ticket

- `onSubmit` punches `review` (closes WORK_TIME), then calls `submitTicket`. **[V]**
- The server `submitTicket` (`job-tickets.service.ts:961`) sets `COMPLETE` without checking
  anything, and ignores the `captures` payload entirely. **[V]**
- `useTicketSync` retries only that final submit. **[V]**

### 1.6 Offline hazard in the existing reset protection

- `openTicket` → `dropStaleDraftIfServerReset` wipes the local draft whenever the server
  shows no progress. **[V]**
- The only guard against that, `pendingServerAck`, is in memory and cleared on `openTicket`. **[V]**
- So a crew who completes steps offline, restarts the app, and reopens the ticket once
  signal returns **loses everything**, because the draft is wiped before anything syncs.
  This has to be fixed before offline completion can ship.

### 1.7 Backend replay safety (audit of every write endpoint)

- No endpoint takes an idempotency key. **[A]**
- Every ticket write except the checklist submits and the uploads rejects once the ticket is
  `COMPLETE`, so **everything must sync before `submit`**. **[A]**

| Write | Safe to send twice? | Device timestamp kept? |
|---|---|---|
| `PATCH :id/steps` | yes, overwrites the edge | yes (`at`) |
| `PATCH :id/step-progress` | yes, upsert keeps the first | yes (`completedAt`) |
| checklist `…/submit` | yes, upserts answers | **no**: `markSubmitted` sets `submittedAt: new Date()` (`checklist-assignments.repository.ts:219-225`) **[V]**. Fixed in U7. |
| `POST :id/signatures` | yes, upsert per step key | yes (`capturedAt`) |
| `POST :id/lunch-breaks` | yes, keyed on `breakIndex` | yes |
| `POST :id/buildups` · `POST :id/breakdowns` | yes, update in place | yes |
| `PATCH` buildups / boom-sessions / breakdowns `/:segmentId` with both edges | yes; a client UUID in the path creates the row at that id | yes |
| `POST :id/boom-sessions` | **dup** if the session closed before the replay | yes |
| `POST :id/labor-entries` | yes, update on (ticket, employee) | only if boom times are sent |
| **every attachment upload** | **dup**: new S3 object and row each call | n/a |

Other gaps:
- There is no DELETE for signature or lunch-break attachments.
- Nothing cleans up orphaned attachments.
- Step-gap validation (30 min between neighbouring milestones) runs on replay too, so a time
  recorded offline can be rejected when it finally syncs.

---

## 2. Design

Four ideas carry the whole plan.

1. **Every value lives in the device draft from the moment it is entered.** The backend
   is a copy of the draft.
2. **One idempotent sync function per step**, `syncStep(stepKey)`. It uploads the step's
   pending attachments, sends the step's data to the backend, and acks progress. It is what
   Next calls while online, and what the catch-up calls later. The backend upserts on
   almost every write, so resending a step is safe and always sends its *latest* capture,
   never a stale queued request.
3. **A persisted sync ledger** in the draft. For every step it records
   `{ state: 'synced' | 'pending' | 'failed', lastError?, updatedAt }`, and for every photo
   `{ localId, path, state: 'local' | 'uploaded', attachmentId? }`. It replaces the in-memory
   `pendingServerAck`, and a pending entry blocks every reset-wipe path.
4. **Completion runs a fixed pipeline:** catch up → close Work Time → verify every step
   against the server → resend what differs → verify again → complete. The server refuses
   to complete a ticket with missing data.

### How Next behaves

- **Online:** `syncStep` runs and must succeed before advancing. This is what happens today.
- **Offline:** the step completes on the device. The ledger marks it `pending`, and the
  step card shows a "saved on device" state. The crew moves on.
- **Start Work taps (decision 1):**
  - Online, they are unchanged and still write per tap.
  - Offline, they record on the device instead of hanging. Segments get client UUIDs, so a
    later `PATCH …/:segmentId` with both edges creates exactly that row. The `startWork`
    ledger entry becomes `pending`, and `syncStep('startWork')` replays lunches, build-up,
    boom sessions, breakdown and End Work from the draft.

### When the catch-up runs

- In the background, when the connection returns and the ticket is open, so dispatch sees
  progress as early as possible.
- Always, as the first stage of completion.
- In step order (`n`), stopping at the first failure. A failure shows that step's server
  message on its card, for example a step-gap violation.

---

## 3. Units

Each unit ships on its own. They are listed in dependency order, and all are in this ticket.

Build order: **U0 → U1 → U2 → U3 → U7 → U4 → U5 → U6**, with U8 folded into whichever unit
touches each file.
- U0–U3 are mobile/shared only, and each is safe to release alone.
- U7 goes before U4, because deferred upload is only duplicate-safe once `clientUploadId` exists.
- U7's guard ships **disabled behind a flag** until U6 is in the app, so older builds that
  skip verification are not rejected before the crew has updated.

### U0 — Step catalogue in `@tcg/shared` (shared, mobile)

Today the step list is `RAW_STEPS` in `apps/mobile/data/mock/fixtures.ts:76`, a mock-fixtures
file. The persona filter is `CHECKLIST_ONLY_FOR_OILER_KEYS` in
`apps/mobile/data/compose-ticket-detail.ts:26`. **[V]**

- **Done, 2026-09-24:** `packages/shared/src/constants/ticket-flow-steps.ts`. The names are
  *flow* names on purpose. The API's `TICKET_STEP_KEYS` and mobile's `TicketStepKey`
  already mean the milestone keys (including `endWork`), and both stay as they are. It contains:
  - `TICKET_FLOW_STEP_KEYS`, in flow order: `pretrip, leftYard, driving, arriveJob, sig1, jsa,
    startWork, sig2, leftJob, arriveYard, posttrip, compliance, labor, review`
  - `OILER_ONLY_FLOW_STEP_KEYS`: `pretrip, jsa, posttrip, compliance, labor`
  - `visibleFlowStepKeys(employeeTypeName)`: Oilers get all 14, every other type gets 9
  - `requiredFlowStepKeysForSubmit(employeeTypeName)`: the steps the server guard checks. It
    starts equal to the visible list, minus `review` (the submit itself proves review).
    Kept as its own function so the two lists can diverge later.
- Export it from the `constants` barrel. Only keys, order and persona rules move. Titles,
  icons and step kinds stay in mobile.
- Mobile:
  - `compose-ticket-detail.ts` and the fixtures read order and filtering from shared.
  - A drift test in `compose-ticket-detail.test.ts` pins the `RAW_STEPS` keys to the shared list.
  - `pnpm --filter @tcg/shared build` runs before the mobile typecheck.
- Unit tests in shared cover the Oiler and non-Oiler lists. The existing mobile
  step-order tests must still pass unchanged; that is the proof the move is behaviour-neutral.
- `endWork` is **not** a step key. It is a `PATCH :id/steps` milestone punched inside Start Work.

### U1 — Store foundation (mobile)

- Serialize persist writes through a promise chain, and `await` each write.
- `kv.setJSON` rethrows, so `persistFailed` becomes true when a write fails.
- Add the sync ledger (`sync.steps`, `sync.attachments`) to `TicketDraft` and persist it.
- `openTicket`, `reconcileWithServerTickets` and `dropStaleDraftIfServerReset` never wipe a
  draft whose ledger has a `pending` or `failed` entry. `pendingServerAck` is retired.
- Clear `<key>:draft` when a step completes. `setCapture` merges for Driving.
- Tests: the wipe guard across a restart. This is the §1.6 scenario, and it must be a test.

### U2 — Offline cold start (mobile)

- Persist the react-query cache to AsyncStorage for the ticket list, checklist assignments,
  signatures, labor crew and Start Work segment queries. Raise `gcTime` for them.
- New dependencies (**approved 2026-09-24**): `@tanstack/react-query-persist-client` and
  `@tanstack/query-async-storage-persister`, plus `expo-crypto` for UUIDs. Install `expo-crypto`
  with `npx expo install` so the version matches SDK 54, and pin the TanStack packages to the
  installed `@tanstack/react-query` major.
- Done when: in airplane mode, kill the app, reopen it, and the in-progress ticket opens on
  the right step with its data.

### U3 — Draft every field (mobile)

- Add a `useStepDraft(stepKey)` hook.
  - Writes are debounced about 300 ms and flushed on unmount and on AppState `background`.
  - The draft carries `updatedAt`.
  - Restore order: for an incomplete step, draft then server. For a reopened completed step,
    the draft if it is newer than the capture; today the capture always wins.
- Wire it into each body:
  - `TimeRecordBody`: note, manual time, auto-stamped time
  - `Sig1Body`, `Sig2Body`, `SignatureBody`: every field in §1.2
  - `ChecklistEngine`: the signature and the emergency flag
  - `LaborBody`: entries and comments
  - `lunch-breaks.tsx`: the WTL sheet
  - `StartWorkBody`: in-progress adjustments
- Drawn signatures: rasterize to a PNG in `documentDirectory` when a stroke ends, and store
  the path. On return, show that image with "Sign again". Pad strokes are not serialized.

### U4 — Photos stored on the device first (mobile)

- `usePhotoCapture` gains a deferred mode, built on its unused `snapOnly`.
  - On capture, copy the file to `documentDirectory/tickets/<ticketId>/<localId>.jpg` and
    add it to the ledger as `local`, shown as a single green tick (`SyncStatusBadge` `local`).
  - Nothing is uploaded at capture.
- `flushStepAttachments(stepKey)` runs first inside `syncStep`.
  - It uploads `local` entries one at a time, and a `localId` is uploaded at most once.
  - Each resulting `attachmentId` goes into the ledger and the capture, then the badge shows
    the uploaded state.
  - A retry skips entries that are already `uploaded`, which removes today's duplicate
    signature uploads.
- Removing a photo:
  - Still `local`: delete the file only.
  - Already `uploaded`: call the DELETE endpoint (U7 adds the missing ones).
- Remove the delete-if-unmounted logic in `ChecklistEngine` and `deficiency-panel`.
  Validation accepts a `local` photo.
- Covered: checklist item and vehicle photos, identity photos, signature images, and the WTL
  signature and ID photo.
- Delete the ticket's local files after `submit` succeeds.

### U5 — Offline completion and the sync engine (mobile)

- `features/field-ticket/sync/step-sync.ts` holds `syncStep(stepKey, ctx)`. It is built from
  the save logic now inline in `step/[key].tsx`: `saveTrackedStep`, `submitChecklistForStep`,
  `submitSignatureForStep`, and Labor's `submitAllEntries`, plus the Start Work replay.
- `onComplete`:
  - Online: `syncStep`, then advance. The UX is unchanged.
  - Offline: `completeStep` locally, and the ledger entry becomes `pending`.
- `drainPendingSteps()` runs in the background when the connection returns, and as the first
  stage of completion.
- Start Work offline path:
  - Gate each per-tap call on `useOnline`. This fixes `segmentBusyRef` staying stuck.
  - Mint client UUID segment ids.
  - Remove the misleading comment at `StartWorkBody.tsx:723` ("useTicketSync re-sends").
- Checklists: each checklist capture records `completedAt` (device time, via `timelineNow`)
  when the crew taps Next, and every sync sends it, including a catch-up hours later.
- Labor: when there is no local boom window, *nothing* is sent today and the step still
  completes (`LaborBody.tsx:397-453`) **[A]**. With this change it stays `pending` until it
  can actually be sent.
- Offline behaviour of the `review` punch and `submit`: the existing `pendingSync` plus
  `useTicketSync`, re-pointed at the U6 pipeline.

### U6 — Pre-submit verification (mobile)

- `features/field-ticket/sync/submit-pipeline.ts` runs in `onSubmit` and in `useTicketSync`:
  1. `drainPendingSteps()`, then `flushStepAttachments` for every step.
  2. Punch `review`, which closes WORK_TIME. This is the "work time saved in DB" point in the request.
  3. Fetch the server snapshot.
     - Refetch the ticket for `timeTracking` and `completedStepKeys`.
     - `GET` checklists/pretrip, jsa, posttrip.
     - `GET` signatures, lunch-breaks, buildups, boom-sessions, breakdowns, labor-entry.
  4. For each step the persona has, run a pure comparator
     `(localCapture, snapshot) → ok | missing | mismatch`. See §4.
  5. For every `missing` or `mismatch`, run `syncStep` again, then repeat steps 3–4 once.
  6. If everything is `ok`, call `submit`. If anything is still wrong, block and show a
     sheet listing each affected step, with the server's reason and an "Open step" link.
- The whole pipeline runs under the existing `ScreenTransitionLoader`, with the message
  "Verifying ticket data…".

### U7 — Backend (api)

- `submitTicket` guard.
  - Before setting `COMPLETE`, check that every required step exists server-side:
    - the milestone timestamps
    - `completedStepKeys`
    - signature rows
    - submitted checklists (Oiler only)
    - the labor entry
    - WORK_TIME closed
  - Otherwise return a 400 that lists what is missing.
- **Checklist finish time.**
  - The `pretrip`/`jsa`/`posttrip` submit DTOs gain an optional `completedAt` (ISO), and
    `markSubmitted` stores it as `submittedAt`. It falls back to now() only when absent, so
    older app builds keep working.
  - The API rejects a `completedAt` that is in the future, or before the ticket's `leftYard`.
  - **A replayed submit must not move `submittedAt` later**: once it is set, only a
    `completedAt` from the device overwrites it. The column already exists; no migration
    is needed for this item.
- The submit guard reads `requiredFlowStepKeysForSubmit` from `@tcg/shared` (U0), with the
  persona taken from the ticket employee's type.
- Make the COMPLETE transition conditional (`WHERE status <> COMPLETE`), so two concurrent
  submits cannot both log and notify.
- Idempotent attachment upload: accept an optional `clientUploadId` and return the existing
  attachment on a repeat. This needs a `client_upload_id` column with a per-tenant unique
  index, and so a migration.
- Add DELETE for signature and lunch-break attachments.

### U8 — Defects found in review (fold into the unit that touches the file)

- Sig2 rehydrate turns a null approval into `true` (`Sig2Body.tsx:119-121`). This implies
  attestations the customer never gave. **[A]**
- `{0,0}` GPS is sent when there is no fix (sig1, sig2, compliance, and `signature-rehydrate.ts`). **[A]**
- `TimeRecordBody` treats "a capture exists" as "completed". So adjusting Left Job or Arrive
  Yard after RECORD, but before Next, writes straight to the backend. **[A]**
- The `use-signature-time-adjust.ts:28-30` comment disagrees with its code. **[A]**
- Labor copies one comment onto every teammate's entry. **[A]** The intent is unconfirmed,
  so do not change it without an answer.

---

## 4. Comparators (U6)

| Step | "ok" means |
|---|---|
| leftYard, arriveJob, endWork, leftJob, arriveYard | server timestamp equals the device `at`, to the minute (the server truncates); leftYard note matches |
| driving, startWork, labor, review | key present in `completedStepKeys` |
| startWork segments | every device lunch / WTL / build-up / boom / breakdown row exists server-side with equal edges |
| pretrip, jsa, posttrip | every device answer (result, deficiency reason, priority, `photoAttachmentId`) matches the server answer, **and** the server `submittedAt` equals the device `completedAt` (to the minute) |
| sig1, sig2, compliance | a signature row exists; attachment ids, signer name and approvals match |
| labor | the entry exists for self and each teammate, with the bracket and modifier the device sent |
| review | WORK_TIME has an `endedAt` equal to the review instant |

---

## 5. Risks

- **Step-gap rejects on catch-up.** Times entered offline were never checked against the
  server's 30-minute rule. The failure surfaces on that step's card, and the crew fixes the
  time there.
- **AsyncStorage size.** Photos stay out of the blob; only file paths go in. The Android
  per-row cursor limit is about 2 MB.
- **Refresh-token expiry after long offline.** Drafts survive a re-login (logout does not
  clear `ticket:*`), but drafts are not scoped per user. That is acceptable on a
  single-user device; say so in the spec.
- **Shared-package ripple.** U0 changes an `@tcg/shared` export that mobile compiles
  against. Run `tcg-contract-tracer` on it. Web does not read ticket steps today, but check
  anyway.
- **Lost upload response.** Duplicate attachments are possible until U7's `clientUploadId`
  ships, so U4 should ship after U7, or together with it.
