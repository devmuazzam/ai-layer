---
paths:
  - 'apps/api/prisma/**'
  - '**/*.prisma'
---

# Prisma Database Rules

## Model Pattern

```prisma
model User {
  id           String   @id @default(uuid())
  email        String   @unique
  passwordHash String   @map("password_hash")
  createdAt    DateTime @default(now()) @map("created_at") @db.Timestamptz
  updatedAt    DateTime @updatedAt @map("updated_at") @db.Timestamptz

  @@map("users")
  @@index([email], name: "idx_users_email")
}
```

## Naming Conventions

| Entity    | Convention                      | Example                     |
| --------- | ------------------------------- | --------------------------- |
| Model     | PascalCase                      | `User`, `Customer`          |
| Field     | camelCase                       | `createdAt`, `passwordHash` |
| DB column | snake_case via `@map()`         | `password_hash`             |
| DB table  | snake_case plural via `@@map()` | `users`                     |
| Index     | `idx_<table>_<column>`          | `idx_users_email`           |

## Business ID Convention (CRITICAL — Multi-Tenant UUID PKs)

Every business entity has a UUID surrogate PK **plus** a per-tenant prefixed business
code. Codes are unique per tenant, not globally — two tenants can each own `QUOT-00001`.

```prisma
model Customer {
  id              String @id @default(uuid()) @db.Uuid
  tenantCompanyId String @map("tenant_company_id") @db.Uuid
  customerCode    String @map("customer_code") @db.VarChar(50)  // CUST-00001

  @@unique([tenantCompanyId, customerCode], name: "uq_customers_tenant_code")
  @@index([tenantCompanyId], name: "idx_customers_tenant_company_id")
  @@map("customers")
}

model Quotation {
  id              String  @id @default(uuid()) @db.Uuid
  tenantCompanyId String  @map("tenant_company_id") @db.Uuid
  quoteNo         String  @map("quote_no") @db.VarChar(50)
  customerId      String? @map("customer_id") @db.Uuid
  customer        Customer? @relation(fields: [customerId], references: [id], onDelete: SetNull)

  @@unique([tenantCompanyId, quoteNo], name: "uq_quotations_tenant_code")
  @@map("quotations")
}
```

**Rules**:

- PK is the UUID `id`. Never make the business code the PK.
- Business code column is `@@unique([tenantCompanyId, <codeField>])`.
- Child FKs reference the parent's UUID `id` (`customerId`, `quotationId`, ...), never the code.
- Route params and DTOs still expose the code (`/customers/:customerCode`); services resolve `code → id` via `findFirst({ where: { customerCode } })` — Prisma middleware adds `tenantCompanyId` automatically.
- Mint new codes with `entity_sequences` (already tenant-scoped by `(tenantCompanyId, prefix)`).
- Polymorphic columns (`Attachment.featureId`, `ActivityLog.entityId`) stay as business codes; tenant isolation comes from the sibling `tenantCompanyId` column.

### Service-layer code → UUID resolution

```typescript
// Accept the business code on the boundary…
async update(customerCode: string, data: UpdateCustomerInput) {
  const existing = await this.customersRepository.findByCode(customerCode);
  if (!existing) throw new NotFoundException(`Customer "${customerCode}" not found`);

  // …then operate by UUID internally.
  return this.customersRepository.update({ id: existing.id }, data);
}
```

## Data Types

- **Dates**: Always `@db.Timestamptz`
- **Money**: `Decimal` with precision
- **Status**: Enums with `UPPER_SNAKE_CASE` values

## Seed Script

```typescript
// Idempotent: check before insert
const existing = await prisma.user.findUnique({ where: { email } });
if (!existing) {
  await prisma.user.create({ data: { ... } });
}
```

## Migrations when tables change (MANDATORY)

Whenever you **add or edit** a Prisma model used by a list/API feature (new table, column, index, nullability, relation):

1. Update `apps/api/prisma/schema.prisma`.
2. Run `pnpm db:migrate` with a descriptive migration name.
3. Commit the generated folder under `apps/api/prisma/migrations/`.

Do **not** merge schema-only changes without a migration file. UI-only table work with no schema change does not need a migration.

See `apps/api/prisma/MIGRATION_BASELINE.md` for recovery and ordering notes.

## Commands

```bash
pnpm db:generate   # Regenerate client after schema changes
pnpm db:migrate    # Create + run migration (dev)
pnpm db:deploy     # Run pending migrations (prod)
pnpm db:studio     # Visual database browser
pnpm db:reset      # Reset DB + re-seed
```
