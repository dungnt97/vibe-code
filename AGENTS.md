# AGENTS.md — Instructions for Claude Sessions

You are working in an AI Vibecode OS repository. Read this file at the start of every session.

## Your Tools

### Core Stack
1. **Superpowers** — execution methodology. Skills auto-activate (brainstorm, plan, TDD, debug, code-review). Follow them.
2. **beads_rust (br)** — task tracker. Source of truth for all work items. Always use `--json` when parsing output programmatically.
3. **beads_viewer (bv)** — planning lens. Use `--robot-*` commands for machine-readable output. Never depend on interactive TUI in automated flows.
4. **mcp_agent_mail** — coordination layer. Only use when multiple agents are active or delegation is needed.
5. **OpenSpec** — spec layer. Only use when escalation rules in PROJECT_RULES.md require it.

### Plugins (Claude Code)
6. **Context7** (71.8k installs) — live library/API docs. Auto-invokes when you reference libraries. Command: `/context7:docs <query>`.
7. **Code Review** (50k installs) — multi-agent parallel code review with confidence scoring (only flags score ≥ 80).
8. **Security Guidance** (25.5k installs) — scans edits for OWASP vulns (injection, XSS, hardcoded secrets) before commit.
9. **Playwright** (28.1k installs) — browser automation and E2E testing. Install when building web apps.
10. **Frontend Design** (96.4k installs) — better AI-generated UI. Install when doing frontend work.
11. **Ralph Loop** (57k installs) — autonomous long coding sessions. Install when needed.

## Session Start Checklist

```bash
# 1. Understand repo state
git status && git log --oneline -5

# 2. Check open tasks
br list --status open --json

# 3. Find best next task
bv --robot-next

# 4. Check for pending specs (if any)
ls openspec/changes/ 2>/dev/null

# 5. Check inbox (if multi-agent)
# Use mcp_agent_mail fetch_inbox tool
```

## How to Choose What to Do

1. Run `bv --robot-next` — it returns the highest-impact unblocked task
2. If no tasks exist, ask the user what to work on
3. If the task is blocked, run `bv --robot-triage` to find an unblocking path
4. Never start a task without a bead. Create one first: `br q "description"` or `br create "title" --type <type> --priority <n>`

## How to Work on a Task

### Quick task (Layer A)
```bash
br update <id> --status in_progress
# implement
# validate (run tests, lint, etc.)
br close <id> --reason "Brief description of what was done"
```

### Normal task (Layer B)
```bash
br update <id> --status in_progress
bv --robot-triage              # check for blockers/dependencies
# implement with Superpowers workflow
# validate
br close <id> --reason "Description"
br sync --flush-only           # export to JSONL for git
```

### Coordinated task (Layer C)
```bash
# Register identity via mcp_agent_mail
# Reserve files: file_reservation_paths(...)
# Send status messages to thread matching bead ID
# Release files when done
# Close bead
```

### Spec-driven task (Layer D)
```bash
# /opsx:propose "feature-name"
# Review specs with user
# /opsx:apply
# Create beads for each task in tasks.md
# Implement against spec
# /opsx:archive when complete
```

## Beads Conventions

- **Statuses**: open, in_progress, closed
- **Priorities**: 0 (critical), 1 (high), 2 (medium), 3 (low), 4 (backlog)
- **Types**: bug, feature, task, chore, spike
- **IDs**: auto-generated as `bd-<hash>` — always reference by ID
- **Dependencies**: `br dep add <id> <blocks-on-id>`
- **Quick capture**: `br q "description"` for fast task creation
- **JSON output**: append `--json` to any command for machine-readable output

## Beads Viewer Conventions

Always use robot mode for programmatic access:

```bash
bv --robot-next                # Top pick + claim command
bv --robot-triage              # Full recommendations
bv --robot-plan                # Parallel execution tracks
bv --robot-insights            # Graph metrics, bottlenecks
bv --robot-graph --graph-format=json  # Dependency graph as JSON
bv --robot-alerts              # Stale issues, cascading blocks
bv --robot-suggest             # Hygiene: duplicates, missing deps
```

Filter with labels and recipes:
```bash
bv --robot-plan --label backend
bv --recipe actionable --robot-plan
bv --recipe high-impact --robot-triage
```

## OpenSpec Conventions

- Specs live in `openspec/changes/<feature-name>/`
- Each change has: proposal.md, specs/, design.md, tasks.md
- Archived changes go to `openspec/changes/archive/`
- Use `/opsx:propose` to start, `/opsx:apply` to implement, `/opsx:archive` to close
- Do NOT create specs for quick/trivial tasks — see PROJECT_RULES.md escalation rules

## Agent Mail Conventions

- Agent names: AdjectiveNoun format (e.g., SwiftFalcon, CalmRiver)
- Thread IDs: match bead IDs (e.g., `bd-abc123`)
- File leases: always reserve before editing shared files in multi-agent mode
- Always release leases when done
- Check inbox at session start in multi-agent mode

## Decision Records

When making a non-obvious technical decision:
1. Create `docs/decisions/NNNN-short-title.md` using the template in `templates/decision.md`
2. Reference the decision in relevant beads and specs
3. Decisions are append-only — supersede, don't edit

## What NOT to Do

- Do NOT create beads for sub-steps of a task (use checklist comments instead)
- Do NOT use OpenSpec for tasks under 2 hours unless they're risky/ambiguous
- Do NOT send agent mail when working solo
- Do NOT depend on bv interactive TUI in automated flows — use `--robot-*`
- Do NOT skip validation before closing a bead
- Do NOT amend someone else's commits
- Do NOT force-push without explicit user approval
