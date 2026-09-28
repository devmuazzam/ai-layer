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

---

# Pass 4 — 2026-08-27 (two new transcripts only)

Applied to the two files added 2026-08-27; no earlier file was touched.

| File | Heard as | Corrected to | n |
| --- | --- | --- | --- |
| 2026-08-26-erp-sprint-review.md | ADB file (payroll context) | ADP file | 1 |
| 2026-08-26-erp-sprint-review.md | graph code(s) | craft code(s) | 2 |
| 2026-08-26-erp-sprint-review.md | graph board · draft board(s) (same sentence as "craft boards") | craft board(s) | 3 |
| 2026-08-25-accounting-process.md | — | — | 0 |

Left unchanged, visible to readers: "prompt code", "graph quarters", "Leiann" (08-26, 36:15).

---

# Pass 5 — 2026-09-07 (one new transcript only)

Applied to `2026-09-03-payroll-lunch-rules-and-dispatch-times.md`; no earlier file was touched.
16 substitutions, judged in context: "ERB" -> "ERP" (4); "page straight through" -> "paid straight through" (4); "the launch" -> "the lunch" (2); "every train" -> "every crane" (1); "graph ports" -> "craft codes" (1); "graph quotes" -> "craft codes" (1); "SCC" -> "FCC" (1); "Cal, correct me" -> "Kyle, correct me" (1); "bot rate updates" -> "bulk rate updates" (1). "paid straight through" is the term Brian
Petros uses in the same passage Corrina's lines were heard as "page straight through"; "every
train" sits between "build up a crane" and "the buildup for every crane"; "graph ports/quotes"
both occur inside the craft-code bulk-rate discussion; "Cal, correct me" addresses Kyle Harlow,
who answers. Left unchanged: the items listed in the file's own header note.

---

# Pass 6 — 2026-09-17 (two new transcripts only)

Applied to `2026-09-15-erp-live-demo-01.md` and `2026-09-16-resource-types-and-billing-codes.md`;
no earlier file was touched. (The 2026-09-10 file's 23 substitutions are listed in its own header
note and were not logged here as a pass.)

| File | n |
| --- | --- |
| `2026-09-15-erp-live-demo-01.md` | 76 |
| `2026-09-16-resource-types-and-billing-codes.md` | 35 |

**2026-09-15 — 76, judged in context:** "graph code(s)" -> "craft code(s)" (9); "graph board(s)" -> "craft code(s)" (3);
"draft codes" -> "craft codes" (2); "graph based" -> "craft based" (3 — the *Craft-Based Hourly*
compensation type); "graph modifier(s)" / "prop modifiers" -> "craft modifier(s)" (4 + 1);
"train(s)" / "frame(s)" / "green(s)" -> "crane(s)" (9); "the green guys" -> "The Crane Guys" (1);
"turn" / "done" -> "ton" (2); "whiler" / "Eiler" / "Euler" / "boiler" / "order" -> "oiler" (6);
"crop" / "props" / "drug(s)" -> "truck(s)" (6); "Samantha" / "Sam Sarah" -> "Samsara" (3 + 2);
"left plan" / "left line" -> "lift plan" (5); "side line" -> "site plan" (1); "DL allocation" ->
"daily allocation" (1); "A to B file number" -> "ADP file number" (1); "Taylor" -> "trailer" (1);
"operator Rd." -> "operator load" (1); "billing quotes" -> "billing codes" (2); "quoted 2" ->
"quoted to" (1); "FA permit" -> "FAA permit" (1); "send code for approval" -> "send quote for
approval" (1); "status to one" / "mark as one" -> "won" (2); "pre-label form" -> "pre-labor form"
(1); "tools and rankings" -> "tools and riggings" (1); "notation" -> "quotation" (1); "DocuSane" /
"send via document" -> "DocuSign" (2); "snack" -> "snag" (1); "intra" -> "Entra" (1); "FCC
logging" -> "FCC login" (1). New evidence rule used here: **"crop / props / drug" -> truck** is
pinned by the same speaker's *"operator load is going to have operator and the truck"* (30:24) and
the Samsara vehicle-ID reply (29:48); it does **not** license "frog" elsewhere, which stays
unresolved.

**2026-09-16 — 35, judged in context:** "Maine"/"mean" -> "Main" (4; the FCC Main tab);
"coding stage" -> "quoting stage" (1); "done"/"turn" -> "ton" (4);
"trains"/"train"/"grain(s)"/"screen"/"cream"/"queen" -> "crane(s)" (11); "9010" -> "90 ton" (2);
"Laufer"/"lover"/"loffer" -> "luffer" (6); "mode" -> "mob" (2); "MobDMob" -> "mob/demob" (1);
"debop" -> "demob" (1); "demo" -> "demob" (3). "luffer" is pinned by FCC resource type 76, *360 Ton
All Terrain w/Luffer* (`assets/fcc-units-and-schedule-types.md` §6); "9010" by the speaker's own
"I see two 90s"; "screen" occurs only as "mobile screen"/"crawler screen" in a question about crane
types; "demo" -> "demob" only inside the demobilization block (23:52) — "demos" (16:19, meaning
walkthroughs) is unchanged; "mean" -> "main" only where it names the tab (3:54, 12:21), not in "can
one thing mean" (4:21).

Both source .docx files carried in-turn line breaks as U+2028; they were rendered as newlines
(layout only). Left unchanged: the items listed in each file's own header note, including "350 time
frame", the same pattern pass 3 left unresolved.

---

# Pass 7 — 2026-09-24 (one new transcript only)

Applied to `2026-09-22-erp-live-demo-02.md`; no earlier file was touched. **56 substitutions**, each
applied to a named line and judged in context, never by blanket rule. The full breakdown, with the
timestamps that pin each one, is in that file's header note. In summary: "one" -> "won" (5); "view" -> "PO" (3);
"train"/"plane" -> "crane" (4); "leave your / live year / leave year time" -> "leave yard time" (4)
and "onset" -> "onsite" (1); "side plan" -> "site plan" (1); "task" -> "DAS" (6); "Euler" -> "oiler"
(3); "market holdover" -> "mark it holdover" (2); "their locations" / "a location" -> "the
allocations" / "allocation" (3); "graph code(s)" -> "craft code(s)" (6); "graph boards" / "draft
board" -> "craft codes" / "craft code" (2); "operate load" -> "operator load" (1); "tools and
rankings" -> "tools and rigging" (2); "leaf" -> "leave" (1); "Samsung" / "Sam Sarah" -> "Samsara"
(2); "1910 print" -> "190 ton crane" (1); "frames" / "clean" / "screens" / "green(s)" / "print" /
"queen" -> "crane(s)" (7); "share" / "shirts" -> "shift(s)" (2).

New evidence rules used here: **"task" -> DAS** only where the sentence names the daily allocation
system or a DAS screen in the same turn. It does not license "task" elsewhere. **"view" -> PO** only
inside a purchase-order sentence. **"Piazza" is not an error**: it is an outside-trucking vendor
(`vendors-agencies/outside-trucking-piazza-invoice-sop.md`). Speaker labels are reproduced
uncorrected. Lisette Anzaldo speaks on Brian Petros's room microphone throughout, and the file
header lists her probable turns. Left unchanged: the items listed in the file's own header note.

---

# Pass 8 — 2026-09-28 (one new transcript only)

Applied to `2026-09-28-adp-integration-sync.md`; no earlier file was touched. **49 substitutions**, each
judged in its own line. The full breakdown, with the timestamps that pin each one, is in that file's
header note. In summary: "ADB" / "ATP" -> "ADP" (12 / 1, as pass 3); "DRP" -> "ERP" (1); "Karina" ->
"Corrina" (1) and "Michaela" -> "Micaela" (1), as pass 3; "Estraham" -> "Ehtesham" (1); "Harris" ->
"Haris" (5) and "Umar" / "Omar" -> "Umer" (5); "graph code" / "graph modifier" -> "craft code" /
"craft modifier" (3 / 2); "grain" / "train" -> "crane" (2); "rigor" -> "rigger" (1); "lung boom" ->
"long boom" (1); "non-immune" -> "non-union" (1); "EBI4RZ36" -> "EPI4RZ36" (1); "for RZ" / "before
RY" -> "4RZ" / "4RY" (2 / 1); "temperate" / "template" -> "temp rate" (3 / 3); "Overly" -> "Hourly"
(1); "filling" -> "fill-in" (1).

New evidence rules used here: **"Harris" -> Haris and "Umar"/"Omar" -> Umer** only where the turn is
about inviting the two CodingCops attendees (pinned by *"It's Umer Islam, right?"*). **"temperate" /
"template" -> temp rate** only inside the 48:24–1:01:25 temp-rate explanation; Corrina's "The
temporary is" (50:01) was left, because a genuine *temporary rate* reading is possible. **Company
codes** were corrected only where the speaker's sentence names the live or dead company
unambiguously; abdulrehman's "4YZ" / "4Y4RY" (3:48) was left. Speaker labels are reproduced
uncorrected. Left unchanged: the items listed in the file's own header note.
