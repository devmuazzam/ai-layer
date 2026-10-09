---
title: A customer contact's email is unique within its customer only; checked in the API and the form, not the database — decision
source: decision/Syed Haris
decided: 2026-10-09
decided_by: Syed Haris (developer on TCG), approved when Akif took TCG-159 to him. This is a CodingCops ruling, not a TCG client confirmation — the ticket names Brian Petros as the client-side owner of the scope. `status: reference` — binding on the build now, open to being overruled by TCG.
status: reference
conflicts_with: []
resolves: TCG-159 open question "Must a customer contact's email be unique per-customer, per-tenant, or not at all?"
jira: []
tags: [module/customers, kind/decision, contacts, email, uniqueness]
entities: [customer-contact, customer]
---

## Decision

**One customer cannot hold two contacts with the same email.**

- **Per customer, not per tenant.** The same email at two different customers is allowed.
- **Upper/lower case ignored:** `John@ABC.com` and `john@abc.com` are the same email.
- **Blank emails are skipped.** Whether email is required is TCG-158, not this note.
- Shown under the Email field: the API answers "A contact with this email already exists for
  this customer" (409); the customer forms say "This email is already used by another contact".

Enforced in two places, **no database constraint**:

1. **API** — `CustomerContactsService` checks on create, and on update when the email changes.
2. **Web form** — the customer wizard and the customer Contacts tab refuse two rows with one
   email before anything is sent.

## Why

- **Per customer:** a repeated email inside one customer is a data-entry mistake and leaves two
  look-alike people in the Quoted To / Report To pickers. Per tenant would forbid one person
  being a contact at two customers, which is normal in construction.
- **Not a database constraint:** the FCC first-pass migration redacted contact emails, and
  restoring them may bring legacy duplicates that a unique index would reject. Same approach
  as yard names (`2026-10-08-yard-names-unique-among-active-yards.md`).
- **The form check is required, not cosmetic:** the Contacts form saves every row as its own
  request, all at once, so two new rows with one email would each pass the API check. Removed
  contacts are now deleted before the rest of the save, so their email can be reused in the
  same save.

## Scope — what this does not decide

- **Existing duplicates** are not merged or renamed; they stay until someone edits one.
- **Vendor contacts** are not covered — still open (sibling question to the developer).
- **A database constraint** can be added later, once FCC emails are restored and cleaned.
- **Swapping two contacts' emails in one save** can be refused by the API. Rare; edit them
  one at a time.
