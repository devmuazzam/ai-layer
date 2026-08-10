# Automated Feature Implementation - Complete Setup ✅

> Drop design images → Get fully functional feature automatically

## 🎯 What's Been Set Up

### 1. Design Folder System

**Location**: `.claude/design/`

**Structure**:

```
.claude/design/
├── README.md                    # Complete guide
├── example-feature/             # Example feature template
│   ├── specs.md                 # Example specifications
│   └── assets/                  # Example assets folder
└── <your-feature>/              # Your feature folders
    ├── overview.png             # Main design (REQUIRED)
    ├── desktop.png              # Desktop view (optional)
    ├── mobile.png               # Mobile view (optional)
    ├── interactions.png         # Hover/focus states (optional)
    ├── specs.md                 # Requirements (optional)
    └── assets/                  # Icons, images (optional)
```

### 2. Updated Documentation

✅ **Updated `.claude/AGENTS.md`**

- Automated feature implementation workflow
- Phase-by-phase agent execution
- specs.md structure guide

✅ **Updated `.claude/CLAUDE.md`**

- Automated feature implementation section
- Design folder reference

✅ **Created `.claude/design/README.md`**

- Complete folder structure guide
- Image guidelines
- specs.md examples
- Multi-agent workflow explanation
- Example features
- Tips for best results

✅ **Created `.claude/design/example-feature/specs.md`**

- Full example of feature specifications
- Shows all possible sections
- Real-world dashboard example

## 🚀 How to Use

### Quick Start (3 Steps)

#### Step 1: Create Feature Folder

```bash
# Create feature folder
mkdir .claude/design/user-profile

# Create assets folder (optional)
mkdir .claude/design/user-profile/assets
```

#### Step 2: Add Design Images

Drop your design images into the folder:

```bash
.claude/design/user-profile/
├── overview.png      # Main design (REQUIRED)
├── mobile.png        # Mobile version (optional)
└── specs.md          # Additional requirements (optional)
```

**Supported formats**: PNG, JPG, JPEG, SVG, WebP

#### Step 3: Request Implementation

Simply say:

```
"Implement the user-profile feature"
```

That's it! I will automatically:

1. ✅ Read all images from `.claude/design/user-profile/`
2. ✅ Parse `specs.md` if it exists
3. ✅ Analyze design (colors, spacing, components, layout)
4. ✅ Implement database changes (Prisma schema + migrations)
5. ✅ Build API endpoints (NestJS controllers + services)
6. ✅ Create web UI (Next.js components, responsive)
7. ✅ Build mobile screens (Expo, touch-friendly)
8. ✅ Write tests (API + UI, >80% coverage)
9. ✅ Update documentation

## 📋 What Gets Built

### Database Layer

- ✅ Prisma schema models
- ✅ Migration files
- ✅ Indexes for performance
- ✅ Relations between tables
- ✅ Seed data (if needed)

### API Layer (NestJS)

- ✅ Controllers with all endpoints
- ✅ DTOs with Zod validation
- ✅ Use cases (business logic)
- ✅ Repositories (data access)
- ✅ Error handling
- ✅ Auth guards & permissions
- ✅ Registered in `app.module.ts`

### Web UI (Next.js)

- ✅ Pixel-perfect components (±2px tolerance)
- ✅ Responsive design (mobile-first)
- ✅ Colors matched to CSS variables
- ✅ Reuses existing atoms/molecules/organisms
- ✅ CVA variants for component variations
- ✅ TanStack Query for API integration
- ✅ Loading/error/empty states
- ✅ Dark mode support
- ✅ Accessibility (WCAG AA)
- ✅ **List tables**: `searchPlaceholder` lists all searchable fields; filter-specific `emptyFilterStateMessage` + `unfilteredItemCount` when filters apply (see `AGENTS.md`, `.claude/rules/web.md`)

### Mobile UI (Expo)

- ✅ Native-feeling screens
- ✅ Touch-friendly (48px targets)
- ✅ Expo Router navigation
- ✅ Native features (camera, gestures)
- ✅ Optimized performance
- ✅ iOS + Android compatible

### Tests

- ✅ API unit tests
- ✅ API integration tests
- ✅ Component unit tests (React Testing Library)
- ✅ E2E tests (Playwright)
- ✅ >80% code coverage

### Documentation

- ✅ JSDoc comments on all components
- ✅ API endpoint documentation
- ✅ README updates if needed

## 📝 Optional: specs.md

For complex features, add a `specs.md` file for additional context:

```markdown
# Feature Name

## Description

Brief feature description

## User Stories

- As a user, I want to...

## API Requirements

### GET /api/endpoint

Response schema...

## Database Changes

### New Tables

Prisma schema...

## Design Specifications

### Colors

Brand colors to use...

### Components

Reuse existing components...

## Permissions

Role requirements...

## Validation Rules

Business rules...

## Test Scenarios

Critical test cases...
```

**See**: `.claude/design/example-feature/specs.md` for a complete example.

## 🎨 Design Guidelines

### Image Requirements

**Minimum**:

- `overview.png` - Main feature design

**Recommended**:

- `desktop.png` - Desktop viewport (1920×1080)
- `tablet.png` - Tablet viewport (768×1024)
- `mobile.png` - Mobile viewport (375×667)
- `interactions.png` - Hover/focus/active states
- `error-states.png` - Error/loading/empty states
- `dark-mode.png` - Dark mode variant

**Quality**:

- High resolution (2x/Retina preferred)
- Clear text and labels
- Visible colors and spacing
- Annotations for measurements (helpful)

### Color Matching

I will automatically:

1. Extract colors from design
2. Match to existing CSS variables in `theme.css`
3. Map exact or closest match
4. Add new CSS variables if color is used 5+ times

You can specify colors in `specs.md`:

```markdown
## Colors

- Primary: #7F56D9 (matches --color-utility-brand-600)
- Background: #FFFFFF (matches --color-bg-primary)
```

## 🤖 Multi-Agent Execution

When you request a feature, I launch 5 agents in parallel:

### Agent 1: Database Agent

**Reads**: `@prisma.md`
**Tasks**:

- Parse database requirements from specs.md
- Create Prisma schema models
- Generate migration files
- Run migrations
- Update seed data

### Agent 2: API Agent

**Reads**: `@api.md`
**Tasks**:

- Create controllers + DTOs
- Implement use cases (business logic)
- Create repositories (data access)
- Add validation + error handling
- Register in app.module.ts

### Agent 3: Web UI Agent

**Reads**: `@design-system.md`, `@web.md`, `@DESIGN.md`
**Tasks**:

- Analyze design images
- Match colors to CSS variables
- Map to existing components
- Implement responsive layouts
- Add interactions + states
- Integrate with API
- List tables: descriptive `searchPlaceholder`, filter `emptyFilterStateMessage`, `unfilteredItemCount` when client-filtered

### Agent 4: Mobile UI Agent

**Reads**: `@mobile.md`, `@design-system.md`
**Tasks**:

- Create Expo screens
- Touch-friendly UI (48px targets)
- Native features integration
- API integration
- Performance optimization

### Agent 5: Test & Docs Agent

**Tasks**:

- Write API tests (unit + integration)
- Write UI component tests
- Write E2E tests
- Update API documentation
- Add JSDoc comments

All agents work simultaneously = faster implementation! 🚀

## 📂 Example: Simple Feature

### Feature: Contact Form

**Folder**:

```
.claude/design/contact-form/
└── overview.png
```

**Command**: `"Implement the contact-form feature"`

**Built**:

- ✅ API: POST /api/contact
- ✅ Frontend: Contact form component
- ✅ Validation: Email, name, message fields
- ✅ Email: Send to admin email
- ✅ Tests: Form validation + API endpoint

## 📂 Example: Complex Feature

### Feature: Order Management

**Folder**:

```
.claude/design/order-management/
├── overview.png        # Feature overview
├── list-view.png       # Orders list table
├── detail-view.png     # Order detail page
├── create-order.png    # Create order form
├── mobile.png          # Mobile responsive
├── interactions.png    # Hover states
└── specs.md            # Additional requirements
```

**Command**: `"Implement the order-management feature"`

**Built**:

- ✅ Database: orders table + relations
- ✅ API: Full CRUD + filters + pagination
- ✅ Web: List view + detail view + create form
- ✅ Mobile: Mobile-optimized screens
- ✅ Tests: Full test coverage
- ✅ All following design system rules

## 🎯 Design System Compliance

All implementations automatically follow:

### Colors (MANDATORY)

✅ Only CSS variables from `theme.css`
✅ No hardcoded hex/rgb colors
✅ Automatic dark mode support

### Components (CRITICAL)

✅ Reuse existing atoms/molecules/organisms
✅ Create new components only if needed
✅ CVA variants for all variations
✅ cn() utility for className merging

### Responsive (REQUIRED)

✅ Mobile-first approach (375px base)
✅ Breakpoints: sm (640px), md (768px), lg (1024px), xl (1280px)
✅ Touch targets: 44px web, 48px mobile

### Accessibility (WCAG AA)

✅ Semantic HTML
✅ ARIA attributes
✅ Keyboard navigation
✅ Focus visible states
✅ Color contrast 4.5:1

### Code Quality

✅ TypeScript strict mode
✅ No `any` types
✅ Zod validation
✅ Named exports
✅ JSDoc comments

## 🛠️ Commands Reference

```bash
# Design Management
pnpm design:list              # List all feature folders
pnpm design:create <name>     # Create new feature template
pnpm design:validate <name>   # Validate feature folder

# Development
pnpm web:dev                  # Start web dev server
pnpm mobile:start             # Start Expo dev server
pnpm api:dev                  # Start API dev server

# Database
pnpm db:migrate               # Create and run migration
pnpm db:studio                # Open Prisma Studio

# Design System
pnpm export-tokens            # Export design tokens to JSON

# Quality
pnpm lint                     # Lint all packages
pnpm build                    # Build all packages
```

## 🔄 Iteration & Updates

After initial implementation, you can request changes:

```
"Update user-profile: Add social media links section"
"Fix user-profile: Make avatar larger on mobile"
"Enhance user-profile: Add skeleton loading states"
```

I'll iterate on the existing implementation.

## ⚡ Performance

**Parallel execution** means:

- 5 agents working simultaneously
- Faster than sequential implementation
- Each agent has specialized knowledge
- Reduced total implementation time

**Example Timeline**:

- Sequential: ~30-45 minutes
- Parallel (5 agents): ~10-15 minutes
- **~3x faster!** ⚡

## 🚨 Important Notes

### What I CAN Do Automatically

✅ CRUD operations (create, read, update, delete)
✅ Form validation (email, phone, required fields)
✅ File uploads (images, PDFs)
✅ Sorting & filtering (tables, search)
✅ Pagination (infinite scroll or page-based)
✅ Authentication flows (login, signup, logout)
✅ Real-time updates (WebSocket)
✅ Responsive design (all breakpoints)

### What I CANNOT Do (Need Your Input)

❌ Complex business logic decisions
❌ Third-party API integrations (need credentials)
❌ Payment processing (need Stripe/PayPal setup)
❌ Custom algorithms (need algorithm specs)

I'll ask questions if clarification is needed!

## 📞 Getting Help

**List available features**:

```bash
pnpm design:list
```

**Create new feature template**:

```bash
pnpm design:create my-feature
```

**Check folder structure**:

```
.claude/design/
├── README.md                # Full guide
└── example-feature/         # Complete example
    └── specs.md
```

**Ask me**:

```
"How do I use the design folder?"
"Show me design folder examples"
"Create a template for feature X"
```

## ✨ Benefits

✅ **Super fast** - Drop images, get feature
✅ **Consistent** - Always follows design system rules
✅ **Complete** - Database → API → UI → Tests
✅ **Quality** - >80% test coverage, WCAG AA
✅ **Maintainable** - Reusable components, clean code
✅ **Responsive** - Mobile-first, all breakpoints
✅ **Accessible** - Keyboard nav, screen readers
✅ **Themeable** - CSS variables, automatic dark mode

## 🎉 Ready to Use!

1. **Create folder**: `pnpm design:create my-feature`
2. **Add images**: Drop PNG/JPG files in `.claude/design/my-feature/`
3. **Request**: `"Implement the my-feature feature"`
4. **Watch it build!** 🚀

---

**Questions?** Just ask: "How do I implement a feature from design?"
