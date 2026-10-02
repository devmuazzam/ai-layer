# Offline ticket sync — UI isolation review and fix plan

Reviewed 2026-10-02 against application commit `2e3fd102f`.
Status: proposed implementation; application code has not been changed.

## Requirement and source

The user reported that reconnecting after offline ticket work dims the entire mobile
screen and prevents interaction. Automatic synchronization must run independently of
foreground loading, while the employee can navigate, scroll, and continue entering data.
The working notification implementation is the reference for request isolation.

This clarifies the existing nonblocking-sync requirement in
`../intent.md`, section 3, the 2026-09-25 offline-submit revision. The field-ops vault
index and conflict stub were read; this plan does not choose between the conflicting
field-ops FRDs or change ticket business rules. This ticket folder currently has intent
and design plans, but no `spec.md` or `units.md`.

## Findings

Paths below are relative to `apps/mobile/`.

| Finding | Evidence | Effect |
| --- | --- | --- |
| **Direct cause: sync HTTP requests drive the global loader.** | `lib/base-api.ts:49–89`; `data/services/tickets/tickets.http.ts:36–72`; checklist, signature, labor, lunch, segment, breakdown and submit HTTP adapters | Unmarked requests increment the foreground loader counter, although their caller is a background task. |
| The loader deliberately dims the screen and captures touches. | `providers/global-loader-provider.tsx:13–14,64–98`; `components/ui/global-loader-overlay.tsx:46–65` | A request lasting over 200 ms can show the scrim, which remains visible for at least 400 ms. A sequence of sync requests can sustain or repeatedly display it. This explains the reported interaction freeze without requiring a blocked JS thread. |
| Notifications already use the appropriate exclusion. | `data/services/notifications/notifications.http.ts:91–106` | Polls pass `backgroundRequest: true`; the request and response interceptors both exclude them from the loader counter. |
| Cache reconciliation can reintroduce foreground loading. | `features/field-ticket/sync/background-sync.ts:355–357`; `sync/use-ticket-outbox.ts:32–34`; `data/hooks/query-keys.ts`; related HTTP GET adapters | Broad `['tickets']` invalidation includes signatures, lunches, segments, labor, comments, attachments and other ticket queries. Checklist invalidation refetches unmarked GETs too. Making only sync PATCH/POST requests silent would leave this path unfixed. |
| Reconnect uses a foreground submission path as well as the scanner. | `app/(field)/ticket/_layout.tsx:13–26`; `features/field-ticket/use-ticket-sync.ts:28–45`; `ticket-flow.store.ts:835–870` | The hook calls `submitTicket(true, submit.mutateAsync)`, changing shared `submitState` to `submitting`. Review renders that state as saving. The hook's precondition only drains steps; it does not run the scanner's complete snapshot-verification sequence. |
| Existing concurrency protection does not cover the whole transaction. | `sync/background-sync.ts:290–327,375–394`; `sync/drain.ts` | Scanner calls are serialized and open-ticket step drains share a slot. Attachment upload, closed-draft draining, verification and final submit are not all owned by that same per-ticket slot; the independent submit hook can overlap them. |
| An interactive UI requires protecting concurrent edits. | `sync/background-sync.ts:43–60,71–126`; `ticket-flow.store.ts:442–459,713–723` | Attachment sync reads a whole draft, awaits upload, patches the live store, then writes the older draft snapshot. An edit saved during that wait can be overwritten on disk. Serialized storage operations alone do not merge stale snapshots. Closed-draft draining also needs protection if the employee opens that ticket mid-run. |
| Thread responsiveness has not been demonstrated. | `sync/background-sync.ts:38,370`; `sync/drain.ts:onePass`; `lib/kv.ts` | Some scanner loops yield, but the open-ticket operation loop does not explicitly yield between operations. JSON parsing/serialization and file operations still have synchronous portions. The existing “zero UI jank” comment is not a measured guarantee. |

### Controlled reproduction

A Node harness transpiled the actual Axios interceptor and actual ticket/notification
HTTP adapters, substituting token storage, loader reporting, schema parsing and an Axios
adapter returning success. No network requests were made.

- `ticketsHttp.recordStepProgress(...)`: neither exclusion flag was present; loader
  activity was `[+1, -1]`.
- `notificationsHttp.unreadCount()`: `backgroundRequest: true`; no loader activity.
- A PATCH with `backgroundRequest: true`: no loader activity.

This demonstrates the request-classification defect. It does not measure device frame
times or prove that every cause of jank has been identified.

## Implementation units, in order

### 1. Carry background intent through the complete sync request chain

Add a small, typed, optional request-options argument to the relevant service interfaces
and HTTP implementations. It carries `backgroundRequest` to Axios; request options must
never be added to API payloads or persisted step operations. Preserve existing defaults
for direct foreground mutations. Mock implementations must remain type compatible.

Thread background options through:

- `scanAndSyncTickets` / `syncSingleDraft`, attachment uploader and cleanup requests.
- Both drain paths, `runStepOps` and every `sendOp` branch: milestones, progress,
  checklists, signatures and signature times, labor, lunch, buildup and breakdown.
- `findServerTicket`, `fetchServerSnapshot`, discrepancy resends, review punch and final
  `services.submit.submit`.

Existing photo-upload adapters already set `suppressGlobalLoader: true`; keep that
behavior and ensure their automatic cleanup requests are also excluded.

Use the notification mechanism at each actual HTTP boundary. Do not introduce a global
“sync is running” switch: simultaneous foreground requests must still be counted
correctly. Keep request/response/error/retry accounting symmetric, including token
refresh and replay after a 401.

### 2. Make automatic cache updates silent and precise

In field-ticket query functions and dashboard cache warming, pass background request
options for automatic reads. Include checklist, signature, lunch, segment, breakdown,
labor and identity reads that run on reconnect/focus. Retain cached data during refetch;
only a first load without usable data may show an initial loading view.

Replace blanket sync invalidation with a shared reconciliation helper that collects
changed ticket UUIDs and affected resource kinds. Invalidate ticket-list variants once
per batch and the exact affected ticket/resource keys. Do not refetch comments,
attachments or unrelated checklists merely because a milestone synced. Finalization
must still update the ticket list so completed tickets move to the correct section.

Separate manual refresh from query activity in `app/(field)/field.tsx`: use local state
owned by `handleRefresh`, reset in `finally`, while keeping its synchronous double-tap
guard. `isRefetching` cannot identify who initiated a request; a background refetch must
not animate or disable the manual refresh button. Manual refresh retains explicit local
progress and its result toast.

Use query/mutation metadata to suppress global error toasts only for automatic
reconciliation work. Direct sync failures remain recorded in the existing ledger;
foreground actions continue to report their own errors. Do not silently swallow a
permanent validation failure or treat it as success.

### 3. Give automatic sync one owner, separate from foreground submit

Have reconnect and ticket-open hooks request work from one coordinator. Reuse the
existing ordered drain and revision checks; extend per-ticket ownership to attachments,
steps, verification and finalization. Resolve UUID/code aliases to the same ticket slot
so duplicate triggers join the same work rather than submit twice.

Remove the automatic hook's invocation of foreground `submitTicket(true, ...)` and
foreground `useSubmitTicket` mutation. Keep manual Complete & Submit and its explicit
pre-submit check. Automatic work must not set `savingStep`, `isSavingStep`, saving
messages, confirmation-modal state or foreground `submitState: 'submitting'`.
An offline-submitted ticket remains locally submitted while its existing sync ledger
records progress; successful server completion replaces the offline reference.

All automatic finalization must use the existing sequence: upload, drain in order,
close review/work time, fetch/compare the server snapshot, resend eligible discrepancies
and verify again, then submit. Retain draft/files until backend success is confirmed.
Preserve the existing attempted retry of a failed foreground submit, but route it through
this verification sequence; distinguish transient transport failures from validation or
verification failures so connectivity events cannot create an unbounded submission loop.

Coalesce duplicate online events and recheck connectivity between operations. Preserve
pending work when connectivity drops. A network event does not itself constitute a
foreground user action.

### 4. Protect edits and verify actual responsiveness

Store background acknowledgments as updates to the latest draft, not full replacement
of a snapshot read before a network wait. For an open ticket, merge through the live
store and persist its latest snapshot. For closed tickets, serialize read/merge/write
with a revision check; recheck ownership if a ticket opens or changes mid-request.
Mark a step synced only for the revision actually sent. Extend the per-ticket slot to
avoid duplicate attachment uploads/finalization when the ticket opens during a scan.

Yield between operation units in both open and closed drains. Avoid repeating full-draft
reads/writes or scanning every saved ticket on every acknowledgment. Preserve the
existing targeted store selectors. Profile a representative large backlog with photos
on a physical device before claiming thread isolation or introducing another execution
framework. Async HTTP already releases the event loop; removing the touch-blocking
loader is the first fix, and a native worker is not required by the observed defect.

## Required regression coverage and acceptance

Tests must exercise the actual HTTP adapters/interceptors, not only mocked services.
Existing background-sync tests mock those layers and therefore cannot detect this bug.

1. Every sync operation kind, verification read, final submit and cleanup request excludes
   global loader activity on success and error; exclusion survives a 401 replay.
2. A foreground request concurrent with sync still increments/decrements the loader
   correctly. Background completion cannot decrement the foreground request's count.
3. Reconnect while an offline ticket is open, while Home is visible, and while another
   ticket is being edited: no sync-driven scrim, foreground submitting state, navigation
   or modal; scroll, taps and typing remain usable.
4. Automatic reconciliation retains displayed data, updates only relevant caches and
   leaves the manual refresh button idle. A manual refresh still shows its own progress.
5. Duplicate reconnect/open triggers join one ticket run. Rapid network loss, failed
   upload, expired access token, failed verification and restart keep unsent drafts/files
   and never complete the ticket prematurely.
6. Edit a ticket or open a previously closed draft during a delayed upload/step request:
   new values survive in memory and after reopening from disk; old acknowledgments do
   not mark newer operations synced.
7. On a physical device, sync multiple offline tickets including large photos over a slow
   connection while navigating and typing. Observe frame timing, touch responsiveness,
   loader counters and request classification. Confirm server data and final ticket state
   after catch-up.

Run the focused mobile suites through Nx, then mobile lint and typecheck. Add targeted
adapter/interceptor, coordinator and screen tests above. A passing mocked drain suite
alone is insufficient evidence for the UI isolation requirement.

## Review validation

- Static request-to-overlay trace and controlled interceptor reproduction completed.
- No application implementation changes or device reproduction were made in this review.
- Existing background-sync suite passed through
  `pnpm nx run @tcg/mobile:test --runInBand --watchman=false --testPathPattern=background-sync --outputStyle=stream`.
  The initial run could not access the sandboxed Watchman socket; disabling Watchman
  allowed the test target to complete. Shared build was restored from Nx cache.
- Full mobile lint/typecheck and device profiling were not run for this plan-only review.


## Implementation — 2026-10-02

Application changes are committed as `c43b0f14d` on
`fix/SCRUM-OFFLINE-SYNC-readonly-badges-persistence`.

- Typed request intent reaches HTTP adapters for replay writes, verification reads, uploads
  and cleanup. Automatic query reads and Home cache warming also run silently. Foreground
  mutations retain their defaults. Axios regression tests include 401 replay, overlapping
  foreground activity and token-storage failures.
- Automatic hooks schedule one scanner; manual submission shares a canonical ticket lock.
  Finalization retains the upload/drain/review/verify/resend/reverify sequence. Duplicate
  online events coalesce; connectivity and session identity are checked between operations.
- Reconciliation batches exact ticket resource keys and the ticket list. Home refresh uses
  local state owned by the tap, rather than query refetch activity.
- Acknowledgments merge into the latest draft under the storage queue, checking step
  revision and timestamp. Failed writes keep their operations and reason. Durable submission
  intent survives errors. Work arriving during final submission is retained with a persisted
  conflict marker, including later scans against a completed server ticket; it requires
  explicit review rather than automatic deletion. Queued manual work and late submission
  responses cannot mutate another open ticket.

Validation: 203 focused tests pass across HTTP adapters/interceptors, coordinator, cache
reconciliation, scanner, manual Home refresh, store, scheduling hook, ordered drain and
server verification. Mobile lint passed through Nx; changed-file lint and whitespace
checks also pass. Mobile typecheck passed through Nx. Jest was invoked directly after
Nx's test target repeatedly rejected execution with a recursive task invocation error.
Reports: `/tmp/nonblocking-final.json` (unchanged passing suites) and
`/tmp/nonblocking-races-final.json` (final Home/scanner/store checks).

Physical-device acceptance item 7 remains unperformed in this workspace. Async requests still share the React Native JavaScript runtime; yields
and loader isolation are implemented, but frame timing under a large photo backlog needs
that device check. Broader defects from `offline-implementation-review.md` remain outside
this plan's scope. The plan and review are committed separately in the overlay repository;
no changes have been pushed.
