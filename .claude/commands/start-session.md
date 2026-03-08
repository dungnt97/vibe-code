Run the daily session start routine:

1. Check git status and recent commits
2. Import any beads JSONL changes: `br sync --import-only`
3. List open tasks: `br list --status open`
4. List in-progress tasks: `br list --status in_progress`
5. Get recommended next task: `bv --robot-next` (fall back to `br ready` if bv unavailable)
6. Check for active specs: list `openspec/changes/` excluding archive
7. Present a concise summary to the user with recommended next action
