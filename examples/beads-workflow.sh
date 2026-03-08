#!/usr/bin/env bash
# Example: Complete beads workflow from creation to closure
# This is a reference — not meant to be run as-is

# ─── Quick capture ──────────────────────────────────
br q "Fix broken login redirect"
# Output: Created bd-a1b2c3

# ─── Detailed creation ──────────────────────────────
br create "Implement OAuth2 login flow" --type feature --priority 1
# Output: Created bd-d4e5f6

br create "Set up OAuth2 callback endpoint" --type task --priority 1
# Output: Created bd-g7h8i9

br create "Add OAuth2 config to env" --type chore --priority 2
# Output: Created bd-j0k1l2

# ─── Dependencies ───────────────────────────────────
# OAuth2 login depends on callback endpoint
br dep add bd-d4e5f6 bd-g7h8i9

# Callback endpoint depends on config
br dep add bd-g7h8i9 bd-j0k1l2

# ─── Check what's ready ─────────────────────────────
br ready
# Output: bd-j0k1l2 "Add OAuth2 config to env" (no blockers)
# Output: bd-a1b2c3 "Fix broken login redirect" (no blockers)

# ─── Work on a task ─────────────────────────────────
br update bd-j0k1l2 --status in_progress

# ... do the work ...

br close bd-j0k1l2 --reason "Added OAUTH_CLIENT_ID and OAUTH_SECRET to .env.example"

# ─── Check what unblocked ───────────────────────────
br ready
# Now bd-g7h8i9 is unblocked

# ─── Use viewer for triage ──────────────────────────
bv --robot-next
# Returns the highest-impact unblocked task

bv --robot-triage
# Full recommendations with quick wins and blockers

# ─── Export for git ─────────────────────────────────
br sync --flush-only
git add .beads/issues.jsonl
git commit -m "[beads] Update task status"

# ─── JSON output for programmatic use ───────────────
br list --status open --json | jq '.[] | {id, title, priority}'
bv --robot-triage | jq '.recommendations[0]'
