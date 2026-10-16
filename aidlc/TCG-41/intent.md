# Intent — TCG-41

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `TCG-41` |
| Title | Assets: decide what to do with the Bar Code field |
| Type | UAT remediation |
| Branch | `fixes/TCG-15-OCT` (shared with the other 2026-10-15 tickets) |
| Captured on | `2026-10-16` |
| Captured by | Claude Opus 5.5, session for devmohsinakram |

## 2. Ticket text (as given)

**Problem.** Two UAT requests disagree. UAT 1 asked to remove Bar Code from Assets > Create. UAT 6
asked to "review the barcode functionality". The field is on both Create and Edit (they share one
form) and shows on the asset detail page. Many assets moved over from the old system already have
barcode values.

**What should happen.** Unspecified until someone decides what an asset barcode is for.

**Blocked / needs decision.** A named person at TCG must answer: What is an asset barcode used for?
Remove it from Create only, or also from Edit and detail? Hide the field, or delete the saved values
too? What happens to barcodes brought over from the old system? Do not build until this is decided.

**Done when.** The decision is written down. The Create, Edit and detail screens match it. No barcode
is shown that cannot be set.

**Notes for developer.** Do not change the Tools barcode or its QR code page. That is a different
field. Automated tests fill this field by its label. Update them in the same change. Full technical
details are in the first comment (not available in this session).

## 3. Business intent

UAT 1 (`vault/uat/register-2026-09-18.md:218`) and UAT 6 (`:327`), both NOT DONE and in tension.

## 4. Where it went

The ticket said not to build before TCG decides. The developer chose to build the reversible option
anyway — hide everywhere, keep the data — and to leave the automated tests untouched (`spec.md` §12).
