#!/usr/bin/env bash
set -euo pipefail

TEMPLATE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

usage() {
  echo "Usage: bash scripts/clone-template.sh /path/to/new-project"
  echo ""
  echo "Clone the Vibecode OS starter template into a new project directory."
  exit 1
}

if [ $# -lt 1 ]; then
  usage
fi

TARGET="$1"

if [ -e "$TARGET" ]; then
  echo "Error: Target directory '$TARGET' already exists."
  exit 1
fi

echo "Cloning Vibecode OS template into: $TARGET"

# Create target directory
mkdir -p "$TARGET"

# Copy top-level files
for f in .gitignore CLAUDE.md AGENTS.md WORKFLOW.md PROJECT_RULES.md README.md Makefile; do
  if [ -e "$TEMPLATE_DIR/$f" ]; then
    cp "$TEMPLATE_DIR/$f" "$TARGET/$f"
  fi
done

# Copy directories (excluding those that will be re-initialized)
for d in docs examples scripts templates; do
  if [ -d "$TEMPLATE_DIR/$d" ]; then
    cp -R "$TEMPLATE_DIR/$d" "$TARGET/$d"
  fi
done

# Copy .claude/commands/ and .claude/settings/ (skip .claude/skills/)
if [ -d "$TEMPLATE_DIR/.claude" ]; then
  mkdir -p "$TARGET/.claude"
  for sub in commands settings; do
    if [ -d "$TEMPLATE_DIR/.claude/$sub" ]; then
      cp -R "$TEMPLATE_DIR/.claude/$sub" "$TARGET/.claude/$sub"
    fi
  done
fi

# Initialize fresh git repo
echo ""
echo "Initializing git repository..."
git -C "$TARGET" init -q

# Initialize beads
if command -v br &>/dev/null; then
  echo "Initializing beads task tracker..."
  (cd "$TARGET" && br init)
else
  echo "Warning: 'br' (beads_rust) not found. Run 'br init' manually after installing."
fi

# Initialize openspec if available
if command -v openspec &>/dev/null; then
  echo "Initializing OpenSpec..."
  (cd "$TARGET" && openspec init)
else
  echo "Note: 'openspec' not found. Run 'openspec init' manually if needed."
fi

echo ""
echo "Done! New project created at: $TARGET"
echo ""
echo "Next steps:"
echo "  cd $TARGET"
echo "  git add -A && git commit -m 'Initial commit from Vibecode OS template'"
echo "  # Install tools if not already available:"
echo "  #   cargo install beads_rust     — task tracker"
echo "  #   cargo install beads_viewer   — triage/planning"
echo "  #   npm install -g openspec      — spec management"
echo "  # Then run: bash scripts/setup.sh"
