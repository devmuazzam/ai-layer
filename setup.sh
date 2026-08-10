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

ROOT_DOCS="AGENTS.md CLAUDE.md DESIGN.md AUTOMATED-FEATURES.md QUICK-REFERENCE.md DESIGN-FOLDER-UPDATE.md"
for f in $ROOT_DOCS; do
  if [ -f "$AI_DIR/claude/$f" ]; then
    safe_link ".claude/$f" "$f"          # via .claude, so tracked docs that
  elif [ -L "$f" ] && [ ! -e "$f" ]; then #   cite .claude/rules/... keep resolving
    rm "$f"; PRUNED=$((PRUNED + 1))
  fi
done

[ -f "$AI_DIR/.mcp.json" ] && safe_link "$AI_DIR/.mcp.json" ".mcp.json"

# ------------------------------------------------------ 3. surface mirrors ---
# .agent/ kept for now — flagged as a possible drop in the audit; delete the
# entry below once confirmed nobody's tool reads it.
for surface in .cursor .agent .codex; do
  mirror_dir "$AI_DIR/claude/skills" "$surface/skills"
  mirror_dir "$AI_DIR/aidlc/agents"  "$surface/agents"
done
# Cursor gets the rules too (audit: rules currently reach Claude only).
mirror_dir "$AI_DIR/claude/rules" ".cursor/rules"

# --------------------------------------------- 4. hide from the client repo --
EXCLUDE="$GIT_DIR/info/exclude"
mkdir -p "$(dirname "$EXCLUDE")"
for p in "/$AI_DIR/" "/.claude" "/CLAUDE.md" "/AGENTS.md" "/DESIGN.md" \
         "/AUTOMATED-FEATURES.md" "/QUICK-REFERENCE.md" "/DESIGN-FOLDER-UPDATE.md" \
         "/.mcp.json" "/.cursor/" "/.codex/" "/.agent/" "*.$STAMP" "*.backup-*"; do
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
