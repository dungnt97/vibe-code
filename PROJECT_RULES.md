# PROJECT_RULES.md — Escalation Rules & Conventions

## Escalation Matrix

Every task must be classified before starting. Use this matrix:

```
┌─────────────────────────────────────────────────────────────────────┐
│ TASK SIZE & RISK ASSESSMENT                                        │
├─────────────────────┬──────────────┬────────────┬──────────────────┤
│ Criteria            │ Quick (A)    │ Normal (B) │ Structured (D)   │
├─────────────────────┼──────────────┼────────────┼──────────────────┤
│ Estimated time      │ < 30 min     │ 30m - 2h   │ > 2 hours        │
│ Files touched       │ 1-3          │ 4-10       │ 10+              │
│ Dependencies        │ None         │ Some       │ Many/complex     │
│ Requirements clear? │ Yes          │ Mostly     │ No/ambiguous     │
│ Risk level          │ Low          │ Medium     │ High             │
│ Reversible?         │ Easily       │ With effort│ Difficult        │
├─────────────────────┼──────────────┼────────────┼──────────────────┤
│ Tools required      │ br           │ br + bv    │ br + bv + opsx   │
│ Superpowers         │ Yes          │ Yes        │ Yes              │
│ Spec needed?        │ No           │ No         │ Yes              │
│ Viewer needed?      │ No           │ Yes        │ Yes              │
├─────────────────────┴──────────────┴────────────┴──────────────────┤
│ Add Layer C (agent mail) when: multiple agents work in parallel    │
└─────────────────────────────────────────────────────────────────────┘
```

## Decision: When to Escalate

### Stay in Quick Mode (A) when ALL are true:
- [ ] Task is well-understood
- [ ] Touches ≤ 3 files
- [ ] No dependencies on other open tasks
- [ ] Takes < 30 minutes
- [ ] Low risk (easy to revert)
- [ ] Single agent working

### Escalate to Normal Mode (B) when ANY is true:
- Task has dependencies on other beads
- Touches 4+ files
- Needs planning or sequencing
- Estimated > 30 minutes
- Needs triage to determine priority

### Escalate to Coordinated Mode (C) when ANY is true:
- Multiple Claude instances active on same repo
- Task is delegated to a sub-agent
- Parallel workstreams touching overlapping files
- Need to coordinate timing or ordering across agents

### Escalate to Structured Spec Mode (D) when ANY is true:
- Requirements are ambiguous or incomplete
- Change is cross-cutting (affects 3+ modules)
- Change is a breaking/risky migration
- New external integration or API surface
- Architecture change (new patterns, new dependencies)
- Estimated > 2 hours AND not purely mechanical
- User explicitly requests a spec
- Change has downstream consumers who need to understand it

### Do NOT use OpenSpec when:
- Task is mechanical (rename, reformatting, dependency bump)
- Task is a well-understood bug fix
- Task is a direct feature request with clear implementation
- Time to write spec > time to implement the change
- User says "just do it"

## Naming Conventions

### Beads
- **Titles**: imperative mood, lowercase start after type
  - Good: "Add rate limiting to API endpoints"
  - Bad: "rate limiting" or "Added rate limiting"
- **Types**: bug, feature, task, chore, spike
- **Labels**: lowercase, hyphenated (e.g., `auth`, `api`, `front-end`)
- **IDs**: system-generated `bd-XXXXXX` — never invent your own

### Specs
- **Directory names**: lowercase, hyphenated (e.g., `add-payment-system`)
- **File names**: as OpenSpec generates (proposal.md, design.md, tasks.md)

### Decisions
- **File names**: `NNNN-short-title.md` (e.g., `0001-use-postgres.md`)
- **Numbering**: sequential, zero-padded to 4 digits

### Agent Names
- **Format**: AdjectiveNoun, PascalCase (e.g., `SwiftFalcon`, `CalmRiver`)
- **Lead agent**: always registers first
- **Convention**: include role hint in name if useful (e.g., `TestRunner`, `DocWriter`)

### Branches
- **Feature**: `feat/<bead-id>-short-desc` (e.g., `feat/bd-7f3a2c-auth-module`)
- **Bug fix**: `fix/<bead-id>-short-desc`
- **Chore**: `chore/<bead-id>-short-desc`

## Git Conventions

- Commit messages reference bead IDs: `[bd-XXXX] Brief description`
- One logical change per commit
- `.beads/` directory is committed to git (JSONL is the collaboration format)
- `openspec/` directory is committed to git
- `.mail/` is in `.gitignore` (local coordination state only)
- Never commit `beads.db` — only `issues.jsonl` is git-tracked

## Task Splitting Rules

Split a task when:
1. Implementation reveals 2+ independent sub-problems
2. Task has been in_progress for > 1 hour without clear end in sight
3. You discover the task needs work in unrelated modules
4. Part of the task is blocked but another part can proceed

How to split:
1. `br close <original> --reason "Split into bd-X, bd-Y, bd-Z"`
2. Create new beads for each sub-task
3. Preserve any dependencies from the original
4. Add new inter-task dependencies if needed

## Validation Rules

Before closing ANY bead:
1. Code compiles / builds without errors
2. Relevant tests pass (or new tests written and passing)
3. No lint errors introduced
4. The change does what the bead title says

Before closing a SPEC-DRIVEN bead:
1. All above, plus:
2. Implementation matches spec
3. Edge cases from spec are covered
4. Decision record created if non-obvious choices were made

## File Ownership Rules (Multi-Agent)

- In solo mode: no ownership tracking needed
- In multi-agent mode: ALWAYS use file_reservation_paths before editing
- Reservations are advisory — the pre-commit hook enforces them
- Glob patterns preferred over individual files: `src/auth/**`
- Release immediately after committing changes
- Never hold reservations across sessions

## Process Budget

The amount of process should be proportional to risk:

| Task Risk | Max Process Time | Max Spec Pages | Max Planning Rounds |
|-----------|-----------------|----------------|---------------------|
| Low       | 2 min           | 0              | 0                   |
| Medium    | 10 min          | 0              | 1                   |
| High      | 30 min          | 2-3            | 2                   |
| Critical  | 1 hour          | 5+             | 3+                  |

If you're spending more time on process than on implementation, you've over-escalated.
