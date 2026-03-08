## Context

The Vibecode OS template installs br, bv, openspec, mcp_agent_mail, and 6 Claude Code plugins. Each has its own install path, config files, and runtime requirements. Currently there is no unified way to verify the system is working — users must manually check each tool.

## Goals / Non-Goals

**Goals:**
- Single command (`make health`) to verify all tools are operational
- Clear pass/fail per component with actionable fix suggestions
- Machine-readable JSON output for agent consumption (`--json` flag)
- Fast execution (< 5 seconds for all checks)
- Exit code 0 = all pass, non-zero = failures

**Non-Goals:**
- Dependency version checking or auto-update
- Network connectivity tests (beyond local mcp_agent_mail)
- Plugin functionality testing (only presence check)
- Performance benchmarking

## Decisions

### Single bash script over multiple scripts
One script (`scripts/health-check.sh`) checks everything. Simpler to maintain than per-tool scripts. Each check is a function that returns 0/1 and outputs a status line.

**Alternative considered:** Per-tool check scripts called from Makefile. Rejected — too many files for a simple feature.

### JSON output via --json flag
When `--json` is passed, output a JSON array of check results instead of human-readable text. This lets `bv` or agents parse health status programmatically.

**Alternative considered:** Always output JSON. Rejected — human-readable is the primary use case.

### Check categories
1. **CLI tools**: br, bv, openspec — verify `command -v` and `--version`
2. **Beads state**: `.beads/` exists and is initialized
3. **OpenSpec state**: `openspec/` exists
4. **mcp_agent_mail**: venv exists, Python module imports
5. **Plugins**: count installed plugins from `~/.claude/plugins/installed_plugins.json`
6. **MCP token**: `.claude/settings/mcp.json` has a real token (not placeholder)
7. **Git**: repo is initialized, remote configured

## Risks / Trade-offs

- [Plugin check reads `installed_plugins.json` directly] → Brittle if Anthropic changes format. Mitigation: graceful fallback if file missing.
- [mcp_agent_mail import check requires Python] → All macOS systems have Python3. Low risk.
- [Token check reads mcp.json] → File may not exist if gitignored and not regenerated. Mitigation: check existence first, suggest `make setup` if missing.
