#!/usr/bin/env bash
# Daily session start — run at beginning of each work session
set -euo pipefail

echo "═══ Session Start ═══"
echo ""

# Git sync
echo "── Git ──"
git fetch --quiet 2>/dev/null && echo "Remote fetched" || echo "No remote configured"
git status --short
echo ""

# Import any JSONL changes from collaborators
echo "── Beads Sync ──"
br sync --import-only 2>/dev/null || echo "No JSONL to import"
echo ""

# Open tasks
echo "── Open Tasks ──"
br list --status open 2>/dev/null || echo "No tasks"
echo ""

# In progress
echo "── In Progress ──"
br list --status in_progress 2>/dev/null || echo "None"
echo ""

# Next recommendation
echo "── Recommended Next ──"
bv --robot-next 2>/dev/null || br ready 2>/dev/null || echo "No recommendation available"
echo ""

# Alerts
echo "── Alerts ──"
bv --robot-alerts 2>/dev/null || echo "No alerts"
echo ""

# Active specs
echo "── Active Specs ──"
if [ -d openspec/changes ]; then
    found=0
    for d in openspec/changes/*/; do
        [ -d "$d" ] && [ "$(basename "$d")" != "archive" ] && echo "  • $(basename "$d")" && found=1
    done
    [ "$found" -eq 0 ] && echo "  None"
else
    echo "  None"
fi
echo ""
echo "═══ Ready ═══"
