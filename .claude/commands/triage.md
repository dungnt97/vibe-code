Run a full triage of the current task graph:

1. Run `bv --robot-triage` and parse the JSON output
2. Present to the user:
   - Top recommended task with reasoning
   - Quick wins (low effort, high impact)
   - Current blockers and what they block
   - Any stale or stuck tasks
   - Project health summary
3. Ask the user which task to work on next
4. If user picks a task, update its status to in_progress: `br update <id> --status in_progress`
