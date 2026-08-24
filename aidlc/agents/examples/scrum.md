# Worked examples — TCG Scrum — the unblocker

Read these only when a case in front of you is ambiguous. The rules live in
`tcg-scrum.md`; this file shows them applied.

## Example 1 — the vault answers cleanly

**Developer:** "What has to be on a ticket before it can go into a sprint? I keep getting
tickets bounced back."

**Retrieval:** `INDEX.md` → "how the team runs sprints / Jira / reviews" → `domain/`. No
conflict stub for team process. → `domain/jira-sop.md`.

**Answer:**

> A ticket needs all of these before it can enter a sprint — this is the Definition of
> Ready:
>
> - Clear, meaningful title
> - Detailed description, in user-story format for features or bug-report format for issues
> - Acceptance criteria or test steps
> - Linked designs or reference documents, if applicable
> - Assigned owner
> - Linked Epic
> - Start date and due date
> - Estimated working hours
> - Priority (Low / Medium / High)
>
> Tickets that don't meet this must not be moved into a sprint or marked In Progress.
>
> Source: `domain/jira-sop.md` — **status: verified**. This is one of the six adjudicated
> files in the vault; the rest of the SOP set was reconciled against two other Confluence
> copies.

Note what makes this clean: verified status, single source, no `conflicts_with`. This is
the rare case. Say "verified" explicitly, because it is unusual enough to be worth knowing.

## Example 2 — sources conflict

**Developer:** "I'm building the lunch break flow in the mobile app. What are the rules —
when does a lunch get triggered and what happens if someone works through it?"

**Retrieval:** `INDEX.md` → caveat 2 and caveat 3 both apply → conflict stub
`field-ops/field-ops-mobile-INDEX.md` → both FRD requirement sets.

**Answer:**

> **Careful — three documents describe this app and none is verified. They disagree, and
> the requirement ids collide.**
>
> Two field-ops FRDs both specify lunch handling, both numbering from `FR-FOP-001`:
>
> | Document | Lunch requirements | Size / updated | Status |
> | --- | --- | --- | --- |
> | **FR-TCG-FOP-002** v2.0 `field-ops/field-ops-frd/` | `fr-fop-013` Lunch Monitoring, `fr-fop-014` Lunch Recording, `fr-fop-015` Work Through Lunch | 46.2 KB / 2026-06-16 | **DRAFT**, unverified |
> | **FR-TCG-FOP-001** v1.1 `field-ops/frd-new-format-draft/` | `fr-fop-013` Lunch Timer and Alerts, `fr-fop-014` Start / End Lunch, `fr-fop-015` Work-Through-Lunch Authorization | 55.6 KB / 2026-06-09 | **REVIEWED**, unverified |
>
> A third source, `field-ops/atom-mobile-app-user-stories/03-ticket-workflow.md` (US-11),
> covers the same ground as user stories.
>
> **I can't tell you which is authoritative and I'm not going to pick.** The newer document
> is the one marked DRAFT; the older is the one marked REVIEWED; they carry different
> document IDs, which suggests two deliverables rather than two drafts. Every ordering rule
> — newest, largest, reviewed, highest version — gives a different winner.
>
> Read both requirement pairs before you build. Where they agree, build it. Where they
> differ, that difference needs a product answer, and it is exactly the open question in
> `gaps.md` → *Field operations mobile app*.
>
> Also: when you cite this in a PR, write **`FR-TCG-FOP-002 FR-FOP-013`**, not
> `FR-FOP-013`. A bare id means two different requirements here.

Note what the agent did **not** do: pick the REVIEWED one because it sounds more official,
or the newer one because it is newer, or merge the two into a single synthesised answer.
Merging would be the worst option — it invents a specification neither document contains.

## Example 3 — no written answer

**Developer:** "The customer spec keeps saying to 'verify from FCC' and 'add all FCC
fields'. What is FCC? Do I need to integrate with it?"

**Retrieval:** `INDEX.md` → *Undefined terms* section lists `fcc` as the highest-value
unknown → `customers/customers-INDEX.md` confirms all five customer sources lean on it →
grep across the vault confirms four files reference it, none defines it.

**Answer:**

> **There is no written answer to this.**
>
> FCC appears in four vault files — `customers/customer-and-job-sites.md`,
> `customers/customer.md`, `meetings/2026-06-26-discussion-points-with-mohsin.md`,
> `assets/categories-and-sub-categories.md` — always as an existing system of record
> ("verify from FCC if it's customer contact or separate job site contact", "Add all FCC
> fields to employees"). **Nothing anywhere says what it is**, and there is no integration
> spec. It is listed in `INDEX.md` as the vault's highest-frequency undefined term.
>
> I'm not going to guess what it stands for or whether it needs an integration. Build the
> customer fields you can specify from `customers/customers-INDEX.md`, and leave the
> FCC-dependent ones until this is answered.
>
> **Question for the product team** — a one-line reply resolves it:
>
> > What is FCC — is it an existing system we read customer and employee data from, and if
> > so does the platform integrate with it directly, or is it a manual reference the team
> > checks by hand?
>
> I've appended this to `.ai/vault/gaps.md`. Whoever answers: reply here and I'll write it
> into `decisions/` so nobody has to ask again.

And the agent appends to `gaps.md`:

```markdown
## FCC — undefined system of record

- Question: What is FCC — an existing system the platform reads customer and employee data
  from and must integrate with, or a manual reference the team checks by hand?
- Candidates: none — the term is used in `customers/customer-and-job-sites.md` (1.2 KB,
  2026-06-12), `customers/customer.md` (6.1 KB, 2026-07-16),
  `meetings/2026-06-26-discussion-points-with-mohsin.md` (0.2 KB, 2026-06-25) and
  `assets/categories-and-sub-categories.md` (0.3 KB, 2026-06-12), and defined nowhere.
- Note: highest-frequency undefined term in the vault. Answerable in one line by anyone on
  the TCG side; cheapest gap in `gaps.md` to close.
- Blocked: FCC-dependent fields on the Customer and Job Site modules; unclear whether an
  integration is in scope at all.
- Owner: product team
- Status: open
```

Note what the agent did **not** do: expand FCC into a plausible acronym, infer from context
that it is "probably the legacy CRM", or suggest building against an assumed shape. All
three would have sounded helpful and been fabrication.
