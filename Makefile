# AI Vibecode OS — Makefile
# Just run `make` to see all commands

.DEFAULT_GOAL := help

# ─── Help ──────────────────────────────────────────────────────────

help:
	@echo ""
	@echo "\033[1m  Vibecode OS Commands\033[0m"
	@echo "\033[1m  ════════════════════\033[0m"
	@echo ""
	@echo "\033[1m  First time:\033[0m"
	@echo "    make setup           Install everything (tools + plugins + token)"
	@echo "    make health          Verify all tools are working"
	@echo ""
	@echo "\033[1m  Daily:\033[0m"
	@echo "    make status          Git + tasks overview"
	@echo "    make next            Recommended next task"
	@echo "    make triage          Full triage view"
	@echo "    make plan            Parallel execution plan"
	@echo "    make sync            Export beads to git"
	@echo ""
	@echo "\033[1m  Services:\033[0m"
	@echo "    make start-services  Start all services (Agent Mail + Beads Viewer)"
	@echo "    make stop-services   Stop all services"
	@echo "    make services-status Check all services status"
	@echo "    make bv-refresh      Re-export beads data to viewer"
	@echo ""
	@echo "\033[1m  Maintenance:\033[0m"
	@echo "    make update          Update all tools to latest"
	@echo "    make install-plugins Auto-install Claude Code plugins"
	@echo "    make health          Run full health check"
	@echo ""
	@echo "\033[2m  Advanced: make [setup|update]-[br|bv|openspec|mail|plugins]\033[0m"
	@echo "\033[2m  More:     make [alerts|insights|graph|graph-html|validate|clean]\033[0m"
	@echo ""

# ─── Setup & Update ────────────────────────────────────────────────

setup:
	@bash scripts/setup.sh

update:
	@bash scripts/setup.sh --update

setup-br:
	@echo "→ Installing beads_rust (br)..."
	@command -v br >/dev/null 2>&1 || \
		curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_rust/main/install.sh?$$(date +%s)" | bash
	@echo "✓ br: $$(br --version 2>/dev/null || echo 'check PATH')"

update-br:
	@echo "→ Updating beads_rust (br)..."
	@curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_rust/main/install.sh?$$(date +%s)" | bash
	@echo "✓ br: $$(br --version 2>/dev/null || echo 'check PATH')"

setup-bv:
	@echo "→ Installing beads_viewer (bv)..."
	@command -v bv >/dev/null 2>&1 || \
		curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_viewer/main/install.sh" | bash
	@echo "✓ bv: $$(bv --version 2>/dev/null || echo 'check PATH')"

update-bv:
	@echo "→ Updating beads_viewer (bv)..."
	@if command -v brew >/dev/null 2>&1; then \
		brew upgrade dicklesworthstone/tap/bv 2>/dev/null || \
		curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_viewer/main/install.sh" | bash; \
	else \
		curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_viewer/main/install.sh" | bash; \
	fi
	@echo "✓ bv: $$(bv --version 2>/dev/null || echo 'check PATH')"

setup-openspec:
	@echo "→ Installing OpenSpec..."
	@command -v openspec >/dev/null 2>&1 || npm install -g @fission-ai/openspec@latest
	@echo "✓ openspec: $$(openspec --version 2>/dev/null || echo 'check PATH')"

update-openspec:
	@echo "→ Updating OpenSpec..."
	@npm install -g @fission-ai/openspec@latest
	@openspec update 2>/dev/null || true
	@echo "✓ openspec: $$(openspec --version 2>/dev/null || echo 'check PATH')"

setup-mail:
	@echo "→ Installing mcp_agent_mail..."
	@if [ ! -d "$$HOME/.mcp_agent_mail" ]; then \
		curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/mcp_agent_mail/main/scripts/install.sh?$$(date +%s)" | bash -s -- --yes; \
	fi
	@echo "✓ mcp_agent_mail installed"

update-mail:
	@echo "→ Updating mcp_agent_mail..."
	@if [ -d "$$HOME/.mcp_agent_mail" ]; then \
		cd "$$HOME/.mcp_agent_mail" && git pull --ff-only && uv sync; \
	else \
		curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/mcp_agent_mail/main/scripts/install.sh?$$(date +%s)" | bash -s -- --yes; \
	fi
	@echo "✓ mcp_agent_mail updated"

setup-plugins:
	@bash scripts/setup-plugins.sh

update-plugins:
	@bash scripts/setup-plugins.sh --update

install-plugins:
	@bash scripts/install-plugins.sh

# ─── Services ─────────────────────────────────────────────────────

start-services:
	@bash scripts/mail-server.sh start
	@bash scripts/bv-server.sh start
	@echo ""
	@echo "  Agent Mail:    http://localhost:8765/mail"
	@echo "  Beads Viewer:  http://localhost:9000"

stop-services:
	@bash scripts/mail-server.sh stop
	@bash scripts/bv-server.sh stop

services-status:
	@echo "=== Agent Mail ==="
	@bash scripts/mail-server.sh status
	@echo "\n=== Beads Viewer ==="
	@bash scripts/bv-server.sh status

start-mail:
	@bash scripts/mail-server.sh start

stop-mail:
	@bash scripts/mail-server.sh stop

mail-status:
	@bash scripts/mail-server.sh status

start-bv:
	@bash scripts/bv-server.sh start

stop-bv:
	@bash scripts/bv-server.sh stop

bv-status:
	@bash scripts/bv-server.sh status

bv-refresh:
	@bash scripts/bv-server.sh refresh

# ─── Daily Commands ────────────────────────────────────────────────

init:
	@echo "→ Initializing beads_rust..."
	@br init 2>/dev/null || echo "  (already initialized or br not in PATH)"
	@echo "→ Initializing OpenSpec..."
	@openspec init 2>/dev/null || echo "  (already initialized or openspec not in PATH)"
	@echo "✓ Project initialized"

status:
	@echo "=== Git Status ==="
	@git status --short 2>/dev/null || echo "(not a git repo)"
	@echo "\n=== Open Tasks ==="
	@br list --status open 2>/dev/null || echo "(br not initialized)"
	@echo "\n=== In Progress ==="
	@br list --status in_progress 2>/dev/null || echo "(none)"

next:
	@bv --robot-next 2>/dev/null || echo "(bv not available — use: br ready)"

triage:
	@bv --robot-triage 2>/dev/null || echo "(bv not available)"

plan:
	@bv --robot-plan 2>/dev/null || echo "(bv not available)"

insights:
	@bv --robot-insights 2>/dev/null || echo "(bv not available)"

alerts:
	@bv --robot-alerts 2>/dev/null || echo "(bv not available)"

graph:
	@bv --robot-graph --graph-format=json 2>/dev/null || echo "(bv not available)"

graph-html:
	@bv --export-graph .beads/graph.html 2>/dev/null && echo "✓ Graph exported to .beads/graph.html" || echo "(bv not available)"

sync:
	@br sync --flush-only
	@git add .beads/issues.jsonl 2>/dev/null
	@echo "✓ Beads synced"

health:
	@bash scripts/health-check.sh $(ARGS)

# ─── Validation ────────────────────────────────────────────────────

test:
	@echo "No test command configured. Override this target in your project."

lint:
	@echo "No lint command configured. Override this target in your project."

validate: test lint

# ─── Cleanup ───────────────────────────────────────────────────────

clean:
	@rm -f .beads/graph.html
	@echo "✓ Cleaned"

.PHONY: help setup update init status next triage plan insights alerts sync health
.PHONY: setup-br setup-bv setup-openspec setup-mail setup-plugins
.PHONY: update-br update-bv update-openspec update-mail update-plugins
.PHONY: install-plugins start-services stop-services services-status
.PHONY: start-mail stop-mail mail-status start-bv stop-bv bv-status bv-refresh
.PHONY: graph graph-html test lint validate clean
