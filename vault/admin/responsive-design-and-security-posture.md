---
title: Responsive design and security posture — CodingCops technical response, March 2026
source: shared-folder/Project-Repository-2026-09-04/1.2.1_TECHNICAL-SPECS/CRANEGUYS_Responsive Design & Security Posture.docx
migrated: 2026-09-04
updated: 2026-03-09
status: unverified
conflicts_with: []
jira: []
tags: [module/admin, kind/source, architecture, authentication, permissions-roles, integrations, compliance]
entities: []
---

# Responsive design and security posture — CodingCops technical response, March 2026

**What this is.** A three-part technical response written by the CodingCops development team on
**9 March 2026** — the same day the engagement started — addressed to **Brian** (Brian Petros,
TCG's ERP project coordinator), answering a set of client questions about mobile responsiveness,
security, and the Samsara integration.

**Why it matters.** It is the earliest written statement of the platform's actual technology
choices and security model, and of what the team had committed to TCG about them. It also records
three operational facts about Samsara that came from TCG and are not written down anywhere else in
the vault.

> **Status caution.** This is a **vendor's answer to a client's questions**, written at the start
> of the build. It describes what the codebase did in March 2026 and what the team intended. It is
> not a specification and not a current architecture record — the platform has moved since. Do not
> cite it for how the system works today; cite it for what was promised, and check the code.

---

## Part 1 — Mobile-first responsive design

The response confirms the architecture "already aligns with every point raised". Its claims:

- **Mobile-first CSS.** Next.js 16 + Tailwind CSS v4; utilities apply to the smallest viewport by
  default and breakpoints use `min-width` queries. Text renders at **16px on mobile** to prevent
  iOS auto-zoom on focus.
- **Flexbox/grid with wrapping.** Cards and form containers start at 100% width and cap at
  **448px**. The component library is shadcn/ui (**New York style**), with responsive overrides
  composed through a `cn()` utility built on clsx + tailwind-merge.
- **Breakpoints.** Tailwind v4 defaults — `sm` 640 · `md` 768 · `lg` 1024 · `xl` 1280 · `2xl` 1536 —
  which the response notes exceeds the client's stated minimum of 768px and 1280px.
- **Fluid units.** No hardcoded pixel widths on layout containers; rem-based spacing; radii and
  spacing as CSS custom properties in `globals.css`.
- **No horizontal scroll.** `box-sizing: border-box` globally via Tailwind preflight; components
  constrained with `w-full` and max-width utilities.
- **Touch targets.** Button variants: default `h-9 px-4 py-2` (36px), `lg` `h-10 px-6` (40px),
  `icon` `size-9` (36×36). The response **commits to an audit** against the WCAG 2.1 minimum of
  **44×44px** and to increasing input tap areas via padding on mobile — stated as future work,
  not as done.

## Part 2 — Security posture

### Dependencies

The response tabulates the libraries chosen and their weekly download counts as evidence of
maturity: shadcn/ui (Radix UI) · Tailwind CSS v4 · Lucide React · Axios · React Hook Form · Zod
and class-validator · TanStack React Query · Passport.js + `@nestjs/jwt` · bcryptjs · **Prisma
ORM**.

Vetting: `npm`/`pnpm audit` in CI; `pnpm-lock.yaml` pinning exact versions against supply-chain
drift; Husky pre-commit hooks and lint-staged as quality gates. Major framework updates evaluated
quarterly, security patches prioritised, with an intention to integrate **Dependabot or Snyk**.

### Authentication and access control

A **custom JWT system, not a third-party identity provider**, with a dual-token architecture:

| Token | Lifetime | Web storage |
| --- | --- | --- |
| Access token | 15 minutes | NextAuth |
| Refresh token | 7 days | NextAuth |

- Refresh tokens are **bcrypt-hashed (12 salt rounds) before database storage**, so a database
  breach would not expose usable tokens. On logout the stored hash is nullified server-side,
  invalidating the session immediately.
- Passwords: bcrypt at 12 salt rounds, minimum 8 characters enforced client- and server-side; only
  `passwordHash` is stored.
- **RBAC — "for now three roles are defined: CUSTOMER, HR and ADMIN."** Every API route is
  protected by default through global guards (`AccessTokenGuard`, `RolesGuard`); public routes must
  opt out explicitly with `@Public()`; admin endpoints require `@Roles(Role.ADMIN)`. The response
  is explicit that **authorization is always enforced server-side and front-end checks are
  cosmetic only**.

> These three roles do not match the three named in the Sprint 1 acceptance criteria written three
> days earlier — Admin, Sales Person, Customer
> ([codingcops-sow-and-engagement-terms.md](codingcops-sow-and-engagement-terms.md)). Neither
> document reconciles them.

### Data protection

**In transit:** TLS/HTTPS enforced at the infrastructure layer via a reverse proxy (Nginx,
Cloudflare or AWS ALB — stated as a choice not yet made); CORS locked to one allowed origin per
environment; **Swagger disabled in production**.

**At rest:** bcrypt-hashed passwords and refresh tokens; **UUID primary keys rather than sequential
integers, to prevent enumeration**; timezone-aware timestamps (`timestamptz`).

**Response sanitisation:** a `sanitizeUser()` utility strips `passwordHash` and `hashedRt` from
every user object before it reaches an API response.

### Input validation and common vulnerabilities

A global `ValidationPipe` with `whitelist: true` (strips undeclared properties),
`forbidNonWhitelisted: true` (rejects unknown properties) and `transform: true`. class-validator
DTOs on every endpoint; Zod schemas via react-hook-form on the front end mirroring server rules,
with the server as the authoritative validator.

- **SQL injection** — Prisma generates parameterised queries exclusively; "raw SQL is never used".
- **XSS** — React 19 / Next.js 16 escape rendered content; `dangerouslySetInnerHTML` not used.
- **CSRF** — Bearer-token auth rather than cookies, so cross-origin form submissions cannot forge
  a request.
- **Environment validation** — `JWT_ACCESS_SECRET`, `JWT_REFRESH_SECRET`, `DATABASE_URL`, `PORT`
  and `CORS_ORIGIN` are validated at startup with Joi; the app refuses to start if any is missing
  or malformed. *(Names only — no values appear in the source.)*

### API security

Endpoints namespaced under `/api/v1/` with URI versioning. JWT secrets loaded only from
environment variables with a minimum length enforced by the startup schema; Docker Compose refuses
to start containers without them. **Silent token refresh** on both web and mobile: a 401 queues
the failed request, triggers a refresh, and replays the queue on success; refresh failure logs the
user out; auth endpoints are excluded from retry to prevent infinite loops. In the Docker
deployment all services share a private network (`tcg-network`) and the database is not exposed
publicly.

### Planned enhancements (stated as not yet done, March 2026)

| Enhancement | Description | Priority |
| --- | --- | --- |
| HTTP security headers | `helmet` for CSP, HSTS, X-Frame-Options, X-Content-Type-Options | High |
| Rate limiting | `@nestjs/throttler` on auth endpoints against brute force | High |
| Automated dependency scanning | Dependabot or Snyk in CI | Medium |
| Structured audit logging | Log login, logout and failed attempts | Medium |
| Production request logging | Structured JSON logging instead of Morgan dev format | Medium |

## Part 3 — Samsara integration

Written as a response to a TCG briefing on how Samsara is used. Four facts here come from TCG and
are recorded nowhere else in the vault:

- **Cross-departmental usage.** Samsara is used across **dispatch, payroll, accounting and
  safety**, all relying on vehicle location history, dash-cam imagery, and mileage/hours tracking.
- **Existing FCC integration.** The current FCC integration pulls mileage via API, stored across
  the tables `FMS_TELEMATICS_PROVIDER_MASTER`, `FMS_TELEMATICS_PROVIDERS_ERRORLOG` and
  `FMS_GPS_ATTRIBUTES`.
- **Mileage accuracy is a known problem.** The mileage data in FCC is inaccurate "to the point that
  the Maintenance department is entering mileage manually".
- **Dual-engine cranes.** Mobile cranes have a drive engine and a separate crane-operation engine.
  Whether the tracking devices report on one or both **was an open question** at the time of
  writing; the response commits to investigating it, since road mileage and crane operation hours
  both depend on the answer.

**Access.** At the time of writing CodingCops had no Samsara credentials — the document says a
login or API token was to come from **Patrick** (Patrick McKiernan, TCG IT Manager), and that no
blockers were foreseen.

---

## Source

`1.2.1_TECHNICAL-SPECS/CRANEGUYS_Responsive Design & Security Posture.docx` — 13.3 KB as converted
text, pandoc GFM, three parts plus a planned-enhancements table. **No secrets, tokens or
credentials appear in the source** — only environment-variable names, reproduced above.
