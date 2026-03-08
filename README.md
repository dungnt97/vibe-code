# AI Vibecode OS — Starter Template

A production-lean operating system for AI-assisted development with Claude Code.

## What This Is

A reusable starter template that integrates five tools into a layered workflow:

| Layer | Tool | Purpose | When Used |
|-------|------|---------|-----------|
| Execution | **Superpowers** | Structured dev skills (brainstorm, plan, TDD, debug) | Always |
| Tasks | **beads_rust (br)** | Local-first task/issue tracker (SQLite + JSONL) | Always |
| Planning | **beads_viewer (bv)** | Dependency graph, triage, critical path analysis | Normal+ tasks |
| Coordination | **mcp_agent_mail** | Multi-agent messaging, file leases, identity | Multi-agent only |
| Specs | **OpenSpec** | Proposals, specs, design docs, decision records | Non-trivial changes |

## Quick Start

```bash
# 1. Clone and setup (installs all tools + plugins + generates MCP token)
git clone <repo> my-project && cd my-project
make setup

# 2. Verify everything works
make health

# 3. Start working
br q "My first task"
```

That's it. Three commands.

## Commands

Just run `make` to see all available commands:

```
First time:
  make setup           Install everything (tools + plugins + token)
  make health          Verify all tools are working

Daily:
  make status          Git + tasks overview
  make next            Recommended next task
  make triage          Full triage view
  make plan            Parallel execution plan
  make sync            Export beads to git

Multi-agent:
  make start-mail      Start agent mail server
  make stop-mail       Stop agent mail server
  make mail-status     Check server status

Maintenance:
  make update          Update all tools to latest
  make install-plugins Auto-install Claude Code plugins
```

## Claude Code Commands

Inside Claude Code, use these slash commands:

| Command | Purpose |
|---------|---------|
| `/start-session` | Daily start routine (status + inbox + alerts) |
| `/end-session` | Daily end routine (sync + cleanup) |
| `/new-task` | Guided task creation |
| `/close-task` | Guided task closure |
| `/triage` | Full task triage |
| `/propose-spec` | Start a structured spec |
| `/multi-agent` | Start coordinated multi-agent session |
| `/opsx:propose` | Create spec with all artifacts |
| `/opsx:apply` | Implement from spec |
| `/opsx:archive` | Archive completed spec |

## Workflow Layers

### Layer A: Quick Mode (default)
For tiny tasks (< 30 min, single file, no ambiguity):
```bash
br q "Fix typo in login page"
# implement with Claude + Superpowers
br close <id> --reason "Fixed"
```

### Layer B: Normal Mode
For tasks with dependencies or multiple files:
```bash
br create "Refactor auth module" --type task --priority 1
br dep add <new-id> <blocking-id>
bv --robot-next              # What should I do next?
# implement
br close <id> --reason "Refactored"
```

### Layer C: Coordinated Mode
For parallel agents or delegated work:
```bash
make start-mail              # Start the agent mail server
# In Claude Code:
/multi-agent                 # Register lead, spawn sub-agents
# Sub-agents work in worktrees, coordinate via mail
make stop-mail               # When done
```

### Layer D: Structured Spec Mode
For non-trivial features or risky changes:
```bash
/opsx:propose "add-payment-system"
# Review and refine specs (proposal → design → specs → tasks)
/opsx:apply                  # Implement against spec
/opsx:archive                # Archive when complete
```

## Plugins

Installed automatically by `make setup`:

| Plugin | Purpose |
|--------|---------|
| **Superpowers** | Brainstorm, plan, TDD, debug, code review skills |
| **Context7** | Real-time library/API docs |
| **Code Review** | Multi-agent parallel code review |
| **Security Guidance** | OWASP vulnerability scanning |

## Repo Structure

```
.
├── .beads/                  # Task database (auto-created by setup)
├── .claude/
│   ├── commands/            # Slash commands (start-session, multi-agent, etc.)
│   └── settings/            # MCP config (gitignored, auto-generated)
├── openspec/                # Specs and proposals
│   └── changes/             # Active and archived changes
├── scripts/                 # Implementation (called by Makefile)
├── docs/decisions/          # Architecture decision records
├── templates/               # Message templates
├── examples/                # Example workflows
├── CLAUDE.md                # Instructions loaded every Claude session
├── AGENTS.md                # Full operational instructions
├── WORKFLOW.md              # Operating model and daily loop
├── PROJECT_RULES.md         # Escalation rules and conventions
├── Makefile                 # All commands (just run `make`)
└── README.md
```

## Requirements

- macOS or Linux
- Node.js >= 20.19
- Rust/Cargo
- Claude Code CLI
- Python 3.11+ with uv (auto-installed if missing)

## License

MIT
