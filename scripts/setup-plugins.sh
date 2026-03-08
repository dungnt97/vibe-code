#!/usr/bin/env bash
# ────────────────────────────────────────────────────────────────────
# AI Vibecode OS — Claude Code Plugins Setup
#
# Prints exact commands to paste into Claude Code session.
#
# Usage:
#   bash scripts/setup-plugins.sh            # Show install commands
#   bash scripts/setup-plugins.sh --update   # Show update commands
# ────────────────────────────────────────────────────────────────────

UPDATE=false
[[ "${1:-}" == "--update" || "${1:-}" == "-u" ]] && UPDATE=true

BOLD='\033[1m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
DIM='\033[2m'
NC='\033[0m'

echo ""
echo -e "${BOLD}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║  Claude Code — Plugin Setup                               ║${NC}"
echo -e "${BOLD}║  Paste these commands into your Claude Code session       ║${NC}"
echo -e "${BOLD}╚════════════════════════════════════════════════════════════╝${NC}"

section() {
    echo -e "\n${BOLD}${CYAN}$1${NC}  ${DIM}($2)${NC}"
}

cmd() {
    echo -e "  ${GREEN}$1${NC}"
}

note() {
    echo -e "  ${DIM}# $1${NC}"
}

# ═══════════════════════════════════════════════════════════════════
# CORE — install these (stable, high adoption)
# ═══════════════════════════════════════════════════════════════════

echo -e "\n${BOLD}${YELLOW}═══ CORE (install all) ═══${NC}"

section "Superpowers" "54k+ stars — brainstorm, plan, TDD, debug, review"
if $UPDATE; then
    cmd "/plugin update superpowers"
else
    cmd "/plugin marketplace add obra/superpowers-marketplace"
    cmd "/plugin install superpowers@superpowers-marketplace"
fi
note "Auto-activates all skills — no manual invocation needed"

section "Context7" "71.8k installs — real-time library docs, kills hallucinations"
if $UPDATE; then
    cmd "/plugin update context7"
else
    cmd "/plugin install context7@claude-plugins-official"
fi
note "Auto-invokes on library references. Manual: /context7:docs <query>"

section "Code Review" "50k installs — parallel multi-agent review"
if $UPDATE; then
    cmd "/plugin update code-review"
else
    cmd "/plugin install code-review@claude-plugins-official"
fi
note "5 agents review in parallel, only flags confidence >= 80"

section "Security Guidance" "25.5k installs — OWASP vuln scanner"
if $UPDATE; then
    cmd "/plugin update security-guidance"
else
    cmd "/plugin install security-guidance@claude-plugins-official"
fi
note "Scans edits for injection, XSS, secrets before commit"

# ═══════════════════════════════════════════════════════════════════
# SITUATIONAL — install based on your project type
# ═══════════════════════════════════════════════════════════════════

echo -e "\n${BOLD}${YELLOW}═══ SITUATIONAL (install if needed) ═══${NC}"

section "Playwright" "28.1k installs — browser E2E testing"
if $UPDATE; then
    cmd "/plugin update playwright"
else
    cmd "/plugin install playwright@claude-plugins-official"
fi
note "Install when: building web apps that need E2E tests"

section "Frontend Design" "96.4k installs — better AI-generated UI"
if $UPDATE; then
    cmd "/plugin update frontend-design"
else
    cmd "/plugin install frontend-design@claude-plugins-official"
fi
note "Install when: building web UI, want polished layouts"

section "Ralph Loop" "57k installs — autonomous long coding sessions"
if $UPDATE; then
    cmd "/plugin update ralph-loop"
else
    cmd "/plugin install ralph-loop@claude-plugins-official"
fi
note "Install when: want Claude to work autonomously for hours"

section "Figma MCP" "18.1k installs — design-to-code"
if $UPDATE; then
    cmd "/plugin update figma"
else
    cmd "/plugin install figma@claude-plugins-official"
fi
note "Install when: have Figma designs to convert"

# ═══════════════════════════════════════════════════════════════════
# COPY-PASTE BLOCK
# ═══════════════════════════════════════════════════════════════════

echo -e "\n${BOLD}═══ QUICK COPY-PASTE (Core only) ═══${NC}"
echo ""

if $UPDATE; then
cat << 'BLOCK'
/plugin update superpowers
/plugin update context7
/plugin update code-review
/plugin update security-guidance
BLOCK
else
cat << 'BLOCK'
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
/plugin install context7@claude-plugins-official
/plugin install code-review@claude-plugins-official
/plugin install security-guidance@claude-plugins-official
BLOCK
fi

echo ""
echo -e "${BOLD}${GREEN}Paste commands above into Claude Code.${NC}"
echo ""
