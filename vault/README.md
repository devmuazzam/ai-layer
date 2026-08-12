# TCG documentation vault

Confluence content migrated on **2026-08-10**. Everything here is a migration, not an
edit: bodies are reproduced as they were written, including typos, contradictions, and
half-finished sentences. Where content was omitted, the omission is marked inline rather
than performed silently.

## Index first — the retrieval convention

**Read [`INDEX.md`](./INDEX.md) before opening any content file.** The order is always:

1. **`INDEX.md`** — what exists, what it answers, and the four caveats that change how
   everything downstream should be read.
2. **The conflict stub**, if the area has one (`product/<topic>-INDEX.md`). One ~2 KB
   file replaces reading several contradictory documents. Five exist: field-ops-mobile,
   quotations, customers, agencies-vendors, daily-allocation.
3. **The specific file** — and its folder `INDEX.md` first if it is a split document.

Skipping to step 3 is how an agent ends up quoting one side of an unresolved conflict
as though it were settled. Most of the vault is `unverified`; the index is where that
is stated once instead of being rediscovered file by file.

## Folders

| Folder | Holds |
| --- | --- |
| `product/` | Behaviour and module specs, user stories, FRDs, feedback punch lists |
| `meetings/` | Sprint planning pages that carry real plan content |
| `domain/` | The team's Scrum SOP set — shared process vocabulary |
| `decisions/` | Dated decisions. **Currently empty by design** — see below |

`decisions/` is empty because nothing in the source Confluence was a clean dated
decision. The closest candidate (a sprint review feedback log carrying per-item
Approved / Deferred / Pending statuses) sits in the excluded client-feedback set.

## Frontmatter

Every file carries:

```yaml
title:           original Confluence page title
source:          confluence/<SPACE_KEY>/<original title>
migrated:        2026-08-10
updated:         the page's Confluence last-updated date
status:          verified | unverified | superseded | reference
conflicts_with:  vault-root-relative paths of sibling files on the same topic
jira:            SCRUM-### ids referenced in the body
topics:          3–8 subject-area tags, controlled vocabulary
entities:        domain nouns the file actually specifies
```

**All path fields are vault-root-relative** (`product/customer.md`,
`product/field-ops-frd/INDEX.md`) — never bare filenames, never `../`. Bare filenames
break the moment a file is split into a folder, which has already happened twice.

`topics:` is subject area and carries one anchor tag: every file under a field-ops
document gets `field-ops-mobile` so the broad lookup works, plus narrow tags so the
specific lookup lands on the right two files rather than all 102. `entities:` gets **no
anchor** — it states what the file specifies, and inflating it claims coverage that is
not there.

**Tags are capped — absence of a tag is not proof of absence in the file.** A file gets at
most **8 `topics:`** and **10 `entities:`**, ranked by how often the term occurs. Long
files legitimately touch more than that, so the tail is dropped. The first pass capped
both at 6 and silently discarded 252 entity tags across 50 files and 398 topic tags across
74 — including `fcc` on `product/mobilization-and-demobilization.md`, the most informative
FCC source in the vault. That was invisible until an agent cross-checked the index against
the files. **Grep the body before concluding a file does not cover something.** Both come from a frozen vocabulary listed at the bottom of `INDEX.md`; adding
a term is fine when a real domain area is missing, but coin a near-synonym
(`quoting` beside `quotations`) and retrieval quietly degrades.

Some files carry additional fields where the migration found something a reader needs:
`date_conflict` (the body's own dates disagree with the page's created date),
`provenance` / `provenance_note` (where the page came from, when that matters),
`supersedes` (Confluence pages this file replaces), and `verified_because` (why this
copy won).

### Generated files are marked as such

Conflict stubs and folder indexes are navigation, not migrated content, and say so:

```yaml
source: generated/conflict-stub    # not a confluence/ path — nothing was migrated
kind:   conflict-stub              # this file describes a conflict, it is not a spec
gap:    gaps.md#<anchor>           # the gaps.md entry it summarises
updated: 2026-08-10                # generation date, not a page's edit date
```

Marking them is better than letting generated navigation pass as source material.

### What the statuses mean

- **`verified`** — a human resolved this against its competing copies and this file won.
  Only the `domain/` SOP set is verified. It existed in triplicate across three
  Confluence spaces; the TPD copy was chosen because it is the only set containing the
  Development Process SOP. That was decided on content, not on recency — the newest copy
  was the least complete.
- **`unverified`** — migrated faithfully, never adjudicated. **This is the default and
  it covers almost the entire vault.** It does not mean the content is wrong; it means
  nobody has confirmed it is current.
- **`superseded`** — a known-outdated copy retained for reference. No file currently
  carries this status; superseded Confluence pages were not migrated, and the pages that
  replaced them record the fact in `supersedes:`.
- **`reference`** — **not migrated content at all.** Added 2026-08-11, deliberately, for
  definitional entries sourced from a person or from outside Confluence. The other three
  statuses are a *migration-confidence* axis: they answer "has anyone adjudicated this page
  against its rivals?" That question does not apply to a file that was never a page. Marking
  an external definition `unverified` would imply it is a migrated document awaiting
  verification, which misstates where it came from — and honest provenance is the whole point
  of this field. A `reference` file must carry a `source:` naming the actual origin (a person,
  a URL) rather than a `confluence/` path, and must say in its body what it does **not**
  authorise. Currently one file: `domain/fcc-nexgen-fms.md`.

  **`reference` is not a licence to specify from.** These entries resolve vocabulary. They do
  not describe behaviour, and no requirement may rest on one.

## Filenames

- `product/` and `domain/`: kebab-case topic, no date — `product/purchase-order.md`
- `meetings/`: `YYYY-MM-DD-topic.md` using the page's **created** date, not its
  last-updated date. A meeting note records when the meeting happened; last-edited dates
  drift for unrelated reasons.

## Large files are split into folders

**Any file over 15 KB becomes a folder with a local `INDEX.md`.** Pulling 38 KB to read
one 1 KB requirement is the failure mode this removes.

```
product/field-ops-frd/
├── INDEX.md                          parts: [...]   — section list, one line each
├── 01-executive-overview.md          part_of: product/field-ops-frd/INDEX.md
├── 08-functional-requirements/       a section that was itself over 15 KB
│   ├── INDEX.md                      parts: [...] + part_of: the parent INDEX
│   └── fr-fop-001-bottom-navigation.md
└── 11-open-questions-future-considerations.md
```

- Each part **inherits the parent's frontmatter** and adds `part_of:`. The folder
  `INDEX.md` carries `parts:`. Nesting works the same way at any depth.
- Split on **whichever heading level actually carries the document's structure** — `##`
  in the FRDs, whose single `#` is only a title; `#` in the user-story documents.
- **Numbered sections keep their numbers**, zero-padded, so `10-` sorts after `09-`.
  Where a document's own numbering is not a clean sequence, parts fall back to
  positional numbering and the folder INDEX says so (see `product/project-module/`).
- **Every byte of the original lives in exactly one part.** This was verified by
  sha256 of the concatenated parts against the original body, at every nesting level —
  which catches reordering and substitution, not just loss. If you re-split something,
  verify the same way; there is no Confluence diff to fall back on.
- Wikilinks were **deliberately not added inside split parts**, so that reassembly
  guarantee still holds byte-for-byte.

## Maintaining `INDEX.md` — the compression rule

`INDEX.md` is read on every lookup, so it is deliberately not a row-per-file listing of
all 153 files. When you add files, follow the same rule rather than expanding it:

- **Non-leaf files get their own row** — a path, a one-line statement of what question
  the file answers, and a size. Low-value siblings may share a row as long as each is
  still separately linked.
- **Leaf parts of a split document are enumerated by id and title**, in a compact block,
  not as table rows. Their filenames are mechanically derivable
  (`fr-fop-NNN-<slug>.md` in the named folder) and their folder `INDEX.md` is one hop
  away. This costs ~18 lines instead of ~70.
- **Structural fragments** (`00-document-header.md`, `00-section-header.md`) are listed
  only in their parent folder's `INDEX.md`. One is 36 bytes; none answers a question.

So every file is reachable, but not every file has a direct row. Keep the whole file
under 300 lines. A new file that is unlisted anywhere is a bug; a new leaf part that is
only in its folder index is correct.

## Rule for agents: surface conflicts, never resolve them

If a file's `conflicts_with` is non-empty, **you must not pick one and answer from it.**
Cite every candidate and say they disagree. Do not resolve by recency, by file size, by
which one you read first, or by which one is easier to parse.

Recency in particular is actively wrong in this vault. Worked examples, all real:

- The newest field-ops mobile document is a third the size of the two older ones, and
  the newest of those two is the *lower*-status document (v2.0 DRAFT versus v1.1
  REVIEWED, under different document IDs).
- The two newest agencies/vendors files are the two smallest and are punch lists, not
  specifications. Recency would discard the only user-story-level content.
- Before migration, the newest "tools and rigging" page in Confluence was a 38-character
  stub that would have beaten a 3.7 KB specification.

Every unresolved set has an entry in [`gaps.md`](./gaps.md) with candidates, sizes, and
dates, and the five biggest have a stub at `product/<topic>-INDEX.md`. When you hit one,
read the stub and point the reader at the gap entry.

### `FR-FOP-NNN` ids are ambiguous across documents

Both field-ops FRDs number their requirements from `001`, so **the same id means
different things in each**: `FR-FOP-013` is *Lunch Monitoring* in FR-TCG-FOP-002 and
*Lunch Timer and Alerts* in FR-TCG-FOP-001. Seventy filenames now carry these ids.
**Always cite the document as well as the id** — a bare "FR-FOP-013" identifies nothing.
Only 001, 002, 003 and the Leave Yard / Start Work / Arrive Yard transitions describe
roughly the same thing in both sets; everything else diverges.

## Caveat on `meetings/`: these are records, not plans

**Do not read anything in `meetings/` as a forward-looking commitment.** Seven of the
eight sprint pages examined during migration were written after their sprint had already
started; one plan page was created four days after its sprint *ended*. An agent asked
"what did we commit to for Sprint 6" would otherwise answer from a document written once
the answer was already known.

Treat these files as retrospective records of what a sprint contained, not as evidence of
what was planned or agreed in advance. Every affected file states the specific
discrepancy in its `date_conflict` frontmatter field. Where a body's stated dates
disagree with the page's created date, the migration flagged the disagreement rather than
guessing — including one page internally stamped 2025 that belongs to 2026.

## What this vault does not contain, and why

Absences here are deliberate. If you cannot find something, check this list before
concluding the migration failed.

| Not migrated | Why |
| --- | --- |
| Employee and department pages | Personnel content — employee record fields, union/comp/craft codes, org structure and permissions. Excluded by policy. |
| Daily scrum logs (Sprint 3, Sprint 5) | Per-person daily output and leave status. Personnel content, excluded by policy. |
| Attendee tables inside SOP pages | Named individuals. Stripped from otherwise-migrated pages; each removal is marked inline with a `[table not migrated: ...]` note. |
| Four client-feedback pages | Sprint 2 client feedback, the 5 May session notes, the Sprint 4 review feedback log, and a later feedback round. **Excluded pending a separate decision, not permanently.** The Sprint 4 review log is the only decision-bearing content found in the whole source, so revisiting this is worthwhile. |
| Sprint 3, 4, 5, 6, 7 reports | Dropped as unrecoverable. Their "completed work" was a saved Jira search URL rather than a ticket list, leaving a prose goal and a link that resolves only for someone with Jira access. Sprint 7's report additionally states the wrong sprint dates (copied from Sprint 6), which makes it worse than absent — an agent would cite it confidently. See the Sprint 7 entry in `gaps.md`. |
| The FRD "BRS References" table | Linked to payroll charts, ADP paydata, and a labor union master agreement on SharePoint. Personnel and contractual content. The omission is marked inline in `product/field-ops-frd/10-brs-references.md`. |
| Empty containers, sub-200-character stubs, unedited Atlassian templates, personal-space Overview pages | No recoverable content. |

One page was migrated **from an individual's personal Confluence space**:
`product/user-story-and-tasks.md`. It is the only source anywhere for the Yard
Management, HubSpot sync, and email 2FA stories. Its frontmatter carries a
`provenance_note` — personal-space content is more likely to be one person's private
draft than agreed specification, and should be treated that way until product confirms it.

## How a gap gets closed

**Owner: `tcg-scrum`, in one pass.** All four steps below are inside its write access — the
decision note, the frontmatter on the winner and the losers, and the `gaps.md` entry. This
used to split across two actors at step 2, and the handoff had no tracking, so the failure
it produced was a gap marked `resolved` in `gaps.md` above files that still read
`unverified`. Agents read the files, not the handoff note.

A human still makes the decision. Scrum only records it: it may set these frontmatter fields
and nothing else, never a file body, and never from its own reasoning — no named human, no
edit.

When product resolves a conflict set:

1. Write a dated note in `decisions/` — `YYYY-MM-DD-topic.md`, using the date the
   decision was made. State which page won, which lost, and the reason. The reason
   matters more than the verdict: it is what lets the next person resolve a similar
   conflict the same way.
2. Flip the winning file's `status:` from `unverified` to `verified` and add a
   `verified_because:` field pointing at the decision note.
3. Set the losing files to `status: superseded` and add `superseded_by:` naming the
   winner. Do not delete them — a superseded file with a pointer is more useful than a
   missing one, because it stops the same question being reopened.
4. Clear `conflicts_with` on the winner, and update the corresponding `gaps.md` entry to
   `Status: resolved` with a link to the decision note.

## How the vault stays in step with Confluence

This vault was built as a **one-time snapshot** on 2026-08-10. Confluence is a **living
source**. Those two facts do not reconcile themselves, so the standing relationship between
them has to be stated rather than assumed.

**The principle, which decides every specific case: sync is detect-and-triage, never
auto-absorb.** A Confluence page changing is a signal to *review*, not a trigger to
*overwrite*. The moment newest-wins flows straight into the vault, the thing the vault is for
is gone — a stable, source-tagged, conflict-marked artifact that agents and people can stand
on. *Recency is not authority* is already binding on the agents that read this vault; it binds
the process that maintains it too.

### The loop

Human-in-the-loop and cheap, on purpose. A real bidirectional Confluence sync is a large piece
of engineering and is not needed at this stage.

1. **Detect.** Find pages changed since the last migration, by timestamp or version
   (`lastmodified >= <last migration date>`).
2. **Report.** Produce a change report. It is a list of what moved, not a set of edits.
3. **Triage each entry by type.** Most entries are not migrations:
   - **Non-content — skip.** Personal-space pages are not TCG's and do not belong in the vault
     at all; empty pages are nothing. Both were already excluded by policy at migration.
   - **A change that contradicts marked content — goes to the conflict or gap machinery.**
     Append it as evidence to the existing `gaps.md` entry, or file a new conflict stub the way
     the others were filed. **Never as an overwrite.** New values appearing in a second place
     is a data point *inside* a conflict, never the resolution of it.
   - **A new page on a topic the vault already covers — a conflict stub**, not a replacement.
   - **A stable, substantive revision of a migrated page — re-migrate**, deliberately.
4. **Re-migrate only what is stable.** A page edited minutes ago, or carrying obvious
   in-progress defects (broken heading numbering, duplicate ids, missing sections), is
   **not** re-migrated. Stamping a half-finished document `migrated: <today>` is worse than
   leaving the vault a few days stale, because the staleness is visible in the frontmatter and
   the half-finished import is not.
5. **Re-migration is the documented procedure, not a hand-edit.** Byte-faithful, split by the
   same rules if it exceeds 15 KB, with `source:`, `migrated:`, `updated:` and `status:`
   re-stamped. Editing a vault file to "catch it up" breaks the guarantee that every byte of
   a page lives in exactly one part.

### Who does what

An agent may run steps 1–3: detect drift, report it, and file it into `gaps.md` or a conflict
stub. That is recording, and recording is safe.

**Step 4–5 stay a deliberate human procedure.** Whether a page is stable enough to re-migrate
is a judgement about someone else's unfinished work, and it is not an agent's call to make.

### Recorded drift

- **2026-08-11** — six pages had changed since the migration. Triage: two personal/empty pages
  skipped; the Sprint 8 report noted against the *Sprint 7 date range* gap; lunch thresholds
  appearing on the Atom user-stories page appended as evidence to the *Lunch thresholds* gap
  (which stays **open**); a second mobilization page filed as a new conflict stub
  (`product/mob-demob-INDEX.md`). **Nothing was re-migrated** — the Atom page was mid-edit.

## Conversion notes

- Confluence tables became markdown tables. Single-cell tables used as visual banners
  were dropped, keeping their text.
- Jira smartlink macros became plain `SCRUM-###` references in the body and were
  collected into `jira:`. Saved-search (JQL) URLs were kept as plain URLs; they resolve
  only with Jira access.
- Embedded images became `> [image not migrated: ...]` lines. No dead Confluence media
  links were emitted.
- Confluence encodes empty paragraphs as a lone zero-width non-joiner (U+200C). Those
  lines were removed and runs of blank lines collapsed. This is formatting
  normalization; no wording was changed.
- `[[wikilinks]]` were added to body text in standalone files, `meetings/` and
  `domain/` — first mention per target per file, headings excluded, written as
  `[[path|displayed text]]` so the visible prose is unchanged. They mostly point at
  conflict stubs rather than at individual files, so following one lands on "here are
  the candidates and none is verified" rather than on a document that looks settled.
  Split-document parts carry no wikilinks, to preserve their byte-exact reassembly.

## Glossary — one entry, seven terms still missing

The migration produced no glossary. One entry has been added since:
`domain/fcc-nexgen-fms.md` (`status: reference`, 2026-08-11) defines **FCC** as Fleet Cost &
Care, the legacy fleet-management vendor whose NexGen desktop system and Atom mobile app this
platform replaces. It was the highest-value unknown — referenced throughout as an existing
system of record ("Customer-FCC", "need to verify from FCC if its customer contact or
seperate job site contact") with nothing saying what it was.

That entry **resolves the term and nothing else.** It records what NexGen and Atom are, not
how they behave. No spec may cite "FCC/NexGen does X" as the basis for a requirement unless
that behaviour is written down in the vault or a ticket.

Seven crane-domain terms are still used throughout as though understood and defined nowhere:
`tailboard-jsa` (13 files), `das` (12), `boom-time` (9), `craft-code` (6), `build-up` (4),
`loadout` (4), `mob-demob` (1).

An eighth, `comp-code`, exists in the domain but its only documentation was in the
personnel content excluded by policy, so it has to be sourced from a person rather than
a document. That is the first real cost of the exclusion policy showing up.

Definitions land in `domain/`, with the status matching where the definition actually came
from: `status: reference` when it came from a person or an external source and was never a
Confluence page, `status: unverified` when it was migrated from a page but nobody has
adjudicated it. Do not use `verified` for either — that is reserved for content a human
resolved against competing copies.
