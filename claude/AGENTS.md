# AGENTS.md

> For other AI coding agents. Use @CLAUDE.md for full context.

## Automated Feature Implementation from Design Folder

### Quick Start

User drops design images in `.claude/design/<feature-name>/` and says:

```
"Implement the <feature-name> feature"
```

I automatically:

1. ✅ Read all images from `.claude/design/<feature-name>/`
2. ✅ Parse optional `specs.md` for requirements
3. ✅ Execute multi-agent parallel implementation
4. ✅ Deliver fully functional feature (database → API → UI → tests)

**See**: `.claude/design/README.md` for full folder structure and guidelines

### Feature Folder Structure

```
.claude/design/<feature-name>/
├── overview.png         # Main design (REQUIRED)
├── desktop.png          # Desktop view (optional)
├── mobile.png           # Mobile view (optional)
├── interactions.png     # Hover/focus states (optional)
├── specs.md             # Requirements (optional)
└── assets/              # Icons, images (optional)
    └── *.svg
```

**Example**:

```bash
design/user-profile/
├── overview.png
├── mobile.png
└── specs.md
```

**Request**: `"Implement the user-profile feature"`

### Automated Workflow

When user requests feature implementation:

#### Phase 1: Discovery (Automated)

1. **Detect feature folder**: `.claude/design/<feature-name>/`
2. **Read all images**: Load PNG, JPG, SVG files
3. **Parse specs.md**: Extract requirements, API endpoints, database schema
4. **Extract design specs**: Colors, spacing, typography, components

#### Phase 2: Parallel Agent Execution

Launch 5 agents simultaneously:

**Agent 1: Database Agent** (reads @prisma.md)

```
Input: Database requirements from specs.md
Tasks:
├── Create Prisma schema models
├── Generate migration files (required for every table/column change — commit under `apps/api/prisma/migrations/`)
├── Run migrations
└── Update seed data if needed
Output: Database ready with new tables/columns
```

**Agent 2: API Agent** (reads @api.md)

```
Input: API requirements from specs.md + database schema
Tasks:
├── Create controllers (src/presentation/<feature>/)
├── Create DTOs (validation schemas)
├── Implement use cases (src/usecase/<feature>/)
├── Create repositories (src/service/<feature>/)
└── Register in app.module.ts
Output: RESTful API endpoints with validation
```

**Agent 3: Web UI Agent** (reads @design-system.md, @web.md, @DESIGN.md)

```
Input: Design images + specs.md UI requirements
Tasks:
├── Analyze design (colors, spacing, components)
├── Match colors to CSS variables
├── Map to existing atoms/molecules/organisms
├── Use CommonTable standardized layout for desktop tables (`standardizeDesktopColumns` + role-based columns)
├── List tables: `searchPlaceholder` (all searchable fields), `emptyFilterStateMessage` + `unfilteredItemCount` for filters
├── Create new components if needed (with CVA)
├── Implement responsive layouts (mobile-first)
├── Add interactions (hover, focus, loading, error states)
└── Integrate with API (TanStack Query)
Output: Pixel-perfect responsive UI components
```

**Agent 4: Mobile UI Agent** (reads @mobile.md, @design-system.md)

```
Input: Design images (mobile.png) + specs.md
Tasks:
├── Create Expo screens (app/(tabs)/<feature>/)
├── Implement touch-friendly UI (48px targets)
├── Add native features (camera, gestures)
├── Integrate with API
└── Optimize performance
Output: Mobile-optimized screens
```

**Agent 5: Test & Docs Agent**

```
Input: All agent outputs (API, UI, database)
Tasks:
├── Write API tests (unit + integration)
├── Write UI component tests (React Testing Library)
├── Write E2E tests (Playwright)
├── Update API documentation (Swagger/OpenAPI)
├── Add component JSDoc comments
└── Update README if needed
Output: >80% test coverage + documentation
```

#### Phase 3: Integration & Verification

1. **Run all tests**: Ensure everything passes
2. **Verify design accuracy**: Compare with images (±2px tolerance)
3. **Test responsive breakpoints**: 375px, 768px, 1024px, 1920px
4. **Check dark mode**: Toggle and verify colors
5. **Verify accessibility**: WCAG AA compliance
6. **Report completion**: Summary of what was built

### Agent Communication Protocol

Agents share context via structured files:

1. **`/.agents/task-context.json`** - Shared task state
2. **`/.agents/design-specs.json`** - Design requirements from images
3. **`/.agents/api-contracts.json`** - API endpoint specifications
4. **`/.agents/implementation-log.json`** - Progress tracking

### specs.md Structure

Optional file for additional requirements:

```markdown
# <Feature Name>

## Description

Brief feature description

## User Stories

- As a user, I want to...

## API Requirements

### GET /api/<endpoint>

Response schema...

## Database Changes

### New Tables

Prisma schema...

### Schema Updates

Fields to add...

## Design Specifications

### Colors

Brand colors...

### Components

Reuse existing components...

## Permissions

Role requirements...

## Validation Rules

Business rules...

## UI Requirements (list tables)

- `searchPlaceholder`: list every searchable field (`Search by …`)
- `emptyFilterStateMessage` + `unfilteredItemCount` when select filters apply
- Prisma migration required for any new/changed table columns

## Test Scenarios

Critical test cases...
```

## Multi-Agent Workflow (General)

### Parallel Task Execution

For complex features requiring multiple independent tasks, use **parallel agent execution**:

**Agent Types**:

1. **Design Agent** - Implements UI from design images (reads @design-system.md)
2. **API Agent** - Creates backend endpoints (reads @api.md)
3. **Database Agent** - Handles schema changes (reads @prisma.md)
4. **Test Agent** - Writes tests for components/APIs
5. **Documentation Agent** - Updates docs and comments

**Workflow Pattern**:

```
User Request: "Add user profile management feature"
├── Agent 1: Database Schema (profiles table, migrations)
├── Agent 2: API Endpoints (CRUD operations, validation)
├── Agent 3: UI Components (profile form, profile view)
├── Agent 4: Mobile UI (profile screen in Expo)
└── Agent 5: Tests (API tests, UI tests)
```

### Design Implementation Agent

When implementing from design images:

**Input**: Design image URL or file path
**Process**:

1. Analyze design (colors, spacing, components, layout)
2. Match colors to CSS variables in `theme.css`
3. Map to existing atomic components (atoms → molecules → organisms)
4. Identify responsive breakpoints from design
5. Implement using reusable components only
6. Verify pixel-perfect accuracy (±2px tolerance)

**Output**: Production-ready components using design system

**See**: @design-system.md for full implementation rules

## Critical: ID Convention (Multi-Tenant UUID PKs)

Business entities have BOTH a UUID primary key and a per-tenant prefixed business code.
The code is unique per tenant, not globally — two tenants can each have `QUOT-00001`.

Affected models (PK = `id String @id @default(uuid()) @db.Uuid`, code = `@@unique([tenantCompanyId, <code>])`):

| Model                   | Business code field             |
| ----------------------- | ------------------------------- |
| `Customer`              | `customerCode` (`CUST-00001`)   |
| `Quotation`             | `quoteNo` (`QUOT-00001`)        |
| `Yard`                  | `yardId` (`YARD-00001`)         |
| `JobSite`               | `jobSiteCode` (`SITE-00001`)    |
| `Employee`              | `employeeCode` (`EMP-00001`)    |
| `LeaveRequest`          | `requestId` (`LVR-00001`)       |
| `Department`            | `departmentCode` (`DEPT-00001`) |
| `DepartmentRole`        | `roleCode` (`ROLE-00001`)       |
| `BillingCode`           | `billingCodeId` (`BLCD-00001`)  |
| `PriceListing`          | `priceListingId` (`PRLT-00001`) |
| `BillingCodeCustomType` | `billingCodeCustomTypeId`       |

**Rules**:

- PK is always the UUID `id`. Child FKs (`customerId`, `quotationId`, `employeeId`, ...) are UUIDs.
- Routes and DTOs still take/return the business code (`/customers/:customerCode`). The service layer resolves `code → id` internally; Prisma middleware scopes `findFirst({ where: { code } })` by tenant.
- Use `entity_sequences` (already tenant-scoped) to mint new codes.
- `Attachment.featureId` and `ActivityLog.entityId` remain polymorphic business codes — tenant-isolation still holds through `tenantCompanyId`.
- When creating/updating a child (e.g., Address, Asset, Quotation), accept the parent's code in the DTO, resolve to UUID once in the service, and persist the UUID FK.

## Critical: Form Validation UX Convention (Web)

For all current and future web forms, enforce one common validation behavior:

1. Do not use top-of-form validation summary boxes.
2. On failed submit/save, move to the invalid step/tab (if multi-step) and focus the first invalid field.
3. Ensure the viewport scrolls to the invalid field location before/while focusing.
4. RHF flows: prefer `trigger(..., { shouldFocus: true })` and invalid-submit handlers that route to the right tab.
5. Errors must clear as soon as fields become valid.

## Critical: Web List Tables (CommonTable)

When **adding or editing** a list table (`CommonTable` in `apps/web`):

### Search placeholder (required)

- Set `searchPlaceholder` to enumerate **every field** users can search by (client-side haystack or API query).
- Format: `Search by <field1>, <field2>, or <field3>` — match existing modules (customers, yards, temp employees).
- Keep the placeholder in sync with search logic; if you add a searchable field, update both.

Example: `searchPlaceholder="Search by name, ID, email, phone, or SSN"`

### Filter empty state (required when filters exist)

- Wire `filters`, `filterValues`, and `onFilterChange` on `CommonTable`.
- Set `emptyFilterStateMessage` when select filters can hide all rows — a specific message naming the filter (not the generic empty list message).
- Pass `unfilteredItemCount` for client-filtered lists so the table distinguishes **no records** vs **no matches for current filters** (omit for server-side-only filtering).
- Long filter labels (e.g. `Employment Status`): use `className: 'w-64'` (or wider) on the select filter config.

Example:

```tsx
emptyFilterStateMessage="No temp employees match the selected employment status. Try a different status or clear the filter."
unfilteredItemCount={employees.length}
```

### Database migrations (required for schema/table changes)

- Any new or changed Prisma model/table/column/index used by the table **must** ship with a migration in `apps/api/prisma/migrations/`.
- Run `pnpm db:migrate` with a descriptive name and commit the generated SQL with the feature — never merge schema-only changes without a migration file.
- See `apps/api/prisma/MIGRATION_BASELINE.md` and `.claude/rules/prisma.md`.

## Project Skills (all providers)

Canonical skill definitions live in `.claude/skills/<name>/SKILL.md` ([Agent Skills spec](https://agentskills.io)). After clone, run `pnpm setup:agents` to link them for Cursor (`.cursor/skills/`), Claude Code (`.claude/skills/`), Codex (`.codex/skills/`), and Antigravity (`.agent/skills/`).

| Skill         | Trigger                                           | Path                                  |
| ------------- | ------------------------------------------------- | ------------------------------------- |
| `commit`      | User asks to commit or write a commit message     | `.claude/skills/commit/SKILL.md`      |
| `debug-api`   | API errors, failed endpoints, guard/Prisma issues | `.claude/skills/debug-api/SKILL.md`   |
| `new-feature` | New backend/web feature module                    | `.claude/skills/new-feature/SKILL.md` |
| `review-pr`   | PR review, diff review, pre-merge check           | `.claude/skills/review-pr/SKILL.md`   |

When a matching task appears, read the skill file and follow its instructions. Do not rely on provider-specific fields — instructions are provider-neutral.
