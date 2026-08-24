---
run: 2026-08-24-bootstrap
tier: CONFLICT
reason: untracked pages duplicating vault-covered topics (§4.3) + verified files with no verified_hash (§5.1.1)
staged: 2026-08-24
---

# The six verified SOPs exist in three Confluence spaces — and none carries a `verified_hash`

The vault's only `status: verified` content is the six `domain/` SOPs, sourced from space
**TPD**. This run found the same documents living in **three places**:

| Document | TPD (vault source) | TCG space copy | Personal space copy (Umair Khan) |
| --- | --- | --- | --- |
| Development Process SOP | 2228227 · Feb 04 | — | 26378248 · **Apr 16** |
| Jira SOP | 2293762 · Feb 04 | 31752199 · **Apr 23** | 26738689 · **Apr 16** |
| Sprint Closing | 2392065 · Feb 04 | 31817730 · **Apr 23** | 26640385 · **Apr 16** |
| Daily Scrum | 1540100 · Feb 04 | 31391750 · **Apr 23** | 26509313 · **Apr 16** |
| Backlog Grooming | 2097153 · Feb 04 | 31031298 · **Apr 23** | 26378241 · **Apr 16** |
| Sprint Planning | 1933313 · Feb 04 | 31326210 · **Apr 23** | 26116099 · **Apr 16** |

All dates 2026. Every copy in the two non-TPD spaces was modified **after** the TPD
original. Whether the copies differ in content has not been checked — first-paragraph
summaries are identical, which proves nothing about the rest.

## Why this matters more than an ordinary duplicate

`verified` means a human adjudicated these bytes and this copy won. If the Apr 16/23 copies
contain edits the TPD originals lack, the vault is verified against the *stalest* of three
copies — and nothing would ever report it, because the sync tracks only TPD.

## The §5.1.1 problem, flagged for the promote owner

All six vault files carry `status: verified` with **no `verified_hash`**. The spec is
explicit: *"A file carrying `status: verified` with no `verified_hash` is treated as stale
and demoted on the next run."* This bootstrap did not demote — the sync has no write path to
`domain/` (§2) and demotion is a promote-step act. Two facts make repair cheap right now:

- TPD pages are unmodified since Feb 04, months before migration — so **current vault bytes
  are the adjudicated bytes**. Minting `verified_hash` today (gap-closing procedure, dated
  decision note) is honest; after any upstream edit it no longer would be.
- `sync/manifest.json` now records the content hash of each SOP's vault body
  (`hashBasis: vault-body-bootstrap`).

## Suggested disposition (human decisions, in order)

1. Adjudicate the canonical home; TPD is the presumptive answer (vault sources it; the vault
   README's conversion notes were written against it).
2. Diff the three copies of each; fold real differences into TPD or discard them, then
   archive the TCG-space and personal-space copies upstream.
3. Run the gap-closing procedure once for all six: decision note + `verified_hash`.
