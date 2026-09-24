---
title: Job-site status is not operator-settable — customer forms drop it, the badge stays (Areeba Gul, 2026-09-22) — decision
source: decision/Areeba Gul — Linear TCG-46, branch `fix/customer-jobsite-status-select`, answering customers/gaps.md (a)–(d)
decided: 2026-09-22
decided_by: >-
  Areeba Gul (ticket assignee on Linear TCG-46), stated 2026-09-22 in a Cursor
  session while shipping the Status-select removal. An internal CodingCops build
  decision on a UAT remediation ticket, not a TCG client-side sign-off (Melissa
  McNutt, named as owner of (a)–(c) on the register entry, was not asked), so
  `status: reference` — binding on the CodingCops build, open to being overruled
  by TCG.
status: reference
conflicts_with: []
resolves:
  - customers/gaps.md#job-site-status--only-its-removal-is-written-down-and-the-badge-becomes-unsettable
jira: []
tags: [module/customers, module/quotations, kind/decision, requirements]
---

# Job-site status leaves the operator's hands

The UAT ask ([uat/sessions/uat-session-1-internal.md](../uat/sessions/uat-session-1-internal.md)
→ *Job Sites*) was one line — *"Remove the Status field from Add Job Site"* — and said
nothing about the default, update semantics, the badge, pickers or the column. All four
open questions on
[customers/gaps.md](../customers/gaps.md#job-site-status--only-its-removal-is-written-down-and-the-badge-becomes-unsettable)
are answered here.

## Decision

**(a) Operators never set job-site status, on any surface.** The customer Add and Edit
Job Site forms no longer offer a Status select, and the quotation job-site popup already
had none (removed earlier under UAT 5, `f121dd7bf`). So the intent is the broader one:
there is no operator-facing way to make a job site Inactive going forward.

Two consequences the operator settled explicitly:

- **New job sites land Active** from the DB/API default, not from a form value — the
  form sends no `status` at all.
- **Updates omit `status`**, so a row that is already Inactive is never flipped back to
  Active by an ordinary edit. Pre-existing Inactive data is preserved, just not
  reachable from the UI.

**(b) The read-only Active/Inactive badge on the customer job-sites list stays as-is.**
Decided earlier in the same ticket by the same operator: keep the list badge. It still
tells the truth for rows that carry Inactive, which is why it is worth keeping even
though nothing in the UI can now produce a new one.

**(c) Inactive is not a live operator workflow after this change, and pickers are
unchanged.** Picker filtering for inactive job sites is **out of scope** on TCG-46 —
job sites continue to appear in every picker regardless of the flag. The sibling
conflict the register flagged (UAT 6, *"Inactive and archived yards must not appear
anywhere"*, where yards act on the flag and job sites do not) is **moot for newly
created job sites**, because none of them can become Inactive. It is not adjudicated
for the rows that already carry the flag.

**(d) The `status` column is retained. No migration on this ticket.** `JobSite.status`
(`String @default("Active")`, plus `idx_job_sites_status`) stays in the schema. This
decision does not authorise a later drop, and does not answer whether FCC import or
reporting needs it — that half of (d) is still owned by whoever owns the FCC migration.

## Why

The written ask only covered one form, and a form-only reading leaves the platform in
the worst state: a flag that half the UI reads, that one surface can still write, and
that nothing documents. Removing the *write* everywhere and keeping the *read* makes the
behaviour describable in one sentence — job-site status is system-set, Active by
default — without a migration, without touching dispatch, and without discarding
whatever Inactive rows a tenant already holds.

Omitting `status` from the update payload rather than pinning it to `ACTIVE` is the
load-bearing detail. Pinning would have silently reactivated every Inactive site the
next time anyone edited its address.

Retaining the column is the cheap half of the same argument: dropping it is
irreversible, the FCC legacy model documents a per-site `Status Active` and a job-site
status filter ([customers/fcc-maintain-customers-tcg-review.md](../customers/fcc-maintain-customers-tcg-review.md)
→ *Customer Job Sites (slides 8–12)*, `unverified`), and nobody has yet asked for the
space back.

## What this does not claim

Whether job-site Inactive *should* hide a site from pickers, the way yard Inactive does,
is not decided — it is descoped. If TCG later wants that behaviour, this change removed
the only operator path to setting the flag it would key off, and a way to set it has to
come back first.

The stored casing is also unsettled and was not part of the decision: the schema default
is `"Active"` while the web layer reads and previously wrote `'ACTIVE'` / `'INACTIVE'`.
Existing rows may therefore hold either form. Recorded as an observation so the next
person does not read this note as having normalised it.

## Effect on the vault

- Gaps entry: [customers/gaps.md → *Job-site status — only its removal is written down,
  and the badge becomes unsettable*](../customers/gaps.md#job-site-status--only-its-removal-is-written-down-and-the-badge-becomes-unsettable)
  → **Status: resolved**, pointing at this note — **done**.
- No winner/superseded pair: there was no conflicting vault specification to adjudicate.
  The candidates checked on that entry ([uat/sessions/uat-session-1-internal.md](../uat/sessions/uat-session-1-internal.md),
  [uat/register-2026-09-18.md](../uat/register-2026-09-18.md),
  [customers/fcc-maintain-customers-tcg-review.md](../customers/fcc-maintain-customers-tcg-review.md))
  are records of asks and of legacy behaviour, not specifications, and stay
  `status: unverified` with their frontmatter untouched.
- UAT register DONE status is **not** updated here — that belongs to `close-ticket`.
