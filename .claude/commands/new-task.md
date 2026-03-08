Create a new task/bead. Ask the user for:

1. Title (required) — imperative mood
2. Type (default: task) — bug, feature, task, chore, spike
3. Priority (default: 2) — 0=critical, 1=high, 2=medium, 3=low, 4=backlog
4. Dependencies (optional) — other bead IDs this blocks on

Then run:
```
br create "<title>" --type <type> --priority <priority>
```

If dependencies were specified:
```
br dep add <new-id> <dep-id>
```

Report the new bead ID to the user.

Assess whether this task should escalate beyond Quick mode using the rules in PROJECT_RULES.md. If it should, advise the user.
