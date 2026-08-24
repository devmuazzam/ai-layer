# Intent — SCRUM-###

> Copy to `.ai/aidlc/SCRUM-###/intent.md` and fill. One intent per ticket.
>
> This file captures **what the ticket asks for**, from the ticket. It is not a spec and
> not a design. Nothing here is sourced from the vault yet — that happens in `spec.md`.

## Fill rules

Every field below is required. **Never delete a field.** A field you cannot fill keeps its
heading and takes exactly one of these markers, so the hole is visible to the elaborator:

| Marker | Means |
| --- | --- |
| `NOT ON TICKET` | The ticket does not say. Not "probably X". |
| `N/A — <reason>` | Genuinely does not apply to this ticket. |
| `OPEN — <question>` | Needs a human answer before build. Phrase it so a one-line reply resolves it. |

An intent with `NOT ON TICKET` in six places is a **correct** intent for a thin ticket. An
intent where those six fields were quietly deleted is a broken one — the elaborator cannot
tell a missing answer from an answer nobody needed.

Do not paraphrase acceptance criteria into your own words. Quote them.

---

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-###` |
| Title | *exact ticket summary* |
| Type | Story / Bug / Task / Sub-task |
| Status | *as of the date below* |
| Epic | `SCRUM-###` — *name*, or `NOT ON TICKET` |
| Sprint | *sprint name/number*, or `NOT ON TICKET` |
| Reporter | |
| Assignee | |
| Captured on | `YYYY-MM-DD` |
| Captured by | |

Ticket state moves. Everything below is a snapshot of the ticket on *Captured on*; if the
ticket changed after that date, the spec built from this intent is stale.

## 2. Business intent

One paragraph. **Why** this is being built, in business terms — the crane-rental outcome,
not the implementation. If the ticket only describes a UI change, say that, and record the
underlying reason as `NOT ON TICKET` rather than inventing one.

- Intent:
- Who benefits (role): *dispatcher / field crew / accounting / admin / customer*
- What is worse today without it:

## 3. Definition of done, as the ticket states it

Quote the ticket. Verbatim, including the parts that are vague.

```
<paste acceptance criteria / test steps exactly as written>
```

- Acceptance criteria present on the ticket: yes / no
- If no: `OPEN — <ticket has no acceptance criteria; per domain/jira-sop.md it does not meet Definition of Ready>`

`domain/jira-sop.md` is one of the six verified vault files, and it requires acceptance
criteria before a ticket enters a sprint. A ticket without them is worth flagging here.

## 4. In scope

Explicit list. Each line is something a reviewer could check off.

- [ ]
- [ ]

## 5. Out of scope

Explicit list. This field is where the sprint gets protected — an empty out-of-scope
section is almost always an unfilled one, not a ticket with no boundaries.

- [ ]
- [ ] *(adjacent thing a reader would reasonably assume is included, and is not)*

## 6. Surfaces touched

Mark every row. `?` is a legitimate answer and is more useful than a wrong `no`.

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS — presentation / usecase / service) | yes / no / ? | |
| `apps/api/prisma` (schema + migration) | yes / no / ? | |
| `apps/web` (Next.js — atoms → pages) | yes / no / ? | |
| `apps/mobile` (Expo Router) | yes / no / ? | |
| `packages/shared` (types shared across apps) | yes / no / ? | |

Notes for the elaborator:

- A `yes` on `apps/api/prisma` means a committed migration under
  `apps/api/prisma/migrations/` is mandatory (CLAUDE.md → Web UI Rules 12,
  `.ai/claude/contexts/prisma.md`).
- A `yes` on `packages/shared` means both web and mobile are downstream whether or not
  they are marked here.

## 7. Entities and business codes

Which business entities does this touch, and does it mint or read any per-tenant code?
Follow the Identity Convention: UUID PK, per-tenant prefixed code, child FKs by UUID.

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| e.g. `Customer` | `customerCode` / `CUST-#####` | reads / creates / renames / `N/A` |

- New entity introduced by this ticket: yes / no
- New code prefix introduced: yes / no — *if yes, name it; a new prefix is a schema-level
  decision, not an implementation detail*
- Existing rows affected (backfill / migration of data, not just schema): yes / no / ?

## 8. Roles and permissions

- Roles that can perform this: *e.g. `Role.ADMIN`* / `NOT ON TICKET`
- Roles explicitly excluded:
- Tenant scope: standard per-tenant isolation / something else — *describe*

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | *path to the UI team's HTML/CSS delivery, or a link*, or `NOT ON TICKET` |
| Jira attachments | |
| Related tickets | `SCRUM-###` — *how it relates* |
| Existing repo docs | *e.g.* `docs/notifications-architecture.md` |
| Vault area the reader thinks is relevant | *e.g.* `quotations/quotations-INDEX.md` — **a guess is fine here; the elaborator verifies it** |

## 10. Terms used that may not be defined

List domain terms the ticket uses without defining. The vault has **no glossary**, and
nine terms are known-undefined: `fcc`, `tailboard-jsa`, `das`, `boom-time`, `build-up`,
`craft-code`, `loadout`, `mob-demob`, `comp-code`.

- Term — used on the ticket as: *quote the sentence*

## 11. Numbers, thresholds and enumerated values on the ticket

Any concrete number, threshold, list of statuses, or timing rule the ticket states.
**Record where each came from.** A value with no origin is the single most dangerous thing
in a ticket — `gaps.md` → *Lunch thresholds and work-through-lunch authorization* is a
live example of numeric thresholds reaching an In Progress ticket while every specification
records them as undecided.

| Value | Where the ticket says it came from |
| --- | --- |
| | `NOT ON TICKET — no origin cited` |

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: *count + list*
- Fields left as `OPEN`: *count + list*
- Is this ticket, as written, buildable without a product answer? yes / no
- If no, the blocking questions are: *list them; the elaborator will carry each into
  `spec.md` and `.ai/vault/gaps.md`*

---

**Next step:** run the elaborator (`.ai/aidlc/agents/inception/tcg-elaborator.md`) against this file.
It produces `spec.md` beside it and then stops to ask its questions. It will not implement.
