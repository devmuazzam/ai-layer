# Reflection — MOBILE-TICKET-PRESIGNED-IMAGES — presigned S3 images in the mobile ticketing flow

> Written 2026-10-29 by `tcg-reflector`, close-ticket step 2. Evidence tags: VERIFIED = a command
> or file:line was checked in this run; INFERRED = taken from the session facts the caller gave
> or from state.md prose and not re-checked against git or a device.
>
> Model note: the reflections index shows a third occurrence in four classes (see §5). The
> reflector spec says to run those on Opus. This run was Sonnet-class; a human should read
> §5 with that in mind.

## 0. Context

| Field | Value |
| --- | --- |
| Ticket | `MOBILE-TICKET-PRESIGNED-IMAGES` (slug; no Jira id, Q2 still open) |
| Spec | `.ai/aidlc/MOBILE-TICKET-PRESIGNED-IMAGES/spec.md`, elaborated 2026-10-27, amended 2026-10-28 (D11, D12, D13, REQ-12, REQ-13) |
| Units | U1..U7 — shipped. U1-U5 original; U6, U7 added mid-ticket (web progress tracking, asset meter-reading photos). Merged to `staging` as PR #958, merge commit `0f4704b10`, 2026-10-29. Not on `main`. VERIFIED: `git diff 0f4704b10^1 0f4704b10 --stat` = 102 files, 2944 insertions, 710 deletions |
| Reflected on | 2026-10-29 |
| Reviewer(s) | Syed Haris (developer, requester, every §12 owner). Automated: `tcg-analyst` (U1-U5), `tcg-contract-tracer` (web tile), a three-agent static review of PR #947 (`review-pr947.md`) |
| Open questions at build time | 8 (Q1-Q8). Q1, Q3, Q4, Q5, Q6 answered before U1 started; Q7 (raised by U1) and Q8 (raised by U3) came from the build; Q2 (Jira id) still open. INFERRED from the §12 Answer lines and state.md |
| `[UNVERIFIED]` requirements built | 9 (REQ-01, 02, 03, 04, 06, 07, 08, 12, 13). At least 4 had a part that proved wrong, stale or incomplete: REQ-02 (cover shape, reworked by D11), REQ-04 (intent named `saveSignature`, code has `recordSignature`, spec.md:139), REQ-06 (Content-Disposition left open, spec.md:177), REQ-07 (featureId note, D12). The tag predicted trouble in this ticket |
| Unverified × irreversible | 2: the response shape (`cover` / new ticket type) and the value stored in `attachments.feature_id`. Neither was flagged before the build. The shape was found after U5 was built (36-file rework, `9f19d41e9`); the stored value was found by the developer in the local DB after U1-U5 (`51f233353`). Pattern: discovered late both times |

## 1. Spec defects — what the spec missed

### SD-1 — Sibling image type beside the shared cover contract

- **Where:** REQ-02, D5, D6, D11 (first version); `contexts/patterns.md` P3.
- **What the executor needed to know:** that a new image field must reuse `EntityImageCover` and, if the cover lacks something (the original), the cover itself grows for every entity.
- **What the spec said:** the intent said "use the same field name" (intent.md §3). REQ-02 first said return `EntityImageCover` "under the existing field names", but D5/D11 first version introduced a `TicketImage` type and said `EntityImageCover` was not changed (provenance_note of the D11 decision note, VERIFIED). P3 in patterns.md had no sentence about extending versus adding.
- **What was decided instead, and by whom:** the plan carried a sibling type; the developer corrected it twice (first: reuse the `cover` object and field names; later, after U5: `originalUrl` goes on `EntityImageCover` for every entity).
- **Was the decision right:** no, then yes after correction.
- **Cost:** commit `9f19d41e9`, 36 files, +176/-162, deletes `packages/shared/src/types/ticket-image.types.ts` (VERIFIED `git show 9f19d41e9 --stat`). Plus two developer review rounds.
- **Class:** missing (the rule "extend, do not add a sibling" is written nowhere).
- **Fix:** R1, R2.

### SD-2 — Schema comments and a spec note said `feature_id` holds `ticketCode`; the Identity invariant says UUID

- **Where:** REQ-07 Notes for the executor (spec.md:194, amended after the fact); schema comments on `Attachment` (VERIFIED: `apps/api/prisma/schema.prisma:84-98` and `:4346` now say "holds the ticket's UUID (rows written before 2026-10-28 hold its `ticketCode`)"); root `CLAUDE.md` Identity ("Children reference the parent by UUID").
- **What the executor needed to know:** which of two documented conventions wins for a new reference column value.
- **What the spec said:** the DB `featureId` column still holds `ticketCode`; only the S3 key uses the UUID (quoted in the D12 amendment of REQ-07, spec.md:194).
- **What was decided instead, and by whom:** the spec carried the old schema comment forward as settled. The executor built to it. The developer spotted `feature_id = 'TK-00028'` in his local DB and decided on UUID, dual-read, no backfill (D12, G2).
- **Was the decision right:** yes. Cost of the late find is real: PR #947 review item A-1 (`review-pr947.md`) notes any other reader that filters by ticketCode (generic `GET /attachments`, reports, DAS) silently misses new rows. VERIFIED the review file says so; whether those readers were checked afterwards is NOT verified.
- **Cost:** commit `51f233353` (15 files, +126/-75), a dual-read forever, and unmigrated legacy rows.
- **Class:** contradicted a source (a schema comment, treated as authoritative, against a root invariant).
- **Fix:** R3.

### SD-3 — Nothing said how to serve user-uploaded non-image files (stored XSS)

- **Where:** REQ-06 and REQ-07 Notes (spec.md:177), D9.
- **What the executor needed to know:** a presigned GET for a user-uploaded file renders inline with its stored content type; an HTML or SVG upload would execute in the S3 origin context.
- **What the spec said:** "a `Content-Disposition` is not controlled by the presign today ... whether the shared file keeps its original name is a detail for the executor (record in the PR)" (spec.md:177, VERIFIED). D9 chose `presignGetUrl(fileName)`, `Needs developer: no`, `Reviewed by` blank (spec.md:404, VERIFIED).
- **What was decided instead, and by whom:** the executor used the plain presign. The developer found the gap in human code review; neither the analyst, the guardian nor the tracer did. Fixed with `presignDownloadUrl` (forced attachment disposition, octet-stream) in `8838aa0e2` (VERIFIED callers: `ticket-attachments.service.ts:258`, `ticket-incidents.service.ts:262,320`).
- **Was the decision right:** no. The spec saw the hole and filed it as a naming detail.
- **Cost:** a security fix after units were reviewed as shipping. Not yet paid in production.
- **Class:** missing (the spec noticed a security property and scoped it as cosmetic; no unit contract or analyst checklist line covers "user-uploaded content served by link").
- **Fix:** R4, R5.

### SD-4 — Unit contract said `cleanupReplaced unchanged` while the storage layout became two objects per row

- **Where:** units.md U1 row (units.md:127); §11a ripple.
- **What the executor needed to know:** every delete or replace path for a ticket image row must delete `preview.webp` too.
- **What the spec said:** "`cleanupReplaced` unchanged" (VERIFIED, units.md:127).
- **What was decided instead, and by whom:** the executor followed the unit. The analyst's U1 review found `preview.webp` left in S3 on replace; fixed by `b78c3776a` (VERIFIED message; the caller names the same fix as `128072695`, a rewritten hash, INFERRED). U3 then also fixed the generic attachment delete; the whole-stack review found the generic DELETE path again (INFERRED from fact 5; `review-pr947.md` A-2 mentions DB-first delete and the missing lifecycle rule).
- **Was the decision right:** no.
- **Cost:** one analyst fix round plus two further delete-path fixes; orphan sweep still relies on an S3 lifecycle rule nobody confirmed (see §3, Q10).
- **Class:** missing (the ripple list named readers and the cover shape, not the delete paths of a changed storage layout).
- **Fix:** R6.

### SD-5 — Link lifetime and persistence never stated

- **Where:** REQ-01, REQ-08, D8 (D8 handles an expired image on screen, nothing about stored copies).
- **What the executor needed to know:** presigned links live about 1 hour (`review-pr947.md` M-1); a client store that persists them holds dead links.
- **What the spec said:** nothing about client persistence.
- **What was decided instead, and by whom:** the executor put `signatureImage` and `identityPhotoImage` into the capture that `setCapture` writes to AsyncStorage. The AI review of PR #947 caught it (M-1, "Bug"); fixed in `db45e243e` ("Strip presigned S3 links from AsyncStorage drafts", VERIFIED).
- **Was the decision right:** no.
- **Cost:** one review round; no shipped defect.
- **Class:** missing.
- **Fix:** R2 (same template line as the shared-type row: an "expiring values" row), see R2 text.

### SD-6 — Sign-off waived, not recorded as waived; Q4 mapping derived and never confirmed

- **Where:** spec §14 (all boxes unticked, VERIFIED spec.md:558-570); Q4 Answer line (spec.md:478, "to be confirmed at review").
- **What the executor needed to know:** whether the build may start with `[OPEN]`/unticked sign-off, and which exact category strings for four items.
- **What the spec said:** §14 is a pre-build gate; the developer waived it in the session ("skip the gates"), recorded only in state.md prose.
- **What was decided instead, and by whom:** the executor built on the derived mapping; the developer waived the gates. No named person confirmed the mapping.
- **Was the decision right:** still unknown (the strings are in a DB column; changing them later is cheap, so low risk).
- **Cost:** nothing yet. Mild: §14 reads as an unticked gate on a shipped ticket.
- **Class:** open-built-anyway (waived by the developer; the artifact does not say so).
- **Fix:** R7. Q9 appended to spec §12 asks Haris to confirm the mapping.

### SD-7 — Spec and proposal text left stale after amendments

- **Where:** spec.md:404 (D9 still says `presignGetUrl(fileName)`, VERIFIED); `patterns-p3-proposal.md` ("Rows keep ... `featureId = ticketCode`", VERIFIED, stale after D12; "four copies of `labelAttachment`" before extraction); state.md "Merged" box reads `PR #… (none opened)` and "Reflect" unticked at the time of reading.
- **What the executor needed to know:** nothing for this ticket; the next reader of the proposal would copy a wrong rule into patterns.md.
- **What was decided instead, and by whom:** amendments were appended as paragraphs, not applied to the line they change.
- **Cost:** the proposal for Haris currently instructs the wrong `featureId` value. Needs fixing before it is applied.
- **Class:** stale reference.
- **Fix:** R8, and a direct note to Haris to correct the proposal before applying it.

## 2. Executor defects — what was built against the spec

### ED-1 — The same helper written 3-5 times across units

- **Where:** `labelAttachment` private method in `checklist-assignments.service.ts:422`, `ticket-incidents.service.ts:271`, `ticket-lunch-breaks.service.ts:528`, plus `labelAttachments` in `ticket-signatures.service.ts:300` (VERIFIED `git grep labelAttachment 779e13a98^`). The ids-to-covers loader existed in several copies until `779e13a98` / `loadTicketCovers`. `isImageMimeType` was copied in 3 files until `db45e243e` (VERIFIED commit message). The presign function and the web thumbnail hook were extracted by `e8039d1bd` and `c1b1c4b69` (VERIFIED log).
- **Spec said:** `patterns-p3-proposal.md` records "four copies of the best-effort `labelAttachment` ... should become one guard method" as a known gap. The ticket shipped the copies and listed the extraction as follow-up.
- **Built:** per-unit private helpers; extraction by the developer after review.
- **Caught by:** the developer's post-review refactors (VERIFIED four commits). Not by the analyst.
- **Class:** duplicated an existing component / helper (units built in separate sessions, each seeing only its unit contract).
- **Fix:** R9.

### ED-2 — Spinner on a reopened signature step ran forever; first fix failed

- **Where:** mobile signature step image (`a71ffcc37`, then `bd1cd43ff`, VERIFIED in log).
- **Spec said:** D7/D8 describe the shared component and one retry on expiry; nothing about loading-state ownership.
- **Built:** a loading flag not reset when the image was already displayed or cached. Root cause "inferred, never reproduced" (caller, fact 3). The second fix drives the spinner by "not displayed yet" with a 250 ms delay and 10 s cap (state.md, VERIFIED).
- **Caught by:** device testing by the developer. Not by any gate: mobile jest is red at baseline and nothing runs a device.
- **Class:** other — UI state that outlives its input (new vocabulary class `stale-ui-state`, §5).
- **Fix:** R10.

### ED-3 — A failed web tile stayed failed after a good link arrived

- **Where:** web progress-tracking tile (`2b58998f3`, VERIFIED log).
- **Spec said:** D8 "mirrors `avatar.tsx` and web `photo-tile-stage`" (spec.md:403).
- **Built:** error state set once and never keyed to the new URL.
- **Caught by:** `tcg-contract-tracer` (caller, fact 4). Good catch; the second instance of the same shape as ED-2 in one ticket.
- **Class:** `stale-ui-state`.
- **Fix:** R10 (the web half is the same rule).

### ED-4 — Every push used `SKIP_GATES=1`; API never booted; nothing ran on a device or S3

- **Where:** `.husky/pre-push:22-23` (VERIFIED skip path); state.md ("pre-push gates skipped"); units.md:66-68 (VERIFIED a `Gate baseline` header exists and records `pnpm test: fail`).
- **Spec said:** the units template baseline rule, applied after TCG-218, required a recorded baseline. It was recorded.
- **Built:** the baseline said mobile test is red on main (9 suites / 18 tests), so the all-or-nothing pre-push hook could not pass for any push. Using `SKIP_GATES=1` skips lint, typecheck and build too, not only the red target. DI was checked by reading and by a throwaway testing-module compile. S3 behaviour and device behaviour were never run by an agent.
- **Caught by:** nothing; this is how the ticket shipped. Defects 3-6 above were found by the developer, not by a gate.
- **Class:** `gate-illusion` (16th row, see §5).
- **Fix:** R11.

### ED-5 — Branch and checkout hazards

- **Where:** process (git).
- **Spec said:** `tcg-executor.md` requires `pnpm worktree:add` (R10 from TCG-218, applied 2026-10-20, VERIFIED in index line 133).
- **Built:** per the caller (INFERRED, not re-checked): an executor session ended with uncommitted work that was gated and committed by hand; unit branches u1-u4 were rewritten after push and stale copies deleted; the primary checkout held a staged index that reversed a commit after commits went through a second worktree on the same branch.
- **Caught by:** the developer.
- **Class:** `branch-ops` (third row, see §5).
- **Fix:** R12.

## 3. Source and vault findings

- **Sources that turned out to be wrong or stale:**
  - `apps/api/prisma/schema.prisma:84-98`, `:4346` — said `featureId` holds `ticketCode` — now corrected in the file (VERIFIED). Tagged: the spec carried it as an unmarked note, not `[UNVERIFIED]`. This is the case the tag missed. **Disposition: fixed; no vault action.**
  - `.ai/claude/contexts/patterns.md` P3 (via `patterns-p3-proposal.md`) — P3 assumes an owner cover and says nothing on extending the shared type; the proposal itself still says `featureId = ticketCode`. **Disposition: Haris corrects the proposal first, then applies; R1.**
  - `intent.md` §4 — names `saveSignature`; code method is `recordSignature` (spec.md:139, VERIFIED). Source was `[UNVERIFIED]` and was wrong. **Disposition: none needed; counts toward the tag-predicts-trouble tally.**
  - `spec.md` D9 — `presignGetUrl(fileName)` is no longer true for documents (`presignDownloadUrl`). **Disposition: R8.**
  - `spec.md` REQ-02 original text — `EntityImageListItem` / new ticket shape; kept as first written with amendment. **Disposition: fine, amendment is recorded.**
- **Conflicts that surfaced only during build:** schema comment versus root CLAUDE.md Identity (SD-2). No `gaps.md` entry is needed; the conflict is closed in the code and comments. The REQ-05 lunch-WTL conflict with the field-ops FRD (`field-ops-mobile-INDEX.md`) stays open and was not touched (labels mirror a four-slot cap and settle nothing).
- **Questions answered by a named human during the build:** Written? yes for each of: Q1/Q3 (`2026-10-27-mobile-ticket-images-ticketing-flow-only-old-images-not-backfilled.md`), Q4 and label table (`2026-10-28-ticket-attachment-category-labels.md`, mapping flagged unconfirmed), Q5/Q7/Q8 (`2026-10-28-ticket-incident-video-plain-file-undecodable-image-rejected-no-viewer.md`), D6/D11 (`2026-10-28-ticket-images-640-px-preview-32-px-blur-original-on-zoom-additive-fields.md`), D12 (`2026-10-28-ticket-attachment-feature-id-holds-ticket-uuid-old-rows-keep-code.md`), D13 scope widening (`2026-10-28-web-ticket-progress-and-meter-reading-images-on-presigned-covers.md`). VERIFIED all six exist (ls of `vault/decisions`). **Not written: 1** — the developer's decision to force attachment disposition for documents and videos (`8838aa0e2`, SD-3). `tcg-scrum` should write `2026-10-29-user-uploaded-files-are-served-as-forced-download.md`. Also not written: the developer's lightbox swap for progress images and the waiver of §14 (recorded only in state.md).
- **`gaps.md` entries this ticket should close:** NONE FOUND. I did not read any `gaps.md` whole; the ticket's questions lived in spec §12 (all but Q2 resolved). Spec §12 Q2 (Jira id) is open and unrelated to gaps. The field-ops FRD conflict stays open.
- **`gaps.md` entries this ticket opened:** none written (I cannot write the vault). Two for `tcg-scrum` to place if the owner agrees: DAS loadout photos not on presigned covers; sales quotation attachments and job artifacts on mobile still stream `/download` (Q1 = A follow-up); no incident viewer on mobile (Q8 = A follow-up). Spec §12 Q9 and Q10 appended for the two questions this ticket owns.
- **Undefined terms hit:** "thumbnail" versus "preview": for tickets `thumbnailUrl` is the 640 px `preview.webp` while for entity covers it is the 160 px crop (decision note on D11) — the same field name carries two sizes. "Cover" on ticket images, which have no owner cover. Neither is in the known nine; both are new, for the glossary.

## 4. Rule changes proposed

All target Haris-only files or root CLAUDE.md. I have not applied any. Surface rules moved to `.ai/claude/contexts/`, so these target contexts, templates and agents, not `rules/`.

| # | File | Section | Exact change | Prevents | Accepted |
| --- | --- | --- | --- | --- | --- |
| R1 | `.ai/claude/contexts/patterns.md` | P3, Rules | Add one sentence: "A response that returns an image returns `EntityImageCover` from `@tcg/shared` as is. If the cover lacks a field, add it to `EntityImageCover` for every entity; never add a sibling image type." Adds 1 line, removes 0 (no sentence covers this). Would the executor have stopped? Yes: it names the type and the forbidden act. | SD-1 | pending |
| R2 | `.ai/aidlc/templates/spec.md` | §7 Shared package, and §11 Non-functional | In §7 replace the free-text intro with a required row: "New exported type: `<name>` — nearest existing type: `<name>` — why it cannot be extended: `<reason>` (or `N/A — none added`)". In §11 add one required row: "Values that expire or change (links, tokens): `<where stored on the client, what refreshes them>` or `N/A`". Adds 2 rows, removes 1 sentence of §7 intro. | SD-1, SD-5 | pending |
| R3 | `.ai/aidlc/templates/spec.md` | §3 Data model | Add a required row for any column that holds a reference to another entity: "Value stored: UUID, or code (cite the `CLAUDE.md` Identity exception that permits it). A schema comment is not an exception." Adds 1 row, removes 0 (no field covers reference values). | SD-2 | pending |
| R4 | `apps/api/src/service/storage/s3-storage.service.ts` (code, Haris to apply) | `presignGetUrl` | Rename `presignGetUrl` to `presignInlineImageUrl`, with JSDoc: "ONLY for objects this server re-encoded to WebP. Any user-uploaded file uses `presignDownloadUrl`." A rename breaks every caller at compile time, so the next author must choose (VERIFIED 6 non-spec call sites, all image paths, in `attachment-photos.service.ts` and `ticket-image.ts`). Adds 1 JSDoc, replaces 1 name. | SD-3 | pending |
| R5 | `.ai/aidlc/agents/construction/tcg-analyst.md` | review checklist | Add: "For every new link, redirect or response header the API hands to a client: is the object user-uploaded and not re-encoded by us? Then it must be served as a forced download (`presignDownloadUrl`) — an inline render of HTML or SVG is stored XSS. Cite the line." Adds 1 item, removes 0. | SD-3 | pending |
| R6 | `.ai/aidlc/templates/units.md` | unit contract, per-row "Ripple" or "Notes" | Add a required line for any unit that changes where or how many objects a row stores: "Every create, replace and delete path touched: `<list from grep of the old key helper>`". Replace the phrase `cleanup unchanged` convention (not a template sentence; the executor writes it) with this line being non-empty. Adds 1 line, removes 0. | SD-4 | pending |
| R7 | `.ai/aidlc/templates/spec.md` | §14 | Replace the line `Answered by: ______  Date: ______` with `Answered by / waived by (name, date, which boxes): ______`. A waiver is then a recorded act, not an unticked box. Adds 0 lines, replaces 1. | SD-6 | pending |
| R8 | `.ai/aidlc/agents/inception/tcg-elaborator.md` | amendment rule | Add one sentence: "When an amendment changes a decision, edit the original D-row or REQ text in place and mark it `(amended <date>)`; do not leave the old text beside a new paragraph." Adds 1 sentence, removes 0. Also: Haris to correct `patterns-p3-proposal.md` (`featureId = ticketCode` is now wrong) before applying it. | SD-7 | pending |
| R9 | `.ai/aidlc/templates/units.md` and `.ai/aidlc/agents/inception/tcg-decomposer.md` | units header / decompose step | Add a required header row in units.md: "Shared helpers: `<name>` — created in `<unit>`, reused in `<units>`". In `tcg-decomposer.md` add: "If two or more units need the same private method, the earliest unit creates it in `@service/*` and the later units list it as reused; grep the ticket's own sibling services for a same-named method first." Executor side: in `tcg-executor.md` self-review add: "Before writing a private helper, `grep -rn '<name>' apps/api/src`; a second hit means extract now." Adds 3 lines, removes 0. Mechanical option (needs a G5 dependency ask): `jscpd` on `apps/api/src/usecase` with a min-token threshold. This is the third `duplicated-logic` row: prose alone has not held (see §5). | ED-1 | pending |
| R10 | `.ai/claude/contexts/web.md` and `.ai/claude/contexts/mobile.md` | image / loading state | Add to each one sentence: "A loading or failed flag tied to an image URL is keyed by that URL (reset when the URL changes) and never has an unbounded spinner: cap it." For a bug only reproducible on a device: "write the hypothesis in the PR; after one fix that fails, stop and ask for a repro." Adds 2 lines per file, removes 0. | ED-2, ED-3 | pending |
| R11 | `.husky/pre-push` (and `tcg-executor.md` §gates) | `SKIP_GATES` | Replace the all-or-nothing skip with a per-target one: `SKIP_GATE_TARGETS="@tcg/mobile:test"` skips only the named red targets from the units `Gate baseline`; lint, typecheck and build still run. Replace the executor sentence that allows `SKIP_GATES=1` on a red baseline with "name the red targets from the baseline; skip only those." Adds ~8 lines of hook, removes 1 sentence. The previous fix (record a baseline, TCG-218 ED-4) held but made red main visible without making the hook usable; every push then bypassed everything. | ED-4 | pending |
| R12 | `scripts/` worktree helper (`pnpm worktree:add` / `worktree:done`) and `.ai/aidlc/agents/construction/tcg-executor.md` | worktree, session end | (a) `pnpm worktree:done` refuses to push a branch that is checked out in another worktree of the same repo. (b) executor rule: "commit work-in-progress after each logical step (`wip:` prefix, squashed by the developer); never leave an uncommitted tree when a session ends." (c) state.md: unit branches are not rewritten after push; if the developer rebases, write it in Resume. Adds ~6 lines, removes 0 (existing R10 covers creation only, not branch reuse or session end). NOT verified: I did not reproduce the stale staged index; git itself refuses the same branch in two worktrees unless forced, so the actual cause may be a detached HEAD or `--force`. Haris to confirm before applying (a). | ED-5 | pending |

- **Rejected proposals, and why:**
  - A new guardrail G7 "serving user-uploaded content" in root CLAUDE.md — R4 (a compile break) and R5 (a checklist line) hold without making the always-on file longer.
  - A rule "AI-decisions rows never `Needs developer: no`" — D9 (which carried the XSS) and D1 would not have been caught by a blanket rule; the actual gap was an unlisted security property, handled by R4/R5.
  - A spec requirement for a device test before merge — the sandbox has no AWS env and no device; the check cannot be run by an agent. Not proposed; stated as a limit in §6.

## 5. Recurrence check

Checked by `grep -c "| <class> |" .ai/aidlc/reflections/INDEX.md`.

| Defect | Class | Prior rows | Occurrence | Why the previous fix did not hold |
| --- | --- | --- | --- | --- |
| SD-1 | `pattern-drift` | 0 (class defined, no rows) | 1st | N/A |
| SD-2 | `contradicted-source` | 3 (SCRUM-926 ED-1, SCRUM-252 SD-2, TICKET-FLOW-SLOTS-HOLDOVER ED-4) | **4th** | Written and applied (`tcg-executor.md` §3, `templates/units.md` test plan, 2026-10-20), but scoped to decision notes and sibling implementations. This contradiction was a schema comment against a root CLAUDE.md invariant, which that wording does not cover. Remedy: R3, a required template field, not another sentence. |
| SD-3 | `missing-requirement` | 19 | 20th row | Escalated already (template requirement block R1, applied 2026-10-20). The R1 field asks for edge cases of behaviour; it has no prompt for a security property of served content, and D9 sat under `Needs developer: no`. Remedy: R4 (rename forces a choice) and R5. |
| SD-4 | `missing-requirement` | 19 | 21st row | Same as above; remedy R6, which names the grep the unit must list. |
| SD-5 | `missing-requirement` | 19 | 22nd row | Same; remedy R2 adds an explicit expiring-values row. |
| SD-6 | `open-built-anyway` | 0 | 1st | N/A |
| SD-7 | `stale-reference` | 6 | **7th** | Earlier rows (SCRUM-LOADOUT-UNASSIGNED SD-1, TICKET-FLOW-SLOTS-HOLDOVER SD-7 "5th occurrence", SD-8) show the same shape: amendments appended, original text left. Prose in the elaborator has not held. Remedy R8 is still prose; the mechanical option is a `/check-stale` step in `close-ticket` that greps each D-row against the final diff (not designed here). |
| ED-1 | `duplicated-logic` | 2 (SCRUM-252 ED-2, ED-3) | **3rd** | Previous fix: applied to `tcg-executor.md` self-review. The rows were about domain computations that diverge; here the copies were per-unit helpers written in separate sessions that never saw each other, and nothing told unit N that unit N-1 already had one. Written where each executor reads it, but with no input for the executor to act on. Remedy: R9 puts the shared helper into units.md so each session is told, plus an optional jscpd check. |
| ED-2 | `stale-ui-state` (new) | 0 | 1st | N/A |
| ED-3 | `stale-ui-state` (new) | 0 | 2nd (same ticket) | N/A |
| ED-4 | `gate-illusion` | 15 | 16th | Escalated at TCG-218 (8th row): `Gate baseline` header and restore pre-push, applied. It held for the baseline (this ticket records one) but the hook offers only all-or-nothing, so a red main means every push bypasses lint, typecheck and build. Remedy: R11. |
| ED-5 | `branch-ops` | 2 (TCG-218 ED-2, ED-3, both applied 2026-10-20) | **3rd** | Written and applied, but both rules cover creating the branch and the stacked PR base. Neither covers reusing a branch across worktrees, rewriting after push, or an executor session ending uncommitted. Remedy: R12, with the hook half mechanical. |

- **Escalate:** third-or-later occurrences this ticket:
  1. `branch-ops` (3rd). Not a reminder problem: mechanism is a guard in `worktree:done` (R12a) plus a commit-per-step line in the executor's instructions.
  2. `duplicated-logic` (3rd). Mechanism: shared-helper row in units.md filled by the decomposer (R9), optional `jscpd`.
  3. `contradicted-source` (4th). Mechanism: required field in the spec data-model section (R3).
  4. `gate-illusion` (16th). Mechanism: per-target skip in the pre-push hook (R11).
- **New class added to the index?** yes — `stale-ui-state` (UI state tied to an async input that outlives the input: a spinner that never ends, a failed tile that never retries). None of the existing classes describe a runtime state bug; two instances in one ticket. Added to the vocabulary table in `INDEX.md`.
- **Rows appended to `reflections/INDEX.md`:** yes — 12 rows (SD-1 to SD-7, ED-1 to ED-5).

## 6. Kept as-is

- **Scope growth twice (web progress tracking, asset meter-reading photos, then the shared lightbox)** — the developer's request, recorded in intent.md amendment, REQ-12/13, D13 and a decision note. Not a spec defect. Cost: units U6/U7 appended after U5 was reviewed. Next time, ask "web too?" in intake: the original intent said "In Web and mobile (Only profile photo)", so web was foreseeable.
- **DAS loadout photos not built; sales quotation attachments, job artifacts and an incident viewer left out** — Q1 = A and Q8 = A (decision notes), listed as follow-ups. Correct.
- **No backfill of legacy `attachments.feature_id` and dual-read** — G2 requires approval and a copy-of-staging guard run; not requested. Correct.
- **No new tests** — root CLAUDE.md default; spec §10 says `not requested`.
- **Unit branches rebased by the developer after push** — the developer's right; recorded under R12 as a process note only.
- **U3 shipped API-and-data-layer only** — Q8 = A; a vertical-unit exception the developer chose.
- **Four unrelated API suites failing on the rebased base (payroll x2, quotation-pdf)** — pre-existing, not this ticket's. INFERRED from fact 9; not re-run.
- **Not verifiable by anyone in this loop:** behaviour on a device or against real S3. Only the developer's device runs exist (spinner fix confirmed by Haris). The spinner root cause was never reproduced (ED-2).
