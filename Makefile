# AI Vibecode OS — Makefile
# Run `make help` for available targets

.PHONY: help setup update setup-br setup-bv setup-mail setup-openspec setup-plugins
.PHONY: update-br update-bv update-openspec update-mail update-plugins
.PHONY: init status next triage plan insights sync
.PHONY: test lint validate clean

# ─── Setup & Update ────────────────────────────────────────────────

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## Full bootstrap (install + init)
	@bash scripts/setup.sh

update: ## Update all tools to latest version
	@bash scripts/setup.sh --update

setup-br: ## Install beads_rust
	@echo "→ Installing beads_rust (br)..."
	@command -v br >/dev/null 2>&1 || \
		curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_rust/main/install.sh?$$(date +%s)" | bash
	@echo "✓ br: $$(br --version 2>/dev/null || echo 'check PATH')"

update-br: ## Update beads_rust to latest
	@echo "→ Updating beads_rust (br)..."
	@curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_rust/main/install.sh?$$(date +%s)" | bash
	@echo "✓ br: $$(br --version 2>/dev/null || echo 'check PATH')"

setup-bv: ## Install beads_viewer
	@echo "→ Installing beads_viewer (bv)..."
	@command -v bv >/dev/null 2>&1 || \
		curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_viewer/main/install.sh" | bash
	@echo "✓ bv: $$(bv --version 2>/dev/null || echo 'check PATH')"

update-bv: ## Update beads_viewer to latest
	@echo "→ Updating beads_viewer (bv)..."
	@if command -v brew >/dev/null 2>&1; then \
		brew upgrade dicklesworthstone/tap/bv 2>/dev/null || \
		curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_viewer/main/install.sh" | bash; \
	else \
		curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_viewer/main/install.sh" | bash; \
	fi
	@echo "✓ bv: $$(bv --version 2>/dev/null || echo 'check PATH')"

setup-openspec: ## Install OpenSpec
	@echo "→ Installing OpenSpec..."
	@command -v openspec >/dev/null 2>&1 || npm install -g @fission-ai/openspec@latest
	@echo "✓ openspec: $$(openspec --version 2>/dev/null || echo 'check PATH')"

update-openspec: ## Update OpenSpec to latest
	@echo "→ Updating OpenSpec..."
	@npm install -g @fission-ai/openspec@latest
	@openspec update 2>/dev/null || true
	@echo "✓ openspec: $$(openspec --version 2>/dev/null || echo 'check PATH')"

setup-mail: ## Install mcp_agent_mail
	@echo "→ Installing mcp_agent_mail..."
	@if [ ! -d "$$HOME/.mcp_agent_mail" ]; then \
		curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/mcp_agent_mail/main/scripts/install.sh?$$(date +%s)" | bash -s -- --yes; \
	fi
	@echo "✓ mcp_agent_mail installed"

update-mail: ## Update mcp_agent_mail to latest
	@echo "→ Updating mcp_agent_mail..."
	@if [ -d "$$HOME/.mcp_agent_mail" ]; then \
		cd "$$HOME/.mcp_agent_mail" && git pull --ff-only && uv sync; \
	else \
		curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/mcp_agent_mail/main/scripts/install.sh?$$(date +%s)" | bash -s -- --yes; \
	fi
	@echo "✓ mcp_agent_mail updated"

setup-plugins: ## Show all Claude Code plugin install commands
	@bash scripts/setup-plugins.sh

update-plugins: ## Show all Claude Code plugin update commands
	@bash scripts/setup-plugins.sh --update

init: ## Initialize beads + openspec in this repo
	@echo "→ Initializing beads_rust..."
	@br init 2>/dev/null || echo "  (already initialized or br not in PATH)"
	@echo "→ Initializing OpenSpec..."
	@openspec init 2>/dev/null || echo "  (already initialized or openspec not in PATH)"
	@echo "✓ Project initialized"

# ─── Daily Commands ─────────────────────────────────────────────────

status: ## Show repo + task status
	@echo "=== Git Status ==="
	@git status --short 2>/dev/null || echo "(not a git repo)"
	@echo "\n=== Open Tasks ==="
	@br list --status open 2>/dev/null || echo "(br not initialized)"
	@echo "\n=== In Progress ==="
	@br list --status in_progress 2>/dev/null || echo "(none)"

next: ## Show recommended next task
	@bv --robot-next 2>/dev/null || echo "(bv not available — use: br ready)"

triage: ## Full triage view
	@bv --robot-triage 2>/dev/null || echo "(bv not available)"

plan: ## Show parallel execution plan
	@bv --robot-plan 2>/dev/null || echo "(bv not available)"

insights: ## Show graph insights (PageRank, bottlenecks)
	@bv --robot-insights 2>/dev/null || echo "(bv not available)"

alerts: ## Show stale/blocked/mismatched items
	@bv --robot-alerts 2>/dev/null || echo "(bv not available)"

graph: ## Export dependency graph as JSON
	@bv --robot-graph --graph-format=json 2>/dev/null || echo "(bv not available)"

graph-html: ## Export interactive HTML dependency graph
	@bv --export-graph .beads/graph.html 2>/dev/null && echo "✓ Graph exported to .beads/graph.html" || echo "(bv not available)"

sync: ## Sync beads JSONL (export + git add)
	@br sync --flush-only
	@git add .beads/issues.jsonl 2>/dev/null
	@echo "✓ Beads synced"

# ─── Validation ─────────────────────────────────────────────────────

test: ## Run tests (override in your project)
	@echo "No test command configured. Override this target in your project."

lint: ## Run linter (override in your project)
	@echo "No lint command configured. Override this target in your project."

validate: test lint ## Run all validation

# ─── Cleanup ────────────────────────────────────────────────────────

clean: ## Remove generated artifacts
	@rm -f .beads/graph.html
	@echo "✓ Cleaned"
