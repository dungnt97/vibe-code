#!/usr/bin/env bash
# ────────────────────────────────────────────────────────────────────
# AI Vibecode OS — Setup & Update Script
#
# Usage:
#   bash scripts/setup.sh            # Fresh install (skip if already installed)
#   bash scripts/setup.sh --update   # Force update all tools to latest version
#   bash scripts/setup.sh --help     # Show help
# ────────────────────────────────────────────────────────────────────
set -euo pipefail

# ─── Config ─────────────────────────────────────────────────────────

UPDATE=false
VERBOSE=false
SKIP_GIT_INIT=false
SKIP_COMMIT=false

for arg in "$@"; do
    case "$arg" in
        --update|-u)   UPDATE=true ;;
        --verbose|-v)  VERBOSE=true ;;
        --skip-git)    SKIP_GIT_INIT=true ;;
        --skip-commit) SKIP_COMMIT=true ;;
        --help|-h)
            echo "Usage: bash scripts/setup.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --update, -u      Force update all tools to latest version"
            echo "  --verbose, -v     Show detailed output"
            echo "  --skip-git        Skip git init"
            echo "  --skip-commit     Skip initial git commit"
            echo "  --help, -h        Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $arg (use --help)"
            exit 1
            ;;
    esac
done

# ─── Helpers ────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${CYAN}→${NC} $*"; }
success() { echo -e "  ${GREEN}✓${NC} $*"; }
warn()    { echo -e "  ${YELLOW}⚠${NC} $*"; }
fail()    { echo -e "  ${RED}✗${NC} $*"; }
header()  { echo -e "\n${BOLD}── $* ──${NC}"; }

check_cmd() {
    local cmd="$1"
    local hint="$2"
    if command -v "$cmd" &>/dev/null; then
        success "$cmd found: $("$cmd" --version 2>/dev/null | head -1)"
        return 0
    else
        fail "$cmd NOT FOUND — $hint"
        return 1
    fi
}

run_quiet() {
    if $VERBOSE; then
        "$@"
    else
        "$@" 2>&1 | tail -3
    fi
}

# ─── Banner ─────────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════╗${NC}"
if $UPDATE; then
echo -e "${BOLD}║  AI Vibecode OS — Update to Latest               ║${NC}"
else
echo -e "${BOLD}║  AI Vibecode OS — Setup                          ║${NC}"
fi
echo -e "${BOLD}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# ─── Prerequisites ──────────────────────────────────────────────────

header "Prerequisites"

prereq_ok=true
check_cmd git     "Install: https://git-scm.com"            || prereq_ok=false
check_cmd node    "Install: https://nodejs.org (>= 20.19)"  || prereq_ok=false
check_cmd npm     "Comes with Node.js"                       || prereq_ok=false
check_cmd cargo   "Install: https://rustup.rs"               || prereq_ok=false

# uv is needed for mcp_agent_mail
if ! command -v uv &>/dev/null; then
    warn "uv not found — will install (needed for mcp_agent_mail)"
fi

if ! $prereq_ok; then
    echo ""
    fail "Missing prerequisites above. Install them and re-run."
    exit 1
fi

# ─── Git Init ───────────────────────────────────────────────────────

if ! $SKIP_GIT_INIT; then
    header "Git"
    if [ -d .git ]; then
        success "Git repo exists"
    else
        info "Initializing git repository..."
        git init -q
        success "Git initialized"
    fi
fi

# ─── beads_rust (br) ───────────────────────────────────────────────

header "beads_rust (br) — Task Tracker"

install_br() {
    info "Installing/updating br..."
    curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_rust/main/install.sh?$(date +%s)" | bash
    success "br installed: $(br --version 2>/dev/null | head -1)"
}

if command -v br &>/dev/null; then
    if $UPDATE; then
        install_br
    else
        success "br already installed: $(br --version 2>/dev/null | head -1)"
        info "Use --update to force update"
    fi
else
    install_br
fi

# Init .beads/
if [ -d .beads ]; then
    success ".beads/ already exists"
else
    info "Initializing beads..."
    br init
    success ".beads/ initialized"
fi

# ─── beads_viewer (bv) ─────────────────────────────────────────────

header "beads_viewer (bv) — Planning & Triage"

install_bv() {
    info "Installing/updating bv..."
    # Try brew first (better update path), fall back to install script
    if command -v brew &>/dev/null; then
        brew install dicklesworthstone/tap/bv 2>/dev/null \
            || brew upgrade dicklesworthstone/tap/bv 2>/dev/null \
            || {
                warn "Brew install failed, trying install script..."
                curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_viewer/main/install.sh" | bash
            }
    else
        curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_viewer/main/install.sh" | bash
    fi
    success "bv installed: $(bv --version 2>/dev/null | head -1)"
}

if command -v bv &>/dev/null; then
    if $UPDATE; then
        install_bv
    else
        success "bv already installed: $(bv --version 2>/dev/null | head -1)"
        info "Use --update to force update"
    fi
else
    install_bv
fi

# ─── OpenSpec ───────────────────────────────────────────────────────

header "OpenSpec — Spec-Driven Development"

install_openspec() {
    info "Installing/updating OpenSpec..."
    npm install -g @fission-ai/openspec@latest
    success "openspec installed: $(openspec --version 2>/dev/null | head -1)"
}

if command -v openspec &>/dev/null; then
    if $UPDATE; then
        install_openspec
    else
        success "openspec already installed: $(openspec --version 2>/dev/null | head -1)"
        info "Use --update to force update"
    fi
else
    install_openspec
fi

# Init openspec/
if [ -d openspec ]; then
    success "openspec/ already exists"
    if $UPDATE; then
        info "Updating OpenSpec agent instructions..."
        openspec update 2>/dev/null || warn "openspec update failed (non-critical)"
    fi
else
    info "Initializing OpenSpec..."
    openspec init
    success "openspec/ initialized"
fi

# ─── mcp_agent_mail ────────────────────────────────────────────────

header "mcp_agent_mail — Multi-Agent Coordination"

MCP_MAIL_DIR="$HOME/.mcp_agent_mail"

install_mail() {
    info "Installing/updating mcp_agent_mail..."

    # Install uv if not present
    if ! command -v uv &>/dev/null; then
        info "Installing uv (Python package manager)..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        export PATH="$HOME/.local/bin:$PATH"
        success "uv installed"
    fi

    if [ -d "$MCP_MAIL_DIR" ]; then
        # Update: pull latest
        info "Updating mcp_agent_mail repo..."
        cd "$MCP_MAIL_DIR"
        git pull --ff-only 2>/dev/null || warn "git pull failed — may need manual update"
        uv sync 2>/dev/null || warn "uv sync failed"
        cd - >/dev/null
    else
        # Manual install (avoids the official installer which starts a foreground server)
        info "Cloning mcp_agent_mail..."
        git clone --depth 1 https://github.com/Dicklesworthstone/mcp_agent_mail "$MCP_MAIL_DIR"
        info "Setting up Python venv + dependencies..."
        cd "$MCP_MAIL_DIR"
        uv venv -p 3.11 2>/dev/null || uv venv 2>/dev/null || warn "venv creation issue"
        uv sync 2>/dev/null || warn "uv sync issue — run manually: cd $MCP_MAIL_DIR && uv sync"
        cd - >/dev/null

        # Create 'am' alias for starting server
        SHELL_RC="$HOME/.zshrc"
        if ! grep -q 'alias am=' "$SHELL_RC" 2>/dev/null; then
            echo "" >> "$SHELL_RC"
            echo "# mcp_agent_mail server" >> "$SHELL_RC"
            echo "alias am='cd $MCP_MAIL_DIR && source .venv/bin/activate && uv run python -m mcp_agent_mail.cli serve-http'" >> "$SHELL_RC"
            success "Added 'am' alias to $SHELL_RC"
        fi
    fi
    success "mcp_agent_mail installed at $MCP_MAIL_DIR"
}

if [ -d "$MCP_MAIL_DIR" ]; then
    if $UPDATE; then
        install_mail
    else
        success "mcp_agent_mail already installed at $MCP_MAIL_DIR"
        info "Use --update to force update"
    fi
else
    install_mail
fi

# Ensure .claude MCP config exists
MCP_CONFIG=".claude/settings/mcp.json"
if [ -f "$MCP_CONFIG" ]; then
    success "MCP config exists: $MCP_CONFIG"
else
    info "Creating MCP config..."
    mkdir -p .claude/settings
    cat > "$MCP_CONFIG" << 'MCPEOF'
{
  "mcpServers": {
    "agent-mail": {
      "url": "http://127.0.0.1:8765/mcp/",
      "headers": {
        "Authorization": "Bearer ${MCP_AGENT_MAIL_TOKEN}"
      }
    }
  }
}
MCPEOF
    success "MCP config created: $MCP_CONFIG"
fi

# ─── Superpowers ────────────────────────────────────────────────────

header "Claude Code Plugins & Skills"

echo -e "  ${YELLOW}Plugins must be installed inside Claude Code.${NC}"
echo ""
echo "  Full install/update guide:"
if $UPDATE; then
    echo "    bash scripts/setup-plugins.sh --update"
else
    echo "    bash scripts/setup-plugins.sh"
fi
echo ""
echo "  Quick-start (paste into Claude Code):"
echo ""
echo "    /plugin marketplace add obra/superpowers-marketplace"
echo "    /plugin marketplace add upstash/context7"
echo "    /plugin marketplace add trailofbits/skills"
echo "    /plugin install superpowers@superpowers-marketplace"
echo "    /plugin install context7-plugin@context7-marketplace"
echo "    /plugin install code-review@claude-plugins-official"
echo "    /plugin install security-guidance@claude-plugins-official"
echo "    /plugin install playwright@claude-plugins-official"
echo ""

# ─── Initial Commit ─────────────────────────────────────────────────

if ! $SKIP_COMMIT && [ -d .git ]; then
    header "Git Commit"
    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
        info "Staging and committing..."
        git add -A
        if $UPDATE; then
            git commit -m "Update AI Vibecode OS tools" 2>/dev/null \
                && success "Committed" \
                || warn "Nothing new to commit"
        else
            git commit -m "Initialize AI Vibecode OS starter template" 2>/dev/null \
                && success "Committed" \
                || warn "Nothing new to commit"
        fi
    else
        success "Working tree clean"
    fi
fi

# ─── Verification ──────────────────────────────────────────────────

header "Verification"

echo ""
all_ok=true

check_cmd br       "Run: make setup-br"       || all_ok=false
check_cmd bv       "Run: make setup-bv"       || all_ok=false
check_cmd openspec "Run: make setup-openspec"  || all_ok=false

echo ""
[ -d .beads ]   && success ".beads/ exists"   || { fail ".beads/ missing";   all_ok=false; }
[ -d openspec ] && success "openspec/ exists"  || { fail "openspec/ missing"; all_ok=false; }
[ -d "$MCP_MAIL_DIR" ] && success "mcp_agent_mail installed" || { fail "mcp_agent_mail missing"; all_ok=false; }
[ -f "$MCP_CONFIG" ]   && success "MCP config exists"        || { fail "MCP config missing";     all_ok=false; }

# ─── Summary ────────────────────────────────────────────────────────

echo ""
if $all_ok; then
    echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════════════╗${NC}"
    if $UPDATE; then
    echo -e "${BOLD}${GREEN}║  All tools updated!                              ║${NC}"
    else
    echo -e "${BOLD}${GREEN}║  Setup complete!                                 ║${NC}"
    fi
    echo -e "${BOLD}${GREEN}╠══════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}${GREEN}║                                                  ║${NC}"
    echo -e "${BOLD}${GREEN}║  Next steps:                                     ║${NC}"
    echo -e "${BOLD}${GREEN}║  1. Open Claude Code in this directory           ║${NC}"
    echo -e "${BOLD}${GREEN}║  2. Install Superpowers plugin (see above)       ║${NC}"
    echo -e "${BOLD}${GREEN}║  3. Run: br q \"My first task\"                    ║${NC}"
    echo -e "${BOLD}${GREEN}║  4. Start building!                              ║${NC}"
    echo -e "${BOLD}${GREEN}║                                                  ║${NC}"
    echo -e "${BOLD}${GREEN}║  Daily commands:                                 ║${NC}"
    echo -e "${BOLD}${GREEN}║    make status    — overview                     ║${NC}"
    echo -e "${BOLD}${GREEN}║    make next      — recommended task             ║${NC}"
    echo -e "${BOLD}${GREEN}║    make triage    — full triage                  ║${NC}"
    echo -e "${BOLD}${GREEN}║    make sync      — export beads to git          ║${NC}"
    echo -e "${BOLD}${GREEN}║                                                  ║${NC}"
    echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════════╝${NC}"
else
    echo -e "${BOLD}${RED}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${RED}║  Setup incomplete — check errors above          ║${NC}"
    echo -e "${BOLD}${RED}╚══════════════════════════════════════════════════╝${NC}"
    exit 1
fi
