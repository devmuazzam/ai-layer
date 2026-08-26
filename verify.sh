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

head_ "Root entry points  (Claude reads .claude/CLAUDE.md, Cursor reads AGENTS.md)"
resolves ".claude/CLAUDE.md" "TCG platform"
resolves "AGENTS.md" "TCG platform"
if [ -e CLAUDE.md ]; then
  bad "root CLAUDE.md exists — Claude Code would load it AND .claude/CLAUDE.md (double context); rerun setup.sh"
else
  ok "no root CLAUDE.md (Claude Code loads .claude/CLAUDE.md once)"
fi
if [ "$(cat AGENTS.md 2>/dev/null)" = "$(cat .claude/CLAUDE.md 2>/dev/null)" ]; then
  ok "AGENTS.md and .claude/CLAUDE.md are the same content (cannot drift)"
else
  bad "AGENTS.md and .claude/CLAUDE.md differ — they should resolve to one file"
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
  | grep -E ' (\.ai/|\.claude|CLAUDE\.md|AGENTS\.md|\.cursor/|\.codex/|\.agents?/)' || true)"
if [ -z "$LEAKED" ]; then
  ok "git status shows no AI-layer paths"
else
  bad "AI-layer paths are visible to the client repo:"
  printf '%s\n' "$LEAKED" | sed 's/^/         /'
  note "fix: re-run 'bash .ai/setup.sh' — the exclude step did not complete"
fi

head_ "Skills  (auto-invoked on all three surfaces, by description match)"
SKILLS="commit review-pr lint-triage find-component debug-api close-ticket"
for s in $SKILLS; do
  f="$AI_DIR/claude/skills/$s/SKILL.md"
  if [ ! -f "$f" ]; then bad "skills/$s — missing"; continue; fi
  # Cursor requires `name` to match the folder, and uses `description` to decide
  # relevance. A skill missing either is silently never auto-invoked there.
  n="$(sed -n 's/^name: *//p' "$f" | head -1)"
  if [ "$n" != "$s" ]; then
    bad "skills/$s — frontmatter name is \"$n\", must match the folder name"
  elif ! grep -q '^description:' "$f"; then
    bad "skills/$s — no description: the model has nothing to match a request against"
  else
    ok "skills/$s"
  fi
done
note "not in your agent's list? it started before these existed — restart the session"

head_ "Subagents  (every surface discovers these as FLAT <name>.md, never a tree)"
# The overlay stores agents nested by phase. Every surface scans a flat directory, so a
# mirror of the phase tree publishes directories instead of agents and the tools find
# nothing — which is exactly what happened to .cursor and .agent until 2026-08-19, with
# all 22 checks here passing throughout. That is the failure this block exists to catch.
AGENT_COUNT="$(find "$AI_DIR/aidlc/agents" -name 'tcg-*.md' -type f 2>/dev/null | wc -l | tr -d ' ')"
for pair in ".claude:Claude Code" ".cursor:Cursor" \
            ".agents:Antigravity" ".agent:Antigravity (legacy path)"; do
  d="${pair%%:*}/agents"; tool="${pair##*:}"
  if [ ! -d "$d" ]; then note "$d/ not present — fine unless you use $tool"; continue; fi
  flat="$(find "$d" -maxdepth 1 -name 'tcg-*.md' 2>/dev/null | wc -l | tr -d ' ')"

  # Split what is NOT one of our flat agents into two piles, because they need
  # opposite advice. STALE is the old nested mirror — our own symlinks into
  # aidlc/agents; setup.sh removes those, so "re-run setup" is the fix. FOREIGN is
  # anything else: a real directory left by an older setup, or a developer's own
  # subagent. setup.sh deliberately never touches those (it keys on the link target),
  # so telling someone to re-run it would loop forever on a failure it cannot clear.
  stale=0; foreign=0
  for e in "$d"/*; do
    [ -e "$e" ] || [ -L "$e" ] || continue
    case "$(basename "$e")" in tcg-*.md) continue ;; esac
    if [ -L "$e" ] && case "$(readlink "$e")" in *aidlc/agents*) true ;; *) false ;; esac; then
      stale=$((stale + 1))
    else
      foreign=$((foreign + 1))
    fi
  done

  if [ "$flat" != "$AGENT_COUNT" ]; then
    bad "$d — $flat of $AGENT_COUNT agents discoverable by $tool"
    note "fix: re-run 'bash .ai/setup.sh'"
  elif [ "$stale" != "0" ]; then
    bad "$d — $stale leftover entr(ies) from the old nested mirror; $tool may read examples/ as real agents"
    note "fix: re-run 'bash .ai/setup.sh'"
  else
    ok "$d — all $AGENT_COUNT agents flat and discoverable"
  fi
  [ "$foreign" = "0" ] || \
    note "$d — $foreign entr(ies) here are not ours and were left alone; delete by hand if unwanted"
done

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

head_ "Surface mirrors  (skills/ and agents/ load for real; contexts/ is a reference copy)"
for s in .cursor .agents .agent; do
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
  Claude Code   .claude/CLAUDE.md, plus the nearest apps/*/CLAUDE.md as you work.
                Skills and .claude/agents/ both auto-invoke. VERIFIED.
  Cursor        root AGENTS.md, plus the nearest apps/*/AGENTS.md. VERIFIED.
                Skills in .cursor/skills/<name>/SKILL.md are auto-invoked by
                description match; subagents in .cursor/agents/<name>.md are
                delegated to by Agent. VERIFIED ON A REAL INSTALL 2026-08-19 —
                /lint-triage resolved through the symlinked skills dir, which
                was the open question (every skill here is a symlink into .ai/).
                Note: Cursor ignores .md in .cursor/rules — only .mdc is read
                there. That is its RULES system and says nothing about skills or
                subagents; it was long misread as ruling those out too.
  Antigravity   root AGENTS.md/GEMINI.md (native since v1.20.3), nested
                AGENTS.md per directory, plus .agents/skills/ and
                .agents/agents/ (Skills in IDE 1.14.2, Subagents in 2.0).
                Wiring is in place; UNCONFIRMED on a real install.
                .agents/ (plural) is the current default; .agent/ (singular) is
                the legacy path, still supported, still written here.
                Its planner delegates via invoke_subagent on the description
                rather than routing automatically, so a subagent may need
                naming out loud more often than on the other two.

  To confirm on Cursor or Antigravity, ask for something only a skill or agent
  knows, and watch whether the tool pulls it in without being told the path:
    "which lint failures here are mine?"        -> should reach for lint-triage
    "is there already a badge component?"       -> should reach for find-component
  If it answers from general knowledge instead, the skill did not load.
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

    BOTH LINES GO IN THE CLAUDE CODE CHAT, NOT IN THIS TERMINAL:

        read apps/api/src/main.ts
        /context

    Then look under "Memory files" for apps/api/CLAUDE.md.

    /context is a Claude Code slash command. Typing it in a shell gives you
    "no such file or directory".

    It reports which instruction files actually loaded — an observation, not a
    self-report. Asking a model what is in its own context is the one method
    that cannot be trusted for this.

    For a permanent record, the InstructionsLoaded hook logs which instruction
    files load, when, and why. See the Claude Code hooks documentation.

  WHAT COUNTS AS THE TRIGGER — confirmed in Claude Code's own docs:
  subdirectory CLAUDE.md files are "included when CLAUDE reads files in those
  directories" rather than at launch.

    triggers:      Claude using its Read tool on a file in that directory
    does NOT:      a `cd` inside a bash command
    does NOT:      you running `cat` yourself in a terminal — Claude is not
                   involved, so nothing loads
    probably not:  Claude running `cat` via bash; the trigger is tied to
                   reading a file, so ask it to read, not to cat

  Two sessions on 2026-08-12 explored apps/web with find and ls only, never had
  Claude read a file there, and correctly did not load contexts/web.md.

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
