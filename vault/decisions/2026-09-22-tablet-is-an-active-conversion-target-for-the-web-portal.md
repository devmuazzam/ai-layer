---
title: "Tablet is an active conversion target for the web portal, including the quotation builder — the RFP §5 device matrix is pre-conversion (Syed Haris, 2026-09-22) — decision"
source: decision/Syed Haris — closeout of `fix/quotation-surcharge-toggle` (main-repo PR #630, overlay PR #104)
decided: 2026-09-22
decided_by: >-
  Syed Haris (hariscops, syed.haris@codingcops.com) — CodingCops developer, in a
  Claude Code session on 2026-09-22 during closeout of `fix/quotation-surcharge-toggle`.
  He is the person who requested and reviewed that work. This is an engineering /
  build-scope statement from the vendor side, not a TCG client sign-off, so
  `status: reference`: binding on how CodingCops builds, and open to being overruled
  by TCG. He explicitly framed tablet-responsive UI as "an engineering and product
  decision". Brian Petros — the owner named on the register entry, and the person who
  owns both sides of the RFP-vs-shipped divergence — has NOT answered, and nothing
  here is his.
status: reference
conflicts_with: []
resolves:
  - quotations/gaps.md#is-the-quotation-builder-supported-on-tablet-and-at-which-breakpoint
tags: [module/quotations, module/admin, kind/decision, requirements]
entities: []
---

# Tablet is a conversion target, not out of scope — what that settles and what it does not

[quotations/gaps.md](../quotations/gaps.md#is-the-quotation-builder-supported-on-tablet-and-at-which-breakpoint)
asked two halves: **(a)** is the quotation builder a supported surface on tablet for
Sales / Estimating, and **(b)** at which breakpoint. The entry recorded half (a) as
*Contradicted* — [admin/tcg-erp-rfp-2026-02-26.md](../admin/tcg-erp-rfp-2026-02-26.md)
§5 *User base* gives Sales / Estimating `Desktop (Mac/Windows)` while giving Dispatch,
Field Crew and Mechanics tablet explicitly — and half (b) as blank.

## Decision

Syed Haris, 2026-09-22, verbatim:

> "we've desktop first, now converting to tablet, so it shouldn't be any issue"

and, earlier in the same session, that providing tablet-responsive UI

> "is an engineering and product decision"

What that means for the register:

1. **RFP §5's `Sales / Estimating → Desktop (Mac/Windows)` describes the pre-conversion
   state.** It is **stale**, not a live constraint on the build. The platform was built
   desktop-first and is now being converted to tablet.
2. **Tablet is an active conversion target for the web portal, including the quotation
   builder.** Building the builder to work on a coarse pointer is in scope, not a
   scope violation.
3. **Main-repo commit `1242f593e`** — *"iPad and Mobile responsiveness Web 1.0"*,
   2026-08-19 — **was that conversion starting**, not a breach of the February RFP.
   The register recorded it as an unreconciled divergence between a documented *no*
   and shipped code; this is the reconciliation, from the vendor-engineering side.

## Why

The RFP is a **draft** dated February 2026, pre-vendor-selection. Its *Access method*
column records how each user type reached the **legacy** system and what the client
expected at the time; it is not, and never claimed to be, a breakpoint specification —
it names no breakpoint anywhere. The build has since moved past it deliberately, and
the person who requested and reviewed that work says so. Reading a nine-month-old draft
column as a live prohibition would freeze the build against a document nobody has
adjudicated and that the client's own later work has overtaken.

This is the reasoning to reuse the next time a draft-RFP row contradicts shipped code:
an RFP row is evidence of intent at its date, not a standing constraint, and the way to
settle it is to ask whoever owns the decision now — not to pick whichever of the two is
newer.

## What this does NOT settle — read this before citing the note

**This is not adjudicated by Brian Petros, by TCG product, or by anyone client-side.**
The register's Owner line named Brian Petros, and he has not answered. Two things
therefore stay open, and this note does not narrow either:

- **(a-remainder) The client-facing support claim.** Whether TCG is *promised* tablet
  support for Sales / Estimating — which drives QA / UAT device coverage and what may be
  claimed contractually — is **not** settled here. A vendor developer saying the build is
  converting to tablet is not TCG accepting a supported-device commitment. Preserved as
  its own open entry:
  [quotations/gaps.md → *Is TCG promised tablet support for Sales / Estimating…*](../quotations/gaps.md#is-tcg-promised-tablet-support-for-sales--estimating-and-at-which-breakpoint).
- **(b) The breakpoint.** Haris named **no** breakpoint. Nothing in this note attaches
  `md` 768, `xl` 1280 or any other number to the quotation builder. The nearest thing in
  the vault remains [admin/responsive-design-and-security-posture.md](../admin/responsive-design-and-security-posture.md)
  §Part 1 — a vendor paraphrase of a client minimum whose original is not in the vault,
  naming no screen. Carried in the same open entry above.

**Consequence: the touch-target rail has no answer for a tablet-targeted web surface.**
Now that tablet is in scope for the *web* portal, the two build rails disagree and neither
covers the case: `claude/contexts/web.md` (*Misc*) says touch targets **≥ 44px**, and
`claude/contexts/mobile.md` says **≥ 48px, "not web's 44px"**. A tablet-targeted web
surface — the quotation builder among them — sits between them, and nothing written says
which applies. This note does **not** answer that; it records it as a real consequence of
tablet entering scope. Filed as
[quotations/gaps.md → *Touch-target rail for a tablet-targeted web surface…*](../quotations/gaps.md#touch-target-rail-for-a-tablet-targeted-web-surface--44px-or-48px).

## Effect on the vault

Bookkeeping completed in the same pass as this note, 2026-09-22:

- **No winner file, and no content file becomes `verified`.** This decision has no vault
  document behind it — it is a person's answer recorded here. Nothing in
  `vault/quotations/` or `vault/admin/` was promoted. **Done** (by not doing it,
  deliberately).
- **[admin/tcg-erp-rfp-2026-02-26.md](../admin/tcg-erp-rfp-2026-02-26.md) — `status`
  left `unverified`, NOT superseded.** A CodingCops developer cannot supersede a client
  RFP, and §5 is one row of a document that is the written scope of the whole engagement.
  Only a `provenance_note:` was added, pointing at this note and scoping it to the one
  row. **Done.**
- **[quotations/gaps.md](../quotations/gaps.md) → *Is the quotation builder supported on
  tablet, and at which breakpoint?*** — `Status: resolved — see
  decisions/2026-09-22-tablet-is-an-active-conversion-target-for-the-web-portal.md`, with
  the original entry left intact as the record of what was in question. **Done.**
- **Two new open entries added to [quotations/gaps.md](../quotations/gaps.md)** so the
  unanswered remainders stay in the `grep -rn '^- \*\*Status:\*\* open'` sweep: the
  client-facing support claim + breakpoint (Owner: Brian Petros), and the 44px / 48px
  touch-target rail (Owner: CodingCops engineering). **Done.**
- **[admin/gaps.md](../admin/gaps.md) — untouched.** Its WCAG / conformance entry stays
  open and unmodified; nobody answered it, and nothing here bears on it.
