Close a completed task/bead.

1. Ask user which bead to close (or accept bead ID as argument)
2. Run validation:
   - `make validate` (or project-specific test/lint commands)
   - If validation fails, report errors and do NOT close the bead
3. If validation passes:
   - `br close <id> --reason "<brief description of what was done>"`
   - `br sync --flush-only`
4. Check if this unblocked other tasks: `br ready`
5. Report: what was closed, what's now unblocked, recommended next task
