# Intent — SCRUM-JSA-SIGNATURES

Auto-populate customer name on field ticket signature steps, add customer and crew signature recording on JSA checklist screen with validation gate, and display JSA signatures on the web Job Progress Tracking tab.

---

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-JSA-SIGNATURES` — customer feedback / story |
| Title | Mobile ticket customer name auto-population, JSA checklist signatures, and web progress tracking display |
| Type | Story |
| Status | Complete |
| Epic | Field Operations & Ticketing |
| Sprint | Current |
| Reporter | Product / Customer Feedback |
| Assignee | Antigravity AI-DLC Pair |
| Captured on | `2026-09-25` |
| Captured by | Antigravity session, from user request |

## 2. Business intent

- **Intent**:
  1. On field mobile tickets, when reaching steps that capture the customer name, signature, and photo (`sig1`, `WTL` lunch authorization on `startWork`, and `sig2`), pre-fill the customer's name from job contact information on first arrival so the crew doesn't retype it every time. Allow editing if needed, and propagate edits forward.
  2. On the JSA checklist screen, allow capturing signatures for the Customer (1 required) and assigned Crew members (at least 1 required) with custom bottom-sheet modal signature pads.
  3. Re-use the existing `ticket_signatures` database table with synthetic step keys (`jsa:customer`, `jsa:crew:0`, `jsa:crew:1`), eliminating schema migrations and reusing existing S3 storage / attachment mechanisms.
  4. In the Office Web App (`project -> job -> progress tracking`), display the captured JSA Customer and Crew signatures under the JSA checklist step in the timeline and the JSA card in the checklists monitoring section.
- **Who benefits (role)**:
  - Field crew: Reduced friction and typing when capturing customer approvals; clear hazard tailgate sign-off from both customer and crew.
  - Project managers / Dispatchers: Immediate visibility in Progress Tracking of JSA tailgate sign-off with customer and crew member signatures, timestamps, and GPS coordinates.
- **What is worse today without it**:
  - Crew must retype customer names manually on multiple steps.
  - JSA checklist records hazard answers but captures no customer or crew sign-offs.
  - Progress Tracking shows JSA checklist inspection items but cannot verify customer or crew tailgate participation.

## 3. Definition of done, as the ticket states it

1. Customer name is auto-populated on first arrival at `sig1`, `WTL` lunch sheet, and `sig2` from job report-to contact or customer company, while remaining editable.
2. JSA screen features a bottom signatures section with:
   - Customer signature (0/1 or 1/1)
   - Crew signatures (0/N or X/N) for assigned crew members
3. Clicking on signature rows opens role-based bottom-sheet modals with name input, drawing canvas, timestamp, GPS, Clear, and Save actions.
4. Signed rows display mint-green background (`#ECFDF5`), green border, checkmark icon, and "Signed <time>".
5. JSA completion gate requires all hazard questions answered + 1 Customer signature + at least 1 Crew signature.
6. Captured signatures are persisted in `ticket_signatures` under `jsa:customer` and `jsa:crew:<idx>` without requiring identity photos.
7. Job Progress Tracking on web displays the captured JSA Customer and Crew signatures with signature images, signer names, timestamps, and GPS coordinates.

## 4. In scope

- [x] Mobile customer name auto-population helper and pre-fill across `sig1`, `WTL`, and `sig2`
- [x] Backend repository mobile ticket query to return `subJob.job.reportToContact` and crew `employeeType.name`
- [x] Backend DTO and `checklist-assignments.service.ts` to accept, persist (to `ticket_signatures`), and return JSA signatures
- [x] Backend `job-progress.service.ts` and `@tcg/shared` types to expose JSA signatures on `ProgressTicketDetail` and `ProgressChecklist`
- [x] Mobile `JsaSignatureModal.tsx` bottom sheet modal component matching user design screenshots
- [x] Mobile `JsaBody.tsx` signature cards, counters, mint-green completed status, and validation gate
- [x] Mobile `jsa-submission.ts` payload wiring
- [x] Web `JsaSignatures` component in `apps/web/src/features/ticket-progress/`
- [x] Web `JsaBody` timeline step and `ChecklistResults` / `ChecklistsSection` integration

## 5. Out of scope

- [ ] Photos for JSA signatures (explicitly not required per customer feedback)
- [ ] Adding new database tables (explicitly instructed to reuse `ticket_signatures`)
- [ ] Changes to Pre-Trip or Post-Trip signatures (they follow their existing designs)

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `packages/shared` | yes | `ProgressChecklist` & `ProgressTicketDetail` types |
| `apps/api` | yes | Job tickets repository, field ticket mapper, checklist assignments service & DTOs, job progress service |
| `apps/mobile` | yes | Field ticket contracts, customer name autofill helper, `Sig1Body`, `lunch-breaks` WTL, `Sig2Body`, `JsaSignatureModal`, `JsaBody`, `jsa-submission` |
| `apps/web` | yes | Ticket progress JSA step body and checklist results |

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `TicketSignature` | none (`stepKey` column) | Creates rows with `stepKey: 'jsa:customer'` and `'jsa:crew:<idx>'` |
| `JobTicket` | `ticketCode` | Reads / queries |
| `ChecklistAssignment` | none | Submits / queries |

- New entity introduced: no
- New code prefix introduced: no
- Database migration required: no (uses existing `ticket_signatures`)

---

**Next step:** Elaborate into `spec.md` and slice into `units.md`.
