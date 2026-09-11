---
title: Billing code types — the master picklist dropped on 2026-09-11, recorded for restore
source: repo history — commit b4cef85b1 on branch fix/das-fixes (pre-rebase 12c3c4e30, same patch-id) and its parent tree; migrations 20260706130000, 20260807180000, 20260911040000; apps/api/fcc-seeder (code and generated docs); read-only check of the local dev database, 2026-09-11
created: 2026-09-11
updated: 2026-09-11
status: reference
conflicts_with: []
jira: []
tags: [module/quotations, module/admin, kind/reference, pricing, reference-data, data-migration, architecture]
---

# Billing code types — the dropped master picklist, recorded for restore

> ## ⛔ This is an archive of removed code. It is never a source for a spec.
>
> Sections 1, 2, 4 and 5 describe what was built and then deleted. Under `close-ticket` →
> *The one thing this never does*, shipped behaviour is not product memory: nothing here
> answers *"what should billing code types do?"* or *"should they exist?"*. This file sits in
> the vault only because the drop decision
> ([../decisions/2026-09-11-billing-code-type-master-dropped.md](../decisions/2026-09-11-billing-code-type-master-dropped.md))
> required everything dropped to be kept here. It follows the same rule as
> `claude/skills/demo-walkthrough/WALKTHROUGH.md`. Only §3.1 and §3.3 (what FCC holds) are source
> data about the legacy system.

**What this is.** A record of everything commit `b4cef85b1` removed from the product, kept so the
billing-code-type catalogue can be re-added and re-seeded later without digging through git
history. It describes code that no longer exists. **It is not a requirement**, and nothing here
says the catalogue should come back.

**Not to be confused with** the billing-code form's **Type** field, whose accessible name
(`aria-label`) and quick-create error text say *"Billing code type"*. That field is the
`typeCategory` resource classifier (`BillingCodeTypeSelect`, testid
`billing-code-classification`: ASSETS / EMPLOYEES / CUSTOM plus the resource). The drop kept it.

## 0. Why and when

- **Commit.** `b4cef85b1`, *"refactor(billing-codes): remove unused billing code type master
  picklist"*, by Jz-Nd, 2026-09-11, on `fix/das-fixes`. It is the same patch as the pre-rebase
  `12c3c4e30` (identical `git patch-id`). A squash merge will give it a third SHA, so find it by
  subject: `git log --all --oneline --grep 'remove unused billing code type master picklist'`.
  Before using a squash SHA, read §5 step 2. 55 files, +34 / −1639.
- **Migration.** `20260911040000_drop_billing_code_types` (§1.4).
- **Stated reason** (the commit message): *"Drop the display-only billing_code_types catalog,
  optional FK, Settings CRUD, and related seeds/E2E. Keep typeCategory (ASSETS/EMPLOYEES/CUSTOM)
  for resource classification."* The type was optional on a billing code, and nothing priced,
  filtered or routed on it. It was set on the two billing-code forms and shown on the billing-code
  detail page.
- **Who decided.** The developer in the `fix/das-fixes` review session, 2026-09-11 (named in
  the decision note). The drop stays on condition that this record exists. See
  [../decisions/2026-09-11-billing-code-type-master-dropped.md](../decisions/2026-09-11-billing-code-type-master-dropped.md).
  That note is `status: reference`: binding on the CodingCops build, and open to being overruled
  by TCG. It is the authority on the decision, and this file is only the record behind it.
- **What the product record says.** That decision note surfaces the product record and does not
  resolve it. Nothing written from TCG says the lookup is unneeded. TCG's reviewed FCC slides show
  Billing Code Types as a live 37-row lookup ([fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md)
  → *Billing Code Types (slide 12)*), and the unverified punch list
  [billing-code-and-price-list.md](billing-code-and-price-list.md) asked for *"billing code type
  CRUD"*, which is what this code implemented. The decision supersedes that ask for the CodingCops
  build. A later requirement might want FCC's Billing Type back, for FCC-import parity or for
  `Mobilization` as a billing type ([mobilization-and-demobilization.md](mobilization-and-demobilization.md)).
  If so, §5 is the way back.
- **Rollout caveat of the drop itself.** While the deploy rolls out, old API tasks still select
  `billing_codes.billing_code_type_id`, and old web bundles that send `billingCodeTypeId` get a
  `400`, because the validation pipe runs `forbidNonWhitelisted`.

## 1. Database objects

The drop removed table `billing_code_types`, enum `"BillingCodeTypeStatus"`, column
`billing_codes.billing_code_type_id`, FK `billing_codes_billing_code_type_id_fkey` and index
`idx_billing_codes_tenant_billing_code_type_id`. The table's own PK, unique index, tenant index and
tenant FK went with it.

### 1.1 Created — `20260706130000_add_billing_code_types_and_extra_fields` (verbatim, billing-code-type part)

```sql
-- CreateEnum
CREATE TYPE "BillingCodeTypeStatus" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateTable
-- Global master list of billing code types (e.g. "MOB" — Mobilization,
-- "OT" — Overtime). Not tenant-scoped, same reference list shared by every
-- tenant — mirrors the "states"/"countries"/"cities" master-table pattern.
CREATE TABLE "billing_code_types" (
    "id" UUID NOT NULL,
    "code" VARCHAR(50) NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "status" "BillingCodeTypeStatus" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "billing_code_types_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "billing_code_types_code_key" ON "billing_code_types"("code");

-- ─── Link billing_codes → billing_code_types (optional — 0 or 1 type) ─────────
--
-- Nullable, so no backfill of existing "billing_codes" rows is required.

-- AlterTable
ALTER TABLE "billing_codes" ADD COLUMN "billing_code_type_id" UUID;

-- CreateIndex
CREATE INDEX "idx_billing_codes_tenant_billing_code_type_id" ON "billing_codes"("tenant_company_id", "billing_code_type_id");

-- AddForeignKey
ALTER TABLE "billing_codes" ADD CONSTRAINT "billing_codes_billing_code_type_id_fkey" FOREIGN KEY ("billing_code_type_id") REFERENCES "billing_code_types"("id") ON DELETE SET NULL ON UPDATE CASCADE;
```

The same migration then adds `gl_account`, `auto_allocate`, `taxable` and `percent_applied` to
`billing_codes`. The drop did not touch those columns.

### 1.2 Tenant-scoped — `20260807180000_tenant_scope_billing_types_addresses_contacts`, section 1 (verbatim)

```sql
ALTER TABLE "billing_code_types"
  ADD COLUMN IF NOT EXISTS "tenant_company_id" UUID;

-- Allow duplicate codes while cloning globals into per-tenant rows
DROP INDEX IF EXISTS "billing_code_types_code_key";
ALTER TABLE "billing_code_types" DROP CONSTRAINT IF EXISTS "billing_code_types_code_key";

-- Staging: keep original global rows (tenant_company_id IS NULL) as templates.
-- Clone one set per tenant with new UUIDs.
CREATE TEMP TABLE "_bct_clone_map" (
  "old_id" UUID NOT NULL,
  "tenant_company_id" UUID NOT NULL,
  "new_id" UUID NOT NULL,
  "code" VARCHAR(50) NOT NULL,
  PRIMARY KEY ("old_id", "tenant_company_id")
);

INSERT INTO "_bct_clone_map" ("old_id", "tenant_company_id", "new_id", "code")
SELECT
  bct.id,
  tc.id,
  gen_random_uuid(),
  bct.code
FROM "billing_code_types" bct
CROSS JOIN "tenant_companies" tc
WHERE bct.tenant_company_id IS NULL;

INSERT INTO "billing_code_types" (
  "id",
  "tenant_company_id",
  "code",
  "title",
  "status",
  "created_at",
  "updated_at"
)
SELECT
  m.new_id,
  m.tenant_company_id,
  bct.code,
  bct.title,
  bct.status,
  bct.created_at,
  NOW()
FROM "_bct_clone_map" m
JOIN "billing_code_types" bct ON bct.id = m.old_id;

-- Remap billing_codes to the clone for that tenant + code
UPDATE "billing_codes" bc
SET "billing_code_type_id" = m.new_id
FROM "_bct_clone_map" m
WHERE bc.billing_code_type_id = m.old_id
  AND bc.tenant_company_id = m.tenant_company_id;

-- Drop FKs that still point at orphaned global templates
UPDATE "billing_codes"
SET "billing_code_type_id" = NULL
WHERE "billing_code_type_id" IN (
  SELECT id FROM "billing_code_types" WHERE tenant_company_id IS NULL
);

DELETE FROM "billing_code_types" WHERE tenant_company_id IS NULL;

DROP TABLE "_bct_clone_map";

-- If no tenants existed, table may be empty — still enforce NOT NULL going forward
-- by requiring tenant_company_id on all remaining rows.
ALTER TABLE "billing_code_types"
  ALTER COLUMN "tenant_company_id" SET NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS "billing_code_types_tenant_company_id_code_key"
  ON "billing_code_types" ("tenant_company_id", "code");

CREATE INDEX IF NOT EXISTS "idx_billing_code_types_tenant_company_id"
  ON "billing_code_types" ("tenant_company_id");

ALTER TABLE "billing_code_types"
  DROP CONSTRAINT IF EXISTS "billing_code_types_tenant_company_id_fkey";

ALTER TABLE "billing_code_types"
  ADD CONSTRAINT "billing_code_types_tenant_company_id_fkey"
  FOREIGN KEY ("tenant_company_id") REFERENCES "tenant_companies"("id")
  ON DELETE CASCADE ON UPDATE CASCADE;
```

### 1.3 The pre-drop shape, as restore SQL

This SQL was generated on 2026-09-11 with an offline schema-to-schema diff (no database
involved): `prisma migrate diff --from-schema <schema at b4cef85b1> --to-schema <schema at
b4cef85b1^> --script`. A forward restore migration should contain exactly these statements, and
every object name matches §1.1–§1.2. The only difference is harmless: in the original table,
`tenant_company_id` was physically last, because it was appended by `ALTER TABLE`.

```sql
-- CreateEnum
CREATE TYPE "BillingCodeTypeStatus" AS ENUM ('ACTIVE', 'INACTIVE');

-- AlterTable
ALTER TABLE "billing_codes" ADD COLUMN     "billing_code_type_id" UUID;

-- CreateTable
CREATE TABLE "billing_code_types" (
    "id" UUID NOT NULL,
    "tenant_company_id" UUID NOT NULL,
    "code" VARCHAR(50) NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "status" "BillingCodeTypeStatus" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "billing_code_types_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "idx_billing_code_types_tenant_company_id" ON "billing_code_types"("tenant_company_id");

-- CreateIndex
CREATE UNIQUE INDEX "billing_code_types_tenant_company_id_code_key" ON "billing_code_types"("tenant_company_id", "code");

-- CreateIndex
CREATE INDEX "idx_billing_codes_tenant_billing_code_type_id" ON "billing_codes"("tenant_company_id", "billing_code_type_id");

-- AddForeignKey
ALTER TABLE "billing_codes" ADD CONSTRAINT "billing_codes_billing_code_type_id_fkey" FOREIGN KEY ("billing_code_type_id") REFERENCES "billing_code_types"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "billing_code_types" ADD CONSTRAINT "billing_code_types_tenant_company_id_fkey" FOREIGN KEY ("tenant_company_id") REFERENCES "tenant_companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;
```

The reverse diff confirms that the drop commit changed nothing else in the schema.

### 1.4 The drop — `20260911040000_drop_billing_code_types` (verbatim)

```sql
-- Drop optional billing code type master picklist (display/metadata only).

ALTER TABLE "billing_codes" DROP CONSTRAINT IF EXISTS "billing_codes_billing_code_type_id_fkey";

DROP INDEX IF EXISTS "idx_billing_codes_tenant_billing_code_type_id";

ALTER TABLE "billing_codes" DROP COLUMN IF EXISTS "billing_code_type_id";

DROP TABLE IF EXISTS "billing_code_types";

DROP TYPE IF EXISTS "BillingCodeTypeStatus";
```

### 1.5 Prisma model text (verbatim, from `b4cef85b1^:apps/api/prisma/schema.prisma`)

```prisma
enum BillingCodeTypeStatus {
  ACTIVE
  INACTIVE
}

// Per-tenant master list of billing code types (e.g. "MOB" — Mobilization,
// "OT" — Overtime). Each tenant owns an independent catalog (seeded with
// defaults on tenant create).
//
// Named `BillingCodeTypeMaster` (rather than `BillingCodeType`) to avoid
// clashing with `BillingCode.typeCategory` — the DB table itself is
// `billing_code_types`.
model BillingCodeTypeMaster {
  id              String                @id @default(uuid()) @db.Uuid
  tenantCompanyId String                @map("tenant_company_id") @db.Uuid
  code            String                @db.VarChar(50)
  title           String                @db.VarChar(255)
  status          BillingCodeTypeStatus @default(ACTIVE)

  createdAt DateTime @default(now()) @map("created_at") @db.Timestamptz()
  updatedAt DateTime @updatedAt @map("updated_at") @db.Timestamptz()

  tenantCompany TenantCompany @relation(fields: [tenantCompanyId], references: [id], onDelete: Cascade)
  billingCodes  BillingCode[]

  @@unique([tenantCompanyId, code])
  @@index([tenantCompanyId], name: "idx_billing_code_types_tenant_company_id")
  @@map("billing_code_types")
}
```

The lines removed from other models:

```prisma
// model TenantCompany
  billingCodeTypes             BillingCodeTypeMaster[]

// model BillingCode — field, relation, index
  billingCodeTypeId String?                 @map("billing_code_type_id") @db.Uuid
  billingCodeType   BillingCodeTypeMaster? @relation(fields: [billingCodeTypeId], references: [id], onDelete: SetNull)
  @@index([tenantCompanyId, billingCodeTypeId], name: "idx_billing_codes_tenant_billing_code_type_id")
```

`schema.dbml` only ever had the `Enum BillingCodeTypeStatus { ACTIVE INACTIVE }` block and a
`billing_code_type_id uuid` line in `Table billing_codes`. It never had a
`Table billing_code_types` block.

The model comment says the catalogue was *"seeded with defaults on tenant create"*. That stopped
being true on 2026-08-25 (§2.2).

## 2. Default seed values

### 2.1 `BILLING_CODE_TYPES` — 35 rows, all ACTIVE (verbatim, from `apps/api/src/utility/seed-data.ts`)

The spelling `Long Subsustence` is in the source.

```ts
// Per-tenant master list of billing code types — seeded for each tenant on create.
export const BILLING_CODE_TYPES = [
  { code: 'BR', title: 'Bare Rental', status: 'ACTIVE' },
  { code: 'COMP', title: 'Compliance Paperwork', status: 'ACTIVE' },
  { code: 'CR', title: 'Crawler Crane', status: 'ACTIVE' },
  { code: 'CRW', title: 'Crew Time', status: 'ACTIVE' },
  { code: 'CUR', title: 'Curfew Stand By Time', status: 'ACTIVE' },
  { code: 'CWT', title: 'Counter Weight Truck', status: 'ACTIVE' },
  { code: 'DBL', title: 'Double Time', status: 'ACTIVE' },
  { code: 'DEMOB', title: 'DeMobilization', status: 'ACTIVE' },
  { code: 'FAA', title: 'FAA Permit', status: 'ACTIVE' },
  { code: 'LBP', title: 'Long Boom Pay', status: 'ACTIVE' },
  { code: 'LSUB', title: 'Long Subsustence', status: 'ACTIVE' },
  { code: 'LT', title: 'Lift Plan', status: 'ACTIVE' },
  { code: 'MOB', title: 'Mobilization', status: 'ACTIVE' },
  { code: 'MV', title: 'On-site Move', status: 'ACTIVE' },
  { code: 'NOT', title: 'Notam', status: 'ACTIVE' },
  { code: 'OPL', title: 'Operator Load', status: 'ACTIVE' },
  { code: 'OT', title: 'Overtime', status: 'ACTIVE' },
  { code: 'P&T', title: 'Permits and Traffic Control', status: 'ACTIVE' },
  { code: 'PA', title: 'Price Adjustment', status: 'ACTIVE' },
  { code: 'PI', title: 'Pilot Car', status: 'ACTIVE' },
  { code: 'PW', title: 'Prevailing Wage', status: 'ACTIVE' },
  { code: 'RCS', title: 'RCS', status: 'ACTIVE' },
  { code: 'RIGGERS', title: 'Riggers', status: 'ACTIVE' },
  { code: 'SL', title: 'Self Loader', status: 'ACTIVE' },
  { code: 'SPE EQUIP', title: 'Special Equipment', status: 'ACTIVE' },
  { code: 'ST', title: 'Standard Crane', status: 'ACTIVE' },
  { code: 'STORAGE', title: 'Storage', status: 'ACTIVE' },
  { code: 'SUB', title: 'Subsistence', status: 'ACTIVE' },
  { code: 'SUPP', title: 'Support Load', status: 'ACTIVE' },
  { code: 'SUR', title: 'Fuel & Insurance Surcharge', status: 'ACTIVE' },
  { code: 'SURCHARGE', title: 'Surcharge', status: 'ACTIVE' },
  { code: 'TP', title: 'Travel Permit', status: 'ACTIVE' },
  { code: 'TPL', title: 'Holiday Triple Time', status: 'ACTIVE' },
  { code: 'TPR', title: 'Travel Permit with Runner', status: 'ACTIVE' },
  { code: 'TRUCKING', title: 'Trucking', status: 'ACTIVE' },
] as const;
```

### 2.2 Where the seed ran

- **`seedDatabase()`**, the demo seed, called `await seedBillingCodeTypes(prisma, tenant.id, log);`
  for `TCG-DEFAULT` only (`pnpm db:seed`, `GET /seed/run`).
- **`apps/api/prisma/scripts/seed-billing-code-types.ts`** seeded one tenant, named by
  `SEED_TENANT_CODE` (§2.3).
- **Not on tenant creation.** `seedTenantDefaults()` seeded the catalogue from `4b02a6440`
  (2026-08-07) until `70faaf3ba` (2026-08-25, SCRUM-537) removed the call. `seedTenantDefaults()`
  now has no callers anywhere. A tenant created after 2026-08-25 had no types unless someone ran
  the script.
- **E2E run tenant.** `qa-automation/e2e/support/seed/shared-catalogs.ts` created two types per run
  (code `E2EBCT-<runId>-<n>`, title `E2E Shared BCType <runId> <n>`).

### 2.3 `seedBillingCodeTypes()` and the one-tenant script (verbatim)

```ts
/**
 * Upserts the default billing code type catalog for a tenant.
 * Idempotent — safe to call from prisma seed and on tenant creation.
 */
export async function seedBillingCodeTypes(
  prisma: PrismaClient,
  tenantId: string,
  log: (msg: string) => void = () => undefined,
): Promise<void> {
  for (const type of BILLING_CODE_TYPES) {
    await prisma.billingCodeTypeMaster.upsert({
      where: {
        tenantCompanyId_code: {
          tenantCompanyId: tenantId,
          code: type.code,
        },
      },
      update: { title: type.title, status: type.status },
      create: {
        tenantCompanyId: tenantId,
        code: type.code,
        title: type.title,
        status: type.status,
      },
    });
  }
  log(`Billing code types synced/upserted: ${BILLING_CODE_TYPES.length}`);
}
```

```ts
/**
 * Seed script: Billing Code Types for a single tenant.
 *
 * Populates `billing_code_types` from the shared `BILLING_CODE_TYPES` list for
 * the tenant named by `SEED_TENANT_CODE`. Idempotent — upserts by `(tenant, code)`.
 * Never iterates every tenant.
 *
 * Run with: SEED_TENANT_CODE=ISO-TST npx ts-node --transpile-only prisma/scripts/seed-billing-code-types.ts
 */

import 'dotenv/config';
import { PrismaClient } from '@prisma/client';
import { Pool } from 'pg';
import { PrismaPg } from '@prisma/adapter-pg';
import { resolveSeedTenant, seedBillingCodeTypes } from '../../src/utility/seed-data';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  const tenant = await resolveSeedTenant(prisma);
  await seedBillingCodeTypes(prisma, tenant.id, (msg) => console.log(`[${tenant.tenantCode}] ${msg}`));
  console.log(`Billing code types seeded for tenant ${tenant.tenantCode}`);
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
```

### 2.4 Demo billing code → type links (`CRANE_GUYS_BILLING_CODES`, tenant `TCG-DEFAULT`)

`seedCraneGuysOperationalData()` gave 12 of the demo billing codes a `billingCodeTypeCode`, as
follows:

| `billingCodeId` | Name | `typeCategory` | Billing code type |
| --- | --- | --- | --- |
| `BLCD-00001` | Crane Operator – Standard | EMPLOYEES | `CRW` |
| `BLCD-00002` | Crane Operator – Overtime | EMPLOYEES | `OT` |
| `BLCD-00003` | Oiler | EMPLOYEES | `CRW` |
| `BLCD-00004` | Rigger | EMPLOYEES | `RIGGERS` |
| `BLCD-00005` | Driver | EMPLOYEES | `CRW` |
| `BLCD-00006` | Mechanic – Field Service | EMPLOYEES | `CRW` |
| `BLCD-00007` | All Terrain Crane – Day Rate | ASSETS | `ST` |
| `BLCD-00008` | Rough Terrain Crane – Day Rate | ASSETS | `ST` |
| `BLCD-00009` | Boom Truck – Hourly | ASSETS | `BR` |
| `BLCD-00010` | Lowboy Trailer – Day | ASSETS | `TRUCKING` |
| `BLCD-00011` | Oversize Permit Fee | CUSTOM | `P&T` |
| `BLCD-00012` | Pilot Car Escort | CUSTOM | `PI` |

The removed lookup code (verbatim):

```ts
  const billingCodeTypeIdByCode = new Map<string, string>();
  const billingCodeTypeMasters = await prisma.billingCodeTypeMaster.findMany();
  for (const t of billingCodeTypeMasters) billingCodeTypeIdByCode.set(t.code, t.id);
  // … per code:
    const billingCodeTypeId = bc.billingCodeTypeCode
      ? (billingCodeTypeIdByCode.get(bc.billingCodeTypeCode) ?? null)
      : null;
```

⚠ **Restore caveat.** This `findMany()` runs on a raw `PrismaClient`, so the tenant extension does
not apply, and it has no `where`. The map therefore held whichever tenant's row came last for each
code. On a database with several tenants, the demo codes could point at another tenant's type row.
When restoring, add `where: { tenantCompanyId: tenantId }`.

## 3. FCC billing types, and each FCC code → type link

### 3.1 Where the FCC data lives

- **Server.** FCC (NexGen FMS) SQL Server, read-only test catalogue `NexGenFMS-Test`. Connection
  keys are in `apps/api/fcc-seeder/config/env.example`; credentials are in `tcg/app-secrets`. The
  seeder refuses the production catalogue `NexGenFMS`.
- **Types.** `dbo.FMS_BILLING_CODES_TYPE`, columns `BillingCodeType` (the code), `Description` and
  `Status`. It had **35 rows** in the generated snapshots (`fcc-seeder/docs/field-gaps.md`,
  2026-08-20, and `seed-files-index.md`, 2026-08-27), with the audit columns populated on all 35.
- **Links.** `dbo.FMS_BILLING_CODES.BillingCodeType` holds one type code per billing code. That
  table had **365 rows** in the same snapshot.

### 3.2 How fcc-seeder loaded them (removed code, verbatim)

Extract (`fcc-seeder/src/extract-seed-files.ts`). This wrote `seed-files/billing-code-types.json`,
and its module name sat in `SEED_MODULE_ORDER` between `quotation-lost-reasons` and
`billing-codes`:

```ts
    const billingTypes = await loadTable(pool, 'FMS_BILLING_CODES_TYPE');
    files.push({
      module: 'billing-code-types',
      tcgModel: 'BillingCodeTypeMaster',
      fccTable: 'FMS_BILLING_CODES_TYPE',
      count: billingTypes.length,
      preview: [],
      records: billingTypes.map((row) => ({
        fccId: asRequiredString(getRaw(row, ['BillingCodeType']), 'unknown'),
        id: uuidFromFcc('bctype', asRequiredString(getRaw(row, ['BillingCodeType']), 'unknown')),
        code: asRequiredString(getRaw(row, ['BillingCodeType']), 'unknown', 50),
        title: asRequiredString(getRaw(row, ['Description']), 'Untitled', 255),
        status: mapStatus(getRaw(row, ['Status'])),
      })),
    });
```

Seed (`fcc-seeder/src/seed-all.ts`). This inserted the types, then linked each billing code:

```ts
    const billingTypes = loadRecords('billing-code-types');
    const billingTypeIds = new Set<string>();
    await createMany(
      'billing-code-types',
      billingTypes.map((row) => {
        const fccId = requiredStr(row, 'fccId', 'unknown');
        const id = ids.of('bctype', fccId);
        billingTypeIds.add(id);
        return {
          id,
          tenantCompanyId: tenantId,
          code: requiredStr(row, 'code', fccId, 50),
          title: requiredStr(row, 'title', fccId, 255),
          status:
            mapUpperStatus(str(row, 'status')) === 'INACTIVE'
              ? BillingCodeTypeStatus.INACTIVE
              : BillingCodeTypeStatus.ACTIVE,
          createdAt: now,
          updatedAt: now,
        };
      }),
      (chunk) => prisma.billingCodeTypeMaster.createMany({ data: chunk, ...many }),
    );
```

```ts
      const typeFcc = str(row, 'billingCodeType');
      const typeId = typeFcc ? ids.of('bctype', typeFcc) : null;
      // … in the billing-code row:
        billingCodeTypeId: typeId && billingTypeIds.has(typeId) ? typeId : null,
      // … and for the extra (non-FCC) billing codes:
        billingCodeTypeId: null,
```

The IDs are deterministic. `ids.of('bctype', code)` is `uuidFromFcc('<tenantCode>:bctype', code)`,
which gives `sha256("fcc:<tenantCode>:bctype:<code>")` shaped as a v4 UUID. A re-sync therefore
reproduces the same UUIDs per tenant.

The fcc-seeder had four more entries, each deleted by the drop:

- `seeded-modules.ts`: `{ module: 'billing-code-types', fccTable: 'FMS_BILLING_CODES_TYPE' }`
- `reset-tenant.ts`: `await tx.billingCodeTypeMaster.deleteMany({ where: { tenantCompanyId: tenantId } });`
- `generate-field-gaps.ts`: the *Billing code types* module (`mappedFcc`
  `['BillingCodeType', 'Description', 'Status']`, `mappedTcg` `['code', 'title', 'status']`) and
  `'billingCodeTypeId'` in the billing-codes `mappedTcg`
- `classify-fcc-table.ts`: a `queued` / `billing-code-types` rule, which the drop turned into
  `no-tcg-equivalent` / *"Removed: TCG no longer stores a billing code type master picklist"*.
  Its pattern `/billing.?code.?type|billcode.?type/iu` never matched `FMS_BILLING_CODES_TYPE`
  (plural `CODES`), so the table was always classified by the later `/billing.?code|billcode/iu`
  rule as *Queued — billing-codes*. Later on 2026-09-11, on the same branch, the pattern was
  widened to `/billing.?codes?.?type|billcode.?type/iu`, and `docs/fcc-unmapped-entities.md` now
  lists the table under *FCC has data — no TCG equivalent*.

### 3.3 What could be copied on 2026-09-11: nothing from FCC itself

Three sources were checked before this record was written. **None holds the FCC values, so
they are not embedded here.**

- **Extracted seed JSON.** None exists. `apps/api/fcc-seeder/seed-files/` is gitignored and held
  only `.gitkeep`. A search of the developer's machine found no `billing-code-types.json` or
  `billing-codes.json`, and no SQL dump containing `billing_code_types`.
- **Local dev database (`tcg_db`), read-only SELECTs.** `_prisma_migrations` shows
  `20260911040000_drop_billing_code_types` applied on 2026-09-11 at 03:34 (+05). The table, the
  column and the enum are gone. No FCC tenant exists on this database: its tenants are
  `PLATFORM`, `TCG`, `TCG-2`, `TCG-DEFAULT` and four `SMK*` smoke tenants, and only `TCG-DEFAULT`
  has billing codes (20). No per-tenant row export was possible. For `TCG-DEFAULT`, the lost
  content was §2.1 plus the §2.4 links.
- **Second local database (`tcg_db_scrum540`), read-only SELECTs, 2026-09-11.** Its newest applied
  migration is `20260706000000_drop_legacy_sub_category_code` (31 applied), so it predates
  `20260706130000_add_billing_code_types_and_extra_fields`: `to_regclass('public.billing_code_types')`
  is NULL and the drop migration is not applied. It never held the catalogue. Its tenants are
  `PLATFORM`, `TCG`, `TCG-2`, `TCG-DEFAULT` and four `SMK*` smoke tenants — no FCC tenant. The
  check used, for any other database that turns up:

  ```sql
  BEGIN READ ONLY;
  SELECT migration_name, finished_at FROM _prisma_migrations
  WHERE migration_name LIKE '20260911040000%';
  SELECT to_regclass('public.billing_code_types');
  COMMIT;
  ```

  If the table is there, export both of these and append them as §3.5, per tenant, TCG first:

  ```sql
  SELECT tc.tenant_code, t.code, t.title, t.status
  FROM billing_code_types t JOIN tenant_companies tc ON tc.id = t.tenant_company_id
  ORDER BY (tc.tenant_code <> 'TCG'), tc.tenant_code, t.code;

  SELECT tc.tenant_code, bc.billing_code_id, bc.name, t.code
  FROM billing_codes bc
  JOIN tenant_companies tc ON tc.id = bc.tenant_company_id
  JOIN billing_code_types t ON t.id = bc.billing_code_type_id
  ORDER BY (tc.tenant_code <> 'TCG'), tc.tenant_code, bc.billing_code_id;
  ```

The closest copies that do exist:

1. **§2.1.** 35 codes, the same count as `FMS_BILLING_CODES_TYPE` on `NexGenFMS-Test`. The list is
   probably transcribed from that table, but this is **not verified**.
2. **The vault's screenshot of FCC's list:** [fcc-billing-data-and-price-lists.md](fcc-billing-data-and-price-lists.md)
   → *Billing Code Types (slide 12)*, 37 rows, all Active. It differs from §2.1. The slide has
   `CO` *Certified Operator* and `RT` *Rough Terrain Crane*, which the seed lacks, and it spells
   `LSUB` *Long Subsistence*.
3. **A handful of real code → type pairs, from screenshots:** the same file → *Billing Codes – WPF
   (slides 5–10)*. For example, *275 Ton Crane* → Standard Crane, the `109`/`110` LADWP
   portal-to-portal codes → Mobilization, `116 LADWP Item 116 Fuel Surcharge` → Surcharge, and
   `110 / 130 / 150 Ton RT` → Rough Terrain Crane.

**What still survives in code.** The billing-codes extract still reads
`FMS_BILLING_CODES.BillingCodeType` into every `billing-codes.json` record, as `billingCodeType`.
`seed-all.ts` still reads it, but only to choose `typeCategory`, via `billingTypeCategory()` in
`fcc-seeder/src/lib/seed-helpers.ts`:

| FCC billing code type | → `typeCategory` |
| --- | --- |
| `CRW` `CUR` `DBL` `LSUB` `OPL` `OT` `PW` `RIGGERS` `SUB` `SUPP` `TPL` | EMPLOYEES |
| `BR` `CR` `CWT` `LBP` `SL` `SPE EQUIP` `ST` `STORAGE` `TRUCKING` | ASSETS |
| anything else, including `MOB` `DEMOB` `SUR` `SURCHARGE` `P&T`, or blank | CUSTOM |

So the per-code link can be recovered from any fresh extract with no change to the extractor.
The type list itself needs §3.4.

### 3.4 Extraction steps

**Option A: SQL, read-only, against `NexGenFMS-Test`.**

```sql
-- the type catalogue (35 rows at the last snapshot)
SELECT BillingCodeType AS code, Description AS title, Status
FROM dbo.FMS_BILLING_CODES_TYPE
ORDER BY BillingCodeType;

-- every billing code's type (365 rows at the last snapshot)
SELECT BillingCodeID, Description, BillingCodeType, Status
FROM dbo.FMS_BILLING_CODES
ORDER BY BillingCodeID;
```

The extractor also accepted `BillingID` for the code column, so use whichever exists. The
seeder's status mapping was: `0`, `i`, `t`, `inactive`, `terminated`, `false` or `n` → INACTIVE,
and anything else → ACTIVE.

**Option B: the seeder's own extract, which makes no TCG writes.** From `apps/api`, with the FCC
keys in `.env`, run `npx ts-node --transpile-only fcc-seeder/src/extract-seed-files.ts`. It reads
FCC, writes `fcc-seeder/seed-files/*.json`, rewrites `fcc-seeder/docs/seed-files-index.md`, and
does not touch Postgres. Today `billing-codes.json` already carries `billingCodeType` for each
code. To also get `billing-code-types.json`, first restore the §3.2 extract block.
**Do not use `pnpm fcc:sync` just to extract: it wipes and reloads the target tenant.**

When the values are extracted, append them to this file as a dated §3.5, TCG tenant first, so the
record is complete.

## 4. Removed code paths

**API, deleted files:**

- `apps/api/src/presentation/billing-code-types/`: `billing-code-types.controller.ts`,
  `dto/create-billing-code-type.dto.ts`, `dto/update-billing-code-type.dto.ts`, `dto/index.ts`,
  `index.ts`
- `apps/api/src/usecase/billing-code-types/`: `billing-code-types.module.ts`,
  `billing-code-types.service.ts`, `index.ts`
- `apps/api/src/service/billing-code-types/`: `billing-code-types.repository.ts`,
  `billing-code-types.repository.spec.ts`, `index.ts`
- `apps/api/prisma/scripts/seed-billing-code-types.ts`

**Endpoints removed.** All five were under `@Controller('billing-code-types')`:

- `GET /billing-code-types`: public and active-only, `@SkipThrottle()`, `QueryPickerDto`. It
  returned a paginated page when given `search`, `page` or `limit`, and the full list otherwise.
- `GET /billing-code-types/admin`: `QueryReferenceCodeListDto`.
- `POST /billing-code-types`: body `code` (≤ 50), `title` (≤ 255), optional `status`
  `ACTIVE | INACTIVE`.
- `PATCH /billing-code-types/:id`.
- `DELETE /billing-code-types/:id`: a soft archive to `INACTIVE`.

Every endpoint except the public `GET` was `@Roles(ADMIN, SUPER_ADMIN)`.

**API, edited files:**

| File | What was removed |
| --- | --- |
| `apps/api/src/app.module.ts` | `import { BillingCodeTypesModule } from '@usecase/billing-code-types';` and `BillingCodeTypesModule` in `imports` |
| `apps/api/src/orm/prisma.service.ts` | `'billingcodetypemaster'` in `tenantModels`. **Without this entry, no query on the table is tenant-scoped** |
| `apps/api/src/presentation/billing-codes/dto/create-billing-code.dto.ts` | `billingCodeTypeId?: string`, with `@ApiPropertyOptional` `@IsOptional()` `@IsUUID()`. `UpdateBillingCodeDto` is `PartialType` of it |
| `apps/api/src/service/billing-codes/billing-codes.repository.ts` | `billingCodeType: { select: { id: true, code: true, title: true } }` in `BILLING_CODE_INCLUDE` |
| `apps/api/src/usecase/billing-codes/billing-codes.service.ts` | `billingCodeTypeId: dto.billingCodeTypeId ?? null,` on create |
| `apps/api/src/presentation/shared/dto/query-reference-code-list.dto.ts` | `billing-code-types` in the doc comment |
| `apps/api/src/usecase/admin/admin-tenants.service.spec.ts` | test title only |
| `apps/api/src/utility/seed-data.ts` | §2.1–§2.4 |
| `apps/api/prisma/schema.prisma`, `schema.dbml` | §1.5 |

**Web, deleted files:**

- `apps/web/src/app/(protected)/settings/billing-code-types/page.tsx`
- `apps/web/src/features/settings/views/billing-code-types-tab.tsx`
- `apps/web/src/features/settings/views/billing-code-types-tab-parts.tsx`
- `apps/web/src/features/billing-codes/components/billing-code-type-master-select.tsx`
- `apps/web/src/features/billing-codes/hooks/use-billing-code-types.ts`
- `apps/web/src/features/billing-codes/services/billing-code-types.service.ts`

**Web, edited files:**

| File | What was removed |
| --- | --- |
| `components/sidebar/sidebar-nav-groups.tsx` | Settings item `{ label: 'Billing Code Types', view: 'settings-billing-code-types' }` |
| `components/sidebar/sidebar-routing.ts` | route `/settings/billing-code-types`, label, breadcrumb `['settings', 'settings-billing-code-types']`, path matcher |
| `components/sidebar/sidebar.types.ts` | `ViewType` `'settings-billing-code-types'`, and its entry in `SETTINGS_VIEWS` |
| `features/billing-codes/components/billing-code-form.tsx` | *Billing Code Type* field (`BillingCodeTypeMasterSelect`) |
| `features/billing-codes/views/create-billing-code-modal.tsx`, `create-billing-code-modal-extra-fields.tsx` | the same field on the quick-create modal |
| `features/billing-codes/view/billing-code-details.tsx` | `InfoRow` *Billing Code Type* |
| `features/billing-codes/schemas/billing-code.schema.ts`, `services/billing-codes.service.ts` | `billingCodeTypeId` / `billingCodeType` in the form schema and types |
| `features/settings/views/settings-editor-modal-close.test.mjs` | `'Billing Code Types'` in `SETTINGS_DROPDOWN_LABELS` (between `'Work Comp Codes'` and `'Certificates'`) and the `{ fileName: 'billing-code-types-tab-parts.tsx', recordField: 'billingCodeType' }` entry in `EDITOR_SOURCES`. The same hunk also deleted stale expectations unrelated to the drop, already failing at the parent: the `'Categories'`, `'Sub-Categories'` and `'Craft Codes'` labels and the `/settings/categories` / `/settings/sub-categories` `router.push` assertions. Do not restore those. |

**Test IDs removed:** `billing-codes-form-billing-code-type` and
`billing-codes-create-billing-code-type`. The Settings tab also had its own copies of
`reference-code-form`, `reference-code-code`, `reference-code-label` and `reference-code-submit`;
those IDs still exist on the shared `ReferenceCodeManager`.

**qa-automation, edited files:**

- `e2e/specs/settings/sections.spec.ts`: `@SETT-038` (lifecycle and code-only uniqueness) and
  `@SETT-039` (form quirks)
- `e2e/specs/settings/consumers.spec.ts`: `@SETT-040` (archived types leave the billing-code
  dropdown)
- `e2e/specs/settings/settings.fixtures.ts`: the `billingCodeTypes` `PicklistPage`
- `e2e/support/api/reference-code-api.ts`: `PICKLIST_SECTIONS.billingCodeTypes`, the only section
  with `labelField: 'title'`
- `e2e/support/seed/shared-catalogs.ts`: two per-run types (§2.2)
- `e2e/support/api/types/accounting.ts`
- `e2e/specs/accounting/{accounting.page.ts,billing-code-create.spec.ts,billing-code-lifecycle.spec.ts}`

`SETT-041` (seeded types present) was manual-only and has no subject now.

**fcc-seeder, edited files:** `src/extract-seed-files.ts`, `src/seed-all.ts`,
`src/generate-field-gaps.ts`, `src/lib/{classify-fcc-table,reset-tenant,seeded-modules}.ts` and
`docs/seed-files-index.md` (§3.2). On the same branch, the generated `docs/field-gaps.md` lost its
*Billing code types* section by hand, matching what the generator now emits.

## 5. Restore recipe

1. **Find the commit** (§0).
2. **Revert it, but keep the drop migration.**

   ```bash
   git revert --no-commit <sha>
   # never delete an applied migration — put the drop back and restore forward
   git checkout HEAD -- apps/api/prisma/migrations/20260911040000_drop_billing_code_types
   ```

   Resolve conflicts against whatever has changed since; `seed-data.ts` and the sidebar files are
   the likely ones. To restore selectively instead, bring back every deleted file (the lists in
   §4):

   ```bash
   SHA=<sha>   # b4cef85b1 on fix/das-fixes; find the merged one with the grep in §0
   git checkout "$SHA^" -- \
     apps/api/src/presentation/billing-code-types \
     apps/api/src/usecase/billing-code-types \
     apps/api/src/service/billing-code-types \
     apps/api/prisma/scripts/seed-billing-code-types.ts \
     'apps/web/src/app/(protected)/settings/billing-code-types' \
     apps/web/src/features/settings/views/billing-code-types-tab.tsx \
     apps/web/src/features/settings/views/billing-code-types-tab-parts.tsx \
     apps/web/src/features/billing-codes/components/billing-code-type-master-select.tsx \
     apps/web/src/features/billing-codes/hooks/use-billing-code-types.ts \
     apps/web/src/features/billing-codes/services/billing-code-types.service.ts
   ```

   Then reverse only the drop's hunks in each edited file. Take care, because the paths overlap
   with later work:

   ```bash
   git show "$SHA" -- <edited path> | git apply -R --3way
   ```

   If the grep in §0 finds only a squash-merge commit, that SHA is the whole `fix/das-fixes` PR.
   Do not `git revert` it or `git apply -R` its hunks: shared files (`schema.prisma` and
   `schema.dbml` as of 2026-09-11) also carry that PR's PO status/type and permit catalog changes.
   Use the original commit instead (GitHub keeps it reachable with
   `git fetch origin pull/<PR number>/head`), or restore by hand from §1.5, §2 and §4.

   Exception: for `apps/web/src/features/settings/views/settings-editor-modal-close.test.mjs`,
   keep the current file (after a `git revert`, `git checkout HEAD -- <that path>`) and re-add
   only the two billing-code-type entries named in §4.
3. **Write a forward migration.** With the Prisma model back (§1.5), from `apps/api` run
   `npx prisma migrate dev --create-only --name restore_billing_code_types`. Diff the generated SQL
   against §1.3; they should be identical. Never edit or remove `20260911040000`.
4. **Check tenant scoping.** Confirm `'billingcodetypemaster'` is back in `tenantModels` in
   `apps/api/src/orm/prisma.service.ts`. A revert restores it, but a hand restore can miss it, and
   without it the table is read across tenants.
5. **Re-seed.**
   - Demo tenant: `pnpm db:seed` (`TCG-DEFAULT` only) reseeds §2.1 and the §2.4 links.
   - Any other tenant: from `apps/api`, run
     `SEED_TENANT_CODE=<code> npx ts-node --transpile-only prisma/scripts/seed-billing-code-types.ts`.
     This seeds types only, with no links.
   - FCC tenant: once the §3.2 blocks are back, `pnpm fcc:sync` wipes and reloads that tenant with
     FCC's types and the per-code links.
   - Every other existing billing code comes back with a NULL type. Backfill from the link query in
     §3.4 if that matters.
6. **Fix these before shipping a restore:**
   - Scope the demo seed's `billingCodeTypeMaster.findMany()` by tenant (§2.4).
   - Keep the classifier's widened pattern `/billing.?codes?.?type|billcode.?type/iu`, which
     matches `FMS_BILLING_CODES_TYPE` (§3.2). It was widened after the drop, so a `git revert`
     conflicts on that rule: resolve it to the `queued` / `billing-code-types` tag and reason with
     the widened pattern, and put `'billing-code-types'` back in the `QueuedModule` union.
   - Correct the `UpdateBillingCodeTypeDto` doc: it describes `code` as *"globally unique"*, but
     codes have been per-tenant since `20260807180000`.
7. **Update the clients.** `billingCodeTypeId` must be back on `CreateBillingCodeDto` before any
   client sends it, because `forbidNonWhitelisted` returns `400` for an unknown field. Restore the
   two test IDs in §4 (run `grep -rn` over `qa-automation/e2e` first), then `@SETT-038`, `@SETT-039`
   and `@SETT-040` with their fixtures and the shared-catalog seed. Also restore the Settings row
   in the demo walkthrough (`.ai/claude/skills/demo-walkthrough/WALKTHROUGH.md`, step 2).
