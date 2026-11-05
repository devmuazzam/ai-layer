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
