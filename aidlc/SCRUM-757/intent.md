# Intent — SCRUM-757

> **Captured retroactively on 2026-08-12, after `spec.md` was already written on
> 2026-08-11.** The normal order is intent → spec; this file did not exist when the
> elaborator ran, which the spec records as a finding in its §0 Provenance.
>
> It is therefore **not** an input to that spec. It is captured now so the ticket has the
> record the loop expects, and so the next pass (re-elaboration after Q1–Q5 are answered)
> has one. Where this capture and the spec disagree, the spec was written first and from
> the same ticket — this file introduces no new sources.

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-757` |
| Title | *Performance Issues and Excessive API Calls and  Plan Comments issue* (double space is in the ticket) |
| Type | Bug |
| Status | To Do — as of 2026-08-12 |
| Epic | `SCRUM-232` — *Project* (Epic, To Do) |
| Sprint | `NOT ON TICKET` — no sprint field returned by the capture query |
| Reporter | Aiman Farooq |
| Assignee | syed haris |
| Captured on | `2026-08-12` |
| Captured by | Claude session, retroactively — see the note above |

Ticket last updated 2026-08-07. No ticket comments, no issue links, no components, no
labels.

## 2. Business intent

The ticket describes only observed defects on a screen and in the Network tab. It states no
business outcome, no affected role, and no cost of leaving it. Recording that rather than
inventing one.

- Intent: `NOT ON TICKET` — the ticket reports three symptoms and does not say why fixing
  them matters or to whom. The nearest thing to a stated stake is its own claim that the
  400/401 responses "do not currently affect the application's functionality" but "could
  negatively impact performance and scalability over time".
- Who benefits (role): `NOT ON TICKET` — the screen's users are not named, and which screen
  it is is itself open (spec Q1).
- What is worse today without it: users of the unidentified Plan Comments screen find the
  comment box unresponsive as comments accumulate. Severity, frequency and how many users
  are affected: `NOT ON TICKET`.

## 3. Definition of done, as the ticket states it

Quoted verbatim from the ticket description:

```
The **Plan Comments** page experiences significant performance issues when multiple
comments containing long paragraphs are added. As the number and length of comments
increase, the page becomes noticeably slow, and the comment box becomes unresponsive,
making it difficult to type or interact with the application.

Additionally, while monitoring the Network tab, opening a single page triggers multiple
repeated API requests. Several **400 (Bad Request)** and **401 (Unauthorized)** responses
are also generated. Although these errors do not currently affect the application's
functionality, they indicate unnecessary network activity that could negatively impact
performance and scalability over time.

**Steps to Reproduce:**

1. Navigate to the **Plan Comments** page.
2. Add multiple comments containing long paragraphs.
3. Continue interacting with the comment box.
4. Open the browser's Network tab and observe the API requests.
```

- Acceptance criteria present on the ticket: **no**
- `OPEN — ticket has no acceptance criteria; per domain/jira-sop.md it does not meet
  Definition of Ready`

The steps to reproduce are the closest thing to criteria, and they describe how to *see*
the problem, not how to tell when it is fixed. Every symptom is comparative — "noticeably
slow", "unresponsive", "multiple repeated" — with no baseline, count or threshold. This is
the origin of spec Q2 and Q3.

## 4. In scope

Nothing can be checked off yet: the screen is unidentified (Q1), so the scope of every line
below is unknown. Listed as the ticket's three claims, not as agreed scope.

- [ ] The comment entry on the Plan Comments screen stays usable as comments accumulate
      — *screen unidentified (Q1), threshold unstated (Q2)*
- [ ] A single page open stops issuing the same request repeatedly
      — *which requests, and how many times, unstated (Q3)*
- [ ] The 400 responses are eliminated or shown to be expected
      — *which requests produce them, unstated (Q3)*
- [ ] The 401 responses are eliminated or shown to be the designed refresh cycle
      — *undetermined (Q4)*

## 5. Out of scope

- [ ] Any change to the comment **data model**. Plan comments are currently stored as
      project activity-log entries, not as a comment model. Whether that should change is a
      product question nobody has asked; the spec records it as current state only.
- [ ] Pagination, virtualization, or a comment length cap. These are three different
      products and choosing one in code answers Q5 without asking it.
- [ ] `SCRUM-763` "Inhouse comments – design update needed" (Task, **Blocked**, same epic).
      It is open against one of the two candidate screens. Whether it describes the same
      defect is unknown and is part of Q1.
- [ ] Any change to the silent-refresh interceptor in `apps/web/src/lib/base-api.ts`
      pending Q4 — if the observed 401s are the designed cycle, suppressing them weakens the
      auth flow to clean up a console.
- [ ] Performance work on any other screen. The ticket names one page.

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS — presentation / usecase / service) | **?** | Only if the 400s or the repeated requests turn out to be server-side. Unknown until Q3 |
| `apps/api/prisma` (schema + migration) | **?** | Expected **no** — but Q5 (pagination / volume) could reach the schema, and the spec explicitly does not propose a `PlanComment` model |
| `apps/web` (Next.js) | **yes** | The reported symptoms are all client-side; the screen is unidentified (Q1) |
| `apps/mobile` (Expo Router) | **no** | The ticket describes a browser Network tab and a web page |
| `packages/shared` | **?** | Only if an API contract moves, which nothing yet indicates |

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| `N/A` | `N/A` | No entity is created, renamed, or has a code minted |

- New entity introduced by this ticket: **no** — and the spec explicitly declines to propose
  a `PlanComment` model
- New code prefix introduced: **no**
- Existing rows affected: **no** — this is a read/render-path defect as reported

## 8. Roles and permissions

- Roles that can perform this: `NOT ON TICKET` — the ticket names no role, and the affected
  screen is unidentified
- Roles explicitly excluded: `NOT ON TICKET`
- Tenant scope: standard per-tenant isolation assumed; the ticket says nothing about
  tenancy and nothing here changes a query's scope

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | `NOT ON TICKET` |
| Jira attachments | Two smart links, **neither opened by the elaboration or this capture** — Google Drive (`1dxIXkwKwibb18O4B509oI8tr-q5pTNrF`) and Loom (`a87a3af4649240a0841ff1b50faa2370`). Per spec §0 these are the only place the ticket's concrete evidence exists |
| Related tickets | `SCRUM-763` — "Inhouse comments – design update needed" (Task, **Blocked**, same epic), open against one candidate screen · `SCRUM-211` — "Comment rich text scroll bar is missing" (Done) |
| Existing repo docs | none found |
| Vault area the reader thinks is relevant | `product/project-module/04-create-and-approve-lift-plans.md` — the elaborator checked it; it specifies plan creation and approve/request-changes-with-comments but **describes no comments page and no performance expectation** |

## 10. Terms used that may not be defined

- **"the Plan Comments page"** — used on the ticket as: *"Navigate to the **Plan Comments**
  page."* No vault file, Jira ticket or repo route defines a screen by this name. This is
  spec Q1 and the ticket's single largest ambiguity.
- **"noticeably slow" / "unresponsive"** — used on the ticket as: *"the page becomes
  noticeably slow, and the comment box becomes unresponsive"*. Comparative, with no
  baseline. Spec Q2.
- **"multiple repeated API requests"** — used on the ticket as: *"opening a single page
  triggers multiple repeated API requests"*. No count, no endpoint. Spec Q3.

None of the nine known-undefined domain terms appears on this ticket.

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| `400` (Bad Request) | Observed in the Network tab. An HTTP status, not a threshold |
| `401` (Unauthorized) | Observed in the Network tab. An HTTP status, not a threshold |

**The ticket states no threshold of any kind** — no load-time budget, no input-latency
budget, no comment count, no comment length, no request count. Every number the fix would
need is absent, which is why five of the spec's seven requirements are `[OPEN]`.

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: **7** — business intent, beneficiary role, severity/reach,
  sprint, design handoff, roles permitted, roles excluded
- Fields left as `OPEN`: **1** — acceptance criteria absent (Definition of Ready not met per
  `domain/jira-sop.md`, one of the six verified vault files)
- Is this ticket, as written, buildable without a product answer? **no**
- The blocking questions are the spec's Q1–Q5, all five already carried into `spec.md`:
  1. **Q1** — which screen is "the Plan Comments page"? *(owner: Aiman Farooq)*
  2. **Q2** — what is the performance target, and at what comment volume? *(owner: product)*
  3. **Q3** — which requests return 400, and which were seen repeated, with counts? *(owner: Aiman Farooq)*
  4. **Q4** — are the 401s the designed refresh cycle or calls that should not be made? *(owner: product / auth owner)*
  5. **Q5** — comment volume, length limit, and list behaviour: paginate, virtualize, or load in full? *(owner: product)*

**Q1 and Q3 are answerable by opening the two attachments**, which no pass has done. That
is the cheapest unblocking action available on this ticket.

---

**Next step:** not the elaborator — it has already run and produced `spec.md`. The next step
is answering Q1–Q5, then re-elaborating the affected requirements and decomposing.
