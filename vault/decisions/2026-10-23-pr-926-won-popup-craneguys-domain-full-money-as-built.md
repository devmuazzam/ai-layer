---
title: PR #926 (fixes/TCG-22-OCT-UAT) as built — Won popup redesign, craneguys.com website and emails, quotation money in full — decision
source: decision/Asad Amanullah
decided: 2026-10-23
decided_by: >-
  Asad Amanullah (CodingCops; overlay identity asod-cc <asad.amanullah@codingcops.com>),
  stated 2026-10-23 in a Claude Code session on branch `fixes/TCG-22-OCT-UAT` (PR #926):
  "things we did in this branch are approved by humans and we want new changes which is
  www.craneguys.com and email@craneguys.com etc". Earlier in the same session they said the
  Won popup redesign "was approved" by a human and asked for money in full, with no K/M
  rounding. They did not name the person who approved the Won popup redesign, or say where
  that approval was given. The vault does not record their role, so whether they can decide
  product behaviour for TCG is not on record. Recorded as `status: reference`, as with the
  other CodingCops sign-offs of UAT branches (for example
  2026-09-15-fix-15-sep-das-and-quotations-as-built.md). It binds the CodingCops build.
  TCG can overrule it. It is not a TCG client sign-off.
status: reference
conflicts_with: []
supersedes_partial:
  - aidlc/TCG-48/spec.md (REQ-03, REQ-04, REQ-05, the ring-pulse part of REQ-08, the two REQ-10 test IDs quotations-won-celebration-close and quotations-won-celebration-add-to-project, and §12 Q4)
  - 2026-09-15-fix-15-sep-das-and-quotations-as-built.md (item 12 fallback table, the Email and Website rows only)
resolves:
  - "aidlc/TCG-48/spec.md#q6"
  - "admin/gaps.md#branch-fixestcg-22-oct-uat-pr-926--fallback-company-email-moved-from-thecraneguyscom-to-craneguyscom-with-new-mailbox-names"
  - "quotations/gaps.md#branch-fixestcg-22-oct-uat-pr-926--quotation-hero-subtotal-and-workspace-kpis-now-show-money-in-full-not-compact"
jira: []
tags: [module/quotations, module/admin, kind/decision, web, api]
entities: [quotation, project, job]
---

# PR #926 ships as built

The PR #926 review (`fixes/TCG-22-OCT-UAT`) found three changes with no written source.
Each was escalated as an open question: TCG-48 spec §12 Q6, an entry in
`admin/gaps.md` and an entry in `quotations/gaps.md`. On 2026-10-23 **Asad Amanullah
approved all three as built.** In their words: "things we did in this branch are approved by
humans".

## Decision

### 1. The Won celebration popup (TCG-48) is approved as redesigned

As built in commit `99365758b`, with the quote total fixed in `30798b9ca`:

- **Header:** a star badge with one confetti burst, "Quote won" / "Congratulations!", and
  the quote number and customer.
- **Facts row:** **Job site** and **Quote total**. The quote total is the **computed**
  total, the same figure as the hero Total Amount and the quotations list (TCG-255). It is
  not the stored `Quotation.total` column.
- **One next step:** **Convert to Project**. If the quote already has a project, the step
  is **Convert to Job** instead.
- **Later** closes the popup. The same action stays available in Quick Actions.
- **Removed:**
  - the **Add to a Project** option and its open-project count
  - the ✕ close button
  - the "I'll do this later / Quick Actions" text
  - the ring pulse (confetti stays)

This supersedes the following parts of [TCG-48 spec](../../aidlc/TCG-48/spec.md):

- **REQ-03:** the options and the close controls.
- **REQ-04:** the Add to a Project option opening in `existing` mode.
- **REQ-05:** the whole requirement.
- **REQ-08:** the ring pulse only. Confetti, CSS-only animation, `prefers-reduced-motion`
  and theme colours stand.
- **REQ-10:** two test IDs are dropped, `quotations-won-celebration-close` and
  `quotations-won-celebration-add-to-project`. The other `quotations-won-celebration-*`
  IDs stand.
- **§12 Q4:** the open-project count.

Every other part of TCG-48 stands: REQ-01, REQ-02, REQ-06, REQ-07, REQ-09, Q1–Q3 and Q5.

### 2. Company website and contact email domain

As built in commit `6db7f735b`:

- **Website:** `www.craneguys.com`. This is the bare host, with no `https://` and all
  lowercase, on printed and PDF output. Email templates add the scheme to their links
  when the value has none.
- **Contact emails:** `@craneguys.com`
  - `quotes@`: Print Quote, the API default and the quote PDF
  - `permits@`: permit print
  - `dispatch@`: the Dylen dispatch print
  - `hello@`: the ticket-email fallback

This supersedes the **Email** and **Website** rows of the fallback table in item 12 of
[2026-09-15-fix-15-sep-das-and-quotations-as-built.md](2026-09-15-fix-15-sep-das-and-quotations-as-built.md)
(`quotes@thecraneguys.com`, `www.CraneGuys.com`). The rest of that table and that note
stand: legal name, address, phone, fax, license and the letterhead layout.

### 3. Quotation money is shown in full

As built in commit `151c4ba7c`, these figures show the full amount with 2 decimals and
no K/M rounding:

- on the **quotation detail hero:** Total Amount and Subtotal
- on the **quotations workspace KPIs:** Won value and Pipeline value

## Why

The changes came from UAT feedback on 2026-10-22. `aidlc/processed.log` records that
feedback, but nobody wrote down who gave it. The approver confirmed the branch as the
intended product instead of reverting it. For money, the hero showed Total Amount in full
($267,577.00) beside a compact Subtotal ($267.58K), and the two forms disagreed.

## What this does not settle

- **Who approved the Won popup redesign, and where.** The decider relayed the approval
  but did not name the approver. Ryan Adams and Joe Schacatano are still the named copy
  owners of TCG-48. UAT 1 (`uat/sessions/uat-session-1-internal.md:61`, `unverified`)
  still says "Create Project or Add to a Project", and this note does not edit that
  record.
- **Whether `quotes@`, `permits@` and `hello@` exist on TCG's mail server.** This note
  decides that the build uses them. It does not confirm the mailboxes exist or that anyone
  reads them. Only `dispatch@craneguys.com` has a source
  (`projects-jobs/city-permits/permit-acquisition-process.md`, `unverified`). Patrick
  McKiernan (IT Manager) can confirm the others.
- **[Whose company identity do customer-facing emails carry when a deployment sets no env?](../admin/gaps.md#whose-company-identity-do-customer-facing-emails-carry-when-a-deployment-sets-no-env)**
  stays **open**. That question is whether a hardcoded TCG fallback is right at all.
  This note sets only the domain the existing fallback uses.
- **Placeholder ticket-email branding** (Toronto address, 555 phone) and the permit print
  header address and phone. Commit `6db7f735b` left them as is. This note does not decide
  them.
- **Other compact money displays.** Tables, the pipeline board and other `qmoney` uses
  stay compact. This note covers only the four figures named in decision 3.
- **The quotations conflict stub.** This note picks no winner among
  `quotations/quotations-INDEX.md`'s candidates.

## Effect on the vault

- **No winner or loser among migrated files.** Nothing changes `status:`. A sign-off of a
  UAT branch does not adjudicate Confluence content.
- **Done:** in [TCG-48 spec](../../aidlc/TCG-48/spec.md) §12, Q6 is marked
  `resolved`, pointing here, with the superseded REQs listed. The REQ table body is not
  edited.
- **Done:** the `provenance_note` of
  [2026-09-15-fix-15-sep-das-and-quotations-as-built.md](2026-09-15-fix-15-sep-das-and-quotations-as-built.md)
  records that item 12's Email and Website rows are superseded here. `status: reference`
  is kept, and the body is not edited.
- **Done:** the `admin/gaps.md` entry *Branch fixes/TCG-22-OCT-UAT (PR #926) — fallback
  company email…* is marked resolved, pointing here.
- **Done:** the `quotations/gaps.md` entry *Branch fixes/TCG-22-OCT-UAT (PR #926) —
  quotation hero Subtotal and workspace KPIs…* is marked resolved, pointing here.
- **Not done (outside tcg-scrum's write scope):** the `INDEX.md` router row "quotation
  print/PDF letterhead" (line 31) still points only at the 2026-09-15 note. A human, or
  `close-ticket`, should add this note to that row.
