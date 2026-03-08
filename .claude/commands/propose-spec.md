Start a structured spec for a non-trivial change.

First, confirm this needs a spec by checking against PROJECT_RULES.md escalation rules:
- Is the change > 2 hours?
- Are requirements ambiguous?
- Is it cross-cutting (3+ modules)?
- Is it a risky migration or architecture change?

If yes to any: proceed with `/opsx:propose "<feature-name>"`

If no to all: suggest the user can skip the spec and just create beads directly. Only proceed with spec if user insists.

After proposal is generated:
1. Present the spec summary to user for review
2. Iterate on feedback
3. Once approved, create beads from tasks.md
4. Add dependencies between beads
5. Report the full task graph to user
