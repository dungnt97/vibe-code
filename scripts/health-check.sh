#!/usr/bin/env bash
# Health check — verify all Vibecode OS tools, configs, and connections
set -euo pipefail

# ─── Argument parsing ──────────────────────────────────────────────
JSON_MODE=false
for arg in "$@"; do
  case "$arg" in
    --json) JSON_MODE=true ;;
  esac
done

# ─── State ─────────────────────────────────────────────────────────
RESULTS=()
HAS_FAIL=false

# ─── Helpers ───────────────────────────────────────────────────────
pass_check() {
  local name="$1" detail="$2"
  RESULTS+=("{\"name\":\"$name\",\"status\":\"pass\",\"detail\":\"$detail\",\"fix\":\"\"}")
  if [ "$JSON_MODE" = false ]; then
    printf "  \033[32m✓\033[0m %-20s %s\n" "$name" "$detail"
  fi
}

fail_check() {
  local name="$1" detail="$2" fix="$3"
  RESULTS+=("{\"name\":\"$name\",\"status\":\"fail\",\"detail\":\"$detail\",\"fix\":\"$fix\"}")
  HAS_FAIL=true
  if [ "$JSON_MODE" = false ]; then
    printf "  \033[31m✗\033[0m %-20s %s\n" "$name" "$detail"
    printf "    fix: %s\n" "$fix"
  fi
}

# ─── CLI tool checks ──────────────────────────────────────────────
check_cli_tool() {
  local name="$1" install_cmd="$2"
  if command -v "$name" >/dev/null 2>&1; then
    local version
    version=$("$name" --version 2>/dev/null | head -1 || echo "unknown")
    pass_check "$name" "$version"
  else
    fail_check "$name" "not found in PATH" "$install_cmd"
  fi
}

# ─── Run checks ───────────────────────────────────────────────────
if [ "$JSON_MODE" = false ]; then
  echo "Vibecode OS Health Check"
  echo "========================"
  echo ""
  echo "CLI Tools:"
fi

check_cli_tool "br" "curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/beads_rust/main/install.sh | bash"
check_cli_tool "bv" "curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/beads_viewer/main/install.sh | bash"
check_cli_tool "openspec" "npm install -g @fission-ai/openspec@latest"

if [ "$JSON_MODE" = false ]; then
  echo ""
  echo "State:"
fi

# Beads initialization
if [ -f ".beads/issues.jsonl" ]; then
  pass_check "beads" "initialized (.beads/issues.jsonl exists)"
else
  fail_check "beads" ".beads/ not initialized" "br init"
fi

# mcp_agent_mail install
if [ -f "$HOME/.mcp_agent_mail/.venv/bin/python" ]; then
  pass_check "mcp_agent_mail" "installed"
else
  fail_check "mcp_agent_mail" "not installed or venv missing" "make setup-mail"
fi

# mcp_agent_mail server
if curl -s http://127.0.0.1:8765/docs >/dev/null 2>&1; then
  pass_check "mail_server" "running on port 8765"
else
  fail_check "mail_server" "not running" "make start-mail"
fi

if [ "$JSON_MODE" = false ]; then
  echo ""
  echo "Plugins:"
fi

# Plugin count
PLUGINS_FILE="$HOME/.claude/plugins/installed_plugins.json"
if [ -f "$PLUGINS_FILE" ]; then
  count=$(python3 -c "import json; print(len(json.load(open('$PLUGINS_FILE'))))" 2>/dev/null || echo "0")
  if [ "$count" -gt 0 ] 2>/dev/null; then
    pass_check "plugins" "$count plugin(s) installed"
  else
    fail_check "plugins" "no plugins found" "claude plugin install <plugin>"
  fi
else
  fail_check "plugins" "installed_plugins.json not found" "claude plugin install <plugin>"
fi

# ─── Output ────────────────────────────────────────────────────────
if [ "$JSON_MODE" = true ]; then
  printf "["
  for i in "${!RESULTS[@]}"; do
    if [ "$i" -gt 0 ]; then printf ","; fi
    printf "%s" "${RESULTS[$i]}"
  done
  printf "]\n"
fi

if [ "$JSON_MODE" = false ]; then
  echo ""
  if [ "$HAS_FAIL" = true ]; then
    echo "Some checks failed. See fix suggestions above."
  else
    echo "All checks passed!"
  fi
fi

# Exit code
if [ "$HAS_FAIL" = true ]; then
  exit 1
else
  exit 0
fi
