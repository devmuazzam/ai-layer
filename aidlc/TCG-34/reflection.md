# TCG-34 implementation checkpoint — 2026-10-10

The requester settled the conflicting UAT interpretations before implementation,
excluded SMS masking and explicitly selected native secure-field support.
The decision is recorded in the vault and a Linear comment; no client ruling is claimed.

Shared Input keeps secureTextEntry and the real value. A local Android Expo module
uses PasswordTransformationMethod-based rendering with a native bounded visibility
span. Android's 1500 ms interval is an implementation detail; iOS stays native.
No RN patch, new JS dependency or JavaScript masked-value editor was introduced.

Static review corrected the interrupted implementation's layout-event target lookup:
RN 0.86 LayoutChangeEvent does not declare nativeEvent.target. Input now resolves
the existing forwarded native ref via findNodeHandle. Native configure also preserves
selection and clears any existing single-character reveal when entering hide mode.

Verified: Expo autolinking discovery of TcgPasswordReveal. Added JS integration tests
and native device checklist, but did not execute tests/builds/typechecking per requester.
Kotlin compilation, Android secure-field rendering, native timing, iOS behavior and
password-manager/accessibility compatibility remain unverified. No shipping claim.

Do not reuse the old ticket's Expo/RN version assumptions: current checkout uses Expo
57 and RN 0.86.3. Native integration was read against those installed sources.
