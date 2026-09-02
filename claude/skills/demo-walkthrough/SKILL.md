---
name: demo-walkthrough
description: Run or maintain the fresh-tenant demo — the full quotation-to-payroll path with every pre-req, URL, sidebar location and edge case. Use when demoing the platform, onboarding someone to what it does end to end, setting up a clean tenant, or checking whether a merged ticket has made the walkthrough wrong.
---

The whole platform, one tenant, zero data, ending in an exported payroll file.

**The runbook is [WALKTHROUGH.md](WALKTHROUGH.md)** — 13 phases, every URL, every sidebar path,
what to verify at each step, and the edge cases and known defects worth showing on purpose. Read it
there; this file is the router and the maintenance contract.

---

## This is not product memory

`WALKTHROUGH.md` describes **what the code does today**, read off the source tree and a running
instance. That makes it the exact opposite of vault content, and the distinction is load-bearing:

| | `WALKTHROUGH.md` | `vault/<module>/` |
| --- | --- | --- |
| Answers | *how do I make it do the thing?* | *what is it supposed to do?* |
| Derived from | the code | human decisions, sources, meetings |
| Safe to spec from | **never** | yes, with its caveats |

`close-ticket` → *The one thing this never does* forbids shipped behaviour becoming product memory.
Keeping this file current does not bend that rule — it lives in `claude/skills/`, and nothing here
is ever cited as a requirement. **If a demo turns up a question about intent, it goes in the
module's `gaps.md`, not in this file.**

---

## Using it

Two modes, and they want different things from you.

**Running a demo.** Work Appendix C (the pre-req checklist) first, in a real tenant, the day before
— not live. Half the checklist is things that fail *later*: a missing craft code blocks employee
creation four phases on; a flat resource tree silently kills boom pay two phases on and cannot be
repaired once tickets are sent. Then follow phases 1→13 in order.

**Showing someone the system.** Phases 8→13 (quotation → job → DAS → mobile ticket → payroll) are
the spine and stand alone on a tenant that already has data — e.g. `TCG-DEFAULT`. Phases 1→7 are
setup and are only interesting if the audience asks "what does it take to onboard a customer?"

**Either way, read Appendix A before you start.** Reporting, Payroll ▸ Rules Configuration, ADP
Payroll Files and Audit Log are placeholders; the mobile sales and dispatch personas are mock-only;
mobile *My Labor* is a hardcoded fixture. Discovering those live is avoidable.

---

## Keeping it true

**`close-ticket` step 5 is the mechanism.** A merged ticket that touches any of these makes some
part of this file wrong, and a wrong runbook is worse than none — it sends someone to a URL that
404s, or has them demo a bug that was fixed last sprint.

| A ticket that changed… | Makes stale |
| --- | --- |
| `apps/web/src/app/(protected)/**` | the URL in that phase |
| `apps/web/src/components/sidebar/**` | §1.3's sidebar map and every "Sidebar:" line |
| a form schema (`*-form.ts`, `*.schema.ts`) | the required-fields lists in phases 4–8 |
| `packages/payroll-engine/**`, `usecase/payroll/**` | phase 13's expected numbers, and Appendix B |
| seeding, tenant provisioning, env vars | phase 0 and Appendix C |
| **a fix for anything in Appendix B** | **that row — strike it, don't leave it** |

The last one is the one that rots quietest. Appendix B goes stale in the *good* direction: bugs get
fixed and nobody remembers the runbook still lists them. A defect list that cries wolf gets ignored
wholesale, which loses the ones that are still real.

**Struck rows do not silently vanish.** Move them to Appendix B's *Fixed* table with the PR number,
so the next reader can tell "fixed" from "never happened" — and so a regression is recognisable as
a regression.

---

## Its own limits

- **Local dev only.** Ports, seeded logins (`superadmin@tcg.com` / `Admin@1234`) and the SES
  workaround in §0.3 are dev-environment facts. It has never been run against staging or prod.
- **The payroll numbers in phase 13 are from one measured run** on `TCG-DEFAULT` (see
  `E2E_PAYROLL_FLOW_REPORT.md` in the main repo). They are illustrative of the *shape* of the
  defect, not a fixture your tenant will reproduce to the cent.
- **`FCC Sync` is untested here.** §1.1 says it exists and warns it wipes the tenant; nobody has
  run it as part of this walkthrough.
- **Some edge cases are code-read, not live-run** — they say so inline where that is true.
