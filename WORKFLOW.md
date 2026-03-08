# WORKFLOW.md — Operating Model

## Daily Loop

### 1. Session Start (2 min)

```bash
git pull                        # sync with remote
br sync --import-only           # load any JSONL changes from collaborators
br list --status open --json    # see all open work
bv --robot-next                 # recommended next task
```

If multi-agent: check inbox via mcp_agent_mail `fetch_inbox`.
If specs exist: `ls openspec/changes/` to see active proposals.

### 2. Task Selection

**Decision tree:**

```
Is there a bv --robot-next recommendation?
  YES → Take it (unless user overrides)
  NO  → Ask user what to work on → Create bead first

Is the task blocked?
  YES → Run bv --robot-triage to find unblocking path
        Either: work on the blocker first
        Or: ask user to re-prioritize
  NO  → Proceed
```

### 3. Execution

**Start:**
```bash
br update <id> --status in_progress
```

**Work using Superpowers skills:**
- Brainstorming auto-activates for new features
- Writing-plans activates for multi-step work
- TDD activates during implementation
- Systematic-debugging activates for bugs
- Code-review activates between tasks

**CRITICAL — After Superpowers brainstorming/planning completes:**
- Create beads from the generated plan: `br create "task" --type task --priority <n>`
- Add dependencies: `br dep add <child-id> <parent-id>`
- Verify graph: `bv --robot-plan`
- This bridges Superpowers planning → beads execution tracking

**During implementation:**
- Use Context7 for library/API docs: `/context7:docs <query>` (also auto-invokes)
- If you discover a new task, capture it: `br q "discovered: <description>"`
- If you discover a dependency, add it: `br dep add <id> <dep-id>`
- If scope grows beyond original task, consider splitting

**If Layer D (OpenSpec) is triggered:**
- Pause implementation
- Run `/opsx:propose "feature-name"`
- Get user approval on spec
- **Create beads from tasks.md** — one bead per top-level task
- **Add dependencies between beads** matching task order
- **Add spec reference**: `br update <id> --comment "Spec: openspec/changes/<name>/"`
- Resume with `/opsx:apply`

### 4. Validation

Before closing any task:
```bash
# Run whatever validation is appropriate:
make test          # or npm test, cargo test, etc.
make lint          # if available
# Manual check if no automated tests exist
```

### 5. Completion

```bash
br close <id> --reason "What was done and why"
br sync --flush-only    # export to JSONL
git add .beads/
git commit -m "Close <id>: brief description"
```

If spec-driven: `/opsx:archive` after all tasks complete.

### 6. Session End

```bash
br list --status in_progress --json   # anything left open?
bv --robot-alerts                      # any stale or blocked items?
br sync --flush-only                   # ensure JSONL is fresh
git add .beads/ && git commit -m "Sync beads"  # if changes
```

---

## Layer Definitions

### Layer A: Quick Mode

**When:** Task is < 30 minutes, touches 1-3 files, has no ambiguity, no dependencies.

**Tools:** br + Superpowers only.

**Process:**
1. `br q "description"` or `br create ...`
2. Implement
3. Validate
4. `br close <id> --reason "..."`

**Skip:** bv triage, OpenSpec, agent mail.

### Layer B: Normal Mode

**When:** Task has dependencies, touches 4+ files, takes 30 min–2 hours, or needs planning.

**Tools:** br + bv + Superpowers.

**Process:**
1. `br create "title" --type <type> --priority <n>`
2. Add dependencies: `br dep add ...`
3. `bv --robot-triage` or `bv --robot-plan` to understand the work graph
4. Implement with Superpowers (plan skill will auto-activate)
5. Validate
6. Close bead
7. Sync JSONL

### Layer C: Coordinated Mode

**When:** Multiple Claude instances working in parallel, or delegating sub-tasks to sub-agents.

**Tools:** br + bv + Superpowers + mcp_agent_mail.

**Process:**
1. Lead agent creates beads for all workstreams
2. Each agent registers via `register_agent`
3. File reservations claimed before editing: `file_reservation_paths`
4. Status communicated via `send_message` with thread_id = bead ID
5. Lead monitors via `fetch_inbox` and `bv --robot-plan`
6. Agents release file reservations and close beads when done
7. Lead verifies all work, resolves conflicts

**Message conventions:**
- Subject format: `[bd-XXXX] Brief description`
- Thread ID: always the bead ID
- Importance: `normal` for status updates, `high` for blockers
- Always acknowledge received messages

### Layer D: Structured Spec Mode

**When:** Feature is > 2 hours estimated, or is risky, or requirements are ambiguous, or it's a cross-cutting architectural change.

**Tools:** br + bv + Superpowers + OpenSpec (+ mcp_agent_mail if multi-agent).

**Process:**
1. `/opsx:propose "feature-name"` — generates proposal, specs, design, tasks
2. Review with user — iterate on specs until approved
3. Create beads from tasks.md: one bead per top-level task
4. Add dependencies between beads
5. `/opsx:apply` — implement against spec
6. Validate each task
7. Close beads as tasks complete
8. `/opsx:archive` — archive completed change
9. Record key decisions in `docs/decisions/`

---

## Superpowers Integration

Superpowers skills auto-activate based on context. Here's how to work with them:

### Brainstorming
- Triggers before writing code for new features
- Asks clarifying questions, explores alternatives
- Produces a design document
- **Do this:** answer honestly, don't rush through
- **Avoid:** skipping brainstorm for medium+ tasks

### Planning
- Triggers with approved design
- Breaks work into 2-5 minute tasks with exact file paths
- **Do this:** review the plan, adjust if needed
- **Avoid:** plans with > 20 steps (split into phases)

### TDD
- Triggers during implementation
- RED → GREEN → REFACTOR cycle
- **Do this:** write failing test first, minimal code to pass
- **Avoid:** writing implementation before tests when TDD is active

### Debugging
- Triggers for bug investigation
- 4-phase: reproduce → hypothesize → test → fix
- **Do this:** follow the phases systematically
- **Avoid:** random shotgun fixes

### Code Review
- Triggers between tasks
- Reviews against the plan
- **Do this:** address all review findings before moving on

### Git Worktrees
- Triggers after design approval for isolated work
- Creates branch + worktree
- **Do this:** use for any work that might need to be abandoned
- **Avoid:** for quick fixes that are obviously correct

---

## Beads Task Lifecycle

```
[idea] → br create/q → [open]
                          ↓
                    br update --status in_progress → [in_progress]
                          ↓
                    implement + validate
                          ↓
                    br close --reason "..." → [closed]
                          ↓
                    br sync --flush-only → JSONL exported
                          ↓
                    git commit .beads/
```

### Splitting Tasks

If a task grows beyond its original scope:
1. Close the original with reason "Split — see bd-X, bd-Y"
2. Create new beads for the sub-tasks
3. Add dependencies as needed

### Naming

- Titles: imperative mood ("Add login endpoint", "Fix null check in parser")
- Types: `bug` (broken), `feature` (new capability), `task` (maintenance/ops), `chore` (cleanup), `spike` (investigation)
- Labels: free-form, use for grouping (e.g., `backend`, `auth`, `perf`)

---

## Agent Mail Protocol (Layer C)

### Solo Mode

When working alone, agent mail is dormant. No registration needed. No messages to check.

### Multi-Agent Activation

```
Lead agent:
  1. ensure_project(project_key="/path/to/repo")
  2. register_agent(project_key, "LeadFalcon", program="Claude Code")
  3. Creates all beads for the project
  4. Sends task assignments via send_message

Sub-agent:
  1. register_agent(project_key, "SwiftRaven", program="Claude Code")
  2. fetch_inbox → get assignment
  3. file_reservation_paths → claim files
  4. Work on assigned bead
  5. send_message → report completion
  6. release_file_reservations → release files
```

### File Lease Rules

- Reserve files BEFORE editing in multi-agent mode
- Use glob patterns for directories: `src/auth/**`
- Set `exclusive=true` for files only one agent should touch
- Set `reason` to the bead ID
- TTL: 1 hour default, extend if needed
- ALWAYS release when done

### Collision Avoidance

- Check `get_active_reservations` before claiming
- If conflict: send message to reservation holder asking for release
- Never force-override someone else's reservation
- If agent is unresponsive: escalate to user

---

## OpenSpec Protocol (Layer D)

### When to Use

See PROJECT_RULES.md escalation rules. Quick summary:

| Condition | Use OpenSpec? |
|-----------|--------------|
| < 2 hours, clear scope | No |
| > 2 hours, clear scope | Optional |
| Ambiguous requirements | Yes |
| Cross-cutting change | Yes |
| Risky migration | Yes |
| New external integration | Yes |
| Architecture change | Yes |

### Spec-to-Beads Mapping

After `/opsx:propose` generates tasks.md:
1. Create one bead per top-level task number
2. Add bead IDs to tasks.md as comments: `<!-- bd-abc123 -->`
3. Add dependencies between beads matching task dependencies
4. Reference spec in bead: `br update <id> --comment "Spec: openspec/changes/<name>/"`

### Decision Records

For decisions made during spec work:
1. Create `docs/decisions/NNNN-short-title.md`
2. Link from spec's design.md
3. Link from relevant beads
