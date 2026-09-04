---
title: Project Repository filing rules — TCG's own SSOT folder structure
source: shared-folder/Project-Repository-2026-09-04/00_README_Folder_Structure_and_Rules.txt
migrated: 2026-09-04
updated: 2026-09-04
status: unverified
conflicts_with: []
jira: []
tags: [module/admin, kind/standard, provenance]
entities: []
---

# Project Repository filing rules — TCG's own SSOT folder structure

**What this is.** The README that sits at the root of the SharePoint/Teams "Project Repository"
TCG shares with CodingCops. It declares that directory the **Single Source of Truth (SSOT)** for
all documentation, assets and deliverables on the ERP project, and sets out the folder hierarchy,
naming convention and version-control rules that both the internal team and vendor partners are
asked to follow.

**Why it matters.** Every numbered folder path cited by the 2026-09-04 drop's vault pages —
`1.0.1_BUSINESS-REQUIREMENTS`, `2.1.1_DATA-MIGRATION`, and so on — comes from this scheme. This
page is what makes those citations legible, and it is the client's own statement of where a new
document is supposed to go.

> This describes the **client's** filing system, not this vault's. The vault's own organisation is
> [STRUCTURE.md](../STRUCTURE.md). The two are unrelated schemes over the same material.

---

## The hierarchy

Numbered so that folders sort logically rather than alphabetically. The README asks that top-level
folder names not be altered.

| Prefix | Meaning | Named sub-folders in the README |
| --- | --- | --- |
| `0.x.x` | **Project management** — administrative docs, contracts, schedules, high-level planning | `0.1.1_PROJECT-SCHEDULES` (Gantt charts, sprint timelines) · `0.2.1_MEETING-NOTES` (weekly syncs, standups) |
| `1.x.x` | **Requirements & design** — "the blueprint of the software" | `1.0.1_BUSINESS-REQUIREMENTS` (user stories, BRDs, scope) · `1.1.1_UX-UI-DESIGN` (wireframes, Figma exports, mockups) · `1.2.1_TECHNICAL-SPECS` (API docs, architecture diagrams) |
| `2.x.x` | **Development & QA** | `2.0.1_DATABASE` (schema, SQL scripts, data dictionaries) · `2.2.1_QA-TESTING` (test plans, UAT sign-offs, bug reports) |
| `3.x.x` | **Functional modules** — per-module documentation (finance, HR, inventory, …) | — |
| `9.x.x` | **Archive & shared resources** | `9.0.1_ARCHIVE` ("do not delete files; move them here") · `9.9.9_SHARED-RESOURCES` (logos, fonts, style guides) |

> The drop as received also contains `0.0.1_PROJECT-ADMIN` (contracts, SOWs, NDAs, vendor contact
> lists), `1.0.2_FCC-RESOURCES-GUIDES` and `2.1.1_DATA-MIGRATION` — folders the README does not
> name. Several folders carry their own one-line `__this folder for …` placeholder text file
> stating their purpose. The README is therefore **not a complete index of the repository as it
> stands**.

## The "General" folder — explicitly forbidden

> "DO NOT USE THE 'General' FOLDER FOR PROJECT DOCUMENTATION."

It is generated automatically by Microsoft Teams for chat attachments, is unstructured, and is not
to be used for permanent file storage.

## File naming convention

`[YYYY-MM-DD]_[Category]_[Description]_[vX.X].[ext]`

The README's own examples: `2025-10-12_Specs_InventoryModule_v1.0.docx`,
`2025-11-05_Meeting_WeeklySync_Notes.pdf`.

> Most files in the drop **do not follow this convention** — dates appear as suffixes
> (`… 2026-05-11.docx`), as US-format infixes (`TCG Organization Chart 6.16.26.pdf`), or not at
> all. The convention is stated as a request, and compliance is patchy.

## Version control

- SharePoint/Teams version history is the mechanism.
- Avoid saving `v1`, `v2`, `vFinal` as separate files "unless necessary".
- Either overwrite the existing file so its version history updates, **or** move the old file to
  `9.0.1_ARCHIVE` before uploading the new one.

---

## Source

`00_README_Folder_Structure_and_Rules.txt` — 2.4 KB, plain text, sat loose at the root of the
Project Repository outside every numbered archive. Reproduced above in substance; the ASCII rule
lines and greeting are not.

## The companion Teams rollout deck — `TCG_Guide_IT_MicrosoftTeams_GettingStarted_v1.0.pptx`

Eighteen slides that converted to zero text; the slide images were extracted and three
representative ones read on 2026-09-04. It is TCG IT's staff-facing guide to the move onto
Microsoft Teams — the platform the Project Repository itself lives in — and it explains the
filing rules above from the user's side:

- **Section 1, "Welcome to Microsoft Teams"**: *"We are moving our day-to-day communication and
  file sharing into Microsoft Teams. This replaces scattered email chains and group texts…"* What
  Teams replaces — *group text messages between staff · email chains with attachments · files saved
  to personal desktops · shared drives with no structure*; what it gives — *organized channels by
  topic · files stored next to the conversation · shared calendars per department · one searchable
  place for everything.*
- **Section 2, "Teams & Channels"**: three Teams every employee belongs to — **Company – All
  Staff** (announcements, IT help, celebrations, policies), **Your Department Team** (*"Sales,
  Dispatch, Finance, HR, Safety, Fleet, IT, or Field Projects"*), and **Management Hub**
  (managers and department leads; cross-department coordination and KPI reporting).
- **Section 4, "Files & Documents"**: the one rule — *"files live where their conversations live.
  There are three zones, and every file belongs in exactly one of them."*

The department list is the same eight-way split the June 2026 org chart draws
([engagement-directory-and-org-charts.md](engagement-directory-and-org-charts.md)), and the
"group texts" this replaces are the texted dispatch-sheet screenshots the FCC health check called
out ([fcc-nexgen-health-check-2025-12-16.md](fcc-nexgen-health-check-2025-12-16.md)).
