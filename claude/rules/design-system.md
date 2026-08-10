---
paths:
  - 'apps/web/**/*.tsx'
  - 'apps/web/**/*.css'
  - 'apps/mobile/**/*.tsx'
---

# Design System Rules

## Centralized Theming

### Color System Architecture

**CRITICAL**: All colors MUST use CSS variables from `apps/web/src/styles/theme.css`.
Changing one variable automatically updates the entire application.

```css
/* ✅ CORRECT - Uses centralized theme variable */
<div className="bg-[var(--color-bg-primary)] text-[var(--color-text-primary)]" />

/* ❌ WRONG - Hardcoded color */
<div className="bg-white text-black" />
<div style={{ backgroundColor: '#ffffff' }} />
```

### Theme Variable Categories

1. **Background Colors**: `--color-bg-*`
   - `--color-bg-primary` - Main background
   - `--color-bg-secondary` - Secondary background
   - `--color-bg-brand-solid` - Brand primary color
   - `--color-bg-error-primary` - Error states
   - `--color-bg-success-primary` - Success states

2. **Text Colors**: `--color-text-*`
   - `--color-text-primary` - Primary text
   - `--color-text-secondary` - Secondary text
   - `--color-text-tertiary` - Tertiary text
   - `--color-text-error-primary` - Error text

3. **Border Colors**: `--color-border-*`
   - `--color-border-primary` - Primary border
   - `--color-border-brand` - Brand border
   - `--color-border-error` - Error border

4. **Utility Colors**: `--color-utility-*`
   - Brand: `--color-utility-brand-{50-900}`
   - Neutral: `--color-utility-neutral-{50-900}`
   - Status: `blue`, `red`, `green`, `yellow`, `orange`

### Dark Mode Support

All color variables automatically adjust for dark mode via `.dark-mode` class.

```tsx
// ✅ Automatically works in light/dark mode
<div className="bg-[var(--color-bg-primary)]" />
```

## Component Reusability (MANDATORY)

### Atomic Design Hierarchy

```
apps/web/src/components/
├── atoms/              Base primitives (Button, Input, Badge)
│   ├── buttons/
│   ├── inputs/
│   └── badges/
├── molecules/          Simple composites (FormField, SearchBar)
│   ├── forms/
│   └── cards/
├── organisms/          Complex sections (DataTable, Header, Sidebar)
│   ├── tables/
│   └── navigation/
├── templates/          Page layouts (DashboardLayout, FormLayout)
│   └── layouts/
└── features/           Feature-specific components
    └── <feature>/
        ├── components/
        └── views/
```

**Import Rule**: NEVER import from higher levels:

- Atoms: Import nothing (pure primitives)
- Molecules: Import atoms only
- Organisms: Import atoms + molecules only
- Templates: Import atoms + molecules + organisms
- Features: Import any (feature-isolated)

### Component Creation Checklist

Before creating a new component, check:

1. ✅ Does similar component exist in `atoms/`, `molecules/`, or `organisms/`?
2. ✅ Can existing component be extended with new variant?
3. ✅ Is this truly unique, or can CSS customization suffice?

**Rule**: If 70%+ similar component exists, extend it. Don't create duplicate.

### Form Validation Reusability (MANDATORY)

Do not create per-form validation summary widgets. Reuse `FormErrorSummary` from
`apps/web/src/components/organisms/form-error-summary.tsx` for all forms.

Required behavior for all new forms:

1. Top summary messages are single-line and readable.
2. First invalid field is auto-focused/scrolled on failed submit.
3. Error lines can be clicked to focus the related field.
4. RHF forms use `errors` + `fieldLabels`.
5. Custom validation forms use `items`; include `target` selector where needed.
6. Errors clear immediately once valid.

### CVA Variant Pattern (REQUIRED)

All reusable components MUST use `class-variance-authority` (CVA):

```tsx
import { cva, type VariantProps } from 'class-variance-authority';
import { cn } from '@/lib/utils';

const buttonVariants = cva(
  // Base classes (always applied)
  'inline-flex items-center justify-center rounded-lg font-medium transition-colors disabled:opacity-50 disabled:pointer-events-none',
  {
    variants: {
      variant: {
        primary:
          'bg-[var(--color-bg-brand-solid)] text-white hover:bg-[var(--color-bg-brand-solid_hover)]',
        secondary:
          'bg-[var(--color-bg-secondary)] text-[var(--color-text-primary)] hover:bg-[var(--color-bg-secondary_hover)]',
        destructive:
          'bg-[var(--color-bg-error-solid)] text-white hover:bg-[var(--color-bg-error-solid_hover)]',
      },
      size: {
        sm: 'h-9 px-3 text-sm',
        md: 'h-10 px-4 text-base',
        lg: 'h-11 px-5 text-lg',
      },
    },
    defaultVariants: {
      variant: 'primary',
      size: 'md',
    },
  },
);

interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>, VariantProps<typeof buttonVariants> {
  asChild?: boolean;
}

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, ...props }, ref) => (
    <button className={cn(buttonVariants({ variant, size }), className)} ref={ref} {...props} />
  ),
);
Button.displayName = 'Button';
```

### Responsive Design (MANDATORY)

#### Mobile-First Approach

All components MUST be mobile-responsive using Tailwind breakpoints:

```tsx
// ✅ CORRECT - Mobile-first responsive design
<div className="w-full sm:w-auto flex-col sm:flex-row gap-2 sm:gap-4">
```

**Breakpoints**:

- `sm:` - 640px (small tablets)
- `md:` - 768px (tablets)
- `lg:` - 1024px (laptops)
- `xl:` - 1280px (desktops)

#### Touch Target Sizes

- **Web**: Minimum 44px × 44px
- **Mobile**: Minimum 48px × 48px

```tsx
// ✅ Web buttons
<Button className="h-10 min-w-10" /> // 40px base

// ✅ Mobile buttons
<Button className="h-12 min-w-12" /> // 48px (Expo)
```

#### Responsive Action Buttons Pattern

**REQUIRED** for all button groups:

```tsx
<div className="flex w-full flex-col gap-2 sm:w-auto sm:flex-row sm:gap-3">
  <SecondaryButton className="h-10 w-full justify-center sm:w-auto">Cancel</SecondaryButton>
  <PrimaryButton className="h-10 w-full justify-center sm:w-auto">Submit</PrimaryButton>
</div>
```

#### Desktop Table Layout Pattern (REQUIRED)

Use `CommonTable` with standardized desktop columns so headings and body cells always align.

```tsx
<CommonTable
  data={rows}
  columns={[
    { key: 'select', title: '', role: 'leading-fixed' },
    { key: 'name', title: 'Name', role: 'data' },
    { key: 'status', title: 'Status', role: 'data' },
    { key: 'actions', title: '', role: 'trailing-fixed', align: 'right' },
  ]}
  standardizeDesktopColumns
  renderRow={(row, layout) => (
    <div className={layout.rowClassName} style={layout.rowStyle}>
      <div className={layout.getCellClassName('name')} style={layout.getCellStyle('name')}>
        {row.name}
      </div>
    </div>
  )}
/>
```

Rules:

1. Do not hardcode separate desktop widths for header and row cells.
2. Use role-based columns (`leading-fixed | data | trailing-fixed`) for width distribution.
3. Keep mobile layouts separate when needed, but desktop alignment must come from `CommonTable`.

## Workspace Page Patterns (MANDATORY)

Every web module (list, detail, and form pages) MUST be built from the shared
workspace pattern components. These were rolled out across the app to give
Customers, Quotations, Assets, Projects, Jobs, Plans, Employees, Permits, Yards,
Price Listings, Agencies, Vendors, Departments, etc. one consistent look. Do
**not** hand-roll headers, section cards, label/value rows, tabs, or tables.

| Concern | Use this | Import from |
| --- | --- | --- |
| Page header (title, status, breadcrumb, actions, KPIs) | `PageHero` (+ `PageHeroButton`, `PageHeroStat`, `PageHeroKpi`, `HeroTrend`) | `@/components/patterns` |
| Section grouping / card with header | `SectionCard` (or `SectionHeading`, `WorkspaceCard`) | `@/components/patterns` |
| Label/value detail pairs | `Field` (+ `FieldGrid`) or `InfoRow` | `@/components/patterns`, `@/components/molecules` |
| Tabbed sections inside a detail page | `SectionTabs` | `@/components/organisms` |
| Data tables (search, filters, sort, column toggle, row/bulk actions) | `WorkspaceTable` + `useWorkspaceTableControls` | `@/components/templates` |
| Status pill | `StatusBadge` | `@/components/ui` |

### 1) Page headers — `PageHero`

- Use `PageHero` for **all** page headers: list/overview pages use `size="lg"`
  with `title` + `description` + `actions` (+ optional `stats`); detail pages use
  `size="md"` (default) with `icon` + `title` + `breadcrumb` + `onBack` + `actions`.
- Header action buttons MUST be `PageHeroButton` (`variant="primary" | "secondary"`),
  not `PrimaryButton`/`SecondaryButton`.
- KPIs belong **inside** the hero via the `stats` slot (`PageHeroStat` / `PageHeroKpi`),
  not in a separate band below the header.
- Do not reintroduce `FormLayout`/`PageHeader` headers — those have been migrated to `PageHero`.

```tsx
<PageHero
  size="lg"
  title="Customers"
  description="Manage customer accounts and contacts."
  actions={
    <PageHeroButton variant="primary" onClick={onCreate}>
      <Plus className="h-4 w-4" /> New Customer
    </PageHeroButton>
  }
  stats={<PageHeroStat label="Active">{activeCount}</PageHeroStat>}
/>
```

### 2) Status pills (consistent with Quotations)

- Render entity status as a **pill** placed inline inside the `PageHero` `title`,
  and set `status={null}` on `PageHero` to suppress its built-in status dot.
- Use the shared `StatusBadge` (auto-maps `ACTIVE`→green, `INACTIVE`→red,
  `DRAFT`→amber, etc.). Quotations use their domain-specific `QStatusPill`; mirror
  that placement for every other module.

```tsx
<PageHero
  title={
    <span className="flex flex-wrap items-center gap-3">
      <TruncatedValue value={entity.name} />
      <StatusBadge status={statusLabel} />
    </span>
  }
  status={null}
  /* ...icon, breadcrumb, onBack, actions */
/>
```

### 3) Section bodies — `SectionCard` + `Field`/`InfoRow`

- Group page body content in `SectionCard`. Pass `icon`/`iconNode` + `title`
  (+ `description`, `headerRight`) for the icon-tile header; use `heading={false}`
  to drop the outer blue-bar heading when the card already has its own header.
- For tables inside a card, pass `contentPad="p-0"` so the table sits flush.
- Detail label/value pairs MUST use `Field` (`layout="stacked"` for grids via
  `FieldGrid`, `layout="row"` for divider rows) or `InfoRow` (which delegates to
  `Field layout="row"`). Do not hand-roll `dl/dt/dd` or bespoke row markup.

```tsx
<SectionCard icon={User01} title="Contact Info">
  <FieldGrid columns={2}>
    <Field label="Phone" value={customer.phone} />
    <Field label="Email" value={customer.email} />
  </FieldGrid>
</SectionCard>
```

### 4) Tabs — `SectionTabs` + required layout wrapper

- Use `SectionTabs` for in-page tab navigation (do not build custom tab bars).
- **Layout gotcha (REQUIRED):** inside a `min-h-full`/`flex-col` page, wrap
  `PageHero` + `SectionTabs` + tab content in a single inner
  `div className="flex w-full flex-col gap-6"`. Without this wrapper `SectionTabs`
  collapses to near-zero height and the tabs appear "invisible".

```tsx
<div className="flex w-full flex-col gap-6">
  <PageHero {/* ... */} />
  <SectionTabs ariaLabel="Customer sections" value={tab} onChange={setTab} items={items} />
  <div>{renderTabContent(tab)}</div>
</div>
```

### 5) Data tables — `WorkspaceTable`

- New/edited tables use `WorkspaceTable` with `useWorkspaceTableControls` for
  search, sort, column toggle, and selection. Put the create/bulk actions in
  `toolbarActions` and per-row actions in `rowActions` (avoid bespoke per-row buttons).
- Follow the searchPlaceholder / filter empty-state / migration rules in
  @.claude/rules/web.md.

### When a new shared variant is needed

If an existing pattern is ~70% right, extend it with a prop/variant rather than
forking a one-off. Only create a new component when none of the above fit, and
place it under `components/patterns` (workspace) or the right atomic level.

## Design Implementation from Images

### Process

1. **Analysis Phase**
   - Identify all UI elements (buttons, inputs, cards, etc.)
   - Extract color palette (match to existing CSS variables)
   - Measure spacing, sizing, typography
   - Note responsive behavior hints

2. **Component Mapping**
   - Map design elements to existing atoms/molecules
   - Identify needed variants for existing components
   - List truly new components (create only if necessary)

3. **Implementation**
   - Use existing components with appropriate variants
   - Apply custom CSS via `className` prop (Tailwind only)
   - Create new reusable component only if 3+ instances needed

4. **Verification**
   - Compare with design image pixel-perfectly (within 2px tolerance)
   - Test responsive breakpoints (mobile, tablet, desktop)
   - Verify dark mode appearance

### Color Extraction from Design

When implementing from design images:

1. **Identify color in design** (hex, RGB)
2. **Find closest CSS variable** in `theme.css`
3. **Use variable** instead of hardcoding

```tsx
// Design shows #7F56D9 → matches --color-brand-600
// ✅ Use variable
<div className="bg-[var(--color-brand-600)]" />

// ❌ Don't hardcode
<div className="bg-[#7F56D9]" />
```

## Spacing System

Use Tailwind's spacing scale (0.25rem = 4px unit):

```tsx
// ✅ Consistent spacing
<div className="p-4 gap-3 mt-6" /> // 16px, 12px, 24px

// ❌ Arbitrary values (use only when alignment demands it)
<div className="p-[13px]" />
```

## Typography

Use centralized type scale from `theme.css`:

```tsx
// ✅ Using theme variables
<h1 style={{ fontSize: 'var(--text-display-lg)' }}>

// ✅ Or Tailwind utilities
<h1 className="text-4xl">

// ❌ Inline hardcoded sizes
<h1 style={{ fontSize: '40px' }}>
```

## Gradients & Effects

### Maintaining Existing Gradients

**IMPORTANT**: Keep existing gradients unless explicitly asked to change.

If design requires gradient:

1. Check if similar gradient exists in codebase
2. Extract to CSS variable if used 3+ times
3. Document in comments for future reference

```css
/* Custom gradients */
--gradient-brand: linear-gradient(135deg, var(--color-brand-600) 0%, var(--color-brand-500) 100%);
```

## Status/Badge Variants

Use existing status badge system from `atoms/badges/`:

```tsx
<Badge variant="success">Active</Badge>
<Badge variant="error">Error</Badge>
<Badge variant="warning">Pending</Badge>
<Badge variant="info">Info</Badge>
```

**Don't create** new badge variants without checking existing ones first.

## Component Documentation

All new components MUST include:

```tsx
/**
 * PrimaryButton - Main action button component
 *
 * @example
 * <PrimaryButton size="lg" onClick={handleClick}>
 *   Submit Form
 * </PrimaryButton>
 */
```

## Accessibility

All components MUST follow:

1. **Semantic HTML**: Use correct elements (`<button>`, `<nav>`, etc.)
2. **ARIA attributes**: Add `aria-label`, `role`, etc. when needed
3. **Keyboard navigation**: Support Tab, Enter, Escape, Arrow keys
4. **Focus states**: Visible focus ring (`focus-visible:ring-2`)
5. **Color contrast**: WCAG AA minimum (4.5:1 text, 3:1 UI)

```tsx
// ✅ Accessible button
<button
  aria-label="Close modal"
  className="focus-visible:ring-2 focus-visible:ring-[var(--color-focus-ring)]"
>

// ❌ Inaccessible
<div onClick={handleClick}>Click me</div>
```

## CSS Best Practices

1. **Tailwind Only**: No inline styles, no CSS Modules
2. **cn() utility**: Always use for className merging
3. **No !important**: Use proper CSS specificity
4. **No arbitrary values**: Use theme tokens (exception: precise alignment)
5. **Consistent ordering**: Tailwind class order (layout → spacing → colors → effects)

```tsx
// ✅ Good class ordering
<div className="flex items-center gap-4 p-4 bg-white rounded-lg shadow-sm" />

// ❌ Random ordering
<div className="shadow-sm bg-white flex rounded-lg p-4 gap-4 items-center" />
```

## Performance

1. **Lazy load** heavy components with `React.lazy()`
2. **Memoize** expensive computations with `useMemo()`
3. **Avoid** inline object/array creation in render
4. **Use** `React.memo()` for pure components receiving props

## List tables (`CommonTable`)

When adding or editing data tables, follow @.claude/rules/web.md:

1. **Search placeholder** — list all searchable fields in `searchPlaceholder`.
2. **Filter empty state** — `emptyFilterStateMessage` + `unfilteredItemCount` when filters apply.
3. **Migrations** — commit Prisma migrations for any schema/table change backing the list.

## Design Tokens Export

For design handoff or documentation, export theme tokens:

```bash
# Generate design tokens JSON
pnpm run export-tokens
```

This creates `design-tokens.json` with all CSS variables for Figma/design tools.
