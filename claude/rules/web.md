---
paths:
  - 'apps/web/**/*.tsx'
  - 'apps/web/src/components/templates/**'
---

# Web UI Rules

## List tables (`CommonTable`)

When **adding or editing** a list table in `apps/web`:

### Search placeholder (required)

- Set `searchPlaceholder` on `CommonTable` to enumerate **every field** users can search by.
- Format: `Search by <field1>, <field2>, or <field3>` (see customers, yards, temp employees).
- Keep placeholder text in sync with search implementation (client `haystack` string or API query params).

```tsx
searchPlaceholder = 'Search by name, ID, email, phone, or SSN';
```

### Filter empty state (required when filters exist)

- Provide `filters`, `filterValues`, and `onFilterChange`.
- Set `emptyFilterStateMessage` when select filters can yield zero rows — use copy that names the filter, not the generic empty list message.
- Pass `unfilteredItemCount` for **client-side** filtered lists so the table can distinguish no data vs filtered-out (omit for server-only filtering).
- Long filter labels: add `className: 'w-64'` (or wider) on the select filter config.

```tsx
filters={[{ type: 'select', key: 'status', label: 'Employment Status', className: 'w-64', options: [...] }]}
filterValues={{ status: statusFilter }}
onFilterChange={(_key, value) => setStatusFilter(value)}
emptyFilterStateMessage="No temp employees match the selected employment status. Try a different status or clear the filter."
unfilteredItemCount={employees.length}
```

### Database migrations (required for schema changes)

- New or edited Prisma models/columns/indexes for the entity **must** include a migration under `apps/api/prisma/migrations/`.
- Run `pnpm db:migrate` with a descriptive name; commit the generated SQL with the feature.
- UI-only table changes with no schema change do not need a migration.

See @.claude/rules/prisma.md and `apps/api/prisma/MIGRATION_BASELINE.md`.

### Layout (required)

- Use `standardizeDesktopColumns`, column `role` (`leading-fixed` | `data` | `trailing-fixed`), and `renderRow(row, layout)`.
- Do not hardcode per-row desktop width classes for header/body alignment.
