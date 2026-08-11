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

head_ "Result"
printf '  %s checks passed, %s failed\n\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || { echo "Not wired correctly. Start with: bash .ai/setup.sh"; exit 1; }
echo "AI layer verified."
