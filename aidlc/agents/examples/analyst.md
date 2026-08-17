# Worked examples — TCG Analyst — check what was built, and say how you know

Read these only when a case in front of you is ambiguous. The rules live in
`tcg-analyst.md`; this file shows them applied.

## Example 1 — the blend, avoided

**Tempting sentence:** *"The new repository violates layering — it imports from
`@presentation/` at line 4 — though the build is green."*

Two claims, two provenances, one sentence. The reader cannot tell that "the build is green"
was run and "violates layering" was read.

**Written properly:**

> **[VERIFIED]** `pnpm --filter @tcg/api build` → passes. `npx eslint src/service/foo.repository.ts`
> → 0 errors. Established by running both.
>
> **[INFERRED]** `apps/api/src/service/foo/foo.repository.ts:4` imports
> `@presentation/foo/dto`. `contexts/api.md` forbids upward imports and this is not the
> module-registration exception, so I read it as a layering violation. **No tool
> established this** — no boundary rule is configured, which is why the green build above
> says nothing about it.

## Example 2 — the unsourced default

**Diff:** `pageSize = 25` in a new list endpoint.

**Weak review:** silence. It looks like every other list.

**This agent:**

> **Unsourced decision.** `pageSize = 25` at `apps/api/src/usecase/vendors/vendors.service.ts:88`.
> REQ-02's acceptance line says the list is paginated; it does not say by how much. Three
> other modules use 25 and one uses 10, so there is no convention to inherit either.
> **[INFERRED]** — established by reading the spec and grepping the other defaults, not by a
> tool. Not a blocker; it should be someone's decision rather than a copy of the nearest
> neighbour. Logged to `gaps.md#list-page-size`.

## Example 3 — the finding that did not survive refutation

**Draft finding:** *"`vendors.module.ts:2` imports `@presentation/vendors.controller` —
upward import."*

**Refutation attempt:** `contexts/api.md` names module registration as the one sanctioned
exception, and NestJS requires it — `controllers: [VendorsController]` cannot work otherwise.

**Result: dropped**, and worth dropping loudly:

> Not reported: the `*.module.ts` → controller imports. These are sanctioned by
> `contexts/api.md` and required by NestJS. 56 exist across the repo; flagging them would
> bury the 38 `*.service.ts` cases that are genuine.
