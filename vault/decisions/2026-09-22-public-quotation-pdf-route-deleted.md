---
title: The public quotation PDF route is deleted, not gated (Fouzan Shakil, 2026-09-22) — decision
source: decision/Fouzan Shakil — TCG-88 triage, answering quotations/gaps.md Q-01 and Q-03
decided: 2026-09-22
decided_by: >-
  Fouzan Shakil (assignee on TCG-88). Q-01 and Q-03 were raised by the
  2026-09-01 quotation audit with `Evidence: confirmed` and **no named
  owner**, and TCG-88 explicitly refused to let an implementer pick
  between session / token / both / delete. This note is that pick. It is
  an engineering-security decision on an internal endpoint, not a TCG
  client-side sign-off, so `status: reference`: binding on the build and
  open to being overruled by TCG if the customer-facing consequence in
  §"What breaks" is judged unacceptable.
status: reference
conflicts_with: []
resolves:
  - quotations/gaps.md#q-01--public-pdf-endpoint-has-no-authentication
  - quotations/gaps.md#q-03--public-routes-resolve-quoteno-across-tenants
tags: [module/quotations, kind/decision, security, tenancy, api, email]
entities: []
---

# The public quotation PDF route is deleted, not gated

`GET /quotations/:quoteNo/pdf` was `@Public()`, took no token, applied no status
filter, and resolved the quote number through `findByCodeWithRelations` — which is
`findFirst({ where: { quoteNo } })` with **no `tenantCompanyId`**.

On a public route `TenantContextService.get()` returns nothing, so the Prisma
`$extends` tenant extension hits its first skip condition and returns the query
untouched. `'quotation'` is in the extension's allowlist, but that never matters: the
function returns before the allowlist is reached. And `quoteNo` is
`@@unique([tenantCompanyId, quoteNo])` — unique only *within* a tenant.

So one unauthenticated request returned a rendered PDF carrying customer identity and
addresses, job site and dates, contacts, staff PII (salesperson, coordinator,
takenBy, checkedBy — names and emails), the full priced line-item breakdown with
billing codes and rates, and the commercial T&C. Quote numbers are a zero-padded
sequential counter, so the keyspace was walkable end to end, across every tenant at
once, DRAFT and LOST included.

This was known. `12b32d3bd` diagnosed the exact mechanism while fixing the signing
link and listed this route under *"Not done (found, same flaw)"*. `0a01900b0`
deferred it a second time. TCG-88 is that deferral coming due.

## The decision

**The controller is deleted.** Not gated behind a session, not gated behind a signed
token — removed, along with its module registration.

Four options were on the table; this is why the other three lost:

| Option | Why not |
| --- | --- |
| Keep `@Public()`, add a signed token | Real, and it is the pattern `resolveSigningLink` already uses. But it preserves a customer-facing URL nobody currently needs — see below — to solve a problem the email attachment already solves. |
| Require a session | Closes the hole just as completely, but customers have no accounts, so it cannot serve a customer-facing link either way. Its only value is the *internal* render check — see "What this costs". |
| Accept both | Two code paths, two ways to get it wrong, for a capability with no established consumer. |

**Nothing consumed the route.** Verified across the whole repo at `origin/main`:
nothing in `apps/web` (the quotation print view is client-side React driving the
browser print dialog — it never calls the API), nothing in `apps/mobile` (the one
near-miss, `compose.tsx`, builds `${quoteNo}.pdf` as a display label, not a URL),
nothing in `qa-automation/e2e`, nothing in `packages/`. The only references were the
controller, its registration, four `attachmentHref` builders and test fixtures.

**The customer keeps the PDF.** Every delivery path attaches it as a real MIME
attachment. The deleted link was a "view online" convenience sitting beside a file the
customer already had — and since `d81bee4f0` (2026-09-04, *"removed attached document
part in emails"*) the template stopped rendering the link at all:
`buildAttachedDocumentsSection` returns `''`. `attachmentHref` was still computed at
four call sites and threaded through the notification catalog, read by nothing. That
dead plumbing is removed too, along with the `DeliveryAttachmentCard` API kept alive
only to compile it.

## What breaks

**Bare links in emails sent before 2026-09-04 now 404.** Decided deliberately against
a grace window: any window keeps the enumeration open for its duration, which is the
whole defect. Those same emails still carry the PDF as an attachment, so no customer
loses the document — only that URL.

No resend or backfill is planned. If one is ever wanted it is a separate change.

## What this costs

`QuotationPdfService.generate` is now reachable only from the send paths and from the
authenticated `signature/signed-document` fallback, **which needs a signature row to
exist**. There is therefore no longer any endpoint that renders an arbitrary
quotation's PDF on demand, authenticated or not.

The route's own summary string said *"local testing"*, and that was plausibly true —
it was the one-URL way to eyeball a server-rendered PDF. That habit is not greppable,
so it cannot be ruled out. If it turns out to matter, restoring it **with `@Public()`
removed** gives the capability back and still closes the hole; the leak was the
missing authentication, not the route's existence.

## The rule for any future public quotation link

Recorded because the question will recur, and it is the part of this decision that
outlives the deleted controller.

1. **Resolve by a globally unique, unguessable key** — never by a per-tenant business
   code. The three surviving public signature routes resolve by DocuSign envelope id,
   which is why they are safe without a tenant context. A `QUOT-` counter is
   incrementable; a UUID is not.
2. **Verify the secret before any DB read**, binding it to the specific quotation —
   the existing `parsed.quoteNo !== quoteNo` check is the precedent.
3. **Never rely on the `$extends` extension on a public route.** It is not
   unconditional; no context means no scoping.
4. **Status gate: SENT-or-later only.** A DRAFT or LOST quotation is never downloadable
   through a public link. Decided here so the next implementer does not have to invent
   it, even though the deletion makes it moot today.

Note for whoever builds that: `mintSigningLinkToken` signs
`quoteNo|envelopeId|signerEmail` and **carries no expiry**. TCG-88's AC3 requires a
token that expires, so the existing helper cannot be reused as-is — an `exp` field has
to be added, and adding it to the shared helper invalidates in-flight signing links.

## What this does not claim

Only the PDF route was in scope. `sign-complete` keeps its optional token — verified
harmless, since without a token it does no DB read and its landing page echoes only
the escaped quote number — and is unchanged. The repository method
`findByCodeWithRelations` is **still unscoped by construction**; this decision removed
its one public caller and corrected its JSDoc, it did not make the method safe. A
source-level tripwire (`apps/api/src/presentation/public-route-allowlist.spec.ts`)
pins the set of `@Public()` routes so a future one fails the build, but that is a
tripwire, not a fix.

TCG-88's AC7 asked for a seeded two-tenant regression test. With the route deleted
there is no public surface to exercise, so the tripwire stands in its place. If a
tenant-crossing test is still wanted it has to be written at the repository level.
