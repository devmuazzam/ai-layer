# Spec — SCRUM-757 Performance Issues and Excessive API Calls and Plan Comments issue

> Written to `.ai/aidlc/SCRUM-757/spec.md` by the elaborator
> (`.ai/aidlc/agents/tcg-elaborator.md`).
>
> This is the document an executor builds from. **Every requirement in it carries its
> sources, and every source carries its status.** A requirement with no source is not a
> requirement — it is an open question, and it stays marked as one.

> **Read this before anything else.** This spec is mostly open questions. Five of seven
> requirements are `[OPEN]`. The ticket is a three-symptom bug report with no acceptance
> criteria, no named endpoints, and its only concrete evidence in two attachments this
> elaboration could not open. Nothing here is ready to build.

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-757` — Bug, **To Do**, priority Medium, epic `SCRUM-232` "Project", reported by Aiman Farooq, created 2026-07-16, last updated 2026-08-07, no ticket comments, no issue links |
| Intent | **MISSING** — `.ai/aidlc/SCRUM-757/intent.md` does not exist. Retrieval step 1 could not be performed; this spec was elaborated from the Jira ticket directly. Any field the intent capture would normally have carried (surfaces, `NOT ON TICKET` markers, capture date) is absent, so absences below are this elaboration's findings, not the capture's. |
| Elaborated on | 2026-08-11 |
| Vault state at elaboration | 153 files per `INDEX.md` (151 content files); six `domain/` files verified, everything else `unverified`; **8** entries open in `gaps.md` before this spec |
| Gaps opened by this spec | `gaps.md#scope-of-the-plan-comments-page-in-scrum-757`, `gaps.md#plan-comment-performance-target`, `gaps.md#source-of-the-400-and-401-responses-on-the-plan-page`, `gaps.md#plan-comment-volume-length-and-pagination` |
| Rules consulted | `.ai/claude/rules/web.md`, `.ai/claude/rules/api.md`, `.ai/claude/rules/prisma.md`, `.ai/claude/rules/design-system.md`, `CLAUDE.md` → Web UI Rules, Frontend Patterns, Identity Convention |

> **Note added 2026-08-12 — the rule paths cited in this spec no longer resolve.**
> This spec cites `.ai/claude/rules/{web,api,prisma,design-system}.md` in seven places
> (§0 twice, §2 REQ-03, §3, §4, §5 twice). **That directory does not exist.** The surface
> rules live at `.ai/claude/contexts/{api,prisma,web,mobile}.md`; `design-system.md` has no
> successor at all — the design intake is being redesigned (`aidlc/GUIDE.md` §13).
>
> The citations are **left as written** rather than repointed, because §0 is a record of
> what this elaboration read on 2026-08-11 and rewriting it would falsify that record. A
> reader following those paths today will find nothing; use `contexts/` instead.
>
> This is a `stale-reference` defect of exactly the class `aidlc/GUIDE.md` §12 predicts
> ("this layer has been restructured twice and a reference that still resolves is not proof
> it is current"). It is logged here for the reflector rather than fixed mid-run, and it
> does not change any requirement — none of the four files sets a performance budget, which
> is the only thing this spec asked them for.

### What the ticket says, verbatim in substance

Three symptoms, filed as one bug:

1. The **Plan Comments** page becomes noticeably slow as the number and length of comments
   grow; the comment box becomes unresponsive, "making it difficult to type or interact
   with the application".
2. Opening a single page triggers **multiple repeated API requests**.
3. Several **400 (Bad Request)** and **401 (Unauthorized)** responses are generated. The
   ticket states these "do not currently affect the application's functionality" but
   "indicate unnecessary network activity that could negatively impact performance and
   scalability over time".

Steps to reproduce name the Plan Comments page, adding multiple long comments, and
watching the Network tab. Two attachments are linked — a Google Drive file and a Loom
recording. **Neither was opened during this elaboration**, and they are the only place the
ticket's concrete evidence (which screen, which requests) exists.

### Retrieval performed, and what it did not settle

| Step | Read | Result |
| --- | --- | --- |
| 1 | `.ai/aidlc/SCRUM-757/intent.md` | **Does not exist.** |
| 2 | `SCRUM-757` via Jira; epic-sibling scan of `SCRUM-232`; JQL across the project for `performance`, `API calls`, `plan comment`, `comments` | Ticket read in full. Siblings found: `SCRUM-763` "Inhouse comments – design update needed" (Task, **Blocked**, same epic, "In house comments tab - design required") and `SCRUM-211` "Comment rich text scroll bar is missing" (Done). Neither states a performance target or names the Plan Comments page. |
| 3 | `.ai/claude/rules/web.md`, `api.md`, `prisma.md`, `design-system.md`, `CLAUDE.md` | Bind *how*. None speaks to performance budgets or request counts. |
| 4 | `.ai/vault/INDEX.md`, `README.md`, `gaps.md` | No conflict area covers plan comments. `README.md` → *What this vault does not contain* does not list performance or NFR content as a deliberate exclusion, so this is "nobody wrote it down", not "excluded by policy". |
| 5 | Conflict stubs | None of the five (`field-ops-mobile`, `quotations`, `customers`, `agencies-vendors`, `daily-allocation`) covers plans or plan comments. |
| 6 | `product/project-module/INDEX.md` → `04-create-and-approve-lift-plans.md`; `product/job-project-das.md`; vault-wide grep for `comment`, `performance`, `slow`, `api call`, `lift plan` | `04-create-and-approve-lift-plans.md` specifies plan creation and the approve / request-changes-with-comments workflow. **It describes no comments page, no comment thread, no volume limit, and no performance expectation.** `product/job-project-das.md` (punch list) records two adjacent one-liners — under **Plan**: `rich text field - UI issue`; under **Project**: `in house comments – design update needed` — neither of which says what the issue is. Nothing else in 153 files touches web performance. |
| 7 | Repo (`apps/web/src/features/plans/`, `apps/api/src/presentation/plans/`, `apps/api/prisma/schema.prisma`, `apps/web/src/lib/base-api.ts`) | Current state only — see §3, §4, §5. |

**A source I deliberately did not use.**
`product/frd-new-format-draft/07-non-functional-requirements.md` carries the only
Performance row anywhere in the vault: *"Ticket screens, checklist rendering, and signature
capture must load within acceptable response times under field network conditions."* It is
scoped to the **field-ops mobile app**, it names no threshold, and it sits inside the
unresolved field-ops conflict set (`conflicts_with` is non-empty; see
`gaps.md#field-operations-mobile-app`). Borrowing it as a performance target for a web plan
page would be inventing a requirement, so it is recorded here and used nowhere below.

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Which screen "the Plan Comments page" is | web | `[OPEN]` | none | **yes** |
| REQ-02 | Comment entry stays usable as the comment thread grows | web | `[UNVERIFIED]` | `SCRUM-757` | no |
| REQ-03 | What counts as acceptable responsiveness | web | `[OPEN]` | none | **yes** |
| REQ-04 | A single page open does not repeat the same request | web | `[UNVERIFIED]` | `SCRUM-757` | no |
| REQ-05 | The 400 responses — which requests, and expected or not | web / api | `[OPEN]` | none | **yes** |
| REQ-06 | The 401 responses — defect or the designed refresh cycle | web / api | `[OPEN]` | none | **yes** |
| REQ-07 | Comment volume, length and pagination | web / api / schema | `[OPEN]` | none | **yes** |

Counts: **7** total — **0** verified, **2** unverified, **0** conflicted, **5** open.

## 2. Requirements

### REQ-01 — Which screen "the Plan Comments page" is `[OPEN]`

- **Statement:** `OPEN — the ticket names "the Plan Comments page" as the surface under
  test; no source in the vault, Jira or the repo defines a screen by that name, and the repo
  offers at least two candidates.`
- **Surface:** web
- **Sources:** none.
  - Searched: `SCRUM-757` (names the page, does not identify it); epic `SCRUM-232`
    siblings; project-wide JQL for `comments`; `product/project-module/` in full;
    `product/job-project-das.md`; vault-wide grep for `comment`. `product/project-module/04-create-and-approve-lift-plans.md`
    describes a *Plans tab* and approve/request-changes **with comments**, but specifies no
    comments page.
  - Not settled by any of them. The ticket's two attachments (Google Drive file, Loom
    recording) are the only evidence that names the screen, and they were not opened.
- **Conflict:** n/a
- **Open question:** Which screen is "the Plan Comments page" — the plan detail view's
  comment surface, the project **In-House Comments** tab, or a third screen? Logged at
  `gaps.md#scope-of-the-plan-comments-page-in-scrum-757`
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked. Everything else in this spec is scoped to whichever
  screen this resolves to. For the reader's orientation only, the repo currently has two
  distinct comment surfaces that a reporter could plausibly call this — see §5 *Current
  state*. Identifying which one is a question for the reporter, not a choice for the
  executor: the two are different features with different owners, and `SCRUM-763`
  ("Inhouse comments – design update needed", **Blocked**) is already open against one of
  them.

### REQ-02 — Comment entry stays usable as the comment thread grows `[UNVERIFIED]`

- **Statement:** Typing in and interacting with the comment box remains usable as the
  number of comments and the length of each comment increase.
- **Surface:** web
- **Sources:**
  - `SCRUM-757` — `[UNVERIFIED]` — kind: jira — reports that with "multiple comments
    containing long paragraphs" the page "becomes noticeably slow, and the comment box
    becomes unresponsive, making it difficult to type or interact with the application".
    A bug report sources *this is currently wrong*; it does not source what correct is.
- **Conflict:** none
- **Open question:** none for the defect itself. The **threshold** at which it is fixed is
  REQ-03, and the **volume it must hold** is REQ-07; this requirement cannot be closed
  without both.
- **Acceptance:** Reproduce the ticket's steps on the screen REQ-01 identifies, at the
  comment count and length REQ-07 establishes, and confirm the box no longer degrades —
  measured against REQ-03's threshold. **This acceptance is not testable today**: two of
  its three inputs are open.
- **Notes for the executor:**
  - `product/job-project-das.md` (punch list, 1.7 KB, updated 2026-07-16) records
    `**Plan** — rich text field - UI issue` and `**Project** — in house comments – design
    update needed`. Both are one-liners that say nothing about performance. They are
    **not** cited as sources for this requirement because neither states that the issue is
    the one in this ticket; whether they describe the same defect is unknown and worth
    asking alongside Q1. Note also that this file is one of the four cross-module punch
    lists flagged in `gaps.md#feedback-punch-lists-are-not-scoped-to-the-module-they-are-filed-under`.
  - Two code observations, offered as questions and not as proposals — neither is a
    diagnosis, and neither should be actioned before REQ-01 resolves:
    (a) plan comments are persisted as **project activity-log entries**, not as rows of a
    comment model (`apps/api/src/presentation/plans/plans.controller.ts:139` —
    *"Append a free-form comment (stored as a project activity log entry)"*; no
    `PlanComment` model exists in `apps/api/prisma/schema.prisma`). Does a plan's comment
    list therefore grow with the whole project's activity, and is that intended?
    (b) `useAddPlanComment` invalidates `plansKeys.detail`, `plansKeys.all` and the entire
    `['activity-logs']` key on every comment added
    (`apps/web/src/features/plans/hooks/use-plans.ts:114-124`, with an in-code note that
    the invalidation is deliberately broad). Is a full refetch per keystroke-committed
    comment the intended behavior?

### REQ-03 — What counts as acceptable responsiveness `[OPEN]`

- **Statement:** `OPEN — the ticket asks for the page to stop being slow; no source states
  what "fast enough" is — no load-time budget, no input-latency budget, no comment count at
  which the page must still meet it.`
- **Surface:** web
- **Sources:** none.
  - Searched: the whole vault for `performance`, `slow`, `response time`, `api call`. Four
    hits, none applicable: `product/frd-new-format-draft/07-non-functional-requirements.md`
    (field-ops **mobile**, "acceptable response times" with no number, and inside an
    unresolved conflict set — see §0); `product/customer.md` "Tooltips are very slow" (a
    different defect, no target); `product/quotation.md` "Auto api call on page refresh"
    (a request for *more* automatic calls, in a different module);
    `product/atom-mobile-app-user-stories/02-home-dashboard.md` (employee performance
    metrics, unrelated sense of the word).
  - `.ai/claude/rules/*` and `CLAUDE.md` set no performance budget for `apps/web`.
  - `README.md` → *What this vault does not contain* does not list NFRs as an exclusion, so
    this is an absence, not a policy omission.
- **Conflict:** n/a
- **Open question:** What is the acceptance threshold — and against what comment volume?
  Logged at `gaps.md#plan-comment-performance-target`
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked, and it blocks REQ-02's sign-off. Without a number,
  "fixed" is whoever last looked at it deciding it feels fine, which is how this ticket
  reopens.

### REQ-04 — A single page open does not repeat the same request `[UNVERIFIED]`

- **Statement:** Opening the page once issues each of its API requests once, rather than
  repeating the same request several times.
- **Surface:** web
- **Sources:**
  - `SCRUM-757` — `[UNVERIFIED]` — kind: jira — "opening a single page triggers multiple
    repeated API requests… they indicate unnecessary network activity that could negatively
    impact performance and scalability over time."
- **Conflict:** none
- **Acceptance:** On the screen REQ-01 identifies, a single navigation produces no
  duplicate request to the same endpoint with the same parameters. **Not yet testable**:
  the ticket does not say which requests repeat, how many times, or whether the observation
  was made in a development build — see Q3. What the reporter counted as "repeated" is not
  recorded.
- **Notes for the executor:** `NOT SPECIFIED` — no source states which requests these are.
  Do not begin removing calls before Q1 and Q3 are answered; several plan-adjacent hooks
  legitimately refetch (`apps/web/src/features/projects/jobs/job-details/main/travel-permits/hooks/use-job-plan-assignments.ts`
  takes a `refetchInterval`), and the global TanStack Query defaults already set
  `refetchOnWindowFocus: false` with a non-zero `staleTime`
  (`apps/web/src/providers/query-provider.tsx`). Which of the observed repeats are
  duplicates and which are designed is exactly what is unknown.

### REQ-05 — The 400 responses `[OPEN]`

- **Statement:** `OPEN — the ticket reports several 400 (Bad Request) responses on page
  load; it names no endpoint, no request payload and no frequency, and no other source
  records them.`
- **Surface:** web / api
- **Sources:** none.
  - Searched: `SCRUM-757` (states the symptom, identifies nothing); its two attachments
    (not opened — they are where the Network tab evidence lives); epic `SCRUM-232`
    siblings; the vault (no source discusses API error responses on any web page).
- **Conflict:** n/a
- **Open question:** Which requests return 400, and are any of them expected? Logged at
  `gaps.md#source-of-the-400-and-401-responses-on-the-plan-page`
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked. A 400 with no named endpoint cannot be specified;
  it can only be reproduced. The cheapest resolution is the reporter re-running the steps
  and pasting the request lines, or someone opening the Loom.

### REQ-06 — The 401 responses `[OPEN]`

- **Statement:** `OPEN — the ticket reports several 401 (Unauthorized) responses and treats
  them as unnecessary; no source states which 401s are defects and which are the intended
  behavior of the platform's silent token refresh.`
- **Surface:** web / api
- **Sources:** none.
  - Searched: as REQ-05. `CLAUDE.md` → Auth System documents dual-token JWT with a 15-minute
    access token, and `apps/web/src/lib/base-api.ts:92` implements a *silent refresh*
    response interceptor — a 401 triggers `POST /auth/refresh` and one retry, with attempt
    rate limiting. That is a **code and rule observation about how the system works today**,
    not a statement that the observed 401s are or are not expected. It is why this is a
    question rather than a defect.
- **Conflict:** n/a
- **Open question:** Are the observed 401s the designed access-token-expiry → refresh →
  retry cycle, or unauthenticated calls that should not be issued at all? Logged at
  `gaps.md#source-of-the-400-and-401-responses-on-the-plan-page`
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked. Note the direction of the risk: if these 401s are the
  designed refresh cycle, "fixing" them means weakening the auth flow to make a console look
  clean. Confirm before touching `base-api.ts`.

### REQ-07 — Comment volume, length and pagination `[OPEN]`

- **Statement:** `OPEN — the defect is triggered by comment count and comment length; no
  source states how many comments a plan is expected to hold, how long a single comment may
  be, or whether the comment list is meant to paginate, virtualize or load in full.`
- **Surface:** web / api / schema
- **Sources:** none.
  - Searched: `product/project-module/04-create-and-approve-lift-plans.md` (specifies
    approve / request-changes-with-comments; no volume, no length, no list behavior);
    `product/job-project-das.md`; the whole vault for `comment`; `SCRUM-757`; siblings
    `SCRUM-763`, `SCRUM-211`. No limit or list behavior is stated anywhere.
- **Conflict:** n/a
- **Open question:** How many comments must the page hold at full responsiveness, is there
  a maximum comment length, and should the list paginate or load in full? Logged at
  `gaps.md#plan-comment-volume-length-and-pagination`
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** blocked, and it gates the shape of the fix. Pagination,
  virtualization and a length cap are three different features with three different data
  models behind them; picking one here would decide the product question by implementation.
  Do not add a max-length validator "for safety" — an unsourced limit is an invention with a
  small footprint, and it will be enforced on users who were never told about it.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** `OPEN — depends on REQ-07.` No sourced requirement in this
  spec requires one. If the answer to Q5 is pagination or an index on the comment read
  path, that is a schema change.
- **Migration required:** `OPEN — conditional on the above.` If any Prisma model, column or
  index changes, a migration under `apps/api/prisma/migrations/` is **mandatory**, created
  with `pnpm db:migrate` and committed with the change (`.ai/claude/rules/prisma.md`,
  `CLAUDE.md` → Web UI Rules #12). This is not optional even for an index-only change.
- **Data backfill required:** `NOT SPECIFIED`

```prisma
// No new or changed models are specified by this spec.
// Writing a model here would decide REQ-07 by implementation.
```

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| — none proposed — | — | — | — | — |

- **New prefix introduced:** no
- **Child relations:** n/a — nothing proposed.
- **Fields whose type/precision no source states:** n/a — nothing proposed.

**Current state, descriptive** (`code`, `[UNVERIFIED]` — what exists today, not what should
exist): there is **no `PlanComment` model**. `model Plan` (`apps/api/prisma/schema.prisma:2762`)
carries a single `approvalComments String? @db.Text` field for the approval workflow. Free-form
plan comments are appended as **project activity-log entries** — `POST /plans/:planId/comments`
is documented in the controller as *"Append a free-form comment (stored as a project activity
log entry)"* (`apps/api/src/presentation/plans/plans.controller.ts:137-146`). Whether that is
the intended long-term home for plan comments is not stated by any source, and this spec does
not decide it.

## 4. API surface — `apps/api`

No new or changed endpoints are specified. No sourced requirement calls for one.

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| — none proposed — | — | — | — | — | — |

Per endpoint: `N/A — nothing proposed.`

- **Request DTO:** `N/A`
- **Response shape:** `N/A`
- **Guards / roles:** unchanged — `AccessTokenGuard` and `RolesGuard` are global
  (`CLAUDE.md` → Auth System). Relevant to REQ-06 only as context.
- **Route param identity:** unchanged.
- **Errors:** `NOT SPECIFIED` — REQ-05 is precisely the question of which errors these are.
- **Module registration:** `N/A` — no new module.

**Current state, descriptive** (`code`): `apps/api/src/presentation/plans/plans.controller.ts`
exposes `GET /plans/tracker`, `GET /plans`, `GET /plans/:planId`, `POST /plans`,
`POST /plans/:planId/submit|approve|reject|send-email`, `POST /plans/:planId/comments` and a
delete. Submit / approve / reject and the comment append all take `ApprovalCommentDto`.
Layering is `presentation → usecase → service → orm` and must stay that way
(`.ai/claude/rules/api.md`, `CLAUDE.md` → Architecture).

## 5. Web surface — `apps/web`

- **Routes:** `OPEN — REQ-01.` Not stated until the screen is identified.
- **Existing components to reuse** *(mandatory check before proposing anything new)*:
  no new components are proposed, so nothing to check against. Should the eventual fix add
  UI, `PageHero`, `PageHeroButton`, `PageHeroStat`, `StatusBadge`, `SectionCard`, `Field`,
  `InfoRow`, `SectionTabs`, `WorkspaceTable`, `useWorkspaceTableControls` and `CommonTable`
  must be checked first (`CLAUDE.md` → Web UI Rules #1 and #13,
  `.ai/claude/rules/design-system.md`).
- **New components proposed:** none. *(This is the good outcome.)*
- **Table (if any):** `N/A` — no table is added or edited. If the fix turns the comment list
  into a table, `.ai/claude/rules/web.md` becomes binding in full: `standardizeDesktopColumns`,
  column roles, `renderRow(row, layout)`, a `searchPlaceholder` enumerating every searchable
  field, and `emptyFilterStateMessage` / `unfilteredItemCount` where filters exist.
- **Forms:** unchanged. The comment box is an input, not a validated form, and no source asks
  to change that. If validation is added, `CLAUDE.md` → Form Validation UX Standard binds:
  no summary box, failed submit scrolls and focuses the first invalid input, state clears the
  moment the input becomes valid.
- **Server state:** TanStack Query v5. No query key or invalidation change is specified —
  see REQ-02's second code observation for the one worth asking about.
- **Colors / spacing:** unchanged; CSS variables from `theme.css` only, no hardcoded colors.
- **Responsive:** unchanged; mobile-first, 44px touch targets.
- **Copy:** `NOT SPECIFIED` — no source provides UI copy, and none should be written.

**Current state, descriptive** (`code`) — the two candidate surfaces behind REQ-01:

1. **Plan detail view.** `apps/web/src/features/plans/components/plan-view-sidebar.tsx`
   renders an **Add Comment** action; `plan-view-recent-activity-card.tsx` renders comments
   inside a *Recent Activity* card fed from `@/features/activity-logs`, mapping
   `entry.changes['commentText']` to a "Comment added" row.
2. **Project In-House Comments tab.**
   `apps/web/src/features/projects/components/project-detail-comments-tab.tsx`. `SCRUM-763`
   ("Inhouse comments – design update needed") is open and **Blocked** against this one, and
   `product/job-project-das.md` carries the matching punch-list line.

Neither is named "Plan Comments". Choosing between them from the code is exactly the
substitution this spec must not make.

## 6. Mobile surface — `apps/mobile`

`N/A — the ticket describes a browser Network tab and a web page; no source places any part
of this defect in the Expo app.`

- **Screens / routes:** `N/A`
- **Components:** `N/A`
- **Offline / sync behavior:** `N/A`
- **Touch targets:** `N/A`
- **Push / notifications involvement:** `N/A`

## 7. Shared package — `packages/shared`

`N/A — no type is added or changed; no requirement in this spec crosses web and mobile.`

## 8. Permissions and tenancy

- **Roles permitted:** unchanged — no source asks to change who may read or add plan
  comments, and this spec does not state one.
- **Roles denied:** unchanged.
- **Tenant isolation:** unchanged — Prisma middleware injects `tenantCompanyId` on reads and
  writes (`CLAUDE.md` → Identity Convention). No requirement here needs it restated.
- **Cross-tenant reads:** none.

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| Comment body — maximum length | `NOT SPECIFIED` — no source states a limit, and the defect being triggered by "long paragraphs" is not a source for one. See REQ-07 / Q5. | — | — |
| Comment body — minimum length / required | `NOT SPECIFIED` | — | — |
| Comments per plan — maximum | `NOT SPECIFIED` — see REQ-07 / Q5. | — | — |
| Rich-text content restrictions | `NOT SPECIFIED` — `product/job-project-das.md` records `Plan — rich text field - UI issue` with no detail; that is a defect note, not a rule. | — | — |

Invented validation is still invention. A max length nobody wrote down is `NOT SPECIFIED`.

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit | `NOT SPECIFIED` — nothing to unit-test until a fix has a shape. | — |
| Integration (API) | `NOT SPECIFIED` — no endpoint changes. | — |
| E2E / manual script | The ticket's own reproduction — open the page REQ-01 identifies, add comments at the volume REQ-07 sets, type in the box, and record Network-tab request counts and status codes — becomes the regression script once REQ-01, REQ-03 and REQ-07 are answered. | REQ-02, REQ-04 |

- Requirements with no testable acceptance criterion: **REQ-01, REQ-03, REQ-05, REQ-06,
  REQ-07** (all `[OPEN]`), and **REQ-02** and **REQ-04**, which are sourced but not
  measurable until REQ-01/REQ-03/REQ-07 and REQ-01/REQ-05 respectively are answered. That is
  every requirement in this spec.

## 11. Non-functional

- **Performance:** `NOT SPECIFIED` — and it is the substance of the ticket, not a footnote.
  No load-time budget, no input-latency budget, no comment volume at which either must hold.
  See REQ-03 / Q2.
- **Concurrency:** `N/A` — no code minting, no new writes.
- **Audit / activity log:** relevant as **current state**, not as a requirement: plan
  comments are themselves stored as activity-log entries (§3), so any change to how comments
  are read or written touches the audit trail. No source states what the audit expectation
  for plan comments is.
- **Migration/rollout order:** `N/A` — nothing to roll out. If REQ-07 resolves toward a
  schema change, the order is schema → API → web, with the migration committed alongside.

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** Nothing below is built until these are answered.

### Q1 — Which screen is "the Plan Comments page"

- **Question:** Is "the Plan Comments page" in SCRUM-757 (a) the comment surface on the plan
  detail view, (b) the project **In-House Comments** tab, or (c) a different screen?
- **Why it cannot be answered from what is written:** the ticket names the page but nothing
  identifies it. `product/project-module/04-create-and-approve-lift-plans.md` specifies a
  Plans tab and approve/request-changes-with-comments but no comments page; no other vault
  file, and no sibling ticket, names one. The repo has two plausible surfaces and the
  codebase cannot say which the reporter was looking at. The ticket's Loom recording and
  Drive file would settle it in seconds — they were not opened during this elaboration.
- **Blocked:** REQ-01, and through it every other requirement here — none of them can be
  scoped, reproduced or accepted against an unidentified screen.
- **Owner:** Aiman Farooq (reporter) — or anyone who can open the ticket's attachments.
- **Logged:** `.ai/vault/gaps.md#scope-of-the-plan-comments-page-in-scrum-757` — `Status: open`
- **Workaround, if any:** none. Opening the two attachments is faster than any workaround
  and removes the question entirely.

### Q2 — What is the performance target

- **Question:** What is the acceptance threshold for "responsive" — a page-load budget, an
  input-latency budget, or both — and at what comment count and comment length must it hold?
- **Why it cannot be answered from what is written:** the vault contains exactly one
  Performance requirement, in `product/frd-new-format-draft/07-non-functional-requirements.md`;
  it is scoped to the field-ops **mobile** app, states no number, and sits inside an
  unresolved conflict set. No rule file and no `CLAUDE.md` section sets a web performance
  budget. `README.md` does not list NFRs among the deliberate exclusions, so nobody wrote
  this down.
- **Blocked:** REQ-03, and the sign-off of REQ-02 — without a number, "fixed" is a matter of
  opinion and the ticket reopens.
- **Owner:** product team
- **Logged:** `.ai/vault/gaps.md#plan-comment-performance-target` — `Status: open`
- **Workaround, if any:** none that is safe to call a fix. A profiling pass that *measures*
  current behavior — comment count vs. input latency vs. request count — is not blocked by
  this question and would give the answerer real numbers to set a threshold against. That is
  measurement, explicitly not a change.

### Q3 — Which requests produce the 400s, and what counts as a "repeated" request

- **Question:** On the page from Q1, which specific requests return 400, and which requests
  did the reporter see repeated — with counts, and whether the observation was made against a
  development build?
- **Why it cannot be answered from what is written:** the ticket states both symptoms and
  names no endpoint, no payload and no count. Nothing in the vault discusses API error
  responses on any web page. The evidence exists only in the attachments.
- **Blocked:** REQ-05, and the acceptance criterion of REQ-04.
- **Owner:** Aiman Farooq (reporter)
- **Logged:** `.ai/vault/gaps.md#source-of-the-400-and-401-responses-on-the-plan-page` —
  `Status: open`
- **Workaround, if any:** none. Re-running the reproduction and pasting the request lines
  answers it directly.

### Q4 — Are the 401s the designed refresh cycle

- **Question:** Are the observed 401s the intended access-token-expiry → `POST /auth/refresh`
  → retry cycle, or are they calls being made without authentication that should not be made
  at all?
- **Why it cannot be answered from what is written:** `CLAUDE.md` → Auth System documents a
  15-minute access token, and `apps/web/src/lib/base-api.ts:92` implements a silent-refresh
  interceptor that turns a 401 into a refresh plus one retry. That tells us the system
  *produces* 401s by design; it does not tell us whether the ones in the ticket are those.
  The ticket asserts they are unnecessary and cites nothing.
- **Blocked:** REQ-06.
- **Owner:** product team / whoever owns the auth flow — the answer determines whether this
  is a defect or expected behavior to close as "working as designed".
- **Logged:** `.ai/vault/gaps.md#source-of-the-400-and-401-responses-on-the-plan-page` —
  `Status: open`
- **Workaround, if any:** none, and there is a risk in guessing: if these 401s are the
  designed refresh cycle, suppressing them means weakening the auth flow to clean up a
  console.

### Q5 — Comment volume, length and list behavior

- **Question:** How many comments must a plan's comment page hold while staying responsive,
  is there a maximum length for a single comment, and should the list paginate, virtualize,
  or load in full?
- **Why it cannot be answered from what is written:** no vault source, no ticket and no rule
  states a comment volume, a length limit or a list-loading behavior anywhere for plans.
  `04-create-and-approve-lift-plans.md` is the closest thing to a plan specification and is
  silent on all three.
- **Blocked:** REQ-07, the shape of the fix for REQ-02, and §3's schema question.
- **Owner:** product team
- **Logged:** `.ai/vault/gaps.md#plan-comment-volume-length-and-pagination` — `Status: open`
- **Workaround, if any:** none. Pagination, virtualization and a length cap are three
  different products; choosing one in code decides the question without asking it.

## 13. What this spec deliberately does not specify

- **Which screen the ticket is about** — no source identifies it; see Q1 and REQ-01. Two
  candidates exist in the repo and this spec does not choose between them.
- **A performance number of any kind** — no source; see Q2. The one Performance requirement
  in the vault is field-ops mobile and is inside an unresolved conflict set; it was
  deliberately not borrowed.
- **Which requests are duplicated, and which return 400** — no source; see Q3.
- **Whether the 401s are a defect** — no source; see Q4.
- **A maximum comment length, a maximum comment count, or a pagination scheme** — no source;
  see Q5. No validator, page size or virtualization threshold is proposed, including as a
  "safe default".
- **A schema change, a migration, an index, or a new `PlanComment` model** — none is sourced.
  That plan comments are currently stored as project activity-log entries is recorded as
  current state in §3; whether that should change is a product question nobody has asked yet,
  and it is not this ticket's to answer by implication.
- **Any change to the TanStack Query invalidation on adding a comment** — the current broad
  invalidation is recorded as an observation under REQ-02 and phrased as a question. It is
  not a diagnosis and not a proposed fix.
- **Whether `product/job-project-das.md`'s `Plan — rich text field - UI issue` and
  `in house comments – design update needed`, and the Blocked `SCRUM-763`, describe the same
  defect as this ticket** — nothing says so; worth asking alongside Q1, but not assumed here.

## 14. Sign-off before build

- [ ] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person
- [ ] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/` — *none in
      this spec*
- [ ] Answers written back into `spec.md` with their new sources and flags
- [ ] `gaps.md` entries updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md`
- [ ] Decomposed into vertical units — `units.md`

Answered by: ______________  Date: ______________
