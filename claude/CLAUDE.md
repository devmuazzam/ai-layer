# TCG Monorepo

> Crane rental platform: NestJS API + Next.js Web + Expo Mobile + Shared package

## Stack

| App    | Path               | Stack                                | Port |
| ------ | ------------------ | ------------------------------------ | ---- |
| API    | `apps/api/`        | NestJS 10 + Prisma 5 + PostgreSQL    | 3000 |
| Web    | `apps/web/`        | Next.js 16 + Tailwind v4 + shadcn/ui | 3001 |
| Mobile | `apps/mobile/`     | Expo SDK 54 + Expo Router v6         | 8081 |
| Shared | `packages/shared/` | Pure TypeScript                      | -    |

## Commands

```bash
pnpm install              # Install deps
pnpm api:dev              # API dev server
pnpm web:dev              # Web dev server
pnpm mobile:start         # Expo dev server
pnpm db:migrate           # Create + run migration
pnpm db:studio            # Prisma Studio
pnpm lint && pnpm build   # Quality checks
```

## Automated Feature Implementation

**Quick Start**: Drop design images in `.claude/design/<feature-name>/` and say:

```
"Implement the <feature-name> feature"
```

**Process**:

1. ✅ Automatically reads all design images from folder
2. ✅ Parses optional `specs.md` for requirements
3. ✅ Implements full stack: Database → API → Web UI → Mobile UI → Tests
4. ✅ Follows all design system rules and coding standards

**See**: `.claude/design/README.md` for detailed guidelines, folder structure, and examples

## Architecture

**API Clean Architecture** (never import upward):

```
Presentation → Use-Case → Service → ORM
src/presentation/  Controllers, DTOs
src/usecase/       Business logic
src/service/       Repositories
src/orm/           PrismaService
```

**Web Atomic Design** (never import upward):

```
Atoms → Molecules → Organisms → Templates → Pages
```

## Naming Conventions

| Type       | Convention                        | Example                 |
| ---------- | --------------------------------- | ----------------------- |
| Files      | `kebab-case`                      | `access-token.guard.ts` |
| Classes    | `PascalCase`                      | `AuthService`           |
| Functions  | `camelCase`                       | `signUp`                |
| Constants  | `UPPER_SNAKE`                     | `JWT_SECRET`            |
| DB columns | `snake_case` via `@map()`         | `password_hash`         |
| DB tables  | `snake_case` plural via `@@map()` | `users`                 |

## Identity Convention (CRITICAL — Multi-Tenant UUID PKs)

Every business entity has two identifiers: a surrogate UUID primary key and a per-tenant
prefixed business code. The business code is NOT the PK — it is unique only within a tenant.

| Model                   | UUID PK (`@id`) | Per-tenant code (unique)  | Example      |
| ----------------------- | --------------- | ------------------------- | ------------ |
| `Customer`              | `id` (uuid)     | `customerCode`            | `CUST-00001` |
| `Quotation`             | `id` (uuid)     | `quoteNo`                 | `QUOT-00001` |
| `Yard`                  | `id` (uuid)     | `yardId`                  | `YARD-00001` |
| `JobSite`               | `id` (uuid)     | `jobSiteCode`             | `SITE-00001` |
| `Employee`              | `id` (uuid)     | `employeeCode`            | `EMP-00001`  |
| `LeaveRequest`          | `id` (uuid)     | `requestId`               | `LVR-00001`  |
| `Department`            | `id` (uuid)     | `departmentCode`          | `DEPT-00001` |
| `DepartmentRole`        | `id` (uuid)     | `roleCode`                | `ROLE-00001` |
| `BillingCode`           | `id` (uuid)     | `billingCodeId`           | `BLCD-00001` |
| `PriceListing`          | `id` (uuid)     | `priceListingId`          | `PRLT-00001` |
| `BillingCodeCustomType` | `id` (uuid)     | `billingCodeCustomTypeId` | `BCCT-00001` |

**Rules**:

- PK = `id String @id @default(uuid()) @db.Uuid` — never the business code.
- The business code column is `@@unique([tenantCompanyId, <codeField>])` (NOT globally unique).
- Child tables reference the parent via the UUID `id` (`customerId`, `quotationId`, etc.) — never by code.
- Prisma middleware injects `tenantCompanyId` on reads/writes; code-only lookups (`findFirst({ where: { customerCode } })`) are tenant-scoped automatically.
- Routes and DTOs keep using the business code for UX (e.g., `/customers/:customerCode`). The service layer resolves `(tenantCompanyId, code) → id` once, then operates by UUID.
- `Attachment.featureId` and `ActivityLog.entityId` stay as business codes (polymorphic); isolation still holds via the tenant scope.
- Use `entity_sequences` (tenant-scoped) to mint new codes.
- Two tenants may both own `QUOT-00001` — they are distinct rows with distinct UUIDs.

## Import Aliases

**API**: `@orm/*`, `@presentation/*`, `@usecase/*`, `@service/*`, `@config/*`, `@guard/*`, `@decorator/*`, `@strategy/*`, `@utility/*`

**Web/Mobile**: `@/*` → `./src/*`, `@tcg/shared` → `../../packages/shared/src`

## Auth System

JWT dual-token: Access (15m) + Refresh (7d, bcrypt-hashed in DB)

- Guards: `AccessTokenGuard` (global), `RolesGuard` (global), `RefreshTokenGuard` (explicit)
- Decorators: `@Public()` opt-out, `@Roles(Role.ADMIN)` restrict

## Frontend Patterns

- **State**: TanStack Query v5 (server), React Context (auth)
- **Forms**: react-hook-form + Zod v4
- **Routes**: URL-driven states (`/create`, `/<id>`, `/<id>/edit`)
- **Styling**: Tailwind + CVA + `cn()` utility
- **Touch targets**: 44px web, 48px mobile

## Form Validation UX Standard (MANDATORY)

Apply these rules to all existing and future web forms:

1. Do not render top-of-form validation summary boxes.
2. Failed save/submit must scroll and focus directly to the first invalid input.
3. Multi-step/tab forms must navigate to the invalid step/tab before focusing the field.
4. RHF forms must validate with `trigger(..., { shouldFocus: true })` or equivalent focused submit handling.
5. Validation state must clear immediately when inputs become valid (no extra submit required).

## Web UI Rules

1. **Component Reusability (CRITICAL)**: ALWAYS check `atoms/`, `molecules/`, `organisms/` before creating new components
2. **Centralized Colors (MANDATORY)**: Use CSS variables from `theme.css` - NO hardcoded colors
3. **Responsive design**: Mobile-first with Tailwind breakpoints (sm, md, lg, xl)
4. **CVA variants**: All reusable components use `class-variance-authority`
5. Responsive action buttons pattern:

```tsx
<div className="flex w-full flex-col gap-2 sm:w-auto sm:flex-row sm:gap-3">
  <SecondaryButton className="h-10 w-full justify-center sm:w-auto">...</SecondaryButton>
  <PrimaryButton className="h-10 w-full justify-center sm:w-auto">...</PrimaryButton>
</div>
```

6. Keep existing gradients unless explicitly asked to change
7. Use existing status/badge variants
8. **Theme Configuration**: Use `@/lib/theme.ts` for accessing theme variables in TypeScript
9. **Table Alignment (MANDATORY)**: For desktop tables, use `CommonTable` with `standardizeDesktopColumns`, role-based columns (`leading-fixed | data | trailing-fixed`), and `renderRow(row, layout)` helpers. Do not hardcode per-row desktop width classes for header/body alignment.
10. **Table search placeholder (MANDATORY)**: `searchPlaceholder` must list every searchable field (`Search by name, code, email, …`). Keep it in sync with client/API search logic.
11. **Table filter empty state (MANDATORY)**: When using select filters, set `emptyFilterStateMessage`, `unfilteredItemCount` (client-filtered lists), and a filter-specific message when nothing matches the selected filter.
12. **Table schema migrations (MANDATORY)**: New or edited Prisma tables/columns for a list feature require a committed migration under `apps/api/prisma/migrations/` (`pnpm db:migrate`). See @.claude/rules/web.md and @.claude/rules/prisma.md.
13. **Workspace page patterns (MANDATORY)**: Build list/detail/form pages from the shared workspace components — `PageHero` (+ `PageHeroButton`/`PageHeroStat`) for headers, `StatusBadge` pills inline in the hero title, `SectionCard` + `Field`/`InfoRow` for section bodies, `SectionTabs` for in-page tabs (wrap hero + tabs + content in an inner `flex w-full flex-col gap-6`), and `WorkspaceTable` + `useWorkspaceTableControls` for data tables. Do not hand-roll headers, cards, label/value rows, tabs, or `FormLayout`/`PageHeader` headers. See @.claude/rules/design-system.md → "Workspace Page Patterns".

## Feature Checklist

New feature:

1. `src/presentation/<feat>/` - Controller + DTOs
2. `src/usecase/<feat>/` - Service + Module
3. `src/service/<feat>/` - Repository
4. Prisma model + `pnpm db:migrate`
5. Register in `app.module.ts`
6. Barrel exports (`index.ts`) everywhere

## Code Quality

- Strict TypeScript, no `any`
- Named exports only (except Next.js pages)
- ESLint + Prettier + Husky pre-commit
- JSDoc on public APIs
- Section headers: `// ─── Section ────────────────────────────`

## Links

- @.claude/rules/api.md - API patterns
- @.claude/rules/web.md - Web/UI patterns
- @.claude/rules/prisma.md - Database patterns
- @.claude/rules/design-system.md - Centralized theming, component reusability
- @.claude/DESIGN.md - Design implementation from images guide
- @.claude/AGENTS.md - Multi-agent workflow for parallel tasks
- @.claude/AUTOMATED-FEATURES.md - Automated feature implementation guide
- @.claude/QUICK-REFERENCE.md - Quick reference card for common tasks
- @.claude/design/README.md - Design folder usage guide
