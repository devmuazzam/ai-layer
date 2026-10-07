# Surcharge stepper — failed save falls back, one save per burst, step follows typed decimals, 44px buttons

**Date:** 2026-10-07
**Decider:** Haris (team lead) for the failed-save fallback, approved and confirmed to Akif on
2026-10-07;
Akif for the debounce, the toast slot, the step size and the button size, the same day
**Ticket:** TCG-103

## Decision

On the **Billing Codes → Surcharge** card and the **Price Listing → Surcharge** card:

1. **A failed save falls back to the server value.** When a percentage save fails (+/- or
   typing a value and leaving the box), the card shows the value the server holds again.
   The red error toast stays.
2. **One save per burst of clicks.** +/- updates the number at once and saves once, 500 ms
   after the last click. Typing in the box or using the switch cancels a waiting stepper
   save; leaving the page sends it.
3. **One toast slot.** Every surcharge success or error toast carries the id
   `surcharge-update`, so a new one replaces the last in the same place instead of stacking.
   Other toasts on the page are unaffected.
4. **44px buttons.** The Billing Codes stepper matches the Price Listing one: 44×44px
   +/- buttons, 16px value.
5. **The step follows the typed decimals.** 5 → steps of 1, 0.5 → 0.1, 0.25 → 0.01. Until
   the user types, it follows the shown value, locked at the first click so 0.9 → 1 does not
   switch to whole steps. Results round to two decimals.

## Context

The UAT register row *"Surcharge +/- fires a toast on every click"*
(`uat/register-2026-09-18.md`) could not be traced to any UAT session. While checking it,
the ticket found a worse bug: the save cleared the on-screen draft only on success, so a
failed save left the rejected number showing as if saved, and the next click counted from
it. That was fixed first, since a wrong number on screen is wrong under any reading of
intent. Items 2–5 were the ticket's deferred half; the team decided them without tracing
the original reporter.

## Impact

- Failed save: `features/surcharges/utils/persist-surcharge-percentage.ts`, used by all four
  save sites in `billing-code-surcharge-card.tsx` and `price-listing-surcharge-card.tsx`.
  The ticket named three; the Price Listing blur handler had the same bug.
- Debounce: `features/surcharges/utils/trailing-debounce.ts` and
  `hooks/use-surcharge-save-debounce.ts`.
- Step: `features/surcharges/utils/surcharge-step.ts` and `hooks/use-surcharge-step.ts`. The
  shared `AdjustmentCard` now rounds +/- results to two decimals; Discount and Price Hike
  still step by 1 and show nothing different.
- Toast: `toastMutationSuccess` takes an optional options argument (none of its other
  callers pass one). `lib/toast-core.ts` swaps a same-id toast into the old one's slot
  instead of appending below it while the old one animates out. Only id-carrying toasts
  change: surcharge, and notification toasts when the same notification arrives twice.
- Buttons: Billing Codes stepper restyled only; the card is not replaced by `AdjustmentCard`.
- Tests: `persist-surcharge-percentage`, `trailing-debounce` and `surcharge-step`, in the
  web `test` target. No API change, no `data-testid` change.
- Not covered: the Create Price List form's Surcharge card still steps by 1; slow clicks
  (over 500 ms apart) still save once each, now in one toast slot.

Client commits on branch `TCG-103`: `e8e66c2ab`, `b296356a2`, `3f9a504f7`.
