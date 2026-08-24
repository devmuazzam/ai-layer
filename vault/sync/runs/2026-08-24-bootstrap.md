---
title: Confluence sync — bootstrap run, 2026-08-24
run: 2026-08-24-bootstrap
kind: sync-run-report
executed_by: manual (Claude Code session, syed haris) — the §10 nightly pipeline is still unbuilt
status: report
tags: [module/all, kind/sync-report]
---

# Sync run 2026-08-24 — bootstrap

First run ever. No manifest existed; this run created it. Method differs from steady-state
(§3) in one honest way: with no stored hashes, drift detection used `lastModified` as a
**negative** filter — a page untouched since its capture cannot have content drift, because
every published Confluence edit bumps `lastModified`. Only pages modified on/after
2026-08-10 were fetched and compared. False *positives* (label/move-only bumps) are
possible under this method; false negatives are not.

## Scope

| | |
| --- | --- |
| Spaces swept | TCG (71 pages), TPD (10), Umair Khan personal (9) |
| Tracked (manifest) | **40 pages → 148 vault files** (matched via `source:` frontmatter, by title) |
| Outside sync | `status: reference` files (§4.4), `generated/conflict-stub` files, payroll/ (OneDrive), meetings transcripts/summaries (user-supplied) |
| Fetched this run | 7 pages (3 drift candidates + 4 overlap/new) |

## Results at a glance

| Class | Count | Where |
| --- | --- | --- |
| Drift — staged CLEAN | 1 | `queue/2026-08-24-bootstrap/sprint-8-report.md` |
| Drift candidates cleared (no content drift) | 2 | Atom user stories · Mobilization & Demobilization — below |
| New since migration → CONFLICT (§4.3) | 2 | Craft codes · Payroll management — `.conflict/2026-08-24-bootstrap/` |
| New since migration → already registered | 1 | Mob & demob (143458306) — `quotations/mob-demob-INDEX.md` already documents it; page unchanged since that stub (both 2026-08-11) |
| New since migration → no content | 1 | "Documents" (141918209, Aug 10) — **empty body**, title only. Nothing to stage. |
| New since migration → report-only | 2 | Sprint 10 Report (159907841) · Sprint report 9 (152829955), both Aug 21 — sprint-report family; README exclusion policy applies. 13-august-QA (145195009, Aug 17) likewise QA family. |
| Stale sources (§5.2) | **0** | every tracked title resolves |
| Holds (§5.3) | 0 pages held | H2 n/a (nothing modified within 30 min of run); H1 not observable through the current API access — stated as a blind spot |
| Verified demotions | 0 executed — but see `.conflict/2026-08-24-bootstrap/sop-triplication.md` | all six verified SOPs lack `verified_hash`; §5.1.1 makes that a demotion on the next run unless repaired first |

## The two cleared drift candidates, so nobody re-checks them

**Atom Mobile Application (95158273, modified Aug 11).** The vault's 8-file split already
reproduces the page's current state verbatim, structural defects included — two sections
both numbered `US-11`, `PIC 10` where an EPIC number belongs, no `US-12`, epic numbering
jumping 4 → 11 (the migration note in `03-work-execution-and-lunch.md` says "reproduced as
written"). Fingerprint match on all markers; no staging. **The defect is upstream and 13
days old** — the H3 signal that held this page on 2026-08-11 would fire on every future run
until the page is repaired. Escalate to the page owner (author of record: Umair Khan);
sync cannot fix it and the vault must not.

**Mobilization & Demobilization (142049281, modified Aug 10).** Modified on migration day —
ambiguous by date, so compared in full: headings, FR-1…FR-8, REQ-1…REQ-5 all match the
vault copy exactly. The vault captured the post-edit state. No drift.

## Discovery: 31 TCG pages never migrated (§3.3)

Not new — they predate the migration and were not captured. The migration's exclusion
policy (README → *What this vault does not contain*) covers some of them (sprint 3–7
reports, JQL-link defect); it does not obviously cover all. **Substantive product topics
with no vault representation:**

`Assets` (79462401) · `Settings` (79134723) · `Department` (79757313) · `Employees and temp
employees` (83951617) · `JobSite` (112787458) · `Permit and plan` (92766210) · `Yard
operations` (98500609, distinct from the migrated "Yard operations jz") · `Tool and
Riggings` (79364098, distinct from the migrated "Tool and rigging") · `User stories for
TCG` (30867465) · `FRDs` (75497473)

The last four are the familiar hazard: near-duplicate titles of pages the vault *did*
migrate. Sprint/QA/feedback family (13 pages), the TCG-space SOP copies (6 — see
sop-triplication), and `TCG Home` account for the rest. Disposition belongs to the
reorganization work, not to sync: candidates for module folders when `product/` is carved
up.

## Bootstrap caveats — what the next run must know

1. **`hashBasis: vault-body-bootstrap`** — manifest hashes are over vault bodies (which
   include migration notes), not over converted upstream markdown. First implemented run:
   fetch every tracked page once, convert per README conversion notes, compare content,
   rewrite hashes with basis `converted-upstream`. Until then hash inequality vs upstream
   proves nothing.
2. **`confluenceVersion: null`** everywhere — the CQL listing does not return versions.
3. **Draft state (H1) is invisible** through current API access; only H2/H3 were checkable.
4. `lastModified` from CQL has day granularity; the H2 30-minute window needs the page API.
5. The staged sprint-8 change awaits promote; its manifest hash is the *current vault*
   body and must be re-recorded at promote.

## Next run, in order

1. Resolve sop-triplication (or accept six demotions per §5.1.1).
2. Promote or reject `queue/2026-08-24-bootstrap/sprint-8-report.md`.
3. Adjudicate the two payroll `.conflict` items — they gate the payroll knowledge-base work.
4. Upgrade hashes to `converted-upstream` (caveat 1).
