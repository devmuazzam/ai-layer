---
title: Accounting — open questions
status: reference
kind: gaps
updated: 2026-08-24
tags: [module/accounting, kind/gaps, open-questions]
---

# Accounting — open questions

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

*No entries yet. Pre-2026-08-20 questions remain in the retired registers
([gaps.md](../gaps.md)); disposition into module files is phase 3.*

## Wishlist vs committed scope — nobody has tiered the accounting list

- **Status:** open
- **Asked:** 2026-08-24 — on capturing the July 2026 accounting-team wishlist
- **Question:** the [wishlist](2026-07-accounting-team-erp-wishlist.md) spans core accounting
  (GL/AR/AP/job costing) through heavy AI ambitions (OCR, predictions, collections assistant,
  customer portal). Which tier is committed ERP scope, which is later, which is out? The module
  is slated to start ~October–November 2026; tiering is the first kickoff decision.
- **Sources checked:** no FRD, no matrix, no ticket exists for accounting; the wishlist is the
  only source. Payroll-integration rows already live in the payroll register; mobile time entry
  is largely the Atom app; job-document storage overlaps field-ops/projects attachments.

## Project detail Accounting tab — what it shows, and what it shows before the module exists

- **Status:** open
- **Asked:** 2026-08-24 — `SCRUM-897` (path C, `feat/SCRUM-897`); tcg-scrum during PR review
- **Question:** Two questions, and they need separate answers. (a) **Content:** what does the
  project detail Accounting tab show? The only written AC is
  `projects-jobs/project-module/05-create-and-track-permits.md:64` — *"The accounting tab shows a
  financial summary along with quotations and invoices, and payroll status where applicable"* —
  a 2026-04-30 page, `status: unverified`, and its subject was reopened on tape three months
  later without settling (below). (b) **Interim:** until the accounting module ships (~Oct–Nov
  2026), should the tab render a *"Coming Soon"* placeholder, be hidden from the tab bar
  entirely, or something else? Is a "Coming Soon" panel an accepted app-wide interim for a
  shipped-but-empty tab, or is it a per-PR improvisation? **Nothing written answers (b).**
- **Sources checked:** `vault/INDEX.md`; `accounting/INDEX.md` (module not yet built, kickoff
  ~Oct–Nov 2026); this register; `projects-jobs/INDEX.md` and `projects-jobs/gaps.md`;
  `projects-jobs/project-module/INDEX.md`, `01-create-and-track-projects.md:33` (tab bar lists
  Accounting), `05-create-and-track-permits.md:55,64` (the AC, under *User Story 5: Project
  Dashboard Overview*); `2026-07-accounting-team-erp-wishlist.md`;
  `2026-07-invoicing-adjustment-taxonomy.md`; all of `decisions/` (no accounting-tab or
  placeholder/deferral decision); vault-wide grep for `coming soon|placeholder`; the six
  `module/accounting` meeting files; `aidlc/processed.log`; no `aidlc/SCRUM-897/` folder exists
  (correct for path C).
- **Note — the content question is live on tape, not settled by the 2026-04-30 AC.** In
  `meetings/transcripts/2026-07-29-erp-review-dispatch-das-update.md`, `ehtesham.anwar`
  (CodingCops) at 30:11 demos a project-level Accounting structure (contracts, contract amounts,
  CORs/SCOs, invoices linked to contracts) and asks *"do we need something of a contract amounts
  tracker within the projects, within the TCG platform or not?"*. **Melissa McNutt answers at
  32:45: "Yes."** — and at 29:40, to the same theme, *"No, we want it."* But she immediately
  qualifies it at 32:58: *"we're currently not doing it. We're not really tracking it. We're only
  tracking Edison on an Excel… maybe we'll add Ryan to the call tomorrow"*, and Ehtesham defers:
  *"let's talk about this in detail tomorrow"*. The next-day call
  (`meetings/transcripts/2026-07-30-invoice-processing.md`, lines 44, 69, 73) is still open
  design — customer-level contracts whose amount is consumed by projects, with jobs selected in
  or billed separately — and ends with TCG owing the vendor their workflow. **So a named TCG
  person has confirmed she wants project-level accounting; nobody has specified it, dated it, or
  reconciled it with the 2026-04-30 AC (which mentions contracts nowhere).** That is a want on
  record, not a requirement, and it does not settle (b) either way.
- **Note — the weakest of weak precedents for (b).**
  `customers/customer-and-job-sites.md:38` — *"Make need attention tab - coming soon"*, under
  *Feedback on new Design*, `status: unverified`. It is a design-feedback punch-list line for a
  **different module's** tab, and punch lists are cross-module and unscoped
  (`gaps.md#feedback-punch-lists-are-not-scoped-to-the-module-they-are-filed-under`). It shows
  the pattern has been *asked for* once; **it is not an app-wide convention and must not be cited
  as one.** In the build, "Coming Soon" is already shipped in ~15 places, including the same
  `EmptyState title="Coming Soon"` on `/reporting` and a per-tab variant on job details — but
  that is a **build habit with no written product backing**, and existing code is not evidence of
  a convention.
- **Blocked:** `SCRUM-897` review cannot label the Accounting tab as spec-conformant either way;
  any future project-accounting ticket; the tiering question above, which must place
  project-level contract/invoice tracking in a tier before (a) can be answered.
- **Owner:** Melissa McNutt (she is the one on record wanting it), with Ryan Adams for contracts
  — for (a). For (b), the interim-placeholder convention is app-wide UI policy: Fouzan Shakil,
  as with `decisions/2026-08-20-archive-instead-of-delete-app-wide.md` and
  `decisions/2026-08-20-post-save-navigation-convention.md`.

