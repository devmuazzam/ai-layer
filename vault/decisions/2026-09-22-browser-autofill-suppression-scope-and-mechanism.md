---
title: Browser autofill suppression — scope and mechanism (Fouzan Shakil, 2026-09-22) — decision
source: decision/Fouzan Shakil — PR review of `fix/remove-chrome-suggestions`, answering admin/gaps.md (a)–(e)
decided: 2026-09-22
decided_by: >-
  Fouzan Shakil (internal UI / form conventions) — the owner named on the
  open register entry. An internal build convention, not a TCG client-side
  sign-off, so `status: reference`: binding on the CodingCops build and open
  to being overruled by TCG. Questions (b) and (d) were flagged in the
  register as needing Brian Petros / Ehtesham Anwar and QA respectively;
  both are answered here in the *less* invasive direction, which removes the
  security and accessibility exposure rather than accepting it.
status: reference
conflicts_with: []
resolves:
  - admin/gaps.md#browser-suggestions-suppressed-on-every-input-app-wide
tags: [module/admin, kind/decision, forms, web, accessibility]
entities: []
---

# Browser autofill suppression — what is suppressed, and how

Chrome ignores `autocomplete="off"`, so internal forms kept offering saved emails,
addresses and phone numbers, and kept re-offering values typed into the same field
before. This records what the platform does about that, and closes questions (a)–(e)
on [admin/gaps.md](../admin/gaps.md).

## The five questions

**(a) Scope — every field, not a risk-ranked subset.** Every text input, textarea and
select in `apps/web` suppresses browser suggestions. Picking "only the harmful ones"
requires someone to re-make that judgement on every new form; "all of them, one
mechanism" does not.

**(b) Login is in scope as an exemption, and password managers must keep working
there.** The login email and password carry real `username` / `current-password`
tokens and none of the password-manager ignore attributes, so 1Password, LastPass
and Bitwarden offer and save TCG credentials normally. This reverses the behaviour
the register describes. A corporate portal that cannot be used with a password
manager pushes people toward typed and reused passwords, which is the worse of the
two security outcomes.

**Non-login password fields stay suppressed, and that is a real cost:** reset-password,
accept-invite, the agency portal-password field and the change-password OTP will not
be offered or saved by a manager. Accepted deliberately — those are set-once flows,
and the agency portal password is third-party business data stored on a customer
record, not a TCG credential.

**(c) The read-only-until-focus lock is removed.** It made fields non-interactive
until focused, which suppressed the caret, raised an unanswered question for
keyboard-only and assistive-technology users, and broke Playwright's `fill()` across
the E2E suite. The unique token and decoy `name` do the actual suppression; the lock
was a second mechanism whose only reliable effect was degrading the form.

**(d) The U+200C label disguise is removed.** Inserting an invisible character after
the first letter of every label is what a screen reader announces. The register
flagged this as needing QA sign-off before merge; removing it retires the question
instead. Chrome's field classifier does read label text, so suppression now leans on
the token and the decoy `name` — accepted, because an accessibility regression is not
a reasonable price for one extra heuristic signal.

**(e) No allowlist.** There is no per-field opt-out list to maintain. A field opts
*in* to browser help by passing a real `autocomplete` category, which is how login
stays exempt. Today login is the only caller that does.

## The mechanism, and why each part is load-bearing

Chrome runs two separate systems and they need different answers:

| | What it offers | Beaten by |
| --- | --- | --- |
| Profile Autofill | saved addresses, emails, phones | an `autocomplete` token Chrome has never seen |
| Typed-history | values *you* typed into a field before | a DOM `name` Chrome has never seen |

So every control gets both: a `chrome-off-<key>` token and a decoy `name`.

**The decoy has to change on every page load.** An earlier build derived it from
React's `useId()`, which is deterministic by design — server and client must agree
during hydration — so the decoy renamed each field exactly once and typed-history
simply accumulated under the new name. The key now mixes a client-only salt
regenerated per page load.

**Real `id` and `placeholder` values are preserved.** An earlier build rewrote both.
That bought no extra suppression — typed-history keys on `name`, which is already a
decoy — and invalidated roughly 72 `qa-automation` selectors, in a suite no CI job
runs.

**`data-tcg-field` carries the real field name for tests.** The decoy `name` has to be
opaque to Chrome but the E2E suite still needs a stable handle. A `data-*` attribute
is not an autofill signal.

**A source-level guard enforces it.** `apps/web/src/lib/browser-autofill-coverage.test.mjs`
fails the build when a raw control carries no suppression, a hardcoded token
(`"off"` included — Chrome ignores it, and any literal is identical on every load), or
a real `name` with only the token. Adding an exemption means editing an allowlist in
that file, which is deliberate.

## What this does not claim

Chrome's dropdown is native UI outside the DOM, so no automated check confirms it stays
shut; the guard verifies the attributes, not the browser. Third-party password managers
are **not** suppressed on ordinary fields — they largely ignore `autocomplete` and run
their own heuristics, so anyone with one installed will still see its overlay. Neither
was in the register's questions; both are recorded here so the next person does not
read this note as a stronger guarantee than it is.
