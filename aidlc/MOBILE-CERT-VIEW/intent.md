# Intent — MOBILE-CERT-VIEW

> Trello card #180 (https://trello.com/c/vFcMvcqf), board Scrum, list Sprint Backlog. No Jira ticket.
> Quoted from the card, then the developer's two answers from chat on 2026-11-10.

## 1. Ticket

| Field | Value |
| --- | --- |
| Ticket | `NOT ON JIRA` (Trello #180; working id `MOBILE-CERT-VIEW`) |
| Title | Mobile app: view and download certificates |
| Type | Task |
| Due | 2026-11-16 |
| Card member | Abdul Muazzam |
| Captured by | Claude Code, from the Trello card and haris |

## 2. Business intent

Quote: "Let users view and download certificates in the mobile app."

## 3. Definition of done, as the card states it

- A certificate opens on the phone and can be downloaded or shared.
- A user only sees the certificates they are allowed to see.
- A missing certificate shows a clear message.
- Done when tested on a real phone.

## 4. Decisions already made (developer, chat, 2026-11-10)

- Q1 (which certificates): employee certificates only for now. Asset/crane certificates are out.
- Q2 (who sees them): the logged-in employee sees only their own. No crew view, no office-staff view in the mobile app.
- Certificates are not shown in the progress-tracking module; employee mobile only.

Status: developer statements, not client rulings. Vault sources are all `unverified`/`reference` (see spec).

## 5. In scope

- Field worker persona, Menu > My Certifications (`apps/mobile/app/(field)/menu/certifications.tsx`).
- Opening a certificate document via presigned S3 links (`GET /attachments/:id/links`).
- Clear message for a certification with no document.

## 6. Out of scope

- Asset / crane certificates. Crew-wide or office-staff certificate views.
- Web, progress tracking, renewal-upload flow, expiry thresholds.

## 7. Surfaces touched

| Surface | Touched |
| --- | --- |
| `apps/mobile` | yes |
| `apps/api` | to be decided in spec (only if the response shape needs a flag) |
| `apps/api/prisma`, `apps/web`, `packages/shared` | no, unless spec says otherwise |

## 8. Known state of the code (read, not run)

Screen, `GET /me/certifications`, and presigned open-via-share-sheet already exist. Gaps: no in-app preview; certifications without a file show no message; view/share/download is one button.

## 9. Capture completeness

Thin card. Open points go to spec §12.
