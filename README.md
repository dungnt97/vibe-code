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
# 1. Bootstrap everything
make setup

# 2. Initialize task tracker
br init

# 3. Start working
br q "My first task"
br ready
# ... implement ...
br close <id> --reason "Done"
```

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
bv --robot-triage             # Full triage view
# implement
br close <id> --reason "Refactored"
```

### Layer C: Coordinated Mode
For parallel agents or delegated work:
```bash
# Agent registers and coordinates via mcp_agent_mail MCP tools
# See WORKFLOW.md for conventions
```

### Layer D: Structured Spec Mode
For non-trivial features or risky changes:
```bash
/opsx:propose "add-payment-system"
# Review and refine specs
/opsx:apply
# Implement against spec
/opsx:archive
```

## Key Files

| File | Purpose |
|------|---------|
| `AGENTS.md` | Instructions for Claude sessions |
| `WORKFLOW.md` | Operating model and daily loop |
| `PROJECT_RULES.md` | Escalation rules and conventions |
| `Makefile` | Setup and daily commands |
| `scripts/` | Bootstrap and helper scripts |

## Repo Structure

```
.
├── .beads/                  # Task database (br init creates this)
├── .claude/
│   ├── commands/            # Custom Claude Code commands
│   └── settings/            # Claude Code settings
├── .mail/                   # Agent mail storage (when multi-agent)
├── openspec/                # Specs and proposals (openspec init creates this)
│   ├── changes/
│   └── project.md
├── docs/
│   ├── specs/               # Supplementary spec docs
│   └── decisions/           # Architecture decision records
├── scripts/                 # Setup and helper scripts
├── templates/               # Message and spec templates
├── examples/                # Example tasks, specs, messages
├── AGENTS.md
├── WORKFLOW.md
├── PROJECT_RULES.md
├── Makefile
└── README.md
```

## Requirements

- macOS (primary) or Linux
- Node.js >= 20.19.0
- Rust/Cargo
- Claude Code CLI
- Python 3.11+ with uv (for mcp_agent_mail)

## License

MIT
