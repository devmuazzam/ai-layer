---
title: Domain — process index
status: reference
kind: index
updated: 2026-09-04
tags: [module/all, kind/reference]
---

# Domain

Process, method and glossary. `domain/` is one of the vault's **cross-cutting folders** — it is not
a product module, so it takes no `module/<name>` folder position and its files are routed to by
tag. See [STRUCTURE.md](../STRUCTURE.md).

Three kinds of thing live here, and confusing them is the mistake to avoid:

1. **The vendor's delivery process** — the six SOPs migrated from Confluence TPD. These are the
   **only `verified` files in the vault**.
2. **The client's own process** — TCG IT's value engines and playbooks, and the house
   process-mapping method they are written in. Added 2026-09-04. `unverified`.
3. **Glossary** — what a term means. Currently one entry.

## Files

| File | Answers | KB |
| --- | --- | --- |
| **1 — Vendor delivery process (`verified`)** | | |
| [development-process-sop.md](development-process-sop.md) | What is our full SDLC, from planning to monitoring? | 6.1 |
| [sprint-planning-sop.md](sprint-planning-sop.md) | How is sprint planning meant to run? | 6.3 |
| [daily-scrum-sop.md](daily-scrum-sop.md) | How is the daily standup meant to run? | 4.6 |
| [backlog-grooming-sop.md](backlog-grooming-sop.md) | How is refinement meant to run? | 4.0 |
| [sprint-closing-sop.md](sprint-closing-sop.md) | How does a sprint get formally closed? | 4.5 |
| [jira-sop.md](jira-sop.md) | What must a ticket contain before it enters a sprint? | 3.5 |
| **2 — Client process and method (`unverified`)** | | |
| [value-engines-and-playbooks-method.md](value-engines-and-playbooks-method.md) | What *is* a value engine and a playbook? The symbol set, the five-step mapping process, and how one is authored. **Read this before reading any value engine.** | 9.5 |
| [tcg-it-value-engines-and-playbooks.md](tcg-it-value-engines-and-playbooks.md) | How does TCG IT say software work should flow — intake, build-vs-buy, discovery, security review, QA, release — and how does that meet our SOPs? | 17.4 |
| [wes-whiteboard-value-engines.md](wes-whiteboard-value-engines.md) | What are the four processes Wes drew on the whiteboard — AP/collections, field/safety/storage, sales-to-dispatch, payroll? **Layered provenance; read the warning.** | 15.9 |
| **3 — Glossary** | | |
| [fcc-nexgen-fms.md](fcc-nexgen-fms.md) | What are FCC, NexGen and Atom? | 3.0 |

## What is not here

- **Product behaviour.** `domain/` says how work is done, never what the product must do. A rule
  here can never make a requirement true.
- **Open questions.** `domain/` carries no `gaps.md` — the gap system is for product questions
  ([STRUCTURE.md](../STRUCTURE.md) → *Where a question goes*). Process questions belong in a
  reflection.
- **Detail on FCC NexGen.** [fcc-nexgen-fms.md](fcc-nexgen-fms.md) resolves the term; the system
  itself is documented under [../admin/](../admin/INDEX.md).
