#!/usr/bin/env bash
# ────────────────────────────────────────────────────────────────────
# AI Vibecode OS — Auto-install Claude Code Plugins
#
# Installs core plugins using `claude plugin install` CLI.
# Safe to re-run — skips already installed plugins.
#
# Usage:
#   bash scripts/install-plugins.sh
# ────────────────────────────────────────────────────────────────────
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

if ! command -v claude &>/dev/null; then
  echo -e "${RED}claude CLI not found.${NC} Install Claude Code first: https://docs.anthropic.com/en/docs/claude-code"
  exit 1
fi

echo "Installing Claude Code plugins..."
echo ""

install_plugin() {
  local name="$1"
  local source="$2"
  local desc="$3"

  echo -n "  $name ($desc)... "
  if claude plugin install "$name@$source" </dev/null 2>/dev/null; then
    echo -e "${GREEN}ok${NC}"
  else
    echo -e "${YELLOW}skipped (may already be installed)${NC}"
  fi
}

# Add Superpowers marketplace first
echo -n "  Adding superpowers marketplace... "
claude plugin marketplace add obra/superpowers-marketplace </dev/null 2>/dev/null \
  && echo -e "${GREEN}ok${NC}" \
  || echo -e "${YELLOW}already added${NC}"
echo ""

# Core plugins
echo "Core plugins:"
install_plugin "superpowers"       "superpowers-marketplace"   "brainstorm, plan, TDD, debug, review"
install_plugin "context7"          "claude-plugins-official"   "real-time library docs"
install_plugin "code-review"       "claude-plugins-official"   "multi-agent code review"
install_plugin "security-guidance" "claude-plugins-official"   "OWASP vulnerability scanner"

echo ""
echo -e "${GREEN}Done!${NC} Restart Claude Code to activate new plugins."
