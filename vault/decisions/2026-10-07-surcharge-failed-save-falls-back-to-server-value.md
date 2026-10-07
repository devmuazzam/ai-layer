# Surcharge stepper — failed save falls back, one save per burst, one toast slot, 44px buttons

**Date:** 2026-10-07
**Decider:** Haris (team lead) for the failed-save fallback, approved and confirmed to Akif on
2026-10-07; Akif for the debounce, the toast slot, the button size, the step size and the
Discount / Price Hike scope, the same day
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
5. **+/- move the whole-number part by 1 and keep the decimals; the arrow keys fine-tune by
   0.01.** 12.5 + → 13.5, ↑ → 12.51. Buttons are for quick, coarse changes; the keyboard is
   for precise ones, and the decimals a user typed are kept. The buttons already worked this
   way; the Billing Codes box's arrows already moved by 0.01, and the Price Listing Discount,
   Price Hike and Surcharge cards (detail page and Create Price List form) now match it (their
   arrows moved by 1 and snapped 12.5 → 13). Results round to two decimals, so 0.57 + 1 shows
   1.57. Tried and dropped the same day: a step that followed the typed decimals (too many
   edge cases), whole-number snapping, and 0.01 buttons.
6. **Discount and Price Hike get items 1–3** (same +/- control on the Price Listing page):
   failed save falls back, one save per burst, one toast slot (`price-list-update`).

## Context

The UAT register row *"Surcharge +/- fires a toast on every click"*
(`uat/register-2026-09-18.md`) could not be traced to any UAT session. While checking it,
the ticket found a worse bug: the save cleared the on-screen draft only on success, so a
failed save left the rejected number showing as if saved, and the next click counted from
it. That was fixed first, since a wrong number on screen is wrong under any reading of
intent. Items 2–6 were the ticket's deferred half; the team decided them without tracing
the original reporter.

## Impact

- Failed save, surcharge: `features/surcharges/utils/persist-surcharge-percentage.ts`, used
  by all four save sites in `billing-code-surcharge-card.tsx` and
  `price-listing-surcharge-card.tsx`. The ticket named three; the Price Listing blur handler
  had the same bug.
- Failed save, Discount / Price Hike: `createPersistPercentageField` in
  `price-listings/views/price-listing-inline-validation.helpers.ts`.
- Debounce: `apps/web/src/lib/trailing-debounce.ts` and `hooks/use-stepper-save-debounce.ts`,
  used by both surcharge cards and by Discount / Price Hike in
  `price-listing-overview-section.tsx`.
- Toasts: `toastMutationSuccess` takes an optional options argument (none of its other
  callers pass one). `lib/toast-core.ts` swaps a same-id toast into the old one's slot
  instead of appending below it while the old one animates out. Ids: `surcharge-update`
  (surcharge hooks) and `price-list-update` (`useUpdatePriceListing`, also used by the
  create/edit price list form). Notification toasts also carry ids and get the same swap.
- Step: `PERCENTAGE_STEP` (0.01, the arrow-key step) and `roundPercentage` in
  `lib/percentage-input.ts`, used by the Billing Codes stepper and the shared `AdjustmentCard`,
  whose `step` prop now sets only the arrow-key step (buttons always ±1). All six Price
  Listing cards, detail and create, behave the same way.
- Buttons: Billing Codes stepper restyled only; the card is not replaced by `AdjustmentCard`.
- Tests: `persist-surcharge-percentage`, `trailing-debounce` and `percentage-input`, in the
  web `test` target. No API change, no `data-testid` change.
- Not covered: slow clicks (over 500 ms apart) still save once each, now in one toast slot.
  The Create Price List form saves on submit, so items 1–3 do not apply there.

Client work is on branch `TCG-103`.
