#!/bin/sh
# Shared agent detection for the global git hooks.
#
# Source this file and call agent_tool_name. It prints a tool name, or
# nothing when the commit is from a human. Executing this file does the same.
#
# Detection order:
#   1. AGENT_TOOL (any non-empty value wins, including over the markers below)
#   2. HERMES_AGENT=true            -> hermes
#   3. CLAUDECODE=1                 -> claude-code
#   4. a Codex child-shell variable -> codex
#   5. otherwise nothing (human)
#
# Codex: `codex sandbox -- env` on Codex CLI 0.166.0 exports
# CODEX_SANDBOX=seatbelt and CODEX_SANDBOX_NETWORK_DISABLED=1 into the
# child shell. Those are the signals used here. CODEX_HOME is ignored
# because a human terminal may have it set. CODEX_THREAD_ID and
# CODEX_MANAGED_BY_NPM are present in the binary but were not verified as
# child-shell exports (`codex exec --skip-git-repo-check` failed: the
# configured model is rejected for this ChatGPT account), so they are not
# signals. Unsandboxed Codex sessions that set neither verified variable
# are detected only via AGENT_TOOL.
#
# Repos that set their own core.hooksPath (husky, pre-commit, and similar)
# override this global hooksPath. Git never runs these scripts there.

# Run the repo-local hook of the same name, if it exists and is executable.
# A global core.hooksPath disables Git's automatic .git/hooks lookup, so
# each global hook chains explicitly. Skip the chain when that path is this
# hooks directory, or the target file is this script, so we cannot recurse.
run_chained_hook() {
  hook_name=$(basename "$0") || return 0
  self_dir=$(CDPATH='' cd "$(dirname "$0")" && pwd -P) || return 0
  common=$(git rev-parse --git-common-dir 2>/dev/null) || return 0
  case "$common" in
    /*) ;;
    *)
      common=$(CDPATH='' cd "$common" && pwd -P) || return 0
      ;;
  esac
  target="$common/hooks/$hook_name"
  if [ ! -f "$target" ] || [ ! -x "$target" ]; then
    return 0
  fi
  target_dir=$(CDPATH='' cd "$(dirname "$target")" && pwd -P) || return 0
  if [ "$target_dir" = "$self_dir" ] || [ "$target" -ef "$0" ]; then
    return 0
  fi
  "$target" "$@"
}

agent_tool_name() {
  if [ -n "${AGENT_TOOL:-}" ]; then
    printf '%s\n' "$AGENT_TOOL"
    return 0
  fi
  if [ "${HERMES_AGENT:-}" = "true" ]; then
    printf '%s\n' "hermes"
    return 0
  fi
  if [ "${CLAUDECODE:-}" = "1" ]; then
    printf '%s\n' "claude-code"
    return 0
  fi
  if [ -n "${CODEX_SANDBOX:-}" ] || [ -n "${CODEX_SANDBOX_NETWORK_DISABLED:-}" ]; then
    printf '%s\n' "codex"
    return 0
  fi
  return 0
}

case "$0" in
  */_agent-detect.sh | _agent-detect.sh)
    agent_tool_name
    ;;
esac
