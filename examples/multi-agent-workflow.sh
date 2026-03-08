#!/usr/bin/env bash
# Example: Multi-agent coordination with mcp_agent_mail
# This shows the MCP tool calls — run via Claude Code MCP integration

# ─── Prerequisites ──────────────────────────────────
# 1. mcp_agent_mail server running: am
# 2. MCP configured in Claude Code settings
# 3. Multiple Claude Code instances open

# ─── Lead Agent Setup ───────────────────────────────
# MCP tool calls (in Claude Code):

# ensure_project(project_key="/path/to/repo")
# register_agent(project_key="/path/to/repo", agent_name="LeadFalcon", program="Claude Code", model="claude-opus-4-6")

# ─── Create work items ──────────────────────────────
# br create "Refactor auth module" --type task --priority 1  → bd-auth01
# br create "Refactor database layer" --type task --priority 1  → bd-db01
# br create "Update API endpoints" --type task --priority 1  → bd-api01
# br dep add bd-api01 bd-auth01
# br dep add bd-api01 bd-db01

# ─── Assign to sub-agents ───────────────────────────
# send_message(
#   project_key="/path/to/repo",
#   from_agent="LeadFalcon",
#   to_agents=["SwiftRaven"],
#   thread_id="bd-auth01",
#   subject="[bd-auth01] Task assignment: Refactor auth module",
#   body="... (use templates/agent-message-assignment.md format)"
# )

# send_message(
#   project_key="/path/to/repo",
#   from_agent="LeadFalcon",
#   to_agents=["CalmRiver"],
#   thread_id="bd-db01",
#   subject="[bd-db01] Task assignment: Refactor database layer",
#   body="... (use templates/agent-message-assignment.md format)"
# )

# ─── Sub-Agent: SwiftRaven ──────────────────────────
# register_agent(project_key="/path/to/repo", agent_name="SwiftRaven", ...)
# fetch_inbox(project_key="/path/to/repo", agent_name="SwiftRaven")
# → sees assignment for bd-auth01

# Reserve files before editing:
# file_reservation_paths(
#   project_key="/path/to/repo",
#   agent_name="SwiftRaven",
#   paths=["src/auth/**", "tests/auth/**"],
#   exclusive=true,
#   reason="bd-auth01",
#   ttl_seconds=3600
# )

# ... do the work ...

# Report completion:
# send_message(
#   project_key="/path/to/repo",
#   from_agent="SwiftRaven",
#   to_agents=["LeadFalcon"],
#   thread_id="bd-auth01",
#   subject="[bd-auth01] Completed: Refactor auth module",
#   body="... (use templates/agent-message-completion.md format)"
# )

# Release files:
# release_file_reservations(
#   project_key="/path/to/repo",
#   agent_name="SwiftRaven",
#   paths=["src/auth/**", "tests/auth/**"]
# )

# ─── Lead Agent: Monitor ────────────────────────────
# fetch_inbox(project_key="/path/to/repo", agent_name="LeadFalcon")
# → sees completion reports
# acknowledge_message(...)

# Now bd-api01 is unblocked (both deps done)
# Lead can work on it or assign it

# ─── Blocker Example ────────────────────────────────
# If CalmRiver hits a blocker:
# send_message(
#   project_key="/path/to/repo",
#   from_agent="CalmRiver",
#   to_agents=["LeadFalcon"],
#   thread_id="bd-db01",
#   subject="[bd-db01] BLOCKED: Missing migration script",
#   importance="high",
#   body="... (use templates/agent-message-blocker.md format)"
# )
