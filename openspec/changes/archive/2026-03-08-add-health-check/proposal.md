## Why

The starter template installs 5 CLI tools, 6 plugins, and generates config files with tokens. There is no single command to verify everything is working. When something breaks (tool update, PATH issue, expired token), debugging requires checking each tool manually. A health check command gives instant confidence that the system is operational.

## What Changes

- Add `scripts/health-check.sh` — verifies all tools, configs, and connections
- Add `make health` Makefile target — single entry point
- Health check covers: br, bv, openspec CLI, mcp_agent_mail venv, plugin count, token validity, git state
- Exit code 0 = all healthy, non-zero = failures found
- Machine-readable JSON output with `--json` flag for agent consumption

## Capabilities

### New Capabilities
- `health-check`: Verify all Vibecode OS tools, plugins, configs, and connections are operational. Reports pass/fail per component with actionable fix suggestions.

### Modified Capabilities

## Impact

- New files: `scripts/health-check.sh`
- Modified files: `Makefile` (add `health` target)
- No breaking changes
- No new dependencies
