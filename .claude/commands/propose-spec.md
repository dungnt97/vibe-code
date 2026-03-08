Start a structured spec for a non-trivial change.

First, confirm this needs a spec by checking against PROJECT_RULES.md escalation rules:
- Is the change > 2 hours?
- Are requirements ambiguous?
- Is it cross-cutting (3+ modules)?
- Is it a risky migration or architecture change?

If yes to any: proceed with `/opsx:propose "<feature-name>"`

If no to all: suggest the user can skip the spec and just create beads directly. Only proceed with spec if user insists.

After `/opsx:propose` generates artifacts (proposal.md, design.md, tasks.md):

1. Present the spec summary to user for review
2. Iterate on feedback until approved

3. **CRITICAL — Create beads from tasks.md:**
   - Read `openspec/changes/<name>/tasks.md`
   - For each top-level task section, create a bead:
     ```
     br create "<task title>" --type task --priority <n>
     ```
   - Add dependencies between beads matching the task order:
     ```
     br dep add <child-id> <parent-id>
     ```
   - Add spec reference to each bead:
     ```
     br update <id> --comment "Spec: openspec/changes/<name>/"
     ```

4. **Verify the task graph:**
   ```
   bv --robot-plan
   ```

5. Report to user: beads created, dependency graph, recommended first task via `bv --robot-next`
