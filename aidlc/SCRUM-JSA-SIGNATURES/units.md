# Units — SCRUM-JSA-SIGNATURES

> Written to `.ai/aidlc/SCRUM-JSA-SIGNATURES/units.md` from the approved `spec.md` beside it.

## Unit ledger

| Unit | Outcome (one line) | Reqs | Surfaces | Depends on | Size | Status |
| --- | --- | --- | --- | --- | --- | --- |
| U1 | Backend persists JSA signatures to `ticket_signatures`, returns contact & crew roles, and exposes JSA signatures in Progress Tracking read model | REQ-01, REQ-02, REQ-03 | api, shared | — | M | complete |
| U2 | Mobile auto-populates customer name on `sig1`, `WTL`, and `sig2` while remaining editable | REQ-04 | mobile | U1 | S | complete |
| U3 | Mobile JSA checklist captures Customer and Crew signatures with bottom sheet modals, mint-green cards, and validation gate | REQ-05 | mobile | U1 | M | complete |
| U4 | Web Progress Tracking displays captured JSA Customer and Crew signatures on timeline step and checklist results | REQ-06 | web | U1 | S | complete |

---

## U1 — Backend API Persistence & Read Models

- **Outcome:** Backend receives and stores JSA signatures in `ticket_signatures`, provides `reportToName` and crew `role` on mobile tickets, and includes JSA signatures in `ProgressTicketDetail` on the web progress tracking endpoint.
- **Kind:** vertical / foundation
- **Requirements covered:** REQ-01, REQ-02, REQ-03
- **Depends on:** —

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Schema (`apps/api/prisma`) | N/A | Reuses existing `ticket_signatures` table |
| API (`apps/api`) | `job-tickets.repository.ts`, `field-ticket.mapper.ts`, `submit-jsa-checklists.dto.ts`, `checklist-assignments.service.ts`, `job-progress.service.ts` | Persist and read `jsa:*` signatures |
| Shared (`packages/shared`) | `job-progress.types.ts` | Add JSA signatures to `ProgressTicketDetail` and `ProgressChecklist` |
| Tests | API unit tests for checklist assignments and job progress | Ensure persistence and read model coverage |

---

## U2 — Mobile Customer Name Auto-population

- **Outcome:** Field crew opening `sig1`, `WTL` lunch authorization, or `sig2` sees the customer name pre-filled from job contact or prior steps instead of typing it from scratch.
- **Kind:** vertical
- **Requirements covered:** REQ-04
- **Depends on:** U1

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Mobile (`apps/mobile`) | `customer-name-autofill.ts`, `ticket.contract.ts`, `Sig1Body.tsx`, `lunch-breaks.tsx`, `Sig2Body.tsx` | Auto-populate customer name on mount if empty |
| Tests | `customer-name-autofill.test.ts`, `Sig1Body.test.tsx`, `Sig2Body.test.tsx` | Verification of auto-fill logic |

---

## U3 — Mobile JSA Checklist Signatures UI & Validation Gate

- **Outcome:** Field crew on JSA checklist screen can record Customer (1 required) and Crew ($\ge 1$ required) signatures via bottom sheet modals with green completion state and validation enforcement.
- **Kind:** vertical
- **Requirements covered:** REQ-05
- **Depends on:** U1

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Mobile (`apps/mobile`) | `checklist.contract.ts`, `capture.ts`, `JsaSignatureModal.tsx`, `JsaBody.tsx`, `jsa-submission.ts` | Signature rows, bottom sheet modals, mint-green cards, validation gate |
| Tests | `JsaBody.test.tsx`, `jsa-submission.test.ts` | UI rendering, validation, and payload formatting |

---

## U4 — Web Progress Tracking Display for JSA Signatures

- **Outcome:** Dispatch and office staff viewing `project -> job -> progress tracking` can view captured JSA Customer and Crew signatures with signature images, timestamps, and GPS coordinates.
- **Kind:** vertical
- **Requirements covered:** REQ-06
- **Depends on:** U1

### Slice contents

| Layer | Change | Notes |
| --- | --- | --- |
| Web (`apps/web`) | `jsa-signatures.tsx`, `step-bodies/checklist.tsx`, `checklist-results.tsx` | Render JSA signatures in timeline step and checklists section |
| Tests | Web node test or component test | Ensure no regressions in progress tracking |

---

## Sequencing

```
U1 ──▶ U2
U1 ──▶ U3
U1 ──▶ U4
```

- **Parallelisable:** U2, U3, and U4 can be executed in sequence or in parallel once U1 is in place because they touch separate mobile steps and web UI.
