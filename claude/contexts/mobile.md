# Mobile context — `apps/mobile/`

Expo SDK 54 + Expo Router. The field-operations app.

## Structure

File-based routing via Expo Router. Feature code sits alongside it in `features/`,
`components/`, `hooks/`, `services/`, `session/`, `lib/` and `design-system/`.

Aliases: `@/*` maps to the app root (**not** `./src/*` as on web — mobile has no `src/`).
`@tcg/shared` is a `workspace:*` dependency resolved to its **built `dist/`** — the old
`paths` alias to `packages/shared/src` is gone; do not re-add it. Nx builds shared before
`mobile:start`; if you are editing shared while the app runs, keep
`pnpm --filter @tcg/shared dev` (`tsc --watch`) open.

## Styling — not Tailwind

This surface shares no styling stack with web. Use `StyleSheet.create` (~116 files do) and
take values from `theme/tokens.ts`. Tailwind classes, `cn()`, CVA and `theme.css` do not
exist here.

Web's design-system rules do not apply to this surface, whatever their frontmatter may
claim. If a web rule mentions Tailwind, shadcn or CSS variables, it is not about mobile.

Touch targets ≥ 48px, not web's 44px.

## Tokens and secrets

Auth tokens go in `expo-secure-store` — see `lib/token-storage.ts` and `lib/base-api.ts`.
Never `AsyncStorage` for credentials.

## Product intent

The field-ops app is the least settled area in the product record: several documents
describe it and they disagree, with none verified. **Read
`.ai/vault/product/field-ops-mobile-INDEX.md` before building any field-ops behaviour**,
and do not resolve the disagreement in code.

Requirement ids are ambiguous here — both field-ops FRDs number from `FR-FOP-001`, so a
bare id identifies nothing. Always cite the document alongside the id.

## Caveat on this file

Mobile rules were historically wired to nothing and are the least exercised of the four
surface contexts. Treat gaps here as unwritten rather than intentional, and check the code
before assuming a convention exists.
