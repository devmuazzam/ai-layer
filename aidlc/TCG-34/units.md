# TCG-34 units

| Unit | Outcome | Requirements | Status |
| --- | --- | --- | --- |
| U1 | Shared Input configures native Android hidden-mode character reveal, preserving secure input and SMS | REQ-01–03 | implemented; native device validation pending |

Branch: `feat/TCG-34-password-character-reveal` in client and overlay repositories.
One independent native implementation; no stacked unit or dependency upgrade.
Scope: existing Input, local Android Expo module, JS integration coverage and manual
native verification instructions. Native support chosen by requester, not client ratification.

Verification: Expo autolinking resolution discovers the local module; static diff checks.
No tests, builds or typechecking run. No commit, push, store build, ticket closure or deployment.
