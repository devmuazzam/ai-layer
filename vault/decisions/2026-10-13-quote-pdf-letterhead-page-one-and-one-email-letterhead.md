---
title: Quote PDF letterhead stays on page 1; every email opens with the Print Quote letterhead, logo embedded (Jahanzaib Nadeem, 2026-10-13) — decision
source: decision/Jahanzaib Nadeem — tcg branch `fix/13-oct-uat`, commit `afe691bac` (TCG-37)
decided: 2026-10-13
decided_by: >-
  Jahanzaib Nadeem (git Jz-Nd, jahanzaib.nadeem@codingcops.com, CodingCops developer), in a
  Claude Code session on 2026-10-13, recorded in the commit body of `afe691bac` under
  "Developer decisions". Relayed to tcg-scrum by the reviewing agent; tcg-scrum did not hear it
  first-hand. A developer has authority over structure, not over product intent: items 1 and 2
  below reinterpret a client UAT ask, and nobody at TCG (UAT 4 was a client session) or the
  CodingCops PM has confirmed them. Hence `status: reference` — binds the CodingCops build,
  open to being overruled by TCG.
status: reference
conflicts_with: []
resolves: []
related_decisions:
  - 2026-09-15-fix-15-sep-das-and-quotations-as-built.md
jira: [TCG-37]
tags: [module/quotations, module/admin, kind/decision]
---

## Decision

1. **Quote PDF letterhead is drawn on page 1 only.** Continuation pages carry no letterhead.
2. **UAT 4 #7** (*"The header should be consistent with the TCG logo on the Quotation PDF"*,
   `uat/sessions/uat-session-4.md`) is read as **"emails should carry the same header as the
   quote"**, not as "repeat the header on every PDF page".
3. **Every email opens with one shared letterhead** modelled on the web Print Quote header:
   logo, red rule, a per-email heading, company address, Office / Fax / web, blue rule.
4. **The logo is `crane-guys.png`, embedded as an inline CID attachment** (`cid:tcg-logo`), not a
   hosted URL — the hosted logo could not be fetched by an inbox when the web app is not public.
   `COMPANY_LOGO_URL`, when set, still overrides it.
5. Build choice (structural, recorded here for context; its home is the PR's *Developer
   decisions* table): the header is extracted from the quotation email layout as a shared
   builder rather than moving every email onto one layout.

## Why

Emails drew their header four different ways and the logo was broken on many (commit
`afe691bac`). The developer judged one letterhead, embedded, to be the fix for TCG-37, and took
"consistent" in UAT 4 #7 to mean consistency across documents rather than across PDF pages.

## What this does not settle

- **Email heading copy** ("Password Reset", "Ticket Assignment", "Quotation Approved",
  "Payroll", "Verification Code", …) was written by the AI and is not decided here — open at
  [`../admin/gaps.md#email-letterhead-headings--who-owns-the-heading-text-each-email-shows`](../admin/gaps.md#email-letterhead-headings--who-owns-the-heading-text-each-email-shows).
- **Social-media icon rows removed** from the ticket and pre-quote email headers — open at
  [`../admin/gaps.md#social-media-icon-rows-removed-from-ticket-and-pre-quote-emails--intended`](../admin/gaps.md#social-media-icon-rows-removed-from-ticket-and-pre-quote-emails--intended).
- **Seal vs wordmark.** [2026-09-15-fix-15-sep-das-and-quotations-as-built.md](2026-09-15-fix-15-sep-das-and-quotations-as-built.md)
  item 12 names a **crane seal** for the print/PDF letterhead (`reference`, Ehtesham Anwar); this
  note puts `crane-guys.png` on email. Not a contradiction — item 12 covers print/PDF only — but
  the two documents now carry different marks.
- The quotations conflict stub (`quotations/quotations-INDEX.md`) — not adjudicated.

## Effect on the vault

- **No winner, no loser.** No migrated file changes status; `uat/` rows stay unverified records.
- Done: two open entries added to `admin/gaps.md`, one pointer added to `quotations/gaps.md`.
