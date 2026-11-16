# Intent — Trello-178 Permissions: hide Create and Edit buttons from users without that permission

> Path C. Captured from the Trello card, not from Jira. Nothing here is sourced from the vault.

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | Trello #178 — https://trello.com/c/avuckZJW |
| Title | Permissions: hide Create and Edit buttons from users without that permission |
| Type | Task (from Syed Haris's list, 6 Nov 2026) |
| Status | In Review (card moved there before this capture) |
| Epic / Sprint | NOT ON TICKET · due 2026-11-16 |
| Reporter | Syed Haris |
| Assignee | fouzanshakil |
| Captured on | 2026-11-16 |
| Captured by | Claude Code session (fouzan) |

## 2. Business intent

- Intent: a user who may not create or edit something should not be shown the control for it.
- Who benefits (role): every role below admin; the people who sign off roles (Brian, Corrina).
- What is worse today without it: the control shows, the API refuses, the user sees a 403.

## 3. Definition of done, as the ticket states it

```
- Without create permission, the Create / Add button for that area is hidden.
- Without edit permission, the Edit button is hidden.
- Users with the permission see the buttons as today.
- Applies across the web app and the mobile app.
To confirm: whether other actions (Delete, Approve, Export) follow the same rule.
Done when checked on staging with a user who has the permission and one who does not.
```

- Acceptance criteria present on the ticket: yes

## 4. In scope

- [x] Web: Create, Add, Edit, Archive/Restore, upload and invite controls hidden when the role lacks the grant
- [ ] Mobile app: same rule — **not started** (see `state.md`)
- [ ] Delete, Approve, Export — the card's own open question; Archive was covered, the others only where an existing approve rule already applied

## 5. Out of scope

- Field-level access (hidden fields) — Trello #195, vault `admin/gaps.md` *Field-level access inside a module*
- Which role may do what (TCG-237 Q5, TCG-246) — seeded defaults stay the draft matrix
- Enforcement in the API — already done under TCG-245; the UI follows the same module and action

## 6. Surfaces touched

| Surface | Touched | What changes |
| --- | --- | --- |
| `apps/api` | no | — |
| `apps/api/prisma` | no | — |
| `apps/web` | yes | `Can` gate and `usePermission` on list, detail, create and edit screens of ~25 modules; read-only modes on the shared photo card, notes grid and attachments section |
| `apps/mobile` | no (not yet) | the card asks for it |
| `packages/shared` | no | — |

## 7. Entities and business codes

N/A — no entity or code is created or renamed.

## 8. Roles and permissions

- Roles that can perform this: any role holding the module's action (`view | create | edit | archive`)
- Roles explicitly excluded: NOT ON TICKET
- Tenant scope: standard per-tenant isolation

## 9. Designs and references

| Kind | Reference |
| --- | --- |
| Related tickets | Trello #130 (per-action permissions), #92 TCG-245 (enforced in the API), #247 (role editor decisions), #195 (hidden fields) |
| Vault area | `admin/gaps.md` → *Role editor behaviour nobody specified* |

## 10. Terms used that may not be defined

- "Delete" — used on the card; the platform archives, it does not delete. Treated as Archive.

## 11. Numbers, thresholds and enumerated values on the ticket

None.

## 12. Capture completeness

All fields filled or marked. Mobile and the Delete / Approve / Export question remain open on the card itself.
