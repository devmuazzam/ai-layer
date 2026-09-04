---
title: Safety and compliance — module index
source: shared-folder/Project-Repository-2026-09-04/3.6.1_MODULE-SAFETY-COMPLIANCE/ and 1.0.1_BUSINESS-REQUIREMENTS/TCG_FORMS_(paper_and_electronic)/
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/field-ops, module/payroll, module/admin, kind/index, safety, compliance, certifications, inspections, lift-plans, permits]
entities: []
---

# Safety and compliance

**Where this lives and why.** The vault's ten-module scheme has **no safety module**. Safety is not a
screen — it is a set of obligations that attach to a job, a unit, an employee and a customer, and
almost all of its *capture* happens on the crew's device. So it lives here, in `field-ops/`, tagged
`safety` · `compliance` · `certifications`, and pages that are really about employees or assets say
so and link across.

**What is here.** Everything TCG's safety department shipped in the 2026-09-04 Project Repository
drop (`3.6.1_MODULE-SAFETY-COMPLIANCE`, 8 files), plus the two safety forms that arrived in the
general forms folder instead.

## The requirement this material answers to

**Safety is in the initial build, and the client said so on 2026-05-03.** Entry #11 of
[erp-review-log.md](../../erp-review-log.md) is Melissa McNutt's own statement —
*"Yes safety will need to be built in the initial build. Currently we are only using FCC for tracking
employee certifications for safety"* — with six named needs:

| Asked for | Nearest material here |
| --- | --- |
| Track **employee certifications and training expirations**, with expiry notifications | [01](01-ideal-single-safety-platform.md) · [field-paper-forms.md](../field-paper-forms.md) §4 |
| **On-site JSAs** | [02](02-jsa-and-lift-planning-forms.md) |
| **Audit forms that attach to jobs**, with pictures, compiled to track trends | [03](03-field-audit-and-safety-value.md) · [value-engine-field-safety-storage.md](../value-engine-field-safety-storage.md) |
| **Employee certifications on the app** | [field-app-demo-2026-06.md](../field-app-demo-2026-06.md) §8 |
| **Upload trainings and have employees take them** | [01](01-ideal-single-safety-platform.md) — nothing else in the drop |
| A **library of safety programmes** field employees can see | [01](01-ideal-single-safety-platform.md) — nothing else in the drop |

Neither Field Ops FRD carries a safety *module*: `FR-FOP-011 JSA`, `FR-FOP-017 Compliance Checklist`,
`FR-FOP-025 Deficiency Reporting` and `FR-FOP-028 Certifications` are the whole of it. **The gap
between what #11 asks for and what the FRDs specify is the largest single gap this drop exposes in
field-ops.**

## Files

| File | Answers | KB |
| --- | --- | --- |
| [01-ideal-single-safety-platform.md](01-ideal-single-safety-platform.md) | **What does the safety department actually want?** — the July 2026 wish-list, twelve domains, and the four commercial platforms it names as already doing it | 10.0 |
| [02-jsa-and-lift-planning-forms.md](02-jsa-and-lift-planning-forms.md) | **What is a JSA at TCG?** — two different 2026 forms three months apart, the Crane Guys Standard gate, and the on-site scope-of-work lift calculation | 16.4 |
| [03-field-audit-and-safety-value.md](03-field-audit-and-safety-value.md) | **How is safety measured and reported?** — the field crane audit, the Safety Value Assessment, and the quarterly customer-facing report with its metric list | 13.9 |
| [04-incident-investigation-form.md](04-incident-investigation-form.md) | **What happens after an incident?** — the 24-hour report, its full code lists, root causes and corrective actions | 10.0 |
| [05-customer-imposed-safety-requirements.md](05-customer-imposed-safety-requirements.md) | **What do customers require of TCG?** — the SCE 71-page orientation and safety plan, and two H&M/Mesa subcontract safety documents | 18.3 |

## What is not here

- **TCG's own Safety Manual and IIPP.** Referenced by name a dozen times in the SCE plan as the
  authority behind every mitigation. **Not in this drop.** Without it, most of what §05 records is a
  pointer to a document nobody has.
- **The employee handbook**, cited by the meal-and-rest attestation on every ticket and timesheet.
- **The Field Availability Options Form** referenced by the crew intake form.
- Any **safety-programme library** or training content.

## Related, elsewhere in the vault

- [../e-ticket-worked-example-44944.md](../e-ticket-worked-example-44944.md) — the 6-item
  `JSA 12.18.25` job checklist as actually completed on a job
- [../field-paper-forms.md](../field-paper-forms.md) — the crew intake certification list and the
  sling inspection sheet
- [../field-app-demo-2026-06.md](../field-app-demo-2026-06.md) — JSA, incident reporting, SOS and
  certification screens as built in the June 2026 prototype
- [../fcc-nexgen-service-guide.md](../fcc-nexgen-service-guide.md) — unit **certifications** as
  activities in the legacy system, and the Certification Type that constrains who may do the work
