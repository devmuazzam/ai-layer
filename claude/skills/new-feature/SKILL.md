---
name: new-feature
description: Create a new feature module following TCG Clean Architecture and Atomic Design. Use when adding a new backend module, web feature area, or full-stack feature named by the user.
---

Create a new feature module using the name the user provided, following TCG patterns.

## Steps

1. **API Layer** (if backend needed):
   - Create `src/presentation/<feature>/` with controller + DTOs
   - Create `src/usecase/<feature>/` with service + module
   - Create `src/service/<feature>/` with repository
   - Add Prisma model if needed, run `pnpm db:migrate`
   - Register in `app.module.ts`

2. **Web Layer** (if frontend needed):
   - Create `features/<feature>/` with views, hooks, components
   - Use Atomic Design: atoms, molecules, organisms
   - Follow URL patterns: list, create, details, edit

3. **Shared** (if cross-platform):
   - Add types/enums to `packages/shared/src/`
   - Export from barrel `index.ts`

4. **Verification**:
   - Run `pnpm lint` and `pnpm build`
   - Ensure barrel exports everywhere

Always follow existing patterns in the codebase.
