# Spec — SCRUM-JSA-SIGNATURES

> Written to `.ai/aidlc/SCRUM-JSA-SIGNATURES/spec.md` from `intent.md` beside it.

## 0. Provenance

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-JSA-SIGNATURES` |
| Intent | `.ai/aidlc/SCRUM-JSA-SIGNATURES/intent.md`, captured 2026-09-25 |
| Elaborated on | 2026-09-25 |
| Open questions raised | none |
| Already-shipped behaviour reached | Mobile `Sig1Body`, `lunch-breaks` WTL, `Sig2Body`, `JsaBody`, `checklist-assignments.service`, `job-progress.service`, web `ticket-progress` |
| Rules consulted | `AGENTS.md`, `.ai/claude/contexts/api.md`, `.ai/claude/contexts/mobile.md`, `.ai/claude/contexts/web.md`, `.ai/claude/contexts/prisma.md` |

## 1. Requirements ledger

| Req | Title | Surface | Flag | Sources | Blocks build? |
| --- | --- | --- | --- | --- | --- |
| REQ-01 | Backend JSA signature persistence in `ticket_signatures` | api | `[VERIFIED]` | Decision: reuse `ticket_signatures` table | no |
| REQ-02 | Field ticket job report-to contact & crew roles | api | `[UNVERIFIED]` | Mobile customer name & crew card display | no |
| REQ-03 | Shared types & Progress Tracking read model | shared, api | `[VERIFIED]` | Office progress tracking read model | no |
| REQ-04 | Mobile customer name auto-population (`sig1`, `WTL`, `sig2`) | mobile | `[UNVERIFIED]` | Customer feedback 1 | no |
| REQ-05 | Mobile JSA checklist signatures UI & validation gate | mobile | `[UNVERIFIED]` | Customer feedback 2 & design screenshots | no |
| REQ-06 | Web Progress Tracking display of JSA signatures | web | `[UNVERIFIED]` | Job progress tracking display requirement | no |

## 2. Requirements

### REQ-01 — Backend JSA Signature Persistence in `ticket_signatures` `[VERIFIED]`
- **Description**: Reusing the `ticket_signatures` table, `ChecklistAssignmentsService.submitJsa` shall persist signatures sent with the JSA submission payload.
- **Step keys**:
  - Customer signature: `stepKey: 'jsa:customer'`
  - Crew signatures: `stepKey: 'jsa:crew:<idx>'` (or `jsa:crew:<employeeId>`)
- **Fields recorded**: `jobTicketId`, `stepKey`, `signerName`, `signatureAttachmentId`, `gpsLatitude`, `gpsLongitude`, `capturedAt`, `capturedByUserId`, `tenantCompanyId`.
- **Photo requirement**: `identityPhotoAttachmentId` is explicitly **null** for JSA signatures.
- **Read back**: `getJsaForTicket` shall query `ticket_signatures` where `stepKey` begins with `jsa:` and include them in the response.

### REQ-02 — Field Ticket Job Report-To Contact & Crew Roles `[UNVERIFIED]`
- **Description**: In `JobTicketsRepository.findForEmployeeMobile`, query `subJob.job.reportToContact: { select: { name: true } }` and `employees.employee.employeeType: { select: { name: true } }`.
- **Mapping**: In `field-ticket.mapper.ts`:
  - Map `reportToName: ticket.subJob.job.reportToContact?.name ?? null` into `FieldTicketJob`.
  - Map `role: ticketEmployee.employee.employeeType?.name ?? null` into `FieldTicketEmployee`.

### REQ-03 — Shared Types & Progress Tracking Read Model `[VERIFIED]`
- **Description**:
  - In `packages/shared/src/types/job-progress.types.ts`:
    - Add `jsa?: { customer: ProgressSignature | null; crew: ProgressSignature[]; } | null` to `ProgressTicketDetail['signatures']`.
    - Add `signatures?: { customer: ProgressSignature | null; crew: ProgressSignature[]; } | null` to `ProgressChecklist`.
  - In `JobProgressService`:
    - In `toSignatures(ticket)`: extract `jsa:customer` and `jsa:crew:*` from `ticket.signatures` into `signatures.jsa`.
    - In `toChecklists(ticket)`: for checklist assignment where `type === 'JSA'`, attach `signatures: jsa`.

### REQ-04 — Mobile Customer Name Auto-population (`sig1`, `WTL`, `sig2`) `[UNVERIFIED]`
- **Description**: Helper `getDefaultCustomerName(ticket, flowData)` resolves the active customer name:
  1. Any previously entered customer name in current ticket flow data (`sig1.signerName`, `jsa.customerSignature.signerName`, or `startWork:wtl*.sigName`).
  2. The job report-to contact name (`ticket.customerContact` / `job.reportToName`).
  3. The customer company name (`ticket.customer`).
- **Steps**:
  - `Sig1Body.tsx`: Auto-fill name field on mount if empty.
  - `WtlSheet` in `lunch-breaks.tsx`: Auto-fill `sigName` on mount if empty.
  - `Sig2Body.tsx`: Auto-fill name field on mount if empty.
- **User editable**: Field remains completely editable by the user. Editing updates the current step state and will propagate to subsequent steps.

### REQ-05 — Mobile JSA Checklist Signatures UI & Validation Gate `[UNVERIFIED]`
- **Description**:
  - Render customer signature row (`0/1` or `1/1`) and crew signature rows (`0/N` or `X/N`) at bottom of `JsaBody.tsx`.
  - Unsigned rows show white card with pencil icon, label, and signer title.
  - Signed rows show mint-green background (`#ECFDF5`), green border, checkmark icon, and "Signed <time>".
  - Clicking opens `JsaSignatureModal.tsx` bottom sheet modal with role-based title, name input prefilled with auto-populated/crew name, drawing pad, timestamp, GPS, and Clear/Save buttons.
  - Gate: `Complete JSA` is blocked unless all hazard items answered AND Customer signature present (1/1) AND at least 1 Crew signature present ($\ge 1$).

### REQ-06 — Web Progress Tracking Display of JSA Signatures `[UNVERIFIED]`
- **Description**:
  - Create `JsaSignatures` in `apps/web/src/features/ticket-progress/components/jsa-signatures.tsx`.
  - Display Customer signature block and Crew member signature blocks with signature thumbnails, timestamps, and GPS coordinates.
  - Wire into `JsaBody` in `step-bodies/checklist.tsx` and into `ChecklistResults` / `ChecklistsSection`.
  - Maintain `data-testid` contracts.

## 3. Implementation & Review Notes

- **Architectural Boundary Enforcement:** `ChecklistAssignmentsService` in the `usecase` layer declares domain input interfaces `ChecklistSignatureInput` and `JsaSignatureInput`, removing upward imports from `@presentation/...`. Presentation DTOs fulfill these interfaces via structural typing.
- **WTL State Stabilization:** `useWtlState` in `lunch-breaks.tsx` was guarded with `if (!open) return;` and a single-autofill `autofillPatchedRef`, preventing draft patch write debounce cycles from triggering continuous re-renders across lunch cards.
- **Customer Name Autofill Handling:** `customer-name-autofill.ts` filters out placeholder `"Customer unavailable"` on `sig1` (matching `sig2`), inspects in-progress `signatures` arrays in `jsa:draft`, and handles `startWork:wtl${i}:draft` keys. Fully covered by unit tests.


