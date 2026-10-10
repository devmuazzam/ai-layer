---
title: Mobile password character reveal — requester-authorized TCG-34 direction
source: decision/requester in Codex session
decided: 2026-10-09
decided_by: >-
  The requester in this Codex session explicitly authorized the behavior and
  selected native support. Their name was not supplied; their client or product
  authority has not been established. The decision was also recorded on TCG-34
  in Linear under abdulmuazzam@codingcops.org, comment
  629bf003-bab6-40f8-b1de-032af5c6e1a7. That account attribution identifies the
  recorded comment, not the unnamed requester.
status: reference
requester_authorization: explicit — behavior and native implementation selected in this Codex session
client_ratification: not recorded
resolves: []
linear: [TCG-34]
tags: [module/field-ops, kind/decision, authentication, open-questions]
---

# Mobile password character reveal — TCG-34

## Decision and standing

For [TCG-34](https://linear.app/the-crane-guys/issue/TCG-34), the requester explicitly
authorized preserving the current password behavior and eye toggle. In hidden mode,
each newly typed character should be visible briefly; entering the next character
must hide the previous one. The eye toggle continues to control full-value visibility.
The SMS six-digit verification-code input remains unchanged.

The requester separately selected native support to preserve native secure-input
protections after being told that it requires a new development/production build
and is unavailable in Expo Go. This is explicit authorization for the current
implementation, recorded with `status: reference`; no TCG client ratification or
verified product ruling is claimed.

## Original ask and questions answered

The original UAT ask is recorded in
[uat/sessions/uat-session-2.md](../uat/sessions/uat-session-2.md), Login / General,
from the 2026-09-09 session: “The next character is written and then hidden. Apply
this validation on the App login page.” That source is `status: unverified`.
[uat/INDEX.md](../uat/INDEX.md) identifies these sheets as records of asks rather
than adjudicated specifications.

The reveal direction and whether the change should affect the SMS code input are
now answered by this session's requester. Those answers are not attributed to the
UAT client. The Linear decision comment is recorded under
`abdulmuazzam@codingcops.org`, comment ID
`629bf003-bab6-40f8-b1de-032af5c6e1a7`.

## Implementation detail and validation status

The requester did not specify or approve an exact reveal timer. The planned
Android implementation uses the native standard 1500 ms interval; iOS retains
its native secure field. These are implementation details, not human-approved
timing requirements.

Native implementation is underway. No validation has been performed for this
decision record; it provides no build, device, test, or runtime sign-off.

## Effect on the vault

Only this decision record is added. No UAT source is promoted to verified or
superseded, no conflict is adjudicated, and no gap is marked resolved. The
requester's direction is durable without claiming client ratification.
