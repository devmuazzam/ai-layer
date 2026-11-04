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

## 2. Known baseline, as of 2026-10-21 (`main` at `27390de69`)

**0 lint errors on every project** — the 37 `apps/web` errors of 2026-08-19 are gone. Warnings
only (`@tcg/api` ~712). So on a branch from current `main`, **a lint error is yours**.
`@tcg/api` lint and build need `NODE_OPTIONS=--max-old-space-size=4096` on an 8 GB machine;
a heap-out-of-memory crash is not a lint failure. **Re-measure rather than trusting this
line** — it is a snapshot and the point of the skill is not to need it.

## 3. Know which projects actually run, and where

- `pnpm lint` → `pnpm nx run-many -t lint` — all four projects, **cached**. A replayed cache
  hit prints the old result; when in doubt `pnpm nx run @tcg/web:lint --skip-nx-cache`.
- `pnpm lint:local` → `nx run-many -t lint -p @tcg/shared @tcg/api`. Both are real ESLint now
  (`@tcg/shared` got a config in the Nx merge). It passing still says nothing about web or
  mobile.
- No `lint` script mutates the tree any more; the `lint:fix` targets do, and are `cache: false`.
  `lint-staged` in the pre-commit hook **does** run `eslint --fix` + Prettier on your staged
  files — re-read `git diff --staged` after a commit attempt.
- **The pre-push hook and PR CI (`.github/workflows/affected.yml`) run
  `nx affected -t lint --exclude=@tcg/web`** and `typecheck --exclude=@tcg/mobile`. So a web
  lint error or one of mobile's two pre-existing TS2339s never blocks a push or a PR — which is
  exactly why the baseline above keeps growing. Run `pnpm web:lint` yourself before you hand back.

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
