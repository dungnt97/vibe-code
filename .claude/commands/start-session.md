Run the daily session start routine:

1. Check git status and recent commits:
   ```
   git status --short
   git log --oneline -5
   ```

2. Import any beads JSONL changes: `br sync --import-only`

3. List open tasks: `br list --status open`

4. List in-progress tasks: `br list --status in_progress`

5. Get recommended next task: `bv --robot-next` (fall back to `br ready` if bv unavailable)

6. Check for alerts: `bv --robot-alerts`

7. Check for active specs: list `openspec/changes/` excluding archive

8. **Start services (if not already running):**
   ```bash
   # Agent Mail (port 8765)
   bash scripts/mail-server.sh status
   # If not running, start it:
   bash scripts/mail-server.sh start

   # Beads Viewer (port 9000)
   bash scripts/bv-server.sh status
   # If not running, start it:
   bash scripts/bv-server.sh start
   ```
   If Agent Mail is running: use mcp_agent_mail `fetch_inbox` to check for pending messages.

9. Present a concise summary to the user:
   - Open tasks count
   - In-progress tasks
   - Active specs (if any)
   - Recommended next action
   - Any alerts or blockers
   - Services status:
     - Agent Mail: http://localhost:8765/mail
     - Beads Viewer: http://localhost:9000
