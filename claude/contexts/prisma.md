# Database context — `apps/api/prisma/`

Prisma 7 + PostgreSQL, multi-tenant.

## Identity — UUID PK plus a per-tenant business code

Every business entity has both:

```prisma
id             String @id @default(uuid()) @db.Uuid
customerCode   String                                  // per-tenant, prefixed
@@unique([tenantCompanyId, customerCode])              // NOT globally unique
```

- The business code is **never** the primary key.
- Child tables reference the parent by the UUID `id`, never by code.
- Routes and DTOs use the code for UX; the service resolves `(tenant, code) → id` once,
  then works by UUID.
- New codes are minted from `entity_sequences`.
- Two tenants can both own `QUOT-00001`. They are different rows.

### Derive the code field and prefix — do not memorise them

There are roughly **28** code-bearing models and the set grows. Any enumerated list here
would be stale within a sprint; the last one was, in several rows at once. To find them:

```bash
# the code field for a model
grep -B15 '@@unique(\[tenantCompanyId' apps/api/prisma/schema.prisma

# the prefix it is minted with
grep -rn "getNextValue" apps/api/src/usecase/<feature>/
```

Two traps when reading prefixes: some are passed as string literals
(`getNextValue('CUST')`), others through a constant (`getNextValue(PART_SEQUENCE_PREFIX)`),
so grepping only for quoted literals misses a chunk of them. And the prefix rarely matches
the model name — price listings mint `PRCL`, not `PRLT`.

## Tenant scoping is conditional — check before relying on it

Scoping is a Prisma **client extension** (`$extends` in `src/orm/prisma.service.ts`), not
`$use` middleware, which Prisma removed. It injects `tenantCompanyId` on reads and writes,
but it **skips scoping entirely** in three cases:

1. **No request context.** Anything running outside an HTTP request — cron jobs, workers,
   seeds — gets no scoping. `quotation-expiry.service.ts` documents exactly this and
   operates across all tenants deliberately.
2. **`SUPER_ADMIN`.** Scoping is bypassed by design for that role.
3. **Models outside the allowlist.** The extension carries an explicit set of tenant-scoped
   models; anything absent is untouched. Several ticket-flow models are deliberately
   excluded because they inherit isolation through their parent.

So "the middleware handles it" is not a safe assumption. For any new model, confirm whether
it is in the allowlist before relying on automatic isolation — and if it holds tenant data
and is not in it, that is a finding, not a detail.

## Conventions

- Tables `snake_case` plural via `@@map()`; columns `snake_case` via `@map()`.
- Timestamps are `@db.Timestamptz` — used ~285 times; match it.
- Indexes: `idx_<table>_<column>`; unique constraints `uq_<table>_<what>`.

## Migrations

**Any schema change requires a committed migration** under `apps/api/prisma/migrations/`.
Run `pnpm db:migrate` with a descriptive name and commit the generated SQL alongside the
feature. A model edit without a migration is an incomplete change, not a pending one.
