#!/usr/bin/env bash
# Example: OpenSpec workflow for a non-trivial feature
# This shows the commands and flow — run interactively in Claude Code

# ─── Step 1: Propose ────────────────────────────────
# In Claude Code:
#   /opsx:propose "add-payment-system"
#
# This creates:
#   openspec/changes/add-payment-system/
#   ├── proposal.md    — why we're doing this, scope
#   ├── specs/         — requirements, scenarios
#   ├── design.md      — technical approach
#   └── tasks.md       — implementation checklist

# ─── Step 2: Review with user ───────────────────────
# Claude presents the spec for review
# User provides feedback
# Claude iterates on specs
# Repeat until approved

# ─── Step 3: Create beads from tasks ────────────────
# For each top-level task in tasks.md:
br create "Set up Stripe SDK integration" --type task --priority 1
# → bd-pay001

br create "Implement checkout endpoint" --type feature --priority 1
# → bd-pay002

br create "Add payment webhook handler" --type feature --priority 1
# → bd-pay003

br create "Write payment integration tests" --type task --priority 2
# → bd-pay004

# Dependencies
br dep add bd-pay002 bd-pay001   # checkout needs SDK
br dep add bd-pay003 bd-pay001   # webhook needs SDK
br dep add bd-pay004 bd-pay002   # tests need checkout
br dep add bd-pay004 bd-pay003   # tests need webhook

# ─── Step 4: Implement ──────────────────────────────
# In Claude Code:
#   /opsx:apply
#
# Claude implements tasks in dependency order
# Each completed task → close the corresponding bead

# ─── Step 5: Archive ────────────────────────────────
# When all tasks complete:
#   /opsx:archive
#
# Moves to: openspec/changes/archive/2026-03-08-add-payment-system/

# ─── Step 6: Decision record (if applicable) ────────
# If non-obvious decisions were made during implementation:
# Create docs/decisions/0002-use-stripe-over-square.md
