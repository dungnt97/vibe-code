# CLAUDE.md — Project Instructions for Claude Code

Read AGENTS.md for full operational instructions.
Read PROJECT_RULES.md for escalation rules.
Read WORKFLOW.md for daily operating loop.

## Tool Integration Rules

These tools work together. Follow these integration rules STRICTLY:

### After Superpowers brainstorming/planning completes:
- Create beads from the plan: `br create "task title" --type task --priority <n>` for each task
- Add dependencies between beads: `br dep add <id> <dep-id>`
- Use `bv --robot-plan` to verify the task graph makes sense

### After `/opsx:propose` generates tasks.md:
- Create one bead per top-level task: `br create "..." --type task --priority <n>`
- Add dependencies between beads matching the task order
- Add spec reference: `br update <id> --comment "Spec: openspec/changes/<name>/"`
- Use `bv --robot-plan` to verify the execution plan

### After completing any task:
- Run validation (tests, lint)
- Close the bead: `br close <id> --reason "what was done"`
- Sync: `br sync --flush-only`
- Check what unblocked: `bv --robot-next`

### When using Context7:
- Use `/context7:docs <query>` when referencing any library/framework API
- Context7 also auto-invokes — no need to call explicitly for common lookups

### When using mcp_agent_mail (multi-agent only):
- Thread IDs must match bead IDs: `thread_id = "bd-XXXXXX"`
- Reserve files before editing: `file_reservation_paths(...)`
- Release files after committing

## Quick Reference

### Task commands
- `br q "description"` — quick capture a task
- `br create "title" --type <type> --priority <n>` — detailed task creation
- `br list --status open` — see open tasks
- `br ready` — see unblocked tasks
- `br update <id> --status in_progress` — claim a task
- `br close <id> --reason "..."` — close a task
- `br dep add <id> <dep-id>` — add dependency
- `br sync --flush-only` — export to JSONL

### Triage commands
- `bv --robot-next` — recommended next task
- `bv --robot-triage` — full triage
- `bv --robot-plan` — parallel execution plan
- `bv --robot-alerts` — stale/blocked items

### Spec commands
- `/opsx:propose "name"` — start a spec (creates proposal + design + tasks)
- `/opsx:apply` — implement from spec
- `/opsx:archive` — archive completed spec

### Plugin commands
- `/context7:docs <query>` — look up library/API docs
- Superpowers skills auto-activate (brainstorm, plan, TDD, debug, review)
- Code Review plugin runs on PR review requests
- Security Guidance scans edits automatically

### Custom commands
- `/start-session` — daily start routine
- `/end-session` — daily end routine
- `/triage` — full task triage
- `/new-task` — guided task creation
- `/close-task` — guided task closure
- `/propose-spec` — guided spec creation

## Rules
- Always create a bead before starting work
- After any planning/spec step, create beads with dependencies
- Use `--json` flag when parsing command output programmatically
- Use `--robot-*` flags for bv (never depend on interactive TUI)
- Validate before closing any bead
- Sync JSONL after status changes
- Follow escalation rules in PROJECT_RULES.md
