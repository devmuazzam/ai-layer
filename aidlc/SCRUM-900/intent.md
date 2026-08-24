# Intent — SCRUM-900

> Captured from Jira. Not a spec. Nothing here is sourced from the vault yet.

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `SCRUM-900` |
| Title | Update Tool and Rigging Usage Logic After Job Completion |
| Type | Task |
| Status | In Progress (as of 2026-08-21) |
| Epic | `SCRUM-454` — Tool and Riggings |
| Sprint | Sprint 10 |
| Reporter | Aiman Farooq |
| Assignee | Fouzan Shakil |
| Captured on | `2026-08-21` |
| Captured by | fouzan (session) |

## 2. Business intent

- Intent: On the Tool and Rigging detail page, the **In Use** count should reset after the associated job is completed.
- Who benefits (role): yards / asset management (who reads live availability); NOT ON TICKET for a named role
- What is worse today without it: NOT ON TICKET — ticket does not state the current failure beyond the desired reset

## 3. Definition of done, as the ticket states it

```
On the Tool and Rigging detail page, the **In Use** count should reset after the associated job is completed.
```

- Acceptance criteria present on the ticket: no
- If no: `OPEN — ticket has no acceptance criteria; per domain/jira-sop.md it does not meet Definition of Ready`

## 4. In scope

- [ ] Tool and Rigging detail page **In Use** count resets after the associated job is completed (verbatim ticket)

## 5. Out of scope

- [ ] NOT ON TICKET — ticket does not name boundaries
- [ ] *(adjacent assumption a reader might make)* Dylan yard-dashboard In Use counters — NOT ON TICKET whether this ticket covers them
- [ ] Parent Job.status completion trigger itself — owned by SCRUM-903; this ticket only names the In Use effect

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` (NestJS — presentation / usecase / service) | ? | Utilization / In Use calculation for tools |
| `apps/api/prisma` (schema + migration) | ? | Unknown whether stock is stored or derived |
| `apps/web` (Next.js) | ? | Tool detail In Use display (may already consume API) |
| `apps/mobile` (Expo Router) | no | NOT ON TICKET |
| `packages/shared` | ? | |

## 7. Entities and business codes

| Entity (Prisma model) | Code field / prefix | This ticket… |
| --- | --- | --- |
| Tool / JobToolAssignment / Job (guess — elaborator verifies) | NOT ON TICKET | reads / updates utilization — elaborator verifies |

- New entity introduced by this ticket: no
- New code prefix introduced: no
- Existing rows affected (backfill / migration of data, not just schema): ?

## 8. Roles and permissions

- Roles that can perform this: NOT ON TICKET
- Roles explicitly excluded: NOT ON TICKET
- Tenant scope: standard per-tenant isolation — assumed; NOT ON TICKET

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Design handoff | NOT ON TICKET |
| Jira attachments | none |
| Related tickets | `SCRUM-454` (epic); `SCRUM-903` (Job.status → COMPLETED on last-day offload); `SCRUM-453` / `SCRUM-457` (tool detail + Dylan live In Use) |
| Existing repo docs | NOT ON TICKET |
| Vault area the reader thinks is relevant | `product/tool-and-rigging.md` — guess for elaborator |

## 10. Terms used that may not be defined

- **In Use** — used on the ticket as: "the **In Use** count should reset"
- **reset** — used on the ticket as: "should reset after the associated job is completed" (to what value? NOT ON TICKET)
- **associated job is completed** — used on the ticket as: "after the associated job is completed" (parent Job.status vs sub-job/offload — NOT ON TICKET)

## 11. Numbers, thresholds and enumerated values on the ticket

| Value | Where the ticket says it came from |
| --- | --- |
| *(none)* | `NOT ON TICKET — no origin cited` |

## 12. Capture completeness

- Fields left as `NOT ON TICKET`: many — business "what is worse", AC, out of scope, roles, design, reset semantics, completion trigger
- Fields left as `OPEN`: 1 — no acceptance criteria / DoR
- Is this ticket, as written, buildable without a product answer? no
- If no, the blocking questions are:
  1. When does "job completed" free tools from In Use — parent `Job.status = COMPLETED` only, or sub-job/loadout closed (offload complete / stage COMPLETED) like Dylan's yard panel?
  2. Does "reset" mean subtract that job's assigned qty from the selected date's utilization (live stock), or set something else (catalog `availableQuantity`, global zero)?
  3. For a historical date picker on the detail page, after the job completed, should In Use for that past date show 0 (released) or the historical assignment peak?

---

**Next step:** run the elaborator (`.ai/aidlc/agents/inception/tcg-elaborator.md`) against this file.
