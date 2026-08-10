# Quick Reference Card

## 🚀 Automated Feature Implementation

### 3-Step Process

```bash
# 1. Create feature folder
pnpm design:create my-feature

# 2. Add design images
# Drop images in .claude/design/my-feature/

# 3. Request implementation
"Implement the my-feature feature"
```

### What You Get

✅ **Database**: Prisma schema + migrations
✅ **API**: NestJS endpoints + validation
✅ **Web UI**: Next.js components (responsive)
✅ **Mobile**: Expo screens (touch-friendly)
✅ **Tests**: >80% coverage
✅ **Docs**: Complete documentation

### Design Folder Structure

```
.claude/design/<feature-name>/
├── overview.png         # Main design (REQUIRED)
├── desktop.png          # Desktop view (optional)
├── mobile.png           # Mobile view (optional)
├── interactions.png     # Hover states (optional)
├── specs.md             # Requirements (optional)
└── assets/              # Icons, images (optional)
```

## 📋 Commands

```bash
# Design Management
pnpm design:list              # List feature folders
pnpm design:create <name>     # Create feature template
pnpm design:validate <name>   # Validate folder

# Development
pnpm web:dev                  # Web dev server
pnpm mobile:start             # Mobile dev server
pnpm api:dev                  # API dev server

# Design System
pnpm export-tokens            # Export design tokens

# Database
pnpm db:migrate               # Run migrations
pnpm db:studio                # Prisma Studio
```

## 🎨 Design System Rules

### Colors (MANDATORY)

```tsx
✅ className="bg-[var(--color-bg-primary)]"
❌ className="bg-white"
```

### Components (CRITICAL)

1. Check existing components first
2. Extend with variants if similar
3. Create new only if 70%+ different

### Responsive (REQUIRED)

```tsx
// Mobile-first
<div className="flex flex-col md:flex-row lg:gap-8">
```

### Tables (REQUIRED)

Use `CommonTable` with `standardizeDesktopColumns` and `renderRow(row, layout)`.

- **Search**: `searchPlaceholder="Search by …"` must list every field the search matches (keep in sync with filter/haystack logic).
- **Filters**: `emptyFilterStateMessage` + `unfilteredItemCount` when select filters can hide all rows; message should name the filter context.
- **DB**: New/edited Prisma tables or columns → `pnpm db:migrate` and commit `apps/api/prisma/migrations/*`.

See `.claude/rules/web.md` and `AGENTS.md`.

## 📚 Documentation

- **`.claude/AUTOMATED-FEATURES.md`** - Complete guide
- **`.claude/design/README.md`** - Design folder guide
- **`.claude/DESIGN.md`** - Design implementation guide
- **`.claude/AGENTS.md`** - Multi-agent workflow
- **`.claude/design/example-feature/specs.md`** - Example specs

## 🤖 Multi-Agent Workflow

When you say "Implement the X feature", 5 agents work in parallel:

1. **Database Agent** → Schema + migrations
2. **API Agent** → Endpoints + validation
3. **Web UI Agent** → Components + responsive
4. **Mobile UI Agent** → Screens + native features
5. **Test Agent** → Tests + docs

**Result**: ~3x faster implementation! ⚡

## 💡 Tips

### For Best Results

1. **High-res images** (2x/Retina)
2. **Multiple views** (desktop + mobile)
3. **Show interactions** (hover, focus, error states)
4. **Add specs.md** for complex features

### Example Request

```
"Implement the user-dashboard feature with these requirements:
- Show user stats (orders, revenue)
- Recent activity timeline
- Quick actions section"
```

### Iteration

```
"Update user-dashboard: Add chart for revenue trend"
"Fix user-dashboard: Make cards larger on mobile"
```

## 🎯 What Gets Built

### Database Layer

- Prisma models with relations
- Migrations (reversible)
- Indexes for performance
- Seed data (if needed)

### API Layer

- RESTful endpoints
- Zod validation
- Error handling
- Auth guards
- Swagger docs

### Web UI

- Pixel-perfect (±2px)
- Responsive (mobile-first)
- Reusable components
- Loading/error states
- Dark mode support
- Accessibility (WCAG AA)

### Mobile UI

- Touch-friendly (48px)
- Native features
- Optimized performance
- iOS + Android

### Tests

- Unit tests
- Integration tests
- E2E tests
- > 80% coverage

## ✨ Key Features

- ✅ **Centralized colors** - Change 1 variable → update whole app
- ✅ **Component reuse** - No duplication, consistent UI
- ✅ **Responsive** - Works on all devices
- ✅ **Accessible** - WCAG AA compliant
- ✅ **Fast** - Multi-agent parallel execution
- ✅ **Complete** - Full stack + tests + docs

---

**Ready?** Just drop design images in `.claude/design/<feature>/` and say:

```
"Implement the <feature> feature"
```

🚀 Let's build!
