# Intent — Trello-247 Role editor: linked View grants, hidden unenforced modules and actions, per-action toggles

> Path A (client-facing behaviour nobody specified — guardrail G1). Captured from the Trello card, created
> 2026-11-16 by the developer from the vault gap *Role editor behaviour nobody specified*.

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | Trello #247 — https://trello.com/c/2S2z3r8v |
| Title | Role editor: linked View grants, hidden unenforced modules and actions, and separate View / Create / Edit / Archive toggles |
| Type | Task / decision |
| Status | In Review (the build exists; the decisions are unanswered) |
| Epic / Sprint | NOT ON TICKET |
| Reporter / Assignee | fouzanshakil |
| Captured on | 2026-11-16 · by Claude Code session (fouzan) |

## 2. Business intent

- Intent: the people who set role permissions (Brian, Corrina, Patrick) get an editor that does not hand out
  access by accident and does not offer switches that do nothing.
- What is worse today without it: ticking Quotations could leave links to pages the role cannot open; the
  editor offered modules and actions nothing enforces; the four levels TCG was shown (no access / view / edit /
  full) are not what the editor shows.

## 3. Definition of done, as the ticket states it

```
Done when the answers are written down and the editor follows them on staging.
To settle with TCG:
1. Should ticking a module also give View on the modules it links to?
2. Should modules and actions nothing enforces yet be hidden, or shown greyed out?
3. Four separate toggles per module, or the single four-level choice (None / View / Edit / Full) TCG was shown on 21 Oct 2026?
4. Hidden fields: which employee details must be hidden from roles that can open Employees (same question as #195).
```

- Acceptance criteria present on the ticket: yes (the four questions)

## 4. In scope

- [ ] Written answers to 1–3 from the owner of roles at TCG, then the editor changed if an answer differs from the build
- [ ] 4 is tracked on #195 and the vault gap *Field-level access inside a module*; not built

## 5. Out of scope

- What each seeded role may do (TCG-237 Q5, TCG-246)
- A Notifications section in the editor (deferred; #177 / TCG-248 cover who receives what)

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/web` | yes | `features/departments` — `constants/linked-modules.ts`, `enforced-permissions.ts`, the permission grid and toolbar |
| `apps/api` | yes | `web-portal-access.ts`, `updateRole` merge, access-token role read |
| prisma / mobile / shared | no | — |

## 7. Entities and business codes

`DepartmentRole.permissions` read and written; no new entity or code.

## 8. Roles and permissions

- Roles that can perform this: Departments edit
- Tenant scope: standard per-tenant isolation (G3 — roles are tenant data)

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Vault | `vault/admin/gaps.md` → *Role editor behaviour nobody specified* (entry updated 2026-11-16 with this card) |
| Meetings | 2026-10-21 demo part 1 §4 (four levels shown) · 2026-11-10 employee-access call (Brian still describes four levels, 11:00) |
| Related tickets | #130, #178, #195, #177, TCG-237 |
| Build record | `../ROLE-EDITOR-PERMISSIONS/state.md` |

## 10. Terms used that may not be defined

- "linked" — a module whose pages are linked from another module's screens, one hop only (`linked-modules.ts`)

## 11. Numbers, thresholds and enumerated values on the ticket

Four actions: View, Create, Edit, Archive. Four levels shown on 2026-10-21: no access, view, edit, full.

## 12. Capture completeness

Complete. All four questions are open (OPEN — owner at TCG not yet named in the vault).
