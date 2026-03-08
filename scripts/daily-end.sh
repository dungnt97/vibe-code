#!/usr/bin/env bash
# Daily session end — run before closing
set -euo pipefail

echo "═══ Session End ═══"
echo ""

# Check for in-progress tasks
echo "── Still In Progress ──"
br list --status in_progress 2>/dev/null || echo "None"
echo ""

# Alerts
echo "── Alerts ──"
bv --robot-alerts 2>/dev/null || echo "No alerts"
echo ""

# Sync beads
echo "── Syncing Beads ──"
br sync --flush-only 2>/dev/null && echo "✓ JSONL exported" || echo "Nothing to sync"
echo ""

# Check for uncommitted changes
echo "── Uncommitted Changes ──"
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    git status --short
    echo ""
    echo "⚠ You have uncommitted changes. Consider committing before ending session."
else
    echo "Working tree clean"
fi
echo ""
echo "═══ Session ended ═══"
