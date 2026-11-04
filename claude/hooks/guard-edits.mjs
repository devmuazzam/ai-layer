#!/usr/bin/env node
/**
 * PreToolUse guard for Edit / Write / MultiEdit / NotebookEdit — turns two CLAUDE.md rules
 * from prose into a refusal:
 *
 *   1. Client-repo files are never edited on `main`. Branch first (`commit` skill §1);
 *      `.husky/pre-push` refuses a push of main anyway, so work there is stranded.
 *   2. AI-layer tooling is Haris-only (CLAUDE.md → "Tooling is Haris-only"): an overlay
 *      tooling path is editable only when the overlay's git user.email is Haris's.
 *
 * Exit 2 blocks the tool call and shows stderr to the model. Any failure inside the guard
 * itself exits 0 — a broken guard must never stop eight people from editing.
 * Shell edits (sed -i, heredocs) do not pass through here; this is a rail, not a wall.
 */
import { execFileSync } from 'node:child_process';
import { existsSync, readFileSync, realpathSync } from 'node:fs';
import { basename, dirname, join, relative, sep } from 'node:path';

const TOOLING_OWNER = 'syed.haris@codingcops.com';

/** Overlay paths CLAUDE.md lists under "Tooling is Haris-only", relative to the overlay root. */
const TOOLING_PATHS = [
  /^claude\//,
  /^aidlc\/agents\//,
  /^aidlc\/templates\//,
  /^aidlc\/GUIDE\.md$/,
  /^setup\.sh$/,
  /^verify\.sh$/,
  /^README\.md$/,
];

const git = (cwd, ...args) => {
  try {
    return execFileSync('git', ['-C', cwd, ...args], {
      encoding: 'utf8',
      stdio: ['ignore', 'pipe', 'ignore'],
    }).trim();
  } catch {
    return '';
  }
};

/**
 * Real path of the file, resolving symlinks (`.claude` → `.ai/claude`) through its nearest
 * existing ancestor — the file, or even its folder, may not exist yet on a Write.
 */
const resolveTarget = (filePath) => {
  let dir = dirname(filePath);
  const tail = [basename(filePath)];
  while (!existsSync(dir)) {
    const up = dirname(dir);
    if (up === dir) return null;
    tail.unshift(basename(dir));
    dir = up;
  }
  const existingDir = realpathSync(dir);
  return { existingDir, target: join(existingDir, ...tail) };
};

const block = (message) => {
  process.stderr.write(`${message}\n`);
  process.exit(2);
};

try {
  const input = JSON.parse(readFileSync(0, 'utf8'));
  const raw = input.tool_input?.file_path ?? input.tool_input?.notebook_path;
  if (!raw) process.exit(0);

  const resolved = resolveTarget(raw);
  if (!resolved) process.exit(0);
  const { existingDir, target } = resolved;

  const top = git(existingDir, 'rev-parse', '--show-toplevel');
  if (!top) process.exit(0); // not in a git repo — scratch files, home dir

  const isOverlay = basename(top) === '.ai' || basename(dirname(top)) === '.ai-worktrees';

  if (isOverlay) {
    const rel = relative(top, target).split(sep).join('/');
    const email = git(top, 'config', 'user.email');
    if (TOOLING_PATHS.some((re) => re.test(rel)) && email !== TOOLING_OWNER) {
      block(
        `Blocked: .ai/${rel} is AI-layer tooling, which only Haris changes ` +
          `(CLAUDE.md → "Tooling is Haris-only"; overlay user.email is "${email || 'unset'}"). ` +
          'Do not edit it. Write the proposed change out for the developer to send to Haris.',
      );
    }
    process.exit(0);
  }

  const branch = git(top, 'rev-parse', '--abbrev-ref', 'HEAD');
  if (branch === 'main') {
    block(
      `Blocked: ${relative(top, target)} is in the client repo, which is on main. ` +
        'Name the ticket and its path (GUIDE.md §2), then create the branch with the `commit` ' +
        'skill — `<type>/<TICKET>-u<n>-<slug>` from origin/main — before editing. ' +
        'Pre-push refuses main, so an edit here is stranded.',
    );
  }
  process.exit(0);
} catch {
  process.exit(0);
}
