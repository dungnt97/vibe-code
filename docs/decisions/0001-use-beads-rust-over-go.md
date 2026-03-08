# 0001 — Use beads_rust (br) over original Go beads (bd)

**Status:** accepted
**Date:** 2026-03-08
**Related beads:** n/a (foundational decision)
**Related spec:** n/a

## Context

The Beads ecosystem has two main implementations: the original Go version (`bd`) by Steve Yegge, and the Rust port (`br`) by Jeff Emanuel. Both implement the same JSONL format and are interoperable. We need to choose one as the standard for this template.

## Options Considered

### Option A: Original Go beads (bd)
- Pros: More features (Linear/Jira sync, RPC daemon), larger community
- Cons: ~276K lines of Go, heavier binary, more complex

### Option B: beads_rust (br)
- Pros: ~20K lines of Rust, faster compilation, smaller binary, explicit --json on every command, fewer moving parts, pairs with beads_viewer (same author)
- Cons: Fewer integrations, no Linear/Jira sync

## Decision

Use beads_rust (br). The template prioritizes local-first simplicity and agent-friendliness. The `--json` flag on every command and smaller footprint align with the lightweight daily workflow goal. JSONL compatibility means switching to `bd` later is trivial.

## Consequences

- All bead commands in docs use `br` syntax
- If Linear/Jira sync is needed later, can add `bd` alongside or use a separate sync script
- beads_viewer works with both, so the planning layer is unaffected
