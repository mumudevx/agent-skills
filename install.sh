#!/usr/bin/env bash
set -euo pipefail

# ─── Config ───────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXCLUDE_DIRS=".git .github node_modules docs __pycache__"
ALL_TOOLS="claude gemini copilot antigravity"

# ─── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ─── Tool → Directory mapping (Bash 3.2 compatible) ──────────────────────────
get_tool_dir() {
  case "$1" in
    claude)       echo "$HOME/.claude/skills" ;;
    gemini)       echo "$HOME/.gemini/skills" ;;
    copilot)      echo "$HOME/.copilot/skills" ;;
    antigravity)  echo "$HOME/.gemini/antigravity/skills" ;;
    *)            return 1 ;;
  esac
}

is_valid_tool() {
  case "$1" in
    claude|gemini|copilot|antigravity) return 0 ;;
    *) return 1 ;;
  esac
}

# ─── Helpers ──────────────────────────────────────────────────────────────────
usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Install agent skills as symlinks into AI tool skill directories.

Options:
  --tool <name>     Target tool: claude, gemini, copilot, antigravity, all
  --skill <name>    Install only a specific skill (default: all skills)
  --uninstall       Remove installed symlinks
  --list            List available skills
  --help            Show this help message

Examples:
  $(basename "$0") --tool claude              # Install all skills for Claude Code
  $(basename "$0") --tool all                 # Install for all tools
  $(basename "$0") --tool gemini --skill remotion  # Install only remotion for Gemini
  $(basename "$0") --uninstall --tool claude  # Uninstall from Claude Code
  $(basename "$0") --list                     # List available skills
EOF
}

discover_skills() {
  for dir in "$SCRIPT_DIR"/*/; do
    [ ! -d "$dir" ] && continue
    local name
    name="$(basename "$dir")"

    # Skip excluded dirs
    local skip=false
    for excl in $EXCLUDE_DIRS; do
      if [ "$name" = "$excl" ]; then
        skip=true
        break
      fi
    done
    $skip && continue

    # Must contain SKILL.md
    [ -f "$dir/SKILL.md" ] && echo "$name"
  done
}

get_skill_description() {
  local skill_md="$SCRIPT_DIR/$1/SKILL.md"
  grep -m1 '^description:' "$skill_md" 2>/dev/null | sed 's/^description: *//' || echo "(no description)"
}

# ─── Actions ──────────────────────────────────────────────────────────────────
list_skills() {
  local skills
  skills="$(discover_skills)"

  if [ -z "$skills" ]; then
    echo -e "${YELLOW}No skills found.${NC}"
    return
  fi

  echo -e "${CYAN}Available skills:${NC}"
  echo ""
  echo "$skills" | while read -r skill; do
    local desc
    desc="$(get_skill_description "$skill")"
    printf "  %-25s %s\n" "$skill" "$desc"
  done
}

install_skills() {
  local tool="$1"
  local filter_skill="$2"
  local target_dir
  target_dir="$(get_tool_dir "$tool")"

  local skills
  skills="$(discover_skills)"

  # Filter if --skill specified
  if [ -n "$filter_skill" ]; then
    if ! echo "$skills" | grep -qx "$filter_skill"; then
      echo -e "${RED}Error: Skill '$filter_skill' not found.${NC}"
      exit 1
    fi
    skills="$filter_skill"
  fi

  # Create target dir if needed
  mkdir -p "$target_dir"

  local installed=0 skipped=0 errors=0

  echo "$skills" | while read -r skill; do
    local src="$SCRIPT_DIR/$skill"
    local dest="$target_dir/$skill"

    if [ -L "$dest" ]; then
      local current_target
      current_target="$(readlink "$dest")"
      if [ "$current_target" = "$src" ]; then
        echo -e "  ${YELLOW}⊘ $skill${NC} — already installed"
        continue
      else
        echo -e "  ${YELLOW}⚠ $skill${NC} — symlink exists but points to $current_target, skipping"
        continue
      fi
    elif [ -e "$dest" ]; then
      echo -e "  ${RED}✗ $skill${NC} — real file/directory exists at $dest, skipping"
      continue
    fi

    ln -s "$src" "$dest"
    echo -e "  ${GREEN}✓ $skill${NC} — installed"
  done

  echo ""
  echo -e "${CYAN}[$tool]${NC} Done."
}

uninstall_skills() {
  local tool="$1"
  local filter_skill="$2"
  local target_dir
  target_dir="$(get_tool_dir "$tool")"

  if [ ! -d "$target_dir" ]; then
    echo -e "  ${YELLOW}Directory $target_dir does not exist, nothing to uninstall.${NC}"
    return
  fi

  local skills
  skills="$(discover_skills)"

  if [ -n "$filter_skill" ]; then
    skills="$filter_skill"
  fi

  echo "$skills" | while read -r skill; do
    local dest="$target_dir/$skill"

    if [ -L "$dest" ]; then
      local current_target
      current_target="$(readlink "$dest")"
      if [ "$current_target" = "$SCRIPT_DIR/$skill" ]; then
        rm "$dest"
        echo -e "  ${GREEN}✓ $skill${NC} — removed"
      else
        echo -e "  ${YELLOW}⊘ $skill${NC} — symlink points elsewhere, skipping"
      fi
    fi
  done

  echo ""
  echo -e "${CYAN}[$tool]${NC} Done."
}

# ─── Argument parsing ────────────────────────────────────────────────────────
TOOL=""
SKILL_FILTER=""
UNINSTALL=false
LIST=false

while [ $# -gt 0 ]; do
  case "$1" in
    --tool)
      TOOL="$2"
      shift 2
      ;;
    --skill)
      SKILL_FILTER="$2"
      shift 2
      ;;
    --uninstall)
      UNINSTALL=true
      shift
      ;;
    --list)
      LIST=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      usage
      exit 1
      ;;
  esac
done

# ─── Execute ─────────────────────────────────────────────────────────────────
if $LIST; then
  list_skills
  exit 0
fi

if [ -z "$TOOL" ]; then
  echo -e "${RED}Error: --tool is required (claude, gemini, copilot, antigravity, all)${NC}"
  echo ""
  usage
  exit 1
fi

# Validate tool
if [ "$TOOL" != "all" ] && ! is_valid_tool "$TOOL"; then
  echo -e "${RED}Error: Unknown tool '$TOOL'. Use: claude, gemini, copilot, antigravity, all${NC}"
  exit 1
fi

# Determine target tools
if [ "$TOOL" = "all" ]; then
  targets="$ALL_TOOLS"
else
  targets="$TOOL"
fi

# Run install or uninstall
for t in $targets; do
  echo ""
  echo -e "${CYAN}━━━ $t ━━━${NC}"
  if $UNINSTALL; then
    uninstall_skills "$t" "$SKILL_FILTER"
  else
    install_skills "$t" "$SKILL_FILTER"
  fi
done
