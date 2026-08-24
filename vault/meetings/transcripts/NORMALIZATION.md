# Transcript normalization — 2026-08-19, extended 2026-08-24

**Pass 1+2 (2026-08-19): 257 substitutions across 40 of the 56 transcripts. Pass 3
(2026-08-24): 185 more across 42 of the now-57, targeting what the first passes deferred —
proper nouns and terms then unresolvable.** Every touched file carries `normalized: <date of the last pass that touched it>` and a
**cumulative** `normalized_substitutions: <n>`; files never touched by any pass carry neither.

## Why this exists

These transcripts were produced by automatic speech recognition (Teams, Read.ai, Fireflies) at
capture time. ASR has no crane-industry vocabulary, so it systematically mis-heard the two terms
this business is built on:

- **`craft code`** — the identifier that drives union classification, base rate and pay
  modifiers — was transcribed as **"graph code"**, "graph board", "draft code", "draft course"
  and "draft quote".
- **`crane`** was transcribed as **"train"**, **"green"**, **"grain"** and **"brain"**.

This is not cosmetic. The 2026-08-13 payroll meeting alone contained 25 instances of "graph
code" where the speakers said *craft code*, in the middle of the discussion that defines
subsistence eligibility. Any reader — human or agent — searching the vault for `craft code`
would have found nothing in the meeting that decided it.

**Consequence worth stating plainly:** the *Recordings vs. Confluence Audit* was built by
reading these transcripts in their uncorrected state. Its coverage of craft-code, JSA, lattice
and subsistence topics was therefore built on garbled source text.

## Method

Two passes, both conservative. Nothing was replaced on a guess.

**Pass 1 — unambiguous domain terms (127 substitutions).** Applied by rule, because these
strings have no other possible meaning in this corpus.

| Heard as | Corrected to | n |
| --- | --- | --- |
| graph code / graph codes / graph board | craft code / craft codes | 26 |
| draft code / draft codes / draft course / draft quotes | craft code / craft codes | 4 |
| GSA | JSA (Job Safety Analysis) | 15 |
| grain / grains | crane / cranes | 16 |
| `<N>` ton train(s), mobile train(s), train super, crawler train, and 9 further gated crane phrases | crane / cranes | 60 |
| lettuce | lattice | 4 |
| Substance / sustenance / "qualifying for residence" | subsistence | 2 |

**Pass 2 — ambiguous words, judged one at a time (130 of 174 occurrences changed).** The words
`train`, `green`, `brain` and their plurals cannot be resolved by rule: this corpus contains
both "100 ton train" (a crane) and "train them a little bit" (genuine), both "green super" (a
crane superintendent) and "the box turns green" (a genuine UI colour). Every one of the 174
remaining occurrences was read in context and decided individually against the surrounding
vocabulary — tonnage, oiler, boom, trailer, yard and dispatch indicating a crane; red/turns/
highlight/indicator indicating the literal colour.

**44 occurrences were deliberately left unchanged**: 25 `green` (status colours in the UI), 12
`train` (training, "lost my train of thought"), 7 `brain` (idiom, "brainstorm").

## What was deliberately *not* done

- **No paraphrasing, summarising or cleanup.** Filler, false starts, repetition and mis-heard
  proper nouns are all still there. Only the vocabulary substitutions above were made.
- **Speaker labels were not corrected.** Room-mic recordings mislabel Lisette, Dylan, Liz, Ryan
  and Wes as "Brian Petros", and the 03-20 Fireflies transcript has no speaker labels at all.
  Those defects are reproduced, not fixed — see the caveat in [INDEX.md](INDEX.md).
- **Other likely errors were left alone** where the correct term could not be established from
  context — e.g. "Euler" for *oiler*, "done" for *ton*, "Queen" and "planes" in equipment
  contexts. They are visible to a reader; a wrong guess would not be.

## Reproducing or reversing

The originals are the `.docx` / `.txt` files named in each transcript's `original_file:`
frontmatter field, from the OneDrive export dated 2026-08-19. Re-extracting from those and
re-applying the table above reproduces these files exactly.

---

# Pass 3 — 2026-08-24

**185 substitutions across 42 transcripts.** Same discipline: rule-applied where a string has
one possible meaning in this corpus, judged one-at-a-time otherwise, nothing replaced on a
guess. What is new is the evidence base: several corrections became decidable only by reading
the vault — the MLA classifies **Oilers**; `payroll/foreman-and-military-premiums.md` records
the Foreman **$3/hr** premium that pins "four men pay… $3 more per hour"; the account
`mohsin.ali` pins "Mohsen".

| Heard as | Corrected to | n |
| --- | --- | --- |
| ADB / ATP (all payroll/HR contexts; zero Android contexts) | ADP | 35 |
| Lizette | Lisette | 28 |
| Euler(s) | oiler(s) | 23 |
| Karina | Corrina | 16 |
| plane(s) — crane contexts | crane(s) | 15 |
| rigor / "rigorous rates" | rigger / rigger rates | 12 |
| next Gen / next gen / NextGen | NexGen | 10 |
| Queen(s) — incl. "queen guys" → **Crane Guys**, "Queen Super" → Crane Super | crane(s) | 9 |
| some Sarah / Sam Sara | Samsara | 7 |
| `<N>` done (crane) | `<N>` ton | 6 |
| four man / four mans / four men (crew-role contexts) | foreman(s) | 5 |
| toll and digging · tools and regains | tool(s) and rigging(s) | 4 |
| Mohsen | Mohsin | 4 |
| tail board | tailboard | 4 |
| Graph modifier(s) · "graph. Codes" | craft modifier(s) / craft codes | 2 |
| DSA tailboard | JSA tailboard | 1 |
| Estahem · Michaela · substance · quick book | Ehtesham · Micaela · subsistence · QuickBooks | 4 |

## Deliberately left unchanged, and why

- **Speaker labels — a principle pass 1 implied, stated plainly now:** labels are Teams
  account display names, not ASR output. ASR corrupts only speech. A label is never
  "mis-transcribed" and is never corrected, whatever it says.
- **`Umer` / `umer.islam` (63):** a real, distinct person — not Umair. The 04-21 transcript
  itself distinguishes them ("Oh, it's Umer… Umair, Umair, Umair").
- **`David Bacon` (2, 08-06):** the *speaker* misspoke and said so ("I think I'm getting it
  wrong, but David something"). Faithful transcription of a misspeak is not an ASR error.
- **`Daily Graph` (4):** a real FCC NexGen screen name, not a craft-code corruption.
- **"graph browser" (08-13):** genuine — the surrounding sentence is about connected data.
- **One `plane` (05-21):** "screen shares are on a different plane" — genuine.
- **Still unresolvable, visible to readers:** "frogs and trailers" / "this frog or plane"
  (frog ≈ truck?), "300 time frames" (≈ 300-ton cranes?), "crawler cranes and refrains",
  "Jazeb"/"Tanzi" (nicknames for Jahanzaib?), "you have got for more moderates" (≈ four more
  modifiers?), "this patch" (≈ dispatch?). A wrong guess would be invisible; these are not.

## Reproducing

Original files per `original_file:` frontmatter → apply the pass-1/2 tables above → apply
this table. Frontmatter `normalized_substitutions` is cumulative across passes.
