# Design Implementation Guide

> How to implement pixel-perfect designs from images using the TCG design system

## Process Overview

When given a design image (Figma screenshot, mockup, etc.):

### 1. Analysis Phase (5-10 minutes)

#### Extract Visual Elements

- [ ] **Layout**: Grid system, spacing patterns, responsive breakpoints
- [ ] **Colors**: Background, text, border, accent colors
- [ ] **Typography**: Font sizes, weights, line heights
- [ ] **Components**: Buttons, inputs, cards, tables, modals
- [ ] **States**: Hover, focus, active, disabled, loading
- [ ] **Spacing**: Padding, margins, gaps (8px grid recommended)
- [ ] **Shadows**: Box shadows, elevations
- [ ] **Borders**: Radius, width, color
- [ ] **Responsive**: Mobile, tablet, desktop variations

#### Color Matching

Extract colors from design → Match to CSS variables:

| Design Color | CSS Variable                | Usage                |
| ------------ | --------------------------- | -------------------- |
| #FFFFFF      | `--color-bg-primary`        | Main background      |
| #F9FAFB      | `--color-bg-secondary`      | Secondary background |
| #7F56D9      | `--color-utility-brand-600` | Brand primary        |
| #101828      | `--color-text-primary`      | Primary text         |
| #475467      | `--color-text-secondary`    | Secondary text       |
| #D0D5DD      | `--color-border-primary`    | Borders              |

**Tool**: Use browser DevTools color picker or Figma's inspect mode.

### 2. Component Mapping

#### Check Existing Components First

```bash
# Search for similar components
ls apps/web/src/components/atoms/buttons/
ls apps/web/src/components/molecules/
ls apps/web/src/components/organisms/

# Search for specific patterns
grep -r "variant:" apps/web/src/components/
```

#### Decision Tree

```
Design Element
├─ Does exact component exist? → USE IT
├─ Does similar component exist?
│  ├─ Can add variant? → EXTEND IT (CVA variant)
│  └─ 70%+ different? → CREATE NEW (last resort)
└─ Completely new pattern?
   ├─ Used 1-2 times? → Inline composition
   └─ Used 3+ times? → Create reusable component
```

### 3. Implementation

#### Step-by-Step

**Step 1**: Create component skeleton

```tsx
import { cn } from '@/lib/utils';

interface DesignComponentProps {
  // Props from design requirements
}

export const DesignComponent: React.FC<DesignComponentProps> = ({ className, ...props }) => {
  return (
    <div
      className={cn(
        // Base classes here
        className,
      )}
      {...props}
    >
      {/* Component content */}
    </div>
  );
};
```

**Step 2**: Apply Tailwind classes using theme variables

```tsx
<div
  className={cn(
    'rounded-lg',
    'bg-[var(--color-bg-primary)]',
    'border border-[var(--color-border-primary)]',
    'p-6',
    'shadow-sm',
    className,
  )}
/>
```

**Step 3**: Implement responsive behavior

```tsx
<div
  className={cn(
    // Mobile-first
    'flex flex-col gap-4 p-4',
    // Tablet (md: 768px)
    'md:flex-row md:gap-6 md:p-6',
    // Desktop (lg: 1024px)
    'lg:gap-8 lg:p-8',
    className,
  )}
/>
```

**Step 4**: Add interactive states

```tsx
<button
  className={cn(
    'transition-colors duration-200',
    'hover:bg-[var(--color-bg-secondary_hover)]',
    'focus-visible:ring-2 focus-visible:ring-[var(--color-focus-ring)]',
    'active:scale-95',
    'disabled:opacity-50 disabled:cursor-not-allowed',
    className,
  )}
/>
```

**Step 5**: Extract to CVA variants (if 3+ variations)

```tsx
import { cva, type VariantProps } from 'class-variance-authority';

const cardVariants = cva(
  'rounded-lg border p-6 shadow-sm', // base
  {
    variants: {
      variant: {
        default: 'bg-[var(--color-bg-primary)] border-[var(--color-border-primary)]',
        elevated: 'bg-[var(--color-bg-primary)] shadow-lg border-transparent',
        outlined: 'bg-transparent border-[var(--color-border-brand)]',
      },
      size: {
        sm: 'p-4',
        md: 'p-6',
        lg: 'p-8',
      },
    },
    defaultVariants: {
      variant: 'default',
      size: 'md',
    },
  },
);

interface CardProps
  extends React.HTMLAttributes<HTMLDivElement>, VariantProps<typeof cardVariants> {}

export const Card: React.FC<CardProps> = ({ className, variant, size, ...props }) => {
  return <div className={cn(cardVariants({ variant, size }), className)} {...props} />;
};
```

### 4. Verification

#### Pixel-Perfect Checklist

- [ ] **Colors match** (exact CSS variable or ±5% tolerance)
- [ ] **Spacing matches** (±2px tolerance)
- [ ] **Font size matches** (use `--text-*` variables)
- [ ] **Border radius matches** (use `--radius-*` or Tailwind)
- [ ] **Shadows match** (use Tailwind shadow utilities)
- [ ] **Responsive breakpoints work** (mobile, tablet, desktop)
- [ ] **Dark mode works** (if applicable)
- [ ] **Interactive states work** (hover, focus, active, disabled)

#### Testing Procedure

1. **Desktop** (1920×1080): Visual comparison with design
2. **Tablet** (768×1024): Check responsive layout
3. **Mobile** (375×667): Verify mobile-first design
4. **Dark mode**: Toggle and verify colors
5. **Accessibility**: Tab navigation, screen reader, contrast

### 5. Documentation

Add JSDoc comments to new components:

````tsx
/**
 * ProfileCard - Displays user profile information
 *
 * @example
 * ```tsx
 * <ProfileCard
 *   variant="elevated"
 *   size="lg"
 *   name="John Doe"
 *   avatar="/avatar.jpg"
 * />
 * ```
 */
export const ProfileCard: React.FC<ProfileCardProps> = ({ ... }) => { ... };
````

## Common Design Patterns

### Button Group (Responsive)

```tsx
<div className="flex w-full flex-col gap-2 sm:w-auto sm:flex-row sm:gap-3">
  <SecondaryButton className="h-10 w-full justify-center sm:w-auto">Cancel</SecondaryButton>
  <PrimaryButton className="h-10 w-full justify-center sm:w-auto">Submit</PrimaryButton>
</div>
```

### Card with Header & Footer

```tsx
<div className="rounded-lg border border-[var(--color-border-primary)] bg-[var(--color-bg-primary)] overflow-hidden">
  <div className="border-b border-[var(--color-border-primary)] p-6">
    <h3 className="text-lg font-semibold text-[var(--color-text-primary)]">Card Header</h3>
  </div>
  <div className="p-6">{/* Card content */}</div>
  <div className="border-t border-[var(--color-border-primary)] p-6 bg-[var(--color-bg-secondary)]">
    {/* Card footer */}
  </div>
</div>
```

### Data Table (Responsive)

```tsx
<div className="overflow-x-auto">
  <table className="w-full">
    <thead className="bg-[var(--color-bg-secondary)] border-b border-[var(--color-border-primary)]">
      <tr>
        <th className="px-6 py-3 text-left text-xs font-medium text-[var(--color-text-secondary)] uppercase tracking-wider">
          Name
        </th>
      </tr>
    </thead>
    <tbody className="divide-y divide-[var(--color-border-secondary)]">{/* Table rows */}</tbody>
  </table>
</div>
```

### Form Field

```tsx
<div className="space-y-2">
  <label htmlFor="email" className="text-sm font-medium text-[var(--color-text-primary)]">
    Email
  </label>
  <input
    id="email"
    type="email"
    className={cn(
      'w-full h-10 px-3 rounded-lg',
      'bg-[var(--color-bg-primary)]',
      'border border-[var(--color-border-primary)]',
      'text-[var(--color-text-primary)]',
      'placeholder:text-[var(--color-text-placeholder)]',
      'focus:outline-none focus:ring-2 focus:ring-[var(--color-focus-ring)]',
      'disabled:opacity-50 disabled:cursor-not-allowed',
    )}
    placeholder="you@example.com"
  />
  <p className="text-sm text-[var(--color-text-error-primary)]">{/* Error message */}</p>
</div>
```

### Modal Overlay

```tsx
<div className="fixed inset-0 z-50 flex items-center justify-center">
  {/* Backdrop */}
  <div
    className="absolute inset-0 bg-[var(--color-bg-overlay)] backdrop-blur-sm"
    onClick={onClose}
  />

  {/* Modal */}
  <div className="relative z-10 w-full max-w-lg mx-4 rounded-lg bg-[var(--color-bg-primary)] shadow-xl">
    <div className="p-6">{/* Modal content */}</div>
  </div>
</div>
```

## Tools & Resources

### Browser DevTools

- **Color Picker**: Extract hex colors from design images
- **Pixel Ruler**: Measure spacing, sizes
- **Responsive Mode**: Test breakpoints

### Figma (if provided)

- **Inspect Mode**: Get exact CSS values
- **Export**: Download assets (SVG, PNG)
- **Dev Mode**: View component specs

### VS Code Extensions

- **Tailwind CSS IntelliSense**: Autocomplete for Tailwind classes
- **ES7+ React/Redux**: Component snippets
- **Prettier**: Auto-format code

### CLI Commands

```bash
# Find similar components
grep -r "className=" apps/web/src/components/ | grep "button"

# Search for color usage
grep -r "var(--color-" apps/web/src/

# List all theme variables
grep "^[[:space:]]*--color-" apps/web/src/styles/theme.css
```

## Troubleshooting

### Colors Don't Match

**Problem**: Design color doesn't exist in theme.css

**Solution**:

1. Find closest CSS variable (use color picker)
2. If truly unique and used 5+ times, add to `theme.css`:

```css
/* In apps/web/src/styles/theme.css under appropriate section */
--color-custom-purple: #7f56d9;
--color-custom-purple-hover: #6941c6;
```

### Component Not Reusable Enough

**Problem**: Created component too specific

**Solution**:

1. Extract props for customization
2. Add CVA variants for variations
3. Keep composition flexible with `children` prop

### Responsive Layout Breaks

**Problem**: Desktop layout doesn't adapt to mobile

**Solution**:

1. Use mobile-first approach (base = mobile)
2. Add breakpoint-specific classes: `sm:`, `md:`, `lg:`
3. Test at each breakpoint: 375px, 768px, 1024px, 1920px

### Dark Mode Colors Wrong

**Problem**: Component looks bad in dark mode

**Solution**:

1. Use theme variables (auto dark mode support)
2. Test in dark mode: Add `dark-mode` class to `<html>`
3. Adjust specific dark mode styles if needed:

```tsx
<div className="bg-[var(--color-bg-primary)] dark:bg-[var(--color-bg-primary)]" />
```

## Examples from Real Designs

### Example 1: Login Form

**Design**: [Describe design features]

**Implementation**:

```tsx
export const LoginForm = () => {
  return (
    <div className="flex min-h-screen items-center justify-center bg-[var(--color-bg-secondary)] p-4">
      <div className="w-full max-w-md space-y-8 rounded-lg bg-[var(--color-bg-primary)] p-8 shadow-lg">
        <div className="text-center">
          <h2 className="text-3xl font-bold text-[var(--color-text-primary)]">Welcome Back</h2>
          <p className="mt-2 text-sm text-[var(--color-text-secondary)]">Sign in to your account</p>
        </div>

        <form className="space-y-6">{/* Form fields */}</form>
      </div>
    </div>
  );
};
```

### Example 2: Dashboard Stats Card

**Design**: [Describe design features]

**Implementation**:

```tsx
export const StatsCard = ({ title, value, trend, icon }: StatsCardProps) => {
  return (
    <div className="rounded-lg border border-[var(--color-border-primary)] bg-[var(--color-bg-primary)] p-6 shadow-sm">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm font-medium text-[var(--color-text-secondary)]">{title}</p>
          <p className="mt-2 text-3xl font-semibold text-[var(--color-text-primary)]">{value}</p>
        </div>
        <div className="rounded-full bg-[var(--color-utility-brand-100)] p-3">{icon}</div>
      </div>
      <div className="mt-4 flex items-center gap-2">
        <span className="text-sm font-medium text-[var(--color-utility-green-600)]">{trend}</span>
        <span className="text-sm text-[var(--color-text-tertiary)]">vs last month</span>
      </div>
    </div>
  );
};
```

## Best Practices Summary

1. ✅ **Always check existing components first** before creating new ones
2. ✅ **Use CSS variables** for all colors (no hardcoded hex/rgb)
3. ✅ **Mobile-first responsive design** with Tailwind breakpoints
4. ✅ **44px minimum touch targets** for buttons/interactive elements
5. ✅ **CVA for variants** when component has 3+ variations
6. ✅ **cn() utility** for className merging
7. ✅ **Test dark mode** if design supports it
8. ✅ **Accessibility first** (ARIA, keyboard nav, focus states)
9. ✅ **Document components** with JSDoc comments
10. ✅ **Pixel-perfect within ±2px** tolerance
11. ✅ **List tables** (`CommonTable`): `searchPlaceholder` lists all searchable fields; `emptyFilterStateMessage` + `unfilteredItemCount` when filters apply; Prisma migrations for schema changes (see `.claude/rules/web.md`)
