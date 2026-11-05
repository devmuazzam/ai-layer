# Proposal — make shared UI changes visible before they ripple

**Status:** applied on 2026-11-05 as written, with Umer Islam as approver and the hook set to block · **Date:** 2026-11-05 · **Decided by:** Haris (tooling owner)

## The problem

A ticket changes the design or UI of something shared, and other screens change with it. Nobody sees
the reach until QA or the client does.

- 302 shared component files. `ui/button` is imported directly by 107 files, `ui/dialog` by 85.
- 79 commits touched shared components or theme styles on staging since 1 Oct. Some were meant to be
  app-wide (TCG-133). Others rode along on a feature: the Weekly Payroll branch also loaded Inter app-wide.
- Nothing flags it. There is no CODEOWNERS file, and the E2E suite has no visual comparisons.
  `review-pr` asks for every render site, but only if someone runs it. Path C gets no `tcg-analyst`.
- `reflections/INDEX.md` has no class for it, so it can't be counted.

No GitHub Action, by Haris's decision. Screenshot tests are left out for now: they need new tests, stable
seed data and something to run them. Reconsider them if this isn't enough after two sprints.

## 1. New hook: `.claude/hooks/guard-shared-ui.mjs`

Runs when a Claude Code agent uses `gh pr create`. If the branch changed `apps/web/src/components/` or
`apps/web/src/styles/`, and the PR text has no "Shared UI changed" section, it refuses and lists the files
with their direct importers. Any error inside the hook lets the command through, like `guard-edits.mjs`.

```js
#!/usr/bin/env node
// PreToolUse (Bash). When an agent opens a PR that changes shared web UI, the PR text must say so.
// Exit 2 refuses the command and tells the agent why. Any error here lets the command through.
import { execFileSync } from 'node:child_process';
import { existsSync, readFileSync } from 'node:fs';
import { resolve } from 'node:path';

const SECTION = 'Shared UI changed';
const SHARED = /^apps\/web\/src\/(components|styles)\//;
const TEST = /\.(test|spec|stories)\.[jt]sx?$|\.test\.mjs$/;

const main = () => {
  const input = JSON.parse(readFileSync(0, 'utf8'));
  const command = input?.tool_input?.command ?? '';
  if (!/\bgh\s+pr\s+create\b/.test(command) || /\s--web\b/.test(command)) return;
  // An overlay PR says nothing about the client repo's diff.
  if (/(?:--repo|-R)[\s=]+["']?[^\s"']*tcg-ai-layer/.test(command) || /\bcd\s+["']?[^;&|]*\.ai\b/.test(command)) return;

  const cwd = input.cwd || process.cwd();
  const git = (...args) =>
    execFileSync('git', args, { cwd, encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] }).trim();

  const baseArg = command.match(/(?:--base|-B)[\s=]+["']?([^\s"']+)/)?.[1] ?? 'main';
  const isRef = (ref) => {
    try { git('rev-parse', '--verify', '--quiet', `${ref}^{commit}`); return true; } catch { return false; }
  };
  const base = isRef(`origin/${baseArg}`) ? `origin/${baseArg}` : baseArg;

  const changed = git('diff', '--name-only', `${base}...HEAD`)
    .split('\n')
    .filter((file) => SHARED.test(file) && !TEST.test(file));
  if (changed.length === 0) return;

  const bodyFile = command.match(/(?:--body-file|-F)[\s=]+["']?([^\s"']+)/)?.[1];
  const bodyPath = bodyFile ? resolve(cwd, bodyFile) : null;
  const body = bodyPath && existsSync(bodyPath) ? readFileSync(bodyPath, 'utf8') : '';
  if (command.includes(SECTION) || body.includes(SECTION)) return;

  const reach = changed.slice(0, 15).map((file) => {
    if (!file.startsWith('apps/web/src/components/')) return `- ${file}: applies across the web app`;
    const spec = file.replace('apps/web/src/', '@/').replace(/(\/index)?\.[jt]sx?$/, '').replace(/\.css$/, '');
    let count = 0;
    try {
      const pattern = `${spec}['"]`;
      count = git('grep', '-l', '-E', pattern, '--', 'apps/web/src').split('\n').filter(Boolean).length;
    } catch { /* no direct importers */ }
    return `- ${file}: imported directly by ${count} file(s); barrel imports not counted`;
  });
  if (changed.length > 15) reach.push(`- and ${changed.length - 15} more`);

  process.stderr.write(
    `This PR changes shared web UI, so its description needs a "${SECTION}" section ` +
      `(see the commit skill, section 6).\nFor each file, say what changed and which screens you checked:\n` +
      `${reach.join('\n')}\n`,
  );
  process.exit(2);
};

try { main(); } catch { process.exit(0); }
```

Add to `.ai/claude/settings.json` under `hooks.PreToolUse`:

```json
{
  "matcher": "Bash",
  "hooks": [
    { "type": "command", "command": "node \"$CLAUDE_PROJECT_DIR/.claude/hooks/guard-shared-ui.mjs\"" }
  ]
}
```

**Tested** by feeding it hook input against real history on 2026-11-05. Not yet run inside a live
Claude Code session.

| Case | Result |
| --- | --- |
| A command that isn't `gh pr create` | allowed |
| PR changing shared UI, no section | refused, files and counts listed |
| Section in `--body` | allowed |
| Section in `--body-file` | allowed |
| Nothing shared changed | allowed |
| `gh pr create --web` | allowed |
| Bad input | allowed |

**What it won't catch:** PRs from the GitHub website or a terminal, Cursor, Codex, or an agent that writes
the heading and nothing useful under it. Counts cover direct imports only, so barrel imports such as
`@/components/ui` aren't included and real reach can be higher. Mobile's shared components and theme aren't
covered; add them if this works for web. `.ai/verify.sh` may need the new hook added to its checks.

## 2. `.ai/claude/skills/commit/SKILL.md`

Change the description, adding "opening a pull request":

```diff
-Use when starting work on a unit, before pushing, or when asked to commit, stage, or write a commit message.
+Use when starting work on a unit, before pushing, when opening a pull request, or when asked to commit, stage, or write a commit message.
```

Add to §6, after the _Siblings_ bullet:

```markdown
**A PR that changes `apps/web/src/components/` or `apps/web/src/styles/` also carries:**

## Shared UI changed
| File | What changed | Screens checked |
| --- | --- | --- |
| `ui/button` | new variant only, existing screens unaffected | Quotations, DAS |

A Claude Code hook refuses `gh pr create` without this section. "Screens checked: not checked" is an
acceptable answer; a missing section is not.
```

## 3. `.ai/claude/contexts/web.md`

Add before _Misc_:

```markdown
## Shared UI — a ticket changes only its own screens

If a ticket needs a shared component or the theme to look different, add a variant or raise a separate
design ticket. A deliberate app-wide change gets its own ticket and PR, lists the screens it affects, and is
approved by Umer Islam.
```

## 4. `.ai/aidlc/reflections/INDEX.md`

Add to the class vocabulary:

```markdown
| `ui-ripple` | A change to a shared component or the theme altered screens outside its ticket, unnoticed until QA, UAT or the client |
```

## 5. Correct the pre-push docs (separate problem, found while checking)

Three tooling files say pre-push only guards `main`. Since 20 Oct 2026 (`51b07fc14`, `20291a8d0`) it also
runs `scripts/gates.sh affected` (on main and staging), and `SKIP_GATES=1` works.

- `.ai/claude/CLAUDE.md`:121, "pre-push keeps only the `main` guard"
- `.ai/claude/skills/commit/SKILL.md`:158-159, "`SKIP_GATES=1` is a no-op"
- `.ai/aidlc/agents/construction/tcg-executor.md`:274, "block in `.husky/pre-push` is commented out"

Correct wording for `CLAUDE.md`:

```markdown
**`pre-push` refuses `main` and runs the gates on affected projects** (`scripts/gates.sh`: lint skips
`@tcg/web`, build skips `@tcg/web`). `SKIP_GATES=1` skips them. CI only deploys, so run the web checks yourself.
```

## How to tell if it worked

After two sprints, count `ui-ripple` rows and ask QA whether ripples still reach them. If they do, add
screenshot tests for a few key screens only.

## Decisions for Haris

1. **Approver for app-wide design changes:** Umer Islam is the suggested name.
2. **Block or warn:** the hook blocks until the section exists. Changing it to warn-only is a small edit,
   but agents may then ignore it.
