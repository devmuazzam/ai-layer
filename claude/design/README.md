# Design Assets Directory

> Drop design images here for automatic feature implementation

## 📁 Folder Structure

```
.claude/design/
├── <feature-name>/          # Feature name in kebab-case
│   ├── overview.png         # Overall feature layout
│   ├── desktop.png          # Desktop view (optional)
│   ├── mobile.png           # Mobile view (optional)
│   ├── interactions.png     # Hover/focus states (optional)
│   ├── specs.md             # Design specifications (optional)
│   └── assets/              # Icons, logos, images (optional)
│       ├── icon-*.svg
│       └── *.png
├── example-feature/
│   └── README.md
└── README.md (this file)
```

## 🚀 Quick Start

### Step 1: Create Feature Folder

Create a folder with your feature name (kebab-case):

```bash
mkdir .claude/design/user-profile
mkdir .claude/design/user-profile/assets
```

### Step 2: Add Design Images

Drop your design images into the folder:

```bash
.claude/design/user-profile/
├── overview.png      # Main design
├── mobile.png        # Mobile version
└── specs.md          # Optional: Add notes
```

### Step 3: Request Implementation

Simply tell me the feature name:

```
"Implement the user-profile feature"
```

I will automatically:

1. ✅ Read all images from `.claude/design/user-profile/`
2. ✅ Analyze design (colors, components, layout, spacing)
3. ✅ Implement backend (API + database)
4. ✅ Implement frontend (web + mobile)
5. ✅ Write tests
6. ✅ Update documentation

## 📋 Image Guidelines

### Required Images

At minimum, provide:

- **overview.png/jpg** - Main feature design

### Recommended Images

For better implementation:

- **desktop.png** - Desktop viewport (1920×1080)
- **tablet.png** - Tablet viewport (768×1024)
- **mobile.png** - Mobile viewport (375×667)
- **interactions.png** - Hover/focus/active states
- **error-states.png** - Error/loading/empty states
- **dark-mode.png** - Dark mode variant

### Image Requirements

- **Format**: PNG, JPG, or SVG
- **Resolution**: High-res (2x/Retina preferred)
- **Annotations**: Add measurements/notes if needed
- **Naming**: Use descriptive kebab-case names

## 📝 Optional: Design Specs File

Create `specs.md` in your feature folder for additional context:

```markdown
# User Profile Feature

## Description

User profile management with avatar upload, bio editing, and settings.

## User Stories

- As a user, I can view my profile
- As a user, I can edit my profile information
- As a user, I can upload a profile picture

## API Requirements

- GET /api/users/:id/profile
- PUT /api/users/:id/profile
- POST /api/users/:id/avatar

## Database Changes

- Add `bio` field to users table (TEXT, nullable)
- Add `avatar_url` field to users table (VARCHAR(500), nullable)

## Special Notes

- Avatar upload max 5MB
- Bio max 500 characters
- Support jpg, png, webp formats
```

## 🎨 Design Specifications

### Colors

If your design uses specific colors not in our theme:

```markdown
## Colors

- Primary Brand: #7F56D9
- Secondary: #F9FAFB
- Text Primary: #101828
- Text Secondary: #475467
- Error: #F04438
- Success: #12B76A
```

I'll match these to our CSS variables or add new ones if needed.

### Typography

Specify custom font requirements:

```markdown
## Typography

- Headings: Inter Bold, 24px-48px
- Body: Inter Regular, 14px-16px
- Code: Roboto Mono, 13px
```

### Spacing

Note specific spacing requirements:

```markdown
## Spacing

- Card padding: 24px
- Button height: 44px
- Form field gap: 16px
- Section margins: 48px
```

## 🤖 Multi-Agent Implementation

When you request a feature, I'll execute in parallel:

### Agent 1: Database (Prisma)

- Analyze data requirements from design
- Create Prisma schema models
- Generate migration files
- Run migrations

### Agent 2: API (NestJS)

- Create controllers + DTOs
- Implement use cases (business logic)
- Create repositories (data access)
- Add validation + error handling

### Agent 3: Web UI (Next.js)

- Extract colors → Match to CSS variables
- Map to existing components (atoms/molecules/organisms)
- Implement responsive layouts (mobile-first)
- Add interactions + animations

### Agent 4: Mobile UI (Expo)

- Create mobile screens (Expo Router)
- Implement touch-friendly interactions (48px targets)
- Add native features (camera, gestures)
- Optimize performance

### Agent 5: Tests & Docs

- Write API tests (unit + e2e)
- Write component tests (React Testing Library)
- Update API documentation
- Add component storybook entries

## 📂 Example Features

### Example 1: Simple Feature (1 screen)

```
.claude/design/contact-form/
└── overview.png
```

**Request**: `"Implement the contact-form feature"`

**What I'll Build**:

- API: POST /api/contact
- Frontend: Contact form component
- Validation: Email, name, message
- Email: Send to admin

### Example 2: Complex Feature (Multiple screens)

```
.claude/design/order-management/
├── overview.png        # Feature overview
├── list-view.png       # Orders list table
├── detail-view.png     # Order detail page
├── create-order.png    # Create order form
├── mobile.png          # Mobile responsive
├── interactions.png    # Hover states, dropdowns
└── specs.md            # Additional requirements
```

**Request**: `"Implement the order-management feature"`

**What I'll Build**:

- Database: orders table + relations
- API: Full CRUD + filters + pagination
- Web: List view + detail view + create form
- Mobile: Mobile-optimized screens
- Tests: Full test coverage

### Example 3: Feature with Assets

```
.claude/design/dashboard-widgets/
├── overview.png
├── mobile.png
├── specs.md
└── assets/
    ├── icon-revenue.svg
    ├── icon-users.svg
    └── icon-orders.svg
```

**Request**: `"Implement the dashboard-widgets feature"`

**What I'll Build**:

- Uses provided SVG icons
- Stats cards with real API data
- Responsive dashboard layout
- Loading + error states

## 🎯 Implementation Standards

All implementations follow:

### Design System Rules

✅ **Colors**: Only CSS variables from `theme.css`
✅ **Components**: Reuse existing atoms/molecules/organisms
✅ **Responsive**: Mobile-first (375px → 1920px)
✅ **Touch Targets**: 44px web, 48px mobile
✅ **Accessibility**: WCAG AA compliant
✅ **Dark Mode**: Auto-support via theme variables

### List table standards (web)

✅ **Search placeholder**: `searchPlaceholder` lists every searchable field (`Search by …`)
✅ **Filter empty state**: `emptyFilterStateMessage` when filters hide all rows; `unfilteredItemCount` for client-filtered lists
✅ **Migrations**: Prisma schema changes ship with `apps/api/prisma/migrations/*` (`pnpm db:migrate`)

See `AGENTS.md` and `.claude/rules/web.md`.

### Code Quality Standards

✅ **TypeScript**: Strict mode, no `any`
✅ **Validation**: Zod schemas on API + forms
✅ **Error Handling**: Consistent error responses
✅ **Testing**: >80% code coverage
✅ **Documentation**: JSDoc comments + README

### API Standards

✅ **REST**: RESTful endpoints with proper HTTP methods
✅ **Validation**: DTO validation on all inputs
✅ **Auth**: JWT access + refresh tokens
✅ **Pagination**: Cursor-based pagination for lists
✅ **Filtering**: Query params for filtering/sorting

### Database Standards

✅ **Naming**: snake_case columns, plural tables
✅ **IDs**: Prefixed internal IDs (CUST-12345)
✅ **Indexes**: Add indexes for foreign keys + queries
✅ **Migrations**: Required for every schema/table change — `pnpm db:migrate`, commit `apps/api/prisma/migrations/*`

## 🚨 Important Notes

### What I CANNOT Do Automatically

❌ **Business Logic Decisions** - You must specify requirements
❌ **Third-party Integrations** - Need API keys/credentials
❌ **Complex Algorithms** - Specify algorithm requirements
❌ **Payment Processing** - Needs Stripe/PayPal setup

### What I CAN Do Automatically

✅ **CRUD Operations** - Standard create/read/update/delete
✅ **Form Validation** - Email, phone, required fields
✅ **File Uploads** - Images, PDFs (with storage setup)
✅ **Sorting/Filtering** - Table sorting, search
✅ **Pagination** - Infinite scroll or page-based
✅ **Authentication** - Login/signup/logout flows
✅ **Real-time Updates** - WebSocket for live data
✅ **Responsive Design** - Mobile/tablet/desktop layouts

## 📞 Getting Help

If I need clarification during implementation, I'll ask questions about:

- Business logic requirements
- Data validation rules
- Permission/role requirements
- Third-party service configurations
- Performance requirements
- Browser/device support

## 🎓 Tips for Best Results

### 1. Provide Complete Designs

✅ Include all screens/states in the feature
✅ Show mobile + desktop versions
✅ Include error/loading/empty states

### 2. Add Context in specs.md

✅ Describe user stories
✅ List API requirements
✅ Note business rules/validations

### 3. Use High-Quality Images

✅ High resolution (2x/Retina)
✅ Clear text/labels
✅ Visible colors/spacing

### 4. Name Folders Clearly

✅ Use kebab-case: `user-profile`
✅ Be specific: `invoice-generator` not `invoices`
✅ Group related: `order-management` not `orders` + `order-details`

### 5. Reference Existing Features

If similar feature exists, mention it:

```
"Implement the product-catalog feature, similar to customer-catalog"
```

I'll reuse existing patterns and components.

## 🔄 Iteration Workflow

After implementation, you can request changes:

```
"Update user-profile: Add social media links section"
"Fix user-profile: Make avatar larger on mobile"
"Enhance user-profile: Add skeleton loading states"
```

I'll iterate on the existing implementation.

## 📊 Progress Tracking

During implementation, I'll use todo lists to track:

- [ ] Database schema created
- [ ] Migrations run
- [ ] API endpoints implemented
- [ ] Web UI components created
- [ ] Mobile screens created
- [ ] Tests written
- [ ] Documentation updated

You can see real-time progress.

## 🎉 Ready to Use!

Simply:

1. Drop design images in `.claude/design/<feature-name>/`
2. Tell me: `"Implement the <feature-name> feature"`
3. Watch it come to life! 🚀

---

**Questions?** Just ask: "How do I use the design folder for feature X?"
