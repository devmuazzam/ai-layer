---
title: Vendors Agencies — open questions
status: reference
kind: gaps
updated: 2026-08-24
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
- Status: open — needs confirmation
- **From (frozen original):** [gaps.md#purchase-orders-at-three-levels-joe-and-ryan-on-tape-nothing-written](../gaps.md#purchase-orders-at-three-levels-joe-and-ryan-on-tape-nothing-written)

