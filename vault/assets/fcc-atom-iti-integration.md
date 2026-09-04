---
title: FCC ↔ ITI Learning Hub integration — how certificates reach the unit record today
source: shared-folder/Project-Repository-2026-09-04/1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/NexGen_Atom_ITI_Integration_User_Guide_v2.0.pdf
migrated: 2026-09-04
updated: 2024-01-01
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, module/field-ops, module/admin, module/assets, kind/reference, integrations, certifications, compliance, reference-data]
entities: []
---

# FCC ↔ ITI Learning Hub integration

**What this is.** Vendor documentation, **version 2.0, January 2024**, for the integration between
**Fleet Cost & Care (FCC / NexGen FMS)** and the **ITI Learning Hub** — ITI being **Industrial
Training International**, a crane-industry training provider. It documents a shipped, configurable
FCC feature, available *"as a part of NexGen version 2022.2.0.0 and later"*. It also shows the
**Atom** mobile app surfacing the ITI portal to field crews.

> **Routing note.** This page is filed in `assets/` because that is the group it arrived with in
> the 2026-09-04 drop. **Its subject is employee certifications, not assets** — if the vault is
> re-routed by subject it belongs in `payroll/` (which owns `employee*`) or `admin/` (which owns
> integrations). It is tagged for all of them.

> **Nothing here is a requirement for the TCG ERP.** It describes a capability the legacy system
> has. Whether TCG uses it, and whether the ERP must replace it, is not stated in any source in
> this drop.

---

## 1. What the integration does

The vendor's own framing: FCC and ITI *"have partnered to create an integration between FCC's
fleet management software and the ITI Learning Hub"*, so that customers can

- automate learning assignments to employees with learning paths,
- **synchronise training achievements in ITI with employee records in NexGen**,
- reduce data entry and duplication,
- reduce employee downtime,
- *"Prove to customers that onsite employees have the qualifications and training records for each
  job."*

Stated objective: *"automate the learner creation in ITI with Employee information from FCC and
download the course completion certificates from the ITI to FCC to reduce the manual HR tasks
involved between the two systems."*

**So it is a two-way pipe with one direction each way:** employees go out to ITI as *learners*;
certificates come back to FCC as records with PDF files attached.

---

## 2. Configuration

| Step | Where |
| --- | --- |
| Turn the feature on | `Admin → Set System Defaults → Features` tab |
| Store the API token | `Admin → Set System Defaults → External APIs → ITI Integration Token` — with a **Test** button that validates the token and the portal |
| Sub-License Key | optional; supplied by ITI depending on account setup |
| ITI Learning Hub URL | the portal link *"that will show up on ATOM for the on-field employees to access portal easily from their mobile devices"* |
| Image Icon | a `.PNG` / `.JPG` / `.JPEG` upload; once set, the icon appears **on the Atom app under the Display Menu** as the way into the ITI portal |
| Course SKUs | `Maintain → Employees → Certifications` — each certificate is configured with an **ITI Course SKU**, supplied by ITI |

**The SKU configuration is the filter, and the guide says so in a note:** *"only the configured ITI
Course SKU certificates will be imported into FCC with Import Employee Certificate feature."* A
certificate with no SKU mapped never arrives.

**[credentials present in the source file — the guide describes where an API token and an optional
sub-license key are entered; no token value appears in the document, and none has been copied.]**
The guide's screenshots of the token screen were not transcribed.

---

## 3. Employee → ITI

- **Automatic on create.** *"When an employee record is added via Maintain → Employees Screen and
  ITI Integration is turned on, then a learner record is created in ITI."*
- The resulting **ITI ID** is stored on the FCC employee record and shown under the
  **Certifications** tab; its presence is how you verify the learner was created.
- **Batch export** for existing employees: `Export/Import → Export Employees to ITI`, filtered by
  **Company**, **Yard** and **View By** — which defaults to `Not Exported`.
- **Matching is by email address.** *"We are using the Email ID to check if the Learner record
  exists in ITI or not."* If the learner already exists, FCC retrieves and stores the existing ITI
  ID rather than creating a duplicate.
- **Email is mandatory.** *"Email ID is required field in ITI and If an Employee is missing Email
  ID, then the Select option is disabled for that Employee record."* An `Export Status` column
  shows *"Exported"* on success and an `Error Message` column carries failures.

---

## 4. ITI → FCC

- `Export/Import → Import Employee Certifications`, filtered by **Certificate Issue Date** — usable
  either for a historical backfill or incrementally.
- **Already-imported certificates are locked out of re-import**: *"If the Employee Certificate is
  already imported for the selected date range, the option to select would be disabled."*
- Save *"would import the certificate record into FCC and the file link, PDF copy of the Employee
  certificate into FCC"* — so the imported artefact is a record **plus a stored PDF**.
- Imported certificates appear on `Maintain → Employees → Employees → Certificates` tab. A **red
  file-links icon** indicates attached files; double-clicking opens `Maintain File Links → Employee
  Certifications`, and the lightning-bolt icon opens the PDF itself.

---

## 5. Why this is in the assets group at all

Two reasons, both indirect and both worth knowing:

1. **It is the only source in the drop that shows the Atom app's configuration surface** — the
   Display Menu, and an admin-uploaded icon that adds a third-party portal link to it. Atom is the
   legacy field app the TCG mobile app replaces; see `field-ops/atom-mobile-app-user-stories/`.
2. **Certification currency is what the asset-side "batch readiness" ask depends on.** The deck in
   [asset-record-requested-additions.md](asset-record-requested-additions.md) asks for a dispatch
   report proving everything in an asset batch is *"good/current"*; on the people side, the
   equivalent currency check is exactly what this integration keeps up to date. The two are not
   connected in any source — this is an observation, not a stated design.

FCC's employee-certificate data itself is elsewhere: `FMS_EMP_CERTIFICATES` and `FMS_CERTIFICATES`
appear in `FCC_EMPLOYEES_20260705.xlsx`, which belongs to the payroll group of this drop.

---

## Source

`1.0.2_FCC-RESOURCES-GUIDES/FCC-USER-GUIDES/NexGen_Atom_ITI_Integration_User_Guide_v2.0.pdf` —
16 pp, version 2.0, dated **Jan. 2024**, `pdftotext -layout`. Screenshots (the token screen, the
Atom phone and tablet layouts, the certificate grids) are images and were not transcribed; several
pages are screenshot-only and converted to nothing but their page number.
