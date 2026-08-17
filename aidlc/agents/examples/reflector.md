# Worked examples — TCG Reflector — what the loop got wrong, and what would have prevented it

Read these only when a case in front of you is ambiguous. The rules live in
`tcg-reflector.md`; this file shows them applied.

## Example 1 — the right guess, recorded anyway

**What happened:** the spec did not state a page size. The executor used 25, review was
happy, it shipped and works.

**The temptation:** `NONE FOUND`. Nothing broke.

**What the agent writes:**

> **SD-1 — list page size unspecified.** Where: REQ-02, which requires pagination and states
> no size. What the spec said: nothing. Decided instead: `25`, by the executor, matching
> three neighbouring modules (a fourth uses 10). Was the decision right: **still unknown** —
> nobody has stated a target, so "right" has no referent. Cost: none yet. Class: missing.
> Fix: R2 — `templates/spec.md` should require a pagination field on any requirement whose
> acceptance mentions a list.

Note it is recorded as a **spec** defect, not an executor defect. The executor did the right
thing; the contract had a hole.

## Example 2 — third occurrence, escalated

**What happened:** the third ticket in a row where a component was created that already
existed elsewhere in `apps/web`.

**Weak reflection:** *"Remind developers to check existing components before creating new
ones."* That is what the rule already says, in two files.

**What the agent writes:**

> **Recurrence: third occurrence.** Also SCRUM-8xx (SD-3) and SCRUM-8xx (ED-2). Why the
> previous fixes did not hold: both added prose. `contexts/web.md` already says to check
> before creating, and it was read — the executor searched `atoms/`, `molecules/` and
> `organisms/` and genuinely did not find it, because the component was in `ui/`, which has
> the most consumers in the app and was not in the search list the rule implied.
>
> **ESCALATION.** This is not a reminder problem. Two structural options: (a) a single
> canonical primitive source so "where do I look" has one answer — this is the `ui`/`base`/
> `atoms` question already open and is the real fix; (b) failing that, an index of exported
> shared components, generated, so the search is one grep rather than nine directories.
> Proposing (b) as the interim since (a) is scheduled inside the revamp.

Note what makes it useful: it diagnoses **why** the prose failed rather than restating it,
and its proposal is mechanical.

## Example 3 — the proposal that does not survive its own test

**Draft proposal:** add to `contexts/api.md`: *"Be careful with tenant scoping."*

**Testing it against the defect:** the executor had already read `contexts/api.md`. It knew
scoping existed. It did not know its model sat outside the extension's allowlist, because
nothing told it the allowlist existed.

**Result:** rejected, and replaced:

> R3 — `.ai/claude/contexts/prisma.md`, "Tenant scoping is conditional". Exact change: add
> *"Before adding a model that holds tenant data, confirm it is in the extension's
> allowlist in `prisma.service.ts`. A model outside it is not isolated."* Prevents SD-2.
>
> Rejected: "be careful with tenant scoping" — the executor was careful and still missed it.
> Care was not the failing input; knowledge of the allowlist was.
