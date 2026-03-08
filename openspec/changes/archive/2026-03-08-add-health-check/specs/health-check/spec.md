## ADDED Requirements

### Requirement: Health check verifies all CLI tools
The system SHALL verify that br, bv, and openspec are installed and executable by checking `command -v` and running `--version`.

#### Scenario: All CLI tools installed
- **WHEN** user runs `make health`
- **THEN** each tool shows a pass status with its version number

#### Scenario: A CLI tool is missing
- **WHEN** br, bv, or openspec is not found in PATH
- **THEN** that tool shows a fail status with the install command as fix suggestion

### Requirement: Health check verifies beads initialization
The system SHALL verify that `.beads/` directory exists and contains `issues.jsonl`.

#### Scenario: Beads initialized
- **WHEN** `.beads/issues.jsonl` exists
- **THEN** beads check passes

#### Scenario: Beads not initialized
- **WHEN** `.beads/` does not exist
- **THEN** beads check fails with suggestion: `br init`

### Requirement: Health check verifies mcp_agent_mail
The system SHALL verify that mcp_agent_mail is cloned and its Python venv exists.

#### Scenario: mcp_agent_mail installed
- **WHEN** `~/.mcp_agent_mail/.venv/bin/python` exists
- **THEN** mcp_agent_mail check passes

#### Scenario: mcp_agent_mail not installed
- **WHEN** `~/.mcp_agent_mail` does not exist
- **THEN** check fails with suggestion: `make setup-mail`

### Requirement: Health check verifies plugins
The system SHALL count installed Claude Code plugins from `~/.claude/plugins/installed_plugins.json`.

#### Scenario: Plugins installed
- **WHEN** at least 1 plugin exists in installed_plugins.json
- **THEN** plugin check passes showing count

#### Scenario: No plugins file
- **WHEN** installed_plugins.json does not exist
- **THEN** plugin check fails with suggestion to install plugins

### Requirement: Health check supports JSON output
The system SHALL output a JSON array of check results when `--json` flag is passed.

#### Scenario: JSON output requested
- **WHEN** user runs `bash scripts/health-check.sh --json`
- **THEN** output is valid JSON with array of objects containing: name, status (pass/fail), detail, fix

### Requirement: Health check exit code reflects status
The system SHALL exit 0 when all checks pass and non-zero when any check fails.

#### Scenario: All checks pass
- **WHEN** every component is healthy
- **THEN** exit code is 0

#### Scenario: Any check fails
- **WHEN** one or more components fail
- **THEN** exit code is 1
