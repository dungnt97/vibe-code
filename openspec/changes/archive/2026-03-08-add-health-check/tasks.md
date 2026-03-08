## 1. Script Setup

- [x] 1.1 Create `scripts/health-check.sh` with argument parsing (`--json` flag detection)
- [x] 1.2 Define helper functions: `pass_check`, `fail_check`, `emit_json`

## 2. CLI Tool Checks

- [x] 2.1 Implement check for `br` — `command -v` and `--version`
- [x] 2.2 Implement check for `bv` — `command -v` and `--version`
- [x] 2.3 Implement check for `openspec` — `command -v` and `--version`

## 3. State Checks

- [x] 3.1 Implement beads initialization check (`.beads/issues.jsonl` exists)
- [x] 3.2 Implement mcp_agent_mail check (`~/.mcp_agent_mail/.venv/bin/python` exists)

## 4. Plugin and Config Checks

- [x] 4.1 Implement plugin count check from `~/.claude/plugins/installed_plugins.json`

## 5. Output and Exit

- [x] 5.1 Implement JSON output mode — collect results into JSON array
- [x] 5.2 Implement human-readable output mode with pass/fail formatting
- [x] 5.3 Set exit code: 0 if all pass, 1 if any fail

## 6. Makefile Integration

- [x] 6.1 Add `health` target to Makefile calling `bash scripts/health-check.sh`
