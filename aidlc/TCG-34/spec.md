# Spec — TCG-34 mobile password character reveal

## 0. Provenance

Ticket: TCG-34. Intent: `aidlc/TCG-34/intent.md`. Elaborated 2026-10-10.
Rules consulted: mobile context and AI-DLC GUIDE. The original UAT ask is unverified;
the implementation follows explicit requester authorization recorded as reference
in `vault/decisions/2026-10-09-mobile-password-character-reveal.md`, not a client ruling.

## 1. Requirements ledger

| Req | Requirement | Surface | Source | Blocks build? |
| --- | --- | --- | --- | --- |
| REQ-01 | Reveal newest typed character only while hidden | mobile | requester decision, reference | no |
| REQ-02 | Preserve initially hidden native password and eye toggle | mobile | requester decision, reference | no |
| REQ-03 | SMS verification code unchanged; shared Input owns behavior | mobile | requester decision, reference | no |

Three requirements, all requester-authorized; no verified client product ruling.

## 2. Requirements

### REQ-01 — hidden-mode reveal

- Statement: a newly typed character is briefly visible; the next edit hides it.
- Surface: Android native password rendering; existing iOS native secure-field rendering.
- Sources: decision above (reference); UAT Session 2 Login / General (unverified).
- Conflict: the original reveal direction was ambiguous; the requester selected reveal-then-hide.
- Open question: exact cross-platform duration NOT SPECIFIED by the requester.
- Ripple: login, new-password and confirm-password, found with `rg -n secureTextEntry apps/mobile`.
- Acceptance: Android native dev client shows only the latest insertion for 1500 ms,
  masks on the next edit/blur/background, and masks multi-character paste/autofill.
- Executor notes: 1500 ms matches Android's native interval. Preserve iOS system timing.

### REQ-02 — secure-field and eye behavior

- Statement: retain the true password value and native secure-field protections.
- Surface: shared Input and the existing React Native TextInput.
- Sources: requester selected native support after native versus JS trade-offs were presented.
- Conflict/open question: none for the authorized implementation.
- Ripple: all current password fields. No new password representation or JS masked value.
- Acceptance: password starts hidden; eye shows the full value and hide immediately masks
  all existing characters; text and selection survive. No password crosses the native-module API.
- Executor notes: configure the existing native view; do not replace TextInput or patch RN.

### REQ-03 — scope

- Statement: leave SMS-code rendering and ordinary inputs unchanged.
- Surface: shared Input; no login-screen-specific transformation.
- Sources: requester explicitly excluded SMS masking and requested shared Input ownership.
- Conflict/open question: none.
- Ripple: non-password Input consumers retain existing behavior; only supplied secureTextEntry
  configures native rendering.
- Acceptance: SMS code is still visible; no native module configuration for ordinary inputs.
- Executor notes: no new npm dependencies; use Expo's existing local-module autolinking.

## 3. Data model

N/A — no persistent data, schema, models or migrations.

## 4. API surface

N/A — no HTTP contract changes. Native API: configure a view tag and hidden boolean only.

## 5. Web surface

N/A — mobile ticket; React Native web retains its existing field behavior.

## 6. Mobile surface

Shared `design-system/primitives/input.tsx`; existing login/set-password routes.
Android local Expo module under `modules/password-reveal`. Existing styles and
touch targets unchanged. Offline/sync and notifications: N/A.

## 7. Shared package

N/A — no packages/shared changes.

## 8. Permissions and tenancy

No changes. The module neither stores nor sends credentials; it modifies rendering
on an already-mounted password view. Only its view tag and hidden flag cross JS/native.

## 9. Validation rules

Password lengths/strength, SMS length, authentication and server validation unchanged.

## 10. Tests

JS integration tests cover native secureTextEntry/value retention, forwarded ref,
eye toggle and SMS exclusion. Native timing/selection/autofill/background checks are
listed in the module README for a rebuilt Android dev client and an iOS device.
Tests, builds and typechecking NOT RUN per requester. Native behavior NOT VERIFIED.

## 11. Non-functional

Native interval is bounded; old visibility spans/timers are removed on edits and blur.
Native module holds weak view references. Rollout requires rebuilding Android;
Expo Go/older clients retain platform defaults. No audit/event/log of passwords.

## 11a. Ripple

Enumerated with `rg -n secureTextEntry apps/mobile/app apps/mobile/components apps/mobile/design-system`.
Three password fields use the shared Input: login; set-password new and confirm.
Other inputs do not supply secureTextEntry and are not configured. iOS/web unchanged.

## 11b. Developer decisions

Requester chose native support rather than custom JS masking, preserving secure input,
and shared Input ownership. Recorded in the decision note and Linear comment.
Local Expo module versus dependency patch is an implementation detail under that native choice;
no dependency, new exported JS component, or backend structure introduced.

## 11c. Siblings

Login/new-password/confirm-password receive the same behavior through shared Input,
as requested. SMS explicitly excluded. Future secure Input consumers inherit it.

## 12. Open questions

- Reveal direction: resolved by requester — see decision note.
- Mask SMS code: resolved by requester — no.
- Native versus JS implementation: resolved by requester — native.
- Exact timer: NOT SPECIFIED; Android standard 1500 ms and iOS system timing are
  implementation details, not human-approved numeric requirements.
- Client ratification: not recorded; do not promote the UAT source to verified.

## 13. Deliberately unspecified

No new password policy, SMS masking, cross-platform exact timer or Expo Go override.

## 14. Sign-off

Requester authorized behavior and native implementation. One unit in `units.md`.
Implementation/static inspection complete; native build and device sign-off remain pending.
