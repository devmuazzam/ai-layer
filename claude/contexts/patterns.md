# Pattern registry — one way to build each recurring thing

**Same job, same build.** When a feature repeats a shape that already exists elsewhere — a
CRUD, a reference-code list, an archive flow — it is built the way that shape's **reference
implementation** is built, not the way the nearest neighbour happens to be built.

Every entry here is **decided by a developer** and edited by **Haris only** (tooling rule —
root `CLAUDE.md` → _Tooling is Haris-only_). An AI never picks a reference, never edits this
file, and never treats the nearest module as the reference because no entry exists.

## How an agent uses this file

1. **Building something that matches an entry?** Follow its reference. A deviation is a
   developer decision (root `CLAUDE.md` → _Developers decide structure_), recorded with its
   reason — never a silent improvement.
2. **The entry says `UNDECIDED`?** Stop before writing the structure. Show the developer the
   variants below with their trade-offs, ask which one this feature follows, and record the
   answer as a developer decision. Do not choose "the cleanest one".
3. **No entry fits, but the thing will clearly repeat?** Say so, and propose an entry to the
   developer. Haris adds it.
4. **Changing an instance of a pattern?** The other instances are its **siblings**. Name them,
   ask the developer whether they get the same change, and apply it in the same PR on a yes
   (root `CLAUDE.md` → _Siblings get the same change — with the developer's say-so_).

The **Known deviations** list under each entry is consistency debt. Do not fix it in passing
inside an unrelated ticket; it is sibling work and needs the developer's yes like any other.

---

## P1 — Business-entity CRUD (coded, archivable)

Entities with a minted business code, list/detail/create/edit, archive and unarchive.

**Reference — decided by Haris, 2026-10-09:**

- **API: `manufacturers`** (Variant A) — `apps/api/src/presentation/manufacturers/`,
  `usecase/manufacturers/`, `service/manufacturers/`.
- **Web: `agencies`** (W1) — `apps/web/src/features/agencies/` (`schemas/`, `api/`,
  `hooks/`, `views/`, `components/`).

Copy their shape, not their known deviations below — `agencies`' `data as any` (API) and
the `manufacturers` web screen (W1b) are **not** part of the reference.

The variants as surveyed on 2026-10-09:

| Layer | Variant | Modules | Shape |
| --- | --- | --- | --- |
| API | **A** | yards, manufacturers, agencies, vendors, departments, customers | All four layers; repository extends `BaseRepository`; class-validator DTOs; code minted with `SequenceRepository.getNextValue`; code is the route key; `POST :code/archive` / `:code/unarchive` set `archivedAt`; `DELETE` is a hard delete guarded by `DeletionReferenceService`; list returns `{data,total,page,limit}`; `ArchiveReferenceService` + `ArchivedNameConflictService` |
| Web | **W1** | yards, agencies, vendors | `views/<feature>.tsx` switches list/detail/create/edit on pathname; `WorkspaceTable` + `useWorkspaceListQueryState` + `useWorkspaceTableControls`; React Query key factory over an api object on `@/lib/base-api`; full-page react-hook-form + `formZodResolver`; `ConfirmDeleteModal` / `BulkActionConfirmDialog` |

Every other module in the table is a **sibling**: a change to the reference's shape is
offered to them (root `CLAUDE.md` → _Siblings get the same change_).

**Known deviations:**
- `formatInternalId` is copied into each Variant A usecase instead of shared.
- yards keeps both `status` (INACTIVE) and `archivedAt`, and a legacy `{items,total}` list.
- agencies returns `data as any`.
- manufacturers web: create/edit live in `app/(protected)/asset-management/parts/manufacturers/create/page.tsx` with a `useState` form, not react-hook-form (**W1b**).

## P2 — Reference-code list (admin lookup table)

Small admin-maintained lists — a code the user types, a label, active/inactive, a picker.

**Reference — decided by Haris, 2026-10-09:**

- **API: `industries`** (Variant C) — `apps/api/src/presentation/industries/`,
  `usecase/industries/`, `service/industries/`: repository extends `BaseRepository` and wraps
  `utility/reference-code-list.helpers.ts`. **Open:** its controller is unversioned
  (`@Controller('industries')`) while the Variant B modules use `version: '1'` — whether a new
  P2 module copies that is not decided; ask the developer, record it, and Haris updates this
  line.
- **Web: the shared manager** (W2) — `apps/web/src/features/settings/views/reference-code-manager.tsx`
  with a ~40-line tab like `industry-codes-tab.tsx`, over `createReferenceCodeService` and the
  hook factories in `features/employee-reference-codes/`. A new reference list is a new tab,
  never a new manager.

**Variant B (no `service/` layer) is not to be copied** — it breaks the layering rule.

The variants as surveyed on 2026-10-09:

| Layer | Variant | Modules | Shape |
| --- | --- | --- | --- |
| API | **B** | quotation-loss-reasons, expense-gl-accounts, employee-union-codes, employee-work-comp-codes, employee-craft-codes, employee-certificates (partly) | **No `service/` layer** — usecase (and the controller, for the public list) inject `PrismaService`; routed by `:id`; `GET /` picker, `GET /admin` list; `DELETE :id` soft-archives to `status: INACTIVE`; `findReferenceCodesPaginated` from `utility/reference-code-list.helpers.ts`; private `mapWriteError` copied per service |
| API | **C** | industries | Same contract as B, **with** a repository extending `BaseRepository` that wraps the reference-code helpers — the only P2 module that respects the layers. Not versioned (`@Controller('industries')`) |
| Web | **W2** | industry-codes, union-codes, work-comp-codes, expense-gl-accounts, certificates tabs | One shared `features/settings/views/reference-code-manager.tsx`; ~40-line tab per entity; `createReferenceCodeService('/path')` + `use{Create,Update,Archive}ReferenceCodeMutation` factories |

The Variant B modules, loss reasons' forked tab and the craft-codes screen are **siblings
carrying consistency debt** (below): bring them to the reference as their own tickets, with
a developer's yes — never in passing.

**Known deviations:**
- Every Variant B module skips the `service/` layer and injects Prisma into the controller.
- Web loss reasons — `features/settings/views/loss-reasons-tab.tsx` (578 lines) is a fork of
  the shared manager, with its service and hooks in `features/quotations/`, outside the factory.
- craft-codes — API hybrid (repository not extending the base, usecase also calls
  `this.prisma`); web **W3** master/detail cards with a hand-built `useState` form, no
  `WorkspaceTable`.
- `features/settings/views/craft-codes-tab.tsx` is imported by no route and targets the old
  `/employee-craft-codes` endpoint.
- industries has two hook files: `use-industries.ts` and `use-industry-codes.ts`.

## Shared building blocks that already exist — reuse before writing your own

| Need | Use | Adoption today |
| --- | --- | --- |
| A repository | `orm/repository/base.repository.ts` — its doc says every repository extends it | 31 of 80 do (counted 2026-10-09) |
| Paginated reference-code list | `utility/reference-code-list.helpers.ts` | the P2 modules, industries, craft-codes, certificates |
| A business code | `service/sequences/sequence.repository.ts` → `getNextValue` | Variant A, billing-code-custom-types |
| Archive guards | `ArchiveReferenceService`, `ArchivedNameConflictService` | ~20 usecases |
| A list table (web) | `components/templates/workspace-table.tsx` + its hooks | 79 files reference it; no other list table is in use |
| Reference-code web service/hooks | `createReferenceCodeService` + the hook factories | 6 entities |

No code generator exists (no `generators` in `nx.json`, no plop/hygen). Until one does, the
reference implementation **is** the template.
