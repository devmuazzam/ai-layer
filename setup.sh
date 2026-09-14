#!/usr/bin/env bash
# setup.sh — installs the TCG AI layer from the private overlay repo.
#
# LIVES IN THE OVERLAY REPO (.ai/setup.sh), NOT in the client repo.
#
# First-time bootstrap (run once, from the client repo root) — use YOUR OWN remote URL:
#   git clone <your-overlay-remote> .ai && bash .ai/setup.sh
# After that, just:  bash .ai/setup.sh   (safe to re-run any time)
#
# AI_REMOTE below defaults to an SSH host ALIAS (dev_codingcops_github.com) that only
# resolves on a machine with that entry in ~/.ssh/config. On any other machine, either
# clone manually as above, or override it:
#   AI_REMOTE=git@github.com:<org>/tcg-ai-layer.git bash .ai/setup.sh
# Once .ai/ is a clone the default is never used again — the script pulls from whatever
# origin that clone already has.
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
MIRROR_URL="${MIRROR_URL:-}"          # optional: private CI mirror of the CLIENT repo (remote only; push to it by hand — the overlay no longer installs a hook)
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

# link_agents <dest-dir> <target-root> — flat-link every tcg-*.md into <dest-dir>, one
# file per agent. This is how EVERY surface discovers subagents: a flat directory of
# <name>.md files carrying YAML frontmatter. Claude Code reads .claude/agents/, Cursor
# reads .cursor/agents/ (cursor.com/docs/subagents), Antigravity reads .agent/agents/.
#
# mirror_dir CANNOT do this job, and the reason is two separate bugs:
#
#  1. Shape. The overlay stores agents nested by phase (inception/, construction/, ...).
#     Mirroring that tree publishes four DIRECTORIES, a README and one stray flat agent —
#     so a surface scanning for <name>.md finds one of eight, and would pick up the six
#     examples/ agents that are not ours. Flat is the shape every surface agrees on; the
#     phase directories stay the source of truth and this is a discovery index over them.
#
#  2. Prefix. .claude is itself a symlink to .ai/claude, so a link created at
#     .claude/agents/x resolves its relative target from the PHYSICAL directory
#     .ai/claude/agents/ and needs ../../ + aidlc/... — while .cursor/agents/x is a real
#     directory in the client root and needs ../../ + .ai/aidlc/... mirror_dir computes
#     one prefix from the string path and gets the .claude case wrong every time.
#     Hence <target-root>: what to prepend to the agent's path inside the overlay.
link_agents() {
  local dst="$1" target_root="$2" src="$AI_DIR/aidlc/agents" entry name
  [ -d "$src" ] || return 0
  mkdir -p "$dst"
  while IFS= read -r entry; do
    [ -n "$entry" ] || continue
    name="$(basename "$entry")"
    safe_link "$target_root${entry#"$AI_DIR/"}" "$dst/$name"
  done < <(find "$src" -name 'tcg-*.md' -type f | sort)
  prune_broken "$dst"
}

# drop_nested_agent_mirror <dir> — remove the old nested-shape links (construction/,
# inception/, reflection/, tools/, examples/, README.md) that earlier versions mirrored
# into a surface's agents directory. prune_broken will not touch them: they RESOLVE
# perfectly, they are simply the wrong shape for agent discovery, which is the failure
# mode this whole layer is built to make impossible to have silently.
#
# Keyed on the link target, so it can only ever remove a link this script created — a
# real file, or someone's own agent, is left alone.
drop_nested_agent_mirror() {
  local dir="$1" entry
  [ -d "$dir" ] || return 0
  for entry in "$dir"/*; do
    [ -L "$entry" ] || continue
    case "$(basename "$entry")" in tcg-*.md) continue ;; esac
    case "$(readlink "$entry")" in
      *aidlc/agents*) rm "$entry"; PRUNED=$((PRUNED + 1)) ;;
    esac
  done
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
if [ ! -e "$AI_DIR/.git" ]; then
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

# Only AGENTS.md is linked at the root (for Cursor/Antigravity). Claude Code already
# auto-loads .claude/CLAUDE.md, so a root CLAUDE.md symlink made it load the same 11 KB
# twice — it is pruned below. AGENTS.md is a symlink to CLAUDE.md inside the overlay, so
# every entry point still resolves to one file and cannot drift. The flow-era docs (DESIGN.md,
# AUTOMATED-FEATURES.md, QUICK-REFERENCE.md, DESIGN-FOLDER-UPDATE.md) were removed; they
# stay in the exclude list below so machines that still have their symlinks get them
# pruned rather than left dangling.
ROOT_DOCS="AGENTS.md"
if [ -L CLAUDE.md ]; then rm CLAUDE.md; PRUNED=$((PRUNED + 1)); fi   # duplicate of .claude/CLAUDE.md
for f in $ROOT_DOCS; do
  if [ -f "$AI_DIR/claude/$f" ]; then
    safe_link ".claude/$f" "$f"          # via .claude, so tracked docs that
  elif [ -L "$f" ] && [ ! -e "$f" ]; then #   cite .claude/rules/... keep resolving
    rm "$f"; PRUNED=$((PRUNED + 1))
  fi
done

# Sweep the repo root for dangling links into .claude/. The ROOT_DOCS loop above only
# prunes names still IN that list, so a doc removed from the overlay AND from ROOT_DOCS
# would dangle forever — which is exactly what happened to DESIGN.md,
# AUTOMATED-FEATURES.md, QUICK-REFERENCE.md and DESIGN-FOLDER-UPDATE.md. Keyed on the
# link target so it can only ever touch links this script created.
for f in *.md; do
  [ -L "$f" ] || continue
  [ -e "$f" ] && continue
  case "$(readlink "$f")" in
    .claude/*|"$AI_DIR"/*) rm "$f"; PRUNED=$((PRUNED + 1)) ;;
  esac
done

[ -f "$AI_DIR/.mcp.json" ] && safe_link "$AI_DIR/.mcp.json" ".mcp.json"

# ------------------------------------------------------ 3. surface mirrors ---
# Three surfaces are supported: Claude Code, Cursor and Antigravity. Codex was dropped.
#
# skills/ and agents/ are NOT reference copies any more — they are the loading mechanism
# on Cursor and Antigravity, both of which shipped Skills and Subagents in 2026:
#
#   Cursor       .cursor/skills/<name>/SKILL.md   auto-invoked; the model matches the
#                                                 request against each description
#                .cursor/agents/<name>.md         Agent delegates on description
#   Antigravity  .agents/skills/<name>/SKILL.md   description required; name defaults
#                                                 to the folder
#                .agents/agents/<name>.md         subagent: true (the default), then
#                                                 invoke_subagent
#
# SURFACE DIRECTORIES ARE NOT ONE PER TOOL. `.agents/` (plural) is Antigravity's current
# default AND a second path Cursor scans for skills — it is becoming the cross-tool
# standard. `.agent/` (singular) is Antigravity's legacy path: still supported, no longer
# the default, kept here so a machine on an older build does not silently lose everything.
# Both are written; neither is authoritative over the other.
#
# So the skills mirror was already the real thing: <name>/SKILL.md with `name` matching
# the folder and a `description` written as trigger phrasing is exactly what both tools
# require. The AGENTS mirror was not — see link_agents for the two bugs.
#
# contexts/ stays a findable reference copy: all three surfaces get the contexts for real
# through the nested CLAUDE.md/AGENTS.md files in section 3b.
#
# prune_broken runs first because claude/skills/ and claude/rules/ were removed from the
# overlay and earlier versions of this script linked them. (The old note here — "Cursor
# never read .cursor/rules/*.md, only .mdc" — is still true and still why this layer does
# not use that path. It describes Cursor's RULES system, which is not how skills or
# subagents load, and it was being read as though it settled those too.)
SURFACES=".cursor .agents .agent"
for surface in $SURFACES; do
  prune_broken "$surface"
  mirror_dir "$AI_DIR/claude/skills"   "$surface/skills"
  mirror_dir "$AI_DIR/claude/contexts" "$surface/contexts"
  drop_nested_agent_mirror "$surface/agents"
  link_agents "$surface/agents" "$(prefix_for "$surface/agents")$AI_DIR/"
done

# Claude Code loads .claude/skills and .claude/agents for real. Skills already worked
# because they live under claude/. The agents did not: they live under aidlc/, the loop
# above only ever mirrored them into .cursor and .agent, and claude/agents/ was never
# created at all. Every agent in aidlc/GUIDE.md was therefore uninvokable on the one
# surface this layer is written for, with nothing reporting it — the loop simply had no
# executor to call. Agents also need YAML frontmatter to register; they now carry it.
link_agents "$AI_DIR/claude/agents" "../../"

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
CONTEXT_MAP="apps/api:api.md apps/api/prisma:prisma.md apps/web:web.md apps/mobile:mobile.md packages/payroll-engine:payroll-engine.md"

for pair in $CONTEXT_MAP; do
  link_context "${pair%%:*}" "${pair##*:}"
done

# --------------------------------------------- 4. hide from the client repo --
EXCLUDE="$GIT_DIR/info/exclude"
mkdir -p "$(dirname "$EXCLUDE")"
EXCLUDE_PATHS="/$AI_DIR/ /.claude /CLAUDE.md /AGENTS.md /DESIGN.md \
/AUTOMATED-FEATURES.md /QUICK-REFERENCE.md /DESIGN-FOLDER-UPDATE.md \
/.mcp.json /.codex/ *.$STAMP *.backup-*"

# Surface directories, derived from SURFACES rather than restated — a surface added to
# that list but missed here would show up as untracked files in the CLIENT repo, which is
# the one failure that breaks the stealth model. Note that gitignore patterns are exact:
# "/.agent/" does NOT cover "/.agents/", so listing them by hand was one typo away from
# publishing the whole layer.
for surface in $SURFACES; do
  EXCLUDE_PATHS="$EXCLUDE_PATHS /$surface/"
done

# Nested context triggers, derived from CONTEXT_MAP rather than restated.
for pair in $CONTEXT_MAP; do
  EXCLUDE_PATHS="$EXCLUDE_PATHS /${pair%%:*}/CLAUDE.md /${pair%%:*}/AGENTS.md"
done

for p in $EXCLUDE_PATHS; do
  grep -qxF "$p" "$EXCLUDE" 2>/dev/null || echo "$p" >> "$EXCLUDE"
done

# ------------------------------------------------- 5. hooks: defer to .husky ---
# Since the client repo's Nx merge (PR #363, 2026-08-19) the git hooks are TRACKED files in
# .husky/ and run in the main checkout and every linked worktree — `pnpm install` sets
# core.hooksPath=.husky (relative, so it resolves inside each worktree). pre-commit runs
# lint-staged + `nx affected -t build`; pre-push refuses a direct push of main and runs
# affected lint/typecheck/build. That is everything the overlay's own pre-push used to do
# except the rebase-behind check and the private CI mirror push.
#
# Two core.hooksPath values cannot coexist, and the tracked hooks won. Earlier versions of
# this script pointed hooksPath at .git/hooks and wrote a pre-commit/pre-push there; that
# now only ever *disables* the tracked hooks. So: repair, don't compete.
HOOKS_PATH="$(git config --get core.hooksPath || true)"
case "$HOOKS_PATH" in
  ""|.husky|"$ROOT/.husky") ;;   # already right (empty: `pnpm install` will set it)
  *)
    git config core.hooksPath .husky
    say "core.hooksPath was '$HOOKS_PATH' — reset to .husky (tracked hooks; see README)."
    ;;
esac
for h in pre-commit pre-push; do
  f="$GIT_DIR/hooks/$h"
  if [ -f "$f" ] && grep -q "Installed by .ai/setup.sh\|Delegates to husky" "$f" 2>/dev/null; then
    rm -f "$f"
    say "Removed stale overlay hook $f (superseded by tracked .husky/$h)."
  fi
done

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
say "  hooks                 : tracked .husky/ (client repo) — overlay installs none"
