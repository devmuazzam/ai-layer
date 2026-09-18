---
title: UAT — folder index
status: reference
kind: index
updated: 2026-09-19
tags: [module/all, kind/index, requirements, open-questions]
---

# UAT — the user-acceptance sessions and their register

What TCG and CodingCops raised in the six UAT sessions run between 9 and 17 September 2026,
and what the 2026-09-18 audit found had actually been built. Migrated from Confluence space
TCG on 2026-09-19.

> **This folder is a record of requests and their build status, never a source for a spec.**
> A UAT row is a client or internal **ask** — someone sat in front of a screen and said what
> they wanted changed. Nothing here was adjudicated. Where a row asserts how the product must
> behave ("Permit Cost should be the same as the PO Fee", "One person cannot be assigned to
> two jobs"), that assertion carries no more authority than the person who said it in the
> room. **Do not cite a UAT row as product intent.** If a row states a rule the vault does not
> already hold, it is an open question for the owning module's `gaps.md` or a decision note —
> not a requirement. Everything in this folder is `status: unverified`.

## Files

| File | Answers | KB |
| --- | --- | --- |
| [register-2026-09-18.md](register-2026-09-18.md) | **Every UAT request across sessions 1–6, with what the code actually does.** 252 rows, two tables, verified against `origin/main` at `f800a3972`. Fouzan Shakil, 2026-09-18 | 105 |
| [sessions/](sessions/) | The six raw session sheets, verbatim — the register's sources | 25 |

## The sessions

| # | Page | Session date | Page ID | Author | Rows in the register |
| --- | --- | --- | --- | ---: | --- |
| 1 | [UAT session 1 ( Internal )](sessions/uat-session-1-internal.md) | *not stated on the page* | `170229761` | Umair Khan | 34 — 13 done, 21 not done |
| 2 | [UAT Session 2](sessions/uat-session-2.md) | 2026-09-09 | `170360833` | Umair Khan | 45 — 24 done, 21 not done |
| 3 | [UAT session 3](sessions/uat-session-3.md) | *not stated on the page* | `170491905` | Umair Khan | 39 — 20 done, 19 not done |
| 4 | [UAT session 4](sessions/uat-session-4.md) | 2026-09-14 | `170786817` | Umair Khan | 53 — 27 done, 26 not done |
| 5 | [UAT session 5](sessions/uat-session-5.md) | *not stated — the heading says only "Tuesday \| 1:00 AM"* | `170950664` | Umair Khan | 16 — 7 done, 9 not done |
| 6 | [17Sep Internal UAT](sessions/17sep-internal-uat.md) | 2026-09-17 | `174850050` | Fouzan Shakil | 38 — 0 done, 38 not done |
| — | *no source — untraceable to a session* | — | — | — | 27 — 9 done, 18 not done |
| | | | | **Total** | **252 — 100 done, 152 not done** |

**100 done, 152 not done — 40% / 60%.** The register calls the six pages "UAT 1" through
"UAT 6"; the Confluence page titled *17Sep Internal UAT* is the one it calls UAT 6.

**Two caveats the register states about its own numbers**, and both matter before anyone
works from a status:

- **The 38 UAT 6 rows were never checked against code.** They were entered as NOT DONE on
  the assumption that the 17 Sep session listed outstanding work. Their status is assumed.
- **27 rows have no traceable source.** Nine are bugs found during the audit itself; the rest
  came from a list whose origin is unrecorded. The register says nobody should act on one
  until its origin is confirmed.

## Read this first — the three headline defects

Quoted from the register's own *Read this first* section. All three are things widely
believed finished that are not:

> **Push notifications do not work on any phone.** There is no Firebase config file in the
> app at all, so Android never gets a token and iOS sends a token the server rejects and
> deletes. The server half is complete and correct — only the app's native config is missing.

> **Allocations can still be removed after the time has passed.** The delete check looks at
> payroll locks and whether tickets were sent — it never looks at the clock.

> **The Pre-Inspection checklist still pre-ticks every item.** The fix exists, but a build
> setting turns the autofill back on in every build we ship, including production.

A fourth line in the same section is the reason the register exists at all: *"Nine items
widely believed outstanding are already built — anyone working from an older list will
rebuild finished work."*

## How to read a row

Five columns: **Status** (DONE / NOT DONE), **Item** (the request in plain words), **Src**
(a link to the exact point on the session sheet — blank where untraceable), **Comments** (the
finding, usually naming the file that proves it), **Owner** (blank on purpose). A row is DONE
only if the thing complained about no longer happens; anything half-built sits in NOT DONE
with the remaining gap spelled out.

## Related

- [../erp-review-log.md](../erp-review-log.md) — the client's **own** feedback register, kept
  separately. Same class of artefact, different author and a different period; also unadjudicated.
- [../decisions/](../decisions/) — where a UAT question becomes binding, once a named human
  answers it.
- `../<module>/gaps.md` — where a UAT row that states an unsettled product rule belongs.
