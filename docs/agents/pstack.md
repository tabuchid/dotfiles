# pstack integration

## Maintained source

The default Hermes profile uses Michael Denyer's maintained `pstack-claude` port with a small Hermes mapping. Load `poteto-mode`, then its `references/hermes-tools.md`. The reproducible pin, installer, and compatibility gate live in `~/Developer/workspace/pstack-drift/`. Do not install a second copy in this repo. Claude Code, Codex, Pi, and Copilot use their own mappings; the Hermes adapter does not configure those harnesses or grant new tools.

## Planning and domain rules

Use Linear on the Tabuchi team as the durable system of record. Read the workspace's authoritative `~/Developer/workspace/docs/agents/issue-tracker.md` and this repo's `docs/agents/issue-tracker.md` when present. Resolve exactly one appropriate label from Linear's Repo group before publishing a repository issue. Do not invent labels from the folder name or revive Beads. Use `.scratch/<feature>/` only for offline drafts when Linear is unavailable.

Read `docs/agents/domain.md` when present. Preserve existing CONTEXT.md/CONTEXT-MAP.md glossary files; do not create parallel GLOSSARY files. If neither a glossary nor a domain policy exists, create domain docs lazily using the current Matt convention. Read relevant ADRs before changing design. On Hermes, Matt's workflows use `matt-pocock-tdd` and `matt-pocock-teach`; pstack owns `tdd` and `teach`.

## Verification and safety

Project-local skills found during this integration: No project-local skill driver was found. Use the repository's documented test or verification command; do not invent a passing result.

Use existing launch, doctor, drive, evidence, and cleanup commands. Reuse the project's verification gate rather than generating another driver. A missing independent reviewer leaves shipping blocked. Compatibility checks establish policy and skill discovery, not that every application test passed.

Verify the Git root before Git operations. Preserve existing dirty, untracked, ignored, credential-bearing, and local-only files. Use isolated worktrees for concurrent code work. Current-request authorization is required for pushes, merges, deployments, service restarts, or access-policy changes. This integration does not enable shared-family profiles or broaden their capabilities.
