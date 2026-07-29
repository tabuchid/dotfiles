#!/usr/bin/env zsh

# ============================================
# Claude Code — agent view + background sessions
#
# One screen across the Buoy code tree and the Obsidian vault.
# Worktree isolation is scoped per-repo via each dir's .claude/settings.json
# (vault + outer BuoySoftware = off; nested clones = on). See the vault doc
# docs/agents/background-agents.md for the full rationale.
#
# Usage:
#   ca            - open agent view from the Buoy code tree, vault added in
#   cab "<task>"  - dispatch one background session (vault reachable), code tree
#   caw           - agent view scoped to just the Buoy code tree (--cwd)
# ============================================

# Single source of truth for the iCloud vault path (spaces + ~ are why this
# lives in a var instead of being retyped at every call site).
export DOUG_VAULT="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Doug LifeHQ 2.0.5"
export BUOY_CODE_TREE="$HOME/Developer/BuoySoftware"

# Open agent view from the code tree with the vault added.
# @<repo> in a dispatch targets a nested clone (BuoyRails, Wharf, …);
# vault work runs against the added dir. Extra args pass through, e.g.
#   ca --model opus --effort high
ca() {
    ( cd "$BUOY_CODE_TREE" && claude agents --add-dir "$DOUG_VAULT" "$@" )
}

# Dispatch one background session from the code tree, vault reachable.
#   cab "investigate the flaky checkout test"
#
# The `--` is load-bearing: without it the positional prompt lands right after
# `--add-dir <value>` and the CLI parser swallows it as another --add-dir arg,
# dispatching an empty (idle) session. `--` ends option parsing so the prompt
# always binds as the prompt.
cab() {
    ( cd "$BUOY_CODE_TREE" && claude --bg --add-dir "$DOUG_VAULT" -- "$@" )
}

# Agent view scoped to sessions started under the Buoy code tree only.
caw() {
    claude agents --cwd "$BUOY_CODE_TREE" "$@"
}
