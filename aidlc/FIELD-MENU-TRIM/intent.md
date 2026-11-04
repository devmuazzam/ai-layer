# Intent — FIELD-MENU-TRIM

> No Jira ticket. Captured from the developer's request in chat. Quoted, not paraphrased.

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `NOT ON TICKET` (working id `FIELD-MENU-TRIM`) |
| Title | Trim the field-worker mobile Menu to My Certifications only |
| Type | Task |
| Captured on | 2026-10-26 |
| Captured by | Claude Code, from haris |

## 2. Business intent

Quote: "In mobile app for field worker in menu we have these options: My Labour, My
Certifications, My Tasks, Checklist History. Except My Certifications, we do not need other
options so we need to completely remove them from mobile UI and backend and DB as well if
possible."

## 3. Definition of done, as the request states it

- The Menu screen shows My Certifications and no other navigation row.
- The mobile UI for the three removed options is gone.
- Their backend is gone.
- Their DB objects are gone "if possible".

## 4. In scope

- Menu rows: My Labor (row label in code is "My Labor"), My Tasks, Checklist History.
- Their routes under `apps/mobile/app/(field)/menu/`.
- Mobile code that exists only for them (hooks, services, contracts, components, prefetch).
- API endpoints that exist only for them.

## 5. Out of scope

- My Certifications and `GET /me/certifications`.
- The in-ticket Labor step (`features/field-ticket/steps/labor`) and ticket labor entries.
- Payroll, pay class, hourly rate data itself (still used by payroll).
- Vault pages describing the removed screens (follow-up via `tcg-scrum`, not this PR).

## 6. Surfaces touched

| Surface | Touched |
| --- | --- |
| `apps/mobile` | yes |
| `apps/api` | yes (`/me/labor`, `/me/performance`) |
| `apps/api/prisma` | `NOT ON TICKET` — investigated, nothing to drop (spec §3) |
| `apps/web`, `packages/shared`, `qa-automation` | no references found |

## 7. Entities and business codes

N/A — no entity is created or removed.

## 8. Roles and permissions

Field worker persona only. Nothing changes for other personas.

## 9. Designs and references

`.design-ref/tcg2/app/extras.jsx` (DF8 T4 original design of the screens).

## 10. Terms used that may not be defined

"My Labour" = the row labelled "My Labor" (`menu/labor.tsx`). Assumed, see Q1.

## 11. Numbers, thresholds and enumerated values on the ticket

None.

## 12. Capture completeness

Thin request: no ticket, no acceptance criteria beyond the quote. DB scope resolved by
investigation, not by the request.
