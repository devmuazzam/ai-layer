---
name: lint-triage
description: Work out which lint or build failures are yours and which were already broken. Use when pnpm lint or pnpm build fails, before committing, or when a gate blocks a push.
---

`pnpm lint` fails on this repo **before you change anything**. Every developer and every
agent hits that and has to work out whether a failure is theirs. This does it in one step.

Getting it wrong is expensive in both directions: chasing someone else's error wastes an
afternoon, and dismissing your own as "pre-existing" ships a defect.

## 1. Get the baseline, then compare

```bash
git stash -u                                  # or: git switch --detach origin/main
pnpm --filter @tcg/web exec eslint src/ -f json -o /tmp/lint-base.json
git stash pop                                 # or: git switch -

pnpm --filter @tcg/web exec eslint src/ -f json -o /tmp/lint-now.json
```

Then diff by `file:line:rule` rather than by count — counts shift when lines move, which
makes an unchanged file look guilty.

```bash
node -e '
const load = f => require(f).flatMap(r =>
  r.messages.filter(m => m.severity === 2)
   .map(m => `${r.filePath.split("/apps/web/")[1]}:${m.line} ${m.ruleId}`));
const base = new Set(load("/tmp/lint-base.json"));
const now  = load("/tmp/lint-now.json");
const mine = now.filter(x => !base.has(x));
console.log(`total ${now.length}, pre-existing ${now.length - mine.length}, MINE ${mine.length}`);
mine.forEach(x => console.log("  " + x));
'
```

## 2. Known baseline, as of 2026-08-11

`apps/web` carried **14 errors** before any recent work:

| Rule | Count | Where |
| --- | --- | --- |
| `no-magic-numbers` | 10 | `features/permits/components/print/*` |
| `complexity` | 2 | `permits-listing.tsx:73`, `print/permit-print-model.ts:169` |
| `max-lines-per-function` | 1 | `print/permit-print-document.tsx:160` |
| `max-lines` | 1 | `print/permit-print-document.tsx:301` |

If your failures are in `features/permits/components/print/`, suspect the baseline first.
**Re-measure rather than trusting this table** — it is a snapshot and the point of the skill
is not to need it.

## 3. Know which workspaces actually run

- `pnpm lint` → `pnpm -r lint`, every workspace.
- `pnpm lint:local` → `@tcg/shared` then `@tcg/api`. **`@tcg/shared`'s lint is
  `echo "no lint configured yet"`**, so `lint:local` covers `apps/api` alone. It passing
  tells you nothing about web or mobile.
- `apps/api`'s lint script runs `eslint src/ --fix` — it **mutates your working tree**.
  Check `git status` after running it.

## 4. What lint does not check

A green run is much weaker evidence than it looks. Nothing enforces module boundaries,
cross-file duplication, hardcoded colours, or component reuse, and `any` is a warning on all
three surfaces. Passing lint is not evidence a convention was followed.

## 5. Report it, always split

Never write "lint fails" without the split. It wastes the reader's time and trains everyone
to ignore the gate:

```
Gates: lint FAIL — 14 pre-existing (apps/web, permits/print), 2 mine
         src/features/quotations/utils/foo.ts:41 no-magic-numbers
         src/features/quotations/utils/foo.ts:58 complexity
       build PASS
```

**Never `--no-verify`.** If a gate genuinely must be bypassed, say so out loud and say why.
