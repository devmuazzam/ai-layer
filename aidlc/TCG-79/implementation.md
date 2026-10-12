# TCG-79 — Path B construction record

Scope source: Linear TCG-79 description and technical comment, plus the user's approved six-point implementation plan in this session. Privacy and ownership are expressly excluded by the user. Existing draft/session improvements are reused.

Branch: fix/TCG-79-crash-reporting-recovery. Started 2026-10-10.

Reproduction by static inspection: crashlytics.ts was a no-op; the only boundary replaced the root UI and falsely claimed reports were delivered; no ticket/step reporting or native build display existed. Firebase native packages were removed in f701b8402 because of static-framework conflicts.

Construction: restore RNFirebase26.4 with its documented SPM opt-out/static linkage fix; retain exact native-build Hermes maps for manual symbolication; reuse CrashlyticsProvider, ErrorBoundary, the field persona shell and env configuration. Native exceptions chain through the SDK; production Hermes rejections use native tracking. Add navigation recovery, build display, capture/storage error reporting and targeted regression coverage.

Analyst pass: found ticket context cleared when the recovery boundary unmounted TicketLayout. Context ownership moved outside the recovering subtree. Re-review found no further consequential correctness issue by static inspection; native delivery remains unverified. Privacy/ownership not reviewed.

Verification constraint: user requested no builds/tests/typechecking earlier in the session; no such commands run. Targeted ESLint, script syntax checks and git diff checks passed. Tests were authored but not executed. The restart regression checks photo references and attachment metadata, not photo bytes. A full device crash, five-minute Firebase delivery, native symbol quality, exact-map symbolication and real-photo restart remain pending.

Publication scope: approximately 412 changed source lines excluding tests, documentation, dependency lock changes and the user's existing Metro edit. Before publishing, resolve the review skill's approximately 400-line guidance through an explicit size exception or split infrastructure and recovery into separate PRs. No publication is part of this implementation request.

Operational inputs: Firebase EAS file variables for each platform/environment and a new native preview build. No production crash button; device test uses a temporary probe removed before shipping. No commits or PR publication requested.

User-requested test probe: added a temporary field Menu native-crash control with a confirmation dialog. Build config enables it only for EAS preview; Expo Go additionally hides it. Menu navigation clears ticket context as designed, so this probe verifies delivery/build/native traces, while in-ticket context verification still needs a step-local probe. Remove the control and previewCrashTestEnabled flag after verification.

Preview build 7f410efb-cb76-4e1c-9ac9-3b7dde0e6edb failed while evaluating android/app/build.gradle: firebaseCrashlytics() was unavailable on the release build type. RNFirebase's Expo mod appends its apply-plugin statement, so symbol configuration now waits on plugins.withId('com.google.firebase.crashlytics') before accessing its extension. Script syntax and diff checks passed; a replacement native build remains required. Expo Doctor additionally warned about legacy newArchEnabled/edgeToEdgeEnabled fields and a missing expo-server peer; those warnings did not terminate this build.

Later user authorization explicitly requested builds and then local compilation. Installed SDK platform 36/NDK 27.1.12297006; Gradle installed Build Tools 35, CMake 3.22.1 and Java 17. Local Firebase files were supplied by absolute path and remain ignored. Local compilation exposed missing direct babel-preset-expo dependency (added 57.0.14), Java 25 CMake incompatibility (used Java 17), and an existing password-reveal module import unavailable on the RN compile classpath (replaced ReactEditText with its Android EditText base; only base-class methods are used). Gradle 9 additionally required generateCrashlyticsSymbolFileRelease to depend explicitly on mergeReleaseNativeLibs; the config plugin now declares this.

Resumed Gradle in preserved EAS workspace /tmp/tcg79-preview-local-2 with signing credentials, Java 17, 4 GB heap/1 GB metaspace and four workers. Final :app:assembleRelease and native symbol generation/upload succeeded (1094 tasks, 61 executed, 1033 up-to-date). Ran the artifact collector against the exact generated map; saved APK/map/metadata at apps/mobile/build/preview. APK signature verification passed and assets/app.config enables the preview crash control. Original EAS wrapper attempts failed; the final successful assembly resumed directly through Gradle. Expo Doctor's remote schema check was unavailable due DNS; no standalone tests/typechecking were run. Device reporting/recovery and iOS build acceptance remain pending. No cloud build was submitted during these local attempts.
