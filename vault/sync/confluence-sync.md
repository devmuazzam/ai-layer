# Confluence → vault sync — v1 production specification

Status: **specification for review. Not implemented. No pipeline code exists.**

Home: `.ai/vault/sync/confluence-sync.md`. This is **vault infrastructure**, not an AI-DLC
loop step, which is why it lives under `vault/` and not under `aidlc/`.

---

## 0. Provenance of this document

Stated plainly because the rest of this spec is about not laundering sources.

**No prior `confluence-sync.md` was found.** `.ai/aidlc/confluence-sync.md` does not exist,
and a search of `.ai/` for any `*sync*.md` returned nothing. This is therefore a **first
write, not a rewrite**, and no section below is quoted or carried forward from an earlier
design document — there was none to carry.

Three design elements were supplied as already-settled and are adopted as given, not
re-derived: **content-hash detection over last-modified** (§3), **three-tier trust staging**
(§4), and **conflict changes routed to `.conflict`, never auto-written** (§4.3). Where this
document adds reasoning to those, the reasoning is new and marked.

The one genuinely pre-existing source it builds on is real and citable:
`.ai/vault/README.md` → *How the vault stays in step with Confluence*, which states the
governing principle and the five-step loop this spec makes buildable.

---

## 1. Framing — what changed from the earlier posture

The earlier posture was proof-of-concept: a human runs a check occasionally, eyeballs the
output, and decides. **v1 is not that.** It runs on a schedule, unattended, and real
developers consume the vault it maintains.

That does not loosen the discipline. It **tightens** it, for one reason: an unattended
process that writes is an unattended process that can be wrong at 3am with nobody reading the
output. Every requirement in §5 exists because automation removes the human who would
otherwise have caught it.

The governing principle is unchanged and is restated here because it decides every specific
case below:

> **Sync is detect-and-triage, never auto-absorb.** A Confluence page changing is a signal to
> *review*, not a trigger to *overwrite*. — `README.md` → *How the vault stays in step with
> Confluence*

And its corollary, already binding on the agents that read this vault and equally binding on
the process that maintains it: **recency is not authority.** A page edited today does not
outrank content a human adjudicated. The sync must never encode "newer wins".

---

## 2. What the sync is responsible for

| | |
| --- | --- |
| **Reads** | Confluence Cloud, space `TCG`, via the Atlassian API (read-only scopes) |
| **Writes** | `.ai/vault/sync/**` **only** — manifest, run reports, staging queue, `.conflict` |
| **Never writes** | `vault/product/`, `vault/domain/`, `vault/meetings/`, `vault/decisions/`, `vault/INDEX.md`, `vault/README.md`, `vault/gaps.md`, `vault/payroll/gaps.md` |
| **Cadence** | **Nightly** (decided 2026-08-11; see §10) |
| **Owner of the promote step** | `<OPEN — review-and-promote queue owner not named; see §10>` |

**The write-scope restriction is the enforcement mechanism, not a guideline.** This session's
standing finding is that a rule nothing mechanically enforces is not a rail. So the rule "the
sync never writes vault content" is implemented as *the runner has no write path to vault
content*, not as an instruction in a document. If the runner is ever given broader write
access, every guarantee in §8 lapses.

---

## 3. Detection — content hash, not last-modified

**Adopted as given.** Rationale recorded so it is not re-litigated:

- `lastModified` and `version` both increment on changes that alter no content — a label
  added, the page moved in the tree, an inline comment resolved, a restack. Acting on those
  produces churn in the review queue, and a queue that cries wolf stops being read.
- They can also fail to move in the other direction under API-driven edits.
- A content hash answers the only question that matters: *did the bytes we migrated change?*

### 3.1 What is hashed

The hash is taken over the **converted markdown body**, after the documented conversion
normalizations (`README.md` → *Conversion notes*: U+200C removal, blank-line collapsing,
table conversion, image and smartlink handling) and **excluding vault frontmatter**.

This matters: hashing the raw Confluence storage format would make every whitespace-level
editor artefact a change. Hashing post-normalization means the hash tracks *what a reader
would see a difference in*.

Algorithm: SHA-256 over UTF-8, hex-encoded. Recorded as `sha256:<hex>`.

### 3.2 The manifest

`vault/sync/manifest.json` — the sync's only persistent state. One record per tracked page:

```json
{
  "pageId": "95158273",
  "spaceKey": "TCG",
  "title": "Atom Mobile Application ( User stories )",
  "vaultPaths": ["product/atom-mobile-app-user-stories/INDEX.md", "..."],
  "contentHash": "sha256:…",
  "confluenceVersion": 14,
  "lastSeenAt": "2026-08-11T14:00:00Z",
  "lastPromotedAt": "2026-08-10T00:00:00Z",
  "trustAtPromote": "unverified",
  "heldRuns": 0,
  "sourceState": "present"
}
```

`vaultPaths` is a list because split documents map one page to many files
(`product/field-ops-frd/` is twelve). `trustAtPromote` records the `status:` the vault file
carried when these bytes were promoted — §5.1 depends on it.

**The manifest is not a cache and must not be treated as one.** Deleting it does not force a
resync; it destroys the record of which bytes were reviewed, which is the input to
verified-demotion. Back it up with the vault.

### 3.3 Discovery of untracked pages

Pages in `TCG` with no manifest record are **new**. They are reported, and routed by §4.3 if
they touch a topic the vault already covers. They are never auto-added — a new page on a
covered topic is a candidate conflict, and that judgement is the promote step's.

---

## 4. Three-tier trust staging

**Adopted as given.** The tier is determined by **the trust status and conflict state of the
vault target**, never by the size or recency of the upstream change.

Two gates run **before** tiering, and a page caught by either is not tiered at all:

- **§5.3 IN-FLIGHT HOLD** — held entirely, nothing staged.
- **§5.2 STALE-SOURCE** — the page is gone or renamed; nothing staged.

### 4.1 Tier CLEAN

Target file is `status: unverified`, has empty `conflicts_with`, and the page passed both
gates.

→ Staged to `vault/sync/queue/<run-id>/` with a diff. Awaits promote.

### 4.2 Tier WARN

Any of:

- Target file is `status: verified` → **triggers §5.1 demotion**. Always WARN, never CLEAN,
  regardless of how small the change is.
- The change removes more than 25% of the file's lines, or removes a whole heading section.
  (Threshold is a spec decision, tunable; the intent is "content disappeared upstream", which
  is the case most likely to be an accident.)
- The page's structure changed shape — headings renumbered, sections reordered — such that a
  split document's part boundaries no longer line up.

→ Staged, flagged, and the promote step must acknowledge the warning explicitly rather than
bulk-approving.

### 4.3 Tier CONFLICT — routed to `.conflict`, never auto-written

**Adopted as given.** Any of:

- Target file has non-empty `conflicts_with`.
- The page is new and covers a topic that already has a conflict stub or a vault file.
- Two Confluence pages now hash-differently but map to overlapping `vaultPaths`.

→ Written to `vault/sync/.conflict/<run-id>/`, **never** to the staging queue, and never
proposed as a vault write. The output is a *report* naming both sides, sized and dated, in the
shape `gaps.md` entries use — because the correct destination for a conflict is the gap
machinery, not a file edit.

**No tier ever resolves a conflict.** See §7.

### 4.4 `status: reference` files are outside the sync entirely

A `reference` file (e.g. `domain/fcc-nexgen-fms.md`) has no `confluence/` source — its
`source:` names a person or an external URL. It has **no manifest record**, is never hashed,
and cannot drift, because there is nothing upstream to drift from.

The sync must not create manifest records for them, and must not report their absence from
Confluence as `stale-source`.

---

## 5. v1 requirements

### 5.1 VERIFIED-DEMOTION — load-bearing

> **Any content-hash change to a file tagged `status: verified` demotes that file to
> `status: unverified` and raises WARN.**

Stated without qualification, because every qualification is a loophole:

- **No size threshold.** A one-character upstream typo fix demotes. There is no "trivial
  change" exemption.
- **No author exemption.** It does not matter who edited it.
- **No re-verification.** The sync never restores `verified`. That requires a human running
  the gap-closing procedure (`README.md` → *How a gap gets closed*). See §7.

**The reasoning, which is the rule:** `verified` means *a human adjudicated these bytes
against their competing copies and this copy won*. It attaches to the reviewed bytes, never to
the filename. A new revision has not been reviewed. Letting `verified` survive an upstream
edit means the vault asserts human adjudication of content no human has seen — which is the
single most damaging thing this vault could do, because `verified` is the one signal agents
are told to trust plainly (`tcg-scrum.md` §3, `tcg-elaborator.md` §4).

**Frontmatter transformation applied at promote:**

```yaml
status: unverified
demoted_from: verified
demoted_on: 2026-08-11
demotion_note: "was verified before the 2026-08-11 upstream edit; these bytes have not been reviewed"
# verified_because: REMOVED — it points at a decision note that adjudicated different bytes
```

Removing `verified_because` is not optional. Leaving it makes the file look adjudicated while
claiming not to be.

**Blast radius today:** the six `domain/` SOP files are the only `verified` content in the
vault. A single upstream edit to any one of them takes the vault's verified count to five.
That is the correct outcome and should not be softened; it is also why the promote queue owner
(§10) needs to be someone who will notice.

#### 5.1.1 Re-verification is not a queue action

The rule above leaks if restoring `verified` is one click, because the path of least
resistance then re-verifies without re-reading — and the demotion becomes a speed bump rather
than a control.

- **Promote never restores `verified`.** Clearing a WARN promotes the file as `unverified`.
  There is no promote-time control that sets `verified`, and the promote tooling must not
  offer one.
- **Restoring `verified` is a separate, later act**, done through the gap-closing procedure
  (`README.md` → *How a gap gets closed*): a dated note in `decisions/` stating what was read
  and why this copy wins. Re-confirming means **reading the changed bytes**, not dismissing a
  warning.
- **And it is enforced by the hash, not by diligence.** A file returning to `verified` must
  record the hash that was actually reviewed:

  ```yaml
  status: verified
  verified_because: decisions/2026-09-01-jira-sop.md
  verified_hash: sha256:…          # the bytes a human read
  ```

  §5.1 then demotes on `currentHash != verified_hash` — exact, and mechanical. `verified`
  attaches to reviewed bytes by construction rather than by anyone remembering to.

**A file carrying `status: verified` with no `verified_hash` is treated as stale and demoted
on the next run.** This clause is what makes the rule airtight rather than merely correct.
Without it, the rule would govern only files verified *after* it existed, and everything
verified before — today, the entire `domain/` SOP set — would carry `verified` with nothing
underneath it and coast indefinitely. Treating a missing hash as stale sweeps those in too.

**Hard precondition on the promote tooling — not a note:**

> The promote step **must refuse to write `status: verified` unless a `verified_hash` is
> written with it, in the same operation.** Not a warning, not a lint: a refusal that fails
> the promote.

The reason it is a precondition rather than a convention is the failure it prevents. If a file
ever reaches `verified` without a hash, the demotion check has nothing to compare against and
**silently passes that file forever** — the paper-only failure wearing a green check, which is
strictly worse than an unverified file, because an unverified file tells the truth. Enforcing
it in the tooling also means a well-meaning hand-edit cannot reintroduce the leak later, which
a documented convention cannot prevent.

### 5.2 DELETIONS AND RENAMES — mark stale, never delete

A vaulted page whose Confluence source disappears or is retitled is marked **`stale-source`**.
**Stage nothing. Never silent-delete. Never rewrite the vault filename.**

**Rename vs. delete+create — the discrimination rule.** Confluence `pageId` is stable across a
title change. So:

| Observation | Classification | Action |
| --- | --- | --- |
| `pageId` resolves, `title` differs from manifest | **Rename** | `sourceState: renamed`. Stage a `source:` frontmatter correction *only* — no body change. Vault filename unchanged. |
| `pageId` returns 404 / `trashed` / `deleted` | **Source gone** | `sourceState: missing`. Report. Stage nothing. |
| `pageId` 404s **and** a new untracked page's content hash equals the vanished page's last known hash | **Delete-and-recreate** — treat as rename | `sourceState: recreated`, new `pageId` recorded, `source:` correction staged. |
| `pageId` 404s and no hash match exists | **Genuine deletion** | `sourceState: missing`. Report and escalate. |

**Why the vault filename does not follow a rename:** vault filenames are kebab-case topic
names by convention (`README.md` → *Filenames*), deliberately decoupled from Confluence
titles. Propagating a rename would break every `conflicts_with`, `part_of`, wikilink and
`gaps.md` citation pointing at the old path — the exact breakage the vault-root-relative path
rule exists to prevent.

**Why deletion never propagates:** a vault file whose source vanished is still the only record
that the content existed. Deleting it destroys evidence and silently changes what agents can
cite, with no trace. `stale-source` keeps it readable and marks it untrustworthy — the same
logic as `superseded` in `README.md` → *How a gap gets closed* step 3.

### 5.3 IN-FLIGHT HOLD — held entirely, not staged as WARN

A page that looks mid-edit is **HELD**. It is reported and **not staged at any tier**.

**Signals. Any one triggers HOLD:**

| # | Signal | Threshold |
| --- | --- | --- |
| H1 | Confluence reports an **unpublished draft** for the page | any |
| H2 | **Recency window** — `lastModified` within *N* of run start | **N = 30 minutes** (spec decision; tunable) |
| H3 | **Structural-defect heuristic** — duplicate heading text at the same level, or a gap/repeat in an ordered section sequence | any hit |

**On H2's threshold, honestly:** 30 minutes is a heuristic and it does not catch a slow
editor who pauses for an hour. That is exactly why H3 exists — the real-world case that
motivated this requirement was caught by structure, not by clock. The 2026-08-11 Atom page had
been edited 6 minutes prior (H2 would have caught it) *and* carried two sections numbered
`US-11`, an epic titled `PIC 10`, epics 5–9 absent and `US-12` missing (H3 would have caught
it independently). Neither signal alone is sufficient; both are cheap.

**H3 may be overridden** at the promote step, because it is heuristic and some documents are
legitimately irregular. H1 and H2 may not be overridden — they resolve themselves by waiting.

**Held pages retry on the next run.** `heldRuns` increments. At **`heldRuns >= 3`** the report
escalates it: a page that has been mid-edit across three runs is not mid-edit, it is a
document someone needs to talk to the author about.

**Why HOLD and not WARN:** a WARN still puts proposed content in the queue, and content in a
queue gets promoted. Stamping a half-finished document `migrated: <today>` is worse than
leaving the vault a few days stale, because staleness is visible in the frontmatter and a
half-finished import is not.

### 5.4 HUMAN REVIEW AND PROMOTE — nothing reaches the vault without it

Staged changes land in a review queue. A **named owner** promotes them. There is no auto-merge
path, no "low-risk" fast path, and no time-based auto-approval.

**Queue layout:**

```
vault/sync/
├── manifest.json
├── runs/<run-id>/report.md          # the change report — what moved, per §6
├── queue/<run-id>/<page-slug>/
│   ├── proposed/                    # converted markdown, split per the documented rules
│   ├── diff.patch                   # against current vault content
│   └── decision.md                  # tier, signals fired, frontmatter deltas promote will apply
└── .conflict/<run-id>/              # §4.3 output — reports, never proposed writes
```

**Promote is the documented procedure, not a hand-edit.** It re-runs the byte-faithful split
if the page exceeds 15 KB, and re-stamps `source:`, `migrated:`, `updated:` and `status:` —
plus §5.1's demotion fields where they apply. Hand-editing a vault file to "catch it up"
breaks the guarantee that every byte of a page lives in exactly one part, which is the
guarantee `product/atom-mobile-app-user-stories/INDEX.md` makes to its readers.

**Promote is a human step by design, per `README.md`:** an agent may run detect / report /
file. Whether a page is stable enough to promote is a judgement about someone else's
unfinished work, and that is not an agent's call.

### 5.5 STAGED CONTENT MUST NOT BE RETRIEVABLE AS VAULT CONTENT

*This requirement is not one of the four supplied. It is a hazard introduced by putting the
staging queue inside `vault/`, and it is listed so the choice is made deliberately.*

`vault/sync/` sits inside the directory agents retrieve from. Without a guard, an agent
answering a product question could grep the vault, hit a **staged, unpromoted** file, and cite
it as vault content — which would defeat every gate above in one step.

v1 must therefore:

1. Give every staged file frontmatter `status: staged` and a first-line banner:
   `> STAGED — NOT VAULT CONTENT. Do not cite. Awaiting promote.`
2. Exclude `vault/sync/**` from the retrieval order documented in `INDEX.md`,
   `tcg-scrum.md` §1 and `tcg-elaborator.md` §2 — which means those three files need one line
   each at promote time.
3. Exclude `vault/sync/**` from the Obsidian vault view, so a human browsing does not hit
   staged content either.

**Alternative, if this is judged too fragile:** move the queue to `.ai/sync/` — outside the
vault entirely — and keep only the manifest under `vault/`. That trades a slightly worse
locality story for a hazard that cannot occur. **Recommended if the exclusions in (2) cannot
be mechanically enforced**, on this session's standing rule that an unenforced convention is
not a rail.

---

## 6. The change report

Every run emits `vault/sync/runs/<run-id>/report.md`, whether or not anything changed. A run
that reports nothing is evidence the runner ran; a missing report is evidence it did not.

Per entry: page id, title, space, vault path(s), outcome
(`CLEAN | WARN | CONFLICT | HELD | STALE-SOURCE | UNCHANGED | NEW`), the signals that fired,
and a one-line human-readable reason.

The report ends with a triage summary counting each outcome, and — for HELD entries — the
`heldRuns` value, so a stuck page is visible without reading the whole file.

---

## 7. Non-goals — v2 or never, not v1

Stated as a section so nobody reaches for them under deadline.

1. **No auto-conflict-resolution.** The sync never picks a winner between competing sources,
   never merges them, and never orders them by recency, size, or version number. Merging is
   the worst available option: two documents describing the same thing differently do not
   average into a third, they produce a specification neither contains, that nobody wrote and
   nobody can be asked about. Conflicts go to `.conflict` and from there to `gaps.md`.
2. **No write-back to Confluence.** The relationship is read-only from our side. The sync
   holds read scopes only, and acquiring write scopes is a scope change requiring its own
   review. The vault is downstream of Confluence and must stay downstream — a bidirectional
   sync is a materially larger piece of engineering and is not needed.
3. **No automated re-verification.** Nothing in the pipeline may set `status: verified`, and
   nothing may clear a `demoted_from` field. Verification is a human adjudication recorded in
   `decisions/`, per `README.md` → *How a gap gets closed*. §5.1 is one-directional by
   construction.

---

## 8. Scope — guarantees and non-guarantees

**v1 makes the vault CURRENT. It does not make it AUTHORITATIVE.** Those are different
properties and conflating them is the failure mode this section exists to prevent.

**Guarantees, within one run of the cadence — nightly, so within 24 hours:**

- Every tracked page's change state is known and reported.
- No Confluence change silently overwrites vault content — every write passes a human promote.
- No vault file is deleted or renamed by the sync.
- `verified` content cannot silently survive an upstream edit (§5.1).
- A mid-edit page is not imported (§5.3).
- A conflict is never resolved by machine (§7.1).

**Does not guarantee:**

- **Authority.** The vault's own figure is that **145 of 151 content files are
  `status: unverified`** — migrated faithfully, never adjudicated. *(That figure is the
  vault's, and is itself now stale: two files were added 2026-08-11. Recount at first
  promote.)* Sync does not change it. A file that is perfectly current and unverified is still
  unverified.
- **Conflict resolution.** Thirteen `gaps.md` entries are open and stay open. Sync can add to
  them; only product can close them.
- **Completeness.** Coverage is tracked pages plus new-page discovery in space `TCG`. Content
  excluded by policy (`README.md` → *What this vault does not contain*) stays excluded, and
  sync must not quietly re-import it.
- **Correctness of upstream.** A page can be current, promoted, and wrong.

> **"Synced" is not "trustworthy."** Current means the vault reflects Confluence. Trustworthy
> would mean someone checked whether Confluence is right. Only the second one lets an agent
> answer plainly, and v1 does not deliver it.

---

## 9. Future connection — drift detection and the reflector

Drift detection is eventually the **reflector's** concern: the agent that notices "the vault
has drifted from source" and files it, rather than a human reading a report.

Reference path for when it exists: `agents/reflection/tcg-reflector.md`.

**This is a FUTURE connection, not a live dependency.** The reflector is unbuilt — that path
does not exist on disk today, and nothing in v1 may require it. v1 emits a report a human
reads (§6). If the reflector later consumes the same report, that is an addition to v1, not a
change to it.

Note for whoever builds it: even with a reflector, **promote stays human** (§5.4). The
reflector would take over detect/report/file — steps 1–3 of the README loop — and stop there.

---

## 10. Open decisions — not invented here

These are decisions this spec must not make for itself. One is closed; one is not, and they
were never equal in weight.

| Decision | Status | Notes |
| --- | --- | --- |
| **Runner cadence / trigger** | **CLOSED — nightly**, decided 2026-08-11 | See §10.1 |
| **Review-and-promote queue owner** | **`<OPEN>`** | See §10.2. **This is the one that decides whether the system works.** |

### 10.1 Cadence — nightly (closed)

Nightly is the safe default for a first version. Drift caught within a day is well inside
tolerance for a vault that was a static snapshot until now, and the loop can be tightened
later — starting slow costs nothing.

It also helps §5.3: a slower loop gives the in-flight hold room to let mid-edit pages settle
before a run ever sees them. This removes the interaction a fast cadence would have created,
where a cadence shorter than the 30-minute recency window re-holds the same pages every run.

Consequence for §8: the staleness bound the guarantees are stated against is **24 hours**.

### 10.2 Promote owner — open, and not a config value

**This is a people question, not a setting, and the spec will not guess it.**

Every trust decision in this design routes to a human (§5.4, §7.3, §5.1.1). That is the
correct design *only if the human exists and has the time*. If the owner is unnamed, or named
but unavailable, the staging queue grows and the vault falls behind **while continuing to look
maintained** — a green pipeline, a tidy queue, and content nobody promoted. That failure is
quieter and worse than having no sync at all, because no sync at least leaves the staleness
visible in the frontmatter.

So the honest statement of the dependency: **the production deadline is a deadline on that
person existing, not on the code.** Steps 1–4 of §12 can ship without them. Step 8 cannot, and
should not be built until the name is real.

Requirements on the answer: a **named individual**, not a rota and not a team alias; with
stated time for it; and a **named fallback held to the same standard as the primary**.

The fallback is not a lesser field. A nightly runner produces a queue on a schedule whether or
not anyone is watching, so "the owner is away" is not an edge case — it is a certainty on a
long enough timeline. A fallback that is a name rather than a real second commitment of time
does not remove the silent-staleness failure described above, it relocates it to whenever the
primary takes leave. Same standard, applied twice.

---

## 11. Loose ends folded in

Both were on record as outstanding. **Both are already closed** — verified 2026-08-11, cited
here so they are not re-opened as work.

1. **`status: reference` admitted to the trust vocabulary.** Done. `README.md:45` now reads
   `status: verified | unverified | superseded | reference`, and `README.md:104-115` documents
   what it means and why the other three did not fit — they are a *migration-confidence* axis,
   and that question does not apply to a file that was never a Confluence page. **What this
   spec adds is the sync behaviour**, which was not previously stated: §4.4 — `reference`
   files have no manifest record, are never hashed, and are never reported as `stale-source`.
2. **`INDEX.md` stale glossary lines.** Already corrected 2026-08-11: `INDEX.md:24` now points
   at `domain/fcc-nexgen-fms.md`, and `INDEX.md:202-206` was rewritten from *"there is no
   glossary"* to *"the glossary has one entry"* with the remaining seven undefined terms
   listed. No promote-time action needed.

   **The real remaining staleness is counts, not glossary lines.** `INDEX.md:3` says 153 files
   and `tcg-scrum.md:60` says 154; the two already disagreed and both are now short by the two
   files added 2026-08-11. Every promote changes file counts, so the promote procedure should
   recount rather than carry a hardcoded number. Recorded here; not fixed in this run.

---

## 12. Build order

First through last. Each step is independently testable against the previous one.

1. **Read-only API client + space enumeration.** Fetch page list and bodies for `TCG`. No
   state, no writes. Verifies scopes and pagination.
2. **Converter + normalizer.** Confluence storage format → markdown, applying the documented
   conversion rules. This is the piece the hash depends on, so it must be settled before
   hashing means anything.
3. **Hashing + manifest.** Build `manifest.json` from the current vault by back-hashing
   already-migrated content. **This is the bootstrap step and the riskiest one** — if the
   converter is not byte-stable against the 2026-08-10 migration, every page reports as
   changed on run one. Expect to iterate between steps 2 and 3.
4. **Detection + change report (§3, §6).** Read-only end to end: detect and report, stage
   nothing. **Ship this and run it for a while before building step 5.** It is useful alone,
   and it is how the false-positive rate gets measured.
5. **Gates: IN-FLIGHT HOLD (§5.3) and STALE-SOURCE (§5.2).** Before tiering, because both
   pre-empt it.
6. **Tiering + staging (§4), including `.conflict` routing.** Writes only under
   `vault/sync/`.
7. **Staged-content guard (§5.5).** Must land with step 6, not after — the hazard exists the
   moment staged files appear inside `vault/`.
8. **Promote tooling (§5.4)**, including the §5.1 demotion transformation **and §5.1.1's hard
   refusal to write `verified` without a `verified_hash`**. The last step, and the only one
   that writes vault content. Blocked on §10.2.

Steps 1–4 are the useful half and carry almost no risk. **A working step 4 with no step 6 is a
legitimate stopping point** if the two §10 decisions stall.

---

## 13. Deliberately left out of v1

Recorded so the omissions are visible rather than discovered.

- **Attachments and images.** The migration emitted `> [image not migrated: ...]` lines. Sync
  detects no change to images and will not notice a diagram being replaced. Real gap; larger
  than it sounds.
- **Comments and inline comments.** Not tracked. Confluence comments sometimes carry the
  decision the page lacks, which is precisely the content `gaps.md` is short of.
- **Spaces other than `TCG`.** One page was migrated from a personal space
  (`product/user-story-and-tasks.md`); it will report as untracked or stale-source depending
  on that space's visibility. Needs a manifest exception, not a policy change.
- **Jira sync.** Out of scope entirely. Tickets are read live by the agents; the vault does
  not mirror them.
- **Page-tree / hierarchy changes.** A page moving under a different parent is invisible to a
  content hash. Probably fine; noted because "probably" is doing work.
- **Automated recount of `INDEX.md` figures** (§11.2). Manual at promote for now.
- **Multi-page atomic changes.** An author editing four pages of one FRD in sequence produces
  four independent staged items with no notion that they are one change. The promote step will
  see them as unrelated.
- **Rollback.** No mechanism to un-promote. Recovery is git revert on the vault, which is
  adequate but undocumented.
