# TCG-34 — native password character reveal

Captured 2026-10-09; implementation resumed 2026-10-10. Path A: new behavior.

The requester resolved the ambiguous UAT ask in the Codex session: retain the
initially hidden password and full-value eye toggle, briefly show only the newest
typed character while hidden, then mask it. Leave the six-digit SMS code unchanged.
The requester explicitly chose native support over custom JavaScript masking.

Source: `vault/decisions/2026-10-09-mobile-password-character-reveal.md`, status
reference, explicit requester authorization; no client ratification claimed.
The decision was also recorded on Linear TCG-34, comment
`629bf003-bab6-40f8-b1de-032af5c6e1a7`.

Scope: shared mobile Input and native Android rendering, reaching login,
new-password and confirm-password. iOS retains native secure input/reveal behavior.
No API, schema, web, shared-package or SMS-flow change. New native Android builds
are required; Expo Go keeps platform defaults. No JS plaintext-masking fallback.

Builds, tests and typechecking must not be run under the requester's standing
instruction. Device validation remains pending; do not close the ticket or claim shipped.
