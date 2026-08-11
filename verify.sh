#!/usr/bin/env bash
# verify.sh — confirm the AI layer is actually wired, whatever agent you use.
#
#   bash .ai/verify.sh
#
# Run it after .ai/setup.sh, and any time an agent seems to be ignoring the rules.
# Exits non-zero if anything a tool depends on is missing, so CI can run it too.
#
# This checks WIRING — that the files exist, resolve, and are hidden from the client
# repo. It cannot check that your particular tool chose to read them; the per-surface
# notes below say what each one is documented to do.
set -uo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" \
  || { echo "ERROR: run this from inside the client repo." >&2; exit 1; }
cd "$ROOT"
AI_DIR=".ai"
PASS=0; FAIL=0

ok()   { printf '  \033[32mok\033[0m   %s\n' "$*"; PASS=$((PASS + 1)); }
bad()  { printf '  \033[31mFAIL\033[0m %s\n' "$*"; FAIL=$((FAIL + 1)); }
note() { printf '       %s\n' "$*"; }
head_() { printf '\n%s\n' "$*"; }

# resolves <path> <expected-substring> — file exists, is readable, contains the marker.
resolves() {
  local p="$1" marker="$2"
  [ -e "$p" ] || { bad "$p — missing"; return; }
  [ -r "$p" ] || { bad "$p — unreadable"; return; }
  if grep -q "$marker" "$p" 2>/dev/null; then ok "$p"; else
    bad "$p — resolves but does not contain \"$marker\""; fi
}

head_ "Overlay"
if [ -d "$AI_DIR/.git" ]; then ok "$AI_DIR/ is a git clone"; else
  bad "$AI_DIR/ is not a git clone — run the install from the README"; fi
resolves "$AI_DIR/claude/CLAUDE.md" "TCG platform"

head_ "Root entry points  (Claude reads CLAUDE.md, Cursor reads AGENTS.md)"
resolves "CLAUDE.md" "TCG platform"
resolves "AGENTS.md" "TCG platform"
if [ "$(readlink AGENTS.md 2>/dev/null)" = "$(readlink CLAUDE.md 2>/dev/null)" ] \
   || [ "$(cat AGENTS.md 2>/dev/null)" = "$(cat CLAUDE.md 2>/dev/null)" ]; then
  ok "AGENTS.md and CLAUDE.md are the same content (cannot drift)"
else
  bad "AGENTS.md and CLAUDE.md differ — they should resolve to one file"
fi

head_ "Surface contexts  (the nearest file to your edit wins)"
for pair in "apps/api:API context" \
            "apps/api/prisma:Database context" \
            "apps/web:Web context" \
            "apps/mobile:Mobile context"; do
  dir="${pair%%:*}"; marker="${pair##*:}"
  if [ -d "$dir" ]; then
    resolves "$dir/CLAUDE.md" "$marker"
    resolves "$dir/AGENTS.md" "$marker"
  else
    note "$dir/ not present in this checkout — skipped"
  fi
done

head_ "Stealth  (the layer must be invisible to the client repo)"
LEAKED="$(git status --porcelain 2>/dev/null \
  | grep -E ' (\.ai/|\.claude|CLAUDE\.md|AGENTS\.md|\.cursor/|\.codex/|\.agent/)' || true)"
if [ -z "$LEAKED" ]; then
  ok "git status shows no AI-layer paths"
else
  bad "AI-layer paths are visible to the client repo:"
  printf '%s\n' "$LEAKED" | sed 's/^/         /'
  note "fix: re-run 'bash .ai/setup.sh' — the exclude step did not complete"
fi

head_ "Skills  (Claude Code discovers these at session start)"
SKILLS="commit review-pr lint-triage find-component debug-api"
for s in $SKILLS; do
  if [ -f "$AI_DIR/claude/skills/$s/SKILL.md" ]; then ok "skills/$s"; else
    bad "skills/$s — missing"; fi
done
note "not in your agent's list? it started before these existed — restart the session"

head_ "Stale pointers  (a doc removed from the overlay must not leave a link behind)"
DANGLING=""
for f in *.md; do
  [ -L "$f" ] && [ ! -e "$f" ] && DANGLING="$DANGLING $f"
done
if [ -z "$DANGLING" ]; then
  ok "no dangling doc links at the repo root"
else
  bad "dangling at repo root:$DANGLING"
  note "these resolve to nothing; an agent following one gets an error, not a rule"
  note "fix: re-run 'bash .ai/setup.sh'"
fi

head_ "Surface mirrors  (reference copies; not the loading mechanism)"
for s in .cursor .agent; do
  if [ -d "$s" ]; then
    broken="$(find "$s" -type l ! -exec test -e {} \; -print 2>/dev/null | wc -l | tr -d ' ')"
    if [ "$broken" = "0" ]; then ok "$s — no dangling links"; else
      bad "$s — $broken dangling link(s); re-run 'bash .ai/setup.sh' to prune"; fi
  else
    note "$s/ not present — fine unless you use that tool"
  fi
done

head_ "What your agent will read"
cat <<'EOF'
  Claude Code   root CLAUDE.md, plus the nearest apps/*/CLAUDE.md as you work.
                VERIFIED.
  Cursor        root AGENTS.md, plus the nearest apps/*/AGENTS.md. VERIFIED.
                Cursor ignores .md in .cursor/rules — only .mdc is read there,
                which is why this layer does not use that path at all.
  Antigravity   UNVERIFIED. Both root entry files and both nested filenames are
                present, and .agent/{agents,contexts} mirror the content, so it
                is reachable — but which of those it loads on its own has not
                been confirmed. To check: open a file under apps/api/ and ask it
                something only contexts/api.md answers, e.g. "how many global
                guards does this API register, and which?" (four:
                AccessToken, Roles, Permissions, Throttler). If it cannot say,
                point it at .ai/claude/CLAUDE.md explicitly.
EOF

head_ "Known stale docs in the CLIENT repo  (not ours to delete)"
if [ -f "ATOMIC_DESIGN_SYSTEM.md" ]; then
  note "ATOMIC_DESIGN_SYSTEM.md — describes atomic design as the web architecture."
  note "  contexts/web.md contradicts it and was measured against the codebase."
  note "  Harmless if your agent reads the context; a wrong answer below means it did not."
else
  ok "no known stale client docs present"
fi

head_ "Essence test  (wiring is not comprehension — ask your agent these)"
cat <<'EOF'
  TWO TIERS, and they must be kept apart. Tier A is answerable from the root
  CLAUDE.md alone; Tier B is answerable ONLY from a nested surface context.
  Passing A tells you the root loaded. It tells you NOTHING about the nested
  files — an earlier version of this test conflated them and read a root-only
  pass as full coverage.

  TIER A — proves the root loaded
  1. "Which NestJS and Prisma major versions is this on?"
       stale   NestJS 10, Prisma 5          correct  NestJS 11, Prisma 7
  2. "Is every query automatically tenant-scoped?"
       stale   yes, Prisma middleware       correct  no — a $extends extension
  3. "How is apps/web organised?"
       stale   atomic design hierarchy      correct  feature-first; not atomic

  TIER B — proves a NESTED context loaded. These facts appear in no other file.
  4. "How many global guards does the API register, and which?"
       correct four — AccessToken, Roles, Permissions, Throttler
       ................................. ONLY in contexts/api.md
  5. "Which components directory has the most importers, and how many?"
       correct components/ui — 308. And components/application has zero.
       ................................. ONLY in contexts/web.md
  6. "Name the three cases where tenant scoping is skipped."
       correct no request context; SUPER_ADMIN; model absent from the allowlist
       ................................. ONLY in contexts/prisma.md
  7. "What styling API does mobile use?"
       correct StyleSheet.create with theme/tokens.ts — not Tailwind; 48px targets
       ................................. ONLY in contexts/mobile.md

  CHECK THE LOADING MECHANICALLY FIRST — do not start with the questions.

    Claude Code:  cat apps/api/src/main.ts     # reading a file is the trigger
                  /context                      # look under "Memory files"

    /context reports which instruction files actually loaded. It is an
    observation, not a self-report, so it beats asking the model — and asking
    a model what is in its own context is the one method that cannot be
    trusted for this.

    For a permanent record, the InstructionsLoaded hook logs which instruction
    files load, when, and why. See the Claude Code hooks documentation.

  WHY READING A FILE IS THE TRIGGER — confirmed in Claude Code's own docs:
  subdirectory CLAUDE.md files are "included when Claude reads files in those
  directories" rather than at launch. A `cd` inside a bash command does not
  count. Two sessions on 2026-08-12 explored apps/web with find and ls only,
  never opened a file there, and correctly did not load contexts/web.md.

  Note also: after /compact, nested contexts are NOT re-injected. They reload
  the next time a file in that directory is read.

  The questions below are the behavioural backstop for when /context is
  unavailable, or when a file is loaded but not being followed.

  READING THE RESULT
    A pass, B pass   -> the whole layer is reaching the agent.
    A pass, B stale  -> only the root is loading. The nested mechanism is the
                        problem; re-ask with a file open first, and if it is
                        still stale that is a real defect worth chasing.
    A stale          -> nothing is loading. Re-run setup.sh, then start a NEW
                        session — an agent that began before the files existed
                        cannot see them, and cannot reliably tell you so.
EOF

head_ "Result"
printf '  %s checks passed, %s failed\n\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || { echo "Not wired correctly. Start with: bash .ai/setup.sh"; exit 1; }
echo "AI layer verified."
