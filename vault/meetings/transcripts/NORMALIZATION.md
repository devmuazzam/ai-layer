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

---

# Pass 9 — 2026-10-01 (one new transcript only)

Applied to `2026-09-29-safety-discussion.md`; no earlier file was touched. **22 substitutions**, each
judged in its own line. The full breakdown, with the timestamps that pin each one, is in that file's
header note. In summary: "Shyam" -> "Ehtesham" (2); "Sam Sara" -> "Samsara" (1, as pass 7); "Steb" /
"Steph Gallagher" -> "Step Gallagher" (1 / 1); "Abdirahman" / "Abrahman" -> "Abdulrehman" (1 / 1) and
"Aris" / "Paris" -> "Haris" (1 / 1); "TOIC" -> "TWIC" (1); "metrics" -> "matrix" (2); "ERB" -> "ERP" (1);
"be an SF" -> "BNSF" (1); "debrivatized" -> "deprioritized" (1); "Green Super" -> "Crane Super" (1, as
pass 1); "Dean" / "Adi" -> "Dee" (2 / 1); "Vanessa" -> "Melissa" (1); "SERS" / "Koopa" -> "CERS" /
"CUPA" (1 / 1).

New evidence rules used here: **"Dean" / "Adi" -> Dee** only where ehtesham.anwar addresses the Safety
Manager, pinned by the spelling exchange at 5:38 (*"DEE"*); the exchange itself ("D EE Dean") is left
as heard. **"Step Gallagher"** is pinned by the speaker spelling *"step STEP"* (10:03). It does not
establish the product's official name. **"SERS" / "Koopa" -> CERS / CUPA** only as the pair, in the
turn that names California submissions. **Speaker labels are reproduced uncorrected.** Dennene "Dee"
Jones (Safety Manager) speaks on Brian Petros's room microphone for most of the call, and the file
header lists the evidence. Left unchanged: the items listed in the file's own header note.

# Pass 10 — 2026-10-02 (one new transcript only)

Applied to `2026-10-01-quotes-and-billing-codes.md`; no earlier file was touched. **26 substitutions**,
each pinned to its own line, with the timestamps in that file's header note. In summary: "ATP" -> "ADP"
(3); "early" -> "hourly" (5, pinned by the speakers' own "hourly" in the same exchange and by the
prototype's *Hourly* column on screen); "Euler" / "Eiler" -> "oiler" (3 / 1, as pass 3); crane
mis-hearings in tonnage phrases -> "crane" / "ton" (11: "done cream", "and frame", "and point", "100
time", "and queen", "ton frame", "done train", "the queen", "and grain", "and crane", "grain
configuration"); "queue overtime" -> "crew overtime" (1, the *Crew Overtime* line on screen); "Perez" /
"Paris" -> "Haris" (2 / 1, as pass 9). One 37:07 substitution covers both an "early" and a "done train",
so the categories sum to 27.

New evidence rule used here: **"early" -> "hourly"** only where the speaker is naming the quote type or
the prototype's column — every case sits in an exchange where another speaker, or the same one, says
"hourly". "in RV as well" (7:32) is the same mis-hearing in all likelihood, but was left as heard because
"RV" is not "early". "the 110 grand" (1:02:23) was left because 110 is a real tonnage. Speaker labels
are reproduced uncorrected. Left unchanged: the items listed in the file's own header note.

# Pass 11 — 2026-10-08 (one new transcript only)

Applied to `2026-10-07-erp-sprint-review-offline-tickets-holdover-and-mob-demob.md`; no earlier file was
touched. **43 substitutions**, each pinned to its own turn, with the timestamps in that file's header note.
In summary: "train(s)" / "grain(s)" -> "crane(s)" (14); "done" / "time" -> "ton" (2) and "hundred and" ->
"100 ton" (2, as pass 10's "100 and"); "detector semi" -> "the tractor-semi" (1); "code(s)" -> "quote(s)"
(5, as pass 6's "send code for approval") and "code invoice" -> "quote/invoice" (1, the column on screen);
"Shyam" -> "Ehtesham" (1, as pass 9); "Perez" / "Harris" -> "Haris" (1 / 3, as pass 10); "GSA" -> "JSA" (1);
"ADB" -> "ADP" (1); "one" -> "won" (1); "rigor" -> "rigger" (2); "dash" -> "DAS" (2); "joke" -> "job" (1);
"SCS" -> "SES" (1); "SL" -> "SSL" (2); "Euler" -> "oiler" (1); "early" -> "hourly" (1).

New evidence rules used here: **"code(s)" -> "quote(s)"** only where the code is sent to a customer, built
in a project, or is "the single code" a set of cranes goes on. "Billing code" is never touched. **"dash" ->
DAS** only where the sentence names the board that shows held items per day. "back to desk" (27:00) was
left. **"SCS" -> SES** only beside "SNS" in the AWS sentence. "110 crane" was kept although the same speaker
says 100 ton a turn later, because 110 is a real tonnage (as pass 10). Speaker labels are reproduced
uncorrected. The 33:24 "Melissa McNutt" turn is macOS VoiceOver audio, noted in the header. Left
unchanged: the items listed in the file's own header note.

# Pass 12 — 2026-10-09 (one new transcript only)

Applied to `2026-10-08-accounting-demo-invoicing-ar-ap-and-quickbooks-sync.md`; no earlier file was
touched. **14 substitutions**, each pinned to its own turn, with the timestamps in that file's header note.
In summary: "Sam Sara" -> "Samsara" (1) and "F CC" -> "FCC" (1); "Ed Shawn" / "Ashtem" -> "Ehtesham" (2, as
pass 9's "Shyam"); "pre-driven inspection" -> "pre-trip inspection" (1); "build" -> "bill" (2, one beside
"an invoice status", one naming the LADWP pay-before-bill rule); "building codes" -> "billing codes" (1);
"ERB" -> "ERP" (1); "TRGs" / "DRG's" -> "TRG's" (2, The Repair Guys, named by Brian in the same call);
"Abdul Rahman" / "Abdur Rahman" -> "Abdulrehman" (2, as pass 9) and "Harris" -> "Haris" (1, as pass 10).
**"on the CC" (1:39) was left** although the next turn says FCC, because "CC" alone is also the meeting's
own name (*CC TCG ERP System*). **"cubing integration within RCS" (28:58) was left** — it reads as *QB
integration* but nothing in the turn pins it. "LW, LWBA" / "LABWB" were left: the speaker is fumbling the
name and Brian supplies LADWP in the next turn. Speaker labels are reproduced uncorrected. Left unchanged:
the items listed in the file's own header note.

# Pass 13 — 2026-10-15 (one new transcript only)

Applied to `2026-10-13-accounting-and-safety-discussion.md`; no earlier file was touched. **19
substitutions**, each pinned to its own turn, with the timestamps in that file's header note. In summary:
"Harris" -> "Haris" (2, as pass 10); "Abrahman" -> "Abdulrehman" (1, as pass 9); "SAS" -> "SaaS" (1);
"Euler" -> "oiler" (3, as pass 3); "payroll flat" -> "payroll flagged" (1); "build" -> "bill" (3, as pass
12); "PU" -> "PO" (1); "ERB" -> "ERP" (1, as pass 9); "pitchers" -> "pictures" (1); "green super" / "train
super" -> "crane super" (1 / 1, as pass 1); "D" -> "Dee" (3, as pass 9).

New evidence rules used here: **"SAS" -> SaaS** only where the turn is about selling the product, pinned
by abdulrehman's *"SaaS product"* half a minute earlier. **"payroll flat" -> payroll flagged** only beside
*"needs to be finalized from payroll"*, pinned by "flagged" in the next two exchanges. "if this is black …
the day is black" (14:47) reads the same way, but was left because "black" is not "flat". **"PU" -> PO**
only where the next sentence says "A PO". **"D" -> Dee** only in ehtesham.anwar's turns naming the Safety
Manager. IT Support's "log in as D" (43:07) was left, because it may be a login name. "the cost" / "our
cost" (54:19, 54:41) names the document that requires a paper scope of work, and was left because nothing
in the call resolves it. Speaker labels are reproduced uncorrected: Dee speaks on Brian Petros's
microphone from 36:41, as in pass 9's file. Left unchanged: the items listed in the file's own header note.

# Pass 14 — 2026-10-22 (two new transcripts only)

Applied to `2026-10-20-erp-documentation-and-guides.md` (10) and `2026-10-21-erp-demo-walkthrough-part-1.md`
(42); no earlier file was touched. **52 substitutions**, each pinned to its own turn, with the timestamps in
each file's header note. In summary: "Harris" -> "Haris" (3, as pass 10); "graph code(s)" / "graph
board(s)" / "graph ports" / "draft boards" -> "craft code(s)" (18) and "draft based hourly" -> "craft
based hourly", "graph modifiers" -> "craft modifiers" (1 / 1, as pass 1); "union ports" -> "union codes"
(3); "train(s)" -> "crane(s)" (4, as pass 1); "Abdul Rahman" / "Abdur Rahman" / "Abiraman" ->
"Abdulrehman" (3, as pass 9 and 12); "ERB" -> "ERP" (1, as pass 9); "code" -> "quote" (2, as pass 11);
"550 time frame" -> "550 ton crane" (1, "time" -> "ton" as pass 11); "tools and writings" / "tools and
draggings" -> "tools and riggings" (2); "billing boards" / "Belling codes" -> "billing codes" (1 / 1);
"departments and rules" / "rules" -> "roles" (1 / 2); "Bess" -> "Wes" (1); "CD data" -> "seed data" (1);
"asserts" -> "assets" (2); "bentress" -> "vendors" (1); "default DL expense account" -> "default GL
expense account" (1); "early" -> "hourly" and "code invoice" -> "quote/invoice" (1 / 1, as pass 11).

New evidence rules used here: **"union ports" -> union codes and "graph ports" -> craft codes** only in
the 10-21 19:34 turn, which opens with *"union codes, graph codes"*. **"rules" -> roles** only where the
sentence is about departments and their access, never for payroll rules. **"Bess" -> Wes** only where the
next turn by the same speaker says *"Wes and Melissa"*. **"CD data" -> seed data** pinned by *"we have
just seeded this information"* in the same call. **"DL" -> GL** only in *"default DL expense account …
of the general ledger"*; "the DL" meaning a distribution list (10-20 14:51) was left, as pass 13. "Perez"
was **not** read as Haris here (pass 10 did), because the same sentence names *"Harris"* separately.
"Edison" addressing ehtesham.anwar (10-20 24:39) was left because Edison is also a TCG customer, named in
the 10-21 call. "200 ton queen" was left — "queen" is not in pass 1's crane list. Speaker labels are
reproduced uncorrected: "Brian Petros" is the conference-room microphone, carrying Dee (10-20) and Ryan
Adams (10-21 51:59–55:18), each file's header gives the evidence. Left unchanged: the items listed in
each file's own header note.

# Pass 15 — 2026-10-23 (one new transcript only)

Applied to `2026-10-22-erp-demo-walkthrough-part-2.md` (63); no earlier file was touched. **63
substitutions**, each pinned to its own turn, with the timestamps in the file's header note. In summary:
"screen" -> "crane" (6), "train(s)" / "brains" -> "crane(s)" (14) and "green" -> "crane" (1, as pass 1);
"done" / "then" -> "ton" (1 / 1, as pass 11); "Eiler" / "boiler" / "Euler" / "ailer" -> "oiler" (6, as
pass 11); "one" -> "won" (5, as pass 11 and 13); "Harris" -> "Haris" (4, as pass 10); "Quoted To" /
"Report To" for "Ported 2" / "ported 2" / "report 2" / "report tool" (4); "belly code" / "billing board" /
"billing date" -> "billing code" (3, as pass 14); "left information" / "left planning" -> "lift …" (3);
"early" -> "hourly" (2, as pass 11); "Sam Sarah" -> "Samsara" (2, as pass 7); and one each: "wet field" ->
"wet fuel", "ERB" -> "ERP" (as pass 9), "building purposes" -> "billing purposes", "search jars" ->
"surcharges", "customer PU" -> "customer PO" (as pass 13), "tools and ratings" -> "tools and riggings" (as
pass 14), "DL allocation system" -> "daily allocation system", "Doss" -> "DAS", "free checklist" -> "pre
checklist", "Ed Shawn" -> "Ehtesham" (as pass 12), "approved format" -> "approved permit".

New evidence rules used here: **"screen" -> crane** only in *"<N> ton screen"*, *"done screen"*, *"mobile
screen"* (the category) and *"send with the screen whenever the screen is going on a job"*, all in
ehtesham.anwar's asset turns, pinned by *"that train is a mobile train"* in the next sentence. It does not
license "screen" elsewhere: *"share my screen"*, *"My screen is visible"* and *"display on the screen"* are
genuine. **"Ported 2" / "report 2" -> Quoted To / Report To** only in the quotation-form turn where both
fields add contacts to the customer profile; the pin is the two field labels in the web app, which were on
the shared screen. **"left" -> lift** only beside *information* or *planning*, pinned by *"We need to
figure out the lift planning separately"* in the same turn. **"Doss" -> DAS** only in the turn presenting
the daily allocation system. "plane(s)", "frame", "cream" and "turn clean" were **not** read as crane —
none is in pass 1's list — and are listed in the file's header note. Speaker labels are reproduced
uncorrected: "IT Support" is Patrick McKiernan; the header gives the evidence. Left unchanged: the items
listed in the file's own header note.

# Pass 16 — 2026-10-29 (one new transcript only)

Applied to `2026-10-27-erp-demo-walkthrough-part-3.md` (32); no earlier file was touched. **32
substitutions**, each pinned to its own turn, with the timestamps in the file's header note. In summary:
"Harris" -> "Haris" (5, as pass 10); "ADB" -> "ADP" (3, as pass 3 and 11); "Dispatch Flight app" ->
"TestFlight app" (2); "Euler" -> "oiler" (2, as pass 3 and 11); "graph code rate" / "the graph code" ->
"craft code" (2, as pass 1) and "graph modifier" -> "craft modifier" (1, as pass 14); "ending codes" ->
"earning codes" (2); "JS tail bootstrap" / "TS retail board" -> "JSA tailboard" (2) and "GSA" -> "JSA" (1,
as pass 1); "grain" / "plane" / "plan" -> "crane" (1 / 1 / 1, as pass 1 and 3); and one each: "desk view"
-> "DAS view" (as pass 11's "dash"), "Sam Sara traging" -> "Samsara tracking" and "Sam Sara" -> "Samsara"
(as pass 3), "food" -> "fuel", "label unit details" -> "labor and unit details", "code" -> "quote" (as
pass 11), "long room" -> "long boom", "Abdimana" -> "Abdulrehman" (as pass 9 and 12), "rigor" -> "rigger"
(as pass 3 and 8).

New evidence rules used here: **the mobile app's own labels pin a correction**, as pass 15 used the web
app's: *JSA — Tailboard* (the JSA step), *"The crane was left set up yesterday. Tap to start work — no
build up needed today"* and *"Leave crane set up"* / *"Start Breakdown"* (the holdover cards) were on the
shared phone screen, so "JS tail bootstrap", "TS retail board", "the plane was left up" and "leave plan
set up" were read against them. **"Dispatch Flight" -> TestFlight** only in abdulrehman's 8:16 turn, which
installs the App Store app that opens the builds added *"in the test flight"*. **"food" -> fuel** only in
the 19:09 Samsara turn that opens on the asset's fuel. "failed" for *filled* (three times) was **not**
changed — no earlier pass licensed it and "failed" is a real word in an inspection form. "hotel" (21:44)
was left: the app offers only *Yard* and *Home*, and the curated notes say so. Speaker labels need no
caveat: every speaker joined under their own account. Left unchanged: the items listed in the file's own
header note.

# Pass 17 — 2026-10-30 (one new transcript only)

Applied to `2026-10-29-sales-quoting.md` (22); no earlier file was touched. **22 substitutions**, each
pinned to its own turn, with the timestamps in the file's header note. In summary: "Harris" -> "Haris" (1,
as pass 10); "time" / "100 and" -> "ton" (4 / 1, as pass 10 and 11) and "train" -> "crane" (3, as pass 1);
"100 time frame" -> "100 ton crane" (1, as pass 14); "Euler" -> "oiler" (1, as pass 3 and 11); "rigor" /
"dagger" -> "rigger" (1 / 1); "quoted, report to" / "report 2" -> "Quoted To, Report To" / "Report To"
(1 / 1, as pass 15); "tree closures" -> "street closures" (1); "tracking" -> "trucking" (1); "cells" ->
"sales" (1); "FA" -> "FAA" (3) and "NOTAMP" / "NODEM" -> "NOTAM" (1 / 1).

New evidence rules used here: **"dagger" -> rigger** only in ehtesham.anwar's 36:38 answer to *"can you
add a rigger on there?"* (36:12). **"tree closures" -> street closures** only where the next turn answers
*"we are working on street closure part"*. **"tracking" -> trucking** only beside *Piazza*, TCG's outside
trucking vendor in the vault. **"cells" -> sales** only in *"would cells be sending the PO … or would
Dispatch be sending"*, where the sentence sets the two departments against each other. **"FA" -> FAA and
"NOTAMP" / "NODEM" -> NOTAM** only in the airport-distance exchange, pinned by *"we either have to get an
FAA or a NOTAM"* (1:04:30). "cream", "queen" and "undertone" were **not** read as crane or *hundred ton*
— none is in pass 1's list (as pass 14 and 15) — although the "time" beside "cream" was read as "ton".
"Dallas" was not read as Lisette. Speaker labels are reproduced uncorrected: "Brian Petros" is the
conference-room microphone, carrying Brian and Ryan Adams; the header gives the evidence. Left unchanged:
the items listed in the file's own header note.

# Pass 18 — 2026-11-05 (one new transcript only)

Applied to `2026-11-03-accounting-module.md` (50); no earlier file was touched. **50 substitutions**, each
pinned to its own turn, with the timestamps in the file's header note. In summary: "coding cups" / "code
cops" -> "CodingCops" (1 / 1); "is a 10 itself" -> "is a tenant itself" (1); "from FC" -> "from FCC" (1);
"green super" / "grain super" / "clean super" / "pain super" -> "crane super" (3 / 1 / 1 / 1, as pass 1 and
7); "75 ton train" -> "75 ton crane" (1, as pass 1), "mobile trains" -> "mobile cranes" (3, as pass 1);
"plane(s)" -> "crane(s)" (3, as pass 3); "higher level frame" -> "higher level crane" (1, as pass 6);
"greens" -> "cranes" (1, as pass 2); "PU" -> "PO" (1, as pass 13); "NQB." -> "in QB." (1); "build" / "built"
/ "builds" -> "bill" / "billed" / "billing" / "bills" (8, as pass 12 and 13); "my clean" -> "mark clean" (1);
"an R" / "Rs" / "ours" -> "an hour" / "hours" (5); "payroll flat" -> "payroll flagged" (1, as pass 13);
"Payable" -> "Payroll" (2); "Estan" -> "Ehtesham" (1, as pass 9 and 12); "ERB" -> "ERP" (1, as pass 9);
"Brett" -> "Brent" (1); "making a code" -> "making a quote" (1, as pass 11); "spot e-mail" -> "support e-mail"
(1); "O2.0" -> "OAuth 2.0" (1); "AP connection" -> "API connection" (1); "mob demo" / "mob demog" -> "mob
demob" (1 / 1, as pass 6); "early" -> "hourly" (3, as pass 10, the quote type, set against mob/demob).

New evidence rules used here: **"an R" / "Rs" / "ours" -> hour(s)** only in ehtesham.anwar's 26:55, 31:19 and
32:19 turns on the payroll side of a ticket, pinned by Brent's restatement *"you talked about adding hours"*
(29:35). It is the same mis-hearing pass 17 listed and left as *"If we don't have an Rs"*; here the turns
carry the argument and Brent's restatement pins them. **"Payable" -> Payroll** only in Brent's 29:35 turn,
which opens on *"the payroll processing on Tuesday"*, and in ehtesham.anwar's *"ask to. Payroll to clean it"*
(45:43), beside *"mark it clean"*. *Accounts Payable* and every other "Payable(s)" are untouched. **"pain super"
-> crane super** is pinned by *"the crane super"* at 36:13 and by "super". **"10" -> tenant** only in *"is a
10 itself"*, because the same sentence continues to *"new tenant"*. **"Brett" -> Brent** only at 1:00:36, where
the speaker named Brent two sentences earlier; *"Hey, Brett. Brent"* (49:58) is a self-correction and stays.
"customer base" and "draft to bid" (54:53, ~ *pays*, *paid*) were **not** changed, because each is a real phrase;
the curated notes mark that reading as inferred. "Leo" (25:45) was not read as Joe, because Leo Lopez is a real
TCG name. "Sam" (51:44) was not read as Ehtesham, because Sammy Garrett is on the call. "queen" was left (as
pass 14, 15 and 17). "flat" outside *"payroll flat"* was left (as pass 13). Speaker labels are reproduced
uncorrected: "IT Support" is Patrick McKiernan; the header gives the evidence. Left unchanged: the items
listed in the file's own header note.

# Pass 19 — 2026-11-10 (one new transcript only)

Applied to `2026-11-05-customer-portal.md` (28); no earlier file was touched. **28 substitutions**, each pinned
to its own turn, with the timestamps in the file's header note. In summary: "Euler" -> "oiler" (1, as pass 3);
"rigor" -> "rigger" (2, as pass 3 and 17); "Sam," / "Ashtam," / "as Jam," -> "Ehtesham," (2 / 1 / 1, as pass
14); "Sam Sarah" / "Sam Sura" / "Samantha" -> "Samsara" (1 / 1 / 1, as pass 3 and 7) and "access to Sam, sorry to
see it" -> "access to Samsara to see it" (1); "train(s)" -> "crane(s)" (3, as pass 1); "265 done train" -> "265
ton crane" (2, as pass 1 and 3); "green" -> "crane" (2, as pass 2); "early quotation" -> "hourly quotation" (1,
as pass 10 and 18); "presidents" / "presence" -> "precedence" (2 / 1); "drag and draw" -> "drag and drop" (1);
"coding stage" -> "quoting stage" (1, as pass 11); "beyond number" -> "PO number" (1); "assert" -> "asset" (1);
"Yard 2 job site" -> "yard to job site" (1); "D's" -> "Dee's" (1, as pass 12).

New evidence rules used here: **"Sam" -> Ehtesham** only where Ryan Adams addresses him and ehtesham.anwar
answers (6:33, 20:44), and only because TCG's Sammy Garrett is not on this call; pass 18 left "Sam" because he
was. **"access to Sam, sorry to see it" -> Samsara** only in Joe's 29:06 turn, which answers Ryan's *"Samsara also
sends out a code"* (28:50) and goes on to *"where it's at in route"*. **"presidents" / "presence" -> precedence**
only in the line-order exchange (11:25, 13:21), pinned by *"set precedence"*, which ASR caught correctly at 12:15
and 12:47. **"beyond number" -> PO number** only at 20:09, which answers Ryan's question about a PO and sets the
number against *"upload document"*. **"Yard 2 job site" -> yard to job site** only at 31:38, where the next
sentence is *"scheduling from job to job"*. "Now they are looking at the green" (32:14) was **not** changed: on a
tracking map it may be the marker. "Anzaldo" (38:15) was not read as Joe, because Lisette Anzaldo is a real TCG
name. "liquidation" (9:26), "upload" (14:00), "compiler" (11:03), "Esq measures" (26:40) and "PNO" (36:31) were
left; the header lists the likely readings. Speaker labels are reproduced uncorrected; none was found wrong. Left
unchanged: the items listed in the file's own header note.
