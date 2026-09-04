---
title: Vendors Agencies — open questions
status: reference
kind: gaps
updated: 2026-09-04
tags: [module/vendors-agencies, kind/gaps, open-questions]
---

# Vendors Agencies — open questions

Live register per [STRUCTURE.md](../STRUCTURE.md) → *Where a question goes*. Ticket-raised
questions do **not** go here — they belong in that ticket's `spec.md` §12.

Entry format (unchanged from the retired registers, so the global sweep still works):

```markdown
## <question title>
- **Status:** open
- **Asked:** YYYY-MM-DD — by whom / which work raised it
- **Question:** one paragraph
- **Sources checked:** what was read before declaring this open
```

## Purchase orders at three levels — Joe and Ryan on tape, nothing written

- Question: may a PO be created **standalone** — not linked to any job — and should a PO created at
  the **quotation** level be cancelled automatically when the quote is lost?
- Candidates:
  - Recording **2026-03-12 "Sales-Pricing in FCC"** — the strongest attribution in the whole product
    set; this transcript carries reliable speaker labels. **Joe Schacatano at 1:15:04**: *"Freely at
    any point if we wanted to just create a PO in general. So really having it at the quotation…
    Also having the ability to do it within a job again if that was just a scheduled job with no
    quotation."* At **1:15:23**: *"And then third, completely separately if we just need to create a
    PO in general for for the business for a vendor."* At **1:18:47**: *"Yeah, yeah, really. Yeah.
    **Any level** and have the ability to tie it to something… **It's got to have a trail. It's got
    to lead us to a reason of why it's even in there** to begin with, right?"* And at 1:15:x he gives
    the reason: in FCC a PO created before the job *"can get lost in translation because it's not
    tied to anything."*
  - Same recording, **Ryan Adams at 1:16:59**: *"either quote is pending won or lost and **if it's
    lost it closes out the PO**. If it's won it processes the PO to go to the next level… so that way
    we don't get a backlog in our system."* **Joe Schacatano at 1:17:42: *"I agree with that."***
  - `meetings/2026-06-22-sprint-4-additional.md:91` (`conflicts_with: []`, updated **2026-06-22** — three months
    *after* the recording) — *"Every PO must be linked to a job number this is required, not
    optional"*. Note :92 already grants quotation-level POs carrying over, and :102 already grants a
    global PO list, **so the only genuine contradiction is the standalone case.**
  - `SCRUM-518` *PO Implementation on projects and global level* — **Done**, **`description: null`**.
    Its QA comment lists the four creation surfaces actually built — *"1. yards 2. assets 3. projects
    4. main side bar"* — **none of which is the quotation** — and complains at item 16 that the form
    *"is allwoing the creation of empty records"*, i.e. the job link was not enforced.
  - `SCRUM-473` *Add PO to main side navigation* — **Done**. *"PO creation **allows** linking to a
    specific project, job, and vendor"* — permissive, not mandatory. `SCRUM-478`, the parent
    **Purchase Order epic**, is still **To Do** with `description: null`, untouched since 2026-05-25.
  - `vendors-agencies/purchase-order.md` (`conflicts_with: []`) — documents only the **permit-driven** path
    and names **Liz Lopez** and **Jeff Stricker** as the two PO owners. It never mentions the
    quotation level, standalone POs, or the mandatory-job-link rule.
- Note: on the standalone half the vault line is simply **wrong about the built system** —
  `model PurchaseOrder` has `jobId String?` (**nullable**), `poType PoType? @default(GENERAL)`, and
  **no quotation relation at all**. So the recording and the code agree and
  `meetings/2026-06-22-sprint-4-additional.md:91` is the outlier — yet that file carries `conflicts_with: []`,
  so an agent reading it has no signal to doubt it. The rest is state (d): **two named TCG people
  specified three creation levels, a mandatory audit trail, and a quote-lost→PO-closed rule on a
  reliably-labelled transcript, and none of it is written anywhere.** The quotation-level PO and the
  quote-lost rule were **never built and have no ticket** — invisible rather than merely contested.
- Blocked: `SCRUM-478` (epic, To Do, empty); the PO audit-trail requirement; any quotation-level PO
  work; the accounting reconciliation Ryan described.
- Owner: Joe Schacatano (stated the three levels) and Ryan Adams (stated the cancellation rule) —
  sales & quotation. Liz Lopez for how it meets the permit-driven PO path she owns.
- **Status:** open — needs confirmation
- **From (frozen original):** [gaps.md#purchase-orders-at-three-levels-joe-and-ryan-on-tape-nothing-written](../gaps.md#purchase-orders-at-three-levels-joe-and-ryan-on-tape-nothing-written)
- Update 2026-09-04 (Project Repository ingest): the December 2025 draft P&P set in
  [purchase-orders-fcc/](purchase-orders-fcc/INDEX.md) is the first written material on either half
  of this question — and all of it is **FCC practice, not a TCG decision for the new ERP**; all three
  P&Ps are drafts by Brian Petros with Effective Date `[fill in]`, never shown approved.
  **(a) Standalone.** FCC does not require a Job on a PO: the Job Number sits on the *Detail* line
  and both the policy and the walkthrough say to leave it blank when no Job exists —
  [po-001](purchase-orders-fcc/po-001-pre-job-purchase-orders.md) → *Step 3 — Detail lines*;
  [fcc-po-entry-walkthrough](purchase-orders-fcc/fcc-po-entry-walkthrough.md) → *[Detail] tab*:
  *"Include the Job Number — if there is no Job yet, leave it blank"*.
  [po-002](purchase-orders-fcc/po-002-vendor-billing-and-customer-invoicing.md) rule 2:
  *"Quote-anchored POs are valid even if no Job exists yet"*, and AP may voucher against them. The
  Fleet parts POs in the purchasing-guide screenshots (`FL-1723`, from requisition `FL-1628`) hang
  off a Work Order and Unit, never a job
  ([fcc-nexgen-purchasing-guide](fcc-nexgen-purchasing-guide.md) → *The requisition-to-PO link*).
  So FCC's own record sides with the built `jobId?` and with Joe, and
  `meetings/2026-06-22-sprint-4-additional.md:91` stays the outlier. **But every no-job PO in the
  drop is still anchored to something** — a Quote Number, which PO-001 rule 2 makes *mandatory* when
  no Job exists, or a work order — which matches Joe's "it's got to have a trail"; a PO tied to
  nothing at all (his third, "for the business" case) appears nowhere in the drop, and
  [dispatch/travel-permits-playbook.md](../dispatch/travel-permits-playbook.md) has Dispatch
  *"create a PO# against the job number"* for permits.
  **(b) Quote lost → PO closed.** Nothing automatic exists in FCC. In FCC a PO is closed by a
  voucher (fcc-nexgen-purchasing-guide → *The four-stage chain*), not by a quote outcome;
  [po-003](purchase-orders-fcc/po-003-linking-pre-job-pos-to-jobs.md) → *Step 5* and *Controls* has
  AP *periodically* review POs carrying a Quote Number but no Job Number, establish with
  Sales/Dispatch whether the Job was *"cancelled, never booked, or still pending"*, and *"link or
  close out"* by hand — no report named, no frequency set. The page itself records that it *"does
  not say what to do with a quote-only PO whose Job was cancelled, beyond 'resolve' it"*, and PO-002
  says the same for a Job cancelled after AP has vouchered. The mechanism all three P&Ps rely on —
  the quote number in a comments field — also carries Melissa McNutt's unanswered 3 Dec 2025
  objection ([commissioning-email-thread](purchase-orders-fcc/commissioning-email-thread.md) →
  *The unresolved objection*).
  **Still needs the client:** whether the new ERP requires an anchor (job, quotation, work order or
  other) on every PO or allows a truly unanchored one; whether quote-lost → PO-closed is automatic
  (Ryan and Joe on tape) or stays a periodic AP audit (PO-003); and the same person must dispose of
  the 2026-06-22 "every PO must be linked to a job number" line, which the drop contradicts for FCC
  but does not overrule for the ERP.

