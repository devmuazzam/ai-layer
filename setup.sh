#!/usr/bin/env bash
# setup.sh — installs the TCG AI layer from the private overlay repo.
#
# LIVES IN THE OVERLAY REPO (.ai/setup.sh), NOT in the client repo.
# First-time bootstrap (run once, from the client repo root):
#   git clone git@github.com:codingcops/tcg-ai-layer.git .ai && bash .ai/setup.sh
# After that, just:  bash .ai/setup.sh   (safe to re-run any time)
#
# Replaces the zip-era scripts/setup-skills.sh. Fixes from the audit:
#  - no unconditional rm -f: real files/dirs are backed up, never destroyed
#  - no ln-into-real-directory gotcha (nested .cursor/skills/x/x links)
#  - prunes broken symlinks left behind by deleted skills/docs
#  - relative link prefix computed from destination depth, not hardcoded
#  - reports what it actually did instead of unconditional "Skills linked."
set -euo pipefail

AI_REMOTE="${AI_REMOTE:-git@dev_codingcops_github.com:devCodingcops/tcg-ai-layer.git}"
AI_DIR=".ai"
MIRROR_URL="${MIRROR_URL:-}"          # optional: private CI mirror of the CLIENT repo
MIRROR_REMOTE="private"

ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" \
  || { echo "ERROR: run this from inside the client repo." >&2; exit 1; }
cd "$ROOT"
GIT_DIR="$(git rev-parse --git-dir)"
STAMP="backup-$(date +%Y%m%d-%H%M%S)"
CHANGED=0; PRUNED=0; BACKED_UP=0

say()  { printf '%s\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }

# ---------------------------------------------------------------- helpers ----
# safe_link <target> <linkpath> — idempotent; never destroys real files/dirs.
safe_link() {
  local target="$1" link="$2"
  if [ -L "$link" ]; then
    [ "$(readlink "$link")" = "$target" ] && return 0
    rm "$link"
  elif [ -e "$link" ]; then
    warn "$link is a real file/dir with possible local edits — moved to $link.$STAMP"
    mv "$link" "$link.$STAMP"
    BACKED_UP=$((BACKED_UP + 1))
  fi
  ln -s "$target" "$link"
  CHANGED=$((CHANGED + 1))
}

# prefix_for <dest-dir> — "../" per path level, so nesting changes can't break links.
prefix_for() {
  local p="" part; IFS=/ read -ra _parts <<< "$1"
  for part in "${_parts[@]}"; do [ -n "$part" ] && p="../$p"; done
  printf '%s' "$p"
}

# mirror_dir <source-dir> <dest-dir> — link every entry, then prune dead links.
mirror_dir() {
  local src="$1" dst="$2" prefix entry name
  [ -d "$src" ] || return 0
  mkdir -p "$dst"
  prefix="$(prefix_for "$dst")"
  for entry in "$src"/*; do
    [ -e "$entry" ] || continue
    name="$(basename "$entry")"
    safe_link "$prefix$src/$name" "$dst/$name"
  done
  for entry in "$dst"/*; do
    [ -L "$entry" ] || continue
    if [ ! -e "$entry" ]; then
      rm "$entry"
      PRUNED=$((PRUNED + 1))
    fi
  done
}

# prune_broken <dir> — remove dangling symlinks anywhere under <dir>, then drop any
# directory left empty. mirror_dir cannot do this: it returns early when its SOURCE is
# missing, so a mirror whose source was deleted from the overlay leaves its dead links
# behind forever. That is exactly what happened to .cursor/rules and */skills, and it is
# what a machine set up before those were removed will still be carrying.
prune_broken() {
  local dir="$1" entry
  [ -d "$dir" ] || return 0
  while IFS= read -r entry; do
    [ -n "$entry" ] || continue
    rm "$entry"; PRUNED=$((PRUNED + 1))
  done < <(find "$dir" -type l ! -exec test -e {} \; -print 2>/dev/null)
  find "$dir" -mindepth 1 -type d -empty -delete 2>/dev/null || true
}

# link_context <surface-dir> <context-file> — drop a location-triggered context file
# into a client-repo directory, under BOTH filenames, because the surfaces disagree on
# which one they read: Claude Code auto-loads a nested CLAUDE.md, several other tools
# look for a nested AGENTS.md, and tools that auto-load neither can still be pointed at
# the path by the root context file. One target, three ways in.
# No-ops when the directory is absent, so a partial checkout does not break the run.
link_context() {
  local dir="$1" ctx="$2" prefix
  [ -d "$dir" ] || return 0
  [ -f "$AI_DIR/claude/contexts/$ctx" ] || { warn "missing context: contexts/$ctx"; return 0; }
  prefix="$(prefix_for "$dir")"
  safe_link "$prefix$AI_DIR/claude/contexts/$ctx" "$dir/CLAUDE.md"
  safe_link "$prefix$AI_DIR/claude/contexts/$ctx" "$dir/AGENTS.md"
}

# ------------------------------------------------- 1. fetch/update overlay ---
if [ ! -d "$AI_DIR/.git" ]; then
  if [ -e "$AI_DIR" ]; then
    warn "$AI_DIR exists but is not a git clone — moved to $AI_DIR.$STAMP"
    mv "$AI_DIR" "$AI_DIR.$STAMP"; BACKED_UP=$((BACKED_UP + 1))
  fi
  say "Cloning overlay into $AI_DIR/ ..."
  git clone "$AI_REMOTE" "$AI_DIR"
else
  say "Updating overlay ..."
  git -C "$AI_DIR" pull --ff-only || warn "overlay pull failed — continuing with local copy"
fi
[ -d "$AI_DIR/claude" ] \
  || { echo "ERROR: $AI_DIR/claude/ not found — wrong overlay repo?" >&2; exit 1; }

# ------------------------------------------------------- 2. root symlinks ----
# .claude becomes a symlink into the overlay. A zip-era real .claude/ directory
# is backed up by safe_link, not deleted — first run on each machine migrates it.
safe_link "$AI_DIR/claude" ".claude"

# AGENTS.md is a symlink to CLAUDE.md inside the overlay, so both root entry points
# resolve to one file and cannot drift. The flow-era docs (DESIGN.md,
# AUTOMATED-FEATURES.md, QUICK-REFERENCE.md, DESIGN-FOLDER-UPDATE.md) were removed; they
# stay in the exclude list below so machines that still have their symlinks get them
# pruned rather than left dangling.
ROOT_DOCS="AGENTS.md CLAUDE.md"
for f in $ROOT_DOCS; do
  if [ -f "$AI_DIR/claude/$f" ]; then
    safe_link ".claude/$f" "$f"          # via .claude, so tracked docs that
  elif [ -L "$f" ] && [ ! -e "$f" ]; then #   cite .claude/rules/... keep resolving
    rm "$f"; PRUNED=$((PRUNED + 1))
  fi
done

[ -f "$AI_DIR/.mcp.json" ] && safe_link "$AI_DIR/.mcp.json" ".mcp.json"

# ------------------------------------------------------ 3. surface mirrors ---
# Three surfaces are supported: Claude Code, Cursor and Antigravity. Codex was dropped.
#
# These mirrors are findable reference copies, NOT the loading mechanism. Claude Code and
# Cursor both receive this layer through the root + nested entry files in section 3b.
# Antigravity's auto-load mechanism is unverified, so the mirror is what makes the content
# reachable there at all — see the README.
#
# prune_broken runs first because claude/skills/ and claude/rules/ were removed from the
# overlay and earlier versions of this script linked them. Cursor never read
# .cursor/rules/*.md in any case: its rules system loads .mdc only, so those links were
# inert even while they resolved.
for surface in .cursor .agent; do
  prune_broken "$surface"
  mirror_dir "$AI_DIR/aidlc/agents"    "$surface/agents"
  mirror_dir "$AI_DIR/claude/contexts" "$surface/contexts"
done

# Retire Codex. Only removed when every file under it is a symlink — i.e. everything there
# was created by this script and nothing of anyone's own is inside. If a human put a real
# file there, it is left alone and reported instead.
if [ -d ".codex" ]; then
  if [ -z "$(find .codex ! -type d ! -type l -print -quit 2>/dev/null)" ]; then
    rm -rf ".codex"; PRUNED=$((PRUNED + 1))
    say "Removed .codex/ — that surface is no longer supported."
  else
    warn ".codex/ contains real files; left in place. Delete it by hand once you have checked it."
  fi
fi

# ------------------------------------------- 3b. location-triggered contexts --
# Surface contexts are dropped into the directory they govern. On Claude Code the
# nested file loads automatically when work happens there; on every other surface it
# is simply a file at a predictable path, and the root context file names that path.
# Either way the content is identical and lives in exactly one place.
#
# Declared once. Section 4 derives its exclude entries from this same list, so the
# "what we link" and "what we hide" lists cannot drift apart — a link that is not
# excluded shows up as an untracked file in the client repo, which is the one failure
# that breaks the stealth model.
CONTEXT_MAP="apps/api:api.md apps/api/prisma:prisma.md apps/web:web.md apps/mobile:mobile.md"

for pair in $CONTEXT_MAP; do
  link_context "${pair%%:*}" "${pair##*:}"
done

# --------------------------------------------- 4. hide from the client repo --
EXCLUDE="$GIT_DIR/info/exclude"
mkdir -p "$(dirname "$EXCLUDE")"
EXCLUDE_PATHS="/$AI_DIR/ /.claude /CLAUDE.md /AGENTS.md /DESIGN.md \
/AUTOMATED-FEATURES.md /QUICK-REFERENCE.md /DESIGN-FOLDER-UPDATE.md \
/.mcp.json /.cursor/ /.codex/ /.agent/ *.$STAMP *.backup-*"

# Nested context triggers, derived from CONTEXT_MAP rather than restated.
for pair in $CONTEXT_MAP; do
  EXCLUDE_PATHS="$EXCLUDE_PATHS /${pair%%:*}/CLAUDE.md /${pair%%:*}/AGENTS.md"
done

for p in $EXCLUDE_PATHS; do
  grep -qxF "$p" "$EXCLUDE" 2>/dev/null || echo "$p" >> "$EXCLUDE"
done

# ------------------------------------------ 5. hooks: G3 gates + CI mirror ---
# Husky sets core.hooksPath=.husky, and .husky/ is tracked (client-visible),
# so the pre-push gate can't live there. We point hooksPath at .git/hooks
# (local config, invisible), delegate pre-commit back to husky so existing
# behavior is preserved, and add our pre-push.
# CAVEAT: husky's prepare script re-flips hooksPath on every pnpm install —
# re-run this script after installs. It prints a reminder for that reason.
git config core.hooksPath "$GIT_DIR/hooks"

cat > "$GIT_DIR/hooks/pre-commit" <<'EOF'
#!/usr/bin/env bash
# Delegates to husky so tracked pre-commit behavior is unchanged.
[ -f .husky/pre-commit ] && exec bash .husky/pre-commit "$@"
exit 0
EOF
chmod +x "$GIT_DIR/hooks/pre-commit"

cat > "$GIT_DIR/hooks/pre-push" <<'EOF'
#!/usr/bin/env bash
# G3 quality gates + optional private CI mirror. Installed by .ai/setup.sh.
# Emergency bypass: SKIP_GATES=1 git push   (use sparingly — gates fail open enough already)
set -euo pipefail
[ "${SKIP_GATES:-0}" = "1" ] && { echo "pre-push: gates skipped"; exit 0; }
echo "pre-push: G3 gates — lint, test, build"
pnpm lint
pnpm -r --if-present test
pnpm build
if git remote get-url private >/dev/null 2>&1; then
  echo "pre-push: mirroring to private CI remote"
  git push private HEAD --force-with-lease \
    || echo "pre-push: mirror push failed (non-blocking)"
fi
EOF
chmod +x "$GIT_DIR/hooks/pre-push"

# Optional: register the private CI mirror remote for the client repo.
if [ -n "$MIRROR_URL" ] && ! git remote get-url "$MIRROR_REMOTE" >/dev/null 2>&1; then
  git remote add "$MIRROR_REMOTE" "$MIRROR_URL"
  say "Added '$MIRROR_REMOTE' remote for CI mirroring."
fi

# ------------------------------------------------------------- 6. report -----
say ""
say "AI layer ready."
say "  links created/updated : $CHANGED"
say "  stale links pruned    : $PRUNED"
say "  local edits backed up : $BACKED_UP$( [ "$BACKED_UP" -gt 0 ] && printf ' (see *.%s)' "$STAMP" )"
say "  hooks                 : pre-commit (husky delegate), pre-push (G3 + mirror)"
say ""
say "Reminder: after 'pnpm install', run 'bash .ai/setup.sh' again"
say "(husky resets the hooks path on install)."
