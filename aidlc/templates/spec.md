# Spec — SCRUM-### <feature name>

> Written to `.ai/aidlc/SCRUM-###/spec.md` by the elaborator
> (`.ai/aidlc/agents/inception/tcg-elaborator.md`) from `intent.md` beside it.
>
> This is the document an executor builds from. **Every requirement in it carries its
> sources, and every source carries its status.** A requirement with no source is not a
> requirement — it is an open question, and it stays marked as one.

## Fill rules

Every section below is required. **Never delete a section or a field inside a requirement
block.** A field you cannot fill keeps its heading and takes one of:

| Marker | Means |
| --- | --- |
| `NOT SPECIFIED` | No source says anything about this. |
| `N/A — <reason>` | Does not apply to this feature. |
| `OPEN — <question>` | Blocked on a human. Must also appear in §12. |

A spec that is 40% `NOT SPECIFIED` is an honest spec of a thin ticket. A spec where those
sections were deleted is a spec that lies by omission — the executor cannot tell "nobody
specified this" from "this doesn't apply", and will fill the silence with an invention.

## Source tagging — mandatory on every source line

Two statuses. There is no third.

| Tag | When | Today |
| --- | --- | --- |
| `[VERIFIED]` | A human adjudicated it against its competing copies. | **Only the six files in `.ai/vault/domain/`.** Nothing else in the vault qualifies. |
| `[UNVERIFIED]` | Migrated faithfully, never confirmed current. | Everything else — 145 of the vault's 151 content files, plus every Jira ticket, plus the repo. |

Alongside the tag, state the **kind** of source. Kind is provenance, not status:

- `vault` — a `.ai/vault/` path, always **vault-root-relative** (`customers/customer.md`,
  `field-ops/field-ops-frd/08-functional-requirements/fr-fop-013-lunch-monitoring.md`).
  Never a bare filename, never `../`.
- `jira` — `SCRUM-###`. A ticket is `[UNVERIFIED]` by default: it records what someone
  decided to build, not what product agreed. `gaps.md` → *Lunch thresholds* is the worked
  example of a ticket carrying numbers no specification supports.
- `code` — an `apps/…` path. **Evidence of what the system does today, never of what it
  should do.** A `code` source can settle "how is this currently implemented"; it can
  never settle a product question, and it can never be the only source for a behavior
  change.
- `decision` — `.ai/vault/decisions/YYYY-MM-DD-topic.md`. These are `[VERIFIED]`.
- `rule` — a `.ai/claude/contexts/*.md` or `CLAUDE.md` section. Binding on *how* we build,
  never on *what* we build.

**FR-FOP ids must name their document.** Both field-ops FRDs number from `001`, so a bare
`FR-FOP-013` identifies nothing — it is *Lunch Monitoring* in FR-TCG-FOP-002 and *Lunch
Timer and Alerts* in FR-TCG-FOP-001. Write `FR-TCG-FOP-002 FR-FOP-013` plus the path.

## Requirement flags — inline, never laundered

A requirement inherits the worst of its sources. Put the flag in the heading:

| Flag | Set when |
| --- | --- |
| `[VERIFIED]` | Every source is `[VERIFIED]`. Rare. Expect this only for process requirements sourced from `domain/`. |
| `[UNVERIFIED]` | Any source is `[UNVERIFIED]`. **This is the normal case.** |
| `[CONFLICT]` | A source's `conflicts_with` is non-empty, or the topic has a stub (`<module>/<topic>-INDEX.md`). Name every candidate in the block. Do not pick a winner. |
| `[OPEN]` | No source supports it. The block states the question and nothing else — no fields, no endpoints, no schema. |

Never rewrite a `[CONFLICT]` requirement as a clean single statement by merging the
candidates. A merge invents a specification that none of the documents contains, and it
reads as competence.

---

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-###` |
| Intent | `.ai/aidlc/SCRUM-###/intent.md`, captured `YYYY-MM-DD` |
| Elaborated on | `YYYY-MM-DD` |
| Vault state at elaboration | *N files; six `domain/` files verified; N entries open in `gaps.md`* |
| Open questions raised by this spec | *N, all in §12* — or `none` |
| Rules consulted | *list the `.ai/claude/contexts/*.md` files that bind this feature* |

## 1. Requirements ledger

One row per requirement. This table is what a reviewer reads first — it must make the
unsourced and conflicted requirements impossible to miss.

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | | schema / api / web / mobile / shared | `[UNVERIFIED]` | `<module>/…` | no |
| REQ-02 | | | `[OPEN]` | none | **yes** |

Counts: `N` total — `N` verified, `N` unverified, `N` conflicted, `N` open.

## 2. Requirements

Repeat this block per requirement. Keep the field order.

### REQ-01 — <title> `[UNVERIFIED]`

- **Statement:** *one sentence, in the behavior's own terms. What the system does, not how.*
- **Surface:** schema / api / web / mobile / shared *(more than one is fine)*
- **Sources:**
  - `<module>/<path>.md` — `[UNVERIFIED]` — kind: vault — *what it actually says, in one
    line. Quote if the wording matters.*
  - `SCRUM-###` — `[UNVERIFIED]` — kind: jira — *what the ticket states.*
- **Conflict:** none — *or* — `gaps.md#<anchor>`; candidates: `<module>/a.md` (N KB,
  `YYYY-MM-DD`), `<module>/b.md` (N KB, `YYYY-MM-DD`). *State plainly that none is verified
  and that this spec does not choose between them.*
- **Open question:** none — *or* — *the one-line-answerable question*, logged at
  `gaps.md#<anchor>`
- **Acceptance:** *how a reviewer checks this is done. Concrete enough to fail.*
- **Notes for the executor:** *e.g. which existing component/service to reuse; which rule
  file governs it. `NOT SPECIFIED` is allowed.*

### REQ-02 — <title> `[OPEN]`

- **Statement:** `OPEN — the intent asks for <X>; no source in the vault, Jira or the repo
  specifies <the undecided part>.`
- **Surface:**
- **Sources:** none — *list what you searched and what it did not settle. "Nothing written"
  is a finding, and the search that produced it is part of the record.*
- **Conflict:** n/a
- **Open question:** *the question*, logged at `gaps.md#<anchor>`
- **Acceptance:** `OPEN — cannot be stated until the question above is answered.`
- **Notes for the executor:** *the smallest change that does not depend on the unknown, if
  one exists, explicitly labelled a workaround. Otherwise `blocked`.*

> An `[OPEN]` block contains no field list, no endpoint, no schema and no copy. Anything
> concrete written under an open question will be built as though it were decided.

## 3. Data model — `apps/api/prisma/schema.prisma`

- **Schema change required:** yes / no
- **Migration required:** yes / no — *if yes: `pnpm db:migrate`, committed under
  `apps/api/prisma/migrations/`. Mandatory, not optional (`.ai/claude/contexts/prisma.md`).*
- **Data backfill required:** yes / no / `NOT SPECIFIED`

```prisma
// New / changed models. Follow the Identity Convention:
//   id String @id @default(uuid()) @db.Uuid           — PK is always the UUID
//   tenantCompanyId String @map("tenant_company_id") @db.Uuid
//   <code>Field String @map("<code>_field") @db.VarChar(50)   — e.g. CUST-00001
//   @@unique([tenantCompanyId, <codeField>], name: "uq_<table>_tenant_code")
//   @@index([tenantCompanyId], name: "idx_<table>_tenant_company_id")
//   @@map("<snake_case_plural>")
```

| Model | Code field | Prefix | Minted via | Source |
| --- | --- | --- | --- | --- |
| | | `XXXX-#####` | `entity_sequences` (`SequenceRepository.getNextValue`) | REQ-nn |

- **New prefix introduced:** yes / no — *a new prefix is a product-visible decision. If no
  source names it, it is `[OPEN]`, not a naming choice for the executor.*
- **Child relations:** *FKs reference the parent UUID `id`, never the business code.*
- **Fields whose type/precision no source states:** *list them as `NOT SPECIFIED` rather
  than choosing. Money is `Decimal` with precision; dates are `@db.Timestamptz`.*

## 4. API surface — `apps/api`

Layering is `presentation → usecase → service → orm`, never upward.

| Method | Route | Presentation | Use-case | Repository | Req |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/api/v1/<feature>/:<code>` | `<feature>.controller.ts` | `<feature>.service.ts` | `<feature>.repository.ts` | REQ-nn |

Per endpoint:

- **Request DTO:** `create-<feature>.dto.ts` — *fields + `class-validator` rules*
- **Response shape:** *JSON, or `NOT SPECIFIED`*
- **Guards / roles:** `AccessTokenGuard` (global) + `@Roles(...)` / `@Public()`
- **Route param identity:** *business code on the boundary; resolve `(tenant, code) → id`
  once in the service, then operate by UUID*
- **Errors:** *status + message per failure case, or `NOT SPECIFIED`*
- **Module registration:** *new module registered in `app.module.ts`; barrel `index.ts` in
  every folder*

## 5. Web surface — `apps/web`

**Feature-first, not atomic design.** Most work lands in `src/features/<feature>/`;
`components/` is a shared library across nine directories. Features may import from
`components/`; `components/` must not import from `features/`. Search all of `ui/`, `base/`,
`atoms/`, `molecules/` and `patterns/` before creating anything — `ui/` has the most
consumers. Detail in `.ai/claude/contexts/web.md`.

- **Routes:** `/<feature>`, `/<feature>/create`, `/<feature>/<code>`, `/<feature>/<code>/edit`
- **Existing components to reuse** *(checked before proposing anything new — mandatory)*:
  `PageHero`, `PageHeroButton`, `PageHeroStat`, `StatusBadge`, `SectionCard`, `Field`,
  `InfoRow`, `SectionTabs`, `WorkspaceTable`, `useWorkspaceTableControls`, `CommonTable`
- **New components proposed:** *name + layer + why nothing existing fits. An empty list is
  the good outcome.*
- **Table (if any):** `standardizeDesktopColumns`, column roles
  (`leading-fixed | data | trailing-fixed`), `renderRow(row, layout)`
  - `searchPlaceholder` — *must enumerate every searchable field*
  - `filters` / `filterValues` / `onFilterChange`
  - `emptyFilterStateMessage`, `unfilteredItemCount`
- **Forms:** react-hook-form + Zod v4. No top-of-form validation summary; failed submit
  scrolls and focuses the first invalid input; multi-step forms navigate to the invalid
  step first; state clears the moment the input becomes valid.
- **Server state:** TanStack Query v5 — *query keys + invalidation on mutate*
- **Colors / spacing:** CSS variables from `theme.css` only. No hardcoded colors.
- **Responsive:** mobile-first; 44px touch targets
- **Copy:** *exact strings, or `NOT SPECIFIED` — do not write UI copy no source implies*

## 6. Mobile surface — `apps/mobile`

- **Screens / routes:** *Expo Router paths*
- **Components:** *reused from `components/`; tokens from `theme/tokens.ts`*
- **Offline / sync behavior:** *or `NOT SPECIFIED` — this is a frequent silent gap in
  field-ops requirements and must not be inferred from how the web app behaves*
- **Touch targets:** 48px
- **Push / notifications involvement:** *catalog entry + `notify()` call site, or `N/A`*

## 7. Shared package — `packages/shared`

- **Types added / changed:** *these are consumed by both web and mobile*
- **Nothing shared:** `N/A — <reason>`

## 8. Permissions and tenancy

- **Roles permitted:** *per REQ*
- **Roles denied:**
- **Tenant isolation:** *standard middleware injection, or state the exception*
- **Cross-tenant reads:** none / *justify*

## 9. Validation rules

| Field | Rule | Source | Flag |
| --- | --- | --- | --- |
| | | `SCRUM-###` / `<module>/…` | `[UNVERIFIED]` |
| | `NOT SPECIFIED` — *no source states a limit* | — | — |

Invented validation is still invention. A max length nobody wrote down is `NOT SPECIFIED`.

## 10. Tests

| Level | What it proves | Req |
| --- | --- | --- |
| Unit | | |
| Integration (API) | | |
| E2E / manual script | | |

- Requirements with no testable acceptance criterion: *list them — this is usually the
  same list as the `[OPEN]` ones*

## 11. Non-functional

- **Performance:** *or `NOT SPECIFIED`*
- **Concurrency:** *e.g. code minting under concurrent creates*
- **Audit / activity log:** *`ActivityLog` entries, or `N/A`*
- **Migration/rollout order:** *e.g. schema → API → web → mobile, behind what*

## 12. Open questions — the stop-and-ask list

**The elaborator stops here.** Nothing below is built until these are answered.

**This section is the ticket's gaps register — there is no separate `gaps.md` in a ticket
folder.** Every question this ticket raised lives here, with the search that produced it, and
stays here when it is answered: mark it resolved and point at the decision note, so the
question and its answer are read together. `.ai/vault/gaps.md` holds only what belongs to no
ticket. To sweep every ticket for what is still open:

```bash
grep -rn '^- \*\*Status:\*\* open' .ai/aidlc/SCRUM-*/spec.md
```

Each question must be answerable in one line by the person named. If it takes a meeting to
answer, it is two questions.

### Q1 — <topic>

- **Question:** *one line, with the options if there are obvious ones*
- **Why it cannot be answered from what is written:** *what you read, and what it did not
  settle*
- **Blocked:** REQ-nn *(and what cannot ship without it)*
- **Candidates:** *every vault file consulted, with size and date — or "none: nothing
  written". This is the search record: it stops the next person repeating it*
- **Owner:** product team / *named person, where a vault open-question names one*
- **Workaround, if any:** *the smallest change that does not depend on the answer,
  explicitly labelled as a workaround*
- **Status:** open *— or* `resolved — see decisions/YYYY-MM-DD-topic.md`

### Q2 — …

## 13. What this spec deliberately does not specify

Anything the intent asked for that no source supports, listed once, plainly. This section
exists so nobody mistakes the spec's silence for the feature's simplicity.

- *thing* — no source; see Q*n*
- *thing* — sources conflict; see REQ-nn and `vault/gaps.md#<anchor>`

## 14. Sign-off before build

- [ ] Every `[OPEN]` requirement is answered, or explicitly deferred by a named person
- [ ] Every `[CONFLICT]` requirement has a decision note in `.ai/vault/decisions/`
- [ ] Answers written back into `spec.md` with their new sources and flags
- [ ] Every §12 question updated to `Status: resolved — see decisions/YYYY-MM-DD-topic.md`
- [ ] Decomposed into vertical units — `units.md`

Answered by: ______________  Date: ______________
