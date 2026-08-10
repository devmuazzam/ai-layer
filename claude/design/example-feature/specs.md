# Example Feature - User Dashboard

> This is an example of how to structure a feature request

## 📸 Design Files

- `overview.png` - Main dashboard layout
- `desktop.png` - Desktop view (1920×1080)
- `mobile.png` - Mobile view (375×667)
- `interactions.png` - Hover states and interactions
- `assets/` - Icons and images used in the design

## 📝 Feature Description

A user dashboard that displays:

- User statistics (orders, revenue, activity)
- Recent orders table
- Quick actions (create order, view reports)
- Activity timeline

## 👤 User Stories

- As a user, I want to see my dashboard when I log in
- As a user, I want to see my key metrics at a glance
- As a user, I want to view my recent orders
- As a user, I want quick access to common actions

## 🔌 API Requirements

### Endpoints Needed

#### GET /api/dashboard/stats

Returns user statistics:

```json
{
  "totalOrders": 150,
  "totalRevenue": 45000,
  "pendingOrders": 12,
  "completedOrders": 138
}
```

#### GET /api/dashboard/recent-orders

Returns recent orders with pagination:

```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 150
  }
}
```

#### GET /api/dashboard/activity

Returns user activity timeline:

```json
{
  "activities": [
    {
      "id": "ACT-001",
      "type": "order_created",
      "message": "Created order ORD-12345",
      "timestamp": "2024-03-15T10:30:00Z"
    }
  ]
}
```

## 🗄️ Database Changes

### New Tables

#### `user_activities` table

```prisma
model UserActivity {
  id          String   @id @default(cuid())
  userId      String   @map("user_id")
  activityType String  @map("activity_type") // order_created, order_completed, etc.
  message     String
  metadata    Json?    // Additional activity data
  createdAt   DateTime @default(now()) @map("created_at")

  user User @relation(fields: [userId], references: [id])

  @@index([userId, createdAt])
  @@map("user_activities")
}
```

### Schema Updates

Add relation to User model:

```prisma
model User {
  // ... existing fields
  activities UserActivity[]
}
```

## 🎨 Design Specifications

### Colors

Use existing theme variables:

- Background: `--color-bg-primary`
- Cards: `--color-bg-secondary`
- Text: `--color-text-primary`
- Brand: `--color-utility-brand-600`

### Typography

- Dashboard title: 32px, Bold
- Card titles: 18px, Semibold
- Stats numbers: 36px, Bold
- Labels: 14px, Medium

### Spacing

- Card padding: 24px
- Card gap: 16px
- Section margins: 32px
- Stats card min-height: 120px

### Components

Reuse existing components:

- `<StatsCard />` from atoms/cards
- `<DataTable />` from organisms/tables
- `<ActivityTimeline />` from molecules/timeline (or create if needed)
- `<Button />` from atoms/buttons

## 🔒 Permissions

- **Role**: All authenticated users
- **Permissions**:
  - Users can only view their own dashboard
  - Admins can view any user's dashboard via `/dashboard/:userId`

## ✅ Validation Rules

- Date ranges for filtering: Max 1 year
- Pagination: Max 100 items per page
- Activity types: Enum of valid types

## 🚀 Performance Requirements

- Dashboard loads in <1 second
- Stats query optimized with indexes
- Activity timeline paginated (show last 20)
- Implement caching for stats (5 minute TTL)

## 📱 Responsive Behavior

### Desktop (1024px+)

- 3-column stats grid
- Full-width table
- Sidebar with activity timeline

### Tablet (768px-1023px)

- 2-column stats grid
- Full-width table
- Activity timeline below main content

### Mobile (375px-767px)

- 1-column stats grid (stacked cards)
- Horizontal scrollable table
- Collapsible activity section

## 🎯 Interactions

### Stats Cards

- Hover: Slight elevation shadow
- Click: Navigate to detailed view
- Loading: Skeleton placeholder

### Recent Orders Table

- Sortable columns: Date, Amount, Status
- Filterable: Status dropdown
- Pagination: 10 items per page
- Row click: Navigate to order detail

### Activity Timeline

- Auto-refresh: Every 30 seconds
- Infinite scroll: Load more on scroll
- Real-time: WebSocket for new activities (optional)

## 🧪 Test Scenarios

### Unit Tests

- Stats calculation logic
- Activity filtering
- Date range validation

### Integration Tests

- GET /api/dashboard/stats returns correct data
- GET /api/dashboard/recent-orders with pagination
- GET /api/dashboard/activity filters by user

### E2E Tests

- User logs in → sees dashboard
- Stats cards display correct numbers
- Recent orders table loads and is sortable
- Activity timeline displays recent activities

## 📚 Additional Notes

- Consider adding chart.js for revenue trend graph (future enhancement)
- May need export to PDF feature later
- Dark mode support required
- Should work offline (show cached data)

## 🔗 Related Features

- Similar to: `admin-dashboard` (but user-specific)
- Integrates with: `order-management`, `user-profile`
- Shares components with: `analytics-page`

---

## 🚀 Implementation Request

To implement this feature, simply say:

```
"Implement the example-feature"
```

Or for this specific feature:

```
"Implement the user-dashboard feature"
```

I will:

1. ✅ Read all images from this folder
2. ✅ Parse this specs.md file
3. ✅ Implement database changes (Prisma migration)
4. ✅ Create API endpoints (NestJS controllers + services)
5. ✅ Build web UI (Next.js components)
6. ✅ Create mobile screens (Expo)
7. ✅ Write tests (API + UI)
8. ✅ Update documentation

All following the design system rules and coding standards! 🎉
