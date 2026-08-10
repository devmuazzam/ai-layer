---
name: review-pr
description: Review code changes for quality, TCG patterns, and issues. Use when reviewing a PR, diff, branch changes, uncommitted changes, or before merging.
---

Review the current changes for code quality and TCG patterns.

## Review Checklist

1. **Architecture**
   - API: Clean Architecture layers respected?
   - Web: Atomic Design hierarchy followed?
   - No upward imports?

2. **Naming**
   - Files: kebab-case
   - Classes: PascalCase
   - Functions: camelCase
   - DB: snake_case with @map()

3. **TypeScript**
   - No `any` types
   - Proper interfaces
   - Strict mode compliance

4. **Identity Convention**
   - UUID PK (`id`) plus per-tenant business code (`CUST-00001`, `QUOT-00001`, etc.)
   - Routes/DTOs use business codes; services resolve code → UUID

5. **UI (Web)**
   - Responsive patterns used
   - Touch targets 44px+
   - Existing components reused
   - CommonTable search/filter conventions

6. **Quality**
   - Barrel exports present
   - No hardcoded values
   - Error handling

## Output

Provide:

- Summary of changes
- Issues found (with file:line references)
- Suggestions for improvement
