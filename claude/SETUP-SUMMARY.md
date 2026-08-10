# Design System Setup Complete ✅

## What's Been Implemented

### 1. Centralized Theme System

**Location**: `apps/web/src/styles/theme.css`

- ✅ All colors use CSS variables
- ✅ Automatic dark mode support via `.dark-mode` class
- ✅ Change one variable = update entire app
- ✅ 850+ predefined color variables organized by utility

### 2. Theme Configuration Utility

**Location**: `apps/web/src/lib/theme.ts`

TypeScript utilities for accessing theme variables:

```tsx
import { themeConfig, getThemeVar } from '@/lib/theme';

// Access theme colors
const brandColor = getThemeVar('brand.primary'); // 'var(--color-utility-brand-600)'

// Runtime color updates
setThemeColor('--color-utility-brand-600', '#7F56D9');

// Get computed values
const actualColor = getComputedThemeVar('--color-bg-primary'); // '#ffffff'
```

### 3. Design System Documentation

#### New Documentation Files:

1. **`.claude/rules/design-system.md`**
   - Centralized theming architecture
   - Component reusability guidelines (MANDATORY)
   - CVA variant patterns
   - Responsive design rules
   - Design implementation from images
   - Accessibility requirements

2. **`.claude/DESIGN.md`**
   - Step-by-step design implementation guide
   - Color extraction & matching process
   - Component mapping decision tree
   - Pixel-perfect implementation checklist
   - Common design patterns (buttons, cards, forms, modals, tables)
   - Troubleshooting guide

3. **Updated `.claude/AGENTS.md`**
   - Multi-agent workflow for parallel task execution
   - 5 specialized agents: Design, API, Database, Test, Documentation
   - Agent communication protocol
   - Design implementation agent workflow

4. **`.claude/rules/web.md`**
   - List table conventions: search placeholder, filter empty state, migrations with schema changes
   - `CommonTable` layout rules (`standardizeDesktopColumns`, `renderRow` layout helpers)

5. **Updated `.claude/CLAUDE.md`**
   - Added design system references
   - Updated Web UI rules with component reusability
   - Added theme configuration reference
   - Added `pnpm export-tokens` command

### 4. Design Token Export Script

**Location**: `scripts/export-design-tokens.js`

**Usage**:

```bash
pnpm export-tokens
```

**Output**: `design-tokens.json` (for Figma/Sketch import)

Exports all CSS variables as structured JSON:

- Colors (850+)
- Spacing scale
- Typography scale
- Border radius
- Metadata & timestamps

### 5. Component Structure Enforcement

```
apps/web/src/components/
├── atoms/              Pure primitives (Button, Input, Badge)
├── molecules/          Simple composites (FormField, SearchBar)
├── organisms/          Complex sections (DataTable, Header)
├── templates/          Page layouts
└── features/           Feature-specific components
```

**Import Rule** (ENFORCED):

- Atoms → Import nothing
- Molecules → Import atoms only
- Organisms → Import atoms + molecules
- Templates → Import atoms + molecules + organisms
- Features → Import any (isolated)

## How to Use

### When Implementing New Designs

1. **Provide Design Image**

   ```
   "Here's the design (attach image), please implement it"
   ```

2. **We Will**:
   - ✅ Analyze colors → Match to CSS variables
   - ✅ Check existing components → Reuse when possible
   - ✅ Create CVA variants if needed
   - ✅ Implement mobile-responsive
   - ✅ Verify pixel-perfectly (±2px)
   - ✅ Test dark mode
   - ✅ Ensure accessibility

### Changing Colors Globally

**In CSS** (`apps/web/src/styles/theme.css`):

```css
:root {
  --color-utility-brand-600: #7f56d9; /* Change this */
}
```

✅ Entire app updates automatically!

**At Runtime** (TypeScript):

```tsx
import { setThemeColor } from '@/lib/theme';

setThemeColor('--color-utility-brand-600', '#NEW_COLOR');
```

### Creating Reusable Components

**Always use CVA for variants**:

```tsx
import { cva, type VariantProps } from 'class-variance-authority';
import { cn } from '@/lib/utils';

const cardVariants = cva('rounded-lg border p-6', {
  variants: {
    variant: {
      default: 'bg-[var(--color-bg-primary)]',
      elevated: 'shadow-lg',
    },
    size: {
      sm: 'p-4',
      lg: 'p-8',
    },
  },
  defaultVariants: {
    variant: 'default',
    size: 'sm',
  },
});

interface CardProps
  extends React.HTMLAttributes<HTMLDivElement>, VariantProps<typeof cardVariants> {}

export const Card: React.FC<CardProps> = ({ className, variant, size, ...props }) => {
  return <div className={cn(cardVariants({ variant, size }), className)} {...props} />;
};
```

### Multi-Agent Parallel Execution

For complex features, we can run multiple agents in parallel:

**Example**: "Add user profile management with API, UI, and tests"

```
Agent 1 (Database): Creates profile schema → Runs migrations
Agent 2 (API): Creates CRUD endpoints → Adds validation
Agent 3 (Web UI): Builds profile form → Profile view
Agent 4 (Mobile): Creates profile screen in Expo
Agent 5 (Tests): Writes API + UI tests
```

All agents work simultaneously, reducing implementation time.

## Key Design Principles

### 1. Centralized Colors (MANDATORY)

❌ **NEVER** do this:

```tsx
<div className="bg-white text-black" />
<div style={{ backgroundColor: '#ffffff' }} />
```

✅ **ALWAYS** do this:

```tsx
<div className="bg-[var(--color-bg-primary)] text-[var(--color-text-primary)]" />
```

### 2. Component Reusability (CRITICAL)

Before creating new component, **CHECK**:

1. Does exact component exist? → USE IT
2. Does similar component exist? → EXTEND IT (add variant)
3. 70%+ different? → CREATE NEW (last resort)

### 3. Mobile-First Responsive

```tsx
// ✅ Mobile-first
<div className="flex flex-col gap-4 md:flex-row md:gap-6 lg:gap-8" />

// ❌ Desktop-first
<div className="flex flex-row lg:flex-col" />
```

### 4. Accessibility First

- ✅ Semantic HTML (`<button>`, not `<div onClick>`)
- ✅ ARIA labels when needed
- ✅ Keyboard navigation support
- ✅ Focus visible states
- ✅ WCAG AA color contrast (4.5:1)

### 5. Touch Targets

- Web: 44px minimum
- Mobile: 48px minimum

```tsx
<Button className="h-10 min-w-10" /> // Web (40px base, flex to 44px)
<Button className="h-12 min-w-12" /> // Mobile (48px)
```

## Commands Reference

```bash
# Development
pnpm web:dev                  # Start web dev server
pnpm mobile:start             # Start Expo dev server

# Design System
pnpm export-tokens            # Export design tokens to JSON

# Database
pnpm db:migrate               # Create and run migration
pnpm db:studio                # Open Prisma Studio

# Quality
pnpm lint                     # Lint all packages
pnpm build                    # Build all packages
```

## File Structure

```
tcg-platform/
├── .claude/
│   ├── CLAUDE.md                   # Main project guide
│   ├── AGENTS.md                   # Multi-agent workflows
│   ├── DESIGN.md                   # Design implementation guide
│   └── rules/
│       ├── design-system.md        # Design system rules
│       ├── web.md                  # Web/UI patterns
│       ├── api.md                  # API patterns
│       ├── prisma.md               # Database patterns
│       └── mobile.md               # Mobile patterns
├── apps/
│   └── web/
│       └── src/
│           ├── components/
│           │   ├── atoms/          # Primitives
│           │   ├── molecules/      # Simple composites
│           │   ├── organisms/      # Complex sections
│           │   ├── templates/      # Layouts
│           │   └── features/       # Feature-specific
│           ├── lib/
│           │   ├── theme.ts        # Theme utilities
│           │   └── utils.ts        # cn() utility
│           └── styles/
│               ├── globals.css     # Global styles
│               ├── theme.css       # CSS variables (850+)
│               └── typography.css  # Typography styles
├── scripts/
│   └── export-design-tokens.js     # Token export script
└── package.json                    # Updated with export-tokens
```

## Next Steps

### For Design Implementation

1. Provide design images/mockups
2. Specify any special requirements (animations, interactions)
3. Mention if it's for web, mobile, or both

### For Color Customization

1. Tell us which colors to change
2. Provide hex codes or color names
3. We'll update CSS variables automatically

### For New Features

1. Describe the feature requirements
2. We'll use multi-agent workflow for parallel implementation
3. Database → API → UI → Mobile → Tests (all in parallel)

## Benefits

✅ **Change color once** → Updates entire app (light + dark mode)
✅ **Reusable components** → No duplication, consistent UI
✅ **Responsive by default** → Mobile-first design system
✅ **Fast development** → Multi-agent parallel execution
✅ **Pixel-perfect** → Design implementation within ±2px tolerance
✅ **Accessible** → WCAG AA compliant out of the box
✅ **Type-safe** → TypeScript theme utilities
✅ **Exportable** → Design tokens for Figma/Sketch

---

**Ready to implement designs!** 🎨

Just provide design images and requirements, and we'll build it following all the design system rules.
