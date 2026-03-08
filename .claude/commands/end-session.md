Run the daily session end routine:

1. List any tasks still in_progress: `br list --status in_progress`
2. Check for alerts: `bv --robot-alerts`
3. Sync beads to JSONL: `br sync --flush-only`
4. Check for uncommitted changes: `git status`
5. If there are uncommitted beads changes, stage and commit them
6. Present summary to user: what's still open, any warnings
