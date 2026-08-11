# Is this working?

How to tell whether the AI layer is earning its keep, in a way that does not rely on anyone
remembering how things felt.

Two parts: **numbers you can re-run**, and **signals you have to read**. The numbers cannot
tell you whether the discipline is working, and the signals cannot be faked into a
spreadsheet. Both are needed.

---

## 1. Baseline — measured 2026-08-12

Every command below runs from the client repo root and is copy-pasteable. Re-run them
monthly, or before any claim that things improved.

```bash
# Layering, RUNTIME: usecase services constructor-injecting presentation gateways
grep -rln "from '@presentation/.*gateway'" apps/api/src/usecase --include='*.service.ts' | wc -l

# Layering, RUNTIME: repositories importing executable helpers from usecase
grep -rn "^import {" -A6 apps/api/src/service/vendors/vendors.repository.ts \
  apps/api/src/service/employee/employee.repository.ts | grep -c "buildVendor\|buildEmployee"

# Layering, TYPE-LEVEL: usecase services importing presentation DTOs
grep -rln "from '@presentation/.*dto" apps/api/src/usecase --include='*.service.ts' | wc -l

# Layering, TYPE-LEVEL: repositories importing upward at all
grep -rln "from '@presentation\|from '@usecase" apps/api/src/service | wc -l

# Layering: shared components importing from features (dependency inversion)
grep -rln "from '@/features" apps/web/src/components | wc -l

# Theming: hardcoded hex colour utilities
grep -rlE "(text|bg|border|from|to|via)-\[#[0-9a-fA-F]{3,8}\]" apps/web/src --include='*.tsx' | wc -l
grep -rhoE "(text|bg|border|from|to|via)-\[#[0-9a-fA-F]{3,8}\]" apps/web/src --include='*.tsx' | wc -l

# Duplication: private re-declarations of one helper
grep -rc "^const formatInternalId" apps/api/src --include='*.ts' | grep -v ':0' | wc -l

# Product debt: open questions nobody has answered
grep -c '^- Status: open' .ai/vault/gaps.md
```

| Metric | 2026-08-12 | Severity | Direction |
| --- | --- | --- | --- |
| Usecase services injecting presentation **gateways** | **9** | runtime inversion | down |
| Repositories importing **executable helpers** from usecase | **2** | runtime inversion | down |
| Usecase services importing presentation **DTOs** | **35** | type-level only | flat is fine |
| Repositories importing upward (any kind) | **6** | 2 runtime, 4 type-only | down to 4 |
| Shared components importing features | **16** | runtime | down |
| Files with hardcoded hex | **113** | — | down |
| Hardcoded hex occurrences | **593** | — | down |
| `formatInternalId` copies | **7** | — | down |
| Open gaps | **13** | — | **not necessarily down** — see §3 |

**Do not read these as a scorecard.** They are the standing debt the layer was built to stop
*growing*. The first honest success is that they hold flat while features ship. Falling is a
later, separate win that belongs to the revamp.

### Why the layering rows are split — a correction

An earlier version of this file reported **"38 services importing upward"** and **"6
repositories importing upward"** as single violation counts. That was one grep labelled as a
finding. Reading the imports splits them into two categories with very different cost:

**Runtime inversion — 11 files.** Nine usecase services import a WebSocket gateway from
`@presentation` and take it as a **constructor parameter of an `@Injectable()` class**
(`jobs.service.ts:82-83`), so Nest's DI resolves it and the module graph carries a real edge
from usecase up to presentation. `DasGateway` accounts for eight of them; `JobsGateway` and
`NotificationsGateway` one each. Two repositories do the same in effect, importing *executed*
query builders rather than types — `buildVendorActivityAllocationWhere` and
`vendorActivityAllocationSelect` in `vendors.repository.ts:6-9`, `buildEmployeeListOrderBy`
and `buildEmployeeListWhere` in `employee.repository.ts:12-18`. **These are the violations.**

**Type-level coupling — 35 services, 4 repositories.** Everything else is a DTO or a type
alias used in a method signature. `tsconfig.base.json:17` sets `emitDecoratorMetadata`, so a
class in a *constructor* parameter survives to runtime — but these appear in ordinary
undecorated methods (`plans.service.ts:285`), where TypeScript elides the import at emit.
They compile away. The coupling is real — usecase cannot be lifted out without presentation's
`dto/` folders — but it is a DTO-placement question and a common NestJS layout, not a
runtime dependency, and treating it as equivalent to the nine overstates the problem by 4×.

**The rail in §5 must encode this distinction.** `import/no-restricted-paths` applied naively
flags all 44 at once. Nobody triages 44 errors; they disable the rule, and the nine that
matter go with it. Ban value imports across the boundary, allow `import type`, and the rule
lands on 11 real findings.

### One that is a live bug, not a baseline

`apps/web` does not glob its tests — `package.json` lists filenames explicitly. Today:

```bash
node -e "
const p=require('./apps/web/package.json');
const listed=new Set((p.scripts.test.match(/src\/[^ ]+\.test\.mjs/g)||[]));
const all=require('child_process').execSync(\"find src -name '*.test.*'\",{cwd:'apps/web'}).toString().trim().split('\n');
console.log('listed:',listed.size,'exist:',all.length);
all.filter(f=>!listed.has(f)).forEach(f=>console.log('  NEVER RUN: '+f));
"
```

**17 test files exist, 14 run.** These three have never executed:

- `src/features/assets/asset/utils/meter-reading-changes.test.mjs`
- `src/features/quotation-signatures/components/send-quotation-modal.helpers.test.mjs`
- `src/features/activity-logs/components/activity-log-sentence.test.mjs`

Someone wrote them, they passed review, and they run nothing. Fix the runner before trusting
any web coverage claim.

---

## 2. Leading signals — visible within days

These tell you the layer is *reaching* people. Read them off real artifacts, not from
opinion.

**Is the context loading at all?** In the Claude Code chat, not a terminal:

```
read apps/api/src/main.ts
/context
```

`apps/api/CLAUDE.md` under **Memory files** means nested contexts load. Still unconfirmed as
of writing, and it is the cheapest open question here.

**Do specs cite sources with status tags?** Open any `spec.md`. Requirements should carry a
vault path and `[VERIFIED]`/`[UNVERIFIED]`. Assertions without them mean the elaborator is
being ignored or bypassed.

**Do `[OPEN]` markers appear at all?** A spec with zero open questions on a thin ticket is a
**red flag, not a win**. The vault is mostly unverified; a spec that found nothing to ask
either got a genuinely well-specified ticket or quietly guessed.

**Does `gaps.md` grow?** If it never grows, either every question is being answered — which
is implausible — or people are filling gaps silently, which is the failure the whole layer
exists to prevent.

**Are PRs unit-sized?** One unit, one branch, one PR. A 40-file PR means decomposition was
skipped or the units were not vertical.

---

## 3. Counter-signals — how this dies

Each of these is more likely than outright rejection, and each is quiet.

**People stop using it for bugs.** The most likely failure by a distance. If the full loop
gets run on a one-line fix, it will be abandoned within a fortnight — which is why the
triage in [`aidlc/GUIDE.md`](aidlc/GUIDE.md) exists. Watch for the opposite too: everything
being classed a "small change" to skip inception.

**`gaps.md` grows and nobody answers.** Then you have built an excellent machine for
generating unanswered questions. **The count going up is only good if the count also comes
down.** Track both directions; a rising count with no resolutions is worse than no register.

**Reviews blend verified and inferred again.** If findings stop naming the command that
established them, the review is back to assertion with `file:line` precision attached. This
document did it in its own first draft — see §1's correction, where a grep count was labelled
a violation count without anyone reading the imports. A number is evidence; the word for what
it means is a claim, and the two need separate justification.

**A doc contradicts a doc.** This layer has already reintroduced that failure four times in
one day — root versus context on the web architecture, templates asserting a deleted
convention, a duplicated README block, a stale rename. Expect it. The check is in §5.

---

## 4. The sharpest test

The layer's core claim is that **stopping instead of guessing is cheaper than guessing and
fixing it later.** That is falsifiable:

> Does an `[OPEN]` marker ever get answered, and turn out to have mattered?

- If every open question resolves to something trivial, the discipline is overhead. Cut it
  back — fewer required fields, more Path B and C.
- If **one** prevents a wrong migration, a tenant leak, or a threshold shipped at the wrong
  value, it has paid for the entire build.

You will know inside two or three tickets. Record the answer either way, in the reflection
for the ticket that produced it.

---

## 5. What would make the numbers hold — the missing rails

The layer's own finding is that **a rule nothing enforces is not a rule.** Everything in §1
is currently guarded by convention and by agents remembering. Five rails would convert
reminders into mechanism, each hours rather than days:

| Rail | Closes | Priority |
| --- | --- | --- |
| A test asserting every model with `tenantCompanyId` is in the `$extends` allowlist | **tenant leaks** — silent, invisible to every gate, data-exposure class | **first** |
| `import/no-restricted-paths` (or `boundaries/*`) on the API layers, **value imports only — `import type` allowed** | the 11 runtime inversions; see §1's correction for why the naive version fails | high |
| Glob the `apps/web` test runner | 3 tests that never run, and every future one | high — cheapest of the five |
| Pre-commit: `schema.prisma` changed → migration staged | incomplete schema changes | medium |
| Lint rule for hex literals in `.tsx` | the 593 | medium |

The tenancy one first, because `tcg-prisma-guardian` currently guards a data-leak class by
asking an agent to remember, and that is the definition of a reminder where a rail belongs.

**A drift check for the layer itself**, given §3's last item:

```bash
# dead references in live files
grep -rn "claude/rules/\|claude/design/\|skills/new-feature" \
  .ai/README.md .ai/aidlc/GUIDE.md .ai/aidlc/templates/ .ai/aidlc/agents/ .ai/claude/

# broken markdown links, layer-wide
cd .ai && for f in $(find . -name '*.md' -not -path './.git/*'); do
  grep -oE '\]\([a-zA-Z0-9._/-]+\.md\)' "$f" | tr -d '](' | tr -d ')' | while read -r t; do
    [ -e "$(dirname "$f")/$t" ] || echo "BROKEN: $f -> $t"; done; done
```

Both should return nothing. The first catches paths that moved; only reading catches a claim
that went stale while still resolving.

---

## 6. Review cadence

**After the first real ticket** — did the spec have open questions worth asking? That single
answer decides more than a month of metrics.

**Monthly** — re-run §1, check `gaps.md` in both directions, run the §5 drift check.

**On the third occurrence of anything** — that is `tcg-reflector`'s escalation threshold, and
it applies to this document too. A metric that moves the wrong way three months running is
not a reminder problem.

---

## 7. Honest state at time of writing

- The loop has **never run a real ticket end to end.** Written is not working.
- Nested-context loading is **unconfirmed by observation**. `/context` settles it in seconds.
- Antigravity's loading behaviour is **unestablished**.
- **None of the five rails in §5 exists.** Every convention in §1 is enforced by nothing.
- The sync spec is written and **blocked on a named owner**, not on code.
