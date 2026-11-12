# Agent instructions

## pstack integration

For nontrivial changes, design decisions, unknown-cause bugs, or performance work, load `poteto-mode` before acting. Read `docs/agents/pstack.md` for this repository's runtime mapping, tracker, domain layout, and verification rules. Existing safety boundaries and current-request authorization take precedence. Do not install another repository-local copy of the global skill set.

## Finishing work

Agents follow `/Users/tabuchid/Developer/workspace/docs/agents/finish-work.md` (TAB-164). Never edit the main checkout; work in a worktree on an `agent/<tool>/<task>` branch. End every session committed and pushed, merged with Doug's approval, or explicitly abandoned with a Linear comment. Push over HTTPS with the `gh` credential helper.
