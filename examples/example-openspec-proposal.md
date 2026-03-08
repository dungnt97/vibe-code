# Example: What OpenSpec generates for /opsx:propose "add-dark-mode"

> This is a reference example showing what the openspec/changes/ directory
> looks like after a proposal. In practice, /opsx:propose generates these files.

## openspec/changes/add-dark-mode/proposal.md

```markdown
# Proposal: Add Dark Mode

## Why
Users have requested dark mode for reduced eye strain during nighttime use.
Analytics show 40% of sessions occur after 8 PM.

## Scope
- Theme toggle in header
- CSS variable-based theming
- localStorage persistence
- Respect OS prefers-color-scheme

## Out of Scope
- Per-component custom themes
- Theme marketplace
```

## openspec/changes/add-dark-mode/design.md

```markdown
# Design: Dark Mode

## Approach
CSS custom properties with a `[data-theme="dark"]` attribute on `<html>`.
React context provides toggle function. localStorage persists choice.

## Key Decisions
- CSS variables over styled-components theme prop (simpler, no runtime cost)
- Single dark palette (not multiple themes — YAGNI)
- OS preference as default, user choice overrides

## File Changes
- src/styles/variables.css — add dark theme variables
- src/contexts/ThemeContext.tsx — new file
- src/components/ThemeToggle.tsx — new file
- src/components/Header.tsx — add toggle button
- src/index.html — add data-theme attribute logic
```

## openspec/changes/add-dark-mode/tasks.md

```markdown
# Tasks: Dark Mode

## 1. Theme infrastructure
- 1.1 Add CSS custom properties for colors in variables.css
- 1.2 Create dark theme variable overrides
- 1.3 Add [data-theme] selector logic

## 2. React integration
- 2.1 Create ThemeContext with toggle function
- 2.2 Add localStorage read/write
- 2.3 Add OS preference detection (prefers-color-scheme)
- 2.4 Wrap app in ThemeProvider

## 3. UI components
- 3.1 Create ThemeToggle component
- 3.2 Add toggle to Header
- 3.3 Style toggle with transitions

## 4. Testing
- 4.1 Unit tests for ThemeContext
- 4.2 Visual regression test for dark mode
```

## Mapping to Beads

After spec approval, create beads:

```bash
br create "Dark mode: theme infrastructure (CSS vars)" --type task --priority 1
# → bd-dm001

br create "Dark mode: React context + localStorage" --type task --priority 1
# → bd-dm002

br create "Dark mode: toggle component + header" --type feature --priority 2
# → bd-dm003

br create "Dark mode: tests" --type task --priority 2
# → bd-dm004

br dep add bd-dm002 bd-dm001  # React needs CSS vars
br dep add bd-dm003 bd-dm002  # UI needs context
br dep add bd-dm004 bd-dm003  # Tests need UI
```
