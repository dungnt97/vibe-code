Start a multi-agent coordinated session (Layer C).

1. **Ensure mail server is running:**
   ```bash
   bash scripts/mail-server.sh status
   ```
   If not running:
   ```bash
   bash scripts/mail-server.sh start
   ```

2. **Register this agent as lead:**
   Use the mcp_agent_mail MCP tools (available via MCP server):
   - Call `ensure_project` with `project_key` = absolute path of current directory
   - Call `register_agent` with `project_key` = same path, `program` = "claude-code", `model` = "claude-opus-4-6", `name` = generate an AdjectiveNoun name (e.g., "SwiftFalcon")
   - Save the returned `name` and `registration_token` for this session

3. **Check for pending work:**
   ```bash
   bv --robot-plan
   ```

4. **Identify parallelizable tracks:**
   Parse the plan output — each `track` can be assigned to a separate agent.
   If only 1 track: suggest staying in solo mode (Layer A/B).
   If 2+ tracks: proceed with multi-agent.

5. **Spawn sub-agents using Superpowers worktrees:**
   For each parallel track, use the Agent tool with `isolation: "worktree"` to:
   - Create a worktree for the track
   - The sub-agent should:
     a. Register itself with mcp_agent_mail (`register_agent`)
     b. Claim file reservations (`file_reservation_paths`) for its work area
     c. Implement the assigned tasks
     d. Send completion message (`send_message` with thread_id = bead ID)
     e. Release file reservations when done

6. **Monitor as lead:**
   - Periodically `fetch_inbox` to check for completion/blocker messages
   - Update bead statuses as sub-agents complete
   - Resolve any file reservation conflicts
   - When all tracks complete, close remaining beads

7. **Present summary:**
   - Tracks completed
   - Beads closed
   - Any issues or conflicts resolved
   - Suggest: `make stop-mail` when done with multi-agent work
